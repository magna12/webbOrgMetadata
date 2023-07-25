({
	myAction : function(component, event, helper) 
    {
        var action = component.get('c.getAllRecord');
        action.setCallback(this, function(response) 
       	{
            var allRecord = response.getReturnValue();
            component.set('v.AccList', allRecord.AccountList );
            component.set('v.ConList', allRecord.ContactList );
            
        });
        $A.enqueueAction(action); 
		
	}
})