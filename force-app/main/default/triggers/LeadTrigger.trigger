trigger LeadTrigger on Lead (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    list<Lead> lstLead = new list<Lead>();
    if(trigger.isBefore){
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:');
            set<Id> setRemovedPartnerAccountId = new set<Id>();
            for(Lead oLead :trigger.New){
                if(oLead.Assign_to_Partner__c != trigger.oldMap.get(oLead.Id).Assign_to_Partner__c && trigger.oldMap.get(oLead.Id).Assign_to_Partner__c &&
                   trigger.oldMap.get(oLead.Id).PartnerAccountId != null)
                {
                    setRemovedPartnerAccountId.add(trigger.oldMap.get(oLead.Id).PartnerAccountId);
                    lstLead.add(oLead);
                }
                
                if(oLead.PartnerAccountId != trigger.oldMap.get(oLead.Id).PartnerAccountId && trigger.oldMap.get(oLead.Id).PartnerAccountId != null &&
                   trigger.oldMap.get(oLead.Id).Assign_to_Partner__c)
                {
                    setRemovedPartnerAccountId.add(trigger.oldMap.get(oLead.Id).PartnerAccountId);
                    lstLead.add(oLead);
                }
                
                if(oLead.Assign_to_Partner__c  && oLead.PartnerAccountId != null){
                    oLead.Status = 'Assigned';
                }
            }
            
            if(setRemovedPartnerAccountId.size()>0){
                System.debug('@Developer --> setRemovedPartnerAccountId :' + setRemovedPartnerAccountId);
                map<string,list<AccountTeamMember>> mapAccountIdWiseTeamMembers = LeadTriggerHelper.fetchPartnerAccountWiseTeamMembers(setRemovedPartnerAccountId);
                if(mapAccountIdWiseTeamMembers.size()>0){
                    set<String> setTeamMemberIdToDelete = new set<String>();
                    for(String accId : mapAccountIdWiseTeamMembers.keySet()){
                        for(AccountTeamMember atm : mapAccountIdWiseTeamMembers.get(accId)){
                            setTeamMemberIdToDelete.add(atm.userId);
                        }
                    }
                    System.debug('@Developer --> setTeamMemberIdToDelete :' + setTeamMemberIdToDelete);
                    LeadTriggerHelper.DeleteLeadSharing(lstLead,mapAccountIdWiseTeamMembers,setTeamMemberIdToDelete,true);
                }
            }
        }
    }
    if(trigger.isAfter){
        System.debug('@Developer -->trigger.isAfter:' );
        set<Id> setPartnerAccountId = new set<Id>();
        if(trigger.isInsert){
            System.debug('@Developer -->trigger.isInsert:' );
            for(Lead oLead :trigger.New){
                if(oLead.Assign_to_Partner__c  && oLead.PartnerAccountId != null){
                    setPartnerAccountId.add(oLead.PartnerAccountId);
                    lstLead.add(oLead);
                }
            }
            System.debug('@Developer --> setPartnerAccountId :' + setPartnerAccountId);
            if(setPartnerAccountId.size()>0){
                map<string,list<AccountTeamMember>> mapAccountIdWiseTeamMembers = LeadTriggerHelper.fetchPartnerAccountWiseTeamMembers(setPartnerAccountId);
                if(mapAccountIdWiseTeamMembers.size()>0){
                    LeadTriggerHelper.InsertLeadSharing(lstLead,mapAccountIdWiseTeamMembers,true);
                }
            }
        }
        
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:');
            for(Lead oLead :trigger.New){
                
                if( oLead.Assign_to_Partner__c != trigger.oldMap.get(oLead.Id).Assign_to_Partner__c && oLead.Assign_to_Partner__c &&
                   oLead.PartnerAccountId != null)
                {
                    setPartnerAccountId.add(oLead.PartnerAccountId);
                    lstLead.add(oLead);
                }
                
                if(oLead.PartnerAccountId != trigger.oldMap.get(oLead.Id).PartnerAccountId && oLead.PartnerAccountId != null &&
                   oLead.Assign_to_Partner__c)
                {
                    setPartnerAccountId.add(oLead.PartnerAccountId);
                    lstLead.add(oLead);
                }
            }
            System.debug('@Developer --> setPartnerAccountId :' + setPartnerAccountId);
            if(setPartnerAccountId.size()>0){
                map<string,list<AccountTeamMember>> mapAccountIdWiseTeamMembers = LeadTriggerHelper.fetchPartnerAccountWiseTeamMembers(setPartnerAccountId);
                if(mapAccountIdWiseTeamMembers.size()>0){
                    LeadTriggerHelper.InsertLeadSharing(lstLead,mapAccountIdWiseTeamMembers,true);
                }
            }
        }
    }
}