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

    context "when the sender's balance is zero" do
      let(:user_from) { create :user, balance: 0 }

      it "doesn't create a transaction" do
        expect { result }.to change(Transaction, :count).by(0)
      end

      it "doesn't update user balance" do
        expect(result.user_from.reload.balance).to eq(0)
        expect(result.user_to.reload.balance).to eq(0)
        expect(result.error).to eq("Validation failed: Balance must be greater than or equal to 0.0")
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
