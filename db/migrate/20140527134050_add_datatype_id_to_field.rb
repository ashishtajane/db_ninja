class AddDatatypeIdToField < ActiveRecord::Migration
  def change
    add_column :fields, :datatype_id, :integer
  end
end
