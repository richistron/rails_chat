# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chat::Message, type: :model do
  it_behaves_like 'archivable', :chat_message

  context 'validations' do
    let(:message) { build :chat_message }

    context 'content' do
      before { message.content = nil }

      context 'invalid' do
        before { expect(message).not_to be_valid }

        it 'has error key' do
          expect(message.errors).to have_key(:content)
        end
        it 'cannot be blank' do
          expect(message.errors[:content]).to include("can't be blank")
        end
        it 'minimum' do
          expect(message.errors[:content]).to include(match(/minimum is 1 character/))
        end
        it 'maximum' do
          message.content = 's' * 300
          message.valid?
          expect(message.errors[:content]).to include(match(/maximum is 200 characters/))
        end
      end
    end

    context 'user' do
      before { message.user = nil }

      context 'invalid' do
        before { expect(message).not_to be_valid }

        it 'has error key' do
          expect(message.errors).to have_key(:user)
        end
        it 'cannot be blank' do
          expect(message.errors[:user]).to include("can't be blank")
        end
      end
    end

    context 'chat_channel' do
      before { message.chat_channel = nil }

      context 'invalid' do
        before { expect(message).not_to be_valid }

        it 'has error key' do
          expect(message.errors).to have_key(:chat_channel)
        end
        it 'cannot be blank' do
          expect(message.errors[:chat_channel]).to include("can't be blank")
        end
      end
    end
  end

  context 'associations' do
    let(:message) { create :chat_message }

    it 'has user' do
      expect(message.user).to be_instance_of(User)
    end

    it 'has Chat::Channel' do
      expect(message.chat_channel).to be_instance_of(Chat::Channel)
    end
  end
end
