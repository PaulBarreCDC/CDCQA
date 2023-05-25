global with sharing class AccountWiseLeadShareSync implements Database.Batchable<sObject>,database.stateful{
    global map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember ;
    global integer nMode;
    global set<string> setTeamMemberIdToDelete;
    global AccountWiseLeadShareSync(){
        System.debug('@Developer --> AccountWiseLeadShareSync -->');
        mapAccIdWiseTeamMember = new map<string,list<AccountTeamMember>>();
        nMode = 0;
        setTeamMemberIdToDelete = new set<string>();
    }
    global AccountWiseLeadShareSync(integer nTempMode,map<string,list<AccountTeamMember>> mapTempAccIdWiseTeamMember){
        System.debug('@Developer --> AccountWiseLeadShareSync -->');
        mapAccIdWiseTeamMember = mapTempAccIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = new set<string>();
    }
    global AccountWiseLeadShareSync(integer nTempMode,map<string,list<AccountTeamMember>> mapTempAccIdWiseTeamMember,set<string> setTempTeamMemberIdToDelete){
        System.debug('@Developer --> AccountWiseLeadShareSync -->');
        mapAccIdWiseTeamMember = mapTempAccIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = setTempTeamMemberIdToDelete ; 
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('@Developer --> AccountWiseLeadShareSync --> start --> timestamp:' + system.now());
        set<string> setAccountIds = mapAccIdWiseTeamMember.keySet();
        set<string> setTempTeamMemberIdToDelete = setTeamMemberIdToDelete;
        String query = '';
        if(nMode == 1){ //insert
            query = 'Select Id,PartnerAccountId,ownerid,CreatedById From lead Where Assign_to_Partner__c = true and PartnerAccountId in :setAccountIds' ;
        }
        else if(nMode == 2){ //delete
            query = 'Select Id,PartnerAccountId,ownerid,CreatedById,(select id,UserOrGroupId from shares where UserOrGroupId in : setTeamMemberIdToDelete) From lead Where Assign_to_Partner__c = true and PartnerAccountId in :setAccountIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        System.debug('@Developer --> AccountWiseLeadShareSync --> execute --> timestamp:' + system.now());
        if(nMode == 1){
            LeadTriggerHelper.InsertLeadSharing(scope,mapAccIdWiseTeamMember,false);
        }
        else if(nMode == 2){
            LeadTriggerHelper.DeleteLeadSharing(scope,mapAccIdWiseTeamMember,false);
        }
    }
    
    global void finish(Database.BatchableContext BC){   
        System.debug('@Developer --> AccountWiseLeadShareSync --> finish --> timestamp:' + system.now());
    }
}