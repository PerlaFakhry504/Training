// firstNameInput.js
import { LightningElement } from 'lwc';

export default class FirstNameInput extends LightningElement {
  firstName = '';
  email     = '';

  handleFirstNameChange(event) {
    this.firstName = event.target.value;
    console.log('First Name now is:', this.firstName);
  }

  handleEmailChange(event) {
    this.email = event.target.value;
    console.log('email now is:', this.email);
  }

  handleSave() {
    console.log(`Saving contact: ${this.firstName} , email: ${this.email}`);
  }
  
}
