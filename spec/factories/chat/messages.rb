# frozen_string_literal: true

FactoryBot.define do
  factory :chat_message, class: 'Chat::Message' do
    uuid { 'uuid-message-123' }
    content { 'Lorem ipsum message' }
    association :chat_channel, factory: :chat_channel
    association :user, factory: :user
    archived { false }
  end
end
