@isTest
public class RDThicknessFormulaeTest {
    public static id currentRD {get;set;}
    public static Rupture_Disc__c rdRecord = new Rupture_Disc__c();

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
        RDThicknessFormulaeTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords6();

        RDThicknessFormulae RDThickForm = new RDThicknessFormulae(TestDataRDUtility.conProd, 100.00, 103.00);
        RDThickForm.getThicknessArrayVals(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00, 'M220');
        RDThickForm.getTSThickness4ArrayVals(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00, 'M220');
        RDThickForm.getTSThicknessMfgArrayVals(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00, 0.75, 'M220');
        RDThickForm.thickTSArr.add(0.99);
        RDThickForm.RDTopSectionThickness();
        RDThickForm.thickTSArr.add(0.99);
        RDThickForm.thickTSArr.add(0.99);
        RDThickForm.thickTSArr.add(0.1199);
        RDThickForm.RDTopSectionThickness();
        RDThickForm.thickMfgTSArr.add(0.99);
        RDThickForm.thickMfgTSArr.add(0.99);
        RDThickForm.thickMfgTSArr.add(0.99);
        RDThickForm.RDTopSectionThickness();
        RDThickForm.getThicknessInitialPass(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00, 2.00, 4.00, 'M220');
        RDThickForm.RDThicknessCal();

        RDThickForm.getMSThickness3ArrayVals(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00);
        RDThickForm.getMSThicknessMfgArrayVals(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00);
        RDThickForm.getMSThickness4ArrayVals(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00, 0.75);
        RDThickForm.thickMSArr.add(0.99);
        RDThickForm.RDMetalSealThickness();
        RDThickForm.thickMSArr.add(0.99);
        RDThickForm.thickMSArr.add(0.99);
        RDThickForm.thickMSArr.add(0.1199);
        RDThickForm.RDMetalSealThickness();
        RDThickForm.thickMfgMSArr.add(0.99);
        RDThickForm.thickMfgMSArr.add(0.99);
        RDThickForm.thickMfgMSArr.add(0.99);
        RDThickForm.RDMetalSealThickness();
        Test.stopTest();

    }

    @isTest
    public static void runGettersAndSetters(){
        Test.startTest();
        TestDataRDUtility.createRDTestRecSecAandEwithPAS();
        TestDataRDUtility.createRDMasterTestRecords();
        RDThicknessFormulae RDThickForm = new RDThicknessFormulae(TestDataRDUtility.conProd, 100.00, 103.00);

        String strDefault = 'test';
        strDefault = RDThickForm.PTC;
        strDefault = RDThickForm.STC;
        strDefault = RDThickForm.MCDT1;
        strDefault = RDThickForm.MCDD;
        strDefault = RDThickForm.MCDT2;
        strDefault = RDThickForm.strSZC;
        strDefault = RDThickForm.MCSS1;
        strDefault = RDThickForm.MCSS2;
        strDefault = RDThickForm.MCSS3;
        strDefault = RDThickForm.MCSS;
        strDefault = RDThickForm.DiscMatl;
        strDefault = RDThickForm.RefMCD1;
        strDefault = RDThickForm.CEMARK;
        strDefault = RDThickForm.ASME;
        strDefault = RDThickForm.TMPTSTASME;
        strDefault = RDThickForm.RefMCSM1;

        RDThickForm.MCSS1='005';
        strDefault=RDThickForm.MCSS;
        RDThickForm.MCSS1=null;
        RDThickForm.MCSS2='005';
        strDefault=RDThickForm.MCSS;
        RDThickForm.MCSS1=null;
        RDThickForm.MCSS2=null;
        RDThickForm.MCSS3='005';
        strDefault=RDThickForm.MCSS;


        RDThickForm.MCDT1='005';
        strDefault=RDThickForm.MCDT;
        RDThickForm.MCDT1=null;
        RDThickForm.MCDT2='005';
        strDefault=RDThickForm.MCDT;



        Decimal decDefault = 0.0;
        decDefault = RDThickForm.intSZC;
        decDefault = RDThickForm.RTTMDF;
        decDefault = RDThickForm.Disc_Thickness;
        decDefault = RDThickForm.TopSectionThickness;
        decDefault = RDThickForm.MetalSealThickness;

        RDThickForm.PTC = 'test';
        RDThickForm.STC = 'test';
        RDThickForm.MCDT1 = 'test';
        RDThickForm.MCDD = 'test';
        RDThickForm.MCDT2 = 'test';
        RDThickForm.strSZC = 'test';
        RDThickForm.MCSS1 = 'test';
        RDThickForm.MCSS2 = 'test';
        RDThickForm.MCSS3 = 'test';
        RDThickForm.MCSS = 'test';
        RDThickForm.DiscMatl = 'test';
        RDThickForm.RefMCD1 = 'test';
        RDThickForm.CEMARK = 'test';
        // RDThickForm.CODET = 'test';

        RDThickForm.ASME = 'test';
        RDThickForm.TMPTSTASME = 'test';

        RDThickForm.RefMCSM1 = 'test';

        RDThickForm.intSZC = 100;
        RDThickForm.RTTMDF = 100.00;
        RDThickForm.Disc_Thickness = 100.00;
        RDThickForm.TopSectionThickness = 100;
        RDThickForm.MetalSealThickness = 100.00;
        Test.stopTest();
    }

    @isTest
    public static void testMethod2() {
        Test.startTest();
        RDThicknessFormulaeTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords6();

        RDThicknessFormulae RDThickForm = new RDThicknessFormulae(TestDataRDUtility.conProd, 100.00, 103.00);

        RDThickForm.CE_RTTMDF = false;
        RDThickForm.getThicknessArrayVals(TestDataRDUtility.RDtblMfgDataTable, 100.00, 103.00, 'A');
        RDThickForm.getTSThickness4ArrayVals(TestDataRDUtility.RDtblMfgDataTable, 100.00, 103.00, '005');
        RDThickForm.getTSThicknessMfgArrayVals(TestDataRDUtility.RDtblMfgDataTable, 100.00, 103.00, 0.9999, '005');
        RDThickForm.RDTopSectionThickness();


        RDThickForm.CEMARK = 'CET';
        RDThickForm.RTTMDF = 72;
        // RDThickForm.CODET = 'C8';

        RDThickForm.ASME = '8';
        RDThickForm.TMPTSTASME = 'N';

        RDThickForm.ProdTempTest = 'Yes';
        RDThickForm.getThicknessInitialPass(TestDataRDUtility.RDtblMfgDataTable, 65.00, 70.00, 100.00, 103.00, 'B');
        RDThickForm.thickArrC.add(0.999);
        RDThickForm.RDThicknessCal();
        RDThickForm.thickArrC.add(0.999);
        RDThickForm.thickArrC.add(0.989);
        RDThickForm.RDThicknessCal();
        RDThickForm.thickArrC.clear();
        RDThickForm.thickArrB.add(0.999);
        RDThickForm.RDThicknessCal();
        RDThickForm.thickArrB.add(0.999);
        RDThickForm.thickArrB.add(0.989);
        RDThickForm.RDThicknessCal();
        RDThickForm.thickArrB.clear();
        RDThickForm.thickArrA.add(0.999);
        RDThickForm.RDThicknessCal();
        RDThickForm.thickArrA.add(0.999);
        RDThickForm.thickArrA.add(0.989);
        RDThickForm.RDThicknessCal();


        result res=RDThickForm.getRDtblMfgDataForSTD();
        Test.stopTest();

        // RDThickForm.getMSThickness3ArrayVals(TestDataRDUtility.RDtblMfgDataTable, 100.00, 103.00);
        // RDThickForm.getMSThicknessMfgArrayVals(TestDataRDUtility.RDtblMfgDataTable, 100.00, 103.00);
        // RDThickForm.getMSThickness4ArrayVals(TestDataRDUtility.RDtblMfgDataTable, 100.00, 103.00, 0.9999);
        // RDThickForm.RDMetalSealThickness();
    }
    @isTest
    public static void testMethod31() {
        Test.startTest();
        RDThicknessFormulaeTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecords2();
        RDThicknessFormulae RDThickForm = new RDThicknessFormulae(TestDataRDUtility.conProd, 100.00, 103.00);
        RDThickForm.MCSM='005';
        String strDefault=RDThickForm.RefMCSM1;

        RDThickForm.MCSM='050';
        strDefault=RDThickForm.RefMCSM1;
        Test.stopTest();
    }
}