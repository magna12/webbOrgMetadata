trigger testEmailClass on Object_to_test_Trigger__c (before insert,after insert,before update,after update) {
    if(trigger.isinsert){
        if(trigger.isbefore){
            System.debug('Before+++Trigger new'+Trigger.new);
            System.debug('Before+++Trigger Old'+Trigger.old);
            System.debug('Before+++Trigger new Map'+Trigger.newMap);
            System.debug('Before+++Trigger Old Map'+Trigger.oldMap); 
        } 
        if(trigger.isAfter){
            System.debug('After+++Trigger new'+Trigger.new);
            System.debug('After+++Trigger Old'+Trigger.old);
            System.debug('After+++Trigger new Map'+Trigger.newMap);
            System.debug('After+++Trigger Old Map'+Trigger.oldMap); 
        }
        
    }    
    if(trigger.isupdate){
        if(trigger.isbefore){
            System.debug('Before+++Trigger new'+Trigger.new);
            System.debug('Before+++Trigger Old'+Trigger.old);
            System.debug('Before+++Trigger new Map'+Trigger.newMap);
            System.debug('Before+++Trigger Old Map'+Trigger.oldMap); 
        } 
        if(trigger.isAfter){
            System.debug('After+++Trigger new'+Trigger.new);
            System.debug('After+++Trigger Old'+Trigger.old);
            System.debug('After+++Trigger new Map'+Trigger.newMap);
            System.debug('After+++Trigger Old Map'+Trigger.oldMap); 
        }
        
    }
}