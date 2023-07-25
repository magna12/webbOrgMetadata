public class testApexClass {
    public String recordName{get;set;}
    public List<Account> accList{get;set;}
    public string test{get; set;}
    public List<Account> displayList{get;set;}
    public testApexClass(ApexPages.StandardController stdController){
        accList=new List<Account>([Select Id,Name,Rating,Website from Account]);
        test = JSON.serialize(accList);
        System.debug('account'+accList[0]);
        displayList=new List<Account>();
        recordName='';
    }
}