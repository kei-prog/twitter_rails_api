# frozen_string_literal: true

module Api
  module V1
    class ImagesController < ApplicationController
      before_action :authenticate_api_v1_user!

      def create
        tweet = current_api_v1_user.tweets.find(image_params[:tweet_id])
        tweet.images.attach(image_params[:images])

        if tweet.images.attached? && tweet.valid?
          head :created
        else
          render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def image_params
        params.permit(:tweet_id, images: [])
      end
    end
  end
end
