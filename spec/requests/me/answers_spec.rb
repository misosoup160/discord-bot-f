# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Me::AnswersController', type: :request do
  let(:alice) { create(:alice) }
  let(:bob) { create(:bob) }
  let(:question_food) { create(:question, body: '好きな食べ物はなんですか？') }
  let(:question_sushi) { create(:question, body: '好きな寿司ネタはなんですか？') }
  let!(:answer_alice_food) { create(:answer, :posted, user: alice, question: question_food, body: '焼肉定食です') }
  let!(:answer_bob_food) { create(:answer, :posted, user: bob, question: question_food, body: 'オムライスです') }
  let!(:answer_bob_sushi) { create(:answer, user: bob, question: question_sushi, body: 'アジです') }

  describe 'GET /me/answers' do
    before { login_as(bob) }

    it '自分の回答のみ表示される' do
      get me_answers_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('自分の回答一覧')
      expect(response.body).not_to include('焼肉定食です')
      expect(response.body).to include('オムライスです')
      expect(response.body).to include('アジです')
    end
  end
end
