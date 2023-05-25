@isTest
public class RDOutputUtilityXMLTest {

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
        //TestDataRDUtility.createRDMasterTestRecords();
    }
    public static RDOutputUtilityXML setValues() {

        RDOutputBaseUtilityTest.getconfigRDCntrl();
        TestDataRDUtility.createRDTestRecordWithOutput();
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

        RDOutputUtilityXML obj = new RDOutputUtilityXML(TestDataRDUtility.conProd.id);
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
       // obj.COMPDESCRIPTION = 'Test';
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

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        //obj.GlobalSiteParametersISPM();
        obj.getGlobalSitePPS();
    }

    @isTest
    public static void testEngineeringParts() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getEngineeringParts();
    }

    @isTest
    public static void testEngPartCharacterXML() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getEngPartCharacterXML();
    }

    @isTest
    public static void testEngPartStructureXML() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getEngPartStructureXML();
    }

    @isTest
    public static void testENGPARTREV() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getENGPARTREV();
    }

    @isTest
    public static void testProdDoc() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getProdDoc();
    }

    @isTest
    public static void testProductCatalog() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getProductCatalog();
    }

    @isTest
    public static void testStructureXML() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getStructureXML();
    }

    @isTest
    public static void testInventoryPartDetails() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getInventoryPartDetails();
    }
    @isTest
    public static void testPurchasePartSuppliers() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getPurchasePartSuppliers();
    }

    @isTest
    public static void testSalesParts() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getSalesParts();
    }

    @isTest
    public static void testRoutingDetails() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.GetRoutingDetails();
    }

    @isTest
    public static void testControlPlanDetails() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.GetControlPlanDetails();
    }

    @isTest
    public static void testPurchasePart() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getPurchasePart();
    }

    @isTest
    public static void testPartNumber() {

        RDOutputUtilityXML obj = RDOutputUtilityXMLTest.setValues();
        obj.getPartNumber();
    }

}