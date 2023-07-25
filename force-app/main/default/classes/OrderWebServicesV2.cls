@RestResource(urlMapping='/Order/*')
global with sharing class OrderWebServicesV2 {

    private class OrderWrapper {
        Account account;
        Contact contact;
        list<ContactWrapper> contacts;
    }

    private class ContactWrapper {
        Contact contact;
    }

    @HttpPost
    global static String doPost() {

        OrderWrapper container = (OrderWrapper)System.JSON.deserialize(
            RestContext.request.requestBody.tostring(), 
            OrderWrapper.class);

        Account acc = container.account;
        Contact con=container.Contact;
        System.debug(con);
        System.debug(acc);
       /* insert acc;

        list<Contact> contactsToInsert = new list <Contact>();
        for (ContactWrapper wcon :container.contacts) {
            wcon.contact.accountId = acc.id;
            contactsToInsert.add(wcon.contact);
        }
        insert contactsToInsert;

        //now wrapper list contains contact ids
        */
        return 'success';
    }
}