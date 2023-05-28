FactoryBot.define do
  factory :chat_channel, class: 'Chat::Channel' do
    name { "general" }
    archived { false }
  end
end
