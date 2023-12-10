# frozen_string_literal: true

module Api
  module V1
    module Users
      class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
        protected

        def redirect_options
          { allow_other_host: true }
        end

        private

        def resource_params
          params.permit(:email, :confirmation_token, :config_name, :redirect_url)
        end
      end
    end
  end
end
