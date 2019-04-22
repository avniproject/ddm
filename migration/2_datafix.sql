set role ddm;

with ins as (select id
             from individual
             where uuid in ('52b13be2-ab04-41db-b315-15b8aa01b1c8',
                            '25373d7d-5215-43fb-9999-6a3fcdd60d3b',
                            'cc9848e9-5528-40fb-a7fc-3f40c4841e5c',
                            '4207873b-9163-438b-8f36-fd3958e9228d',
                            '8fb4f4a3-fb10-4158-bd41-a70ca7db95cb')),
    take_from as (select enrolment.id, enrolment.individual_id, c.name
                  from program_enrolment enrolment
                         join ins on ins.id = enrolment.individual_id
                         join audit on audit.id = enrolment.audit_id
                         join users c on audit.created_by_id = c.id and c.name <> 'dataimporter@ddm'),
    take_to as (select enrolment.id, enrolment.individual_id, c.name
                from program_enrolment enrolment
                       join ins on ins.id = enrolment.individual_id
                       join audit on audit.id = enrolment.audit_id
                       join users c on audit.created_by_id = c.id and c.name = 'dataimporter@ddm'),
    moves as (select take_from.name                         fname,
                     program_encounter.program_enrolment_id fenrol,
                     take_to.name                           tname,
                     take_to.id                             tenrol,
                     program_encounter.id                   encid
              from program_encounter
                     join take_from on take_from.id = program_enrolment_id
                     join take_to on take_from.individual_id = take_to.individual_id)

update program_encounter set program_enrolment_id = moves.tenrol
from moves
where moves.fenrol = program_encounter.program_enrolment_id

update program_enrolment set is_voided = true where id in (select fenrol from moves)

update program_enrolment set is_voided = false where id in (select fenrol from moves)
;

with ins as (select id
             from individual
             where uuid in ('52b13be2-ab04-41db-b315-15b8aa01b1c8',
                            '25373d7d-5215-43fb-9999-6a3fcdd60d3b',
                            'cc9848e9-5528-40fb-a7fc-3f40c4841e5c',
                            '4207873b-9163-438b-8f36-fd3958e9228d',
                            '8fb4f4a3-fb10-4158-bd41-a70ca7db95cb')),
    audits as (select program_enrolment.audit_id
                     from program_enrolment
                     where individual_id in (select id from ins)
    union select program_encounter.audit_id
                   from program_encounter
                          join program_enrolment on program_encounter.program_enrolment_id = program_enrolment.id
                   where individual_id in (select id from ins))

update audit set last_modified_date_time = current_timestamp, last_modified_by_id = (select id from users where name = 'dataimporter@ddm')
where audit.id in (select audit_id from audits);
