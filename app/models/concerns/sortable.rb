# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent, ->(offset, limit) { order(created_at: :desc).offset(offset).limit(limit) }
  end
end
