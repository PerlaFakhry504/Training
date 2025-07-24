import { LightningElement, wire } from 'lwc';
import getTopAccounts from '@salesforce/apex/TopAccountsController.getTopAccounts';

export default class TopAccounts extends LightningElement {
    accounts;
    error;

    @wire(getTopAccounts)
    wiredTopAccounts({ data, error }) {
        if (data) {
            // map each Account into an object that includes parsedAmount
            this.accounts = data.map(acc => {
                const raw = acc.Total_Opportunity_Amount_c__c;
                // Number(...) will turn a string or number into a JS number
                const num = Number(raw);
                return {
                    ...acc,
                    parsedAmount: isNaN(num) ? 0 : Math.floor(num)
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error    = error;
            this.accounts = undefined;
        }
    }

    get errorMessage() {
        return this.error?.body?.message || this.error?.message || '';
    }
}
