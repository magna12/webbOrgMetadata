public with sharing class Apex1_1 {
@AuraEnabled
   public static list <Lead> getLeads() {
      Return [SELECT Name,Status,Email FROM Lead LIMIT 50];
          
    }
}