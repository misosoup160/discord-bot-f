# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordMessage, type: :model do
  let(:alice) { create(:alice) }
  let(:question_food) { create(:question, body: '好きな食べ物はなんですか？') }
  let(:question_sushi) { create(:question, body: '好きな寿司ネタはなんですか？') }
  let(:answer) { create(:answer, :posted, user: alice, question: question_sushi, body: '焼肉定食です。') }

  before do
    WebMock.disable_net_connect!
  end

  after do
    WebMock.allow_net_connect!
  end

  describe '#post' do
    let(:message_url) { "#{Discordrb::API.api_base}/channels/#{ENV['DISCORD_CHANNEL_ID']}/messages" }

    context '回答がある場合' do
      it 'Discord APIに正しいメッセージを投稿する' do
        stub_first = stub_request(:post, message_url)
                     .with { |req| JSON.parse(req.body)['content'] == 'こんにちは！今日もみんなに教えてもらったことを紹介するよ〜。' }
        stub_answer = stub_request(:post, message_url)
                      .with do |req|
                        body = JSON.parse(req.body)
                        body['content'] == "<@#{answer.user.uid}>さんに聞きました！" &&
                          body['embeds']&.first&.dig('title') == answer.question.body
        end
        stub_end = stub_request(:post, message_url)
                   .with do |req|
                     body = JSON.parse(req.body)
                     body['content'] == "確かに〜。\n今日はみんなにこんなことも聞いてみたいな。"
        end

        DiscordMessage.new(message_count: 1, host: 'example.com', comment: '確かに〜。', question: question_sushi)
                      .post(answers: [answer])

        expect(stub_first).to have_been_requested
        expect(stub_answer).to have_been_requested
        expect(stub_end).to have_been_requested
      end
    end

    context '回答がない場合' do
      it 'Discord APIに質問のみのメッセージを投稿する' do
        stub_no_answer = stub_request(:post, message_url)
                         .with do |req|
                           body = JSON.parse(req.body)
                           body['content'].include?('こんにちは！こちらは毎日サーバーのメンバーのことを紹介するBotです！')
        end

        DiscordMessage.new(message_count: 3, host: 'example.com', comment: '確かに〜。', question: question_food)
                      .post(answers: nil)

        expect(stub_no_answer).to have_been_requested
      end
    end
  end

  private

  def answer_hash(answer)
    {
      content: "<@#{answer.user.uid}>さんに聞きました！",
      embeds: [{
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
      }]
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
      embeds: [daily_embed_hash(question)]
    }
  end

  def no_answer_hash(question)
    {
      content: "こんにちは！こちらは毎日サーバーのメンバーのことを紹介するBotです！\nみんなのお話是非聞かせてください。\n今日はこんな質問はどうかな？",
      embeds: [daily_embed_hash(question)]
    }
  end
end
