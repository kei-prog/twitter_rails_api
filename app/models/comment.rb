# frozen_string_literal: true

class Comment < ApplicationRecord
  include NotificationCreator
  include BodyValidation

  has_many :notifications, as: :target, dependent: :destroy
  belongs_to :tweet
  belongs_to :user

  validate_body_byte_size :body

  scope :recent, ->(offset, limit) { order(created_at: :desc).offset(offset).limit(limit) }

  def recipient_user
    tweet.user
  end
end
