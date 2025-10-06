require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class ForgetPasswordFormTest < PasswordResetsTest
  test "password test path" do
    get new_password_reset_path
    assert_template "password_resets/new"
    assert_select "input[name=?]", "password_reset[email]"
  end

  test "reset path with the invalid email" do
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template "password_resets/new"
  end
end

class PasswordResetForm < PasswordResetsTest
  def setup
    super
    @user = users(:zain)
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @reset_user = assigns(:user)
  end
end


class PasswordFormTest < PasswordResetForm
  test "reset with valid email" do
    assert_not_equal @user.reset_digest, @reset_user.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "reset with wrong email" do
    get edit_password_reset_path(@reset_user.reset_token, email: "")
    assert_redirected_to root_path
  end

  test "reset with the right email but wrong token" do
    get edit_password_reset_path("worng token", email: @reset_user.email)
    assert_redirected_to root_path
  end

  test "with the right email and password" do
    get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", @reset_user.email
  end
end

class PasswordUpdateTest < PasswordResetForm
  test "update with the invalid password and confirmation password" do
    patch password_reset_path(@reset_user.reset_token), params: { email: @reset_user.email, user: { password: "", confirmation_password: "" } }
    assert_select "div#error_explanation"
  end

  test "update with valid password and confirmation" do
    patch password_reset_path(@reset_user.reset_token), params: { email: @reset_user.email, user: { password: "foobar", confirmation_password: "foobar" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @reset_user
  end
end
