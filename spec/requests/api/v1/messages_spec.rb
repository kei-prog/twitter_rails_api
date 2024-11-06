# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Messages' do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET index' do
    let(:group) { create(:group) }

    before do
      create_list(:message, 3, group:)
    end

    context 'with valid parameters' do
      before do
        get api_v1_group_messages_path(group_id: group.id, offset: 0, limit: 10)
      end

      it 'returns a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of messages' do
        json = response.parsed_body
        expect(json).not_to be_empty
      end
    end

    context 'with invalid parameters' do
      before do
        get api_v1_group_messages_path(group_id: group.id, offset: -1, limit: 10)
      end

      it 'fails to get message' do
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('query_parameters.invalid_query_parameters')])
      end

      it 'returns a 400 status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST create' do
    let(:group) { create(:group) }

    context 'with valid parameters' do
      let(:valid_params) { { content: 'Spec content' } }

      it 'creates a new message' do
        expect do
          post api_v1_group_messages_path(group_id: group.id), params: valid_params
        end.to change(Message, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_group_messages_path(group_id: group.id), params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { {} }

      it 'does not create a new message' do
        expect do
          post api_v1_group_messages_path(group_id: group.id), params: invalid_params
        end.not_to change(Message, :count)
      end

      it 'returns an unprocessable entity status' do
        post api_v1_group_messages_path(group_id: group.id), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
