class Division < ActiveRecord::Base
  
  attr_accessible :name, :city_ids
   
  has_many :division_cities, :dependent => :destroy
  has_many :cities, :through => :division_cities
  
  has_many :division_referral_cities, :dependent => :destroy
  has_many :division_referral_city_specializations, :through => :division_referral_cities
  
  has_many :division_users, :dependent => :destroy
  has_many :users, :through => :division_users
  
  has_paper_trail
  
  default_scope order('divisions.name')
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  
  def to_s
    self.name
  end
  
  def local_referral_cities_for_specialization(specialization)
    refined_cities = division_referral_city_specializations.reject{ |drcs| drcs.specialization_id != specialization.id }.map{ |drcs| drcs.division_referral_city.city }
    if refined_cities.present?
      #division has overriden this specialty
      return refined_cities
    else
      #division has not overriden this specialty
      return cities
    end
  end
end
