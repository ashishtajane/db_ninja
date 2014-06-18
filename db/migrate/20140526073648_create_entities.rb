class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.integer :project_id
      t.string :model_name
      t.string :table_name

      t.timestamps
    end
  end
end
