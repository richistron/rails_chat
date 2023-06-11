# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'archivable', :user

  context 'model validations' do
    let(:user) { build(:user) }

    context 'validates_uniqueness_of :username' do
      before { user.save! }
      let(:duplicated_user) { User.create username: user.username, password: '123', password_confirmation: '123' }

      context 'model is invalid' do
        before do
          expect(duplicated_user.valid?).to be_falsey
        end

        it 'username in errors' do
          expect(duplicated_user.errors).to have_key(:username)
        end

        it 'error type taken' do
          expect(duplicated_user.errors.first.type).to eq(:taken)
        end
      end
    end

    context 'validates_presence_of' do
      context 'username' do
        before { user.username = nil }

        it 'invalid' do
          expect(user.valid?).to be_falsey
          expect(user.errors).to have_key(:username)
          expect(user.errors.first.type).to eq(:blank)
        end
      end

      context 'password_digest' do
        before do
          user.password = nil
          user.password_confirmation = nil
        end

        it 'invalid' do
          expect(user.valid?).to be_falsey
          expect(user.errors).to have_key(:password_digest)
          expect(user.errors.first.type).to eq(:blank)
        end
      end
    end
  end

  context 'has_secure_password' do
    let(:user) { create(:user) }

    it 'password_digest' do
      expect(user.password_digest).to be_truthy
    end
  end

  context 'is_admin' do
    let(:user) { create(:user) }
    let(:admin) { create(:user, :admin) }

    it 'is_admin false' do
      expect(user.is_admin).to be_falsey
    end

    it 'is_admin true' do
      expect(admin.is_admin).to be_truthy
    end
  end
end
