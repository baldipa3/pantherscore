class ServicesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @services = Service.all
  end

  def show
    @service = Service.find(params[:id])
    impressionist(@service)
    @review = Review.new
  end
end
