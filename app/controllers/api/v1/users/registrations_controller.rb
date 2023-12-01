# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        private

        def sign_up_params
          params.permit(:name, :email, :password, :password_confirmation, :birthday, :introduction, :location, :website)
        end
      end
    end
  end
end
