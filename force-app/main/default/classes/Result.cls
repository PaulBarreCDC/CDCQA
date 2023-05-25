// This class is used to convey result of any operation using error\success code, text message associated with
// error\success operation.
public class Result {
    // Overall 0 means failure, 1 means success
    public boolean bResult;

    public boolean bErrorCheck;

    // Any error message associated. any exception that was caught etc
    public string strErrorMessage;
    // Any other return value that needs to be passed back
    public string strRetValue;
    public string strRetValue2;
    public list<string> listStrResValue;
    public double dblRetValue;
    public double dblRetValue2;
    //To return List of Records
    public List<sObject> objResultList;
    // To return the XML Output
    public XmlStreamWriter xmlResult;
    // To return the XML Output String
    public String xmlStringResult;
    // Default
    public Result(){
        bResult = false;
        bErrorCheck=false;
        strErrorMessage = 'No error information available.';
        strRetValue = '';
        strRetValue2='';
        dblRetValue = 0.0;
        dblRetValue2=0.0;
        xmlStringResult= '';
        listStrResValue=new list<string>();
        objResultList=new List<sObject>();
        xmlResult=new XmlStreamWriter();
    }
}