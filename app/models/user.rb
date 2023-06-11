# frozen_string_literal: true

class User < ApplicationRecord
  include Archivable

  has_secure_password

  validates_uniqueness_of :username
  validates_presence_of :username, :password_digest
end
