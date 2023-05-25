//@Akhilesh 16 May 2020
@isTest
public class TestUtility {
    
    public static String getRecordTypeIdByName(String sObjectName,String sRecordTypeName){
        String sRecordTypeId;
        if(sObjectName == 'Account'){
            sRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(sRecordTypeName).getRecordTypeId();    
            System.debug('@Developer --> sRecordTypeId :' + sRecordTypeId);
        }
        return sRecordTypeId;
    }
    
    public static String getRandomNumber(){
        System.debug('@Developer -->getRandomNumber:' );
        
        String sRandomNumber = string.valueof(Math.abs(Crypto.getRandomLong())).substring(0, 5);
        System.debug('@Developer --> sRandomNumber :' + sRandomNumber);
        return sRandomNumber;
    }
    
    public static Account createAccount(String sAccountName, String sRecordTypeId, Boolean bInsert){
        if(sAccountName == ''){
            sAccountName = 'Test_' + getRandomNumber();
            System.debug('@Developer --> sAccountName :' + sAccountName);
        }
                
        Account oAccount = new Account();
        oAccount.Name = sAccountName;
        oAccount.RecordTypeId = sRecordTypeId;
        //add if any other required field needed
                
        if(bInsert){
            insert oAccount;
        }
        
        return oAccount;
    }
    
    public static Account createPartnerAccount(String sAccountName, Boolean bInsert){
        if(sAccountName == ''){
            sAccountName = 'Test_' + getRandomNumber();
            System.debug('@Developer --> sAccountName :' + sAccountName);
        }
                
        Account oAccount = new Account();
        oAccount.Name = sAccountName;
        oAccount.RecordTypeId = getRecordTypeIdByName('Account','Partner & House Account');
        //add if any other required field needed
                
        if(bInsert){
            insert oAccount;
        }
        
        return oAccount;
    }
    
    public static Account createCustomerAccount(String sAccountName, Boolean bInsert){
        if(sAccountName == ''){
            sAccountName = 'Test_' + getRandomNumber();
            System.debug('@Developer --> sAccountName :' + sAccountName);
        }
                
        Account oAccount = new Account();
        oAccount.Name = sAccountName;
        oAccount.RecordTypeId = getRecordTypeIdByName('Account','Customer Account');
        //add if any other required field needed
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        oAccount.BillingCity = 'Mumbai';
        oAccount.BillingStreet = 'ABC Street';
        oAccount.BillingCountry = 'India';       
        if(bInsert){
            insert oAccount;
        }
        
        return oAccount;
    }
    
    public static Contact createContact(String sLastName, String sAccountId, Boolean bInsert){
        if(sLastName == ''){
            sLastName = 'LN_' + getRandomNumber();
            System.debug('@Developer --> sLastName :' + sLastName);
        }
        
        Contact oContact = new Contact();
        oContact.LastName = sLastName;
        oContact.AccountId = sAccountId;
        //add if any other required field needed
                
        if(bInsert){
            insert oContact;
        }
        
        return oContact;
    }
    
    public static User createPartnerUser(String sUserName, String sAccountName,String sContactId,Boolean bInsert){
        Profile oProfile ;
        for(Profile p : [Select ID, Name from Profile Where Name = 'CDC Partner Community Users Profile']){
            oProfile = p;
        }
        System.debug('@Developer --> oProfile :' + oProfile);
        
        if(sUserName == ''){
            sUserName = 'test_' + getRandomNumber() + '@test.com';
            System.debug('@Developer --> sUserName :' + sUserName);
        }
        
        User oUser = new User();
        oUser.UserName = sUserName;
        oUser.FirstName = 'Test-First';
        oUser.LastName = 'Test-Last';
        oUser.Alias = 'test';
        oUser.email = 'test' + getRandomNumber() + '@test.com';
        oUser.CommunityNickName = 't' + getRandomNumber();
        oUser.ProfileID = oProfile.Id;
        oUser.TimeZoneSidKey = 'America/New_York';   
        //oUser.PortalRole = sAccountName ;//+ ' Partner User';
        oUser.LocaleSidKey = 'en_US';
        oUser.EmailEncodingKey = 'UTF-8';
        oUser.LanguageLocaleKey = 'en_US';   
        oUser.ContactID = sContactId;
        oUser.Brand__c = 'CDC';
        
        if(bInsert){
            insert oUser;
        }
        
        return oUser;
    }
    
    public static Opportunity createOpportunty(String sOpportunityName, String sAccountId, String sPartnerAccountId, Boolean bInsert){
        if(sOpportunityName == ''){
            sOpportunityName = 'test_' + getRandomNumber();
            System.debug('@Developer --> sOpportunityName :' + sOpportunityName);
        }
        
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.Name = sOpportunityName;
        oOpportunity.AccountId = sAccountId;
        oOpportunity.PartnerAccountId = sPartnerAccountId;
        
         if(bInsert){
            insert oOpportunity;
        }
        
        return oOpportunity;
    }
}