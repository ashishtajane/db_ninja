class AddTypeArg2ToField < ActiveRecord::Migration
  def change
    add_column :fields, :type_arg2, :string
  end
end
