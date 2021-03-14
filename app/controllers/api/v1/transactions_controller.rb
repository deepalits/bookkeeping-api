class Api::V1::TransactionsController < ApplicationController
  before_action :set_transaction, only: :show
  # before_action :find_contact, only: :create

  def index
    @transactions = Transaction.filter(params.slice(:contact, :transaction_type)).ordered_created_at
    _, transaction_list = pagy(@transactions)
    json_response({
      data: {
        transactions: transaction_list,
        count:        @transactions.count
      }
    })
  end

  def show
    json_response(@transaction)
  end

  def create
    @transaction = Transaction.create!(transaction_params)
    json_response(@transaction, :created)
  end

  private

  def transaction_params
    params.permit(:amount, :transaction_type, :description, :contact_id, :contact)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def filter_transaction
    params[:filter] 
  end
end
