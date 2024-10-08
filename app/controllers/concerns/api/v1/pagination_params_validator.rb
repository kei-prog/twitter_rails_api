# frozen_string_literal: true

module Api
  module V1
    module PaginationParamsValidator
      extend ActiveSupport::Concern

      DEFAULT_LIMIT = 20
      DEFAULT_OFFSET = 0
      MAX_LIMIT = 20

      private

      def validate_query_params
        limit = params[:limit] || DEFAULT_LIMIT.to_s
        offset = params[:offset] || DEFAULT_OFFSET.to_s

        render_invalid_params and return unless valid_integer_params?(limit, offset)

        @limit = limit.to_i
        @offset = offset.to_i

        render_invalid_params unless @limit.between?(0, MAX_LIMIT)
      end

      def valid_integer_params?(limit, offset)
        limit =~ /\A\d+\z/ && offset =~ /\A\d+\z/ # 正の整数
      end

      def render_invalid_params
        render json: { errors: [I18n.t('query_parameters.invalid_query_parameters')] }, status: :bad_request
      end
    end
  end
end
