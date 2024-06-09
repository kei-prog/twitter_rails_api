# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_api_v1_user!, only: %i[update]

      def update
        if current_api_v1_user.update(profile_params)
          attach_files if params[:header].present? || params[:avatar].present?
          render json: current_api_v1_user, status: :ok
        else
          render json: { errors: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      PROFILE_PARAMS = %i[name introduction location website].freeze

      def profile_params
        params.permit(PROFILE_PARAMS)
      end

      def attach_files
        current_api_v1_user.header.attach(params[:header]) if params[:header].present?
        current_api_v1_user.avatar.attach(params[:avatar]) if params[:avatar].present?
      end
    end
  end
end
