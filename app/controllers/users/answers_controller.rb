# frozen_string_literal: true

class Users::AnswersController < ApplicationController
  def index
    @answers = current_user.answers.includes(:question)
                                   .order(created_at: :desc)
                                   .page(params[:page])
  end
end
