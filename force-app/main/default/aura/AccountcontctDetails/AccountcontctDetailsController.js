({
	doInit : function(component, event, helper) {
                var action = component.get("c.getRecords");
        action.setParams({
            "recId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.AccountsList", response.getReturnValue());
                console.log("Account Details"+component.get("v.AccountsList").Name);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    } ,
	
})