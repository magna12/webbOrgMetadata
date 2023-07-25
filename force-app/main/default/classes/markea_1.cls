public class markea_1 {
    //public String Page {get; set;}
    //public String OpenPageURL {get; set;}
     public List<Opportunity> myOpportunities { get;set; }
    public markea_1(){
        myOpportunities=[select id,Name,Amount from Opportunity];
    }
   
   

}