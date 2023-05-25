@isTest
private class SizingRequestDeleteBatchTest {
    public static String CRON_EXP = '0 0 0 3 9 ? 2023';
    
    @TestSetup
    static void makeData(){
        User testLicensedUser = CCTestUtils.createAdminUser(true);
        System.runAs(testLicensedUser){
            Account testPartnerRepAccount = CCTestUtils.createAccount('test partner rep account', false);
            testPartnerRepAccount.Rep_Code__c = 'V3';
            testPartnerRepAccount.External_ID__c = '55555';
            testPartnerRepAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_House_Account').getRecordTypeId();
            insert testPartnerRepAccount;
            testPartnerRepAccount.IsPartner = true;
            update testPartnerRepAccount;
            Account testAccount = CCTestUtils.createAccount('test account', false);
            testAccount.Rep_Code_Account__c = testPartnerRepAccount.Id;
            testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId();
            testAccount.Type = 'Agent';
            insert testAccount;
            Contact testContact = CCTestUtils.createContact(testAccount, true);
            User testUser = CCTestUtils.createTestUser(testContact, false);
            testUser.ContactId = testContact.Id;
            insert testUser;
            cdcpc__SizingRequest__c sizingRequestToDelete = new cdcpc__SizingRequest__c(cdcpc__Brand__c = 'CDC', cdcpc__Is_Ready_for_Quote__c = false, cdcpc__Processed_to_quote__c = false, cdcpc__ProjectName__c = 'test sizing request to delete');
            sizingRequestToDelete.OwnerId = testUser.Id;
            insert sizingRequestToDelete;
        }
    }

    @isTest
    private static void testSizingRequestToQuoteProcess(){
        Test.startTest();
        SizingRequestDeleteBatch s2db = new SizingRequestDeleteBatch();
        Database.executeBatch(s2db);
        Test.stopTest();
        List<cdcpc__SizingRequest__c> remainingSizingRequests = [SELECT Id FROM cdcpc__SizingRequest__c];
        System.assert(remainingSizingRequests.isEmpty(), 'We expect our sizing requests to have been deleted.');
    }
    
    @isTest
    static void testScheduler(){
        Test.startTest();
        SizingRequestDeleteBatch scheduledBatchJob = new SizingRequestDeleteBatch();
        String batchJob = System.schedule('testBatchJob', CRON_EXP, scheduledBatchJob);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :batchJob];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        Test.stopTest();
    }
}