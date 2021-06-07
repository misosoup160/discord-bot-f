# frozen_string_literal: true

class Admin::QuestionsController < ApplicationController
  before_action :set_question, only: %i[edit update destroy]

  def index
    @questions = Question.all.order(updated_at: :desc)
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to admin_questions_path, notice: '質問を登録しました'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to admin_questions_path, notice: '質問を登録しました'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_questions_path, notice: '質問を削除しました'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body)
  end
end
