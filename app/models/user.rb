# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :avatar
  has_one_attached :header
  has_many :tweets, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy,
                            inverse_of: :follower
  has_many :following, through: :active_follows, source: :followed
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy,
                             inverse_of: :followed
  has_many :followers, through: :passive_follows, source: :follower
  has_many :notifications, dependent: :destroy
  has_many :send_user, class_name: 'Notification', foreign_key: 'send_user_id', dependent: :destroy,
                       inverse_of: :send_user

  has_many :sent_groups, class_name: 'Group', foreign_key: 'sender_id', dependent: :destroy, inverse_of: :sender
  has_many :received_groups, class_name: 'Group', foreign_key: 'recipient_id', dependent: :destroy,
                             inverse_of: :recipient
  has_many :messages, foreign_key: 'sender_id', dependent: :destroy, inverse_of: :sender

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :introduction, length: { maximum: 160 }, allow_blank: true
  validates :location, length: { maximum: 30 }, allow_blank: true
  validates :website, length: { maximum: 100 }, allow_blank: true
  validates :birthday, presence: true

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(avatar, host: 'localhost:3000') if avatar.attached?
  end

  def header_url
    Rails.application.routes.url_helpers.rails_blob_url(header, host: 'localhost:3000') if header.attached?
  end

  def following?(user)
    following.include?(user)
  end
end
