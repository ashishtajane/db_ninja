class AddColumnToFields < ActiveRecord::Migration
  def change
    add_column :fields, :entity_id, :integer
  end
end
