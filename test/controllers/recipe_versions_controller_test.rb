require "test_helper"

class RecipeVersionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get recipe_versions_new_url
    assert_response :success
  end
end
