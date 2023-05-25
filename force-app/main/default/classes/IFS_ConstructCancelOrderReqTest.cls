@isTest
private class IFS_ConstructCancelOrderReqTest{          
   static testMethod void generateReq(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name,SBQQ__Account__c,SBQQ__Opportunity2__r.Integration_Message_Counter__c,Order_Number__c,SBQQ__Status__c,Status_Reason__c,IFS_Order_Status__c,Change_Order_Comments__c,Change_Order_Status__c FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];
        quote.Change_Order_Status__c='Cancel';
        quote.Status_Reason__c='CHG ORDER';
        IFS_ConstructCancelOrderReq.generateReq(quote);
        Test.stopTest();
    }
}