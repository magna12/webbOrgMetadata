public inherited sharing class ChatBoxApex {
    //Returing message history of the respective Number when page loads
    @AuraEnabled                        
    public static wrapperClass chatDetail(Id contactId)   
    {
        String sObjName = contactId.getSObjectType().getDescribe().getName();
        wrapperClass returnwrapperClass = new  wrapperClass ();        
        List<SMS_Storage__c> chatInfo = new List<SMS_Storage__c>();
        returnwrapperClass.availableNumbers=PhoneNumberList__c.getall().values();
        System.debug(PhoneNumberList__c.getall().values());
        if(sObjName=='Contact'){
            returnwrapperClass.chatInfo=[select id,Status__c,Message_Type__c,name,Contact__r.Name,Message__c,Type__c,Text_Values__c,createddate from SMS_Storage__c where Contact__c =: contactId AND Message_Type__c!=: 'Case' ORDER BY createddate];
       returnwrapperClass.Mobile=[Select Id,MobilePhone from contact where Id=:contactId].MobilePhone;
        }
        else{
            returnwrapperClass.chatInfo=[select id,Status__c,Message_Type__c,name,Contact__r.Name,Message__c,Type__c,createddate from SMS_Storage__c where Message_Type__c=: 'Case' AND CaseId__c=:contactId ORDER BY createddate];
               returnwrapperClass.Mobile=[Select Id,contact.MobilePhone from Case where Id=:contactId].contact.MobilePhone;
        }
        System.debug(returnwrapperClass);
        return returnwrapperClass;
    }
    public class wrapperClass{
        @AuraEnabled public List<SMS_Storage__c> chatInfo{get;set;}
        @AuraEnabled public List<PhoneNumberList__c> availableNumbers{get;set;}
        @AuraEnabled public String Mobile{get;set;}
    }
    
    //Creating record in salesforce Object(SMS Storage) and calling the rest api function
    @AuraEnabled
    public static List<SMS_Storage__c> saveMessageRecord(String msg,Id contactId,String textVal)  
    {
        String ANI,DNIS,message_Body,flowid;
        message_Body=msg;
        List<PhoneNumberList__c> customSettingValue=PhoneNumberList__c.getall().values();
        for(PhoneNumberList__c record:customSettingValue){
            if(record.Name==textVal){
                System.debug(record.PhoneNumber__c);
                DNIS='+'+record.PhoneNumber__c;
                flowid=record.FlowId__c;
            }
        }
        List<SMS_Storage__c> updatedList = new List<SMS_Storage__c>();
        String sObjName = contactId.getSObjectType().getDescribe().getName();
        if(sObjName=='Contact'){
            Contact contactName=[Select LastName,MobilePhone From Contact where Id=:contactId];
            if(contactName.MobilePhone!=null)
            ANI=contactName.MobilePhone;
            System.debug('ani'+ANI);
            SMS_Storage__c smsRec = new SMS_Storage__c(
                Name=contactName.LastName,
                Text_Values__c=textVal,
                Type__c='Sent',
                Message__c=msg,
                Contact__c=contactId,
                Message_type__c='Contact');
            insert smsRec;
            updatedList = [select id,name,Status__c,Contact__r.Name,Message__c,Text_Values__c,Type__c,createddate from SMS_Storage__c where Contact__c =: contactId ORDER BY createddate];
            ChatBoxCallout(ANI,message_Body,DNIS,flowId,smsRec.Id); 
        }
        else{
            Case case1=[Select ContactId,Contact.LastName,Contact.MobilePhone From Case where Id=:contactId];
            ANI=case1.contact.MobilePhone;
            
            SMS_Storage__c smsRec = new SMS_Storage__c(
                Name=case1.contact.LastName,
                Text_Values__c=textVal,
                Type__c='Sent',
                Message__c=msg,
                CaseId__c=contactId,
                Message_type__c='Case');
            insert smsRec;
            updatedList = [select id,Status__c,Message_Type__c,name,Contact__r.Name,Message__c,Text_Values__c,Type__c,createddate from SMS_Storage__c where Message_Type__c=: 'Case' ORDER BY createddate];
            ChatBoxCallout(ANI,message_Body,DNIS,flowId,smsRec.Id); 
        }
        return updatedList;
    }
    //Creating record for schedule Message
    @AuraEnabled
    public static void createScheduleRecord(DateTime timevals,String message,String Action,Id ContactId){
        Integer Year=timevals.year();
        Integer month=timevals.month();
        Integer datevalue=timevals.day();
        Integer Hour=timevals.hour();
        integer minute=timevals.minute();
        String scheduleTime='0 '+String.valueOf(minute)+' '+Hour+' '+String.valueOf(datevalue)+' '+month+' ? '+string.valueOf(year);
        System.debug(scheduleTime);
        messageScheduler scheduleInstance = new messageScheduler();
        Integer recordAmount=[SELECT COUNT() FROM Scheduled_Message__c WHERE Contact__c =:ContactId];
        recordAmount=recordAmount+1;
        String subject='job for '+ContactId+String.valueOf(recordAmount);
         String jobID = System.schedule(subject,scheduleTime, scheduleInstance);
        System.debug('JobId'+jobID);
        Scheduled_Message__c messageInstance=new Scheduled_Message__c();
        messageInstance.Name=[Select Name from Contact where Id=:ContactId].Name;
        messageInstance.Action_Name__c=Action;
        messageInstance.Contact__c=ContactId;
        messageInstance.Scheduled_Time__c=timevals;
        messageInstance.Scheduled_Message__c=message;
        messageInstance.Scheduled_Job_Id__c=jobID;
        insert messageInstance;
    }
    //Making Rest callout to smart flow with required message body ,FLOW Id and phone numbers
    public void callfuture(String ANIValue,String message_BodyValue,String DNISValue,String flowIdValue,Id newMessageId){
        ChatBoxCallout(ANIValue,message_BodyValue,DNISValue,flowIdValue,newMessageId);
    }
    //Api call is happening in this function
    @future(callout=true)
    public static void ChatBoxCallout(String ANIValue,String message_BodyValue,String DNISValue,String flowIdValue,Id newMessageId)
    {
        SMS_Storage__c smsInstance=new SMS_Storage__c();
        smsInstance=[Select Status__c from SMS_Storage__c where Id=: newMessageId limit 1];
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://smart-flows.intelepeer.com/api/apitriggers/');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody('{"ANI":"'+ANIValue+'","message_Body":"'+ message_BodyValue +'","DNIS":"'+DNISValue+'","flowId":"'+flowIdValue+'","recordId":"'+newMessageId+'"}');
            System.debug(ANIValue);
            System.debug(DNISValue);
            System.debug('Request'+request.getBody());
            HttpResponse response = http.send(request);
            
            System.debug(response);
            System.debug(response.getBody());
            if(response.getStatusCode()==200){
                smsInstance.Status__c='Successfully delivered to smartFlow';
            }
            if(response.getStatusCode()!=200){
                smsInstance.Status__c='Failed to connect to smartFlow';
            }
        }
        
        
        
        catch(Exception e){
            smsInstance.Status__c='Failed to connect to smartFlow';
            System.debug('Message send was un-successful:'+e);        
        }
        update smsInstance;
    }
    //returns the userSessionId
    @AuraEnabled
    public static string getUserSession(){
        return userInfo.getSessionId();
    }
    
}