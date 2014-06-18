class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.string :name
      t.integer :type
      t.integer :constraint_id

      t.timestamps
    end
  end
end
