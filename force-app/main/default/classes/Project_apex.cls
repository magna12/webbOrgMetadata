public class Project_apex {
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
    public Project_apex(){
                //recordList = [select Name from Account where Name like :'Debesh'];
                details=new Donation__c();

    }
public void donationDetails()
{
    insert details;
    details.clear();
}
public void registed_users()
{
  // User__c ur=new User__c(
   //Name=InputName,
   //Address__c=regaddress,
   //Phone__c=InputPhoneNumber,
   //Email_ID__c=InputEmail,
   //Aadhar_number__c=aadhar_number,
   //Username__c=Username,
   //Password__c=Password);
  // insert ur;
    }
    public void acc(){
    }
   
}