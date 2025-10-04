require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end
class UserSignUp < UsersSignupTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template "users/new"
  end

  test "css result of invalid signup" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "user",
                                        email: "user@example.com",
                                        password: "",
                                        password_confirmation: "" } }
    end
    assert_response :unprocessable_entity
    assert_select "div#error_explanation"
  end

  test "User create check" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "user",
                                        email: "uniqueuser@example.com",
                                        password: "foobar",
                                        password_confirmation: "foobar" } }
    end
    follow_redirect!
  end
end

class AccountActivationTest < UsersSignupTest
  def setup
    super
    post users_path, params: { user: { name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }

    @user = assigns(:user)
  end

  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before activated" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should be log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
