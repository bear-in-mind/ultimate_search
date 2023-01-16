class CreatePrints < ActiveRecord::Migration[7.0]
  def change
    create_table :prints do |t|
      t.integer :serial_number
      t.string :format
      t.references :artwork, null: false, foreign_key: true

      t.timestamps
    end
  end
end
