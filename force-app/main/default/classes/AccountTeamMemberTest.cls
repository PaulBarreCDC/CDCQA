@isTest
public class AccountTeamMemberTest{
    @isTest
    static void unittest(){
        Profile oProfile ;
        for(Profile p : [Select ID, Name from Profile Where Name = 'System Administrator']){
            oProfile = p;
        }
        System.debug('@Developer --> oProfile :' + oProfile);
        string sUserName = 'test_' + TestUtility.getRandomNumber() + '@test.com';
        
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
        insert oUser;
        
        Account oAccount = TestUtility.createPartnerAccount('Test',false);
        insert oAccount;
        AccountTeamMember oAccountTeamMember = new AccountTeamMember();
        oAccountTeamMember.AccountId = oAccount.Id;
        oAccountTeamMember.AccountAccessLevel = 'Edit';
        oAccountTeamMember.TeamMemberRole = 'Sales Rep';
        oAccountTeamMember.UserId = oUser.Id;
        insert oAccountTeamMember;
        delete oAccountTeamMember;
        
    }
}