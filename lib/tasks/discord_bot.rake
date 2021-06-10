# frozen_string_literal: true

namespace :discord_bot do
  desc 'start discord bot'
  task start: :environment do
    bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
    DiscordRemoveMember.new(bot).run
    bot.run
  end

  desc 'send message to discord guild'
  task send_messages: :environment do
    DiscordMessage.new.send
  end
end
