@isTest
public class RegenerationRDTest {
	
    @testSetup
    public static void dataSetup() {
                
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;        

        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();
        
        //TestDataRDUtility.createRDTestRecords1();
        TestDataRDUtility.createRDTestRecordWithOutput();
        
        TestDataHolderUtility.quoteLine = quoteLine;
        quoteLine.Line_Status__c = 'Primary';
        update quoteLine;
        
        SBQQ__Quote__c quote  = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :quoteLine.SBQQ__Quote__c];
        quote.SBQQ__Status__c = 'Pending';
        update quote;
    }
    
    @isTest
    public static void testRDRegeneration() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        List<Rupture_Disc__c> rdDets  = [SELECT Id, Finish_Configuration_Flag__c, Quote_Descriptions_Override__c FROM Rupture_Disc__c LIMIT 1];
        system.debug('rdDet:'+rdDets);
        Rupture_Disc__c rdDet = rdDets[0];
        
        rdDet.Finish_Configuration_Flag__c = true;
        update rdDet;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('RD', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'Rupture Disc';
        rrd.Product_Code__c = 'RD';
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
    
    @isTest
    public static void testRDRegeneration2() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        List<Rupture_Disc__c> rdDets  = [SELECT Id, Finish_Configuration_Flag__c, Quote_Descriptions_Override__c FROM Rupture_Disc__c LIMIT 1];
        system.debug('rdDet:'+rdDets);
        Rupture_Disc__c rdDet = rdDets[0];
        
        rdDet.Quote_Descriptions_Override__c = true;
        rdDet.Finish_Configuration_Flag__c = true;
        update rdDet;
        
        List<RD_Outputs__c> rdOutputs = [SELECT Id, ORV__c, ORP__c, ORP_Override__c, ORV_Override__c, OA__c, OB__c, OW__c, OA_Override__c, OB_Override__c, OW_Override__c FROM RD_Outputs__c LIMIT 1];
		RD_Outputs__c outputs = rdOutputs[0];
        outputs.OA_Override__c = 'Test';
        outputs.OB_Override__c = 'Test';
        outputs.ORP_Override__c = 'Test';
        outputs.ORV_Override__c = 'Test';
        outputs.OW_Override__c = 'Test';
        
		outputs.OA__c = 'Test';
        outputs.OB__c = 'Test';
        outputs.ORP__c = 'Test';
        outputs.ORV__c = 'Test';
        outputs.OW__c = 'Test';        
        update outputs;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('RD', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'Rupture Disc';
        rrd.Product_Code__c = 'RD';
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