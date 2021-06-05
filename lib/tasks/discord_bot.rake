# frozen_string_literal: true

namespace :discord_bot do
  desc 'start discord bot'
  task start: :environment do
    bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
    bot.run
  end

  desc 'send message to discord guild'  
  task send_messages: :environment do
    message = 'hello!'
    Discordrb::API::Channel.create_message('Bot ' + ENV['DISCORD_BOT_TOKEN'], ENV['DISCORD_CHANNEL_ID'], message, tts = false, embed = nil, nonce = nil, attachments = nil, allowed_mentions = nil, message_reference = nil)
  end
end
