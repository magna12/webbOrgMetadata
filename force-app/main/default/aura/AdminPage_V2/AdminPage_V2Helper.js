({
    doinit1 :function(component,event,helper){
        var oneToOne=[];
        var oneToMany=[];
        var action=component.get("c.numberList");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                for(var i in result){
                    result[i].edit=true;
                    oneToOne.push(result[i]);
                    
                }
                component.set("v.oneToOneNumber",oneToOne);
                component.set("v.displayList",component.get("v.oneToOneNumber"));
                
            }else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
    }
    })