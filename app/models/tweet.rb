# frozen_string_literal: true

class Tweet < ApplicationRecord
  include BodyValidation
  include Sortable
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :images

  validate :image_type, :image_size, :image_count
  validate_body_byte_size :body

  def as_json(options = {})
    super(options).merge({ images: images.map do |image|
                                     Rails.application.routes.url_helpers.rails_blob_url(
                                       image, host: 'localhost:3000'
                                     )
                                   end })
  end

  def retweet_count
    retweets.count
  end

  def favorite_count
    favorites.count
  end

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
end
