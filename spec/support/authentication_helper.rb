# frozen_string_literal: true

module AuthenticationHelper
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

  def login_as(user)
    OmniAuth.config.mock_auth[:discord] = nil
    Rails.application.env_config['omniauth.auth'] = discord_mock(user.name, user.uid)
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}")
      .to_return(body: { "owner_id": '123456' }.to_json, status: 200)
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{user.uid}")

    get '/auth/discord/callback'
    follow_redirect!
  end
end
