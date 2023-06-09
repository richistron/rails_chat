# frozen_string_literal: true

require 'rails_helper'

describe Chat::Channel, type: :model do
  context 'model validations' do
    let(:chat_channel) { build(:chat_channel) }

    it 'name is required' do
      chat_channel.name = nil
      expect(chat_channel.valid?).to be_falsey
      expect(chat_channel.errors).to have_key(:name)
    end

    # TODO, break into 1 assertions
    it 'name is unique' do
      expect(chat_channel.save).to be_truthy
      duplicated_channel = Chat::Channel.new name: chat_channel.name
      expect(duplicated_channel.valid?).to be_falsey
      expect(duplicated_channel.errors).to have_key(:name)
      expect(duplicated_channel.errors.first.type).to eq(:taken)
    end
  end

  context 'soft deletion' do
    let(:chat_channel) { create(:chat_channel) }

    before do
      expect(chat_channel.archived).to be_falsey
    end

    # TODO, rename method as soft_delete
    it 'archive!' do
      expect(chat_channel.archive!).to be_truthy
      expect(chat_channel.archived).to be_truthy
    end
  end

  context 'archived' do
    let(:active_channels) { 5 }
    let(:inactive_channels) { 3 }

    before do
      active_channels.times { |a| Chat::Channel.create! name: "active channel #{a}" }
      inactive_channels.times { |i| Chat::Channel.create! name: "archive channel #{i}", archived: true }
    end

    it 'returns active channels' do
      expect(Chat::Channel.all_active.count).to eq(active_channels)
    end

    it 'returns all channels' do
      expect(Chat::Channel.all.count).to eq(active_channels + inactive_channels)
    end
  end
end
