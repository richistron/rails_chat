# frozen_string_literal:true

module Chat
  class Message < ApplicationRecord
    include Archivable
    belongs_to :chat_channel, class_name: 'Chat::Channel'
    belongs_to :user
    validates_presence_of :content, :user, :chat_channel
    validates_length_of :content, maximum: 200, minimum: 1
  end
end
