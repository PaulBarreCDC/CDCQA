@isTest
public class ConfigureBGRControllerTest 
{
    
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
    
    public static configureBGRProduct getConfigBGRCntrlQ() 
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
        TestDataBGRUtility.createBGRTestRecordss();
        TestDataBGRUtility.createBGRMasterTestRecordsQ();     
        PageReference pager = Page.ConfigBGR;
        Test.setCurrentPage(pager);    
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));     
        BGR__c conBGR = [SELECT Id,Quantity__c FROM BGR__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        //system.debug('conBGR:'+conBGR);        
        System.debug('quoteId...'+quoteLine.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);       
        return new configureBGRProduct(sc);
    }
     @isTest
    public static void getConfigBGRCntrlQuote() 
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
        TestDataBGRUtility.createBGRTestRecordss();
        TestDataBGRUtility.createBGRMasterTestRecordsQ();
        PageReference pager = Page.ConfigBGR;
        Test.setCurrentPage(pager);    
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));     
        BGR__c conBGR = [SELECT Id,Quote_Line__c FROM BGR__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        //system.debug('conBGR:'+conBGR);        
        System.debug('quoteId...'+quoteLine.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);     
        
        configureBGRProduct cbr = new configureBGRProduct(sc);
        configureBGRProduct ss= new configureBGRProduct(quoteLine.Id);
       
    }
    
    @isTest
    public static void testBGRCostSection() 
    {
        Test.startTest();    
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();  
        
        configBGR.SaveDocID();
        //configBGR.configureBGRProduct(quoteLine.Id);
        //configBGR.saveCosting();
        //configBGR.ApplyDefaultCost();
        Test.stopTest();
    }
    
     @isTest
    public static void testBGRExtraCostSection() 
    {
        
        Test.startTest();    
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();    
        configBGR.getCosts();
        configBGR.saveNotes();
        Test.stopTest();
        
    }   
    
    @isTest
    public static void testBGRPriceSection() 
    {
        Test.startTest();  
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        configBGR.getPricinglist();
        configBGR.selectedTab = 'PricingTab';
        //configBGR.getTabData();
        configBGR.ApplyDefaultPricing();
        configBGR.SavePriceOverride();
        Test.stopTest();
    }
    
    @isTest
    public static void testBGRLeadTimeSection() 
    {     
        Test.startTest();    
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        configBGR.selectedTab = 'ProductReview';
        configBGR.getLeadBGROutputInstance();        
        configBGR.GetLeadTimeRecs();
        configBGR.ApplyDefaultLeadtime();
        configBGR.SaveLeadTimeOverride();      
        Test.stopTest();
    }
    
    @isTest
    public static void testBGRQuoteDescriptionSection() 
    {   
        Test.startTest();      
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();     
        configBGR.GetQuoteDescriptionRec();
        //configBGR.configureBGRProduct();
        configBGR.selectedTab = 'Quote';
        //configBGR.getTabData();
        configBGR.ApplyDefaultQuoteDescription();
        configBGR.SaveQuoteDescriptionOverride();
        Test.stopTest();
    }
    
     @isTest
    public static void testBGRFinishSection() 
    {   
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        configBGR.saveProductMaterials();
         configBGR.showPopup();
         configBGR.saveValveExamination();
        configBGR.EnableEditMode();
        configBGR.saveProductSelection();
        //configBGR.saveDocSourcing();
        configBGR.showSectionB();
        //configBGR.SaveCertifications();
       // configBGR.saveRecommendedProcessInformation();        
        configBGR.GetTroubleShootingAttributes();        
        string str;
        str=configBGR.ASYTYP;
        str=configBGR.GMODEL;
        str=configBGR.BRANDCODE;
        str=configBGR.GTAGPN;
        str=configBGR.ASSEMBLYWT;
        str=configBGR.PRDLIN;
        str=configBGR.RTPRS1;        
        str=configBGR.COMPINVSERTRK;
        str=configBGR.strquoteDes;
       // str=configBGR.IINO;       
        //str=configBGR.PC;
        //str=configBGR.PTC;
        //str=configBGR.RGEUNT;
        //str=configBGR.GPRSC1;
        //str=configBGR.SETINWC;
        //str=configBGR.SETTINGMAX;
        //str=configBGR.SETTINGMIN;
        //str=configBGR.SHLTSTACTPSIG;
        //str=configBGR.SHLTSTACTPSIGMX;
        //str=configBGR.SHLTSTBDYPSIG;
        //str=configBGR.SHLTSTBDYPSIGMX;
        //str=configBGR.SHUTOFFMIN;
        //str=configBGR.SHUTOFFMAX;
        //str=configBGR.SPRINGCODE;
        //str=configBGR.TAGMAXACTPRES;
        //str=configBGR.TAGSPRGRANGE;
        //str=configBGR.ASSEMBLYWTUOM;
        //str=configBGR.ATMPRESPSIA;
        //str=configBGR.ATTRTEMPLATE;
        //str=configBGR.COMPDESCRIPTION;
        //str=configBGR.SUPRS1;
        //str=configBGR.SUPRSU;         
        configBGR.goBack();
        configBGR.generatePartNumber();
        Test.stopTest();
    }
    
     @isTest
    public static void testBGRManufacturingOutputSection() 
    {
        
        Test.startTest();
        
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        configBGR.selectedTab = 'EngineeringTab';
        //configBGR.getTabData();
        configBGR.GetRoutingDetails();        
        configBGR.GetControlPlanDetails();
        configBGR.getGuildeline();
        configBGR.getProDoc();
        configBGR.getStructure();
        
        Test.stopTest();
    }
    
     @isTest
    public static void testBGRDynamicPicklistSection() 
    {
        
        Test.startTest();
        
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        
        configBGR.selectedTab = 'Notes';
        //configBGR.getTabData();
        configBGR.getLeadBGROutputInstance();
        configBGR.getBodyMaterial();
        configBGR.getSoftGoodsMaterial();
        configBGR.getConnection();
        configBGR.getTypes1();
        configBGR.getTypes2();
        configBGR.getTypes3();
        configBGR.getTypes4();
        configBGR.getTypes5();
        configBGR.getTypes6();
        configBGR.getTypes7();
        configBGR.getTypes8();        
        
        Test.stopTest();
    }
    
     @isTest
    public static void testFinishbuttonSection() 
    {
        Test.startTest();
        
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        
        configBGR.saveDocSourcing();
        configBGR.getPartNum();
        Test.stopTest();
    }
    
    @isTest
    public static void testSaveMethodsSection() 
    {
        
        Test.startTest();
        
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        
        List<string> list1=new List<String>();
        list1=configBGR.notValidStatusForChng;        
        configBGR.saveRelief();   
        configBGR.saveSetting();          
        configBGR.saveAtm();   
        configBGR.saveRelief(); 
        configBGR.saveCertificate();        
        configBGR.saveConbgr();
        configBGR.SupplyGas();
       
        
        Test.stopTest();
    }
    
    @isTest
    public static void testExtraMethodsSection() 
    {
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrl();
        List<string> list1=new List<String>();
        list1=configBGR.notValidStatusForChng; 
        //BGROutputUtility BGRO = new BGROutputUtility();
        //BGRO.getPartNumber();
        configBGR.goBackToQuote() ;
        configBGR.cleanSecC();
        configBGR.cleanSecD();
        configBGR.TempUnit();
        configBGR.ConSCFH();
        configBGR.saveSectionB();
        configBGR.showSectionB();
        configBGR.cleanSecB();
        string str=configBGR.setBlankForNull('a');
        Test.stopTest();
    }
    
    @isTest
    public static void testElseMethodsSection() 
    {
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrlQ();
        configBGR.getPricinglist();
        Test.stopTest();
    }
     
     @isTest
    public static void testElseCond() 
    {
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrlQ();
        configBGR.conBGR.Quantity__c=1;
        configBGR.saveProductMaterials();
        configBGR.saveCertificate();
        configBGR.ApplyDefaultPricing();
        configBGR.SavePriceOverride();
        Test.stopTest();
    }
     @isTest
    public static void testElseCondEX() 
    {
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRControllerTest.getConfigBGRCntrlQ();
        configBGR.saveDocSourcing();
        Test.stopTest();
    }
    
    @isTest 
    public static void handleBlanketGasRegulatorController() 
    {
        Test.startTest();        
        configureBGRProduct cBGRProd=getConfigBGRCntrlQ();
        BGR__c conBGR=cBGRProd.conBGR;
        String quoteLineId=conBGR.Quote_Line__c;
        String quoteId=[select SBQQ__Quote__c from SBQQ__QuoteLine__c where Id =: quoteLineid LIMIT 1].SBQQ__Quote__c;
        BGR__c bgrRec=null;
        try{
        bgrRec= BlanketGasRegulatorController.handleNarrowSelection(conBGR);
        }catch(Exception e){}try{
        BlanketGasRegulatorController.formAccessibilityWrapper fW=BlanketGasRegulatorController.fetchFormAccessibility(quoteLineId);
        }catch(Exception e){}try{
        bgrRec= BlanketGasRegulatorController.saveRelief(conBGR);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.SupplyGas(conBGR);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.showSectionB(conBGR);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.saveSectionB(conBGR);
        }catch(Exception e){}try{
        List<BlanketGasRegulatorController.SelectOption> lst=BlanketGasRegulatorController.saveCertificate(conBGR,quoteLineId);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.saveProductSelection(conBGR);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.saveProductMaterials(conBGR);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.saveValveExamination(conBGR);
        }catch(Exception e){}try{
        bgrRec=BlanketGasRegulatorController.saveDocSourcing(conBGR,quoteId);
        }catch(Exception e){}try{
        user oUser=BlanketGasRegulatorController.fetchUserInfo();
        }catch(Exception e){}
        Test.stopTest();
    }
}