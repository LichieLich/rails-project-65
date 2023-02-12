# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :category

  has_one_attached :image, dependent: :destroy
  validates :image, attached: true,
                    content_type: %i[png jpg jpeg],
                    size: { less_than: 5.megabytes }

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }

  aasm whiny_transitions: false do
    state :draft, initial: true, display: 'Черновик'
    state :under_moderation, display: 'На модерации'
    state :published, display: 'Опубликовано'
    state :rejected, display: 'Отклонено'
    state :archived, display: 'В архиве'

    event :moderate do
      transitions from: %i[draft rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end

    event :draft do
      transitions from: %i[under_moderation published rejected], to: :draft
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    super & %w(title aasm_state)
  end

  def self.ransackable_associations(auth_object = nil)
    super & %w(category)
  end
end
