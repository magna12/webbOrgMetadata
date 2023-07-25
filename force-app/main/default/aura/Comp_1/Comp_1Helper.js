({
	Method1 : function(component,lead) {
        var recordsEachPage=component.get("v.recordsPerPage");
        var already=component.get("v.alreadyDone");
        var state=[];
        var temp=0;
		var last=component.get("v.last");
        alert("alr"+already);
        alert("size"+recordsEachPage);
        alert("temp"+temp);
        var x=parseInt(already)+parseInt(recordsEachPage);
        alert(x);
        for(var i=already;i<x&&i<lead.length;i++){
                state.push(lead[i]);
           temp++;
            }
        alert(temp);
        already=already+temp;
        //        alert(already);
        if(lead[already]!=null){
            component.set("v.show2",false);
        }
        else{
             component.set("v.show2",true);
        }
        
        if(already-recordsEachPage>0){
                         component.set("v.show1",false);
        }
        else{
                         component.set("v.show1",true);
        }
        component.set("v.alreadyDone",already);
        //alert(state.length);
        component.set("v.leads",state);
        component.set("v.last",state.length+1);
        
	},
    Method2 : function(component,lead) {
        component.set("v.show2",false);
		var recordsEachPage=component.get("v.recordsPerPage");
        var already=component.get("v.alreadyDone");
        var state=[];
        var last=component.get("v.last");
        already=already-last;
        alert(already);
       
		for(var i=already;i>already-recordsEachPage&&i>=0;i--){
                state.push(lead[i]);
                       component.set("v.show1",false);

            }
        already=already-recordsEachPage;
       
      
        if(already<0)
        {
            component.set("v.show1",true);
            component.set("v.show2",false);


        }
        if(already<=0)
            already=10;
        	component.set("v.alreadyDone",already);
            component.set("v.leads",state);
			component.set("v.last",0);
        
	}
})