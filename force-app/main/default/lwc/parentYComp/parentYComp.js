import FirstName from '@salesforce/schema/Contact.FirstName';
import { LightningElement } from 'lwc';

export default class ParentYComp extends LightningElement {
    callChildMethod(){
        var childCompInstance = this.template.querySelector('c-child-Y-Comp');
        var param1={'FirstName':'Test'};
        childCompInstance.callFromParent(param1);
    }
    eventfromChild(event){
        alert('Child Event Param1: '+event.detail.FirstName);
        alert('Child Event Param2: '+event.detail.SecondName);
    }
}