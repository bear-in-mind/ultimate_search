class Print < ApplicationRecord
  FORMATS = %w[
    18x24
    30x40
    50x60
  ]

  belongs_to :artwork
  has_many :listings

  scope :small, -> { where(format: "18x24") }
  scope :medium, -> { where(format: "30x40") }
  scope :large, -> { where(format: "50x60") }
end
