require 'test_helper'
# frozen_string_literal: true

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  def setup
    @user = users(:michael)
  end

  test 'profile display' do
    log_in_as(@user)
    get user_path(@user)
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'strong#following', count: 1
    assert_select 'strong#followers', count: 1
  end
end
