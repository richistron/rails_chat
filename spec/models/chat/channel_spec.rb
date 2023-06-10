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

    context 'name most be unique' do
      let(:chat_channel) { create(:chat_channel) }
      let(:duplicated_channel) { Chat::Channel.new name: chat_channel.name }

      it 'error has name key' do
        duplicated_channel.valid?
        expect(duplicated_channel.errors).to have_key(:name)
      end

      it 'taken' do
        duplicated_channel.valid?
        expect(duplicated_channel.errors.first.type).to eq(:taken)
      end
    end
  end

  context 'soft deletion' do
    let(:chat_channel) { create(:chat_channel) }

    before do
      expect(chat_channel.archived).to be_falsey
    end

    it 'archive!' do
      expect(chat_channel.soft_delete).to be_truthy
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
