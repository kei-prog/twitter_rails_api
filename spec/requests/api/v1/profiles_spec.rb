# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Profiles' do
  describe 'PATCH /update' do
    let(:user) { create(:user) }
    let(:valid_attributes) do
      { name: 'Update Name',
        introduction: 'Update Introduction',
        location: 'Tokyo',
        website: 'www.example.com' }
    end

    before do
      sign_in user
    end

    context 'when valid parameters' do
      it 'updates the user profile' do
        patch api_v1_profile_path, params: valid_attributes
        user.reload
        expect(user).to have_attributes(valid_attributes)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid parameters' do
      it 'returns 422 for invalid data' do
        patch api_v1_profile_path, params: { name: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
