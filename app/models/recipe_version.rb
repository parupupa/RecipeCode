class RecipeVersion < ApplicationRecord
  belongs_to :recipe
  has_many_attached :images

  validates :version_name, presence: true, length: { maximum: 100 }
  validates :version_number, presence: true
end
