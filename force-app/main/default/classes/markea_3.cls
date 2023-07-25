public class markea_3 {
    public string opoid {get;set;}
         public List<Opportunity> myOpportunities { get;set; }
             public List<Opportunity> myOpportunities1 { get;set; }
         public List<Opportunity> myOpportunities2 { get;set; }
             public List<Opportunity> myOpportunities3 { get;set; }


    public void searchid(){
        myOpportunities=myOpportunities=[select id,Name,Amount,Alphabelts__c from Opportunity where id=:opoid];
        for(Opportunity opp :myOpportunities ){
          if(opp.Alphabelts__c=='A')
              myOpportunities1=myOpportunities.clone();
        if(opp.Alphabelts__c=='B')
              myOpportunities2=myOpportunities.clone();
        if(opp.Alphabelts__c=='A&B')
              myOpportunities3=myOpportunities.clone();
        }
    }
        
        public void A()
        {
            for(Opportunity opp :myOpportunities ){
                if(opp.Alphabelts__c=='B'){
                    myOpportunities1.clear();
                 myOpportunities2=myOpportunities.clone();
                }
                 if(opp.Alphabelts__c=='A&B'){
                    myOpportunities1.clear();
                 myOpportunities3=myOpportunities.clone();
                }

            }
        }
        public void B()
        {
            for(Opportunity opp :myOpportunities ){
                if(opp.Alphabelts__c=='A'){
                    myOpportunities2.clear();
                 myOpportunities1=myOpportunities.clone();
                }
                 if(opp.Alphabelts__c=='A&B'){
                    myOpportunities2.clear();
                 myOpportunities3=myOpportunities.clone();
                }

            }
        }
        public void C(){
            for(Opportunity opp :myOpportunities ){
                if(opp.Alphabelts__c=='A'){
                    myOpportunities3.clear();
                 myOpportunities1=myOpportunities.clone();
                }
                 if(opp.Alphabelts__c=='B'){
                    myOpportunities3.clear();
                 myOpportunities2=myOpportunities.clone();
                }
            }
        }
}