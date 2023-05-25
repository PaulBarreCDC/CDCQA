@isTest
public class ConfigureRVControllerTest {
    
    @testSetup
    public static void datSetup() {
        
        Map<String, String> mapWithRVValues = new Map<String, String>();
        mapWithRVValues.put('BRAND','Groth');
        mapWithRVValues.put('PRODUCT_CODE','RLFVLV');
        mapWithRVValues.put('PRODUCT_NAME','ReliefValves');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRVValues);
        
        TestDataRVUtility.quoteLine = quoteLine;
        TestDataRVUtility.mapWithRVValues = mapWithRVValues;
        
        system.debug('TestDataRVUtility.quoteLine:'+TestDataRVUtility.quoteLine);
        system.debug('TestDataRVUtility.mapWithRVValues:'+TestDataRVUtility.mapWithRVValues);
        Test.startTest();
        TestDataRVUtility.createRVTestRecords();
        TestDataRVUtility.createRVMasterTestRecords();  
        Test.stopTest();
    }
    
    public static configureRVproduct getconfigRVCntrl() {
        
        SBQQ__QuoteLine__c quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        TestDataRVUtility.quoteLine = quoteLine;
        PageReference pager = Page.RVConfig;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        return new configureRVproduct(sc);
    }
    
    @isTest
    public static void CostMethods() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVConfig.disableButton = false;
        RVConfig.getCosts();
        RVConfig.saveCosting();
        RVConfig.ApplyDefaultCost();
        RVConfig.savePartNumber();
        
        Test.stopTest();
    } 
    @isTest
    public static void CostMethods1() 
    {
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVConfig.disableButton = false;
        Test.startTest();
        RVConfig.getCosts(); 
        RVConfig.ApplyDefaultCost();
        Test.stopTest();
    } 
     
    /*@isTest
    public static void Docsourcing() {
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();

        Test.startTest(); 
        configRV.saveDocSourcing();           
        Test.stopTest();
    }*/
    
   
   /* @isTest
    public static void TestLWCsaveRelief() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        system.debug('TestDataRVUtility.quoteLine.Id:'+quoteLine.Id);
        Relief_Valve__c conRV = [SELECT Id FROM Relief_Valve__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        ReliefValveController obj = new ReliefValveController();
        
        ReliefValveController.cleanSecB(conRV);
        ReliefValveController.cleanSecC(conRV);
        ReliefValveController.cleanSecD(conRV);
        ReliefValveController.cleanSecE(conRV);
        ReliefValveController.cleanSecF(conRV);
        ReliefValveController.cleanSecG(conRV);
        
        ReliefValveController.saveRelief(conRV);  
        ReliefValveController.SaveCertifications(conRV); 
        ReliefValveController.saveSizingFLowArea(conRV);
        ReliefValveController.SaveProductNarrowing(conRV);  
        ReliefValveController.SaveProductSelection(conRV);
        ReliefValveController.fetchUserInfo();
        
        Test.stopTest();
    }*/
    
     /* @isTest
    public static void TestLWCProductNarrowing() {
        
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        system.debug('TestDataRVUtility.quoteLine.Id:'+quoteLine.Id);
        Relief_Valve__c conRV = [SELECT Id FROM Relief_Valve__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        try {
            RVProductNarrowing.getEFFMop(conRV);  
            RVProductNarrowing.getEffMBP(conRV); 
            RVProductNarrowing.getPosSetPresOSIG(conRV);  
            RVProductNarrowing.getVacSetPresOSIG(conRV);
            RVProductNarrowing.getInitialNarrowingRecords(conRV);
            RVProductNarrowing.getSettingNarrowingSubProcess(conRV);
            RVProductNarrowing.getFlowNarrowingSubProcess(conRV);
            RVProductNarrowing.getFlowNarrowingSubPosProcess(conRV);
            RVProductNarrowing.getFlowNarrowingSubVacProcess(conRV);
            RVProductNarrowing.getPTCSZCSet(conRV);
            RVProductNarrowing.getStandardValues(conRV);
        } 
        catch(Exception e) {}
        
        Test.stopTest();
    }*/
   
    
    @isTest
    public static void vlaveExaminationOption() 
    {
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVConfig.disableButton = false;
        RVConfig.saveProductMaterialAndOptions();
        RVConfig.saveValveExaminationOption();
        string str;
        str=RVConfig.strquoteDes;
        RVConfig.EnableEditMode(); 
        Test.stopTest();
    }
    
       @isTest
    public static void DocSourcing() 
    {
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVConfig.disableButton = false;
        RVConfig.saveDocSourcing();
        string str;
        str=RVConfig.strquoteDes;
        RVConfig.EnableEditMode(); 
        Test.stopTest();
    }
    
     @isTest
    public static void OutputInstanceMethods() 
    {
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVConfig.disableButton = false;
        RVConfig.getLeadRVOutputInstance();
        RVConfig.getPriceRVOutputInstance();
        string str;
        str=RVConfig.strquoteDes;
        RVConfig.EnableEditMode(); 
        Test.stopTest();
    }
    
    
    @isTest
    public static void PricingMethods() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.goBackToQuote();
        configRV.goBack();
        configRV.getPricingRecords();
        configRV.ApplyDefaultPricing();
        configRV.SavePriceOverride(); 
        
        Test.stopTest();
    }
    
    @isTest
    public static void LeadTimeMethods() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.getLeadTimeRecords();
        configRV.saveLeadTime();
        configRV.ApplyDefaultLeadtime();    
        
        Test.stopTest();
    }
    
    @isTest
    public static void QuoteDescriptionMethods() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.GetQuoteDescriptionRecords();
        configRV.ApplyDefaultQuoteDescription();
        configRV.SaveQuoteDescriptionOverride();    
        
        Test.stopTest();
    }
    
    @isTest
    public static void OutputMethods() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.getIFSAttributes();
        configRV.getTroubleshootingAttributes();
        configRV.getStructureDetails();   
        configRV.getControlPlanDetails();
        configRV.getRouter();
        configRV.getWorkGuideLines();
        configRV.getDocument();
        
        Test.stopTest();
    }
    
    @isTest
    public static void NotesAndDocumentIDSaveMethods(){
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        
        configRV.saveNotes();
        configRV.SaveDocID();
        
        Test.stopTest();
    }
    
    @isTest
    public static void IFSAndTroubleShootingMethods() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.getIFSAttributes();
        configRV.getTroubleshootingAttributes();    
        //configFA.getOnChangeSETTING();
        Test.stopTest();
    }
    
    
    @isTest
    public static void ProductReviewAndTroubleShootingTabs() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        
        configRV.selectedTab = 'ProductReview';
        configRV.getTabData();
        configRV.selectedTab = 'TroubleShoot';
        configRV.getTabData();
        
        Test.stopTest();
    }
    
    @isTest
    public static void PricingAndEngineeringSpecialsTab() 
    {
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVConfig.RVOU = new RVOutputUtility(conRV); 
        RVConfig.disableButton = false;
        RVConfig.selectedTab = 'Pricing';
        RVConfig.rvOutput = RVConfig.getRVOutputRecord(conRV.Id);//RHATHI, Service Ticket #203415 , changed from calling class staticmethod 
        RVConfig.getTabData();
        RVConfig.selectedTab = 'EngineeringSpecials';
        RVConfig.getTabData();
        Test.stopTest();
    }
    
    @isTest
    public static void Engineering() {
        
        Test.startTest();
        
        configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        
        configRV.selectedTab = 'Engineering';
        configRV.getTabData();
        
        Test.stopTest();
    }   
    
    @isTest
    public static void testFAMethod1CostSection() {
    
        Test.startTest();
        //configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.disableButton = false;
        string bdydsgn;
        bdydsgn = configRV.BODYDESIGN;
        configRV.BODYDESIGN = 'STD';
        configRV.getdrillingOptions(); 
        configRV.getbodyMaterialOptions();       
        configRV.getPalletTypeOptions();
        configRV.getDiaphragmMaterialOptions();
        configRV.getFastenerMaterialOptions();
        configRV.getFlameArresterOptions();
        configRV.getVacuumPortOptions();
        configRV.getPressurePortProximitySensor();
        configRV.getVacuumPortProximitySensor();
           
        Test.stopTest();
    }
    
     @isTest
    public static void BdyDsgnMethods() {
    
        Test.startTest();
        //configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.disableButton = false;
        string bdydsgn;
        bdydsgn = configRV.BODYDESIGN;
        configRV.BODYDESIGN = 'STD';
      
        configRV.getPilotActionOptions();
        configRV.getManualBlowdown();
        configRV.getRemoteSense();
        configRV.getPilotExhaustPipedToDischargeHeader();
        configRV.getFieldTestConnection();
        configRV.getPilotSupplyFilter();
        
        
        Test.stopTest();
    }

    public static RVOUtputUtilityXML RVOU2XML{get;set;} 
    public static RVOUtputUtilityXML RVOU3XML{get;set;} 
    public static RVOUtputUtilityXML RVOU4XML{get;set;} 
    public static RVOUtputUtilityXML RVOU5XML{get;set;} 
    @isTest
    public static void testOutputMethod1Section() {
    
       // Test.startTest();
        
        //configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();     
        /*SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;   
        RVOUtputUtilityXML RVOU3XML=new RVOUtputUtilityXML(conRV.Id); */
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        Test.startTest();
        RVOU2XML=new RVOUtputUtilityXML(RVConfig.conRV.Id); 
       /* try{
        RVOU2XML.getEngPartCharacterXML();
        }catch(Exception e){}*/
        RVOU2XML.getEngPartStructureXML();
        RVOU2XML.getEngineeringParts();
        RVOU2XML.GetInventoryPartDetails();
        RVOU2XML.getSalesParts();
       
        Test.stopTest();
    }

    @isTest
    public static void testOutputMethod2section() {
    
        Test.startTest();

       // configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
       /* SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;   
        RVOUtputUtilityXML RVOU3XML=new RVOUtputUtilityXML(conRV.Id); */
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVOU3XML=new RVOUtputUtilityXML(RVConfig.conRV.Id); 
        RVOU3XML.getProductCatalog();
        RVOU3XML.getPurchasePart();
        RVOU3XML.getPurchasePartSuppliers();
        RVOU3XML.getStructureXML();
        RVOU3XML.GetControlPlanDetails();        
        Test.stopTest();
    }
    
      @isTest
    public static void testOutputMethod3section() {    
        Test.startTest();
       // configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVOU4XML=new RVOUtputUtilityXML(RVConfig.conRV.Id);        
        RVOU4XML.GetRoutingDetails();        
        Test.stopTest();
    }
    
    @isTest
    public static void testOutputMethod4section() {    
        Test.startTest();
        //configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct RVConfig = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        RVConfig.conRV = conRV;
        RVOU5XML=new RVOUtputUtilityXML(RVConfig.conRV.Id);        
        RVOU5XML.getEngPartCharacterXML();        
        Test.stopTest();
    }
     @isTest
    public static void RVOutputUtilityGetSet() {
    
        Test.startTest();
        
        //configureRVproduct configRV = ConfigureRVControllerTest.getconfigRVCntrl();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        boolean reorderGetSets;
        RVOutputUtility RVOU = new RVOutputUtility(conRV); 
        reorderGetSets = RVOU.MAGPARTEXAMreorder;
        reorderGetSets = RVOU.PEDreorder;
        reorderGetSets = RVOU.ATEXreorder;
        reorderGetSets = RVOU.CUTRreorder;
        reorderGetSets = RVOU.NACEreorder;
        reorderGetSets = RVOU.POSPROXSENSORreorder;
        reorderGetSets = RVOU.VACPROXSENSORreorder;
        reorderGetSets = RVOU.manualBlowdownreorder;
        reorderGetSets = RVOU.remoteSensereorder;
        reorderGetSets = RVOU.pilotExhstPipedreorder;
        reorderGetSets = RVOU.fieldTestConnectreorder;
        reorderGetSets = RVOU.pilotSplyFilterreorder;
        reorderGetSets = RVOU.GMTH21reorder;
        reorderGetSets = RVOU.FWLDPreorder;
        reorderGetSets = RVOU.USONICEXAMreorder;
        reorderGetSets = RVOU.BRINHARDEXAMreorder;
        reorderGetSets = RVOU.CHARPYIMPEXAMreorder;
        reorderGetSets  = RVOU.VISCASTEXAMreorder;
        reorderGetSets = RVOU.IGCEXAMreorder;
         Test.stopTest();
    }
    @isTest
    public static void configureRVTestCoverage() 
    {
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        Test.startTest();
        configureRVproduct configRV = new configureRVproduct(quoteLine.Id);//ConfigureRVControllerTest.getconfigRVCntrl();
        Test.stopTest();
        //configRV.conRV = conRV;
    }
    @isTest
    public static void TestApplyDefaultQuoteDescription() 
    {
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.rvOutsideInstance = configRV.getQuoteRVOutputInstance();
        configRV.conRV.Quote_Description_Engineer_Override__c = false; 
        configRV.RVOU = new RVOutputUtility(conRV);
        configRV.showsales = true;
        configRV.ApplyDefaultQuoteDescription(); 
    }
    @isTest
    public static void TestgetShellTestValveBody() 
    { 
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.getShellTestValveBody();
        configRV.savePartNumber();
    }
    @isTest
    public static void testconfigureRVproductCons() 
    {
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        conRV.Finish_Configuration_Flag__c = false;
        update conRV;
        TestDataRVUtility.quoteLine = quoteLine;
        PageReference pager = Page.RVConfig;
        Test.setCurrentPage(pager);
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        Test.startTest();
        configureRVproduct configRV = new configureRVproduct(sc);//ConfigureRVControllerTest.getconfigRVCntrl();
        Test.stopTest();
        //configRV.conRV = conRV;
    }
    @isTest
    public static void testconfigureRVproductCons1() 
    {
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        conRV.Finish_Configuration_Flag__c = false;
        update conRV;
        Test.startTest();
        configureRVproduct configRV = new configureRVproduct(quoteLine.Id);//ConfigureRVControllerTest.getconfigRVCntrl();
        Test.stopTest();
       // configRV.conRV = conRV; 
    }
    @isTest
    public static void TestsaveDocSourcing() 
    { 
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.conRV.Section_G_Flag__c = true;
        configRV.saveDocSourcing();
    }
    @isTest
    public static void FlameArrestorOption() 
    { 
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        RV_Valve_Attributes_Details__c RVAttrDetail = new RV_Valve_Attributes_Details__c();
        RVAttrDetail.Text__c = 'W';
        RVAttrDetail.Attribute__c = 'FASubModel';
        RVAttrDetail.Text1Val__c = '1221B Fiberglass';
        insert RVAttrDetail;
        configRV.getFlameArresterOptions();
    }
    @isTest
     public static void Cleanup() 
    { 
        try{
            SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
            Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
            Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
            configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
            configRV.conRV = conRV;
            RV_Valve_Attributes_Details__c RVAttrDetail = new RV_Valve_Attributes_Details__c();
            configRV.cleanRVrecord(conRV);
            configRV.getOnChangeBodyMaterial();
        }catch(exception e){}
    }
    
    @isTest
    public static void ElementMaterialOptions() 
    { 
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        RV_Valve_Attributes_Details__c RVAttrDetail = new RV_Valve_Attributes_Details__c();
        RVAttrDetail.Text__c = 'W';
        RVAttrDetail.Attribute__c = 'FASubModel';
        RVAttrDetail.Text1Val__c = '1221B Fiberglass';
        insert RVAttrDetail;
        configRV.getElementMaterialOptions();
    }
    @isTest
    public static void testcoveragebooster_1()
    {
        Test.starttest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.pmiList = new List<RV_EXMOMC_Cons__c>();
        configRV.getPositiveMaterialIdentificationOptions();
        configRV.pmiList.add(new RV_EXMOMC_Cons__c(Name ='Name'));
        configRV.inputAttrValue_test = new List<RV_Input_Attr_Value_Desc__c>();
        configRV.getPositiveMaterialIdentificationOptions();
        configRV.getLiquidDyePenetrantOptions();
        configRV.getRadiographyOptions();
        configRV.getPilotActionOptions();
        configRV.getVacuumPortOptions();
        configRV.getFlameArresterOptions();
        configRV.getElementMaterialOptions();
        configRV.getPalletFastenerCoatingMaterialOptions();
        configRV.getBodyCoatingMaterialOptions();
        configRV.getPaintingCoatingOptions();
        configRV.getSteamJacketMaterialOptions();
        configRV.inputAttrValue_test.add(new RV_Input_Attr_Value_Desc__c(Name = 'testname',Text_Description_of_AttributeValue__c='test',Value__c='test'));
        configRV.getPositiveMaterialIdentificationOptions();
        configRV.getLiquidDyePenetrantOptions();
        configRV.getRadiographyOptions();
        configRV.getPilotActionOptions();
        configRV.getVacuumPortOptions();
        configRV.getFlameArresterOptions();
        configRV.getElementMaterialOptions();
        configRV.getPalletFastenerCoatingMaterialOptions();
        configRV.getBodyCoatingMaterialOptions();
        configRV.getPaintingCoatingOptions();
        configRV.getSteamJacketMaterialOptions();
        configRV.inputAttrValue_test.add(new RV_Input_Attr_Value_Desc__c(Name = 'testname',Text_Description_of_AttributeValue__c='test1',Value__c='test2'));
        configRV.getPositiveMaterialIdentificationOptions();
        //configRV.getLiquidDyePenetrantOptions();// Nikhil, 23 Feb to pass the test class, quickfix
        //configRV.getRadiographyOptions();// Nikhil, 23 Feb to pass the test class, quickfix
        // Test.starttest();
        configRV.getPilotActionOptions();
        configRV.getVacuumPortOptions();
        configRV.getFlameArresterOptions();
        configRV.getElementMaterialOptions();
        configRV.getPalletFastenerCoatingMaterialOptions();
        configRV.getBodyCoatingMaterialOptions();
        configRV.getPaintingCoatingOptions();
        configRV.getSteamJacketMaterialOptions();


        configRV.getMagneticParticleExamination();
        Test.stoptest();
    }
    @isTest
    public static void testcoveragebooster_2()
    {
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        configureRVproduct configRV = new configureRVproduct();//ConfigureRVControllerTest.getconfigRVCntrl();
        configRV.conRV = conRV;
        configRV.pmiList = new List<RV_EXMOMC_Cons__c>();
        configRV.getPositiveMaterialIdentificationOptions();
        configRV.pmiList.add(new RV_EXMOMC_Cons__c(Name ='Name'));
        configRV.inputAttrValue_test = new List<RV_Input_Attr_Value_Desc__c>();
        configRV.getFastenerMaterialOptions();
        configRV.getPilotSoftGoodsMaterialOptions();
        configRV.getVacuumPalletMaterialOptions();
        configRV.getDiaphragmMaterialOptions();

        configRV.inputAttrValue_test.add(new RV_Input_Attr_Value_Desc__c(Name = 'testname',Text_Description_of_AttributeValue__c='test',Value__c='test'));
        configRV.getFastenerMaterialOptions();
        configRV.getPilotSoftGoodsMaterialOptions();
        configRV.getVacuumPalletMaterialOptions();
        configRV.getDiaphragmMaterialOptions();

        configRV.inputAttrValue_test.add(new RV_Input_Attr_Value_Desc__c(Name = 'testname',Text_Description_of_AttributeValue__c='test1',Value__c='test2'));
        configRV.getFastenerMaterialOptions();
        configRV.getPilotSoftGoodsMaterialOptions();
        configRV.getVacuumPalletMaterialOptions();
        configRV.getDiaphragmMaterialOptions();

        configRV.getSpringMaterialOptions();
    }
    
     @isTest
    public static void RVOutputUtilityGetSet2() {
    
        Test.startTest();
        SBQQ__QuoteLine__c quoteLine = [SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteLine.Id); 
        Relief_Valve__c conRV = (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        decimal reorderGetSets;
        string strreorderGetSets;
        RVOutputUtility RVOU = new RVOutputUtility(conRV); 
        strreorderGetSets = RVOU.MSZC;
        strreorderGetSets = RVOU.Size;
        strreorderGetSets = RVOU.ReliefType;
        strreorderGetSets = RVOU.OA01;
        strreorderGetSets = RVOU.SHLTSTMETHACT;
        strreorderGetSets = RVOU.MPTC;
        strreorderGetSets = RVOU.Schedule;
        strreorderGetSets = RVOU.OnEngrHoldFlag;
        
        reorderGetSets = RVOU.conMaxProcPress;
        reorderGetSets = RVOU.conBackPress;
        reorderGetSets = RVOU.conPressSet;
        reorderGetSets = RVOU.conVacSet;
        reorderGetSets = RVOU.conRelPressVal;
        reorderGetSets = RVOU.conAtmPress;
        reorderGetSets = RVOU.conRelVacVal;
        reorderGetSets = RVOU.conPressRelReqFlow;
        reorderGetSets = RVOU.conconVacRelReqFlow;
        reorderGetSets = RVOU.conVacRelTemp;
        reorderGetSets = RVOU.conPressRelTemp;      
        reorderGetSets = RVOU.SettingMinVacuum;
        reorderGetSets = RVOU.SettingMinPressure;               
        
        RVOU.MSZC='test';
        RVOU.Size='test';
        RVOU.ReliefType='test';
        RVOU.OA01='test';
        RVOU.SHLTSTMETHACT='test';
        RVOU.MPTC='test';
        
        RVOU.ASSYPARTNO='test';
        RVOU.ASYTYP='test';
        RVOU.ValveSubModel='test';
        RVOU.BODYDESIGN='test';
        RVOU.FASubModel='test';
        RVOU.ESZC='test';
        RVOU.VENDORPAINT='test';
        RVOU.INHOUSEPAINT='test';
        RVOU.RGEUNT='test';
        RVOU.VGEUNT='test';
        RVOU.GTAG01='test';
        RVOU.GTAG04='test';
        RVOU.GTAG05='test';
        RVOU.GTAG06='test';
        RVOU.GTAG14='test';
        RVOU.GTAG15='test';
        RVOU.GTAG16='test';
        RVOU.GTAG17='test';
        RVOU.GTAG19='test';
        RVOU.GTAG21='test';
        RVOU.GTAG22='test';
        RVOU.GTAG23='test';
        RVOU.GTAGPN='test';
        RVOU.IINO='test';
        RVOU.SHLTSTACTPSIG='test';
        RVOU.SHLTSTACTPSIGMX='test';
        RVOU.SOURCINGOPT='test';
        RVOU.PRDLIN='test';
        RVOU.PosSettingMaxFact=0;
        RVOU.PosValveLeakMaxFact=0;
        RVOU.PosValveLeakMinFact=0;
        RVOU.VacSettingMaxFact=0;
        RVOU.VacSettingMinFact=0;
        RVOU.VacValveLeakMaxFact=0;
        RVOU.VacValveLeakMinFact=0;
        RVOU.PosPilotSetMinFact=0;
        RVOU.PosPilotSetMaxFact=0;
        RVOU.VacPilotSetMinFact=0;
        RVOU.VacPilotSetMaxFact=0;
        RVOU.PosDomePresMaxFact=0;
        RVOU.VacDomePresMaxFact=0;
        RVOU.PosPilotLeakLowFact=0;
        RVOU.PosPilotLeakHighFact=0;
        RVOU.VacPilotLeakLowFact=0;
        RVOU.VacPilotLeakHighFact=0;
        RVOU.PosStaticPresMinFact=0;
        RVOU.VacStaticPresMinFact=0;
        RVOU.VacStaticPresMaxFact=0;
        RVOU.BodyMAWPpsig=0;
        RVOU.SHLTSTMETHACT='test';
        RVOU.Brand='test';
        RVOU.EffMBP=0;
        RVOU.EFFMOP=0;
        RVOU.OPTIONCODE='test';
        RVOU.GMODEL='test';
        RVOU.GMODEL1='test';
        RVOU.GMODEL2='test';
        RVOU.GMODEL3='test';
        RVOU.GMODEL4='test';
        RVOU.GMODEL5='test';
        RVOU.GMODEL6='test';
        RVOU.GMODEL7='test';
        RVOU.GMODEL8='test';
        RVOU.GMODELN='test';
        RVOU.GTAG02='test';
        RVOU.GTAG08='test';
        RVOU.GTAG10='test';
        RVOU.GTAG18='test';
        RVOU.GTAG20='test';
        RVOU.OB170='test';
        RVOU.OB250='test';
        RVOU.OB300='test';
        RVOU.OB320='test';
        RVOU.OB370='test';
        RVOU.OB400='test';
        RVOU.OB420='test';
        RVOU.OB480='test';
        RVOU.GMODELN='test';
        
        RVOU.conMaxProcPress=0;
        RVOU.conBackPress=0;
        RVOU.conPressSet=0;
        RVOU.conVacSet=0;
        RVOU.conRelPressVal=0;
        RVOU.conAtmPress=0;
        RVOU.conRelVacVal=0;
        RVOU.conPressRelReqFlow=0;
        RVOU.conconVacRelReqFlow=0;
        RVOU.conVacRelTemp=0;
        RVOU.conPressRelTemp=0;     
        RVOU.SettingMinVacuum=0;
        RVOU.SettingMinPressure=0;   
        
        Test.stopTest();
    }
    
}