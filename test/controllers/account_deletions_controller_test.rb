require "test_helper"

class AccountDeletionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get account_deletions_show_url
    assert_response :success
  end
end
