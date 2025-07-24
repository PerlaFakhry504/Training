import { LightningElement, track } from 'lwc';
import getOpenCases from '@salesforce/apex/CaseManagerController.getOpenCases';
import closeCase from '@salesforce/apex/CaseManagerController.closeCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseManager extends LightningElement {
    @track cases = [];
    @track refreshKey = 0; 
    connectedCallback() {
        this.loadCases();
    }

    async loadCases() {
        try {
            const result = await getOpenCases();
            this.cases = result;
        } catch (error) {
            console.error('Error loading cases:', error);
            this.showToast('Error', 'Failed to load open cases', 'error');
        }
    }

    async handleCloseCase(event) {
        const caseId = event.target.dataset.id;
        try {
            await closeCase({ caseId });
            this.showToast('Success', 'Case closed successfully', 'success');
            await this.loadCases();

            // 🔄 Force UI refresh via refreshKey
            this.refreshKey += 1;

        } catch (error) {
            console.error('Error closing case:', error);
            this.showToast('Error', 'Failed to close case', 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
