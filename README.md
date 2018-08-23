# Transaction

Simple example using transactions with `ActiveRecord::Base.transaction`

## Scripts

* `bin/setup` - setup required gems and migrate db if needed
* `bin/quality` - runs rubocop, brakeman, rails_best_practices and bundle-audit for the app
* `bin/ci` - should be used in the CI or locally
* `bin/server` - to run server locally

## Example
[app/interactors/make_payment.rb](https://github.com/sergeyantonov1/transaction/blob/master/app/interactors/make_payment.rb)

```ruby
class MakePayment
  include Interactor

  delegate :user_from, :user_to, :amount, to: :context

  def call
    context.fail! if user_from.balance < amount

    make_payment
  end

  private

  def create_transaction
    Transaction.create!(
      user_from: user_from,
      user_to: user_to,
      amount: amount
    )
  end

  def make_payment
    ActiveRecord::Base.transaction do
      user_from.update!(balance: user_from.balance - amount)
      user_to.update!(balance: user_to.balance + amount)

      create_transaction
    end
  end
end
```
