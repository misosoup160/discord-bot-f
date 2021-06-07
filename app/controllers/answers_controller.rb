# frozen_string_literal: true

class AnswersController < ApplicationController
  def index
    @answers = Answer.where(posted: true).order(created_at: :desc)
  end

  def new
    @answer = Answer.new
    if params[:question]
      @question = Question.find(params[:question])
    else
      @question = Question.find(Question.pluck(:id).sample)
    end
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def edit
    @answer = current_user.answers.find(params[:id])
    @question = Question.find(@answer.question_id)
  end

  def create
    @answer = current_user.answers.new(answer_params.merge(question_id: params[:question_id]))

    if @answer.save
      redirect_to user_answers_path(current_user), notice: '登録しました'
    else
      redirect_to user_answers_path(current_user), notice: '登録に失敗しました'
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])
    if @answer.update(answer_params.merge(question_id: params[:question_id]))
      redirect_to user_answers_path(current_user), notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy
    redirect_to user_answers_path(current_user), notice: '削除しました'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
