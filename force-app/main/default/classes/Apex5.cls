public class Apex5 {
 public List<Account> recordList{get; set;}
   public list<Contact> conList{get;set;}
       public list<sObject> conList1{get;set;}

   public list<Opportunity> opoList{get;set;}
   public String searchedName1{get; set;}
   public string accounid{get; set;}
   public String accId{get;set;}
   Public String query = 'select id, name from';
   public String optName='';
       //public String acc1Id{get;set;}

public void setQuery()
    {
        query = 'select id, name from';
    }
        public void ApexTest1()
        {

   query = query + ' Account';
        recordList = getData();
        setQuery();

      }
    
   
        public void searchedRecord()
        {
         optName = '%' + searchedName1 + '%';
			
          
          query = query + ' Account where Name like \'' + optName + '\'' ;
        	recordList = getData();
            setQuery();
            
          
      }
    public void showRelatedField()
    {
       
        
        query = query + ' Contact where AccountId = \'' + accId + '\'' ;
        conList = getData();
        setQuery();
        query = query + ' Opportunity where AccountId = \'' + accId + '\'' ;
        opoList = getData();
        setQuery();
        conList1=[select ID,(select Name from contacts),(select Name from opportunities) FROM Account where Name like :optName];


        
    }
    public List<SObject> getData()
    {
        return(Database.query(query));
    }
       
}