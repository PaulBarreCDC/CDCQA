global with sharing class SizingRequestToQuoteBatch implements Database.Batchable<sObject>, Schedulable {
    public String query;
    public Sizing_Request_to_Quote__mdt assignedToUser = Sizing_Request_to_Quote__mdt.getInstance('config');
    public List<Opportunity> newOppList = new List<Opportunity>();
    public List<Opportunity> insertedOppList = new List<Opportunity>();
    public List<SBQQ__Quote__c> newQuoteList = new List<SBQQ__Quote__c>();
    public List<Task> newTaskList = new List<Task>();
    public List<cdcpc__SizingRequest__c> sizingRequestsToUpdateList = new List<cdcpc__SizingRequest__c>();
    public List<cdcpc__SizingRequest__c> sizingRequestErrorList = new List<cdcpc__SizingRequest__c>();
    public Set<Id> sizingRequestIdSet = new Set<Id>();
    public Set<Id> insertedOpportunityIdSet = new Set<Id>();
    public Set<Id> insertedQuoteIdSet = new Set<Id>();
    public Set<Id> insertedTaskIdSet = new Set<Id>();
    public Map<Id, Contact> sizingRequestToContactMap = new Map<Id, Contact>();
    public Map<Id, Opportunity> sizingRequestToOpportunityMap = new Map<Id, Opportunity>();
    public Map<Id, SBQQ__Quote__c> sizingRequestToQuoteMap = new Map<Id, SBQQ__Quote__c>();
    public Map<Id, Id> quoteToSizingRequestIdMap = new Map<Id, Id>();
    public Map<Integer, String> oppErrorMap = new Map<Integer, String>();
    public Map<Integer, String> quoteErrorMap = new Map<Integer, String>();
    public Map<Integer, String> taskErrorMap = new Map<Integer, String>();
    public Map<Id, String> errorBankMap = new Map<Id, String>();

    public SizingRequestToQuoteBatch() {
        query = 'SELECT Id, cdcpc__Brand__c, cdcpc__ContactId__c, cdcpc__Is_Ready_for_Quote__c, cdcpc__Processed_to_quote__c, OwnerId FROM cdcpc__SizingRequest__c WHERE cdcpc__Is_Ready_for_Quote__c = true AND cdcpc__Processed_to_quote__c = false AND cdcpc__ContactId__c != null';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('SizingRequestToQuoteBatch start');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<cdcpc__SizingRequest__c> sizingRequestList) {
        getContacts(sizingRequestList); // 1. set up sizing request to contact map for reference.
        createOpportunities(sizingRequestList); // 2. create opportunities from sizing request list.
        createQuotes(sizingRequestList); // 3. create quotes related to opportunities created from sizing request list.
        assignTasks(sizingRequestList); // 4. create tasks and assign them to user determined by custom metadata type record.
        updateSizingRequests(sizingRequestList); // 5. update successfully processed sizing requests as such.
    }

    global void finish(Database.BatchableContext BC){
        System.debug('SizingRequestToQuoteBatch finished');
    }

    private void getContacts(List<cdcpc__SizingRequest__c> sizingRequestList){
        Set<Id> ownerIdSet = new Set<Id>();
        for(cdcpc__SizingRequest__c sizingRequest : sizingRequestList){
            sizingRequestIdSet.add(sizingRequest.Id); //  storing sizing request Ids for later use.
            ownerIdSet.add(sizingRequest.cdcpc__ContactId__c);
        }
        List<Contact> contactList = [SELECT Id, AccountId, Account.Name, Account.Rep_Code_Account__c FROM Contact WHERE Id IN :ownerIdSet];
        for(Contact contact : contactList){
            sizingRequestToContactMap.put(contact.Id, contact);
        }
    }

    private void createOpportunities(List<cdcpc__SizingRequest__c> sizingRequestList){
        for(cdcpc__SizingRequest__c sizingRequest : sizingRequestList){
            Opportunity opp = new Opportunity(
                AccountId = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).AccountId,
                Amount = 0,
                Brand__c = sizingRequest.cdcpc__Brand__c,
                CloseDate = Date.Today().addDays(30),
                Customer_Contact__c = sizingRequest.cdcpc__ContactId__c,
                Customer_Currency__c = 'USD',
                EPC_Firm_Involved__c = 'No',
                End_Use_Application__c = 'Sizing Request TBD',
                End_User__c = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).AccountId,
                Is_it_a_project__c = 'No',
                Name = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).Account.Name + ' Sizing Request',
                PartnerAccountId = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).Account.Rep_Code_Account__c,
                cdcpc__Sizing_Request__c = sizingRequest.Id,
                Shipping_Account__c = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).AccountId,
                StageName = 'Discovery/Identified',
                Type = 'Community Sizing Request'
            );
            newOppList.add(opp);            
        }
        runInsert(newOppList, 'Opportunity', true);
        if(!oppErrorMap.isEmpty()){
            for(Integer i = 0; i < newOppList.size(); i++){
                if(newOppList[i].Id == null){
                    errorBankMap.put(newOppList[i].cdcpc__Sizing_Request__c, oppErrorMap.get(i));
                }
            }
        }
    }

    private void createQuotes(List<cdcpc__SizingRequest__c> sizingRequestList){
        List<Opportunity> insertedOpportunityList = [SELECT Id, cdcpc__Sizing_Request__c FROM Opportunity WHERE Id IN :insertedOpportunityIdSet];
        for(Opportunity opp : insertedOpportunityList){
            sizingRequestToOpportunityMap.put(opp.cdcpc__Sizing_Request__c, opp);
        }
        for(cdcpc__SizingRequest__c sizingRequest : sizingRequestList){
            SBQQ__Quote__c newQuote = new SBQQ__Quote__c(
                Brand_Order_Type__c = sizingRequest.cdcpc__Brand__c,
                RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Pending').getRecordTypeId(),
                SBQQ__Account__c = sizingRequestToContactMap.get(sizingRequest.cdcpc__ContactId__c).AccountId,
                SBQQ__Opportunity2__c = sizingRequestToOpportunityMap.get(sizingRequest.Id).Id,
                SBQQ__PrimaryContact__c = sizingRequest.cdcpc__ContactId__c
            );
            newQuoteList.add(newQuote);
            sizingRequestToQuoteMap.put(sizingRequest.Id, newQuote);
        }
        runInsert(newQuoteList, 'SBQQ__Quote__c', true);
        if(!quoteErrorMap.isEmpty()){
            for(Integer i = 0; i < newQuoteList.size(); i++){
                if(newQuoteList[i].Id == null){
                    errorBankMap.put(newQuoteList[i].SBQQ__Opportunity2__r.cdcpc__Sizing_Request__c, quoteErrorMap.get(i));
                }
            }
        }
    }

    private void assignTasks(List<cdcpc__SizingRequest__c> sizingRequestList){
        for(cdcpc__SizingRequest__c sizingRequest : sizingRequestList){
            Task newTask = new Task(
                OwnerId = assignedToUser.UserId__c,
                Subject = 'New Sizing Request Quote',
                CurrencyIsoCode = 'USD',
                WhatId = sizingRequestToQuoteMap.get(sizingRequest.Id).Id,
                ActivityDate = Date.Today().addDays(14),
                Priority = 'Normal',
                Status = 'Open'
            );
            newTaskList.add(newTask);
            quoteToSizingRequestIdMap.put(sizingRequestToQuoteMap.get(sizingRequest.Id).Id, sizingRequest.Id);
        }
        runInsert(newTaskList, 'Task', true);
        if(!taskErrorMap.isEmpty()){
            for(Integer i = 0; i < newTaskList.size(); i++){
                if(newTaskList[i].Id == null){
                    errorBankMap.put(quoteToSizingRequestIdMap.get(newTaskList[i].WhatId), taskErrorMap.get(i));
                }
            }
        }
    }

    private void updateSizingRequests(List<cdcpc__SizingRequest__c> sizingRequestList){
        Set<Id> successfullyProcessedSizingRequests = new Set<Id>();
        List<Task> insertedTasks = [SELECT Id, WhatId FROM Task WHERE Id IN :insertedTaskIdSet AND WhatId IN :insertedQuoteIdSet];
        for(Task insertedTask : insertedTasks){
            successfullyProcessedSizingRequests.add(quoteToSizingRequestIdMap.get(insertedTask.WhatId));
        }
        for(cdcpc__SizingRequest__c sizingRequest : sizingRequestList){
            if(successfullyProcessedSizingRequests.contains(sizingRequest.Id)){
                sizingRequest.cdcpc__Processed_to_quote__c = true;
                sizingRequestsToUpdateList.add(sizingRequest);
            } else {
                System.debug('error along the line with sizing request: ' + errorBankMap.get(sizingRequest.Id));
                sizingRequest.cdcpc__Errors_on_Quote_Processing__c = errorBankMap.get(sizingRequest.Id);
                sizingRequestErrorList.add(sizingRequest);
            }
        }
        if(!sizingRequestsToUpdateList.isEmpty()){
            runUpdate(sizingRequestsToUpdateList, 'cdcpc__SizingRequest__c', true);
        }
        if(!sizingRequestErrorList.isEmpty()){
            runUpdate(sizingRequestErrorList, 'cdcpc__SizingRequest__c', true);
        }
    }

    /** UTILITY METHODS START **/
    private void runInsert(List<sObject> listToInsert, String objectType, Boolean continueOnError){
        System.debug('runInsert');
        System.debug(objectType + ' listToInsert: ' + listToInsert);
        Database.SaveResult[] srList = Database.insert(listToInsert, continueOnError);
        for (Integer i = 0; i < srList.size(); i++) {            
            if (srList[i].isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted ' + objectType + ', ID: ' + srList[i].getId());
                switch on objectType {
                    when 'Opportunity' {
                        insertedOpportunityIdSet.add(srList[i].getId());
                    }
                    when 'SBQQ__Quote__c' {
                        insertedQuoteIdSet.add(srList[i].getId());
                    }
                    when 'Task' {
                        insertedTaskIdSet.add(srList[i].getId());                        
                    }
                }
            }
            else {
                // Operation failed, so get all errors
                errorHandle(i, srList[i], objectType);               
            }
        }
    }

    private void runUpdate(List<sObject> listToUpdate, String objectType, Boolean continueOnError){
        System.debug('runUpdate');
        System.debug(objectType + ' listToUpdate: ' + listToUpdate);
        Database.SaveResult[] srList = Database.update(listToUpdate, continueOnError);
        for(Database.SaveResult sr : srList){
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated '+ objectType + ' record with ID: ' + sr.getId());
            } else {
                // Operation failed, so get all errors 
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug(objectType + ' fields that affected this error: ' + err.getFields());
                }
            }
        }
    }

    private void errorHandle(Integer i, Database.SaveResult sr, String objectType){
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug(objectType + ' fields that affected this error: ' + err.getFields());
            String errorMessage = 'Error inserting ' + objectType + ' ' + err.getMessage() + ' ' + err.getFields();
            switch on objectType {
                when 'Opportunity' {
                    oppErrorMap.put(i, errorMessage);
                }
                when 'SBQQ__Quote__c' {
                    quoteErrorMap.put(i, errorMessage);
                }
                when 'Task' {
                    taskErrorMap.put(i, errorMessage);                        
                }
            }
        }        
    }

    global void execute(SchedulableContext sc) {
        SizingRequestToQuoteBatch srq = new SizingRequestToQuoteBatch();
        database.executebatch(srq);
    }
}