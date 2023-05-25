global with sharing class AccountWisePartnerAccountTeamSync implements Database.Batchable<sObject>,database.stateful{
    global map<string,list<AccountTeamMember>> mapAccIdWiseTeamMember ;
    global integer nMode;
    global set<string> setTeamMemberIdToDelete;
    global AccountWisePartnerAccountTeamSync(){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync -->');
        mapAccIdWiseTeamMember = new map<string,list<AccountTeamMember>>();
        nMode = 0;
        setTeamMemberIdToDelete = new set<string>();
    }
    
    global AccountWisePartnerAccountTeamSync(integer nTempMode,map<string,list<AccountTeamMember>> mapTempAccIdWiseTeamMember){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync -->');
        mapAccIdWiseTeamMember = mapTempAccIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = new set<string>();
    }
    
    global AccountWisePartnerAccountTeamSync(integer nTempMode,map<string,list<AccountTeamMember>> mapTempAccIdWiseTeamMember,set<string> setTempTeamMemberIdToDelete){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync -->');
        mapAccIdWiseTeamMember = mapTempAccIdWiseTeamMember;
        nMode = nTempMode;
        setTeamMemberIdToDelete = setTempTeamMemberIdToDelete ; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync --> start --> timestamp:' + system.now());
        set<string> setAccountIds = mapAccIdWiseTeamMember.keySet();
        set<string> setTempTeamMemberIdToDelete = setTeamMemberIdToDelete;
        String query = '';
    
        if(nMode == 1){ //insert
            query = 'Select Id,Rep_Code_Account__c,createdById From Account Where Rep_Code_Account__c in :setAccountIds' ;
        }
        else if(nMode == 2){ //delete
            query = 'Select Id,Rep_Code_Account__c,createdById,(Select Id,UserId,AccountId from accountteammembers where UserId in :setTempTeamMemberIdToDelete) From Account Where Rep_Code_Account__c in :setAccountIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync --> execute --> timestamp:' + system.now());
        if(nMode == 1){
            InsertTeamMember(scope);
        }
        else if(nMode == 2){
            DeleteTeamMembers(scope);
        }
    }
    
    global void InsertTeamMember(List<Account> scope){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync --> InsertTeamMember --> timestamp:' + system.now());
        list<AccountTeamMember> lstAccountTeamMemberToInsert = new list<AccountTeamMember>();
        
        set<Id> setUserId = new set<Id>();
        for(Account acc:scope){
            setUserId.add(acc.CreatedById);
        }
        System.debug('@Developer --> setUserId :' + setUserId);
        //map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
        
        
        for(Account acc:scope){
            //if(mapUserWiseIsPartner.get(acc.CreatedById)){
                if(mapAccIdWiseTeamMember.containsKey(acc.Rep_Code_Account__c)){
                    list<AccountTeamMember> lstTempTeamMember = mapAccIdWiseTeamMember.get(acc.Rep_Code_Account__c);
                    if(lstTempTeamMember!=null && lstTempTeamMember.size()>0 ){
                        for(AccountTeamMember oAccountTeamMember:lstTempTeamMember){
                            AccountTeamMember oNewAccountTeamMember = oAccountTeamMember.clone();
                            oNewAccountTeamMember.AccountId = acc.Id;
                            lstAccountTeamMemberToInsert.add(oNewAccountTeamMember);
                        }
                    }
                }
            //}
        }
        if(lstAccountTeamMemberToInsert.size()>0){
            insert lstAccountTeamMemberToInsert;
        }
    }
    
    global void DeleteTeamMembers(List<Account> scope){
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync --> DeleteTeamMembers --> timestamp:' + system.now());
        list<AccountTeamMember> lstAccountTeamMemberToDelete = new list<AccountTeamMember>();
        set<Id> setUserId = new set<Id>();
        for(Account acc:scope){
            setUserId.add(acc.CreatedById);
        }
        System.debug('@Developer --> setUserId :' + setUserId);
        //map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
        
        for(Account acc:scope){
            //if(mapUserWiseIsPartner.get(acc.CreatedById)){
                if(mapAccIdWiseTeamMember.containsKey(acc.Rep_Code_Account__c)){
                    list<AccountTeamMember> lstTempTeamMember = mapAccIdWiseTeamMember.get(acc.Rep_Code_Account__c);
                    if(lstTempTeamMember!=null && lstTempTeamMember.size()>0 && acc.accountteammembers!=null && acc.accountteammembers.size()>0){
                        for(AccountTeamMember oAccountTeamMember:lstTempTeamMember){
                            for(AccountTeamMember ochildTeamMember:acc.accountteammembers){
                                if(oAccountTeamMember.UserId == ochildTeamMember.UserId){
                                    lstAccountTeamMemberToDelete.add(ochildTeamMember);
                                    break;
                                }
                            }
                        }
                    }
                }
            //}
        }
        if(lstAccountTeamMemberToDelete.size()>0){
            delete lstAccountTeamMemberToDelete;
        }
    }
    
    
    global void finish(Database.BatchableContext BC){   
        System.debug('@Developer --> AccountWisePartnerAccountTeamSync --> finish --> timestamp:' + system.now());
    }
}