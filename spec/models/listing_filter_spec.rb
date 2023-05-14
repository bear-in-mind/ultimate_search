require 'rails_helper'

RSpec.describe ListingFilter, type: :model, search: true do
  before :all do
    Listing.delete_all
    photo = Artwork.create(name: "Dogs", author: "Elliott Erwitt", year: 1962, tags: %w[Animals B&W USA], category: "photography")
    poster = Artwork.create(name: "Fargo", author: "Matt Taylor", year: 2021, tags: %w[Cinema USA], category: "poster")
    photo_print = photo.prints.create(format: "30x40", serial_number: 1)
    photo_print_2 = photo.prints.create(format: "18x24", serial_number: 100)
    poster_print = poster.prints.create(format: "40x50", serial_number: 50)
    @photo_listing = photo_print.listings.create(price: 800)
    @photo_listing_2 = photo_print_2.listings.create(price: 400)
    @poster_listing = poster_print.listings.create(price: 200)
    @sold_listing = poster_print.listings.create(price: 300, sold_at: 2.days.ago)
    Listing.reindex
  end

  describe "#results" do
    it "doesn't return a sold listing" do
      expect(ListingFilter.create.results).not_to include(@sold_listing)
    end

    context "Filter options" do
      it "Filters by price" do
        filter = ListingFilter.create(min_price: 100, max_price: 300)
        expect(filter.results).to match_array([@poster_listing])
        filter.update(max_price: 1000)
        expect(filter.results).to match_array([@photo_listing, @photo_listing_2, @poster_listing])
      end

      it "Filters by serial number" do
        filter = ListingFilter.create(max_serial: 10)
        expect(filter.results).to match_array([@photo_listing])
        filter.update(min_serial: 20, max_serial: 60)
        expect(filter.results).to match_array([@poster_listing])
      end

      it "Filters by format" do
        filter = ListingFilter.create(format: ["40x50"])
        expect(filter.results).to match_array([@poster_listing])
        filter.update(format: ["40x50", "30x40"])
        expect(filter.results).to match_array([@photo_listing, @poster_listing])
      end

      it "Filters by category" do
        filter = ListingFilter.create(category: ["photography"])
        expect(filter.results).to match_array([@photo_listing_2, @photo_listing])
        filter.update(category: ["photography", "poster"])
        expect(filter.results).to match_array([@photo_listing, @photo_listing_2, @poster_listing])
      end

      it "Filters by tags" do
        filter = ListingFilter.create(tags: ["Cinema"])
        expect(filter.results).to match_array([@poster_listing])
        filter.update(tags: ["Cinema", "Animals"])
        expect(filter.results).to match_array([@photo_listing, @photo_listing_2, @poster_listing])
      end

      it "Filters by multiple attributes" do
        filter = ListingFilter.create(tags: ["Cinema"], max_price: 300, category: ["poster"])
        expect(filter.results).to match_array([@poster_listing])
      end
    end

    context "Search" do
      it "renders all listings if no query is passed" do
        filter = ListingFilter.create(query: "")
        expect(filter.results).to match_array([@photo_listing, @photo_listing_2, @poster_listing])
      end

      it "can search by artwork name or author" do
        filter = ListingFilter.create(query: "Erwitt")
        expect(filter.results).to match_array([@photo_listing, @photo_listing_2])
        filter.update(query: "Fargo")
        expect(filter.results).to match_array([@poster_listing])
      end

      it "can both search and filter" do
        filter = ListingFilter.create(query: "Erwitt", category: "photography")
        expect(filter.results).to match_array([@photo_listing, @photo_listing_2])
      end

      it "can both search and sort" do
        filter = ListingFilter.create(query: "Erwitt", order_by: "price", direction: "asc")
        expect(filter.results.to_a).to eq([@photo_listing_2, @photo_listing])
        filter.update(query: "Erwitt", order_by: "serial_number", direction: "asc")
        expect(filter.results.to_a).to eq([@photo_listing, @photo_listing_2])
      end
    end

    context "Sort options" do
      specify "Recent listings first (default behaviour)" do
        filter = ListingFilter.create
        expect(filter.results.to_a).to eq([@poster_listing, @photo_listing_2, @photo_listing])
      end

      specify "Most expensive first" do
        filter = ListingFilter.create(order_by: "price", direction: "desc")
        expect(filter.results.to_a).to eq([@photo_listing, @photo_listing_2, @poster_listing])
      end

      specify "Least expensive first" do
        filter = ListingFilter.create(order_by: "price", direction: "asc")
        expect(filter.results.to_a).to eq([@poster_listing, @photo_listing_2, @photo_listing])
      end

      specify "Oldest artworks first" do
        filter = ListingFilter.create(order_by: "year", direction: "asc")
        expect(filter.results.to_a.first.year).to eq(1962)
        expect(filter.results.to_a.last.year).to eq(2021)
      end

      specify "Most recent artworks first" do
        filter = ListingFilter.create(order_by: "year", direction: "desc")
        expect(filter.results.first.year).to eq(2021)
        expect(filter.results.to_a.last.year).to eq(1962)
      end

      specify "Lowest serials first" do
        filter = ListingFilter.create(order_by: "serial_number", direction: "asc")
        expect(filter.results.to_a).to eq([@photo_listing, @poster_listing, @photo_listing_2])
      end

      specify "Highest serials first" do
        filter = ListingFilter.create(order_by: "serial_number", direction: "desc")
        expect(filter.results.to_a).to eq([@photo_listing_2, @poster_listing, @photo_listing])
      end
    end
  end
end
