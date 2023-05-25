@isTest
public class ReorderDriverTest {
    
    //@isTest
    public static ConfigureWasteGasBurner getConfigWGBCntrl() {
                 
        Map<String, String> mapWithWGBValues = new Map<String, String>();
        mapWithWGBValues.put('BRAND','Groth');
        mapWithWGBValues.put('PRODUCT_CODE','WGB');
        mapWithWGBValues.put('PRODUCT_NAME','WasteGasBurner');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithWGBValues);
        
        TestDataWGBUtility.quoteLine = quoteLine;
        TestDataWGBUtility.mapWithWGBValues = mapWithWGBValues;
        
        system.debug('TestDataWGBUtility.quoteLine:'+TestDataWGBUtility.quoteLine);
        system.debug('TestDataWGBUtility.mapWithWGBValues:'+TestDataWGBUtility.mapWithWGBValues);
        TestDataWGBUtility.createWGBTestRecords();
        TestDataWGBUtility.createWGBMasterTestRecords();
        
        PageReference pager = Page.ConfigWGBProduct;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));

        WasteGasBurner__c conWGB = [SELECT Id FROM WasteGasBurner__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new ConfigureWasteGasBurner(sc);
    }
       
    @isTest
    public static void testWGBMethod() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ReorderDriverTest.getConfigWGBCntrl();
        
        ReorderDriver obj1 = new ReorderDriver(configWGB.WGBProd.Id,'WGB',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configWGB.WGBProd.Id,'WGB',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
        ReorderDriver obj3 = new ReorderDriver(configWGB.WGBProd.Id,'WGB',2);
        Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configWGB.WGBProd.Id,'WGB',3);
        Id batchJobId4=System.enqueueJob(obj4); 
        
        Test.stopTest();
    }
    
  // @isTest
    public static configureFLAMEproduct getconfigFACntrl() {
                 
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        system.debug('TestDataFAUtility.quoteLine:'+TestDataFAUtility.quoteLine);
        system.debug('TestDataFAUtility.mapWithFAValues:'+TestDataFAUtility.mapWithFAValues);
        TestDataFAUtility.createFATestRecords();
        TestDataFAUtility.createFAMasterTestRecords();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA = [SELECT Id FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new configureFLAMEproduct(sc);
    }        
  
     @isTest
    public static void testFAMethod() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ReorderDriverTest.getconfigFACntrl();
        
        ReorderDriver obj1 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
        ReorderDriver obj3 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',2);
        Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',3);
        Id batchJobId4=System.enqueueJob(obj4);   
        
        ReorderDriver obj5 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',4);
        Id batchJobId5=System.enqueueJob(obj5);        
        
        ReorderDriver obj6 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',5);
        Id batchJobId6=System.enqueueJob(obj6); 
        
        ReorderDriver obj7 = new ReorderDriver(configFA.flmProd.id,'FlameProducts',6);
        Id batchJobId7=System.enqueueJob(obj7); 
        
        Test.stopTest();
    }
    
    
    // BGR Methods
    public static configureBGRProduct getConfigBGRCntrl() 
		 {
        
			Map<String, String> mapWithBGRValues = new Map<String, String>();
			mapWithBGRValues.put('BRAND','Groth');
			mapWithBGRValues.put('PRODUCT_CODE','BGR');
			mapWithBGRValues.put('PRODUCT_NAME','BlanketGasRegulator'); 
			
			SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithBGRValues);       
			TestDataBGRUtility.quoteLine = quoteLine;
			TestDataBGRUtility.mapWithBGRValues = mapWithBGRValues;       
			TestDataBGRUtility.createBGRTestRecords();
			TestDataBGRUtility.createBGRMasterTestRecords(); 
			
			PageReference pager = Page.ConfigBGR;
			Test.setCurrentPage(pager);

			ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));

			BGR__c conBGR = [SELECT Id FROM BGR__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];

			ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);

			return new configureBGRProduct(sc);		
		}
    
    
        @isTest
        public static void TestBGRMethod() {
            
            Test.startTest();
            configureBGRProduct configBGR = ReorderDriverTest.getConfigBGRCntrl();
        
            ReorderDriver obj1 = new ReorderDriver(configBGR.conBGR.id,'BGR',0);
            Id batchJobId1=System.enqueueJob(obj1);        
            
            ReorderDriver obj2 = new ReorderDriver(configBGR.conBGR.id,'BGR',1);
            Id batchJobId2=System.enqueueJob(obj2); 
            
            ReorderDriver obj3 = new ReorderDriver(configBGR.conBGR.id,'BGR',2);
            Id batchJobId3=System.enqueueJob(obj3); 
            
            ReorderDriver obj4 = new ReorderDriver(configBGR.conBGR.id,'BGR',3);
            Id batchJobId4=System.enqueueJob(obj4);   
            
            ReorderDriver obj5 = new ReorderDriver(configBGR.conBGR.id,'BGR',4);
            Id batchJobId5=System.enqueueJob(obj5);        
            
            ReorderDriver obj6 = new ReorderDriver(configBGR.conBGR.id,'BGR',5);
            Id batchJobId6=System.enqueueJob(obj6);        
            
            Test.stopTest();
        }
    
    
    //Holders Method
    public static ConfigHolderController getConfigHolderCntrl() {
		
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
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
		
		PageReference pager = Page.ConfigHolders;
		Test.setCurrentPage(pager);
		
		//List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
		
		ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));

        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
		
		return new ConfigHolderController(sc);
    }
    
    @isTest
    public static void testHolderMethod() {
    
    	Test.startTest();
    
    	ConfigHolderController configHld = ReorderDriverTest.getConfigHolderCntrl();
    
    	ReorderDriver obj1 = new ReorderDriver(configHld.conHolder.id,'HLD',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configHld.conHolder.id,'HLD',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
      //  ReorderDriver obj3 = new ReorderDriver(configHld.conHolder.id,'HLD',2);
      //  Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configHld.conHolder.id,'HLD',3);
        Id batchJobId4=System.enqueueJob(obj4);   
        
        ReorderDriver obj5 = new ReorderDriver(configHld.conHolder.id,'HLD',4);
        Id batchJobId5=System.enqueueJob(obj5);
    
    	Test.stopTest();
    }
    
    /*
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
    }
    
    public static configureBGRProduct getConfigBGRCntrl() {
        
        List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        TestDataBGRUtility.quoteLine = quoteLine[0];
        BGR__c conBGR = [SELECT Id FROM BGR__c LIMIT 1];

        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine[0].Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(TestDataUtility.quoteLine);
        new configureBGRProduct(sc);
        
        return new configureBGRProduct(TestDataBGRUtility.quoteLine.Id);
    }
    
    @isTest
    public static void TestBGRMethod() {
        
        Test.startTest();
        configureBGRProduct configBGR = ReorderDriverTest.getConfigBGRCntrl();
    
		ReorderDriver obj1 = new ReorderDriver(configBGR.conBGR.id,'BGR',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configBGR.conBGR.id,'BGR',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
        ReorderDriver obj3 = new ReorderDriver(configBGR.conBGR.id,'BGR',2);
        Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configBGR.conBGR.id,'BGR',3);
        Id batchJobId4=System.enqueueJob(obj4);   
        
        ReorderDriver obj5 = new ReorderDriver(configBGR.conBGR.id,'BGR',4);
        Id batchJobId5=System.enqueueJob(obj5);        
        
        ReorderDriver obj6 = new ReorderDriver(configBGR.conBGR.id,'BGR',5);
        Id batchJobId6=System.enqueueJob(obj6);        
        
        Test.stopTest();
    }
    */
  /*  public static configureRVproduct getconfigRVCntrl() {
        
		Map<String, String> mapWithRVValues = new Map<String, String>();
        mapWithRVValues.put('BRAND','Groth');
        mapWithRVValues.put('PRODUCT_CODE','RLFVLV');
        mapWithRVValues.put('PRODUCT_NAME','ReliefValves');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRVValues);
        
        TestDataRVUtility.quoteLine = quoteLine;
        TestDataRVUtility.mapWithRVValues = mapWithRVValues;

        TestDataRVUtility.createRVTestRecords();
        TestDataRVUtility.createRVMasterTestRecords();  
		
        PageReference pager = Page.RVConfig;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        return new configureRVproduct(sc);
    }

	@isTest
    public static void TestRVMethod() {
        
        Test.startTest();
        
        configureRVproduct configRV = ReorderDriverTest.getconfigRVCntrl();
        
        ReorderDriver obj1 = new ReorderDriver(configRV.conRV.id,'RLFVLV',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configRV.conRV.id,'RLFVLV',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
        ReorderDriver obj3 = new ReorderDriver(configRV.conRV.id,'RLFVLV',2);
        Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configRV.conRV.id,'RLFVLV',3);
        Id batchJobId4=System.enqueueJob(obj4);   
        
        ReorderDriver obj5 = new ReorderDriver(configRV.conRV.id,'RLFVLV',4);
        Id batchJobId5=System.enqueueJob(obj5);        
        
        ReorderDriver obj6 = new ReorderDriver(configRV.conRV.id,'RLFVLV',5);
        Id batchJobId6=System.enqueueJob(obj6);
        
        ReorderDriver obj7 = new ReorderDriver(configRV.conRV.id,'RLFVLV',6);
        Id batchJobId7=System.enqueueJob(obj7); 
        
        ReorderDriver obj8 = new ReorderDriver(configRV.conRV.id,'RLFVLV',7);
        Id batchJobId8=System.enqueueJob(obj8); 
        
        Test.stopTest();
    }*/

    /*
	public static Holders__c Holder;
    public static Map<String, String> mapWithHolderValues = new Map<String, String>();
    
    @isTest
    public static void configValues() {
    
    mapWithHolderValues.put('BOLTING_CLASS', 'A3');
    mapWithHolderValues.put('BRAND','CDC');
    mapWithHolderValues.put('PRODUCT_CODE','HLD');
    mapWithHolderValues.put('PRODUCT_NAME','Holder');
    mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
    mapWithHolderValues.put('INLET_MATERIAL','002');
    mapWithHolderValues.put('OUTLET_MATERIAL','002');
    mapWithHolderValues.put('SIZE','1/2" (13mm)');
    mapWithHolderValues.put('SIZE_UNITS', 'US Units');
    }
    
    @testSetup
    public static void dataSetup() {
    
    ReorderDriverTest.configValues();
    
    system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
    TestDataUtility.createHoldersTestRecords();
    TestDataUtility.createHoldersMasterTestRecords();
    }
    
    public static ConfigHolderController getConfigHolderCntrl() {
    
    PageReference pager = Page.ConfigHolders;
    Test.setCurrentPage(pager);
    
    List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
    
    ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine[0].Id));
    
    Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :quoteLine[0].Id LIMIT 1];
    system.debug('conHolder:'+conHolder);
    
    System.debug('quoteId...'+quoteLine[0].Id);
    ApexPages.StandardController sc = new ApexPages.StandardController(TestDataUtility.quoteLine);
    
    return new ConfigHolderController(sc);
    }
    
    @isTest
    public static void testHolderMethod() {
    
    	Test.startTest();
    
    	ConfigHolderController configHld = ReorderDriverTest.getConfigHolderCntrl();
    
    	ReorderDriver obj1 = new ReorderDriver(configHld.conHolder.id,'HLD',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configHld.conHolder.id,'HLD',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
        ReorderDriver obj3 = new ReorderDriver(configHld.conHolder.id,'HLD',2);
        Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configHld.conHolder.id,'HLD',3);
        Id batchJobId4=System.enqueueJob(obj4);   
        
        ReorderDriver obj5 = new ReorderDriver(configHld.conHolder.id,'HLD',4);
        Id batchJobId5=System.enqueueJob(obj5);
    
    	Test.stopTest();
    } */
        
    
    	public static ConfigureRD getConfigRDCntrl() {
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;
        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDTestRecords1();
        TestDataRDUtility.createRDMasterTestRecords();

        PageReference pager = Page.ConfigRD;
        Test.setCurrentPage(pager);

        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
      //  TestDataRDUtility.createRDTestRecSecAandEwithHPZ();
        Rupture_Disc__c conProd = [SELECT Id FROM Rupture_Disc__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];

        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);

        return new ConfigureRD(sc);
    }

    @isTest
    public static void testPressureRating() {
        
		Test.startTest();
        
       	ConfigureRD configRD = ReorderDriverTest.getConfigRDCntrl();
        ReorderDriver obj1 = new ReorderDriver(configRD.conProd.id,'DISC',0);
        Id batchJobId1=System.enqueueJob(obj1);        
        
        ReorderDriver obj2 = new ReorderDriver(configRD.conProd.id,'DISC',1);
        Id batchJobId2=System.enqueueJob(obj2); 
        
        ReorderDriver obj3 = new ReorderDriver(configRD.conProd.id,'DISC',2);
        Id batchJobId3=System.enqueueJob(obj3); 
        
        ReorderDriver obj4 = new ReorderDriver(configRD.conProd.id,'DISC',3);
        Id batchJobId4=System.enqueueJob(obj4);   
        
        ReorderDriver obj5 = new ReorderDriver(configRD.conProd.id,'DISC',4);
        Id batchJobId5=System.enqueueJob(obj5);        
        
        ReorderDriver obj6 = new ReorderDriver(configRD.conProd.id,'DISC',5);
        Id batchJobId6=System.enqueueJob(obj6);
        
        ReorderDriver obj7 = new ReorderDriver(configRD.conProd.id,'DISC',6);
        Id batchJobId7=System.enqueueJob(obj7); 
        
        ReorderDriver obj8 = new ReorderDriver(configRD.conProd.id,'DISC',7);
        Id batchJobId8=System.enqueueJob(obj8);
   
        Test.stopTest();
    }
    
}