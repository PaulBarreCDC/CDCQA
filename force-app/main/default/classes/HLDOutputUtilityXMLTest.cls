@isTest
public class HLDOutputUtilityXMLTest {
    
    @testSetup
    public static void testRecords() {
        
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
        
        TestDataHolderUtility.createHoldersTestRecords();
        TestDataHolderUtility.createHoldersMasterTestRecords();
        
        quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        conHolder.size2__c = '0400';
        conHolder.Part_Number__c = '10000000000000000';
        conHolder.Additional_Documents__c = 'Test1, Test2';
        update conHolder;
        
        Holder_Outputs__c output = [SELECT Id, Lead_Time_Override__c FROM Holder_Outputs__c LIMIT 1];
        output.Lead_Time_Override__c = 7779;
        update output;
        
        List<Global_Site_Part_Parameters_ISPM__c> globalSiteParts = new List<Global_Site_Part_Parameters_ISPM__c>();
        Global_Site_Part_Parameters_ISPM__c obj1 = new Global_Site_Part_Parameters_ISPM__c();
        obj1.InventorySite__c = '10';
        obj1.InventoryPartType__c = 'Purchased';
        obj1.InventoryPartTemplate_ID__c = 'Test';
        obj1.SalesSite__c = 'Test';
        obj1.Sourcing_Option__c = 'Test';
        obj1.PurchaseSite__c = 'Test';
        obj1.PurchasePartTemplate_ID__c = 'Test';
        obj1.MfgSite__c = 'Test';
        obj1.Site__c = '20';
        obj1.LeadTimeLL__c = 7777;
        obj1.LeadTimeUL__c = 7777; 
        obj1.SERIALTRACKCODE__c = '';
        globalSiteParts.add(obj1);
        
        obj1 = new Global_Site_Part_Parameters_ISPM__c();
        obj1.InventorySite__c = '20';
        obj1.InventoryPartType__c = 'Purchased';
        obj1.InventoryPartTemplate_ID__c = 'Test';
        obj1.SalesSite__c = 'Test';
        obj1.Sourcing_Option__c = 'Test';
        obj1.PurchaseSite__c = 'Test';
        obj1.PurchasePartTemplate_ID__c = 'Test';
        obj1.MfgSite__c = 'Test';
        obj1.Site__c = '20';
        obj1.LeadTimeLL__c = 7777;
        obj1.LeadTimeUL__c = 7777; 
        obj1.SERIALTRACKCODE__c = '';
        globalSiteParts.add(obj1);
        
        obj1 = new Global_Site_Part_Parameters_ISPM__c();
        obj1.InventorySite__c = '30';
        obj1.InventoryPartType__c = 'Purchased';
        obj1.InventoryPartTemplate_ID__c = 'Test';
        obj1.SalesSite__c = 'Test';
        obj1.Sourcing_Option__c = 'Test';
        obj1.PurchaseSite__c = 'Test';
        obj1.PurchasePartTemplate_ID__c = 'Test';
        obj1.MfgSite__c = 'Test';
        obj1.Site__c = '20';
        obj1.LeadTimeLL__c = 7777;
        obj1.LeadTimeUL__c = 7777; 
        obj1.SERIALTRACKCODE__c = '';
        globalSiteParts.add(obj1);
        
        obj1 = new Global_Site_Part_Parameters_ISPM__c();
        obj1.InventorySite__c = '40';
        obj1.InventoryPartType__c = 'Purchased';
        obj1.InventoryPartTemplate_ID__c = 'Test';
        obj1.SalesSite__c = 'Test';
        obj1.Sourcing_Option__c = 'Test';
        obj1.PurchaseSite__c = 'Test';
        obj1.PurchasePartTemplate_ID__c = 'Test';
        obj1.MfgSite__c = 'Test';
        obj1.Site__c = '20';
        obj1.LeadTimeLL__c = 7777;
        obj1.LeadTimeUL__c = 7777; 
        obj1.SERIALTRACKCODE__c = '';
        globalSiteParts.add(obj1);
        
        insert globalSiteParts;
        
        
        List<Global_Site_Part_Parameters_PPS__c> siteParts = new List<Global_Site_Part_Parameters_PPS__c>();
        Global_Site_Part_Parameters_PPS__c obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '10';
        obj2.VendorSite__c = '20';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '10';
        obj2.VendorSite__c = '30';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '20';
        obj2.VendorSite__c = '10';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '20';
        obj2.VendorSite__c = '30';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '30';
        obj2.VendorSite__c = '10';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '30';
        obj2.VendorSite__c = '20';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '40';
        obj2.VendorSite__c = '10';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '40';
        obj2.VendorSite__c = '20';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        obj2 = new Global_Site_Part_Parameters_PPS__c();
        obj2.Name = 'Test';
        obj2.Site__c = '40';
        obj2.VendorSite__c = '30';
        obj2.VendorLTLL__c = 7777;
        obj2.VendorLTUL__c = 7778;
        obj2.Primary_Vendor__c = 'Test';
        obj2.PPS_VendoNo__c = 'Test';
        obj2.PurchaseSite__c = 'Test';
        siteParts.add(obj2);
        
        insert siteParts;
        
        RD_SizeList__c rdSize = new RD_SizeList__c();
        rdSize.code__c = '0400';
        rdSize.Desc__c  = '4" (100mm)';
        rdSize.mmDesc__c  = '(4") 100mm';
        rdSize.SizeValue__c  = '0400';
        rdSize.Sort_Order__c  = 25;
        insert rdSize;
    }
    
    public static HLDOutputUtilityXML setValues() {
        
        SBQQ__QuoteLine__c quoteLine = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        Holders__c conHolder = [SELECT Id FROM Holders__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        HLDOutputUtilityXML obj = new HLDOutputUtilityXML(conHolder.Id);
        obj.PARTNUMBER = '10000000000000000';
        obj.PARTREV = '1.0';
        obj.DESCRIPTION = 'Test Desc';
        obj.LOTTRACKCODE = '1';
        obj.PROVIDE = 'Test';
        obj.SERIALTRACKCODE = '1.0';
        
        Map<String, String> mapNewAttributeNames = new Map<String, String>();
        obj.mapNewAttributeNames = mapNewAttributeNames;
        obj.PARTCLASS = 'Test';
        obj.RESPONSIBLE_ID = 'Test';
        obj.ASSEMBLYWTUOM = 'Test';
        obj.ASSEMBLYWT = 'Test';
        obj.COMPRESPONID = 'Test';
        obj.COMPDESCRIPTION = 'Test';
        obj.COMPINVSERTRK = 'Test';
        obj.COMPLOTTRACK = 'Test';
        obj.COMPPROVIDE = 'Test';
        obj.ATTRTEMPLATE = 'Test';
        obj.CUSTOMSTATNO = 'Test';
        obj.PLANNER = 'Test';
        obj.SALESGROUP = 'Test';
        obj.SALESPRICEGROUP = 'Test';
        obj.HSNSACCODE = 'Test';
        obj.PARTUOM = 'Test';
        obj.NOTE = 'Test';
        obj.PARTMANAGEDIN = 'Test';
        obj.SALESPRICEGROUP = 'Test';
        
        return obj;
    }
    
    @isTest
    public static void generalCoverage() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        //obj.GlobalSiteParametersISPM();
        obj.getGlobalSitePPS();
    }
    
    @isTest
    public static void testEngineeringParts() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getEngineeringParts();
    }
    
    @isTest
    public static void testEngPartCharacterXML() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getEngPartCharacterXML();
    }
    
    @isTest
    public static void testEngPartStructureXML() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();        
        obj.getEngPartStructureXML();
    }
    
    @isTest
    public static void testENGPARTREV() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getENGPARTREV();
    }
    
    @isTest
    public static void testProdDoc() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getProdDoc();
    }
    
    @isTest
    public static void testProductCatalog() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getProductCatalog();
    }
    
    @isTest
    public static void testStructureXML() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getStructureXML();
    }
    
    @isTest
    public static void testInventoryPartDetails() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getInventoryPartDetails();
    }
    
    @isTest
    public static void testPurchasePartSuppliers() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getPurchasePartSuppliers();
    }
    
    @isTest
    public static void testSalesParts() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getSalesParts();
    }
    
    @isTest
    public static void testRoutingDetails() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.GetRoutingDetails();
    }
    
    @isTest
    public static void testControlPlanDetails() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.GetControlPlanDetails();
    }
    
    @isTest
    public static void testPurchasePart() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getPurchasePart();
    }
    
    @isTest
    public static void testPartNumber() {
       
        HLDOutputUtilityXML obj = HLDOutputUtilityXMLTest.setValues();
        obj.getPartNumber();
    }

}