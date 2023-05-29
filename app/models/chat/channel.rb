# frozen_string_literal: true

module Chat
  class Channel < ApplicationRecord
    validates_presence_of :name
    scope :all_active, -> { where('archived is not ?', true) }

    def archive!
      self.archived = true
      save!
    end
  end
end
