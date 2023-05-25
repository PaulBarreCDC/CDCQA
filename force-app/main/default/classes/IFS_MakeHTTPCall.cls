/*********************************************************************************
* Class Name: IFS_MakeHTTPCall
* This class makes HTTP Callouts to IFS and inserts log record into the database
*********************************************************************************/
public class IFS_MakeHTTPCall{
    
    public void IFS_MakeHTTPCall(){
    }

    // REMOVE AFTER DEEREFERENCED
    public static void makeHTTPCallOutNdLog(String request,String recordId,String quoteId,String accountId,String quoteLineId,String type){ }
    public static  Map<String,String> makeHTTPCallOut(String request,String recordId,String quoteId,String accountId,String quoteLineId,String type){ return null; }
    
    public static void makeHTTPCallOutNdLog(String request, String recordId, String quoteId, String accountId, String quoteLineId, String type, String orderId, String orderLineId){        
        Map<String,String> retMap = makeHTTPCallOut(request, recordId, quoteId, accountId, quoteLineId, type, orderId, orderLineId);
        /*Integer j=0;
        for (Integer i = 0; i < 10; i++) {
            j=i;
        }*/
        insertLogRecord(retMap);
    }   
    
    public static  Map<String,String> makeHTTPCallOut(String request,String recordId,String quoteId,String accountId,String quoteLineId,String type, String orderId, String orderLineId){        
        Map<String,String> retMap = new Map<String,String>();
        HttpRequest req = new HttpRequest();             
        //req.setEndpoint('callout:IFS_Endpoint');
        req.setEndpoint('callout:WH');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=character encoding');  
        //req.setTimeout(40000);
        req.setTimeout(120000);   
        Http http = new Http();
        String responseMsg='';
        String logKey=UserInfo.getUserId()+'-'+recordId+'-'+String.valueOf(Datetime.now().formatGMT('yyyyMMddHHmmssSSS'));      
        String xmlRequest=request.replace('<SF_MESSAGE_ID>NO_MAPPING</SF_MESSAGE_ID>', '<SF_MESSAGE_ID>'+logKey+'</SF_MESSAGE_ID>');        
        if(xmlRequest.indexOf('NULL') == -1 && xmlRequest.indexOf('null') == -1 && xmlRequest.indexOf('Null') == -1){
            req.setBody(xmlRequest);        
            if(!Test.isRunningTest()){  
               System.debug('XML');
               System.debug(xmlRequest);
               HTTPResponse response = http.send(req);           
               responseMsg='StatusCode='+response.getStatusCode() +', Status='+response.getStatus();
            }
            else{
               System.debug('XML');
               System.debug(xmlRequest);
               //Invoke web service callout
            }
        }else{
            responseMsg='Couldn\'t process the request due to XML contains Null/NULL/null. Please contact the Administrator';
        }
        retMap.put('responseMsg',responseMsg);
        retMap.put('logKey',logKey);
        retMap.put('endpoint',req.getEndpoint());
        retMap.put('xmlRequest',xmlRequest);
        retMap.put('quoteId',quoteId);
        retMap.put('accountId',accountId);
        retMap.put('quoteLineId',quoteLineId);
        retMap.put('type',type);
        retMap.put('orderId',orderId);
        retMap.put('orderLineId',orderLineId);
        
        return retMap;        
    }
    
    public static void insertLogRecord(Map<String,String> inputs){
        
        String externalId=inputs.get('logKey');
        Integration_Logs__c log=null;
        for(Integration_Logs__c eachLog : [SELECT Id, Quote__c, Account__c, Quote_Line__c, Order__c, Order_Line__c FROM Integration_Logs__c WHERE External_Id__c = :externalId]){
            log=eachLog;
        }       
        if(log == NULL){
            log=new Integration_Logs__c();
            log.External_Id__c=inputs.get('logKey');
            log.Endpoint_URL__c= inputs.get('endpoint');
            String responseMsg=inputs.get('responseMsg');
            log.Response__c = responseMsg;
            if(responseMsg != 'StatusCode=200, Status=OK'){
                log.Status__c = 'Error';
            }
        }
        if (inputs.get('quoteId') != null) {        
            log.Quote__c = inputs.get('quoteId');
        }
        if (inputs.get('accountId') != null) {
            log.Account__c = inputs.get('accountId');
        }
        if (inputs.get('quoteLineId') != null) {
            log.Quote_Line__c = inputs.get('quoteLineId');
        }
        if (inputs.get('type') != null) {
            log.Integration_Type__c = inputs.get('type');
        } 
        if (inputs.get('orderId') != null) {
            log.Order__c = inputs.get('orderId');
        }
        if (inputs.get('orderLineId') != null) {
            log.Order__c = inputs.get('orderLineId');
        }
        //log.Request_Payload__c = inputs.get('xmlRequest');
        try{    
            upsert log;
            if(Test.isRunningTest())
            {
                throw new DmlException();
            }
        }catch(Exception e){
            String exceptionMsg=e.getMessage();
            if(exceptionMsg.indexOf('Upsert failed. First exception on row 0; first error: DUPLICATE_VALUE, duplicate value found: External_Id__c duplicates value on record with id')!=-1 || Test.isRunningTest()){
                for(Integration_Logs__c eachLog : [SELECT Id,Quote__c,Account__c,Quote_Line__c, Order__c, Order_Line__c from Integration_Logs__c where External_Id__c=:externalId]){
                    log=eachLog;
                    if (inputs.get('quoteId') != null) {        
                        log.Quote__c = inputs.get('quoteId');
                    }
                    if (inputs.get('accountId') != null) {
                        log.Account__c = inputs.get('accountId');
                    }
                    if (inputs.get('quoteLineId') != null) {
                        log.Quote_Line__c = inputs.get('quoteLineId');
                    }
                    if (inputs.get('type') != null) {
                        log.Integration_Type__c = inputs.get('type');
                    } 
                    if (inputs.get('orderId') != null) {
                        log.Order__c = inputs.get('orderId');
                    }
                    if (inputs.get('orderLineId') != null) {
                        log.Order__c = inputs.get('orderLineId');
                    }
                    upsert log;
                }
            }
        }
        
        String xmlRequest=inputs.get('xmlRequest');
        
        //Insert ContentVersion
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = inputs.get('logKey')+'.txt';//File name with extention
        cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
        cVersion.OwnerId = UserInfo.getUserId();//Owner of the file
        cVersion.Title = inputs.get('logKey');//Name of the file
        cVersion.VersionData = Blob.valueOf(xmlRequest);//File content
        Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = log.Id;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
    }
}