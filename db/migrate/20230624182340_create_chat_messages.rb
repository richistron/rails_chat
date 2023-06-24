# frozen_string_literal: true

class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages do |t|
      t.uuid :uuid, default: 'gen_random_uuid()'
      t.string :content, limit: 200
      t.references :chat_channel, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
