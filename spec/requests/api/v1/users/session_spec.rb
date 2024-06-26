# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::Sessions' do
  describe 'POST /api/v1/users/sign_in' do
    let(:user) { create(:user) }

    it 'logs in the user' do
      post '/api/v1/users/sign_in', params: {
        email: user.email, password: 'password'
      }

      expect(response).to have_http_status(:ok)
      expect(response.headers['access-token']).to be_present
    end

    it 'does not log in the user' do
      post '/api/v1/users/sign_in', params: {
        email: user.email, password: 'wrong_password'
      }

      expect(response).to have_http_status(:unauthorized)
      expect(response.headers['access-token']).to be_nil
    end
  end
end
