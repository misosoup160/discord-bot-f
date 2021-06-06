# frozen_string_literal: true

class DiscordMessage
  MESSAGE_COUNTS = 3

  def send
    if Answer.count >= MESSAGE_COUNTS
      answers = Answer.find(Answer.pluck(:id).sample(MESSAGE_COUNTS))
      messages = []
      messages << first_message
      answers.each do |answer|
        messages.push(set_answers_message(answer))
      end
      messages << end_message
    else
      messages = [ no_answer_message ]
    end

    messages.each do |message|
      create_message(message[:content], message[:embet])
    end
  end

  private

  def create_message(content, embed)
    Discordrb::API::Channel.create_message('Bot ' + ENV['DISCORD_BOT_TOKEN'], ENV['DISCORD_CHANNEL_ID'], message = content, tts = false, embed = embed, nonce = nil, attachments = nil, allowed_mentions = nil, message_reference = nil)
  end

  def create_embet(answer)
    {
      title: answer.question.body,
      description: answer.body,
      color: 0xfa8072,
      timestamp: answer.created_at,
      author: {
        name: answer.user.name,
        icon_url: answer.user.image_url
      },
      thumbnail: {
        url: answer.user.image_url
      }
    }
  end

  def set_answers_message(answer)
    {
      content: "<@#{answer.user.uid}>さんに聞きました！",
      embet: create_embet(answer)
    }
  end

  def first_message
    {
      content: 'こんにちは！今日もみんなに教えてもらったことを紹介するよ！',
      embet: nil
    }
  end

  def end_message
    comment = [
      '確かに〜。',
      'なるほど〜。',
      'わかります！'
    ]
    {
      content: comment.sample + "\n今日はみんなにこんなことも聞いてみたいな。",
      embet: daily_embet
    }
  end

  def no_answer_message
    {
      content: "こんにちは！こちらは毎日サーバーのメンバーのことを紹介するBotです！\nみんなのお話是非聞かせてください。\n今日はこんな質問はどうかな？",
      embet: daily_embet
    }
  end

  def daily_embet
    question = Question.find(Question.pluck(:id).sample)
    {
      title: question.body,
      description: '質問に回答するには[ここ](http://example.com)にアクセスしてね。過去に投稿されたみんなの回答も見れるよ！'
    }
  end
end
