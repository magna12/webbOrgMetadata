import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    greetings="Shadow";
    changeHandler(event){
        this.greetings=event.target.value;
    }
}