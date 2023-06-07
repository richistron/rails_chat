# frozen_string_literal: true

require 'rails_helper'

describe Chat::ChannelsController, type: :request do
  context 'GET /index' do
    before do
      create :chat_channel
      get chat_channels_path
    end

    let(:body) { JSON.parse @response.body }

    it 'status 200' do
      expect(@response.status).to eq(200)
    end

    it 'body has channels key' do
      expect(body).to have_key('channels')
    end

    it 'channels is an array' do
      expect(body['channels'].class).to eq(Array)
    end

    it 'expected fields' do
      expect(body['channels'].first).to include('uuid', 'name')
    end

    it 'excluded fields' do
      expect(body['channels'].first).not_to include('id', 'created_at', 'updated_at')
    end
  end

  context 'GET /create' do
    pending 'should TODO'
  end

  context 'GET /show' do
    context '200' do
      let(:chat_channel) { create :chat_channel }

      before do
        chat_channel.reload # loads uuid
        get chat_channel_path(chat_channel.uuid)
      end

      it 'loads channel' do
        expect(@response).to have_http_status(200)
      end

      context 'field validation' do
        let(:body) { JSON.parse @response.body }

        it 'name matches' do
          expect(body['name']).to eq(chat_channel.name)
        end

        it 'uuid matches' do
          expect(body['uuid']).to eq(chat_channel.uuid)
        end

        it 'allowed fields' do
          expect(body).to include('uuid', 'name')
        end

        it 'not allowed fields' do
          expect(body).not_to include('id', 'created_at', 'updated_at')
        end
      end
    end

    context 'not found' do
      before { get chat_channel_path('uuid-123456') }

      it '404 status' do
        expect(@response).to have_http_status(404)
      end
    end
  end
end
