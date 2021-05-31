desc 'start discord bot'
task :discord_bot_start do
  bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
  bot.run
end
