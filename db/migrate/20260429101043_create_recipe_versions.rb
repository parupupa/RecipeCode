class CreateRecipeVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_versions do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :version_name
      t.integer :version_number
      t.text :ingredients
      t.text :steps
      t.text :memo

      t.timestamps
    end
  end
end
