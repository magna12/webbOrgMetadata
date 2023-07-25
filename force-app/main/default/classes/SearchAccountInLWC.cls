public with sharing class SearchAccountInLWC {
    @AuraEnabled(cacheable = true)
    public Static List<Account> searchAccount() {
        Return [Select Id,Name,Phone,Rating from Account limit 10];
    }
}