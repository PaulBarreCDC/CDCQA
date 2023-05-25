/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team   Initial Version
 * 1.1   16-06-2021   Rohini Hathi             Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup.
**/
@isTest
public class QuoteTriggerTest {
    @isTest
    static void unittest(){
        /*list<group> lstgroups = new list<group>();
        Group gpEng = new Group();
        gpEng.Name = 'ENG_LaMot_10';
        gpEng.DeveloperName = 'ENG_LaMot_10';
        lstgroups.add(gpEng);
        Group gpProd = new Group();
        gpProd.Name = 'PROD_LaMot_10';
        gpProd.DeveloperName = 'PROD_LaMot_10';
        lstgroups.add(gpProd);
        insert lstgroups;*/
        Profile oProfile ;
        for(Profile p : [Select ID, Name from Profile Where Name = 'System Administrator']){
            oProfile = p;
        }
        System.debug('@Developer --> oProfile :' + oProfile);
        string sUserName = 'test_' + TestUtility.getRandomNumber() + '@test.com';
        string sUserName2 = 'test2_' + TestUtility.getRandomNumber() + '@test.com';
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        list<User> lstUsers = new list<User>();
        User oUser = new User();
        oUser.UserRoleId = portalRole.Id;
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
        
        User oUser3 = new User();
        oUser3.UserName = 'test3_' + TestUtility.getRandomNumber() + '@test.com';
        oUser3.FirstName = 'Test-First3';
        oUser3.LastName = 'Test-Last3';
        oUser3.Alias = 'test3';
        oUser3.email = 'test3' + TestUtility.getRandomNumber() + '@test.com';
        oUser3.ProfileID = oProfile.Id;
        oUser3.TimeZoneSidKey = 'America/New_York';   
        oUser3.LocaleSidKey = 'en_US';
        oUser3.EmailEncodingKey = 'UTF-8';
        oUser3.LanguageLocaleKey = 'en_US';
        oUser3.Approver_Level__c = 'Inside Sales';
        oUser3.Approver_for_Selling_Entity__c = '10';
        oUser3.Approver_for_Brand__c = 'LaMot';
        lstUsers.add(oUser3);
        
        User oUser4 = new User();
        oUser4.UserName = 'test4_' + TestUtility.getRandomNumber() + '@test.com';
        oUser4.FirstName = 'Test-First4';
        oUser4.LastName = 'Test-Last4';
        oUser4.Alias = 'test4';
        oUser4.email = 'test4' + TestUtility.getRandomNumber() + '@test.com';
        oUser4.ProfileID = oProfile.Id;
        oUser4.TimeZoneSidKey = 'America/New_York';   
        oUser4.LocaleSidKey = 'en_US';
        oUser4.EmailEncodingKey = 'UTF-8';
        oUser4.LanguageLocaleKey = 'en_US';
        oUser4.Approver_Level__c = 'Sales Director';
        oUser4.Approver_for_Region__c = 'DUPS';
        oUser4.Approver_for_House_Code__c = 'DOE1';
        oUser4.Approver_for_Brand__c = 'LaMot';
        lstUsers.add(oUser4);
        
        User oUser5 = new User();
        oUser5.UserName = 'test5_' + TestUtility.getRandomNumber() + '@test.com';
        oUser5.FirstName = 'Test-First5';
        oUser5.LastName = 'Test-Last5';
        oUser5.Alias = 'test5';
        oUser5.email = 'test5' + TestUtility.getRandomNumber() + '@test.com';
        oUser5.ProfileID = oProfile.Id;
        oUser5.TimeZoneSidKey = 'America/New_York';   
        oUser5.LocaleSidKey = 'en_US';
        oUser5.EmailEncodingKey = 'UTF-8';
        oUser5.LanguageLocaleKey = 'en_US';
        oUser5.Approver_Level__c = 'Regional Manager';
        oUser5.Approver_for_Region__c = 'DUPS';
        lstUsers.add(oUser5);
        
        insert lstUsers;
        system.runAs(oUser){
            string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
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
            
            contact oContact = TestUtility.createContact('testCon',oAccount.Id,true);
            User oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,true);
            
            Account oAccCust = TestUtility.createAccount('Test Customer Accp', sCustomerAccountRecordTypeId, false);
            oAccCust.Rep_Code_Account__c = oAccount.Id;
            // Service Ticket #205643 Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT            oAccCust.BillingCity = 'Mumbai';
         	oAccCust.BillingStreet = 'Park Street, Lane 1';
            oAccCust.BillingCity = 'Kolkatta';
          	oAccCust.BillingCountry = 'India';
            insert oAccCust;
            
            Opportunity oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
            oOpportunity.StageName = 'Discovery/Identified';
            oOpportunity.CloseDate = system.today().adddays(15);
            oOpportunity.EPC_Firm_Involved__c = 'No';
            oOpportunity.Brand__c = 'LaMot';
            oOpportunity.Sourcing_Entity__c = '10';
            oOpportunity.Sales_Division__c = '10';
            insert oOpportunity;
            
            list<OpportunityTeamMember> lstOpportunityTeamMemberToInsert = new list<OpportunityTeamMember>();
            OpportunityTeamMember oOpportunityTeamMember = new OpportunityTeamMember();
            oOpportunityTeamMember.OpportunityId = oOpportunity.Id;
            oOpportunityTeamMember.opportunityaccessLevel = 'Edit';
            oOpportunityTeamMember.TeamMemberRole = 'Sales Rep';
            oOpportunityTeamMember.UserId = oPartnerUser.Id;
            lstOpportunityTeamMemberToInsert.add(oOpportunityTeamMember);
            
            test.startTest();
            insert lstOpportunityTeamMemberToInsert;
            test.stopTest();
            SBQQ__Quote__c oQuote = new SBQQ__Quote__c();
            oQuote.SBQQ__Opportunity2__c = oOpportunity.Id;
            insert oQuote;
            update oQuote;
        }
    }  
}