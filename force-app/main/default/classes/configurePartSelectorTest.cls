@istest
public class configurePartSelectorTest {
    @isTest
    public static configurePartSelector testMethod1() { 
        
        Map<String, String> mapWithPSValues = new Map<String, String>();
        mapWithPSValues.put('BRAND','Groth');
        mapWithPSValues.put('PRODUCT_CODE','PS');
        mapWithPSValues.put('PRODUCT_NAME','Partselecter');
        
        
        TestConfigurePrartSelectorUtility.mapWithPSValues=mapWithPSValues;
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithPSValues);
        TestConfigurePrartSelectorUtility.quoteLine= quoteLine;
        TestConfigurePrartSelectorUtility.createPSTestRecords();
        Part_Selector__c psSelctor=TestConfigurePrartSelectorUtility.psSelctor;
        TestConfigurePrartSelectorUtility.createPSTestRecordsbluk();
        PageReference pager = Page.ConfigPartSelector;
        Test.setCurrentPage(pager);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(psSelctor.id));
        Part_Selector__c partSelector = [SELECT Id,Brand__c,Part_Number__c,ProductGroup__c,SubGroup__c FROM Part_Selector__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        system.debug('$$$$$$$$'+partSelector.Brand__c +'_'+ partSelector.ProductGroup__c +'_'+ partSelector.SubGroup__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(psSelctor);
        return new configurePartSelector(sc);
   }  
    
    @isTest
    public static configurePartSelector testMethod2() { 
        
        Map<String, String> mapWithPSValues = new Map<String, String>();
        mapWithPSValues.put('BRAND','Groth');
        mapWithPSValues.put('PRODUCT_CODE','PS');
        mapWithPSValues.put('PRODUCT_NAME','Partselecter');
        
        
        TestConfigurePrartSelectorUtility.mapWithPSValues=mapWithPSValues;
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithPSValues);
        TestConfigurePrartSelectorUtility.quoteLine= quoteLine;
        TestConfigurePrartSelectorUtility.createPSTestRecordss();
        Part_Selector__c psSelctor=TestConfigurePrartSelectorUtility.psSelctors;        
        TestConfigurePrartSelectorUtility.createPSTestRecordsbluks();
        PageReference pager = Page.ConfigPartSelector;
        Test.setCurrentPage(pager);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(psSelctor.id));
        Part_Selector__c partSelector = [SELECT Id,Brand__c,Part_Number__c,ProductGroup__c,SubGroup__c FROM Part_Selector__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        system.debug('$$$$$$$$'+partSelector.Brand__c +'_'+ partSelector.ProductGroup__c +'_'+ partSelector.SubGroup__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(psSelctor);
        return new configurePartSelector(sc);
   }
    
      @istest
    public static void updateQLAsync(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.creteAssiPD();
         //scr.updateQLAsync();
         Test.stopTest();
    }
    
    
    
    
    
    @isTest
    public static void updatecostinfro(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.creteAssiPD();
        TestConfigurePrartSelectorUtility.csrateDrawing();
        TestConfigurePrartSelectorUtility.creteAssyPD();
        scr.updateQLAsync();
        // scr.PS.Brand__c = 'groth';
        scr.partNumber = '12TH081FFG3204EA0001';
        scr.searchQuoteLineItem();
        string s1 = scr.disabledCSS;
        string s2 = scr.stlCSS2;
        string s3 = scr.stlCSS3;
        Test.stopTest();
    }
    
    @istest
    public static void saveProdPartNumber(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.creteAssiPD();
        scr.partNumber='12TH081FFG3204EA0001';
        scr.saveProdPartNumber();
        Test.stopTest();
    }
    
    @istest
    public static void ProdSpecificAttr(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.creteAssiPD();
        TestConfigurePrartSelectorUtility.creteASSYPratDef();
        TestConfigurePrartSelectorUtility.csrateDrawing();
        scr.saveProdSpecificAttr();
         Test.stopTest();
    }

   
    
    @isTest
    public static void createcostinfro(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.creteAssiPD();
        TestConfigurePrartSelectorUtility.creteASSYPratDef();
        TestConfigurePrartSelectorUtility.csrateDrawing();
        
        scr.fetchfieldsList();
        scr.listField[0].fieldName = 'Maximum Pressure:';
        scr.listField[1].fieldName = 'Pressure Scale:';
        scr.listField[1].lstSelectOption.add(0 , new SelectOption('1','--- Select1 ---'));
        scr.listField[1].lstSelectOption.add(0 , new SelectOption('2','--- Select2 ---'));
        scr.fetchfieldsList();
        scr.applyDefalutsDiagrams();
        Test.stopTest();
    }
    
    
    
    
    
    @isTest
    public static void serchquoteline(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        scr.partNumber='12TH081FFG3204EA0001';
        //TestConfigurePrartSelectorUtility.createInptAttr(); 

        scr.EnableEditMode();
        scr.saveDiagrams();
        scr.getPrdList();
        scr.getSubPrdctList();
        Test.stopTest();
    }
    
    @isTest
    public static void priceinfoserch(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        //TestConfigurePrartSelectorUtility.createPSOutput(); 
        TestConfigurePrartSelectorUtility.createprice();
        scr.getPricinglist();
        scr.SavePriceOverride();
        scr.getPricePSOutputInstance();
        scr.ApplyDefaultPricing();
        scr.SaveLeadTimeOverride();
        scr.getLeadPSOutputInstance();
        scr.getQuotePSOutputInstance();
        Test.stopTest();
    }
    
    @isTest
    public static void leadTimelist(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.createPSleadtime();
        TestConfigurePrartSelectorUtility.createPSGlobaltime();
        scr.getLeadTimeRecs();
        scr.ApplyDefaultLeadtime();
        scr.SaveLeadTimeOverride();
        Test.stopTest();
    }
    
    @isTest
    public static void SellectAttrlist(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        //TestConfigurePrartSelectorUtility.createPSinputValues();
        //TestConfigurePrartSelectorUtility.createPSinputlabel();
        scr.getattrvalueList();
        scr.getsizevalueList();
        scr.getPTCvalueList();
        scr.getMCBODYvalueList();
        scr.getHCLASSvalueList();
        scr.getATEXvalueList();
        scr.getCUTRvalueList();
        scr.getESZCvalueList();
        scr.getMCDPHMvalueList();
        scr.getMCELMTvalueList();
        scr.getMCHOUSvalueList();
        scr.getMCPALLvalueList();
        scr.getNACEvalueList();
        scr.getSETTINGvalueList();
        scr.getSPRINGvalueList();
        scr.getWeightMatlCodevalueList();
        scr.getWeightvalueList();
        scr.getTypevalueList();
        scr.getThicknessvalueList();
        scr.getSpringRangevalueList();
        scr.getSpringMatlCodevalueList();
        scr.getPositionvalueList();
        scr.getPortLoadingvalueList();
        scr.getPortvalueList();
        scr.getPilotSupplyRangevalueList();
        scr.getPilotGasvalueList();
        scr.getMCSPRGvalueList();
        scr.getMCENVGvalueList();
        scr.getGVRSC1valueList();
        scr.getGPRSC1valueList();
        scr.getGENOPTvalueList();
        scr.getEnvelopeGasketvalueList();
        Test.stopTest();
    }
   
   @isTest
    public static void applyFilter(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        //TestConfigurePrartSelectorUtility.createPSOutputs();
        //TestConfigurePrartSelectorUtility.listcreatePSOutput();
        TestConfigurePrartSelectorUtility.creteAssiPD();
        TestConfigurePrartSelectorUtility.creareCostPartNumber();
        //scr.getPSOutputRecord(psSelctor.id);
        scr.psaAllColSelection='kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg;kk:ss:gg';
        scr.psaSelectedCol=7;
        scr.applyFilterOnPSA();
       // scr.ApplyDefaultQuoteDescription();
        //scr.SaveQuoteDescriptionOverride();
        //scr.saveCosting();
        //scr.ApplyDefaultCost();
        scr.getStructure();
        
        Test.stopTest();
    }
    @istest
    public static void ceratecost(){ 
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        TestConfigurePrartSelectorUtility.creareCostPartNumber();
        TestConfigurePrartSelectorUtility.creareCostPartNumber();
        scr.getCosts();
        scr.saveCosting();
        scr.ApplyDefaultCost();
        Test.stopTest();
    }
     @istest
    public static void GetDetails(){
        Test.startTest();
        configurePartSelector scr = configurePartSelectorTest.testMethod1();
        scr.GetRoutingDetails();
        scr.getStructure();
        scr.GetControlPlanDetails();
        scr.getGuildeline();
        scr.getProDoc();
        scr.PSDataSetup();
        scr.getIFSAttributes();
        scr.getPSTroubleshooting();
        scr.saveNotes();
        scr.SaveDocID();
        scr.onSpecialPartNoChange();
        scr.savePartNumber();
        scr.generatePartNumber();
        Test.stopTest();
    }
    
    @isTest
    public static void elasepart(){
        Test.startTest();
        User test_usr=TestConfigurePrartSelectorUtility.createUser('CDC Inside Sales', 'testUser@test.com');
        insert test_usr;
        //System.runas(test_usr) {
            configurePartSelector scr1 = configurePartSelectorTest.testMethod2();
            TestConfigurePrartSelectorUtility.creteAssiPD();
            TestConfigurePrartSelectorUtility.creteASSYPratDef();
            TestConfigurePrartSelectorUtility.createprice();
            //TestConfigurePrartSelectorUtility.csrateDrawing();
            //scr1.ApplyDefaultQuoteDescription();
            scr1.saveProdPartNumber();
            scr1.goBack();
            scr1.applyDefalutsDiagrams();
            scr1.specifyPDGroup();
            scr1.getPricinglist();
            //scr1.SavePriceOverride();
            scr1.saveProdSpecificAttr();
            scr1.copyCostToCostOverride(TestConfigurePrartSelectorUtility.createcost());
            Test.stopTest();
       // }
    } 
    
    public static PSOutputUtilityXML PSOU1XML{get;set;} 
    @isTest
    public static void testXMLMethod1Section() {
    
        Test.startTest();
        
        configurePartSelector configPS = configurePartSelectorTest.testMethod1();
        PSOU1XML=new PSOutputUtilityXML(configPS.PS.Id);
        
        decimal dec;
        string str;
        str=PSOU1XML.PARTNUMBER;
        PSOU1XML.PARTNUMBER='test';
        str=PSOU1XML.PARTREV;
        PSOU1XML.PARTREV='test';
        str=PSOU1XML.psdlst;
        PSOU1XML.psdlst='test';     
        str=PSOU1XML.DESCRIPTION;
        PSOU1XML.DESCRIPTION='test';
        str=PSOU1XML.LOTTRACKCODE;
        PSOU1XML.LOTTRACKCODE='test';
        str=PSOU1XML.PROVIDE;
        PSOU1XML.PROVIDE='test';
        str=PSOU1XML.SERIALTRACKCODE;
        PSOU1XML.SERIALTRACKCODE='test';
        str=PSOU1XML.PARTCLASS;
        PSOU1XML.PARTCLASS='test';
        str=PSOU1XML.RESPONSIBLE_ID;
        PSOU1XML.RESPONSIBLE_ID='test';
        str=PSOU1XML.ASSEMBLYWTUOM;
        PSOU1XML.ASSEMBLYWTUOM='test';
        str=PSOU1XML.ASSEMBLYWT;
        PSOU1XML.ASSEMBLYWT='test';
        str=PSOU1XML.COMPRESPONID;
        PSOU1XML.COMPRESPONID='test';
        str=PSOU1XML.COMPDESCRIPTION;
        PSOU1XML.COMPDESCRIPTION='test';
        str=PSOU1XML.COMPINVSERTRK;
        PSOU1XML.COMPINVSERTRK='test';
        str=PSOU1XML.COMPLOTTRACK;
        PSOU1XML.COMPLOTTRACK='test';
        str=PSOU1XML.COMPPROVIDE;
        PSOU1XML.COMPPROVIDE='test';
        str=PSOU1XML.ATTRTEMPLATE;
        PSOU1XML.ATTRTEMPLATE='test';
        str=PSOU1XML.CUSTOMSTATNO;
        PSOU1XML.CUSTOMSTATNO='test';
        str=PSOU1XML.PLANNER;
        PSOU1XML.PLANNER='test';
        str=PSOU1XML.SALESGROUP;
        PSOU1XML.SALESGROUP='test';
        str=PSOU1XML.SALESPRICEGROUP;
        PSOU1XML.SALESPRICEGROUP='test';
        str=PSOU1XML.HSNSACCODE;
        PSOU1XML.HSNSACCODE='test';
        str=PSOU1XML.PARTUOM;
        PSOU1XML.PARTUOM='test';        
        str=PSOU1XML.NOTE;
        PSOU1XML.NOTE='test';       
        str=PSOU1XML.PARTMANAGEDIN;
        PSOU1XML.PARTMANAGEDIN='IFS';   
        PSOU1XML.getPartNumber();
        
        Test.stopTest();
    }
    
    public static PSOutputUtilityXML PSOU2XML{get;set;} 
    public static PSOutputUtilityXML PSOU3XML{get;set;} 
    
    @isTest
    public static void testOutputMethod1Section() {
    
        Test.startTest();
        
        configurePartSelector configPS = configurePartSelectorTest.testMethod1();       
        PSOU2XML=new PSOutputUtilityXML(configPS.PS.Id);
        PSOU2XML.SERIALTRACKCODE='Serial Tracking'; 
        PSOU2XML.getEngPartCharacterXML();
        PSOU2XML.getEngPartStructureXML();
        PSOU2XML.getEngineeringParts();
        PSOU2XML.GetInventoryPartDetails();
        PSOU2XML.getSalesParts();
        PSOU2XML.ISIFSMANAGEDSPECIAL = 'Y';
        PSOU2XML.pSOutputUtil.ORP = 'ORP';
        PSOU2XML.pSOutputUtil.ORV = 'ORV';
        PSOU2XML.pSOutputUtil.OW = 'OW';
        PSOU2XML.getEngPartCharacterXML();
        Test.stopTest();
    }

    @isTest
    public static void testOutputMethod2section() {
    
        Test.startTest();
        
        configurePartSelector configPS = configurePartSelectorTest.testMethod1();
        PSOU3XML=new PSOutputUtilityXML(configPS.PS.Id);
        PSOU3XML.SERIALTRACKCODE='Serial Tracking';       
        PSOU3XML.getProductCatalog();
        PSOU3XML.getPurchasePart();
        PSOU3XML.getPurchasePartSuppliers();
        PSOU3XML.getStructureXML();
        PSOU3XML.GetControlPlanDetails();
        PSOU3XML.GetRoutingDetails();
        
        Test.stopTest();
    } 
    @isTest
    public static void PSOutputUtilityTest() {
        configurePartSelector configPS = configurePartSelectorTest.testMethod1();
        PSOutputUtility pstest = new PSOutputUtility(configPS.PS.Id);
        Map<string,string> tt = new Map<string,string>();
        tt.put('hello','hello');
        tt.put('hello1','hello1');
        tt.put('hello2','hello2');
        pstest.mapPS_Attribute = tt;
        pstest.GetAttributeMapQuoteDescription();
        pstest.OA01 = 'OA01';
        pstest.GMODEL = 'GMODEL';
        pstest.SubGroup = 'SubGroup';
        pstest.SOURCINGOPT = 'SOURCINGOPT';
        pstest.SHLTSTBDYPSIG = 'SHLTSTBDYPSIG';
        pstest.SETTING = 'SETTING';
        pstest.SERIALTRACKCODE = 'SERIALTRACKCODE';
        pstest.SALESPRICEGROUP = 'SALESPRICEGROUP';
        pstest.SALESGROUP = 'SALESGROUP';
        pstest.PTC = 'PTC';
        pstest.PROVIDE = 'PROVIDE';
        pstest.ProdGroup = 'ProdGroup';
        pstest.PLANNER = 'PLANNER';
        pstest.PC441 = 'PC441';
        pstest.PC440 = 'PC440';
        pstest.PC431 = 'PC431';
        pstest.PC430 = 'PC430';
        pstest.PC421 = 'PC421';
        pstest.PC420 = 'PC420';
        pstest.PC411 = 'PC411';
        pstest.PC410 = 'PC410';
        pstest.PARTUOM = 'PARTUOM';
        pstest.PSAssyPartNumberLookup = 'PSAssyPartNumberLookup';
        pstest.PartNum = 'PartNum';
        pstest.PARTCLASS = 'PARTCLASS';
        pstest.OW920 = 'OW920';
        pstest.OW910 = 'OW910';
        pstest.OW340 = 'OW340';
        pstest.OW330 = 'OW330';
        pstest.OW320 = 'OW320';
        pstest.OW310 = 'OW310';
        pstest.OW300 = 'OW300';
        pstest.OW290 = 'OW290';
        pstest.OW300 = 'OW300';
        pstest.OW110 = 'OW110';
        pstest.OW120 = 'OW120';
        pstest.OW130 = 'OW130';
        pstest.OW140 = 'OW140';
        pstest.OW150 = 'OW150';
        pstest.OW160 = 'OW160';
        pstest.OW170 = 'OW170';
        pstest.OW180 = 'OW180';
        pstest.OW190 = 'OW190';
        pstest.OW200 = 'OW200';
        pstest.OW210 = 'OW210';
        pstest.OW220 = 'OW220';
        pstest.OW230 = 'OW230';
        pstest.OW240 = 'OW240';
        pstest.OW250 = 'OW250';
        pstest.OW260 = 'OW260';
        pstest.OW270 = 'OW270';
        pstest.OW280 = 'OW280';

    }
}