# frozen_string_literal: true

class AnswersController < ApplicationController
  def index
    @answers = Answer.where(posted: true).order(created_at: :desc).page(params[:page])
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
    @answer = Answer.find(params[:id])
  end

  def edit
    @answer = current_user.answers.find(params[:id])
    @question = Question.find(@answer.question_id)
  end

  def create
    @answer = current_user.answers.new(answer_params.merge(question_id: params[:question_id]))

    if @answer.save
      redirect_to user_answers_path(current_user), notice: '回答を登録しました。'
    else
      render :new
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])
    if @answer.update(answer_params.merge(question_id: params[:question_id]))
      redirect_to @answer, notice: '回答の内容を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy
    redirect_to user_answers_path(current_user), notice: '回答を削除しました。'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
