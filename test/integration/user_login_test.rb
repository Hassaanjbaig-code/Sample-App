require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:zain)
  end
end


class InvalidPasswordTest < UserLoginTest
  test "login path" do
    get log_in_path
    assert_template "sessions/new"
  end
  test "login with the valid email/ invalid password" do
    post log_in_path, params: { session: { email: @user.email, password: "foobar" } }
    assert_response :unprocessable_entity
    assert_select "div.alert-danger"
  end
end

class ValidLogin < UserLoginTest
  def setup
    super
  post log_in_path, params: { session: { email: @user.email, password: "password" } }
  end
end

class ValidLoginTest < ValidLogin
  test "valid log in" do
    assert is_logged_in?
  end

  test "redirect after login" do
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", log_out_path
    assert_select "a[href=?]", log_in_path, count: 0
  end
end

class Logout < ValidLogin
  def setup
    super
    delete log_out_path
  end
end


class LogoutTest < Logout
  test "successful log out" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", log_in_path
    assert_select "a[href=?]", log_out_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

class RememberingTest < UserLoginTest
  test "log in with remembering" do
    log_in_as(@user, remember_me: "1")
    assert_not cookies[:remember_token].blank?
  assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "log in without remembering" do
    log_in_as(@user, remember_me: "0")
    assert cookies[:remember_token].blank?
  end
end
