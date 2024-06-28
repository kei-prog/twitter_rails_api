# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Notifications' do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    before do
      create_list(:notification, 10, user:)
    end

    context 'when valid parameters' do
      it 'returns a list of notifications' do
        get api_v1_notifications_path
        json = response.parsed_body
        expect(json.length).to eq(10)
      end

      it 'returns a 200 status code' do
        get api_v1_notifications_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid parameters' do
      before do
        get api_v1_notifications_path(offset: -1)
      end

      it 'failed to get notifications' do
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('query_parameters.invalid_query_parameters')])
      end

      it 'returns a 400 status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
