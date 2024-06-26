# frozen_string_literal: true

class Notification < ApplicationRecord
  include Sortable
  belongs_to :user
  belongs_to :send_user, class_name: 'User'
  belongs_to :target, polymorphic: true

  enum :notification_type, { follow: 0, like: 1, comment: 2 }

  validates :notification_type, presence: true, inclusion: { in: Notification.notification_types.keys }

  def as_json(options = {})
    super(options.merge(only: %i[id notification_type target_type],
                        include: { send_user: { only: %i[id name], methods: :avatar_url } },
                        methods: :target_json))
  end

  private

  def target_json
    case target
    when Favorite, Comment
      target.as_json(include: :tweet)
    when Follow
      {}
    end
  end
end
