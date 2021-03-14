class Transaction < ApplicationRecord
  include Filterable

  belongs_to :contact, optional: true

  enum transaction_type: { credit: 0, debit: 1 }

  validates :transaction_type, presence: true
  validates_presence_of :contact, if: :contact_id_present?
  validate :check_duplicate

  scope :ordered_created_at, -> { order('created_at DESC') }
  scope :filter_by_contact, -> (contact) { joins(:contact).where(contacts: { contact_number: contact }) }
  scope :filter_by_transaction_type, -> (type) { public_send(type.to_sym) }

  private

  def contact_id_present?
    Contact.find contact_id if contact_id.present?
  rescue ActiveRecord::RecordNotFound => e
    errors.add(:base, e.message)
    return
  end

  def check_duplicate
    key = "#{transaction_type}_#{amount}_#{contact_id}"
    if Rails.cache.fetch(key)
      errors.add(:base, "Duplicate request")
    else
      Rails.cache.write(key, 1, expires_in: CACHE_EXPIRES_IN)
    end
  end
end
