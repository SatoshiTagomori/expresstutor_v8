class Customer
   attr_accessor :email,:name,:customer
   def initialize(user)
      self.set_stripe_api_key()
      self.customer = Stripe::Customer.retrieve(user.customer)
      self.customer.email.present? ? self.email=nil : self.email = self.customer.email
      #self.get_param('email')
      self.customer.name.present? ? self.name=nil : self.name = self.customer.name
   end
   
   def get_param(arg)
      eval('self.customer.'+arg+'.present? ? self.'+arg+'=nil : self.'+arg+'=self.customer.'+arg)
   end
   
   


   def set_stripe_api_key()
      Stripe.api_key = ENV['STRIPE_API_KEY']
   end
end