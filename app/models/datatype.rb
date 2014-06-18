class Datatype < ActiveRecord::Base
  attr_accessible :name , :arg,:function_return_type_id
  belongs_to :function_return_type
end
