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
  
  scope :posters, -> { where(category: "poster") }
  scope :photos, -> { where(category: "photography") }

  has_one_attached :cover_image
end
