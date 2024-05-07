# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Images' do
  describe 'GET /create' do
    it 'returns http success' do
      get '/api/v1/images/create'
      expect(response).to have_http_status(:success)
    end
  end
end
