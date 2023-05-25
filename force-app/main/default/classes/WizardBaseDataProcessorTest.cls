@isTest
public class WizardBaseDataProcessorTest {
    
    @testSetup
    public static void dataSetup() {
       
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
        
        TestDataUtility.createHoldersTestRecords();
        TestDataUtility.createHoldersMasterTestRecords();        
    }
    
    @isTest
    public static void parseFieldValues() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id, Brand__c, SBQQ__Description__c FROM SBQQ__QuoteLine__c LIMIT 1];        
        Map<string,string> tmpMap = wizardBaseDataProcessor.mapObjectwithProductCode;
        
        quoteLine[0].SBQQ__Description__c = 'Test*Test';
        wizardBaseDataProcessor.parseFieldValues(quoteLine, 'SBQQ__Description__c');
        wizardBaseDataProcessor.parseFieldValues(quoteLine, 'SBQQ__Description__c*Name');
        Test.stopTest();
    }
    
    @isTest
    public static void getCustomObjectIDbyLine() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id, SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c LIMIT 1];
        Holders__c conHolder = [SELECT Id FROM Holders__c LIMIT 1];
        wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine[0], conHolder.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getCustomObjectIDbyLine2() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getDataList() {
        
        Test.startTest();        
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getDataList('SBQQ__QuoteLine__c', 'Id != null', 'Id, Name');
        wizardBaseDataProcessor.getDataList('SBQQ__QuoteLine__c', 'where Id =  '+quoteLine[0].id, ' from SBQQ__QuoteLine__c');
        Test.stopTest();
    }
    
    @isTest
    public static void getNarrowedDataList() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id, Brand__c FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getNarrowedDataList(quoteLine, 'Brand__c');
        Test.stopTest();
    }
    
    @isTest
    public static void getObjectNameById() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getObjectNameById(quoteLine[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getObjectDataById() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getObjectDataById(quoteLine[0].Id);
        // wizardBaseDataProcessor.getObjectDataById(null);
        Test.stopTest();
    }
    
    @isTest
    public static void createRecordByProductCode() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.createRecordByProductCode ('HLD', quoteLine[0].Id);
        wizardBaseDataProcessor.createRecordByProductCode ('BGR', quoteLine[0].Id);
        wizardBaseDataProcessor.createRecordByProductCode ('RLFVLV', quoteLine[0].Id);
        wizardBaseDataProcessor.createRecordByProductCode ('WGB', quoteLine[0].Id);
        wizardBaseDataProcessor.createRecordByProductCode ('RD', quoteLine[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getMediaPropertiesByType() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        
        Media_Property__c media = new Media_Property__c();
        media.Media__c = 'Glycerin';
        media.Media_Phase__c = 'Gas/Vapor';
        media.MolecularWeight__c = 0.0;
        media.SpecificHeatRatio__c = 0.0;
        media.Density__c = 0.0;
        media.CompressFactor__c = 0.0;
        insert media;
        
        wizardBaseDataProcessor.getMediaPropertiesByType('Glycerin');
        wizardBaseDataProcessor.getMediaPropertiesByType('Glycerincndsvndsnvds');
        wizardBaseDataProcessor.getMediaPropertiesByType('Glycerinc\'\\ndsvndsnvds');
        Test.stopTest();
    }
    
    @isTest
    public static void getRDPricingByProdId() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getRDPricingByProdId(quoteLine[0].Id);
        Map<String, String> t1d = new Map<String, String>{
            'RD' => 'Rupture_Disc__c',
                'BGR' => 'BGR__c',
                'WGB' => 'WasteGasBurner__c',
                'HLD' => 'Holders__c',
                'PS' => 'Part_Selector__c',
                'FlameProducts' =>'Flame_Product__c',
                'RLFVLV'=>'Relief_Valve__c'
                };    
        wizardBaseDataProcessor.mapProdwithObject =  t1d; 
        wizardBaseDataProcessor.mapObjectwithProductCode =  t1d; 
        Test.stopTest();
    }
        
    @isTest
    public static void getProdOutputDescData1() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        Holders__c conHolder = [SELECT Id FROM Holders__c LIMIT 1];
        List<String> selectCols = new List<String>();
        selectCols.add('Id');
        
        List<String> whereCols = new List<String>();
        whereCols.add('Id');
        
        List<String> whereVals = new List<String>();
        whereVals.add('1');
        
        List<String> whereComps = new List<String>();
        whereComps.add('=');
        
        List<String> extraChars = new List<String>();
        whereComps.add('1');
        
        wizardBaseDataProcessor.getProdOutputDescData1('Holders__c', selectCols, whereCols, whereVals, whereComps, extraChars, 'Id');
        
        wizardBaseDataProcessor.getProdOutputDescData('Holders__c', selectCols, whereCols, whereVals, whereComps, extraChars);
        
        wizardBaseDataProcessor.getDataListbyUsingLikeOpp('Holders__c', selectCols, whereCols, whereVals, whereComps, extraChars);
                
        Map<String, String> mapDetails = new Map<String, String>();
        wizardBaseDataProcessor.getDataFromlabelsObj('Name', 'Holders__c', 'Holders__c', mapDetails, selectCols);   
        
        ConfigHoldersOutputController configHld = ConfigHoldersOutputControllerTest.getConfigHolderCntrl();
        configHld.lookupAttributes = null;
        configHld.lookupAttributesAll = null;
        configHld.testingCodeAttributesMap = null;
        configHld.additionalCodeAttributesMap = null;
        map<String,String> holderInputs = configHld.holderInputs;
        List<string> selectCols1 = new List<string> {'Attribute__c','Text__c'};
        selectCols1.add('name');
        wizardBaseDataProcessor.getProdOutputDescData1('Holders__c', selectCols1, whereCols, whereVals, whereComps, extraChars, 'Id');
        wizardBaseDataProcessor.getDynamicQueryFromTranslationObj('Attribute__c', 'Holder_Description_Translation__c', 'Holder_Description_Detail__c', holderInputs, selectCols1);
        
        wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c', 'Holder_Description_Translation__c', 'Holder_Description_Detail__c', holderInputs, selectCols1);
        
        wizardBaseDataProcessor.getDataFromTranslationObj1('Attribute__c', 'Holder_Description_Translation__c', 'Holder_Description_Detail__c', holderInputs, selectCols1, null, null);
        wizardBaseDataProcessor.getSortedDataFromTranslationObj1('Attribute__c', 'PS_Attributes_Translation__c', 'Holder_Description_Detail__c', holderInputs, selectCols1, 'Attribute__c', 'prodgrp', 'subprd');
        wizardBaseDataProcessor.getSortedDataFromTranslationObj('Attribute__c', 'Holder_Description_Translation__c', 'Holder_Description_Detail__c', holderInputs, selectCols1, 'Attribute__c');


        List<String> clnselectCols=new List<String>{'PriceEach__c'};
        List<String> clnwhereCols=new List<String>{'Prod__c','Cleaning__c','SizeValueLL__c','SizeValueUL__c','QtyLL__c','QtyUL__c'};
        List<String> clnwhereValues = new List<String>{'PTC','tempClean','strSizeValue','strSizeValue','strQty','strQty'};
        List<String> clnwhereComps = new List<String>{'LIKE','LIKE','<=','>=','<=','>='};
        List<String> clnextraChars = new List<String>{'','','','','',''};
        wizardBaseDataProcessor.getDataListbyUsingLikeOpp('RDCleaningPrice__c',clnselectCols,clnwhereCols,clnwhereValues,clnwhereComps,clnextraChars);
        wizardBaseDataProcessor.getProdOutputDescData('RDCleaningPrice__c',clnselectCols,clnwhereCols,clnwhereValues,clnwhereComps,clnextraChars);
        wizardBaseDataProcessor.getProdOutputDescData1('RDCleaningPrice__c',clnselectCols,clnwhereCols,clnwhereValues,clnwhereComps,clnextraChars,'ID');

        Test.stopTest();
    }
    
    @isTest
    public static void getPartNumberByQuoteLine() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        wizardBaseDataProcessor.getPartNumberByQuoteLine(quoteLine[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getObjectRecords() {
        
        Test.startTest();
        List<SBQQ__QuoteLine__c> quoteLine  = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        Map<String, Object> parameters = new Map<String, Object>();
        
        parameters.put('sObjects',(new List<String>{'Holder_Description_Detail__c'}));
        parameters.put('Holder_Description_Detail__c_selectedFields', 'Name');
        parameters.put('Holder_Description_Detail__c_whereClause', 'Name = \'XRAY\'');
        parameters.put('Holder_Description_Detail__c_orderBy', 'Id ASC');
        wizardBaseDataProcessor.getObjectRecords(parameters);
        
        system.debug([Select Id,name,PTC__c, SZC__c from FA_HCLASS_Cons__c]);
        system.debug([Select Id,name from Flame_Product__c]);
        parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'FA_HCLASS_Cons__c','FA_Input_Attr_Value_Desc__c'})); 
        parameters.put('FA_HCLASS_Cons__c_selectedFields', 'HCLASS__c');
        // parameters.put('FA_HCLASS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND SZC__c = \'' +flmProd.Size__c+'\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'HCLASS\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_HCLASS_Cons__c-HCLASS__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_HCLASS_Cons__c-HCLASS__c&&Value__c = FA_HCLASS_Cons__c-HCLASS__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_HCLASS_Cons__c-HCLASS__c');
        processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        wizardBaseDataProcessor.testcoveragebooster();
        // parameters = new Map<String, Object>();
        // parameters.put('sObjects',(new List<String>{'RV_MCBODY_N_Cons__c','RV_MCBODY_H_Cons__c','RV_MCBODY_PS_Cons__c','RV_Input_Attr_Value_Desc__c'}));
        // parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        // parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCBODY\'');
        // parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCBODY_N_Cons__c-MCBODY__c,RV_MCBODY_H_Cons__c-MCBODY__c,RV_MCBODY_PS_Cons__c-MCBODY__c');
        // parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCBODY_N_Cons__c-MCBODY__c&&Value__c = RV_MCBODY_H_Cons__c-MCBODY__c&&Value__c = RV_MCBODY_PS_Cons__c-MCBODY__c');
        // parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');
        // processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        Test.stopTest();
    }

}