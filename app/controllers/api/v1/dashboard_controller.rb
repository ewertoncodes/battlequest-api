class Api::V1::DashboardController < ApplicationController
  def show
    render json: DashboardQuery.new.call
  end
end
