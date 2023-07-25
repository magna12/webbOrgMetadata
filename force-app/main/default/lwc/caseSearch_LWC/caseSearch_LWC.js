import { LightningElement,api,wire,track } from 'lwc';
import ShownCases from '@salesforce/apex/ShownCreateCases.ShownCases'
export default class CaseSearch_LWC extends LightningElement {
@track CaseList
@track error
@track columns =[
    {
        label : "Case Number",
        fieldName :"CaseNumber",
        type : "text",
        sortable : true
    },
    {
        label : "Case Status",
        fieldName : "Status",
        type : "text",
        sortable : true
    },
    {
        label : "Case Subject",
        fieldName : "Subject",
        type : "text",
        sortable : true
    },
    {
        label : "Case Created Date",
        fieldName : "CreatedDate",
        type : "datetime",
        sortable : true
    }

]
@wire(ShownCases)
Show10Cases({error,data}){
        if(data){
        this.CaseList = data;
        console.log('Returned Cases'+JSON.stringify(this.CaseList))
        }
        else if(error){
        this.error = error;
        }
    }

}