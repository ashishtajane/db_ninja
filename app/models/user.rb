class User < ActiveRecord::Base
  has_many :projects
  has_many :collaborations , dependent: :destroy
  has_many :collaborating_projects, through: :collaborations, source: :project
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me ,:admin
end
