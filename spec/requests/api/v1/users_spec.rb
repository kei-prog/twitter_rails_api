# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users' do
  describe 'GET /api/v1/users/:id' do
    let(:user) { create(:user) }

    before { create_list(:tweet, 30, user:) }

    context 'when valid parameters' do
      before { get api_v1_user_path(user.id), params: { limit: 20 } }

      it 'returns the user details' do
        expect(response.parsed_body).to include(
          'id' => user.id,
          'name' => user.name,
          'introduction' => user.introduction,
          'location' => user.location,
          'website' => user.website
        )
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user\'s tweets' do
        expect(response.parsed_body['tweets'].size).to eq(20)
      end
    end

    context 'when invalid parameters' do
      before { get api_v1_user_path(-1) }

      it 'returns a 404 status code' do
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['errors']).to include(I18n.t('activerecord.errors.models.user.not_found'))
      end
    end
  end
end
