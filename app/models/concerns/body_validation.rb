# frozen_string_literal: true

module BodyValidation
  extend ActiveSupport::Concern

  class_methods do
    def validate_body_byte_size(attribute)
      validate do
        parsed_body = Twitter::TwitterText::Validation.parse_tweet(send(attribute))
        errors.add(attribute, :too_large) if parsed_body[:weighted_length] > 280
      end
    end
  end
end
