global inherited sharing class messageScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Id messageId=null;
        String scheduleId=sc.getTriggerId();
        String Idval=scheduleId.substring(0,15);
        Scheduled_Message__c schedledMessage=[Select Name,Action_Name__c,Contact__c,Contact__r.MobilePhone,Scheduled_Time__c,Scheduled_Message__c from Scheduled_Message__c where Scheduled_Job_Id__c=:Idval];
        String ANI,DNIS,message_Body,flowid;
        message_Body=schedledMessage.Scheduled_Message__c;
        DNIS=schedledMessage.Contact__r.MobilePhone;
        List<PhoneNumberList__c> customSettingValue=PhoneNumberList__c.getall().values();
        for(PhoneNumberList__c record:customSettingValue){
            if(record.Name==schedledMessage.Action_Name__c){
                System.debug(record.PhoneNumber__c);
                DNIS='+'+record.PhoneNumber__c;
                flowid=record.FlowId__c;
            }
        }
        //Creating a record in SMS Storage Object 
        SMS_Storage__c smsRec = new SMS_Storage__c(
            Name='schedule',
            Text_Values__c=schedledMessage.Action_Name__c,
            Type__c='Sent',
            Message__c=schedledMessage.Scheduled_Message__c,
            Contact__c=schedledMessage.Contact__c,
            Message_type__c='Contact');
        
        insert smsRec;
        messageId=smsRec.id;
        //Calling the API
        String mobileNumber=schedledMessage.Contact__r.MobilePhone;
        ChatBoxApex apicall=new ChatBoxApex();
        apicall.callfuture(mobileNumber,schedledMessage.Scheduled_Message__c,DNIS,flowId,messageId);
    }
}