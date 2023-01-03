class ListingsController < ApplicationController
  def index
    @filter = ListingFilter.create
    @pagy, @listings = pagy(@filter.results)
  end
end
