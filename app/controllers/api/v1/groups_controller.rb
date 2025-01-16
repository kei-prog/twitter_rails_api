# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      include PaginationParamsValidator

      before_action :authenticate_api_v1_user!
      before_action :validate_query_params, only: %i[index]

      def index
        groups = Group.for_user(current_api_v1_user.id, @offset, @limit)

        groups_json = groups.map do |group|
          group.as_user_display_json(current_api_v1_user.id)
        end

        render json: groups_json, status: :ok
      end

      def create
        if Group.exists?(sender_id: current_api_v1_user.id, recipient_id: params[:recipient_id])
          head :ok
          return
        end

        group = Group.new(sender_id: current_api_v1_user.id, recipient_id: params[:recipient_id])
        if group.save
          head :created
        else
          render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
