# == Schema Information
#
# Table name: listings
#
#  id         :bigint           not null, primary key
#  price      :integer
#  sold_at    :datetime
#  print_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Listing < ApplicationRecord
  include PgSearch::Model
  searchkick

  belongs_to :print
  has_one :artwork, through: :print

  delegate :name, :cover_image, :author, :year, :category, :tags, to: :artwork
  delegate :serial_number, :format, to: :print

  scope :for_sale,        -> { where(sold_at: nil) }
  scope :price_between,   ->(min, max) { where(price: min..max) }
  scope :serial_between,   ->(min, max) { joins(:print).where(prints: {serial_number: min..max}) }
  scope :with_formats,    ->(options) { joins(:print).where(prints: {format: options}) if options.present? }
  scope :from_categories, ->(options) { joins(:artwork).where(artworks: {category: options}) if options.present? }
  # Will work as an OR filter
  scope :with_tags,       ->(options) { joins(:artwork).where("artworks.tags && ?", "{#{options.join(",")}}") if options.present? }
  # scope :search,          ->(query) { basic_search(query) if query.present? }
  scope :search_import, -> { for_sale.includes(print: :artwork) }


  pg_search_scope :basic_search,
    associated_against: {
      artwork: [:name, :author]
    },
    using: {
      tsearch: {prefix: true}
    }

  # Caching the max price to avoid unnecessary queries at each object initialization
  def self.max_price
    Rails.cache.fetch("Listing/max_floor_cents", expires_in: 1.day) do
      Listing.for_sale.maximum(:price) || 10_000
    end
  end

  private

  # Using ruby shorthand hash syntax here, thanks to our delegate methods
  def search_data
    {
      price:,
      sold_at:,
      format:,
      serial_number:,
      created_at:,
      category:,
      name:,
      tags:,
      author:,
      year:,
      print_id: print.id,
      artwork_id: print.artwork_id,
    }
  end

end
