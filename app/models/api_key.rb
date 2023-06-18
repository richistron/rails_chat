# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :user
  has_secure_token
  before_create :set_expiration

  scope :expired_keys, -> { where('expiration <= ?', Time.now.utc) }
  scope :active_keys, -> { where('expiration > ?', Time.now.utc) }

  def expired?
    expiration <= Time.now.utc
  end

  private

  def set_expiration
    self.expiration = Time.now.utc + 8.hours
  end
end
