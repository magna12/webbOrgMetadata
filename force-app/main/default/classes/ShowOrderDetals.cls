public with sharing class ShowOrderDetals {
    @AuraEnabled(cacheable = true)
    public static List<OrderwrapperClass> GetOrderDetails() {
        List<OrderwrapperClass> returnedWrapperList = New List<OrderwrapperClass>();
        List<Order> allOrders = New List<Order>([Select Id,OrderNumber,(Select id,Product2.Name,Quantity,ListPrice,UnitPrice from OrderItems) from Order]);
        For(Order ordInstance : allOrders){
            OrderwrapperClass returnedWrapper = New OrderwrapperClass();
            List<productWrapperClass> prodwrapList = New List<productWrapperClass>();
            returnedWrapper.wrap_OrderId = ordInstance.id;
            returnedWrapper.wrap_OrderNumber = ordInstance.OrderNumber;
            For(OrderItem ordItemInsta : ordInstance.orderItems){
                productWrapperClass prodwrapInstance = New productWrapperClass();
                prodwrapInstance.wrap_prodId = ordItemInsta.id;
                prodwrapInstance.wrap_prodName = String.valueof(ordItemInsta.Product2.Name);
                prodwrapInstance.wrap_prodQuantity = String.valueOf(ordItemInsta.Quantity);
                prodwrapInstance.wrap_prodListPrice = String.valueOf(ordItemInsta.ListPrice);
                prodwrapInstance.wrap_prodUnitPrice = String.valueOf(ordItemInsta.UnitPrice);
                prodwrapList.add(prodwrapInstance);
            }
            returnedWrapper.OrderItems = prodwrapList;
            returnedWrapperList.add(returnedWrapper);            
        }
        Return returnedWrapperList;
    }

public class OrderwrapperClass{
    @AuraEnabled public String wrap_OrderNumber{get;set;}
    @AuraEnabled public String wrap_OrderId{get;set;}
    @AuraEnabled public List<productWrapperClass> OrderItems {get;set;}
}
public class productWrapperClass{
    @AuraEnabled public String wrap_prodId{get;set;}
    @AuraEnabled public String wrap_prodName{get;set;}
    @AuraEnabled public String wrap_prodQuantity{get;set;}
    @AuraEnabled public String wrap_prodListPrice{get;set;}
    @AuraEnabled public String wrap_prodUnitPrice{get;set;}
}
}