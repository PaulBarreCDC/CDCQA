@isTest
public class WizardPricingProcessorTest {
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
        WizardPricingProcessorTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordForPricing();

        WizardPricingProcessor Pricing=new WizardPricingProcessor(TestDataRDUtility.conProd.id);
        Pricing.MCHO ='001';
        Pricing.SURFFINISH ='20';
        Pricing.ELECTROPOL='N';
        Pricing.MCHRNG ='001';
        Pricing.MCAR='001';
        Pricing.MCGR1 ='001';
        Pricing.MCOG ='001';
        Pricing.MCGR2='001';
        Pricing.MCOR ='001';
        Pricing.MCDP ='001';
        Pricing.MCOL ='001';
        Pricing.MCVS1 ='001';
        Pricing.MCOC ='001';
        Pricing.MCDT1='001';
        Pricing.MCDD ='001';
        Pricing.MCSS1 ='001';
        Pricing.MCGD ='001';
        Pricing.MCSS2 ='001';
        Pricing.MCDT2 ='001';
        Pricing.MCIC1 ='001';
        Pricing.MCSS3='001';
        Pricing.MCIR1 ='001';
        Pricing.MCIL ='001';
        Pricing.MCIR2 ='001';
        Pricing.MCVS2 ='001';
        Pricing.MCIC2 ='001';
        Pricing.MCIR3 ='001';
        Pricing.MCHS ='001';
        Pricing.MCIG ='001';
        Pricing.MCHT ='001';
        Pricing.MCTSOR ='001';
        Pricing.MCHI ='001';
        Pricing.MCSS ='001';
        Pricing.MCDT ='001';
        Pricing.MCD ='001';
        Pricing.MCSM='001';
        Pricing.MCGR ='001';
        Pricing.MCVS3  ='001';
        Pricing.AssignedRangeType='test';
        Pricing.VAssignedRangeType='test';
        Pricing.RG3DRT=0.0;
        Pricing.VG3DRT=0.0;
        Pricing.TMR =0.0;
        Pricing.VTMR =0.0;
        Pricing.FinalTMRFloat=0.0;
        Pricing.FinalAssignedRangeType='test';
        Pricing.TMRFloat=0.0;
        Pricing.VTMRFloat =0.0;
        Pricing.ADMERK='test';
        Pricing.RPVM084='test';
        Pricing.CHINAMFG='CUSTSI';
        Pricing.ASME='test';
        Pricing.PED ='CET';
        Pricing.TMPTSTASME='test';
        Pricing.addIntegralBDI='test';
        Pricing.RTTMDF=0.0;
        Pricing.NACE='test';
        Pricing.CLEAN ='test';
        Pricing.CSPECS ='test';
        result res=Pricing.getRDAdderPriceValues();
        Test.stopTest();
    }
    @isTest
    public static void runGetterSetters() {
        Test.startTest();
        WizardPricingProcessorTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordForPricing();
        WizardPricingProcessor Pricing=new WizardPricingProcessor(TestDataRDUtility.conProd.id);
       // result res=Pricing.getRDAdderPriceValues();
        Map<string,string> Test1=new map<string,string>(WizardPricingProcessor.mapNonDiscountableFields);
        Map<string,string> Test2=new map<string,string>(WizardPricingProcessor.mapDiscountableFields);
        Map<string,string> Test3=new map<string,string>(WizardPricingProcessor.mapPricingOverriddenfields);

        Test.stopTest();
    }
}