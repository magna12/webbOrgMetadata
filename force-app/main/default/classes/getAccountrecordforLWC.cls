public class getAccountrecordforLWC{

@AuraEnabled(cacheable=true)
public Static List<Account> GetAccounts(){

return [Select id,Name,Type from Account limit 20];
}
@AuraEnabled
public Static String GetContacts(){
return JSON.serialize([Select id,FirstName,LastName from Contact limit 20]);

}
    @AuraEnabled(cacheable=true)
    public Static List<Case> GetCases(){
        return [Select id,CaseNumber,Subject,Status,CreatedDate,Owner.alias from Case limit 20];
    }
}