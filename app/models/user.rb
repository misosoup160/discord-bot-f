# frozen_string_literal: true

class User < ApplicationRecord
  include ActionView::Helpers::AssetUrlHelper

  has_many :answers, dependent: :destroy

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    avatar = auth_hash[:info][:image]
    discriminator = auth_hash[:extra][:raw_info][:discriminator]
    guild_info = Discordrb::API::Server.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_SERVER_ID'])
    owner_id = JSON.parse(guild_info)['owner_id']

    # サーバーメンバーではない場合リクエストに失敗してログインできない
    menber = Discordrb::API::Server.resolve_member("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_SERVER_ID'], uid)
    return unless menber

    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = name
      user.avatar = avatar
      user.discriminator = discriminator
      user.admin = true if owner_id == uid
      user.owner = true if owner_id == uid
    end
  end

  def avatar_url
    avatar || image_url('/images/default_avatar.png', host: ENV['IMAGE_URL_HOST'])
  end

  def self.search(keyword)
    if keyword
      where("concat_ws('#', name, discriminator) like ?", "%#{keyword}%")
    else
      User.all
    end
  end
end
