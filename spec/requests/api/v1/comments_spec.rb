# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Comments' do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user:) }
  let(:valid_attributes) { { body: 'ValidBody' } }
  let(:invalid_attributes) { { body: 'a' * 281 } }

  describe 'GET /index' do
    before do
      sign_in user
    end

    context 'when valid parameters' do
      it 'returns a list of comments' do
        create_list(:comment, 10, tweet:, user:)
        get api_v1_tweet_comments_path(tweet)
        json = response.parsed_body
        expect(json).not_to be_empty
      end

      it 'returns a 200 status code' do
        get api_v1_tweet_comments_path(tweet)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of comments by user' do
        create_list(:comment, 10, user:, tweet:)
        get api_v1_user_comments_path(user)
        json = response.parsed_body
        expect(json).not_to be_empty
      end

      it 'returns a 200 status code for user comments' do
        get api_v1_user_comments_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid parameters' do
      before do
        get api_v1_tweet_comments_path(tweet, offset: -1)
      end

      it 'failed to get comments' do
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('query_parameters.invalid_query_parameters')])
      end

      it 'returns a 400 status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

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

  describe 'DELETE /destroy' do
    let!(:comment) { create(:comment, user:, tweet:) }

    before do
      sign_in user
    end

    context 'when valid parameters' do
      it 'deletes the comment' do
        expect do
          delete api_v1_comment_path(comment)
        end.to change(Comment, :count).by(-1)
      end

      it 'returns a 204 status code' do
        delete api_v1_comment_path(comment)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when invalid parameters' do
      it 'returns a 404 status code' do
        delete api_v1_comment_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        delete api_v1_comment_path(id: 0)
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('activerecord.errors.models.comment.not_found')])
      end
    end
  end
end
