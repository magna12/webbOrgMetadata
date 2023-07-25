({
	afterScriptsLoaded : function(component, event, helper) {
		var domEl = component.find("ratingArea").getElement();
        var maxRating = 5;         
        var readOnly = component.get('v.readonly');

      	var action=component.get("c.getRating");
                var Id=component.get("v.recordId");
        action.setParams({recordId1:Id});
        var currentRating=0;
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var currentRating=0;
			var currentRating=response.getReturnValue();
                alert(currentRating);
                               var callback = function(rating) {
            	component.set("v.value",rating);
        	}
            
                
                component.ratingObj = rating(domEl,currentRating,maxRating,callback,readOnly);
            }
            else{
                var currentRating=response.getReturnValue();
            }

         	
        });
            $A.enqueueAction(action);
        
        
                	
                    },
     onValueChange: function(component,event,helper) {
        if (component.ratingObj) {
        var Id=component.get("v.recordId");
            var star=component.get("v.value");
        var action=component.get("c.updateStar");
            alert(star);
            action.setParams({recordId:Id,starAmount:star});
        }
        $A.enqueueAction(action);
    }
})