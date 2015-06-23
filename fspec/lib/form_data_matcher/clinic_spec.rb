require 'lib/form_data_matcher/clinic'

RSpec.describe FormDataMatcher::Clinic do
  form_data = {"utf8"=>"✓",
  "_method"=>"put",
  "authenticity_token"=>"bHQJqDUTjHOVzjOP0dXKenRK3dRYQ2+Y1SWy2xBgMTw=",
  "clinic"=>
   {"name"=>"asdgasgdsagasggas",
    "categorization_mask"=>"1",
    "specialization_ids"=>["22", ""],
    "clinic_locations_attributes"=>
     {"0"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4698"},
      "1"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4697"},
      "2"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4696"},
      "3"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4695"},
      "4"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4694"},
      "5"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4693"},
      "6"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4692"},
      "7"=>
       {"phone"=>"",
        "phone_extension"=>"",
        "fax"=>"",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"",
        "location_attributes"=>"",
        "location_opened"=>"",
        "sector_mask"=>"4",
        "wheelchair_accessible_mask"=>"3",
        "schedule_attributes"=>"",
        "id"=>"4691"},
      "8"=>
       {"phone"=>"asdgasgd0",
        "phone_extension"=>"",
        "fax"=>"asdgasgsdgasd",
        "contact_details"=>"",
        "email"=>"",
        "public_email"=>"",
        "url"=>"asdgasdgdsagasdgd",
        "location_attributes"=>"",
        "location_opened"=>"Prior to 2010",
        "sector_mask"=>"1",
        "wheelchair_accessible_mask"=>"1",
        "schedule_attributes"=>"",
        "id"=>"4690"},
      "9"=>
       {"attendances_attributes"=>
         {"1427317181821"=>
           {"is_specialist"=>"0", "specialist_id"=>"", "freeform_firstname"=>"asdgasgdsagasdg", "area_of_focus"=>"asdgasgasgd", "_destroy"=>"false"}},
        "id"=>"4690"}},
    "contact_name"=>"asdgasdgdasg",
    "contact_email"=>"asdgdas",
    "contact_phone"=>"asdgsagdas",
    "contact_notes"=>"asdgsagdasg",
    "status_mask"=>"1",
    "unavailable_from(1i)"=>"2015",
    "unavailable_from(2i)"=>"3",
    "unavailable_from(3i)"=>"25",
    "status_details"=>
     "sadgasdgasd",
    "language_ids"=>["1", ""],
    "interpreter_available"=>"1",
    "required_investigations"=>"",
    "not_performed"=>"",
    "referral_fax"=>"1",
    "referral_phone"=>"1",
    "referral_other_details"=>"",
    "referral_details"=>"",
    "referral_form_mask"=>"2",
    "lagtime_mask"=>"1",
    "waittime_mask"=>"1",
    "respond_by_fax"=>"0",
    "respond_by_phone"=>"0",
    "respond_by_mail"=>"0",
    "respond_to_patient"=>"1",
    "patient_can_book_mask"=>"3",
    "red_flags"=>"",
    "urgent_fax"=>"0",
    "urgent_phone"=>"0",
    "urgent_other_details"=>"",
    "urgent_details"=>"",
    "patient_instructions"=>"asdgasgsag",
    "cancellation_policy"=>"",
    "healthcare_provider_ids"=>["2", ""],
    "admin_notes"=>"MH entered 03/25/15",
    "procedure_ids"=>[]},
  "clinic_location_0"=>"Not used",
  "clinic_location_1"=>"Not used",
  "clinic_location_2"=>"Not used",
  "clinic_location_3"=>"Not used",
  "clinic_location_4"=>"Not used",
  "clinic_location_5"=>"Not used",
  "clinic_location_6"=>"Not used",
  "clinic_location_7"=>"Not used",
  "clinic_location_8"=>"In a hospital",
  "focuses_investigations"=>
   {"1230"=>"",
    "1005"=>"",
    "969"=>"",
    "1194"=>"",
    "25495"=>"",
    "6747"=>"",
    "2146"=>"",
    "987"=>"",
    "915"=>"",
    "951"=>"",
    "22696"=>"",
    "25548"=>"",
    "9847"=>"",
    "13473"=>"",
    "1041"=>"",
    "26613"=>"",
    "19219"=>"",
    "2125"=>"",
    "1266"=>"",
    "1077"=>"",
    "1023"=>"",
    "897"=>"",
    "1158"=>"",
    "933"=>"",
    "1212"=>"",
    "1059"=>"",
    "26977"=>"",
    "14866"=>""},
  "focuses_mapped"=>{"2146"=>"1", "951"=>"1", "2125"=>"1"},
  "commit"=>"Update Clinic",
  "action"=>"update",
  "controller"=>"clinics",
  "id"=>"756"}

  ordered_clinic_locations = (4690..4698).map do |n|
    OpenStruct.new(
      id: n
    )
  end

  clinic = OpenStruct.new(
    ordered_clinic_locations: ordered_clinic_locations
  )

  it "reorders the clinic location data to match the current order" do
    new_data = FormDataMatcher::Clinic.new(form_data, clinic).exec

    expect(new_data["clinic"]["clinic_locations_attributes"]["0"]["id"]).to eq(
      "4690"
    )
  end

  it "reorders the clinic location 'used' data to match the current order" do
    new_data = FormDataMatcher::Clinic.new(form_data, clinic).exec

    expect(new_data["clinic_location_0"]).to eq(
      "In a hospital"
    )
  end
end
