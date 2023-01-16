# == Schema Information
#
# Table name: artworks
#
#  id         :bigint           not null, primary key
#  name       :string
#  author     :string
#  category   :string
#  year       :integer
#  tags       :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Artwork < ApplicationRecord
  include PgSearch::Model
  TAGS = %w[
    B&W
    Color
    Landscape
    Street
    Paris
    USA
    Animals
    Sunset
    Cinema
  ]

  CATEGORIES = %w[
    illustration
    poster
    photography
  ]
  
  has_many :prints, dependent: :destroy
  has_many :listings, through: :prints
  has_many :available_listings, -> { where(sold_at: nil) }, through: :prints, source: :listings
  
  scope :posters, -> { where(category: "poster") }
  scope :photos, -> { where(category: "photography") }

  scope :price_between,   ->(min, max) { joins(:listings).where(listings: {price: min..max}) }
  scope :serial_between,   ->(min, max) { joins(:prints).where(prints: {serial_number: min..max}) }
  scope :with_formats,    ->(options) { joins(:prints).where(prints: {format: options}) if options.present? }
  scope :from_categories, ->(options) { where(category: options) if options.present? }
  scope :with_tags,       ->(options) { where("artworks.tags && ?", "{#{options.join(",")}}") if options.present? }
  scope :search,          ->(query) { basic_search(query) if query.present? }
  
  pg_search_scope :basic_search,
  against: [:name, :author],
  using: {
    tsearch: {prefix: true}
  }

  has_one_attached :cover_image
end
