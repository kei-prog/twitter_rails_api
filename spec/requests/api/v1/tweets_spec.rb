# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Tweets' do
  let(:user) { create(:user) }
  let(:valid_attributes) { { body: 'ValidBody' } }
  let(:invalid_attributes) { { body: 'a' * 281 } }

  describe 'GET /index' do
    context 'when valid parameters' do
      it 'returns a list of tweets' do
        create_list(:tweet, 10, user:)
        get api_v1_tweets_path
        json = response.parsed_body
        expect(json).not_to be_empty
      end

      it 'returns a 200 status code' do
        get api_v1_tweets_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid parameters' do
      before do
        get api_v1_tweets_path(offset: -1)
      end

      it 'failed to get tweets' do
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('query_parameters.tweets.invalid_query_parameters')])
      end

      it 'returns a 400 status code' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when either limit or offset parameters are invalid' do
      it 'fails to get tweets when limit is greater than 20' do
        get api_v1_tweets_path(limit: 21)
        expect(response).to have_http_status(:bad_request)
      end

      it 'fails to get tweets when limit is negative' do
        get api_v1_tweets_path(limit: -1)
        expect(response).to have_http_status(:bad_request)
      end

      it 'fails to get tweets when offset is negative' do
        get api_v1_tweets_path(offset: -1)
        expect(response).to have_http_status(:bad_request)
      end

      it 'fails to get tweets when limit is not an integer' do
        get api_v1_tweets_path(limit: 'a')
        expect(response).to have_http_status(:bad_request)
      end

      it 'fails to get tweets when offset is not an integer' do
        get api_v1_tweets_path(offset: 'a')
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when using pagination' do
      before do
        create_list(:tweet, 30, user:)
      end

      it 'returns the correct number of tweets based on limit' do
        get api_v1_tweets_path(limit: 10)
        json = response.parsed_body
        expect(json.size).to eq(10)
      end

      it 'returns the correct tweets based on offset' do
        get api_v1_tweets_path(limit: 20, offset: 10)
        json = response.parsed_body
        expected_tweet_id = Tweet.order(created_at: :desc).offset(10).limit(1).first.id
        expect(json.first['id']).to eq(expected_tweet_id)
      end

      it 'returns an empty list if offset is beyond the total number of tweets' do
        get api_v1_tweets_path(limit: 10, offset: 100)
        json = response.parsed_body
        expect(json).to be_empty
      end
    end
  end

  describe 'GET /show' do
    let!(:tweet) { create(:tweet, user:) }

    context 'with valid parameters' do
      it 'returns the tweet' do
        get api_v1_tweet_path(tweet)
        json = response.parsed_body
        expect(json['id']).to eq(tweet.id)
      end

      it 'returns a 200 status code' do
        get api_v1_tweet_path(tweet)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'returns a 404 status code' do
        get api_v1_tweet_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        get api_v1_tweet_path(id: 0)
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('activerecord.errors.models.tweet.not_found')])
      end
    end
  end

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

  describe 'DELETE /destroy' do
    let!(:tweet) { create(:tweet, user:) }

    before do
      sign_in user
    end

    context 'when valid parameters' do
      it 'deletes the tweet' do
        expect do
          delete api_v1_tweet_path(tweet)
        end.to change(Tweet, :count).by(-1)
      end

      it 'returns a 204 status code' do
        delete api_v1_tweet_path(tweet)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when invalid parameters' do
      it 'returns a 404 status code' do
        delete api_v1_tweet_path(id: 0)
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        delete api_v1_tweet_path(id: 0)
        json = response.parsed_body
        expect(json['errors']).to eq([I18n.t('activerecord.errors.models.tweet.not_found')])
      end
    end
  end
end
