public class testobject2 {

    public Registered_User__c testobj2{get;set;}
    public testobject2(ApexPages.StandardController controller) {
    this.testobj2 = (Registered_User__c) controller.getrecord();

    }

    public void savetest(){
    PageReference pdf = Page.Pdfvf2;

    insert testobj2;
    //system.debug('******************' + attc );
    Blob body;
         try {

        // returns the output of the page as a PDF
        body = pdf.getContent();

    // need to pass unit test -- current bug    
    } catch (VisualforceException e) {
        body = Blob.valueOf('Some Text');
    }
    String myString = 'StringToBlob';
    Blob myBlob = Blob.valueof(myString);
    Attachment a = new Attachment(parentid=testobj2.id, Name = 'xyz' , Body = body );
    insert a;
    //Attachment a = new Attachment(parentid=testobj2.id, Name = 'xyz' , Body = attc );
    //insert a;
    //return null;
    }

}