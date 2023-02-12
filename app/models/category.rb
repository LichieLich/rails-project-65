# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :bulletins, dependent: :destroy

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    super & %w(name)
  end
end
