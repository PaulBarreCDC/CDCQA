public without sharing class QuoteCommentController {
    @AuraEnabled
    public static CommentCompInfo getInfo(Id quoteId, String commentType) {
        return new CommentCompInfo(
            [
                SELECT Id, CreatedBy.Name, CreatedDate, Comments__c 
                FROM Comment_Log__c 
                WHERE Quote__c =:quoteId
                AND Type__c =:commentType
                ORDER BY CreatedDate DESC
            ], 
            [
                SELECT Id, Quote_Line_Number__c,Name, SBQQ__Quote__c, Engineering_Status__c, Product_Planning_Status__c
                FROM SBQQ__QuoteLine__c
                WHERE SBQQ__Quote__c = :quoteId
            ],
            commentType == 'Eng Review' ? 'Engineering_Status__c' : 'Product_Planning_Status__c'
        );
    }
    
    public class CommentCompInfo {
        @AuraEnabled
        public List<Comment_Log__c> comments{get;set;}
        @AuraEnabled
        public List<SBQQ__QuoteLine__c> qlis{get;set;}
        @AuraEnabled
        public Integer pendingApprovalCount{get;set;}
        public CommentCompInfo(){
        }
        public CommentCompInfo(List<Comment_Log__c> comms, List<SBQQ__QuoteLine__c> lines, String filterField){
            this.comments = comms;
            this.qlis = lines;
            countFilterField(filterField);
        }
        public void countFilterField(String filterField){
            pendingApprovalCount = 0;
            if(qlis != null) {
                for(SBQQ__QuoteLine__c qli : qlis) {
                    if(qli.get(filterField) == 'Yes') {
                        pendingApprovalCount += 1;
                    }
                }
            }
        }
    }
    @AuraEnabled
    public static List<Comment_Log__c> getComments(Id quoteId, String commentType) {
        return [SELECT  Id,
                CreatedBy.Name,
                CreatedDate,
                Comments__c 
                FROM Comment_Log__c 
                WHERE Quote__c =:quoteId
                AND Type__c =:commentType
                ORDER BY CreatedDate DESC];
    }
    
    @AuraEnabled
    public static Id callPageReference(String quoteId) {
        
        map<Id,Id> quote = new map<Id,Id>();
        
        if (quoteId != null) {
            try {
                SBQQ__Quote__c qt = [
                    SELECT Id,Quote_Number__c,Name,Change_Order_No__c,SBQQ__Key__c,
                     (SELECT ID FROM Charges__r),
                     (SELECT ID FROM Credits_and_Bookings__r)
                    FROM SBQQ__Quote__c where Id=:quoteId];
                qt.Historical_Only__c = true;
                qt.SBQQ__Key__c = qt.SBQQ__Key__c + 'X' + (qt.Change_Order_No__c == null ? 0 : qt.Change_Order_No__c);
                //@Suraj 9 Sept 2020
                qt.Change_Order_Status__c = 'Change Order Initiated';
                qt.SBQQ__Primary__c = false;
                qt.RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Lock_Order').getRecordTypeId();
                
                update qt;
                
                //Cloning Quote
                sObject originalSObject = (sObject)qt; 
                List<sObject> originalSObjects = new List<sObject>{originalSObject}; 
                List<sObject> clonedSObjects =DynamicClone.cloneObjects( originalSobjects, originalSobject.getsObjectType()); 
                // Set cloned quote values
                SBQQ__Quote__c clonedQt = (SBQQ__Quote__c)clonedSObjects.get(0);
                clonedQt.SBQQ__Key__c = '';
                clonedQt.Change_Order_No__c =  qt.Change_Order_No__c == null ? 1 : qt.Change_Order_No__c + 1; //Added by Maanas to handle Null check and Prevent null pointer ,Cannot add integer to Null 
                clonedQt.Quote_Number__c = qt.Quote_Number__c;
                clonedQt.Revision__c = 0;
                clonedQt.Historical_Only__c = false;
                clonedQt.Status_Reason__c = '';
                Id pendingRecTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Pending').getRecordTypeId();
                clonedQt.RecordTypeId = pendingRecTypeId;
                clonedQt.SBQQ__Status__c = 'Change Order';
                clonedQt.Change_Order_Status__c = '';
                //@Suraj 9 Sept 2020
                clonedQt.SBQQ__OriginalQuote__c = qt.Id;
                
                insert clonedQt;
                //Cloning Quote End

                //Cloning Quote Line Items
                Map<Id,SBQQ__QuoteLine__c> lineItemsMap = new Map<Id,SBQQ__QuoteLine__c>();
                List<sObject> originalSobjects1;
                List<sObject> clonedSObjects1;
                List<SBQQ__QuoteLine__c> clonedLineItems1;
                // Get original Line items
                for(SBQQ__QuoteLine__c lineItem : [SELECT Id,Quote_Line_Number__c,Name,SBQQ__Quote__c,
                                                   (SELECT Id,Quote_Line__c FROM Rupture_Discs__r),
                                                   (SELECT Id,Quote_Line__c FROM BGR__r),
                                                   (SELECT Id,Quote_Line__c FROM Relief_Valves__r),
                                                   (SELECT Id,Quote_Line__c FROM WasteGasBurners__r)
                                                   FROM SBQQ__QuoteLine__c
                                                   WHERE SBQQ__Quote__c = :qt.Id ]) {
                    lineItemsMap.put(lineItem.Id,lineItem);
                    quote.put(lineItem.Id,lineItem.Id);
                }
                // IF we have line items, begin cloning
                if(NULL != lineItemsMap && lineItemsMap.size() > 0) {
                    originalSObjects1 =  (List<sObject>) lineItemsMap.values(); 
                    clonedSObjects1 =DynamicClone.cloneObjects( originalSobjects1, ((sObject)lineItemsMap.values()[0]).getsObjectType()); 
                    clonedLineItems1 = (List<SBQQ__QuoteLine__c>)clonedSObjects1;
                    
                    for(SBQQ__QuoteLine__c item : clonedLineItems1){
                        item.SBQQ__Quote__c = clonedQt.Id;
                        item.Status_Reason__c = '';
                        // IF the line items exists, initialize new values
                        if(lineItemsMap.containskey(item.getCloneSourceId())){
                            item.Quote_Line_Number__c = lineItemsMap.get(item.getCloneSourceId()).Quote_Line_Number__c;
                        }
                    }
                    // IF there are line items to clone, then do so in batch-safe format
                    if(NULL != clonedLineItems1 && clonedLineItems1.size() > 0){
                        list<sObject> s = deepCloneBatched(clonedLineItems1,quote);
                    }
                }
                //Cloning Quote Line Items End 
                
                
                //Cloning Charges
                // IF there are charges on the quote
                if(qt.Charges__r != NULL && qt.Charges__r.size() > 0){
                    List<Charge__c> originalCharges = qt.Charges__r; 
                    /*List<sObject> clonedCharges;
                    List<Charge__c> finalClonedCharges;
                    
                    originalCharges =   qt.Charges__r; 
                    /*clonedCharges =DynamicClone.cloneObjects(originalCharges, ((sObject)qt.Charges__r[0]).getsObjectType()); 
                    finalClonedCharges = (List<Charge__c>)clonedCharges;*/
                    
                    for(Charge__c item : originalCharges){
                        item.Parent_Quote__c = clonedQt.Id;
                    }
                    
                    if(NULL != originalCharges && originalCharges.size() > 0) {
                        update originalCharges;
                    }
                }
                //Clong Charges End
                
                //Cloning Credit and Bookings
                if(qt.Credits_and_Bookings__r != NULL && qt.Credits_and_Bookings__r.size() > 0){
                    List<Credits_and_Booking__c> originalCreditBooking;
                    originalCreditBooking =  (List<Credits_and_Booking__c>) qt.Credits_and_Bookings__r; 

                    for(Credits_and_Booking__c item : originalCreditBooking){
                        item.Quote__c = clonedQt.Id;
                    }
                    
                    if(NULL != originalCreditBooking && originalCreditBooking.size() > 0) {
                        update originalCreditBooking;
                    }
                }
                return clonedQt.Id; 
            } 
            catch (Exception e) {
                System.Debug('Exception:'+e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
            
        }
        return null;  
    }
    
     @AuraEnabled
    public static string cloneQuoteLine(String quoteLineId){
        Map<Id,SBQQ__QuoteLine__c> lineItemsMap = new Map<Id,SBQQ__QuoteLine__c>();
        List<sObject> originalSobjects1;
        List<sObject> clonedSObjects1;
        List<SBQQ__QuoteLine__c> clonedLineItems1;
        Id qId;
        for(SBQQ__QuoteLine__c lineItem : [SELECT Id,Quote_Line_Number__c,Name,SBQQ__Quote__c,
                                           (SELECT Id,Quote_Line__c FROM Rupture_Discs__r),
                                           (SELECT Id,Quote_Line__c FROM BGR__r),
                                           (SELECT Id,Quote_Line__c FROM Relief_Valves__r),
                                           (SELECT Id,Quote_Line__c FROM WasteGasBurners__r)
                                           FROM SBQQ__QuoteLine__c
                                           WHERE Id = :quoteLineId ]) 
        {
            lineItemsMap.put(lineItem.Id,lineItem);
            qId = lineItem.SBQQ__Quote__c;
        }
        
        list<sObject> lstCloned = new list<sObject>();
        
        System.debug('@Developer --> lineItemsMap.size() :' + lineItemsMap.size());
        // IF we have line items, begin cloning
        if(NULL != lineItemsMap && lineItemsMap.size() > 0) {
            originalSObjects1 =  (List<sObject>) lineItemsMap.values(); 
            clonedSObjects1 = DynamicClone.cloneObjects( originalSobjects1, ((sObject)lineItemsMap.values()[0]).getsObjectType()); 
            clonedLineItems1 = (List<SBQQ__QuoteLine__c>)clonedSObjects1;
            //Get the highest QuoteLineNumber__c value on all lines for this quote and increment by 1 to set for this new line
            SBQQ__QuoteLine__c maxLine = [select id, QuoteLineNumber__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =:qId ORDER BY QuoteLineNumber__c DESC Limit 1];
            Decimal nextLineNumber = maxLine.QuoteLineNumber__c +1;
			SBQQ__QuoteLine__c maxNumber = [select id, SBQQ__Number__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =:qId ORDER BY SBQQ__Number__c DESC Limit 1];
            Decimal nextNumNumber = maxNumber.SBQQ__Number__c +1;
            
            for(SBQQ__QuoteLine__c item : clonedLineItems1){
                item.SBQQ__Quote__c = item.SBQQ__Quote__c;
                item.Change_Order_Status__c = '';
                item.Status_Reason__c = '';
                item.Line_Status__c = 'Primary';
                item.QuoteLineNumber__c = nextLineNumber;
                item.SBQQ__Number__c = nextNumNumber;
                // IF the line items exists, initialize new values
                if(lineItemsMap.containskey(item.getCloneSourceId())){
                    //if we don't fill Quote_Line_Number__c than it will auto generate, else not. 
                    item.Quote_Line_Number__c = lineItemsMap.get(item.getCloneSourceId()).Quote_Line_Number__c;
                }
                
            }
            // IF there are line items to clone, then do so in batch-safe format
            if(NULL != clonedLineItems1 && clonedLineItems1.size() > 0){
                try{
                    system.debug('@Developer -->clonedLineItems1>>'+clonedLineItems1);
                    map<id,id> mapClonedLineItem = new map<id,id>();
                    mapClonedLineItem.put(clonedLineItems1[0].getCloneSourceId(),clonedLineItems1[0].Id);
                    lstCloned = deepCloneBatched(clonedLineItems1,mapClonedLineItem); 
                    System.debug('@Developer --> lstCloned :' + lstCloned);
                }
                catch(Exception ex){
                    System.debug('@Developer --> Exception :' + ex.getStackTraceString());
                    //return false;
                    throw new AuraHandledException('Exception:' + ex.getMessage());
                }                
            }
        }
        
        if(clonedLineItems1.size() > 0){
            return clonedLineItems1[0].Id;
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean CheckEngApproverUser(String quoteId){
        
        Boolean showCloseReview = false;
        if (quoteId != null) {
            
            List<SBQQ__Quote__c> qt = [Select Id,Engineering_Approver__c FROM SBQQ__Quote__c where Id=:quoteId AND Engineering_Approver__c =:UserInfo.getUserId()];
           
            if(qt != null && qt.size() >0 ){
               
                showCloseReview = true;
                 system.debug(showCloseReview);
            }
        }
        return showCloseReview;
    }
    
    
    
    //Deep clon
    static map<String,String> mapPreventDuplicate = new map<String,String>();
    static map<String,sObject> mapData = new map<String,sObject>();
    public static list<sObject> deepCloneBatched(list<sObject> objectsToClone) { 
        mapPreventDuplicate.clear();
        mapData.clear();
        return deepCloneBatched(objectsToClone,new map<id,id>());
    }
    
    public static list<sObject> deepCloneBatched(list<sObject> objectsToClone, map<id,id> previousSourceToCloneMap)
    {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();  
        system.debug('\n\n\n--------------------  Cloning record ' + objectsToClone.size() + ' records');
        list<id> objectIds = new list<id>();
        list<sobject> clones = new list<sobject>();
        list<sObject> newClones = new list<sObject>();
        map<id,id> sourceToCloneMap = new map<id,id>();
       
        
        System.debug('@Developer --> objectsToClone:' + objectsToClone);
        System.debug('@Developer --> previousSourceToCloneMap:' + previousSourceToCloneMap);
        
        if(objectsToClone.isEmpty())
        {
            system.debug('\n\n\n-------------------- No records in set to clone. Aborting');
            return clones;
        }
        
        //if this function has been called recursively, then the previous batch of cloned records
        //have not been inserted yet, so now they must be before we can continue. Also, in that case
        //because these are already clones, we do not need to clone them again, so we can skip that part
        if(objectsToClone[0].Id == null)
        {
            System.debug('@Developer --> when objectsToClone[0].Id == null:' );
            //if they don't have an id that means these records are already clones. So just insert them with no need to clone beforehand.
            insert objectsToClone;
            clones.addAll(objectsToClone);
            
            for(sObject thisClone : clones)
            {
                mapPreventDuplicate.put(thisClone.Id,null);
                sourceToCloneMap.put(thisClone.getCloneSourceId(),thisClone.Id);
            }
            
            objectIds.addAll(new list<id>(previousSourceToCloneMap.keySet()));
            //get the ids of all these objects.                    
        }
        else
        {
            System.debug('@Developer --> when objectsToClone[0].Id != null:' );
            //get the ids of all these objects.
            /*for(sObject thisObj :objectsToClone)
            {
                objectIds.add(thisObj.Id);
            }*/
            
            System.debug('@Developer --> mapPreventDuplicate:' + mapPreventDuplicate);
            System.debug('@Developer --> mapData:' + mapData);
            
            for(sObject thisObj : objectsToClone)
            {
                System.debug('@Developer --> thisObj.Id:' + thisObj.Id);
                if(thisObj.Id == null){continue;}
               // System.debug('@Developer -->thisObj.getSObjectType()'+thisObj.getSObjectType());
               sObject clonedObject ;
                
                if(!mapPreventDuplicate.containsKey(thisObj.Id)){
                    objectIds.add(thisObj.Id);
                    clonedObject = thisObj.clone(false,true,false,false);
                    String sKey = generateRandomString(15);
                    mapPreventDuplicate.put(thisObj.Id,sKey);
                    mapData.put(sKey,clonedObject);
                    clones.add(clonedObject);   
                }
            }    
            
            //insert the clones
            insert clones;
            
            for(sObject thisClone : clones)
            {
                mapPreventDuplicate.put(thisClone.Id,null);
                    sourceToCloneMap.put(thisClone.getCloneSourceId(),thisClone.Id);
            }
        }        
        
        
        System.debug('@Developer --> sourceToCloneMap:' + sourceToCloneMap);
        System.debug('@Developer --> clones:' + clones);
        System.debug('@Developer --> objectIds:' + objectIds);
        
        
        //figure out what kind of object we are dealing with
        string relatedObjectType = objectsToClone[0].Id.getSobjectType().getDescribe().getName();
        //System.debug('@Developer --> relatedObjectType'+ relatedObjectType);
        
        //Describes this object type so we can deduce it's child relationships
        Schema.DescribeSObjectResult objectDescribe = globalDescribeMap.get(relatedObjectType).getDescribe();
        
        //get this objects child relationship types
        List<Schema.ChildRelationship> childRelationships = objectDescribe.getChildRelationships();
        
        //system.debug('\n\n\n-------------------- ' + objectDescribe.getName() + ' has ' + childRelationships.size() + ' child relationships');
        
        //then have to iterate over every child relationship type, and every record of that type and clone them as well. 
        for(Schema.ChildRelationship thisRelationship : childRelationships)
        { 
            
            Schema.DescribeSObjectResult childObjectDescribe = thisRelationship.getChildSObject().getDescribe();
            string relationshipField = thisRelationship.getField().getDescribe().getName();
            
            if(childObjectDescribe.getName() == 'Integration_Logs__c') {continue;}
            
//            System.debug('@Developer --> childObjectDescribe.getName()'+ childObjectDescribe.getName());
            try
            {
               // system.debug('\n\n\n-------------------- Looking at ' + childObjectDescribe.getName() + ' which is a child object of ' + objectDescribe.getName());
                
                if(!childObjectDescribe.isCreateable() || !childObjectDescribe.isQueryable() || !childObjectDescribe.isCustom())
                {
                   // system.debug('-------------------- Object is not one of the following: queryable, creatable, or custom. Skipping attempting to clone this object');
                    continue;
                }
                 //System.debug('@Developer --> childObjectDescribe.getName()'+ childObjectDescribe.getName());
                
                if(Limits.getQueries() >= Limits.getLimitQueries())
                {
                    system.debug('\n\n\n-------------------- !!!! ----- Governor limits hit. Must abort. ----- !!!!');
                    return clones;
                }
                
                System.debug('@Developer -->related object :'+childObjectDescribe.getName() );
                
                //create a select all query from the child object type
                string childDataQuery = buildSelectAllStatment(childObjectDescribe.getName());
                
                //add a where condition that will only find records that are related to this record. The field which the relationship is defined is stored in the maps value
                childDataQuery+= ' where '+relationshipField+ ' in :objectIds';
                //System.debug('@Developer --> childDataQuery:'+ childDataQuery);
                
                //get the details of this object
                list<sObject> childObjectsWithData = database.query(childDataQuery);
                
                if(!childObjectsWithData.isEmpty())
                {               
                    map<id,id> childRecordSourceToClone = new map<id,id>();
                    
                    System.debug('@Developer --> mapPreventDuplicate:' + mapPreventDuplicate);
                    System.debug('@Developer --> mapData:' + mapData);
                    for(sObject thisChildObject : childObjectsWithData)
                    {
                        //System.debug('@Developer --> thisChildObject.Id:' + thisChildObject.Id);
                                                
                         sObject newClone ;
                        if(!mapPreventDuplicate.containsKey(thisChildObject.Id)){
                             childRecordSourceToClone.put(thisChildObject.Id,null);
                            //clone the object
                            newClone = thisChildObject.clone(false,true,false,false);
                            
                            String sKey = generateRandomString(15);
                            mapPreventDuplicate.put(thisChildObject.Id,sKey);
                            mapData.put(sKey,newClone);
                            
                            //since the record we cloned still has the original parent id, we now need to update the clone with the id of it's cloned parent.
                            //to do that we reference the map we created above and use it to get the new cloned parent.                        
                            ////system.debug('\n\n\n----------- Attempting to change parent of clone....');
                            
                            id newParentId = sourceToCloneMap.get((id) thisChildObject.get(relationshipField));
                            
                            ////system.debug('Old Parent: ' + thisChildObject.get(relationshipField) + ' new parent ' + newParentId);
                            
                            //write the new parent value into the record
                            newClone.put(thisRelationship.getField().getDescribe().getName(),newParentId );
                            
                            System.debug('@Developer --> newClone:' + newClone);
                            //add this new clone to the list. It will be inserted once the deepClone function is called again. I know it's a little odd to not just insert them now
                            //but it save on redudent logic in the long run.
                            newClones.add(newClone);  
                        } 
                    }  
                    //now we need to call this function again, passing in the newly cloned records, so they can be inserted, as well as passing in the ids of the original records
                    //that spawned them so the next time the query can find the records that currently exist that are related to the kind of records we just cloned.                
                    
                    //System.debug('@Developer --> newClones:' + newClones);
                    System.debug('@Developer --> childRecordSourceToClone:' + childRecordSourceToClone);
                    list<sObject > lstIntermediate = deepCloneBatched(newClones,childRecordSourceToClone);
                    System.debug('@Developer --> lstIntermediate:' + lstIntermediate);
                    clones.addAll(lstIntermediate);        
                    newClones.clear();
                }                    
            }
            catch(exception e)
            {
                system.debug('\n\n\n---------------------- Error attempting to clone child records of type: ' + childObjectDescribe.getName());
                system.debug(e); 
            }            
        }
        
        
        return clones;
    }
    
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    /**
* @description create a string which is a select statment for the given object type that will select all fields. Equivilent to Select * from objectName ins SQL
* @param objectName the API name of the object which to build a query string for
* @return string a string containing the SELECT keyword, all the fields on the specified object and the FROM clause to specify that object type. You may add your own where statments after.
**/
    public static string buildSelectAllStatment(string objectName){ return buildSelectAllStatment(objectName, new list<string>());}
    public static string buildSelectAllStatment(string objectName, list<string> extraFields)
    {       
        // Initialize setup variables
        String query = 'SELECT ';
        String objectFields = String.Join(new list<string>(Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().keySet()),',');
        if(extraFields != null)
        {
            objectFields += ','+String.Join(extraFields,',');
        }
        
        objectFields = objectFields.removeEnd(',');
        
        query += objectFields;
        
        // Add FROM statement
        query += ' FROM ' + objectName;
        
        return query;   
    }
   
 
}