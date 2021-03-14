class Api::V1::ContactsController < ApplicationController
  def index
    @contacts = Contact.ordered_name
    _, contact_list = pagy(@contacts)
    json_response({
      data: {
        contacts: contact_list,
        count:        @contacts.count
      }
    })
  end

  def create
    @contact = Contact.create!(contact_params)
    json_response(@contact, :created)
  end

  private

  def contact_params
    params.permit(:name, :contact_number)
  end
end
