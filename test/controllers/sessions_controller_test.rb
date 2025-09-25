require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "Page loaded" do
    get log_in_path
    assert_response :success
  end


  test "Failed to log in" do
    get log_in_path
    assert_template "sessions/new"
    post log_in_path, params: { session: { email: "user@example.com", password: "foobar" } }
    assert_response :unprocessable_entity
    assert_template "sessions/new"
    assert_not flash.nil?
    get root_path
  end
end
