public class PdfGeneratorController {
    public Registered_User__c	rcc{get;set;}
    public PdfGeneratorController(){
        rcc=new Registered_User__c();
    }
  public ID parentId {get;set;}
  public String pdfName {get;set;}

  public PageReference savePdf() {
insert rcc;
PageReference acctPage = Page.vf2;
        acctPage.setRedirect(true);
        return acctPage;

     
  }
    public void save(){
        PageReference pdfPage = Page.vf2; //create a page reference to our pdfDemo Visualforce page, which was created from the post http://www.interactiveties.com/blog/2015/render-visualforce-pdf.php
		Blob pdfBlob = pdfPage.getContentAsPDF(); //get the output of the page, as displayed to a user in a browser
		Attachment attach = new Attachment(parentId = rcc.id, Name = 'pdfAttachmentDemo.pdf', body = pdfBlob); //create the attachment object
		insert attach; //insert the 
    
    /* Blob body1 = [select body from Attachment limit 1].body;
      Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
     efa.setFileName('attachment.pdf');
     efa.setBody(body );
	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      String addresses='debesh.satapathy@gyansys.com';
	String[] toAddresses = addresses.split(':', 0);
	email.setSubject( rcc.name);
	email.setPlainTextBody( 'hello');
      email.setReplyTo('approve@v-cc2bfr1c6lrzsx3e8wwa2ct0y5pyhxbcne98obo9g0drw8aur.7f-499druaq.ap5.apex.salesforce.com');
      email.setSenderDisplayName('Salesforce');
      email.setToAddresses(toAddresses);
		email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
		Messaging.SendEmailResult [] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
System.debug(r);
*/
}

}