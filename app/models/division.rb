class Division < ActiveRecord::Base
  
  attr_accessible :name, :city_ids, :shared_sc_item_ids, :primary_contact_id, :division_primary_contacts_attributes
   
  has_many :division_cities, :dependent => :destroy

  has_many :cities, :through => :division_cities
  has_many :division_referral_cities, :dependent => :destroy
  
  # # returns all cities in division's local referral area
  # e.g. returns true:  d.referral_cities === d.division_referral_cities.map{|drc| drc.city}
  has_many :referral_cities, through: :division_referral_cities, source: :city

  has_many :division_referral_city_specializations, :through => :division_referral_cities
  
  has_many :division_users, :dependent => :destroy
  has_many :users, :through => :division_users
  
  has_many :division_display_sc_items, :dependent => :destroy
  has_many :shared_sc_items, :through => :division_display_sc_items, :source => "sc_item", :class_name => "ScItem"
  
  has_many :division_primary_contacts, :dependent => :destroy
  has_many :primary_contacts, :through => :division_primary_contacts, :class_name => "User"
  accepts_nested_attributes_for :division_primary_contacts, :allow_destroy => true
  
  has_many :specialization_options, :dependent => :destroy
  
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
