class AddTypeArg1ToField < ActiveRecord::Migration
  def change
    add_column :fields, :type_arg1, :string
  end
end
