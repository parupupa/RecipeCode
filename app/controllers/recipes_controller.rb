class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: [:show, :destroy]

  def index
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
    @latest_recipe_version = @recipe.latest_version
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

    redirect_to recipes_path, notice: "レシピを作成しました"
    
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "レシピを削除しました"
  end

  private

  def set_recipe
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title)
  end

  def initial_recipe_version_params
    params.require(:recipe_version).permit(
      :ingredients,
      :steps,
      :memo,
      images: []
    ).merge(
      version_name: "初回バージョン",
      version_number: 1.0
    )
  end
end
