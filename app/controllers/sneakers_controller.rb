class SneakersController < ApplicationController
    def index
        @sneaker_releases = SolecollectorScrapper.run!
        render json: @sneaker_releases.to_json()
    end
end
