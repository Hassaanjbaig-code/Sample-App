require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end


  test "invalid signup information" do
    get sign_up_path
      assert_no_difference "User.count" do
        post users_path, params: { user: { name: "",
        email: "user@invalid",
        password:
        "foo",
        password_confirmation:
        "bar" } }
      end
    assert_response :unprocessable_entity
    assert_template "users/new"
  end


  test "css result of invalid signup" do
    get sign_up_path
  assert_no_difference "User.count" do
    post users_path, params: { user: { name: "user",
        email: "user@example.com",
        password:
        "",
        password_confirmation:
        "" } }
    end
    assert_response :unprocessable_entity
    assert_select "div#error_explanation"
  end

  test "User create check " do
    get sign_up_path
  assert_difference "User.count", 1 do
    post users_path, params: { user: { name: "user",
        email: "user@example.com",
        password:
        "foobar",
        password_confirmation:
        "foobar" } }
    end
    follow_redirect!
    assert_template "users/show"
  end
end
