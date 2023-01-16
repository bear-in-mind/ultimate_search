class ListingsController < ApplicationController
  include Pagy::Backend

  def index
    @filter ||= ListingFilter.create(filter_params)
    @pagy, @listings = pagy(@filter.results, items: 12, page: @filter.page, size: [1,1,1,1])
  rescue Pagy::OverflowError
    @pagy, @listings = pagy(@filter.results, items: 12, page: 1, size: [1,1,1,1])
  end

  private

  def filter_params
    params.permit(:query, :min_price, :max_price, :category, :tags, :format, :page, :order_by, :direction)
  end
end
