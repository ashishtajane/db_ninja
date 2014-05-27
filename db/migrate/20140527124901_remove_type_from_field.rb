class RemoveTypeFromField < ActiveRecord::Migration
  def change
    remove_column :fields, :type, :integer
  end
end
