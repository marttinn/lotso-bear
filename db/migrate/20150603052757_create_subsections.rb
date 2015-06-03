class CreateSubsections < ActiveRecord::Migration
  def change
    create_table :subsections do |t|
      t.string :code
      t.integer :section_id

      t.timestamps
    end
  end
end
