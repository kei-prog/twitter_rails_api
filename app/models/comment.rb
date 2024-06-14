# frozen_string_literal: true

class Comment < ApplicationRecord
  include BodyValidation
  belongs_to :tweet
  belongs_to :user

  validate_body_byte_size :body
end
