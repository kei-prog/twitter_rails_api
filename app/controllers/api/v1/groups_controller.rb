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
        if group_exists?
          head :ok
          return
        end

        group = current_api_v1_user.sent_groups.build(recipient_id: params[:recipient_id])
        if group.save
          head :created
        else
          render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def group_exists?
        current_api_v1_user.sent_groups.exists?(recipient_id: params[:recipient_id]) ||
          current_api_v1_user.received_groups.exists?(sender_id: params[:recipient_id])
      end
    end
  end
end
