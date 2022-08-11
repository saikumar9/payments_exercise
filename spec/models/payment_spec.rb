require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe '#is_amount_valid?' do
    let(:loan) { Loan.create!(funded_amount: 2000.0) }

    context 'invalid amount' do
      let(:payment) { loan.payments.build(amount: -100.00, payment_date: DateTime.now) }

      it 'should return errors' do
        payment.valid?
        expect(payment.errors.full_messages).to include('Amount should be greater than 0.')
      end
    end

    context 'amount greater than remaining balance' do
      let(:payment) { loan.payments.build(amount: 2100.00, payment_date: DateTime.now) }

      it 'should return errors' do
        payment.valid?
        expect(payment.errors.full_messages).to include('Amount cannot be greater than outstanding balance of the loan.')
      end
    end
  end
end
