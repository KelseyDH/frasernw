class HealthcareProvider < ActiveRecord::Base
  attr_accessible :name
  has_paper_trail
  
  has_many :clinic_healthcare_provider, :dependent => :destroy
  has_many :clinics, :through => :clinic_healthcare_provider
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
end
