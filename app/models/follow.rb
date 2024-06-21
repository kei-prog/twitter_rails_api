# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower
  belongs_to :followed
end
