@isTest
public class RDOutputBaseUtilityTest {
    public static id currentRD {get;set;}
    public static Rupture_Disc__c rdRecord = new Rupture_Disc__c();
    @testSetup
    public static void dataSetup() {
       
        TestDataRDUtility.createRDMasterTestRecords();
    }
    @isTest
    public static void getconfigRDCntrl() {
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;
        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        //TestDataRDUtility.createRDTestRecordWithOutput();
    }
    @isTest
    public static void testMethod1() {

        RDOutputBaseUtilityTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordWithOutput();
        RdOutputBaseUtility RDOU=new RdOutputBaseUtility(TestDataRDUtility.conProd.id);
        map<string,string> test1=RDOU.getOB_LABMAT_Ouput();
        List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        RDOU.MCSS='070';
        String a=RDOU.MCSC;
        Test.startTest();
        RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
        result res1=RDOU.getRDLeadTime();
        result res=RDOU.getOA();

        // res1=RDOU.getControlPlan();
        // res1=RDOU.getLookupAttributes();
        // res1=RDOU.getOW();

        Test.stopTest();
    }
    @isTest
    public static void testMethod2() {
        
        RDOutputBaseUtilityTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordWithOutput();
        RdOutputBaseUtility RDOU=new RdOutputBaseUtility(TestDataRDUtility.conProd.id);
        // map<string,string> test1=RDOU.getOB_LABMAT_Ouput();
        // List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        // RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
        // result res1=RDOU.getRDLeadTime();
        // result res=RDOU.getOA();
        // res1=RDOU.getRouting();
        // res1=RDOU.getWorkGuideLines();
		Test.startTest();
        result res1=RDOU.getControlPlan();
        res1=RDOU.getRouting();
        res1=RDOU.getWorkGuideLines();
        res1=RDOU.getLookupAttributes();
        res1=RDOU.getOW();
        Test.stopTest();
    }
    @isTest
    public static void runSetters() {
        Test.startTest();
        RDOutputBaseUtilityTest.getconfigRDCntrl();
       TestDataRDUtility.createRDTestRecordWithOutput();
        RdOutputBaseUtility RDOU=new RdOutputBaseUtility(TestDataRDUtility.conProd.id);
        //
        String a=RDOU.Brand;
        a=RDOU.VGRATU;
        a=RDOU.DERATEEQN;
        a=RDOU.addIntegralBDICheck;
        a=RDOU.InterfaceCable;
        //
        decimal i=0.0;
        i=RDOU.VGSMIN;
        i=RDOU.VTPRS1;
        i=RDOU.VBurstPressureConverted;
        i=RDOU.decSZC;
        i=RDOU.BPMMMax;
        i=RDOU.BACKPRESSCONV;
        i=RDOU.VGRATW;
       // i=RDOU.METLEQN;
        i=RDOU.METLDER;

        RDOU.DSCVAR='A';

        RDOU.RGTYP1='test';
        RDOU.VGTYP1='test';
        RDOU.POSWTHSTND='test';
        RDOU.VGRAT1='test';
        RDOU.RTPRSU='test';
        RDOU.RTPRSU='test';
        RDOU.StripMatlCode='test';
        RDOU.ENTITY='test';
        RDOU.Brand='test';
        RDOU.CompSTC='test';
        RDOU.RTTMUN='test';
        RDOU.VTPRSU='test';
        RDOU.DPM='test';
        RDOU.ASME='test';
        RDOU.PED='test';
        RDOU.CHINAMFG='N';
        RDOU.CSA='test';
        RDOU.ATEX='test';
        RDOU.GASGRP=null;
        RDOU.ZONE='test';
        RDOU.KOSHA='test';
        RDOU.CUTR='test';
        RDOU.D3ASRV='test';
        RDOU.ADMERK='test';
        RDOU.RPVM084='test';
        RDOU.NACE='test';
        RDOU.strSZC='test';
        RDOU.COOUT='test';
        RDOU.COIN='test';
        RDOU.STC='test';
        RDOU.CSPECS='test';
        RDOU.CLEAN='test';
        RDOU.INDPCK='test';
        RDOU.ELECTROPOL='test';
        RDOU.SURFFINISH='test';
        RDOU.PMI='test';
        RDOU.SHELLTEST='test';
        RDOU.TMPTSTASME='test';
        RDOU.InterfaceCable='test';
        RDOU.BEC='test';
        RDOU.BCL='test';
        RDOU.BCT='test';
        RDOU.WiringConfig='test';
        RDOU.BCT='test';
        RDOU.MCIG='test';
        RDOU.MCHS='005';
        RDOU.MCIR3='005';
        RDOU.MCIC2='005';
        RDOU.MCVS2='005';
        RDOU.MCIR2='005';
        RDOU.MCIL='005';
        RDOU.MCIR1='005';
        RDOU.MCSS3='005';
        RDOU.MCIC1='005';
        RDOU.MCDT2='005';
        RDOU.MCSS2='005';
        RDOU.MCGD='005';
        RDOU.MCSS1='005';
        RDOU.MCDD='005';
        RDOU.MCDT1='005';
        RDOU.MCOC='005';
        RDOU.MCVS1='005';
        RDOU.MCOL='005';
        RDOU.MCDP='005';
        RDOU.MCOR='005';
        RDOU.MCGR2='005';
        RDOU.MCOG='005';
        RDOU.MCGR1='005';
        RDOU.MCAR='005';
        RDOU.MCHRNG='005';
        RDOU.MCHO='005';
        RDOU.HOC='005';
        RDOU.HIC='005';
        RDOU.HCLASS='005';
        RDOU.CSSUM='005';
        RDOU.PTC='005';
        RDOU.SeatDesc='005';
        RDOU.MCBDIG='005';
        RDOU.MCBS='005';
        RDOU.addIntegralBDI='N';
        RDOU.addIntegralBDICheck='N';
        RDOU.MCHI='005';
        RDOU.MCTSOR='005';
        RDOU.MCHT='005';
        RDOU.MCDD='005';
        RDOU.InletOptionASMECode='test';
        RDOU.OutletOptionASMECode='test';
        RDOU.DERATEEQN='test';
        RDOU.GTAG10='test';
        RDOU.OW042='test';
        RDOU.OW041='test';
        RDOU.OW0405='test';
        RDOU.OW0403='test';
        RDOU.OW040='test';
        RDOU.OW040='test';
        RDOU.MCDERATE='test';
        RDOU.MATLSOURCE='test';

        //
        RDOU.BPMMMax=0.0;
        RDOU.MNFAValue=0.0;
        RDOU.TEFAMB=0.0;
        RDOU.POSPRESSCONV=0.0;
        RDOU.RTPRS1=0.0;
        RDOU.RGEMIN=0.0;
        RDOU.VG2MIN=0.0;
        RDOU.RG2MIN=0.0;
        RDOU.RGSMIN=0.0;
        RDOU.PBurstPressureConverted=0.0;
        RDOU.RTTMSP=0.0;
        RDOU.RTTMDF=0.0;
        RDOU.VTPRS1=0.0;
        RDOU.VBurstPressureConverted=0.0;
        RDOU.decSZC=0.0;
        RDOU.SizeValue=0.0;
        //
        RDOU.QTY=2;

        //
        //QuoteLine
        RDOU.MCSC=null;
        RDOU.MCSM='001';
        a=RDOU.MCSC;
        RDOU.MCSM='002';
        RDOU.MCST='070';

        RDOU.MCST='071';
        RDOU.MCSM=null;
        a=RDOU.MCSC;

        RDOU.MCSS='070';
        RDOU.MCSM='009';
        a=RDOU.MCSC;

        Test.stopTest();
    }
    @istest
    public static void testStructureDetails() {
        Test.startTest();
        RDOutputBaseUtilityTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecStructure();
        RdOutputBaseUtility RDOU=new RdOutputBaseUtility(TestDataRDUtility.conProd.id);
        map<string,string> test1=RDOU.getOB_LABMAT_Ouput();
        List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        RDOU.MCSS='070';
        String a=RDOU.MCSC;
        RDOU.MCHI='001';
        RDOU.MCTSOR='001';
        RDOU.MCHO='001';
        RDOU.MCHRNG='001';
        RDOU.MCIR='001';
        RDOU.TefSealThick=0.05;
        boolean bln=RDOU.isMetalCheck('001');
        //MCAR
        // List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper1=new List<RdOutputBaseUtility.RDStructureWrapper>();
        // RDOBUStructWrapper1=RDOU.getConsolidatedStructureDetails();
        RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
        result res1=RDOU.getRVIGasketPartNumber();
        res1=RDOU.getArcuateRingPartNumber();
        res1=RDOU.getTeflonSealPartNumber();
        res1=RDOU.getSlotCoverPartNumber();
        res1=RDOU.getSlotCoverStripPartNumber();
        res1=RDOU.getProDoc();
        Test.stopTest();
    }
}