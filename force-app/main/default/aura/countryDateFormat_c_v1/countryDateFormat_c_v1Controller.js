({
	init : function(component, event, helper) {
        var format1=["China", "koreas", "Japan","Iran"];
        var format2=["Australia", "India", "Russia","New Zealand"];
        var format3=["United States", "Marshall Islands", "Federated States Of Micronesia"];
        var countries=["Choose a country"];
        countries=format1.concat(format2);
        countries=countries.concat(format3);
        component.set("v.country",countries);
        component.set("v.format1",format1);
        component.set("v.format2",format2);
        component.set("v.format3",format3);


	},
    changeFormat: function(component,event,helper){
        var format1=component.get("v.format1");
        var format2=component.get("v.format2");
        var format3=component.get("v.format3");
        var inputDate=component.get("v.inputDate");
        var string='<c:countryDateFormat_c_v1 inputDate=\"'+inputDate+'\"/>';
        component.set("v.output",string);
        var today = new Date(),
    	minutes = today.getMinutes().toString().length == 1 ? '0'+today.getMinutes() : today.getMinutes(),
   		hours = today.getHours().toString().length == 1 ? '0'+today.getHours() : today.getHours(),
    	ampm = today.getHours() >= 12 ? 'PM' : 'AM',
    	months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
    	days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
        //alert("minutes :"+days[d.getDay()]+' '+months[d.getMonth()]+' '+d.getDate()+' '+d.getFullYear()+' '+hours+':'+minutes+ampm);
        var Time=hours+':'+minutes+ampm;
        
        var date = today.getDate();
		var month = today.getMonth()+1; 
		var Year = today.getFullYear();
			if(date<10) 
			{
    			date='0'+date;
			} 

			if(month<10) 
			{
    			month='0'+month;
			} 
        if(inputDate!=null){
            Year=inputDate.substring(0,4);
            month=inputDate.substring(5,7);
            date=inputDate.substring(8,10);
        }
        else
        {
            today= Year+'-'+month+'-'+date;
                    var string='<c:countryDateFormat_c_v1 inputDate=\"'+today+'\"/>';
                    component.set("v.output",string);


        }
       
        
        var selectedValue=component.get("v.selectedValue");
        for(var i=0;i<format1.length;i++){
            if(format1[i]==selectedValue){
                today = Year+'/'+month+'/'+date;
                component.set("v.hide",true);
                component.set("v.dateOutput",today);
            }
        } for(var i=0;i<format2.length;i++){
            if(format2[i]==selectedValue){
                today = date+'/'+month+'/'+Year;
                component.set("v.hide",true);
                component.set("v.dateOutput",today);
            }
        }
         for(var i=0;i<format3.length;i++){
            if(format3[i]==selectedValue){                
                today = month+'/'+date+'/'+Year;
                component.set("v.hide",true);
                component.set("v.dateOutput",today);
            }
        }
    }
})