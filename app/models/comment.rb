# frozen_string_literal: true

class Comment < ApplicationRecord
  include BodyValidation
  belongs_to :tweet
  belongs_to :user

  validate_body_byte_size :body

  scope :recent, ->(offset, limit) { order(created_at: :desc).offset(offset).limit(limit) }
end
