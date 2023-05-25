@isTest
public class RegenerationRVTest {

    @testSetup
    public static void dataSetup() {
                
        Map<String, String> mapWithRVValues = new Map<String, String>();
        mapWithRVValues.put('BRAND','Groth');
        mapWithRVValues.put('PRODUCT_CODE','RLFVLV');
        mapWithRVValues.put('PRODUCT_NAME','ReliefValves');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRVValues);
        
        TestDataRVUtility.quoteLine = quoteLine;
        TestDataRVUtility.mapWithRVValues = mapWithRVValues;
         
        List<Pressure__c> data8 = Test.loadData(Pressure__c.sObjectType, 'TestData_PressureTableRV');
        List<Temparature__c> data9 = Test.loadData(Temparature__c.sObjectType, 'TestData_TemperatureTable');
        List<Distance__c> data4 = Test.loadData(Distance__c.sObjectType, 'TestData_DistanceTable');
      	List<GasFlowRate__c> data10 = Test.loadData(GasFlowRate__c.sObjectType, 'TestData_GasFlowRateTable');
        List<Media_Property__c> MediaPropertyTable = Test.loadData(Media_Property__c.sObjectType, 'MediaPropertyTestData'); 
       
        TestDataRVUtility.createRVTestRecords();
        TestDataRVUtility.createRVMasterTestRecords(); 
        
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
        
        Relief_Valve__c rec  = [SELECT Id, Finish_Configuration_Flag__c FROM Relief_Valve__c LIMIT 1];
        rec.Finish_Configuration_Flag__c = true;
        update rec;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('RLFVLV', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'RLFVLV';
        rrd.Product_Code__c = 'RLFVLV';
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
        
        Relief_Valve__c rec  = [SELECT Id, Finish_Configuration_Flag__c FROM Relief_Valve__c LIMIT 1];
        rec.Finish_Configuration_Flag__c = true;
        rec.Quote_Description_Engineer_Override__c = true;
        update rec;
        
        RV_Outputs__c recOutput = [SELECT Id, OA_Override__c, OB_Override__c, OW_Override__c, PC_Override__c FROM RV_Outputs__c LIMIT 1];
        recOutput.OA_Override__c = 'Test';
        recOutput.OB_Override__c = 'Test';
        recOutput.OW_Override__c = 'Test';
        recOutput.PC_Override__c = 'Test';
        update recOutput;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('RLFVLV', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'RLFVLV';
        rrd.Product_Code__c = 'RLFVLV';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
}