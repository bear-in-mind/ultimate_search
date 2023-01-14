class ListingsController < ApplicationController
  include Pagy::Backend

  def index
    @filter ||= ListingFilter.create
    @pagy, @listings = pagy(@filter.results, items: 12)
  end
end
