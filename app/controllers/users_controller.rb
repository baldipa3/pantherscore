class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_user, only: %i[show edit update]

  def show
    @user = User.find(params[:id])
    pantherscore_sum = @user.services.pluck(:pantherscore).sum
    user_total_services = @user.services.count
    @myscore = pantherscore_sum / user_total_services
    @recommended = Service.all
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
