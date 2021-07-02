# frozen_string_literal: true

require 'application_system_test_case'

class AnswersTest < ApplicationSystemTestCase
  test 'visiting the answers index' do
    login_user users(:alice)
    click_link 'みんなの回答'
    assert_selector 'h1', text: 'みんなの回答一覧'
    assert_text '焼肉定食です。'
    assert_text 'オムライスです。'
    assert_no_text 'アジです。'
  end

  test 'visiting the users answers index' do
    login_user users(:bob)
    click_link '自分の回答'
    assert_selector 'h1', text: '自分の回答一覧'
    assert_no_text '焼肉定食です。'
    assert_text 'オムライスです。'
    assert_text 'アジです。'
  end

  test 'redrect to visited page' do
    user = users(:bob)
    visit '/answers'
    OmniAuth.config.mock_auth[:discord] = nil
    Rails.application.env_config['omniauth.auth'] = discord_mock(user.name, user.uid)
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{user.uid}")
    click_link 'ログイン'
    assert_text 'ログインしました。'
    assert_selector 'h1', text: 'みんなの回答一覧'
  end

  test 'posted answer is not edit' do
    login_user users(:bob)
    click_link '自分の回答'
    click_link '好きな食べ物はなんですか？'
    assert_no_text '編集'
    assert_no_text '削除'
  end

  test 'creating a Answer' do
    login_user users(:alice)
    click_link '質問に答える'
    fill_in 'answer[body]', with: 'とても面白かったのでおすすめです！'
    click_on '登録する'
    assert_text '回答を登録しました。'
    assert_text 'とても面白かったのでおすすめです！'
  end

  test 'updating a Answer' do
    login_user users(:bob)
    click_link '自分の回答'
    click_link '好きな寿司ネタはなんですか？'
    click_link '編集'
    fill_in 'answer[body]', with: 'シマアジです。'
    click_on '内容変更'

    assert_text '回答の内容を更新しました。'
    assert_text 'シマアジです。'
  end

  test 'destroying a Answer' do
    login_user users(:bob)
    click_link '自分の回答'
    click_link '好きな寿司ネタはなんですか？'
    click_link '削除する'
    accept_confirm
    assert_text '回答を削除しました。'
    assert_no_text 'アジです。'
  end
end
