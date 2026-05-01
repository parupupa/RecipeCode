class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = current_user.recipes.includes(:recipe_versions).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new
    @recipe_version = RecipeVersion.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe_version = @recipe.recipe_versions.build(initial_recipe_version_params)

    ActiveRecord::Base.transaction do
      @recipe.save!
      @recipe_version.save!
    end

    redirect_to recipes_path, notice: "レシピを保存しました"
    
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title)
  end

  def initial_recipe_version_params
    params.require(:recipe_version).permit(:ingredients, :steps, :memo).merge(
      version_name: "初回バージョン",
      version_number: 1.0
    )
  end
end
