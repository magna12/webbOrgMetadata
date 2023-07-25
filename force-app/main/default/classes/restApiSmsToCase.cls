@RestResource(urlMapping='/smsToCase/*')
global inherited sharing class restApiSmsToCase {
    //Creating record in SMS Storage object with messge type as CASE and returning Wrapper class with newly created case Number and Case Id
    @HttpPost
    global static String postSms(String ANI, String message_Body,String subject,String description) {
        String contactPhone=ANI;
        String textBody=message_Body;
        Contact contRec=new Contact();
        try{
            contRec = [select Id,AccountId,LastName,MobilePhone from contact where MobilePhone = :contactPhone limit 1];
        }
        catch(Exception ex) {
            System.debug('Error Msg: ' + ex);
            return 'There is no contact with this number';
        }
        SMS_Storage__c newSmsInstance = new SMS_Storage__c();   
        textBody=textBody+' '+'('+contactPhone+')';
        
        //Creating new Case after message received
        Case caseObj = new Case(                 
            ContactId = contRec.Id,
            AccountId = contRec.AccountId,
            Subject=subject,
            Description=description,
            Status = 'Working',
            Origin = 'SMS');
        
        insert caseObj;
        caseObj = [select id, casenumber FROM Case where id = : caseObj.id];
  
        
        //Creating a record of the received message
        newSmsInstance.Name=contRec.LastName;
        newSmsInstance.CaseId__c = caseObj.Id;
        newSmsInstance.Contact__c=contRec.Id;
        newSmsInstance.Message__c = textBody;
        newSmsInstance.Type__c = 'Received';
        newSmsInstance.Message_Type__c='Case';
        insert newSmsInstance;
        String str='{"Case Number":"'+caseObj.casenumber+'","Case id":"'+caseObj.Id+'""}';
        return str;
        
    }    
}