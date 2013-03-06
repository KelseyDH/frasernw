class Specialization < ActiveRecord::Base
  attr_accessible :name, :member_name, :in_progress, :specialization_options_attributes, :open_to_clinic
  has_paper_trail :ignore => :saved_token
  
  has_many :specialist_specializations, :dependent => :destroy
  has_many :specialists, :through => :specialist_specializations
  
  has_many :clinic_specializations, :dependent => :destroy
  has_many :clinics, :through => :clinic_specializations
  
  has_many :procedure_specializations, :dependent => :destroy, :conditions => { "mapped" => true }
  has_many :procedures, :through => :procedure_specializations, :order => 'name ASC'
  
  has_many :sc_items_specializations, :dependent => :destroy
  has_many :sc_items, :through => :sc_items_specializations
  
  has_many :specialization_options, :dependent => :destroy
  accepts_nested_attributes_for :specialization_options
  has_many :owners, :through => :specialization_options, :class_name => "User"
  
  default_scope order('specializations.name')
  
  def self.in_progress_for_divisions(divisions)
    division_ids = divisions.map{ |d| d.id }
    joins(:specialization_options).where('"specialization_options"."division_id" IN (?) AND "specialization_options"."in_progress" = (?)', division_ids, true)
  end
    
  def self.not_in_progress_for_divisions(divisions)
    division_ids = divisions.map{ |d| d.id }
    joins(:specialization_options).where('"specialization_options"."division_id" IN (?) AND "specialization_options"."in_progress" = (?)', division_ids, false)
  end
    
  def self.new_for_divisions(divisions)
    division_ids = divisions.map{ |d| d.id }
    joins(:specialization_options).where('"specialization_options"."division_id" IN (?) AND "specialization_options"."is_new" = (?)', division_ids, true)
  end
  
  def not_fully_in_progress
    specialization_options.reject{ |so| so.in_progress }.length > 0
  end
  
  def fully_in_progress
    specialization_options.reject{ |so| so.in_progress }.length == 0
  end

  def fully_in_progress_for_divisions(divisions)
    (specialization_options.for_divisions(divisions).length > 0) && (specialization_options.for_divisions(divisions).reject{ |so| so.in_progress }.length == 0)
  end
    
  def new_for_divisions(divisions)
    specialization_options.for_divisions(divisions).is_new.length > 0
  end

  def open_to_clinic_tab_for_divisions(divisions)
    #start at clinic tab if all divisions passed in want this. not necessarily 'correct', but the best we can do
    specialization_options.for_divisions(divisions).reject{ |so| so.open_to_clinic_tab }.length == 0
  end
  
  def procedure_specializations_arranged
    return procedure_specializations.arrange(:joins => "JOIN procedures ON procedure_specializations.procedure_id = procedures.id", :conditions => "procedure_specializations.specialization_id = #{self.id} AND procedure_specializations.mapped = 't'", :order => "procedures.name")
  end
  
  def focused_procedure_specializations_arranged
    return procedure_specializations.focused.arrange(:joins => "JOIN procedures ON procedure_specializations.procedure_id = procedures.id", :conditions => "procedure_specializations.specialization_id = #{self.id} AND procedure_specializations.mapped = 't'", :order => "procedures.name")
  end
  
  def non_focused_procedure_specializations_arranged
    return procedure_specializations.non_focused.arrange(:joins => "JOIN procedures ON procedure_specializations.procedure_id = procedures.id", :conditions => "procedure_specializations.specialization_id = #{self.id} AND procedure_specializations.mapped = 't'", :order => "procedures.name")
  end
  
  def assumed_procedure_specializations_arranged
    return procedure_specializations.assumed.arrange(:joins => "JOIN procedures ON procedure_specializations.procedure_id = procedures.id", :conditions => "procedure_specializations.specialization_id = #{self.id} AND procedure_specializations.mapped = 't'", :order => "procedures.name")
  end
  
  def non_assumed_procedure_specializations_arranged
    return procedure_specializations.non_assumed.arrange(:joins => "JOIN procedures ON procedure_specializations.procedure_id = procedures.id", :conditions => "procedure_specializations.specialization_id = #{self.id} AND procedure_specializations.mapped = 't'", :order => "procedures.name")
  end

  def token
    if self.saved_token
      return self.saved_token
    else
      update_column(:saved_token, SecureRandom.hex(16)) #avoid callbacks / validation as we don't want to trigger a sweeper for this
      return self.saved_token
    end
  end

end

