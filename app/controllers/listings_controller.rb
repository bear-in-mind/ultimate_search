class ListingsController < ApplicationController
  include CableReady::Broadcaster
  include Pagy::Backend
  
  def index
    @filter = ListingFilter.create
    @pagy, @listings = pagy(@filter.results)
  end
end
