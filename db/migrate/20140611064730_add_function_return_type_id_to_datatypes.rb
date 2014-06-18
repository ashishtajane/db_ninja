class AddFunctionReturnTypeIdToDatatypes < ActiveRecord::Migration
  def change
    add_column :datatypes, :function_return_type_id, :integer
  end
end
