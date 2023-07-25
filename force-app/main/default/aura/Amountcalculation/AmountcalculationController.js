({
    clickCreate : function(component, event, helper) {
        var Date=component.get("v.DateValue");
        var monthval=component.get("v.MonthValue");
        var months=['Jan','Fab','Mar','Apr','May','Jun','July','Aug','Sept','Oct','NoV','Dec'];
        var monthNum=Date.substring(5, 7);
        var Amount=component.get("v.Amount");
        var Amounteach=Amount/monthval;
        var displayDate=[];
        var val = [42,55,51,22];
        var counter=0;
        for(var i=monthNum-1;i<months.length;i++){
            if(counter<monthval){
                displayDate.push({label: months[i], value: parseInt(Amounteach, 10)});
                counter++;
            }
            else{
                break;
            }
            if(i==11){
                i=-1;
            }
        }
        console.log(displayDate);
        component.set("v.displayList",displayDate);
        component.set("v.displayList2",displayDate);
        
    },
    calculate : function(component,event,helper){
        var target = event.getSource();  
        var Date=component.get("v.DateValue");
        var monthval=component.get("v.MonthValue");
        var monthNum=Date.substring(5, 7);
        var Amount=component.get("v.Amount");
        var Amounteach=Amount/monthval;
        var inputId = target.get("v.name");
        var changedValue=target.get("v.value");

    var restValue=0;
        var x=0;
        var count=0;
        var constantList=component.get("v.displayList2");
        var sum=0;
        var displayList=component.get("v.displayList");
        for(var i =0;i<displayList.length;i++){
            if(displayList[i].value!=0)
            sum=sum+parseInt(displayList[i].value, 10);
            if(displayList[i].label==inputId){
                x=1;
                count=i;
            }
            
        }
        alert(sum);
        
        var y=0;
        if(sum>parseInt(Amount,10)){
            restValue=(sum-parseInt(Amount,10))/(parseInt(displayList.length-count-1, 10));
            displayList[count].value=changedValue;
        }
        else{
            y=1;
            restValue=(parseInt(Amount,10)-sum)/(parseInt(displayList.length-count-1, 10));
        }
        displayList[count].value=changedValue; 
        
        for(var i =count+1;i<displayList.length;i++){
            if(y==0)
                displayList[i].value=parseInt(displayList[i].value, 10)-restValue;
            else
                displayList[i].value=parseInt(displayList[i].value, 10)+restValue;
        }
        component.set("v.displayList",displayList);  
        component.set("v.displayList2",displayList);
        
    }
    
})