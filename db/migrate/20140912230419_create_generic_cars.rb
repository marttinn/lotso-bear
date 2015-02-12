class CreateGenericCars < ActiveRecord::Migration
  def change
    create_table :generic_cars do |t|
      t.string :brand_id
      t.string :model
      t.integer :doors_id
      t.integer :first_generation_year
      t.integer :last_generation_year
      t.string :code
      t.string :number_of_generation


      t.timestamps
    end
  end
end
