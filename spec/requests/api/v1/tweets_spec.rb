# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Tweets' do
  let(:user) { create(:user) }
  let(:valid_attributes) { { body: 'ValidBody' } }
  let(:invalid_attributes) { { body: 'a' * 281 } }

  describe 'POST /create' do
    before do
      sign_in user
    end

    context 'with valid parameters' do
      it 'creates a new Tweet' do
        expect do
          post api_v1_tweets_path, params: { tweet: valid_attributes }
        end.to change(Tweet, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_tweets_path, params: { tweet: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Tweet' do
        expect do
          post api_v1_tweets_path, params: { tweet: invalid_attributes }
        end.not_to change(Tweet, :count)
      end

      it 'returns a 422 status code' do
        post api_v1_tweets_path, params: { tweet: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
