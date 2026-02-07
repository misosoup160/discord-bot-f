# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe '.search' do
    let(:alice) { create(:alice) }
    let(:bob) { create(:bob) }
    let(:question_food) { create(:question, body: '好きな食べ物はなんですか？') }
    let(:question_sushi) { create(:question, body: '好きな寿司ネタはなんですか？') }
    let!(:answer_alice_food) { create(:answer, user: alice, question: question_food, body: '焼肉定食です') }
    let!(:answer_bob_food) { create(:answer, :posted, user: bob, question: question_food, body: 'オムライスです') }
    let!(:answer_bob_sushi) { create(:answer, user: bob, question: question_sushi, body: 'アジです') }

    it '回答本文で検索できる' do
      expect(Answer.search('焼肉定食')).to include(answer_alice_food)
    end

    it 'ユーザー名で検索できる' do
      results = Answer.search('bob')
      expect(results).to include(answer_bob_sushi)
      expect(results).to include(answer_bob_food)
    end

    it '質問本文で検索できる' do
      results = Answer.search('食べ物')
      expect(results).to include(answer_alice_food)
      expect(results).to include(answer_bob_food)
    end

    it '空文字で全ての回答を返す' do
      expect(Answer.search('').count).to eq(3)
    end

    it '無効な検索パターンでnilを返す' do
      expect(Answer.search('%').first).to be_nil
    end
  end
end
