class RemoveDatatypeFromField < ActiveRecord::Migration
  def change
    remove_column :fields, :datatype, :integer
  end
end
