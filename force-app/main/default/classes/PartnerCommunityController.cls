public with sharing class PartnerCommunityController {
    @AuraEnabled
    public static List<cdcpc__SizingRequest__c> getUserSizingRequests(String userId){
        return [SELECT Id, Name, cdcpc__ProjectName__c, cdcpc__Brand__c, cdcpc__Is_Ready_for_Quote__c, cdcpc__Processed_to_quote__c FROM cdcpc__SizingRequest__c WHERE OwnerId = :userId ORDER BY LastModifiedDate DESC LIMIT 5];
    }

    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getQuoteLines(String quoteId){
        return [SELECT Id, SBQQ__ProductName__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteId];
    }
}