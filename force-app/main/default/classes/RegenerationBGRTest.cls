@isTest
public class RegenerationBGRTest {
	
    @testSetup
    public static void dataSetup() {
                
        Map<String, String> mapWithBGRValues = new Map<String, String>();
        mapWithBGRValues.put('BRAND','Groth');
        mapWithBGRValues.put('PRODUCT_CODE','BGR');
        mapWithBGRValues.put('PRODUCT_NAME','BlanketGasRegulator'); 
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithBGRValues);       
        TestDataBGRUtility.quoteLine = quoteLine;
        TestDataBGRUtility.mapWithBGRValues = mapWithBGRValues;       
        TestDataBGRUtility.createBGRTestRecords();
        TestDataBGRUtility.createBGRMasterTestRecords();       

		BGR__c conBGR = [SELECT Id, Quote_Line__c FROM BGR__c LIMIT 1];
        conBGR.Quote_Line__c = quoteLine.Id;
        conBGR.Quantity__c = 1;
        conBGR.Supply_Gas_Temperature_Units__c = 'Deg R';
        conBGR.Minimum_Required_Flow_Capacity__c = 5.0;
        conBGR.Flow_Units__c = 'kg/min';
		update conBGR;
        
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
        
        BGR__c rec  = [SELECT Id, Configuration_Complete__c FROM BGR__c LIMIT 1];
        rec.Configuration_Complete__c = true;
        update rec;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('BGR', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'BGR';
        rrd.Product_Code__c = 'BGR';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderRegeneration2() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        BGR__c rec  = [SELECT Id, Configuration_Complete__c FROM BGR__c LIMIT 1];
        rec.Configuration_Complete__c = true;
        REC.Quote_Description_Engineer_Override__c = true;
        update rec;
        
        BGR_Outputs__c recOutput = [SELECT Id, OA_Override__c, OB_Override__c, OW_Override__c FROM BGR_Outputs__c LIMIT 1];
        recOutput.OA_Override__c = 'Test';
        recOutput.OB_Override__c = 'Test';
        recOutput.OW_Override__c = 'Test';
        update recOutput;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('BGR', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'BGR';
        rrd.Product_Code__c = 'BGR';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
}