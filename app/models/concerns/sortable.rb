# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent, ->(offset, limit) { order(created_at: :desc).offset(offset).limit(limit) }
    scope :recent_in_asc_order, lambda { |offset, limit|
      order(created_at: :asc).offset(offset).limit(limit).reverse_order
    }
  end
end
