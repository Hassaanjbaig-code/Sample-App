require "test_helper"

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:zain)
  end
  # test "the truth" do
  #   assert true
  # end
end
class UnValid < UserEditTest
  test "unsuccessful Edit" do
log_in_as(@user)
   get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "",
    email:
    "foo@invalid",
    password:
    "foo",
    password_confirmation: "bar" } }
    assert_template "users/edit"
  assert_select "div.alert"
  end
end


class ValidUserEdit < UserEditTest
  test "Valid User" do
    log_in_as(@user)
   get edit_user_path(@user)
    assert_template "users/edit"
    name = "Zain Star"
    email = "zainS@example.com"
    patch user_path(@user), params: { user: { name: name,
    email: email,
    password:
    "",
    password_confirmation: "" } }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
  end
end
