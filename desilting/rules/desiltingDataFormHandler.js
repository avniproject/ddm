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
    numberOfTractorTrips([], statusBuilder) {
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Dam");
    }
    
    @WithStatusBuilder
    numberOfHywaTrips([], statusBuilder) {
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Dam");
    }

    @WithStatusBuilder
    amountOfWorkDone([], statusBuilder) {
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Naala", "Water cup");
    }


    quantityOfSiltRemoved(programEncounter, formElement) {
        console.log("came to quantityOfSiltRemoved");
        const statusBuilder = new FormElementStatusBuilder({
            programEncounter: programEncounter,
            formElement: formElement
        });
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Dam");
        let formElementStatus = statusBuilder.build();
        console.log(formElementStatus);
        const numberOfTractorTrips = programEncounter.getObservationValue("Number of tractor trips");
        console.log(numberOfTractorTrips);
        const numberOfHywaTrips = programEncounter.getObservationValue("Number of hywa trips");
        console.log(numberOfHywaTrips);
        if(!_.isNil(numberOfHywaTrips) && !_.isNil(numberOfTractorTrips)) {
            formElementStatus.value = (numberOfTractorTrips * 2.97)+(numberOfHywaTrips*16);
        }
        console.log(formElementStatus);
        return formElementStatus;
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

