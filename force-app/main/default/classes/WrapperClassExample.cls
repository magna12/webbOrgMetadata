public class WrapperClassExample 
{
    @AuraEnabled
    public static WrapExp getAllRecord()
    {
        List<Account> AccList = [select Name, Id from account limit 5];
        List<Contact> ConList = [select Name, Id from Contact limit 5];
        WrapExp TestWrap = new WrapExp();
        TestWrap.AccountList.addAll(AccList);
        TestWrap.ContactList.addAll(ConList);
        return TestWrap;
    }
    public class WrapExp
    {
        @AuraEnabled public List<Account> AccountList= new List<Account>();
        @AuraEnabled public List<Contact> ContactList= new List<Contact>();
        
	}
    

}