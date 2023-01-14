# frozen_string_literal: true

class ListingReflex < ApplicationReflex
  def sort
    update_listing_filter do |filter|
      filter.order_by = element.dataset.column
      filter.direction = element.dataset.direction
    end
  end

  def min_price
    update_listing_filter do |filter|
      filter.min_price = element.value.to_i
    end
  end

  def max_price
    update_listing_filter do |filter|
      filter.max_price = element.value.to_i
    end
  end

  def search
    update_listing_filter do |filter|
      filter.query = element.value
    end
  end

  private

  def update_listing_filter
    @filter = ListingFilter.find(element.dataset.filter_id)
    yield @filter
    @filter.save
    # Take care of updating search params
    # cable_ready.push_state(url: "#{request.path}?#{@filter.as_params}")
  end
end
