import { LightningElement, track } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ChartExample extends LightningElement {
    @track isChartJsInitialized;
    chart;

    config = {
        type: 'line',
        data: {
            datasets: [{
                fill: false,
                label: 'Line Dataset',
                data: [{  
                    y:'25-12-2013',
                    x:0
                 },
                 {  
                    y:'25-12-2013',
                    x:10
                 },
                 {  
                    y:'25-12-2013',
                    x:20
                 },
                 {  
                    y:'25-12-2013',
                    x:30
                 },
                 {  
                    y:'25-12-2013',
                    x:50
                 },
                 {  
                    y:'25-12-2013',
                    x:60
                 },
                 {  
                    y:'25-12-2013',
                    x:70
                 },
                 {  
                    y:'25-12-2013',
                    x:80
                 },
                 {  
                    y:'25-12-2013',
                    x:90
                 },
                 {  
                    y:'25-12-2013',
                    x:100
                 },
                 {  
                    y:'25-12-2013',
                    x:110
                 },
                 {  
                    y:'25-12-2013',
                    x:120
                 },
                 {  
                    y:'25-12-2013',
                    x:130
                 },
                 {  
                    y: '25-12-2013',
                    x:140
                 }
                 
                 ],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)'
                ],
                pointBackgroundColor: 'rgba(255, 99, 132, 0.2)',
                pointBorderColor: 'rgba(255, 99, 132, 1)'
            },
            {
               
            }
            ]
        },
        options: {
            title: {
                display: true,
                text: 'Sand Samples Against Comm Weight %.'
            },
            scales: {
                xAxes: [{
                    type: 'linear',
                    ticks: {
                        suggestedMin: 0,
                        suggestedMax: 100,
                        stepSize: 10
                    }
                }],
                yAxes: [{
                    type: 'linear',
                    ticks: {
                        autoSkip: true,
                        suggestedMin: '21-12-2010',
                        suggestedMax: '21-12-2024',
                        //stepSize: 10,
                       // callback: function (value) {
                       //     return value + '%';
                       // }
                    }
                }]
            },
        }
    };

    renderedCallback() {
        if (this.isChartJsInitialized) {
            return;
        }
        this.isChartJsInitialized = true;

        Promise.all([
            loadScript(this, chartjs)
        ]).then(() => {
            const ctx = this.template.querySelector('canvas.linechart').getContext('2d');
            this.chart = new window.Chart(ctx, this.config);
            this.chart.canvas.parentNode.style.height = '100%';
            this.chart.canvas.parentNode.style.width = '100%';
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading ChartJS',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
}