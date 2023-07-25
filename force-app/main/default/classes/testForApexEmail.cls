public with sharing class testForApexEmail {
    public void sendEmail(){
        
         Messaging.SingleEmailMessage sendSingleEmail = new Messaging.SingleEmailMessage();
        List<String> emailLists=new List<String>();
        emailLists.add('debesh.satapathy@gyansys.com');
        emailLists.add('debesh.satapathy@yahoo.com');
        sendSingleEmail.setSubject('Test for Salesforce Outbound email');
        sendSingleEmail.setPlainTextBody('Test Email body for Outbound email');
        sendSingleEmail.setToAddresses(emailLists);
        sendSingleEmail.setSenderDisplayName('JanaBask Training');
        messaging.email[] emailStatus=new messaging.email[]{sendSingleEmail};
            messaging.sendEmail(emailStatus);

    }
}