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
public class CreditsAndBookingTest{
    @isTest
    static void unittest(){
        Profile oProfile ;
        for(Profile p : [Select ID, Name from Profile Where Name = 'System Administrator']){
            oProfile = p;
        }
        System.debug('@Developer --> oProfile :' + oProfile);
        string sUserName = 'test_' + TestUtility.getRandomNumber() + '@test.com';
        string sUserName2 = 'test2_' + TestUtility.getRandomNumber() + '@test.com';
        
        list<User> lstUsers = new list<User>();
        User oUser = new User();
        oUser.UserName = sUserName;
        oUser.FirstName = 'Test-First';
        oUser.LastName = 'Test-Last';
        oUser.Alias = 'test';
        oUser.email = 'test' + TestUtility.getRandomNumber() + '@test.com';
        oUser.ProfileID = oProfile.Id;
        oUser.TimeZoneSidKey = 'America/New_York';   
        oUser.LocaleSidKey = 'en_US';
        oUser.EmailEncodingKey = 'UTF-8';
        oUser.LanguageLocaleKey = 'en_US';
        oUser.CDC_Selling_Entity__c='10';
        oUser.CDC_Source_Entity__c='10';
        oUser.Groth_Selling_Entity__c='10';
        oUser.Groth_Source_Entity__c='10';
        oUser.LaMot_Selling_Entity__c='10';
        oUser.LaMot_Source_Entity__c='10';
        oUser.LVA_Selling_Entity__c='10';
        oUser.LVA_Source_Entity__c='10';
        lstUsers.add(oUser);
        
        User oUser2 = new User();
        oUser2.UserName = sUserName2;
        oUser2.FirstName = 'Test-First2';
        oUser2.LastName = 'Test-Last2';
        oUser2.Alias = 'test2';
        oUser2.email = 'test2' + TestUtility.getRandomNumber() + '@test.com';
        oUser2.ProfileID = oProfile.Id;
        oUser2.TimeZoneSidKey = 'America/New_York';   
        oUser2.LocaleSidKey = 'en_US';
        oUser2.EmailEncodingKey = 'UTF-8';
        oUser2.LanguageLocaleKey = 'en_US';   
        lstUsers.add(oUser2);
        insert lstUsers;
        string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
        Id PartnerAndHouseID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner & House Account').getRecordTypeId();
        list<Account> lstAccounts = new list<Account>();
        Account oAccount = TestUtility.createPartnerAccount('Test',false);
        oAccount.Rep_Code__c='UCN1';
        oAccount.Region__c='DUPS';
        oAccount.District__c='AMERICAS';
        oAccount.External_ID__c='UCN1-DUPS-AMERICAS';
        lstAccounts.add(oAccount);
        Account oAccount2 = TestUtility.createPartnerAccount('Test2',false);
        oAccount2.Rep_Code__c='AK2';
        oAccount2.Region__c='D05';
        oAccount2.District__c='AMERICAS';
        oAccount2.External_ID__c='AK2-D05-AMERICAS';
        lstAccounts.add(oAccount2);
        insert lstAccounts;
        oAccount.IsPartner = true;
        oAccount2.IsPartner = true;
        update lstAccounts;
        
        Account oAccOEM = TestUtility.createAccount('Test OEM Acc', sCustomerAccountRecordTypeId, false);
        oAccOEM.Rep_Code_Account__c = oAccount.Id;
        // Service Ticket #205643 Change Billing City and Street
        oAccOEM.BillingCity = 'Mumbai';
        oAccOEM.BillingStreet = 'ABC Street';
        oAccOEM.BillingCountry = 'India';  
        insert oAccOEM;
        oAccOEM.Name = 'OEMTest';
        oAccOEM.RecordTypeId = PartnerAndHouseID;
        update  oAccOEM;
        Account oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
        oAccCust.Rep_Code_Account__c = oAccount.Id;
        oAccCust.OEM_Sales_Channel__c = oAccOEM.Id;
        //Service Ticket #205643 Added Biling city strerrt and Country FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        oAccCust.BillingCity = 'Mumbai';
        oAccCust.BillingStreet = 'ABC Street';
        oAccCust.BillingCountry = 'India';  
        insert oAccCust;
        system.runas(oUser){
            
            date dtCloseDate =system.today().adddays(15);
            
            
            list<Opportunity> lstOpportunity = new list<Opportunity>();
            Opportunity oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
            oOpportunity.StageName = 'Discovery/Identified';
            oOpportunity.CloseDate = dtCloseDate;
            oOpportunity.EPC_Firm_Involved__c = 'No';
            oOpportunity.Brand__c = 'LaMot';
            lstOpportunity.add(oOpportunity);
            insert lstOpportunity;
            
            SBQQ__Quote__c oQuote = new SBQQ__Quote__c();
            oQuote.SBQQ__Opportunity2__c = oOpportunity.Id;
            insert oQuote;
            
            list<Goals_Performance__c> lstGoalsPerformance = new list<Goals_Performance__c>();
            
            Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
            oGoalsPerformance.Partner_Org__c = oAccount.Id;
            oGoalsPerformance.Brands__c = 'LaMot';
            oGoalsPerformance.Fiscal_Year__c = string.valueOf(dtCloseDate.Year());
            oGoalsPerformance.Fiscal_Month__c = string.valueOf(dtCloseDate.Month());
            oGoalsPerformance.Goal__c=4900;
            lstGoalsPerformance.add(oGoalsPerformance);
            Goals_Performance__c oGoalsPerformance2 = new Goals_Performance__c();
            oGoalsPerformance2.Partner_Org__c = oAccount2.Id;
            oGoalsPerformance2.Brands__c = 'LaMot';
            oGoalsPerformance2.Fiscal_Year__c = string.valueOf(dtCloseDate.Year());
            oGoalsPerformance2.Fiscal_Month__c = string.valueOf(dtCloseDate.Month());
            oGoalsPerformance2.Goal__c=5100;
            lstGoalsPerformance.add(oGoalsPerformance2);
            insert lstGoalsPerformance;
            oOpportunity.PartnerAccountId = oAccount2.Id;
            update lstOpportunity;
            
            Credits_and_Booking__c oCreditsandBooking = new Credits_and_Booking__c();
            oCreditsandBooking.Type__c='Booking';
            oCreditsandBooking.Quote__c=oQuote.Id;
            oCreditsandBooking.Goals_Performance__c=oGoalsPerformance.Id;
            oCreditsandBooking.Created_Date__c=system.today();
            insert oCreditsandBooking;
            oCreditsandBooking.Created_Date__c=system.today().addDays(10);
            update oCreditsandBooking; 
        }
        
    }
    
}