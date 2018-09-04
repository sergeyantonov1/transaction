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

## Testing
[spec/interactors/make_payment_spec.rb](https://github.com/sergeyantonov1/transaction/blob/master/spec/interactors/make_payment_spec.rb)

```ruby
require "rails_helper"

describe MakePayment do
  describe "#call" do
    let(:amount) { 10 }
    let(:user_to) { create :user, balance: 0 }

    subject(:result) do
      described_class.call(
        user_from: user_from,
        user_to: user_to,
        amount: amount
      )
    end

    context "when the sender's balance is less than zero" do
      let(:user_from) { create :user, balance: -1 }

      it "doesn't create a transaction" do
        expect { result }.to change(Transaction, :count).by(0)
      end

      it "doesn't update user balance" do
        expect(result.user_from.balance).to eq(-1)
        expect(result.user_to.balance).to eq(0)
      end
    end

    context "when the sender's balance is greater than or equal to zero" do
      let(:user_from) { create :user, balance: 20 }

      it "creates a transaction" do
        expect { result }.to change(Transaction, :count).by(1)
      end

      it "updates user balances" do
        expect(result.user_from.balance).to eq(10)
        expect(result.user_to.balance).to eq(10)
      end
    end
  end
end
```
