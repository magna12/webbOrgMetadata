public class mark2 {
public List<Account> recordList{get; set;}
    
   public list<Contact> conList{get;set;}
   public list<Opportunity> opoList{get;set;}
   public String searchedName{get; set;}
   public string accounid{get; set;}
   public String accId{get;set;}

        public void ApexTest1()
        {
		conList=new List<contact>();
        //recordList = [select id, Name, Industry from Account];

      }
   
        public void searchedRecord()
        {
         String optName = '%' + searchedName + '%';

       
         recordList =[select ID,(select Id,LastName from contacts),(select Amount from opportunities) FROM Account where Name like :optName];
			
    
}
    public void clean(){
        if(recordList!=null){ 
      for(Account u:recordList)
{  
    if(u.ID==accId){
    
         conList=u.Contacts;
        opoList=u.opportunities;
        
    }
    }
}
}
}