class PaymentLog < ApplicationRecord
  belongs_to :line_user
  belongs_to :course
end
