class Collaboration < ActiveRecord::Base
	belongs_to :project , class_name: "Project"
	belongs_to :user , class_name: "User"
	attr_accessible :project_id , :user_id
end
