# == Schema Information
#
# Table name: prints
#
#  id            :bigint           not null, primary key
#  serial_number :integer
#  format        :string
#  vintage       :boolean          default(FALSE)
#  artwork_id    :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Print < ApplicationRecord
  FORMATS = %w[
    18x24
    30x40
    50x60
  ]

  CONDITIONS = %w[
    new
    second_hand
  ]

  belongs_to :artwork
  has_many :listings, dependent: :destroy

  scope :small, -> { where(format: "18x24") }
  scope :medium, -> { where(format: "30x40") }
  scope :large, -> { where(format: "50x60") }

  scope :posters, -> { joins(:artwork).merge(Artwork.posters) }
  scope :photos, -> { joins(:artwork).merge(Artwork.photos) }
end
