class Field < ActiveRecord::Base
  has_one :datatype
	belongs_to :entity
end
