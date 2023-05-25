public class QuoteTriggerHelper {
    public static List<Id> quoteIdList = new List<Id>();    // This is a class-wide map that holds all Quote Ids for use with other functions [quoteLookupFieldMap]
    /*
    * This is a list used to set the quote's approvers
    */
    public static List<User> UserData =[
        SELECT Id,UserRole.Name,Name,
        Approver_Level__c,Approver_For_Brand__c,Approver_for_House_Code__c,
        Approver_for_Region__c,Approver_for_Sourcing_Entity__c,Approver_for_Selling_Entity__c 
        FROM USER
        WHERE isActive=true AND Approver_Level__c!=null
    ];
    /*
    * This is the hard-coded user record for Drew; we may need to add an approver level of 'Admin'
    */
    public static User staticUser {
        get {
            if(staticUser == null) {
                try {
                    staticUser = [SELECT Id FROM User WHERE Default_Commercial_Approver__c = TRUE LIMIT 1]; 
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
            return staticUser;
        }
        set;
    }
    /*
    * This is a map of approvers, where the key is their level and any pertinent selection criteria
    */
    /*public static Map<String,Id> approverMap {
        get {
            if(approverMap == null) {
                approverMap = new Map<String,Id>();
                // Key : 
                //  qt.Inside_Sales_Approver__c
                //      OEM -> APPROVERLEVEL_INSIDESALESAPPROVER
                //      DEF -> APPROVERLEVEL_BRAND_SELLINGENTITY
                //  qt.Sales_Director__c
                //      OEM -> APPROVERLEVEL_PARTNERREPCODE
                //      DEF -> APPROVERLEVEL_BRAND_REGION
                //  Sales Executive
                //      OEM -> APPROVERLEVEL_BRAND
                //      DEF -> APPROVERLEVEL_BRAND
        
                for(User usr : UserData) {
                    // Set default user to Drew
                    if(usr.Name == 'Drew Hartzler') {   // HARDCODE
                        continue;
                    }
                    // MultiSelect values Approver_for_Brand__c
                    List<String> brandList = usr.Approver_for_Brand__c != null ? string.valueOf(usr.Approver_for_Brand__c).split(';') : new List<String>();
                    switch on usr.Approver_Level__c {
                        when 'Inside Sales' {   // HARDCODE
                            List<String> sellingEntityList = usr.Approver_for_Selling_Entity__c != null ? string.valueOf(usr.Approver_for_Selling_Entity__c).split(';') : new List<String>();
                            for(String brand : brandList) {
                                for(String entity : sellingEntityList) {
                                    String key = usr.Approver_Level__c + '_' + brand + '_' + entity;
                                    if(!approverMap.containsKey(key)) {
                                        approverMap.put(key,usr.Id);
                                    }
                                }
                            }
                        }
                        when 'Sales Director' { // HARDCODE
                            List<String> regionList = usr.Approver_for_Region__c != null ? string.valueOf(usr.Approver_for_Region__c).split(';') : new List<String>();
                            List<String> repCodeList = usr.Approver_for_House_Code__c != null ? string.valueOf(usr.Approver_for_House_Code__c).split(';') : new List<String>();
                            for(String brand : brandList) {
                                for(String region : regionList) {
                                    String key = usr.Approver_Level__c + '_' + brand + '_' + region;
                                    if(!approverMap.containsKey(key)) {
                                        approverMap.put(key,usr.Id);
                                    }
                                }
                                for(String repCode : repCodeList) {
                                    String key = usr.Approver_Level__c + '_' + brand + '_' + repCode;
                                    if(!approverMap.containsKey(key)) {
                                        approverMap.put(key,usr.Id);
                                    }
                                }
                            }
                        }
                        when 'Sales Executive' {    // HARDCODE
                            for(String brand : brandList) {
                                String key = usr.Approver_Level__c + '_' + brand;
                                if(!approverMap.containsKey(key)) {
                                    approverMap.put(key,usr.Id);
                                }
                            }
                        }
                        when 'Regional Manager' {   // HARDCODE
                            List<String> regionList = usr.Approver_for_Region__c != null ? string.valueOf(usr.Approver_for_Region__c).split(';') : new List<String>();
                            for(String region : regionList) {
                                String key = usr.Approver_Level__c + '_' + region;
                                if(!approverMap.containsKey(key)) {
                                    approverMap.put(key,usr.Id);
                                }
                            }
                        }
                    }
                }
            }
            return approverMap;
        }
        set;
    }*/
    
    public static void findApprovers(List<SBQQ__Quote__c> records, Map<Id,SBQQ__Quote__c> oldMap)
    {
        Set<Id> qIds = new Set<Id>();
        for (SBQQ__Quote__c record : records) qIds.add(record.Sold_By_Rep__c);

        Map<String, Commercial_Approvers__c> approvers = new Map<String, Commercial_Approvers__c>();
        for (Commercial_Approvers__c approver : [
            select Brand__c, Id, Inside_Sales_Approver__c, Partner_Rep_Code_Account__c, External_ID__c,
            Regional_Manager__c, Sales_Director_Approver__c, Sales_Executive_Approver__c 
            from Commercial_Approvers__c
            WHERE Partner_Rep_Code_Account__c IN :qIds
        ]) approvers.put(approver.External_ID__c, approver);
        //System.debug('@developer ==> approvers' + approvers);

        for (SBQQ__Quote__c record : records){
            if (approvers.containsKey(record.Approver_External_ID__c)){
                if(oldMap.get(record.Id).Regional_Manager__c == staticUser.Id || oldMap.get(record.Id).Regional_Manager__c == record.Regional_Manager__c)
                	record.Regional_Manager__c = approvers.get(record.Approver_External_ID__c).Regional_Manager__c;
        		if(oldMap.get(record.Id).Inside_Sales_Approver__c == staticUser.Id || oldMap.get(record.Id).Inside_Sales_Approver__c == record.Inside_Sales_Approver__c)
                	record.Inside_Sales_Approver__c = approvers.get(record.Approver_External_ID__c).Inside_Sales_Approver__c;
        		if(oldMap.get(record.Id).Sales_Director__c == staticUser.Id || oldMap.get(record.Id).Sales_Director__c == record.Sales_Director__c)
               		record.Sales_Director__c = approvers.get(record.Approver_External_ID__c).Sales_Director_Approver__c;
                if(oldMap.get(record.Id).Sales_Executive__c == staticUser.Id || oldMap.get(record.Id).Sales_Executive__c == record.Sales_Executive__c)
        			record.Sales_Executive__c = approvers.get(record.Approver_External_ID__c).Sales_Executive_Approver__c;
            } else {
                if(String.isBlank(record.Sales_Executive__c)) {
                    record.Sales_Executive__c = staticUser.Id;
                }
                if(String.isBlank(record.Inside_Sales_Approver__c)) {
                    record.Inside_Sales_Approver__c = staticUser.Id;
                }
                if(String.isBlank(record.Sales_Director__c)) {
                    record.Sales_Director__c = staticUser.Id;
                }
                if(String.isBlank(record.Regional_Manager__c)) {
                    record.Regional_Manager__c = staticUser.Id;
                }
            }
        }
    }
    
    /*
    * This function uses the keys in MappingUtil.quoteFieldMap to create a query, and then unwrap it into a Map
    *   Map
            KEY::Quote ID
            VALUE::Map
                        KEY::Field API Name (if it's a lookup __r notation)
                        VALUE::Field Value
    */
    public static Map<Id, Map<String,Object>> quoteLookupFieldMap {
        get {
            if(quoteLookupFieldMap == null) {
                try {
                    quoteLookupFieldMap = new Map<Id,Map<String,Object>>();
                    String quoteSourceFields = FunctionUtil.join(MappingUtil.quoteFieldMap.keySet(),',');
                    List<SBQQ__Quote__c> quoteVals = Database.query('SELECT Id, ' + quoteSourceFields + ' FROM SBQQ__Quote__c WHERE Id in :quoteIdList');
                    for(SBQQ__Quote__c thisQuote : quoteVals) {
                        quoteLookupFieldMap.put(
                            thisQuote.Id,
                            FunctionUtil.unwrapSObject(thisQuote.getPopulatedFieldsAsMap(),null)
                        );
                    }
                    return quoteLookupFieldMap;
                } catch (Exception e) {
                    System.debug(e.getLineNumber());
                    System.debug(e.getMessage());
                    System.debug(e.getCause());
                }
            }
            return quoteLookupFieldMap;
        }
        set;
    }
    public static void gatherQuoteIds(List<SBQQ__Quote__c> newQuoteValsList) {
        for(SBQQ__Quote__c newQuoteVals : newQuoteValsList) {
            quoteIdList.add(newQuoteVals.Id);
        }
    }
    public static Map<String,Object> getNewQuoteLookupValues(SBQQ__Quote__c newQuote) {
        Map<String,Object> newQuoteLookupValues = new Map<String,Object>();
        try {
            List<String> opptyFieldNameList = new List<String>();
            for(String opptyFieldName : MappingUtil.quoteOpptyLookupFieldMap.keySet()) {
                opptyFieldNameList.add(opptyFieldName.substringAfter('.'));
            }
            String quoteSourceFields = FunctionUtil.join(MappingUtil.quoteOpptyLookupFieldMap.keySet(),',');
            Opportunity thisOppty = Database.query('SELECT Id, ' + FunctionUtil.join(opptyFieldNameList,',') + ' FROM Opportunity WHERE Id = \'' + newQuote.SBQQ__Opportunity2__c + '\' LIMIT 1');
            newQuoteLookupValues.putAll(
                FunctionUtil.unwrapSObject(
                    thisOppty.getPopulatedFieldsAsMap(),
                    'SBQQ__Opportunity2__r'
                )
            );
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return newQuoteLookupValues;
    }
    public static void MapQuoteValues(List<SBQQ__Quote__c> newQuoteValsList) {
        try {
            // IF the list of quote Ids is empty, populate them
            if(quoteIdList.isEmpty()){
                gatherQuoteIds(newQuoteValsList);
            }
            // IF the quote ids are successfully retrieved, then continue this method
            // Loop over all lookup fields
            for(SBQQ__Quote__c newQuoteVals : newQuoteValsList) {
                System.debug(newQuoteVals);
                Map<String,Object> quoteLookupVals = new Map<String,Object>();
                Set<String> mappingFieldNames = new Set<String>();  /// TODO: make this a class variable(?)
                if(newQuoteVals.Id == null) {
                    System.debug('New Quote');
                    quoteLookupVals = getNewQuoteLookupValues(newQuoteVals);
                    mappingFieldNames = MappingUtil.quoteOpptyLookupFieldMap.keySet();
                } else {
                    System.debug('Existing Quote');
                    quoteLookupVals = quoteLookupFieldMap.get(newQuoteVals.Id);
                    mappingFieldNames = MappingUtil.quoteFieldMap.keySet();
                }
                if(quoteLookupVals.isEmpty()) {
                    System.debug('No values retreived');
                    continue;
                }
                System.debug(quoteLookupVals);
                // Set all fields, as specified by MappingUtil.quoteFieldMap
                for(String quoteLookupField : mappingFieldNames) {
                    // For the new quote, use the field name to set the field lookup value
                    String fieldName = MappingUtil.quoteFieldMap.get(quoteLookupField);
                    Object oldVal = newQuoteVals.get(fieldName);
                    Object newVal = quoteLookupVals.get(quoteLookupField);
                    System.debug('Setting ' + fieldName + ' from ' + String.valueOf(oldVal) + ' to ' + quoteLookupVals.get(quoteLookupField));
                    if(oldVal == null || String.valueOf(oldVal) == '') {
                        newQuoteVals.put(fieldName, quoteLookupVals.get(quoteLookupField));
                    }
                }
                /** Add Special Field Logic Here **/
                if(String.isBlank(newQuoteVals.Quote_Number__c) && !String.isBlank(newQuoteVals.Name)) {
                    newQuoteVals.Quote_Number__c = newQuoteVals.Name;
                }
                if(newQuoteVals.Sold_By_Rep__c == newQuoteVals.Destination_Rep__c) {
                    newQuoteVals.Destination_Rep__c = NULL;
                }
                if(!String.isBlank(newQuoteVals.Quote_Number__c)) {
                    newQuoteVals.SBQQ__Key__c = (!newQuoteVals.Historical_Only__c) ?
                        newQuoteVals.Quote_Number__c + newQuoteVals.Status_Code__c + newQuoteVals.Revision__c :
                        newQuoteVals.Quote_Number__c + 'X' + (newQuoteVals.Change_Order_No__c == null ? 0 : newQuoteVals.Change_Order_No__c);
                }
                // Set Project Approval Flag
                newQuoteVals.Project_Approval_Required__c = (newQuoteVals.Project_Classification__c == 'EXP' || newQuoteVals.Project_Classification__c == 'GRN' || newQuoteVals.Project_Classification__c == 'Yes');

                // Use Inside House Account Flag to Select Approvers
                Boolean isInsideHouseAccount = newQuoteVals.Customer_Stat_Group__c == 'Partner_House_Account' && MappingUtil.houseRepCodes.contains(newQuoteVals.Rep_Code__c);
                
                // Key : 
                //  qt.Inside_Sales_Approver__c
                //      OEM -> APPROVERLEVEL_INSIDESALESAPPROVER
                //      DEF -> APPROVERLEVEL_BRAND_SELLINGENTITY
                //  qt.Sales_Director__c
                //      OEM -> APPROVERLEVEL_PARTNERREPCODE
                //      DEF -> APPROVERLEVEL_BRAND_REGION
                //  Sales Executive
                //      OEM -> APPROVERLEVEL_BRAND
                //      DEF -> APPROVERLEVEL_BRAND
                /*if(isInsideHouseAccount) {
                    newQuoteVals.Inside_Sales_Approver__c = newQuoteVals.Owner.Id;
                    if(approverMap.containsKey('Sales Director_' + newQuoteVals.Rep_Code__c)) {
                        newQuoteVals.Sales_Director__c = approverMap.get('Sales Director_' + newQuoteVals.Rep_Code__c);
                    }
                } else {
                    if(approverMap.containsKey('Inside Sales_' + newQuoteVals.Brand__c + '_' + newQuoteVals.Sales_Division__c)) {
                        newQuoteVals.Inside_Sales_Approver__c = approverMap.get('Inside Sales_' + newQuoteVals.Brand__c + '_' + newQuoteVals.Sales_Division__c);
                    }
                    if(approverMap.containsKey('Sales Director_' + newQuoteVals.Brand__c + '_' + newQuoteVals.Ordering_Region__c)) {
                        newQuoteVals.Sales_Director__c = approverMap.get('Sales Director_' + newQuoteVals.Brand__c + '_' + newQuoteVals.Ordering_Region__c);
                    }
                }

                if(approverMap.containsKey('Sales Executive_' + newQuoteVals.Brand__c)) {
                    newQuoteVals.Sales_Executive__c = approverMap.get('Sales Executive_' + newQuoteVals.Brand__c);
                }
                if(approverMap.containsKey('Regional Manager_' + newQuoteVals.Ordering_Region__c)) {
                    newQuoteVals.Regional_Manager__c = approverMap.get('Regional Manager_' + newQuoteVals.Ordering_Region__c);
                }

                //No Match found then default
                if(String.isBlank(newQuoteVals.Sales_Executive__c)) {
                    newQuoteVals.Sales_Executive__c = staticUser.Id;
                }
                if(String.isBlank(newQuoteVals.Inside_Sales_Approver__c)) {
                    newQuoteVals.Inside_Sales_Approver__c = staticUser.Id;
                }
                if(String.isBlank(newQuoteVals.Sales_Director__c)) {
                    newQuoteVals.Sales_Director__c = staticUser.Id;
                }
                if(String.isBlank(newQuoteVals.Regional_Manager__c)) {
                    newQuoteVals.Regional_Manager__c = staticUser.Id;
                }*/
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getCause());
            System.debug(quoteIdList);
        }
    }
    //Feature #30339
    public static void calculateCommissions(List<SBQQ__Quote__c> newQuotes) {
        System.debug('QuoteTriggerHelper.calculateCommissions');
        for(SBQQ__Quote__c newQuote : newQuotes) {
            if(newQuote.Quote_Type__c == 'Buy/Resell') {
                newQuote.Commission_Split_Sold_By_Rep__c = 0;
                newQuote.Commission_Split_Dest_Rep__c = 0;
                newQuote.Commission_Split_Eng_Rep_1__c = 0;
                newQuote.Commission_Split_Eng_Rep_2__c = 0;
            } else {
                newQuote.Sold_By_Commission_Split__c = newQuote.Commission_Split_Sold_By_Rep__c/100 * newQuote.Base_Commission_Amount__c;
                newQuote.Destination_Rep_Commission_Split__c = newQuote.Commission_Split_Dest_Rep__c/100 * newQuote.Base_Commission_Amount__c;
                newQuote.Eng_Rep_1_Commission_Split__c = newQuote.Commission_Split_Eng_Rep_1__c/100 * newQuote.Base_Commission_Amount__c;
                newQuote.Eng_Rep_2_Commission_Split__c = newQuote.Commission_Split_Eng_Rep_2__c/100 * newQuote.Base_Commission_Amount__c;
            }
        }
    }
    //Feature #30262
    public static void updateShipmentType( List<SBQQ__Quote__c> newQuotes) {
        System.debug('QuoteTriggerHelper.updateShipmentType');
        for(SBQQ__Quote__c newQuote : newQuotes) {
            if(newQuote.Customer_Shipment_Approval_Required__c) {
                newQuote.Shipment_Type__c = 'CA';
            }
            else if(!newQuote.Customer_Shipment_Approval_Required__c && newQuote.Do_Not_Ship_Before__c != NULL) {
                newQuote.Shipment_Type__c = 'DNS';
            } else {
                newQuote.Shipment_Type__c = 'NP';
            }
        }
    }
    
    
    // # Feature #30329 share quote with enginerring users
    // # Feature #30330 share quote with prod userss
    public static void shareQuoteWithProdEngUsers(List<SBQQ__Quote__c> lstQuote){
        System.debug('QuoteTriggerHelper.shareQuoteWithProdEngUsers');
        Map<String,Id> quoteEngGroupMap = new Map<String,Id>();
        Map<String,Id> quoteProdGroupMap = new Map<String,Id>(); 
        List<SBQQ__Quote__Share> engShareToInsert = new List<SBQQ__Quote__Share>();
        List<SBQQ__Quote__Share> prodShareToInsert = new List<SBQQ__Quote__Share>();
        for(SBQQ__Quote__c qtObj : [SELECT Id, SBQQ__Opportunity2__r.Brand__c,SBQQ__Opportunity2__r.Sales_Division__c,SBQQ__Opportunity2__r.Sourcing_Entity__c 
                                    FROM SBQQ__Quote__c
                                    WHERE Id IN:lstQuote
                                   ]){
                                       quoteEngGroupMap.put('ENG' + '_' + String.valueOf(qtObj.SBQQ__Opportunity2__r.Brand__c) + '_' + String.valueOf(qtObj.SBQQ__Opportunity2__r.Sales_Division__c), qtObj.Id);
                                       quoteProdGroupMap.put('PROD' + '_' + String.valueOf(qtObj.SBQQ__Opportunity2__r.Brand__c) + '_' +String.valueOf(qtObj.SBQQ__Opportunity2__r.Sourcing_Entity__c), qtObj.Id);
                                   }        
        if(null != quoteEngGroupMap && quoteEngGroupMap.size() > 0 || quoteProdGroupMap != null && quoteProdGroupMap.size() > 0){
            for(group groupObj: [Select Id,DeveloperName FROM Group WHERE 
                                 DeveloperName  IN : quoteEngGroupMap.keyset() 
                                 OR DeveloperName  IN : quoteProdGroupMap.keyset()]){
                                     if(String.valueof(groupObj.DeveloperName).startsWith('ENG_')){
                                         SBQQ__Quote__Share objQuoteShare = new SBQQ__Quote__Share();
                                         objQuoteShare.AccessLevel = 'Edit'; //Access Level
                                         objQuoteShare.UserOrGroupId = groupObj.Id;
                                         objQuoteShare.ParentID = quoteEngGroupMap.get(String.valueOf(groupObj.DeveloperName));
                                         objQuoteShare.RowCause = Schema.SBQQ__Quote__Share.RowCause.Share_Quote_With_Engineering_Users__c;//Record Sharing Reason
                                         engShareToInsert.add(objQuoteShare);
                                     }else if(String.valueof(groupObj.DeveloperName).startsWith('PROD_')){
                                         SBQQ__Quote__Share objQuoteShare = new SBQQ__Quote__Share();
                                         objQuoteShare.AccessLevel = 'Edit'; //Access Level
                                         objQuoteShare.UserOrGroupId = groupObj.Id;
                                         objQuoteShare.ParentID = quoteProdGroupMap.get(String.valueOf(groupObj.DeveloperName));
                                         objQuoteShare.RowCause = Schema.SBQQ__Quote__Share.RowCause.Share_Quote_With_Production_Plan_Users__c;//Record Sharing Reason
                                         prodShareToInsert.add(objQuoteShare);
                                     }
                                 }
            if(null != engShareToInsert && engShareToInsert.size() > 0){
                try{
                    insert engShareToInsert;
                }catch(Exception e){
                    system.debug(e.getCause());
                }
            }
            if(null != prodShareToInsert && prodShareToInsert.size() > 0){
                try{
                    insert prodShareToInsert;
                }catch(Exception e){
                    system.debug(e.getCause());
                }
            }
        }
    }
    
    public static void shareQuoteWithOppTeam(List<SBQQ__Quote__c> lstQuote){
        set<string> setOppId = new set<string>();
        for(SBQQ__Quote__c oQuote:lstQuote){
            if(oQuote.SBQQ__Opportunity2__c!=null){
                setOppId.add(oQuote.SBQQ__Opportunity2__c);
            }
        }
        if(setOppId.size()>0){
            map<string,Opportunity> mapIdWiseOpp = new map<string,Opportunity>();
            list<SBQQ__Quote__Share> lstQuoteShareToInsert = new list<SBQQ__Quote__Share>();
            
            for(Opportunity opp:[Select Id,(Select Id,UserId,User.ContactId,opportunityaccessLevel from opportunityteammembers) From Opportunity where id in :setOppId]){
                mapIdWiseOpp.put(opp.id,opp);
            }
            
            for(SBQQ__Quote__c oQuote:lstQuote){
                if(UtilityHelper.self.isPartnerUser()){
                    if(oQuote.SBQQ__Opportunity2__c!=null){
                        if(mapIdWiseOpp.containsKey(oQuote.SBQQ__Opportunity2__c)){
                            Opportunity opp = mapIdWiseOpp.get(oQuote.SBQQ__Opportunity2__c);
                            if(opp.opportunityteammembers!=null){
                                for(OpportunityTeamMember oOpportunityTeamMember:opp.opportunityteammembers){
                                    if(oOpportunityTeamMember.UserId != oQuote.ownerid && oOpportunityTeamMember.User.ContactId != null){
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
                }
            }
            
            if(lstQuoteShareToInsert.size()>0){
                insert lstQuoteShareToInsert;
            }
        }
    }
    
  }