require 'rails_helper'

RSpec.describe ListingFilter, type: :model do
  let!(:photo) { Artwork.create(name: "Dogs", author: "Elliott Erwitt", year: 1962, tags: %w[Animals B&W USA], category: "photography") }
  let!(:poster) { Artwork.create(name: "Fargo", author: "Matt Taylor", year: 2021, tags: %w[Cinema USA], category: "poster") }
  let!(:photo_print) { photo.prints.create(format: "30x40", serial_number: 1) }
  let!(:poster_print) { poster.prints.create(format: "40x50", serial_number: 99) }
  let!(:photo_listing) { photo_print.listings.create(price: 800) }
  let!(:poster_listing) { poster_print.listings.create(price: 200) }

  describe "#results" do
    it "Filters by price" do
      filter = ListingFilter.create(min_price: 100, max_price: 300)
      expect(filter.results).to match_array([poster_listing])
      filter.update(max_price: 1000)
      expect(filter.results).to match_array([photo_listing, poster_listing])
    end

    it "Filters by format" do
      filter = ListingFilter.create(format: ["40x50"])
      expect(filter.results).to match_array([poster_listing])
      filter.update(format: ["40x50", "30x40"])
      expect(filter.results).to match_array([photo_listing, poster_listing])
    end
  end
end
