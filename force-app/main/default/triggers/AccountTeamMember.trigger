trigger AccountTeamMember on AccountTeamMember (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
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
            map<string,list<AccountTeamMember>> mapAccountIdWiseTeamMembers = new map<string,list<AccountTeamMember>>();
            set<string> setAccountId = new set<string>();
            string sPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner & House Account').getRecordTypeId();
            for(AccountTeamMember oAccountTeamMember:trigger.New){
                if(oAccountTeamMember.TeamMemberRole=='Sales Rep'){
                    setAccountId.add(oAccountTeamMember.AccountId);
                }
            }
            set<string> setPartnerAccountIds = new set<string>();
            for(Account oAccount:[Select Id From Account Where Recordtypeid=:sPartnerRecordTypeId and Id in :setAccountId]){
                setPartnerAccountIds.add(oAccount.Id);
            }
            for(AccountTeamMember oAccountTeamMember:trigger.New){
                if(oAccountTeamMember.TeamMemberRole=='Sales Rep'){
                    if(setPartnerAccountIds.contains(oAccountTeamMember.AccountId)){
                        list<AccountTeamMember> lstTeamMembers = new list<AccountTeamMember>();
                        if(mapAccountIdWiseTeamMembers.containsKey(oAccountTeamMember.AccountId)){
                            lstTeamMembers = mapAccountIdWiseTeamMembers.get(oAccountTeamMember.AccountId);
                        }
                        lstTeamMembers.add(oAccountTeamMember);
                        mapAccountIdWiseTeamMembers.put(oAccountTeamMember.AccountId,lstTeamMembers);
                    }
                }
            }
            if(mapAccountIdWiseTeamMembers.size()>0){
                AccountWiseOpportunityTeamSync oAccountWiseOpportunityTeamSync = new AccountWiseOpportunityTeamSync(1,mapAccountIdWiseTeamMembers);
                database.executeBatch(oAccountWiseOpportunityTeamSync);
                
                AccountWisePartnerAccountTeamSync oAccountWisePartnerAccountTeamSync = new AccountWisePartnerAccountTeamSync(1,mapAccountIdWiseTeamMembers);
                database.executeBatch(oAccountWisePartnerAccountTeamSync);
                
                AccountWiseLeadShareSync oAccountWiseLeadShareSync = new AccountWiseLeadShareSync(1,mapAccountIdWiseTeamMembers);
                database.executeBatch(oAccountWiseLeadShareSync);
            }
        }
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:' );
        }
        if(trigger.isDelete){
            System.debug('@Developer -->trigger.isDelete:' );
            map<string,list<AccountTeamMember>> mapAccountIdWiseTeamMembers = new map<string,list<AccountTeamMember>>();
            set<string> setAccountId = new set<string>();
            set<string> setTempTeamMemberIdToDelete = new set<string>();
            string sPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner & House Account').getRecordTypeId();
            for(AccountTeamMember oAccountTeamMember:trigger.Old){
                if(oAccountTeamMember.TeamMemberRole=='Sales Rep'){
                    setAccountId.add(oAccountTeamMember.AccountId);
                }
            }
            set<string> setPartnerAccountIds = new set<string>();
            for(Account oAccount:[Select Id From Account Where Recordtypeid=:sPartnerRecordTypeId and Id in :setAccountId]){
                setPartnerAccountIds.add(oAccount.Id);
            }
            for(AccountTeamMember oAccountTeamMember:trigger.Old){
                if(oAccountTeamMember.TeamMemberRole=='Sales Rep'){
                    if(setPartnerAccountIds.contains(oAccountTeamMember.AccountId)){
                        setTempTeamMemberIdToDelete.add(oAccountTeamMember.UserId);
                        list<AccountTeamMember> lstTeamMembers = new list<AccountTeamMember>();
                        if(mapAccountIdWiseTeamMembers.containsKey(oAccountTeamMember.AccountId)){
                            lstTeamMembers = mapAccountIdWiseTeamMembers.get(oAccountTeamMember.AccountId);
                        }
                        lstTeamMembers.add(oAccountTeamMember);
                        mapAccountIdWiseTeamMembers.put(oAccountTeamMember.AccountId,lstTeamMembers);
                    }
                }
            }
            if(mapAccountIdWiseTeamMembers.size()>0){
                AccountWiseOpportunityTeamSync oAccountWiseOpportunityTeamSync = new AccountWiseOpportunityTeamSync(2,mapAccountIdWiseTeamMembers,setTempTeamMemberIdToDelete);
                database.executeBatch(oAccountWiseOpportunityTeamSync);
                
                AccountWisePartnerAccountTeamSync oAccountWisePartnerAccountTeamSync = new AccountWisePartnerAccountTeamSync(2,mapAccountIdWiseTeamMembers,setTempTeamMemberIdToDelete);
                database.executeBatch(oAccountWisePartnerAccountTeamSync);
                
                AccountWiseLeadShareSync oAccountWiseLeadShareSync = new AccountWiseLeadShareSync(2,mapAccountIdWiseTeamMembers,setTempTeamMemberIdToDelete);
                database.executeBatch(oAccountWiseLeadShareSync);
            }
        }
        
        if(trigger.isUnDelete){
            System.debug('@Developer -->trigger.isUnDelete:' );
        }
    }
}