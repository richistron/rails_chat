class Chat::Channel < ApplicationRecord
  validates_presence_of :name
  scope :all_active, -> { where('archived is not ?', true) }

  def archive!
    self.archived = true
    save!
  end
end
