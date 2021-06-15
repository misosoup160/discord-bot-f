# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  test 'visiting the index' do
    login_user users(:alice)
    visit admin_questions_url
    assert_selector 'h1', text: '質問一覧'
  end

  test 'creating a question' do
    login_user users(:alice)
    visit admin_questions_url
    click_link '新規登録'
    fill_in 'question[body]', with: '好きな漫画はなんですか？' 
    click_on '登録する'
    assert_text '新しい質問を登録しました。'
    assert_text '好きな漫画はなんですか？'
  end

  test 'updating a question' do
    login_user users(:alice)
    visit admin_questions_url
    click_link 'admin-question-edit', match: :first
    fill_in 'question[body]', with: '好きな漫画はなんですか？' 
    click_on '内容変更'
    assert_text '質問の内容を更新しました。'
    assert_text '好きな漫画はなんですか？'
  end

  test 'destroying a question' do
    login_user users(:alice)
    visit admin_questions_url
    click_link 'admin-question-delete', match: :first
    accept_confirm
    assert_text '質問を削除しました。'
    assert_no_text '好きな寿司ネタはなんですか？'
  end
end
