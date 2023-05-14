class ListingFilter < AllFutures::Base
  SORTING_OPTIONS = [
    {column: "created_at", direction: "desc", text: "Recently added"},
    {column: "price", direction: "asc", text: "Price: Low to High"},
    {column: "price", direction: "desc", text: "Price: High to Low"},
    {column: "year", direction: "asc", text: "Year: Old to Recent"},
    {column: "year", direction: "desc", text: "Year: Recent to Old"},
    {column: "serial_number", direction: "asc", text: "Serial number: Low to High"}
  ].freeze
  # Filters
  attribute :query, :string
  attribute :min_price, :integer, default: 1
  attribute :max_price, :integer, default: Listing.max_price
  attribute :min_serial, :integer, default: 1
  attribute :max_serial, :integer, default: 100
  attribute :category, :string, array: true, default: []
  attribute :tags, :string, array: true, default: []
  attribute :format, :string, array: true, default: []
  # Pagination
  attribute :page, :integer, default: 1
  # Sorting
  attribute :order_by, :string, default: "created_at"
  attribute :direction, :string, default: "desc"

  def filter_options
    opts = {}
    opts[:serial_number] = {gte: min_serial, lte: max_serial}
    opts[:price] = {gte: min_price, lte: max_price}
    opts[:category] = category if category.present?
    opts[:tags] = tags if tags.present?
    opts[:format] = format if format.present?
    opts
  end

  def body_options
    {
      # size: 0,
      aggs: {
        artworks: {
          terms: {field: :name},
          aggs: {
            # name: {
            #   terms: {field: :name}
            # },
            # created_at: {
            #   max: {field: :created_at}
            # },
            floor_price: {
              min: {field: :price}
            },
            author_name: {
              terms: {field: :author}
            },
            lowest_serial: {
              min: {field: :serial_number}
            },
            highest_serial: {
              max: {field: :serial_number}
            },
            # max_score: {
            #   max: {
            #     script: :_score
            #   }
            # }
          }
        }
      }
    }
  end

  def results
    search_query = query.presence || "*"
    Listing.search(
      search_query,
      where: filter_options,
      body_options: body_options,
      order: {order_by => direction}
    )
  end

  def selected_sorting_option
    SORTING_OPTIONS.find {|option| order_by == option[:column] && direction == option[:direction] }
  end
end
