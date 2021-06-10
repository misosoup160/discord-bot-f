# frozen_string_literal: true

class DiscordRemoveMember
  def initialize(bot)
    @bot = bot
  end

  def run
    # banや脱退などサーバーからメンバーがいなくなったらそのユーザーを消去
    @bot.member_leave do |event|
      user_id = event.user.id
      user = User.find_by(uid: user_id)
      user&.destroy
    end
  end
end
