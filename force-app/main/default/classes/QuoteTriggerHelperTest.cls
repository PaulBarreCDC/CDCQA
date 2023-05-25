/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team           Initial Version
 * 1.1   19-07-2021   Sonam Meshram                    Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup.
**/
@isTest
public class QuoteTriggerHelperTest {
    /**
     * Insert Inside Sales, Sales Director, Sales Executive, Regional Manager
     */ 
    @TestSetup 
    static void makeData(){ 
        User salesI = new User(
         FirstName='Inside', LastName='Sales', Approver_Level__c='', Approver_for_Brand__c='', Approver_for_Region__c='',
         Approver_for_Selling_Entity__c='', Approver_for_Sourcing_Entity__c='', Approver_for_House_Code__c=''
        );
        User salesD = new User(
         FirstName='Sales', LastName='Director', Approver_Level__c='', Approver_for_Brand__c='', Approver_for_Region__c='',
         Approver_for_Selling_Entity__c='', Approver_for_Sourcing_Entity__c='', Approver_for_House_Code__c=''
        );
        User salesE = new User(
         FirstName='Sales', LastName='Executive', Approver_Level__c='', Approver_for_Brand__c='', Approver_for_Region__c='',
         Approver_for_Selling_Entity__c='', Approver_for_Sourcing_Entity__c='', Approver_for_House_Code__c=''
        );
        User regMgr = new User(
         FirstName='Regional', LastName='Manager', Approver_Level__c='', Approver_for_Brand__c='', Approver_for_Region__c='',
         Approver_for_Selling_Entity__c='', Approver_for_Sourcing_Entity__c='', Approver_for_House_Code__c=''
        );
        User drewUser = new User(
         FirstName='Drew*', LastName='Hartzler', Approver_Level__c='', Approver_for_Brand__c='', Approver_for_Region__c='',
         Approver_for_Selling_Entity__c='', Approver_for_Sourcing_Entity__c='', Approver_for_House_Code__c=''
        );
       
    }
    /**
     * Test
     */
    @isTest
    static void testPopulateApprovers1() { 
        System.debug('hold');
    } 
 
  @isTest
    public static void getQuoteLineRefDataTest(){
                //Create a Product
        Id CustomerRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
          
          
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
        testAcc.RecordTypeId = CustomerRecordId;
        
        //Service Ticket #205643, SET BILLING ADDRESS
        testAcc.BillingCountry ='United States';
        testAcc.BillingStreet ='Albama';
        testAcc.BillingCity ='test city';
        testAcc.BillingState ='Florida';
        testAcc.BillingPostalCode ='123';
        insert testAcc;
            
        
        Contact testCon = new Contact();
        testCon.LastName = 'TEMCO INC TEST Contact';
        testCon.AccountId = testAcc.Id;
        testCon.Default_Communication_Method__c = 'PHONE';
        insert testCon;   
        
        Profile oProfile ;
        for(Profile p : [Select ID, Name from Profile Where Name = 'System Administrator']){
            oProfile = p;
        }
        System.debug('@Developer --> oProfile :' + oProfile);
        string sUserName = 'test_' + TestUtility.getRandomNumber() + '@test.com';
        string sUserName2 = 'test2_' + TestUtility.getRandomNumber() + '@test.com';
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        list<User> lstUsers = new list<User>();
        
        User oUser1 = new User();
        oUser1.UserName = 'test1_' + TestUtility.getRandomNumber() + '@test.com';
        oUser1.FirstName = 'Test-First1';
        oUser1.LastName = 'Test-Last1';
        oUser1.Alias = 'test1';
        oUser1.email = 'test1' + TestUtility.getRandomNumber() + '@test.com';
        oUser1.ProfileID = oProfile.Id;
        oUser1.TimeZoneSidKey = 'America/New_York';   
        oUser1.LocaleSidKey = 'en_US';
        oUser1.EmailEncodingKey = 'UTF-8';
        oUser1.LanguageLocaleKey = 'en_US';
        oUser1.Approver_Level__c = 'Inside Sales';
        oUser1.Approver_for_Selling_Entity__c = '10';
        oUser1.Approver_for_Brand__c = 'LaMot';
        oUser1.Default_Commercial_Approver__c = TRUE;
        lstUsers.add(oUser1);
        
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
        
        User oUser6 = new User();
        oUser6.UserName = 'test6_' + TestUtility.getRandomNumber() + '@test.com';
        oUser6.FirstName = 'Test-First6';
        oUser6.LastName = 'Test-Last6';
        oUser6.Alias = 'test6';
        oUser6.email = 'test6' + TestUtility.getRandomNumber() + '@test.com';
        oUser6.ProfileID = oProfile.Id;
        oUser6.TimeZoneSidKey = 'America/New_York';   
        oUser6.LocaleSidKey = 'en_US';
        oUser6.EmailEncodingKey = 'UTF-8';
        oUser6.LanguageLocaleKey = 'en_US';
        oUser6.Approver_Level__c = 'Sales Executive';
        oUser6.Approver_for_Brand__c = 'LaMot';
        lstUsers.add(oUser6);
        
        User oUser7 = new User();
        oUser7.UserName = 'test7_' + TestUtility.getRandomNumber() + '@test.com';
        oUser7.FirstName = 'Test-First7';
        oUser7.LastName = 'Test-Last7';
        oUser7.Alias = 'test7';
        oUser7.email = 'test7' + TestUtility.getRandomNumber() + '@test.com';
        oUser7.ProfileID = oProfile.Id;
        oUser7.TimeZoneSidKey = 'America/New_York';   
        oUser7.LocaleSidKey = 'en_US';
        oUser7.EmailEncodingKey = 'UTF-8';
        oUser7.LanguageLocaleKey = 'en_US';
        oUser7.Approver_Level__c = 'Sales Director';
        oUser7.Approver_for_Brand__c = 'LaMot';
                oUser7.Approver_for_Region__c = 'AF1;D01;D02;D03;D04;D05;D06';

        lstUsers.add(oUser7);
        
        User oUser8 = new User();
        oUser8.UserName = 'test8_' + TestUtility.getRandomNumber() + '@test.com';
        oUser8.FirstName = 'Test-First7';
        oUser8.LastName = 'Test-Last7';
        oUser8.Alias = 'test8';
        oUser8.email = 'test8' + TestUtility.getRandomNumber() + '@test.com';
        oUser8.ProfileID = oProfile.Id;
        oUser8.TimeZoneSidKey = 'America/New_York';   
        oUser8.LocaleSidKey = 'en_US';
        oUser8.EmailEncodingKey = 'UTF-8';
        oUser8.LanguageLocaleKey = 'en_US';
        oUser8.Approver_Level__c = 'Regional Manager';
        oUser8.Approver_for_Brand__c = 'LaMot';
        oUser8.Approver_for_Region__c = 'AF1;D01;D02;D03;D04;D05;D06';
        lstUsers.add(oUser8);
        
        insert lstUsers;
        
        Commercial_Approvers__c testCA = new Commercial_Approvers__c();
        testCA.Brand__c  = 'CDC';
        testCA.Partner_Rep_Code_Account__c  = testAcc1.Id;
        testCA.Inside_Sales_Approver__c = oUser3.ID;
        testCA.Sales_Director_Approver__c = oUser7.ID;
        testCA.Sales_Executive_Approver__c = oUser6.ID;
        testCA.Regional_Manager__c = oUser8.ID;
        testCA.External_ID__c = 'CDC|1AR3';
        insert testCA;
        
          Opportunity o = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='CDC',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc.Id);
        insert o;
        Opportunity o1 = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='Groth',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc.Id);
        insert o1;
        list<SBQQ__Quote__c> lstSbqQuote = new list<SBQQ__Quote__c>();
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
                Inside_Sales_Approver__c = oUser1.ID,
                Sales_Director__c = oUser1.ID,
                Sales_Executive__c = oUser1.ID,
                Regional_Manager__c = oUser1.ID
            );
        lstSbqQuote.add(Quote);
        
        SBQQ__Quote__c Quote1 = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = o1.id,
                SBQQ__Account__c = testAcc.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Unblock',
                Destination_Rep__c = testAcc1.Id,
                Eng_Rep_1__c = testAcc1.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = testAcc1.Id
            );
        lstSbqQuote.add(Quote1);
        
        insert lstSbqQuote;   
        list<Id> lstID = new list<Id>();
        list<SBQQ__QuoteLine__c> lstQuoteLine= new list<SBQQ__QuoteLine__c>();
        lstQuoteLine.add(new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            )
        );  
        insert lstQuoteLine;
        lstID.add(lstQuoteLine[0].Id);
        QuoteTriggerHelper.MapQuoteValues(lstSbqQuote);
        QuoteTriggerHelper.shareQuoteWithOppTeam(lstSbqQuote);
        
       
    }
    
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
        
        User oUser6 = new User();
        oUser6.UserName = 'test6_' + TestUtility.getRandomNumber() + '@test.com';
        oUser6.FirstName = 'Test-First6';
        oUser6.LastName = 'Test-Last6';
        oUser6.Alias = 'test6';
        oUser6.email = 'test6' + TestUtility.getRandomNumber() + '@test.com';
        oUser6.ProfileID = oProfile.Id;
        oUser6.TimeZoneSidKey = 'America/New_York';   
        oUser6.LocaleSidKey = 'en_US';
        oUser6.EmailEncodingKey = 'UTF-8';
        oUser6.LanguageLocaleKey = 'en_US';
        oUser6.Approver_Level__c = 'Sales Executive';
        oUser6.Approver_for_Brand__c = 'LaMot';
        lstUsers.add(oUser6);
        
        User oUser7 = new User();
        oUser7.UserName = 'test7_' + TestUtility.getRandomNumber() + '@test.com';
        oUser7.FirstName = 'Test-First7';
        oUser7.LastName = 'Test-Last7';
        oUser7.Alias = 'test7';
        oUser7.email = 'test7' + TestUtility.getRandomNumber() + '@test.com';
        oUser7.ProfileID = oProfile.Id;
        oUser7.TimeZoneSidKey = 'America/New_York';   
        oUser7.LocaleSidKey = 'en_US';
        oUser7.EmailEncodingKey = 'UTF-8';
        oUser7.LanguageLocaleKey = 'en_US';
        oUser7.Approver_Level__c = 'Sales Director';
        oUser7.Approver_for_Brand__c = 'LaMot';
                oUser7.Approver_for_Region__c = 'AF1;D01;D02;D03;D04;D05;D06';

        lstUsers.add(oUser7);
        
        User oUser8 = new User();
        oUser8.UserName = 'test8_' + TestUtility.getRandomNumber() + '@test.com';
        oUser8.FirstName = 'Test-First7';
        oUser8.LastName = 'Test-Last7';
        oUser8.Alias = 'test8';
        oUser8.email = 'test8' + TestUtility.getRandomNumber() + '@test.com';
        oUser8.ProfileID = oProfile.Id;
        oUser8.TimeZoneSidKey = 'America/New_York';   
        oUser8.LocaleSidKey = 'en_US';
        oUser8.EmailEncodingKey = 'UTF-8';
        oUser8.LanguageLocaleKey = 'en_US';
        oUser8.Approver_Level__c = 'Regional Manager';
        oUser8.Approver_for_Brand__c = 'LaMot';
        oUser8.Approver_for_Region__c = 'AF1;D01;D02;D03;D04;D05;D06';
        lstUsers.add(oUser8);
        
        insert lstUsers;
        string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
        Account oAccount;
        Account oAccount2;
        Account oAccCust;
        contact oContact;
        contact oContact2;
        User oPartnerUser;
        User oPartnerUser2;
        list<AccountTeamMember> lstAccountTeamMember = new list<AccountTeamMember>();
        list<SBQQ__Quote__c> lstSbqQuote = new list<SBQQ__Quote__c>();
        Opportunity oOpportunity;
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
            oContact2 = TestUtility.createContact('testlastCon2',oAccount2.Id,true);
            oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,false);
            oPartnerUser.Brand__c = 'CDC;LaMOT';
            insert oPartnerUser;
            oPartnerUser2 = TestUtility.createPartnerUser('',oAccount2.Name,oContact2.Id,true);
        }
        
        system.runas(oPartnerUser){
            
            for(User u : [Select Id,Profile.Name,ContactId,Contact.Email,Contact.AccountId,Contact.Account.Name,Contact.Account.IsPartner,
                      Contact.Account.RecordType.Name,Contact.Account.External_ID__c
                      From User 
                      Where Id =:oPartnerUser.Id]){
                UtilityHelper.self.oCurrentUser = u;
            } 
            
            oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
            oAccCust.Rep_Code_Account__c = oAccount.Id;
            
            //Service Ticket #205643, SET BILLING ADDRESS
            oAccCust.BillingCountry ='United States';
            oAccCust.BillingStreet ='Albama';
            oAccCust.BillingCity ='test city';
            oAccCust.BillingState ='Florida';
            oAccCust.BillingPostalCode ='123';
       
            insert oAccCust;
            
            oOpportunity = TestUtility.createOpportunty('Test Opportunity1', oAccCust.Id, oAccount.Id, false);
            oOpportunity.StageName = 'Discovery/Identified';
            oOpportunity.CloseDate = system.today().adddays(15);
            oOpportunity.EPC_Firm_Involved__c = 'No';
            oOpportunity.Brand__c = 'CDC';
            insert oOpportunity;
        }
        system.runas(oUser){
            list<OpportunityTeamMember> lstOpportunityTeamMember = new list<OpportunityTeamMember>();
            OpportunityTeamMember oOpportunityTeamMember = new OpportunityTeamMember();
            oOpportunityTeamMember.OpportunityId = oOpportunity.Id;
            oOpportunityTeamMember.opportunityaccessLevel = 'Edit';
            oOpportunityTeamMember.TeamMemberRole = 'Sales Rep';
            oOpportunityTeamMember.UserId = oPartnerUser2.Id;
            lstOpportunityTeamMember.add(oOpportunityTeamMember);
            insert lstOpportunityTeamMember;
        }
        system.runas(oPartnerUser){
            SBQQ__Quote__c Quote = new SBQQ__Quote__c();
            Quote.SBQQ__Opportunity2__c = oOpportunity.id;
            lstSbqQuote.add(Quote); 
            
            insert lstSbqQuote;
            delete lstSbqQuote;
           QuoteTriggerHelper.shareQuoteWithOppTeam(lstSbqQuote);
             
        }
        
    }
}