CREATE ROLE ddm NOINHERIT PASSWORD 'password';

GRANT ddm TO openchs;

GRANT ALL ON ALL TABLES IN SCHEMA public TO ddm;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO ddm;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO ddm;

INSERT into organisation(name, db_user, uuid, parent_organisation_id)
    SELECT 'Dam Desilting Mission', 'ddm', '750cf4e0-1909-47f0-8952-836ae4111c9b', id FROM organisation WHERE name = 'OpenCHS';
