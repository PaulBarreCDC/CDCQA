@isTest
public class ConfigHolderUtilityTest {
	
    @testSetup
    public static void dataSetup() {
        
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
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
    }
    
    @isTest
    public static ConfigHoldersOutputController getConfigHolderCntrl() {
        
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        
        TestDataHolderUtility.quoteLine = quoteLine;
            
        PageReference pager = Page.ConfigHoldersOutputs;
		Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        system.debug('conHolder:'+conHolder);
        
        System.debug('quoteId...'+quoteLine.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new ConfigHoldersOutputController(sc);
    }
    
    @isTest
    public static void testingCodeAttributesMap() {
        
        Test.startTest();        
        
        ConfigHoldersOutputController configHld = ConfigHolderUtilityTest.getConfigHolderCntrl();
        
        Holders__c conHolder = configHld.conHolder;
        ConfigHolderUtility obj = new ConfigHolderUtility(conHolder.Id);
        
        Map<String, Object> holderRequiredParameters = ConfigHolderUtility.holderRequiredParameters();
        
        Map<String, String> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        
        List<Holder_Testing_Details__c> testDetails = [SELECT Id, text1val__c, text2val__c, text3val__c FROM Holder_Testing_Details__c WHERE ( TestCode__c='A'  And text1val__c='N'  )];
        testDetails[0].text1val__c = 'N';
        testDetails[0].text2val__c = 'N';
        testDetails[0].text3val__c = 'CONFIRM';
        update testDetails;
        
        ConfigHolderUtility.testingCodeAttributesMap(holderInputs);
                
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderRequiredParameters() {
        
        Test.startTest();        
        
        ConfigHoldersOutputController configHld = ConfigHolderUtilityTest.getConfigHolderCntrl();
        
        Holders__c conHolder = configHld.conHolder;
        ConfigHolderUtility obj = new ConfigHolderUtility(conHolder.Id);
        
        Map<String, Object> holderRequiredParameters = ConfigHolderUtility.holderRequiredParameters();
        
        Map<String, String> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        Map<String, Holder_Additional_Acc_Details__c> additionalAccAttributes = ConfigHolderUtility.additionalAccAttributes(holderInputs);
        
        ConfigHolderUtility.getPricing(holderInputs);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testDataFromTranslation() {
        
        Test.startTest();        
        
        ConfigHoldersOutputController configHld = ConfigHolderUtilityTest.getConfigHolderCntrl();
        
        Holders__c conHolder = configHld.conHolder;
        ConfigHolderUtility obj = new ConfigHolderUtility(conHolder.Id);
        Map<String, String> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        
        Result lookupDetailList = new Result();
        List<String> selectCols = new List<String> {'Text__c'};
        ConfigHolderUtility.getDataFromTranslationObj('Attribute__c', 'Holder_Lookup_Translation__c', 'Holder_Lookup_Detail__c', holderInputs, selectCols, new List<String> {'OUTLETCOMPPTC'});

        ConfigHolderUtility.getDataFromTranslationObj('Attribute__c', 'Holder_Lookup_Translation__c', 'Holder_Lookup_Detail__c', holderInputs, selectCols, new List<String> {'OUTLETCOMPPTC'}, 'Text__c');
        
        ConfigHolderUtility.getHLDRouting(holderInputs);
        ConfigHolderUtility.getHolderControlPlan(holderInputs);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testUtilityOthers() {
        
        Test.startTest();        
        
        ConfigHoldersOutputController configHld = ConfigHolderUtilityTest.getConfigHolderCntrl();
        
        Holders__c conHolder = configHld.conHolder;
        ConfigHolderUtility obj = new ConfigHolderUtility(conHolder.Id);
        Map<String, String> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
   
        ConfigHolderUtility.getHolderWorkGuideLines(holderInputs);
        ConfigHolderUtility.getHolderDescription(holderInputs);
                
        Test.stopTest();
    }
    
    @isTest
    public static void testStructures() {
        
        Test.startTest();   
        
        ConfigHoldersOutputController configHld = ConfigHolderUtilityTest.getConfigHolderCntrl();
        
        Holders__c conHolder = configHld.conHolder;
        //conHolder.Spacer_Ring_Material__c = 'Test';
		//conHolder.Holder_Product_Code__c = 'PR8';
		//conHolder.Holddown_Ring_Material__c = 'Test';
        //update conHolder;
        
        ConfigHolderUtility obj = new ConfigHolderUtility(conHolder.Id);
        
        obj.getStructures();
                
        Test.stopTest();
    }
   
    @isTest
    public static void testIsHolderParamterRequired() {
        
        Test.startTest();  
     	
        ConfigHoldersOutputController configHld = ConfigHolderUtilityTest.getConfigHolderCntrl();
        
        Holders__c conHolder = configHld.conHolder;
        system.debug('conHolder.Holder_Product_Code__c:'+conHolder.Holder_Product_Code__c);
        Map<String, Object> holdersRequiredInfo = ConfigHolderUtility.holderRequiredParameters();
        system.debug('holdersRequiredInfo:'+holdersRequiredInfo);
        //ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Companion_Flange__c');
        
       	//ConfigHolderUtility.isHolderParamterRequiredString((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Studs_and_Nuts__c');
        
        Test.stopTest();
    }
}