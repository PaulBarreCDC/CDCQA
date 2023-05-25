@isTest
public class OpportunityUtilityTest{
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
        oUser.CDC_Selling_Entity__c='10';
        oUser.CDC_Source_Entity__c='10';
        oUser.Groth_Selling_Entity__c='10';
        oUser.Groth_Source_Entity__c='10';
        oUser.LaMot_Selling_Entity__c='10';
        oUser.LaMot_Source_Entity__c='10';
        oUser.LVA_Selling_Entity__c='10';
        oUser.LVA_Source_Entity__c='10';        
        lstUsers.add(oUser);
        
        insert lstUsers;
        string sCustomerAccountRecordTypeId = UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId();
        list<Account> lstAccounts = new list<Account>();
        Account oAccount = TestUtility.createPartnerAccount('Test',false);
        oAccount.Rep_Code__c='UCN1';
        oAccount.Region__c='DUPS';
        oAccount.District__c='AMERICAS';
        oAccount.External_ID__c='UCN1-DUPS-AMERICAS';
        oAccount.CDC_Selling_Entity__c='10';
        oAccount.CDC_Source_Entity__c='10';
        oAccount.Groth_Selling_Entity__c='10';
        oAccount.Groth_Source_Entity__c='10';
        oAccount.LaMot_Selling_Entity__c='10';
        oAccount.LaMot_Source_Entity__c='10';
        oAccount.LVA_Selling_Entity__c='10';
        oAccount.LVA_Source_Entity__c='10';
        lstAccounts.add(oAccount);
        
        insert lstAccounts;
        oAccount.IsPartner = true;
        
        set<string> setBrand = new set<string>();
        set<string> setPartnerAcc = new set<string>();
        setPartnerAcc.add(oAccount.Id);
        setBrand.add('CDC');
        OpportunityUtility.fetchBrandAndUserWiseEntities(setBrand);
        OpportunityUtility.fetchBrandAndPartnerAccountWiseEntities(setBrand,setPartnerAcc);
        
        
        
        
    }
    
}