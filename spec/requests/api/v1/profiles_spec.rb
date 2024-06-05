# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Profiles' do
  describe 'GET /update' do
    it 'returns http success' do
      get '/api/v1/profiles/update'
      expect(response).to have_http_status(:success)
    end
  end
end
