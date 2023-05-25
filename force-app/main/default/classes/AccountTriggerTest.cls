@isTest
public class AccountTriggerTest{
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
        string sCustomerAccountId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
        list<Account> lstAccounts = new list<Account>();
        Account oAccount = TestUtility.createPartnerAccount('Test',false);
        oAccount.Rep_Code__c='UCN1';
        lstAccounts.add(oAccount);
        Account oAccount2 = TestUtility.createPartnerAccount('Test2',false);
        oAccount2.Rep_Code__c='V3';
        lstAccounts.add(oAccount2);
        insert lstAccounts;
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
        
        Account oAccCust = TestUtility.createAccount('Test Customer Acc', sCustomerAccountId, false);
        oAccCust.Rep_Code_Account__c = oAccount.Id;
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        oAccCust.BillingCity = 'Mumbai';
        oAccCust.BillingStreet = 'ABC Street';
        oAccCust.BillingCountry = 'India';
        insert oAccCust;
        
        oAccCust.Rep_Code_Account__c = oAccount2.Id;
        update oAccCust;
        
    }
}