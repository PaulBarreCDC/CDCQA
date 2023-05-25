/***************************************************************************************************************
* @Name         MassConfiguratorUpdateInitiation
* @Author       Ashim Kumar Sahoo <ashim.kumar@apexit.com>
* @Date         10/16/2020
* @Description  This class is a batch class which groups the quote lines (ID) based on the product (Map<String, Set<String>>)
*				Once the grouping is completed, it creates multiple batch jobs based on the unique product.
*****************************************************************************************************************/
public class MassConfiguratorUpdateInitiation implements Database.Batchable<sObject>, Database.Stateful {
    
    private HandlerInterface genUtil; 
    private String quoteId;
    private String productType;
    Map<String, Set<String>> prodCodesAndQLDet = new Map<String, Set<String>>();
    
    /*******************************************************************************************************
    * @Description  This method is a constructor which either set the quote ID or the product type
    * @Param 1		String - productType (mandatory)
    * @Param 2		Id - quoteId (optional)
    * @Return       N/A
    * @Example     
    * MassConfiguratorUpdateInitiation('PRODUCT_TYPE', 'QUOTE_ID')
    *********************************************************************************************************/
    public MassConfiguratorUpdateInitiation(String productType, Id quoteId) {
        
        if(quoteId != null) {
            
            this.quoteId = quoteId;
        }
        
        if(productType != null) {
            
            this.productType = productType;
        }
    }
    
    /*******************************************************************************************************
    * @Description  This method fetched SBQQ__QuoteLine__c records based on the quote ID or Product Type 
    * @Param 1		Database.BatchableContext - ctx
    * @Return       Database.QueryLocator
    *********************************************************************************************************/
    public Database.QueryLocator start(Database.BatchableContext ctx){
        
        Database.QueryLocator ql;
        List<String> qStatuses = new List<String>();
        List<String> qlStatuses = new List<String>();
        List<String> oppStages = new List<String>();
        
        String oppStage = Label.ReGeneration_Opportunity_Stage_Condition;
        if(oppStage != null) {
            
            oppStages = oppStage.split(',');
        }
        
        String qlStatus = Label.ReGeneration_QuoteLine_Status_Condition;
        if(qlStatus != null) {
            
            qlStatuses = qlStatus.split(',');
        }
        
        String qStatus = Label.ReGeneration_Quote_Status_Condition;
        if(qStatus != null) {
            
            qStatuses = qStatus.split(',');
        }
        
        String sql = 'SELECT Id, SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c WHERE Id != null ';
        if(productType != null) {
            
            //sql += ' AND SBQQ__Product__r.Name = :productType ';
            sql += ' AND SBQQ__ProductCode__c = :productType ';
        }
        
        if(quoteId != null) {
            
            sql += ' AND SBQQ__Quote__c = :quoteId ';
        } 
        
        if(qStatuses.size() > 0) {
            
            sql += ' AND SBQQ__Quote__r.SBQQ__Status__c IN :qStatuses';
        }
        
        if(qlStatuses.size() > 0) {
            
            sql += ' AND Line_Status__c IN :qlStatuses';
        }
        
        if(oppStages.size() > 0) {
            
            sql += ' AND Opportunity_Stage__c IN :oppStages';
        }
        
        //String qlId = 'a1N8A00000G1HFnUAN';
        //sql = 'SELECT Id, SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c WHERE Id = :qlId';
        
        system.debug('oppStages:'+oppStages);
        system.debug('qlStatuses:'+qlStatuses);
        system.debug('qStatuses:'+qStatuses);
        system.debug('productType:'+productType);
        
        //String qlid = 'a1N8A00000GIl6KUAT';
        //sql = 'SELECT Id, SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c WHERE Id = :qlid';
        
        system.debug('sql:'+sql);
        ql = Database.getQueryLocator(sql);
        return ql;
    }
    
    /*******************************************************************************************************
    * @Description  This method receives the SBQQ__QuoteLine__c records and process it
    * 				It groups the quote lines (ID) based on the product and creates a Map<String, Set<String>>
    * 				Set<String> contains the respective QuoteLine IDs
    * @Param 1		Database.BatchableContext - ctx
    * @Param 2		List<SBQQ__QuoteLine__c> - qlRecords
    * @Return       N/A
    *********************************************************************************************************/
    public void execute(Database.BatchableContext ctx, List<SBQQ__QuoteLine__c> qlRecords) {
        
        system.debug('prodCode Tot:'+qlRecords.size());
        Set<String> tmpValues;
        Map<String, String> prodCodeObjectMappingDetails = wizardBaseDataProcessor.mapProdwithObject;
        for(SBQQ__QuoteLine__c quoteLineDet: qlRecords) {
            
            if(prodCodesAndQLDet.get(quoteLineDet.SBQQ__ProductCode__c) != null) {
                
                tmpValues = prodCodesAndQLDet.get(quoteLineDet.SBQQ__ProductCode__c);
                
            } else {
                
                tmpValues = new Set<String>();
            }
            tmpValues.add(quoteLineDet.Id);
            prodCodesAndQLDet.put(quoteLineDet.SBQQ__ProductCode__c, tmpValues);
        }
    }
    
    /*******************************************************************************************************
* @Description  This method gets the QL details which is grouped by configurator, and creates multiple 
* 				batch jobs based on the unique product.
* @Param 1		Database.BatchableContext - ctx
* @Return       N/A
*********************************************************************************************************/
    public void finish(Database.BatchableContext ctx){
        
        Integer maxRecords = 10; //Label.Regeneration_Records_Chunk
        List<Regeneration_Request_Details__c> regenerationReqDetails;
        List<Regeneration_Request_Details__c> regenerationDetails = new List<Regeneration_Request_Details__c>();
        Regeneration_Request_Details__c rrd;
        String parentJobId = '';
        Id batchJobId;
        //Set<String> checkRecords;
        
        parentJobId = '';
        regenerationReqDetails = [SELECT Id FROM Regeneration_Request_Details__c WHERE Requested_By__c = :UserInfo.getUserId() ORDER BY Id DESC LIMIT 1];
        system.debug('regenerationReqDetails:'+regenerationReqDetails);
        if(regenerationReqDetails.size() > 0) {
            
            parentJobId = regenerationReqDetails[0].Id;
        }
        
        for(String prodCode: prodCodesAndQLDet.keySet()) {
            
            Set<String> checkRecords = prodCodesAndQLDet.get(prodCode);
            system.debug('TOT PRODS:'+ checkRecords.size());
            
            
            //Set<String> totalRecordChunksTmp = prodCodesAndQLDet.get(prodCode);
            //List<String> totalRecordChunks = new List<String>();
            //totalRecordChunks.addAll(totalRecordChunksTmp);
            //Set<String> recordChunks = new Set<String>();
            
            /*
Integer cntr = 0;
for(Integer i = 0; i < totalRecordChunks.size(); i++) {
cntr++;
if(cntr == maxRecords) {

if(recordChunks.size() > 0) {

MassConfiguratorUpdateProcess obj = new MassConfiguratorUpdateProcess(prodCode, recordChunks);
batchJobId = Database.executeBatch(obj, 10);  

rrd = new Regeneration_Request_Details__c();
if(parentJobId != null) {

rrd.Parent_Job__c = parentJobId;
}
rrd.Product_Name__c  	= productType;
rrd.Product_Code__c 	= prodCode;
rrd.Batch_Job_ID__c 	= batchJobId;
rrd.Quote_No__c 		= quoteId;
rrd.Requested_By__c 	= UserInfo.getUserId();
rrd.Status__c  			= 'Pending';
insert rrd;
//regenerationDetails.add(rrd);
}
recordChunks = new Set<String>();
cntr = 1;
}

recordChunks.add(totalRecordChunks[i]);
}
*/
            
            if(prodCodesAndQLDet.get(prodCode) != null) {
                
                MassConfiguratorUpdateProcess obj = new MassConfiguratorUpdateProcess(prodCode, prodCodesAndQLDet.get(prodCode), quoteId);
                if(prodCode == 'RD') {
                    
                    batchJobId = Database.executeBatch(obj, 1);
                    
                } else {
                	
                    batchJobId = Database.executeBatch(obj, 10);
                }
                
                rrd = new Regeneration_Request_Details__c();
                if(parentJobId != null) {
                    
                    rrd.Parent_Job__c = parentJobId;
                }
                rrd.Product_Name__c  	= productType;
                rrd.Product_Code__c 	= prodCode;
                rrd.Batch_Job_ID__c 	= batchJobId;
                rrd.Quote_No__c 		= quoteId;
                rrd.Requested_By__c 	= UserInfo.getUserId();
                rrd.Status__c  			= 'Pending';
                //regenerationDetails.add(rrd);
                insert rrd;
            }
            
            //List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id FROM SBQQ__QuoteLine__c ORDER BY ID DESC LIMIT 10];
            //System.enqueueJob(new MassConfiguratorFutureEvnts(quoteLines));            
        }
    }
}