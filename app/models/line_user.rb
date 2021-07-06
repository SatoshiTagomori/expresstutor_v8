class LineUser < ApplicationRecord
    has_one :profile
    has_many :payment_errors
    has_many :payment_logs
    has_many :tickets
    validates :line_id, presence: true,uniqueness: true
    
    
    ###############以下支払いに必要なメソッド#################
    
    def create_payment_log(payment_info,payment_intent)
        if payment_info.mode == 'subscription'
            self.payment_logs.create(:course_id=>payment_info.client_reference_id,:subscription=>payment_info.subscription,:payment_intent=>payment_intent,:log=>payment_info.to_s)
        elsif payment_info.mode == 'payment'
            self.payment_logs.create(:course_id=>payment_info.client_reference_id,:subscription=>nil,:payment_intent=>payment_intent,:log=>payment_info.to_s)
        end
    end
    
    
    def delete_subscription
        Stripe.api_key = ENV['STRIPE_API_KEY']
        if self.subscription.present?
            begin
                Stripe::Subscription.delete(self.subscription)
            rescue => e
                #削除に失敗した場合はエラーログに記載する
                self.payment_errors.create(:content=>e)
            end
            self.update(:subscription=>nil)
        end
    end

    #対象ユーザーのコースを取得する
    def course_id
        if !self.subscription.nil?
            Stripe.api_key = ENV['STRIPE_API_KEY']
            plan = Stripe::Subscription.retrieve(self.subscription).plan
            return Course.find_by(:price_id=>plan).id
        else
            return nil
        end
    end
    
    

    
    
end
