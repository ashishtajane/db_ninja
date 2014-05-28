class Collaboration < ActiveRecord::Base
  belongs_to :project , class_name: "Project"
  belongs_to :user , class_name: "User"
  attr_accessible :project_id , :user_id
  validates :user_id, uniqueness: { scope: :project_id,message: "Already Added" }
end
