Public Class disableCpqTriggers{
@InvocableMethod(label='Disable CPQ Triggers' description='Disables SBQQ package triggers during apex execution context' category='SBQQ__QuoteLine__c')
    Public static void disableCPQ(){
        SBQQ.TriggerControl.disable();
    }
}