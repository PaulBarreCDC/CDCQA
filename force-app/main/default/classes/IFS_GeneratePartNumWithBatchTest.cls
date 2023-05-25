@isTest(SeeAllData=true)
private class IFS_GeneratePartNumWithBatchTest{          
   static testMethod void generateReq(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];         
        IFS_GeneratePartNumWithBatch  generatePartNum = new IFS_GeneratePartNumWithBatch(quote.Id,accLst.Id,false);
        Database.executeBatch(generatePartNum, 1);
        Test.stopTest();
    }
}