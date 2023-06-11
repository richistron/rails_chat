# frozen_string_literal: true

require 'rails_helper'

describe Chat::Channel, type: :model do
  it_behaves_like 'archivable', :chat_channel

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
end
