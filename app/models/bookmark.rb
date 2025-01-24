# frozen_string_literal: true

class Bookmark < ApplicationRecord
  include Sortable
  belongs_to :user
  belongs_to :tweet
end
