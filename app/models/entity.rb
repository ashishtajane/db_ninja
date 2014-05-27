class Entity < ActiveRecord::Base
  belongs_to :project
  has_many :fields
  validates :project_id, uniqueness: { scope: :table_name,message: "Already Present" }
  validates :project_id, uniqueness: { scope: :model_name,message: "Already Present" }
  attr_accessible :project_id, :model_name, :table_name
end
