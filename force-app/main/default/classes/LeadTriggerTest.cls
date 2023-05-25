@isTest
public class LeadTriggerTest{
    @isTest
    static void unitTest(){
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
        insert lstUsers;
        
        list<Account> lstAccounts = new list<Account>();
        Account oAccount;
        Contact oContact;
        
        system.runAs(oUser){
            //string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
            oAccount = TestUtility.createPartnerAccount('Test',false);
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
            list<Contact> lstContacts = new list<Contact>();        
            oContact = TestUtility.createContact('testCon',oAccount.Id,false);
            lstContacts.add(oContact);
            Contact oContact2 = TestUtility.createContact('testCon2',oAccount2.Id,false);
            lstContacts.add(oContact2);
            insert lstContacts;
            list<User> lstPartnerUsers = new list<User>();
            User oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,false);
            lstPartnerUsers.add(oPartnerUser);
            User oPartnerUser2 = TestUtility.createPartnerUser('',oAccount2.Name,oContact2.Id,false);
            lstPartnerUsers.add(oPartnerUser2);
            insert lstPartnerUsers;
            //Account oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
            Account oAccCust = TestUtility.createCustomerAccount('Test Customer Acc',false);
            oAccCust.Rep_Code_Account__c = oAccount.Id;
            insert oAccCust;
            
            list<AccountTeamMember> lstAccountTeamMember = new list<AccountTeamMember>();
            AccountTeamMember oAccountTeamMember = new AccountTeamMember();
            oAccountTeamMember.AccountId = oAccount.Id;
            oAccountTeamMember.AccountAccessLevel = 'Edit';
            oAccountTeamMember.TeamMemberRole = 'Sales Rep';
            oAccountTeamMember.UserId = oPartnerUser.Id;
            lstAccountTeamMember.add(oAccountTeamMember);
            
            AccountTeamMember oAccountTeamMember2 = new AccountTeamMember();
            oAccountTeamMember2.AccountId = oAccount2.Id;
            oAccountTeamMember2.AccountAccessLevel = 'Edit';
            oAccountTeamMember2.TeamMemberRole = 'Sales Rep';
            oAccountTeamMember2.UserId = oPartnerUser2.Id;
            lstAccountTeamMember.add(oAccountTeamMember2);
            test.startTest();
            insert lstAccountTeamMember;
            
            Lead oLead = new Lead();
            oLead.Firstname ='test lead';
            oLead.Lastname ='test lead';
            oLead.Status ='New';
            oLead.Company ='Test company';
            oLead.Assign_to_Partner__c =true;
            oLead.PartnerAccountId  = oAccount.Id;
            insert oLead;
            
            oLead.Assign_to_Partner__c = false;
            update oLead;
            test.stoptest(); 
            oLead.PartnerAccountId  = oAccount2.Id;
            oLead.Assign_to_Partner__c = true;
            update oLead;
            delete lstAccountTeamMember;
        }
    }
    
}