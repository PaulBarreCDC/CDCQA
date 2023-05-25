/*------------------------------------------------------------------------
Author: Maanas Desai
Company: ApexIT
Test Class: BatchUpdateQLIExpirationDate
Class: The batch will execute daily .Pick up Qoute line with expiration date today related to Quote With Pending status And updat invalid Flag on Quote Line
History:
<Date>         <Authors Name>        <Brief Description of Change>
03/04/2020      Maanas Desai          Initial Development
---------------------------------------------------------------------------*/
public with sharing class BatchUpdateQLIExpirationDate implements Database.batchable<sObject> {
    
    String BatchQuery ='';
    String quoteStatus ='Pending';
    public BatchUpdateQLIExpirationDate(){ //Constructor
        
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Is_Expired__c FROM SBQQ__QuoteLine__c WHERE Expiration_Date__c =Today AND  SBQQ__Quote__r.SBQQ__Status__c=:quoteStatus');
    }
    
    public void execute(Database.BatchableContext info, List<SBQQ__QuoteLine__c> scope){
        
        List<SBQQ__QuoteLine__c> quoteLineToUpdate = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c qouteLine : scope){
            qouteLine.Is_Expired__c = true;
            quoteLineToUpdate.add(qouteLine);
        }
        
        if(NULL != quoteLineToUpdate && quoteLineToUpdate.size() > 0 ){
            try{
                update quoteLineToUpdate;
            }
            catch(Exception e){
                system.debug(e.getMessage());
            }     
        }
    }
    
    public void finish(Database.BatchableContext info){
    }
}