public class adminapex {
    //public Event__C createEvent{get;set;}
    //First time editing from VS Code V2.1
    public Integer EventAmount{get;set;}
        public String EventName{get;set;}
        public String EventDescription{get;set;}
		                                  public List<Event__c> eventlist{get; set;}

    public Date EventDate {get;set;}
    public adminapex(){
       // createEvent=new Event__C();
        eventlist=[Select Name,Event_Date__c,Status__C,Description__c,Amount__C FROM Event__C where Status__C='Open'];
        System.debug(eventlist);
    }
    public void store(){
      Event__C createEvent=new Event__c(Name=EventName,Event_Date__c=EventDate,Description__c=EventDescription,Amount__C=EventAmount);
        
    insert createEvent;    
    }
    
}