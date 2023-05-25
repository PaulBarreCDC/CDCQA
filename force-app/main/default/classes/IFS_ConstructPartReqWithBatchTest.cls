@isTest
private class IFS_ConstructPartReqWithBatchTest{          
   static testMethod void generateReq(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];
        BGR_Attribute_lookup_Details__c oBGRAttribute = new BGR_Attribute_lookup_Details__c();
        oBGRAttribute.Name='bga001';
        oBGRAttribute.Attribute__c='RGEUNT';
        oBGRAttribute.Text__c='psig';
        oBGRAttribute.Numval1__c = 0;
        oBGRAttribute.Numval2__c = 20;
        insert oBGRAttribute;
        List<SBQQ__QuoteLine__c> quoteLines=[Select Id,SBQQ__ProductCode__c, isIFSManaged__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=: quote.Id];
        Map<Id,HandlerInterface> genUtilMap = new Map<id,HandlerInterface>();
        Integer recordsProcessed = 0;
        if(quoteLines.size()>0){    
            for(SBQQ__QuoteLine__c eachQuoteLine : quoteLines){ 
                Id currentId=wizardBaseDataProcessor.getCustomObjectIDbyLine(eachQuoteLine.Id);
                GenericUtilityForXML generic=new GenericUtilityForXML();
                HandlerInterface genUtil = generic.getUtilityInstance(eachQuoteLine.SBQQ__ProductCode__c,currentId);                    
                genUtilMap.put(eachQuoteLine.Id,genUtil);
                        
                recordsProcessed = recordsProcessed + 1;
            }
        }
         if(recordsProcessed > 0){            
            if(quoteLines.size()>0){                
                List<String> batchList=new List<String>();  
                for(SBQQ__QuoteLine__c quoteLine : quoteLines){                    
                        if(quoteLine.SBQQ__ProductCode__c!='PS' || !quoteLine.isIFSManaged__c){
                            batchList.add(quoteLine.Id+'_'+'getEngineeringParts');
                            batchList.add(quoteLine.Id+'_'+'getInventoryPartDetails');
                            batchList.add(quoteLine.Id+'_'+'getSalesParts');
                            batchList.add(quoteLine.Id+'_'+'getPurchasePart');
                            batchList.add(quoteLine.Id+'_'+'getPurchasePartSuppliers');
                            batchList.add(quoteLine.Id+'_'+'getProductCatalog');
                            batchList.add(quoteLine.Id+'_'+'getStructureXML');
                            batchList.add(quoteLine.Id+'_'+'GetRoutingDetails');
                            batchList.add(quoteLine.Id+'_'+'GetControlPlanDetails');
                        }                       
                }                
                try{
                if(batchList.size() > 0){   
                    IFS_ConstructPartReqWithBatch  partReq = new IFS_ConstructPartReqWithBatch(quote.Id,accLst.Id,genUtilMap,batchList,false);                    
                    Database.executeBatch(partReq);                    
                }
                }catch(Exception e){
                    System.debug('Exception :'+e.getMessage());
                }
            }
        }        
        Test.stopTest();
    }
    static testMethod void generateReq2(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        Account accLst = [Select Id,Name FROM Account WHERE Name='TEMCO INC TEST' limit 1]; 
        SBQQ__Quote__c  quote = [Select Id,Name FROM SBQQ__Quote__c  WHERE SBQQ__Account__c=:accLst.Id limit 1];
        BGR_Attribute_lookup_Details__c oBGRAttribute = new BGR_Attribute_lookup_Details__c();
        oBGRAttribute.Name='bga001';
        oBGRAttribute.Attribute__c='RGEUNT';
        oBGRAttribute.Text__c='psig';
        oBGRAttribute.Numval1__c = 0;
        oBGRAttribute.Numval2__c = 20;
        insert oBGRAttribute;
        List<SBQQ__QuoteLine__c> quoteLines=[Select Id,SBQQ__ProductCode__c, isIFSManaged__c FROM SBQQ__QuoteLine__c where SBQQ__Quote__c=: quote.Id];
        Map<Id,HandlerInterface> genUtilMap = new Map<id,HandlerInterface>();
        Integer recordsProcessed = 0;
        if(quoteLines.size()>0){    
            for(SBQQ__QuoteLine__c eachQuoteLine : quoteLines){ 
                Id currentId=wizardBaseDataProcessor.getCustomObjectIDbyLine(eachQuoteLine.Id);
                GenericUtilityForXML generic=new GenericUtilityForXML();
                HandlerInterface genUtil = generic.getUtilityInstance(eachQuoteLine.SBQQ__ProductCode__c,currentId);                    
                genUtilMap.put(eachQuoteLine.Id,genUtil);
                        
                recordsProcessed = recordsProcessed + 1;
            }
        }
         if(recordsProcessed > 0){            
            if(quoteLines.size()>0){                
                List<String> batchList=new List<String>();  
                for(SBQQ__QuoteLine__c quoteLine : quoteLines){                    
                        if(quoteLine.SBQQ__ProductCode__c!='PS' || !quoteLine.isIFSManaged__c){
                            batchList.add(quoteLine.Id+'_'+'getEngineeringParts');
                            batchList.add(quoteLine.Id+'_'+'getInventoryPartDetails');
                            batchList.add(quoteLine.Id+'_'+'getSalesParts');
                            batchList.add(quoteLine.Id+'_'+'getPurchasePart');
                            batchList.add(quoteLine.Id+'_'+'getPurchasePartSuppliers');
                            batchList.add(quoteLine.Id+'_'+'getProductCatalog');
                            batchList.add(quoteLine.Id+'_'+'getStructureXML');
                            batchList.add(quoteLine.Id+'_'+'GetRoutingDetails');
                            batchList.add(quoteLine.Id+'_'+'GetControlPlanDetails');
                        }                       
                }                
                try{
                if(batchList.size() > 0){   
                    IFS_ConstructPartReqWithBatch  partReq = new IFS_ConstructPartReqWithBatch(quote.Id,accLst.Id,genUtilMap,batchList,true);                    
                    Database.executeBatch(partReq);                    
                }
                }catch(Exception e){
                    System.debug('Exception :'+e.getMessage());
                }
            }
        }        
        Test.stopTest();
    }
}