# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::QuestionsController', type: :request do
  let(:alice) { create(:alice) }
  let!(:question_food) { create(:question, body: '好きな食べ物はなんですか？') }
  let!(:question_sushi) { create(:question, body: '好きな寿司ネタはなんですか？') }

  describe 'GET /admin/questions' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it '質問一覧を表示する' do
        get admin_questions_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('質問一覧')
        expect(response.body).to include('好きな食べ物はなんですか？')
        expect(response.body).to include('好きな寿司ネタはなんですか？')
      end
    end

    context 'admin権限でログインしていない場合' do
      let(:bob) { create(:bob) }

      before { login_as(bob) }

      it '管理者画面にアクセスできない' do
        get admin_questions_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /admin/questions/new' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it '新規質問フォームを表示する' do
        get new_admin_question_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'admin権限でログインしていない場合' do
      let(:bob) { create(:bob) }

      before { login_as(bob) }

      it '管理者画面にアクセスできない' do
        get new_admin_question_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST /admin/questions' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it '新しい質問を作成する' do
        expect do
          post admin_questions_path, params: {
            question: {
              body: '好きな漫画はなんですか？'
            }
          }
        end.to change(Question, :count).by(1)

        expect(response).to have_http_status(:found)
        follow_redirect!
        expect(response.body).to include('新しい質問を登録しました。')
        expect(response.body).to include('好きな漫画はなんですか？')
      end
    end

    context 'admin権限でログインしていない場合' do
      let(:bob) { create(:bob) }

      before { login_as(bob) }

      it '管理者画面にアクセスできない' do
        post admin_questions_path, params: {
          question: {
            body: '好きな漫画はなんですか？'
          }
        }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /admin/questions/:id/edit' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it '質問の編集フォームを表示する' do
        get edit_admin_question_path(question_food)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('好きな食べ物はなんですか？')
      end
    end

    context 'admin権限でログインしていない場合' do
      let(:bob) { create(:bob) }

      before { login_as(bob) }

      it '管理者画面にアクセスできない' do
        get edit_admin_question_path(question_food)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH /admin/questions/:id' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it '質問を更新する' do
        patch admin_question_path(question_food), params: {
          question: {
            body: '好きな漫画はなんですか？'
          }
        }

        expect(response).to have_http_status(:found)
        follow_redirect!
        expect(response.body).to include('質問の内容を更新しました。')
        expect(response.body).to include('好きな漫画はなんですか？')
        expect(question_food.reload.body).to eq('好きな漫画はなんですか？')
      end
    end

    context 'admin権限でログインしていない場合' do
      let(:bob) { create(:bob) }

      before { login_as(bob) }

      it '管理者画面にアクセスできない' do
        patch admin_question_path(question_food), params: {
          question: {
            body: '好きな漫画はなんですか？'
          }
        }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /admin/questions/:id' do
    context 'admin権限でログインしている場合' do
      before { login_as(alice) }

      it '質問を削除する' do
        expect do
          delete admin_question_path(question_sushi)
        end.to change(Question, :count).by(-1)

        expect(response).to have_http_status(:found)
        follow_redirect!
        expect(response.body).to include('質問を削除しました。')
        expect(response.body).not_to include('好きな寿司ネタはなんですか？')
      end
    end

    context 'admin権限でログインしていない場合' do
      let(:bob) { create(:bob) }

      before { login_as(bob) }

      it '管理者画面にアクセスできない' do
        delete admin_question_path(question_sushi)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
