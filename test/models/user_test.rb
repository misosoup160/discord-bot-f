# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#avatar_url' do
    user = users(:alice)
    assert_equal "#{ENV['IMAGE_URL_HOST']}/images/default_avatar.png", user.avatar_url
  end

  test '.search' do
    user = users(:alice)
    assert_equal user, User.search('alice#1234').first
    assert_equal 2, User.search('').count
    assert_equal nil, User.search('%').first
  end
end
