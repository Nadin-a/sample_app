require 'test_helper'
class UserPathTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:michael)
  end

  test "no_signup_for_logged_user" do
    log_in_as(@user)
    assert is_logged_in?
    get signup_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select 'btn btn-lg btn-primary', count: 0
  end
  #
  # test "no_non_activated_user_pages" do
  #   log_in_as(@user)
  #   assert is_logged_in?
  #   get @non_activated_user
  #  # assert_template 'static_pages/home', count: 0
  # end

end