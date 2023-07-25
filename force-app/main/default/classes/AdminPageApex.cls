public inherited sharing class AdminPageApex {
    @AuraEnabled
    //Returning Available phone number to the script
    public static list<PhoneNumberList__c> numberList(){
        return PhoneNumberList__c.getall().values();
    }
//Creating a new record with respective Phone Number,flowId,text Value received from the Admin in Custom setting  
    @AuraEnabled
    public static list<PhoneNumberList__c> createNewNumber(String Name,String PhoneNumber,Boolean ActiveStatus,String Flow_Id){
        PhoneNumberList__c newRecord=new PhoneNumberList__c();
        newRecord.name=Name;
        newRecord.PhoneNumber__c=PhoneNumber;
        newRecord.Active__C=ActiveStatus;
        newRecord.FlowId__c=Flow_Id;
        insert newRecord;
        return PhoneNumberList__c.getall().values();
    }
    //Updating the Action records and returning the updated Action list and returning the updated Action list
    @AuraEnabled
    public Static list<PhoneNumberList__c> updateRecord(List<PhoneNumberList__c> customlist){
        update customlist;
        return customlist;
    }
    //Deleting Action record
    @AuraEnabled
    public static list<PhoneNumberList__c> deletedRecord(List<PhoneNumberList__c> recordList,String idVal)
    {
                System.debug(recordList);
      PhoneNumberList__c deleteRecord=new PhoneNumberList__c();
        List<PhoneNumberList__c> recordList1=new List<PhoneNumberList__c>();
        for(Integer i=0;i<recordList.size();i++){
            if(idVal==recordList[i].Id){
               deleteRecord= recordList[i];
            }
            else{
                recordList1.add(recordList[i]);
            }
        }
        delete deleteRecord;
        return recordList1;
    }
}