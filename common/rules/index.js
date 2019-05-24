const _ = require('lodash');

module.exports = _.merge({},
    require('../../desilting/rules/desiltingIssuesFormHandlerDDM'),
    require('../../desilting/rules/endlineSurveyFormHandler'),
    require('../../desilting/rules/desiltingProgramSummary'),
    require('../../desilting/rules/vehicleDetailsFormHandlerDDM')
);
