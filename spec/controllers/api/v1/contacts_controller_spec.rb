require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  before do
    create(:contact, contact_number: '1234567890', name: 'Zoey')
    create(:contact, contact_number: '0987654321', name: 'Doe')
    create(:contact, contact_number: '9876543210', name: 'Smith')
    create(:contact, contact_number: '8765432109', name: 'Aby')
    create(:contact, contact_number: '8765432108', name: 'Amy')
  end

  describe 'GET index' do
    it 'returns status code 200' do
      get :index
      expect(response).to have_http_status(200)
    end

    it 'returns transactions in order of the name' do
      get :index
      response_data = JSON.parse(response.body)['data']

      expect(response_data['contacts'].size).to eq(4)
      expect(response_data['count']).to eq(5)
      expect(response_data['contacts'].map { |c| c['name'] }).to eq(["Aby", "Amy", "Doe", "Smith"])
    end
  end

  describe 'POST create' do
    context 'when contact exists' do
      it 'does not create contact and returns status code 200' do
        post :create, params: { name: 'John', contact_number: '8765432108' } 
        response_data = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(response_data['message']).to eq('Validation failed: Contact number has already been taken')
      end
    end

    context 'when contact does not exist' do
      it 'creates contact and returns status code 201' do
        post :create, params: { name: 'John', contact_number: '7777777777' } 

        expect(response).to have_http_status(201)
      end
    end
  end
end
