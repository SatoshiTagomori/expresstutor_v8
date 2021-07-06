class PaymentsController < ApplicationController
    before_action :set_stripe_api_key
    def create_checkout_session
        #コースの情報を取得
        course = Course.find(params[:course_id])
        course.subscription ? mode='subscription' : mode='payment'
        #支払いのセッションを取得
        stripe_session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: [{
                quantity: 1,
                price: course.price_id
            }],
            customer: current_user.customer,
            mode: mode,
            #success_url: request.base_url.to_s+'/payment/'+course.id.to_s+'/succeeded/{CHECKOUT_SESSION_ID}',
            success_url: request.base_url.to_s+'/payment/subscription/succeeded/{CHECKOUT_SESSION_ID}',
            cancel_url: request.base_url.to_s+'/payment/failed',
            client_reference_id: course.id
        })
        {
            id: session.id
        }.to_json
        render plain: stripe_session.to_s
    end
    
    
    def payment_succeeded
        #支払い情報を取得
        payment_info = Stripe::Checkout::Session.retrieve(params[:session])
        if payment_info.mode == 'subscription'
            #現在のサブスクを解約
            current_user.delete_subscription
            #サブスクをアップデート
            current_user.update(:subscription=>payment_info.subscription)
            #payment_intentを取得
            invoice = Stripe::Subscription.retrieve(payment_info.subscription).latest_invoice
            payment_intent = Stripe::Invoice.retrieve(invoice).payment_intent
        elsif payment_info.mode == 'payment'
            #payment_intentを取得
            payment_intent = payment_info.payment_intent
        end
        #チケットの枚数を取得する
        amount =  Course.find(payment_info.client_reference_id).tickets
        #有効期限を取得する
        valid_date = get_valid_date(payment_info)

        #支払いログに記載
        payment_log = current_user.create_payment_log(payment_info,payment_intent)
        #チケット追加
        current_user.tickets.create(:payment_log_id=>payment_log.id,:subscription=>payment_info.subscription,:valid_date=>valid_date,:amount=>amount)
        #支払いページに戻る
        redirect_to payment_path
    end
    
    def cancel_subscription
        #現在のサブスクを解約
        current_user.delete_subscription
        render plain: ''
    end
    
    #返金処理
    def refund
        pl = PaymentLog.find(params[:payment_log_id])
        if pl.line_user_id == current_user.id then
            if (Time.now.to_i - pl.created_at.to_i)/(3600*24) < 8 then
               if pl.course.tickets == current_user.tickets.find_by(:payment_log_id=>pl.id).amount then
                  #返金処理
                  Stripe::Refund.create({payment_intent: pl.payment_intent})
                  #チケットを削除
                  current_user.tickets.find_by(:payment_log_id=>pl.id).destroy
                  #支払いログを削除
                  pl.destroy
               end
            end
        end
        redirect_to payment_path
    end
    
    def subscription_paied
       PaymentLog.create(:line_user_id=>1,course_id=>2,subscription=>'abc',:payment_intent=>'test')
       render plain: 'test' 
    end
    
    
    private
    def set_stripe_api_key
        Stripe.api_key = ENV['STRIPE_API_KEY']
    end
    
    def get_valid_date(payment_info)
        if payment_info.mode=='subscription'
            Time.current.next_month.strftime('%Y-%m-%d %H:%M:%S')
        elsif payment_info.mode=='payment'
            Time.current.next_year.strftime('%Y-%m-%d %H:%M:%S')
        end
    end
end
