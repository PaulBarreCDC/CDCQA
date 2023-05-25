@isTest
private class SizingRequestToQuoteBatchTest {    
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
            cdcpc__SizingRequest__c readySizingRequest = new cdcpc__SizingRequest__c(cdcpc__Brand__c = 'CDC', cdcpc__Is_Ready_for_Quote__c = true, cdcpc__Processed_to_quote__c = false, cdcpc__ProjectName__c = 'sizing request ready to be processed.');
            readySizingRequest.OwnerId = testUser.Id;
            cdcpc__SizingRequest__c notReadySizingRequest = new cdcpc__SizingRequest__c(cdcpc__Brand__c = 'Groth', cdcpc__Is_Ready_for_Quote__c = false, cdcpc__Processed_to_quote__c = false, cdcpc__ProjectName__c = 'sizing request not yet ready to be processed.');
            notReadySizingRequest.OwnerId = testUser.Id;
            cdcpc__SizingRequest__c alreadySubmittedSizingRequest = new cdcpc__SizingRequest__c(cdcpc__Brand__c = 'LaMOT', cdcpc__Is_Ready_for_Quote__c = true, cdcpc__Processed_to_quote__c = true, cdcpc__ProjectName__c = 'sizing request already processed to quote.');
            alreadySubmittedSizingRequest.OwnerId = testUser.Id;
            insert new List<cdcpc__SizingRequest__c>{readySizingRequest, notReadySizingRequest, alreadySubmittedSizingRequest};
        }
    }

    @isTest
    private static void testSizingRequestToQuoteProcess(){
        Test.startTest();
        SizingRequestToQuoteBatch sb = new SizingRequestToQuoteBatch();
        Database.executeBatch(sb);
        Test.stopTest();

        cdcpc__SizingRequest__c readySizingRequest = [SELECT Id, cdcpc__ProjectName__c FROM cdcpc__SizingRequest__c WHERE cdcpc__ProjectName__c = 'sizing request ready to be processed.' LIMIT 1];
        Opportunity newOpp = [SELECT Id, cdcpc__Sizing_Request__c FROM Opportunity WHERE cdcpc__Sizing_Request__c = :readySizingRequest.Id LIMIT 1];
        SBQQ__Quote__c newQuote = [SELECT Id, SBQQ__Opportunity2__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :newOpp.Id LIMIT 1];
        Task newTask = [SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId = :newQuote.Id LIMIT 1];

        System.assertEquals(readySizingRequest.Id, newOpp.cdcpc__Sizing_Request__c, 'We expect a new opportunity to have been created from our sizing request that was ready to have been processed into a quote.');
        System.assertEquals(newOpp.Id, newQuote.SBQQ__Opportunity2__c, 'We expect a new Salesforce CPQ SBQQ__Quote__c record to have been created from our new opportunity.');
        System.assertEquals(newQuote.Id, newTask.WhatId, 'We expect a task to have been created from our new Quote record.');
    }
    
    @isTest
    static void testScheduler(){
        Test.startTest();
        SizingRequestToQuoteBatch scheduledBatchJob = new SizingRequestToQuoteBatch();
        String batchJob = System.schedule('testBatchJob', CRON_EXP, scheduledBatchJob);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :batchJob];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        Test.stopTest();
    } 
}