# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      DEFAULT_LIMIT = 20
      DEFAULT_OFFSET = 0
      MAX_LIMIT = 20

      before_action :authenticate_api_v1_user!, except: %i[index]
      before_action :validate_query_params, only: %i[index]

      def index
        tweets = Tweet.includes(:user).order(created_at: :desc).offset(@offset).limit(@limit)

        render json: tweets.as_json(include: { user: { only: :name } }), status: :ok
      end

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

      def validate_query_params
        limit = params[:limit] || DEFAULT_LIMIT.to_s
        offset = params[:offset] || DEFAULT_OFFSET.to_s

        render_invalid_params and return unless valid_integer_params?(limit, offset)

        @limit = limit.to_i
        @offset = offset.to_i

        render_invalid_params unless @limit.between?(0, MAX_LIMIT)
      end

      def valid_integer_params?(limit, offset)
        limit =~ /\A\d+\z/ && offset =~ /\A\d+\z/ # 正の整数
      end

      def render_invalid_params
        render json: { errors: [I18n.t('query_parameters.tweets.invalid_query_parameters')] }, status: :bad_request
      end
    end
  end
end
