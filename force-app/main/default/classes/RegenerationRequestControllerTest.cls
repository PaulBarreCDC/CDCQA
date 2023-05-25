@isTest
public class RegenerationRequestControllerTest {
    
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
                
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        
        TestDataHolderUtility.quoteLine = quoteLine;
        TestDataHolderUtility.mapWithHolderValues = mapWithHolderValues;
        
        SBQQ__Quote__c quote  = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :quoteLine.SBQQ__Quote__c];
        
        system.debug('TestDataHolderUtility.quoteLine:'+TestDataHolderUtility.quoteLine);
        system.debug('TestDataHolderUtility.mapWithHolderValues:'+TestDataHolderUtility.mapWithHolderValues);
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        quoteLine.Line_Status__c = 'Primary';
        update quoteLine;
        
        
        quote.SBQQ__Status__c = 'Pending';
        update quote;
    }
    
    @isTest
    public static void genericCoverage() {

        Test.startTest();   
        
        SBQQ__Quote__c quote  = [SELECT Id, Name FROM SBQQ__Quote__c LIMIT 1];
        
        Map<String, String> prodMap = RegenerationRequestController.productsMap();
        
        RegenerationRequestController.checkRegenerationRequest();
        
        RegenerationRequestController.submitRegenerationRequest('Holders', quote.Name);
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void genericCoverage2() {

        Test.startTest();   
        
        SBQQ__Quote__c quote  = [SELECT Id, Name FROM SBQQ__Quote__c LIMIT 1];
        
        Regeneration_Request_Details__c rec1 = new Regeneration_Request_Details__c();
        rec1.Batch_Job_ID__c = 'Test1';
        insert rec1;
                        
        RegenerationRequestController.submitRegenerationRequest('Waste Gas Burner', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Blanket Gas Regulator', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Relief Valve', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Flame Products', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Part Selector', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Rupture Disc', quote.Name);
        
        Test.stopTest();
    }
    
    @isTest
    public static void genericCoverage3() {

        Test.startTest();   
        
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, Line_Status__c FROM SBQQ__QuoteLine__c LIMIT 1];
        SBQQ__Quote__c quote  = [SELECT Id, Name FROM SBQQ__Quote__c LIMIT 1];
        
        quoteLine.Line_Status__c = '';
        update quoteLine;
        
        
        quote.SBQQ__Status__c = '';
        update quote;
        
        Regeneration_Request_Details__c rec1 = new Regeneration_Request_Details__c();
        rec1.Batch_Job_ID__c = 'Test1';
        insert rec1;
                        
        RegenerationRequestController.submitRegenerationRequest('Waste Gas Burner', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Blanket Gas Regulator', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Relief Valve', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Flame Products', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Part Selector', quote.Name);
        RegenerationRequestController.submitRegenerationRequest('Rupture Disc', quote.Name);
        
        Test.stopTest();
    }
    
}