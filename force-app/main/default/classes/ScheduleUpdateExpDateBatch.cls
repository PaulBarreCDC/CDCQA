/*------------------------------------------------------------------------
Author: Maanas Desai
Company: ApexIT
Test Class: ScheduleUpdateExpDateBatch
Class: The Schedulable Apex will Schedule BatchUpdateQLIExpirationDate Batch with batch size default 200
History:
<Date>         <Authors Name>        <Brief Description of Change>
03/04/2020      Maanas Desai          Initial Development
---------------------------------------------------------------------------*/
public  class ScheduleUpdateExpDateBatch implements Schedulable {
   
    public void execute(SchedulableContext sc) {
        
        BatchUpdateQLIExpirationDate batchObj = new BatchUpdateQLIExpirationDate();        
        database.executebatch(batchObj,200);
        
    }
}