@RestResource(urlMapping='/smsRequest/*')
global inherited sharing class messageAutoResponse {
    @HttpPost
    global static String postSms(String ANI, String action,String NotificationList) {
       String contactDetails=ANI;
        SMS_Storage__c chat = new SMS_Storage__c();	
        chat.Type__c = 'Received';
        chat.Message_Type__c='Contact';
        requestMessageHistory__c newSmsInstance = new requestMessageHistory__c();
        String textBody='';
        Contact contRec=new Contact();
        try
        {
            contRec = [select Id,AccountId,LastName,MobilePhone from contact where MobilePhone = :contactDetails limit 1];
        }
        catch(Exception ex) {
            textBody='cant find any contact with the received phone number';  
        }
         if(NotificationList=='Unknkown'||action=='Unknkown'){	
                            textbody='TBD';
                        }
        if(contRec.Id!=null&&NotificationList!='Unknkown'&&action!='Unknkown'){
            if(action=='subscribe'){
                
                    newSmsInstance.Contact_Name__c=contRec.Id;
                    newSmsInstance.name=contRec.LastName;
                    newSmsInstance.NotificationList__c=NotificationList;
                    chat.Name=contRec.LastName;
                    chat.Contact__c = contRec.Id;
                       
                     
                            if(action=='SUBSCRIBE'){
                                newSmsInstance.Action__c=action; 
                                if(NotificationList=='NOC'){
                                    contRec.NOC__c=true;
                                    textbody='You have Successfully been subscribed to the NOC notification list';
                                    chat.Message__c = 'User subscribed to Notification list: NOC';
                                }
                                if(NotificationList=='Promo'){
                                    contRec.Promo__c=true;
                                    textbody='You have Successfully been subscribed to the Promo notification list';
                                    chat.Message__c = 'User subscribed to Notification list: Promo';
                                }
                                if(NotificationList=='All'){
                                    contRec.NOC__c=true;
                                    contRec.Promo__c=true;	
                                    textbody='You have Successfully been subscribed to the NOC and Promo notification list';
                                    chat.Message__c = 'User subscribed to Notification list: NOC and Promo';
                                }
                            }
            }
                                                    
                            if(action=='UNSUBSCRIBE'.toLowerCase()){
                                      newSmsInstance.Contact_Name__c=contRec.Id;
                    newSmsInstance.name=contRec.LastName;
                    newSmsInstance.NotificationList__c=NotificationList;
                    chat.Name=contRec.LastName;
                    chat.Contact__c = contRec.Id;
                                newSmsInstance.Action__c=action; 
                                if(NotificationList=='NOC'){
                                    contRec.NOC__c=false;
                                    textbody='You have Successfully been UnSubscribed to the NOC notification list';
                                    chat.Message__c = 'User Un-subscribed from Notification list: NOC';
                                }
                                
                                if(NotificationList=='Promo'){
                                    contRec.Promo__c=false;
                                    textbody='You have Successfully been UnSubscribed to the Promo notification list';
                                    chat.Message__c = 'User Un-subscribed from Notification list: Promo';
                                }
                                
                                if(NotificationList=='All'.toLowerCase()){
                                    contRec.NOC__c=false;
                                    contRec.Promo__c=false;	
                                    textbody='You have Successfully UnSubscribed from all notification list';
                                    chat.Message__c = 'User Un-subscribed from Notification list: NOC and Promo';
                                }
                            }
        }
                    try{
                        if(NotificationList!='Unknkown'&&Action!='Unknkown'){
                        insert chat ;
                            System.debug('iserting');
                                                    update contRec;
                        }
                                                                        insert newSmsInstance;

                    }
                    catch(Exception ex) {
                        System.debug('Error Msg: ' + ex);
                        textBody= 'Wrong Input';
                    }
        
        return textBody;
    }
}