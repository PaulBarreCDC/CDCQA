@isTest
public class SyncConfiguratorDataTest {
	
    @isTest
    public static void testRunRulesForConfigDataForRLFVLV() {
        
            Test.startTest();
            Map<String, String> mapWithFAValues = new Map<String, String>();
            mapWithFAValues.put('BRAND','Groth');
            //mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
            mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
            
            SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
            
            TestDataFAUtility.quoteLine = quoteLine;
            TestDataFAUtility.mapWithFAValues = mapWithFAValues;
            
            TestDataRVUtility.createRVTestRecords();
            TestDataRVUtility.createRVMasterTestRecords();
            SyncConfiguratorData.RVLeadTimeList = new list<SyncConfiguratorData.LeadTimeWrapper>();
            List<Relief_Valve__c> rec = [SELECT Id FROM Relief_Valve__c LIMIT 1];        
            GlobalLeadTime__c gtc = new GlobalLeadTime__c();
            gtc.Schedule__c ='AssemblyLocation';
            gtc.QtyLL__c = 0;
            gtc.QtyUL__c = 9999;
            gtc.X10__c = 100;
            gtc.X20__c = 100;
            gtc.X30__c = 100;
            gtc.X40__c = 100;
            insert gtc;			
        
            Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
            gtc = new GlobalLeadTime__c();
            gtc.Schedule__c ='QTNDE1';
            gtc.QtyLL__c = 0;
            gtc.QtyUL__c = 9999;
            gtc.X10__c = 100;
            gtc.X20__c = 100;
            gtc.X30__c = 100;
            gtc.X40__c = 100;
            insert gtc;
            SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
		Test.stopTest();
           
        
    }
    
    @isTest
    public static void testRunRulesForConfigDataForRLFVLV2() {
        
        Test.startTest();
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth'); 
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        TestDataRVUtility.createRVTestRecords();
        TestDataRVUtility.createRVMasterTestRecords();

        Relief_Valve__c rv = [SELECT Id, Quote_Line__c, Size__c, Lead_Time_Override__c, Price_Engineer_Override__c, Build_Cost_Override__c, Discountable_Price__c, Non_Discountable_Price__c, Quantity__c, PosSetPresOSIG__c, VacSetPresOSIG__c FROM Relief_Valve__c LIMIT 1];
        rv.Quote_Line__c = quoteLine.Id;
        rv.Size__c = '04';
        rv.Lead_Time_Override__c = true;
        rv.Price_Engineer_Override__c = true;
        rv.Build_Cost_Override__c = true;
        rv.Discountable_Price__c = 100;
        rv.Non_Discountable_Price__c = 100;
        rv.Quantity__c = 1;
        rv.PosSetPresOSIG__c = 10;
        rv.VacSetPresOSIG__c = 10;
        update rv;
        
        Result res = SyncConfiguratorData.runRulesForConfigData(rv.Id);
        Test.stopTest();
    }
    
    public static void flameProdDataSetup() {
        
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        TestDataFAUtility.createFATestRecords();
        TestDataFAUtility.createFAMasterTestRecords();
        
        List<Flame_Product__c> rec = [SELECT Id FROM Flame_Product__c LIMIT 1];
        FA_Lead_Time_Details__c leadTime = new FA_Lead_Time_Details__c();
        leadTime.Lead_Time_Item__c = 'MaterialSourceRestrictions';
        leadTime.RunTimeSchedule__c = '2';
        leadTime.QueueTimeSchedule__c = '3';
        leadTime.text1val__c = '00';
        insert leadTime;        
    }
    
    @isTest
    public static void testComputeTotal() {
        
        Test.startTest();
        SyncConfiguratorData.computeTotal(100, 50);
        SyncConfiguratorData.computeTotal(100, 7777);
        
        Map<string,string> res = SyncConfiguratorData.mapBGROutputElements;
        
        SyncConfiguratorData.RVLeadTimeList = null;
        SyncConfiguratorData.RVPriceWrapperList = null;
        SyncConfiguratorData.FALeadTimeList = null;
        Test.stopTest();
    }
    
    @isTest
    public static void testRunRulesForConfigDataForHolders() {
        
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
        
        TestDataHolderUtility.createHoldersTestRecords();
        Holders__c conHolder = TestDataHolderUtility.conHolder;
        
        List<Holder_Outputs__c> holderOutputList = Test.loadData(Holder_Outputs__c.sObjectType, 'Holder_Outputs_MasterData');
        List<Holder_Outputs__c> holderOutputList1 = new List<Holder_Outputs__c>();
        
        for(Holder_Outputs__c holderOutput: holderOutputList){
            holderOutput.ReferenceId__c = conHolder.Id;
            holderOutputList1.add(holderOutput);
        }
        update holderOutputList1;
        
        Test.startTest(); 
        List<Holders__c> holders = [SELECT Id FROM Holders__c LIMIT 1];
        Result res = SyncConfiguratorData.runRulesForConfigData(holders[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testRunRulesForConfigDataForFlameProducts() {
        
        SyncConfiguratorDataTest.flameProdDataSetup();
        
        Test.startTest();
        List<Flame_Product__c> rec = [SELECT Id FROM Flame_Product__c LIMIT 1];
        rec[0].Lead_Time_Override__c = true;
        rec[0].Price_Engineer_Override__c = true;
        rec[0].Build_Cost_Override__c = true;
        rec[0].Discountable_Price__c = 100;
        rec[0].Non_Discountable_Price__c = 100;
        update rec[0];
        
        Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
        
        Test.stopTest();
    } 
    
    @isTest
    public static void testRunRulesForConfigDataForFlameProducts2() {
        
        SyncConfiguratorDataTest.flameProdDataSetup();
        
        Test.startTest();
        List<Flame_Product__c> rec = [SELECT Id FROM Flame_Product__c LIMIT 1];
        
        rec[0].Lead_Time_Override__c = false;
        rec[0].Price_Engineer_Override__c = false;
        rec[0].Build_Cost_Override__c = false;
        rec[0].Discountable_Price__c = 100;
        rec[0].Non_Discountable_Price__c = 100;
        update rec[0];
        
        Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
        
        Test.stopTest();
    } 
    
    @isTest
    public static void testRunRulesForConfigDataForFlameProducts3() {
        
        SyncConfiguratorDataTest.flameProdDataSetup();
        
        Test.startTest();
        List<Flame_Product__c> rec = [SELECT Id FROM Flame_Product__c LIMIT 1];
        
        rec[0].Lead_Time_Override__c = true;
        rec[0].Price_Engineer_Override__c = true;
        rec[0].Build_Cost_Override__c = true;
        rec[0].Discountable_Price__c = 100;
        rec[0].Non_Discountable_Price__c = 100;
        update rec[0];
        
        List<FA_Lead_Time_Details__c> leadTimeData = [SELECT Id FROM FA_Lead_Time_Details__c];
        if(leadTimeData.size() > 0) {
            
            delete leadTimeData;
        }
        
        Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
        
        Test.stopTest();
    } 
    
    @isTest
    public static void testRunRulesForConfigDataForWGB() {
        
        Map<String, String> mapWithConfiguratorValues = new Map<String, String>();
        mapWithConfiguratorValues.put('BRAND','Groth');
        mapWithConfiguratorValues.put('PRODUCT_CODE','WGB');
        mapWithConfiguratorValues.put('PRODUCT_NAME','WasteGasBurner');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithConfiguratorValues);
        
        TestDataWGBUtility.createWGBTestRecords();
        WasteGasBurner__c conWGB = TestDataWGBUtility.conWGB;
        TestDataWGBUtility.createWGBMasterTestRecords();
        
        Test.startTest();
        List<WasteGasBurner__c> rec = [SELECT Id FROM WasteGasBurner__c LIMIT 1];
        Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
        Test.stopTest();
    }    
    
    @isTest
    public static void testRunRulesForConfigDataForRD() {
        
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        
		SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);        
        
        TestDataRDUtility.quoteLine = quoteLine;
        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();
        
        TestDataRDUtility.createRDTestRecordWithOutput();
        
        Test.startTest();
        
        List<Rupture_Disc__c> rec = [SELECT Id FROM Rupture_Disc__c LIMIT 1];
        
        try {
        	Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
        } catch(Exception e) {}
        
        Test.stopTest();
    }     
        
    @isTest
    public static void testRunRulesForConfigDataForBGR() {
                
        Test.startTest();
        TestDataBGRUtility.createBGRTestRecords();
        TestDataBGRUtility.createBGRTestRecordss();
        TestDataBGRUtility.createBGRMasterTestRecords();
        List<BGR_lead_time__c> recs = [SELECT Id, Schedule__c, QtyLL__c, QtyUL__c FROM BGR_lead_time__c];
        recs[0].Schedule__c = 'BGRA';
        recs[0].QtyLL__c = -1;
        recs[0].QtyUL__c = 1;
        update recs[0];
        
        recs[1].Schedule__c = 'BGREST';
        recs[1].QtyLL__c = -1;
        recs[1].QtyUL__c = 1;
        update recs[1];
        
        List<BGR__c> wgb = [SELECT Id FROM BGR__c LIMIT 1];
        wgb[0].Schedule__c = 'BGRA';
        wgb[0].Schedule_2__c = 'BGREST';
        wgb[0].Discountable_Price__c = 100;
        wgb[0].Non_Discountable_Price__c = 100;
        wgb[0].Quantity__c = 1;
        update wgb;
        system.debug('wgb:'+wgb);
        
        Test.loadData(BGR_Attribute_lookup_Translation__c.sObjectType, 'BGR_Attribute_lookup_Translation_Data');
        Test.loadData(BGR_Attribute_lookup_Details__c.sObjectType, 'BGR_Attribute_lookup_Details_Data');
        
        Result res = SyncConfiguratorData.runRulesForConfigData(wgb[0].Id);
        Test.stopTest();
    }
        
    @isTest
    public static void testRunRulesForConfigDataForBGR2() {
        Test.startTest();  
        TestDataBGRUtility.createBGRTestRecords();
        TestDataBGRUtility.createBGRTestRecordss();
        TestDataBGRUtility.createBGRMasterTestRecords();
        List<BGR_lead_time__c> recs = [SELECT Id, Schedule__c, QtyLL__c, QtyUL__c FROM BGR_lead_time__c];
        recs[0].Schedule__c = 'BGRA';
        recs[0].QtyLL__c = -1;
        recs[0].QtyUL__c = 1;
        update recs[0];
        
        recs[1].Schedule__c = 'BGREST';
        recs[1].QtyLL__c = -1;
        recs[1].QtyUL__c = 1;
        update recs[1];
        
        List<BGR__c> wgb = [SELECT Id FROM BGR__c LIMIT 1];
        wgb[0].Schedule__c = 'BGRA';
        wgb[0].Schedule_2__c = 'BGREST';
        wgb[0].Lead_Time_Engineer_Override__c = true;
        wgb[0].Price_Engineer_Override__c = true;
        wgb[0].Discountable_Price__c = 100;
        wgb[0].Non_Discountable_Price__c = 100;
        wgb[0].Quantity__c = 1;
        update wgb;
        system.debug('wgb:'+wgb);
        
        Cost__c cst = new Cost__c();
        cst.Cost_Method__c = 'Test';
        cst.Part_Number__c = '100000';
        cst.Inside_Cost_10__c = '10';
        cst.Outside_Cost_10__c = '10';
        cst.Inside_Cost_20__c = '20';
        cst.Outside_Cost_30__c = '30';
        cst.Inside_Cost_30__c = '30';
        cst.Outside_Cost_20__c = '20';
        cst.Ref_Id__c = wgb[0].Id;
        cst.Product__c='BGR';
        cst.Cost_Method__c = 'Overriden';
        insert cst;
        
        Result res = SyncConfiguratorData.runRulesForConfigData(wgb[0].Id);
        Test.stopTest();
    }
    
     @isTest
    public static void testRunRulesForConfigDataForRLFVLV3() {
        
            Test.startTest();
            Map<String, String> mapWithFAValues = new Map<String, String>();
            mapWithFAValues.put('BRAND','Groth');
            //mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
            mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
            
            SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
            
            TestDataFAUtility.quoteLine = quoteLine;
            TestDataFAUtility.mapWithFAValues = mapWithFAValues;
            
            TestDataRVUtility.createRVTestRecords();
            TestDataRVUtility.createRVMasterTestRecords();
            SyncConfiguratorData.RVLeadTimeList = new list<SyncConfiguratorData.LeadTimeWrapper>();
            List<Relief_Valve__c> rec = [SELECT Id FROM Relief_Valve__c LIMIT 1]; 
        	
        	RV_Valve_Price_Details__c rs= new RV_Valve_Price_Details__c();
        	rs.Pricing_Element__c='WeightPressure';
        	insert rs;
            GlobalLeadTime__c gtc = new GlobalLeadTime__c();
            //gtc.Schedule__c ='AssemblyLocation';
            gtc.QtyLL__c = 0;
            gtc.QtyUL__c = 9999;
            gtc.X10__c = 100;
            gtc.X20__c = 100;
            gtc.X30__c = 100;
            gtc.X40__c = 100;
            insert gtc;			
        
            Result res = SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
            gtc = new GlobalLeadTime__c();
            //gtc.Schedule__c ='QTNDE1';
            gtc.QtyLL__c = 0;
            gtc.QtyUL__c = 9999;
            gtc.X10__c = 100;
            gtc.X20__c = 100;
            gtc.X30__c = 100;
            gtc.X40__c = 100;
            insert gtc;
            SyncConfiguratorData.runRulesForConfigData(rec[0].Id);
		Test.stopTest();
           
        
    }
    
}