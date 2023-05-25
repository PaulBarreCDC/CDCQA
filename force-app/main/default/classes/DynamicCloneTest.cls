@isTest 
private class DynamicCloneTest{
    static testMethod void unitTest(){
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
        
        list<sObject> lstsObjects = new list<sObject>(); 
        lstsObjects.add(oAccount);      
        lstsObjects.add(oAccount2);     
        DynamicClone.cloneObjects(lstsObjects,oAccount.getsObjectType());
    }
}