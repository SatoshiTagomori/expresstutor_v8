class Course < ApplicationRecord
    validates :name,presence: true
    validates :price_id,presence: true
end
