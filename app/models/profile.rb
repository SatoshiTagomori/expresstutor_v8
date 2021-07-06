class Profile < ApplicationRecord
  belongs_to :line_user
  belongs_to :pref
  
  before_save :set_stripe_params
  
  def set_stripe_params
    Stripe.api_key = ENV['STRIPE_API_KEY']
    Stripe::Customer.update(
      self.line_user.customer,
      {
        email: self.email,
        phone: self.tel,
        name: self.name,
        metadata: {
          line_user_id: self.line_user_id,
          cname: self.cname,
          pref_id: self.pref_id,
          year: self.year,
          month: self.month
        }
      },
    )
  end
  
  def gakunen
    school = '小学'
    gn = Date.today.year.to_i - self.year - 5
    #早生まれ
    if [1,2,3].include?(self.month.to_i) then gn -= 1 end
    #学年
    if [7,8,9].include?(gn) then gn -= 6 and school ='中学' end
    if [10,11,12].include?(gn) then gn -= 9 and school ='高校' end
    if gn>12 then
      return nil
    else
      return school + gn.to_s + '年生'
    end
  end
  
end
