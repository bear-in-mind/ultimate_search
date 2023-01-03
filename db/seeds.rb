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
end

def create_photo(name, filename, tags)
  artwork = Artwork.create!(
    name: name,
    category: "photography",
    author: "Louis Sommer",
    year: (2010..2022).to_a.sample,
    tags: tags
  )
  file = File.open(Rails.root.join("artworks", "#{filename}.jpg"))
  artwork.cover_image.attach(io: file, filename: file.path)
end

Artwork.destroy_all
Print.destroy_all
Listing.destroy_all

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

# Creating prints
Artwork.transaction do
  Artwork.posters.each do |poster|
    100.times {|index| poster.prints.create!(serial_number: index + 1, format: "50x60") }
  end
  Artwork.photos.each do |photo|
    10.times {|index| photo.prints.create!(serial_number: index + 1, format: "50x60") }
    large_price = rand(200..300) 
    rand(20).times { photo.prints.listings.create(price: rand(30..60)) }
    50.times {|index| photo.prints.create!(serial_number: index + 1, format: "30x40") }
    100.times {|index| photo.prints.create!(serial_number: index + 1, format: "18x24") }
  end
end

puts "Done!"