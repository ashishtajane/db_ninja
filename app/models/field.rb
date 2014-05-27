class Field < ActiveRecord::Base
  has_one :datatype
	belongs_to :entity
  validates :name, presence: true
  validates :null_value , presence: true
  validate :type_check
  validates :entity_id, presence: true
  attr_accessible :name, :default, :null_value , :entity_id , :datatype_id , :type_arg1 , :type_arg2



  def type_check
    db = Datatype.find(self.datatype_id)
    if db.arg == 1
      db.type_arg1.present?
    elsif db.arg==2
      db.type_arg1.present? && db.type_arg2.present?
    end
  end
end
