require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 3000.0) }

  describe '#create' do
    let(:params) { { loan_id: loan.id, payment: { amount: amount, payment_date: DateTime.now} } }

    context 'payment amount is less than outstanding balance' do
      let(:amount) { 1000.00 }

      it 'adds a payment if outstanding balance greater than payment amount' do
        post :create, params: params
        expect(loan.payments.count).to eq 1
        expect(response).to have_http_status(:created)
      end
    end

    context 'payment amount is zero' do
      let(:amount) { 0 }

      it 'returns error if payment amount is zero with error messages' do
        post :create, params: params
        expect(loan.payments.count).to eq 0
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end

    context 'payment amount is greater than outstanding balance' do
      let(:amount) { 3100.00 }

      it 'should not create a payment and return error' do
        post :create, params: params
        expect(loan.payments.count).to eq 0
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        post :create, params: { loan_id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#show' do
    let(:payment) { Payment.create!(amount: 50.0, loan_id: loan.id, payment_date: DateTime.now) }

    context 'if the payment is found' do
      it 'responds with a 200' do
        get :show, params: { loan_id: loan.id, id: payment.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if the payment is not found' do
      it 'responds with a 404' do
        get :show, params: { loan_id: loan.id, id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#index' do
    it 'responds with a 200' do
      get :index, params: { loan_id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :index, params: { loan_id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
