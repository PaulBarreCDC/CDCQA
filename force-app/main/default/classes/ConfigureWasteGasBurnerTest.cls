@isTest
public class ConfigureWasteGasBurnerTest {
    
    @isTest
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
    public static void testWGBCostSection() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        
        configWGB.getCosts();
        configWGB.savePartNumber();
        configWGB.saveNotes();
        configWGB.SaveDocID();
      //  configWGB.costOnload();
        configWGB.saveCosting();
        configWGB.ApplyDefaultCost();
       // Cost__c copyCostToCostOverride=new Cost__C();
      //  copyCostToCostOverride=configWGB.copyCostToCostOverride();
        
        Test.stopTest();
    }

    @isTest
    public static void testWGBPriceSection() {
    
    Test.startTest();
    
    ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
    
    	configWGB.getPricinglist();
        configWGB.selectedTab = 'PricingTab';
        configWGB.getTabData();
    //    configWGB.ApplyDefaultPricing();
    //   configWGB.SavePriceOverride();
    //    configWGB.getPrice();
    	Test.stopTest();
    }


	@isTest
    public static void testWGBPriceSection2() {
    
    Test.startTest();
    
    ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
    
    	//configWGB.getPricinglist();
      //  configWGB.selectedTab = 'PricingTab';
      //  configWGB.getTabData();
        configWGB.ApplyDefaultPricing();
        configWGB.SavePriceOverride();
        configWGB.getPrice();
    	Test.stopTest();
    }    
    @isTest
    public static void testWGBLeadTimeSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        configWGB.selectedTab = 'ProductReview';
        configWGB.getTabData();                        
     //   configWGB.GetLeadTimeRec();
     //   configWGB.ApplyDefaultLeadtime();
     //   configWGB.SaveLeadTimeOverride();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testWGBLeadTimeSection2() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
       // configWGB.selectedTab = 'ProductReview';
      //  configWGB.getTabData();                        
        configWGB.GetLeadTimeRec();
     //   configWGB.ApplyDefaultLeadtime();
     //   configWGB.SaveLeadTimeOverride();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testWGBLeadTimeSection3() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
       // configWGB.selectedTab = 'ProductReview';
      //  configWGB.getTabData();                        
      //  configWGB.GetLeadTimeRec();
        configWGB.ApplyDefaultLeadtime();
        configWGB.SaveLeadTimeOverride();
        
        Test.stopTest();
    }
    @isTest
    public static void testWGBQuoteDescriptionSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        
     //   configWGB.GetQuoteDescriptionRec();
        configWGB.selectedTab = 'Quote';
        configWGB.getTabData();
      //  configWGB.ApplyDefaultQuoteDescription();
      //  configWGB.SaveQuoteDescriptionOverride();
        Test.stopTest();
    }
    
    @isTest
    public static void testWGBQuoteDescriptionSection2() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        
        configWGB.GetQuoteDescriptionRec();
      //  configWGB.selectedTab = 'Quote';
     //   configWGB.getTabData();
     //   configWGB.ApplyDefaultQuoteDescription();
        configWGB.SaveQuoteDescriptionOverride();
        Test.stopTest();
    }
    @isTest
    public static void testWGBFinishSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        
        configWGB.EnableEditMode();
        configWGB.saveProductSelection();
        configWGB.getSeatValues();
        configWGB.SaveCertifications();
        configWGB.saveRecommendedProcessInformation();        
        configWGB.GetTroubleShootingAttributes();        
        string str;
        str=configWGB.ASYTYP;
        str=configWGB.GMODEL;
        str=configWGB.GTAG01;
        str=configWGB.GTAGPN;
        str=configWGB.ASSEMBLYWT;
        str=configWGB.PRDLIN;
        str=configWGB.RTPRS1;
        str=configWGB.REQDFLOW;
		str=configWGB.strquoteDes;
        configWGB.goBack();
        configWGB.generatePartNumber();
        Test.stopTest();
    }
   
    @isTest
    public static void testWGBManufacturingOutputSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        configWGB.selectedTab = 'EngineeringTab';
        configWGB.getTabData();
        configWGB.getRouter();
       // configWGB.getStructure();
        configWGB.getControlPlanDetails();
        configWGB.getWorkGuideLines();
        configWGB.getDocument();
        configWGB.getStructureDetails();
        
        Test.stopTest();
    }
   
    @isTest
    public static void testWGBDynamicPicklistSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        
        configWGB.selectedTab = 'Notes';
        configWGB.getTabData();
        configWGB.getLeadWGBOutputInstance();
        configWGB.getUpperShroud();
        configWGB.getLowerStack();
        configWGB.getPedestalConnection();
        configWGB.getIgnitorControl();
        configWGB.getFlameSensor();
        configWGB.getThermocoupleMaterial();
        configWGB.getEnclosureType();
        configWGB.getControlPanelAlarm();
        configWGB.getControlPanelHeater();
        configWGB.getStandControlMaterial();
        configWGB.getSunshieldControl();
        configWGB.getStepDownTransformer();
        configWGB.getBackupPowerSupply();
        
        Test.stopTest();
    }
     
    @isTest
    public static void testFinishbuttonSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        
        configWGB.saveSelections();
          
        Test.stopTest();
    }

  
    
    @isTest
    public static void testExtraMethodsSection() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
       
        List<string> list1=new List<String>();
        list1=configWGB.notValidStatusForChng;
        configWGB.reload();
        string str=configWGB.setBlankForNull('a');
          
        Test.stopTest();
    }		
    
    
  /**************Output Methods****************/
    public static WGBOutputUtility WGBOU{get;set;} 
    public static WGBOutputUtility WGBOU1{get;set;} 
    public static WGBOutputUtility WGBOU2{get;set;} 
    public static WGBOutputUtility WGBOU3{get;set;} 
    
    @isTest
    public static void testOutputMethod1Section() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        WGBOU=new WGBOutputUtility(configWGB.WGBProd.Id);

        WGBOU.getEngPartCharacterXML();
        WGBOU.getEngPartStructureXML();
      //  WGBOU.getEngineeringParts();
     //   WGBOU.GetInventoryPartDetails();
    //    WGBOU.getSalesParts();
       
        Test.stopTest();
    }

    @isTest
    public static void testOutputMethod2section() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        WGBOU1=new WGBOutputUtility(configWGB.WGBProd.Id);
        
        WGBOU1.getProductCatalog();
        WGBOU1.getPurchasePart();
        WGBOU1.getPurchasePartSuppliers();
        WGBOU1.getEngineeringParts();
       // WGBOU1.getStructureXML();
      //  WGBOU1.GetControlPlanDetails();
     //   WGBOU1.GetRoutingDetails();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testOutputMethod3section() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        WGBOU3=new WGBOutputUtility(configWGB.WGBProd.Id);
        
     	WGBOU3.GetAttributeMapQuoteDescription();
     //   WGBOU3.getStructureXML();
     //   WGBOU3.GetControlPlanDetails();        
      //  WGBOU3.GetAttributeMapQuoteDescriptionforOA();
      //  WGBOU3.GetAttributeMapQuoteDescriptionforOB();
        
        Test.stopTest();
    }
    
     @isTest
    public static void testOutputMethod6section() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        WGBOU3=new WGBOutputUtility(configWGB.WGBProd.Id);
        
     //	WGBOU3.GetAttributeMapQuoteDescription();
        WGBOU3.getStructureXML();
        WGBOU3.GetControlPlanDetails();        
      //  WGBOU3.GetAttributeMapQuoteDescriptionforOA();
      //  WGBOU3.GetAttributeMapQuoteDescriptionforOB();
        
        Test.stopTest();
    }
    @isTest
    public static void testOutputMethod4section() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        WGBOU2=new WGBOutputUtility(configWGB.WGBProd.Id);

        WGBOU2.getTroubleShootingWGBAttr();
        WGBOU2.getPricing();
        WGBOU2.getFlowRate();       
        WGBOU2.GetRoutingDetails();
        string str;
        str=WGBOU2.ATTRTEMPLATE;
        str=WGBOU2.COMPDESCRIPTION;
        str=WGBOU2.COMPINVSERTRK;
        str=WGBOU2.COMPLOTTRACK;
        str=WGBOU2.COMPPROVIDE;
        str=WGBOU2.COMPRESPONID;
        str=WGBOU2.CUSTOMSTATNO;
        str=WGBOU2.HSNSACCODE;
        str=WGBOU2.LOTTRACKCODE;
        str=WGBOU2.PARTCLASS;
        str=WGBOU2.PARTUOM;
        str=WGBOU2.SALESGROUP;
        str=WGBOU2.SALESPRICEGROUP;
        str=WGBOU2.SERIALTRACKCODE;
        str=WGBOU2.MW;
        str=WGBOU2.OA02;
        str=WGBOU2.OA03;
        str=WGBOU2.OA04;
        str=WGBOU2.OA05;
        str=WGBOU2.OA06;
        str=WGBOU2.OB010;
        str=WGBOU2.OB020;
        str=WGBOU2.OB030;
        str=WGBOU2.OB040;
        str=WGBOU2.OB050;
        str=WGBOU2.OB060;
        str=WGBOU2.OB070;
        str=WGBOU2.OB080;
        str=WGBOU2.OB090;
        str=WGBOU2.OB100;
        str=WGBOU2.OB110;
        str=WGBOU2.OB120;
        str=WGBOU2.OB130;
        str=WGBOU2.OB140;
        str=WGBOU2.OB150;
        str=WGBOU2.OB160;
        str=WGBOU2.OB170;
        str=WGBOU2.OB180;
        str=WGBOU2.OB190;
        str=WGBOU2.OB200;
        str=WGBOU2.OB210;
        str=WGBOU2.OB220;
        str=WGBOU2.OB230;
        str=WGBOU2.OB240;
        str=WGBOU2.OB250;
        str=WGBOU2.OB450;
        str=WGBOU2.SizeDesc;
        str=WGBOU2.SpecialOpt0;
        str=WGBOU2.SpecialOpt2;
        str=WGBOU2.SpecialOpt4;
        str=WGBOU2.SpecialOpt6;
        str=WGBOU2.SpecialOpt8;
        str=WGBOU2.SpecialOptDesc;
        str=WGBOU2.OA01;
        str=WGBOU2.Schedule;
        str=WGBOU2.DocumentID;
        
        WGBOU2.ATTRTEMPLATE='test';
        WGBOU2.COMPDESCRIPTION='test';
        WGBOU2.COMPINVSERTRK='test';
        WGBOU2.COMPLOTTRACK='test';
        WGBOU2.COMPPROVIDE='test';
        WGBOU2.COMPRESPONID='test';
        WGBOU2.CUSTOMSTATNO='test';
        WGBOU2.HSNSACCODE='test';
        WGBOU2.LOTTRACKCODE='test';
        WGBOU2.PARTCLASS='test';
        WGBOU2.PARTUOM='test';
        WGBOU2.SALESGROUP='test';
        WGBOU2.SALESPRICEGROUP='test';
        WGBOU2.SERIALTRACKCODE='test';
        WGBOU2.MW='test';
        WGBOU2.OA02='test';
        WGBOU2.OA03='test';
        WGBOU2.OA04='test';
        WGBOU2.OA05='test';
        WGBOU2.OA06='test';
        WGBOU2.OB010='test';
        WGBOU2.OB020='test';
        WGBOU2.OB030='test';
        WGBOU2.OB040='test';
        WGBOU2.OB050='test';
        WGBOU2.OB060='test';
        WGBOU2.OB070='test';
        WGBOU2.OB080='test';
        WGBOU2.OB090='test';
        WGBOU2.OB100='test';
        WGBOU2.OB110='test';
        WGBOU2.OB120='test';
        WGBOU2.OB130='test';
        WGBOU2.OB140='test';
        WGBOU2.OB150='test';
        WGBOU2.OB160='test';
        WGBOU2.OB170='test';
        WGBOU2.OB180='test';
        WGBOU2.OB190='test';
        WGBOU2.OB200='test';
        WGBOU2.OB210='test';
        WGBOU2.OB220='test';
        WGBOU2.OB230='test';
        WGBOU2.OB240='test';
        WGBOU2.OB250='test';
        WGBOU2.OB450='test';
        WGBOU2.SizeDesc='test';
        WGBOU2.SpecialOpt0='test';
        WGBOU2.SpecialOpt2='test';
        WGBOU2.SpecialOpt4='test';
        WGBOU2.SpecialOpt6='test';
        WGBOU2.SpecialOpt8='test';
        WGBOU2.SpecialOptDesc='test';
        WGBOU2.OA01='test';
        WGBOU2.Schedule='test';
        WGBOU2.DocumentID='test';        
        WGBOU2.SIZECODE='test';
        WGBOU2.MODEL='test';
        WGBOU2.ASSEMBLYWT='test';
        WGBOU2.ASSEMBLYWTUOM='test';
        WGBOU2.ASYTYP='test';
        WGBOU2.CHAR_TEMPLATE='test';
        WGBOU2.BRAND='test';
        WGBOU2.BRANDCODE='test';
        WGBOU2.ENG_DESCRIPTION='test';
        WGBOU2.ENG_INV_SERIAL_TRACKING='test';
        WGBOU2.ENG_LOTTRACK='test';
        WGBOU2.ENG_PROVIDE='test';
        WGBOU2.ENG_RESPONSIBLE_ID='test';
        WGBOU2.ConnectionDesc='test';
        WGBOU2.CUSTOMS_STAT_NO='test';
        WGBOU2.EnclosureOpt='test';
        WGBOU2.EnclosureOptDesc='test';
        WGBOU2.FlameSensorOpt='test';
        WGBOU2.FlameSensorOptDesc='test';
        WGBOU2.GTAG01='test';
        WGBOU2.GTAGPN='test';
        WGBOU2.HSN_SAC_CODE='test';
        WGBOU2.IgnitorOpt='test';
        WGBOU2.IgnitorOptDesc='test';
        WGBOU2.MCEVAL='test';
        WGBOU2.MCLSDesc='test';
        WGBOU2.PART_CLASS='test';
        WGBOU2.PART_UOM='test';
        WGBOU2.PLANNER='test';
        WGBOU2.PROVIDE='test';
        WGBOU2.RESPONSIBLE_ID='test';
        WGBOU2.CATALOG_GROUP='test';
        WGBOU2.SALES_PRICE_GROUP_ID='test';
        WGBOU2.INV_SERIAL_TRACKING='test';
        WGBOU2.SpecialOpt='test';
        WGBOU2.PRDLIN='test';
        WGBOU2.GAGES='test';
        WGBOU2.REGULATOR='test';
        WGBOU2.OA='test';
        WGBOU2.OB='test';
        WGBOU2.GMODEL='test';
        WGBOU2.GASGROUP='test';
        WGBOU2.GASUOM='test';
        WGBOU2.RTPRS1=0;
        WGBOU2.RTPRSU='test';
        WGBOU2.PilotSupplyPressConverted=0;
        WGBOU2.REQDFLOW=0;
        WGBOU2.REQDFLOWUOM='test';
        WGBOU2.CONVERTEDFLOW=0;
        WGBOU2.ULCERT='test';
        WGBOU2.PTC='test';
        WGBOU2.SZC='test';
        WGBOU2.QTY=0;
        WGBOU2.MCUS='test';
        WGBOU2.MCLS='test';
        WGBOU2.PEDCON='test';
        WGBOU2.IGNCTL='test';
        WGBOU2.FLMSNS='test';
        WGBOU2.TCMATERIAL='test';
        WGBOU2.ENCTYP='test';
        WGBOU2.CPALRM='test';
        WGBOU2.CPHEAT='test';
        WGBOU2.STNDCT='test';
        WGBOU2.SUNCTL='test';
        WGBOU2.SPDT='test';
        WGBOU2.BPS='test';
        WGBOU2.PARTMANAGEDIN='test';
        WGBOU2.PARTNUMBER='test';
        WGBOU2.PARTREV='test';
        WGBOU2.NOTE='test';
        WGBOU2.DESCRIPTION='test';
        WGBOU2.getPartNumber();

        Test.stopTest();
    }
    
    @isTest
    public static void testOutputMethod5Section() {
    
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl();
        WGBOU=new WGBOutputUtility(configWGB.WGBProd.Id);

     //   WGBOU.getEngPartCharacterXML();
     //   WGBOU.getEngPartStructureXML();
     //   WGBOU.getEngineeringParts();
        WGBOU.GetInventoryPartDetails();
        WGBOU.getSalesParts();
       
        Test.stopTest();
    }
    
    @isTest
    public static ConfigureWasteGasBurner getConfigWGBCntrl2() {
                 
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
        
        return new ConfigureWasteGasBurner(quoteLine.Id);
    }
    
 /*   
    @isTest
    public static void testconstrutor2Section() {
        
        Test.startTest();
        
        ConfigureWasteGasBurner configWGB = ConfigureWasteGasBurnerTest.getConfigWGBCntrl2();
        
        configWGB.ASSEMBLYWT='test';
          
        Test.stopTest();
    }
    */
    
}