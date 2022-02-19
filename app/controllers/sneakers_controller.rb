class SneakersController < ApplicationController
  def index
    @sneaker_releases = Solecollector::Scrapper.run!
    render json: @sneaker_releases.to_json()
  end

  def monthly_releases
    if valid_month?(month = params[:month].to_i)
      @sneaker_releases = Solecollector::Scrapper.run!(month: month)
      render json: @sneaker_releases.to_json()
    else
      redirect_to root_path
    end
  end

  def all_releases
    @sneaker_releases = Solecollector::Scrapper.run!(all_releases: true)
    render json: @sneaker_releases.to_json()
  end

  private

  def valid_month?(month)
    month.between?(1,12)
  end
end
