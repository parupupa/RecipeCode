class RecipeVersion < ApplicationRecord
  belongs_to :recipe

  validates :version_name, presence: true, length: { maximum: 100 }
  validates :version_number, presence: true
end
