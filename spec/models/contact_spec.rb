require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:transactions) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:contact_number) }
  end

  context 'with ordered_name scope' do
    it 'returns contacts by in alphabetical order' do
      create(:contact, name: 'John Oliver', contact_number: '1234567890')
      create(:contact, name: 'Aby Oliver', contact_number: '1224567890')
      create(:contact, name: 'Andrew Oliver', contact_number: '0234567890')

      expect(described_class.ordered_name.pluck(:name)).to eq(['Aby Oliver', 'Andrew Oliver', 'John Oliver'])
    end
  end
end