# frozen_string_literal: true

class User < ApplicationRecord
  include ActionView::Helpers::AssetUrlHelper

  has_many :answers, dependent: :destroy

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    image_url = auth_hash[:info][:image]
    discriminator = auth_hash[:extra][:raw_info][:discriminator]
    guild_info = Discordrb::API::Server.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_SERVER_ID'])
    owner_id = JSON.parse(guild_info)['owner_id']

    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = name
      user.image_url = image_url
      user.discriminator = discriminator
      user.admin = true if owner_id == uid
    end
  end

  def avatar_url
    avatar? ? avatar : image_url('/images/default_avatar.png', host: 'http://127.0.0.1:3000')
  end
end
