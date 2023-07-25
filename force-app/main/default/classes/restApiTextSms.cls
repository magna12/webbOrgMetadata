@RestResource(urlMapping='/postsms/*')
global with sharing class restApiTextSms {
    @HttpPost
    global static String postSms(String ANI, String message_Body) {
        //Searching for the contact using the received phone number
        String contactPhone=ANI;
        String textBody=message_Body;
        Contact contRec=new Contact();
        try{
        contRec = [select Id,LastName,MobilePhone from contact where MobilePhone = :contactPhone limit 1];
        }
         catch(Exception ex) {
            System.debug('Error Msg: ' + ex);
            return 'There is no Contact with this number';
        }
        //Creating a record for SMS Storage object
        SMS_Storage__c newSmsInstance = new SMS_Storage__c();	
        //        //Searching for the contact using the received phone number

        if(textBody.length()>0){
            newSmsInstance.Name=contRec.LastName;
            newSmsInstance.Contact__c = contRec.Id;
            newSmsInstance.Message__c = textBody;
            newSmsInstance.Type__c = 'Received';
            newSmsInstance.Message_Type__c='Contact';
        }
        //returning state of the DML operation
        try {
            insert newSmsInstance;
            newSmsInstance.Status__c='Success';
            update newSmsInstance;
                        return 'sucess';

        }
        catch(Exception ex) {
            System.debug('Error Msg: ' + ex);
            return 'Fail';
        }
        
    }
    
}