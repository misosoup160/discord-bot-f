# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AnswersController', type: :request do
  let(:alice) { create(:alice) }
  let(:bob) { create(:bob) }
  let!(:question_food) { create(:question, body: '好きな食べ物はなんですか？') }
  let!(:question_sushi) { create(:question, body: '好きな寿司ネタはなんですか？') }
  let!(:answer_alice_food) { create(:answer, :posted, user: alice, question: question_food, body: '焼肉定食です') }
  let!(:answer_bob_food) { create(:answer, :posted, user: bob, question: question_food, body: 'オムライスです') }
  let!(:answer_bob_sushi) { create(:answer, user: bob, question: question_sushi, body: 'アジです') }

  describe 'GET /answers' do
    before { login_as(alice) }

    it '投稿済みの全ての回答を表示する' do
      get answers_path
      expect(response).to have_http_status(:success)

      expect(response.body).to include('みんなの回答一覧')
      expect(response.body).to include('焼肉定食です')
      expect(response.body).to include('オムライスです')
      expect(response.body).not_to include('アジです')
    end
  end

  context 'ログインしていない場合' do
    it 'ログイン画面にリダイレクトする' do
      get answers_path
      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET /answers/new' do
    before { login_as(alice) }

    it '新規回答フォームを表示する' do
      get new_answer_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /answers' do
    before { login_as(alice) }

    it '新しい回答を作成する' do
      expect do
        post answers_path, params: {
          question_id: question_sushi.id,
          answer: {
            body: 'タコです'
          }
        }
      end.to change(Answer, :count).by(1)

      expect(response).to have_http_status(:found)
      follow_redirect!
      expect(response.body).to include('回答を登録しました。')
      expect(response.body).to include('タコです')
    end
  end

  describe 'GET /answers/:id' do
    context '投稿済み回答を閲覧する場合' do
      before { login_as(bob) }

      it '投稿済み回答の編集リンクを表示しない' do
        get answer_path(answer_bob_food)
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('編集')
        expect(response.body).to include('削除')
      end
    end

    context '未投稿回答を閲覧する場合' do
      before { login_as(bob) }

      it '未投稿回答の編集リンクを表示する' do
        get answer_path(answer_bob_sushi)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('編集')
      end
    end
  end

  describe 'GET /answers/:id/edit' do
    before { login_as(bob) }

    it '未投稿回答の編集フォームを表示する' do
      get edit_answer_path(answer_bob_sushi)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('アジです')
    end
  end

  describe 'PATCH /answers/:id' do
    before { login_as(bob) }

    it '回答を更新する' do
      patch answer_path(answer_bob_sushi), params: {
        question_id: question_sushi.id,
        answer: {
          body: 'シマアジです'
        }
      }

      expect(response).to have_http_status(:found)
      follow_redirect!
      expect(response.body).to include('回答の内容を更新しました。')
      expect(response.body).to include('シマアジで')
      expect(answer_bob_sushi.reload.body).to eq('シマアジです')
    end
  end

  describe 'DELETE /answers/:id' do
    before { login_as(bob) }

    it '回答を削除する' do
      expect do
        delete answer_path(answer_bob_sushi)
      end.to change(Answer, :count).by(-1)

      expect(response).to have_http_status(:found)
      follow_redirect!
      expect(response.body).to include('回答を削除しました。')
      expect(response.body).not_to include('アジです')
    end
  end

  describe 'ログイン後のリダイレクト' do
    let(:bob) { create(:bob) }

    it 'ログイン後に訪問していたページにリダイレクトする' do
      get answers_path
      expect(response).to have_http_status(:found)

      login_as(bob)
      expect(response.body).to include('ログインしました。')
      expect(response.body).to include('みんなの回答一覧')
    end
  end
end
