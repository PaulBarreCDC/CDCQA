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
private class ChangeOrderControllerV2Test{
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
        testAcc.BillingCity = 'Delhi';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Mumbai';
        testAcc2.BillingStreet = 'ABCD Street';
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
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
            
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
            
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        insert charge;      
            
        
            
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            );
            
        insert QuoteLine;
            
            
        
        
        
        PageReference pageRef = Page.ChangeOrderV2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('quoteid', Quote.Id);
        ChangeOrderControllerV2 oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Block';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[1].selectedAnswer='Order';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[2].selectedAnswer='CHG ORDER';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[7].selectedAnswer='Delivery Information';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstChargeWrapper = oChangeOrderControllerV2.fetchCharges(Quote.Id);
        oChangeOrderControllerV2.addCharge();
        oChangeOrderControllerV2.nDelChargeIndx=1;
        oChangeOrderControllerV2.deleteCharge();
        oChangeOrderControllerV2.saveCharges();
        oChangeOrderControllerV2.saveQuoteDetails();
        
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
            
        Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
        oGoalsPerformance.Partner_Org__c = testAcc1.Id;
        oGoalsPerformance.Brands__c = 'LaMot';
        oGoalsPerformance.Fiscal_Year__c = string.valueOf(system.today().Year());
        oGoalsPerformance.Fiscal_Month__c = string.valueOf(system.today().Month());
        oGoalsPerformance.Goal__c=4900;
        insert oGoalsPerformance; 
        
        Goals_Performance__c oGoalsPerformance1 = new Goals_Performance__c();
        oGoalsPerformance1.Partner_Org__c = testAcc1.Id;
        oGoalsPerformance1.Brands__c = 'CDC';
        oGoalsPerformance1.Fiscal_Year__c = string.valueOf(system.today().Year());
        oGoalsPerformance1.Fiscal_Month__c = string.valueOf(system.today().Month());
        oGoalsPerformance1.Goal__c=4900;
        insert oGoalsPerformance1;    
            
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
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Delhi';
        testAcc2.BillingStreet = 'ABCD Street';
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
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
            
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
            
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        insert charge;      
            
        
            
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            );
            
        insert QuoteLine;
            
            
        
        
        
        PageReference pageRef = Page.ChangeOrderV2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('quoteid', Quote.Id);
        ChangeOrderControllerV2 oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Cancel';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.onBack();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Cancel';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[4].selectedAnswer='Order';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[5].selectedAnswer='CHNG ORD';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[7].selectedAnswer='Delivery Information';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstChargeWrapper = oChangeOrderControllerV2.fetchCharges(Quote.Id);
        oChangeOrderControllerV2.addCharge();
        oChangeOrderControllerV2.nDelChargeIndx=1;
        oChangeOrderControllerV2.deleteCharge();
        oChangeOrderControllerV2.saveCharges();
        oChangeOrderControllerV2.saveQuoteDetails();
        
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
        
        Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
        oGoalsPerformance.Partner_Org__c = testAcc1.Id;
        oGoalsPerformance.Brands__c = 'LaMot';
        oGoalsPerformance.Fiscal_Year__c = string.valueOf(system.today().Year());
        oGoalsPerformance.Fiscal_Month__c = string.valueOf(system.today().Month());
        oGoalsPerformance.Goal__c=4900;
        insert oGoalsPerformance;    
            
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
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Delhi';
        testAcc2.BillingStreet = 'ABCD Street';
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
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
            
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
                IFS_Order_Status__c = 'Planned'
                    
            );
            
        insert Quote;        
            
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        insert charge;      
            
        
            
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            );
            
        insert QuoteLine;
            
            
        
        
        
        PageReference pageRef = Page.ChangeOrderV2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('quoteid', Quote.Id);
        ChangeOrderControllerV2 oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Cancel';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.onBack();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Cancel';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[4].selectedAnswer='Line';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[6].lstQuoteLineWrapper[0].selectedAnswer='CHNG ORD';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[7].selectedAnswer='Delivery Information';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstChargeWrapper = oChangeOrderControllerV2.fetchCharges(Quote.Id);
        oChangeOrderControllerV2.addCharge();
        oChangeOrderControllerV2.nDelChargeIndx=1;
        oChangeOrderControllerV2.deleteCharge();
        oChangeOrderControllerV2.saveCharges();
        oChangeOrderControllerV2.saveQuoteDetails();
        
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
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Delhi';
        testAcc2.BillingStreet = 'ABCD Street';
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
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
            
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
            
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        insert charge;      
            
         
            
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            );
            
        insert QuoteLine;
            
            
        
        
        
        PageReference pageRef = Page.ChangeOrderV2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('quoteid', Quote.Id);
        ChangeOrderControllerV2 oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Block';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[1].selectedAnswer='Line';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[4].selectedAnswer='CHG ORDER';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.onBack();
        oChangeOrderControllerV2.lstCOCW[4].selectedAnswer='CHG ORDER';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[7].selectedAnswer='Delivery Information';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstChargeWrapper = oChangeOrderControllerV2.fetchCharges(Quote.Id);
        oChangeOrderControllerV2.addCharge();
        oChangeOrderControllerV2.nDelChargeIndx=1;
        oChangeOrderControllerV2.deleteCharge();
        oChangeOrderControllerV2.saveCharges();
        oChangeOrderControllerV2.saveQuoteDetails();
        boolean bShowPrevious = oChangeOrderControllerV2.showPrevious;
        oChangeOrderControllerV2.navigateToQuote();
        
        oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Unblock';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[8].selectedAnswer='Line';
        oChangeOrderControllerV2.onAnswer();
    }
    
    
    /*public static void fetchChangeOrderConfigDetails(){
        
        ChangeOrderControllerV2 oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.fetchChangeOrderConfigDetails(set<string>{'test1'})

    }*/
    
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
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Delhi';
        testAcc2.BillingStreet = 'ABCD Street';
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
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
            
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
            
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        //insert charge;      
            
         
            
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            );
            
        insert QuoteLine;
            
      
        PageReference pageRef = Page.ChangeOrderV2;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('quoteid', Quote.Id);
        ChangeOrderControllerV2 oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.saveCharges();
        oChangeOrderControllerV2.bConfigSelected = true;
        oChangeOrderControllerV2.saveQuoteDetails();
        boolean bShowPrevious = oChangeOrderControllerV2.showPrevious;
        oChangeOrderControllerV2.navigateToQuote();
        
        oChangeOrderControllerV2 = new ChangeOrderControllerV2();
        oChangeOrderControllerV2.lstCOCW[0].selectedAnswer='Unblock';
        oChangeOrderControllerV2.onAnswer();
        oChangeOrderControllerV2.lstCOCW[8].selectedAnswer='Line';
        oChangeOrderControllerV2.onAnswer();
        Set<String> set1 = new Set<String>{'New York', 'Paris'};
        oChangeOrderControllerV2.fetchChangeOrderConfigDetails(set1);       
        
    }
    
}