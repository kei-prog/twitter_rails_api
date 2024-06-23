# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Follows' do
  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }

    before do
      sign_in user
    end

    context 'when creating a follow' do
      it 'creates a Follow' do
        expect do
          post api_v1_user_follows_path(user_id: followed_user.id)
        end.to change(Follow, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_user_follows_path(user_id: followed_user.id)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when invalid parameters' do
      it 'raises an ActiveRecord::RecordInvalid error' do
        expect do
          post api_v1_user_follows_path(user, user_id: 0)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
