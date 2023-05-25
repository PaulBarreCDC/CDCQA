@isTest
public class DataSelectorWizardTest {
    
    
    @isTest
    public static void TestMethod1() {
        
        Test.startTest();
        
        configureFLAMEproduct configWGB = DataSelectorWizardTest.getconfigFACntrl();
        
        //configureBGRProduct configBGR = DataSelectorWizardTest.getConfigBGRCntrl();
        
      //  configHolderController configHolder = DataSelectorWizardTest.getConfigHolderCntrl();
        
        DataSelectorWizard.getInstance();
        //   DataSelectorWizard.getBGRProductRecord(configBGR.conBGR.Id);
        DataSelectorWizard.getFlameProductRecord();
        try{
            DataSelectorWizard.getFlameProductRecord(configWGB.flmProd.id);
            
            //DataSelectorWizard.getBGRProductRecord(configBGR.conBGR.Id);
            
            //DataSelectorWizard.getHolderProductRecord(configHolder.conHolder.Id);
        }
        catch(Exception e) {}
        
        result res=new result();        
        //List<GasFlowRate__c> gas=new List<GasFlowRate__c>();
      //  gas=[SELECT DensityActualFrom__c,DensityActualTo__c,DensityStandardFrom__c,DensityStandardTo__c,Flag__c,
      //       GasFlowRate_UOM_From__c,GasFlowRate_UOM_To__c,Multiplier__c,PFromPsia__c,PToPsia__c,TFromR__c,TToR__c FROM GasFlowRate__c];
        GasFlowRate__c gas = [SELECT DensityActualFrom__c,DensityActualTo__c,DensityStandardFrom__c,DensityStandardTo__c,Flag__c,
             GasFlowRate_UOM_From__c,GasFlowRate_UOM_To__c,Multiplier__c,PFromPsia__c,PToPsia__c,TFromR__c,TToR__c FROM GasFlowRate__c limit 1];
       
        res=DataSelectorWizard.convertGasFlowRate(gas,10,1,1,1,1);
        res=DataSelectorWizard.convertGasFlowRate(gas,10,1,1,1,1);
        res=DataSelectorWizard.convertGasFlowRate(gas,null,1,1,1,1);    
        //    DataSelectorWizard.getHolderProductRecord(configHolder.conHolder.Id);
        //  DataSelectorWizard.getPartSelectorRecord('aaaaaaa');
        
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void TestMethod2() {
        
        Test.startTest();
        
        configHolderController configHolder = DataSelectorWizardTest.getConfigHolderCntrl();
        
        try{
            DataSelectorWizard.getHolderProductRecord(configHolder.conHolder.Id);
        }
        catch(Exception e) {}
        
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void TestMethod3() {
        
        Test.startTest();
                
        configureBGRProduct configBGR = DataSelectorWizardTest.getConfigBGRCntrl();
        
        
        DataSelectorWizard.getInstance();
        //   DataSelectorWizard.getBGRProductRecord(configBGR.conBGR.Id);
        DataSelectorWizard.getFlameProductRecord();
        try{
            
            DataSelectorWizard.getBGRProductRecord(configBGR.conBGR.Id);
            
        }
        catch(Exception e) {}
        
        Test.stopTest();
        
    }
    
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
    
    public static configHolderController getConfigHolderCntrl() {
        
        //     Test.startTest();
        
        ConfigHolderControllerTest.configValues();
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataUtility.quoteLine.Id);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataUtility.createHoldersTestRecords();
        TestDataUtility.createHoldersMasterTestRecords();
        
        PageReference pager = Page.ConfigHolders;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(TestDataUtility.quoteLine.Id));
        
        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :TestDataUtility.quoteLine.Id LIMIT 1];
        system.debug('conHolder:'+conHolder);
        
        System.debug('quoteId...'+TestDataUtility.quoteLine.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(TestDataUtility.quoteLine);
        //    Test.stopTest();
        return new configHolderController(sc);
    }
    
    
    @isTest 
    public static configureBGRProduct getConfigBGRCntrl() 
    {
        //  Test.startTest();
        
        Map<String, String> mapWithBGRValues = new Map<String, String>();
        mapWithBGRValues.put('BRAND','Groth');
        mapWithBGRValues.put('PRODUCT_CODE','BGR');
        mapWithBGRValues.put('PRODUCT_NAME','BlanketGasRegulator2');     
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
        //   Test.stopTest();
        return new configureBGRProduct(sc);
    }
    
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
        TestDataFAUtility.createFATestRecords2();
        TestDataFAUtility.createFAMasterTestRecords2();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA = [SELECT Id FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new configureFLAMEproduct(sc);
    }        
    
}