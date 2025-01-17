# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Bookmarks' do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/v1/bookmarks/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/api/v1/bookmarks/create'
      expect(response).to have_http_status(:success)
    end
  end
end
