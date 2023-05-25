@isTest
public class ConfigHoldersOutputControllerTest {
    
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
    public static void testSavePartNumber() {
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        configHld.conHolder.NEWSPCLPARTNOBASE__c = null;
        configHld.conHolder.Part_Number_Base__c = null;
        configHld.savePartNumber();
        
        configHld.conHolder.NEWSPCLPARTNOBASE__c = 'PART1';
        configHld.conHolder.Part_Number_Base__c = 'PART1';
        
        Test.startTest();
        configHld.savePartNumber();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderStrutureSection2() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        configHld.lookupAttributes = null;
        configHld.lookupAttributesAll = null;
        configHld.testingCodeAttributesMap = null;
        configHld.additionalCodeAttributesMap = null;
        
        map<String,String> holderInputs = configHld.holderInputs;
        holderInputs.put('PTC', 'CR8');
        configHld.holderInputs = holderInputs;
        
        Test.startTest();
        configHld.getStructures();
        configHld.selectedTab = 'MfgOutputs';
        configHld.getTabData();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderStrutureSection() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Map<String, String> lookupAttributes = configHld.lookupAttributes;
        lookupAttributes.put('MCTHDL', 'Test');
        configHld.lookupAttributes = lookupAttributes;
        
        Test.startTest();
        configHld.getStructures();
        configHld.selectedTab = 'MfgOutputs';
        configHld.getTabData();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderPriceSection() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
            
        Test.startTest();
        configHld.getCosts();
        Test.stopTest();
    }

    @isTest
    public static void testHolderPriceSection1() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
                
        Test.startTest();
        configHld.getPricinglist();
        configHld.selectedTab = 'Pricing';
        configHld.getTabData();
        
        Test.stopTest();
    }

    @isTest
    public static void testHolderPriceSection11() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
         
        Holders__c conHolder = configHld.conHolder;
        conHolder.Price_Engineer_Override__c = true;
        update conHolder;
        
        Test.startTest();
        configHld.getPricinglist();
        configHld.selectedTab = 'Pricing';
        configHld.getTabData();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderPriceSection2() {
         
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
               
        Test.startTest();
        configHld.ApplyDefaultPricing();
        configHld.ApplyDefaultCost();        
        Test.stopTest();
    }
    
    @isTest 
    public static void testHolderPriceSection3() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Test.startTest();
        configHld.saveCosting();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderLeadTimeSection() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
                   
        Test.startTest();
        configHld.saveLeadTime();
        Test.stopTest();
    }
        
    @isTest
    public static void testHolderLeadTimeSection1() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Test.startTest();
        configHld.getLeadTime(); 
        configHld.selectedTab = 'ProductReview';
        configHld.getTabData();
        Holder_Leadtime_Schedule__c res = configHld.filterSchedule(2, 'test');
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderLeadTimeSection2() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
           
        Test.startTest();
        configHld.applyDefaultsLead();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderDiagramSection() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
           
        Test.startTest();
        configHld.getDiaData();
        configHld.applyDefalutsDiagrams();
        configHld.conHolder.Drawing_Outside_Config__c = false;
        configHld.applyDefalutsDiagrams();
        configHld.selectedTab = 'Diagram';
        configHld.getTabData();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderDescSection() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
           
        Test.startTest();
        configHld.getQuoteDescriptionRec();
        configHld.ApplyDefaultQuoteDescription();
        configHld.selectedTab = 'EngineeringSpl';
        configHld.getTabData();
        Test.stopTest();
    }        
    
    @isTest
    public static void testHolderDescSection2() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        List<ConfigHoldersOutputController.QuoteDescriptionWrapper> quoteDescriptionList = new List<ConfigHoldersOutputController.QuoteDescriptionWrapper>();
        ConfigHoldersOutputController.QuoteDescriptionWrapper quoteDesc = new ConfigHoldersOutputController.QuoteDescriptionWrapper();
        quoteDesc.attribute = 'OA';
        quoteDesc.strDesc = 'OA Desc';
        quoteDesc.strDescOverride = 'Inlet Desc';
        quoteDesc.noOfLines = 1;
        quoteDescriptionList.add(quoteDesc);
        
        configHld.quoteDescriptionList = quoteDescriptionList;
            
        Test.startTest();
        configHld.saveQuoteDescription();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderGenericFlow() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Test.startTest();
        configHld.generatePartNumber();
        configHld.onSpecialPartNoChange();
        configHld.savePartNumber();
        
        configHld.getHolderRouter();
        configHld.getHolderControlPlan();
        configHld.getAllHolderIFSAttributes();
        configHld.getHolderIFSAttributesWithFalse();
        configHld.getHolderWorkGL();
        new ConfigHoldersOutputController.HolderRouterWrapper();
        new ConfigHoldersOutputController.HolderControlPlanWrapper().strTest_OPNO_1 = 'test';
        new ConfigHoldersOutputController.HolderWorkGLWrapper();
        configHld.generalSave();
        configHld.selectedTab = 'TroubleShooting';
        configHld.getTabData();
        Test.stopTest();  
    }
    
    
    @isTest
    public static void testSaveDiagrams() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Holder_Drawings__c holderDiagram = [SELECT Id FROM Holder_Drawings__c LIMIT 1];
        configHld.holderDiagram = holderDiagram;        
        Test.startTest();
        configHld.saveDiagrams();
        Test.stopTest();
    }
    
    
    @isTest
    public static void testGoBackToProdConfig() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
            
        Test.startTest();
        configHld.goBackToProdConfig();
        Test.stopTest();
    }
    
    @isTest
    public static void testGoBackToQuote() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
            
        Test.startTest();
        configHld.goBackToQuote();
        Test.stopTest();
    }
    
    @isTest
    public static void testCopyCostToCostOverride() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Cost__c costRecord = new Cost__c();
        costRecord.Inside_Cost_10__c    = '10';
        costRecord.Outside_Cost_10__c   = '10';
        costRecord.Inside_Cost_20__c    = '10';
        costRecord.Outside_Cost_20__c   = '10';
        costRecord.Inside_Cost_30__c    = '10';
        costRecord.Outside_Cost_30__c   = '10';
        
        Test.startTest();
        configHld.copyCostToCostOverride(costRecord);
                
        Test.stopTest();
    }    
    
    @isTest
    public static void testInnerWrapper() {
        
        Test.startTest(); 
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
        ConfigHoldersOutputController.HolderControlPlanWrapper obj2 = new ConfigHoldersOutputController.HolderControlPlanWrapper();
        obj2.strTest_OPNO_1 = 'Test';
        obj2.strTEST_OPERATION_DESC = 'Test';
        obj2.strNORM_TYPE = 'Test';
        obj2.strOperation_Number = 'Test';
        obj2.strDATA_TYPE = 'Test';
        obj2.strCATEGORY_ID = 'Test';
        obj2.strINSPECTION_CODE = 'Test';
        obj2.strSAMPLE_PERCENT = 'Test';
        obj2.strProcess_Characteristic = 'Test';
        obj2.strSpecial_Characteristic_Classification = 'Test';
        obj2.strOUTER_MIN = 'Test';
        obj2.strINNER_MIN = 'Test';
        obj2.strNOMINAL_VALUE = 'Test';
        obj2.strINNER_MAX = 'Test';
        obj2.strOUTER_MAX = 'Test';
        obj2.strTool_ID = 'Test';
        obj2.strData_Point = 'Test';
        
        ConfigHoldersOutputController.HolderWorkGLWrapper obj3 = new ConfigHoldersOutputController.HolderWorkGLWrapper();
        obj3.strOperation = 'Test';
        obj3.strTest = 'Test';
        obj3.strStandard_Operation_ID = 'Test';
        obj3.strOutside_Operation_Item = 'Test';
        obj3.strGuideline_Seq = 'Test';
        obj3.strDescription = 'Test';
        obj3.strText = 'Test';
        obj3.strType = 'Test';
        obj3.strSign_Off = 'Test';
        obj3.strInspection_Sign_Off_Required = 'Test';

        String disabledCSS = obj.disabledCSS;
        obj.disabledCSS = 'Test';
        
        String stlCSS2 = obj.stlCSS2;
        obj.stlCSS2 = 'Test';
        
        String stlCSS3 = obj.stlCSS3;
        obj.stlCSS3 = 'Test';
        
        Test.stopTest();
    }
        
    @isTest
    public static void testSavePriceOverride() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        Test.startTest();
        configHld.SavePriceOverride();
        Test.stopTest();
    }
    
    @isTest
    public static void testSavePriceOverride2() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :TestDataHolderUtility.quoteLine.Id LIMIT 1];
        
        Map<String, Holder_Price_Output__c> pricingOverrideOutputs = new Map<String, Holder_Price_Output__c>();
        Holder_Price_Output__c holderPriceOutput;
        List<Holder_Price_Details__c> holderPricingList = new List<Holder_Price_Details__c>();
        Holder_Price_Details__c holderPricingRecord = new Holder_Price_Details__c ();
        holderPricingRecord.Price__c = 9999999.00;
        holderPricingRecord.Price_Override__c = 200;
        holderPricingRecord.Pricing_Element__c = 'Component-Outlet';
        holderPricingList.add(holderPricingRecord);
        
        holderPriceOutput = new Holder_Price_Output__c();
        holderPriceOutput.List_Price__c = holderPricingRecord.Price__c;
        holderPriceOutput.List_Price_Override__c = holderPricingRecord.Price_Override__c;
        holderPriceOutput.Price_Element__c = holderPricingRecord.Pricing_Element__c;
        holderPriceOutput.Holders__c = conHolder.Id;
        pricingOverrideOutputs.put(holderPriceOutput.Price_Element__c, holderPriceOutput);
        
        holderPricingRecord = new Holder_Price_Details__c ();
        holderPricingRecord.Price__c = 9999999.00;
        holderPricingRecord.Price_Override__c = 100;
        holderPricingRecord.Pricing_Element__c = 'Component-Inlet';
        holderPricingList.add(holderPricingRecord);
        
        holderPriceOutput = new Holder_Price_Output__c();
        holderPriceOutput.List_Price__c = holderPricingRecord.Price__c;
        holderPriceOutput.List_Price_Override__c = holderPricingRecord.Price_Override__c;
        holderPriceOutput.Price_Element__c = holderPricingRecord.Pricing_Element__c;
        holderPriceOutput.Holders__c = conHolder.Id;
        pricingOverrideOutputs.put(holderPriceOutput.Price_Element__c, holderPriceOutput);

        insert pricingOverrideOutputs.values();
        
        configHld.holderPricingList = holderPricingList;
        configHld.conHolder.Price_Engineer_Override__c = true;
        configHld.pricingOverrideOutputs = pricingOverrideOutputs;
        
        Test.startTest();
        configHld.SavePriceOverride();
        Test.stopTest();
    }
    
    @isTest
    public static void testSavePriceOverride3() {
                
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :TestDataHolderUtility.quoteLine.Id LIMIT 1];
        
        Map<String, Holder_Price_Output__c> pricingOverrideOutputs = new Map<String, Holder_Price_Output__c>();
        Holder_Price_Output__c holderPriceOutput;
        List<Holder_Price_Details__c> holderPricingList = new List<Holder_Price_Details__c>();
        Holder_Price_Details__c holderPricingRecord = new Holder_Price_Details__c ();
        holderPricingRecord.Price__c = 9999999.00;
        holderPricingRecord.Price_Override__c = 200;
        holderPricingRecord.Pricing_Element__c = 'Component-Outlet';
        holderPricingList.add(holderPricingRecord);
        
        holderPriceOutput = new Holder_Price_Output__c();
        holderPriceOutput.List_Price__c = holderPricingRecord.Price__c;
        holderPriceOutput.List_Price_Override__c = holderPricingRecord.Price_Override__c;
        holderPriceOutput.Price_Element__c = holderPricingRecord.Pricing_Element__c;
        holderPriceOutput.Holders__c = conHolder.Id;
        pricingOverrideOutputs.put(holderPriceOutput.Price_Element__c, holderPriceOutput);
        
        holderPricingRecord = new Holder_Price_Details__c ();
        holderPricingRecord.Price__c = 9999999.00;
        holderPricingRecord.Price_Override__c = 100;
        holderPricingRecord.Pricing_Element__c = 'Component-Inlet';
        holderPricingList.add(holderPricingRecord);
        
        insert pricingOverrideOutputs.values();
        
        configHld.holderPricingList = holderPricingList;
        configHld.conHolder.Price_Engineer_Override__c = true;
        configHld.pricingOverrideOutputs = pricingOverrideOutputs;
        
        Test.startTest();
        configHld.SavePriceOverride();
        Test.stopTest();
    } 
    
    @isTest
    public static void generalCoverage() {
        
        Test.startTest();
        ConfigHoldersOutputController configHld = new ConfigHoldersOutputController();
        
        Holders__c conHolder = new Holders__c();
        conHolder.Size__c = '1000';
        configHld.conHolder = conHolder;
        configHld.prodDesc1 = 'DESC 1';
        configHld.prodDesc2 = 'DESC 2';
        configHld.prodDesc3 = 'DESC 3';
        
        configHld.holderAllIFSAttributes = new Map<String, String>();
        
        Map<String, String> mapHLDRAttr = configHld.mapHLDRAttr;
        configHld.mapHLDRAttr = mapHLDRAttr;
        
        ConfigHoldersOutputController.HolderRouterWrapper hrw = new ConfigHoldersOutputController.HolderRouterWrapper();
        hrw.strDescr = 'DESC';
        hrw.strOPERATION = 'Test';
        hrw.strOutside_Operation_Item = 'Test Item';
        hrw.strStandard_Operation_ID = 'Test Id';
                
        Test.stopTest();
    }
    
    @isTest
    public static void testCostOnload() {
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();

        Test.startTest();
        configHld.costOnload();
        configHld.hiddenCost = new List<Cost__c>();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderRouter() {
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();

        Test.startTest();
        configHld.getHolderRouter();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderControlPlan() {
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();

        Test.startTest();
        configHld.getHolderControlPlan();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderWorkGL() {
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Test.startTest();
        configHld.getHolderWorkGL();
        Test.stopTest();
    }
    
    @isTest
    public static void testSpecialPartNoChange() {
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        configHld.conHolder.NEWSPCLPARTNOBASE__c = 'None';
        configHld.conHolder.ASSYPARTNOBASE__c = null;
        
        Test.startTest();
        configHld.onSpecialPartNoChange();
        
        configHld.prodDiagram = new Holder_Drawings__c();
        
        List<Holder_Drawings_Detail__c> drawingDets = [SELECT Id, DrawingID__c FROM Holder_Drawings_Detail__c WHERE DrawingID__c = 'GEP-6400'];
        Holder_Drawings_Detail__c drawingDet = drawingDets[0];
        drawingDet.DrawingID__c = null;
        update drawingDet;
        
        configHld.loadDiagramData();
        
        Test.stopTest();
    }
}