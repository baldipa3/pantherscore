require "pry"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @services = Service.all.where.not(pantherscore: 0)
    @most_viewed = @services.limit(12).order('impressions_count')
    @top_five_services = pantherscore_order.first(5)
    @last_five_services = pantherscore_order.last(5).reverse
    @recently_added = @services.last(3)
    @categories = Category.all
    @top_reviewed_users = top_advocates(10)
    @recent_reviews = Review.last(4)
    @crew_picks = @services.first(5)
  end

  private

  def pantherscore_order
    @services.order(pantherscore: :desc)
  end

  def top_advocates(num)
    User.joins(:reviews).sort_by { |s| -s.reviews.count }.uniq.first(num)
  end
end
