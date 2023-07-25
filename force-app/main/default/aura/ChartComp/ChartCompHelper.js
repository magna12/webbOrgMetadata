({
	createGraph : function(cmp, temp) {
        
        var dataMap = {"chartLabels": Object.keys(temp),
                       "chartData": Object.values(temp)
                       };
        
        var el = cmp.find('barChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "My Data",
                        backgroundColor: "rgba(153,255,51,0.4)",
                        data: dataMap.chartData
                    },
                     {
                        label: "My Data",
                        backgroundColor: "rgba(153,255,51,0.4)",
                        data: dataMap.chartData
                    }
                ]
            }
        });
	},
    createLineGraph : function(cmp, temp) {
        
        var label = [];
        var firstValue = [];
        var secondValue = [];
        
        for(var a=0; a< temp.length; a++){
            console.debug(temp[a]["label"]);
            label.push(temp[a]["label"]);
            firstValue.push(temp[a]["firstValue"]);
            secondValue.push(temp[a]["secondValue"]);                     
        }    
        console.log('Line Chart First Value'+firstValue);
        console.log('Line Chart Second Value'+secondValue);
        var el = cmp.find('lineChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'line',
            data: {
                    labels: label,
                    datasets: [{
                      label: 'First Values',
                      data: firstValue,
                      backgroundColor: "rgba(153,255,51,0.4)"
                    }, {
                      label: 'Second Values',
                      data: secondValue,
                      backgroundColor: "rgba(255,153,0,0.4)"
                    }]
                  }
        });
        
	}
    
})