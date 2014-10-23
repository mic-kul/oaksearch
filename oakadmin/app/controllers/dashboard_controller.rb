class DashboardController < ApplicationController
	before_filter :authenticate_user
  def index
  	@alerts = Adminalert.all().limit(50)
  end
end
