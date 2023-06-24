# frozen_string_literal: true

module Chat
  class ChannelsController < ApplicationController
    include ApiAuthenticable
    before_action :channel, only: %i[show update delete]
    before_action :authenticate!, only: %i[index show]
    before_action :authenticate_admin!, except: %i[index show]

    def index
      channels ||= Chat::Channel.all_active.limit(10)
      render status: :ok, json: { channels: serialize(channels) }
    end

    def create
      new_channel = Chat::Channel.new channel_params
      if new_channel.save
        render status: :created, json: serialize(new_channel.reload)
      else
        render status: :bad_request, json: { errors: new_channel.errors }
      end
    rescue StandardError
      render status: :bad_request, json: { error: 'Something went wrong' }
    end

    def show
      if channel.nil?
        render status: :not_found
      else
        render status: :ok, json: serialize(channel)
      end
    end

    def update
      if channel.update channel_params
        render status: :ok, json: serialize(channel)
      else
        render status: :bad_request, json: { errors: channel.errors }
      end
    rescue StandardError
      render status: :bad_request, json: { error: 'Something went wrong' }
    end

    def destroy
      if channel.soft_delete
        render status: :ok
      else
        render status: :bad_request
      end
    end

    private

    def channel
      @channel ||= Chat::Channel.all_active.find_by(uuid: channel_uuid)
    end

    def channel_params
      params.require(:channel).permit(:name)
    end

    def channel_uuid
      params[:id]
    end

    def serialize(response)
      response.as_json(only: %i[name uuid])
    end
  end
end
