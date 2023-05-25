/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team   Initial Version
 * 1.1    19-07-2021   Sonam Meshram            Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup. 
**/
@isTest
public class SubmitApprovalControllerTest{
    @isTest
    static void unittest(){
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
        Account oAccount;
        Account oAccount2;
        Account oAccCust;
        contact oContact;
        User oPartnerUser;
        list<AccountTeamMember> lstAccountTeamMember = new list<AccountTeamMember>();
        system.runas(oUser){
            list<Account> lstAccounts = new list<Account>();
            oAccount = TestUtility.createPartnerAccount('Test',false);
            oAccount.Rep_Code__c='UCN1';
            oAccount.Region__c='DUPS';
            oAccount.District__c='AMERICAS';
            oAccount.External_ID__c='UCN1-DUPS-AMERICAS';
            lstAccounts.add(oAccount);
            oAccount2 = TestUtility.createPartnerAccount('Test2',false);
            oAccount2.Rep_Code__c='AK2';
            oAccount2.Region__c='D05';
            oAccount2.District__c='AMERICAS';
            oAccount2.External_ID__c='AK2-D05-AMERICAS';
            lstAccounts.add(oAccount2);
            insert lstAccounts;
            oAccount.IsPartner = true;
            oAccount2.IsPartner = true;
            update lstAccounts;
        
            oContact = TestUtility.createContact('testCon',oAccount.Id,true);
            oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,true);
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
            
            AccountTeamMember oAccountTeamMember3 = new AccountTeamMember();
            oAccountTeamMember3.AccountId = oAccount.Id;
            oAccountTeamMember3.AccountAccessLevel = 'Edit';
            oAccountTeamMember3.TeamMemberRole = 'Sales Rep';
            oAccountTeamMember3.UserId = oPartnerUser.Id;
            lstAccountTeamMember.add(oAccountTeamMember3);
            
            insert lstAccountTeamMember;
            
            oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
            oAccCust.Rep_Code_Account__c = oAccount.Id;
            
            //Service Ticket #205643, SET BILLING ADDRESS
            oAccCust.BillingCountry ='United States';
            oAccCust.BillingStreet ='Albama';
            oAccCust.BillingCity ='test city';
            oAccCust.BillingState ='Florida';
            oAccCust.BillingPostalCode ='123';
            insert oAccCust;
            
            list<Product2> lstProducts = new list<Product2>();
            Product2 oProduct1 = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
            lstProducts.add(oProduct1);
            
            insert lstProducts;
            
            Opportunity oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
            oOpportunity.StageName = 'Discovery/Identified';
            oOpportunity.CloseDate = system.today().adddays(15);
            oOpportunity.EPC_Firm_Involved__c = 'No';
            oOpportunity.Brand__c = 'CDC';
            insert oOpportunity;
            
            SBQQ__Quote__c Quote = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = oOpportunity.id,
                SBQQ__Account__c = oAccCust.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Unblock',
                Destination_Rep__c = oAccount.Id,
                Eng_Rep_1__c = oAccount.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = oAccount.Id
                    
            );
            
            insert Quote;        
            Test.StartTest();
            
            SubmitApprovalController.validateAndSubmitApproval(Quote.Id);
            
            Test.StopTest();
        }
    }
    
}