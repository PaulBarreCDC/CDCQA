trigger RegenerationRequestDetailsTrigger on Regeneration_Request_Details__c (after update) {
    
    Set<Id> parentJobIds = new Set<Id>();
    for(Regeneration_Request_Details__c rec: Trigger.New) {
        
        if(rec.Parent_Job__c != null) {
        	
            parentJobIds.add(rec.Parent_Job__c);
        }
    }
	
    if(parentJobIds.size() > 0) {
        
        RegenerationRequestDetailsTriggerHandler.updateParentJobStatus(parentJobIds);
    }
}