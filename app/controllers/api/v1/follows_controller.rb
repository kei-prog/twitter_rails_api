# frozen_string_literal: true

module Api
  module V1
    class FollowsController < ApplicationController
      before_action :authenticate_api_v1_user!, only: %i[create]

      def create
        Follow.create!(follower_id: current_api_v1_user.id, followed_id: params[:user_id])
        head :created
      end

      def destroy
        follow = Follow.find_by!(follower_id: current_api_v1_user.id, followed_id: params[:user_id])
        follow.destroy!
        head :no_content
      end
    end
  end
end
