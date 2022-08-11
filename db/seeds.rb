loan = Loan.create!(funded_amount: 2000.0)
Payment.create!(loan_id: loan.id, amount: 500.0, payment_date: Date.today)
