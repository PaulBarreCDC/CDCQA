@isTest
private class IFS_ConstructCancelOLineReqTest{          
   static testMethod void generateReq(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST2' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1]; 
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,Name,Line_Number__c,QuoteLineNumber__c,Line_Status__c,SBQQ__Quote__r.Order_Number__c,
                                                    SBQQ__Quote__r.SBQQ__Opportunity2__r.Integration_Message_Counter__c,
                                                    SBQQ__Quote__r.IFS_Order_Status__c,Status_Reason__c,
                                                    SBQQ__OriginalQuoteLineId__c,Delivery_Number__c,Change_Order_Status__c,SBQQ__Quote__r.SBQQ__Status__c,
                                                    SBQQ__Quote__r.Change_Order_Comments__c  
                                             FROM SBQQ__QuoteLine__c 
                                             WHERE Line_Status__c = 'Cancel' AND SBQQ__Quote__c=: quote.Id limit 1];
        quoteLine.Change_Order_Status__c='Cancel';
        quoteLine.Status_Reason__c='CHG ORDER';
        IFS_ConstructCancelOLineReq.generateReq(quoteLine);
        Test.stopTest();
    }
}