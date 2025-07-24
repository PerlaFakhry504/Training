import { LightningElement, api, track, wire } from 'lwc';
import getRelatedDocuments from '@salesforce/apex/WorkOrderHelper.getRelatedDocuments';
import submitReview from '@salesforce/apex/WorkOrderHelper.submitReview';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class CallForReview extends LightningElement {
    @api recordId;

    @track documentSections = [];
    @track missingInfoDescription = '';

    selectedFileIds = new Set();

    // Section-specific missing info
    accountMissingInfo = '';
    contactMissingInfo = '';
    workOrderMissingInfo = '';

    // Dynamically added document requests
    @track requestedDocuments = {
        Account: [],
        Contact: [],
        WorkOrder: []
    };

    // 🔹 Load documents on init
    @wire(getRelatedDocuments, { workOrderId: '$recordId' })
    wiredDocuments({ error, data }) {
        if (data) {
            this.documentSections = [
                { label: 'Account', type: 'Account', files: data.Account || [] },
                { label: 'Contact', type: 'Contact', files: data.Contact || [] },
                { label: 'Work Order', type: 'WorkOrder', files: data['Work Order'] || [] } // match Apex key
            ];
        } else if (error) {
            this.showToast('Error', 'Failed to load documents', 'error');
            console.error('Document load error:', error);
        }
    }

    // 🔹 UI-prepared getter with selected state
    get documentSectionsWithSelection() {
        return this.documentSections.map(section => {
            return {
                ...section,
                fullLabel: `${section.label} Files`,
                placeholder: `Describe missing information for ${section.label} files...`,
                missingInfoLabel: `Missing Information for ${section.label} Files`,
                requestedDocs: this.requestedDocuments[section.type] || [],
                files: section.files.map(file => ({
                    ...file,
                    isSelected: this.selectedFileIds.has(file.Id)
                }))
            };
        });
    }

    // 🔹 Update global missing info
    handleMissingInfoDescriptionChange(e) {
        this.missingInfoDescription = e.target.value;
    }

    // 🔹 Update section-specific missing info
    handleSectionMissingInfoChange(e) {
        const section = e.target.dataset.section;
        const value = e.target.value;

        if (section === 'Account') this.accountMissingInfo = value;
        else if (section === 'Contact') this.contactMissingInfo = value;
        else if (section === 'WorkOrder') this.workOrderMissingInfo = value;
    }

    // 🔹 Checkbox selection for files
    handleCheckboxChange(e) {
        const fileId = e.target.dataset.id;
        if (e.target.checked) {
            this.selectedFileIds.add(fileId);
        } else {
            this.selectedFileIds.delete(fileId);
        }
        // Force LWC reactivity
        this.selectedFileIds = new Set(this.selectedFileIds);
    }

    // 🔹 Add manual doc request
    handleAddDocumentInput(e) {
        const section = e.target.dataset.section;
        const currentDocs = [...this.requestedDocuments[section]];
        const newId = `${section}_${Date.now()}_${Math.random()}`;

        currentDocs.push({
            id: newId,
            value: '',
            label: `Document Request ${currentDocs.length + 1}`
        });

        this.requestedDocuments = {
            ...this.requestedDocuments,
            [section]: currentDocs
        };
    }

    // 🔹 Remove a manual doc request
    handleRemoveDocumentInput(e) {
        const section = e.target.dataset.section;
        const index = parseInt(e.target.dataset.index);
        const currentDocs = [...this.requestedDocuments[section]];

        currentDocs.splice(index, 1);
        currentDocs.forEach((doc, idx) => {
            doc.label = `Document Request ${idx + 1}`;
        });

        this.requestedDocuments = {
            ...this.requestedDocuments,
            [section]: currentDocs
        };
    }

    // 🔹 Update input field value for a requested doc
    handleRequestInputChange(e) {
        const section = e.target.dataset.section;
        const index = parseInt(e.target.dataset.index);
        const value = e.target.value;

        const currentDocs = [...this.requestedDocuments[section]];
        currentDocs[index].value = value;

        this.requestedDocuments = {
            ...this.requestedDocuments,
            [section]: currentDocs
        };
    }

    // 🔹 Submit review to Apex
handleSubmit() {
    const allRequestedDocs = [];

    Object.entries(this.requestedDocuments).forEach(([sectionType, docs]) => {
        docs.forEach(doc => {
            if (doc.value && doc.value.trim()) {
                allRequestedDocs.push({
                    name: doc.value.trim(),
                    type: sectionType
                });
            }
        });
    });

    const requestedNames = allRequestedDocs.map(d => d.name);
    const requestedTypes = allRequestedDocs.map(d => d.type);
    const selectedIdsArray = Array.from(this.selectedFileIds);

    if (selectedIdsArray.length === 0 && requestedNames.length === 0) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Warning',
            message: 'Please select existing files or request new documents',
            variant: 'warning'
        }));
        return;
    }

    submitReview({
        workOrderId: this.recordId,
        missingInfoDescription: this.missingInfoDescription,
        selectedFileIds: selectedIdsArray,
        requestedFileNames: requestedNames,
        requestedFileTypes: requestedTypes,
        accountMissingInfo: this.accountMissingInfo,
        contactMissingInfo: this.contactMissingInfo,
        workOrderMissingInfo: this.workOrderMissingInfo
    })
    .then(() => {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Review submitted successfully',
            variant: 'success'
        }));

        this.resetForm();

        // 🔴 Close modal
        this.dispatchEvent(new CloseActionScreenEvent());
    })
    .catch(error => {
        console.error('Error submitting review:', error);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: error.body?.message || 'Failed to submit review',
            variant: 'error'
        }));
    });
}

    // 🔹 Reset full form
    resetForm() {
        this.missingInfoDescription = '';
        this.accountMissingInfo = '';
        this.contactMissingInfo = '';
        this.workOrderMissingInfo = '';
        this.selectedFileIds = new Set();
        this.requestedDocuments = {
            Account: [],
            Contact: [],
            WorkOrder: []
        };
    }

    // 🔹 Toast helper
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
