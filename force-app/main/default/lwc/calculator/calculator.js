// calculator.js
import { LightningElement, track } from 'lwc';

export default class Calculator extends LightningElement {
    @track displayValue = '0';

    handleButtonClick(event) {
        const label = event.target.label;
        switch (label) {
            case 'CLR':
                this.displayValue = '0';
                break;
            case '=':
                this.evaluateExpression();
                break;
            default:
                // If currently “0” and you clicked a digit, replace it
                if (this.displayValue === '0' && /\d/.test(label)) {
                    this.displayValue = label;
                } else {
                    // Otherwise append the digit or operator
                    this.displayValue += label;
                }
        }
    }

    evaluateExpression() {
        try {
            // Swap out “×” and “÷” for JS operators
            const expr = this.displayValue
                .replace(/×/g, '*')
                .replace(/÷/g, '/');
            // eslint-disable-next-line no-eval
            this.displayValue = String(eval(expr));
        } catch {
            this.displayValue = 'Error';
        }
    }
}
