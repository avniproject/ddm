set role ddm;
-- ----------------------------------------------------
drop view if exists ddm_record_poclain_details;
create or replace view ddm_record_poclain_details as (
  SELECT individual.uuid                                                                   "Ind.uuid",
         individual.id                                                                     "Ind.id",
         individual.first_name                                                             "Ind.first_name",
         individual.last_name                                                              "Ind.last_name",
         g.name                                                                            "Ind.Gender",
         individual.date_of_birth                                                          "Ind.date_of_birth",
         individual.date_of_birth_verified                                                 "Ind.date_of_birth_verified",
         individual.registration_date                                                      "Ind.registration_date",
         individual.facility_id                                                            "Ind.facility_id",
         a.title                                                                           "Ind.Area",
         c2.name                                                                           "Ind.Catchment",
         individual.is_voided                                                              "Ind.is_voided",
         op.name                                                                           "Enl.Program Name",
         programEnrolment.uuid                                                             "Enl.uuid",
         programEnrolment.is_voided                                                        "Enl.is_voided",
         oet.name                                                                          "Enc.Type",
         programEncounter.earliest_visit_date_time                                         "Enc.earliest_visit_date_time",
         programEncounter.id                                         "Enc.Id",
         programEncounter.encounter_date_time                                              "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                             "Enc.program_enrolment_id",
         programEncounter.uuid                                                             "Enc.uuid",
         programEncounter.name                                                             "Enc.name",
         programEncounter.max_visit_date_time                                              "Enc.max_visit_date_time",
         programEncounter.is_voided                                                        "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1')::TEXT  as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                   as "Enl.Silt Estimation as per work plan",
         programEncounter.observations ->>
         'faf5b0b2-64ef-4954-999a-b034dbe98390'::TEXT                                   as "Enc.Number of tractor trips",
         programEncounter.observations ->>
         '44a48cdc-4e79-4f61-acb1-f131ed07fc2c'::TEXT                                   as "Enc.Quantity of silt removed",
         programEncounter.observations ->> '42acf4ee-33bd-4628-b961-d3b6e5c457cc'::TEXT as "Enc.Diesel input quantity",
         programEncounter.observations ->> '3acb5cd4-c25e-41f7-b558-90fd41103e05'::TEXT as "Enc.Registration number",
         programEncounter.observations ->> '26770597-963b-4870-862b-3479d27aadb5'::TEXT as "Enc.Amount of work done",
         programEncounter.observations ->> 'de002f36-a76f-4ca7-ba5f-91fa84946125'::TEXT as "Enc.Working hours",
         programEncounter.observations ->> '61f4edbc-d486-4d32-a714-b144c2fe527a'::TEXT as "Enc.Number of hywa trips",
         programEncounter.cancel_date_time                                                 "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
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
    AND oet.uuid = '4c95ddd1-f59f-4b9b-be36-854031117176'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists ddm_record_jcb_details;
create or replace view ddm_record_jcb_details as (
  SELECT individual.uuid                                                                   "Ind.uuid",
         individual.first_name                                                             "Ind.first_name",
         individual.last_name                                                              "Ind.last_name",
         g.name                                                                            "Ind.Gender",
         individual.date_of_birth                                                          "Ind.date_of_birth",
         individual.date_of_birth_verified                                                 "Ind.date_of_birth_verified",
         individual.registration_date                                                      "Ind.registration_date",
         individual.facility_id                                                            "Ind.facility_id",
         a.title                                                                           "Ind.Area",
         c2.name                                                                           "Ind.Catchment",
         individual.is_voided                                                              "Ind.is_voided",
         op.name                                                                           "Enl.Program Name",
         programEnrolment.uuid                                                             "Enl.uuid",
         programEnrolment.is_voided                                                        "Enl.is_voided",
         programEncounter.id                    "Enc.Id",
         oet.name                                                                          "Enc.Type",
         programEncounter.earliest_visit_date_time                                         "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                              "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                             "Enc.program_enrolment_id",
         programEncounter.uuid                                                             "Enc.uuid",
         programEncounter.name                                                             "Enc.name",
         programEncounter.max_visit_date_time                                              "Enc.max_visit_date_time",
         programEncounter.is_voided                                                        "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1')::TEXT  as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                   as "Enl.Silt Estimation as per work plan",
         programEncounter.observations ->>
         'faf5b0b2-64ef-4954-999a-b034dbe98390'::TEXT                                   as "Enc.Number of tractor trips",
         programEncounter.observations ->>
         '44a48cdc-4e79-4f61-acb1-f131ed07fc2c'::TEXT                                   as "Enc.Quantity of silt removed",
         programEncounter.observations ->> '42acf4ee-33bd-4628-b961-d3b6e5c457cc'::TEXT as "Enc.Diesel input quantity",
         programEncounter.observations ->> '3acb5cd4-c25e-41f7-b558-90fd41103e05'::TEXT as "Enc.Registration number",
         programEncounter.observations ->> '26770597-963b-4870-862b-3479d27aadb5'::TEXT as "Enc.Amount of work done",
         programEncounter.observations ->> 'de002f36-a76f-4ca7-ba5f-91fa84946125'::TEXT as "Enc.Working hours",
         programEncounter.observations ->> '61f4edbc-d486-4d32-a714-b144c2fe527a'::TEXT as "Enc.Number of hywa trips",
         programEncounter.cancel_date_time                                                 "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
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
    AND oet.uuid = 'b92e9835-7b31-4f99-a438-a5564f1ef109'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists ddm_baseline_survey;
create or replace view ddm_baseline_survey as (
  SELECT individual.uuid                                                                   "Ind.uuid",
         individual.first_name                                                             "Ind.first_name",
         individual.last_name                                                              "Ind.last_name",
         g.name                                                                            "Ind.Gender",
         individual.date_of_birth                                                          "Ind.date_of_birth",
         individual.date_of_birth_verified                                                 "Ind.date_of_birth_verified",
         individual.registration_date                                                      "Ind.registration_date",
         individual.facility_id                                                            "Ind.facility_id",
         a.title                                                                           "Ind.Area",
         c2.name                                                                           "Ind.Catchment",
         individual.is_voided                                                              "Ind.is_voided",
         op.name                                                                           "Enl.Program Name",
         programEnrolment.uuid                                                             "Enl.uuid",
         programEnrolment.is_voided                                                        "Enl.is_voided",
         oet.name                                                                          "Enc.Type",
         programEncounter.id                                         "Enc.Id",
         programEncounter.earliest_visit_date_time                                         "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                              "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                             "Enc.program_enrolment_id",
         programEncounter.uuid                                                             "Enc.uuid",
         programEncounter.name                                                             "Enc.name",
         programEncounter.max_visit_date_time                                              "Enc.max_visit_date_time",
         programEncounter.is_voided                                                        "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1')::TEXT  as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                   as "Enl.Silt Estimation as per work plan",
         programEncounter.observations ->> '3bfb1fb4-710d-4cf1-93bb-3ec1aec66d53'::TEXT as "Enc.Image 2",
         programEncounter.observations ->>
         '4dd9914e-e39a-4ca3-8180-b939d6b5e1fa'::TEXT                                   as "Enc.Silt estimation as per technical sanction",
         programEncounter.observations ->> 'b38cd08c-de01-434d-9704-6a4c830e6d3e'::TEXT as "Enc.Image 1",
         programEncounter.observations ->> '37dbe8cd-bf94-451d-8908-ea536f3be512'::TEXT as "Enc.Video",
         programEncounter.cancel_date_time                                                 "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
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
    AND oet.uuid = 'b8352fb5-02be-405e-b178-b94c1581a8f7'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists ddm_endline_survey;
create or replace view ddm_endline_survey as (
  SELECT individual.uuid                                                                        "Ind.uuid",
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
         programEnrolment.is_voided                                                             "Enl.is_voided",
         oet.name                                                                               "Enc.Type",
         programEncounter.id                                         "Enc.Id",
         programEncounter.earliest_visit_date_time                                              "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                                   "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                                  "Enc.program_enrolment_id",
         programEncounter.uuid                                                                  "Enc.uuid",
         programEncounter.name                                                                  "Enc.name",
         programEncounter.max_visit_date_time                                                   "Enc.max_visit_date_time",
         programEncounter.is_voided                                                             "Enc.is_voided",
         single_select_coded(
             individual.observations ->> 'c744731d-f60f-4858-9b5d-9fca0b166ce1')::TEXT       as "Ind.Type of waterbody",
         programEnrolment.observations ->>
         '17e2fbe7-2d36-4ddc-8a12-c5f405d6c398'::TEXT                                        as "Enl.Silt Estimation as per work plan",
         programEncounter.observations ->>
         '37dbe8cd-bf94-451d-8908-ea536f3be512'::TEXT                                        as "Enc.Video",
         programEncounter.observations ->>
         '3bfb1fb4-710d-4cf1-93bb-3ec1aec66d53'::TEXT                                        as "Enc.Image 2",
         programEncounter.observations ->>
         '74c949f9-9a60-407e-9c72-64eefb0f0c0b'::TEXT                                        as "Enc.Approved silt quantity as per MB",
         programEncounter.observations ->>
         'b38cd08c-de01-434d-9704-6a4c830e6d3e'::TEXT                                        as "Enc.Image 1",
         single_select_coded(
             programEncounter.observations ->> 'ad675a1c-ec17-403c-8e7f-3ace80de790e')::TEXT as "Enc.Whether MB recording done",
         programEncounter.cancel_date_time                                                      "EncCancel.cancel_date_time"

  FROM program_encounter programEncounter
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
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
    AND oet.uuid = '415bb1f6-12b4-44df-b85d-373728f9e42d'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

-- ----------------------------------------------------
set role none;

SELECT grant_all_on_all(a.rolname)
FROM pg_roles a
WHERE pg_has_role('openchs', a.oid, 'member')
  and a.rolsuper is false
  and a.rolname not like 'pg%'
  and a.rolname not like 'rds%'
order by a.rolname;
