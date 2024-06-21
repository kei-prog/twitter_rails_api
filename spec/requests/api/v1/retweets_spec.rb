# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Retweets' do
  describe 'POST /toggle_retweet' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user:) }

    before do
      sign_in user
    end

    context 'when createing a retweet' do
      it 'creates a Retweet' do
        expect do
          post api_v1_tweet_toggle_retweet_path(tweet)
        end.to change(Retweet, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_tweet_toggle_retweet_path(tweet)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when deleting a retweet' do
      before do
        post api_v1_tweet_toggle_retweet_path(tweet)
      end

      it 'destroys the Retweet' do
        expect do
          post api_v1_tweet_toggle_retweet_path(tweet)
        end.to change(Retweet, :count).by(-1)
      end

      it 'returns a no_content status code' do
        post api_v1_tweet_toggle_retweet_path(tweet)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when invalid parameters' do
      it 'raises an ActiveRecord::RecordInvalid error' do
        expect do
          post api_v1_tweet_toggle_retweet_path(tweet_id: 0)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
