public class ShareRecordsToPublicGroup {
    
    public static void shareAccountRecordsToOwnerCompanyGroup(List<Account> accList){
        Set<Id> usrIdSet = new Set<Id>();
        for(Account acc:accList){
            usrIdSet.add(acc.CreatedById);
        }
        Set<String> pubGrpName = new Set<String>();
        Map<Id, String> usrAccMap = new Map<Id, String>();
        for(User usr:[select u.Id, u.Contact.Account.Name, u.Profile.Name,u.IsActive from User u where u.Id IN :usrIdSet AND (u.Profile.Name =: Constants.PARTNER_COMMUNITY_REP_PROFILE OR u.Profile.Name =: Constants.PARTNER_COMMUNITY_USER_PROFILE) AND u.IsActive= TRUE]){
            pubGrpName.add(usr.Contact.Account.Name);
            usrAccMap.put(usr.Id, usr.Contact.Account.Name);
        }
        
        if(pubGrpName.size() > 0){
            List<AccountShare> accShrs  = new List<AccountShare>();
            Map<String, Id> groupIdMap = new Map<String, Id>();
            for(Group grp: [select Id,Name from Group where Type='Regular' and NAME IN : pubGrpName]){
                groupIdMap.put(grp.Name, grp.Id);
            }
            for(Account acc:accList){
                if(usrAccMap.containsKey(acc.CreatedById)){
                   AccountShare accShare = new AccountShare(); 
                    accShare.AccountId = acc.Id;
                    accShare.UserOrGroupId = groupIdMap.get(usrAccMap.get(acc.CreatedById));
                    accShare.AccountAccessLevel = 'Edit';
                    accShare.OpportunityAccessLevel = 'Edit';
                    accShrs.add(accShare);
                }
            }
            if(accShrs.size() > 0){
                insert accShrs;
            }
        }
    }  
    
    public static void shareLeadRecordsToOwnerCompanyGroup(List<Lead> leadList){
        Set<Id> usrIdSet = new Set<Id>();
        for(Lead le:leadList){
            usrIdSet.add(le.OwnerId);
        }
        System.debug('***usrIdSet*** '+usrIdSet);
        Set<String> pubGrpName = new Set<String>();
        Map<Id, String> usrAccMap = new Map<Id, String>();
        for(User usr:[select u.Id, u.Contact.Account.Name, u.Profile.Name,u.IsActive from User u where u.Id IN :usrIdSet AND (u.Profile.Name =: Constants.PARTNER_COMMUNITY_REP_PROFILE OR u.Profile.Name =: Constants.PARTNER_COMMUNITY_USER_PROFILE) AND u.IsActive= TRUE]){
            pubGrpName.add(usr.Contact.Account.Name);
            usrAccMap.put(usr.Id, usr.Contact.Account.Name);
        }
        System.debug('***usrAccMap*** '+usrAccMap);
        if(pubGrpName.size() > 0){
            List<LeadShare> leadShrs  = new List<LeadShare>();
            Map<String, Id> groupIdMap = new Map<String, Id>();
            for(Group grp: [select Id,Name from Group where Type='Regular' and NAME IN : pubGrpName]){
                groupIdMap.put(grp.Name, grp.Id);
            }
            for(Lead l:leadList){
                if(usrAccMap.containsKey(l.OwnerId)){
                   LeadShare ledShare = new LeadShare(); 
                    ledShare.LeadId = l.Id;
                    ledShare.UserOrGroupId = groupIdMap.get(usrAccMap.get(l.OwnerId));
                    ledShare.LeadAccessLevel = 'Edit';
                    leadShrs.add(ledShare);
                }
            }
            if(leadShrs.size() > 0){
                insert leadShrs;
            }
        }
    }  

    public static void shareOpportunityRecordsToOwnerCompanyGroup(List<Opportunity> oppList){
        Set<Id> usrIdSet = new Set<Id>();
        for(Opportunity opp:oppList){
            usrIdSet.add(opp.CreatedById);
        }
        Set<String> pubGrpName = new Set<String>();
        Map<Id, String> usrAccMap = new Map<Id, String>();
        for(User usr:[select u.Id, u.Contact.Account.Name, u.Profile.Name,u.IsActive from User u where u.Id IN :usrIdSet AND (u.Profile.Name =: Constants.PARTNER_COMMUNITY_REP_PROFILE OR u.Profile.Name =: Constants.PARTNER_COMMUNITY_USER_PROFILE) AND u.IsActive= TRUE]){
            pubGrpName.add(usr.Contact.Account.Name);
            usrAccMap.put(usr.Id, usr.Contact.Account.Name);
        }
        
        if(pubGrpName.size() > 0){
            List<OpportunityShare> oppShrs  = new List<OpportunityShare>();
            Map<String, Id> groupIdMap = new Map<String, Id>();
            for(Group grp: [select Id,Name from Group where Type='Regular' and NAME IN : pubGrpName]){
                groupIdMap.put(grp.Name, grp.Id);
            }
            for(Opportunity opp:oppList){
                if(usrAccMap.containsKey(opp.CreatedById)){
                    OpportunityShare oppShare = new OpportunityShare(); 
                    oppShare.OpportunityId = opp.Id;
                    oppShare.UserOrGroupId = groupIdMap.get(usrAccMap.get(opp.CreatedById));
                    oppShare.OpportunityAccessLevel = 'Edit';
                    oppShrs.add(oppShare);
                }
            }
            if(oppShrs.size() > 0){
                insert oppShrs;
            }
        }
    }
    public static void shareAccountRecordOnUpdation(List<Account> accList, Map<Id, Account> accMap){
        List<Account> accListNew = new List<Account>();
        for(Account acc:accList){
            if(acc.OwnerId != accMap.get(acc.Id).OwnerId){
                accListNew.add(acc);
            }
        }
        if(accListNew.size() > 0){
            shareAccountRecordsToOwnerCompanyGroup(accListNew);
        }
    }
    
    public static void shareOpportunityRecordOnUpdation(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){
        List<Opportunity> oppListNew = new List<Opportunity>();
        for(Opportunity opp: oppList){
            if(opp.OwnerId != oldMap.get(opp.Id).OwnerId){
                oppListNew.add(opp);
            }
        }
        if(oppListNew.size() > 0){
            shareOpportunityRecordsToOwnerCompanyGroup(oppListNew);
        }
    }
    
    public static void shareLeadRecordOnUpdation(List<Lead> leadList, Map<Id, Lead> leadMap){
        System.debug('Inside lead share condition');
        List<Lead> leadListNew = new List<Lead>();
        for(Lead l: leadList){
            if(l.OwnerId != leadMap.get(l.Id).OwnerId){
                leadListNew.add(l);
            }
        }
        if(leadListNew.size() > 0){
            System.debug('***leadListNew*** '+leadListNew);
            shareLeadRecordsToOwnerCompanyGroup(leadListNew);
        }
    }
}