class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    @service = Service.find(params[:service_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.service = @service
    if @review.valid?
      @review.save!
      redirect_to service_path(@service)
    else
      render 'services/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating, :service_id)
  end

end
