@isTest
public class ConfigureBGRProductTest {
	
    @testSetup
    public static void dataSetup() {
        
        Map<String, String> mapWithBGRValues = new Map<String, String>();
        mapWithBGRValues.put('BRAND','Groth');
        mapWithBGRValues.put('PRODUCT_CODE','BGR');
        mapWithBGRValues.put('PRODUCT_NAME','BlanketGasRegulator'); 
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithBGRValues);       
        TestDataBGRUtility.quoteLine = quoteLine;
        TestDataBGRUtility.mapWithBGRValues = mapWithBGRValues;       
        TestDataBGRUtility.createBGRTestRecords();
        TestDataBGRUtility.createBGRMasterTestRecords();       

		BGR__c conBGR = [SELECT Id, Quote_Line__c FROM BGR__c LIMIT 1];
        conBGR.Quote_Line__c = quoteLine.Id;
        conBGR.Quantity__c = 1;
        conBGR.Supply_Gas_Temperature_Units__c = 'Deg R';
        conBGR.Minimum_Required_Flow_Capacity__c = 5.0;
        conBGR.Flow_Units__c = 'kg/min';
		update conBGR;        
    }
    
    public static configureBGRProduct getConfigBGRCntrl() {
        
        List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        TestDataBGRUtility.quoteLine = quoteLine[0];
        BGR__c conBGR = [SELECT Id FROM BGR__c LIMIT 1];

        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine[0].Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(TestDataUtility.quoteLine);
        new configureBGRProduct(sc);
        
        return new configureBGRProduct(TestDataBGRUtility.quoteLine.Id);
    }
    
    @isTest
    public static void genericCoverage() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRProductTest.getConfigBGRCntrl();
        configBGR.ReorderFlag = false;
        
        configBGR.fetchBGR();
        configBGR.EnableEditMode();
        configBGR.checkoverridevalue();
        configBGR.showSectionB();
        configBGR.goBack();
        configBGR.goBackToQuote();
        configBGR.cleanSecB();
        configBGR.cleanSecC();
        configBGR.cleanSecD();
        configBGR.cleanSecE();
        configBGR.cleanSecF();
        configBGR.cleanSecG();
        
        configBGR.SaveDocID();
        configBGR.saveRelief();
        configBGR.saveSetting();
        configBGR.saveAtm();
        configBGR.TempUnit();
        configBGR.ConSCFH();
        
        configBGR.saveSectionB();
        configBGR.saveCertificate();
		configBGR.saveProductSelection();
		configBGR.saveProductMaterials();        
        configBGR.showPopup();
        configBGR.saveValveExamination();
        configBGR.saveDocSourcing();
        String tmp = configBGR.strquoteDes;
        configBGR.getPartNum();
        configBGR.saveNotes();
        configBGR.getPricinglist();
        configBGR.ApplyDefaultPricing();
        configBGR.SavePriceOverride();
        configureBGRProduct.addQliSyncFlag(TestDataBGRUtility.quoteLine);
        
        configBGR.getLeadBGROutputInstance();
        configBGR.GetLeadTimeRecs();
        configBGR.ApplyDefaultLeadtime();
        configBGR.SaveLeadTimeOverride();
        configBGR.setBlankForNull('test');
        
        configBGR.ApplyDefaultQuoteDescription();
        configBGR.SaveQuoteDescriptionOverride();
        configBGR.generatePartNumber();
        configBGR.saveConbgr();
        configBGR.getProDoc();
        
               
        Test.stopTest();
    }
    
    @isTest
    public static void genericCoverage2() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRProductTest.getConfigBGRCntrl();
        configBGR.ReorderFlag = false;
       
        configBGR.getGuildeline();
        configBGR.GetRoutingDetails();
        configBGR.GetControlPlanDetails();
        configBGR.getTypes1();
        configBGR.getTypes2();
        configBGR.getTypes3();
        configBGR.getTypes4();
        configBGR.getTypes5();
        configBGR.getTypes6();
        configBGR.getTypes7();
        configBGR.getTypes8();
        configBGR.SupplyGas();
        configBGR.getSoftGoodsMaterial();
        configBGR.getConnection();
        configBGR.costOnload();
        configBGR.saveCosting();
        configBGR.ApplyDefaultCost();
        configBGR.cleanBGRrecord();
        //
        configBGR.getTroubleShootingAttributes();
        
        configBGR.showSecB = false;
        configBGR.getcomboorifice = 'Test';
        
        Cost__c costRecord = new Cost__c();
        costRecord.Inside_Cost_10__c = '1';
        costRecord.Outside_Cost_10__c = '1';
        costRecord.Inside_Cost_20__c = '1';
        costRecord.Outside_Cost_20__c = '1';
        costRecord.Inside_Cost_30__c = '1';
        costRecord.Outside_Cost_30__c = '1';
        insert costRecord;
        configBGR.copyCostToCostOverride(costRecord);
        
        configBGR.ASYTYP = 'Test';
        String tmp = configBGR.ASYTYP;
        
        configBGR.GMODEL = 'Test';
        tmp = configBGR.GMODEL;
        
        configBGR.GTAGPN = 'Test';
        tmp = configBGR.GTAGPN;
        
        configBGR.IINO = 'Test';
        tmp = configBGR.IINO;
        
        configBGR.PC = 'Test';
        tmp = configBGR.PC;
        
        configBGR.PTC = 'Test';
        tmp = configBGR.PTC;
        
        configBGR.RGEUNT = 'Test';
        tmp = configBGR.RGEUNT;
        
        configBGR.GPRSC1 = 'Test';
        tmp = configBGR.GPRSC1;
        
        configBGR.RTPRS1 = 'Test';
        //tmp = configBGR.RTPRS1;
        
        configBGR.SETINWC = 'Test';
        tmp = configBGR.SETINWC;
        
        configBGR.SETTINGMAX = 'Test';
        tmp = configBGR.SETTINGMAX;
        
        configBGR.SETTINGMIN = 'Test';
        tmp = configBGR.SETTINGMIN;
        
        configBGR.SHLTSTACTPSIG = 'Test';
        tmp = configBGR.SHLTSTACTPSIG;
        
        configBGR.SHLTSTACTPSIGMX = 'Test';
        tmp = configBGR.SHLTSTACTPSIGMX;
        
        configBGR.SHLTSTBDYPSIG = 'Test';
        tmp = configBGR.SHLTSTBDYPSIG;
        
        configBGR.SHLTSTBDYPSIGMX = 'Test';
        tmp = configBGR.SHLTSTBDYPSIGMX;
        
        configBGR.SHUTOFFMIN = 'Test';
        tmp = configBGR.SHUTOFFMIN;
        
        configBGR.SHUTOFFMAX = 'Test';
        tmp = configBGR.SHUTOFFMAX;
        
        configBGR.SPRINGCODE = 'Test';
        tmp = configBGR.SPRINGCODE;
        
        configBGR.TAGMAXACTPRES = 'Test';
        tmp = configBGR.TAGMAXACTPRES;
        
        configBGR.TAGMAXSUPPRES = 'Test';
        tmp = configBGR.TAGMAXSUPPRES;
        
        configBGR.TAGSPRGRANGE = 'Test';
        tmp = configBGR.TAGSPRGRANGE;
        
        configBGR.ASSEMBLYWT = 'Test';
        tmp = configBGR.ASSEMBLYWT;
        
        configBGR.ASSEMBLYWTUOM = 'Test';
        tmp = configBGR.ASSEMBLYWTUOM;
        
        configBGR.ATMPRESPSIA = 'Test';
        tmp = configBGR.ATMPRESPSIA;
        
        configBGR.ATTRTEMPLATE = 'Test';
        tmp = configBGR.ATTRTEMPLATE;
        
        configBGR.BRANDCODE = 'Test';
        tmp = configBGR.BRANDCODE;
        
        configBGR.COMPDESCRIPTION = 'Test';
        tmp = configBGR.COMPDESCRIPTION;
        
        configBGR.COMPINVSERTRK = 'Test';
        tmp = configBGR.COMPINVSERTRK;
        
        configBGR.SUPRS1 = 'Test';
        tmp = configBGR.SUPRS1;
        
        configBGR.SUPRSU = 'Test';
        tmp = configBGR.SUPRSU;
        
        configBGR.PRDLIN = 'Test';
        tmp = configBGR.PRDLIN;
        
        BGR__c conBGR = [SELECT Id FROM BGR__c LIMIT 1];
        conBGR.Quantity__c = 1;
        conBGR.Schedule_2__c = 'BGRA';
        conBGR.Schedule__c = 'BGREST';
        update conBGR;
        
        Test.stopTest();
    }
    
    @isTest
    public static void genericCoverage3() {
        
        Test.startTest();
        configureBGRProduct configBGR = ConfigureBGRProductTest.getConfigBGRCntrl();
        configBGR.ReorderFlag = false;
       
        BGR__c conBGR = [SELECT Id FROM BGR__c LIMIT 1];
        conBGR.Quantity__c = 1;
        conBGR.Schedule_2__c = 'BGRA';
        conBGR.Schedule__c = 'BGREST';
        update conBGR;
        
        //String SOQL = 'select ID, Schedule__c, Site_10__c, Site_20__c,Site_30__c,Site_40__c,Lead_Time_10_Override__c,Lead_Time_20_Override__c,Lead_Time_30_Override__c,Lead_Time_40_Override__c';
		BGR_lead_time__c leadTime = new BGR_lead_time__c();
        leadTime.Schedule__c = 'BGRA';
        leadTime.Site_10__c = 10;
        leadTime.Site_20__c = 20;
        leadTime.Site_30__c = 30;
        leadTime.Site_40__c = 40;
        leadTime.Lead_Time_10_Override__c = 10;
        leadTime.Lead_Time_20_Override__c = 20;
        leadTime.Lead_Time_30_Override__c = 30;
        leadTime.Lead_Time_30_Override__c = 40;
        leadTime.QtyLL__c = 0;
        leadTime.QtyUL__c = 1;
        insert leadTime;
        
        configBGR.saveDocSourcing();
        configBGR.getPricinglist();
        configBGR.ApplyDefaultPricing();
        configBGR.SavePriceOverride();
        
        
        configBGR.saveCertificate();
        
        Test.stopTest();
    }
}