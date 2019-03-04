const _ = require("lodash");
import {
    FormElementsStatusHelper,
    FormElementStatus,
    FormElementStatusBuilder,
    RuleCondition,
    RuleFactory,
    StatusBuilderAnnotationFactory,
    VisitScheduleBuilder
} from 'rules-config/rules';

const ViewFilter = RuleFactory("8cd7f4c4-dc56-4e64-89d3-7327900f51f1", "ViewFilter");
const WithStatusBuilder = StatusBuilderAnnotationFactory('programEncounter', 'formElement');

@ViewFilter("5b4f0ab3-14e8-4a02-8d18-925beaac94d1", "DesiltingIssuesFormHandlerDDM", 100.0, {})
class DesiltingIssuesFormHandlerDDM {
    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new DesiltingIssuesFormHandlerDDM(), programEncounter, formElementGroup, today);
    }

    @WithStatusBuilder
    otherIssueDetails([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Issues faced during desilting").containsAnyAnswerConceptName("Other");
    }


}

export {
    DesiltingIssuesFormHandlerDDM
}