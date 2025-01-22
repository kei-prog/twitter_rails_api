# frozen_string_literal: true

class Group < ApplicationRecord
  include Sortable
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :messages, dependent: :destroy

  validate :unique_sender_and_recipient

  scope :for_user, lambda { |user_id, offset, limit|
    where(sender_id: user_id).or(where(recipient_id: user_id)).recent(offset, limit)
  }

  def as_user_display_json(current_user_id)
    latest_message = Message.latest_from_other_user(id, current_user_id).first

    user_key = current_user_id == sender_id ? :recipient : :sender

    as_json.merge(
      sender: send(user_key).as_json(only: %i[id name], methods: :avatar_url),
      latest_message: latest_message&.slice(:id, :content)
    )
  end

  private

  def unique_sender_and_recipient
    return unless sender_id == recipient_id

    errors.add(:base, I18n.t('activerecord.errors.models.group.same_user'))
  end
end
