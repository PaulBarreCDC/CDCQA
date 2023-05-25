/*
Author Name   : Akhilesh Soni
Class Name    : OpportunityTrigger
Created Date  : 6 Mar, 2020
Description   : trigger on opportunity to create opportunity pipeline amount record and update goals and performance referece
*/
/** 2020-03-17 Robby Commented out Line 107, to create a quote for demo; Will uncomment afterwards **/

trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    if(trigger.isBefore){
        System.debug('@Developer -->trigger.isBefore:' );
        set<String> setBrand = new set<String>();
        set<String> setPartnerAccount = new set<String>();
        map<String,map<String,string>> mapEntityDetails = new map<String,map<String,string>>();
        
        if(trigger.isInsert){
            System.debug('@Developer -->trigger.isInsert:' );
            Id standardPricebook = fetchStandardPriceBook.queryStandardPriceBookId();
            for(Opportunity oOpportunity :trigger.New){
                oOpportunity.Pricebook2Id = standardPricebook;
                oOpportunity.SBQQ__QuotePricebookId__c = String.valueof(standardPricebook);
                /*if(oOpportunity.PartnerAccountId == null){
                    if(UtilityHelper.self.isInternalUser()){
                        oOpportunity.PartnerAccountId.addError('Please choose appropriate rep code to proceed further');                
                    }
                    else if(UtilityHelper.self.isPartnerUser()){
                        oOpportunity.PartnerAccountId = UtilityHelper.self.getPartnerAccountId();                       
                    }
                }*/
                
                if(UtilityHelper.self.isPartnerUser()){
                    if(oOpportunity.PartnerAccountId == null){
                        oOpportunity.PartnerAccountId = UtilityHelper.self.getPartnerAccountId();                       
                    }
                }
                
                if(oOpportunity.PartnerAccountId == null){                    
                    oOpportunity.PartnerAccountId.addError('Please choose appropriate rep code to proceed further');                
                }
                
                if(oOpportunity.Sales_Division__c == null ||
                   oOpportunity.Sourcing_Entity__c == null)
                {
                    if(oOpportunity.Brand__c != null){
                        setBrand.add(oOpportunity.Brand__c);
                    }
                    
                    if(UtilityHelper.self.isPartnerUser()){
                        if(oOpportunity.PartnerAccountId != null){
                            setPartnerAccount.add(oOpportunity.PartnerAccountId);
                        }
                    }
                }
            }
            
            //partner User
            if(UtilityHelper.self.isPartnerUser()){
                mapEntityDetails = OpportunityUtility.fetchBrandAndPartnerAccountWiseEntities(setBrand, setPartnerAccount);
            }
            //internal User
            else{
                mapEntityDetails = OpportunityUtility.fetchBrandAndUserWiseEntities(setBrand);
            }
            
            for(Opportunity oOpportunity :trigger.New){
                String key = oOpportunity.Brand__c + '-';
                
                if(UtilityHelper.self.isPartnerUser()){
                    key += oOpportunity.PartnerAccountId;
                }
                else{
                    key += userinfo.getUserId();
                }
                System.debug('@Developer --> key :' + key);
                    
                
                if(mapEntityDetails.containsKey(key)){
                    map<String,String> mapEntityFieldDetail = mapEntityDetails.get(key);
                    
                    if(oOpportunity.Sales_Division__c == null){    
                        String sellingEntityKey = oOpportunity.Brand__c + '_selling_entity__c';
                        System.debug('@Developer --> sellingEntityKey :' + sellingEntityKey);                
                        if(mapEntityFieldDetail.containsKey(sellingEntityKey)){
                            oOpportunity.Sales_Division__c = mapEntityFieldDetail.get(sellingEntityKey);    
                            System.debug('@Developer --> oOpportunity.Sales_Division__c :' + oOpportunity.Sales_Division__c);               
                        }
                    }
                     if(oOpportunity.Sourcing_Entity__c == null){
                         String sourceEntityKey = oOpportunity.Brand__c + '_source_entity__c';
                         System.debug('@Developer --> sourceEntityKey :' + sourceEntityKey);                
                         if(mapEntityFieldDetail.containsKey(sourceEntityKey)){
                             oOpportunity.Sourcing_Entity__c = mapEntityFieldDetail.get(sourceEntityKey);    
                             System.debug('@Developer --> oOpportunity.Sourcing_Entity__c :' + oOpportunity.Sourcing_Entity__c);          
                         }
                     }
                }
            }
        }
        
        if(trigger.isUpdate){
            System.debug('@Developer -->trigger.isUpdate:');
            
            for(Opportunity oOpportunity :trigger.New){
                
                /*if(oOpportunity.PartnerAccountId == null){
                    if(UtilityHelper.self.isInternalUser()){
                        oOpportunity.PartnerAccountId.addError('Please choose appropriate rep code to proceed further');                
                    }
                    else if(UtilityHelper.self.isPartnerUser()){
                        oOpportunity.PartnerAccountId = UtilityHelper.self.getPartnerAccountId(); 
                    }
                }*/
                
                if(UtilityHelper.self.isPartnerUser()){
                    if(oOpportunity.PartnerAccountId == null){
                        oOpportunity.PartnerAccountId = UtilityHelper.self.getPartnerAccountId();                       
                    }
                }
                
                if(oOpportunity.PartnerAccountId == null){                    
                    oOpportunity.PartnerAccountId.addError('Please choose appropriate rep code to proceed further');                
                }
                
                if(oOpportunity.Sales_Division__c == null ||
                   oOpportunity.Sourcing_Entity__c == null)
                {
                    if(oOpportunity.Brand__c != null){
                        setBrand.add(oOpportunity.Brand__c);
                    }
                    
                    if(UtilityHelper.self.isPartnerUser()){
                        if(oOpportunity.PartnerAccountId != null){
                            setPartnerAccount.add(oOpportunity.PartnerAccountId);
                        }
                    }
                }
            }
            
            //partner User
            if(UtilityHelper.self.isPartnerUser()){
                mapEntityDetails = OpportunityUtility.fetchBrandAndPartnerAccountWiseEntities(setBrand, setPartnerAccount);
            }
            //internal User
            else{
                mapEntityDetails = OpportunityUtility.fetchBrandAndUserWiseEntities(setBrand);
            }
            
            for(Opportunity oOpportunity :trigger.New){
                String key = oOpportunity.Brand__c + '-';
                
                if(UtilityHelper.self.isPartnerUser()){
                    key += oOpportunity.PartnerAccountId;
                }
                else{
                    key += userinfo.getUserId();
                }
                System.debug('@Developer --> key :' + key);
                
                
                if(mapEntityDetails.containsKey(key)){
                    map<String,String> mapEntityFieldDetail = mapEntityDetails.get(key);
                    
                    if(oOpportunity.Sales_Division__c == null){    
                        String sellingEntityKey = oOpportunity.Brand__c + '_selling_entity__c';
                        System.debug('@Developer --> sellingEntityKey :' + sellingEntityKey);                
                        if(mapEntityFieldDetail.containsKey(sellingEntityKey)){
                            oOpportunity.Sales_Division__c = mapEntityFieldDetail.get(sellingEntityKey);    
                            System.debug('@Developer --> oOpportunity.Sales_Division__c :' + oOpportunity.Sales_Division__c);               
                        }
                    }
                    if(oOpportunity.Sourcing_Entity__c == null){
                        String sourceEntityKey = oOpportunity.Brand__c + '_source_entity__c';
                        System.debug('@Developer --> sourceEntityKey :' + sourceEntityKey);                
                        if(mapEntityFieldDetail.containsKey(sourceEntityKey)){
                            oOpportunity.Sourcing_Entity__c = mapEntityFieldDetail.get(sourceEntityKey);    
                            System.debug('@Developer --> oOpportunity.Sourcing_Entity__c :' + oOpportunity.Sourcing_Entity__c);          
                        }
                    }
                }
            }
        }
    }
    else if(trigger.isAfter){
        System.debug('@Developer -->trigger.isAfter:' );
        
        list<OpportunityTeamMember> lstOTMToInsert = new list<OpportunityTeamMember>();
        list<OpportunityTeamMember> lstOTMToDelete = new list<OpportunityTeamMember>();
        map<String,OpportunityTeamMember> mapExistingOTM = new map<String,OpportunityTeamMember>();
        set<Id> setAccId = new set<Id>();
        set<Id> setOldOppId = new set<Id>();
        
        list<Opportunity_Pipeline_Amount__c> lstOpportunityPipelineAmount = new list<Opportunity_Pipeline_Amount__c>();
        map<string,Goals_Performance__c> mapUniqeIdWiseGoalsPerformace = new map<string,Goals_Performance__c>();
        map<Id,list<Opportunity_Pipeline_Amount__c>>mapOptyIdWiseOptyPipelineAmount = new map<Id,list<Opportunity_Pipeline_Amount__c>>();
        set<Id> setOppId = new set<Id>();
        map<Id,Opportunity> mapOpp = new map<Id,Opportunity>();
        if(trigger.isInsert || trigger.isUpdate){
            for(Opportunity opp : [Select Id,name,Amount,CurrencyIsoCode ,IsClosed,CloseDate,Partner_Rep_Code__c,Brand__c,PartnerAccountId,AccountId
                                   ,Account.OEM_Sales_Channel__c,Account.OEM_Sales_Channel__r.Rep_Code__c
                                   From Opportunity
                                   Where Id In :trigger.new])
            {
                mapOpp.put(opp.Id,opp);
            }
            System.debug('@Developer --> mapOpp :' + mapOpp);
            
            if(trigger.isInsert){
                System.debug('@Developer -->trigger.isInsert:' );
                
                for(Opportunity op :trigger.new){
                    Opportunity opp = op;
                    
                    if(mapOpp.containsKey(op.Id)){
                        opp = mapOpp.get(op.Id);
                    }
                    
                    setOppId.add(opp.Id);
                    
                    string sUniqueId = '';
                    if(opp.PartnerAccountId != null){
                        setAccId.add(opp.PartnerAccountId);
                        
                        sUniqueId = opp.Partner_Rep_Code__c + '-' + opp.closeDate.year() + '-' + opp.closeDate.month() + '-' + opp.Brand__c;
                        System.debug('@Developer --> sUniqueId :' + sUniqueId);
                        mapUniqeIdWiseGoalsPerformace.put(sUniqueId, null);
                    }
                    
                    if(opp.AccountId != null && opp.Account.OEM_Sales_Channel__c != null){
                        sUniqueId = opp.Account.OEM_Sales_Channel__r.Rep_Code__c + '-' + opp.closeDate.year() + '-' + opp.closeDate.month() + '-' + opp.Brand__c;
                        System.debug('@Developer --> sUniqueId :' + sUniqueId);
                        mapUniqeIdWiseGoalsPerformace.put(sUniqueId, null);
                    }
                    
                    
                }
                System.debug('@Developer --> setOppId :' + setOppId);
                System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
                System.debug('@Developer --> setAccId :' + setAccId);
                
                if(setAccId.size() > 0){
                    Map<Id,list<AccountTeamMember>> mapAccIdWiseAccountTeamMembers = UtilityHelper.self.getAccountTeamMembers(setAccId);  
                    set<Id> setUserId = new set<Id>();
                    for(Opportunity opp :trigger.New){
                        setUserId.add(opp.CreatedById);
                    }
                    System.debug('@Developer --> setUserId :' + setUserId);
                    map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
                    
                    for(Opportunity opp :trigger.New){
                        System.debug('@Developer --> opp.PartnerAccountId :' + opp.PartnerAccountId);

                        if(mapUserWiseIsPartner.get(opp.CreatedById)){
                            if(opp.PartnerAccountId != null){
                                if(mapAccIdWiseAccountTeamMembers.containsKey(opp.PartnerAccountId)){
                                    for(AccountTeamMember atm : mapAccIdWiseAccountTeamMembers.get(opp.PartnerAccountId)){
                                        OpportunityTeamMember oOpportunityTeamMember = new OpportunityTeamMember();
                                        oOpportunityTeamMember.OpportunityId = opp.Id;
                                        oOpportunityTeamMember.OpportunityAccessLevel = atm.AccountAccessLevel;
                                        oOpportunityTeamMember.TeamMemberRole = atm.TeamMemberRole;
                                        oOpportunityTeamMember.UserId = atm.UserId;
                                        lstOTMToInsert.add(oOpportunityTeamMember);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(lstOTMToInsert.size() > 0){
                        insert lstOTMToInsert;
                    }
                } 
                
            }
            else if(trigger.isUpdate){
                System.debug('@Developer -->trigger.isUpdate:' );
                
                set<Id> setUserId = new set<Id>();
                for(Opportunity opp :trigger.New){
                    setUserId.add(opp.CreatedById);
                }
                System.debug('@Developer --> setUserId :' + setUserId);
                map<Id,Boolean> mapUserWiseIsPartner = UtilityHelper.self.isPartnerUser(setUserId);
                
                for(Opportunity op :trigger.new){
                    Opportunity oOldOpp = trigger.oldMap.get(op.Id);
                    
                    Opportunity opp = op;
                    
                    if(mapOpp.containsKey(op.Id)){
                        opp = mapOpp.get(op.Id);
                    }
                    System.debug('@Developer --> opp.PartnerAccountId :' + opp.PartnerAccountId);
                    
                    
                    
                    if(opp.PartnerAccountId != oOldOpp.PartnerAccountId){
                        if(oOldOpp.PartnerAccountId != null){
                            setAccId.add(oOldOpp.PartnerAccountId);
                            setOldOppId.add(opp.Id);
                        }
                        
                        if(opp.PartnerAccountId != null){
                            setAccId.add(opp.PartnerAccountId);
                        }   
                    }
                    
                    if(opp.Amount != trigger.oldMap.get(opp.Id).Amount ||
                       opp.isClosed != trigger.oldMap.get(opp.Id).isClosed){
                           setOppId.add(opp.Id);
                       }
                    
                    if(opp.CloseDate != trigger.oldMap.get(opp.Id).CloseDate ||
                       opp.Brand__c != trigger.oldMap.get(opp.Id).Brand__c ||
                       opp.PartnerAccountId != trigger.oldMap.get(opp.Id).PartnerAccountId ||
                       opp.AccountId != trigger.oldMap.get(opp.Id).AccountId 
                      ){
                          
                          setOppId.add(opp.Id);    
                          string sUniqueId = '';
                          
                          if(opp.PartnerAccountId != null){
                              sUniqueId = opp.Partner_Rep_Code__c + '-' + opp.closeDate.year() + '-' + opp.closeDate.month() + '-' + opp.Brand__c;
                              System.debug('@Developer --> sUniqueId :' + sUniqueId);
                              mapUniqeIdWiseGoalsPerformace.put(sUniqueId, null);
                          }
                          
                          if(opp.AccountId != null && opp.Account.OEM_Sales_Channel__c != null){
                              sUniqueId = opp.Account.OEM_Sales_Channel__r.Rep_Code__c + '-' + opp.closeDate.year() + '-' + opp.closeDate.month() + '-' + opp.Brand__c;
                              System.debug('@Developer --> sUniqueId :' + sUniqueId);
                              mapUniqeIdWiseGoalsPerformace.put(sUniqueId, null);
                          }
                      }
                }
                System.debug('@Developer --> setOppId :' + setOppId);
                System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
                System.debug('@Developer --> setAccId :' + setAccId);
                System.debug('@Developer --> setOldOppId :' + setOldOppId);
                
                for(Opportunity_Pipeline_Amount__c opa : [Select Id,Goals_Performance__c,Opportunity__c,uniqueKey__c,Type__c  
                                                          From Opportunity_Pipeline_Amount__c
                                                          Where Opportunity__c In :setOppId])
                {
                    list<Opportunity_Pipeline_Amount__c> lstOPA;
                    if(mapOptyIdWiseOptyPipelineAmount.containsKey(opa.Opportunity__c)){
                        lstOPA = mapOptyIdWiseOptyPipelineAmount.get(opa.Opportunity__c);
                    }
                    else{
                        lstOPA = new list<Opportunity_Pipeline_Amount__c>();
                    }
                    lstOPA.add(opa);
                    mapOptyIdWiseOptyPipelineAmount.put(opa.Opportunity__c,lstOPA);
                }
                System.debug('@Developer --> mapOptyIdWiseOptyPipelineAmount :' + mapOptyIdWiseOptyPipelineAmount);
                
                
                if(setOldOppId.size() > 0){                
                    for(OpportunityTeamMember otm : [Select Id,OpportunityId,OpportunityAccessLevel,TeamMemberRole,UserId  
                                                     From OpportunityTeamMember 
                                                     Where OpportunityId In :setOldOppId
                                                    ])
                    {
                        String sKey = otm.OpportunityId +'-' + otm.OpportunityAccessLevel + '-' + otm.TeamMemberRole + '-' + otm.UserId;
                        System.debug('@Developer --> sKey :' + sKey);
                        mapExistingOTM.put(sKey,otm); 
                    }
                }
                System.debug('@Developer --> mapExistingOTM :' + mapExistingOTM);
                
                if(setAccId.size() > 0){
                    Map<Id,list<AccountTeamMember>> mapAccIdWiseAccountTeamMembers = UtilityHelper.self.getAccountTeamMembers(setAccId);  
                    
                    for(Opportunity opp :trigger.New){
                        System.debug('@Developer --> opp.PartnerAccountId :' + opp.PartnerAccountId);
                        
                        Opportunity oOldOpp = trigger.oldMap.get(opp.Id);
                        if(mapUserWiseIsPartner.get(opp.CreatedById)){
                            
                            if(oOldOpp.PartnerAccountId != null){
                                if(mapAccIdWiseAccountTeamMembers.containsKey(oOldOpp.PartnerAccountId)){
                                    for(AccountTeamMember atm : mapAccIdWiseAccountTeamMembers.get(oOldOpp.PartnerAccountId)){
                                        String sKey = opp.Id + '-' + atm.AccountAccessLevel + '-' + atm.TeamMemberRole + '-' + atm.UserId;
                                        System.debug('@Developer --> sKey :' + sKey);
                                        if(mapExistingOTM.containsKey(sKey)){
                                            lstOTMToDelete.add(mapExistingOTM.get(sKey));
                                        }
                                    }    
                                }
                            }
                            
                            if(opp.PartnerAccountId != null){
                                if(mapAccIdWiseAccountTeamMembers.containsKey(opp.PartnerAccountId)){
                                    for(AccountTeamMember atm : mapAccIdWiseAccountTeamMembers.get(opp.PartnerAccountId)){
                                        OpportunityTeamMember oOpportunityTeamMember = new OpportunityTeamMember();
                                        oOpportunityTeamMember.OpportunityId = opp.Id;
                                        oOpportunityTeamMember.OpportunityAccessLevel = atm.AccountAccessLevel;
                                        oOpportunityTeamMember.TeamMemberRole = atm.TeamMemberRole;
                                        oOpportunityTeamMember.UserId = atm.UserId;
                                        lstOTMToInsert.add(oOpportunityTeamMember);
                                    }    
                                }
                            }
                        }
                    }
                    
                    System.debug('@Developer --> lstOTMToDelete :' + lstOTMToDelete);
                    if(lstOTMToDelete.size() > 0){
                        delete lstOTMToDelete;
                    }
                    
                    System.debug('@Developer --> lstOTMToInsert :' + lstOTMToInsert);
                    if(lstOTMToInsert.size() > 0){
                        insert lstOTMToInsert;
                    }
                }           
            }
            
            for(Goals_Performance__c gp : [Select Id,Unique_Id_gen__c 
                                           From Goals_Performance__c 
                                           Where Unique_Id_gen__c IN : mapUniqeIdWiseGoalsPerformace.keySet()])
            {
                if(mapUniqeIdWiseGoalsPerformace.containsKey(gp.Unique_Id_gen__c)){
                    mapUniqeIdWiseGoalsPerformace.put(gp.Unique_Id_gen__c, gp); 
                }
            }
            System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
            
            
            for(Opportunity op : trigger.new){
                Opportunity opp = op;
                
                if(mapOpp.containsKey(op.Id)){
                    opp = mapOpp.get(op.Id);
                }
                
                string sUniqueId_PartnerAccount = '';
                string sUniqueId_OEMAccount = '';
                
                if(opp.PartnerAccountId != null){
                    sUniqueId_PartnerAccount = opp.Partner_Rep_Code__c + '-' + opp.closeDate.year() + '-' + opp.closeDate.month() + '-' + opp.Brand__c;
                    System.debug('@Developer --> sUniqueId_PartnerAccount :' + sUniqueId_PartnerAccount);
                }
                
                if(opp.AccountId != null && opp.Account.OEM_Sales_Channel__c != null){
                    sUniqueId_OEMAccount = opp.Account.OEM_Sales_Channel__r.Rep_Code__c + '-' + opp.closeDate.year() + '-' + opp.closeDate.month() + '-' + opp.Brand__c;
                    System.debug('@Developer --> sUniqueId_OEMAccount :' + sUniqueId_OEMAccount);
                }
                
                if(setOppId.contains(opp.Id)){
                    list<Opportunity_Pipeline_Amount__c> lstOPA = new list<Opportunity_Pipeline_Amount__c>();
                    Opportunity_Pipeline_Amount__c oOPA;
                    
                    if(mapOptyIdWiseOptyPipelineAmount.containsKey(opp.Id)){
                        lstOPA = mapOptyIdWiseOptyPipelineAmount.get(opp.Id);
                        
                        if(lstOPA.size() == 0){
                            if(opp.PartnerAccountId != null){
                                oOPA = new Opportunity_Pipeline_Amount__c();
                                oOPA.Name = opp.name + '- Pipeline Amount';    
                                oOPA.Opportunity__c = opp.Id;
                                oOPA.Type__c = 'Partner Account';
                                lstOPA.add(oOPA);
                            }
                            
                            if(opp.AccountId != null && opp.Account.OEM_Sales_Channel__c != null){
                                oOPA = new Opportunity_Pipeline_Amount__c();
                                oOPA.Name = opp.name + '- Pipeline Amount';    
                                oOPA.Opportunity__c = opp.Id;
                                oOPA.Type__c = 'OEM Account';
                                lstOPA.add(oOPA);
                            }
                        }
                        else if(lstOPA.size() == 1){
                            if(opp.PartnerAccountId != null  && lstOPA[0].Type__c == 'OEM Account'){
                                oOPA = new Opportunity_Pipeline_Amount__c();
                                oOPA.Name = opp.name + '- Pipeline Amount';    
                                oOPA.Opportunity__c = opp.Id;
                                oOPA.Type__c = 'Partner Account';
                                lstOPA.add(oOPA);
                            }
                            
                            if(opp.AccountId != null && opp.Account.OEM_Sales_Channel__c != null  && lstOPA[0].Type__c == 'Partner Account'){
                                oOPA = new Opportunity_Pipeline_Amount__c();
                                oOPA.Name = opp.name + '- Pipeline Amount';    
                                oOPA.Opportunity__c = opp.Id;
                                oOPA.Type__c = 'OEM Account';
                                lstOPA.add(oOPA);
                            }
                        }
                    }
                    else{
                        lstOPA = new list<Opportunity_Pipeline_Amount__c>();
                        
                        if(opp.PartnerAccountId != null){
                            oOPA = new Opportunity_Pipeline_Amount__c();
                            oOPA.Name = opp.name + '- Pipeline Amount';    
                            oOPA.Opportunity__c = opp.Id;
                            oOPA.Type__c = 'Partner Account';
                            lstOPA.add(oOPA);
                        }
                        
                        if(opp.AccountId != null && opp.Account.OEM_Sales_Channel__c != null){
                            oOPA = new Opportunity_Pipeline_Amount__c();
                            oOPA.Name = opp.name + '- Pipeline Amount';    
                            oOPA.Opportunity__c = opp.Id;
                            oOPA.Type__c = 'OEM Account';
                            lstOPA.add(oOPA);
                        }
                    }
                    System.debug('@Developer --> lstOPA :' + lstOPA);
                    
                    
                    for(Opportunity_Pipeline_Amount__c oOpportunityPipelineAmount : lstOPA){
                        oOpportunityPipelineAmount.CurrencyISOCode = opp.CurrencyISOCode;
                        oOpportunityPipelineAmount.Amount__c = opp.Amount;
                        oOpportunityPipelineAmount.Opportunity_Closed__c = opp.isClosed;
                        
                        if(oOpportunityPipelineAmount.Type__c == 'Partner Account'){
                            if(mapUniqeIdWiseGoalsPerformace.containsKey(sUniqueId_PartnerAccount)){
                                Goals_Performance__c oGP = mapUniqeIdWiseGoalsPerformace.get(sUniqueId_PartnerAccount);
                                System.debug('@Developer --> oGP :' + oGP);                         
                                if(oGP != null){
                                    oOpportunityPipelineAmount.Goals_Performance__c = oGP.Id;   
                                }
                                else{
                                    System.debug('@Developer --> Partner Account related Goals & Performance does not exists. :');
                                }
                            }
                            if(oOpportunityPipelineAmount.Goals_Performance__c == null){
                                
                                //opp.addError('Related Goals & Performance not found.'); 
                            }
                            else{
                                lstOpportunityPipelineAmount.add(oOpportunityPipelineAmount);
                            }
                        }
                        
                        if(oOpportunityPipelineAmount.Type__c == 'OEM Account'){
                            if(mapUniqeIdWiseGoalsPerformace.containsKey(sUniqueId_OEMAccount)){
                                
                                Goals_Performance__c oGP = mapUniqeIdWiseGoalsPerformace.get(sUniqueId_OEMAccount);
                                System.debug('@Developer --> oGP :' + oGP);
                                
                                if(oGP != null){
                                    oOpportunityPipelineAmount.Goals_Performance__c = oGP.Id;   
                                }
                                else{
                                    System.debug('@Developer --> OEM Account related Goals & Performance does not exists. :');
                                }
                            }
                            
                            if(oOpportunityPipelineAmount.Goals_Performance__c == null){
                                //opp.addError('Related Goals & Performance not found.'); 
                            }
                            else{
                                lstOpportunityPipelineAmount.add(oOpportunityPipelineAmount);
                            }
                        }
                    }
                }
            }
            System.debug('@Developer --> lstOpportunityPipelineAmount.size() :' + lstOpportunityPipelineAmount.size());
            if(lstOpportunityPipelineAmount.size() > 0){
                upsert lstOpportunityPipelineAmount;
            }
        }
    }
}