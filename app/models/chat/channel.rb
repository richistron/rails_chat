# frozen_string_literal: true

module Chat
  class Channel < ApplicationRecord
    include Archivable

    validates_presence_of :name
    validates_uniqueness_of :name
  end
end
