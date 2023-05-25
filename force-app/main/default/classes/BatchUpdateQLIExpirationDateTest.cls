/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                        Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team        Initial Version
 * 1.1   19-07-2021   Rohini Hathi                  Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup. 
 **/
@isTest
public class BatchUpdateQLIExpirationDateTest {
   
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
        // Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        // Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'ABCE Street';
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
        Product2 oProduct2 = new Product2(Name = 'Rupture Disc',ProductCode = 'RD', IsActive = true);         
        lstProducts.add(oProduct2);
        Product2 oProduct3 = new Product2(Name = 'Relief Valves',ProductCode = 'RLFVLV', IsActive = true);         
        lstProducts.add(oProduct3);
        Product2 oProduct4 = new Product2(Name = 'Flame Products',ProductCode = 'FlameProducts', IsActive = true);         
        lstProducts.add(oProduct4);
        Product2 oProduct5 = new Product2(Name = 'Waste Gas Burner',ProductCode = 'WGB', IsActive = true);         
        lstProducts.add(oProduct5);
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
                SBQQ__Status__c = 'Pending',
                Destination_Rep__c = testAcc1.Id,
                Eng_Rep_1__c = testAcc1.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        SBQQ__QuoteLine__c QuoteLine1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct1.Id,Line_Status__c ='Cancel',Expiration_Date__c = Date.today());
        lstQuoteLine.add(QuoteLine1);
        
        insert lstQuoteLine;
               
        
        BatchUpdateQLIExpirationDate oBatchUpdateQLIExpirationDate = new BatchUpdateQLIExpirationDate();
        database.executeBatch(oBatchUpdateQLIExpirationDate);
        Test.StopTest();
        
    }
}