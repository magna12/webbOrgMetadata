import { LightningElement, wire,track } from 'lwc';
import GetOrderDetals from '@salesforce/apex/ShowOrderDetals.GetOrderDetails'
export default class OrderDetails extends LightningElement {
    @track Orderdetails ;
    @wire(GetOrderDetals) 
    wiredOrderss({
        error,
        data
    }) {
        if (data) {
            this.Orderdetails = data;
            console.log(data);
            console.log(JSON.stringify(data, null, '\t'));
            
            data.forEach(function (item, key) {
                console.log(key); 
                console.log(item); 
            });
            
        } else if (error) {
            this.error = error;
            console.log('ERROR:::'+JSON.stringify(error));
        }
    }
}