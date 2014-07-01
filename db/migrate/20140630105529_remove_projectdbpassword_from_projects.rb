class RemoveProjectdbpasswordFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :dbpassword, :string
  end
end
