deps:; npm install; npm i -g grunt;
-include ./node_modules/openchs-idi/Makefile

#######################################

db-port:= $(if $(db-port),$(db-port),5432)
su:=$(shell id -un)

_create_views:; psql -U$(su) -h localhost -p $(db-port) -d openchs < create_views.sql

create_views_staging:
	ssh -i ~/.ssh/openchs-infra.pem -f -L 15432:stagingdb.openchs.org:5432 staging-server-openchs sleep 15; \
		make _create_views db-port=15432 su=openchs

create_views_uat:
	ssh -i ~/.ssh/openchs-infra.pem -f -L 15432:uatdb.openchs.org:5432 uat-server-openchs sleep 15; \
		make _create_views db-port=15432 su=openchs

create_views_prod:
	ssh -i ~/.ssh/openchs-infra.pem -f -L 15432:serverdb.openchs.org:5432 prod-server-openchs sleep 15; \
		make _create_views db-port=15432 su=openchs
