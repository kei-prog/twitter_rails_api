# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      include PaginationParamsValidator
      before_action :authenticate_api_v1_user!
      before_action :validate_query_params, only: %i[index]

      def index
        messages = Message.for_group(params[:group_id], @offset, @limit)
        render json: messages.as_json(include: { sender: { only: %i[id] } }), status: :ok
      end

      def create
        message = Message.new(sender_id: current_api_v1_user.id, group_id: params[:group_id],
                              content: params[:content])
        if message.save
          render json: message.as_json(include: { sender: { only: %i[id] } }), status: :created
        else
          head :unprocessable_entity
        end
      end
    end
  end
end
