public class ApprovalTriggerHelper {
    
    public static void updateQuoteStatus(Map<Id,sbaa__Approval__c> oldApprovalRecMap, List<sbaa__Approval__c> newApprovalList){
        
        /* Service Ticket # 200212 , ROHINI HATHI 
        Moved the code in Process builder: if Approval status is changed then update Q status and recordtype and opportunity stage
        Following code does not set values properly when iterating in loop, except for initial approval statuses of Approve or Reject
        It only considers two approval statuses out of four

        Map<Id,SBQQ__Quote__c> updateAllapprovedQuoteMap = new Map<Id,SBQQ__Quote__c>();
        Map<Id,SBQQ__Quote__c> updateAllrejectedQuoteMap = new Map<Id,SBQQ__Quote__c>();
        Map<Id,Id> quoteApprovalMap = new Map<Id,Id>();
        Id approvedRecId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Approved').getRecordTypeId();
        Id pendingApprovaldRecTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Pending_Approval').getRecordTypeId();        
                
        for(sbaa__Approval__c approvalsObj : newApprovalList){
            
            quoteApprovalMap.put(approvalsObj.Id,approvalsObj.Quote__c);
        }
        
        if(NULL != quoteApprovalMap && quoteApprovalMap.size() > 0 ){
            Integer counter = 0;
            Integer approvedCounter = 0;
            Integer rejectedCounter = 0;
            for(SBQQ__Quote__c quoteRec : [SELECT Id, (SELECT id, sbaa__Status__c from Approvals__r) FROM SBQQ__Quote__c WHERE ID IN:quoteApprovalMap.values()]){
                
                for(sbaa__Approval__c singleApproval : quoteRec.Approvals__r){
                    counter = counter+1;
                    if(singleApproval.sbaa__Status__c == 'Approved'){
                        approvedCounter = approvedCounter + 1;
                    }else if(singleApproval.sbaa__Status__c == 'Rejected') {
                        rejectedCounter = rejectedCounter +1;
                    }
                    system.debug('counter::'+counter);
                    system.debug('approvedCounter::'+approvedCounter);
                    system.debug('rejectedCounter::'+rejectedCounter);
                    if(approvedCounter == counter){
                        system.debug('inside approvedCounter');
                        updateAllapprovedQuoteMap.put(quoteRec.Id,(new SBQQ__Quote__c(Id= quoteRec.Id, SBQQ__Status__c ='Approved',RecordTypeId= approvedRecId)));
                    }
                    
                    if(rejectedCounter == counter){
                        system.debug('inside rejectedCounter');
                        updateAllrejectedQuoteMap.put(quoteRec.Id,(new SBQQ__Quote__c(Id= quoteRec.Id, SBQQ__Status__c ='Rejected',RecordTypeId= pendingApprovaldRecTypeId)));
                    }
                }
                
            }
            
            if(NULL != updateAllapprovedQuoteMap && updateAllapprovedQuoteMap.size() > 0){
                system.debug('updateAllapprovedQuoteMap' + updateAllapprovedQuoteMap);
                update updateAllapprovedQuoteMap.values();
            }
            
            if(NULL != updateAllrejectedQuoteMap && updateAllrejectedQuoteMap.size() > 0){
                system.debug('updateAllrejectedQuoteMap'+ updateAllrejectedQuoteMap);
                update updateAllrejectedQuoteMap.values();
            }
        }
    */       
    }
}