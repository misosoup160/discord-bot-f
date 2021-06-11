# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required

  def create
    user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_back_or(root_path)
    flash[:notice] = 'ログインしました'
  end

  def destroy
    reset_session
    redirect_to welcom_path, notice: 'ログアウトしました'
  end

  private

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
end
