# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :sender
  belongs_to :recipient
end
