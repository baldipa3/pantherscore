class ServicesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @services = Service.all
    @categories = Category.all
    # @services = Category.where(name: @category).first.services
  end

  def show
    @service = Service.find(params[:id])
    impressionist(@service)
    @review = Review.new
  end

  def query
    @services_by_category = Service.all
    if params[:category].present?
      @services_by_category = Category.where(name: params[:category]).first.services
      # Service.joins(:categories).where("categories.name=?", params[:category]).all
    end
    render json: @services_by_category
  end
end
