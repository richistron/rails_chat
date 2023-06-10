# frozen_string_literal: true

FactoryBot.define do
  factory :chat_channel, class: 'Chat::Channel' do
    name { 'general' }
    archived { false }
  end

  factory :chat_channel2, class: 'Chat::Channel' do
    name { 'memes' }
    archived { false }
  end
end
