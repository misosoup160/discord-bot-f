# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '.find_or_create_from_auth_hash' do
    uid = '123456'
    auth_hash = {
      provider: 'discord',
      uid: uid,
      info: {
        name: 'carol'
      },
      extra: {
        raw_info: {
          discriminator: '1234'
        }
      }
    }
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}").to_return(body: { "owner_id": '123456' }.to_json, status: 200)
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{uid}")
    user = User.find_or_create_from_auth_hash!(auth_hash)
    assert_equal '123456', user.uid
    assert_equal 'carol', user.name
    assert_equal '1234', user.discriminator
    assert_equal true, user.owner
    assert_equal true, user.admin
    assert_equal User.find_by(uid: uid), User.find_or_create_from_auth_hash!(auth_hash)
  end

  test '.search' do
    user = users(:alice)
    assert_equal user, User.search('alice#1234').first
    assert_equal 2, User.search('').count
    assert_nil User.search('%').first
  end
end
