import { LightningElement,track,api } from 'lwc';

export default class ChildYComp extends LightningElement {
    @track trackparam ='trackValue';
    @api apiparam = 'apiValue';
    noreactiveproperty ='nonreactive';

    paramChangeHandler(){
      //  this.trackparam = 'Value Changed for trackparam';
        //this.apiparam = 'Value changed for apiparam';
       // this.noreactiveproperty ='Values chaged for nonreactiveproperty';
       const childEvent = new CustomEvent('test_event',
       {detail:{FirstName : 'Test First',
                SecondName : 'Test Second'}});
       this.dispatchEvent(childEvent);
    }
   @api callFromParent(paramfromParent){
    alert('This is Child Component'+paramfromParent.FirstName);
      this.trackparam =paramfromParent.FirstName;
      this.apiparam ='Changed api from Parent';
    }
}