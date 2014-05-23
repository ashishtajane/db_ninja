class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :project_id
      t.integer :collaboration_id

      t.timestamps
    end
  end
end
