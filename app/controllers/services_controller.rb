class ServicesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if params[:search].present?
      @services = Service.where("name ILIKE ?", "%#{params[:search]}%")
    end
    @categories = Category.all
    # @services = Category.where(name: @category).first.services
  end

  def show
    @service = Service.find(params[:id])
    impressionist(@service)
    @review = Review.new
    @alternatives = Service.find(params[:id]).alternatives.where.not(pantherscore: 0).order(pantherscore: :desc).first(5)
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
