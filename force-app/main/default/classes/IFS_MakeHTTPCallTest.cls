@isTest
private class IFS_MakeHTTPCallTest{         
   static testMethod void makeHTTPCallOutNdLog(){
        IFS_TestDataFactory.createTestRecords(); 
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];
        Test.startTest();          
        IFS_MakeHTTPCall.makeHTTPCallOutNdLog('<SF_MESSAGE_ID>NO_MAPPING</SF_MESSAGE_ID>',quote.id,quote.id,accLst.Id,null,'Account');
        Test.stopTest();
    }
}