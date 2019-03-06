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

const ViewFilter = RuleFactory("63a064fa-8efe-4ad4-978c-4b973f90afe5", "ViewFilter");
const WithStatusBuilder = StatusBuilderAnnotationFactory('programEncounter', 'formElement');

@ViewFilter("4d6241e3-a07c-4fad-a552-187e13b4e0c3", "VehicleDetailsFormHandlerDDM", 100.0, {})
class VehicleDetailsFormHandlerDDM {
    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new VehicleDetailsFormHandlerDDM(), programEncounter, formElementGroup, today);
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
        const volumeOf1TractorTrolley = 2.8;
        const volumeOf1Hywa = 14;
        const statusBuilder = new FormElementStatusBuilder({
            programEncounter: programEncounter,
            formElement: formElement
        });
        statusBuilder.show().when.valueInRegistration("Type of waterbody").containsAnyAnswerConceptName("Dam");
        let formElementStatus = statusBuilder.build();
        const numberOfTractorTrips = programEncounter.getObservationValue("Number of tractor trips");
        const numberOfHywaTrips = programEncounter.getObservationValue("Number of hywa trips");
        if (!_.isNil(numberOfHywaTrips) && !_.isNil(numberOfTractorTrips)) {
            formElementStatus.value = _.round((numberOfTractorTrips * volumeOf1TractorTrolley) + (numberOfHywaTrips * volumeOf1Hywa), 2);
        }
        return formElementStatus;
    }
}

export {
    VehicleDetailsFormHandlerDDM
}