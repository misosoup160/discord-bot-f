# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  OmniAuth.config.test_mode = true

  def discord_mock(name, uid)
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new({
      provider: 'discord',
      uid: uid,
      info: {
        name: name
      },
      extra: {
        raw_info: {
          discriminator: '1234'
        }
      }
    })
  end

  def login_user(user)
    visit welcom_url
    OmniAuth.config.mock_auth[:discord] = nil
    Rails.application.env_config['omniauth.auth'] = discord_mock(user.name, user.uid)
    click_link 'ログイン'
  end
end
