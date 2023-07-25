public class mark1 {
   public List<Account> recordList{get; set;}
   public list<Contact> conList{get;set;}
   public list<Opportunity> opoList{get;set;}
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

       
         recordList = [select id, Name, Industry from Account where Name like :optName];
          
      }
    public void click(){
       
        dispalyContact(); 
         dispalyOpportunity();
         
    }
        public void dispalyContact() 
        {

            if(accId != null)
              conList=[SELECT id,FirstName,LastName FROM COntact WHERE AccountId=:accId];
      }            
   
        public void  dispalyOpportunity() 
        {

            if(accId != null)
              opoList=[SELECT id,Amount FROM Opportunity WHERE AccountId=:accId];
    }
}