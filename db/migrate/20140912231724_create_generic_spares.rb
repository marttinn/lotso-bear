class CreateGenericSpares < ActiveRecord::Migration
  def change
    create_table :generic_spares do |t|
      t.string :brand
      t.string :type
      t.string :name
      t.string :region
      t.text :description

      t.timestamps
    end
  end
end