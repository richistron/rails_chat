# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :user
  has_secure_token
  before_create :set_expiration

  def expired?
    expiration < Time.now
  end

  private

  def set_expiration
    self.expiration = Time.now + 8.hours
  end
end
