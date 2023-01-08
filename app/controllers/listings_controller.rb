class ListingsController < ApplicationController
  include Pagy::Backend

  def index
    @filter ||= ListingFilter.create
    @pagy, @listings = pagy(@filter.results)
  end
end
