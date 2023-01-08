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

  belongs_to :print
  has_one :artwork, through: :print

  delegate :name, :cover_image, :author, to: :artwork
  
  scope :for_sale,        -> { where(sold_at: nil) }
  scope :price_between,   ->(min, max) { where(price: min..max) }
  scope :with_formats,    ->(options) { joins(:print).where(prints: {format: options}) if options.present? }
  scope :from_categories, ->(options) { joins(:artwork).where(artworks: {category: options}) if options.present? }
  # Will work as an OR filter
  scope :with_tags,       ->(options) { joins(:artwork).where("artworks.tags && ?", "{#{options.join(",")}}") if options.present? }
  scope :search,          ->(query) { basic_search(query) if query.present? }

  pg_search_scope :basic_search, associated_against: {
    artwork: [:name, :author]
  }

  # Caching the max price to avoid unnecessary queries at each object initialization
  def self.max_price
    Rails.cache.fetch("Listing/max_floor_cents", expires_in: 1.day) do
      Listing.for_sale.maximum(:price) || 10_000
    end
  end
end
