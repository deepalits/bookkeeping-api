FactoryBot.define do
  factory :transaction do
    description { 'Bank Deposit' }
    amount { 100 }
    transaction_type { 'credit' }
  end
end
