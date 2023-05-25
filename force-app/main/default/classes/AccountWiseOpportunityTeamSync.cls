global with sharing class AccountWiseOpportunityTeamSync implements Database.Batchable<sObject>,database.stateful{
    global map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember ;
    global map<string,list<OpportunityTeamMember>> mapOppIdWiseTeamMembers ;
    global integer nMode;
    global set<string> setTeamMemberIdToDelete;
    
    global AccountWiseOpportunityTeamSync(){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync -->');
        mapAccIdWiseTeamMember = new map<string,list<AccountTeamMember>>();
        nMode = 0;
        setTeamMemberIdToDelete = new set<string>();
    }
    
    global AccountWiseOpportunityTeamSync(integer nTempMode,map<string,list<AccountTeamMember>> mapTempAccIdWiseTeamMember){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync -->');
        mapAccIdWiseTeamMember = mapTempAccIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = new set<string>();
    }
    
    global AccountWiseOpportunityTeamSync(integer nTempMode,map<string,list<AccountTeamMember>> mapTempAccIdWiseTeamMember,set<string> setTempTeamMemberIdToDelete){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync -->');
        mapAccIdWiseTeamMember = mapTempAccIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = setTempTeamMemberIdToDelete ; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync --> start --> timestamp:' + system.now());
        mapOppIdWiseTeamMembers = new map<string,list<OpportunityTeamMember>>();
        set<string> setAccountIds = mapAccIdWiseTeamMember.keySet();
        set<string> setTempTeamMemberIdToDelete = setTeamMemberIdToDelete;
        String query = '';
    
        if(nMode == 1){ //insert
            query = 'Select Id,PartnerAccountId,createdById From Opportunity Where PartnerAccountId in :setAccountIds' ;
        }
        else if(nMode == 2){ //delete
            query = 'Select Id,PartnerAccountId,createdById,(Select Id,UserId,OpportunityId from opportunityteammembers where UserId in :setTempTeamMemberIdToDelete) From Opportunity Where PartnerAccountId in :setAccountIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync --> execute --> timestamp:' + system.now());
        if(nMode == 1){
            InsertTeamMember(scope);
        }
        else if(nMode == 2){
            DeleteTeamMembers(scope);
        }
    }
    
    global void InsertTeamMember(List<Opportunity> scope){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync --> InsertTeamMember --> timestamp:' + system.now());
        list<OpportunityTeamMember> lstOpportunityTeamMemberToInsert = new list<OpportunityTeamMember>();
        
        set<Id> setUserId = new set<Id>();
        for(Opportunity opp:scope){
            setUserId.add(opp.CreatedById);
        }
        System.debug('@Developer --> setUserId :' + setUserId);
        map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
        
        
        for(Opportunity opp:scope){
            if(mapUserWiseIsPartner.get(opp.CreatedById)){
                if(mapAccIdWiseTeamMember.containsKey(opp.PartnerAccountId)){
                    list<AccountTeamMember> lstTempTeamMember = mapAccIdWiseTeamMember.get(opp.PartnerAccountId);
                    if(lstTempTeamMember!=null && lstTempTeamMember.size()>0 ){
                        for(AccountTeamMember oAccountTeamMember:lstTempTeamMember){
                            if(oAccountTeamMember.opportunityaccessLevel!='None'){
                                OpportunityTeamMember oOpportunityTeamMember = new OpportunityTeamMember();
                                oOpportunityTeamMember.OpportunityId = opp.Id;
                                oOpportunityTeamMember.opportunityaccessLevel = oAccountTeamMember.opportunityaccessLevel;
                                oOpportunityTeamMember.TeamMemberRole = oAccountTeamMember.TeamMemberRole;
                                oOpportunityTeamMember.UserId = oAccountTeamMember.UserId;
                                lstOpportunityTeamMemberToInsert.add(oOpportunityTeamMember);
                                list<OpportunityTeamMember> lstTeamMembers = new list<OpportunityTeamMember>();
                                if(mapOppIdWiseTeamMembers.containsKey(oOpportunityTeamMember.OpportunityId)){
                                    lstTeamMembers = mapOppIdWiseTeamMembers.get(oOpportunityTeamMember.OpportunityId);
                                }
                                lstTeamMembers.add(oOpportunityTeamMember);
                                mapOppIdWiseTeamMembers.put(oOpportunityTeamMember.OpportunityId,lstTeamMembers);
                            }
                        }
                    }
                }
            }
        }
        if(lstOpportunityTeamMemberToInsert.size()>0){
            insert lstOpportunityTeamMemberToInsert;
        }
    }
    
    global void DeleteTeamMembers(List<Opportunity> scope){
        System.debug('@Developer --> AccountWiseOpportunityTeamSync --> DeleteTeamMembers --> timestamp:' + system.now());
        list<OpportunityTeamMember> lstOpportunityTeamMemberToDelete = new list<OpportunityTeamMember>();
        set<Id> setUserId = new set<Id>();
        for(Opportunity opp:scope){
            setUserId.add(opp.CreatedById);
        }
        System.debug('@Developer --> setUserId :' + setUserId);
        map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
        
        for(Opportunity opp:scope){
            if(mapUserWiseIsPartner.get(opp.CreatedById)){
                if(mapAccIdWiseTeamMember.containsKey(opp.PartnerAccountId)){
                    list<AccountTeamMember> lstTempTeamMember = mapAccIdWiseTeamMember.get(opp.PartnerAccountId);
                    if(lstTempTeamMember!=null && lstTempTeamMember.size()>0 && opp.opportunityteammembers!=null && opp.opportunityteammembers.size()>0){
                        for(AccountTeamMember oAccountTeamMember:lstTempTeamMember){
                            for(OpportunityTeamMember oOpportunityTeamMember:opp.opportunityteammembers){
                                if(oAccountTeamMember.UserId == oOpportunityTeamMember.UserId){
                                    lstOpportunityTeamMemberToDelete.add(oOpportunityTeamMember);
                                    
                                    list<OpportunityTeamMember> lstTeamMembers = new list<OpportunityTeamMember>();
                                    if(mapOppIdWiseTeamMembers.containsKey(oOpportunityTeamMember.OpportunityId)){
                                        lstTeamMembers = mapOppIdWiseTeamMembers.get(oOpportunityTeamMember.OpportunityId);
                                    }
                                    lstTeamMembers.add(oOpportunityTeamMember);
                                    mapOppIdWiseTeamMembers.put(oOpportunityTeamMember.OpportunityId,lstTeamMembers);
                                    
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        if(lstOpportunityTeamMemberToDelete.size()>0){
            delete lstOpportunityTeamMemberToDelete;
        }
    }
    
    
    global void finish(Database.BatchableContext BC){   
        System.debug('@Developer --> AccountWiseOpportunityTeamSync --> finish --> timestamp:' + system.now());
        if(mapOppIdWiseTeamMembers.size()>0){
            if(nMode == 1){
                OpportuntyWiseQuoteSharingSync oOpportuntyWiseQuoteSharingSync = new OpportuntyWiseQuoteSharingSync(1,mapOppIdWiseTeamMembers);
                database.executeBatch(oOpportuntyWiseQuoteSharingSync);
            }
            else if(nMode == 2){
                OpportuntyWiseQuoteSharingSync oOpportuntyWiseQuoteSharingSync = new OpportuntyWiseQuoteSharingSync(2,mapOppIdWiseTeamMembers,setTeamMemberIdToDelete);
                database.executeBatch(oOpportuntyWiseQuoteSharingSync);
            }
        }
    }
}