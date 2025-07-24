import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import updateContact from '@salesforce/apex/ContactsController.updateContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = [
  'Contact.FirstName',
  'Contact.LastName',
  'Contact.Phone',
  'Contact.Email'
];

export default class ContactEditModal extends LightningElement {
  @api contactId;
  @track firstName = '';
  @track lastName  = '';
  @track phone     = '';
  @track email     = '';

  // 1) load the record’s current values
  @wire(getRecord, { recordId: '$contactId', fields: FIELDS })
  wiredContact({ data, error }) {
    if (data) {
      this.firstName = getFieldValue(data, FIELDS[0]);
      this.lastName  = getFieldValue(data, FIELDS[1]);
      this.phone     = getFieldValue(data, FIELDS[2]);
      this.email     = getFieldValue(data, FIELDS[3]);
    } else if (error) {
      this.showToast('Error loading contact', error.body.message, 'error');
    }
  }

  // 2) handlers to keep your @track fields in sync
  handleFirstNameChange(evt) { this.firstName = evt.target.value; }
  handleLastNameChange(evt)  { this.lastName  = evt.target.value; }
  handlePhoneChange(evt)     { this.phone     = evt.target.value; }
  handleEmailChange(evt)     { this.email     = evt.target.value; }

  // 3) on Save: validate, then call your Apex updateContact
  handleSave() {
    const fullName = (this.firstName||'') + (this.lastName||'');
    if (fullName.length > 10) {
      return this.showToast(
        'Validation Error',
        'Full name must be 10 characters or fewer.',
        'error'
      );
    }

    const payload = {
      Id:        this.contactId,
      FirstName: this.firstName,
      LastName:  this.lastName,
      Phone:     this.phone,
      Email:     this.email
    };

    updateContact({ cntct: payload })
      .then(() => {
        this.dispatchEvent(new CustomEvent('save'));
        this.showToast('Success', 'Contact updated', 'success');
      })
      .catch(err => {
        this.showToast(
          'Save Error',
          err.body?.message || err.message,
          'error'
        );
      });
  }

  // 4) Cancel just bubbles up
  handleCancel() {
    this.dispatchEvent(new CustomEvent('cancel'));
  }

  // helper to show toast messages
  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({ title, message, variant })
    );
  }
}