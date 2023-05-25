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
public class OpportunityTriggerTest{
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
        //Service Ticket #205643, VPand Added Biling city strerrt and Country FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
         oAccCust.BillingCity = 'Mumbai';
        oAccCust.BillingStreet = 'ABC Street';
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
    @isTest
    static void unittest2(){
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
        string sPartnerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Partner & House Account').getRecordTypeId();
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
        Account oAccOEM = TestUtility.createAccount('OEMTest OEM Acc', sPartnerAccountRecordTypeId, false);
        oAccOEM.Rep_Code_Account__c = oAccount.Id;
        // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
		 oAccOEM.BillingCity = 'Mumbai';
        oAccOEM.BillingStreet = 'ABC Street';
        oAccOEM.BillingCountry = 'India';  
        insert oAccOEM;
        Account oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
        oAccCust.Rep_Code_Account__c = oAccount.Id;
        oAccCust.OEM_Sales_Channel__c = oAccOEM.Id;
        // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
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
            oOpportunity.Brand__c = 'CDC';
            lstOpportunity.add(oOpportunity);
            Opportunity oOpportunity2 = TestUtility.createOpportunty('Test Opportunity2', oAccCust.Id, oAccount.Id, false);
            oOpportunity2.StageName = 'Discovery/Identified';
            oOpportunity2.CloseDate = dtCloseDate;
            oOpportunity2.EPC_Firm_Involved__c = 'No';
            oOpportunity2.Brand__c = 'CDC';
            lstOpportunity.add(oOpportunity2);
            Opportunity oOpportunity3 = TestUtility.createOpportunty('Test Opportunity3', oAccCust.Id, oAccount.Id, false);
            oOpportunity3.StageName = 'Discovery/Identified';
            oOpportunity3.CloseDate = dtCloseDate;
            oOpportunity3.EPC_Firm_Involved__c = 'No';
            oOpportunity3.Brand__c = 'CDC';
            lstOpportunity.add(oOpportunity3);
            
            insert lstOpportunity;
            
            Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
            oGoalsPerformance.Partner_Org__c = oAccount.Id;
            oGoalsPerformance.Brands__c = 'LaMot';
            oGoalsPerformance.Fiscal_Year__c = string.valueOf(dtCloseDate.Year());
            oGoalsPerformance.Fiscal_Month__c = string.valueOf(dtCloseDate.Month());
            oGoalsPerformance.Goal__c=4900;
            insert oGoalsPerformance;
            
            list<Opportunity_Pipeline_Amount__c> lstOPA = new list<Opportunity_Pipeline_Amount__c>();
            Opportunity_Pipeline_Amount__c oOPA = new Opportunity_Pipeline_Amount__c();
            oOPA.Name = oOpportunity2.name + '- Pipeline Amount';    
            oOPA.Opportunity__c = oOpportunity2.Id;
            oOPA.Type__c = 'Partner Account';
            oOPA.Goals_Performance__c = oGoalsPerformance.Id;
            lstOPA.add(oOPA);
            Opportunity_Pipeline_Amount__c oOPA2 = new Opportunity_Pipeline_Amount__c();
            oOPA2.Name = oOpportunity3.name + '- Pipeline Amount';    
            oOPA2.Opportunity__c = oOpportunity3.Id;
            oOPA2.Type__c = 'OEM Account';
            oOPA2.Goals_Performance__c = oGoalsPerformance.Id;
            lstOPA.add(oOPA2);
            insert lstOPA;
            
            
            
            oOpportunity.PartnerAccountId = oAccount2.Id;
            oOpportunity.Sourcing_Entity__c = null;
            oOpportunity.Brand__c = 'LaMot';
            oOpportunity2.Sourcing_Entity__c = null;
            oOpportunity2.Brand__c = 'LaMot';
            oOpportunity3.Sourcing_Entity__c = null;
            oOpportunity3.Brand__c = 'LaMot';
            update lstOpportunity;
        }
        
    }
    /*
    @isTest
    static void unittest3(){
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
        
        list<Opportunity> lstOpportunity = new list<Opportunity>();
        Opportunity oOpportunity;
        Opportunity oOpportunity2;
        Opportunity oOpportunity3;
        contact oContact;
        User oPartnerUser;
        date dtCloseDate;
        list<Account> lstAccounts = new list<Account>();
        Account oAccount;
        Account oAccount2;
        Account oAccOEM;
        Account oAccCust;
        system.runas(oUser){
            
            string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
            string sPartnerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Partner & House Account').getRecordTypeId();
            
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
            
            oAccOEM = TestUtility.createAccount('OEMTest OEM Acc', sPartnerAccountRecordTypeId, false);
            oAccOEM.Rep_Code_Account__c = oAccount.Id;
            insert oAccOEM;
            oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
            oAccCust.Rep_Code_Account__c = oAccount.Id;
            oAccCust.OEM_Sales_Channel__c = oAccOEM.Id;
            insert oAccCust;
            
            oContact = TestUtility.createContact('testCon',oAccount.Id,true);
            oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,true);
            
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
            
            AccountTeamMember oAccountTeamMember3 = new AccountTeamMember();
            oAccountTeamMember3.AccountId = oAccount.Id;
            oAccountTeamMember3.AccountAccessLevel = 'Edit';
            oAccountTeamMember3.TeamMemberRole = 'Sales Rep';
            oAccountTeamMember3.UserId = oPartnerUser.Id;
            lstAccountTeamMember.add(oAccountTeamMember3);
            
            
            
            insert lstAccountTeamMember;
        }
        
        system.runas(oPartnerUser){
            dtCloseDate =system.today().adddays(15);
            oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
            oOpportunity.StageName = 'Discovery/Identified';
            oOpportunity.CloseDate = dtCloseDate;
            oOpportunity.EPC_Firm_Involved__c = 'No';
            oOpportunity.Brand__c = 'CDC';
            lstOpportunity.add(oOpportunity);
            oOpportunity2 = TestUtility.createOpportunty('Test Opportunity2', oAccCust.Id, oAccount.Id, false);
            oOpportunity2.StageName = 'Discovery/Identified';
            oOpportunity2.CloseDate = dtCloseDate;
            oOpportunity2.EPC_Firm_Involved__c = 'No';
            oOpportunity2.Brand__c = 'CDC';
            lstOpportunity.add(oOpportunity2);
            oOpportunity3 = TestUtility.createOpportunty('Test Opportunity3', oAccCust.Id, oAccount.Id, false);
            oOpportunity3.StageName = 'Discovery/Identified';
            oOpportunity3.CloseDate = dtCloseDate;
            oOpportunity3.EPC_Firm_Involved__c = 'No';
            oOpportunity3.Brand__c = 'CDC';
            lstOpportunity.add(oOpportunity3);
            system.debug('oAccount.Id:'+oAccount.Id);
            system.debug('oAccCust.Id:'+oAccCust.Id);
            insert lstOpportunity;
        }
        system.runas(oUser){
            Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
            oGoalsPerformance.Partner_Org__c = oAccount.Id;
            oGoalsPerformance.Brands__c = 'LaMot';
            oGoalsPerformance.Fiscal_Year__c = string.valueOf(dtCloseDate.Year());
            oGoalsPerformance.Fiscal_Month__c = string.valueOf(dtCloseDate.Month());
            oGoalsPerformance.Goal__c=4900;
            insert oGoalsPerformance;
            
            list<Opportunity_Pipeline_Amount__c> lstOPA = new list<Opportunity_Pipeline_Amount__c>();
            Opportunity_Pipeline_Amount__c oOPA = new Opportunity_Pipeline_Amount__c();
            oOPA.Name = oOpportunity2.name + '- Pipeline Amount';    
            oOPA.Opportunity__c = oOpportunity2.Id;
            oOPA.Type__c = 'Partner Account';
            oOPA.Goals_Performance__c = oGoalsPerformance.Id;
            lstOPA.add(oOPA);
            Opportunity_Pipeline_Amount__c oOPA2 = new Opportunity_Pipeline_Amount__c();
            oOPA2.Name = oOpportunity3.name + '- Pipeline Amount';    
            oOPA2.Opportunity__c = oOpportunity3.Id;
            oOPA2.Type__c = 'OEM Account';
            oOPA2.Goals_Performance__c = oGoalsPerformance.Id;
            lstOPA.add(oOPA2);
            insert lstOPA;
            
            
            
            oOpportunity.PartnerAccountId = oAccount2.Id;
            oOpportunity.Sourcing_Entity__c = null;
            oOpportunity.Brand__c = 'LaMot';
            oOpportunity2.Sourcing_Entity__c = null;
            oOpportunity2.Brand__c = 'LaMot';
            oOpportunity3.Sourcing_Entity__c = null;
            oOpportunity3.Brand__c = 'LaMot';
            update lstOpportunity;
        }
        
    }*/
    @isTest
    static void unittest4(){
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
            oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,false);
            oPartnerUser.Brand__c = 'CDC;LaMOT';
            insert oPartnerUser;
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
            // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
 		    oAccCust.BillingCity = 'Mumbai';
            oAccCust.BillingStreet = 'ABC Street';
            oAccCust.BillingCountry = 'India';  
            insert oAccCust;
        }
        
        
        Opportunity oOpportunity;
        system.runas(oPartnerUser){
            oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
            oOpportunity.StageName = 'Discovery/Identified';
            oOpportunity.CloseDate = system.today().adddays(15);
            oOpportunity.EPC_Firm_Involved__c = 'No';
            oOpportunity.Brand__c = 'CDC';
            insert oOpportunity;
        }
        system.runas(oUser){
            oOpportunity.PartnerAccountId = oAccount2.Id;
            oOpportunity.Sourcing_Entity__c = null;
            oOpportunity.Brand__c = 'LaMOT';
            update oOpportunity;
        }
    }
    
}