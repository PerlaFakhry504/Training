import { LightningElement } from 'lwc';

export default class PromoComponent extends LightningElement {

    x = 10; //global variable that i can use in all components
    handleClick(){
        alert("hello:" + this.x); 
    }
}