class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
  end

  def edit
  end

  def update
  end
end
