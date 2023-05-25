/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                          Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team          Initial Version
 * 1.1   19-07-2021    Sonam Meshram                   Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup.
 **/
@isTest
public class MappingUtilTest {
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
        contact oContact2;
        User oPartnerUser;
        User oPartnerUser2;
        list<AccountTeamMember> lstAccountTeamMember = new list<AccountTeamMember>();
        list<SBQQ__Quote__c> lstSbqQuote = new list<SBQQ__Quote__c>();
        Opportunity oOpportunity;
        SBQQ__Quote__c Quote;
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
            oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,true);
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
        //system.runas(oPartnerUser){
        system.runas(oUser){
            Quote = new SBQQ__Quote__c();
            Quote.SBQQ__Opportunity2__c = oOpportunity.id;
            lstSbqQuote.add(Quote); 
            
            insert lstSbqQuote;
            
            
        }
        system.runas(oUser){
            
            list<Product2> lstProducts = new list<Product2>();
            Product2 oProduct1 = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
            lstProducts.add(oProduct1);
            insert lstProducts;
            
            list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
            SBQQ__QuoteLine__c QuoteLine1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct1.Id,Line_Status__c ='Cancel',Run_Config_Sync__c = true,Non_Discountable_List_Price__c=200,Discountable_List_Price__c = 100,Discount_Amount__c=10);
            lstQuoteLine.add(QuoteLine1);
            insert lstQuoteLine;
            
            BGR__c bgrRec = new BGR__c();
            bgrRec.Positive_Material_Identification__c = 'CONFIRM';
            bgrRec.Atex__c = 'Y';
            bgrRec.CSA_Markings__c = 'Y';
            bgrRec.Radiography__c = 'CRITICAL';
            bgrRec.GOST_CU_Tr_010_2011__c = 'Y';
            bgrRec.RGEUNT__c = 'psig';
            bgrRec.Quote_Line__c = QuoteLine1.Id;
            bgrRec.Converted_Setting__c = 0.5000000000;
            insert bgrRec;
            
            MappingUtil.getThresholds('CDC','D01');
            MappingUtil.getThresholds('CDC','D02');
            MappingUtil.getThresholds('DDC','D02');
            Account oTempacc = new Account();
            map<string,string> mapFieldWiseValue=new map<string,string>();
            mapFieldWiseValue.put('Name','test1');
            MappingUtil.mapFieldsToObj(oAccCust,oTempacc,mapFieldWiseValue);
            MappingUtil.getConfigSObjectIDFromQuoteLine(QuoteLine1);
            MappingUtil.ForValidationPurposesUponFieldChangeOnly();
        }
        
    }
}