({
    getRecord : function(component,event,helper){
        var action = component.get('c.getLeads');
        action.setCallback(this, function(response) {
            var state = response.getReturnValue();
            component.set("v.leads1",state);
            component.set("v.leads2",state);
            var lead=component.get("v.leads2");
            console.log(JSON.stringify(state));
            helper.Method1(component,lead);
        });
        $A.enqueueAction(action); 
    },
    getSize : function(component,event,helper){
                var size=document.getElementById("select1").value;
        		component.set("v.recordsPerPage",size);
        var lead=component.get("v.leads1");
                        component.set("v.alreadyDone",0);
        				helper.Method1(component,lead);
        },
    next : function(component,event,helper){
        var lead=component.get("v.leads1");
        helper.Method1(component,lead);
    },
    previous : function(component,event,helper){
        var lead=component.get("v.leads1");
        helper.Method2(component,lead);
    },
        searchRecords : function(component,event,helper){
        
        var display=[];
        var searchField=document.getElementById("select-01").value;
        var searchValue=component.get("v.SearchKeyWord");
        var lead=component.get("v.leads2");
        var lead1=component.get("v.leads1");
            
        if(searchValue=='')
            helper.Method1(component,lead1);
                if(searchField=='Name'){
              if(searchValue==null)
            helper.Method1(component,lead);
        for(var i=0;i<lead.length;i++){
            if(lead[i].Name.toLowerCase().includes(searchValue.toLowerCase())){
                display.push(lead[i]);
                    component.set("v.show1",true);
            component.set("v.show2",true);
                
           		 }
            }
        }
                 else if(searchField=='Status'){
              if(searchValue==null)
            helper.Method1(component,lead);
        for(var i=0;i<lead.length;i++){
            if(lead[i].Status.toLowerCase().includes(searchValue.toLowerCase())){
                display.push(lead[i]);
                    component.set("v.show1",true);
            component.set("v.show2",true);
                
            	}
        	}
        }
         if(searchField=='Email'){
              if(searchValue==null)
            helper.Method1(component,lead);
        for(var i=0;i<lead.length;i++){
            if(lead[i].Email.toLowerCase().includes(searchValue.toLowerCase())){
                display.push(lead[i]);
                    component.set("v.show1",true);
            component.set("v.show2",true);
                 }
        	}
        }
                component.set("v.alreadyDone",0);
			component.set("v.leads1",display);
            helper.Method1(component,display);
        
        
    }
})