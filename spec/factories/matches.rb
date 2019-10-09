FactoryBot.define do
  factory :match do
    target_creator { create :target }
    target_compatible { create :target }
    user_creator { target_creator.user }
    user_compatible { target_compatible.user }
    conversation
  end
end
