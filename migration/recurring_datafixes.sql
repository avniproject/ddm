set role ddm;

-- Void incorrect water body creation
With audits as (update individual
set is_voided = true where uuid in (SELECT ind.uuid
                                    FROM individual ind
                                          join audit a on ind.audit_id = a.id
                                          join users creator on creator.id = a.created_by_id
                                    where ind.is_voided = false
                                      and creator.username <> 'dataimporter@ddm')
returning audit_id)
update audit set last_modified_date_time = current_timestamp,
                 last_modified_by_id = (select id from users where username = 'dataimporter@ddm')
where audit.id in (select audit_id from audits);

-- Void enrolment if water body is_voided or the enrolment isn't imported by dataimporter@ddm
with audits as (update program_enrolment
set is_voided = true where uuid in (SELECT enl.uuid
                                    FROM program_enrolment enl
                                          join individual i on i.id = enl.individual_id
                                          join audit a on enl.audit_id = a.id
                                          join users creator on creator.id = a.created_by_id
                                    where i.is_voided OR (enl.is_voided = false
                                                  and creator.username <> 'dataimporter@ddm'))
returning audit_id)
update audit set last_modified_date_time = current_timestamp,
                 last_modified_by_id = (select id from users where username = 'dataimporter@ddm')
where audit.id in (select audit_id from audits);

-- Void encounter if enrolment is_voided
with audits as (update program_encounter
set is_voided = true where id in (select enc.id
                                    from program_encounter enc
                                                join program_enrolment enl on enc.program_enrolment_id = enl.id
                                    where enc.is_voided is false
                                      and enl.is_voided is true) returning audit_id)
update audit set last_modified_date_time = current_timestamp,
                 last_modified_by_id = (select id from users where username = 'dataimporter@ddm')
where audit.id in (select audit_id from audits);

--Unexit incorrect program exits
with audits as (update program_enrolment
  set program_exit_date_time = null ,
    program_exit_observations = '{}',
    exit_location = null
  where uuid in (SELECT enl.uuid
                 FROM program_enrolment enl
                        join individual i on i.id = enl.individual_id
                        join audit a on enl.audit_id = a.id
                        join users creator on creator.id = a.created_by_id
                        join users modifier on modifier.id = a.last_modified_by_id
                 where enl.program_exit_date_time notnull
                   and enl.is_voided = false
                   and modifier.username <> 'dataimporter@ddm')
  returning audit_id)
update audit
set last_modified_date_time = current_timestamp,
    last_modified_by_id     = (select id from users where username = 'dataimporter@ddm')
where audit.id in (select audit_id from audits);
