@isTest
public class AssyPartDefinationProcessorTest {
    
    @isTest
    public static void testCopyValuesFromTransData() {
        
        Test.startTest();
        
        Map<String, String> mapWithWGBValues = new Map<String, String>();
        mapWithWGBValues.put('BRAND','Groth');
        mapWithWGBValues.put('PRODUCT_CODE','WGB');
        mapWithWGBValues.put('PRODUCT_NAME','WasteGasBurner');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithWGBValues);
        
        TestDataWGBUtility.quoteLine = quoteLine;
        TestDataWGBUtility.mapWithWGBValues = mapWithWGBValues;
        
        system.debug('TestDataWGBUtility.quoteLine:'+TestDataWGBUtility.quoteLine);
        system.debug('TestDataWGBUtility.mapWithWGBValues:'+TestDataWGBUtility.mapWithWGBValues);
        TestDataWGBUtility.createWGBTestRecords();
        TestDataWGBUtility.createWGBMasterTestRecords();
        TestDataWGBUtility.createWGBAssyPartRecords();
        
        PageReference pager = Page.ConfigWGBProduct;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        WasteGasBurner__c conWGB = [SELECT Id FROM WasteGasBurner__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);
        CustomReOrderController configWGB2 =new CustomReOrderController(sc);
        
        //  configWGB2.selectedProduct='byPartumber';
        
        configWGB2.quoteId=String.valueOf(quoteLine.Id);
        configWGB2.selectedProduct='byPartumber';
        configWGB2.reOrderProduct();
        
        Map<string,string> bgrFields = AssyPartDefinationProcessor.mapBGRFields;
        Map<string,string> faFields = AssyPartDefinationProcessor.mapFAFields;
        Map<string,string> rdFields = AssyPartDefinationProcessor.mapRDFields;
        Map<string,string> hldFields = AssyPartDefinationProcessor.mapHLDFields;
        Map<string,string> rvFields = AssyPartDefinationProcessor.mapRVFields;
        Map<string,string> wgbFields = AssyPartDefinationProcessor.mapWGBFields;
        Map<string,string> psFields = AssyPartDefinationProcessor.mapPSFields;
        Map<string,string> partBaseNo = AssyPartDefinationProcessor.mapPartBaseNo;
        Map<string,string> mapConfigWithObj = AssyPartDefinationProcessor.mapConfiguratorwithObject;
        Map<string,string> mapConfigWithObj1 = AssyPartDefinationProcessor.mapObjectwithConfigurator1;
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void testGeneratePartNumber() {
        
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        Holders__c holder = [SELECT Id, Brand__c, ASSYPARTNOBASE__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];        
        holder.ASSYPARTNOBASE__c = '100000100000';
        update holder;
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        
        Test.startTest();
        configHld.generatePartNumber();
        configHld.savePartNumber();
        Test.stopTest();
    }
    
    @isTest
    public static void testGetPartNumberExisting() {
        
        Test.startTest();
        
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
        
        ConfigHolderControllerTest.configValues();
        
        TestDataUtility.createHoldersTestRecords();
        TestDataUtility.createHoldersMasterTestRecords();
        
        List<SBQQ__QuoteLine__c> quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
                
        Holders__c holder = [SELECT Id, Brand__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c, ASME_Section_VIII__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine[0].Id LIMIT 1];        
        holder.ASSYPARTNOBASE__c = '100000100000';
        update holder;
        
        AssyPartDefinition__c asd = new AssyPartDefinition__c();
        asd.ASSYPARTNO__c = '100000100000';
        asd.BRAND__c = 'CDC';
        asd.Configurator__c = 'HLD';
        insert asd;
        
        Test.loadData(ConfigInputsTranslation__c.sObjectType, 'ConfigInputsTranslation_Data');
        
        AssyPartDefinationProcessor.getPartNumberExisting(holder.ASSYPARTNOBASE__c, holder, 'HLD');
        AssyPartDefinationProcessor.copyValuesFromTransData(holder, holder.ASSYPARTNOBASE__c);
        Test.stopTest();  
    }
    
    @isTest
    public static void testGetPartNumberByRec() {
        
        Test.startTest();
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        Holders__c holder = [SELECT Id, Brand__c, ASSYPARTNOBASE__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];        
        holder.ASSYPARTNOBASE__c = '100000100000';
        update holder;
        
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id,Name,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Id currentId = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLines[0].Id);
        Result sObj = wizardBaseDataProcessor.getObjectDataById(currentId); 
        AssyPartDefinationProcessor.getPartNumberByRec(sObj.objResultList[0]);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testGetPartNumberByRec2() {
        
        Test.startTest();
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        Holders__c holder = [SELECT Id, Brand__c, ASSYPARTNOBASE__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];        
        holder.ASSYPARTNOBASE__c = '100000100000';
        update holder;
        
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id,Name,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Id currentId = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLines[0].Id);
        Result sObj = wizardBaseDataProcessor.getObjectDataById(currentId); 
        AssyPartDefinationProcessor.getPartNumberByRec(sObj.objResultList[0]);
          AssyPartDefinationProcessor.mapObjectwithConfigurator=new Map<String,String>();
          AssyPartDefinationProcessor.mapObjectwithConfigurator.put('Holders__c','PS');
          AssyPartDefinationProcessor.mapQuoteNo.put('PS' ,'Cost_Override__c');
          Holders__c hld= (Holders__c) sObj.objResultList[0];
          hld.Cost_Override__c=true;
          Part_Selector__c pstest = new Part_Selector__c();
          pstest.Quote_Description_Engineer_Override__c=true;
          pstest.Quote_Line__c= quoteLines[0].id;
          pstest.NEWSPCLPARTNOBASE__c='LD#TBA';
          insert pstest ;
        AssyPartDefinationProcessor.generatePartNumber(pstest);
            AssyPartDefinationProcessor.mapFAFields=new Map<String,String>();
        AssyPartDefinationProcessor.mapBrandwithCode=new Map<String,String>();
         AssyPartDefinationProcessor.mapObjectwithConfigurator1=new Map<String,String>();
        
           AssyPartDefinationProcessor.mapBGRFields=new Map<String,String>();
            AssyPartDefinationProcessor.mapPSFields=new Map<String,String>();
             AssyPartDefinationProcessor.mapWGBFields=new Map<String,String>();
              AssyPartDefinationProcessor.mapHLDFields=new Map<String,String>();
               AssyPartDefinationProcessor.mapRDFields=new Map<String,String>();
                AssyPartDefinationProcessor.mapRVFields=new Map<String,String>();
                 AssyPartDefinationProcessor.mapConfiguratorwithObject=new Map<String,String>();
        
        
        
        
        
        
        
        
        
        Test.stopTest();
    }
    
      @isTest
    public static void testGetPartNumberByRec3() {
        
        Test.startTest();
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        Holders__c holder = [SELECT Id, Brand__c, ASSYPARTNOBASE__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];        
        holder.ASSYPARTNOBASE__c = '100000100000';
        update holder;
        
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id,Name,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Id currentId = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLines[0].Id);
        Result sObj = wizardBaseDataProcessor.getObjectDataById(currentId); 
        AssyPartDefinationProcessor.getPartNumberByRec(sObj.objResultList[0]);
          AssyPartDefinationProcessor.mapObjectwithConfigurator=new Map<String,String>();
          AssyPartDefinationProcessor.mapObjectwithConfigurator.put('Holders__c','PS');
          AssyPartDefinationProcessor.mapQuoteNo.put('PS' ,'Cost_Override__c');
          Holders__c hld= (Holders__c) sObj.objResultList[0];
          hld.Cost_Override__c=true;
          Part_Selector__c pstest = new Part_Selector__c();
          pstest.Quote_Description_Engineer_Override__c=true;
          pstest.Quote_Line__c= quoteLines[0].id;
          //pstest.NEWSPCLPARTNOBASE__c='CD#TBA';
          insert pstest ;
        AssyPartDefinationProcessor.generatePartNumber(pstest);
        pstest.NEWSPCLPARTNOBASE__c='CD#TBA';
          update pstest ;
                  AssyPartDefinationProcessor.generatePartNumber(pstest);
            AssyPartDefinationProcessor.mapFAFields=new Map<String,String>();
        AssyPartDefinationProcessor.mapBrandwithCode=new Map<String,String>();
         AssyPartDefinationProcessor.mapObjectwithConfigurator1=new Map<String,String>();
        
           AssyPartDefinationProcessor.mapBGRFields=new Map<String,String>();
            AssyPartDefinationProcessor.mapPSFields=new Map<String,String>();
             AssyPartDefinationProcessor.mapWGBFields=new Map<String,String>();
              AssyPartDefinationProcessor.mapHLDFields=new Map<String,String>();
               AssyPartDefinationProcessor.mapRDFields=new Map<String,String>();
                AssyPartDefinationProcessor.mapRVFields=new Map<String,String>();
                 AssyPartDefinationProcessor.mapConfiguratorwithObject=new Map<String,String>();
        Test.stopTest();
    }
   @isTest
    public static void testGetPartNumberByRec4() {
        
        Test.startTest();
        ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
        
        Map<String, String> mapWithHolderValues = new Map<String, String>();
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        Holders__c holder = [SELECT Id, Brand__c, ASSYPARTNOBASE__c, Holder_Product_Code__c, Size2__c, Bolting_Class__c, Part_Number_Base__c, ASSYPARTEXISTING__c  FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];        
        holder.ASSYPARTNOBASE__c = '100000100000';
        update holder;
        
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id,Name,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Id currentId = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLines[0].Id);
        Result sObj = wizardBaseDataProcessor.getObjectDataById(currentId); 
       // AssyPartDefinationProcessor.getPartNumberByRec(sObj.objResultList[0]);
          AssyPartDefinationProcessor.mapObjectwithConfigurator=new Map<String,String>();
          AssyPartDefinationProcessor.mapObjectwithConfigurator.put('Holders__c','PS');
          AssyPartDefinationProcessor.mapQuoteNo.put('PS' ,'Cost_Override__c');
          Holders__c hld= (Holders__c) sObj.objResultList[0];
          hld.Cost_Override__c=true;
          BGR__c bgr = new BGR__c();
           bgr.Quote_Line__c= quoteLines[0].id;
           bgr.Quote_Description_Engineer_Override__c=false;
          insert bgr;
          Part_Selector__c pstest = new Part_Selector__c();
          pstest.Quote_Description_Engineer_Override__c=true;
          pstest.Quote_Line__c= quoteLines[0].id;
          //pstest.NEWSPCLPARTNOBASE__c='CD#TBA';
          insert pstest ;

        AssyPartDefinationProcessor.generatePartNumber(bgr);
         Flame_Product__c fp = new Flame_Product__c();
           fp.Quote_Line__c= quoteLines[0].id;
           fp.Quote_Description_Engineer_Override__c=false;
          insert fp;
        
                AssyPartDefinationProcessor.generatePartNumber(fp);
        Test.stopTest();
    }

}