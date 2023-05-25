@isTest
public class RegenerationPartSelectorTest {
	
    @testSetup
    public static void dataSetup() {
                
        Map<String, String> mapWithPSValues = new Map<String, String>();
        mapWithPSValues.put('BRAND','Groth');
        mapWithPSValues.put('PRODUCT_CODE','PS');
        mapWithPSValues.put('PRODUCT_NAME','Partselecter');
        
        TestConfigurePrartSelectorUtility.mapWithPSValues=mapWithPSValues;
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithPSValues);
        
        TestConfigurePrartSelectorUtility.quoteLine= quoteLine;
        TestConfigurePrartSelectorUtility.createPSTestRecords();
        Part_Selector__c psSelctor = TestConfigurePrartSelectorUtility.psSelctor;
        TestConfigurePrartSelectorUtility.createPSTestRecordsbluk();
        
        quoteLine.Line_Status__c = 'Primary';
        update quoteLine;
        
        SBQQ__Quote__c quote  = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :quoteLine.SBQQ__Quote__c];
        quote.SBQQ__Status__c = 'Pending';
        update quote;
    }
    
    @isTest
    public static void testPSRegeneration() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Part_Selector__c psDet  = [SELECT Id, Finish_Configuration_Flag__c FROM Part_Selector__c LIMIT 1];
        psDet.Finish_Configuration_Flag__c = true;
        update psDet;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('PS', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'Part Selector';
        rrd.Product_Code__c = 'PS';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
    
    @isTest
    public static void testPSRegeneration2() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Part_Selector__c psDet  = [SELECT Id, Finish_Configuration_Flag__c, Quote_Description_Engineer_Override__c FROM Part_Selector__c LIMIT 1];
        psDet.Finish_Configuration_Flag__c = true;
        psDet.Quote_Description_Engineer_Override__c = true;
        update psDet;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('PS', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'Part Selector';
        rrd.Product_Code__c = 'PS';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
}