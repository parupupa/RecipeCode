class RecipeVersionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: [:index, :new, :create]
  before_action :set_recipe_version, only: [:show, :edit, :update, :new_from, :destroy]

  def index
    @recipe_versions = @recipe.recipe_versions.order(version_number: :desc)
  end

  def show
    @recipe = @recipe_version.recipe
  end

  def new
    latest_version = @recipe.latest_version

    @recipe_version = @recipe.recipe_versions.build(
      version_number: next_version_number,
      ingredients: latest_version&.ingredients,
      steps: latest_version&.steps
    )
  end

  def new_from
    @recipe = @recipe_version.recipe
    source_recipe_version = @recipe_version

    @recipe_version = @recipe.recipe_versions.build(
      version_number: next_version_number,
      ingredients: source_recipe_version.ingredients,
      steps: source_recipe_version.steps
    )
  end

  def create
    @recipe_version = @recipe.recipe_versions.build(recipe_version_params)
    @recipe_version.version_number = next_version_number

    if @recipe_version.save
      redirect_to recipe_recipe_versions_path(@recipe), notice: "改良履歴を保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe = @recipe_version.recipe
  end

  def update
    @recipe = @recipe_version.recipe

    if @recipe_version.update(recipe_version_params_without_images)
      attach_images_if_present
      purge_selected_images
      redirect_to recipe_version_path(@recipe_version), notice: "改良履歴を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = @recipe_version.recipe

    if recipe.recipe_versions.count <= 1
      redirect_to recipe_recipe_versions_path(recipe), alert: "最後のバージョンは削除できません\n削除する場合はレシピを削除してください"
      return
     end
    @recipe_version.destroy
    redirect_to recipe_recipe_versions_path(recipe), notice: "改良履歴を削除しました"
  end

  private

  def set_recipe
    @recipe = current_user.recipes.find(params[:recipe_id])
  end

  def set_recipe_version
    @recipe_version = RecipeVersion.joins(:recipe)
                                   .where(recipes: { user_id: current_user.id })
                                   .find(params[:id])
  end

  def recipe_version_params
    params.require(:recipe_version).permit(
      :version_name,
      :ingredients,
      :steps,
      :memo,
      images: []
    )
  end

  def next_version_number
    @recipe.recipe_versions.maximum(:version_number).to_i + 1
  end

  def recipe_version_params_without_images
  params.require(:recipe_version).permit(
    :version_name,
    :ingredients,
    :steps,
    :memo
  )
  end

  def attach_images_if_present
    return if params[:recipe_version][:images].blank?

    images = params[:recipe_version][:images].reject(&:blank?)
    @recipe_version.images.attach(images) if images.present?
  end

  def purge_selected_images
    return if params[:recipe_version][:remove_image_ids].blank?

    params[:recipe_version][:remove_image_ids].each do |image_id|
      image = @recipe_version.images.find_by(id: image_id)
      image&.purge
    end
  end

end
