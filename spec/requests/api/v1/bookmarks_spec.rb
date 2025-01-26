# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Bookmarks' do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    before do
      create_list(:bookmark, 10, user:)
    end

    context 'when valid parameters' do
      it 'returns a list of bookmarks' do
        get api_v1_bookmarks_path(offset: 0, limit: 10)
        json = response.parsed_body
        expect(json.length).to eq(10)
      end

      it 'returns a 200status code' do
        get api_v1_bookmarks_path(offset: 0, limit: 10)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /toggle_bookmark' do
    let(:tweet) { create(:tweet) }

    context 'when createing bookmark' do
      it 'create a new bookmark' do
        expect do
          post api_v1_tweet_toggle_bookmark_path(tweet)
        end.to change(Bookmark, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_tweet_toggle_bookmark_path(tweet)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when deleting a bookmark' do
      before do
        post api_v1_tweet_toggle_bookmark_path(tweet)
      end

      it 'destroys the bookmark' do
        expect do
          post api_v1_tweet_toggle_bookmark_path(tweet)
        end.to change(Bookmark, :count).by(-1)
      end

      it 'returns a no_content status code' do
        post api_v1_tweet_toggle_bookmark_path(tweet)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid parameters' do
      it 'raisess an ActiveRecord::RecordInvalid error' do
        expect do
          post api_v1_tweet_toggle_bookmark_path(tweet_id: 0)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
