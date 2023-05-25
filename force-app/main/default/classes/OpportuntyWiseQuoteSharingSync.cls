global with sharing class OpportuntyWiseQuoteSharingSync implements Database.Batchable<sObject>,database.stateful{
    global map<string,list<OpportunityTeamMember>> mapOppIdWiseTeamMember ;
    global integer nMode;
    global set<string> setTeamMemberIdToDelete;
    global OpportuntyWiseQuoteSharingSync(){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync -->');
        mapOppIdWiseTeamMember = new map<string,list<OpportunityTeamMember>>();
        nMode = 0;
        setTeamMemberIdToDelete = new set<string>();
    }
    global OpportuntyWiseQuoteSharingSync(integer nTempMode,map<string,list<OpportunityTeamMember>> mapTempOppIdWiseTeamMember){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync -->');
        mapOppIdWiseTeamMember = mapTempOppIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = new set<string>();
    }
    global OpportuntyWiseQuoteSharingSync(integer nTempMode,map<string,list<OpportunityTeamMember>> mapTempOppIdWiseTeamMember,set<string> setTempTeamMemberIdToDelete){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync -->');
        mapOppIdWiseTeamMember = mapTempOppIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = setTempTeamMemberIdToDelete ; 
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync --> start --> timestamp:' + system.now());
        set<string> setOpportunityIds = mapOppIdWiseTeamMember.keySet();
        set<string> setTempTeamMemberIdToDelete = setTeamMemberIdToDelete;
        String query = '';
        if(nMode == 1){ //insert
            query = 'Select Id,ownerid,SBQQ__Opportunity2__c From SBQQ__Quote__c Where SBQQ__Opportunity2__c in :setOpportunityIds' ;
        }
        else if(nMode == 2){ //delete
            query = 'Select Id,ownerid,SBQQ__Opportunity2__c,(select id,UserOrGroupId from shares where UserOrGroupId in : setTeamMemberIdToDelete) From SBQQ__Quote__c Where SBQQ__Opportunity2__c in :setOpportunityIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SBQQ__Quote__c> scope){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync --> execute --> timestamp:' + system.now());
        if(nMode == 1){
            InsertQuoteShare(scope);
        }
        else if(nMode == 2){
            DeleteQuoteShare(scope);
        }
    }
    
    global void InsertQuoteShare(List<SBQQ__Quote__c> scope){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync --> InsertQuoteShare --> timestamp:' + system.now());
        list<SBQQ__Quote__Share> lstQuoteShareToInsert = new list<SBQQ__Quote__Share>();
        
        for(SBQQ__Quote__c oQuote:scope){
            if(mapOppIdWiseTeamMember.containsKey(oQuote.SBQQ__Opportunity2__c)){
                list<OpportunityTeamMember> lstTempTeamMember = mapOppIdWiseTeamMember.get(oQuote.SBQQ__Opportunity2__c);
                if(lstTempTeamMember!=null && lstTempTeamMember.size()>0 ){
                    for(OpportunityTeamMember oOpportunityTeamMember:lstTempTeamMember){
                        if(oOpportunityTeamMember.UserId!=oQuote.ownerid){
                            SBQQ__Quote__Share objQuoteShare = new SBQQ__Quote__Share();
                            objQuoteShare.AccessLevel = oOpportunityTeamMember.opportunityaccessLevel;
                            objQuoteShare.UserOrGroupId = oOpportunityTeamMember.UserId;
                            objQuoteShare.ParentID = oQuote.Id;
                            objQuoteShare.RowCause = 'Manual';
                            lstQuoteShareToInsert.add(objQuoteShare);
                        }
                    }
                }
            }
        }
        if(lstQuoteShareToInsert.size()>0){
            insert lstQuoteShareToInsert;
        }
    }
    
    global void DeleteQuoteShare(List<SBQQ__Quote__c> scope){
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync --> DeleteQuoteShare --> timestamp:' + system.now());
        list<SBQQ__Quote__Share> lstQuoteShareToDelete = new list<SBQQ__Quote__Share>();
        for(SBQQ__Quote__c oQuote:scope){
            if(mapOppIdWiseTeamMember.containsKey(oQuote.SBQQ__Opportunity2__c)){
                list<OpportunityTeamMember> lstTempTeamMember = mapOppIdWiseTeamMember.get(oQuote.SBQQ__Opportunity2__c);
                if(lstTempTeamMember!=null && lstTempTeamMember.size()>0 && oQuote.shares!=null && oQuote.shares.size()>0){
                    for(OpportunityTeamMember oOpportunityTeamMember:lstTempTeamMember){
                        for(SBQQ__Quote__Share oQuoteShare:oQuote.shares){
                            if(oQuoteShare.UserOrGroupId == oOpportunityTeamMember.UserId && oOpportunityTeamMember.UserId!=oQuote.ownerid){
                                lstQuoteShareToDelete.add(oQuoteShare);
                                break;
                            }
                        }
                    }
                }
            }
        }
        if(lstQuoteShareToDelete.size()>0){
            delete lstQuoteShareToDelete;
        }
    }
    
    
    global void finish(Database.BatchableContext BC){   
        System.debug('@Developer --> OpportuntyWiseQuoteSharingSync --> finish --> timestamp:' + system.now());
    }
}