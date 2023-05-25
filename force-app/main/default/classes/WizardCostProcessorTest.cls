@isTest
public class WizardCostProcessorTest 
{
 
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
    
    @isTest static void TestMethod1(){

        Test.startTest();
        result res=new result();  
         
        configureFLAMEproduct configFA = WizardCostProcessorTest.getconfigFACntrl();
        
        WizardCostProcessor WizardClass=new WizardCostProcessor(configFA.flmProd.id); 
      /*  WizardCostProcessorTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordForPricing();
		
       	TestDataRDUtility.conProd.Part_Number__c='V7658A0312335ARTT00002';
        
        WizardCostProcessor WizardClass=new WizardCostProcessor(TestDataRDUtility.conProd.id);*/
        
        WizardClass.getAssembleCost();
        WizardClass.getBGRCostData();
        WizardClass.getBuildCost();
        
        Cost_Routing_Inside__c ac=new Cost_Routing_Inside__c();
        List<Cost_Routing_Inside__c> a=new List<Cost_Routing_Inside__c>();
        a.add(ac);
        WizardClass.routingInCost=a;
        
        Cost_Routing_Outside__c ac2=new Cost_Routing_Outside__c();
        List<Cost_Routing_Outside__c> a2=new List<Cost_Routing_Outside__c>();
        a2.add(ac2);
        WizardClass.routingOutCost=a2;
        
        Cost_Part_Number__c ac3=new Cost_Part_Number__c();
        List<Cost_Part_Number__c> a3=new List<Cost_Part_Number__c>();
        a3.add(ac3);
        WizardClass.getAssemblyCost=a3;
        WizardClass.getBuiltCost=a3;
        
        RD_Cost__c ac5=new RD_Cost__c();
        List<RD_Cost__c> a5=new List<RD_Cost__c>();
        a5.add(ac5);
        WizardClass.getRDBuiltCost=a5;
        
       /* BGR__c ac6=new BGR__c();
        List<BGR__c> a6=new List<BGR__c>();
        a6.add(ac6);*/
        BGR__c ac6=new BGR__c();
        ac6=WizardClass.conBGR;
        
        
      //  WizardClass.routingInCost=a
        
        map<string,string> map1=new map<string,string>();
        string str2='a';
        map1.put('aa',str2);
        WizardClass.mapSZCField=map1;
        WizardClass.mapPTCField=map1;
        WizardClass.mapQTYField=map1;
      
        /*BGROutputUtility bgrou;
        bgrou=WizardClass.BGROU;*/
        
        
     //   WizardClass.getRoutingInCost();
     //   WizardClass.getRoutingOutCost();
        //WizardClass.
        string str='';
        str=WizardClass.checkforBlankNull('aa');
      //  WizardClass.CostWrapper FAWrap = new WizardClass.CostWrapper();
        
        Test.stopTest();
    }
    
    
    
 
    @isTest static void TestMethod2(){

        Test.startTest();
        result res=new result();           
        
        configureFLAMEproduct configFA = WizardCostProcessorTest.getconfigFACntrl();        
        WizardCostProcessor WizardClass=new WizardCostProcessor(configFA.flmProd.id); 
        
		WizardClass.getCostRecords();
        WizardClass.getCosts();
        res=WizardClass.addBGRCostData();
   
      //    WizardClass.getRoutingOutCost();
     //    WizardClass.getRDBulidCost();
    //    WizardClass.getRDCostData();
        
        Test.stopTest();
    }
    
   @isTest static void TestMethod3(){

        Test.startTest();
        result res=new result();  
         
      //  ConfigureRD conRD = ConfigureRDTest.getConfigRDCntrl();
     //   WizardCostProcessor WizardClass=new WizardCostProcessor(conRD.conProd.id); 
       
       	WizardCostProcessorTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordForPricing();
		
       	TestDataRDUtility.conProd.Part_Number__c='V7658A0312335ARTT00002';
        
        WizardCostProcessor WizardClass=new WizardCostProcessor(TestDataRDUtility.conProd.id);

        //WizardClass.getAssembleCost();
        WizardClass.getRDBulidCost();
        WizardClass.getRDCostData();
        
        Test.stopTest();
    }
       
    @isTest static void TestMethod4(){

        Test.startTest();
        result res=new result();  
         
        configureFLAMEproduct configFA = WizardCostProcessorTest.getconfigFACntrl();        
        WizardCostProcessor WizardClass=new WizardCostProcessor(configFA.flmProd.id); 
        
        WizardClass.getRoutingInCost();
        WizardClass.getRoutingOutCost();
        string str='';
        str=WizardClass.checkforBlankNull('aa');
        
        Test.stopTest();
    }
    
     @isTest static void TestMethod5(){

        Test.startTest();
        result res=new result();  
         
        configureFLAMEproduct configFA = WizardCostProcessorTest.getconfigFACntrl();        
        WizardCostProcessor WizardClass=new WizardCostProcessor(configFA.flmProd.id); 
        
        Cost__c costrecord=new Cost__c();
        costrecord.Inside_Cost_10__c='10';
        costrecord.Inside_Cost_20__c='10';
        costrecord.Inside_Cost_30__c='10';
		costrecord.Outside_Cost_10__c='10';
        costrecord.Outside_Cost_20__c='10';
		costrecord.Outside_Cost_30__c='10'; 
        insert costrecord;
        List<WizardCostProcessor.CostWrapper> cos=new  List<WizardCostProcessor.CostWrapper>();
       	cos.add(new WizardCostProcessor.CostWrapper(costrecord));
       // WizardClass.CostWrapper costrec=WizardClass.CostWrapper(costrecord);
      //  costrecord.
      //  WizardClass.getRoutingInCost();
      //  WizardClass.getRoutingOutCost();
      //  string str='';
     //   str=WizardClass.checkforBlankNull('aa');
        
        Test.stopTest();
    }
       
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
    
    
    /*
    @isTest
    public static ConfigureRD getConfigRDCntrl() {
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;
        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();

        PageReference pager = Page.ConfigRD;
        Test.setCurrentPage(pager);

        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        TestDataRDUtility.createRDTestRecSecAandEwithHPZ();
        Rupture_Disc__c conProd = [SELECT Id FROM Rupture_Disc__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];

        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);

        return new ConfigureRD(sc);
    }
    
    
     @isTest
    public static configureRD getconfigRDCntrl() {                 
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;        

        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();
        TestDataRDUtility.createRDTestRecords1();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        rupture_disc__c conrd = [SELECT Id FROM rupture_disc__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        
        return new configureRD(sc);
        
    }*/
    
}