# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer, only: %i[edit update destroy]

  def index
    @answer = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to admin_questions_path, notice: '質問を登録しました'
    else
      render :new
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
