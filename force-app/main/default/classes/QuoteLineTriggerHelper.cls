public class QuoteLineTriggerHelper {

    public static User userData = [
        SELECT Id, Brand__c, CDC_Source_Entity__c, Groth_Source_Entity__c, LVA_Source_Entity__c, LaMOT_Source_Entity__c
        FROM User
        WHERE Id=:UserInfo.getUserId() LIMIT 1];
    public static Map<Id, SBQQ__Quote__c> getQuoteData(List<Id> quoteIdList) {
        Map<Id, SBQQ__Quote__c> quoteMap = new Map<Id, SBQQ__Quote__c>();
        try {
            quoteMap = new Map<Id, SBQQ__Quote__c>([
                SELECT Id,Wanted_Delivery_Date__c,Brand__c,Rep_Code__c,Revision__c,Sourcing_Entity__c,
                        SBQQ__Opportunity2__r.Quote_Type__c,
                (
                    SELECT Id,LeadTime__c,Production_Planning_Leadtime__c,Customer_Leadtime__c,SBQQ__Quote__c
                    FROM SBQQ__LineItems__r
                )
                FROM SBQQ__Quote__c WHERE Id IN :quoteIdList
            ]);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return quoteMap;
    }
    public static Map<Id, SBQQ__QuoteLine__c> getQuoteLineRefData(List<Id> quoteLineRefIdList) {
        Map<Id, SBQQ__QuoteLine__c> quoteLineRefMap = new Map<Id, SBQQ__QuoteLine__c>();
        try {
            quoteLineRefMap = new Map<Id, SBQQ__QuoteLine__c>([
                SELECT Id,Config_Record_Id__c,SBQQ__Quantity__c,
                    Engineering_Notes__c,Non_Discountable_List_Price__c,Discountable_List_Price__c,
                    Leadtime_Site_10__c,Leadtime_Site_20__c,Leadtime_Site_30__c,Leadtime_Site_40__c
                FROM SBQQ__QuoteLine__c WHERE Id IN :quoteLineRefIdList
            ]);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return quoteLineRefMap;
    }

    //Feature #30261
    public static void runBeforeInsertOperations(List<SBQQ__QuoteLine__c> lineItems) {
        List<Id> qtIds = new List<Id>();
        List<SBQQ__QuoteLine__c> quoteLinesWithoutPricebookEntryId = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c lineItem : lineItems) {
            // Add all SBQQ Quote IDs to list for queries
            if(qtIds.indexOf(lineItem.SBQQ__Quote__c) == -1) {
                qtIds.add(lineItem.SBQQ__Quote__c);
            }
        }
        Map<Id, SBQQ__Quote__c> sourceQuotes = new Map<Id, SBQQ__Quote__c>(
            [
                SELECT Id, Brand__c, Sourcing_Entity__c, SBQQ__Pricebook__c
                FROM SBQQ__Quote__c
                WHERE Id IN :qtIds
            ]
        );
        // Set more complex logic, based on Quote
        Set<Id> quotePriceBookIds = new Set<Id>();
        for(SBQQ__QuoteLine__c lineItem:lineItems) {
            // If Sourcing Entity
            lineItem.Sourcing_Entity__c = sourceQuotes.get(lineItem.SBQQ__Quote__c).Sourcing_Entity__c;
            //if(quotePriceBookId.size() == 0){
            //system.debug('test 1');
            quotePriceBookIds.add(sourceQuotes.get(lineItem.SBQQ__Quote__c).SBQQ__Pricebook__c);
               //system.debug('set pricebook ' + quotePriceBookId[0]);
            //}
            //add to group of quote lines to gather Pricebook Entry ID 
            if(lineItem.SBQQ__PricebookEntryId__c == null){
            //system.debug('test 2');
                quoteLinesWithoutPricebookEntryId.add(lineItem);
            }
            

        }
        //system.debug('quote pricebook ' + quotePriceBookId);
        //system.debug('quote lines ' + quoteLinesWithoutPricebookEntryId);
        List<SBQQ__Quote__c> quoteRecords = sourceQuotes.values();
        setCPQQuoteLinePricebookEntry.setQuoteLinePricebookEntryId(quoteRecords, quoteLinesWithoutPricebookEntryId, quotePriceBookIds);
        /** MOVE MAPPINGUTIL CALL HERE */
    }
    /**
     *  Purpose : Get Lead Time (leadtime__c) based on sourcing entity
     */
    public static Decimal getDefaultLeadTime(SBQQ__QuoteLine__c lineItem) {
        Decimal leadTime;
        switch on lineItem.Sourcing_Entity__c {
            when '10' {
                leadTime = lineItem.Leadtime_Site_10__c;
            }
            when '20' {
                leadTime = lineItem.Leadtime_Site_20__c;
            }
            when '30' {
                leadTime = lineItem.Leadtime_Site_30__c;
            }
            when '40' {
                leadTime = lineItem.Leadtime_Site_40__c;
            }
        }
        return leadTime;
    }
    /**
     * Purpose: Get Default Sourcing Entity based on users brand
     */
    public static String getDefaultUserSourcingEntity(String brand) {
        String sourcingEntity;
        String test = brand.toUpperCase();
        switch on test {
            when 'CDC' {
                sourcingEntity = userData.CDC_Source_Entity__c;
            }
            when 'GROTH' {
                sourcingEntity = userData.Groth_Source_Entity__c;
            }
            when 'LAMOT' {
                sourcingEntity = userData.LaMOT_Source_Entity__c;
            }
            when 'LVA' {
                sourcingEntity = userData.LVA_Source_Entity__c;
            }
        }
        return sourcingEntity;
    }

    public static void runBeforeUpdateOperations(Map<Id,SBQQ__QuoteLine__c> oldQuoteLineMap, List<SBQQ__QuoteLine__c> lineItems) {

        System.debug('QuoteLineTriggerHelper.UpdateApprovalsFlags');
        Set<Id> quoteIdSet = new Set<Id>();
        Set<Id> quoteLineRefIdSet = new Set<Id>();
        Map<Id,SBQQ__Quote__c> quoteMap = new Map<Id,SBQQ__Quote__c>();
        Map<Id,SBQQ__QuoteLine__c> quoteLineRefMap = new Map<Id,SBQQ__QuoteLine__c>();

        for(SBQQ__QuoteLine__c lineItem : lineItems) {
            quoteIdSet.add(lineItem.SBQQ__Quote__c);
            if(!String.isBlank(lineItem.Quote_Line_Reference__c)) {
                quoteLineRefIdSet.add(lineItem.Quote_Line_Reference__c);
            }
        }
        if(quoteIdSet.size() > 0) {
            quoteMap = getQuoteData(new List<Id>(quoteIdSet));
        }
        if(quoteLineRefIdSet.size() > 0) {
            quoteLineRefMap = getQuoteLineRefData(new List<Id>(quoteLineRefIdSet));
        }

        for(SBQQ__QuoteLine__c lineItem:lineItems) {
            SBQQ__Quote__c quote = quoteMap.get(lineItem.SBQQ__Quote__c);

            //Feature #30261
            // Populate Default Line Number for Original Quote
            if(String.IsBlank(lineItem.Quote_Line_Number__c)) {
                lineItem.Quote_Line_Number__c = lineItem.Name;
            }

            //Feature #30404
            setSourcingEntityAndLeadtime(lineItem);
            setDiscountThresholds(quote,lineItem);
            setConfigValues(quoteLineRefMap,lineItem);
            setPricingAndCommissions(quote, lineItem);

            // Feature #30236/30237
            if(oldQuoteLineMap.containsKey(lineItem.Id)) {
                setDiscountApprovalFlags(
                    oldQuoteLineMap.get(lineItem.Id),
                    lineItem,
                    quote.Revision__c
                );
            }
            setReviewFlags(lineItem);
        }
    }
    /*public static void runAfterUpdateOperations(List<SBQQ__QuoteLine__c> newQuoteLines) {
        Map<Id,Decimal> maxLeadTimeMap = new Map<Id,Decimal>();
        Decimal maxLeadTime;
        for(SBQQ__QuoteLine__c lineItem : newQuoteLines) {
            Decimal currentLeadTime = 0;
            // Check if a max lead time is already present
            if(maxLeadTimeMap.containsKey(lineItem.SBQQ__Quote__c)) {
                currentLeadTime = maxLeadTimeMap.get(lineItem.SBQQ__Quote__c);
            }
            // Assign the current comparison value by hierarchy PP, then Customer, then Config default
            if(lineItem.Production_Planning_Leadtime__c != null && lineItem.Production_Planning_Leadtime__c != 0) {
                currentLeadTime = lineItem.Production_Planning_Leadtime__c;
            } else if(lineItem.Customer_Leadtime__c != null && lineItem.Customer_Leadtime__c != 0) {
                currentLeadTime = lineItem.Customer_Leadtime__c;
            } else if(lineItem.Leadtime__c != null && lineItem.Leadtime__c != 0) {
                currentLeadTime = lineItem.Leadtime__c;
            }
            // If the current lead time is greater than the currently recorded maximum, then store it.
            if(currentLeadTime > maxLeadTime) {
                maxLeadTime = currentLeadTime;
                maxLeadTimeMap.put(lineItem.SBQQ__Quote__c, currentLeadTime);
            }
        }
        // Retrieve all pertinent Quotes, and update them
        List<SBQQ__Quote__c> quotesToUpdate = [
            SELECT Id, Max_Lead_Time__c
            FROM SBQQ__Quote__c
            WHERE Id IN :maxLeadTimeMap.keySet()
        ];
        for(SBQQ__Quote__c qt : quotesToUpdate) {
            qt.Max_Lead_Time__c = maxLeadTimeMap.get(qt.Id);
        }
        update quotesToUpdate;
    }*/
    public static void setSourcingEntityAndLeadtime(SBQQ__QuoteLine__c lineItem) {
        String sourcingEntity = String.isBlank(lineItem.Sourcing_Entity__c) ?
                MappingUtil.brandDefaultSourcingEntityMap.get(lineItem.Brand__c) : lineItem.Sourcing_Entity__c;
        Decimal leadTime = getDefaultLeadTime(lineItem);

        if(leadTime == 7777 ) {
            sourcingEntity = getDefaultUserSourcingEntity(lineItem.Brand__c);
            leadTime = getDefaultLeadTime(lineItem);
            lineItem.Sourcing_Entity__c = sourcingEntity;
        }
        lineItem.Leadtime__c = leadTime;

        if(lineItem.Customer_Leadtime__c < lineItem.Leadtime__c) {
            lineItem.Priority__c ='1';
        } else {
            lineItem.Priority__c ='';
        }
    }
    public static void setDiscountThresholds(SBQQ__Quote__c quote, SBQQ__QuoteLine__c lineItem) {
        MappingUtil.DiscThresholds threshold = MappingUtil.getThresholds(
            quote.Brand__c,
            quote.Rep_Code__c
        );
        lineItem.Sales_Rep_Max_Discount__c = threshold.insideSales;
        lineItem.Inside_Sales_Max_Discount__c = threshold.director;
        lineItem.Director_Max_Discount__c = threshold.salesExec;
    }
    public static void setDiscountApprovalFlags(SBQQ__QuoteLine__c oldLine, SBQQ__QuoteLine__c lineItem, Decimal revisionNumber) {
        //if(revisionNumber == 0) {
            lineItem.Requires_Inside_Sales_Approval__c = lineItem.Discount__c > lineItem.Sales_Rep_Max_Discount__c;
            lineItem.Requires_Sales_Director_Approval__c = lineItem.Discount__c > lineItem.Inside_Sales_Max_Discount__c;
            lineItem.Requires_Sales_Executive_Approval__c = lineItem.Discount__c > lineItem.Director_Max_Discount__c;
        /* TODO: Update tracking to track the discount, and use that for smart approvals
        } else {
            Boolean discountIncreased = lineItem.Discount__c > oldLine.Discount__c;
            lineItem.Requires_Inside_Sales_Approval__c = oldLine.Requires_Inside_Sales_Approval__c &&
                lineItem.Discount__c > lineItem.Sales_Rep_Max_Discount__c && discountIncreased;
            lineItem.Requires_Sales_Director_Approval__c = oldLine.Requires_Sales_Director_Approval__c &&
                lineItem.Discount__c > lineItem.Inside_Sales_Max_Discount__c && discountIncreased;
            lineItem.Requires_Sales_Executive_Approval__c = oldLine.Requires_Sales_Executive_Approval__c &&
                lineItem.Discount__c > lineItem.Director_Max_Discount__c && discountIncreased;
        } */
    }
    public static void setReviewFlags(SBQQ__QuoteLine__c lineItem) {
        if(lineItem.Engineering_Status__c != 'Released' && lineItem.Total_List_Price__c <> 0 && (lineItem.Line_Status__c == 'Primary' || lineItem.Line_Status__c == 'Alternate')) {
            lineItem.Engineering_Status__c = (String.isBlank(lineItem.SBQQ__Description__c) || lineItem.Requires_Technical_Review__c == 'Yes' || lineItem.Total_List_Price__c >= 8000000 || lineItem.Total_List_Price__c <= 0 || lineItem.Drawings_Status__c == 'Requested' || lineItem.Drawings_Status__c == 'Required') ? 'Yes' : 'No';
        }
        if(lineItem.Product_Planning_Status__c != 'Released' && (lineItem.Line_Status__c == 'Primary' || lineItem.Line_Status__c == 'Alternate')) {
            lineItem.Product_Planning_Status__c = (
                lineItem.Priority__c == '1' ||
                (lineItem.Leadtime__c > 4000 && lineItem.Production_Planning_Leadtime__c == null && lineItem.Customer_Leadtime__c == null) ||
                (lineItem.Leadtime__c == 0 && lineItem.Production_Planning_Leadtime__c == null && lineItem.Customer_Leadtime__c == null)
            ) ? 'Yes' : 'No';
        }
    }
    //Feature #30232
    public static void setConfigValues(Map<Id,SBQQ__QuoteLine__c> quoteLineRefMap, SBQQ__QuoteLine__c lineItem) {
        System.debug('@Developer --> SetConfigValues 262: Limits.getLimitQueries() :' + Limits.getLimitQueries());
		System.debug('@Developer --> SetConfigValues 263: Limits.getQueries() :' + Limits.getQueries());
        try {
            if(String.IsNotBlank(lineItem.SBQQ__ProductCode__c)) {
                system.debug('@===> if ' );
                Id configId = String.isBlank(lineItem.Config_Record_Id__c) ? MappingUtil.getConfigSObjectIDFromQuoteLine(lineItem) : lineItem.Config_Record_Id__c;
                lineItem.Run_Config_Sync__c = false;
                if(lineItem.Run_Config_Sync__c && !String.isBlank(configId)) {

                    Result endResult = SyncConfiguratorData.runRulesForConfigData(configId);
                    system.debug('@Developer--> endResult ' + endResult  );
                    lineItem.Config_Record_Id__c = configId;
                    lineItem.Engineering_Notes__c = SyncConfiguratorData.ENG_NOTES;
                    lineItem.Non_Discountable_List_Price__c   = SyncConfiguratorData.NONDISCOUNTABLELISTPRICE != null ? SyncConfiguratorData.NONDISCOUNTABLELISTPRICE : 0;
                    //lineItem.Discountable_List_Price__c = SyncConfiguratorData.LISTPRICE - lineItem.Non_Discountable_List_Price__c;
                    lineItem.Discountable_List_Price__c = SyncConfiguratorData.LISTPRICE != null ? SyncConfiguratorData.LISTPRICE - lineItem.Non_Discountable_List_Price__c : 0;
                    lineItem.PARTNUMBER__c=SyncConfiguratorData.PARTNUMBER;
                    lineItem.Leadtime_Site_10__c = SyncConfiguratorData.LEADTIMEFORSITE10;
                    lineItem.Leadtime_Site_20__c = SyncConfiguratorData.LEADTIMEFORSITE20;
                    lineItem.Leadtime_Site_30__c = SyncConfiguratorData.LEADTIMEFORSITE30;
                    lineItem.Leadtime_Site_40__c = SyncConfiguratorData.LEADTIMEFORSITE40;
                    if(quoteLineRefMap.containsKey(lineItem.Id)) {
                        SBQQ__QuoteLine__c lineItemInfo = quoteLineRefMap.get(lineItem.Id);
                        //if(lineItemInfo.Delivery_Quantity_Total__c != SyncConfiguratorData.QTY) {
                        //    throw new AuraHandledException('Remove delivery info items before changing this line\'s quantity!');
                        //}
                        lineItem.SBQQ__Quantity__c = SyncConfiguratorData.QTY;
                    } else {
                        lineItem.SBQQ__Quantity__c = SyncConfiguratorData.QTY;
                    }
                    lineItem.Run_Config_Sync__c = false;
                }
                System.debug('configId: ' + configId);
            } else if(quoteLineRefMap.containsKey(lineItem.Quote_Line_Reference__c)) {
                system.debug('@===> else if ' );
                SBQQ__QuoteLine__c parentLineItem = quoteLineRefMap.get(lineItem.Quote_Line_Reference__c);
                lineItem.Config_Record_Id__c = parentLineItem.Config_Record_Id__c;
                lineItem.Engineering_Notes__c = parentLineItem.Engineering_Notes__c;
                lineItem.Non_Discountable_List_Price__c =  parentLineItem.Non_Discountable_List_Price__c;
                lineItem.Discountable_List_Price__c = parentLineItem.Discountable_List_Price__c;
                lineItem.Leadtime_Site_10__c = parentLineItem.Leadtime_Site_10__c;
                lineItem.Leadtime_Site_20__c = parentLineItem.Leadtime_Site_20__c;
                lineItem.Leadtime_Site_30__c = parentLineItem.Leadtime_Site_30__c;
                lineItem.Leadtime_Site_40__c = parentLineItem.Leadtime_Site_40__c;
            }
            system.debug('lineItem====> ' + lineItem);
        } catch(Exception e) {
            System.debug('Error on config rules :' + e.getMessage());
            system.debug(e.getLineNumber());
        }
    }
    public static void setPricingAndCommissions(SBQQ__Quote__c quote, SBQQ__QuoteLine__c lineItem) {
        try {
            lineItem.Discount_Amount__c = (lineItem.Discount__c != null && lineItem.Discountable_List_Price__c != null) ? lineItem.Discount__c/100 * lineItem.Discountable_List_Price__c : 0;
            //lineItem.SBQQ__ListPrice__c = lineItem.Discountable_List_Price__c + lineItem.Non_Discountable_List_Price__c;

            if(lineItem.Discountable_List_Price__c == null || lineItem.Non_Discountable_List_Price__c == null){
                if(lineItem.Discountable_List_Price__c != null){
                   lineItem.SBQQ__ListPrice__c = lineItem.Discountable_List_Price__c;
                }
                else if(lineItem.Non_Discountable_List_Price__c != null){
                    lineItem.SBQQ__ListPrice__c = lineItem.Non_Discountable_List_Price__c;
                }
                else{
                    lineItem.SBQQ__ListPrice__c = 0;
                }

            }else{
                lineItem.SBQQ__ListPrice__c =  lineItem.Discountable_List_Price__c + lineItem.Non_Discountable_List_Price__c ;
            }
            
            lineItem.SBQQ__NetPrice__c = lineItem.SBQQ__ListPrice__c;
            if(lineItem.Discountable_List_Price__c != null || lineItem.Non_Discountable_List_Price__c != null){
                lineItem.SBQQ__RegularPrice__c = lineItem.Non_Discountable_List_Price__c + (lineItem.Discountable_List_Price__c - lineItem.Discount_Amount__c);
            }
            //Feature #30339
            if(quote.SBQQ__Opportunity2__r.Quote_Type__c == 'Buy/Resell') {
                lineItem.Maximum_Commission__c = 0;
                lineItem.Discount__c = 20;
            } else {
                lineItem.Maximum_Commission__c = 20;
            }
            
            if(lineItem.Product_Group__c == 'Replacement Parts' || lineitem.Body_Material__c == '1' ){
                lineItem.Maximum_Commission__c = quote.SBQQ__Opportunity2__r.Quote_Type__c == 'Buy/Resell'? 0 : 15;
                
                if (quote.SBQQ__Opportunity2__r.Quote_Type__c == 'Buy/Resell'){
                    lineItem.Discount__c = 15;
                    lineItem.Sales_Rep_Max_Discount__c = 15;
                }
                /*if (lineItem.Discount__c == NULL){
                    lineItem.Discount__c = quote.SBQQ__Opportunity2__r.Quote_Type__c == 'Buy/Resell'? 15 : 20;
                } else {
                    lineItem.Sales_Rep_Max_Discount__c = 15;
                    lineItem.Discount__c = 15;
                       }*/
            } 
            /* TODO: UPDATE PARTNER and MATERIAL LOGIC AFTER CONFIG TALK
                vMaxCommission=20%
                vMaxPartnerOrgDiscount=20%

                if CONFIG PRODUCT LINE = Relief Valves OR Flame Products
                    if MCBODY = “1”[ALUMINUM]
                        MAX COMM=15% and MAX PRTNR DSC=15%
                else if CONFIG PRODUCT LINE = Parts AND PRODUCT = Parts or Kits OR MCBODY = “1”[ALUMINUM] (Verify code)
                    Then vMaxCommission=15% and vMaxPartnerOrgDiscount=15%
                End

            */
        } catch(Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
    }
}