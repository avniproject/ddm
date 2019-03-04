import {ProgramRule} from 'rules-config/rules';

@ProgramRule({
    name: 'Desilting program summary',
    uuid: '0e987766-e465-41c2-bbcb-6beb6f352f06',
    programUUID: '082180d6-c4ef-4695-a137-f14c3b651736',
    executionOrder: 100.0,
    metadata: {}
})
class DesiltingProgramSummary {
    static exec(programEnrolment, summaries, context, today) {
        const typeofWaterbody = programEnrolment.individual.findObservation('Type of waterbody');
        if (typeofWaterbody && typeofWaterbody.getReadableValue() === 'Dam') {
            summaries.push({name: 'Total silt removed', value: this.getTotalSiltRemoved(programEnrolment)});
        } else {
            summaries.push({name: 'Total amount of work done', value: this.getTotalWorkDone(programEnrolment)});
        }
        summaries.push({name: 'Number of beneficiaries', value: this.getTotalBeneficiaries(programEnrolment)});
        summaries.push({name: 'Hours of operation of JCB', value: this.getTotalJcbHours(programEnrolment)});
        summaries.push({name: 'Hours of operation of Poclain', value: this.getTotalPoclainHours(programEnrolment)});
        summaries.push({name: 'Quantity of diesel consumed', value: this.getTotalDieselConsumed(programEnrolment)});
        return summaries;
    }

    static calculateSumOfObservationValues(programEnrolment, encounterTypeName, observationName) {
        return programEnrolment.getEncountersOfType(encounterTypeName)
            .map((enc) => enc.getObservationReadableValue(observationName))
            .reduce((total, val) => total + val, 0);
    }

    static getTotalSiltRemoved(programEnrolment) {
        return this.calculateSumOfObservationValues(programEnrolment, 'Record JCB details', 'Quantity of silt removed')
            + this.calculateSumOfObservationValues(programEnrolment, 'Record poclain details', 'Quantity of silt removed');
    }

    static getTotalWorkDone(programEnrolment) {
        return this.calculateSumOfObservationValues(programEnrolment, 'Record JCB details', 'Amount of work done')
            + this.calculateSumOfObservationValues(programEnrolment, 'Record poclain details', 'Amount of work done');
    }

    static getTotalBeneficiaries(programEnrolment) {
        const encounters = programEnrolment.getEncountersOfType('Record beneficiary data');
        const distinctNames = new Set(encounters.map(enc =>
            `${enc.getObservationReadableValue('Village')}-
            ${enc.getObservationReadableValue('Beneficiary name')}-
            ${enc.getObservationReadableValue('Mobile number')}`
        ));
        return distinctNames.size;
    }

    static getTotalJcbHours(programEnrolment) {
        return this.calculateSumOfObservationValues(programEnrolment, 'Record JCB details', 'Working hours');
    }

    static getTotalPoclainHours(programEnrolment) {
        return this.calculateSumOfObservationValues(programEnrolment, 'Record poclain details', 'Working hours');
    }

    static getTotalDieselConsumed(programEnrolment) {
        return this.calculateSumOfObservationValues(programEnrolment, 'Record JCB details', 'Diesel input quantity')
            + this.calculateSumOfObservationValues(programEnrolment, 'Record poclain details', 'Diesel input quantity');
    }
}

module.exports = {DesiltingProgramSummary};
