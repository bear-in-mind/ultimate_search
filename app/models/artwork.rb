class Artwork < ApplicationRecord
  TAGS = %w[
    black_and_white
    color
    landscape
    street
    Paris
    USA
    animals
    sunset
  ]
  
  has_many :prints
  
  scope :posters, -> { where(category: "poster") }
  scope :photos, -> { where(category: "photography") }
  
  has_one_attached :cover_image
end
