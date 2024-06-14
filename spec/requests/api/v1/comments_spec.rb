# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Comments' do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user:) }
  let(:valid_attributes) { { body: 'ValidBody' } }
  let(:invalid_attributes) { { body: 'a' * 281 } }

  describe 'POST /create' do
    before do
      sign_in user
    end

    context 'when valid parameters' do
      it 'creates a new Comment' do
        expect do
          post api_v1_tweet_comments_path(tweet), params: { comment: valid_attributes }
        end.to change(Comment, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_tweet_comments_path(tweet), params: { comment: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'when invalid parameters' do
      it 'does not create a new Comment' do
        expect do
          post api_v1_tweet_comments_path(tweet), params: { comment: invalid_attributes }
        end.not_to change(Comment, :count)
      end

      it 'returns a 400 status code' do
        post api_v1_tweet_comments_path(tweet), params: { comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
