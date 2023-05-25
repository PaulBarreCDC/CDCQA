/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team       Initial Version
 * 1.1   19-07-2021   Rohini Hathi                 Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup.
**/
@isTest
public class CustomReOrderControllerTest {
   
    static testMethod void unitTest(){
        Account testAcc1 = new Account();
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner & House Account').getRecordTypeId();
        testAcc1.RecordtypeId = recordId;
        testAcc1.Name = 'TEMCO INC PARTNER';
        testAcc1.Rep_Code__c = '1AR3';
        testAcc1.Region__c='D01';
        testAcc1.District__c='AMERICAS';
        testAcc1.External_ID__c ='1AR3-D01-AMERICAS';              
        insert testAcc1;        
        testAcc1.IsPartner = true;      
        Update testAcc1;        
            
        Account testAcc = new Account();
        testAcc.Name = 'TEMCO INC TEST';
        testAcc.Rep_Code_Account__c = testAcc1.Id;
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TESTODR';
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Delhi';
        testAcc2.BillingStreet = 'XYZZ Street';
        testAcc2.BillingCountry = 'India';
        insert testAcc2;
        testAcc2.RecordtypeId = recordId;
        testAcc2.Rep_Code_Account__c    = testAcc1.Id;          
        Update testAcc2;        
            
        Contact testCon = new Contact();
        testCon.LastName = 'TEMCO INC TEST Contact';
        testCon.AccountId = testAcc.Id;
        testCon.Default_Communication_Method__c = 'PHONE';
        insert testCon;     
            
        //Create a Product
        list<Product2> lstProducts = new list<Product2>();
        Product2 oProduct1 = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        lstProducts.add(oProduct1);
        insert lstProducts;
        
        Opportunity o = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='CDC',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc.Id);
        insert o;           
            
        SBQQ__Quote__c Quote = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = o.id,
                SBQQ__Account__c = testAcc.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Unblock',
                Destination_Rep__c = testAcc1.Id,
                Eng_Rep_1__c = testAcc1.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = testAcc1.Id
                    
            );
            
        insert Quote;        
            
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        SBQQ__QuoteLine__c QuoteLine1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct1.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine1);
        
        insert lstQuoteLine;
                               //Creating BGR record
        BGR__c bgrRec = new BGR__c();
        bgrRec.Positive_Material_Identification__c = 'CONFIRM';
        bgrRec.Atex__c = 'Y';
        bgrRec.CSA_Markings__c = 'Y';
        bgrRec.Radiography__c = 'CRITICAL';
        bgrRec.GOST_CU_Tr_010_2011__c = 'Y';
        bgrRec.RGEUNT__c = 'psig';
        bgrRec.Quote_Line__c = QuoteLine1.Id;
        insert bgrRec;

        BGR_Attribute_lookup_Details__c oBGRAttribute = new BGR_Attribute_lookup_Details__c();
        oBGRAttribute.Name='bga001';
        oBGRAttribute.Attribute__c='RGEUNT';
        oBGRAttribute.Text__c='psig';
        oBGRAttribute.Numval1__c = 0;
        oBGRAttribute.Numval2__c = 20;
        insert oBGRAttribute;
        
        list<AssyPartDefinition__c> lstAssyPartDefinition = new list<AssyPartDefinition__c>();
        AssyPartDefinition__c oAssyPartDefinition = new AssyPartDefinition__c();
        oAssyPartDefinition.ASSYPARTNO__c='V3011H001X500B0N00002';
        oAssyPartDefinition.Configurator__c = 'BGR';
        oAssyPartDefinition.Field1__c ='Pressure';
        oAssyPartDefinition.BRAND__c = 'CDC';
        oAssyPartDefinition.Managed_In__c ='Salesforce';
        oAssyPartDefinition.Field2__c='0.0433000000';
        oAssyPartDefinition.Product_Ref__c ='BGR';
        oAssyPartDefinition.Field3__c ='psig';
        lstAssyPartDefinition.add(oAssyPartDefinition);
        
        insert lstAssyPartDefinition;
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('qId', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        CustomReOrderController oCustomReOrderController = new CustomReOrderController(sc);
        oCustomReOrderController.getItems();
        oCustomReOrderController.getProductValues();
        oCustomReOrderController.actionSup();
        oCustomReOrderController.selectedProduct='bySerialNum';
        oCustomReOrderController.actionSup();
        
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.strMfgNumber='1234';
        oCustomReOrderController.quantity=1;
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.quantity=-1;
        oCustomReOrderController.strMfgNumber='';
        oCustomReOrderController.selectedProduct='byPartumber';
        oCustomReOrderController.actionSup();
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.strPartNumber='V3011H001X500B0';
        oCustomReOrderController.quantity=1;
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.quantity=-1;
        oCustomReOrderController.strPartNumber='V3011H001X500B0N00002';
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.quantity=1;
        oCustomReOrderController.search();
        for(CustomReOrderController.orderWrapper pd:oCustomReOrderController.selectedOrderWraper){
            pd.strQuoteLine = QuoteLine1.Id;
        }
        test.StartTest();
        oCustomReOrderController.reOrderProduct();
        oCustomReOrderController.createReorder();
        test.StopTest();
    }
    static testMethod void unitTest2(){
        Account testAcc1 = new Account();
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner & House Account').getRecordTypeId();
        testAcc1.RecordtypeId = recordId;
        testAcc1.Name = 'TEMCO INC PARTNER';
        testAcc1.Rep_Code__c = '1AR3';
        testAcc1.Region__c='D01';
        testAcc1.District__c='AMERICAS';
        testAcc1.External_ID__c ='1AR3-D01-AMERICAS';              
        insert testAcc1;        
        testAcc1.IsPartner = true;      
        Update testAcc1;        
            
        Account testAcc = new Account();
        testAcc.Name = 'TEMCO INC TEST';
        testAcc.Rep_Code_Account__c = testAcc1.Id;
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST22';
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Chennai';
        testAcc2.BillingStreet = 'ABC Lane';
        testAcc2.BillingCountry = 'India'; 
        insert testAcc2;
        testAcc2.RecordtypeId = recordId;
        testAcc2.Rep_Code_Account__c    = testAcc1.Id;          
        Update testAcc2;        
            
        Contact testCon = new Contact();
        testCon.LastName = 'TEMCO INC TEST Contact';
        testCon.AccountId = testAcc.Id;
        testCon.Default_Communication_Method__c = 'PHONE';
        insert testCon;     
            
        //Create a Product
        list<Product2> lstProducts = new list<Product2>();
        Product2 oProduct1 = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'PS', IsActive = true);         
        lstProducts.add(oProduct1);
        insert lstProducts;
        
        Opportunity o = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='CDC',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc.Id);
        insert o;           
            
        SBQQ__Quote__c Quote = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = o.id,
                SBQQ__Account__c = testAcc.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Unblock',
                Destination_Rep__c = testAcc1.Id,
                Eng_Rep_1__c = testAcc1.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = testAcc1.Id
                    
            );
            
        insert Quote;        
            
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        SBQQ__QuoteLine__c QuoteLine1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct1.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine1);
        
        insert lstQuoteLine;
                               //Creating BGR record
        Part_Selector__c h = new Part_Selector__c(); 
        h.Quote_Line__c = QuoteLine1.Id;
        insert h;
        
        list<AssyPartDefinition__c> lstAssyPartDefinition = new list<AssyPartDefinition__c>();
        AssyPartDefinition__c oAssyPartDefinition = new AssyPartDefinition__c();
        oAssyPartDefinition.ASSYPARTNO__c='V3011H001X500B0N00002';
        oAssyPartDefinition.Configurator__c = 'PS';
        oAssyPartDefinition.Field1__c ='Pressure';
        oAssyPartDefinition.BRAND__c = 'CDC';
        oAssyPartDefinition.Managed_In__c ='Salesforce';
        oAssyPartDefinition.Field2__c='0.0433000000';
        oAssyPartDefinition.Product_Ref__c ='PS';
        oAssyPartDefinition.Field3__c ='psig';
        lstAssyPartDefinition.add(oAssyPartDefinition);
        
        insert lstAssyPartDefinition;
        
        PS_AssyPartDefinition__c oPSAssyPartDefinition = new PS_AssyPartDefinition__c();
        oPSAssyPartDefinition.ProdGroup__c = 'Burst Disc Indicators';
        oPSAssyPartDefinition.SubGroup__c = 'Universal B.D.I.';
        oPSAssyPartDefinition.ASSYPARTNO__c='V3011H001X500B0N00002';
        oPSAssyPartDefinition.BRAND__c='CDC';
        insert oPSAssyPartDefinition;
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('qId', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        CustomReOrderController oCustomReOrderController = new CustomReOrderController(sc);
        oCustomReOrderController.getItems();
        oCustomReOrderController.getProductValues();
        oCustomReOrderController.actionSup();
        oCustomReOrderController.selectedProduct='bySerialNum';
        oCustomReOrderController.actionSup();
        
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.strMfgNumber='1234';
        oCustomReOrderController.quantity=1;
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.quantity=-1;
        oCustomReOrderController.strMfgNumber='';
        oCustomReOrderController.selectedProduct='byPartumber';
        oCustomReOrderController.actionSup();
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.strPartNumber='V3011H001X500B0';
        oCustomReOrderController.quantity=1;
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.quantity=-1;
        oCustomReOrderController.strPartNumber='V3011H001X500B0N00002';
        try{
            oCustomReOrderController.search();
        }
        catch(Exception oex){
        }
        oCustomReOrderController.quantity=1;
        oCustomReOrderController.search();
        for(CustomReOrderController.orderWrapper pd:oCustomReOrderController.selectedOrderWraper){
            pd.strQuoteLine = QuoteLine1.Id;
        }
        test.StartTest();
        oCustomReOrderController.reOrderProduct();
        oCustomReOrderController.createReorder();
        test.StopTest();
    }

}