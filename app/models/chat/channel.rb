# frozen_string_literal: true

module Chat
  class Channel < ApplicationRecord
    validates_presence_of :name
    validates_uniqueness_of :name
    scope :all_active, -> { where('archived is not ?', true) }

    def soft_delete
      self.archived = true
      save
    end
  end
end
