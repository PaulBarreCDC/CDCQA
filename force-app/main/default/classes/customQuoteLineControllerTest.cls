/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team   Initial Version
 * 1.1   16-06-2021   Vivek Pandey              Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup. 
**/
@isTest
public class customQuoteLineControllerTest {
   
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
        //RHATHI,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        // Service Ticket #205643 Change Billing City and Street
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune New';
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
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
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

        
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        customQuoteLineController ocustomQuoteLineController = new customQuoteLineController(sc);
        ocustomQuoteLineController.addProduct();
        ocustomQuoteLineController.deleteQuoteLine();
        ocustomQuoteLineController.goBack();
        Test.StopTest();
        
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
        testAcc2.Name = 'TEMCO INC TEST2';
       
       // Service Ticket #205643 VPand Change Billing City and Street
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune New';
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
        
        Product2 oProduct2 = new Product2(Name = 'Rupture Disc',ProductCode = 'RD', IsActive = true);         
        lstProducts.add(oProduct2);
        
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
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        
        SBQQ__QuoteLine__c QuoteLine2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct2.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine2);
        
        insert lstQuoteLine;
                               

        Rupture_Disc__c RD = new Rupture_Disc__c();
        RD.Quote_Line__c = QuoteLine2.Id;
        insert RD;
        
        
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        customQuoteLineController ocustomQuoteLineController = new customQuoteLineController(sc);
        ocustomQuoteLineController.addProduct();
        ocustomQuoteLineController.deleteQuoteLine();
        ocustomQuoteLineController.goBack();
        Test.StopTest();
        
    }
    static testMethod void unitTest3(){
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
        testAcc2.Name = 'TEMCO INC TEST2';
        // Service Ticket #205643 VPand Change Billing City and Street
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune New';
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
        Product2 oProduct3 = new Product2(Name = 'Relief Valves',ProductCode = 'RLFVLV', IsActive = true);         
        lstProducts.add(oProduct3);
        
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
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        
        SBQQ__QuoteLine__c QuoteLine3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct3.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine3);
        
        insert lstQuoteLine;
                               
        
        Relief_Valve__c RV = new Relief_Valve__c();
        RV.Quote_Line__c = QuoteLine3.Id;
        insert RV;
        
        
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        customQuoteLineController ocustomQuoteLineController = new customQuoteLineController(sc);
        ocustomQuoteLineController.addProduct();
        ocustomQuoteLineController.deleteQuoteLine();
        ocustomQuoteLineController.goBack();
        Test.StopTest();
        
    }
    static testMethod void unitTest4(){
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
        testAcc2.Name = 'TEMCO INC TEST2';
        //Service Ticket #205643, VPand Change Billing City and Street
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune New';
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
        
        Product2 oProduct4 = new Product2(Name = 'Flame Products',ProductCode = 'FlameProducts', IsActive = true);         
        lstProducts.add(oProduct4);
        
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
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        
        SBQQ__QuoteLine__c QuoteLine4 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct4.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine4);
        
        insert lstQuoteLine;
                               
        
        Flame_Product__c FP = new Flame_Product__c();
        FP.Quote_Line__c = QuoteLine4.Id;
        insert FP;
        
        
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        customQuoteLineController ocustomQuoteLineController = new customQuoteLineController(sc);
        ocustomQuoteLineController.addProduct();
        ocustomQuoteLineController.deleteQuoteLine();
        ocustomQuoteLineController.goBack();
        Test.StopTest();
        
    }
    static testMethod void unitTest5(){
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
        testAcc2.Name = 'TEMCO INC TEST2';
        // Service Ticket #205643 VPand Change Billing City and Street
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune New';
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
        
        Product2 oProduct5 = new Product2(Name = 'Waste Gas Burner',ProductCode = 'WGB', IsActive = true);         
        lstProducts.add(oProduct5);
        
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
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        
        SBQQ__QuoteLine__c QuoteLine5 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct5.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine5);
        
        insert lstQuoteLine;
                               
        
        WasteGasBurner__c wgb = new WasteGasBurner__c(); 
        wgb.Quote_Line__c = QuoteLine5.Id;
        insert wgb;
        
        
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        customQuoteLineController ocustomQuoteLineController = new customQuoteLineController(sc);
        ocustomQuoteLineController.addProduct();
        ocustomQuoteLineController.deleteQuoteLine();
        ocustomQuoteLineController.goBack();
        Test.StopTest();
        
    }
    static testMethod void unitTest6(){
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
        testAcc2.Name = 'TEMCO INC TEST2';
       
       // Service Ticket #205643 VPand Change Billing City and Street
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune New';
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
        
        Product2 oProduct6 = new Product2(Name = 'Holders',ProductCode = 'HLD', IsActive = true);         
        lstProducts.add(oProduct6);
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
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        
        SBQQ__QuoteLine__c QuoteLine6 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct6.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine6);
        insert lstQuoteLine;
                               
        
        Holders__c h = new Holders__c(); 
        h.Quote_Line__c = QuoteLine6.Id;
        insert h;
        
        PageReference pageRef = Page.customQuoteLinePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quote);
        customQuoteLineController ocustomQuoteLineController = new customQuoteLineController(sc);
        ocustomQuoteLineController.addProduct();
        ocustomQuoteLineController.deleteQuoteLine();
        ocustomQuoteLineController.goBack();
        Test.StopTest();
        
    }

}