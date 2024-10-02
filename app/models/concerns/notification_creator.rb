# frozen_string_literal: true

module NotificationCreator
  extend ActiveSupport::Concern

  included do
    def create_notification(current_user)
      type = self.class.name.downcase.to_sym
      if %w[follow favorite].include? type
        existing_notification = notifications.find_by(notification_type: type, send_user: current_user,
                                                      user: recipient_user)
        return if existing_notification
      end
      notifications.create!(notification_type: type, send_user: current_user, user: recipient_user)
    end
  end
end
