require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:zain)
  end


  test "Invalid Log In" do
    get log_in_path
    assert_select "h1", "Log In"
    assert_template "sessions/new"

    post log_in_path, params: { session: { email: "user@example.com", password: "foobar" } }
    assert_response :unprocessable_entity
  end

  test "Valid Log In" do
    post log_in_path, params: { session: { email: @user.email, password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", log_in_path, count: 0
    assert_select "a[href=?]", log_out_path
    assert_select "a[href=?]", user_path(@user)
    delete log_out_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", log_in_path

  end
end
