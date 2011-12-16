class Procedure < ActiveRecord::Base
  attr_accessible :name, :specialization_id, :done_by_specialists, :done_by_clinics, :specialization_level, :parent_id
  has_paper_trail
  has_ancestry

  has_many :capacities
  has_many :specialists, :through => :capacities
  
  has_many :focuses
  has_many :clinics, :through => :focuses
  
  belongs_to :specialization

  default_scope :order => 'name ASC'

  validates_presence_of :specialization_id, :on => :save, :message => "can't be blank"
  validates_presence_of :name, :on => :save, :message => "can't be blank"

  scope :done_by_specialists, where(:done_by_specialists  => true)
  
  def to_s
    self.name
  end

end
