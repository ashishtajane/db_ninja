class User < ActiveRecord::Base
  has_many :projects
  has_many :collaborations , dependent: :destroy
  has_many :collaborating_projects, through: :collaborations, source: :project
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  validates :name, presence: true
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  #attr_accessible :title, :body
end
