@isTest
private class IFS_ConstructCustReqTest{         
   static testMethod void generateReq(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];
        
        Freight_Information__c oFreightInformation = new Freight_Information__c();
        oFreightInformation.Account__c = accLst.Id;
        oFreightInformation.Account_Number__c = '55555555';
        oFreightInformation.Bill_To__c = 'Receiver';
        oFreightInformation.Entity__c = 'UPS';
        oFreightInformation.Name ='freight info';
        insert oFreightInformation;
        
        quote.Freight_Information__c = oFreightInformation.Id;
        update quote;
        
        IFS_ConstructCustReq.generateReq(accLst.Id,quote.id);
        Test.stopTest();
    }
    static testMethod void generateReq2(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];
        
        Freight_Information__c oFreightInformation = new Freight_Information__c();
        oFreightInformation.Account__c = accLst.Id;
        oFreightInformation.Account_Number__c = '55555555';
        oFreightInformation.Bill_To__c = 'Receiver';
        oFreightInformation.Entity__c = 'FedEx';
        oFreightInformation.Name ='freight info';
        insert oFreightInformation;
        
        quote.Freight_Information__c = oFreightInformation.Id;
        update quote;
        
        IFS_ConstructCustReq.generateReq(accLst.Id,quote.id);
        Test.stopTest();
    }
}