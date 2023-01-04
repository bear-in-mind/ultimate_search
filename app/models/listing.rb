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

  delegate :name, :cover_image, to: :artwork
  
  scope :search, ->(query) { basic_search(query) if query.present? }
  scope :for_sale, -> { where(sold_at: nil) }
  scope :price_between, ->(min, max) { where(price: min..max) }
  # scope :price_between, ->(min, max) { where("listings.price BETWEEN ? and ?", min, max) }
  scope :factory_sealed, ->(factory_sealed_only) { joins(:print).merge(Print.factory_sealed) if factory_sealed_only }
  scope :from_categories, ->(options) { joins(:artwork).where(artworks: {category: options}) if options.present? }
  scope :with_formats, ->(options) { joins(:print).where(prints: {format: options}) if options.present? }
  # Will work as an OR filter
  scope :with_tags, ->(options) { joins(:artwork).where("artworks.tags && ?", "{#{options.join(",")}}") if options.present? }

  pg_search_scope :basic_search, associated_against: {
    artwork: [:name, :author]
  } 

end
