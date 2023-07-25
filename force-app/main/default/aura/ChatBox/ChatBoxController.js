({
    
    send : function(component, event, helper) // calls the helper method 'saveRecord'
    {
        helper.saveRecord(component, event);
    },
    createScheduleMessage:function(component,event,helper){ //calls apex fucntion with values to schedule a message
        var Actionvalue=component.get("v.ScheduleAction");
        var Message=document.getElementById('message').value;
        var Timevalue=component.get("v.ScheduleTime"); 
        //alert(Timevalue);
        //var dateValue=component.get("v.ScheduleDate");
        var action=component.get("c.createScheduleRecord");
        //alert(dateValue);
        if(Message.length==0){
            component.set("v.scheduledError","ERROR: Message body can't be empty");
        }
        else if(Timevalue!=null){
            
            component.set("v.scheduledError","");
            action.setParams({
                timevals:Timevalue,
                message:Message,
                Action:Actionvalue,
                ContactId:component.get("v.recordId")
            });
            action.setCallback(this,function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    component.set("v.isOpen",false);
                    alert('Success');
                }
                else if (state === "INCOMPLETE") {
                      component.set("v.scheduledError",'ERROR: Time must be in future');
                }
                    else if (state === "ERROR") {
                                              component.set("v.scheduledError",'ERROR: Time must be in future');
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
            else{
                component.set("v.scheduledError",'ERROR: Enter date and Time');
            }
    },
    
    doinit : function(component, event, helper)  //executes when the component loads 
    {
        component.set("v.newMsgStatus",0);
        var oneToOne=[];
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var today = new Date();
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var dateTime = date+' '+time;
        component.set("v.currentDate",dateTime);
        var recId = component.get("v.recordId");
        if(recId.charAt(0)=='5')
                                component.set("v.caseorContact",false);
        var action=component.get("c.chatDetail");
        action.setParams({
            contactId :  recId   
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var resulttest = response.getReturnValue();
                component.set("v.MobileNumber",resulttest.Mobile);
                var result=resulttest.chatInfo;
                var number=resulttest.availableNumbers;
                if(number.length>0){
                    for(var i in number){
                        if(number[i].Active__c==true)
                            oneToOne.push(number[i].Name);   
                    }
                    component.set("v.selectedValue",oneToOne[0]);
                }
                for(var i in result){
                    var formattedData=result[i].CreatedDate ;
                    //alert(formattedData);
                    var d = new Date(formattedData);
                    var month= d.getMonth()+1;
                    var day = d.getDate();
                    var year= d.getFullYear();
                    var finalDate = month+"/"+day+"/"+year;
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
    },
    
    entermethod : function(component, event, helper) //calls helper method 'saveRecord' 
    {
        if (event.keyCode == 13 || event.which == 13){
            helper.saveRecord(component, event);
        }
        
    },
    enterSend:function(component,event,helper)
    {
        
        helper.saveRecord(component, event);
    },
    
    ScriptLoaded: function (component, event, helper) //runs after script load and executues streaming Api
    {
        var action = component.get("c.getUserSession");
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS") 
                               {
                                   
                                   component.set("v.sessionId", response.getReturnValue());
                                   $.cometd.init(
                                       {
                                           url: '/cometd/43.0',
                                           requestHeaders: { Authorization: component.get("v.sessionId")},
                                           appendMessageTypeToURL : false
                                       });
                                   $.cometd.subscribe('/topic/smsStreaming_v1', function(message) 
                                                      {
                                                          console.log(JSON.stringify(message));
                                                          if(message['data']['event'].type == 'created')
                                                          {
                                                              if(message['data']['sobject'].Contact__c == component.get("v.recordId") && message['data']['sobject'].Type__c == "Received") {
                                                                  helper.doinit1(component, event);
                                                                  window.setTimeout(
                                                                      $A.getCallback(function() {
                                                                          var objDiv = document.getElementById("style");
                                                                          objDiv.scrollTop = objDiv.scrollHeight;
                                                                      }), 1500
                                                                  );
                                                              }
                                                              
                                                          }
                                                          if(message['data']['event'].type == 'updated')
                                                          {
                                                              if(message['data']['sobject'].Contact__c == component.get("v.recordId") && message['data']['sobject'].Type__c == "Sent") {
                                                                  helper.doinit1(component, event);
                                                                  window.setTimeout(
                                                                      $A.getCallback(function() {
                                                                          var objDiv = document.getElementById("style");
                                                                          objDiv.scrollTop = objDiv.scrollHeight;
                                                                      }), 1500
                                                                  );
                                                              }
                                                              
                                                          }
                                                      });
                               }
                               else if (state === "INCOMPLETE") {
                                   console.log(response.getError());                }
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
    },
    sceduleMessage: function (component, event, helper) //runs after script load and executues streaming Api
    {
        component.set("v.isOpen",true);
    },
    closeModal: function(component,event,helper){
        component.set("v.isOpen",false);
    },
    closeMobilenoError: function(component,event,helper){
        component.set('v.mobilenoError',false);
    }
})