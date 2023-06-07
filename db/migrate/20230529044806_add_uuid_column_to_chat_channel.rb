# frozen_string_literal: true

class AddUuidColumnToChatChannel < ActiveRecord::Migration[7.0]
  def change
    add_column :chat_channels, :uuid, :uuid, default: 'gen_random_uuid()'
  end
end
