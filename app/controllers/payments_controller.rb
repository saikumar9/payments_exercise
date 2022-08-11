class PaymentsController < ApplicationController
  before_action :set_current_loan

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def create
    payment = @loan.payments.build(create_params)

    if payment.save
      render json: { message: 'Payment Successfully created' }, status: :created
    else
      render json: { message: 'Unable to create Payment', errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @loan.payments.find(params[:id])
  end

  def index
    render json: @loan.payments
  end

  private

  def create_params
    params.require(:payment).permit(:amount, :payment_date)
  end

  def set_current_loan
    @loan = Loan.find(params[:loan_id])
  end
end
