# frozen_string_literal: true

class Users::AnswersController < ApplicationController
  def index
    @answers = current_user.answers
  end
end
