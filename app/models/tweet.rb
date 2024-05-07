# frozen_string_literal: true

class Tweet < ApplicationRecord
  include Twitter::TwitterText::Validation
  belongs_to :user
  has_many_attached :images

  validate :image_type, :image_size, :image_count, :body_byte_size

  private

  def image_type
    images.each do |image|
      errors.add(:images, 'はjpeg、またはpng形式にしてください。') unless image.content_type.in?(%w[image/jpeg image/png])
    end
  end

  def image_size
    images.each do |image|
      errors.add(:images, 'は5MB以下にしてください。') if image.byte_size > 5.megabytes
    end
  end

  def image_count
    return unless images.attached?
    return unless images.length > 4

    errors.add(:images, 'は4枚まで投稿できます。')
  end

  def body_byte_size
    parsed_tweet = Twitter::TwitterText::Validation.parse_tweet(body)
    return unless parsed_tweet[:weighted_length] > 280

    errors.add(:body, 'は280文字以内で入力してください。')
  end
end
