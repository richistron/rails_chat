# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:api_key) { create(:api_key) }
  before { expect(api_key.valid?).to be_truthy }
  after { Timecop.return }

  it 'belongs to user' do
    expect(api_key.user).to be_instance_of(User)
  end

  context 'scopes' do
    it 'expired_keys' do
      Timecop.travel (Time.now.utc + 8.hours + 1.minute).to_s
      expect(ApiKey.expired_keys.count).to eq(1)
    end

    it 'active_keys' do
      expect(ApiKey.active_keys.count).to eq(1)
    end
  end

  context 'expired?' do
    it 'is expired' do
      Timecop.travel(8.hours + 1.minute)
      expect(api_key.expired?).to be_truthy
    end

    it 'not expired?' do
      expect(api_key.expired?).to be_falsey
    end
  end

  context 'default expiration' do
    before { Timecop.freeze }
    it 'bigger than 7 hours' do
      expect(api_key.expiration).to be > (Time.now.advance(hours: 7))
    end

    it '8 hours' do
      expect(api_key.expiration).to be <= (Time.now.advance(hours: 8))
    end
  end
end
