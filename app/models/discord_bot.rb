# frozen_string_literal: true

class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
  end

  def start
    settings
    @bot.run
  end

  def settings
    # banや脱退などサーバーからメンバーがいなくなったらそのユーザーを消去
    @bot.member_leave do |event|
      user_id = event.user.id
      user = User.find_by(uid: user_id)
      user&.destroy
    end

    # メンバーのusername, discriminator, avatarの更新を反映する
    @bot.member_update do |event|
      uid = event.user.id
      user_info = Discordrb::API::User.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", uid)
      user = JSON.parse(user_info)

      name = user['username']
      discriminator = user['discriminator']
      avatar_id = user['avatar']
      avatar_url = avatar_id ? 
        Discordrb::API::User.avatar_url(uid, avatar_id) :
        Discordrb::API::User.default_avatar(discriminator)

      user = User.find_by(uid: uid)
      user.update!(name: name) if user && user.name != name
      user.update!(avatar: avatar_url) if user && user.avatar != avatar_url
      user.update!(discriminator: discriminator) if user && user.discriminator != discriminator
    end
  end
end
