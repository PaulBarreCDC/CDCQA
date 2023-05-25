trigger OpportunityTeamMember on OpportunityTeamMember (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(system.isBatch()){
        return;
    }
    if(trigger.isBefore){
        System.debug('@Developer -->trigger.isBefore:' );
        if(trigger.isInsert){ 
            System.debug('@Developer -->trigger.isInsert:' );
        }
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:' );
        }
        if(trigger.isDelete){
            System.debug('@Developer -->trigger.isDelete:' );
        }
    }
    else if(trigger.isAfter){
        System.debug('@Developer -->trigger.isAfter:' );
        if(trigger.isInsert){
            System.debug('@Developer -->trigger.isInsert:' );
            map<string,list<OpportunityTeamMember>> mapOppIdWiseTeamMembers = new map<string,list<OpportunityTeamMember>>();
            for(OpportunityTeamMember oOpportunityTeamMember:trigger.New){
                if(oOpportunityTeamMember.TeamMemberRole=='Sales Rep'){
                    list<OpportunityTeamMember> lstTeamMembers = new list<OpportunityTeamMember>();
                    if(mapOppIdWiseTeamMembers.containsKey(oOpportunityTeamMember.OpportunityId)){
                        lstTeamMembers = mapOppIdWiseTeamMembers.get(oOpportunityTeamMember.OpportunityId);
                    }
                    lstTeamMembers.add(oOpportunityTeamMember);
                    mapOppIdWiseTeamMembers.put(oOpportunityTeamMember.OpportunityId,lstTeamMembers);
                }
            }
            if(mapOppIdWiseTeamMembers.size()>0){
                OpportuntyWiseQuoteSharingSync oOpportuntyWiseQuoteSharingSync = new OpportuntyWiseQuoteSharingSync(1,mapOppIdWiseTeamMembers);
                database.executeBatch(oOpportuntyWiseQuoteSharingSync);
            }
        }
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:' );
        }
        if(trigger.isDelete){
            System.debug('@Developer -->trigger.isDelete:' );
            map<string,list<OpportunityTeamMember>> mapOppIdWiseTeamMembers = new map<string,list<OpportunityTeamMember>>();
            set<string> setTempTeamMemberIdToDelete = new set<string>();
            for(OpportunityTeamMember oOpportunityTeamMember:trigger.Old){
                if(oOpportunityTeamMember.TeamMemberRole=='Sales Rep'){
                    setTempTeamMemberIdToDelete.add(oOpportunityTeamMember.UserId);
                    list<OpportunityTeamMember> lstTeamMembers = new list<OpportunityTeamMember>();
                    if(mapOppIdWiseTeamMembers.containsKey(oOpportunityTeamMember.OpportunityId)){
                        lstTeamMembers = mapOppIdWiseTeamMembers.get(oOpportunityTeamMember.OpportunityId);
                    }
                    lstTeamMembers.add(oOpportunityTeamMember);
                    mapOppIdWiseTeamMembers.put(oOpportunityTeamMember.OpportunityId,lstTeamMembers);
                }
            }
            if(mapOppIdWiseTeamMembers.size()>0){
                OpportuntyWiseQuoteSharingSync oOpportuntyWiseQuoteSharingSync = new OpportuntyWiseQuoteSharingSync(2,mapOppIdWiseTeamMembers,setTempTeamMemberIdToDelete);
                database.executeBatch(oOpportuntyWiseQuoteSharingSync);
            }
        }
        
        if(trigger.isUnDelete){
            System.debug('@Developer -->trigger.isUnDelete:' );
        }
    }
}