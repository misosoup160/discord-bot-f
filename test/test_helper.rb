# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  OmniAuth.config.test_mode = true
  WebMock.allow_net_connect!

  def discord_mock(name, uid)
    auth_hash = {
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
    }
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(auth_hash)
  end
end
