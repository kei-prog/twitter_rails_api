# frozen_string_literal: true

class Favorite < ApplicationRecord
  include NotificationCreator

  has_many :notifications, as: :target, dependent: :destroy
  belongs_to :user
  belongs_to :tweet

  def recipient_user
    tweet.user
  end
end
