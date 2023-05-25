public class RegenerationRequestDetailsTriggerHandler {
	
    public static void updateParentJobStatus(Set<Id> parentJobIds) {
        
        system.debug('parentJobIds:'+parentJobIds);
        List<Regeneration_Request_Details__c> regenerationList = new List<Regeneration_Request_Details__c>();
        Regeneration_Request_Details__c regenerationDet;
        Map<Id, String> jobStatus = new Map<Id, String>();
        for(Regeneration_Request_Details__c rec: [SELECT Id, Status__c, Parent_Job__c FROM Regeneration_Request_Details__c 
                                                  WHERE Parent_Job__c  IN :parentJobIds ORDER BY Status_for_Ordering__c DESC]) {
            
        	jobStatus.put(rec.Parent_Job__c, rec.Status__c);
        }
        
        for(String key: jobStatus.keySet()) {
            
            regenerationDet = new Regeneration_Request_Details__c();
            regenerationDet.Id = key;
            regenerationDet.Status__c = jobStatus.get(key);
            regenerationList.add(regenerationDet);
        }
        
        if(regenerationList.size() > 0) {
        	
            system.debug('regenerationList:'+regenerationList);
            update regenerationList;
            
            /*
            List<QuoteLine_Mass_Update__c> qlMassUpdates = [SELECT Id, Trigger_QL_Update__c FROM QuoteLine_Mass_Update__c];
            
            if(qlMassUpdates.size() > 0) {
                
                for(QuoteLine_Mass_Update__c qlMassUpdate: qlMassUpdates) {
                    
                    qlMassUpdate.Trigger_QL_Update__c = true;
                }
                update qlMassUpdates;
            }
*/
            System.enqueueJob(new MassConfiguratorFutureEvnts());
            //ConfigHolderUtilityBatch.updateQLines();
        }
    }
}