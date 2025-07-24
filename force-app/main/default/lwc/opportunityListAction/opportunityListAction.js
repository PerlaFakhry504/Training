import { LightningElement, api, track, wire } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';

export default class OpportunityListAction extends LightningElement {
    @api recordId;             // Account Id
    @track opportunities = []; // list for the template
    @track error;              // holds any Apex error

    @wire(getOpportunities, { accountId: '$recordId' })
    wiredOpps({ data, error }) {
        if (data) {
            this.opportunities = data.map(opp => ({
                ...opp,
                rowClass:
                    opp.StageName === 'Closed Lost'
                        ? 'closed-lost'
                        : 'slds-text-body_regular'
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.opportunities = [];
        }
    }
}
