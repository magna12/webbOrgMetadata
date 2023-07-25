public with sharing class ShownCreateCases {
    @AuraEnabled(cacheable = true)
    public static List<Case> ShownCases() {
        Return [Select id,CaseNumber,Status,Subject,Createddate from Case Limit 10 ];
    }
}