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
public class OpportunityTeamMemberTest{
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
        list<AccountTeamMember> lstAccountTeamMember = new list<AccountTeamMember>();
        AccountTeamMember oAccountTeamMember = new AccountTeamMember();
        oAccountTeamMember.AccountId = oAccount.Id;
        oAccountTeamMember.AccountAccessLevel = 'Edit';
        oAccountTeamMember.TeamMemberRole = 'Sales Rep';
        oAccountTeamMember.UserId = oUser.Id;
        lstAccountTeamMember.add(oAccountTeamMember);
        
        AccountTeamMember oAccountTeamMember2 = new AccountTeamMember();
        oAccountTeamMember2.AccountId = oAccount2.Id;
        oAccountTeamMember2.AccountAccessLevel = 'Edit';
        oAccountTeamMember2.TeamMemberRole = 'Sales Rep';
        oAccountTeamMember2.UserId = oUser2.Id;
        lstAccountTeamMember.add(oAccountTeamMember2);
        
        insert lstAccountTeamMember;
        
        Account oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
        oAccCust.Rep_Code_Account__c = oAccount.Id;
        // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        oAccCust.BillingCity = 'Mumbai';
        oAccCust.BillingStreet = 'ABC Street, KY Lane';
        oAccCust.BillingCountry = 'India'; 
        insert oAccCust;
        
        Opportunity oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
        oOpportunity.StageName = 'Discovery/Identified';
        oOpportunity.CloseDate = system.today().adddays(15);
        oOpportunity.EPC_Firm_Involved__c = 'No';
        insert oOpportunity;
        
        oOpportunity.PartnerAccountId = oAccount2.Id;
        update oOpportunity;
        
    }
    
    testMethod static void OpportunityTeamMember(){
       string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
       
              Account oAccount2 = TestUtility.createPartnerAccount('Test2',false);
        oAccount2.Rep_Code__c='AK2';
        oAccount2.Region__c='D05';
        oAccount2.District__c='AMERICAS';
        oAccount2.External_ID__c='AK2-D05-AMERICAS';
        insert oAccount2; 
        oAccount2.IsPartner = true;
        update oAccount2;
        
            Account oAccCust = TestUtility.createAccount('Test Customer Accq', sCustomerAccountRecordTypeId, false);
            oAccCust.Rep_Code_Account__c = oAccount2.Id;
       		 // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT            oAccCust.BillingCity = 'Mumbai';
         	oAccCust.BillingStreet = 'Park Street';
            oAccCust.BillingCity = 'Kolkatta';
          	oAccCust.BillingCountry = 'India';  
            insert oAccCust;
        
             
        Opportunity oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount2.Id, false);
        oOpportunity.StageName = 'Discovery/Identified';
        oOpportunity.CloseDate = system.today().adddays(15);
        oOpportunity.EPC_Firm_Involved__c = 'No';
        insert oOpportunity;
        
        oOpportunity.PartnerAccountId = oAccount2.Id;
        update oOpportunity;
        
        //contact oContact = TestUtility.createContact('testCon',oAccount2.Id,true);
        // User oPartnerUser = TestUtility.createPartnerUser('',oAccount2.Name,oContact.Id,true);
            OpportunityTeamMember oOpportunityTeamMember = new OpportunityTeamMember();
            oOpportunityTeamMember.OpportunityId = oOpportunity.Id;
            oOpportunityTeamMember.opportunityaccessLevel = 'Edit';
            oOpportunityTeamMember.TeamMemberRole = 'Sales Rep';
            oOpportunityTeamMember.UserId = userInfo.getUserId();//oPartnerUser.Id;
                   
            test.startTest();
            insert oOpportunityTeamMember;
        delete oOpportunityTeamMember;
            //update oOpportunityTeamMember;
            test.stopTest();
    }
    
}