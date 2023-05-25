@isTest
private class PartnerCommunityControllerTest {
    
    @isTest
    static void getSizingRequestsTest(){
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
                
            List<cdcpc__SizingRequest__c> sizingRequestsList = PartnerCommunityController.getUserSizingRequests(testUser.Id);
        	System.assertEquals(3, sizingRequestsList.size(), 'We expect to have queried for the correct number of exisitng szing request records associated to our test user.');
        }        
    }

    @isTest
    static void getQuoteLinesTest(){
        Account testPartnerRepAccount = CCTestUtils.createAccount('test partner rep account', true);
        testPartnerRepAccount.IsPartner = true;
        testPartnerRepAccount.Rep_Code__c = 'V3';
        testPartnerRepAccount.External_ID__c = '55555';
        testPartnerRepAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_House_Account').getRecordTypeId();
        update testPartnerRepAccount;
        Account testAccount = CCTestUtils.createAccount('test account', false);     
        testAccount.Rep_Code_Account__c = testPartnerRepAccount.Id; 
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId();
        testAccount.Type = 'Agent';
        insert testAccount;
        Opportunity testOpportunity = CCTestUtils.createOpportunity(testAccount, false);
        testOpportunity.PartnerAccountId = testPartnerRepAccount.Id;
        insert testOpportunity;
        Product2 testProduct = CCTestUtils.createProduct('test product', 'TEST', true);
        SBQQ__Quote__c testQuote = CCTesTUtils.createQuote(testAccount, testOpportunity, true, true, true);
        SBQQ__QuoteLine__c testQuoteLine = CCTestUtils.createQuoteLine(testProduct, null, testQuote, true, true);

        List<SBQQ__QuoteLine__c> testQuoteLines = PartnerCommunityController.getQuoteLines(testQuote.Id);
        System.assert(!testQuoteLines.isEmpty());
    }
}