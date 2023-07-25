import { LightningElement,api,track } from 'lwc';

export default class HorizontalTimeline extends LightningElement {
    @api recordId;
    @track multiselectvalue=true;
    @track defaultValues=[{'label':'test1', 'value':'123'}];
    @track slectedval =[];
}