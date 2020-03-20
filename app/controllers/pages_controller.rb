require "pry"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @most_viewed = Service.limit(12).order('impressions_count')
    @top_five_services = pantherscore_order.first(5)
    @last_five_services = pantherscore_order.last(5).reverse
    @recently_added = Service.last(3)
    @categories = Category.all
    @top_reviewed_users = top_advocates(10)
    @recent_reviews = Review.last(4)
    @crew_picks = Service.first(5)
  end

  private

  def pantherscore_order
    Service.order(pantherscore: :desc)
  end

  def top_advocates(num)
    User.joins(:reviews).sort_by { |s| -s.reviews.count }.uniq.first(num)
  end
end
