class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.string :host
      t.string :adapter
      t.string :dbusername
      t.string :dbpassword

      t.timestamps
    end
  end
end
