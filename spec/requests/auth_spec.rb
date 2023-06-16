# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'POST /login' do
    let(:password) { 'superSecretPassword!23' }
    let(:user) { create(:user, password:, password_confirmation: password) }

    context 'success login' do
      before do
        post '/auth/login', params: { username: user.username, password: }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      context 'body response' do
        let(:body) { JSON.parse(response.body) }

        it 'does not return id and password digest' do
          not_included = %w[id password_digest password password_confirmation created_at updated_at]
          expect(body).not_to include(*not_included)
        end

        it 'should include uuid and username' do
          included = %w[uuid username]
          expect(body).to include(*included)
        end
      end
    end

    context 'login failed' do
      before do
        post '/auth/login', params: { username: user.username, password: '123' }
      end

      it 'returns http bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      context 'body response' do
        let(:body) { JSON.parse(response.body) }

        it 'does not return id and password digest' do
          expect(body['error']).to eq('invalid username/password combination')
        end
      end
    end
  end
end
