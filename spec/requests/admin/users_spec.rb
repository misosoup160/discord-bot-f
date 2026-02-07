# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::UsersController', type: :request do
  let!(:alice) { create(:alice) }
  let!(:bob) { create(:bob) }

  describe 'GET /admin/users' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it 'ユーザー一覧を表示する' do
        get admin_users_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザー一覧')
        expect(response.body).to include('alice')
        expect(response.body).to include('bob')
      end
    end

    context 'admin権限でログインしていない場合' do
      before { login_as(bob) }

      it '管理者画面にアクセスできずトップページにリダイレクトする' do
        get admin_users_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH /admin/users/:id' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it 'ユーザーを管理者にする' do
        expect(bob.admin).to be false

        patch admin_user_path(bob), params: {
          user: {
            admin: true
          }
        }

        expect(response).to have_http_status(:found)
        follow_redirect!
        expect(bob.reload.admin).to be true
      end
    end

    context 'admin権限でログインしていない場合' do
      before { login_as(bob) }

      it 'ユーザーの管理者権限を変更できない' do
        expect(bob.admin).to be false

        patch admin_user_path(bob), params: {
          user: {
            admin: true
          }
        }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(bob.reload.admin).to be false
      end
    end
  end
end
