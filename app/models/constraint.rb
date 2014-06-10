class Constraint < ActiveRecord::Base
  has_many :arguements
  has_one :function_return_type
end
