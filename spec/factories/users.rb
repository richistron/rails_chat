# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'panchito' }
    password { '123' }
    is_admin { false }
    archived { false }
    uuid { 'uuid-user-123' }

    trait :admin do
      username { 'redditmod' }
      uuid { 'uuid-admin-123' }
      is_admin { true }
    end
  end
end
