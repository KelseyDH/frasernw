class Hospital < ActiveRecord::Base
  attr_accessible :name, :phone, :fax, :location_attributes, :address_attributes
  has_paper_trail
  
  has_many :privileges, :dependent => :destroy
  has_many :specialists, :through => :privileges
  
  has_many :clinics, :finder_sql => proc { "SELECT DISTINCT c.* FROM clinics c JOIN clinic_addresses ca ON c.id = ca.clinic_id JOIN addresses a ON ca.address_id = a.id WHERE a.hospital_id = #{self.id} ORDER BY c.name ASC" }
  
  has_many :specialist_offices, :finder_sql => proc { "SELECT DISTINCT s.* FROM specialists s JOIN specialist_addresses sa ON s.id = sa.specialist_id JOIN addresses a ON sa.address_id = a.id WHERE a.hospital_id = #{self.id} ORDER BY s.lastname ASC, s.firstname ASC" }, :class_name => "Specialist"
  
  #hospitals have an address
  has_one :location, :as => :locatable
  has_one :address, :through => :location
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :address
  
  default_scope order('name')
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  
  def phone_and_fax
    if phone.present? and fax.present?
      return "#{phone}, Fax: #{fax}"
    elsif phone.present?
      return "#{phone}"
    elsif fax.present?
      return "Fax: #{fax}"
    else
      return ""
    end
  end
  
  def city
    l = location
    return "" if l.blank?
    #hospitals can't be in anything, no need to resolve_address
    a = location.address
    return "" if a.blank?
    c = a.city
    c.present? ? c.name : ""
  end
end
