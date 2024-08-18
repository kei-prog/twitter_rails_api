# frozen_string_literal: true

class Follow < ApplicationRecord
  include NotificationCreator

  has_many :notifications, as: :target, dependent: :destroy
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followed_id }

  def recipient_user
    followed
  end
end
