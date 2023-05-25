@isTest
public class RegenerationFlameProductsTest {

    @testSetup
    public static void dataSetup() {
                
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        TestDataFAUtility.createFATestRecords2();
        TestDataFAUtility.createFAMasterTestRecords2();
        
        quoteLine.Line_Status__c = 'Primary';
        update quoteLine;
        
        SBQQ__Quote__c quote  = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :quoteLine.SBQQ__Quote__c];
        quote.SBQQ__Status__c = 'Pending';
        update quote;
    }
    
    @isTest
    public static void testRegeneration() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Flame_Product__c rec  = [SELECT Id, IsConfig__c FROM Flame_Product__c LIMIT 1];
        rec.IsConfig__c = true;
        update rec;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('FlameProducts', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'FlameProducts';
        rrd.Product_Code__c = 'FlameProducts';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
    
    @isTest
    public static void testRegeneration2() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Flame_Product__c rec  = [SELECT Id, IsConfig__c FROM Flame_Product__c LIMIT 1];
        rec.IsConfig__c = true;
        rec.Quote_Description_Engineer_Override__c = true;
        update rec;
        
        FA_Output__c recOutput = [SELECT Id, OA_Override__c, OB_Override__c, OW_Override__c, PC_Override__c FROM FA_Output__c LIMIT 1];
        recOutput.OA_Override__c = 'Test';
        recOutput.OB_Override__c = 'Test';
        recOutput.OW_Override__c = 'Test';
        recOutput.PC_Override__c = 'Test';
        update recOutput;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('FlameProducts', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'FlameProducts';
        rrd.Product_Code__c = 'FlameProducts';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
}