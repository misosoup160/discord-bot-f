# frozen_string_literal: true

namespace :discord_bot do
  desc 'start discord bot'
  task start: :environment do
    DiscordBot.new.start
  end

  desc 'send message to discord guild'
  task send_messages: :environment do
    DiscordMessage.new.post if Question.exists?
  end
end
