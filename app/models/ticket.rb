class Ticket < ApplicationRecord
  belongs_to :line_user
  belongs_to :payment_log
end
