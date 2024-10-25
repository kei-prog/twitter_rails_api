# frozen_string_literal: true

module BodyValidation
  extend ActiveSupport::Concern

  class_methods do
    def validate_body_byte_size(attribute, max_size: 280)
      validate do
        body = send(attribute)
        next if body.blank?

        parsed_body = Twitter::TwitterText::Validation.parse_tweet(body)
        errors.add(attribute, :too_large) if parsed_body[:weighted_length] > max_size
      end
    end
  end
end
