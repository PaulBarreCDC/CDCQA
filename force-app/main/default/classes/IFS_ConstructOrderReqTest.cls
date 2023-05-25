@isTest
private class IFS_ConstructOrderReqTest{            
   static testMethod void generateReq(){
        
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1]; 
        SBQQ__QuoteLine__c oQuoteLine;
        for(SBQQ__QuoteLine__c oTempQuoteLine:[Select Id From SBQQ__QuoteLine__c limit 1]){
            oQuoteLine = oTempQuoteLine;
        }
        Test.startTest();
        if(oQuoteLine!=null){
            oQuoteLine.Line_Status__c='Blocked';
            update oQuoteLine;
        }
        
        Freight_Information__c oFreightInformation = new Freight_Information__c();
        oFreightInformation.Account__c = accLst.Id;
        oFreightInformation.Account_Number__c = '55555555';
        oFreightInformation.Bill_To__c = 'Receiver';
        oFreightInformation.Entity__c = 'UPS';
        oFreightInformation.Name ='freight info';
        oFreightInformation.Freight_Contact_Email__c ='test@test.com';
        oFreightInformation.Freight_Contact_Phone__c ='555-555-5555';
        insert oFreightInformation;
        
        quote.Freight_Information__c = oFreightInformation.Id;
        quote.Change_Order_Log__c='Charges';
        update quote;
        
        IFS_ConstructOrderReq.generateReq(quote.id);
        Test.stopTest();
    }
    
    static testMethod void generateReq2(){
        
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1]; 
        SBQQ__QuoteLine__c oQuoteLine;
        for(SBQQ__QuoteLine__c oTempQuoteLine:[Select Id From SBQQ__QuoteLine__c limit 1]){
            oQuoteLine = oTempQuoteLine;
        }
        Test.startTest();
        if(oQuoteLine!=null){
            oQuoteLine.Line_Status__c='Blocked';
            update oQuoteLine;
        }
        
        Freight_Information__c oFreightInformation = new Freight_Information__c();
        oFreightInformation.Account__c = accLst.Id;
        oFreightInformation.Account_Number__c = '55555555';
        oFreightInformation.Bill_To__c = 'Receiver';
        oFreightInformation.Entity__c = 'FedEx';
        oFreightInformation.Name ='freight info';
        oFreightInformation.Freight_Contact_Email__c ='test@test.com';
        oFreightInformation.Freight_Contact_Phone__c ='555-555-5555';
        insert oFreightInformation;
        
        quote.Freight_Information__c = oFreightInformation.Id;
        update quote;
        
        IFS_ConstructOrderReq.generateReq(quote.id);
        Test.stopTest();
    }
}