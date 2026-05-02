class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_versions, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }

  def latest_version
    recipe_versions.order(version_number: :desc).first
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["recipe_versions", "user"]
  end
end
