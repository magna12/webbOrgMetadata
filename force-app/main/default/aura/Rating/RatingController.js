({
    afterScriptsLoaded : function(component, event, helper) {
        	var domEl = component.find("ratingArea").getElement();
            var maxRating = 9;
           	var Id=component.get("v.recordId");
        	var action=component.get("c.getRating");
            var readOnly = component.get('v.readonly');
        
       		action.setParams({recordId1:Id,
                               field1:component.get("v.PickList")});
        	action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            var currentRating=0;
			var piclist=response.getReturnValue();
            var length=piclist.length;    
            var picklistvalues=piclist[piclist.length-1];
                              
                
                
                
                
                
           	component.set("v.pickList1",piclist);
            maxRating=piclist.length-1;
            var strin=piclist[0];
            var callback = function(rating) {
            	component.set("v.value",rating);
        	}
            var pickListValue=piclist[piclist.length-1];
            for(var i=0;i<=piclist.length-2;i++){
            	if(pickListValue==piclist[i]){
                  	currentRating=i+1;
             }
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
        var x=component.get("v.pickList1");
        if (component.ratingObj) {
        var Id=component.get("v.recordId");
            var star=component.get("v.value");
        var action=component.get("c.updateStar");
            alert(x[star-1])
            action.setParams({recordId:Id,starAmount:x[star-1],field1:component.get("v.PickList")});
        }
        $A.enqueueAction(action);
    }
    
})