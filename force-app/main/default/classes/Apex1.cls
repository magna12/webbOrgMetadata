public class Apex1 {
   public List<Account> recordList{get; set;}
                            public list<Contact> conList{get;set;}

   public String searchedName{get; set;}
    public string accounid{get; set;}
                            public String accId{get;set;}

   public void ApexTest1()
   {
       recordList = [select id, Name, Industry from Account];
   }
   
   public void searchedRecord()
   {
       String optName = '%' + searchedName + '%';
       if(String.isEmpty(searchedName))
       {
           recordList = [select id, Name, Industry from Account];
       }
       else
       {
       	recordList = [select id, Name, Industry from Account where Name like :optName];
       }
   }
     public PageReference dispalyContact() {

                        if(accId != null)

                        conList=[SELECT id,FirstName,LastName FROM COntact WHERE AccountId=:accId];

                            return null;

    }
}