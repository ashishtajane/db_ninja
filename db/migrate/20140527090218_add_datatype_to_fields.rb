class AddDatatypeToFields < ActiveRecord::Migration
  def change
    add_column :fields, :datatype, :integer
  end
end
