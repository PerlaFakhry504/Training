import { LightningElement, track } from 'lwc';

// Metadata for each object, with proper shapes for display-info and matching-info
const OBJECT_META = {
  Account: {
    label: 'Account',
    displayInfo: {
      primaryField: 'Name',
      additionalFields: ['Type']
    },
    matchingInfo: {
      primaryField: { fieldPath: 'Name' },
      additionalFields: [{ fieldPath: 'Industry' }]
    }
  },
  Contact: {
    label: 'Contact',
    displayInfo: {
      primaryField: 'Name',
      additionalFields: ['Phone']
    },
    matchingInfo: {
      primaryField: { fieldPath: 'Name' },
      additionalFields: [{ fieldPath: 'Email' }]
    }
  }
};

export default class RecordPickerDynamicTarget extends LightningElement {
  @track selectedObject = null;
  @track selectedRecordId = null;

  // 1) Combobox options from our meta
  get objectOptions() {
    return Object.keys(OBJECT_META).map(key => ({
      label: OBJECT_META[key].label,
      value: key
    }));
  }

  // 2) Only show the object selector until a record is picked
  get showObjectSelector() {
    return !this.selectedRecordId;
  }

  // 3) Show the picker once an object is selected (and before record is picked)
  get showRecordPicker() {
    return this.selectedObject && !this.selectedRecordId;
  }

  // 4) Provide the correctly‐shaped displayInfo object
  get displayInfo() {
    return OBJECT_META[this.selectedObject]?.displayInfo
         || { primaryField: 'Name' };
  }

  // 5) Provide the correctly‐shaped matchingInfo object
  get matchingInfo() {
    return OBJECT_META[this.selectedObject]?.matchingInfo
         || { primaryField: { fieldPath: 'Name' } };
  }

  // 6) Handle user picking Account vs Contact
  handleObjectChange(event) {
    this.selectedObject   = event.detail.value;
    this.selectedRecordId = null;
  }

  // 7) Handle the record‐picker’s selection event
  handleRecordChange(event) {
    this.selectedRecordId = event.detail.value;
  }

  // 8) Reset back to the top
  resetAll() {
    this.selectedObject   = null;
    this.selectedRecordId = null;
  }
}
