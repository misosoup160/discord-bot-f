# frozen_string_literal: true

class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
    @question = Question.find(Question.pluck(:id).sample)
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = current_user.answers.new(answer_params.merge(question_id: params[:question_id]))

    if @answer.save
      redirect_to new_answer_path, notice: '登録しました'
    else
      redirect_to new_answer_path, notice: '登録に失敗しました'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
