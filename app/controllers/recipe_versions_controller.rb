class RecipeVersionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe

  def new
    latest_version = @recipe.latest_version

    @recipe_version = @recipe.recipe_versions.build(
      version_number: next_version_number,
      ingredients: latest_version&.ingredients,
      steps: latest_version&.steps
    )
  end

  def create
    @recipe_version = @recipe.recipe_versions.build(recipe_version_params)
    @recipe_version.version_number = next_version_number

    if @recipe_version.save
      redirect_to recipe_path(@recipe), notice: "改良履歴を保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_recipe
    @recipe = current_user.recipes.find(params[:recipe_id])
  end

  def recipe_version_params
    params.require(:recipe_version).permit(:version_name, :ingredients, :steps, :memo).merge(
      version_number: next_version_number
    )
  end

  def next_version_number
    @recipe.recipe_versions.maximum(:version_number).to_i + 1
  end
end
