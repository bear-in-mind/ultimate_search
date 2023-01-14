class ListingFilter < AllFutures::Base
  # Filters
  attribute :query, :string
  attribute :min_price, :integer, default: 1
  attribute :max_price, :integer, default: Listing.max_price
  attribute :category, :string, array: true, default: []
  attribute :tags, :string, array: true, default: []
  attribute :format, :string, array: true, default: []
  # Pagination
  attribute :items, :integer, default: 16
  attribute :page, :integer, default: 1
  # Sorting
  attribute :order_by, :string, default: "created_at"
  attribute :direction, :string, default: "desc"

  def results
    # Step 1
    # Doesn't work because pg_search doesn't play well with joined scopes and associations
    # Listing.for_sale
    #   .price_between(min_price, max_price)
    #   .factory_sealed(only_new_prints)
    #   .from_categories(category)
    #   .with_tags(tags)
    #   .with_formats(format)
    #   .search(query)
    #   .order(order => direction)
    
    # Step 2
    filtered_listings_ids = Listing.for_sale
      .price_between(min_price, max_price)
      .from_categories(category)
      .with_tags(tags)
      .with_formats(format)
      .pluck(:id)
    
    Listing
      .joins(:artwork)
      .includes(artwork: {cover_image_attachment: :blob})
      .where(id: filtered_listings_ids)
      .search(query)
      .order(order_by => direction)
      .limit(200)
  end
end
