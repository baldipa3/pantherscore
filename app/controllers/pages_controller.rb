class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @top_services = Service.limit(12).order('pantherscore')
  end
end
