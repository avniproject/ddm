set role ddm;
-- ----------------------------------------------------
drop view if exists ddm_record_poclain_details;
create or replace view ddm_record_poclain_details as (
  SELECT individual.uuid                                                                    "Ind.uuid",
         individual.id                                                                      "Ind.id",
         individual.address_id                                                              "Ind.address_id",
         individual.first_name                                                              "Ind.first_name",
         individual.last_name                                                               "Ind.last_name",
         g.name                                                                             "Ind.Gender",
         individual.date_of_birth                                                           "Ind.date_of_birth",
         individual.date_of_birth_verified                                                  "Ind.date_of_birth_verified",
         individual.registration_date                                                       "Ind.registration_date",
         individual.facility_id                                                             "Ind.facility_id",
         a.title                                                                            "Ind.Area",
         c2.name                                                                            "Ind.Catchment",
         individual.is_voided                                                               "Ind.is_voided",
         op.name                                                                            "Enl.Program Name",
         programEnrolment.uuid                                                              "Enl.uuid",
         programEnrolment.observations ->> concept_uuid('NGO')                           as "Enl.NGO",
         programEnrolment.is_voided                                                         "Enl.is_voided",
         oet.name                                                                           "Enc.Type",
         programEncounter.earliest_visit_date_time                                          "Enc.earliest_visit_date_time",
         programEncounter.id                                                                "Enc.Id",
         programEnrolment.id                                                                "Enl.Id",
         programEncounter.encounter_date_time                                               "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                              "Enc.program_enrolment_id",
         programEncounter.uuid                                                              "Enc.uuid",
         programEncounter.name                                                              "Enc.name",
         programEncounter.max_visit_date_time                                               "Enc.max_visit_date_time",
         programEncounter.is_voided                                                         "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1') :: TEXT as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398' :: TEXT                                  as "Enl.Silt Estimation as per work plan",
         programEncounter.observations ->>
         'faf5b0b2-64ef-4954-999a-b034dbe98390' :: TEXT                                  as "Enc.Number of tractor trips",
         programEncounter.observations ->>
         '44a48cdc-4e79-4f61-acb1-f131ed07fc2c' :: TEXT                                  as "Enc.Quantity of silt removed",
         programEncounter.observations ->>
         '42acf4ee-33bd-4628-b961-d3b6e5c457cc' :: TEXT                                  as "Enc.Diesel input quantity",
         programEncounter.observations ->>
         '3acb5cd4-c25e-41f7-b558-90fd41103e05' :: TEXT                                  as "Enc.Registration number",
         programEncounter.observations ->>
         '26770597-963b-4870-862b-3479d27aadb5' :: TEXT                                  as "Enc.Amount of work done",
         programEncounter.observations ->>
         'de002f36-a76f-4ca7-ba5f-91fa84946125' :: TEXT                                  as "Enc.Working hours",
         programEncounter.observations ->>
         '61f4edbc-d486-4d32-a714-b144c2fe527a' :: TEXT                                  as "Enc.Number of hywa trips",
         programEncounter.cancel_date_time                                                  "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet
                         on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op
                         ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual
                         ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT OUTER JOIN address_level a
                         ON individual.address_id = a.id
         LEFT OUTER JOIN catchment_address_mapping m2
                         ON a.id = m2.addresslevel_id
         LEFT OUTER JOIN catchment c2 ON m2.catchment_id = c2.id
  WHERE c2.name not ilike '%master%'
    AND op.uuid = '1f961272-faf4-4f99-ba0d-331d15622092'
    AND oet.uuid = '4c95ddd1-f59f-4b9b-be36-854031117176'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL);

drop view if exists ddm_record_jcb_details;
create or replace view ddm_record_jcb_details as (
  SELECT individual.uuid                                                                    "Ind.uuid",
         individual.address_id                                                              "Ind.address_id",
         individual.first_name                                                              "Ind.first_name",
         individual.last_name                                                               "Ind.last_name",
         g.name                                                                             "Ind.Gender",
         individual.date_of_birth                                                           "Ind.date_of_birth",
         individual.date_of_birth_verified                                                  "Ind.date_of_birth_verified",
         individual.registration_date                                                       "Ind.registration_date",
         individual.facility_id                                                             "Ind.facility_id",
         a.title                                                                            "Ind.Area",
         c2.name                                                                            "Ind.Catchment",
         individual.is_voided                                                               "Ind.is_voided",
         op.name                                                                            "Enl.Program Name",
         programEnrolment.uuid                                                              "Enl.uuid",
         programEnrolment.id                                                                "Enl.id",
         programEnrolment.observations ->> concept_uuid('NGO')                           as "Enl.NGO",
         programEnrolment.is_voided                                                         "Enl.is_voided",
         programEncounter.id                                                                "Enc.Id",
         oet.name                                                                           "Enc.Type",
         programEncounter.earliest_visit_date_time                                          "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                               "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                              "Enc.program_enrolment_id",
         programEncounter.uuid                                                              "Enc.uuid",
         programEncounter.name                                                              "Enc.name",
         programEncounter.max_visit_date_time                                               "Enc.max_visit_date_time",
         programEncounter.is_voided                                                         "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1') :: TEXT as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398' :: TEXT                                  as "Enl.Silt Estimation as per work plan",
         programEncounter.observations ->>
         'faf5b0b2-64ef-4954-999a-b034dbe98390' :: TEXT                                  as "Enc.Number of tractor trips",
         programEncounter.observations ->>
         '44a48cdc-4e79-4f61-acb1-f131ed07fc2c' :: TEXT                                  as "Enc.Quantity of silt removed",
         programEncounter.observations ->>
         '42acf4ee-33bd-4628-b961-d3b6e5c457cc' :: TEXT                                  as "Enc.Diesel input quantity",
         programEncounter.observations ->>
         '3acb5cd4-c25e-41f7-b558-90fd41103e05' :: TEXT                                  as "Enc.Registration number",
         programEncounter.observations ->>
         '26770597-963b-4870-862b-3479d27aadb5' :: TEXT                                  as "Enc.Amount of work done",
         programEncounter.observations ->>
         'de002f36-a76f-4ca7-ba5f-91fa84946125' :: TEXT                                  as "Enc.Working hours",
         programEncounter.observations ->>
         '61f4edbc-d486-4d32-a714-b144c2fe527a' :: TEXT                                  as "Enc.Number of hywa trips",
         programEncounter.cancel_date_time                                                  "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet
                         on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op
                         ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual
                         ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT OUTER JOIN address_level a ON individual.address_id = a.id
         LEFT OUTER JOIN catchment_address_mapping m2
                         ON a.id = m2.addresslevel_id
         LEFT OUTER JOIN catchment c2 ON m2.catchment_id = c2.id
  WHERE c2.name not ilike '%master%'
    AND op.uuid = '1f961272-faf4-4f99-ba0d-331d15622092'
    AND oet.uuid = 'b92e9835-7b31-4f99-a438-a5564f1ef109'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL);

drop view if exists ddm_baseline_survey;
create or replace view ddm_baseline_survey as (
  SELECT individual.id                                                                      "Ind.Id",
         individual.address_id                                                              "Ind.address_id",
         individual.uuid                                                                    "Ind.uuid",
         individual.first_name                                                              "Ind.first_name",
         individual.last_name                                                               "Ind.last_name",
         g.name                                                                             "Ind.Gender",
         individual.date_of_birth                                                           "Ind.date_of_birth",
         individual.date_of_birth_verified                                                  "Ind.date_of_birth_verified",
         individual.registration_date                                                       "Ind.registration_date",
         individual.facility_id                                                             "Ind.facility_id",
         a.title                                                                            "Ind.Area",
         c2.name                                                                            "Ind.Catchment",
         individual.is_voided                                                               "Ind.is_voided",
         op.name                                                                            "Enl.Program Name",
         programEnrolment.uuid                                                              "Enl.uuid",
         programEnrolment.is_voided                                                         "Enl.is_voided",
         oet.name                                                                           "Enc.Type",
         programEncounter.id                                                                "Enc.Id",
         programEncounter.earliest_visit_date_time                                          "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                               "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                              "Enc.program_enrolment_id",
         programEncounter.uuid                                                              "Enc.uuid",
         programEncounter.name                                                              "Enc.name",
         programEncounter.max_visit_date_time                                               "Enc.max_visit_date_time",
         programEncounter.is_voided                                                         "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1') :: TEXT as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                    as "Enl.Silt Estimation as per work plan",
         programEnrolment.observations ->> '86a3a3e1-1b59-40a0-aa6c-f2f5bc9c0765'::TEXT  as "Enl.NGO",
         programEncounter.observations ->> '37dbe8cd-bf94-451d-8908-ea536f3be512'::TEXT  as "Enc.Video",
         programEncounter.observations ->> 'b38cd08c-de01-434d-9704-6a4c830e6d3e'::TEXT  as "Enc.Image 1",
         programEncounter.observations ->> '3bfb1fb4-710d-4cf1-93bb-3ec1aec66d53'::TEXT  as "Enc.Image 2",
         programEncounter.observations ->>
         '4dd9914e-e39a-4ca3-8180-b939d6b5e1fa'::TEXT                                    as "Enc.Silt estimation as per technical sanction",
         programEncounter.cancel_date_time                                                  "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet
                         on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op
                         ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual
                         ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT OUTER JOIN address_level a ON individual.address_id = a.id
         LEFT OUTER JOIN catchment_address_mapping m2
                         ON a.id = m2.addresslevel_id
         LEFT OUTER JOIN catchment c2 ON m2.catchment_id = c2.id
  WHERE c2.name not ilike '%master%'
    AND op.uuid = '1f961272-faf4-4f99-ba0d-331d15622092'
    AND oet.uuid = 'b8352fb5-02be-405e-b178-b94c1581a8f7'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL);

drop view if exists ddm_endline_survey;
create or replace view ddm_endline_survey as (
  SELECT individual.id                                                                          "Ind.Id",
         individual.address_id                                                                  "Ind.address_id",
         individual.uuid                                                                        "Ind.uuid",
         individual.first_name                                                                  "Ind.first_name",
         individual.last_name                                                                   "Ind.last_name",
         g.name                                                                                 "Ind.Gender",
         individual.date_of_birth                                                               "Ind.date_of_birth",
         individual.date_of_birth_verified                                                      "Ind.date_of_birth_verified",
         individual.registration_date                                                           "Ind.registration_date",
         individual.facility_id                                                                 "Ind.facility_id",
         a.title                                                                                "Ind.Area",
         c2.name                                                                                "Ind.Catchment",
         individual.is_voided                                                                   "Ind.is_voided",
         op.name                                                                                "Enl.Program Name",
         programEnrolment.uuid                                                                  "Enl.uuid",
         programEnrolment.id                                                                    "Enl.id",
         programEnrolment.is_voided                                                             "Enl.is_voided",
         oet.name                                                                               "Enc.Type",
         programEncounter.id                                                                    "Enc.Id",
         programEncounter.earliest_visit_date_time                                              "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                                   "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                                  "Enc.program_enrolment_id",
         programEncounter.uuid                                                                  "Enc.uuid",
         programEncounter.name                                                                  "Enc.name",
         programEncounter.max_visit_date_time                                                   "Enc.max_visit_date_time",
         programEncounter.is_voided                                                             "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1') :: TEXT     as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                        as "Enl.Silt Estimation as per work plan",
         programEnrolment.observations ->> '86a3a3e1-1b59-40a0-aa6c-f2f5bc9c0765'::TEXT      as "Enl.NGO",
         programEncounter.observations ->>
         '37dbe8cd-bf94-451d-8908-ea536f3be512'::TEXT                                        as "Enc.Video",
         programEncounter.observations ->>
         'b38cd08c-de01-434d-9704-6a4c830e6d3e'::TEXT                                        as "Enc.Image 1",
         programEncounter.observations ->>
         '3bfb1fb4-710d-4cf1-93bb-3ec1aec66d53'::TEXT                                        as "Enc.Image 2",
         single_select_coded(
             programEncounter.observations ->> 'ad675a1c-ec17-403c-8e7f-3ace80de790e')::TEXT as "Enc.Whether MB recording done",
         programEncounter.observations ->>
         '74c949f9-9a60-407e-9c72-64eefb0f0c0b'::TEXT                                        as "Enc.Approved silt quantity as per MB",
         programEncounter.cancel_date_time                                                      "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet
                         on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op
                         ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual
                         ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT OUTER JOIN address_level a ON individual.address_id = a.id
         LEFT OUTER JOIN catchment_address_mapping m2
                         ON a.id = m2.addresslevel_id
         LEFT OUTER JOIN catchment c2 ON m2.catchment_id = c2.id
  WHERE c2.name not ilike '%master%'
    AND op.uuid = '1f961272-faf4-4f99-ba0d-331d15622092'
    AND oet.uuid = '415bb1f6-12b4-44df-b85d-373728f9e42d'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL);

drop view if exists ddm_beneficiary_data;
create or replace view ddm_beneficiary_data as (
  SELECT individual.id                                                                      "Ind.Id",
         individual.uuid                                                                    "Ind.uuid",
         individual.address_id                                                              "Ind.address_id",
         individual.first_name                                                              "Ind.first_name",
         individual.last_name                                                               "Ind.last_name",
         g.name                                                                             "Ind.Gender",
         individual.date_of_birth                                                           "Ind.date_of_birth",
         individual.date_of_birth_verified                                                  "Ind.date_of_birth_verified",
         individual.registration_date                                                       "Ind.registration_date",
         individual.facility_id                                                             "Ind.facility_id",
         a.title                                                                            "Ind.Area",
         c2.name                                                                            "Ind.Catchment",
         individual.is_voided                                                               "Ind.is_voided",
         op.name                                                                            "Enl.Program Name",
         programEnrolment.uuid                                                              "Enl.uuid",
         programEnrolment.id                                                                "Enl.Id",
         programEnrolment.is_voided                                                         "Enl.is_voided",
         oet.name                                                                           "Enc.Type",
         programEncounter.id                                                                "Enc.Id",
         programEncounter.earliest_visit_date_time                                          "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                               "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                              "Enc.program_enrolment_id",
         programEncounter.uuid                                                              "Enc.uuid",
         programEncounter.name                                                              "Enc.name",
         programEncounter.max_visit_date_time                                               "Enc.max_visit_date_time",
         programEncounter.is_voided                                                         "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1') :: TEXT as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                    as "Enl.Silt Estimation as per work plan",
         programEnrolment.observations ->> '86a3a3e1-1b59-40a0-aa6c-f2f5bc9c0765'::TEXT  as "Enl.NGO",
         programEncounter.observations ->>
         '9ce0e6e0-b67d-49ed-9e9d-442fc666167e'::TEXT                                    as "Enc.Area covered by silt in acres",
         programEncounter.observations ->>
         'dc58b01a-51e7-4d00-95c9-309dec27a96c'::TEXT                                    as "Enc.Number of trolleys of silt",
         programEncounter.observations ->> '587bd99d-099e-4574-803f-49d432ab5a84'::TEXT  as "Enc.Number of hywa",
         programEncounter.observations ->>
         '5bc975ff-5bb0-4f7f-8648-3efc4e216d94'::TEXT                                    as "Enc.Amount spent by farmer for carting the silt per day",
         programEncounter.observations ->>
         'fa95dfd7-5bd9-4a4f-83f7-7066975ea371'::TEXT                                    as "Enc.Farm distance from the dam in km",
         programEncounter.observations ->> '74863f01-cf77-4c84-b8e4-5322cc6602ef'::TEXT  as "Enc.Mobile number",
         programEncounter.observations ->> '5cbec7cb-93de-42f2-9fa5-d790adfe4b13'::TEXT  as "Enc.Aadhaar ID",
         programEncounter.observations ->>
         'd9ad08ab-63a2-40ae-85f7-a638aa0c780d'::TEXT                                    as "Enc.Landholding according to 8A in acres",
         programEncounter.observations ->> '45b4dfb9-2a8f-46cc-9b78-33560c81a16e'::TEXT  as "Enc.Village",
         programEncounter.observations ->> 'd690cffb-cfc9-44f3-ae7e-e658198c17e2'::TEXT  as "Enc.Beneficiary name",
         programEncounter.cancel_date_time                                                  "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet
                         on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op
                         ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual
                         ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT OUTER JOIN address_level a ON individual.address_id = a.id
         LEFT OUTER JOIN catchment_address_mapping m2
                         ON a.id = m2.addresslevel_id
         LEFT OUTER JOIN catchment c2 ON m2.catchment_id = c2.id
  WHERE c2.name not ilike '%master%'
    AND op.uuid = '1f961272-faf4-4f99-ba0d-331d15622092'
    AND oet.uuid = 'abf25941-872b-468d-b347-e2abf3877789'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL);

drop view if exists ddm_locations_view;
create or replace view ddm_locations_view as (
  select vill.id    village_id,
         vill.title village,
         blck.id    block_id,
         blck.title block,
         dist.id    district_id,
         dist.title district
  from address_level vill
         join location_location_mapping vill_block
              on vill.id = vill_block.location_id
         join address_level blck on blck.id = vill_block.parent_location_id
         join location_location_mapping block_dist
              on blck.id = block_dist.location_id
         join address_level dist
              on dist.id = block_dist.parent_location_id
  where vill.level = 1
    and blck.level = 3
    and dist.level = 4
);

drop view if exists ddm_record_issues_view;
create or replace view ddm_record_issues_view as (
  SELECT individual.uuid                                                                       "Ind.uuid",
         individual.id                                                                         "Ind.id",
         individual.first_name                                                                 "Ind.first_name",
         individual.last_name                                                                  "Ind.last_name",
         g.name                                                                                "Ind.Gender",
         individual.date_of_birth                                                              "Ind.date_of_birth",
         individual.date_of_birth_verified                                                     "Ind.date_of_birth_verified",
         individual.registration_date                                                          "Ind.registration_date",
         individual.facility_id                                                                "Ind.facility_id",
         a.title                                                                               "Ind.Area",
         c2.name                                                                               "Ind.Catchment",
         individual.is_voided                                                                  "Ind.is_voided",
         op.name                                                                               "Enl.Program Name",
         programEnrolment.uuid                                                                 "Enl.uuid",
         programEnrolment.is_voided                                                            "Enl.is_voided",
         programEnrolment.id                                                                   "Enl.id",
         oet.name                                                                              "Enc.Type",
         programEncounter.earliest_visit_date_time                                             "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                                  "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                                 "Enc.program_enrolment_id",
         programEncounter.uuid                                                                 "Enc.uuid",
         programEncounter.name                                                                 "Enc.name",
         programEncounter.max_visit_date_time                                                  "Enc.max_visit_date_time",
         programEncounter.is_voided                                                            "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1')::TEXT      as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                       as "Enl.Silt Estimation as per work plan",
         multi_select_coded(
             programEncounter.observations -> 'a086446f-fb15-478a-a7c4-12d4e40399eb')::TEXT as "Enc.Issues faced during desilting",
         programEncounter.observations ->>
         '51780dd0-524c-4d3d-924f-1ba3b5cf5a19'::TEXT                                       as "Enc.Other issue details",
         programEncounter.observations ->>
         '4a681a0e-831b-48e8-9334-6c7bdf8334cc'::TEXT                                       as "Enc.Issue photograph",
         programEncounter.cancel_date_time                                                     "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet
                         on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT OUTER JOIN address_level a ON individual.address_id = a.id
         LEFT OUTER JOIN catchment_address_mapping m2 ON a.id = m2.addresslevel_id
         LEFT OUTER JOIN catchment c2 ON m2.catchment_id = c2.id
  WHERE c2.name not ilike '%master%'
    AND op.uuid = '1f961272-faf4-4f99-ba0d-331d15622092'
    AND oet.uuid = '7e908caf-6d34-4087-843e-d98cc498eca2'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);
-- ----------------------------------------------------
set role none;

select grant_all_on_views(array [
                            'ddm_record_poclain_details',
                            'ddm_record_jcb_details',
                            'ddm_baseline_survey',
                            'ddm_endline_survey',
                            'ddm_beneficiary_data',
                            'ddm_locations_view',
                            'ddm_record_issues_view'
                            ], 'ddm');
