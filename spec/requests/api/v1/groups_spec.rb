# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Groups' do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    before do
      create_list(:group, 3, sender: user)
    end

    context 'with valid parameters' do
      before do
        get api_v1_groups_path(offset: 0, limit: 10)
      end

      it 'returns a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of groups' do
        json = response.parsed_body
        expect(json).not_to be_empty
      end
    end

    context 'with invalid parameters' do
      before do
        get api_v1_groups_path(offset: -1)
      end

      it 'fails to get group' do
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('query_parameters.invalid_query_parameters')])
      end

      it 'returns a 400 status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #create' do
    let(:recipient) { create(:user) }

    context 'with valid parameters' do
      let(:valid_params) { { recipient_id: recipient.id } }

      it 'creates a new group' do
        expect do
          post api_v1_groups_path, params: valid_params
        end.to change(Group, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_groups_path, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns a 200 status code when group already exists with sender as user' do
        create(:group, sender: user, recipient:)
        post api_v1_groups_path, params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 200 status code when group already exists with sender as recipient' do
        create(:group, sender: recipient, recipient: user)
        post api_v1_groups_path, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { {} }

      it 'does not create a new group' do
        expect do
          post api_v1_groups_path, params: invalid_params
        end.not_to change(Group, :count)
      end

      it 'returns an unprocessable entity status' do
        post api_v1_groups_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
