public class attachPDFToAccount {
	    public Registered_User__c	rcc{get;set;}

	public attachPDFToAccount(ApexPages.StandardController standardPageController) {
        rcc=new Registered_User__c();

    }
    public PageReference savePdf() {
insert rcc;
        PageReference pdfPage = Page.final;
        pdfpage.setRedirect(true);
		return pdfpage;

    }
	//method called from the Visualforce's action attribute
	public void attachPDF() {
		//generate and attach the PDF document
		PageReference pdfPage = Page.final; //create a page reference to our pdfDemo Visualforce page, which was created from the post http://www.interactiveties.com/blog/2015/render-visualforce-pdf.php
		Blob pdfBlob = pdfPage.getContentAsPDF(); //get the output of the page, as displayed to a user in a browser
		Attachment attach = new Attachment(parentId = rcc.id, Name = 'pdfAttachmentDemo.pdf', body = pdfBlob); //create the attachment object
		insert attach; //insert the attachment
		//redirect the user
		//PageReference pageWhereWeWantToGo = new ApexPages.StandardController(a).view(); //we want to redirect the User back to the Account detail page
		//pageWhereWeWantToGo.setRedirect(true); //indicate that the redirect should be performed on the client side
		//return pageWhereWeWantToGo; //send the User on their way
	}

}