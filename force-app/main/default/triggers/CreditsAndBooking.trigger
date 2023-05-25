trigger CreditsAndBooking on Credits_and_Booking__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(trigger.isBefore){
        System.debug('@Developer -->trigger.isBefore:' );
        
        List<Credits_and_Booking__c> newRecords = Trigger.new;
        set<Id> setQuoteId = new set<Id>();
        set<String> setQuoteExtId = new set<String>();
        map<String,SBQQ__Quote__c> mapQuote = new map<String,SBQQ__Quote__c>();
        map<string,Goals_Performance__c> mapUniqeIdWiseGoalsPerformace = new map<string,Goals_Performance__c>();
        
        if(trigger.isInsert) {
            System.debug('@Developer -->trigger.isInsert:' );
            
            // Gather all new Quote Ids and External Ids from new records
            for(Credits_and_Booking__c cb :newRecords) {
                if( cb.Quote__c == null && cb.Quote_External_Id__c == null){
                    cb.addError('Credits & Booking doesnot have Quote reference and External Id');
                }
                else{
                    if(cb.Quote__c != null){
                        setQuoteId.add(cb.Quote__c);
                    } 
                    else if(cb.Quote_External_Id__c != null) {
                        setQuoteExtId.add(cb.Quote_External_Id__c);
                    }
                }
            }
            System.debug('@Developer --> setQuoteId :' + setQuoteId);
            System.debug('@Developer --> setQuoteExtId :' + setQuoteExtId);
            
            // Gather all quotes into a map; Key[Id OR SBQQ__Key__c]:Value[SBQQ__Quote__c record]
            for(SBQQ__Quote__c qt : [SELECT Id,SBQQ__Key__c,SBQQ__Opportunity2__c,SBQQ__Opportunity2__r.Partner_Rep_Code__c,SBQQ__Opportunity2__r.Brand__c
                                     FROM SBQQ__Quote__c
                                     //WHERE Id In :setQuoteId OR (SBQQ__Key__c IN :setQuoteExtId AND Historical_Only__c!=TRUE)]) {
                                     WHERE (Id In :setQuoteId OR SBQQ__Key__c IN :setQuoteExtId)]) {
                                         mapQuote.put(qt.Id,qt);
                                         mapQuote.put(qt.SBQQ__Key__c,qt);
                                     }
            System.debug('@Developer --> mapQuote :' + mapQuote);
            
            // Set all new record's Quote Ids, if they were sent over with just the External Id, and populate the keys for the map of G&P records
            for(Credits_and_Booking__c cb : newRecords) {
                SBQQ__Quote__c qt;
                String key = '';
                //when Quote reference given
                if(!String.isBlank(cb.Quote__c)){
                    key = cb.Quote__c;
                    System.debug('@Developer --> key :' + key);
                    if(mapQuote.containsKey(key)){
                        qt = mapQuote.get(key);
                    }
                }
                //when Quote external id given
                else if(!String.isBlank(cb.Quote_External_Id__c)){
                    key = cb.Quote_External_Id__c;
                    System.debug('@Developer --> key :' + key);
                    if(mapQuote.containsKey(key)){
                        qt = mapQuote.get(key);
                        cb.Quote__c = qt.Id;
                        cb.External_id__c = cb.Quote_External_Id__c + '-' + System.now().getTime();
                    }
                    else{
                        cb.addError('Invalid Quote External Id');
                    }
                }
                
                if(qt != null){
                    System.debug('@Developer --> qt.SBQQ__Opportunity2__c :' + qt.SBQQ__Opportunity2__c);
                    System.debug('@Developer --> qt.SBQQ__Opportunity2__r.Brand__c :' + qt.SBQQ__Opportunity2__r.Brand__c);
                    System.debug('@Developer --> qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c :' + qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c);
                    
                    string sUniqueId = qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c + '-' + system.today().year() + '-' + system.today().month() + '-' + qt.SBQQ__Opportunity2__r.Brand__c;
                    mapUniqeIdWiseGoalsPerformace.put(sUniqueId, null);
                }
            }
            System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
            
            // Populate the values for the map of G&P records
            for(Goals_Performance__c gp : [Select Id,Unique_Id_gen__c 
                                           From Goals_Performance__c 
                                           Where Unique_Id_gen__c IN : mapUniqeIdWiseGoalsPerformace.keySet()]) {
                                               if(mapUniqeIdWiseGoalsPerformace.containsKey(gp.Unique_Id_gen__c)) {
                                                   mapUniqeIdWiseGoalsPerformace.put(gp.Unique_Id_gen__c, gp); 
                                               }
                                           }
            System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
            
            // Use the C&B records' Quote Ids and to find the matching G&P records
            for(Credits_and_Booking__c cb :newRecords) {
                if(cb.Quote__c != null){
                    if(mapQuote.containsKey(cb.Quote__c)){
                        SBQQ__Quote__c qt = mapQuote.get(cb.Quote__c);
                        string sUniqueId = qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c + '-' + system.today().year() + '-' + system.today().month() + '-' + qt.SBQQ__Opportunity2__r.Brand__c;
                        
                        if(mapUniqeIdWiseGoalsPerformace.containsKey(sUniqueId)){
                            Goals_Performance__c oGP = mapUniqeIdWiseGoalsPerformace.get(sUniqueId);
                            System.debug('@Developer --> oGP :' + oGP);
                            
                            if(oGP != null){
                                cb.Goals_Performance__c = oGP.Id;   
                            }
                        }
                    }
                }
            }            
        }
        else if(trigger.isUpdate){
            
            //find all quotes where created_Date__c is updated
            for(Credits_and_Booking__c cb :newRecords) {
                if(cb.Created_Date__c != trigger.oldMap.get(cb.Id).Created_Date__c){
                    setQuoteId.add(cb.Quote__c);                
                }
            }
            
            //// Gather all quotes into a map
            for(SBQQ__Quote__c qt : [SELECT Id,SBQQ__Key__c,SBQQ__Opportunity2__c,SBQQ__Opportunity2__r.Partner_Rep_Code__c,SBQQ__Opportunity2__r.Brand__c
                                     FROM SBQQ__Quote__c
                                     WHERE Id In :setQuoteId])
            {
                mapQuote.put(qt.Id,qt);
            }
            System.debug('@Developer --> mapQuote :' + mapQuote);
            
            for(Credits_and_Booking__c cb : newRecords) {
                SBQQ__Quote__c qt;
                String key = cb.Quote__c;
                
                if(mapQuote.containsKey(key)){
                    qt = mapQuote.get(key);
                    if(qt != null){
                        System.debug('@Developer --> qt.SBQQ__Opportunity2__c :' + qt.SBQQ__Opportunity2__c);
                        System.debug('@Developer --> qt.SBQQ__Opportunity2__r.Brand__c :' + qt.SBQQ__Opportunity2__r.Brand__c);
                        System.debug('@Developer --> qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c :' + qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c);
                        
                        string sUniqueId = qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c + '-' + cb.Created_Date__c.year() + '-' + cb.Created_Date__c.month() + '-' + qt.SBQQ__Opportunity2__r.Brand__c;
                        mapUniqeIdWiseGoalsPerformace.put(sUniqueId, null);
                    }   
                }                
            }
            System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
            
            //populate the keys for the map of G&P records
            for(Goals_Performance__c gp : [Select Id,Unique_Id_gen__c 
                                           From Goals_Performance__c 
                                           Where Unique_Id_gen__c IN : mapUniqeIdWiseGoalsPerformace.keySet()]) {
                                               if(mapUniqeIdWiseGoalsPerformace.containsKey(gp.Unique_Id_gen__c)) {
                                                   mapUniqeIdWiseGoalsPerformace.put(gp.Unique_Id_gen__c, gp); 
                                               }
                                           }
            System.debug('@Developer --> mapUniqeIdWiseGoalsPerformace :' + mapUniqeIdWiseGoalsPerformace);
            
            // Use the C&B records' Quote Ids and to find the matching G&P records
            for(Credits_and_Booking__c cb :newRecords){
                SBQQ__Quote__c qt;
                String key = cb.Quote__c;
                
                if(mapQuote.containsKey(key)){
                    qt = mapQuote.get(key);
                    
                    if(qt != null){
                        string sUniqueId = qt.SBQQ__Opportunity2__r.Partner_Rep_Code__c + '-' + cb.Created_Date__c.year() + '-' + cb.Created_Date__c.month() + '-' + qt.SBQQ__Opportunity2__r.Brand__c;
                        
                        if(mapUniqeIdWiseGoalsPerformace.containsKey(sUniqueId)){
                            Goals_Performance__c oGP = mapUniqeIdWiseGoalsPerformace.get(sUniqueId);
                            System.debug('@Developer --> oGP :' + oGP);
                            
                            if(oGP != null){
                                cb.Goals_Performance__c = oGP.Id;   
                            }
                        }
                    }
                }
            }
            
        }
        
    }    
}