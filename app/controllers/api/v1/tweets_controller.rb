# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def create
        @tweet = current_api_v1_user.tweets.build(tweet_params)
        if @tweet.save
          render json: @tweet, status: :created
        else
          render json: @tweet.errors, status: :unprocessable_entity
        end
      end

      private

      def tweet_params
        params.require(:tweet).permit(:body)
      end
    end
  end
end
