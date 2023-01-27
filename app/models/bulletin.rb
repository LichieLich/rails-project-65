# frozen_string_literal: true

class Bulletin < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_one_attached :image
  validates :image, attached: true,
                    content_type: %i[png jpg jpeg],
                    size: { less_than: 5.megabytes }

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
