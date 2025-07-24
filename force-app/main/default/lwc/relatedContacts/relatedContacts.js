import { LightningElement, api, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactsController.getContacts';
import { refreshApex } from '@salesforce/apex';

export default class RelatedContacts extends LightningElement {
  @api recordId;
  @track contacts;
  @track error;
  @track showModal = false;

  // this is a primitive (string); it’s automatically reactive , no need for @track
  selectedContactId;

  wiredContactsResult;

  @wire(getContacts, { accId: '$recordId' })
  wiredContacts(result) {
    this.wiredContactsResult = result;
    if (result.data) {
      this.contacts = result.data;
      this.error = undefined;
    } else if (result.error) {
      this.error = result.error.body
                       ? result.error.body.message
                       : result.error;
      this.contacts = undefined;
    }
  }

  handleEdit(evt) {
    this.selectedContactId = evt.target.dataset.id;
    this.showModal = true;
  }

  handleSave() {
    // refresh the list and then close
    refreshApex(this.wiredContactsResult)
      .then(() => {
        this.showModal = false;
        this.selectedContactId = null;
      })
      .catch(err => console.error(err));
  }

  handleClose() {
    this.showModal = false;
    this.selectedContactId = null;
  }
}
