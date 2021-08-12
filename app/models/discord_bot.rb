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
      updated_member = JSON.parse(Discordrb::API::User.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", uid))

      name = updated_member['username']
      discriminator = updated_member['discriminator']
      avatar = avatar_url(uid, updated_member['avatar'], discriminator)

      user = User.find_by(uid: uid)
      if user
        user.update!(name: name) if user.name != name
        user.update!(avatar: avatar) if user.avatar != avatar
        user.update!(discriminator: discriminator) if user.discriminator != discriminator
      end
    end
  end

  private

  def avatar_url(uid, avatar_id, discriminator)
    if avatar_id
      Discordrb::API::User.avatar_url(uid, avatar_id)
    else
      Discordrb::API::User.default_avatar(discriminator)
    end
  end
end
