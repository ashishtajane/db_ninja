class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.integer :type
      t.integer :type_arg1
      t.integer :type_arg2
      t.boolean :null_value
      t.string :default

      t.timestamps
    end
  end
end
