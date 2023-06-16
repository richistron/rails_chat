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

  context 'PATCH /update' do
    context '200' do
      let(:channel) { create(:chat_channel) }
      before do
        channel.reload
        patch chat_channel_path(channel.uuid, params: { channel: { name: 'not memes' } })
      end

      it 'success' do
        expect(@response).to have_http_status(200)
      end

      it 'response' do
        body = JSON.parse(@response.body)
        expect(body['name']).to eq('not memes')
      end

      it 'included fields' do
        included_fields(JSON.parse(@response.body))
      end
    end

    context '400' do
      let(:channel) { create(:chat_channel) }
      before do
        channel.reload
        channel2 = create(:chat_channel2)
        patch chat_channel_path(channel.uuid, params: { channel: { name: channel2.name } })
      end

      it 'status code' do
        expect(@response).to have_http_status(400)
      end

      context 'response body' do
        let(:body) { JSON.parse(@response.body) }

        it 'errors key' do
          expect(body).to have_key('errors')
        end

        it 'contains name key' do
          expect(body['errors']).to have_key('name')
        end

        it 'name is already taken' do
          expect(body['errors']['name'].first).to eq('has already been taken')
        end
      end
    end
  end

  context 'DELETE /delete' do
    let(:uuid) do
      channel = create(:chat_channel)
      channel.reload
      channel.uuid
    end

    before { delete chat_channel_path(uuid) }

    it 'status 200' do
      expect(@response).to have_http_status(200)
    end

    it 'channel has been soft deleted' do
      channel = Chat::Channel.find_by_uuid uuid
      expect(channel.archived).to be_truthy
    end

    context 'does not returns deleted items anymore' do
      before { get chat_channel_path(uuid) }

      it 'not found' do
        expect(@response).to have_http_status(404)
      end
    end
  end
end