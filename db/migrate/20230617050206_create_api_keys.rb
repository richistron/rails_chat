# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.datetime :expiration

      t.timestamps
    end
    add_index :api_keys, :token, unique: true
  end
end
