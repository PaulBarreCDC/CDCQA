@isTest
public class RegenerationHolderTest {
	
    @testSetup
    public static void dataSetup() {
                
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        quoteLine.Line_Status__c = 'Primary';
        update quoteLine;
        
        SBQQ__Quote__c quote  = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :quoteLine.SBQQ__Quote__c];
        quote.SBQQ__Status__c = 'Pending';
        update quote;
    }
    
    @isTest
    public static void testHolderRegeneration() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Holders__c hld  = [SELECT Id, Finish_Configuration__c FROM Holders__c LIMIT 1];
        hld.Finish_Configuration__c = true;
        update hld;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('HLD', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'Holders';
        rrd.Product_Code__c = 'HLD';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        quoteLines.add(quoteLine);
        System.enqueueJob(new MassConfiguratorFutureEvnts(quoteLines));
                
        QuoteLine_Mass_Update__c rec = new QuoteLine_Mass_Update__c();
        rec.Delete_Record__c = true;
        rec.Batch_Job_ID__c = 'Test1';
        rec.Batch_Job_Details__c = 'Test';
        insert rec;
        
        Regeneration_Request_Details__c rec1 = new Regeneration_Request_Details__c();
        rec1.Batch_Job_ID__c = 'Test1';
        insert rec1;
        
        QLMassUpdate.deleteMassQLRecords(null);
        
        List<SBQQ__QuoteLine__c> quoteLines2 = [SELECT Id FROM SBQQ__QuoteLine__c ORDER BY Id DESC LIMIT 1];
		ConfigHolderUtilityBatch.updateQuoteLineDesc(JSON.serialize(quoteLines2));

        
        
        Test.stopTest();
    }
}