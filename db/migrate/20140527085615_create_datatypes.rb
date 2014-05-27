class CreateDatatypes < ActiveRecord::Migration
  def change
    create_table :datatypes do |t|
      t.string :name
      t.integer :arg

      t.timestamps
    end
  end
end
