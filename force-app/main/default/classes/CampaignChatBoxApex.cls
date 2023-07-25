public inherited sharing class CampaignChatBoxApex {
    //Returning a wrapper class containg Campaign Members and available phone numbers for one to many Message
    @AuraEnabled
    public static wrapperClass CamapignMembers(String CampaignId) {
        wrapperClass returnwrapperClass = new  wrapperClass (); 
        List<CampaignMember> memberList=new List <CampaignMember>();
        returnwrapperClass.memberList=[SELECT CompanyOrAccount,ContactId,Contact.Name,Email,Contact.MobilePhone,Country FROM CampaignMember Where CampaignId=:CampaignId];
        List<PhoneNumberList__c> mcs= new List<PhoneNumberList__c>(); 
        returnwrapperClass.mcs=PhoneNumberList__c.getall().values();
        return returnwrapperClass;
    }
    //Creating the Wrapper class
    public class wrapperClass{
        @AuraEnabled public List<CampaignMember> memberList{get;set;}
        @AuraEnabled public List<PhoneNumberList__c> mcs{get;set;}
    }
    //Creating record in Sms Storage Object and calling the rest Api method with paramaeters.
    @AuraEnabled
    public static void sendSms(List<Id> Ids,String textBody,String campaignId,String textVal){
        List<SMS_Storage__c> insertRecord=new List<SMS_Storage__c>();
        String DNIS;
        String flowid;
        System.debug(Ids);
        list<String>ANI=new List<String>();
        
        List<PhoneNumberList__c> customSettingValue=PhoneNumberList__c.getall().values();
        for(PhoneNumberList__c record:customSettingValue){
            if(record.Name==textVal){
                DNIS='+'+record.PhoneNumber__c;
                flowid=record.FlowId__c;
            }
        }
        Set<Id> setOfMemberIds = new Set<Id>();
        Set<Id> setOfContactIds = new Set<Id>();
        Set<Id> setOfLeadIds = new Set<Id>();
        
        System.debug(textBody);
        setOfMemberIds.addAll(Ids);
        List<CampaignMember> memberList=new List<CampaignMember>();
        memberList=[Select LastName,ContactId,Contact.MobilePhone,LeadId,Lead.mobilePhone,Type From CampaignMember Where id In:setOfMemberIds];
        System.debug('memberList'+memberList);
        map<Id,String>memberDetails=new Map<Id,String>();
        for(CampaignMember member :memberList){
            if(member.Type=='Contact'){
                SMS_Storage__c newSmsInstance = new SMS_Storage__c();	
                newSmsInstance.CampaignId__c=campaignId;
                newSmsInstance.Text_Values__c=textVal;
                newSmsInstance.Name=member.LastName;
                newSmsInstance.Message__c = textBody;
                newSmsInstance.Type__c = 'Sent';
                newSmsInstance.Message_Type__c='Campaign';
                newSmsInstance.contact__c=member.ContactId;
                insert newSmsInstance;
                ChatBoxCallout(member.Contact.MobilePhone,textBody,DNIS,flowid,newSmsInstance.id); 
            }
            if(member.Type=='Lead'){
                SMS_Storage__c newSmsInstance = new SMS_Storage__c();	
                newSmsInstance.CampaignId__c=campaignId;
                newSmsInstance.Text_Values__c=textVal;
                newSmsInstance.Name=member.LastName;
                newSmsInstance.Message__c = textBody;
                newSmsInstance.Type__c = 'Sent';
                newSmsInstance.Message_Type__c='Campaign';
                newSmsInstance.lead__c=member.LeadId;
                insert newSmsInstance;
                ChatBoxCallout(member.Lead.mobilePhone,textBody,DNIS,flowid,newSmsInstance.id); 
                setOfLeadIds.add(member.LeadId);
            }
            
        }
        System.debug('setOfContactIds'+setOfContactIds.size());
        System.debug('setOfLeadIds'+setOfLeadIds);
    }
    //Creating record for schedule Message
    @AuraEnabled
    public static void createScheduleRecord(DateTime datevals,String message,String Action,List<Id>membersList,Id CampaignId){
        Integer Year=datevals.year();
        Integer month=datevals.month();
        Integer datevalue=datevals.day();
        Integer Hour=datevals.hour();
        Integer minute=datevals.minute();
        String scheduleTime='0 '+String.valueOf(minute)+' '+Hour+' '+String.valueOf(datevalue)+' '+month+' ? '+string.valueOf(year);
        System.debug(scheduleTime);
        GroupMessageScheduler scheduleInstance = new GroupMessageScheduler();
        Integer recordAmount=[SELECT COUNT() FROM Scheduled_Message__c WHERE Campaign__C =:CampaignId];
        recordAmount=recordAmount+1;
        String subject='job for '+CampaignId+String.valueOf(recordAmount);
        String jobID = System.schedule(subject,scheduleTime, scheduleInstance);
        String numberList=''; 
        System.debug(membersList);
        for(integer i=0;i<membersList.size();i++){
            if(membersList[i]!=null)
            numberList=numberList+membersList[i]+',';
        }
        
        Scheduled_Message__c messageInstance=new Scheduled_Message__c();
        messageInstance.Name=[Select Name from Campaign where Id=:CampaignId].Name;
        messageInstance.Action_Name__c=Action;
        messageInstance.Campaign__c=CampaignId;
        messageInstance.Scheduled_Time__c=datevals;
        messageInstance.Scheduled_Message__c=message;
        messageInstance.Scheduled_Job_Id__c=jobID;
        messageInstance.Phone_Number_List__c=numberList;
        insert messageInstance;
    }
    public void callfuture(String ANIValue,String message_BodyValue,String DNISValue,String flowIdValue,Id newMessageId){
        ChatBoxCallout(ANIValue,message_BodyValue,DNISValue,flowIdValue,newMessageId);
    }
    //Creating record in salesforce Object(SMS Storage) and calling the rest api function
    @future(callout=true)
    public static void ChatBoxCallout(String ANIValue,String message_BodyValue,String DNISValue,String flowIdValue,Id newMessageId){
        SMS_Storage__c smsInstance=new SMS_Storage__c();
        smsInstance=[Select Status__c from SMS_Storage__c where Id=: newMessageId limit 1];
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://smart-flows.intelepeer.com/api/apitriggers');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody('{"ANI":"'+ ANIValue +'","message_Body":"'+ message_BodyValue +'","DNIS":"'+ DNISValue+'","flowId":"'+flowIdValue+'","recordId":"'+newMessageId+'"}');
            HttpResponse response = http.send(request);
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
}