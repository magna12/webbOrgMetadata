({
    saveRecord : function(component, event)//calls apex functions with contact recordId and message
    {
        var message = document.getElementById("sendtextMsg").value;
        document.getElementById("sendtextMsg").value="";
        var recId = component.get("v.recordId");
        var action= component.get("c.saveMessageRecord");
        var textValue=component.get("v.selectedValue");
        action.setParams({
            contactId : recId,
            msg : message,
            textVal:textValue
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                
                for(var i in result){
                    var formattedData=result[i].CreatedDate ;
                    var d = new Date(formattedData);
                    var month= d.getMonth()+1;
                    var day = d.getDate();
                    var year= d.getFullYear();
                    var finalDate = day+"/"+month+"/"+year;
                    var timeMsg;
                    if(d.getHours() > 12){
                        timeMsg = d.getHours() - 12+":"+(d.getMinutes()>9?"":"0") +d.getMinutes() + " PM";
                    }
                    else {
                        timeMsg = d.getHours() +":"+(d.getMinutes()>9?"":"0") +d.getMinutes() + " AM";
                    }
                    result[i].timeMsg = finalDate+"("+timeMsg+")";
                }
                component.set("v.ChatList", result);
                window.setTimeout(
                    $A.getCallback(function() {
                        var objDiv = document.getElementById("style");
                        objDiv.scrollTop = objDiv.scrollHeight;
                    }), 100
                );
                
                
                
                
            }else if (state === "INCOMPLETE") {
console.log('Incomplete');            }
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
        if(message.length>0){
            if(component.get("v.MobileNumber")!=undefined){
            $A.enqueueAction(action);
            }
            else{
                component.set("v.mobilenoError",true);
            }
        }
    },
    doinit1 : function(component, event, helper)  //executes when the component loads 
    {
        component.set("v.newMsgStatus",0);
        var oneToOne=[];
        var recId = component.get("v.recordId");
        var action=component.get("c.chatDetail");
        action.setParams({
            contactId :  recId   
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var resulttest = response.getReturnValue();
                var result=resulttest.chatInfo;
                var number=resulttest.availableNumbers;
                if(number.length>0){
                    for(var i in number){
                        oneToOne.push(number[i].Name);   
                        component.set("v.selectedValue",oneToOne[0]);
                    }
                }
                else{
                    component.set("v.caseorContact",false);
                }
                for(var i in result){
                    var formattedData=result[i].CreatedDate ;
                    //alert(formattedData);
                    var d = new Date(formattedData);
                    var month= d.getMonth()+1;
                    var day = d.getDate();
                    var year= d.getFullYear();
                    var finalDate = day+"/"+month+"/"+year;
                    var timeMsg;
                    if(d.getHours() > 12){
                        timeMsg = d.getHours() - 12+":"+(d.getMinutes()>9?"":"0") +d.getMinutes() + " PM";
                    }
                    else {
                        timeMsg = d.getHours() +":"+(d.getMinutes()>9?"":"0") +d.getMinutes() + " AM";
                    }
                    result[i].timeMsg = finalDate+"("+timeMsg+")";
                }
                component.set("v.ChatList", result);
                //var contactname = result[0].Contact__r.Name;
                //component.set("v.ConatctName",contactname);
                window.setTimeout(
                    $A.getCallback(function() {
                        var objDiv = document.getElementById("style");
                        objDiv.scrollTop = objDiv.scrollHeight;
                    }), 1500
                );
                component.set("v.options",oneToOne);
                
            }else if (state === "INCOMPLETE") {
                // do something
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