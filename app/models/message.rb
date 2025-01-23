# frozen_string_literal: true

class Message < ApplicationRecord
  include BodyValidation
  include Sortable
  belongs_to :group
  belongs_to :sender, class_name: 'User'

  validates :content, presence: true
  validate_body_byte_size :content, max_size: 500

  scope :for_group, lambda { |group_id, offset, limit|
    where(group_id:).recent_in_asc_order(offset, limit)
  }

  scope :latest_from_other_user, lambda { |group_id, current_user_id|
    where(group_id:)
      .where.not(sender_id: current_user_id)
      .order(created_at: :desc)
      .limit(1)
  }
end
