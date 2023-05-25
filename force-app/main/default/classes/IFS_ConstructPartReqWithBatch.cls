/*********************************************************************************
* Class Name: IFS_ConstructPartReqWithBatch
* This class constructs part XML request from quote lines for IFS Integration
*********************************************************************************/
global class IFS_ConstructPartReqWithBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{ 
    private String quoteId;
    public String xmlRequest='';
    private String partMasterInfo='';
    private String accountId='';
    private boolean orderSyncFlag;
    private Map<Id,HandlerInterface> genUtilMap = new Map<Id,HandlerInterface>();
    private List<String> batchList= new List<String>(); 
    public IFS_ConstructPartReqWithBatch(String qId,String accountId,Map<Id,HandlerInterface> genUtilMap,List<String> batchList,boolean oSyncFlag){
        quoteId=qId;
        orderSyncFlag = oSyncFlag;         
        this.accountId=accountId;
        this.genUtilMap=genUtilMap;
        this.batchList=batchList;   
    }    
    global Integer recordsProcessed = 0;
    global Long startTime=0;
    global Long endTime=0;  
    global Iterable<String> start(Database.BatchableContext bc) {
        startTime = DateTime.now().getTime();
        return batchList;
    }    
    global void execute(Database.BatchableContext bc, List<String> batchList){     
            for(String eachMethod : batchList){
                String[] eachMethodSplitted=eachMethod.split('_');             
                String detailsString='';           
                    HandlerInterface genUtil = genUtilMap.get(eachMethodSplitted[0]);
                    Result res=new Result();
                    try{    
                    if(eachMethodSplitted[1]=='getEngineeringParts'){   
                        res=genUtil.getEngineeringParts();                                               
                    }else if(eachMethodSplitted[1]=='getInventoryPartDetails'){ 
                        res=genUtil.getInventoryPartDetails();                                         
                    }else if(eachMethodSplitted[1]=='getSalesParts'){   
                        res=genUtil.getSalesParts();                                             
                    }else if(eachMethodSplitted[1]=='getPurchasePart'){ 
                        res=genUtil.getPurchasePart();                                         
                    }else if(eachMethodSplitted[1]=='getPurchasePartSuppliers'){    
                        res=genUtil.getPurchasePartSuppliers();                                             
                    }else if(eachMethodSplitted[1]=='getProductCatalog'){   
                        res=genUtil.getProductCatalog();                                          
                    }else if(eachMethodSplitted[1]=='getStructureXML'){ 
                        res=genUtil.getStructureXML();                                            
                    }else if(eachMethodSplitted[1]=='GetRoutingDetails'){   
                        res=genUtil.GetRoutingDetails();                                                
                    }else if(eachMethodSplitted[1]=='GetControlPlanDetails'){   
                        res=genUtil.GetControlPlanDetails();                                               
                    }
                    }catch(Exception e){
                        if(!Test.isRunningTest()){
                            throw e;
                        }
                    }                   
                    if(res.xmlStringResult != NULL && res.xmlStringResult != ''){
                        detailsString= res.xmlStringResult;
                    }
                    if(detailsString != ''){
                        partMasterInfo = partMasterInfo + detailsString;
                    }   
                recordsProcessed = recordsProcessed + 1;                
            }
                     
    }
    global void finish(Database.BatchableContext bc){
        if(partMasterInfo != ''){
            
                XmlStreamWriter xmlStream = new XmlStreamWriter();
                xmlStream.writeStartElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
                xmlStream.writeNamespace('soap','http://schemas.xmlsoap.org/soap/envelope/');
                xmlStream.writeStartElement('soap','Body','');
                xmlStream.writeStartElement('','PARTS','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_part_master_request');
                xmlStream.writeNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
                xmlStream.writeNamespace('','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_part_master_request');  

                xmlStream.writeStartElement('', 'SF_MESSAGE_ID', '');
                xmlStream.writeCharacters('NO_MAPPING'); 
                xmlStream.writeEndElement();        

                xmlStream.writeStartElement('','PART_LIST','');// start of PART_LIST                                      
                xmlStream.writeCharacters('$PART_LIST_PH$');           
                xmlStream.writeEndElement();// end of PART_LIST             
                xmlStream.writeEndElement();// end of PARTS
                xmlStream.writeEndElement();// end of BODY
                xmlStream.writeEndElement();//end of Envelope           
                    
                xmlRequest = xmlStream.getXMLString();
               
                xmlRequest=xmlRequest.replace('$PART_LIST_PH$',partMasterInfo);
                xmlRequest=xmlRequest.replace('<ENG_PART_REC>','<PART_MASTER><ENG_PART_REC>');              
                xmlRequest=xmlRequest.replace('</CONTROL_PLAN_MANUF_LIST>','</CONTROL_PLAN_MANUF_LIST></PART_MASTER>');
                xmlRequest=xmlRequest.replace('<CONTROL_PLAN_MANUF_LIST/>','<CONTROL_PLAN_MANUF_LIST/></PART_MASTER>');
                xmlRequest=xmlRequest.replace('<CONTROL_PLAN_MANUF_LIST />','<CONTROL_PLAN_MANUF_LIST /></PART_MASTER>');
                xmlRequest=xmlRequest.replace('<?xml version="1.0"?>','');
                xmlRequest=xmlRequest.replace('<?xml version="1.0" encoding="utf-8"?>','');
                
                if(!orderSyncFlag){
                    IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest,quoteId,quoteId,accountId,NULL,'Parts');
                }else{                  
                    String xmlRequestOrder=IFS_ConstructOrderReq.generateReq(quoteId);
                    Map<String,String> retMapParts=IFS_MakeHTTPCall.makeHTTPCallOut(xmlRequest,quoteId,quoteId,accountId,NULL,'Parts');                 
                    Map<String,String> retMapOrder=IFS_MakeHTTPCall.makeHTTPCallOut(xmlRequestOrder,quoteId,quoteId,accountId,NULL,'Order');
                    IFS_MakeHTTPCall.insertLogRecord(retMapParts);
                    IFS_MakeHTTPCall.insertLogRecord(retMapOrder);
                    Id orderSumittedRecTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Order_Submitted').getRecordTypeId();
                    SBQQ__Quote__c qt = [Select Id,RecordTypeId, SBQQ__Status__c FROM SBQQ__Quote__c where Id=:quoteId];
                    qt.RecordTypeId = orderSumittedRecTypeId;
                    qt.SBQQ__Status__c ='Order Submitted';
                    update qt;
                }
        }else{
            xmlRequest='';
        }
        
        //System.debug(recordsProcessed + ' lines processed!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        endTime = DateTime.now().getTime(); 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {'vinayaka.singh@apexit.com','ashok.sontineni@apexit.com'};
            String[] toAddresses = new String[] {UserInfo.getUserEmail()};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Apex Batch Job is done'+ job.Id);
            //mail.setPlainTextBody('The batch Apex job processed '+ job.Id);
            //mail.setPlainTextBody(xmlRequest);
            mail.setPlainTextBody('Quote : '+quoteId+' Time Taken for the Batch :'+ job.Id + ' is '+ String.valueOf((endTime-startTime)/1000) + ' sec');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }   
   
}