require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get help" do
    get help_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get contact" do
    get contact_url
    assert_response :success
  end

  test "Test for the partial of navbar" do
    get root_url
    assert_template partial: '_navbar'
  end

  test "Test for the partial of footer" do
    get root_url
    assert_template partial: '_footer'
  end
end
