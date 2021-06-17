# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  test 'visiting the users index' do
    login_user users(:alice)
    visit admin_users_url
    assert_selector 'h1', text: 'ユーザー一覧'
  end

  test 'updating a user to admin' do
    login_user users(:alice)
    visit admin_users_url
    click_link '管理者にする'
    accept_confirm
    assert_no_text '管理者にする'
  end
end
