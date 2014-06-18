class Constraint < ActiveRecord::Base
  has_many :arguments
  belongs_to :function_return_type
  validates :sql_syntax, presence: true ,uniqueness: true
  validates :display_content, presence: true


  attr_accessible :display_content,:function_type,:sql_syntax,:function_return_type_id
end
