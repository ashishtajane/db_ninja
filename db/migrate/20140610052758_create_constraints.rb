class CreateConstraints < ActiveRecord::Migration
  def change
    create_table :constraints do |t|
      t.string :sql_syntax
      t.string :display_content
      t.integer :function_type
      t.integer :function_return_type

      t.timestamps
    end
  end
end
