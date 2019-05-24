select create_db_user('ddm', 'password');

INSERT into organisation(name, db_user, uuid, media_directory, parent_organisation_id)
values ('Dam Desilting Mission', 'ddm', '750cf4e0-1909-47f0-8952-836ae4111c9b', 'dam_desilting', null)
ON CONFLICT (uuid) DO NOTHING;
