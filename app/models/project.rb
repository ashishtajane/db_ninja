class Project < ActiveRecord::Base
	belongs_to :user
	has_many :collaborators , dependent: :destroy
	has_many :collaborating_users, through: :collaborators, source: :user
	has_many :project_models
	#has_many :helping_users , through: :accesss, source: :project 
	attr_accessible :name, :description, :dbpassword, :dbusername, :adapter ,:host
end
