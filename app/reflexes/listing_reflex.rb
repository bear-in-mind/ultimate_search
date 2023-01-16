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

  def format
    update_listing_filter do |filter|
      filter.format = element.value
    end
  end

  def search
    update_listing_filter do |filter|
      filter.query = element.value
    end
  end

  def paginate
    update_listing_filter do |filter|
      filter.page = element.dataset.page
    end
  end

  def clear
    ListingFilter.find(element.dataset.filter_id).destroy
    @filter = ListingFilter.create
    cable_ready.push_state(url: request.path)
  end

  private

  def update_listing_filter
    @filter = ListingFilter.find(element.dataset.filter_id)
    yield @filter
    @filter.save
    # Updating URL with filter state
    cable_ready.push_state(url: "#{request.path}?#{@filter.attributes.to_query}")
  end
end
