class ListingFilter < AllFutures::Base
  # Filters
  attribute :query, :string
  attribute :min_price, :integer, default: 1
  # In a real world scenario, the default value here should probably be cached
  attribute :max_price, :integer, default: Listing.maximum(:price)
  attribute :category, :string, array: true, default: []
  attribute :tags, :string, array: true, default: []
  attribute :format, :string, array: true, default: []
  attribute :only_new_prints, :boolean, default: false
  # Pagination
  attribute :items, :integer, default: 16
  attribute :page, :integer, default: 1
  # Sorting
  attribute :order, :string, default: "created_at"
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
    
    # Step 2
    filtered_listings_ids = Listing.for_sale
      .price_between(min_price, max_price)
      .factory_sealed(only_new_prints)
      .from_categories(category)
      .with_tags(tags)
      .with_formats(format)
      .pluck(:id)
    
    Listing.where(id: filtered_listings_ids).search(query).limit(200)
  end
end
