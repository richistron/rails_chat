# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:api_key) { build(:api_key) }

  it 'belongs to user' do
    api_key.save
    expect(api_key.user).to be_instance_of(User)
  end

  context 'expiration' do
    after do
      expect(api_key.valid?).to be_truthy
    end

    it 'expired?' do
      api_key.expiration = Time.now - 1.hour
      expect(api_key.expired?).to be_truthy
    end

    it 'not expired?' do
      api_key.expiration = Time.now + 1.hour
      expect(api_key.expired?).to be_falsey
    end

    it 'default expiration' do
      api_key.save!
      expect(api_key.expiration).to be > (Time.now.advance(hours: 7))
      expect(api_key.expiration).to be <= (Time.now.advance(hours: 8))
    end
  end
end
