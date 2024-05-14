# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Images' do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user:) }
  let(:valid_image_attributes) do
    { images: [fixture_file_upload(Rails.root.join('spec/fixtures/files/test.jpeg'), 'image/jpeg')] }
  end
  let(:invalid_image_attributes) { { images: [] } }

  describe 'POST /create' do
    before do
      sign_in user
    end

    context 'with valid parameters' do
      it 'attaches a new image to the tweet' do
        expect do
          post api_v1_tweet_images_path(tweet), params: valid_image_attributes
        end.to change(tweet.images, :count).by(1)
      end

      it 'returns a 201 status code' do
        post api_v1_tweet_images_path(tweet), params: valid_image_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not attach a new image to the tweet' do
        expect do
          post api_v1_tweet_images_path(tweet), params: invalid_image_attributes
        end.not_to change(tweet.images, :count)
      end

      it 'returns a 422 status code' do
        post api_v1_tweet_images_path(tweet), params: invalid_image_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
