class Project < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations , dependent: :destroy
  has_many :collaborating_users, through: :collaborations, source: :user
  has_many :project_models
  has_many :entities
  validates :name, presence: true
  validates :host, presence: true
  validates :adapter, presence: true
  validates :dbusername, presence: true
  validates :dbname , presence: true
  attr_accessible :name, :description, :dbusername, :adapter ,:host,:user_id ,:dbname
end
