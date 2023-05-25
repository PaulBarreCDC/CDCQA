@isTest
public class ConfigureFlameProductControllerTest {
    
    @isTest
    public static configureFLAMEproduct getconfigFACntrl() {
                 
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        system.debug('TestDataFAUtility.quoteLine:'+TestDataFAUtility.quoteLine);
        system.debug('TestDataFAUtility.mapWithFAValues:'+TestDataFAUtility.mapWithFAValues);
        TestDataFAUtility.createFATestRecords();
        TestDataFAUtility.createFAMasterTestRecords();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA = [SELECT Id FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new configureFLAMEproduct(sc);
    }        
  
    //Second Record Code
   @isTest
    public static configureFLAMEproduct getconfigFACntrl2() {
                 
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        system.debug('TestDataFAUtility.quoteLine:'+TestDataFAUtility.quoteLine);
        system.debug('TestDataFAUtility.mapWithFAValues:'+TestDataFAUtility.mapWithFAValues);
        TestDataFAUtility.createFATestRecords2();
        TestDataFAUtility.createFAMasterTestRecords2();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA2 = [SELECT Id FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new configureFLAMEproduct(sc);
    }
 
    
   // public static id conFA {get;set;}
   // public static Flame_Product__c conProd2 = new Flame_Product__c();
    
    @isTest
    public static void testLWCMethod1Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        FlameProductController.saveApplicationParameters(TestDataFAUtility.conProd2);  
		FlameProductController.flowingMediaValues(TestDataFAUtility.conProd2); 
        try
        {
            FlameProductController.saveSizing(configFA.flmProd);
            FlameProductController.saveCertifications(configFA.flmProd); 
            FlameProductController.saveProductNarrowing(configFA.flmProd,configFA.flmProd.id);  
            FlameProductController.saveProductSelection(configFA.flmProd);
        } 
        catch(Exception e) {}
       
        FlameProductController.FAWrapper FAWrap = new FlameProductController.FAWrapper();
        FlameProductController.clearSectBSizingFlowArea(configFA.flmProd);
      //  TestDataFAUtility.conProd2.Mounting__c = 'End-of-Line';
      //  FlameProductController.clearSectBSizingFlowArea(TestDataFAUtility.conProd2);
        
        List<FA_MasterBlaster__c> lstOfFlowRatefilterRecs = new List<FA_MasterBlaster__c>();        
        lstOfFlowRatefilterRecs=FlameProductController.getFilterByFlowRate(lstOfFlowRatefilterRecs,configFA.flmProd.id,configFA.flmProd);
        result res=new result();     
        FlameProductController.connectedCallBackMethod(configFA.flmProd.id);
        FlameProductController.fetchFlowingMedia();
        try
        {
            Flame_Product__c FLM2=new Flame_Product__c();
            FLM2.Mounting__c = 'End-of-Line';
            FLM2.Certification_Save_Check_Flag__c=false;
            FlameProductController.saveProductNarrowing(FLM2,FLM2.id);                                                
        } 
        catch(Exception e) {}                
        
        FlameProductController.clearSectBSizingFlowArea(TestDataFAUtility.conProd2);
        
        TestDataFAUtility.conProd2.Pressure_Units__c=null;
        FlameProductController.clearSectBSizingFlowArea(TestDataFAUtility.conProd2);
        TestDataFAUtility.conProd2.Mounting__c = 'End-of-Line';
        FlameProductController.clearSectBSizingFlowArea(TestDataFAUtility.conProd2);
        
        
        
        map<string,string> myMap1 =new map<string,string>();
     	myMap1=FlameProductController.mapOfESZC;
        map<string,integer> myMap2 =new map<string,integer>();
        //myMap2=FlameProductController.mapOfGroupGas;
      //  myMap1=FlameProductController.mapOfModelDesc;
        myMap1=FlameProductController.mapOfSZC;        
        
     	res=FlameProductController.getConvertedValErrorMsg('Pressure',0, 18, 'psig', 'psia',5,'PilotsSupplyPressure');     
        res=FlameProductController.getConvertedValErrorMsg('Pressure',1, 1, 'psig', 'psig',1,'PilotsSupplyPressure');
     	res=FlameProductController.getConvertedValErrorMsg('Pressure',null,null, 'psig', 'psig',null,'PilotsSupplyPressure');
        
     	res=FlameProductController.getConvertedValErrorMsg('Temperature', 0, 1000, 'Deg C', 'Deg F',100,'Temperature');
        res=FlameProductController.getConvertedValErrorMsg('Temperature', 1, 1, 'Deg C', 'Deg C',1,'Temperature');
     	res=FlameProductController.getConvertedValErrorMsg('Temperature', null, null, 'Deg C', 'Deg C',null,'Temperature');
        
        Test.stopTest();
    }
   
    @isTest
    public static void testLWCMethod2Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl2();
        FlameProductController.saveApplicationParameters(TestDataFAUtility.conProd);  
		FlameProductController.flowingMediaValues(TestDataFAUtility.conProd); 
        try
        {
            FlameProductController.saveCertifications(configFA.flmProd); 
            FlameProductController.saveProductNarrowing(configFA.flmProd,configFA.flmProd.id);  
            FlameProductController.saveProductSelection(configFA.flmProd);
        } 
        catch(Exception e) {}
        
     //   Flame_Product__c FLM5=new Flame_Product__c();
	//	FlameProductController.clearSectBSizingFlowArea(configFA.flmprod);
       
        FlameProductController.FAWrapper FAWrap = new FlameProductController.FAWrapper();
        FlameProductController.fetchFormAccessibility(configFA.quotelineId);
     //   FlameProductController.fetchCurrentProductAccessibility('a','a');
        FlameProductController.fetchUserInfo();
        result res=new result();     
        FlameProductController.connectedCallBackMethod(configFA.flmProd.id);
        FlameProductController.fetchFlowingMedia();
        
        Test.stopTest();
    }
    
    
   
    @isTest
    public static void testFAMethod1CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getdrillingOptions(); 
        configFA.getbodyMaterialOptions();
        configFA.getHousingMaterialOptions();
        configFA.getElementMaterialOptions();
        configFA.getPalletMaterialOptions();
        configFA.getDiaphragmMaterialOptions();
        configFA.getPressureSettingOptions();
        configFA.getSpringRangeOptions();
        
        Test.stopTest();
    }
    @isTest
    public static void testFAMethod2CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getPaintingCoatingOptions();
        configFA.getInletAOptions();
        configFA.getInletBOptions();
        configFA.getInletCOptions();
        configFA.getOutletAOptions();
        configFA.getOutletBOptions();
        configFA.getOutletCOptions();
        
        Test.stopTest();
    }
    @isTest
    public static void testFAMethod3CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getRadiographyOptions();
        configFA.getFilletWeldLiquidDyePenetrant();
        configFA.getPositiveMaterialIdentificationOptions();
        configFA.getLiquidDyePenetrantOptions();
        configFA.getUltrasonicExamination();
        configFA.getMagneticParticleExamination();
        configFA.getBrinellHardnessExamination();
        configFA.getCharpyImpactTesting();
        configFA.getVisualCastingExamination();
        configFA.getIntergranularCorrosionTest();
        
        Test.stopTest();
    }
    
     @isTest
    public static void testFAMethod4CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.saveProductMaterialAndOptions();
        configFA.saveExaminationOption();
        string str;
        str=configFA.strquoteDes;
        configFA.EnableEditMode();
       // configFA.getPositiveMaterialIdentificationOptions();    
        
        Test.stopTest();
    }
    
    @isTest
    public static void testFAMethod5CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.saveCertificateDocumentOrSourcingRestrictions();   
        
        Test.stopTest();
    }
    
    @isTest
    public static void testFAMethod6CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.goBackToQuote();
        configFA.goBack();
        configFA.getPricinglist();
        configFA.ApplyDefaultPricing();
        configFA.SavePriceOverride(); 
        
        Test.stopTest();
    }
    
    @isTest
    public static void testFAMethod7CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getLeadTimeRecords();
        configFA.saveLeadTime();
        configFA.ApplyDefaultLeadtime();    
        
        Test.stopTest();
    }
    @isTest
    public static void testFAMethod8CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.GetQuoteDescriptionRecords();
        configFA.ApplyDefaultQuoteDescription();
        configFA.SaveQuoteDescriptionOverride();    
        
        Test.stopTest();
    }
    @isTest
    public static void testFAMethod9CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getIFSAttributes();
        configFA.getTroubleshootingAttributes();
        configFA.getStructureDetails();   
        configFA.getControlPlanDetails();
        configFA.getRouter();
        configFA.getWorkGuideLines();
        configFA.getDocument();
        
        Test.stopTest();
    }
    
     @isTest
    public static void testWGBCostSection(){
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        
      //  configFA.getCosts();
      //  configFA.getFAOutputRecord();
        configFA.saveNotes();
        configFA.SaveDocID();
      //  configFA.copyCostToCostOverride();
      //  configFA.saveCosting();
      //  configFA.ApplyDefaultCost();
       // Cost__c copyCostToCostOverride=new Cost__C();
      //  copyCostToCostOverride=configFA.copyCostToCostOverride();
        
        Test.stopTest();
    }

     @isTest
    public static void testFAMethod10CostSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getIFSAttributes();
        configFA.getTroubleshootingAttributes();    
        configFA.getOnChangeSETTING();
        Test.stopTest();
    }
    
     @isTest
    public static void testFACostMethodSection() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        configFA.getCosts();
        configFA.saveCosting();
        configFA.ApplyDefaultCost();
        configFA.savePartNumber();
        
        Test.stopTest();
    }
    @isTest
    public static void testFATabData1Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
		
		configFA.selectedTab = 'ProductReview';
		configFA.getTabData();
		configFA.selectedTab = 'TroubleShoot';
		configFA.getTabData();
        
        Test.stopTest();
    }
	@isTest
    public static void testFATabData2Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
		
		configFA.selectedTab = 'Pricing';
		configFA.getTabData();
        configFA.selectedTab = 'EngineeringSpecials';
		configFA.getTabData();
        Test.stopTest();
    }
	@isTest
    public static void testFATabData3Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
		
		configFA.selectedTab = 'Engineering';
		configFA.getTabData();
        
        Test.stopTest();
    }	
 
    @isTest
    public static void testFAMethodlead2Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl2();
        configFA.getLeadTimeRecords();
		configFA.getLiquidDyePenetrantOptions();        
        Test.stopTest();
    }   
   
    @isTest
    public static void testFAMethod1Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl2();
        configFA.getdrillingOptions(); 
        configFA.getbodyMaterialOptions();
        configFA.getHousingMaterialOptions();
        configFA.getElementMaterialOptions();
        
        Test.stopTest();
    }
    @isTest
    public static void testFAMethod2Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl2();
        configFA.getPalletMaterialOptions();
        configFA.getDiaphragmMaterialOptions();
        configFA.getPressureSettingOptions();
        configFA.getSpringRangeOptions();
        
        Test.stopTest();
    }
    
    public static FAOutputUtility FAOU1{get;set;} 
    
    @isTest
    public static void testFAOutputMethod1Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        FAOU1=new FAOutputUtility(configFA.flmProd.Id);
        
      //  FAOU1
        
        Test.stopTest();
    }
    
    
	@isTest
    public static void testFAMethod3Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        FAOU1=new FAOutputUtility(configFA.flmProd.Id);
        
        decimal dec;
        string str;
        str=FAOU1.OA;
        str=FAOU1.OA01;
        str=FAOU1.OB;
        str=FAOU1.OW;
        dec=FAOU1.AtmPres;
        str=FAOU1.AtmPresUOM;
        str=FAOU1.DPM;
        str=FAOU1.EndCondition;
        str=FAOU1.FlameType;
        dec=FAOU1.FlowPres;
        str=FAOU1.FlowPresUOM;
        dec=FAOU1.FlowTemp;
        str=FAOU1.FlowTempUOM;
        dec=FAOU1.MaxAlowdPresDrop;
        str=FAOU1.MaxAlowdPresDropUOM;
        str=FAOU1.MediaName;
        dec=FAOU1.MinReqdFlowRate;
        str=FAOU1.MinReqdFlowRateUOM;
        str=FAOU1.Mounting;
        dec=FAOU1.MW;
        str=FAOU1.OffsetBases;
        dec=FAOU1.OpPres;
        str=FAOU1.OpPresUOM;
        str=FAOU1.OpTemp;
        dec=FAOU1.ReqdGasGroupLevel;
        dec=FAOU1.RunUpLengthA;
        str=FAOU1.RunUpLengthAUOM;
        dec=FAOU1.RunUpLengthB;
        str=FAOU1.RunUpLengthBUOM;
        dec=FAOU1.Z;
        str=FAOU1.PARTREV;
        str=FAOU1.DESCRIPTION;
        
        str=FAOU1.ASSEMBLYWT;
        str=FAOU1.ASSEMBLYWTUOM;
        str=FAOU1.ASYTYP;
        str=FAOU1.ATTRTEMPLATE;
        str=FAOU1.COMPDESCRIPTION;
        str=FAOU1.COMPINVSERTRK;
        str=FAOU1.COMPLOTTRACK;
        str=FAOU1.COMPPROVIDE;
        str=FAOU1.COMPRESPONID;
        str=FAOU1.CUSTOMSTATNO;
        str=FAOU1.DesignOutlet;
        str=FAOU1.FBASSY;
        str=FAOU1.GMODEL1;
        str=FAOU1.GMODEL2;
        str=FAOU1.GMODEL3;
        str=FAOU1.GMODEL4;
        str=FAOU1.GMODEL5;
        str=FAOU1.GMODEL6;
        str=FAOU1.GPFACE;
        str=FAOU1.GTAG01;
        str=FAOU1.GTAG04;
        str=FAOU1.GTAG05;
        str=FAOU1.GTAG06;
        str=FAOU1.GTAG14;
        str=FAOU1.GTAG15;
        str=FAOU1.GTAG16;
        str=FAOU1.GTAG17;
        str=FAOU1.GTAGPN;
        str=FAOU1.HSNSACCODE;
        str=FAOU1.IINO;
        str=FAOU1.INHOUSEPAINT;
        str=FAOU1.LOTTRACKCODE;        
        str=FAOU1.PARTCLASS;
        str=FAOU1.PARTUOM;
        str=FAOU1.PC410;
        str=FAOU1.PC411;
        str=FAOU1.PC420;
        str=FAOU1.PC421;
        str=FAOU1.PC430;
        str=FAOU1.PC431;
        str=FAOU1.PC440;
        str=FAOU1.PC441;
        str=FAOU1.PLANNER;
        str=FAOU1.PNGPFACE;
        str=FAOU1.PNMODEL;
        str=FAOU1.PROVIDE;
        str=FAOU1.RESPONSIBLE_ID;
        str=FAOU1.SALESGROUP;
        str=FAOU1.SALESPRICEGROUP;
        str=FAOU1.SERIALTRACKCODE;
        dec=FAOU1.SHLTSTBDYPSIG;
        str=FAOU1.SOURCINGOPT;
        str=FAOU1.VENDORPAINT;
        
        str=FAOU1.PRDLIN;
        str=FAOU1.ASSYPARTNO;
        str=FAOU1.OWs;
        str=FAOU1.OAs;
        str=FAOU1.OBs;
        dec=FAOU1.AtmPresPSIA;
        dec=FAOU1.CriticalPresRatio;
        dec=FAOU1.FlowPresPSIG;
        dec=FAOU1.FlowTempDEGR;
        str=FAOU1.GINLOP;
        str=FAOU1.GMODEL;
        str=FAOU1.GMODEL7;
        str=FAOU1.GOUTOP;
        dec=FAOU1.InletFlowPresPSIA;
        dec=FAOU1.MaxAlowdPresDropPSIG;
        dec=FAOU1.MinReqdFlowRateSCFH;
        str=FAOU1.OnEngrHoldFlag;
        dec=FAOU1.OpPresPSIA;
        str=FAOU1.PC;
        dec=FAOU1.PresRatio;
        dec=FAOU1.RunUpLengthAIn;
        dec=FAOU1.RunUpLengthBIn;
        dec=FAOU1.ShlTstBdyPSIGMx;
        str=FAOU1.UOMSystem;
        str=FAOU1.PTC;
        str=FAOU1.SZC;
        str=FAOU1.ESZC;
        str=FAOU1.MCELEM;
        str=FAOU1.SHLTSTMETHBDY;
        str=FAOU1.Model;
        str=FAOU1.ASSYLOCATION;
        str=FAOU1.ATEX;
        str=FAOU1.BRAND;
        str=FAOU1.BRINHARDEXAM;
        str=FAOU1.CHARPYIMPEXAM;
        str=FAOU1.CUTR;
        str=FAOU1.FWLDP;
        str=FAOU1.GINLOP_OptA;
        str=FAOU1.GINLOP_OptB;
        str=FAOU1.GINLOP_OptC;
        str=FAOU1.GOUTOP_OptA;
        str=FAOU1.GOUTOP_OptB;
        str=FAOU1.GOUTOP_OptC;
        str=FAOU1.GPAINT;
        str=FAOU1.HCLASS;
        str=FAOU1.IGCEXAM;
        dec=FAOU1.K;
        str=FAOU1.LDP;
        str=FAOU1.MAGPARTEXAM;
        str=FAOU1.MATLSOURCE;
        str=FAOU1.MCBODY;
        str=FAOU1.MCDPHM;
        str=FAOU1.MCELMT;
        str=FAOU1.MCHOUS;
        str=FAOU1.MCPALL;
        str=FAOU1.NACE;
        str=FAOU1.PMI;
        str=FAOU1.PressureSide;
        str=FAOU1.SETTING;
        str=FAOU1.SPRING;
        str=FAOU1.USCG;
        str=FAOU1.USONICEXAM;
        str=FAOU1.VISCASTEXAM;
        str=FAOU1.XRAY;
        str=FAOU1.GasGroupLevel;        
        
		FAOU1.OA='test';
        FAOU1.OA01='test';
        FAOU1.OB='test';
        FAOU1.OW='test'; 
        FAOU1.AtmPres=0;
        FAOU1.AtmPresUOM='test';
        FAOU1.DPM='test';
        FAOU1.EndCondition='test';
        FAOU1.FlameType='test';
        FAOU1.FlowPres=0;
        FAOU1.FlowPresUOM='test';
        FAOU1.FlowTemp=0;
        FAOU1.FlowTempUOM='test';
        FAOU1.MaxAlowdPresDrop=0; 
        FAOU1.MaxAlowdPresDropUOM='test';
        FAOU1.MediaName='test';
        FAOU1.MinReqdFlowRate=0;
        FAOU1.MinReqdFlowRateUOM='test';
        FAOU1.Mounting='test';
        FAOU1.MW=0;
        FAOU1.OffsetBases='test';
        FAOU1.OpPres=0;
        FAOU1.OpPresUOM='test';
        FAOU1.OpTemp='test';
        FAOU1.ReqdGasGroupLevel=0;
        FAOU1.RunUpLengthA=0;
        FAOU1.RunUpLengthAUOM='test';
        FAOU1.RunUpLengthB=0;
        FAOU1.RunUpLengthBUOM='test';
        FAOU1.Z=0;
        FAOU1.PARTREV='test';
        FAOU1.DESCRIPTION='test';
		
        FAOU1.ASSEMBLYWT='test';
        FAOU1.ASSEMBLYWTUOM='test';
        FAOU1.ASYTYP='test';
        FAOU1.ATTRTEMPLATE='test';
        FAOU1.COMPDESCRIPTION='test';
        FAOU1.COMPINVSERTRK='test';
        FAOU1.COMPLOTTRACK='test';
        FAOU1.COMPPROVIDE='test';
        FAOU1.COMPRESPONID='test';
        FAOU1.CUSTOMSTATNO='test';
        FAOU1.DesignOutlet='test';
        FAOU1.FBASSY='test';
        FAOU1.GMODEL1='test';
        FAOU1.GMODEL2='test';
        FAOU1.GMODEL3='test';
        FAOU1.GMODEL4='test';
        FAOU1.GMODEL5='test';
        FAOU1.GMODEL6='test';
        FAOU1.GPFACE='test';
        FAOU1.GTAG01='test';
        FAOU1.GTAG04='test';
        FAOU1.GTAG05='test';
        FAOU1.GTAG06='test';
        FAOU1.GTAG14='test';
        FAOU1.GTAG15='test';
        FAOU1.GTAG16='test';
        FAOU1.GTAG17='test';
        FAOU1.GTAGPN='test';
        FAOU1.HSNSACCODE='test';
        FAOU1.IINO='test';
        FAOU1.INHOUSEPAINT='test';
        FAOU1.LOTTRACKCODE='test';        
        FAOU1.PARTCLASS='test';
        FAOU1.PARTUOM='test';
        FAOU1.PC410='test';
        FAOU1.PC411='test';
        FAOU1.PC420='test';
        FAOU1.PC421='test';
        FAOU1.PC430='test';
        FAOU1.PC431='test';
        FAOU1.PC440='test';
        FAOU1.PC441='test';
        FAOU1.PLANNER='test';
        FAOU1.PNGPFACE='test';
        FAOU1.PNMODEL='test';
        FAOU1.PROVIDE='test';
        FAOU1.RESPONSIBLE_ID='test';
        FAOU1.SALESGROUP='test';
        FAOU1.SALESPRICEGROUP='test';
        FAOU1.SERIALTRACKCODE='test';
        FAOU1.SHLTSTBDYPSIG=0;
        FAOU1.SOURCINGOPT='test';
        FAOU1.VENDORPAINT='test';
        
        FAOU1.PRDLIN='test';
        FAOU1.ASSYPARTNO='test';
        FAOU1.OWs='test';
        FAOU1.OAs='test';
        FAOU1.OBs='test';
        FAOU1.AtmPresPSIA=0;
        FAOU1.CriticalPresRatio=0;
        FAOU1.FlowPresPSIG=0;
        FAOU1.FlowTempDEGR=0;
        FAOU1.GINLOP='test';
        FAOU1.GMODEL='test';
        FAOU1.GMODEL7='test';
        FAOU1.GOUTOP='test';
        FAOU1.InletFlowPresPSIA=0;
        FAOU1.MaxAlowdPresDropPSIG=0;
        FAOU1.MinReqdFlowRateSCFH=0;
        FAOU1.OnEngrHoldFlag='test';
        FAOU1.OpPresPSIA=0;
        FAOU1.PC='test';
        FAOU1.PresRatio=0;
        FAOU1.RunUpLengthAIn=0;
        FAOU1.RunUpLengthBIn=0;
        FAOU1.ShlTstBdyPSIGMx=0;
        FAOU1.UOMSystem='test';
        FAOU1.PTC='test';
        FAOU1.SZC='test';
        FAOU1.ESZC='test';
        FAOU1.MCELEM='test';
        FAOU1.SHLTSTMETHBDY='test';
        FAOU1.Model='test';
        FAOU1.ASSYLOCATION='test';
        FAOU1.ATEX='test';
        FAOU1.BRAND='test';
        FAOU1.BRINHARDEXAM='test';
        FAOU1.CHARPYIMPEXAM='test';
        FAOU1.CUTR='test';
        FAOU1.FWLDP='test';
        FAOU1.GINLOP_OptA='test';
        FAOU1.GINLOP_OptB='test';
        FAOU1.GINLOP_OptC='test';
        FAOU1.GOUTOP_OptA='test';
        FAOU1.GOUTOP_OptB='test';
        FAOU1.GOUTOP_OptC='test';
        FAOU1.GPAINT='test';
        FAOU1.HCLASS='test';
        FAOU1.IGCEXAM='test';
        FAOU1.K=0;
        FAOU1.LDP='test';
        FAOU1.MAGPARTEXAM='test';
        FAOU1.MATLSOURCE='test';
        FAOU1.MCBODY='test';
        FAOU1.MCDPHM='test';
        FAOU1.MCELMT='test';
        FAOU1.MCHOUS='test';
        FAOU1.MCPALL='test';
        FAOU1.NACE='test';
        FAOU1.PMI='test';
        FAOU1.PressureSide='test';
        FAOU1.SETTING='test';
        FAOU1.SPRING='test';
        FAOU1.USCG='test';
        FAOU1.USONICEXAM='test';
        FAOU1.VISCASTEXAM='test';
        FAOU1.XRAY='test';
        FAOU1.GasGroupLevel='test';        

        Test.stopTest();
    }
        
    
    public static FAOutputUtilityXML FAOU1XML{get;set;} 
	@isTest
    public static void testXMLMethod1Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        FAOU1XML=new FAOutputUtilityXML(configFA.flmProd.Id);
        
        decimal dec;
        string str;
        str=FAOU1XML.PARTNUMBER;
        FAOU1XML.PARTNUMBER='test';
        str=FAOU1XML.PARTREV;
        FAOU1XML.PARTREV='test';
        str=FAOU1XML.DESCRIPTION;
        FAOU1XML.DESCRIPTION='test';
        str=FAOU1XML.LOTTRACKCODE;
        FAOU1XML.LOTTRACKCODE='test';
     	str=FAOU1XML.PROVIDE;
        FAOU1XML.PROVIDE='test';
        str=FAOU1XML.SERIALTRACKCODE;
        FAOU1XML.SERIALTRACKCODE='test';
        str=FAOU1XML.PARTCLASS;
        FAOU1XML.PARTCLASS='test';
        str=FAOU1XML.RESPONSIBLE_ID;
        FAOU1XML.RESPONSIBLE_ID='test';
        str=FAOU1XML.ASSEMBLYWTUOM;
        FAOU1XML.ASSEMBLYWTUOM='test';
        str=FAOU1XML.ASSEMBLYWT;
        FAOU1XML.ASSEMBLYWT='test';
        str=FAOU1XML.COMPRESPONID;
        FAOU1XML.COMPRESPONID='test';
        str=FAOU1XML.COMPDESCRIPTION;
        FAOU1XML.COMPDESCRIPTION='test';
        str=FAOU1XML.COMPINVSERTRK;
        FAOU1XML.COMPINVSERTRK='test';
        str=FAOU1XML.COMPLOTTRACK;
        FAOU1XML.COMPLOTTRACK='test';
        str=FAOU1XML.COMPPROVIDE;
        FAOU1XML.COMPPROVIDE='test';
        str=FAOU1XML.ATTRTEMPLATE;
        FAOU1XML.ATTRTEMPLATE='test';
        str=FAOU1XML.CUSTOMSTATNO;
        FAOU1XML.CUSTOMSTATNO='test';
        str=FAOU1XML.PLANNER;
        FAOU1XML.PLANNER='test';
        str=FAOU1XML.SALESGROUP;
        FAOU1XML.SALESGROUP='test';
        str=FAOU1XML.SALESPRICEGROUP;
        FAOU1XML.SALESPRICEGROUP='test';
        str=FAOU1XML.HSNSACCODE;
        FAOU1XML.HSNSACCODE='test';
        str=FAOU1XML.PARTUOM;
        FAOU1XML.PARTUOM='test';
        str=FAOU1XML.PRDLIN;
        FAOU1XML.PRDLIN='test';
        str=FAOU1XML.NOTE;
        FAOU1XML.NOTE='test';
        str=FAOU1XML.PARTMANAGEDIN;
        FAOU1XML.PARTMANAGEDIN='test';
        FAOU1XML.getPartNumber();
        
        Test.stopTest();
    }
    
    public static FAOutputUtilityXML FAOU2XML{get;set;} 
    public static FAOutputUtilityXML FAOU3XML{get;set;} 
    
    @isTest
    public static void testOutputMethod1Section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        FAOU2XML=new FAOutputUtilityXML(configFA.flmProd.id);

        FAOU2XML.getEngPartCharacterXML();
        FAOU2XML.getEngPartStructureXML();
        FAOU2XML.getEngineeringParts();
        FAOU2XML.GetInventoryPartDetails();
        FAOU2XML.getSalesParts();
       
        Test.stopTest();
    }

    @isTest
    public static void testOutputMethod2section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl();
        FAOU3XML=new FAOutputUtilityXML(configFA.flmProd.Id);
        
        FAOU3XML.getProductCatalog();
        FAOU3XML.getPurchasePart();
        FAOU3XML.getPurchasePartSuppliers();
        FAOU3XML.getStructureXML();
        FAOU3XML.GetControlPlanDetails();
        FAOU3XML.GetRoutingDetails();
        
        Test.stopTest();
    }
    
    @isTest
    public static configureFLAMEproduct getconfigFACntrl3() {
                 
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        system.debug('TestDataFAUtility.quoteLine:'+TestDataFAUtility.quoteLine);
        system.debug('TestDataFAUtility.mapWithFAValues:'+TestDataFAUtility.mapWithFAValues);
        TestDataFAUtility.createFATestRecords();
        TestDataFAUtility.createFAMasterTestRecords();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA = [SELECT Id FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new configureFLAMEproduct(quoteLine.Id);
    }        
  
    
    @isTest
    public static void testOutputMethod22section() {
    
        Test.startTest();
        
        configureFLAMEproduct configFA = ConfigureFlameProductControllerTest.getconfigFACntrl3();
        configFA.getIFSAttributes();
        
        Test.stopTest();
    }
  
}