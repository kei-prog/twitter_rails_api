# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      include PaginationParamsValidator
      before_action :authenticate_api_v1_user!
      before_action :validate_query_params, only: %i[index]

      def index
        tweet = Tweet.find_by(id: params[:tweet_id])
        if tweet
          comments = tweet.comments.recent(@offset, @limit)
          render json: comments.as_json(include: { user: { methods: :avatar_url, only: %i[id name] } }), status: :ok
        else
          render json: { errors: [I18n.t('activerecord.errors.models.tweet.not_found')] }, status: :not_found
        end
      end

      def create
        comment = current_api_v1_user.comments.build(comment_params)
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        comment = current_api_v1_user.comments.find_by(id: params[:id])
        if comment
          comment.destroy
          head :no_content
        else
          render json: { errors: [I18n.t('activerecord.errors.models.comment.not_found')] }, status: :not_found
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body).merge(tweet_id: params[:tweet_id])
      end
    end
  end
end
