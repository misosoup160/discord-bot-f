# frozen_string_literal: true

class DiscordMessage
  attr_reader :message_count, :host, :comment, :question

  def initialize(
    message_count: ENV['SEND_MESSAGE_COUNT'].to_i,
    host: ENV['URL_HOST'],
    comment: nil,
    question: nil
  )
    @message_count = message_count
    @host = host
    comments = [
      '確かに〜。',
      'なるほど〜。',
      'わかります！'
    ]
    @comment = comment || comments.sample
    @question = question || Question.find(Question.pluck(:id).sample)
  end

  def post(answers: nil)
    answers ||= pickup_answers
    if answers
      post_message(first_message)
      answers.each do |answer|
        post_message(answers_message(answer))
        answer.update!(posted: true, posted_at: Time.current)
      end
      post_message(end_message)
    else
      post_message(no_answer_message)
    end
  end

  private

  def pickup_answers
    if Answer.where(posted: false).count >= message_count
      Answer.find(Answer.where(posted: false).pluck(:id).sample(message_count))
    else
      repost_answer = Answer.find_by(id: Answer.where(posted: true).where('posted_at < ?', 3.months.ago).pluck(:id).sample)
      repost_answer ? [repost_answer] : nil
    end
  end

  def post_message(message)
    Discordrb::API::Channel.create_message(
      "Bot #{ENV['DISCORD_BOT_TOKEN']}",
      ENV['DISCORD_CHANNEL_ID'],
      message[:content],
      false,
      message[:embed]
    )
  end

  def create_embed(answer)
    {
      title: answer.question.body,
      description: answer.body,
      color: 16_083_556,
      timestamp: answer.created_at,
      author: {
        name: answer.user.name,
        icon_url: answer.user.avatar
      },
      thumbnail: {
        url: answer.user.avatar
      }
    }
  end

  def answers_message(answer)
    {
      content: "<@#{answer.user.uid}>さんに聞きました！",
      embed: create_embed(answer)
    }
  end

  def first_message
    {
      content: 'こんにちは！今日もみんなに教えてもらったことを紹介するよ〜。',
      embed: nil
    }
  end

  def end_message
    {
      content: "#{comment}\n今日はみんなにこんなことも聞いてみたいな。",
      embed: daily_embed
    }
  end

  def no_answer_message
    {
      content: "こんにちは！こちらは毎日サーバーのメンバーのことを紹介するBotです！\nみんなのお話是非聞かせてください。\n今日はこんな質問はどうかな？",
      embed: daily_embed
    }
  end

  def daily_embed
    routes = Rails.application.routes.url_helpers
    url = routes.url_for(host: host, controller: :answers, action: :new, question: question.id, only_path: false)
    {
      title: question.body,
      description: "質問に回答するには[ここ](#{url})にアクセスしてね。過去に投稿されたみんなの回答も見れるよ！",
      color: 4_216_419
    }
  end
end
