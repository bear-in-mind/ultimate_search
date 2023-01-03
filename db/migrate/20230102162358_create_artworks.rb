class CreateArtworks < ActiveRecord::Migration[7.0]
  def change
    create_table :artworks do |t|
      t.string :name
      t.string :author
      t.string :category
      t.integer :year
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
