require 'rails_helper'

RSpec.describe Loan, type: :model do
  let!(:loan) { Loan.create!(funded_amount: 2000.0) }
  let(:payment) { Payment.create!(amount: 100.0, payment_date: Date.today, loan_id: loan.id) }

  describe '.all_with_outstanding_balance' do
    it 'should return loans with outstanding balance' do
      expect(described_class.all_with_outstanding_balance).to be_a Array
      expect(described_class.all_with_outstanding_balance.first).to have_key('outstanding_balance')
    end
  end

  describe '#with_outstanding_balance' do
    context 'with payments' do
      it 'should return loan with outstanding balance' do
        payment
        expect(loan.with_outstanding_balance).to have_key('outstanding_balance')
        expect(loan.with_outstanding_balance['outstanding_balance']).to eq(1900)
      end
    end

    context 'without payments' do
      it 'should return loan with outstanding balance' do
        expect(loan.with_outstanding_balance).to have_key('outstanding_balance')
        expect(loan.with_outstanding_balance['outstanding_balance']).to eq(loan.funded_amount)
      end
    end
  end

  describe '#outstanding_balance' do
    context 'with payments' do
      it 'should return remaining balance' do
        payment
        expect(loan.outstanding_balance).to eq(1900)
      end
    end

    context 'without payments' do
      it 'should return remaining balance' do
        expect(loan.outstanding_balance).to eq(loan.funded_amount)
      end
    end
  end
end
