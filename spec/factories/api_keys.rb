# frozen_string_literal: true

FactoryBot.define do
  factory :api_key do
    token { 'asdf123' }
    association :user, factory: :user
    expiration { '2023-06-16 22:02:07' }
  end
end
