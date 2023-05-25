public class CustomErrorController {
	    
    public PageReference redirectHome() {
        
        PageReference retURL = new PageReference(URL.getOrgDomainUrl().toExternalForm());
        retURL.setRedirect(true);
        return retURL;
	}
}