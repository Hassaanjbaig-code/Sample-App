require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:zain)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should be redirect edit when not log in" do
    get edit_user_path(@user)
  assert_not flash.empty?
    assert_redirected_to log_in_path
  end

  test "should redirect update when not log in" do
    patch user_path(@user), params: { session: { name: "zainS", email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to log_in_path
  end
end


class Invaliduser < UsersControllerTest
  def setup
    super
    @second = users(:ayesha)
  end

  test "should redirect edit when differnt user update" do
    log_in_as(@second)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect to update when logged in wrong user" do
    log_in_as(@user)
    patch user_path(@second), params: { users: { name: "Ayesha Ahmad", email: @second.email } }
  assert flash.empty?
    assert_redirected_to root_path
  end
end

class SuccessfullForwarded < UsersControllerTest
  test "successful edit with friendly forward" do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
    name = "Zain Star"
    email = "zainS@example.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", confirmation_password: "" } }
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
  end
end

class IndexPage <UsersControllerTest
  test "unless the user log in not visit the index page" do
    get users_path
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end
end

class AdminRole < Invaliduser
  def setup
    super
    @third = users(:michael)
  end
  test " should not allow to edit the user as admin " do
    log_in_as(@second)
    assert_not @second.admin
    patch user_path(@user), params: { user: { name: @second.name,
      email: @second.email,
      password: "",
      confirmation_password: "",
    admin: true } }
    assert_not @second.admin?
  end
  test "should redirect to destroy when not log in" do
    assert_no_difference "User.count" do
      delete user_path(@second)
    end
    assert_response :see_other
    assert_redirected_to log_in_path
  end

  test "should be redirect when the user is not log in" do
    log_in_as @third
    assert_no_difference "User.count" do
      delete user_path(@second)
    end
    assert_response :see_other
    assert_redirected_to root_path
  end

  test "admin can delete user" do
    log_in_as @user
    assert_difference "User.count", -1 do
      delete user_path @third.id
      assert_response :see_other
      assert_redirected_to users_path
    end
  end
end
