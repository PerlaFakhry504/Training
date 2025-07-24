import { LightningElement , wire } from 'lwc';
import getMethod from '@salesforce/apex/MyLWCController.getMethod'; 

export default class MyLWCController extends LightningElement {
    maxRecords = 10;
    // @wire(getMethod, { maxRecords: "$maxRecords" }) accounts ;
    accounts;
    errors; 
    @wire(getMethod, { maxRecords: "$maxRecords" })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.errors = undefined;
        }else if (error){
            this.accounts = undefined;
            this.errors = error;
        }
    }
    
    handleMaxRecordsChange(event) {
    const val = parseInt(event.target.value, 10);
    this.maxRecords = Number.isInteger(val) && val > 0 ? val : 0;
}
}