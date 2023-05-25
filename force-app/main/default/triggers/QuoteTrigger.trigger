trigger QuoteTrigger on SBQQ__Quote__c (
    before insert, after insert,
    before update, after update,
    before delete, after delete ) {
        // SIMPLIFY THIS BY SWITCHING ON THE operationType variables
        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                QuoteTriggerHelper.MapQuoteValues(Trigger.new);
            } else if(Trigger.isUpdate) {
                try{
                //disable for trigger execution to prevent recursive calculations
                    disableCpqTriggers.disableCPQ();

                    System.debug('QUOTE BEFORE UPDATE');
                    // Feature #30338
                    QuoteTriggerHelper.MapQuoteValues(Trigger.new);
                    //Feature #30339
                    QuoteTriggerHelper.calculateCommissions(Trigger.new);
                    //Feature #30262
                    QuoteTriggerHelper.updateShipmentType(Trigger.new);
                    //CO#10
                    QuoteTriggerHelper.findApprovers(trigger.new, trigger.oldMap);
                    //re-enable CPQ triggers
                    SBQQ.TriggerControl.enable();
                } catch (Exception e) {
                    System.debug(e.getMessage());
                }
            } else if(Trigger.isDelete) {
                System.debug('BEFORE DELETE');
            }
        } else if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                System.debug('AFTER INSERT');
                QuoteTriggerHelper.shareQuoteWithProdEngUsers(trigger.new);
                QuoteTriggerHelper.shareQuoteWithOppTeam(trigger.new);
            } else if(Trigger.isUpdate) {
                System.debug('AFTER UPDATE');
            } else if(Trigger.isDelete) {
                System.debug('AFTER DELETE');
            }
        }
        
    }