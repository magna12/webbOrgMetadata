({
    doinit : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        /*setTimeout(function(){ 
                    $('#tableId').DataTable();
                    // add lightning class to search filter field with some bottom margin..  
                    $('div.dataTables_filter input').addClass('slds-input');
                    $('div.dataTables_filter input').css("marginBottom", "10px");
                }, 2000); */ 
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var today = new Date();
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var dateTime = date+' '+time;
        component.set("v.currentDate",dateTime);
        var action = component.get('c.CamapignMembers');
        action.setParams({
            CampaignId :  recordId   
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var oneToMany=[];
            if (state === "SUCCESS") {
                
                component.set('v.lstOpp', response.getReturnValue().memberList);
                component.set("v.memberList",response.getReturnValue().memberList);
                var result=response.getReturnValue().mcs;
                for(var i in result){
                    if(result[i].Active__c==true)
                        oneToMany.push(result[i].Name);
                }
                component.set("v.selectedValue",oneToMany[0]);
                component.set("v.options",oneToMany);
                
            }
        });
        $A.enqueueAction(action);         
    },
    checkall : function(component,event,helper){
        
        var displaylist=component.get("v.lstOpp");
        if(document.getElementById('checkbox-2').checked==true){
            for(var i in displaylist){
                document.getElementById(displaylist[i].Id).checked=true;
            }}
        else{
           for(var i in displaylist)
                document.getElementById(displaylist[i].Id).checked=false;
        } 
    },
    sendMessage : function(component,event,helper){
        var textValue=component.get("v.selectedValue");
        component.set("v.displayError",false);
        component.set("v.hideTable",false);
        var messageValue=document.getElementById('message').value;
        var selectedRecord=[];
        var displaylist=component.get("v.lstOpp");
        if(messageValue.length==0){
            component.set("v.displayError",true);
            component.set("v.ErrorMessage",'ERROR: Message Body cannot be empty');
            component.set("v.hideTable",true);
        }
        else{
            
            for(var i in displaylist){
                if(document.getElementById(displaylist[i].Id).checked==true	){
                    //alert('checked');
                    selectedRecord[i]=displaylist[i].Id;
                }}
            //alert(selectedRecord.length);
            if(selectedRecord.length==0){
                component.set("v.displayError",true);
                component.set("v.ErrorMessage",'ERROR: You need to select at least one recipient');
                component.set("v.hideTable",true);
            }
            else{
                var action= component.get("c.sendSms");
                //alert(selectedRecord.length);
                action.setParams({
                    Ids : selectedRecord,
                    textBody:messageValue,
                    campaignId:component.get("v.recordId"),
                    textVal:textValue
                });
                action.setCallback(this,function(response) {
                    var state = response.getState();
                    //alert(state);
                    component.set("v.hideTable",true);
                    document.getElementById('message').value='';
                });
                $A.enqueueAction(action);
            }
        }
        
        
        
    },
    createScheduleMessage : function(component,event,helper){
        var selectedRecord=[];
        var displaylist=component.get("v.lstOpp");
        for(var i in displaylist){
            if(document.getElementById(displaylist[i].Id).checked==true	){
                //alert('checked');
                selectedRecord[i]=displaylist[i].Id;
            }}
        var Actionvalue=component.get("v.ScheduleAction");
        var Message=document.getElementById('scheduledMessage').value;
        var Timevalue=component.get("v.ScheduleTime"); 
        var dateValue=component.get("v.ScheduleDate");
        
        var action=component.get("c.createScheduleRecord");
        if(Message.length==0){
            component.set("v.scheduledError","ERROR: Message body can't be empty");
        }
        else if(Timevalue!=null){
            component.set("v.scheduledError","");
            action.setParams({
                datevals :Timevalue,
                message:Message,
                Action:Actionvalue,
                membersList:selectedRecord,
                CampaignId:component.get("v.recordId")
            });
            action.setCallback(this,function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                                component.set("v.isOpen",false);
                    document.getElementById('checkbox-2').checked=false;
                    alert('SUCCESS');
                    for(var i in displaylist)
                        document.getElementById(displaylist[i].Id).checked=false;
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
    search : function(component,event,helper){
        var displayList=component.get("v.memberList");
        var displayList1=[];
        var subStringValue=document.getElementById("searchValues").value;
        if(subStringValue.length==0)
            component.set("v.lstOpp",displayList);
        for( var i in displayList){
            var n = displayList[i].CompanyOrAccount.search(subStringValue);
            if(n>=0){
                displayList1.push(displayList[i]);
            }
            else if(displayList[i].ContactId!=null&&displayList[i].ContactId!=undefined){
                var n = displayList[i].ContactId.search(subStringValue);
                if(n>=0){
                    displayList1.push(displayList[i]);
                }
                else if(displayList[i].Email!=null&&displayList[i].Email!=undefined){
                    var n = displayList[i].Email.search(subStringValue);
                    if(n>=0){
                        displayList1.push(displayList[i]);
                    }
                    else if(displayList[i].Phone!=null&&displayList[i].Phone!=undefined){
                        var n = displayList[i].Phone.search(subStringValue);
                        if(n>=0){
                            displayList1.push(displayList[i]);
                        } 
                        else if(displayList[i].Country!=null&&displayList[i].Country!=undefined){
                            var n = displayList[i].Country.search(subStringValue);
                            if(n>=0){
                                displayList1.push(displayList[i]);
                            }
                        }
                    }
                }
            }
        }
        component.set("v.lstOpp",displayList1);
    },
    openModal : function(component,event,helper){
        var selectedRecord=[];
        var displaylist=component.get("v.lstOpp");
        
        for(var i in displaylist){
            if(document.getElementById(displaylist[i].Id).checked==true	){
                //alert('checked');
                selectedRecord[i]=displaylist[i].Id;
            }}
        if(selectedRecord.length==0){
            component.set("v.displayError",true);
            component.set("v.ErrorMessage",'ERROR: You need to select at least one recipient');            component.set("v.hideTable",true);
        }
        else{
            component.set("v.displayError",false);
            component.set("v.isOpen",true);
        }
    },
    closeModal : function(component,event,helper){
        component.set("v.isOpen",false);
    }
    
})