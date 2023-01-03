class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.integer :price
      t.references :print, null: false, foreign_key: true

      t.timestamps
    end
  end
end
