# frozen_string_literal: true

module Chat
  class ChannelsController < ApplicationController
    before_action :channel, only: [:show]

    def index
      channels ||= Chat::Channel.all_active.limit(10)
      render status: :ok, json: { channels: serialize(channels) }
    end

    def create
      new_channel = Chat::Channel.new channel_params
      if new_channel.save
        render status: :ok, json: serialize(new_channel.reload)
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

    # TODO, add delete method
    # TODO, add update method

    private

    def channel
      @channel ||= Chat::Channel.find_by_uuid channel_uuid
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
