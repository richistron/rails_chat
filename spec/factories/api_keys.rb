# frozen_string_literal: true

FactoryBot.define do
  factory :api_key do
    token { 'asdf123' }
    association :user, factory: :user
  end
end
