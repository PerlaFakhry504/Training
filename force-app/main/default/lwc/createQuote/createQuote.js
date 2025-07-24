import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LEASE_FIELD from '@salesforce/schema/Opportunity.Lease__c';
import { NavigationMixin } from 'lightning/navigation';

const FIELDS = [LEASE_FIELD];

export default class CreateQuote extends NavigationMixin(LightningElement) {
    @api recordId;
    
    leaseType;
    selectedDuration;
    landPaymentTerms=4;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredOpportunity({ data, error }) {
        if (data) {

            console.log('Wired Opportunity Record:', JSON.stringify(data, null, 2)); //JSON.stringify(value, replacer, space)

            this.leaseType = data.fields.Lease__c?.value;

        } else if (error) {
            console.error('Error loading lease type', error);
        }
    }

    get isOffice() {
        return this.leaseType === 'Office';
    }

    get isRetail() {
        return this.leaseType === 'Retail';
    }

    get isLand() {
        return this.leaseType === 'Land';
    }

    handleDurationChange(event) {
        this.selectedDuration = event.detail.value;
    }

    get showUpload() {
        return this.selectedDuration === '49 years' || this.selectedDuration === '60 years';
    }

     handleUploadFinished(event) {
        this.showToast('Success', 'File uploaded successfuly', 'success');}
    
    handleSuccess(event) {
        const quoteId = event.detail.id;
        this.showToast('Success', 'Quote created successfully', 'success');
        setTimeout(() => { this.navigateToRecord(quoteId);} , 500);
        
    }

    showToast(title, message, variant) {
            this.dispatchEvent(new ShowToastEvent( {title,message,variant} ) );
        }

    navigateToRecord(recordId) {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            objectApiName: 'Quote__c',
            actionName: 'view'
        }
    });
}
}
