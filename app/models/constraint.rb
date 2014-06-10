class Constraint < ActiveRecord::Base
  has_many :arguments
  belongs_to :function_return_type
  attr_accessible :display_content,:function_type,:sql_syntax,:function_return_type_id
end
