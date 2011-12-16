class Procedure < ActiveRecord::Base
  attr_accessible :name, :specialization_id, :specialization_level, :parent_id
  has_paper_trail
  has_ancestry

  has_many :capacities
  has_many :specialists, :through => :capacities
  
  has_many :focuses
  has_many :clinics, :through => :focuses
  
  belongs_to :specialization

  validates_presence_of :specialization_id, :on => :save, :message => "can't be blank"
  validates_presence_of :name, :on => :save, :message => "can't be blank"
  
  def to_s
    self.name
  end

end
