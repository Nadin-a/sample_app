require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: '',
                                            email: 'foo@invalid',
                                            password: 'foo',
                                            password_confirmation: 'bar'}}
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors.'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  # Write a test to make sure that friendly forwarding only forwards to the given URL
  # the first time. On subsequent login attempts, the forwarding URL should revert to the default
  # (i.e., the profile page). Hint: Add to the test in Listing 10.29 by checking
  # for the right value of session[:forwarding_url].
  end


