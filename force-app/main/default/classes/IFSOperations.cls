/************************************************************************************
* Class Name: IFSOperations
* This class perrforms integration call to IFS for Customer, Order & Order Lines Sync
*************************************************************************************/
global class IFSOperations{
    public void IFSOperations(){    
    }      
    
    @AuraEnabled
    public static void syncCustomer(String accountId, String recordId){      
        IFSOperations.syncCustomerIFS(accountId, recordId);
        //syncPartrev(quoteId);
    }
    /*public static void syncPartrev(String quoteId){
    List<Part_Selector__c> pslst = [Select Id, Quote_Line__r.SBQQ__Quote__c,Part_Number__c,PARTREV__c  from Part_Selector__c where Quote_Line__r.SBQQ__Quote__c= :quoteId];
    Map<string,List<Id>> mao= new Map<string,List<Id>>();//prtnube, Listofpartselector
    for(Part_Selector__c ps : pslst){
    if(!String.Isempty(ps.Part_Number__c)){
    if(!mao.keyset().contains(ps.Part_Number__c))
    mao.put(ps.Part_Number__c,new List<string>());
    mao.get(ps.Part_Number__c).add(ps.Id);
    }
    }
    List<PS_AssyPartDefinition__c> assypartlst = [Select Id,PartRevision__c,ASSYPARTNO__c from PS_AssyPartDefinition__c where ASSYPARTNO__c in :mao.keyset()];
    List<Part_Selector__c> pslstUpdated = new List<Part_Selector__c>();
    for(PS_AssyPartDefinition__c assypart : assypartlst){
    for(ID i : mao.get(assypart.ASSYPARTNO__c)){
    Part_Selector__c temPS = new Part_Selector__c();
    temPS.Id = i;
    temPS.PARTREV__c = assypart.PartRevision__c;
    pslstUpdated.add(temPS);
    }
    }
    update pslstUpdated;
    }*/
    
    @AuraEnabled
    public static void generateAndSyncParts(String recordId){

        String accountIdLocal = getAccountId(recordId);

        if (isOrderId(recordId)) { 
            IFS_GeneratePartNumWithBatchCPQ generatePartNum = new IFS_GeneratePartNumWithBatchCPQ(recordId, accountIdLocal, false);
            Database.executeBatch(generatePartNum);
        }
        else {
            IFS_GeneratePartNumWithBatch generatePartNum = new IFS_GeneratePartNumWithBatch(recordId, accountIdLocal, false);
            Database.executeBatch(generatePartNum, 2);
        }

    }
    
    @AuraEnabled
    public static void generateAndSyncPartsAndOrder(String recordId) {

        String accountIdLocal = getAccountId(recordId);

        if (isOrderId(recordId)) { 

            List<String> listOfOrderItemStatus = new List<String>();        
            listOfOrderItemStatus.add('Primary');
            listOfOrderItemStatus.add('Blocked');
            listOfOrderItemStatus.add('Unblock');

            List<OrderItem> orderLines = [
                SELECT Id 
                FROM OrderItem 
                WHERE OrderId = :recordId 
                AND Line_Status__c IN :listOfOrderItemStatus
            ];

            if (orderLines.size() > 0) { 
                IFS_GeneratePartNumWithBatchCPQ generatePartNum = new IFS_GeneratePartNumWithBatchCPQ(recordId, accountIdLocal, true);
                Database.executeBatch(generatePartNum);
            }
            else {
                String xmlRequest = IFS_ConstructOrderReqCPQ.generateReq(recordId);       
                IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest, recordId, null, accountIdLocal, null, 'Order', recordId, null);
            }

        }
        else {

            List<String> listofQuoteLineStatus = new List<String>();        
            listofQuoteLineStatus.add('Primary');
            listofQuoteLineStatus.add('Blocked');
            listofQuoteLineStatus.add('Unblock');
            List<SBQQ__QuoteLine__c> quoteLines=[Select Id FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=: recordId AND Line_Status__c IN:listofQuoteLineStatus];
            if(quoteLines.size()>0){
                IFS_GeneratePartNumWithBatch  generatePartNum = new IFS_GeneratePartNumWithBatch(recordId,accountIdLocal,true);
                //Database.executeBatch(generatePartNum, 20);
                Database.executeBatch(generatePartNum, 2);
            }else{
                String xmlRequest=IFS_ConstructOrderReq.generateReq(recordId);       
                IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest,recordId,recordId,accountIdLocal,NULL,'Order',null,null);
            }

        }
    }
    
    // Feature #30292
    /**
    * Purpose: Validate that all contract reviews are completed, before the quote can Sync to IFS
    */
    @AuraEnabled
    public static ResponseWrapper syncOrderValidation(String recordId) {

        if (isOrderId(recordId)) {

            ResponseWrapper rw = new ResponseWrapper();
            
            List<String> listOfOrderItemStatus = new List<String>(); 
            listOfOrderItemStatus.add('Primary');
            listOfOrderItemStatus.add('Blocked');
            listOfOrderItemStatus.add('Unblock');
            
            Order ord = [
                SELECT Id, SBQQ__Quote__r.Contract_Review_Date__c, SBQQ__Quote__r.Denied_Party_Screening_Date__c, SBQQ__Quote__r.Terms_and_Conditions_Review_Date__c, SBQQ__Quote__r.Project_Coordinator__c,
                    Type, Backorder_Option__c, Customer_s_PO_Number__c, Ship_Via__c, Wanted_Delivery_Date__c, Planned_Delivery_Date__c,Delivery_Terms__c, Delivery_Terms_Location__c, (
                        SELECT Name 
                        FROM Integration_Logs__r 
                        WHERE Integration_Type__c = 'Order' 
                        AND Status__c = 'Success' 
                        LIMIT 1
                    ), (
                        SELECT SBQQ__QuoteLine__r.Expiration_Date__c 
                        FROM OrderItems
                        WHERE Line_Status__c IN :listOfOrderItemStatus 
                        ORDER BY SBQQ__QuoteLine__r.Expiration_Date__c  DESC 
                        LIMIT 1
                    ) 
                FROM Order
                WHERE Id = :recordId
                LIMIT 1
            ];
            
            Boolean orderProcessedFlag = false;
            List<Integration_Logs__c> integrationLogs = ord.Integration_Logs__r;
            if (integrationLogs.size() > 0) {
                orderProcessedFlag = true;
            }
            Boolean orderHasExpiredLines = false;
            List<OrderItem> orderLines  = ord.OrderItems;
            for (OrderItem orderLine : orderLines){
                if (orderLine.SBQQ__QuoteLine__r.Expiration_Date__c != null) {
                    if (Date.today() > orderLine.SBQQ__QuoteLine__r.Expiration_Date__c) {
                        orderHasExpiredLines = true;
                    }
                }
            }
            
            rw.message += ord.SBQQ__Quote__r.Contract_Review_Date__c == null ? 'Contract Review Is Not Complete.\n' : '';
            rw.message += ord.SBQQ__Quote__r.Denied_Party_Screening_Date__c == null ? 'Denied Party Screening Is Not Complete.\n' : '';
            rw.message += ord.SBQQ__Quote__r.Terms_and_Conditions_Review_Date__c == null ? 'Terms and Conditions Review Is Not Complete' : '';
            
            if (orderProcessedFlag) {
                rw.message += '\n Order already been successfully synced to IFS. Please use \'Change Order New\' button for making changes.';
            }
            if (orderHasExpiredLines) {
                rw.message += '\n Order can\'t be synced to IFS due to one or many quote lines are expired.';
            }
            rw.message += ord.SBQQ__Quote__r.Project_Coordinator__c == null ? 'Project Coordinator Is Not Complete.\n' : '';
            rw.message += ord.Type == null ? 'Order Type Is Not Complete.\n' : '';
            rw.message += ord.Backorder_Option__c == null ? 'Backorder Option Is Not Complete.\n' : '';
            rw.message += ord.Customer_s_PO_Number__c == null ? 'Customer\'s PO Number Is Not Complete.\n' : '';
            rw.message += ord.Ship_Via__c == null ? 'Ship via Is Not Complete.\n' : '';
            rw.message += ord.Wanted_Delivery_Date__c == null ? 'Wanted Delivery Date Is Not Complete.\n' : '';
            rw.message += ord.Planned_Delivery_Date__c == null ? 'Planned Delivery Date Is Not Complete.\n' : '';
            rw.message += ord.Delivery_Terms__c == null ? 'Delivery Terms Is Not Complete.\n' : '';
            rw.message += ord.Delivery_Terms_Location__c == null ? 'Delivery Terms Location Is Not Complete.\n' : '';
            rw.status = String.isBlank(rw.message) ? 'SUCCESS' : 'ERROR';

            return rw;

        }
        else {

            ResponseWrapper rw = new ResponseWrapper();
            List<String> listofQuoteLineStatus = new List<String>();        
            listofQuoteLineStatus.add('Primary');
            listofQuoteLineStatus.add('Blocked');
            listofQuoteLineStatus.add('Unblock');
            SBQQ__Quote__c qt = [
                SELECT Id,Contract_Review_Date__c,Denied_Party_Screening_Date__c,Terms_and_Conditions_Review_Date__c,
                Project_Coordinator__c,Order_Type__c,Backorder_Option__c,Customer_s_PO_Number__c,Ship_Via__c,
                Wanted_Delivery_Date__c,Planned_Delivery_Date__c,Delivery_Terms__c,Delivery_Terms_Location__c,(SELECT Name FROM Integration_Logs__r WHERE Integration_Type__c='Order' AND Status__c='Success' LIMIT 1),
                (SELECT Expiration_Date__c FROM SBQQ__LineItems__r WHERE Line_Status__c IN:listofQuoteLineStatus ORDER BY Expiration_Date__c desc LIMIT 1) 
                FROM SBQQ__Quote__c
                WHERE Id=:recordId
                LIMIT 1
            ];
            boolean orderProcessedFlag=false;
            List<Integration_Logs__c> integrationLogs  = qt.Integration_Logs__r;
            if(integrationLogs.size()>0){
                orderProcessedFlag=true;
            }
            boolean quoteHasExpiredLines=false;
            List<SBQQ__QuoteLine__c> quoteLines  = qt.SBQQ__LineItems__r;
            for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                if(quoteLine.Expiration_Date__c != NULL){
                    if(date.today() > quoteLine.Expiration_Date__c){
                        quoteHasExpiredLines=true;
                    }
                }
            }
            // IF ANY of the review dates are null (reviews are incomplete)
            //  THEN add them to the response
            rw.message += qt.Contract_Review_Date__c == null ? 'Contract Review Is Not Complete.\n' : '';
            rw.message += qt.Denied_Party_Screening_Date__c == null ? 'Denied Party Screening Is Not Complete.\n' : '';
            rw.message += qt.Terms_and_Conditions_Review_Date__c == null ? 'Terms and Conditions Review Is Not Complete' : '';
            
            if(orderProcessedFlag){
                rw.message += '\n Order already been successfully synced to IFS. Please use \'Change Order New\' button for making changes.';
            }
            if(quoteHasExpiredLines){
                rw.message += '\n Order can\'t be synced to IFS due to one or many quote lines are expired.';
            }
            rw.message += qt.Project_Coordinator__c == null ? 'Project Coordinator Is Not Complete.\n' : '';
            rw.message += qt.Order_Type__c == null ? 'Order Type Is Not Complete.\n' : '';
            rw.message += qt.Backorder_Option__c == null ? 'Backorder Option Is Not Complete.\n' : '';
            rw.message += qt.Customer_s_PO_Number__c == null ? 'Customer\'s PO Number Is Not Complete.\n' : '';
            rw.message += qt.Ship_Via__c == null ? 'Ship via Is Not Complete.\n' : '';
            rw.message += qt.Wanted_Delivery_Date__c == null ? 'Wanted Delivery Date Is Not Complete.\n' : '';
            rw.message += qt.Planned_Delivery_Date__c == null ? 'Planned Delivery Date Is Not Complete.\n' : '';
            rw.message += qt.Delivery_Terms__c == null ? 'Delivery Terms Is Not Complete.\n' : '';
            rw.message += qt.Delivery_Terms_Location__c == null ? 'Delivery Terms Location Is Not Complete.\n' : '';
            // IF ALL of the review dates are filled out, set the status to success
            rw.status = String.isBlank(rw.message) ? 'SUCCESS' : 'ERROR';
            return rw;

        }
    }
    
    @AuraEnabled
    public static void cancelOrder(String accountId,String quoteId){
        IFSOperations.cancelOrderIFS(accountId, quoteId);
    }
    
    webservice static void syncCustomerClassic(String accountId,String quoteId){
        IFSOperations.syncCustomerIFS(accountId, quoteId);
    }
    
    webservice static void syncPartsClassic(String accountId,String quoteId){        
        IFSOperations.syncPartsIFSWithBatch(accountId, quoteId);        
    }
    
    webservice static void syncOrderClassic(String accountId,String quoteId){
        IFSOperations.syncOrderIFS(accountId, quoteId);
        
    }
    
    webservice static void cancelOrderClassic(String accountId,String quoteId){
        IFSOperations.cancelOrderIFS(accountId, quoteId);
    }
    
    @future(callout=true)   
    public static void syncCustomerIFS(String accountId, String recordId) {

        String accountIdLocal = accountId;

        if(accountIdLocal == null || accountIdLocal == ''){         
            accountIdLocal = getAccountId(recordId);
        }

        if (isOrderId(recordId)) {
            String xmlRequest = IFS_ConstructCustReqCPQ.generateReq(accountIdLocal, recordId);
            IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest, accountIdLocal, null, accountIdLocal, null, 'Customer', recordId, null);
        }
        else {
            String xmlRequest = IFS_ConstructCustReq.generateReq(accountIdLocal, recordId);
            IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest, accountIdLocal, recordId, accountIdLocal, null, 'Customer', null, null);
        }
                          
    }
    
    @future(callout=true)   
    public static void syncOrderIFS(String accountId, String recordId){

        String accountIdLocal = accountId;

        if(accountIdLocal == null || accountIdLocal == ''){         
            accountIdLocal = getAccountId(recordId);
        }

        if (isOrderId(recordId)) {
            String xmlRequest = IFS_ConstructOrderReq.generateReq(recordId); 
            IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest, accountIdLocal, null, accountIdLocal, null, 'Order', recordId, null);
        }
        else {
            String xmlRequest = IFS_ConstructOrderReq.generateReq(recordId); 
            IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest, accountIdLocal, recordId, accountIdLocal, null, 'Order', null, null);
        }
                        
    }        
    
    @AuraEnabled
    public static void syncPartsIFSWithBatch(String accountId,String quoteId){
        String accountIdLocal=accountId;
        if(accountIdLocal == null){
            accountIdLocal=getAccountId(quoteId);
        }
        List<SBQQ__QuoteLine__c> quoteLines=[Select Id,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=: quoteId];
        if(quoteLines.size()>0){
            Map<Id,HandlerInterface> genUtilMap = new Map<id,HandlerInterface>();
            List<String> batchList=new List<String>();  
            for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                Id currentId=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine.Id);
                //if(quoteLine.SBQQ__ProductCode__c == 'BGR'){
                GenericUtilityForXML generic=new GenericUtilityForXML();
                HandlerInterface genUtil = generic.getUtilityInstance(quoteLine.SBQQ__ProductCode__c,currentId);                    
                genUtilMap.put(quoteLine.Id,genUtil);
                batchList.add(quoteLine.Id+'_'+'getEngineeringParts');
                batchList.add(quoteLine.Id+'_'+'getInventoryPartDetails');
                batchList.add(quoteLine.Id+'_'+'getSalesParts');
                batchList.add(quoteLine.Id+'_'+'getPurchasePart');
                batchList.add(quoteLine.Id+'_'+'getPurchasePartSuppliers');
                batchList.add(quoteLine.Id+'_'+'getProductCatalog');
                batchList.add(quoteLine.Id+'_'+'getStructureXML');
                batchList.add(quoteLine.Id+'_'+'GetRoutingDetails');
                batchList.add(quoteLine.Id+'_'+'GetControlPlanDetails');
                //}              
            }
            
            try{
                IFS_ConstructPartReqWithBatch  partReq = new IFS_ConstructPartReqWithBatch(quoteId,accountIdLocal,genUtilMap,batchList,false);
                if(!Test.isRunningTest()){
                    Database.executeBatch(partReq, 1);
                }else{
                    Database.executeBatch(partReq);
                }
            }catch(Exception e){
                System.debug('Exception :'+e.getMessage());
            }
        }   
    }
    
    @future(callout=true)    
    public static void cancelOrderIFS(String accountId,String quoteId){
        List<String> listofStatuses = new List<String>();
        listofStatuses.add('Hold');
        listofStatuses.add('Cancelled');
        listofStatuses.add('Cancel');
        listofStatuses.add('Blocked');
        listofStatuses.add('Unblock');
        List<String> listofQuoteLineStatus = new List<String>();        
        listofQuoteLineStatus.add('Cancel');
        listofQuoteLineStatus.add('Blocked');
        listofQuoteLineStatus.add('Unblock');
        SBQQ__Quote__c quote = [SELECT Id,SBQQ__Account__c,Name,SBQQ__Opportunity2__r.Integration_Message_Counter__c,Order_Number__c,Change_Order_Status__c,
                                SBQQ__Status__c,Status_Reason__c,IFS_Order_Status__c,Change_Order_Comments__c,
                                (SELECT Id,Name,Line_Number__c,QuoteLineNumber__c,Line_Status__c,SBQQ__Quote__r.Order_Number__c,
                                 SBQQ__Quote__r.SBQQ__Opportunity2__r.Integration_Message_Counter__c,
                                 SBQQ__Quote__r.IFS_Order_Status__c,Status_Reason__c,
                                 SBQQ__OriginalQuoteLineId__c,Delivery_Number__c,SBQQ__Quote__r.SBQQ__Status__c,
                                 SBQQ__Quote__r.Change_Order_Comments__c, Change_Order_Status__c  
                                 FROM SBQQ__LineItems__r 
                                 WHERE Change_Order_Status__c IN:listofQuoteLineStatus) 
                                FROM SBQQ__Quote__c 
                                WHERE id=:quoteId limit 1];
        String accountIdLocal=accountId;
        if(accountIdLocal == null){         
            accountIdLocal=quote.SBQQ__Account__c;
        }                        
        if(listofStatuses.contains(quote.Change_Order_Status__c)){
            String xmlRequest=IFS_ConstructCancelOrderReq.generateReq(quote);           
            IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest,quoteId,quoteId,accountIdLocal,NULL, quote.Change_Order_Status__c +' Order');           
            
        }else{
            List<SBQQ__QuoteLine__c> quoteLines  = quote.SBQQ__LineItems__r;
            if(quoteLines.size()>0){
                Map<Id,Map<String,String>> retMapMap = new Map<id,Map<String,String>>();
                for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                    String xmlRequest=IFS_ConstructCancelOLineReq.generateReq(quoteLine);
                    String type='Cancel Order Line';
                    if(quoteLine.Change_Order_Status__c != NULL){
                        type=quoteLine.Change_Order_Status__c+' Order Line';
                    }
                    //IFS_MakeHTTPCall.makeHTTPCallOutNdLog(xmlRequest,quoteId,quoteId,accountIdLocal,quoteLine.Id,type);
                    Map<String,String> retMap=IFS_MakeHTTPCall.makeHTTPCallOut(xmlRequest,quoteId,quoteId,accountIdLocal,quoteLine.Id,type);
                    retMapMap.put(quoteLine.Id,retMap);                 
                }
                for(Id lineId:retMapMap.keyset()){
                    IFS_MakeHTTPCall.insertLogRecord(retMapMap.get(lineId));
                }
            }        
        } 
    }

    public static String getAccountId(String recordId) {

        if (isOrderId(recordId)) {

            Order ord = [
                SELECT Id, AccountId 
                FROM Order 
                WHERE Id = :recordId
                LIMIT 1
            ];
            return ord.AccountId;

        }
        else {

            SBQQ__Quote__c quote = [
                SELECT Id, SBQQ__Account__c
                FROM SBQQ__Quote__c
                WHERE Id = :recordId
                LIMIT 1
            ];
            return quote.SBQQ__Account__c;

        }
    }

    @AuraEnabled
    public static void createCreditsAndBooking(String recordId) {

        String quoteId = recordId;
        if (isOrderId(recordId)) {
            quoteId = [
                SELECT SBQQ__Quote__r.Id 
                FROM Order 
                WHERE Id = :recordId
            ].SBQQ__Quote__r.Id;
        }

        Decimal totalAmt = 0;
        Decimal amountOnQuote = 0;
        Credits_and_Booking__c credAndBook = null;
        
        SBQQ__Quote__c quote = [SELECT Id,Change_Order_No__c,Total_amount__c,Total_Bookings__c,SBQQ__NetAmount__c,RecordTypeId, 
                                SBQQ__Status__c, Change_Order_Status__c, Total_Quote_Line_Bookings__c 
                                FROM SBQQ__Quote__c
                                WHERE Id = :quoteId
                                LIMIT 1];
        
        List<Charge__c> existingCharges = [SELECT Amount__c, CreatedDate, Id, IsDeleted, Name, 
                                           Parent_Quote__c, Quantity__c, Sent_to_IFS__c, 
                                           Sequence__c, Status__c, Total_Charge__c, 
                                           Type__c, LastmodifiedDate,Update__c,
                                           Previous_Amount__c,Amount_Updated__c,Quantity_Updated__c,Status_Updated__c, Previous_Quantity__c
                                           FROM Charge__c
                                           WHERE Parent_Quote__c = :quote.Id];
        System.debug('@Developer --> existingCharges :' + existingCharges);
        
        List<Credits_and_Booking__c> existingCredAndBook = [SELECT id,Amount__c
                                                            FROM Credits_and_Booking__c
                                                            WHERE Quote__c = :quote.Id and Charge_Type__c = NULL];
        
        for(Credits_and_Booking__c cRec : existingCredAndBook) {
            totalAmt = totalAmt + cRec.Amount__c;
        }
        
        amountOnQuote = quote.Total_Quote_Line_Bookings__c - totalAmt;
        system.debug('@Developer ==>amountOnQuote'+amountOnQuote);
        system.debug('@Developer ==>SBQQ__NetAmount__c'+quote.SBQQ__NetAmount__c);
        system.debug('@Developer ==>totalAmt'+totalAmt);
        try {
            
            if (amountOnQuote != 0 && quote.Change_Order_Status__c != 'Cancel'){
                credAndBook = new Credits_and_Booking__c(Type__c = 'Booking',
                                                         Amount__c = amountOnQuote,
                                                         Quote__c = quote.id
                                                        );
                insert credAndBook;
            }
            
            if(quote.Change_Order_Status__c == 'Cancel'){
                credAndBook = new Credits_and_Booking__c(Type__c = 'Booking',
                                                         Amount__c =  (-1* quote.Total_Amount__c) ,
                                                         Quote__c = quote.id,
                                                         External_ID__c = (quote.Change_Order_Status__c + ':' + quote.id)
                                                        );
                upsert credAndBook External_ID__c;
            }
            
            
            
            //Feature #30230
            quote.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Order_Submitted').getRecordTypeId();
            quote.SBQQ__Status__c ='Order Submitted';
            update quote;
            
            if (quote.Change_Order_Status__c != 'Cancel'){
                ChargeUpsertBookingAndCharges.upsertCandB(existingCharges);
            }
        } 
        catch(Exception e) {
            System.debug('@Developer --> Exception :' + e.getStackTraceString());
            throw new AuraHandledException('Error message '+e.getMessage());
        }
    }

    public static Boolean isOrderId(Id recordId) {

        if (String.valueOf(recordId.getSobjectType()) == 'Order') {
            return true;
        }
        else {
            return false;
        }

    }

}