require "stripe_act/version"

module StripeAct
  class Error < StandardError; end
  
  errors=[]
  
  def self.env_test
    if !Course.exists? then 'course情報が存在しません' end
    if !Course.find(1).name.nil? then 'コース名が存在しません' end
    if !Course.find(1).tickets.nil? then 'チケットカラムが存在しません' end
    if !Course.find(1).valid_date.nil? then 'コーステーブルに有効期限がありません' end
    if !Course.find(1).price.nil? then 'コーステーブルに価格がありません' end
    if !Course.find(1).subscription.nil? then 'コーステーブルにsubscriptionがありません' end
    if !Course.find(1).price_id.nil? then 'コーステーブルにprice_idがありません' end
    
    if !PaymentError.exists? then 'payment_errorsテーブルが存在しません' end
    if !Payment.exists? then 'paymentsテーブルが存在しません' end
    if !Ticket.exists? then 'ticketsテーブルが存在しません' end
    if !Contract.exists? then 'contractsテーブルが存在しません' end
    if !LineUser.exists? then 'line_usersテーブルが存在しません' end
  end
  
  
  def self.subscription_payment_process(line_user,stripe_session,course_id)
    #エラーをためておく配列
    @errors=[]
    begin
      #支払い情報を取得する
      payment_info = StripeAct.get_payment_info(stripe_session)
      #支払いするユーザー情報を取得する
      user = LineUser.find(payment_info[:client_reference_id])
      #ユーザー情報が一致しない時はエラー
      if line_user.id != user.id then @errors.push('支払い時にユーザー情報が一致しませんでした。') end
      #新しい契約のチケット数を取得する
      tickets = Course.find(course_id).tickets
      #追加するチケットの有効期限を計算する
      valid_date = StripeAct.calc_valid_date(course_id)
      #支払い履歴を追加する
      payment_log = StripeAct.create_payment_instance(user,payment_info)
      #追加できなかった場合はエラー
      if payment_log.save == false then @errors.push('支払い履歴に追加できませんでした') end
      #チケットを追加する
      tickets_data = StripeAct.create_ticket_instance(user,payment_log,tickets,valid_date)
      if tickets_data.save == false then @errors.push('チケットの追加に失敗しました') end
      #サブスク変更の場合のみ
      PaymentError.create(:line_user_id=>1,:message=>Course.find(course_id).subscription)
      if Course.find(course_id).subscription == true
        #契約情報が存在しないときは、新たに契約を作成する
        if user.contract.nil? then
          if StripeAct.create_first_contract(user,course_id,payment_info[:subscription]) == false
            @errors.push('最初の契約が作成できませんでした')
          end
        end
        #契約情報が存在するときは、既存の契約を解約して上書き
        if !user.contract.nil? then
          if StripeAct.delete_contract(user,course_id,payment_info[:subscription]) == false
            @errors.push('既存の契約が解約できておりません。')  
          end
          if StripeAct.update_contract(user,course_id,payment_info[:subscription]) == false
            @errors.push('既存の契約情報が更新できませんでした。')
          end
        end
      end
      
    rescue
    end
    @errors.each do |e|
      PaymentError.create(:line_user_id=>line_user.id,:message=>e)
    end
    return @errors
  end


  def self.create_first_contract(user,course_id,subscription)
    contract = user.build_contract(:course_id=>course_id,:subscription=>subscription)
    return contract.save == true
  end
  
  #契約を解除する
  def self.delete_contract(user,course_id,subscription)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    if user.contract.subscription.present?
      PaymentError.create(:line_user_id=>user.id,:message=>'解除前')
      if !user.contract.subscription.nil?
        begin
          Stripe::Subscription.delete(user.contract.subscription)
        rescue
          #解約できなくとも一旦エラーは出さないようにしておく
        end
      end
      #一旦コースIDを空にする
      user.contract.update(:course_id=>nil,:subscription=>nil)
      PaymentError.create(:line_user_id=>user.id,:message=>'解除後')
      return true
    end
    return true
  end

  #契約情報を更新する
  def self.update_contract(user,course_id,subscription)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    begin
      user.contract.update!(:course_id=>course_id,:subscription=>subscription)
    rescue
      return false
    end
    return true
  end
  
  
  def self.customer_update(user,profile_params)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    customer = Stripe::Customer.update(
      user.profile.customer,
      {   
        description: profile_params[:name],
        name: profile_params[:name],
        phone: profile_params[:tel],
        email: profile_params[:email]
      }
    )
    return customer.id
  end


  def self.create_customer(profile_params)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    customer=Stripe::Customer.create({
          description: profile_params[:name],
          name: profile_params[:name],
          phone: profile_params[:tel],
          email: profile_params[:email]
        })
    return customer.id
  end

  #チケット情報を追加するためのインスタンスを作成する
  def self.create_ticket_instance(user,payment,tickets,valid_date)
      return Ticket.new(:line_user_id=>user.id,
          :payment_id=>payment.id,
          :amount=>tickets,
          :valid_date=>valid_date)
  end


  #支払い履歴を追加するためのインスタンスを作成する
  def self.create_payment_instance(user,co_session)
      return Payment.new(:line_user_id=>user.id,
          :cs=>co_session["id"],
          :amount_total=>co_session["amount_total"],
          :customer=>co_session["customer"],
          :email=>co_session["customer_details"]["email"],
          :payment_method_types=>co_session["payment_method_types"].to_s,
          :payment_status=>co_session["payment_status"].to_s,
          :subscription=>co_session["subscription"]
          )
  end


  def self.calc_valid_date(course_id)
      if Course.find(course_id).valid_date =='１ヶ月'
          return Time.current.next_month.strftime('%Y-%m-%d %H:%M:%S')
      elsif Course.find(course_id).valid_date =='１年'
          return Time.current.next_year.strftime('%Y-%m-%d %H:%M:%S')
      end
  end
  
  
  
  
  def self.get_payment_info(stripe_session)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    return Stripe::Checkout::Session.retrieve(stripe_session)
  end
  
  def self.create_subscription_checkout_session(request,course_id,user)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    course = Course.find(course_id.to_i)
    course.subscription == true ? mode='subscription':mode='payment'
    result = Stripe::Checkout::Session.create({payment_method_types: ['card'],
            line_items: [{quantity: 1,price: course.price_id}],
            mode: mode,
            customer: user.profile.customer,
            success_url: request.base_url.to_s+'/payment/'+course.id.to_s+'/succeeded/{CHECKOUT_SESSION_ID}',
            cancel_url: request.base_url.to_s+'/payment/failed',
            client_reference_id: user.id
        })
        {
            id: request.session.id
        }.to_json
    return result
  end

end
