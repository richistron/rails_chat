class CreateChatChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_channels do |t|
      t.string :name, limit: 50
      t.boolean :archived

      t.timestamps
    end
    add_index :chat_channels, :name, unique: true
  end
end
