import { LightningElement,track,api } from 'lwc';

export default class OrderProductDetails extends LightningElement {
    @api productlist;
    @track columns = [
        {
            label : "Product Name",
            fieldName : "wrap_prodName",
            type : "text",
            sortable: true
        },
        {
            label : "Quantity",
            fieldName : "wrap_prodQuantity",
            type : "text",
            sortable : true,
            cellAttributes: { alignment: 'center' }
        },
        {
            label : "List Price",
            fieldName : "wrap_prodListPrice",
            type : "text",
            sortable : true,
            cellAttributes: { alignment: 'center' }
        },
        {
            label : "Product Name",
            fieldName : "wrap_prodUnitPrice",
            type : "text",
            sortable : true,
            cellAttributes: { alignment: 'center' }
        }
    ]

}