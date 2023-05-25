trigger ApprovalTrigger on sbaa__Approval__c (
 before insert, after insert,
 before update, after update,
 before delete, after delete ) {
  // SIMPLIFY THIS BY SWITCHING ON THE operationType variables
  if(Trigger.isBefore) {
    if(Trigger.isInsert) {
      System.debug('Before Insert');

    } else if(Trigger.isUpdate) {
      System.debug('Before Insert');         
    } else if(Trigger.isDelete) {
      System.debug('Before Insert');
    }
  } else if(Trigger.isAfter) {
    if(Trigger.isInsert) {
      System.debug('Before Insert');
    } else if(Trigger.isUpdate) {
      System.debug('Before Insert');
       ApprovalTriggerHelper.updateQuoteStatus(Trigger.oldMap, Trigger.new);
    } else if(Trigger.isDelete) {
      System.debug('Before Insert');
    }
  }

}