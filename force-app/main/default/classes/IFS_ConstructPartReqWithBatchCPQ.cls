public class IFS_ConstructPartReqWithBatchCPQ implements Database.Batchable<cdcpc.IFSXML_Result>, Database.Stateful, Database.AllowsCallouts {
    
    private String orderId;
    private String accountId;
    private boolean orderSyncFlag; 
    private List<cdcpc.IFSXML_Result> parts;
    private Long startTime = 0;
    private Long endTime = 0;

    public IFS_ConstructPartReqWithBatchCPQ(
        String orderId, 
        String accountId, 
        boolean orderSyncFlag,
        List<cdcpc.IFSXML_Result> parts
    ) {

        this.orderId = orderId;
        this.accountId = accountId;
        this.orderSyncFlag = orderSyncFlag;
        this.parts = parts;

    }

    public List<cdcpc.IFSXML_Result> start(Database.BatchableContext bc) {

        startTime = DateTime.now().getTime();
        return parts;

    }  

    public void execute(Database.BatchableContext bc, List<cdcpc.IFSXML_Result> scope) {

        String partsXml = null;

        System.debug('scope.size()');
        System.debug(scope.size());

        for (cdcpc.IFSXML_Result part : scope) {

            System.debug('part.result');
            System.debug(part.result);
            System.debug((String)part.result);

            if (partsXml == null) {
                partsXml = (String)part.result;
            }
            else {
                partsXml = partsXml + (String)part.result;
            } 

        }

        if (partsXml != null) {

            String xmlRequest = '';

            XmlStreamWriter xmlStream = new XmlStreamWriter();
            xmlStream.writeStartElement('soap', 'Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');
            xmlStream.writeNamespace('soap', 'http://schemas.xmlsoap.org/soap/envelope/');
            xmlStream.writeStartElement('soap', 'Body', '');
            xmlStream.writeStartElement('','PARTS','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_part_master_request');
            xmlStream.writeNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
            xmlStream.writeNamespace('', 'urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_part_master_request');  

            xmlStream.writeStartElement('', 'SF_MESSAGE_ID', '');
            xmlStream.writeCharacters('NO_MAPPING'); 
            xmlStream.writeEndElement();        

            xmlStream.writeStartElement('', 'PART_LIST', '');                                     
            xmlStream.writeCharacters('$PART_LIST_PH$');           
            xmlStream.writeEndElement();           
            xmlStream.writeEndElement();
            xmlStream.writeEndElement();
            xmlStream.writeEndElement();         
                
            xmlRequest = xmlStream.getXMLString();
           
            xmlRequest = xmlRequest.replace('$PART_LIST_PH$', partsXml);
            xmlRequest = xmlRequest.replace('<ENG_PART_REC>', '<PART_MASTER><ENG_PART_REC>');              
            xmlRequest = xmlRequest.replace('</CONTROL_PLAN_MANUF_LIST>', '</CONTROL_PLAN_MANUF_LIST></PART_MASTER>');
            xmlRequest = xmlRequest.replace('<CONTROL_PLAN_MANUF_LIST/>', '<CONTROL_PLAN_MANUF_LIST/></PART_MASTER>');
            xmlRequest = xmlRequest.replace('<CONTROL_PLAN_MANUF_LIST />', '<CONTROL_PLAN_MANUF_LIST /></PART_MASTER>');
            xmlRequest = xmlRequest.replace('<?xml version="1.0"?>', '');
            xmlRequest = xmlRequest.replace('<?xml version="1.0" encoding="utf-8"?>', '');

            if (!orderSyncFlag) {

                IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest, accountId, null, accountId, null, 'Parts', orderId, null);
            
            }
            else {      

                String xmlOrderRequest = IFS_ConstructOrderReqCPQ.generateReq(orderId);
                Map<String,String> retMapParts = IFS_MakeHTTPCall.makeHTTPCallOut(xmlRequest, accountId, null, accountId, null, 'Parts', orderId, null);
                // Map<String,String> retMapParts = IFS_MakeHTTPCall.makeHTTPCallOut(xmlRequest, quoteId, quoteId, accountId, NULL, 'Parts');                 
                Map<String,String> retMapOrder = IFS_MakeHTTPCall.makeHTTPCallOut(xmlOrderRequest, accountId, null, accountId, null, 'Order', orderId, null);
                // Map<String,String> retMapOrder = IFS_MakeHTTPCall.makeHTTPCallOut(xmlRequestOrder,quoteId,quoteId,accountId,NULL,'Order');
                IFS_MakeHTTPCall.insertLogRecord(retMapParts);
                IFS_MakeHTTPCall.insertLogRecord(retMapOrder);

                Order ord = [
                    SELECT Id, Status 
                    FROM Order 
                    WHERE Id = :orderId
                ];
                ord.Status = 'Order Submitted';
                // cloned code had record types but there are no record types on Order

            }

        }

    }

    public void finish(Database.BatchableContext bc) {

        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()
        ];

        endTime = DateTime.now().getTime(); 

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { UserInfo.getUserEmail() };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Batch Job is done' + job.Id);
        mail.setPlainTextBody('Order : ' + orderId + ' Time Taken for the Batch :' + job.Id + ' is ' + String.valueOf((endTime - startTime) / 1000) + ' sec');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

}