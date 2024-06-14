# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_api_v1_user!

      def create
        comment = current_api_v1_user.comments.build(comment_params)
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body).merge(tweet_id: params[:tweet_id])
      end
    end
  end
end
