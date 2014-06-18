class RemoveTypeArg1FromField < ActiveRecord::Migration
  def change
    remove_column :fields, :type_arg1, :integer
  end
end
