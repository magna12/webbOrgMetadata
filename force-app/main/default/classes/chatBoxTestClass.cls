@isTest
public class chatBoxTestClass {
    //Creating records for the test class 
    @testSetup static void setup() {
        //Creating contact Record
        Contact contactRef=new Contact();
        contactRef.LastName='Check';
        contactRef.MobilePhone='123456789';
        insert contactRef;
        
        Lead newLead=new Lead();
        newLead.LastName='test';
        newLead.Company='test Company';
        newLead.MobilePhone='+1934532223';
        insert newLead;
       
        //Creating case Record
        Case caseRef=new Case();
        caseRef.ContactId=contactRef.Id;
        insert caseRef;
        
        //Creating Campaign
        Campaign campaignInstance=new Campaign();
        campaignInstance.Name='test';
        insert campaignInstance;
        
        //Creating campaign member
        CampaignMember newMember=new CampaignMember();
        newMember.CampaignId=campaignInstance.Id;
        newMember.ContactId=contactRef.Id;
        insert newMember;
        
        //Creating campaign member
        CampaignMember newLeadMember=new CampaignMember();
        newLeadMember.CampaignId=campaignInstance.Id;
        newLeadMember.LeadId=newLead.Id;
        insert newLeadMember;
        
        //Creating action record
        PhoneNumberList__c newCustomRecord=new PhoneNumberList__c();
        newCustomRecord.Name='Test';
        newCustomRecord.Active__c=true;
        newCustomRecord.FlowId__c='textforflow';
        newCustomRecord.PhoneNumber__c='9658527277';
        newCustomRecord.Text_Values__c='testAction';
        insert newCustomRecord;
        
        //Creating action record
        PhoneNumberList__c newCustomRecordInstance=new PhoneNumberList__c();
        newCustomRecordInstance.Name='Test1';
        newCustomRecordInstance.Active__c=true;
        newCustomRecordInstance.FlowId__c='textforflo1w';
        newCustomRecordInstance.PhoneNumber__c='96585272717';
        newCustomRecordInstance.Text_Values__c='testAct1ion';
        insert newCustomRecordInstance;
        
    }
    static testMethod void smsTest() {
        Contact conInstance=[Select Id From Contact Where MobilePhone=:'123456789' limit 1];
        Lead leadInstance=[Select Id from Lead where lastName='test'];
        PhoneNumberList__c ActionInstance=[Select Active__c,PhoneNumber__c,FlowId__c,Text_Values__c From PhoneNumberList__c limit 1];
        List<Id> availablemembers=new List<Id>();
        List<PhoneNumberList__c> numberlIst=new List<PhoneNumberList__c>();
        PhoneNumberList__c newCustomRecordTest=[Select Name,Active__c,FlowId__c,PhoneNumber__c,Text_Values__c from PhoneNumberList__c where name='Test1'];
        numberlIst.add(newCustomRecordTest);
        CampaignMember newMember=[Select Id from CampaignMember where ContactId=:conInstance.Id limit 1];
        availablemembers.add(newMember.Id);
        CampaignMember newLeadMember=[Select Id from CampaignMember where LeadId=:leadInstance.Id limit 1];
        availablemembers.add(newLeadMember.Id);
        Campaign campaignInstance=[select Id from Campaign where Name=:'test' limit 1];
        DateTime scheduleTime=System.now();
        scheduleTime=scheduleTime.addMinutes(2);
        
        //calling restApiTextSms class's postSms function
        restApiTextSms.postSms('123456789','hello');
        System.assertEquals([Select Count() from SMS_Storage__c where Type__c = 'Received'], 1);
        
        //Calling ChatBoxApex class's getUserSession function
        String currentSessionId=ChatBoxApex.getUserSession();
        //System.assertEquals(currentSessionId,userInfo.getSessionId());
        
        //Calling ChatBoxApex class's saveMessageRecord function
        ChatBoxApex.saveMessageRecord('testing',conInstance.Id,'Testing');
        System.assertEquals([Select Id,Message__c from SMS_Storage__c where Text_Values__c='Testing'].size() ,1);
        
        //Calling ChatBoxApex class's chatdetail function
        chatBoxApex.chatdetail(conInstance.Id);
        System.assertEquals([Select Count() from SMS_Storage__c],2);
        
        //Calling ChatBoxApex class's createScheduleRecord function
        ChatBoxApex.createScheduleRecord(scheduleTime,'test','Jason',conInstance.Id);
        System.assertEquals([Select count() from Scheduled_Message__c],1);
        
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('123456789','subscribe','Promo');
        System.assertEquals(messageAutoResponse.postSms('123456789','subscribe','Promo'),'You have Successfully been subscribed to the Promo notification list');
        
        //calling restApiSmsToCase class's postSms function
        restApiSmsToCase.postSms('123456789','test','test1','test2');
        System.assertEquals([Select Count() from SMS_Storage__c where Message_Type__c='Case'], 1);
        
        //calling CampaignChatBoxApex class's CamapignMembers function
        CampaignChatBoxApex.CamapignMembers(campaignInstance.Id);
        System.assertEquals([Select Count() from CampaignMember], 2);
        
        //calling CampaignChatBoxApex class's sendSms function
        CampaignChatBoxApex.sendSms(availablemembers,'test',campaignInstance.Id,ActionInstance.Text_Values__c);
        System.assertEquals([Select Count() from SMS_Storage__c where Message_Type__c='Campaign'], 2);
        
        //calling CampaignChatBoxApex class's schedule message function
        CampaignChatBoxApex.createScheduleRecord(scheduleTime,'test','Jason',availablemembers,[Select Id from Campaign where name='test'].Id);
        
        
        //calling AdminPageApex class's numberList function
        //AdminPageApex.numberList();
        System.assertEquals(AdminPageApex.numberList().size(),2);
        
        //calling AdminPageApex class's numberList function
        //AdminPageApex.createNewNumber('Test5','96556654565','TestActio5n','testFlowI5d');
        System.assertEquals(AdminPageApex.createNewNumber('Tes65','96556654565',True,'testFlowI5d').size(),3);
        
        //calling AdminPageApex class's updateRecord function
        //AdminPageApex.updateRecord(numberlIst);
        System.assertEquals(AdminPageApex.updateRecord(numberlIst).size(),1);
        
        //calling AdminPageApex class's updateRecord function
        //AdminPageApex.deletedRecord(numberlIst,newCustomRecordTest.Id);
        System.assertEquals(AdminPageApex.deletedRecord(numberlIst,newCustomRecordTest.Id).size(),0);
        
    }
    
    static testMethod void elseCondition(){
        PhoneNumberList__c newCustomRecord=[Select Active__c,PhoneNumber__c,FlowId__c,Text_Values__c From PhoneNumberList__c limit 1];
        Contact con=[Select Id From Contact Where MobilePhone=:'123456789' limit 1];
        Case caseCheck=[Select Id From Case Where ContactId=:con.Id limit 1];
        
        //Calling ChatBoxApex class's saveMessageRecord function
        ChatBoxApex.saveMessageRecord('test',caseCheck.Id,'Testing');
        System.assertEquals([Select Id,Message__c from SMS_Storage__c where Text_Values__c='Testing'].size() ,1);
        
        //Calling ChatBoxApex class's chatdetail function
        chatBoxApex.chatdetail(caseCheck.Id);  
        System.assertEquals([Select Count() from SMS_Storage__c],1);
        
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('1234567893','subscribe','All');
        System.assertEquals(messageAutoResponse.postSms('123456789','subscribe','All'),'You have Successfully been subscribed to the NOC and Promo notification list');
        
        //calling restApiTextSms class's postSms function
        restApiTextSms.postSms('123456789','');
        System.assertEquals([Select Count() from SMS_Storage__c where Type__c = 'Received'], 1);
        
        //calling restApiSmsToCase class's postSms function
        restApiSmsToCase.postSms('1234567789','test','test1','test2');
        System.assertEquals([Select Count() from SMS_Storage__c where Message_Type__c='Case'], 1);
        
    }
    
    static testMethod void testMethod1(){
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('123456789','Unknkown','All');
        System.assertEquals(messageAutoResponse.postSms('123456789','Unknkown','All'),'Wrong Input');
        
    }
    static testMethod  void testMethod2(){
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('123456789','subscribe','noc');
        System.assertEquals(messageAutoResponse.postSms('123456789','subscribe','noc'),'You have Successfully been subscribed to the NOC notification list');
        
    }
    static testMethod  void testMethod3(){
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('123456789','UNSUBSCRIBE','noc');
        System.assertEquals(messageAutoResponse.postSms('123456789','UNSUBSCRIBE','noc'),'You have Successfully been UnSubscribed to the NOC notification list');
        
    }
    static testMethod  void testMethod4(){
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('123456789','UNSUBSCRIBE','All');
        System.assertEquals(messageAutoResponse.postSms('123456789','UNSUBSCRIBE','All'),'You have Successfully UnSubscribed from all notification list');
        
    }
    static testMethod  void testMethod5(){
        //calling messageAutoResponse class's postSMS funtion 
        //messageAutoResponse.postSms('123456789','UNSUBSCRIBE','promo');
        System.assertEquals(messageAutoResponse.postSms('123456789','UNSUBSCRIBE','promo'),'You have Successfully been UnSubscribed to the Promo notification list');
        
    }
    /* static testMethod  void testMethod6(){
messageAutoResponse.postSms('123456789','subscribe','All');
//calling messageAutoResponse class's postSMS funtion 
//messageAutoResponse.postSms('1234567893','subscribe','All');
System.assertEquals(messageAutoResponse.postSms('1234567893','subscribe','All'),'You have Successfully been subscribed to the NOC and Promo notification list');

}*/
    
}