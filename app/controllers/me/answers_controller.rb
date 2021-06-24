# frozen_string_literal: true

class Me::AnswersController < ApplicationController
  def index
    @answers = current_user.answers.preload(:question)
                           .order(created_at: :desc)
                           .page(params[:page])
  end
end
