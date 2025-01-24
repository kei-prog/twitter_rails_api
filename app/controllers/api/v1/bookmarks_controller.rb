# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      include PaginationParamsValidator

      before_action :authenticate_api_v1_user!
      before_action :validate_query_params, only: %i[index]

      def index
        tweets = current_api_v1_user.bookmarked_tweets.recent(@offset, @limit)

        render json: tweets.as_json(include: { user: { methods: :avatar_url, only: %i[id name] } },
                                    methods: %i[retweet_count favorite_count],
                                    current_user: current_api_v1_user), status: :ok
      end

      def toggle_bookmark
        bookmark = current_api_v1_user.bookmarks.find_by(tweet_id: params[:tweet_id])
        if bookmark
          bookmark.destroy!
          head :no_content
        else
          current_api_v1_user.bookmarks.create!(tweet_id: params[:tweet_id])
          head :created
        end
      end
    end
  end
end
