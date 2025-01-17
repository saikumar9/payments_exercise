require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context 'with loan' do
      let!(:loan) { Loan.create!(funded_amount: 2000.0) }

      it 'responds with a 200 and valid JSON' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_truthy
      end
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, params: { id: loan.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_truthy
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
