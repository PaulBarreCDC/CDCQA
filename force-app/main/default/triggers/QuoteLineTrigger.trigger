trigger QuoteLineTrigger on SBQQ__QuoteLine__c (
    before insert, after insert,
    before update, after update,
    before delete, after delete ) {
        if(checkRecursive.runOnce()){
            // SIMPLIFY THIS BY SWITCHING ON THE operationType variables
            if(Trigger.isBefore) {
                if(Trigger.isInsert) {
                    System.debug('Quote Line Before Insert');
                    QuoteLineTriggerHelper.runBeforeInsertOperations(Trigger.new);
                } 
                else if(Trigger.isUpdate) {
                //temporarily disabling CPQ triggers for trigger execution
                    disableCpqTriggers.disableCPQ();
                    System.debug('Quote Line Before Update');                 
                    QuoteLineTriggerHelper.runBeforeUpdateOperations(Trigger.oldMap,Trigger.new);
                    //enable CPQ triggers again
                    SBQQ.TriggerControl.enable(); 
                } 
                /*else if(Trigger.isDelete) {
                    System.debug('Quote Line Before Delete');
                }*/
            } 
            /*else if(Trigger.isAfter) {
                //  Use this section to update related objects
                if(Trigger.isUpdate) {
                    // Run code to sync delivery items here
                    //QuoteLineTriggerHelper.runAfterUpdateOperations(Trigger.new);
                }
            }*/
        }
        
    }