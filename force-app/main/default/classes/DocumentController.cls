public class DocumentController {
    public String XMLHeadingInformation {
        get {
            if(XMLHeadingInformation == null) {
                XMLHeadingInformation = '<?xml version="1.0" encoding="UTF-8" ?>';
            }
            return XMLHeadingInformation;
        }
        set;
    }
}