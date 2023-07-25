trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
                List <Task> task1=new List <Task>();

    for(Opportunity a : Trigger.New) {
        if(a.StageName=='Closed Won')
        {
            	//task1.add(new Task(subject=''))
                Task t = new Task();
				t.Subject = 'Follow Up Test Task';
				t.WhatId=a.Id;
				task1.add(t);
        }
    }
    if(task1.size()>0){
    insert task1;
    }
}