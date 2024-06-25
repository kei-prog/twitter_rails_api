# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < ApplicationController
      include PaginationParamsValidator

      before_action :authenticate_api_v1_user!, only: %i[index]
      before_action :validate_query_params, only: %i[index]

      def index
        notifications = current_api_v1_user.notifications.recent(@offset, @limit)
        render json: notifications, status: :ok
      end
    end
  end
end
