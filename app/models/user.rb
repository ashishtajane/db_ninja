class User < ActiveRecord::Base
  has_many :projects
  has_many :collaborators , dependent: :destroy
  has_many :involved_projects, through: :collaborators, source: :project
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  #attr_accessible :title, :body
end
