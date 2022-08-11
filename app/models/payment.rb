class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :amount, presence: true
  validates :payment_date, presence: true
  validate :is_amount_valid?

  private

  def is_amount_valid?
    return errors.add(:amount, "should be greater than 0.") unless amount > 0
    errors.add(:amount, "cannot be greater than outstanding balance of the loan.") if amount > loan.outstanding_balance
  end
end
