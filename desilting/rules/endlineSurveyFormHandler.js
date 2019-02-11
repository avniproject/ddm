const _ = require("lodash");
import {
    RuleFactory,
    FormElementsStatusHelper,
    FormElementStatusBuilder,
    StatusBuilderAnnotationFactory,
    FormElementStatus,
    VisitScheduleBuilder,
    RuleCondition
} from 'rules-config/rules';

const EndlineSurveyDataViewFilter = RuleFactory("4f4539ab-3fe7-44cc-850f-92deac61b767", "ViewFilter");
const WithStatusBuilder = StatusBuilderAnnotationFactory('programEncounter', 'formElement');

@EndlineSurveyDataViewFilter("b4499dfe-e6b3-4803-9773-452fec3c55a1", "DDM Endline survey View Filter", 100.0, {})
class EndlineSurveyViewFilterHandlerDDM {

    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new EndlineSurveyViewFilterHandlerDDM(), programEncounter, formElementGroup, today);
    }

    @WithStatusBuilder
    approvedSiltQuantityAsPerMb([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Whether MB recording done").containsAnswerConceptName("Yes");
    }
}

module.exports = {EndlineSurveyViewFilterHandlerDDM};
