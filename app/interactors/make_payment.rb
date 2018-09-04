class MakePayment
  include Interactor

  delegate :user_from, :user_to, :amount, to: :context

  def call
    ActiveRecord::Base.transaction do
      user_from.update!(balance: user_from.balance - amount)
      user_to.update!(balance: user_to.balance + amount)

      create_transaction
    end

  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e.message)
  end

  private

  def create_transaction
    Transaction.create!(
      user_from: user_from,
      user_to: user_to,
      amount: amount
    )
  end
end
