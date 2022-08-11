class Loan < ActiveRecord::Base
  has_many :payments, dependent: :destroy

  def self.all_with_outstanding_balance
    Loan.all.inject([]) do |arr, loan|
      arr << loan.with_outstanding_balance
    end
  end

  def with_outstanding_balance
    attributes.tap do |attrs|
      attrs.merge!({ 'outstanding_balance' => outstanding_balance })
    end
  end

  def outstanding_balance
    return funded_amount if payments.empty?
    funded_amount - payments.sum(:amount)
  end
end
