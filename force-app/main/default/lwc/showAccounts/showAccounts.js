import { LightningElement,api,wire,track } from 'lwc';
import searchAccount from '@salesforce/apex/SearchAccountInLWC.searchAccount'
export default class ShowAccounts extends LightningElement {
@track accList;
@track error;
@track isModalOpen = false;
@track columns = [
    {
        label : "Account Name",
        fieldName: "Name",
        type : "Text",
        sortable : "true"
    },
    {
        label : "Account Phone",
        fieldName: "Phone",
        type : "Phone",
        sortable : "true"
    },
    {
        label : "Account Rating",
        fieldName: "Rating",
        type : "Text",
        sortable : "true"
    }
                ]
    @wire(searchAccount) 
    allAccounts({error,data}){
        if(data){
            this.accList = data;
        }
        else if(error){
            this.error = error;
        }
    }

    handleClick (event){
        this.isModalOpen = true;
        //alert('Create New Account Page')
    }
    closeModal(event){
        this.isModalOpen = false;
    }
}