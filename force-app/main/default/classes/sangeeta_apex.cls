public class sangeeta_apex {
                                  public String InputName{get;set;}
                                  public String InputEmail{get;set;}
                                  public Integer InputPhoneNumber{get;set;}
                                  public Integer DonationAmount{get;set;}
                                  public String regaddress{get;set;}
                                  public Integer aadhar_number{get;set;}
                                  public String Username{get;set;}
                                  public String Password{get;set;}
                                  public List<Account> recordList{get; set;}
                                  public Donation__c details{get;set;}
                                  public Integer EventAmount{get;set;}                                 
                                  public List<Event__c> eventlist{get; set;}
    								public User__c ur{get;set;}
 
                                  public sangeeta_apex(){
               
                                  details=new Donation__c();
                                      ur=new User__C();
                                       eventlist  =[select Name,Amount__c from Event__c ];
      
                                 }
                                public void donationDetails()
                                    {
                                    insert details;
                                        details.clear();
                                          }

                             public void showevent(){
                                 System.debug(EventAmount);
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message');

ApexPages.addMessage(myMsg);

                            
                                 }
    public void registed_users()
{
    
  
   insert ur;
    ur.clear();
    }
    
   
}