require "test_helper"

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #
  test "Get Edit Page" do
    get edit_account_activation_path("alkff kjaakj ")
    assert_response :success
  end
end
