class RemoveTypeArg2FromField < ActiveRecord::Migration
  def change
    remove_column :fields, :type_arg2, :integer
  end
end
