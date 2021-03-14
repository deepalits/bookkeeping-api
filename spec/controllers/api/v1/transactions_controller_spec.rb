require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let(:contact) { create(:contact, contact_number: '1234567890') }
  let(:contact_id) { contact.id }

  before do
    create_list(:transaction, 10, contact_id: contact.id)
    create_list(:transaction, 10)
  end

  describe 'GET index' do
    context 'when no filter is passed' do
      it 'returns status code 200' do
        get :index
        expect(response).to have_http_status(200)
      end

      it 'returns all transactions' do
        get :index
        response_data = JSON.parse(response.body)['data']

        expect(response_data['transactions'].size).to eq(4)
        expect(response_data['count']).to eq(20)
      end
    end

    context 'when filter of existing contact number is passed' do
      it 'returns status code 200 and returns transactions of contact' do
        get :index, params: { contact: '1234567890' }
        response_data = JSON.parse(response.body)['data']

        expect(response).to have_http_status(200)
        expect(response_data['transactions'].size).to eq(4)
        expect(response_data['count']).to eq(10)
      end
    end

    context 'when filter of non-existing contact number is passed' do
      it 'returns status code 200 and returns transactions of contact' do
        get :index, params: { contact: '9234567890' }
        response_data = JSON.parse(response.body)['data']

        expect(response).to have_http_status(200)
        expect(response_data['transactions'].size).to eq(0)
        expect(response_data['count']).to eq(0)
      end
    end
  end

  describe 'POST create' do
    context 'when contact exists' do
      it 'creates transaction record for contact and returns status code 200' do
        post :create, params: { amount: 1000, transaction_type: 'debit', contact_id: contact_id } 
        expect(response).to have_http_status(201)
      end
    end

    context 'when contact does not exist' do
      it 'returns a not found message' do
        post :create, params: { amount: 1000, transaction_type: 'debit', contact_id: 100 } 

        expect(response.body).to match(/Couldn't find Contact/)
      end
    end
  end
end
