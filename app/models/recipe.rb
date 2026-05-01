class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_versions, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }

  def latest_version
    recipe_versions.order(version_number: :desc).first
  end
end
