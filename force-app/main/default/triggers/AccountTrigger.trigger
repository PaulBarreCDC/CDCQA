trigger AccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(trigger.isBefore){
        System.debug('@Developer -->trigger.isBefore:' );
        
        if(trigger.isInsert){
            System.debug('@Developer -->trigger.isInsert:' );
            
            for(Account oAccount :trigger.New){
                
                /*if(oAccount.Rep_Code_Account__c == null){
                    if(UtilityHelper.self.isInternalUser()){
                        oAccount.Rep_Code_Account__c.addError('Please choose appropriate rep code to proceed further');                
                    }
                    else if(UtilityHelper.self.isPartnerUser()){
                        oAccount.Rep_Code_Account__c = UtilityHelper.self.getPartnerAccountId();                       
                    }
                }*/
                
                if(oAccount.RecordTypeId == UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId()
                    && oAccount.Type <> 'Ship-To'){
                    if(UtilityHelper.self.isPartnerUser()){
                        if(oAccount.Rep_Code_Account__c == null){
                            oAccount.Rep_Code_Account__c = UtilityHelper.self.getPartnerAccountId();
                        }                       
                    }
                    if(oAccount.Rep_Code_Account__c == null && System.UserInfo.getName() <> 'System User'){
                        oAccount.Rep_Code_Account__c.addError('Please choose appropriate rep code to proceed further');                
                    }
                }                    
            }
        }
        
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:' );
            for(Account oAccount :trigger.New){
                
                /*if(oAccount.Rep_Code_Account__c == null){
                    if(UtilityHelper.self.isInternalUser()){
                        oAccount.Rep_Code_Account__c.addError('Please choose appropriate rep code to proceed further');                
                    }
                    else if(UtilityHelper.self.isPartnerUser()){
                        oAccount.Rep_Code_Account__c = UtilityHelper.self.getPartnerAccountId();                       
                    }
                }*/
                
                if(oAccount.RecordTypeId == UtilityHelper.self.mapAccountRecordTypeNameWiseId.get('Customer Account').getRecordTypeId()
                  && oAccount.Type <> 'Ship-To'){
                    if(UtilityHelper.self.isPartnerUser()){
                        if(oAccount.Rep_Code_Account__c == null){
                            oAccount.Rep_Code_Account__c = UtilityHelper.self.getPartnerAccountId();
                        }                       
                    }    
                    if(oAccount.Rep_Code_Account__c == null && System.UserInfo.getName() <> 'System User'){
                        oAccount.Rep_Code_Account__c.addError('Please choose appropriate rep code to proceed further');                
                    }
                }
            }
        }
    }
    else if(trigger.isAfter){
        System.debug('@Developer -->trigger.isAfter:' );
        
        list<AccountTeamMember> lstATMToInsert = new list<AccountTeamMember>();
        list<AccountTeamMember> lstATMToDelete = new list<AccountTeamMember>();
        map<String,AccountTeamMember> mapExistingATM = new map<String,AccountTeamMember>();
        set<Id> setAccId = new set<Id>();
        set<Id> setOldAccId = new set<Id>();
        
        if(trigger.isInsert){
            System.debug('@Developer -->trigger.isInsert:' );
            
            for(Account oAccount :trigger.New){
                System.debug('@Developer --> oAccount.Rep_Code_Account__c :' + oAccount.Rep_Code_Account__c);
                if(oAccount.Rep_Code_Account__c != null){
                    setAccId.add(oAccount.Rep_Code_Account__c);
                }
            }
            
            if(setAccId.size() > 0){
                Map<Id,list<AccountTeamMember>> mapAccIdWiseAccountTeamMembers = UtilityHelper.self.getAccountTeamMembers(setAccId);  
                
                for(Account oAccount :trigger.New){
                    System.debug('@Developer --> oAccount.Rep_Code_Account__c :' + oAccount.Rep_Code_Account__c);
                    if(oAccount.Rep_Code_Account__c != null){
                        if(mapAccIdWiseAccountTeamMembers.containsKey(oAccount.Rep_Code_Account__c)){
                            for(AccountTeamMember atm : mapAccIdWiseAccountTeamMembers.get(oAccount.Rep_Code_Account__c)){
                                AccountTeamMember oAccountTeamMember = new AccountTeamMember();
                                oAccountTeamMember.AccountId = oAccount.Id;
                                oAccountTeamMember.AccountAccessLevel = atm.AccountAccessLevel;
                                oAccountTeamMember.TeamMemberRole = atm.TeamMemberRole;
                                oAccountTeamMember.UserId = atm.UserId;
                                lstATMToInsert.add(oAccountTeamMember);
                            }
                        }
                    }
                }
                
                if(lstATMToInsert.size() > 0){
                    insert lstATMToInsert;
                }
            }            
        }
        
        else if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:' );
            
            for(Account oAccount :trigger.New){
                System.debug('@Developer --> oAccount.Rep_Code_Account__c :' + oAccount.Rep_Code_Account__c);
                
                Account oOldAccount = trigger.oldMap.get(oAccount.Id);
                
                if(oAccount.Rep_Code_Account__c != oOldAccount.Rep_Code_Account__c){
                    if(oOldAccount.Rep_Code_Account__c != null){
                        setAccId.add(oOldAccount.Rep_Code_Account__c);
                        setOldAccId.add(oAccount.Id);
                    }
                    
                    if(oAccount.Rep_Code_Account__c != null){
                        setAccId.add(oAccount.Rep_Code_Account__c);
                    }
                }
            }
            System.debug('@Developer --> setAccId :' + setAccId);
            System.debug('@Developer --> setOldAccId :' + setOldAccId);
            
            if(setOldAccId.size() > 0){                
                for(AccountTeamMember atm : [Select Id,AccountId,AccountAccessLevel,TeamMemberRole,UserId  
                                             From AccountTeamMember 
                                             Where AccountId In :setOldAccId
                                            ])
                {
                    String sKey = atm.AccountId +'-' + atm.AccountAccessLevel + '-' + atm.TeamMemberRole + '-' + atm.UserId;
                    System.debug('@Developer --> sKey :' + sKey);
                    mapExistingATM.put(sKey,atm); 
                }
            }
            System.debug('@Developer --> mapExistingATM :' + mapExistingATM);
            
            if(setAccId.size() > 0){
                Map<Id,list<AccountTeamMember>> mapAccIdWiseAccountTeamMembers = UtilityHelper.self.getAccountTeamMembers(setAccId);  
                
                for(Account oAccount :trigger.New){
                    System.debug('@Developer --> oAccount.Rep_Code_Account__c :' + oAccount.Rep_Code_Account__c);
                    
                    Account oOldAccount = trigger.oldMap.get(oAccount.Id);
                    
                    if(oOldAccount.Rep_Code_Account__c != null){
                        if(mapAccIdWiseAccountTeamMembers.containsKey(oOldAccount.Rep_Code_Account__c)){
                            for(AccountTeamMember atm : mapAccIdWiseAccountTeamMembers.get(oOldAccount.Rep_Code_Account__c)){
                                String sKey = oAccount.Id +'-' + atm.AccountAccessLevel + '-' + atm.TeamMemberRole + '-' + atm.UserId;
                                System.debug('@Developer --> sKey :' + sKey);
                                if(mapExistingATM.containsKey(sKey)){
                                    lstATMToDelete.add(mapExistingATM.get(sKey));
                                }
                            }
                        }
                    }
                    
                    if(oAccount.Rep_Code_Account__c != null){
                        if(mapAccIdWiseAccountTeamMembers.containsKey(oAccount.Rep_Code_Account__c)){
                            for(AccountTeamMember atm : mapAccIdWiseAccountTeamMembers.get(oAccount.Rep_Code_Account__c)){
                                AccountTeamMember oAccountTeamMember = new AccountTeamMember();
                                oAccountTeamMember.AccountId = oAccount.Id;
                                oAccountTeamMember.AccountAccessLevel = atm.AccountAccessLevel;
                                oAccountTeamMember.TeamMemberRole = atm.TeamMemberRole;
                                oAccountTeamMember.UserId = atm.UserId;
                                lstATMToInsert.add(oAccountTeamMember);
                            }
                        }
                    }
                }
                
                System.debug('@Developer --> lstATMToDelete :' + lstATMToDelete);
                if(lstATMToDelete.size() > 0){
                    delete lstATMToDelete;
                }
                
                System.debug('@Developer --> lstATMToInsert :' + lstATMToInsert);
                if(lstATMToInsert.size() > 0){
                    insert lstATMToInsert;
                }
                
                
            } 
        }
    }
}