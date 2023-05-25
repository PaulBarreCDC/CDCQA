@isTest
public class ConfigHolderControllerTest {
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
        
        ConfigHolderControllerTest.configValues();
        
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataUtility.createHoldersTestRecords();
        TestDataUtility.createHoldersMasterTestRecords();
    }
    
    public static ConfigHolderController getConfigHolderCntrl() {
        
        /*        
ConfigHolderControllerTest.configValues();

system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
TestDataUtility.createHoldersTestRecords();
TestDataUtility.createHoldersMasterTestRecords();
*/
        
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
    public static void testHolderRuptureSection() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        List<string> strList = new List<String>();
        strList.add('test');
        configHld.notValidStatusForChng = strList;
        configHld.selectedBotingClassDesc = 'test';
        configHld.size = '1000';
        configHld.errorMessage = 'NA';
        configHld.holderSizeDesc = 'test';
        configHld.strURL = 'www.google.com';
        configHld.editModeLable = 'Edit';
        configHld.selectedBrandSize = 'test';
        configHld.EnableEditMode();
        configHld.editModeLable = 'Cancel';
        configHld.EnableEditMode();
        
        configHld.pageError = true;
        configHld.redirectToErrorPageDuringError();
        configHld.pageError = false;
        configHld.redirectToErrorPageDuringError();
        configHld.handleSZCChange();
        configHld.ruptureDiscPr = 'test';
        configHld.handleRDProductChange();
        configHld.handleSeatChange();
        configHld.conHolder.Rupture_Disc_Burst_Pressure_Units__c = null;
        configHld.conHolder.Rupture_Disc_Burst_Temperature_Units__c = null;
        configHld.saveRuptureDiscSpecification();
        
        configHld.conHolder.Rupture_Disc_Burst_Pressure__c = 0;
        configHld.conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg F';
        configHld.conHolder.Rupture_Disc_Burst_Temperature__c = 72;
        configHld.saveRuptureDiscSpecification();
        
        configHld.conHolder.Rupture_Disc_Burst_Pressure__c = 0;
        configHld.conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg F';
        configHld.conHolder.Rupture_Disc_Burst_Temperature__c = -322;
        configHld.saveRuptureDiscSpecification();
        
        configHld.conHolder.Rupture_Disc_Burst_Pressure__c = 0;
        //configHld.conHolder.Rupture_Disc_Burst_Pressure_Units__c = 'barg1';
        configHld.conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg A';
        configHld.conHolder.Rupture_Disc_Burst_Temperature__c = 1000;
        configHld.saveRuptureDiscSpecification();
        
        configHld.conHolder.Rupture_Disc_Burst_Pressure__c = 0;
        configHld.conHolder.Rupture_Disc_Burst_Pressure_Units__c = 'barg1';
        configHld.saveRuptureDiscSpecification();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderCertificationSection() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.saveCertifications();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHoldergoBack() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.goBack();
        configHld.clearMidFlangeSection();
        configHld.handleOutletMaterialChange();
        
        Test.stopTest();
    }
    @isTest
    public static void testAssigningHolderValues() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.selectedInletMaterial = 'test';
        configHld.inletSectionFlag = true;
        configHld.holddownRingSectionFlag = true;
        configHld.clampSectionFlag = true;
        configHld.nutSectionFlag = true;
        configHld.selectedBotingClass = 'A1';
        configHld.excessFlowMFLGValveFlag = true;
        configHld.excessFlowMFLGValveSelectOptions();
        configHld.conHolder.ATEX_Certificate__c = true;
        configHld.conHolder.NACE_Compliance__c = 'MR0175';
        configHld.outletMaterialSelectOptions();
        configHld.inletMaterialSelectOptions();
        Test.stopTest();
        
    }
    
    @isTest
    public static void testHolderMaterialSelectOptions() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.conHolder.ATEX_Certificate__c = false;
        configHld.inletMaterialSelectOptions();
        configHld.conHolder.ATEX_Certificate__c = false;
        configHld.conHolder.NACE_Compliance__c = 'MR0175';
        configHld.midFlangeMaterialSelectOptions();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.handleHolderProductChange();
        configHld.selectedBotingClass = 'A5';
        configHld.handleSTC2Change();
        configHld.getHoldersFieldHelpText(); //not using in VF
        
        configHld.handleInletChange();
        configHld.handleOutletChange();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection10() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        configHld.clearInletSection();      
        configHld.selectedBodyMaterial = 'test';
        configHld.handlebodyMaterialChange();
        configHld.handleCoatingBodyChange();
        configHld.clearBodySection();
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection1() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.conHolder.Inlet_Connection__c = null;
        configHld.getNACEComplianceOptions();
        configHld.getChinaManufacturingLicenseOptions();
        configHld.handleFacingChange();
        configHld.handleKnifebladeMaterialChange();
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection2() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.selectedCompanionFlangeMaterial = '051';
        configHld.handleCompanionFlangeMaterialChange();
        configHld.selectedBore = 'None';
        configHld.selectedjackscrewDrilling = 'None';
        configHld.handleCompanionFlangeMaterialChange();
        configHld.handleboreOptionsChange();
        configHld.handlejackscrewDrillingChange();
        configHld.clearCFMSection();
        configHld.selectedOutletMaterial = '005';
        configHld.handleOutletMaterialChange();
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection3() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.selectedOutletMaterial = '005';
        configHld.selectedGaugeTap = '1/2" FPT';        
        configHld.selectedBore = 'None';
        configHld.selectedEyeboltsOutlet = 'Eyebolt Drilling';
        configHld.selectedFacing = 'RTJ Facing';
        configHld.selectedCoating = 'Fluoropolymer Coating';
        configHld.selectedKnifebladeMaterial = '316 SS';
        configHld.selectedLining = 'Tantalum Lining';
        configHld.selectedJackscrewDrilling2 = 'Pre-Assy Capscrews';
        configHld.handleGaugeTapChange();
        configHld.handleOutletMaterialChange();
    }
    
    @isTest
    public static void testHolderProductSection42() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();        
        configHld.selectedEyeboltsOutlet = 'Eyebolt Drilling';
        configHld.selectedFacing = 'RTJ Facing';
        configHld.selectedCoating = 'Fluoropolymer Coating';
        configHld.selectedKnifebladeMaterial = '316 SS';
        configHld.selectedLining = 'Tantalum Lining';
        configHld.selectedJackscrewDrilling2 = 'Pre-Assy Capscrews';
        configHld.selectedBore2 = 'Sch. 80 Bore';
        configHld.handleGaugeTapChange();
        configHld.handleEyeboltsOutletChange();
        configHld.getUserTimeZone();
        configHld.selectedBotingClass = 'A1';
        configHld.gasketMaterialSelectOptions();
        configHld.spacerRingSelectOptions();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection41() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();        
        
        configHld.outletMaterialSelectOptions();
        configHld.companionFlangeMaterialSelectList();        
        configHld.handleMidFlangeMaterialChange();
        configHld.selectedMidFlangeMaterial = '050';
        configHld.selectedEyeboltsDrillingMFLG = 'None'; 
        configHld.handleMidFlangeMaterialChange();
        configHld.nutMaterialSelectOptions();
        configHld.clampMaterialSelectOptions();
        
        configHld.conHolder.ATEX_Certificate__c = TRUE;
        configHld.midFlangeMaterialSelectOptions();
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection5() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.handleBore2Change();
        configHld.handleNipple2Change();
        configHld.handleTee2Change();
        
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection6() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.handleUOMPressRangeChange();
        configHld.handlePhysicalPropertiesChange();
        configHld.handleTubeCaseMaterialChange();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection7() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.clearOutletSection();
        configHld.selectedGaugeTap2 = 'None';
        configHld.handleGaugeTap2Change();
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection4() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.selectedEyeboltsOutlet = 'Eyebolt Drilling';
        configHld.selectedFacing = 'RTJ Facing';
        configHld.selectedCoating = 'Fluoropolymer Coating';
        configHld.selectedKnifebladeMaterial = '316 SS';
        configHld.selectedLining = 'Tantalum Lining';
        configHld.selectedJackscrewDrilling2 = 'Pre-Assy Capscrews';
        configHld.selectedBore2 = 'Sch. 80 Bore';
        configHld.handleCoatingChange();
        configHld.selectedKnifebladeMaterial = 'None';
        configHld.selectedEyeboltsOutlet = 'None';
        configHld.handleLiningChange();
        configHld.handleJackscrewDrilling2Change();
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection71() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.selectedGaugeTap2 = 'None';
        configHld.selectedUOMPressMFLGRange = 'None';
        configHld.selectedPhysicalMFLGProperties = 'None';
        configHld.excessFlowMFLGValveFlag = true;
        configHld.selectedEyeboltsDrillingMFLG = 'None';
        configHld.selectedLiningMFLG = 'None';
        configHld.selectedEyeboltsDrillingMFLG = 'None';
        configHld.selectedCoatingMFLG = 'None';
        configHld.selectedLiningMFLG = 'None';
        
        configHld.handleGaugeTap2Change();
        configHld.holddownRingMaterialSelectOptions();
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection8() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        configHld.handleEyeboltsDrillingMFLGChange();
        configHld.selectedEyeboltsDrillingMFLG = 'None';
        configHld.selectedGaugeTap2 = 'None';
        configHld.selectedCoatingMFLG = 'None';
        configHld.selectedLiningMFLG = 'None';
        configHld.handleCoatingMFLGChange();
        configHld.handleLiningMFLGChange();
        configHld.handleUOMPressRangeMFLGChange();
        configHld.handlePhysicalMFLGPropertiesChange();
        configHld.handleTubeCaseMFLGMaterialChange();
        configHld.selectedUOMPressMFLGRange = 'None';
        configHld.selectedPhysicalMFLGProperties = 'None';
        configHld.selectedTubeCaseMFLGMaterial = 'None';
        configHld.handleTubeCaseMFLGMaterialChange();     
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection81() {
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.selectedInletMaterial = '005';		//3472
        configHld.selectedEyeboltsDrillingInlet = 'test';
        configHld.selectedEyeboltsDrillingInlet = 'test';
        configHld.handleInletMaterialChange();
        configHld.handleEyeboltsDrillingInletChange();
        Test.stopTest();
        
    }
    @isTest
    public static void testHolderProductSection82() {
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        configHld.selectedInletMaterial = '005';
        configHld.selectedKnifebladeMaterialInlet = 'test';
        configHld.selectedEyeboltsDrillingInlet = 'test';
        configHld.handlejHookChange();
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection86() {
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        configHld.selectedInletMaterial = '005';		
        configHld.selectedKnifebladeMaterialInlet = 'None';
        configHld.selectedGaugeTapInlet = 'None';
        configHld.selectedEyeboltsDrillingInlet = 'None';
        configHld.selectedjHook = 'None';
        configHld.selectedFacingInlet = 'None';
        configHld.selectedCoatingInlet = 'None';
        configHld.selectedLiningInlet = 'None';   
        configHld.handleFacingInletChange();
        configHld.handleCoatingInletChange();
        
        Test.stopTest();
    }  
    @isTest
    public static void testHolderProductSection83() {
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        configHld.selectedInletMaterial = '005';
        configHld.selectedKnifebladeMaterialInlet = 'None';
        configHld.selectedEyeboltsDrillingInlet = 'None';
        configHld.selectedFacingInlet = 'None';
        configHld.selectedCoatingInlet = 'None';
        configHld.selectedLiningInlet = 'None';
        configHld.selectedBoreInlet = 'None';
        configHld.handleLiningInletChange();//error
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection85() {
        Test.startTest();
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        configHld.selectedInletMaterial = '005';		
        configHld.selectedKnifebladeMaterialInlet = 'None';
        configHld.selectedGaugeTapInlet = 'None';
        configHld.selectedEyeboltsDrillingInlet = 'None';
        configHld.selectedjHook = 'None';
        configHld.selectedFacingInlet = 'None';
        configHld.selectedCoatingInlet = 'None';
        configHld.selectedLiningInlet = 'None';          
        configHld.handleBoreInletChange();
        configHld.selectedInletMaterial = '005';
        configHld.handleKnifebladeMaterialInletChange();
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderProductSection84() {
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        
        configHld.selectedKnifebladeMaterialInlet = 'None';
        configHld.selectedGaugeTapInlet = 'None';
        configHld.selectedEyeboltsDrillingInlet = 'None';
        configHld.selectedjHook = 'None';
        configHld.selectedFacingInlet = 'None';
        configHld.selectedCoatingInlet = 'None';
        configHld.selectedLiningInlet = 'None'; 
        configHld.selectedInletMaterial = '005';
        configHld.handleGaugeTapInletChange();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection9() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        configHld.isselectedUOMPressRange = false;
        configHld.isselectedPhysicalProperties = false;
        configHld.isselectedUOMPressMFLGRange = false;
        configHld.isselectedPhysicalMFLGProperties = false;
        configHld.CmpFlangeSectionFlag = false;
        configHld.gasketSectionFlag = false;
        configHld.spacerRingSectionFlag = false;
        configHld.outletSetcionFlag = false;
        configHld.midFlangeSectionFlag = false;
        configHld.nutSectionFlag = false;
        configHld.clampSectionFlag = false;
        configHld.holddownRingSectionFlag = false;
        configHld.inletSectionFlag = false;
        configHld.bodySectionFlag = false;
        configHld.isStudsandNutsRequired = false;
        configHld.isJackscrewsAdditionalRequired = false;
        
        configHld.conHolder.Size_Unit__c = null;
        configHld.conHolder.Holder_Product_Code__c = null;
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.conHolder.Size_Unit__c = '1000';
        configHld.conHolder.Holder_Product_Code__c = 'HXI';
        //
        configHld.CmpFlangeSectionFlag = true;
        configHld.selectedCompanionFlangeMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedCompanionFlangeMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedjackscrewDrilling = 'None';
        configHld.selectedBore = 'None';
        configHld.saveComponentMaterialOptionSelection();
        configHld.CmpFlangeSectionFlag = false;
        
        configHld.gasketSectionFlag = true;
        configHld.selectedGasketMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedGasketMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.gasketSectionFlag = false;
        
        configHld.spacerRingSectionFlag = true;
        configHld.selectedSpacerRing = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedSpacerRing = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.spacerRingSectionFlag = false;
        
        configHld.outletSetcionFlag = true;
        configHld.selectedOutletMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection13() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        configHld.isselectedUOMPressRange = false;
        configHld.isselectedPhysicalProperties = false;
        configHld.isselectedUOMPressMFLGRange = false;
        configHld.isselectedPhysicalMFLGProperties = false;
        configHld.CmpFlangeSectionFlag = false;
        configHld.gasketSectionFlag = false;
        configHld.spacerRingSectionFlag = false;
        configHld.outletSetcionFlag = false;
        configHld.midFlangeSectionFlag = false;
        configHld.nutSectionFlag = false;
        configHld.clampSectionFlag = false;
        configHld.holddownRingSectionFlag = false;
        configHld.inletSectionFlag = false;
        configHld.bodySectionFlag = false;
        configHld.isStudsandNutsRequired = false;
        configHld.isJackscrewsAdditionalRequired = false;
        
        configHld.selectedOutletMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedKnifebladeMaterial = 'None';
        configHld.selectedGaugeTap = 'None';
        configHld.selectedEyeboltsOutlet = 'None';
        configHld.selectedFacing = 'None';
        configHld.selectedCoating = 'None';
        configHld.selectedLining = 'None';
        configHld.selectedJackscrewDrilling2 = 'None';
        configHld.selectedBore2 = 'None';
        configHld.saveComponentMaterialOptionSelection();
        configHld.outletSetcionFlag = false;
        
        configHld.midFlangeSectionFlag = true;
        configHld.selectedMidFlangeMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedMidFlangeMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.selectedGaugeTap2 = 'None';
        configHld.selectedEyeboltsDrillingMFLG = 'None';
        configHld.selectedCoatingMFLG = 'None';
        configHld.selectedLiningMFLG = 'None';
        configHld.saveComponentMaterialOptionSelection();
        configHld.midFlangeSectionFlag = false;
        
        configHld.nutSectionFlag = true;
        configHld.selectedNutMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection11() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        configHld.isselectedUOMPressRange = false;
        configHld.isselectedPhysicalProperties = false;
        configHld.isselectedUOMPressMFLGRange = false;
        configHld.isselectedPhysicalMFLGProperties = false;
        configHld.CmpFlangeSectionFlag = false;
        configHld.gasketSectionFlag = false;
        configHld.spacerRingSectionFlag = false;
        configHld.outletSetcionFlag = false;
        configHld.midFlangeSectionFlag = false;
        configHld.nutSectionFlag = false;
        configHld.clampSectionFlag = false;
        configHld.holddownRingSectionFlag = false;
        configHld.inletSectionFlag = false;
        configHld.bodySectionFlag = false;
        configHld.isStudsandNutsRequired = false;
        configHld.isJackscrewsAdditionalRequired = false;
        
        configHld.selectedNutMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.nutSectionFlag = false;
        
        configHld.clampSectionFlag = true;
        configHld.selectedClampMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedClampMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.clampSectionFlag = false;
        
        configHld.holddownRingSectionFlag = true;
        configHld.selectedHolddownRingMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedHolddownRingMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.holddownRingSectionFlag = false;
        
        configHld.inletSectionFlag = true;
        configHld.selectedInletMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedInletMaterial = 'test';
        configHld.selectedEyeboltsDrillingInlet = 'None';
        configHld.selectedLiningMFLG = 'None';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedKnifebladeMaterialInlet = 'None';
        configHld.selectedGaugeTapInlet = 'None';
        configHld.selectedEyeboltsDrillingInlet = '';
        configHld.selectedFacingInlet = 'None';
        configHld.selectedCoatingInlet = 'None';
        configHld.selectedLiningMFLG = '';
        configHld.selectedjHook = '';
        configHld.saveComponentMaterialOptionSelection();
        configHld.inletSectionFlag = false;
        
        configHld.bodySectionFlag = true;
        configHld.selectedBodyMaterial = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedBodyMaterial = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.bodySectionFlag = false;
        
        configHld.isStudsandNutsRequired = true;
        configHld.selectedStudsandNuts = '';
        configHld.saveComponentMaterialOptionSelection();
        
        configHld.selectedStudsandNuts = 'test';
        configHld.saveComponentMaterialOptionSelection();
        configHld.isStudsandNutsRequired = false;
        
        configHld.isJackscrewsAdditionalRequired = true;
        configHld.saveComponentMaterialOptionSelection();
        configHld.isJackscrewsAdditionalRequired = false;
        
        configHld.isStudsandNutsRequired = false;
        configHld.saveComponentMaterialOptionSelection();       
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderProductSection14() {
        
        Test.startTest();  
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        configHld.isselectedUOMPressRange = false;
        configHld.isselectedPhysicalProperties = false;
        configHld.isselectedUOMPressMFLGRange = false;
        configHld.isselectedPhysicalMFLGProperties = false;
        configHld.CmpFlangeSectionFlag = false;
        configHld.gasketSectionFlag = false;
        configHld.spacerRingSectionFlag = false;
        configHld.outletSetcionFlag = false;
        configHld.midFlangeSectionFlag = false;
        configHld.nutSectionFlag = false;
        configHld.clampSectionFlag = false;
        configHld.holddownRingSectionFlag = false;
        configHld.inletSectionFlag = false;
        configHld.bodySectionFlag = false;
        configHld.isStudsandNutsRequired = false;
        configHld.isJackscrewsAdditionalRequired = false;
        
        configHld.isselectedUOMPressRange = true;
        configHld.saveComponentMaterialOptionSelection();
        configHld.isselectedUOMPressRange = false;
        configHld.selectedPhysicalProperties = 'test';
        
        configHld.isselectedPhysicalProperties = true;
        configHld.saveComponentMaterialOptionSelection();
        configHld.isselectedPhysicalProperties = false;
        configHld.selectedTubeCaseMaterial = 'test';
        
        configHld.isselectedUOMPressMFLGRange = true;
        configHld.saveComponentMaterialOptionSelection();
        configHld.isselectedUOMPressMFLGRange = false;
        configHld.selectedPhysicalMFLGProperties = 'tesst';
        
        configHld.isselectedPhysicalMFLGProperties = true;
        configHld.saveComponentMaterialOptionSelection();
        configHld.isselectedPhysicalMFLGProperties = false;
        configHld.selectedTubeCaseMFLGMaterial = 'test';
        
        configHld.studsandNutsFlag = true;
        configHld.jackscrewsAdditionalFlag = true;
        configHld.saveComponentMaterialOptionSelection();
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHolderSaveConfigurationSection() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        configHld.selectedInletMaterial = 'test';
        configHld.selectedOutletMaterial = 'test';
        configHld.conHolder.Holder_Product_Code__c = null;
        configHld.saveCleaningMarkingsTesting();
        
        Test.stopTest();
    }
    @isTest
    public static void testHolderSaveConfigurationSection1() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        List<Holder_Drawings__c> hldDrawiingList = new List<Holder_Drawings__c>();
        configHld.selectedHolderProduct = 'CDC';
        configHld.saveCleaningMarkingsTesting();
        
        test.stopTest();  
    }
    
    @isTest
    public static void testHolderErrorMsg() {
        
        Test.startTest();
        
        ConfigHolderControllerTest.configValues();
        
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        //TestDataUtility.createHoldersTestRecords();
        //TestDataUtility.createHoldersMasterTestRecords();
        
        PageReference pager = Page.ConfigHolders;
        Test.setCurrentPage(pager);
        
        List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine[0].Id));
        
        Holder = [SELECT Id, Brand__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine[0].Id LIMIT 1];
        system.debug('conHolder:'+Holder);
        
        configHolderController.getConvertedValErrorMsg('Temperature', 1, 1, 'Deg C', 'Deg C', 1, 'test__c');
        system.debug('getConvertedValErrorMsg..');
        Holders__c hld = configHolderController.generateHolderPartBaseNumber(Holder);
        
        configHolderController.getConvertedValErrorMsg('Temperature', 1, 1, 'Deg C', 'Deg C', 2, 'test__c');
        Test.stopTest();  
    }
    
    @isTest
    public static void testGetDiaData() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        List<Holder_Drawings__c> hldDrawiingList = new List<Holder_Drawings__c>();
        configHld.selectedHolderProduct = 'CDC';
        
        List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Holder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :quoteLine[0].Id LIMIT 1];
        configHld.getDiaData();
        
        List<Holder_Drawings__c> hldDrawings2 = [SELECT id FROM Holder_Drawings__c WHERE Holders__c = :Holder.Id];
        delete hldDrawings2;
        
        Holder_Drawings__c hldDrawings = new Holder_Drawings__c();
        hldDrawings.Drawing_ID__c = '1128';
        hldDrawings.Drawing_ID_Override__c = '1128';
        hldDrawings.Dim_A__c = '8.10 [205.7]';
        hldDrawings.Dim_A_Override__c = '8.10 [205.7]';
        hldDrawings.Dim_B__c = '4.56 [115.8]';
        hldDrawings.Dim_B_Override__c = '4.56 [115.8]';
        hldDrawings.Dim_C__c = '3.97 [100.8]';
        hldDrawings.Dim_C_Override__c = '3.97 [100.8]';
        hldDrawings.IINO_DWGNO__c = '1000002';
        hldDrawings.JHOOK_IINO_DWGNO__c = '1000002';
        hldDrawings.Holders__c = Holder.Id;
        insert hldDrawings;
        configHld.getDiaData();
        
        hldDrawings.Drawing_ID__c = '2128';
        hldDrawings.Drawing_ID_Override__c = '2128';
        update hldDrawings;
        configHld.getDiaData();
        
        hldDrawings.Drawing_ID__c = null;
        hldDrawings.Drawing_ID_Override__c = null;
        update hldDrawings;
        configHld.getDiaData();
        
        test.stopTest();  
    }
    
    @isTest
    public static void testGetDiaData2() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        List<Holder_Drawings__c> hldDrawiingList = new List<Holder_Drawings__c>();
        configHld.selectedHolderProduct = 'CDC';
        
        List<Holder_Drawings_Detail__c> delData = [SELECT Id FROM Holder_Drawings_Detail__c WHERE Drawing_Type__c = 'Submittal Drawing'];
        delete delData;
        configHld.getDiaData();
        
        test.stopTest();  
    }
    
    @isTest
    public static void testHolderSaveProduct2() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.conHolder.Size_Unit__c = '';
        configHld.conHolder.Size__c = '';
        configHld.selectedBotingClass = '';
        configHld.saveProductSelection();       
        Test.stopTest();
    }
    @isTest
    public static void testHolderSaveProduct() {
        test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.conHolder.Bolting_Class__c = null;
        configHld.conHolder.Inlet_Connection__c = null;
        configHld.conHolder.Outlet_Connection__c = null;       
        configHld.saveProductSelection();        
        Test.stopTest();
    }
    
    @isTest
    public static void testJackscrewsAdditionaSelectlOptions() {
        
        Test.startTest();
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.jackscrewsAdditionaSelectlOptions();        
        Test.stopTest();
    }
    
    @isTest
    public static void testSeatSelectOptions() {
        
        Test.startTest();
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        configHld.ruptureDiscPr = 'CDC';
        configHld.seatSelectOptions();        
        Test.stopTest();
    }
    
    @isTest
    public static void testHandleSZC2Change() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        configHld.holderSize = null;
        configHld.handleSZC2Change();        
        Test.stopTest();
    }
    
    @isTest
    public static void testBoltingClassSelectList() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        Holder_Product_Detail__c hpd = new Holder_Product_Detail__c();
        hpd.Bolting_Class_Desc__c = 'PN 40 DIN Bolting';
        hpd.HCLASS__c = 'A1';
        hpd.Brand__c = 'CDC';
        hpd.SZC__c = '1000';
        hpd.Holder_Type__c = 'HPX Insert';
        hpd.TempLL__c = 70;
        hpd.TempUL__c = 73;
        hpd.HIC_Desc__c = 'Welded';
        hpd.HIC__c = 'W';
        insert hpd;
        
        configHld.boltingClassSelectList(configHld.conHolder);
        
        configHld.holderSize = '1000';
        configHld.size2 = '1000';
        configHld.boltingClassSelectList(configHld.conHolder);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testHldConstructor() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];

        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl(); 
        
        configHld.isselectedUOMPressRange = false;
        configHld.isselectedPhysicalProperties = false;
        configHld.isselectedUOMPressMFLGRange = false;
        configHld.isselectedPhysicalMFLGProperties = false;
        configHld.CmpFlangeSectionFlag = false;
        configHld.gasketSectionFlag = false;
        configHld.spacerRingSectionFlag = false;
        configHld.outletSetcionFlag = false;
        configHld.midFlangeSectionFlag = false;
        configHld.nutSectionFlag = false;
        configHld.clampSectionFlag = false;
        configHld.holddownRingSectionFlag = false;
        configHld.inletSectionFlag = false;
        configHld.bodySectionFlag = false;
        configHld.isStudsandNutsRequired = false;
        configHld.isJackscrewsAdditionalRequired = false;
        
        configHld.conHolder.Size_Unit__c = null;
        configHld.conHolder.Holder_Product_Code__c = null;
        
        configHld.conHolder.Size_Unit__c = '1000';
        configHld.conHolder.Holder_Product_Code__c = 'HXI';
        //
        configHld.CmpFlangeSectionFlag = true;
        configHld.selectedCompanionFlangeMaterial = '';
        
        new ConfigHolderController(quoteLine[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testInletConnectionSelectList() {
        
        Test.startTest();
        
        ConfigHolderController configHld = ConfigHolderControllerTest.getConfigHolderCntrl();
        
        Holder_Product_Detail__c hpd = new Holder_Product_Detail__c();
        hpd.Bolting_Class_Desc__c = 'PN 40 DIN Bolting';
        hpd.HCLASS__c = 'A1';
        hpd.Brand__c = 'CDC';
        hpd.SZC__c = '1000';
        hpd.Holder_Type__c = 'HPX Insert';
        hpd.TempLL__c = 70;
        hpd.TempUL__c = 73;
        hpd.HIC_Desc__c = 'Welded';
        hpd.HIC__c = 'W';
        insert hpd;
        
        configHld.selectedBotingClass = null;
        configHld.selectedHolderProduct = null;
        configHld.holderSize = null;
        configHld.size2 = null;
        configHld.inletConnectionSelectList(configHld.conHolder);
        
        Test.stopTest();
    }
}