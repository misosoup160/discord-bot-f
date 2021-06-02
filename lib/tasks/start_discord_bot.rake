# frozen_string_literal: true

desc 'start discord bot'
task discord_bot_start: :environment do
  bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
  bot.run
end
