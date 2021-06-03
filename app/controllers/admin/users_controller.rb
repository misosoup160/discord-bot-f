class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
    user = User.find(params[:id])
    if user.update(admin: !user.admin?)
      redirect_to admin_users_url, notice: '更新しました'
    else
      redirect_to admin_users_url, notice: '更新に失敗しました'
    end
  end
end
