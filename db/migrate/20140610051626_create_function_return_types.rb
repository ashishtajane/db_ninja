class CreateFunctionReturnTypes < ActiveRecord::Migration
  def change
    create_table :function_return_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
