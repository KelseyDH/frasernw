require 'app/services/form_data_matcher/specialist'
require 'lib/form_data/specialist'

RSpec.describe FormDataMatcher::Specialist do

form_data = {"utf8"=>"✓",
 "_method"=>"put",
 "authenticity_token"=>"rzhjQViVvkvlmWtqogMEJ71nX4MHnWNxXJUtTTI/wyQ=",
 "specialist"=>
  {"firstname"=>"asdgdsag",
   "lastname"=>"asdgasg",
   "goes_by_name"=>"",
   "sex_mask"=>"2",
   "billing_number"=>"23019",
   "categorization_mask"=>"1",
   "is_gp"=>"0",
   "specialization_ids"=>["1", ""],
   "specialist_offices_attributes"=>
    {"0"=>
      {"phone"=>"",
       "phone_extension"=>"",
       "fax"=>"",
       "direct_phone"=>"",
       "direct_phone_extension"=>"",
       "email"=>"",
       "public_email"=>"",
       "url"=>"",
       "office_id"=>"",
       "open_saturday"=>"0",
       "open_sunday"=>"0",
       "sector_mask"=>"1",
       "phone_schedule_attributes"=>{"id"=>"2197"},
       "id"=>"2182"},
     "1"=>
      {"phone"=>"asdgasdgsdg",
       "phone_extension"=>"",
       "fax"=>"asdgasdgsdg",
       "direct_phone"=>"asdgsdgadg",
       "direct_phone_extension"=>"",
       "email"=>"",
       "public_email"=>"",
       "url"=>"",
       "office_id"=>"1320",
       "open_saturday"=>"0",
       "open_sunday"=>"0",
       "sector_mask"=>"1",
       "phone_schedule_attributes"=>{"id"=>"2388"},
       "id"=>"2330"},
     "2"=>
      {"phone"=>"",
       "phone_extension"=>"",
       "fax"=>"",
       "direct_phone"=>"",
       "direct_phone_extension"=>"",
       "email"=>"",
       "public_email"=>"",
       "url"=>"",
       "office_id"=>"",
       "open_saturday"=>"0",
       "open_sunday"=>"0",
       "sector_mask"=>"1",
       "phone_schedule_attributes"=>{}
     }},
   "contact_name"=>"asdgasgsadg",
   "contact_email"=>"asdgsadgsdag",
   "contact_phone"=>"604-463-5334",
   "contact_notes"=>"",
   "status_mask"=>"1",
   "unavailable_from(1i)"=>"2012",
   "unavailable_from(2i)"=>"10",
   "unavailable_from(3i)"=>"22",
   "unavailable_to(1i)"=>"2012",
   "unavailable_to(2i)"=>"10",
   "unavailable_to(3i)"=>"2",
   "status_details"=>"asdgasg",
   "practise_limitations"=>"",
   "location_opened"=>"Prior to 2010",
   "language_ids"=>["1", ""],
   "interpreter_available"=>"0",
   "required_investigations"=>"All relevant x-rays (must be weight bearing), MRI, U/S and blood work.",
   "interest"=>"Knee and foot and ankle reconstruction.",
   "not_performed"=>"Back, hands, hips, shoulders, neck, wrists.",
   "referral_fax"=>"1",
   "referral_phone"=>"0",
   "referral_other_details"=>"",
   "referral_details"=>"",
   "referral_form_mask"=>"2",
   "lagtime_mask"=>"",
   "waittime_mask"=>"5",
   "respond_by_fax"=>"0",
   "respond_by_phone"=>"0",
   "respond_by_mail"=>"0",
   "respond_to_patient"=>"1",
   "patient_can_book_mask"=>"1",
   "red_flags"=>"Trauma, biceps and ACL tears, Achilles tendon rupture.",
   "urgent_fax"=>"0",
   "urgent_phone"=>"1",
   "urgent_other_details"=>"Follow-up fax of relevant patient information/studies",
   "urgent_details"=>"Please include radiographic results, previous consultations, list of medications, past medical history.",
   "patient_instructions"=>
    "Bring CareCard and list of current medications.  Bring orthotics/braces to office if you are using them, as well as typical shoes worn. For knee problems, wear or bring shorts. Ensure that you have had recent weight-bearing x-rays.",
   "cancellation_policy"=>"48 hours cancellation notice is required",
   "hospital_clinic_details"=>"",
   "hospital_ids"=>["4", ""],
   "clinic_location_ids"=>["149", ""],
   "admin_notes"=>""},
 "location_0"=>"Not used",
 "location_1"=>"In an office",
 "location_2"=>"Not used",
 "capacities_investigations"=>
  {"13793"=>"",
   "13853"=>"",
   "13823"=>"",
   "135"=>"Need standing AP both ankles on single film (include feet), + standing lateral (affected) foot and ankle, + mortise ankle ",
   "8306"=>"",
   "70"=>"",
   "136"=>"",
   "12"=>"",
   "137"=>"",
   "75"=>"",
   "76"=>"",
   "77"=>"",
   "138"=>"",
   "72"=>"",
   "73"=>"",
   "74"=>"",
   "35"=>"Need standing AP both feet on single film, + oblique and standing lateral of affected foot and ankle",
   "78"=>"",
   "139"=>"",
   "79"=>"",
   "80"=>"",
   "81"=>"",
   "88"=>"",
   "82"=>"",
   "26738"=>"",
   "83"=>"",
   "84"=>"",
   "6460"=>"Including trauma upper and lower extremity",
   "55"=>"",
   "56"=>"",
   "89"=>"Need standing AP both knees single film + lateral and skyline of affected knee",
   "140"=>"",
   "85"=>"/osteotomies",
   "86"=>"",
   "87"=>"",
   "4480"=>"",
   "95"=>"",
   "6433"=>"",
   "6406"=>"",
   "7929"=>"",
   "10088"=>"",
   "8016"=>"",
   "7987"=>"",
   "7958"=>"",
   "7900"=>"",
   "10058"=>"",
   "7871"=>"",
   "115"=>"",
   "141"=>"",
   "142"=>"",
   "150"=>"",
   "143"=>"",
   "144"=>"",
   "145"=>"",
   "121"=>"",
   "146"=>"",
   "6379"=>"",
   "147"=>"",
   "148"=>""},
 "capacities_mapped"=>
  {"135"=>"1",
   "8306"=>"1",
   "70"=>"1",
   "136"=>"1",
   "74"=>"1",
   "35"=>"1",
   "78"=>"1",
   "83"=>"1",
   "6460"=>"1",
   "55"=>"1",
   "89"=>"1",
   "140"=>"1",
   "85"=>"1",
   "86"=>"1",
   "87"=>"1",
   "4480"=>"1",
   "6433"=>"1",
   "144"=>"1"},
 "commit"=>"Update Specialist",
 "action"=>"update",
 "controller"=>"specialists",
 "id"=>"846"}


 ordered_specialist_offices = [
   OpenStruct.new(
     id: 2330
   ),
   OpenStruct.new(
     id: 2182
   ),
   OpenStruct.new(
     id: 3378
   ),
 ]

 specialist = OpenStruct.new(
   ordered_specialist_offices: ordered_specialist_offices
 )

 it "reorders the specialist office data to match the current order" do
   new_data = FormDataMatcher::Specialist.new(form_data, specialist).exec

   expect(new_data["specialist"]["specialist_offices_attributes"]["0"]["id"]).to eq(
     "2330"
   )
 end

 it "reorders the clinic location 'used' data to match the current order" do
   new_data = FormDataMatcher::Specialist.new(form_data, specialist).exec

   expect(new_data["location_0"]).to eq(
    "In an office"
   )
 end
end
