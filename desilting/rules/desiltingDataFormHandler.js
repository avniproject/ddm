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

const DesiltingDataViewFilter = RuleFactory("8cd7f4c4-dc56-4e64-89d3-7327900f51f1", "ViewFilter");
const WithStatusBuilder = StatusBuilderAnnotationFactory('programEncounter', 'formElement');

@DesiltingDataViewFilter("5b4f0ab3-14e8-4a02-8d18-925beaac94d1", "DDM Desilting Data View Filter", 100.0, {})
class DesiltingDataViewFilterHandlerDDM {
    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new DesiltingDataViewFilterHandlerDDM(), programEncounter, formElementGroup, today);
    }

    @WithStatusBuilder
    amountOfWorkDone([], statusBuilder) {
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Naala", "Water cup");
    }

    @WithStatusBuilder
    quantityOfSiltRemoved([], statusBuilder) {
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Dam");
    }

    issues(programEncounter, formElementGroup) {
        return formElementGroup.formElements.map(fe=>{
            let statusBuilder = new FormElementStatusBuilder({programEncounter:programEncounter, formElement:fe});
            statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Dam");
            return statusBuilder.build();
        });
    }

    @WithStatusBuilder
    otherIssueDetails([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Issues faced during desilting").containsAnyAnswerConceptName("Other");
    }




}

module.exports = {DesiltingDataViewFilterHandlerDDM};

