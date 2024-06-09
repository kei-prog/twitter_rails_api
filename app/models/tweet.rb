# frozen_string_literal: true

class Tweet < ApplicationRecord
  include Twitter::TwitterText::Validation
  belongs_to :user
  has_many_attached :images

  validate :image_type, :image_size, :image_count, :body_byte_size

  def as_json(options = {})
    super(options).merge({ images: images.map do |image|
                                     Rails.application.routes.url_helpers.rails_blob_url(
                                       image, host: 'localhost:3000'
                                     )
                                   end })
  end

  scope :recent, ->(offset, limit) { order(created_at: :desc).offset(offset).limit(limit) }

  private

  def image_type
    images.each do |image|
      errors.add(:images, :invalid_type) unless image.content_type.in?(%w[image/jpeg image/png])
    end
  end

  def image_size
    images.each do |image|
      errors.add(:images, :too_large) if image.byte_size > 5.megabytes
    end
  end

  def image_count
    return unless images.attached?
    return unless images.length > 4

    errors.add(:images, :too_many)
  end

  def body_byte_size
    parsed_tweet = Twitter::TwitterText::Validation.parse_tweet(body)
    return unless parsed_tweet[:weighted_length] > 280

    errors.add(:body, :too_large)
  end
end
