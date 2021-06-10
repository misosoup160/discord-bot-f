# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all.order(created_at: :desc).page(params[:page])
  end

  def update
    user = User.find(params[:id])
    if user.update(admin: !user.admin?)
      redirect_to admin_users_url, notice: '更新しました。'
    else
      redirect_to admin_users_url, alert: '更新に失敗しました。'
    end
  end

  def search
    @users = User.search(params[:keyword]).order(created_at: :desc).page(params[:page])
    @keyword = params[:keyword]
    render :index
  end

  private

  def require_admin
    redirect_to root_path unless current_user.admin
  end
end
