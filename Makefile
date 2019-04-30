# <makefile>
# Objects: refdata, package
# Actions: clean, build, deploy
help:
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
	    IFS=$$'#' ; \
	    help_split=($$help_line) ; \
	    help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
	    help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
	    printf "%-30s %s\n" $$help_command $$help_info ; \
	done
# </makefile>

port:= $(if $(port),$(port),8021)
db-port:= $(if $(db-port),$(db-port),5432)
server:= $(if $(server),$(server),http://localhost)
server_url:=$(server):$(port)
su:=$(shell id -un)
org_name=Dam Desilting mission
org_admin_name=admin@ddm

poolId:=
clientId:=
username:=admin@ddm
password:=

auth:
	$(if $(poolId),$(eval token:=$(shell node scripts/token.js $(poolId) $(clientId) $(username) $(password))))
	echo $(token)

auth_live:
	make auth poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) username=admin@ddm password=$(OPENCHS_PROD_ADMIN_USER_PASSWORD)

define _curl
	curl -X $(1) $(server_url)/$(2) -d $(3)  \
		-H "Content-Type: application/json"  \
		-H "USER-NAME: $(org_admin_name)"  \
		$(if $(token),-H "AUTH-TOKEN: $(token)",)
	@echo
	@echo
endef

define _curl_for_form_query_export
	@curl -X GET '$(server_url)/query/program/$(1)/encounter/$(2)'  \
		-H "Content-Type: application/json"  \
		-H "USER-NAME: $(org_admin_name)"  \
		$(if $(token),-H "AUTH-TOKEN: $(token)",)
	@echo
	@echo
endef

define _curl_for_all_forms_query_export
	@curl -X GET '$(server_url)/query/program/$(1)'  \
		-H "Content-Type: application/json"  \
		-H "USER-NAME: $(org_admin_name)"  \
		$(if $(token),-H "AUTH-TOKEN: $(token)",)
	@echo
	@echo
endef

define _curl_as_openchs
	curl -X $(1) $(server_url)/$(2) -d $(3)  \
		-H "Content-Type: application/json"  \
		-H "USER-NAME: admin"  \
		$(if $(token),-H "AUTH-TOKEN: $(token)",)
	@echo
	@echo
endef


create_org:; psql -U$(su) openchs < create_organisation.sql
create_views:; psql -U$(su) -h localhost -p $(db-port) -d openchs < create_views.sql


deploy_checklists:


# <deploy>
deploy_locations: auth
	$(call _curl,POST,locations,@address_level/village.json)
	$(call _curl,POST,locations,@address_level/locations_yavatmal.json)
	$(call _curl,POST,locations,@address_level/locations_aurangabad.json)
	$(call _curl,POST,locations,@address_level/locations_beed.json)
	$(call _curl,POST,locations,@address_level/locations_nashik.json)

deploy_org_data: deploy_locations
#	$(call _curl,POST,catchments,@catchments.json)

deploy_beta_catchments:
	$(call _curl,POST,catchments,@users/beta-catchments_nashik.json)
	$(call _curl,POST,catchments,@users/beta-catchments_beed.json)

deploy_beta_users:
	#$(call _curl_as_openchs,POST,users,@users/beta-users_nashik.json)
#	$(call _curl_as_openchs,POST,users,@users/beta-users_beed.json)

create_admin_user:
	$(call _curl_as_openchs,POST,users,@users/dev-admin-user.json)

create_admin_user_uat:
	make auth create_admin_user poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 password=$(password) username=admin

create_admin_user_dev:
	$(call _curl_as_openchs,POST,users,@users/dev-admin-user.json)

create_users_dev:
	$(call _curl,POST,users,@users/dev-users.json)

deploy_org_data_live:
#	make auth deploy_org_data poolId=$(STAGING_USER_POOL_ID) clientId=$(STAGING_APP_CLIENT_ID) username=admin@ddm password=$(STAGING_ADMIN_USER_PASSWORD)

_deploy_refdata: deploy_subjects
	$(call _curl,POST,concepts,@registration/registrationConcepts.json)
	$(call _curl,POST,forms,@registration/registrationForm.json)
	$(call _curl,POST,programs,@programs.json)
	$(call _curl,POST,encounterTypes,@encounterTypes.json)
	$(call _curl,POST,operationalEncounterTypes,@operationalModules/operationalEncounterTypes.json)
	$(call _curl,POST,operationalPrograms,@operationalModules/operationalPrograms.json)
	$(call _curl,POST,concepts,@desilting/desiltingConcepts.json)
	$(call _curl,POST,forms,@desilting/enrolmentForm.json)
	$(call _curl,POST,forms,@desilting/recordIssuesForm.json)
	$(call _curl,POST,forms,@desilting/vehicleDetailsForm.json)
	$(call _curl,POST,forms,@desilting/beneficiaryDataForm.json)
	$(call _curl,POST,forms,@desilting/baselineSurveyForm.json)
	$(call _curl,POST,forms,@desilting/endlineSurveyForm.json)
	$(call _curl,POST,formMappings,@formMappings.json)

deploy_subjects:
	$(call _curl,POST,subjectTypes,@subjectTypes.json)
	$(call _curl,POST,operationalSubjectTypes,@operationalModules/operationalSubjectTypes.json)

deploy_rules:
	node index.js "$(server_url)" "$(token)" "$(username)"

deploy_rules_live:
	make auth deploy_rules poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) username=admin@ddm password=$(password) server=https://server.openchs.org port=443

deploy_refdata: _deploy_refdata

deploy: create_admin_user_dev create_users_dev deploy_org_data _deploy_refdata deploy_beta_catchments deploy_rules

_deploy_prod: deploy_org_data _deploy_refdata deploy_checklists deploy_rules

deploy_prod:
#	there is a bug in server side. which sets both isAdmin, isOrgAdmin to be false. it should be done. also metadata upload should not rely on isAdmin role.
#	need to be fixed. then uncomment the following line.
#	make auth deploy_admin_user poolId=ap-south-1_DU27AHJvZ clientId=1d6rgvitjsfoonlkbm07uivgmg server=https://server.openchs.org port=443 username=admin password=
	make auth _deploy_prod poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) server=https://server.openchs.org port=443 username=admin@ddm password=$(password)


create_deploy: create_org deploy ##

deploy_staging:
	make auth _deploy_prod poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

deploy_uat:
	make auth _deploy_prod poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 username=admin@ddm password=$(password)

deploy_rules_uat:
	make auth deploy_rules poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 username=admin@ddm password=$(password)

deploy_rules_staging:
	make auth deploy_rules poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)


create_admin_user_staging:
	make auth create_admin_user poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin password=$(password)

_create_users_staging:
	$(call _curl,POST,users,@staging-users.json)

create_users_staging:
	make auth _create_users_staging poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

deploy_locations_staging:
	make auth deploy_locations poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

deploy_beta_catchments_staging:
	make auth deploy_beta_catchments poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

deploy_beta_users_staging:
	make auth deploy_beta_users poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)




program=
encounter-type=
get_forms:
	$(call _curl_for_form_query_export,$(program),$(encounter-type))

get_all_forms:
	$(call _curl_for_all_forms_query_export,$(program))

# <package>
build_package: ## Builds a deployable package
	rm -rf output/impl
	mkdir -p output/impl
	cp registrationForm.json catchments.json deploy.sh output/impl
	cd output/impl && tar zcvf ../openchs_impl.tar.gz *.*
# </package>

deps:
	npm i

impl=ddm

#create_views_prod:
#	ssh -i ~/.ssh/openchs-infra.pem -f -L 15432:serverdb.openchs.org:5432 prod-server-openchs sleep 15; \
#		make create_views db-port=15432 su=openchs

create_views_staging:
	ssh -i ~/.ssh/openchs-infra.pem -f -L 15432:stagingdb.openchs.org:5432 staging-server-openchs sleep 15; \
		make create_views db-port=15432 su=openchs

create_views_uat:
	ssh -i ~/.ssh/openchs-infra.pem -f -L 15432:uatdb.openchs.org:5432 uat-server-openchs sleep 15; \
		make create_views db-port=15432 su=openchs

define _mcurl
	curl -X $(1) $(server_url)/$(2) -d @../../data/ddm-data/$(3)  \
		-H "Content-Type: application/json"  \
		-H "USER-NAME: $(username)"  \
		$(if $(token),-H "AUTH-TOKEN: $(token)",)
	@echo
	@echo
endef

migrate_locations:
	$(call _mcurl,POST,locations,locations_AhmedNagar.json)
	$(call _mcurl,POST,locations,locations_Amravati.json)
	$(call _mcurl,POST,locations,locations_Aurangabad.json)
	$(call _mcurl,POST,locations,locations_Dhule.json)
	$(call _mcurl,POST,locations,locations_Hingoli.json)
	$(call _mcurl,POST,locations,locations_Jalgaon.json)
	$(call _mcurl,POST,locations,locations_Jalna.json)
	$(call _mcurl,POST,locations,locations_Nanded.json)
	$(call _mcurl,POST,locations,locations_Nashik.json)
	$(call _mcurl,POST,locations,locations_Palghar.json)
	$(call _mcurl,POST,locations,locations_Parbhani.json)
	$(call _mcurl,POST,locations,locations_Pune.json)
	$(call _mcurl,POST,locations,locations_Sangli.json)
	$(call _mcurl,POST,locations,locations_Satara.json)
	$(call _mcurl,POST,locations,locations_Solapur.json)
	$(call _mcurl,POST,locations,locations_Wardha.json)
	$(call _mcurl,POST,locations,locations_Yavatmal.json)
	$(call _mcurl,POST,locations,locations_Beed.json)
	$(call _mcurl,POST,locations,locations_Nandurabar.json)

migrate_catchments:
	$(call _mcurl,POST,catchments,catchments_AhmedNagar.json)
	$(call _mcurl,POST,catchments,catchments_Amravati.json)
	$(call _mcurl,POST,catchments,catchments_Aurangabad.json)
	$(call _mcurl,POST,catchments,catchments_Dhule.json)
	$(call _mcurl,POST,catchments,catchments_Hingoli.json)
	$(call _mcurl,POST,catchments,catchments_Jalgaon.json)
	$(call _mcurl,POST,catchments,catchments_Jalna.json)
	$(call _mcurl,POST,catchments,catchments_Nanded.json)
	$(call _mcurl,POST,catchments,catchments_Nashik.json)
	$(call _mcurl,POST,catchments,catchments_Palghar.json)
	$(call _mcurl,POST,catchments,catchments_Parbhani.json)
	$(call _mcurl,POST,catchments,catchments_Pune.json)
	$(call _mcurl,POST,catchments,catchments_Sangli.json)
	$(call _mcurl,POST,catchments,catchments_Satara.json)
	$(call _mcurl,POST,catchments,catchments_Solapur.json)
	$(call _mcurl,POST,catchments,catchments_Wardha.json)
	$(call _mcurl,POST,catchments,catchments_Yavatmal.json)
	$(call _mcurl,POST,catchments,catchments_Beed.json)
	$(call _mcurl,POST,catchments,catchments_Nandurabar.json)

migrate_users:
	$(call _mcurl,POST,users,users_AhmedNagar.json)
	$(call _mcurl,POST,users,users_Amravati.json)
	$(call _mcurl,POST,users,users_Aurangabad.json)
	$(call _mcurl,POST,users,users_Dhule.json)
	$(call _mcurl,POST,users,users_Hingoli.json)
	$(call _mcurl,POST,users,users_Jalgaon.json)
	$(call _mcurl,POST,users,users_Jalna.json)
	$(call _mcurl,POST,users,users_Nanded.json)
	$(call _mcurl,POST,users,users_Nashik.json)
	$(call _mcurl,POST,users,users_Palghar.json)
	$(call _mcurl,POST,users,users_Parbhani.json)
	$(call _mcurl,POST,users,users_Pune.json)
	$(call _mcurl,POST,users,users_Sangli.json)
	$(call _mcurl,POST,users,users_Satara.json)
	$(call _mcurl,POST,users,users_Solapur.json)
	$(call _mcurl,POST,users,users_Wardha.json)
	$(call _mcurl,POST,users,users_Yavatmal.json)
	$(call _mcurl,POST,users,users_Beed.json)
	$(call _mcurl,POST,users,users_Nandurabar.json)

migrate_taluka_wise:
	$(call _mcurl,POST,catchments,taluka_wise.catchments.json)
	$(call _mcurl,POST,users,taluka_wise.users.json)

migrate_refdata: auth migrate_locations migrate_catchments migrate_users

migrate_locations_staging:
	make auth migrate_locations poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

migrate_catchments_staging:
	make auth migrate_catchments poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

migrate_users_staging:
	make auth migrate_users poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

migrate_refdata_staging:
	make auth migrate_locations migrate_catchments migrate_users poolId=$(OPENCHS_STAGING_USER_POOL_ID) clientId=$(OPENCHS_STAGING_APP_CLIENT_ID) server=https://staging.openchs.org port=443 username=admin@ddm password=$(password)

migrate_locations_uat:
	make auth migrate_locations poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 username=admin@ddm password=$(password)

migrate_catchments_uat:
	make auth migrate_catchments poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 username=admin@ddm password=$(password)

migrate_users_uat:
	make auth migrate_users poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 username=admin@ddm password=$(password)

migrate_refdata_uat:
	make auth migrate_locations migrate_catchments migrate_users poolId=$(OPENCHS_UAT_USER_POOL_ID) clientId=$(OPENCHS_UAT_APP_CLIENT_ID) server=https://uat.openchs.org port=443 username=admin@ddm password=$(password)

migrate_locations_prod:
	make auth migrate_locations poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) server=https://server.openchs.org port=443 username=admin@ddm password=$(password)

migrate_catchments_prod:
	make auth migrate_catchments poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) server=https://server.openchs.org port=443 username=admin@ddm password=$(password)

migrate_users_prod:
	make auth migrate_users poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) server=https://server.openchs.org port=443 username=admin@ddm password=$(password)

migrate_refdata_prod:
	make auth migrate_locations migrate_catchments migrate_users poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) server=https://server.openchs.org port=443 username=admin@ddm password=$(password)

migrate_taluka_wise_prod:
	make auth migrate_taluka_wise poolId=$(OPENCHS_PROD_USER_POOL_ID) clientId=$(OPENCHS_PROD_APP_CLIENT_ID) server=https://server.openchs.org port=443 username=admin@ddm password=$(password)
