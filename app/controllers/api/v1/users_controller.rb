# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include PaginationParamsValidator

      before_action :validate_query_params, only: %i[show]
      before_action :authenticate_api_v1_user!, only: %i[show]

      def show
        user = User.find_by(id: params[:id])
        if user
          render json: user_json(user), status: :ok
        else
          render json: { errors: [I18n.t('activerecord.errors.models.user.not_found')] }, status: :not_found
        end
      end

      private

      def user_json(user)
        tweets = user.tweets.recent(@offset, @limit)
        user.as_json(only: %i[id name introduction location website created_at])
            .merge(
              avatar_url: user.avatar_url,
              header_url: user.header_url,
              following: current_api_v1_user.following?(user),
              tweets: tweets.as_json(include: { user: { methods: :avatar_url, only: :name } },
                                     only: %i[id body created_at],
                                     methods: %i[retweet_count favorite_count])
            )
      end
    end
  end
end
