# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, limit: 30
      t.string :password_digest
      t.boolean :is_admin, default: false
      t.boolean :archived, default: false
      t.uuid :uuid, default: 'gen_random_uuid()'

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
