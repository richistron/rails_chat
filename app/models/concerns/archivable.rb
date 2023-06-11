# frozen_string_literal: true

module Archivable
  extend ActiveSupport::Concern

  included do
    scope :all_active, -> { where('archived = ?', false) }
    scope :all_archived, -> { where('archived = ?', true) }
  end

  def soft_delete
    update_attribute :archived, true
  end
end
