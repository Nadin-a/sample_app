require 'test_helper'
# frozen_string_literal: true

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get login_path
    assert_response :success
  end
end
