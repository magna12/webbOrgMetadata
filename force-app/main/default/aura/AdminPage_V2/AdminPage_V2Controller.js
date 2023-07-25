({
    
    myAction : function(component, event, helper) {
        component.set("v.isOpen",true);
    },
    closeModel  : function(component,event,helper){
        component.set("v.isOpen",false);
        
    },
    save  : function(component,event,helper){
        component.set("v.hideButton",true);
        var Name=document.getElementById('text-input-id-0').value;
        var contactNumber=document.getElementById('text-input-id-1').value;
        var Active=document.getElementById('text-input-id-2').checked;
        var flowId=document.getElementById('text-input-id-3').value;
        //var chatType=component.get("v.chatType");
        var action=component.get("c.createNewNumber");
        action.setParams({
            Name:Name,
            PhoneNumber:contactNumber,
            ActiveStatus:Active,
            Flow_Id:flowId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var oneToMany=[];
            if (state === "SUCCESS") {
                
                        component.set("v.isOpen",false);
                var result = response.getReturnValue();
                for(var i in result){
                    result[i].edit=true;
                    
                }
                component.set("v.displayList",result);
                
                component.set("v.checked",true);
                
                
            }
        });
        if(Name!=''&&contactNumber!=''&&flowId!=''){
            component.set("v.showError",false);            
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showError",true); 
            component.set("v.ErrorMessage",'All the fields are required');
        }
        
        
    },
    doinit :function(component,event,helper){
        helper.doinit1(component);
    },
    EditRecord :function(component,event,helper){
        var displayList=component.get("v.displayList");
        for(var i in displayList){
            displayList[i].edit=true;
        }
        component.set("v.displayList",displayList);
        component.set("v.checked",false);
        component.set("v.disableSave",false);
        component.set("v.disableEdit",true);
        component.set("v.hideButton",false);
        component.set("v.hideeditAll",false);
        component.set("v.hideButton",false);
        
    },
    DeleteRecord :function(component,event,helper){
        
        var displaynumbers=component.get("v.displayList");
        var displayVals=[];
        var inputId=component.get("v.recordIDToDelete");
        var action=component.get("c.deletedRecord");
        action.setParams({
            recordList:component.get("v.displayList"),
            idVal:inputId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var oneToMany=[];
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                for(var i in result){
                    result[i].edit=true;
                    
                }
                component.set("v.displayList",result);
                component.set("v.isClose",false);
                
            }
        });
        $A.enqueueAction(action);
        
    },
    saveRecord:function(component,event,helper){
        var actionList=component.get("v.displayList");
        component.set("v.checked",true);
        var action=component.get("c.updateRecord");
        action.setParams({
            customlist:component.get("v.displayList")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var oneToMany=[];
            if (state === "SUCCESS") {
                var oneToOne=[];
                var result=response.getReturnValue();
                for(var i in result){
                    result[i].edit=true;
                    oneToOne.push(result[i]);
                    
                }                component.set('v.displayList',oneToOne );
                component.set("v.hideButton",true);
                component.set("v.hideeditAll",true);
                
                
            }
        });
        $A.enqueueAction(action);
        component.set("v.disableSave",true);
        component.set("v.disableEdit",false);
    },
    editSingleRecord:function(component,event,helper){
        component.set("v.disableSave",false);
        var target = event.getSource();  
        var inputId = target.get("v.name");
        var displaynumbers=component.get("v.displayList");
        for (var i=0;i<displaynumbers.length;i++){
            if(inputId==displaynumbers[i].Id)
                displaynumbers[i].edit=false; 
        }
        component.set("v.displayList",displaynumbers);
        component.set("v.hideButton",false);
        component.set("v.hideeditAll",false);
        
        
    },
    CancelEditing:function(component,event,helper){
        helper.doinit1(component);
        component.set("v.checked",true);
        component.set("v.hideeditAll",true);
        component.set("v.disableEdit",false);
        component.set("v.disableSave",true);
        component.set("v.hideButton",true);
        
    },
    cancelDeletingrecord:function(component,event,helper){
        component.set("v.isClose",false);
    },
    confirmdeletingRecord:function(component,event,helper){
        var target = event.getSource();  
        var inputId = target.get("v.name");
        component.set("v.recordIDToDelete",inputId);
        component.set("v.isClose",true);
        
    },
    inputOnChange:function(component,event,helper){
        
        var whichOne = event.getSource();
        $A.util.addClass(whichOne,'myClass');
    }
    
    
    
})