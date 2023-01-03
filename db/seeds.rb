# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_poster(name, filename)
  artwork = Artwork.create!(
    name: name,
    category: "poster",
    author: "Paul Bijaoui",
    year: (2010..2022).to_a.sample,
    tags: ['cinema']
  )
  file = File.open(Rails.root.join("artworks", "#{filename}.webp"))
  artwork.cover_image.attach(io: file, filename: file.path)
  artwork
end

def create_photo(name, filename, tags, author: "Louis Sommer", year: nil)
  artwork = Artwork.create!(
    name: name,
    category: "photography",
    author: author,
    year: year || (2010..2022).to_a.sample,
    tags: tags
  )
  file = File.open(Rails.root.join("artworks", "#{filename}.jpg"))
  artwork.cover_image.attach(io: file, filename: file.path)
  artwork
end

Listing.destroy_all
Print.destroy_all
Artwork.destroy_all

Artwork.transaction do
  puts "Creating posters"
  create_poster "Citizen Kane", "citizen_kane"
  create_poster "Dallas Buyer's Club", "dallas_buyers"
  create_poster "Drive", "drive"
  create_poster "Fargo", "fargo"
  create_poster "Grease", "grease"
  create_poster "Le Mépris", "le_mepris"
  create_poster "Paris, Texas", "paris_texas"
  create_poster "Pierrot Le Fou", "pierrot"
  create_poster "The Godfather", "the_godfather"
  create_poster "Top Gun", "top_gun"

  puts "Creating photos"
  create_photo "Pont Charles de Gaulle", "photo-01", %w[color sunset landscape Paris]
  create_photo "Oiseau", "photo-02", %w[black_and_white animals]
  create_photo "Notre-Dame de Paris", "photo-03", %w[color Paris]
  create_photo "Sortie du Métro", "photo-04", %w[color Paris street]
  create_photo "Food", "photo-05", %w[black_and_white animals]
  create_photo "Nénette", "photo-07", %w[black_and_white animals]
  create_photo "Ile Saint-Louis", "photo-08", %w[black_and_white Paris street]
  create_photo "Place de la Concorde", "photo-09", %w[black_and_white Paris street]
  create_photo "Paris IXe", "photo-10", %w[black_and_white Paris street]
  create_photo "Jardin d'Acclimatation", "photo-11", %w[color animals]
  create_photo "Coney Island", "photo-12", %w[color street USA]
  create_photo "Echo Park", "photo-13", %w[color animals USA]
  create_photo "San Francisco Bay", "photo-14", %w[black_and_white landscape USA]
  create_photo "Beatty, Nevada", "photo-15", %w[color landscape USA]
  create_photo "Detroit", "photo-16", %w[black_and_white street USA]
  create_photo "Corsica", "photo-17", %w[color animals]
  create_photo "Detroit", "photo-18", %w[color street USA]
  create_photo "Erbalunga", "photo-19", %w[color sunset landscape]
  create_photo "Canal Saint Martin", "photo-20", %w[black_and_white animals Paris street]
  create_photo "Paris XIII", "photo-21", %w[color Paris street]
  create_photo "Oaxaca in gold", "photo-23", %w[color street]
  create_photo "Oaxaca in blue", "photo-25", %w[color street sunset]
  create_photo "Cuajimoloyas", "photo-24", %w[color landscape]
  create_photo "Tunnel View", "photo-26", %w[color landscape USA]
  create_photo "Valley View", "photo-27", %w[black_and_white landscape USA]

  puts "Creating photos for vintage prints"
  depardon_1 = create_photo "Liban", "depardon-2", %w[color street], author: "Raymond Depardon", year: 1972
  depardon_2 = create_photo "Chambre", "depardon-1", %w[color], author: "Raymond Depardon", year: 1986
  erwitt_1 = create_photo "Untitled", "erwitt-1", %w[black_and_white animals street], author: "Elliott Erwitt", year: 1965
  erwitt_2 = create_photo "Bulldog", "erwitt-2", %w[black_and_white animals], author: "Elliott Erwitt", year: 1968
  gilden_1 = create_photo "Yakuzas", "gilden-1", %w[black_and_white street], author: "Bruce Gilden", year: 1976
  gilden_2 = create_photo "Brooklyn party", "gilden-2", %w[black_and_white street USA], author: "Bruce Gilden", year: 1980

  puts "Creating prints"
  Artwork.posters.each do |poster|
    100.times {|index| poster.prints.create!(serial_number: index + 1, format: "50x60") }
  end
  Artwork.photos.each do |photo|
    10.times {|index| photo.prints.create!(serial_number: index + 1, format: "50x60") }
    50.times {|index| photo.prints.create!(serial_number: index + 1, format: "30x40") }
    100.times {|index| photo.prints.create!(serial_number: index + 1, format: "18x24") }
  end
  puts "Creating listings"
  poster_prices = [100, 200, 300]
  Print.posters.each { |poster_print| poster_print.listings.create(price: poster_prices.sample) }
  sm_photo_prices = [50, 80, 100]
  Print.photos.small.each { |photo_print| photo_print.listings.create(price: sm_photo_prices.sample) }
  md_photo_prices = [100, 150, 200]
  Print.photos.medium.each { |photo_print| photo_print.listings.create(price: md_photo_prices.sample) }
  lg_photo_prices = [200, 500, 1000]
  Print.photos.large.each { |photo_print| photo_print.listings.create(price: lg_photo_prices.sample) }
  
  [depardon_1 ,depardon_2 ,erwitt_1 ,erwitt_2 ,gilden_1 ,gilden_2].each do |vintage_artwork|
    # Creating a unique print and a unique listing for each
    print = vintage_artwork.prints.create(serial_number: rand(500), format: Print::FORMATS.sample, vintage: true)
    print.listings.create(price: rand(2000..5000))
  end

  # Marking some random listings as sold
  Listing.limit(1000).order("RANDOM()").update_all(sold_at: 2.days.ago)
end

puts "Done!"