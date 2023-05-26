class Payment < ApplicationRecord
  has_and_belongs_to_many :invoices, class_name: "Tranzaction"
  belongs_to :tranzaction
end
