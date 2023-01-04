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
    black_and_white
    color
    landscape
    street
    Paris
    USA
    animals
    sunset
  ]
  
  has_many :prints, dependent: :destroy
  
  scope :posters, -> { where(category: "poster") }
  scope :photos, -> { where(category: "photography") }

  has_one_attached :cover_image
end
