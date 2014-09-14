class SpecializationOption < ActiveRecord::Base
  attr_accessible :specialization, :owner, :content_owner, :division, :in_progress, :is_new, :open_to_clinic_tab_old, :open_to_type, :open_to_sc_category
  
  belongs_to :specialization
  belongs_to :owner, :class_name => "User"
  belongs_to :content_owner, :class_name => "User"
  belongs_to :division
  belongs_to :open_to_sc_category, :class_name => "User"
  
  def self.for_divisions(divisions)
    division_ids = divisions.map{ |d| d.id }
    where("specialization_options.division_id IN (?)", division_ids)
  end
  
  def self.for_divisions_and_specializations(divisions, specializations)
    division_ids = divisions.map{ |d| d.id }
    specialization_ids = specializations.map{ |s| s.id }
    where("specialization_options.division_id IN (?) AND specialization_options.specialization_id IN (?)", division_ids, specialization_ids)
  end

  def self.not_in_progress_for_divisions_and_specializations(divisions, specializations)
    division_ids = divisions.map{ |d| d.id }
    specialization_ids = specializations.map{ |s| s.id }
    where("specialization_options.division_id IN (?) AND specialization_options.specialization_id IN (?) and in_progress = (?)", division_ids, specialization_ids, false)
  end

  def self.is_new
    where("specialization_options.is_new = (?)", true)
  end

  OPEN_TO_SPECIALISTS = 1
  OPEN_TO_CLINICS = 2
  OPEN_TO_CONTENT_CATEGORY = 3

  OPEN_TO_HASH = {
    OPEN_TO_SPECIALISTS => "Specialists",
    OPEN_TO_CLINICS => "Clinics",
    OPEN_TO_CONTENT_CATEGORY => "Content Category"
  }

  has_paper_trail
end
