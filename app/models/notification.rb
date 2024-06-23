# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :send_user
  belongs_to :target, polymorphic: true
end
