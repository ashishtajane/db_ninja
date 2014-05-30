class Field < ActiveRecord::Base
  has_one :datatype
  belongs_to :entity
  validates :name, presence: true
  validates :null_value , :inclusion => {:in => [true, false]}
  validate :type_check
  validates :entity_id, presence: true
  validates :entity_id, uniqueness: { scope: :name,message: "Already Present" }

  attr_accessible :name, :default, :null_value , :entity_id , :datatype_id , :type_arg1 , :type_arg2



  def type_check
    db = Datatype.find(self.datatype_id)
    if db.arg == 1
      !(self.type_arg1.empty?)
    elsif db.arg == 2
      !(self.type_arg1.empty?) && !(self.type_arg2.empty?)
    else
      true
    end
  end
end
