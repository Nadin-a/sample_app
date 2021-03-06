# frozen_string_literal: true

require 'test_helper'
class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    get contact_path
    assert_select 'title', full_title('Contact')
  end

  test 'all_layout_links' do
    get root_path
    assert_template 'static_pages/home'
    log_in_as(@user)
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', logout_path, count: 1
    assert_select 'a[href=?]', edit_user_path
    delete logout_path
    follow_redirect!
    assert_not logged_in?
    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
  end
end
