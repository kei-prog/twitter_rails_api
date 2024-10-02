# frozen_string_literal: true

module Api
  module V1
    class FavoritesController < ApplicationController
      before_action :authenticate_api_v1_user!, only: %i[toggle_favorite]

      def toggle_favorite
        favorite = current_api_v1_user.favorites.find_by(tweet_id: params[:tweet_id])
        if favorite
          favorite.destroy!
          head :no_content
        else
          favorite = current_api_v1_user.favorites.create!(tweet_id: params[:tweet_id])
          favorite.create_notification(current_api_v1_user)
          head :created
        end
      end
    end
  end
end
