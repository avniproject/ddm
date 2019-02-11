const _ = require('lodash');

module.exports = _.merge({},
    require('./desilting/rules/desiltingDataFormHandler'),
    require('./desilting/rules/endlineSurveyFormHandler')

);
