public class getaccountcontacts {
    @AuraEnabled
    public static List<Account> getRecords(String recId){
        
        return [Select id,Name,Type,(Select id,LastName,email From Contacts) From Account where id=:recId];
    }
}