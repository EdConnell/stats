class MainController < ApplicationController
  def index
    @eff_rating = WorldOfTanks.scrape_efficiency_rating
  end
end
