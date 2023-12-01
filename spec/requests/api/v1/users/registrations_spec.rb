# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::Registrations' do
  describe 'POST /api/v1/users' do
    let(:user_params) do
      {
        name: 'test',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password',
        birthday: '1990-01-01'
      }
    end

    it 'creates a new user' do
      expect do
        post '/api/v1/users', params: user_params
      end.to change(User, :count).by(1)

      expect(response).to have_http_status(:ok)
    end
  end
end
