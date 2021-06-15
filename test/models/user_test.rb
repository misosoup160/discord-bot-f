# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "#avatar_url" do
    user = users(:alice)
    assert_equal 'http://127.0.0.1:3000/images/default_avatar.png', user.avatar_url
  end

  test "#users_search" do
    user = users(:alice)
    assert_equal user, User.search('alice#1234').first
  end
end
