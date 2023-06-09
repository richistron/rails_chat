# frozen_string_literal: true

require 'rails_helper'

describe Chat::ChannelsController, type: :request do
  def included_fields(chat_channel)
    expect(chat_channel).to include('uuid', 'name')
    expect(chat_channel).not_to include('id', 'created_at', 'updated_at')
  end

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
      included_fields body['channels'].first
    end
  end

  context 'POST /create' do
    context 'success' do
      before do
        post chat_channels_path, params: { channel: { name: 'Memes' } }
      end

      it '201 status' do
        expect(@response).to have_http_status(201)
      end

      context 'response' do
        let(:body) { JSON.parse @response.body }

        it 'included fields' do
          included_fields body
        end
      end
    end

    context 'invalid request' do
      context 'invalid params' do
        before do
          post chat_channels_path, params: { channel: { foo: 'bar' } }
        end
        let(:body) { JSON.parse(@response.body) }

        it '400' do
          expect(@response).to have_http_status(400)
        end

        it 'name is required' do
          expect(body['errors']).to have_key('name')
        end
      end
    end
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

        it 'included fields' do
          included_fields body
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
