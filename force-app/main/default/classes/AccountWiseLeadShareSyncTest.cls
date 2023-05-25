@isTest
public class AccountWiseLeadShareSyncTest{
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
                    
            oContact = TestUtility.createContact('testCon',oAccount.Id,true);
            User oPartnerUser = TestUtility.createPartnerUser('',oAccount.Name,oContact.Id,true);
            //Account oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountRecordTypeId, false);
            Account oAccCust = TestUtility.createCustomerAccount('Test Customer Acc',false);
            oAccCust.Rep_Code_Account__c = oAccount.Id;
            insert oAccCust;
            Lead oLead = new Lead();
            oLead.Firstname ='test lead';
            oLead.Lastname ='test lead';
            oLead.Status ='New';
            oLead.Company ='Test company';
            oLead.Assign_to_Partner__c =true;
            oLead.PartnerAccountId  = oAccount.Id;
            insert oLead;
            list<AccountTeamMember> lstAccountTeamMember = new list<AccountTeamMember>();
            AccountTeamMember oAccountTeamMember = new AccountTeamMember();
            oAccountTeamMember.AccountId = oAccount.Id;
            oAccountTeamMember.AccountAccessLevel = 'Edit';
            oAccountTeamMember.TeamMemberRole = 'Sales Rep';
            oAccountTeamMember.UserId = oPartnerUser.Id;
            lstAccountTeamMember.add(oAccountTeamMember);
            
            /*AccountTeamMember oAccountTeamMember2 = new AccountTeamMember();
            oAccountTeamMember2.AccountId = oAccount2.Id;
            oAccountTeamMember2.AccountAccessLevel = 'Edit';
            oAccountTeamMember2.TeamMemberRole = 'Sales Rep';
            oAccountTeamMember2.UserId = oUser2.Id;
            lstAccountTeamMember.add(oAccountTeamMember2);*/
            test.startTest();
            insert lstAccountTeamMember;
            test.stoptest(); 
            delete lstAccountTeamMember;
        }
    }
    
}