# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      include PaginationParamsValidator

      before_action :authenticate_api_v1_user!, except: %i[index show]
      before_action :validate_query_params, only: %i[index]

      def index
        tweets = Tweet.recent(@offset, @limit)

        render json: tweets.as_json(include: { user: { methods: :avatar_url, only: %i[id name] } }), status: :ok
      end

      def show
        tweet = Tweet.find_by(id: params[:id])

        if tweet
          render json: tweet.as_json(include: { user: { methods: :avatar_url, only: %i[id name] } }), status: :ok
        else
          render json: { errors: [I18n.t('activerecord.errors.models.tweet.not_found')] }, status: :not_found
        end
      end

      def create
        @tweet = current_api_v1_user.tweets.build(tweet_params)
        if @tweet.save
          render json: @tweet.as_json(include: { user: { only: :name } }), status: :created
        else
          render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        tweet = current_api_v1_user.tweets.find_by(id: params[:id])

        if tweet
          tweet.destroy
          head :no_content
        else
          render json: { errors: [I18n.t('activerecord.errors.models.tweet.not_found')] }, status: :not_found
        end
      end

      private

      def tweet_params
        params.require(:tweet).permit(:body)
      end
    end
  end
end
