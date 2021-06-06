class Users::AnswersController < ApplicationController
  def index
    @answers = current_user.answers
  end
end
