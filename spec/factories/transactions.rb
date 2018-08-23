FactoryGirl.define do
  factory :transaction do
    user_from { create :user }
    user_to { create :user }
    amount 1.5
  end
end
