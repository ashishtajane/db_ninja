class Entity < ActiveRecord::Base
  belongs_to :project
  has_many :fields , dependent: :destroy
  validates :table_name ,presence: true
  validates :model_name ,presence: true
  validates :project_id, uniqueness: { scope: :table_name,message: "Already Present" }
  validates :project_id, uniqueness: { scope: :model_name,message: "Already Present" }
  attr_accessible :project_id, :model_name, :table_name
end
