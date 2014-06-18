class Argument < ActiveRecord::Base
  self.inheritance_column = 'type_column_name'
  belongs_to :constraint
  attr_accessible :name,:type,:constraint_id
end
