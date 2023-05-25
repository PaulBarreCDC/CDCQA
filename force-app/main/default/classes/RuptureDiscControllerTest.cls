@isTest
public class RuptureDiscControllerTest {


    public static id conRD {get;set;}
    public static Rupture_Disc__c RDCT = new Rupture_Disc__c();

    @isTest
    public static void getconfigRDCntrl() {
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');

        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;

        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();
    }

    @isTest
    public static void testMethod1() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords1();

        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'WGB');
        RuptureDiscController.fetchFormAccessibility(TestDataRDUtility.quoteLine.id);
        RuptureDiscController.getDiscMaterial();
        RuptureDiscController.getMaterialConstruction();
        RuptureDiscController.rDMBRecords(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        //RuptureDiscController.getRDMasterIDs(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.getRDProductNarrowFilterClause(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.connectedCallBackMethod(TestDataRDUtility.conProd.id);
        RuptureDiscController.navToProdSelPage(TestDataRDUtility.conProd.id);


        try{
            RuptureDiscController.saveRelief(TestDataRDUtility.conProd);
            RuptureDiscController.saveCertificate(TestDataRDUtility.conProd);
            RuptureDiscController.saveProductNarrowing(TestDataRDUtility.conProd);
        } catch(Exception e) {}

        //Clearing Logic
        RuptureDiscController.clearPressureAlone(TestDataRDUtility.conProd);
        RuptureDiscController.clearVacuumAlone(TestDataRDUtility.conProd);
        RuptureDiscController.clearSizingData(TestDataRDUtility.conProd);
        RuptureDiscController.clearAllSectBfields(TestDataRDUtility.conProd);
        RuptureDiscController.clearDataBasedOnReliefType(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectCCertifications(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectDProductNarrowing(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectEProductSelection(TestDataRDUtility.conProd);
        Test.stopTest();
    }

    @isTest
    public static void testMethod2() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords2();

        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'PS');
        RuptureDiscController.getDiscMaterial();
        RuptureDiscController.getMaterialConstruction();
        RuptureDiscController.rDMBRecords(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        //RuptureDiscController.getRDMasterIDs(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.getRDProductNarrowFilterClause(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.connectedCallBackMethod(TestDataRDUtility.conProd.id);
        RuptureDiscController.navToProdSelPage(TestDataRDUtility.conProd.id);
        //RuptureDiscController.getRupDiscRecords(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);

        try{
            RuptureDiscController.saveRelief(TestDataRDUtility.conProd);
            RuptureDiscController.saveCertificate(TestDataRDUtility.conProd);
            RuptureDiscController.saveProductNarrowing(TestDataRDUtility.conProd);
            RuptureDiscController.getRDProductNarrowFilterClause(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id);
            RuptureDiscController.saveProductSelection(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id, TestDataRDUtility.lstRDMBIds);
        } catch(Exception e) {}

        //Clearing Logic
        RuptureDiscController.clearPressureAlone(TestDataRDUtility.conProd);
        RuptureDiscController.clearVacuumAlone(TestDataRDUtility.conProd);
        RuptureDiscController.clearSizingData(TestDataRDUtility.conProd);
        RuptureDiscController.clearAllSectBfields(TestDataRDUtility.conProd);
        RuptureDiscController.clearDataBasedOnReliefType(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectCCertifications(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectDProductNarrowing(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectEProductSelection(TestDataRDUtility.conProd);

        Test.stopTest();
    }

    @isTest
    public static void testMethod3() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords3();

        //Wrapper
        RuptureDiscController.EvalPerChangePicklistRDWrapper EPCPwrap = new RuptureDiscController.EvalPerChangePicklistRDWrapper();
        RuptureDiscController.formAccessibilityWrapper fAWrap = new RuptureDiscController.formAccessibilityWrapper();
        RuptureDiscController.HClassWrapper HCWrap = new RuptureDiscController.HClassWrapper();
        RuptureDiscController.RDDMWrapper RDDMWrap = new RuptureDiscController.RDDMWrapper();
        RuptureDiscController.RDMBWrapper RDMBWrap = new RuptureDiscController.RDMBWrapper();
        RuptureDiscController.RDOptions RDOptionsWrap = new RuptureDiscController.RDOptions('CDC','FS','0200',TestDataRDUtility.conProd.id,true);
        RuptureDiscController.fetchUserInfo();
        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'RD');
        RuptureDiscController.getConsolidateHCLASSOptns(TestDataRDUtility.conProd);
        RuptureDiscController.getHCLASSValues(TestDataRDUtility.conProd);
        RuptureDiscController.getHCLASSValues2(TestDataRDUtility.conProd);
        RuptureDiscController.HCLASSRecords(TestDataRDUtility.conProd);
        RuptureDiscController.HCLASSRecords2(TestDataRDUtility.conProd);
        RuptureDiscController.getConsolidateHICOptns(TestDataRDUtility.conProd);
        RuptureDiscController.getHICValues(TestDataRDUtility.conProd);
        RuptureDiscController.getHICValues2(TestDataRDUtility.conProd);
        RuptureDiscController.getConsolidateHOCOptns(TestDataRDUtility.conProd);
        RuptureDiscController.getHOCValues(TestDataRDUtility.conProd);
        result res= RuptureDiscController.getConvertedValErrorMsg('CPSPressure', 200, 10, 'psig', 'psia', 45, 'Back_Pressure_Value__c');
        try{
            RuptureDiscController.saveRelief(TestDataRDUtility.conProd);
            RuptureDiscController.saveCertificate(TestDataRDUtility.conProd);
            RuptureDiscController.saveProductNarrowing(TestDataRDUtility.conProd);
            RuptureDiscController.saveHClass(TestDataRDUtility.conProd);
            RuptureDiscController.recalMNFA(TestDataRDUtility.conProd);
            
            RuptureDiscController.saveProductSelection(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id, TestDataRDUtility.lstRDMBIds);
        } catch(Exception e) {}

        Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
        ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ASME Water';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ASME Steam';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Steam';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Gas/Vapor';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Liquid';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ISO Gas/Vapor';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ISO Liquid';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ISO Dry Steam';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ISO Wet Steam';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Omega Method 2 Phase Flashing or Nonflashing';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Gas-Liquid';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Vapor-Liquid';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
        RuptureDiscController.clearSizingData(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'Fauske All Liquid Flashing';
        RuptureDiscController.clearSizingData(ruptDisc);


        //Clearing Logic
        RuptureDiscController.clearPressureAlone(TestDataRDUtility.conProd);
        RuptureDiscController.clearVacuumAlone(TestDataRDUtility.conProd);
        RuptureDiscController.clearSizingData(ruptDisc);
        RuptureDiscController.clearAllSectBfields(TestDataRDUtility.conProd);
        RuptureDiscController.clearDataBasedOnReliefType(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectCCertifications(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectDProductNarrowing(TestDataRDUtility.conProd);
        RuptureDiscController.clearSectEProductSelection(TestDataRDUtility.conProd);

        Test.stopTest();
    }

    @isTest
    public static void testMethod4() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords4();

        try{
            RuptureDiscController.saveRelief(TestDataRDUtility.conProd);
            RuptureDiscController.saveSizingFlowArea(TestDataRDUtility.conProd);
            RuptureDiscController.saveCertificate(TestDataRDUtility.conProd);
            RuptureDiscController.saveProductNarrowing(TestDataRDUtility.conProd);
            RuptureDiscController.saveHClass(TestDataRDUtility.conProd);
            RuptureDiscController.recalMNFA(TestDataRDUtility.conProd);
        } catch(Exception e) {}
        RuptureDiscController.getDiscMaterial();
        RuptureDiscController.getMaterialConstruction();
        RuptureDiscController.optsGasFlowRate();
        RuptureDiscController.optsLiquidFlowRate();
        RuptureDiscController.optsStreamFlowRate();
        RuptureDiscController.optsAPIOmegaFlowRate();
        RuptureDiscController.optsFauskeFlowRate();
        RuptureDiscController.requiredFlowRateUnitsPicklist(TestDataRDUtility.conProd);
        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'HLD');

        RuptureDiscController.rDMBRecords(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.getRDMasterIDs(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.getRDProductNarrowFilterClause(TestDataRDUtility.conProd,TestDataRDUtility.conProd.id);
        RuptureDiscController.mediaPropertyOnProcessMedia(TestDataRDUtility.conProd);
        RuptureDiscController.imperativeMediaTypesPickValues(TestDataRDUtility.conProd);
        RuptureDiscController.connectedCallBackMethod(TestDataRDUtility.conProd.id);
        RuptureDiscController.navToProdSelPage(TestDataRDUtility.conProd.id);

        Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
        ruptDisc.Process_Media__c = 'Steam';
        RuptureDiscController.mediaPropertyOnProcessMedia(ruptDisc);

        ruptDisc.Process_Media__c = 'None';
        RuptureDiscController.mediaPropertyOnProcessMedia(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ISO Gas/Vapor';
        RuptureDiscController.coefficientOfDischargePicklistValues(ruptDisc);
        RuptureDiscController.requiredFlowRateUnitsPicklist(ruptDisc);
        RuptureDiscController.mediaTypesPickValues(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Liquid';
        RuptureDiscController.coefficientOfDischargePicklistValues(ruptDisc);
        RuptureDiscController.requiredFlowRateUnitsPicklist(ruptDisc);
        RuptureDiscController.mediaTypesPickValues(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
        RuptureDiscController.requiredFlowRateUnitsPicklist(ruptDisc);
        RuptureDiscController.mediaTypesPickValues(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'API Omega Method 2 Phase Flashing or Nonflashing';
        RuptureDiscController.requiredFlowRateUnitsPicklist(ruptDisc);
        RuptureDiscController.mediaTypesPickValues(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ASME Water';
        RuptureDiscController.mediaTypesPickValues(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'ASME Steam';
        RuptureDiscController.mediaTypesPickValues(ruptDisc);

        ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Gas-Liquid';
        RuptureDiscController.requiredFlowRateUnitsPicklist(ruptDisc);

        Test.stopTest();
    }

    @isTest
    public static void testMethod5() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();

        // User user1 = new User();

        // UserRole portalRole = [SELECT Id FROM USERROLE WHERE PortalType = 'None' Limit 1];
        // Profile profile1 = [SELECT Id FROM PROFILE WHERE name = 'System Administrator'];
        // User portalAccountOwner1 = new User(
        //     UserRoleId = portalRole.Id,
        //     ProfileId = profile1.Id,
        //     Username = System.now().millisecond() + 'test2@test.com',
        //     Alias = 'adminU',
        //     Email='test.adminUser@cdc.com',
        //     EmailEncodingKey='UTF-8',
        //     Firstname='CDC',
        //     Lastname='Test User',
        //     LanguageLocaleKey='en_US',
        //     LocaleSidKey='en_US',
        //     TimeZoneSidKey='America/Chicago'
        // );
        // Database.insert(portalAccountOwner1);

        // System.RunAs(portalAccountOwner1){
        //     Account portalAccount1 = new Account(Name = 'TestAccount',OwnerId = portalAccountOwner1.Id);
        //     Database.insert(portalAccount1);

        //     //Create contact
        //     Contact contact1 = new Contact(FirstName = 'Test',Lastname = 'TestPortalContact',AccountId = portalAccount1.Id,Email = System.now().millisecond() + 'test@test.com');
        //     Database.insert(contact1);

        //     //Create user
        //     Profile portalProfile = [SELECT Id FROM Profile Limit 1];
        //     user1 = new User(
        //     Username = System.now().millisecond() + 'test12345@cdc.com', ContactId = contact1.Id, ProfileId = portalProfile.Id,
        //         Alias = 'test123', Email = 'test.prtalUser@cdc.com', EmailEncodingKey = 'UTF-8', LastName = 'tstUs', CommunityNickname = 'test12345',
        //         TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        //     Database.insert(user1);
        // }

        User portalUser = new User();
        portalUser.lastname = 'portalUserLastName1234098765';
        portalUser.alias = 'ptlLU';
        portalUser.email = 'portalUserLastName1234098765@test.com';
        portalUser.username = 'portalUserLastName1234098765@portalTest.com';
        portalUser.CommunityNickname = 'portalUserLastName1234098';
        //portalUser.IsPortalEnabled = true;
        portalUser.ProfileId = '00e8A000000E3DV';

        RuptureDiscController.quoteLineWrapper qLWrap = new RuptureDiscController.quoteLineWrapper(TestDataRDUtility.quoteLine,TestDataRDUtility.conProd,portalUser);
        RuptureDiscController.matlCodeProcessor('007');
        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'FlameProducts');
        Test.stopTest();
    }

    @isTest
    public static void testMethod6() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();

        RuptureDiscController.mapDerateValues(100.0);
        RuptureDiscController.filterDerateValue(TestDataRDUtility.lstDerateVal, 100.0);

        RuptureDiscController.getConvertedValErrorMsg('RelTemperature', 99999999, -320, 'Deg F', 'Deg F', 200, 'Rel temp');
        RuptureDiscController.getConvertedValErrorMsg('RelievingPressure', 3200, 15, 'psig', 'psig', 200, 'Rel Pressure');
        RuptureDiscController.getConvertedValErrorMsg('Pressure', 3200, 15, 'psig', 'psig', 200, 'Pressure');
        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'RLFVLV');
        Test.stopTest();
    }

    @isTest
    public static void testMethod7() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords2();

        try{
            RuptureDiscController.saveProductSelection(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id, TestDataRDUtility.lstRDMBIds);
            RuptureDiscController.saveHClass(TestDataRDUtility.conProd);
            RuptureDiscController.recalMNFA(TestDataRDUtility.conProd);
        } catch(Exception e) {}


        RuptureDiscController.getProductPicklistValues(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id, TestDataRDUtility.lstRDMBIds);
        RuptureDiscController.getSeatPicklistValues(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id, TestDataRDUtility.lstRDMBIds);
        RuptureDiscController.getSizePicklistValues(TestDataRDUtility.conProd, TestDataRDUtility.conProd.id, TestDataRDUtility.lstRDMBIds);
        RuptureDiscController.upsertQuoteLineItem(TestDataRDUtility.quoteLine,'BGR');
        Test.stopTest();
    }



    @isTest
    public static void testMethod8() {
        Test.startTest();

        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');

        SBQQ__Quote__c quote = TestDataBaseUtility.createQuoteAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quote = quote;

        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();

        RuptureDiscController.getQuoteLineDataImpa(TestDataRDUtility.quote.Id);
        RuptureDiscController.getQuoteLineData(TestDataRDUtility.quote.Id);
        RuptureDiscController.getProductData(TestDataRDUtility.quote.Id);
        RuptureDiscController.getQLDetails(TestDataRDUtility.quote.Id, TestDataRDUtility.quoteLine.Id);
        RuptureDiscController.getQuoteLineDetails(TestDataRDUtility.quoteLine.Id);
        //RuptureDiscController.fetchFormAccessibility(TestDataRDUtility.quoteLine.id);

        Test.stopTest();
    }

    @isTest
    public static void testMethod9() {
        Test.startTest();
        RuptureDiscControllerTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords5();

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Liquid';
            ruptDisc.Process_Media__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 2;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 2.5;
            ruptDisc.Compressibility_Factor__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 2.5;
            ruptDisc.Compressibility_Factor__c = 0.5;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 2.5;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 2.5;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 0.5;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Water';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Density_Specific_Volume_Specific_Gravity__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Water';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Density_Specific_Volume_Specific_Gravity__c = 100;
            ruptDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = 'Test';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

    	try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ASME Gas/Vapor';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Liquid';
            ruptDisc.Process_Media__c = 'Air';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Density_Specific_Volume_Specific_Gravity__c = 100;
            ruptDisc.Density_SpecificVolume_SpcfcGravityUnits__c = 'lb/ft3';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Liquid';
            ruptDisc.Process_Media__c = 'Water';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 28.964;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.4;
            ruptDisc.Density_Specific_Volume_Specific_Gravity__c = 100;
            ruptDisc.Density_SpecificVolume_SpcfcGravityUnits__c = 'lb/ft3';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            // ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            // ruptDisc.Enter_Different_Temperature_Value__c = 110;
            // ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ISO Wet Steam';
            ruptDisc.Process_Media__c = 'Steam';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 18.02;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.31;
            ruptDisc.Coefficient_of_Discharge__c = '0.68';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Dryness_of_Wet_Steam__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'ISO Wet Steam';
            ruptDisc.Process_Media__c = 'Steam';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Molecular_Weight__c = 18.02;
            ruptDisc.Compressibility_Factor__c = 1;
            ruptDisc.Ratio_of_Specific_Heats__c = 1.31;
            ruptDisc.Coefficient_of_Discharge__c = '0.68';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Dryness_of_Wet_Steam__c = 95;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method 2 Phase Flashing or Nonflashing';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Specific_Volume_at_inlet__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method 2 Phase Flashing or Nonflashing';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Specific_Volume_at_inlet__c = 100;
            ruptDisc.Specific_Volume_at_Inlet_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method 2 Phase Flashing or Nonflashing';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Specific_Volume_at_inlet__c = 100;
            ruptDisc.Specific_Volume_at_Inlet_Units__c = 'm3/kg';
            ruptDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method 2 Phase Flashing or Nonflashing';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Specific_Volume_at_inlet__c = 100;
            ruptDisc.Specific_Volume_at_Inlet_Units__c = 'm3/kg';
            ruptDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = 100;
            ruptDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Density_at_Inlet__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Density_at_Inlet__c = 100;
            ruptDisc.Density_at_Inlet_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Density_at_Inlet__c = 100;
            ruptDisc.Density_at_Inlet_Units__c = 'lb/ft3';
            ruptDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Density_at_Inlet__c = 100;
            ruptDisc.Density_at_Inlet_Units__c = 'lb/ft3';
            ruptDisc.Saturation_Pressure_at_Inlet_Temperature__c = 100;
            ruptDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Density_at_Inlet__c = 100;
            ruptDisc.Density_at_Inlet_Units__c = 'lb/ft3';
            ruptDisc.Saturation_Pressure_at_Inlet_Temperature__c = 100;
            ruptDisc.Saturation_Pressure_at_inlet_temp_units__c = 'psig';
            ruptDisc.Density_at_90_of_Saturation_Pressure__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'API Omega Method Subcooled Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Viscosity__c = 1;
            ruptDisc.Viscosity_units__c = 'centipoise';
            ruptDisc.Density_at_Inlet__c = 100;
            ruptDisc.Density_at_Inlet_Units__c = 'lb/ft3';
            ruptDisc.Saturation_Pressure_at_Inlet_Temperature__c = 100;
            ruptDisc.Saturation_Pressure_at_inlet_temp_units__c = 'psig';
            ruptDisc.Density_at_90_of_Saturation_Pressure__c = 100;
            ruptDisc.Density_at_90_Saturation_Pressure_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = 'psig';
            ruptDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = 'psig';
            ruptDisc.Vapor_pres_correspond_to_stagnation_temp__c = 100;
            ruptDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = 'psig';
            ruptDisc.Vapor_pres_correspond_to_stagnation_temp__c = 100;
            ruptDisc.Vapor_Pres_to_Stagnation_temp_Units__c = 'psig';
            ruptDisc.Isentropic_coefficient_gas__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = '10%';
            // ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            // ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            // ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = 'psig';
            ruptDisc.Vapor_pres_correspond_to_stagnation_temp__c = 100;
            ruptDisc.Vapor_Pres_to_Stagnation_temp_Units__c = 'psig';
            ruptDisc.Isentropic_coefficient_gas__c = 100;
            ruptDisc.Isentropic_coefficient_vapor__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = '16%';
            // ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            // ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            // ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            ruptDisc.Enter_Different_Temperature_Value__c = 110;
            ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = 'psig';
            ruptDisc.Vapor_pres_correspond_to_stagnation_temp__c = 100;
            ruptDisc.Vapor_Pres_to_Stagnation_temp_Units__c = 'psig';
            ruptDisc.Isentropic_coefficient_gas__c = 100;
            ruptDisc.Isentropic_coefficient_vapor__c = 100;
            ruptDisc.Molecular_Weight_gas__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Pressure Relief';
            ruptDisc.Evaluation_Type__c = 'Capacity';
            ruptDisc.Evaluation_Per__c = 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
            ruptDisc.Process_Media__c = 'Customer Specified';
            ruptDisc.Customer_Specified_Media__c = '';
            ruptDisc.Coefficient_of_Discharge__c = '0.62';
            ruptDisc.Required_Flow_Rate__c = 100;
            ruptDisc.Required_Flow_units__c = 'lb/h';
            ruptDisc.Relieving_Pressure_at_Inlet__c = '21%';
            // ruptDisc.Relieving_Pressure_at_Inlet__c = 'Enter Relieving Pressure Value/ units';
            // ruptDisc.Enter_Relieving_Pressure_Value__c = 100;
            // ruptDisc.Enter_Relieving_Pressure_units__c = 'psig';
            ruptDisc.Pressure_Relieving_Temperature__c = 'PRTSameAsTemperatureSetting';
            // ruptDisc.Pressure_Relieving_Temperature__c = 'PRTEnterDifferentTemperatureUnits';
            // ruptDisc.Enter_Different_Temperature_Value__c = 110;
            // ruptDisc.Enter_Different_Temperature_Units__c = 'Deg F';
            ruptDisc.Stagnation_gas_vapor_quality__c = 100;
            ruptDisc.Liquid_density__c = 100;
            ruptDisc.Liquid_density_Units__c = 'lb/ft3';
            ruptDisc.Stagnation_vapor_density__c = 100;
            ruptDisc.Stagnation_Vapor_Density_Units__c = 'lb/ft3';
            ruptDisc.Latent_heat_of_vaporization__c = 100;
            ruptDisc.Liquid_specific_heat__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure__c = 100;
            ruptDisc.Stagnation_gas_partial_pressure_Units__c = 'psig';
            ruptDisc.Vapor_pres_correspond_to_stagnation_temp__c = 100;
            ruptDisc.Vapor_Pres_to_Stagnation_temp_Units__c = 'psig';
            ruptDisc.Isentropic_coefficient_gas__c = 100;
            ruptDisc.Isentropic_coefficient_vapor__c = 100;
            ruptDisc.Molecular_Weight_gas__c = 100;
            ruptDisc.Molecular_Weight_vapor__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Vacuum Relief';
            ruptDisc.VacRequired_Flow_Rate__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Vacuum Relief';
            ruptDisc.VacRequired_Flow_Rate__c = 100;
            ruptDisc.VacRequired_Flow_Rate_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Vacuum Relief';
            ruptDisc.VacRequired_Flow_Rate__c = 100;
            ruptDisc.VacRequired_Flow_Rate_Units__c = 'psig';
            ruptDisc.VacPressure_Relieving_Temperature__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Vacuum Relief';
            ruptDisc.VacRequired_Flow_Rate__c = 100;
            ruptDisc.VacRequired_Flow_Rate_Units__c = 'psig';
            ruptDisc.VacPressure_Relieving_Temperature__c = 'vacPRTEnterDifferentTemperatureUnits';
            ruptDisc.VacEnter_Different_Temperature_Value__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Vacuum Relief';
            ruptDisc.VacRequired_Flow_Rate__c = 100;
            ruptDisc.VacRequired_Flow_Rate_Units__c = 'psig';
            ruptDisc.VacPressure_Relieving_Temperature__c = 'vacPRTEnterDifferentTemperatureUnits';
            ruptDisc.VacEnter_Different_Temperature_Value__c = 100;
            ruptDisc.VacEnter_Different_Temperature_Units__c = null;
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}

        try{
            Rupture_Disc__c ruptDisc = new Rupture_Disc__c();
            ruptDisc.Relief_Type__c='Vacuum Relief';
            ruptDisc.VacRequired_Flow_Rate__c = 100;
            ruptDisc.VacRequired_Flow_Rate_Units__c = 'psig';
            ruptDisc.VacPressure_Relieving_Temperature__c = 'vacPRTEnterDifferentTemperatureUnits';
            ruptDisc.VacEnter_Different_Temperature_Value__c = 100;
            ruptDisc.VacEnter_Different_Temperature_Units__c = 'Deg F';
            RuptureDiscController.saveSizingFlowArea(ruptDisc);
        } catch(Exception e) {}
        Test.stopTest();
    }
}