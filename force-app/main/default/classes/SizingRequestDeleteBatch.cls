global with sharing class SizingRequestDeleteBatch implements Database.Batchable<sObject>, Schedulable{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('SizingRequestDeleteBatch start');
        Sizing_Request_to_Quote__mdt daysToDelete = Sizing_Request_to_Quote__mdt.getInstance('config');
        Datetime targetDate = DateTime.now() - daysToDelete.Days_to_delete__c;
        String query;
        if(Test.isRunningTest()){
            query = 'SELECT Id FROM cdcpc__SizingRequest__c WHERE cdcpc__Is_Ready_for_Quote__c = false AND cdcpc__Processed_to_quote__c = false AND cdcpc__ProjectName__c = \'test sizing request to delete\'';
        } else {
            query = 'SELECT Id FROM cdcpc__SizingRequest__c WHERE cdcpc__Is_Ready_for_Quote__c = false AND cdcpc__Processed_to_quote__c = false AND LastModifiedDate < :targetDate';
        }        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<cdcpc__SizingRequest__c> sizingRequestsToDeleteList) {
            runDelete(sizingRequestsToDeleteList, true);
    }

    global void finish(Database.BatchableContext BC){
        System.debug('SizingRequestDeleteBatch finished');
    }

    /** UTILITY METHODS START **/
    private void runDelete(List<sObject> listToDelete, Boolean continueOnError){
        Database.DeleteResult[] drList = Database.delete(listToDelete, continueOnError);
        for (Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted ID: ' + dr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('fields that affected this error: ' + err.getFields());
                }
            }
        }
    }

    /** SCHEDULABLE METHODS START **/
    global void execute(SchedulableContext sc) {
        SizingRequestDeleteBatch sr2d = new SizingRequestDeleteBatch();
        database.executebatch(sr2d);
    }
}