# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer, only: %i[edit update destroy]

  def index
    @answers = Answer.preload(:question, :user)
                     .where(posted: true)
                     .order(posted_at: :desc)
                     .page(params[:page])
  end

  def new
    @answer = Answer.new
    @question = if params[:question]
                  Question.find(params[:question])
                else
                  Question.find(Question.pluck(:id).sample)
                end
  end

  def show
    @answer = Answer.where(posted: true)
                    .or(Answer.where(user_id: current_user.id)).find(params[:id])
  end

  def edit
    @question = Question.find(@answer.question_id)
  end

  def create
    @answer = current_user.answers.new(answer_params.merge(question_id: params[:question_id]))
    @question = Question.find(params[:question_id])
    if @answer.save
      redirect_to user_answers_path(current_user), notice: '回答を登録しました。'
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:question_id])
    if @answer.update(answer_params.merge(question_id: params[:question_id]))
      redirect_to @answer, notice: '回答の内容を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to user_answers_path(current_user), notice: '回答を削除しました。'
  end

  def search
    @answers = Answer.search(params[:keyword])
                     .where(posted: true)
                     .order(created_at: :desc)
                     .page(params[:page])
    @keyword = params[:keyword]
    render :index
  end

  private

  def set_answer
    @answer = current_user.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
