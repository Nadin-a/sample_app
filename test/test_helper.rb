# frozen_string_literal: true

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'carrierwave/test/matchers'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabeticalorder
  fixtures :all
  include ApplicationHelper
  # Returns true if a test user is logged in.
  def logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end

  class ActionDispatch::IntegrationTest
    def setup
      @user = users(:michael)
    end

    # Log in as a particular user.
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params:
      {
        session:
        {
          email: user.email,
          password: password,
          remember_me: remember_me
        }
      }
    end

    def valid_email
      # Valid email
      post password_resets_path,
           params: { password_reset: { email: @user.email } }
      assert_not_equal @user.reset_digest, @user.reload.reset_digest
      assert_equal 1, ActionMailer::Base.deliveries.size
      assert_not flash.empty?
      assert_redirected_to root_url
    end
  end
  # Add more helper methods to be used by all tests here...
end

# # frozen_string_literal: true
#
# require File.expand_path('../../config/environment', __FILE__)
# require 'rails/test_help'
# require 'minitest/reporters'
# require 'carrierwave/test/matchers'
#
# Minitest::Reporters.use!
# module ActiveSupport
#   class TestCase
#     fixtures :all
#     include ApplicationHelper
#     # Returns true if a test user is logged in.
#     def logged_in?
#       !session[:user_id].nil?
#     end
#
#     # Log in as a particular user.
#     def log_in_as(user)
#       session[:user_id] = user.id
#     end
#
#     module ActionDispatch
#       class IntegrationTest
#         # Log in as a particular user.
#         def log_in_as(user, password: 'password', remember_me: '1')
#           post login_path, params: {
#           session: {
#           email: user.email,
#           password: password,
#           remember_me: remember_me
#           }
#           }
#         end
#       end
#     end
#     # Add more helper methods to be used by all tests here...
#   end
# end
