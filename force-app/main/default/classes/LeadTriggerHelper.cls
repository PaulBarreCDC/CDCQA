public class LeadTriggerHelper {
    public static map<string,list<AccountTeamMember>> fetchPartnerAccountWiseTeamMembers(set<Id> setPartnerAccountId){
        System.debug('@Developer -->LeadTriggerHelper.fetchPartnerAccountWiseTeamMembers:' );
        System.debug('@Developer --> setPartnerAccountId :' + setPartnerAccountId);
    
        map<string,list<AccountTeamMember>> mapAccountIdWiseTeamMembers = new map<string,list<AccountTeamMember>>();
        for(AccountTeamMember oAccountTeamMember : [Select Id,AccountId,TeamMemberRole,UserId 
                                                    From AccountTeamMember 
                                                    Where AccountId In :setPartnerAccountId
                                                    And TeamMemberRole = 'Sales Rep'
                                                   ])
        {
            list<AccountTeamMember> lstTeamMembers = new list<AccountTeamMember>();
            if(mapAccountIdWiseTeamMembers.containsKey(oAccountTeamMember.AccountId)){
                lstTeamMembers = mapAccountIdWiseTeamMembers.get(oAccountTeamMember.AccountId);
            }
            lstTeamMembers.add(oAccountTeamMember);
            mapAccountIdWiseTeamMembers.put(oAccountTeamMember.AccountId,lstTeamMembers);
        }
        System.debug('@Developer --> mapAccountIdWiseTeamMembers :' + mapAccountIdWiseTeamMembers);
        
        return mapAccountIdWiseTeamMembers;
    }
    
    public static void InsertLeadSharing(map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember){
        System.debug('@Developer --> InsertLeadSharing --> timestamp:' + system.now());
        set<string> setAccountIds = mapAccIdWiseTeamMember.keySet();
        System.debug('@Developer --> setAccountIds:' + setAccountIds);
        List<Lead> lstLead = database.query('Select Id,PartnerAccountId,ownerid,CreatedById From lead Where Assign_to_Partner__c = true and PartnerAccountId in :setAccountIds');
        InsertLeadSharing(lstLead,mapAccIdWiseTeamMember,false);
    }
   
    public static void InsertLeadSharing(List<Lead> lstLead,map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember,Boolean bForceShare){
        System.debug('@Developer --> InsertLeadSharing --> timestamp:' + system.now());
        list<LeadShare> lstLeadShareToInsert = new list<LeadShare>();
        
        set<Id> setUserId = new set<Id>();
        for(Lead oLead:lstLead){
            setUserId.add(oLead.CreatedById);
        }
        System.debug('@Developer --> setUserId :' + setUserId);
        map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
        
        for(Lead oLead:lstLead){
            if(mapUserWiseIsPartner.get(oLead.CreatedById) || bForceShare){
                if(mapAccIdWiseTeamMember.containsKey(oLead.PartnerAccountId)){
                    list<AccountTeamMember> lstTempTeamMember = mapAccIdWiseTeamMember.get(oLead.PartnerAccountId);
                    if(lstTempTeamMember != null && lstTempTeamMember.size() > 0 ){
                        for(AccountTeamMember oAccountTeamMember:lstTempTeamMember){
                            if(oAccountTeamMember.UserId != oLead.ownerid){
                                LeadShare oLeadShare = new LeadShare();
                                oLeadShare.LeadAccessLevel = 'Edit';
                                oLeadShare.UserOrGroupId = oAccountTeamMember.UserId;
                                oLeadShare.LeadID = oLead.Id;
                                oLeadShare.RowCause = 'Manual';
                                lstLeadShareToInsert.add(oLeadShare);
                            }
                        }
                    }
                }
            }
        }
        if(lstLeadShareToInsert.size()>0){
            insert lstLeadShareToInsert;
        }
    }
    
    public static void DeleteLeadSharing(map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember,set<string> setTeamMemberIdToDelete){
        System.debug('@Developer --> DeleteLeadSharing --> timestamp:' + system.now());
        set<string> setAccountIds = mapAccIdWiseTeamMember.keySet();
        System.debug('@Developer --> setAccountIds:' + setAccountIds);
        System.debug('@Developer --> setTeamMemberIdToDelete:' + setTeamMemberIdToDelete);
        list<Lead>lstLead = database.query('Select Id,PartnerAccountId,ownerid,CreatedById,(select id,UserOrGroupId from shares where UserOrGroupId in : setTeamMemberIdToDelete) From lead Where Assign_to_Partner__c = true and PartnerAccountId in :setAccountIds');
        DeleteLeadSharing(lstLead,mapAccIdWiseTeamMember,false);
    }
    
    public static void DeleteLeadSharing(List<Lead>lstLead,map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember,set<string> setTeamMemberIdToDelete,Boolean bForceShare){
        System.debug('@Developer --> DeleteLeadSharing --> timestamp:' + system.now());
        set<string> setAccountIds = mapAccIdWiseTeamMember.keySet();
        System.debug('@Developer --> setAccountIds:' + setAccountIds);
        System.debug('@Developer --> setTeamMemberIdToDelete:' + setTeamMemberIdToDelete);
        lstLead = database.query('Select Id,PartnerAccountId,ownerid,CreatedById,(select id,UserOrGroupId from shares where UserOrGroupId in : setTeamMemberIdToDelete) From lead Where Assign_to_Partner__c = true and PartnerAccountId in :setAccountIds And Id In :lstLead ');
        DeleteLeadSharing(lstLead,mapAccIdWiseTeamMember, bForceShare);
    }
        
    public static void DeleteLeadSharing(List<Lead> lstLead,map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember,Boolean bForceShare){
        System.debug('@Developer --> DeleteLeadSharing --> timestamp:' + system.now());
        list<LeadShare> lstLeadShareToDelete = new list<LeadShare>();
        
        set<Id> setUserId = new set<Id>();
        for(Lead oLead:lstLead){
            setUserId.add(oLead.CreatedById);
        }
        System.debug('@Developer --> setUserId :' + setUserId);
        map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
        
        for(Lead oLead:lstLead){
            if(mapUserWiseIsPartner.get(oLead.CreatedById) || bForceShare){
                if(mapAccIdWiseTeamMember.containsKey(oLead.PartnerAccountId)){
                    list<AccountTeamMember> lstTempTeamMember = mapAccIdWiseTeamMember.get(oLead.PartnerAccountId);
                    if(lstTempTeamMember != null && lstTempTeamMember.size() > 0 && oLead.shares!=null && oLead.shares.size() > 0){
                        for(AccountTeamMember oAccountTeamMember:lstTempTeamMember){
                            for(LeadShare oLeadShare:oLead.shares){
                                if(oLeadShare.UserOrGroupId == oAccountTeamMember.UserId && oAccountTeamMember.UserId != oLead.ownerid){
                                    lstLeadShareToDelete.add(oLeadShare);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        if(lstLeadShareToDelete.size()>0){
            delete lstLeadShareToDelete;
        }
    }
}