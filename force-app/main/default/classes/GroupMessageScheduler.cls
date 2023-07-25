global with sharing class GroupMessageScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Id messageId=null;
        String DNIS,flowid;
        String scheduleId=sc.getTriggerId();
        String Idval=scheduleId.substring(0,15);
        Scheduled_Message__c schedledMessage=[Select Name,Campaign__c,Phone_Number_List__c,Action_Name__c,Contact__c,Contact__r.MobilePhone,Scheduled_Time__c,Scheduled_Message__c from Scheduled_Message__c where Scheduled_Job_Id__c=:Idval];
        System.debug('group schedule'+schedledMessage);
        List<SMS_Storage__c> insertRecord=new List<SMS_Storage__c>();
        list<String>ANI=new List<String>();
        List<PhoneNumberList__c> customSettingValue=PhoneNumberList__c.getall().values();
        for(PhoneNumberList__c record:customSettingValue){
            if(record.Name==schedledMessage.Action_Name__c){
                DNIS='+'+record.PhoneNumber__c;
                flowid=record.FlowId__c;
            }
        }
        CampaignChatBoxApex apicall=new CampaignChatBoxApex();
        Set<Id> setOfMemberIds = new Set<Id>();
        Set<Id> setOfContactIds = new Set<Id>();
        Set<Id> setOfLeadIds = new Set<Id>();
       	List<String> Ids= schedledMessage.Phone_Number_List__c.split(',');
        for(Integer i=0;i<Ids.size();i++){
           setOfMemberIds.add(Ids[i].trim()); 
        }
        System.debug('IdList'+Ids);
        List<CampaignMember> memberList=new List<CampaignMember>();
        memberList=[Select LastName,ContactId,LeadId,Type From CampaignMember Where id In:setOfMemberIds];
        System.debug('memberList'+memberList);
        map<Id,String>memberDetails=new Map<Id,String>();
        for(CampaignMember member :memberList){
            if(member.Type=='Contact')
                setOfContactIds.add(member.ContactId);
            if(member.Type=='Lead')
                setOfLeadIds.add(member.LeadId);
        }
        if(setOfContactIds.size() > 0)
        {
            for(Contact contactInstance:[Select iD,LastName,MobilePhone From Contact where Id IN: setOfContactIds])
            {
                If(contactInstance.MobilePhone!=null){
                    SMS_Storage__c newSmsInstance = new SMS_Storage__c();	
                    newSmsInstance.CampaignId__c=schedledMessage.Campaign__c;
                    newSmsInstance.Text_Values__c=schedledMessage.Action_Name__c;
                    newSmsInstance.Name=contactInstance.LastName;
                    newSmsInstance.Message__c = schedledMessage.Scheduled_Message__c;
                    newSmsInstance.Type__c = 'Sent';
                    newSmsInstance.Message_Type__c='Campaign';
                    newSmsInstance.contact__c=contactInstance.Id;
                    insert newSmsInstance;
                    apicall.callfuture(contactInstance.MobilePhone,schedledMessage.Scheduled_Message__c,DNIS,flowid,newSmsInstance.id); 
                }
            }
        }
        
        if(setOfLeadIds.size()>0)
        {
            for(Lead contactInstance:[Select MobilePhone,LastName From Lead where Id in:setOfLeadIds]){
                system.debug('phone'+contactInstance.MobilePhone);
                If(contactInstance.MobilePhone!=null){
                    SMS_Storage__c newSmsInstance = new SMS_Storage__c();	
                    newSmsInstance.CampaignId__c=schedledMessage.Campaign__c;
                    newSmsInstance.Text_Values__c=schedledMessage.Campaign__c;
                    newSmsInstance.Name=contactInstance.LastName;
                    newSmsInstance.Message__c = schedledMessage.Scheduled_Message__c;
                    newSmsInstance.Type__c = 'Sent';
                    newSmsInstance.Message_Type__c='Campaign';
                    newSmsInstance.lead__c=contactInstance.Id;
                    insert newSmsInstance;
                    apicall.callfuture(contactInstance.MobilePhone,schedledMessage.Scheduled_Message__c,DNIS,flowid,newSmsInstance.id); 
                }
            }
        }
    }
    
}