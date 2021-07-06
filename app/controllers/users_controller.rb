class UsersController < ApplicationController
  before_action :set_stripe_api_key
  
  def index
    LineAct.profile_action(@_request,self,LineUser,AccessLog)
    #current_userが存在して、かつcustomerが入っていない場合
    if !current_user.nil? && current_user.customer.nil?
      #customerを生成して保存する
      customer = Stripe::Customer.create({description: current_user.id})
      current_user.update(:customer=>customer[:id])
    end
    
    #顧客情報が入っていなければ
    if !current_user.nil? && !current_user.customer.nil?
      customer = Stripe::Customer.retrieve(current_user.customer)
      if customer[:email].nil?
        redirect_to profile_path and return
      end
    end
    
  end
  
  def payment
    #過去の支払い履歴
    @payments = Stripe::Charge.list({customer: current_user.customer}).data
  end
  
  def create
    current_user.build_profile(profile_params).save
    redirect_to profile_path
  end
  
  def edit
    
  end
  
  def update
    current_user.profile.update(profile_params)
    redirect_to profile_path
  end
  
  def sign_out
    LineAct.user_sign_out(@_request)
    current_user=nil
    redirect_to root_path
  end
  
  private
  #stripeのapi_keyを設定する
  def set_stripe_api_key
     Stripe.api_key = ENV['STRIPE_API_KEY']
  end
  
  def profile_params
    params.require(:profile).permit(:email,:name,:cname,:pref_id,:tel,:year,:month)
  end

end
