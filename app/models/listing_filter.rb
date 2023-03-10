class ListingFilter < AllFutures::Base
  SORTING_OPTIONS = [
    {column: "created_at", direction: "desc", text: "Recently added"},
    {column: "price", direction: "asc", text: "Price: Low to High"},
    {column: "price", direction: "desc", text: "Price: High to Low"}
    # {column: "artworks.year", direction: "asc", text: "Year: Old to Recent"},
    # {column: "artworks.year", direction: "desc", text: "Year: Recent to Old"},
    # {column: "prints.serial_number", direction: "asc", text: "Serial number: Low to High"}
  ]
  # Filters
  attribute :query, :string
  attribute :min_price, :integer, default: 1
  attribute :max_price, :integer, default: Listing.max_price
  attribute :category, :string, array: true, default: []
  attribute :tags, :string, array: true, default: []
  attribute :format, :string, array: true, default: []
  # Pagination
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
      .joins(print: :artwork)
      .price_between(min_price, max_price)
      .from_categories(category)
      .with_tags(tags)
      .with_formats(format)
      .pluck(:id)
    
    Listing
      .includes(artwork: {cover_image_attachment: :blob})
      .where(id: filtered_listings_ids)
      .search(query)
      .reorder(order_by => direction)
      .limit(200)
  end

  # Memoizing the value to avoid re-computing at every call
  def selected_sorting_option
    @_selected_option ||= SORTING_OPTIONS.find {|option| order_by == option[:column] && direction == option[:direction] }
  end
end
