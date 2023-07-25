global class caseEmailer implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        String mySubject = email.subject;
          System.debug(mySubject);
          String sick=mySubject.substring(4,mySubject.length());
                    Registered_User__c rcc=[SELECT id,name,Status__c From Registered_User__c Where name =:sick];
         rcc.Status__c='Approved';
          update rcc;
          //System.debug(body);
                  //String s = 'acc';

           //Boolean unsubMe;
             //     unsubMe = mySubject.contains(s);

          ///System.debug(mySubject);
          //if (unsubMe == true){
            //  System.debug('hell');
          //case c = new case(subject = email.subject, description = email.plainTextBody);
          //insert c;
         
          
      //}

          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          return result;
          
  }
}