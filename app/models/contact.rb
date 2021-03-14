class Contact < ApplicationRecord
  has_many :transactions

  validates :name, presence: true
  validates :contact_number, numericality: { only_integer: true }, presence: true, uniqueness: true, length: { is: 10 }

  scope :ordered_name, -> { order('name ASC') }
end
