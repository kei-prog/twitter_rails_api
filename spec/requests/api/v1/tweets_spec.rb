# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Tweets' do
  describe 'GET /create' do
    it 'returns http success' do
      get '/api/v1/tweets/create'
      expect(response).to have_http_status(:success)
    end
  end
end
