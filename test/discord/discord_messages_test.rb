# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.allow_net_connect!
  end

  test '#post' do
    answer = answers(:one)
    question = questions(:susi)
    message_url = "#{Discordrb::API.api_base}/channels/#{ENV['DISCORD_CHANNEL_ID']}/messages"

    stub_first = stub_request(:post, message_url)
                 .with(body: hash_including({ content: 'こんにちは！今日もみんなに教えてもらったことを紹介するよ〜。' }))
    stub_answer = stub_request(:post, message_url)
                  .with(body: hash_including(answer_hash(answer)))
    stub_end = stub_request(:post, message_url)
               .with(body: hash_including(end_hash(question)))
    stub_no_answer = stub_request(:post, message_url)
                     .with(body: hash_including(no_answer_hash(question)))

    DiscordMessage.new(message_count: 1, host: 'example.com', comment: '確かに〜。')
                  .post(answers: [answer])

    assert_requested(stub_first)
    assert_requested(stub_answer)
    assert_requested(stub_end)

    DiscordMessage.new(message_count: 3, host: 'example.com', comment: '確かに〜。', question: question)
                  .post(answers: nil)
    assert_requested(stub_no_answer)
  end

  private

  def answer_hash(answer)
    {
      content: "<@#{answer.user.uid}>さんに聞きました！",
      embed: {
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
    }
  end

  def daily_embed_hash(question)
    {
      title: question.body,
      description: "質問に回答するには[ここ](http://example.com/?question=#{question.id})にアクセスしてね。過去に投稿されたみんなの回答も見れるよ！",
      color: 4_216_419
    }
  end

  def end_hash(question)
    {
      content: "確かに〜。\n今日はみんなにこんなことも聞いてみたいな。",
      embed: daily_embed_hash(question)
    }
  end

  def no_answer_hash(question)
    {
      content: "こんにちは！こちらは毎日サーバーのメンバーのことを紹介するBotです！\nみんなのお話是非聞かせてください。\n今日はこんな質問はどうかな？",
      embed: daily_embed_hash(question)
    }
  end
end
