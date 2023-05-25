@isTest 
private class IFSOperationsTest{
    @testSetup static void setup() {
       IFS_TestDataFactory.createTestRecords();        
    }
    
    static testMethod void syncCustomer(){
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.getAccountId(quote.Id);   
        IFSOperations.syncCustomer(null,quote.Id);
        Test.stopTest();
    }
    
    static testMethod void generateAndSyncParts() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.generateAndSyncParts(quote.Id);
        Test.stopTest();
    }
    
    static testMethod void generateAndSyncPartsAndOrder() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.generateAndSyncPartsAndOrder(quote.Id);
        Test.stopTest();
    }
    
     static testMethod void syncOrderValidation() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.syncOrderValidation(quote.Id);
        Test.stopTest();
    }    
    
    static testMethod void cancelOrderCancel() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.cancelOrder(null,quote.Id);
        Test.stopTest();
    }
       
    
    static testMethod void cancelOrderApprovedStatus(){      
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name=:'TEMCO INC TEST2']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.cancelOrder(accLst[0].Id,quote.Id);
        Test.stopTest();
    }
    
     /*static testMethod void getAccountId() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.getAccountId(quote.Id);
        Test.stopTest();
    }*/
    
    static testMethod void createCreditsAndBooking() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        List<Account> lstaccPartner = [Select Id,Name FROM Account WHERE Name='TEMCO INC PARTNER'];
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        date dtCloseDate =system.today();
        Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
        oGoalsPerformance.Partner_Org__c = lstaccPartner[0].Id;
        oGoalsPerformance.Brands__c = 'LaMot';
        oGoalsPerformance.Fiscal_Year__c = string.valueOf(dtCloseDate.Year());
        oGoalsPerformance.Fiscal_Month__c = string.valueOf(dtCloseDate.Month());
        oGoalsPerformance.Goal__c=4900;
        insert oGoalsPerformance;
        IFSOperations.createCreditsAndBooking(quote.Id);
        Test.stopTest();
    }
    
    static testMethod void syncCustomerClassic() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.syncCustomerClassic(accLst[0].Id,quote.Id);
        Test.stopTest();
    }
    
    static testMethod void syncPartsClassic() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        
        BGR_Attribute_lookup_Details__c oBGRAttribute = new BGR_Attribute_lookup_Details__c();
        oBGRAttribute.Name='bga001';
        oBGRAttribute.Attribute__c='RGEUNT';
        oBGRAttribute.Text__c='psig';
        oBGRAttribute.Numval1__c = 0;
        oBGRAttribute.Numval2__c = 20;
        insert oBGRAttribute;
        
        IFSOperations.syncPartsClassic(accLst[0].Id,quote.Id);
        Test.stopTest();
    }
    
    static testMethod void syncOrderClassic() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.syncOrderClassic(accLst[0].Id,quote.Id);
        IFSOperations.cancelOrderClassic(accLst[0].Id,quote.Id);
        Test.stopTest();
    }
    
    /*static testMethod void cancelOrderClassic() {
        Test.startTest();        
        List<Account> accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST']; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst[0].Id limit 1];
        IFSOperations.cancelOrderClassic(accLst[0].Id,quote.Id);
        Test.stopTest();
    }*/
    
    
}