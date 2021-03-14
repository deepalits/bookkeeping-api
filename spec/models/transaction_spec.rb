require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:transaction_type) }
  end

  describe 'scopes' do
    before do
      @contact1 = create(:contact, name: 'John Oliver', contact_number: '1234567890')
      contact2 = create(:contact, name: 'Aby Oliver', contact_number: '2334567890')
      create_list(:transaction, 3, contact: @contact1)
      create_list(:transaction, 2, transaction_type: 'debit')
      create_list(:transaction, 2, contact: contact2, transaction_type: 'credit')
    end

    context 'with filter_by_contact' do
      it 'returns all transactions of a contact' do
        transaction_ids = @contact1.transactions.ids
        result = described_class.filter_by_contact('1234567890')
        expect(result.length).to eq(3)
        expect(result.pluck(:id)).to eq(transaction_ids)
      end
    end

    context 'with filter_by_transaction_type' do
      it 'returns all transactions of a type' do
        transaction_ids = Transaction.debit.ids
        result = described_class.filter_by_transaction_type('debit')
        expect(result.length).to eq(2)
        expect(result.pluck(:id)).to eq(transaction_ids)
      end
    end
  end
end
