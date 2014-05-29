class AddDbnameToProject < ActiveRecord::Migration
  def change
    add_column :projects, :dbname, :string
  end
end
