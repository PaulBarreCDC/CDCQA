/************************************************************************
* Class Name: BGROutputUtilityTest
* This class covers BGROutputUtility test
************************************************************************/
@isTest
Public class BGROutputUtilityTest {
    
    @isTest
    public static configureBGRProduct getConfigBGRCntrl() 
    {
        Map<String, String> mapWithBGRValues = new Map<String, String>();
        mapWithBGRValues.put('BRAND','Groth'); 
        mapWithBGRValues.put('PRODUCT_CODE','BGR');
        mapWithBGRValues.put('PRODUCT_NAME','BlanketGasRegulator');     
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithBGRValues);       
        TestDataBGRUtility.quoteLine = quoteLine;
        TestDataBGRUtility.mapWithBGRValues = mapWithBGRValues;       
        system.debug('TestDataBGRUtility.quoteLine:'+TestDataBGRUtility.quoteLine);
        system.debug('TestDataBGRUtility.mapWithBGRValues:'+TestDataBGRUtility.mapWithBGRValues);
        TestDataBGRUtility.createBGRTestRecords();
        TestDataBGRUtility.createBGRMasterTestRecords();       
        PageReference pager = Page.ConfigBGR;
        Test.setCurrentPage(pager);    
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));     
        BGR__c conBGR = [SELECT Id FROM BGR__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        //system.debug('conBGR:'+conBGR);        
        System.debug('quoteId...'+quoteLine.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);       
        return new configureBGRProduct(sc);
    }
    
    public static BGROutputUtility BGROU{get;set;} 
    public static BGROutputUtility BGROU1{get;set;} 
    public static BGROutputUtility BGROU2{get;set;}  
    public static BGROutputUtility BGROU3{get;set;} 
    
    @isTest
    public static void testPurchasePartSuppliers() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        
        BGROU = new BGROutputUtility(configBGR.conBGR.Id);
        BGROU.getPurchasePartSuppliers();
        Test.stopTest();
    }
    
    @isTest
    public static void testRoutingDetails() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU = new BGROutputUtility(configBGR.conBGR.Id);
        BGROU.GetRoutingDetails();
        Test.stopTest();
    }
    
    @isTest
    public static void testControlPlanDetails() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU = new BGROutputUtility(configBGR.conBGR.Id);
        BGROU.GetControlPlanDetails();
        Test.stopTest();
    }
        
    @isTest
    public static void testStructureXML() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU = new BGROutputUtility(configBGR.conBGR.Id);
        BGROU.getStructureXML();
        Test.stopTest();
    }
    
    @isTest
    public static void testGetEngPartStructureXML() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU = new BGROutputUtility(configBGR.conBGR.Id);
        BGROU.getEngPartStructureXML();
        Test.stopTest();
    }
    
    @isTest
    public static void testGetProdDoc() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU = new BGROutputUtility(configBGR.conBGR.Id);
        BGROU.getProdDoc();
        Test.stopTest();
    }
    
    @isTest
    public static void testOutputMethod1Section() {
    
        Test.startTest();
        
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU=new BGROutputUtility(configBGR.conBGR.Id);

        BGROU.getEngPartCharacterXML();
        BGROU.getEngPartStructureXML();
        BGROU.getEngineeringParts();
        BGROU.GetInventoryPartDetails();
        BGROU.getSalesParts();
        String tmp = BGROU.ENG_RESPONSIBLE_ID;
        tmp = BGROU.SETINUOM;
        List<BGR__c> bgrList = [SELECT Id FROM BGR__c];
        BGROU.getSerializedDataFromList(bgrList);
        Test.stopTest();
    }
    
    
    @isTest
    public static void testOutputMethod2section() {
    
        Test.startTest();
        
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU1=new BGROutputUtility(configBGR.conBGR.Id);
        
        BGROU1.getProductCatalog();
        BGROU1.getPurchasePart();
        BGROU1.getPurchasePartSuppliers();
        BGROU1.getStructureXML();
        BGROU1.GetControlPlanDetails();
        BGROU1.GetRoutingDetails();
        BGROU1.getRouting();
        
        Test.stopTest();
    }
    
      @isTest
    public static void testOutputMethod3section() {
    
        Test.startTest();
        
       configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU3=new BGROutputUtility(configBGR.conBGR.Id);
        
        BGROU3.GetAttributeMapQuoteDescription();
        BGROU3.GetLeadTimeRec();
        
        Test.stopTest();
    }
    
     @isTest
    public static void testOutputMethod4section() {
        
        Test.startTest();
        
      configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        BGROU2=new BGROutputUtility(configBGR.conBGR.Id);

        BGROU2.getTroubleShootingBGRAttr();
        BGROU2.getPricing();
        
         string str;
        str=BGROU2.ASSEMBLYWT;
        str=BGROU2.BRANDCODE;
        str=BGROU2.COMPINVSERTRK;
        str=BGROU2.COMPPROVIDE;
        str=BGROU2.CONSTBDYTST;
        str=BGROU2.CUSTOMSTATNO;
        str=BGROU2.HSNSACCODE;
        str=BGROU2.OPTIONCODE;
        str=BGROU2.PARTUOM;
        str=BGROU2.PC220;
        str=BGROU2.PC320;
        str=BGROU2.PC420;
        str=BGROU2.PNMODEL;
        str=BGROU2.PRESRATIO;
        str=BGROU2.RESPONSIBLE_ID;
        str=BGROU2.SALESPRICEGROUP;
        str=BGROU2.SETTINGMAXFACT;
        str=BGROU2.SHUTOFFMAXFACT;
        str=BGROU2.SOURCINGOPT;
        str=BGROU2.ASSEMBLYWTUOM;
        str=BGROU2.ATTRTEMPLATE;
        str=BGROU2.COMPDESCRIPTION;
        str=BGROU2.COMPLOTTRACK;
        str=BGROU2.CONSTACTTST;
        str=BGROU2.LOTTRACKCODE;
        str=BGROU2.PARTCLASS;
        str=BGROU2.PC210;
        str=BGROU2.PC310;
        str=BGROU2.PC410;
        str=BGROU2.PLANNER;
        str=BGROU2.PNSIZE;
        str=BGROU2.PROVIDE;
        str=BGROU2.SALESGROUP;
        str=BGROU2.SERIALTRACKCODE;
        str=BGROU2.SETTINGMINFACT;
        str=BGROU2.IINO;
        str=BGROU2.PC;
        str=BGROU2.PTC;
        str=BGROU2.OA;
        str=BGROU2.OB;
        str=BGROU2.OW;
        str=BGROU2.RGEUNT;
        str=BGROU2.ASSEMBLYWTUOM;
        str=BGROU2.SUPRS1;
        str=BGROU2.SPRINGCODE;
        str=BGROU2.TAGMAXACTPRES;
        str=BGROU2.TAGSPRGRANGE;
        str=BGROU2.SHLTSTBDYPSIG;
        str=BGROU2.SHUTOFFMINFACT;
        str=BGROU2.SHUTOFFMINFACT;
        str=BGROU2.SUPRSU;
        str=BGROU2.PARTREV;
        str=BGROU2.PARTNUMBER;
        str=BGROU2.CONTRACT;
        str=BGROU2.CATALOG_GROUP;
        str=BGROU2.SALES_PRICE_GROUP_ID;
        str=BGROU2.SOURCING_OPTION;
         str=BGROU2.HSN_SAC_CODE;
         str=BGROU2.PLANNER;
         str=BGROU2.CUSTOMS_STAT_NO;
         str=BGROU2.ENG_DESCRIPTION;
         str=BGROU2.ENG_LOTTRACK;
         str=BGROU2.ENG_PROVIDE;
         str=BGROU2.ENG_INV_SERIAL_TRACKING;
        str=BGROU2.CHAR_TEMPLATE;
        str=BGROU2.PART_UOM;
        str=BGROU2.OrificeSetting;
        str=BGROU2.Schedule;
        str=BGROU2.Schedule2;
        str=BGROU2.PC220;
        str=BGROU2.PC320;
        str=BGROU2.CHAR_TEMPLATE;
        str=BGROU2.CHAR_TEMPLATE;
        str=BGROU2.CHAR_TEMPLATE;
        
            
        
        BGROU2.ASSEMBLYWT ='Test';
        BGROU2.BRANDCODE ='Test';
        BGROU2.COMPINVSERTRK ='Test';
        BGROU2.COMPPROVIDE ='Test';
        BGROU2.CONSTBDYTST ='Test';
        BGROU2.CUSTOMSTATNO ='Test';
        BGROU2.HSNSACCODE ='Test';
        BGROU2.OPTIONCODE ='Test';
        BGROU2.PARTUOM ='Test';
        BGROU2.PC220 ='Test';
        BGROU2.PC320 ='Test';
        BGROU2.PC420 ='Test';
        BGROU2.PNMODEL ='Test';
        BGROU2.PRESRATIO ='Test';
        BGROU2.RESPONSIBLE_ID ='Test';
        BGROU2.SALESPRICEGROUP ='Test';
        BGROU2.SETTINGMAXFACT='Test';
        BGROU2.SHUTOFFMAXFACT ='Test';
        BGROU2.SOURCINGOPT ='Test';
        BGROU2.ASSEMBLYWTUOM='Test';
        BGROU2.ATTRTEMPLATE='Test';
        BGROU2.COMPDESCRIPTION='Test';
        BGROU2.COMPLOTTRACK ='Test';
        BGROU2.CONSTACTTST='Test';
        BGROU2.IINO ='Test';
        BGROU2.PC  ='Test';
        BGROU2.PTC ='Test';
        BGROU2.OA = 'Test';
        BGROU2.OB ='Test';
        BGROU2.OW ='Test';
        BGROU2.PC210 ='Test';
        BGROU2.PC310 ='Test';
        BGROU2.PC410 ='Test';
        BGROU2.LOTTRACKCODE ='Test';
        BGROU2.SALESGROUP ='Test';
        BGROU2.PARTCLASS ='Test';
        BGROU2.SERIALTRACKCODE ='Test';
        BGROU2.TEMPDEGR ='Test';
        BGROU2.PRESRATIO ='Test';
        BGROU2.GTAGPN ='Test';
        BGROU2.SETTING ='Test';
        BGROU2.SETTINGMINFACT ='Test';
        BGROU2.SHLTSTACTPSIG ='Test';
        BGROU2.SHLTSTBDYPSIGMX ='Test';
        BGROU2.TAGMAXSUPPRES ='Test';  
        BGROU2.OB250 ='Test';
        BGROU2.DocumentID ='Test';
        BGROU2.CONTRACT ='Test';
        BGROU2.PARTREV ='Test';        
        BGROU2.RGEUNT= 'Test';
        BGROU2.ASSEMBLYWTUOM ='Test';
        BGROU2.SUPRS1='Test';
        BGROU2.SPRINGCODE='Test';
        BGROU2.TAGMAXACTPRES='Test';
        BGROU2.TAGSPRGRANGE='Test';
        BGROU2.SHLTSTBDYPSIG='Test';
        BGROU2.SHUTOFFMINFACT='Test';
        BGROU2.SHUTOFFMINFACT='Test';
        BGROU2.SUPRSU='Test';        
        BGROU2.GMODEL='test';        
        BGROU2.REQDFLOWUOM='test';          
        BGROU2.SZC='test';
        BGROU2.QTY=0;        
        BGROU2.PARTMANAGEDIN='test';
        BGROU2.PARTNUMBER='test';
        BGROU2.PARTREV='test';
        BGROU2.NOTE='test';
        BGROU2.DESCRIPTION='test';
        BGROU2.getPartNumber();
  }
  
}