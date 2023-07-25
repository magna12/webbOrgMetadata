public class SaveAsPdfExtension {
    public SaveAsPDFExtension(ApexPages.StandardController controller) {}
    public String renderingService { get; private set; }
    public String renderedFileName {
        get;
        set { renderedFileName = this.sanitizeFileName(value); }
    }
    public String renderedContentType {
        get {
            String renderedContentType = 'text/html'; // the default
            if( ! this.renderingAsHtml() ) {
                // Provides a MIME type for a PDF document
                renderedContentType = 'application/pdf';
                // Add a file name for the PDF file
                if( this.renderedFileName != null) {
                    // This is supposed to set the file name, but it doesn't work
                    renderedContentType += '#' + this.renderedFileName;
                    ApexPages.currentPage().getHeaders().put(
                        'content-disposition', 'attachment; filename=' +
                         this.renderedFileName);
                }
            }
             
            return renderedContentType;
        }
    }
    public Boolean renderingAsHtml() {
        return ( (renderingService == null) ||
                 ( ! renderingService.startsWith('PDF')) );
    }
    public PageReference saveToPdf() {
        renderingService = 'PDF';
        return null;
    }
    private String sanitizeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String sanitizedName =
            unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        return(sanitizedName);
    }


}