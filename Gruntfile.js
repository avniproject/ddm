const rulesConfigInfra = require('rules-config/infra');
const IDI = require('openchs-idi');
const secrets = require('../secrets.json');

module.exports = IDI.configure({
    "name": "ddm",
    "chs-admin": "admin",
    "org-name": "Dam Desilting Mission",
    "org-admin": "admin@ddm",
    "secrets": secrets,
    "files": {
        "adminUsers": {
            "dev": ["./users/dev-admin-user.json"],
        },
        "forms": [
            "./registration/registrationForm.json",
            "./desilting/enrolmentForm.json",
            "./desilting/endlineSurveyForm.json",
            "./desilting/recordIssuesForm.json",
            "./desilting/vehicleDetailsForm.json",
            "./desilting/baselineSurveyForm.json",
            "./desilting/beneficiaryDataForm.json",
        ],
        "formMappings": [
            "./common/formMappings.json",
        ],
        "formDeletions": [],
        "formAdditions": [],
        "catchments": {
            "dev": [
                "./users/beta-catchments_nashik.json",
            ],
            "staging": [
                "./users/beta-catchments_beed.json",
                "./users/beta-catchments_nashik.json",
            ],
            "prod": [
                // Keep the ddm-data repository cloned in `../../data/ddm-data`
                // Uncomment specific file-paths and run `make deploy-prod-catchments`
                // "../../data/ddm-data/catchments_AhmedNagar.json",
                // "../../data/ddm-data/catchments_Amravati.json",
                // "../../data/ddm-data/catchments_Aurangabad.json",
                // "../../data/ddm-data/catchments_Beed.json",
                // "../../data/ddm-data/catchments_Dhule.json",
                // "../../data/ddm-data/catchments_Hingoli.json",
                // "../../data/ddm-data/catchments_Jalgaon.json",
                // "../../data/ddm-data/catchments_Jalna.json",
                // "../../data/ddm-data/catchments_Nanded.json",
                // "../../data/ddm-data/catchments_Nandurabar.json",
                // "../../data/ddm-data/catchments_Nashik.json",
                // "../../data/ddm-data/catchments_Palghar.json",
                // "../../data/ddm-data/catchments_Parbhani.json",
                // "../../data/ddm-data/catchments_Pune.json",
                // "../../data/ddm-data/catchments_Sangli.json",
                // "../../data/ddm-data/catchments_Satara.json",
                // "../../data/ddm-data/catchments_Solapur.json",
                // "../../data/ddm-data/catchments_Wardha.json",
                // "../../data/ddm-data/catchments_Yavatmal.json",

                // "../../data/ddm-data/taluka_wise.catchments.json",
            ],
        },
        "checklistDetails": [],
        "concepts": [
            "./registration/registrationConcepts.json",
            "./desilting/desiltingConcepts.json",
        ],
        "addressLevelTypes": [],
        "locations": {
            "dev": [
                "./address_level/locations_nashik.json",
            ],
            "staging": [
                "./address_level/village.json",
                "./address_level/locations_aurangabad.json",
                "./address_level/locations_beed.json",
                "./address_level/locations_nashik.json",
                "./address_level/locations_yavatmal.json",
            ],
            "prod": [
                // Keep the ddm-data repository cloned in `../../data/ddm-data`
                // Uncomment specific file-paths and run `make deploy-prod-locations`
                // "../../data/ddm-data/locations_AhmedNagar.json",
                // "../../data/ddm-data/locations_Amravati.json",
                // "../../data/ddm-data/locations_Aurangabad.json",
                // "../../data/ddm-data/locations_Beed.json",
                // "../../data/ddm-data/locations_Dhule.json",
                // "../../data/ddm-data/locations_Hingoli.json",
                // "../../data/ddm-data/locations_Jalgaon.json",
                // "../../data/ddm-data/locations_Jalna.json",
                // "../../data/ddm-data/locations_Nanded.json",
                // "../../data/ddm-data/locations_Nandurabar.json",
                // "../../data/ddm-data/locations_Nashik.json",
                // "../../data/ddm-data/locations_Palghar.json",
                // "../../data/ddm-data/locations_Parbhani.json",
                // "../../data/ddm-data/locations_Pune.json",
                // "../../data/ddm-data/locations_Sangli.json",
                // "../../data/ddm-data/locations_Satara.json",
                // "../../data/ddm-data/locations_Solapur.json",
                // "../../data/ddm-data/locations_Wardha.json",
                // "../../data/ddm-data/locations_Yavatmal.json",
            ],
        },
        "programs": [
            "./common/programs.json",
        ],
        "encounterTypes": [
            "./common/encounterTypes.json",
        ],
        "subjectTypes": [
            "./registration/subjectTypes.json",
        ],
        "operationalEncounterTypes": ["./operationalModules/operationalEncounterTypes.json"],
        "operationalPrograms": ["./operationalModules/operationalPrograms.json"],
        "operationalSubjectTypes": ["./registration/operationalSubjectTypes.json"],
        "users": {
            "dev": ["./users/dev-users.json"],
            "staging": [
                // Not checked in
                // "./staging-beta-users.json",
            ],
            "prod": [
                // Keep the ddm-data repository cloned in `../../data/ddm-data`
                // Uncomment specific file-paths and run `make deploy-prod-users`
                // "../../data/ddm-data/users_AhmedNagar.json",
                // "../../data/ddm-data/users_Amravati.json",
                // "../../data/ddm-data/users_Aurangabad.json",
                // "../../data/ddm-data/users_Beed.json",
                // "../../data/ddm-data/users_Dhule.json",
                // "../../data/ddm-data/users_Hingoli.json",
                // "../../data/ddm-data/users_Jalgaon.json",
                // "../../data/ddm-data/users_Jalna.json",
                // "../../data/ddm-data/users_Nanded.json",
                // "../../data/ddm-data/users_Nandurabar.json",
                // "../../data/ddm-data/users_Nashik.json",
                // "../../data/ddm-data/users_Palghar.json",
                // "../../data/ddm-data/users_Parbhani.json",
                // "../../data/ddm-data/users_Pune.json",
                // "../../data/ddm-data/users_Sangli.json",
                // "../../data/ddm-data/users_Satara.json",
                // "../../data/ddm-data/users_Solapur.json",
                // "../../data/ddm-data/users_Wardha.json",
                // "../../data/ddm-data/users_Yavatmal.json",

                // "../../data/ddm-data/taluka_wise.users.json",
            ],
        },
        "videos": [],
        "rules": ["./common/rules/index.js"],
        "organisationSql": []
    }
}, rulesConfigInfra);
