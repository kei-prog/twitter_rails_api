# frozen_string_literal: true

class Tweet < ApplicationRecord
  include BodyValidation
  include Sortable
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :images

  validate :image_type, :image_size, :image_count
  validate_body_byte_size :body

  def as_json(options = {})
    super.merge({ images: images.map do |image|
      Rails.application.routes.url_helpers.rails_blob_url(
        image, host: 'localhost:3000'
      )
    end, bookmarked: options[:current_user] ? bookmarked_by?(options[:current_user]) : false })
  end

  def retweet_count
    retweets.count
  end

  def favorite_count
    favorites.count
  end

  def bookmarked_by?(current_user)
    current_user.bookmarks.exists?(tweet_id: id)
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
