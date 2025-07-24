import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import createAccountImperatively from '@salesforce/apex/CreateAccount.createAccountImperatively';

export default class CreateAccountImperatively extends NavigationMixin(LightningElement) {

    accountName;

    isLoading = false;

    handleChange(event){
        this.accountName = event.target.value;
    }
    
   handleClick() {

    this.isLoading = true;

    createAccountImperatively({ name: this.accountName })
        .then(result => {
            this.showToast('Success', 'Account created successfully', 'success');
            console.log('result: ',result);
             setTimeout(() => { this.navigateToRecord(result.Id);} , 500);
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
            console.log('Error: ',error.body.message);
        })
        
        .finally(() => {
                this.isLoading = false;
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent( {title,message,variant} ) );
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId,
                          objectApiName: 'Account',
                          actionName: 'view'
                        }
        });
    }

}