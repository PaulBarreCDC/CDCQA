/***************************************************************************************************************
* @Name         MassConfiguratorUpdateProcess
* @Author       Ashim Kumar Sahoo <ashim.kumar@apexit.com>
* @Date         10/16/2020
* @Description  This class is a batch class which updates the respective QuoteLines, and all associated Configurator records
*				Holders - Updates the description and diagram details in Holders__c, Holder_Drawings__c & QuoteLine
*****************************************************************************************************************/
public class MassConfiguratorUpdateProcess implements Database.Batchable<sObject>, Database.Stateful  {
    private String errorDetails;
    private String prodCode;
    private String quoteId;
    private Set<String> quoteLineIds;   
    private GenericUtilityForXML generic;
    private HandlerInterface genUtil;
    private Map<Id, SBQQ__QuoteLine__c> quoteLine;
    
    /*******************************************************************************************************
    * @Description  This method is a constructor which set the Product Code and QuoteLine Id
    * @Param 1		String - prodCode (it can be null also as both parameters are not mandatory)
    * @Param 2		Set<String> - quoteLineIds
    * @Return       N/A
    * @Example     
    * MassConfiguratorUpdateInitiation('PRODUCT_CODE', 'QUOTE_LINE_IDS')
    *********************************************************************************************************/
    public MassConfiguratorUpdateProcess() {}
    public MassConfiguratorUpdateProcess(String prodCode, Set<String> quoteLineIds, String quoteId) {
        
        this.quoteId = quoteId;
        this.prodCode = prodCode;
        this.quoteLineIds = quoteLineIds;
        system.debug('Test quoteLineIds::'+quoteLineIds.size());
        quoteLine = new Map<Id, SBQQ__QuoteLine__c>();
        errorDetails = '';
    }
    
    /*******************************************************************************************************
    * @Description  This method fetched SBQQ__QuoteLine__c records based on the QuoteLine Ids, and 
    * 				based on the product type, specific logical flows are executed
    * @Param 1		Database.BatchableContext - ctx
    * @Return       Database.QueryLocator
    *********************************************************************************************************/
    public Database.QueryLocator start(Database.BatchableContext ctx){
        
        system.debug('Test1 quoteLineIds:'+quoteLineIds.size());
        system.debug('Test2 quoteLineIds:'+quoteLineIds);
        
        Database.QueryLocator ql;
        String soql = null;
        //pick the records whose desc override or image override are false (OR condition)
        
        if(prodCode == 'HLD') {
            
            soql = 'SELECT Id, Quote_Line__c, Diagram_Override__c, Quote_Descriptions_Override__c '+
                ' FROM Holders__c  '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND Finish_Configuration__c = true ';
            
        } else if(prodCode == 'BGR') {
            
            soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, Quote_Line__r.Name '+
                ' FROM BGR__c  '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND Configuration_Complete__c = true ';  
            
        } else if(prodCode == 'WGB') {
            
            soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, Quote_Line__r.Name '+
                ' FROM WasteGasBurner__c '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND IsConfig__c = true ';   
            
        } else if(prodCode == 'FlameProducts') {
            
            soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, PC__c, Quote_Line__r.Name '+
                ' FROM Flame_Product__c '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND IsConfig__c = true ';
            
        } else if(prodCode == 'RLFVLV') {
            
            soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, PC__c, Quote_Line__r.Name '+
                ' FROM Relief_Valve__c '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND Finish_Configuration_Flag__c = true ';

        } else if(prodCode == 'RD') {
            
            soql = 'SELECT Id, Quote_Line__c, Quote_Line__r.Name, Quote_Descriptions_Override__c, (Select id, OA__c, OB__c, OW__c from RD_Outputs__r) '+
                ' FROM Rupture_Disc__c '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND Finish_Configuration_Flag__c = true ';
            
        } else if(prodCode == 'PS') {
            
            soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, Quote_Line__r.Name '+
                ' FROM Part_Selector__c '+
                ' WHERE Quote_Line__c IN :quoteLineIds AND Finish_Configuration_Flag__c = true ';
        }
        
        if(soql != null) {
            
            /*
            if(prodCode == 'RD') {
                String qlid = 'a1Q0v000000elVCEAY';
                soql = 'SELECT Id, Quote_Descriptions_Override__c, Quote_Line__c, Quote_Line__r.Name, (Select id, OA__c, OB__c, OW__c from RD_Outputs__r)  FROM Rupture_Disc__c WHERE Quote_Line__c = :qlid AND Finish_Configuration_Flag__c = true ';
            }
			*/
            ql = Database.getQueryLocator(soql);
        }
        return ql;
    }
    
    /*******************************************************************************************************
    * @Description  This method receives the SBQQ__QuoteLine__c records and process it based on each product workflow
    * 				Holders - Updates the description and diagram details in Holders__c, Holder_Drawings__c & QuoteLine
    * 
    * @Param 1		Database.BatchableContext - ctx
    * @Param 2		List<sObject> - records
    * @Return       N/A
    *********************************************************************************************************/
    public void execute(Database.BatchableContext ctx, List<sObject> records) {
        
        if(records.size() > 0) {
            
            Map<String, Object> res;
            Map<Id, SBQQ__QuoteLine__c> tmpQuoteLineDetails;
            SBQQ__QuoteLine__c tmpQuoteLineDetail;
            BGROutputUtility bgrUtility;
            ConfigureWasteGasBurner wgbCntrl;
            List<ConfigureWasteGasBurner.QuoteDescriptionWrapper> descWrapper;
                
            if(prodCode == 'HLD') {
                
                List<Holders__c> hldRecords = (List<Holders__c>) records;
                for(Holders__c hld: hldRecords) {
                    
                    res = ConfigHolderUtilityBatch.updateHolderRecords(hld);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetails = (Map<Id, SBQQ__QuoteLine__c>) res.get('QUOTE_LINE');
                        quoteLine.putAll(tmpQuoteLineDetails);
                    }
                }
                
            } else if(prodCode == 'WGB') {
                
                List<WasteGasBurner__c> wgbRecords = (List<WasteGasBurner__c>) records;
                for(WasteGasBurner__c wgbRecord: wgbRecords) {
            		
                    res = ConfigWGBUtilityBatch.updateWGBRecords(wgbRecord);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetail = (SBQQ__QuoteLine__c) res.get('QUOTE_LINE');
                        quoteLine.put(tmpQuoteLineDetail.Id, tmpQuoteLineDetail);
                        
                    }
                }
                
            } else if(prodCode == 'BGR') {
                
                List<BGR__c> bgrRecords = (List<BGR__c>) records;
                system.debug('bgrRecords:'+bgrRecords);
                for(BGR__c bgrRecord: bgrRecords) {
            		
                    res = ConfigBGRUtilityBatch.updateBGRRecords(bgrRecord);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetail = (SBQQ__QuoteLine__c) res.get('QUOTE_LINE');
                        quoteLine.put(tmpQuoteLineDetail.Id, tmpQuoteLineDetail);
                        
                    }
                }
                
            } else if(prodCode == 'FlameProducts') {
                
                List<Flame_Product__c> bgrRecords = (List<Flame_Product__c>) records;
                for(Flame_Product__c record: bgrRecords) {
            		
                    res = ConfigFAUtilityBatch.updateFARecords(record);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetail = (SBQQ__QuoteLine__c) res.get('QUOTE_LINE');
                        quoteLine.put(tmpQuoteLineDetail.Id, tmpQuoteLineDetail);
                    }
                }
                
            } else if(prodCode == 'RLFVLV') {
                
                List<Relief_Valve__c> rvRecords = (List<Relief_Valve__c>) records;
                for(Relief_Valve__c rvRecord: rvRecords) {
            		
                    res = ConfigRVUtilityBatch.updateRVRecords(rvRecord);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetail = (SBQQ__QuoteLine__c) res.get('QUOTE_LINE');
                        quoteLine.put(tmpQuoteLineDetail.Id, tmpQuoteLineDetail);
                        
                    }
                }
                
            } else if(prodCode == 'PS') {
                
                List<Part_Selector__c> psRecords = (List<Part_Selector__c>) records;
                for(Part_Selector__c psRecord: psRecords) {
            		
                    res = ConfigPSUtilityBatch.updatePSRecords(psRecord);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetail = (SBQQ__QuoteLine__c) res.get('QUOTE_LINE');
                        quoteLine.put(tmpQuoteLineDetail.Id, tmpQuoteLineDetail);
                        
                    }
                }
                
            } else if(prodCode == 'RD') {
                
                List<Rupture_Disc__c> rdRecords = (List<Rupture_Disc__c>) records;
                for(Rupture_Disc__c rdRecord: rdRecords) {
            		
                    res = ConfigRDUtilityBatch.updateRDRecords(rdRecord);
                    
                    if(res.get('ERROR_DETAILS') != null && res.get('ERROR_DETAILS') != '') {
                        
                        errorDetails += res.get('ERROR_DETAILS')+'\n';
                    }
                    
                    if(res.get('QUOTE_LINE') != null) {
                        
                        tmpQuoteLineDetail = (SBQQ__QuoteLine__c) res.get('QUOTE_LINE');
                        quoteLine.put(tmpQuoteLineDetail.Id, tmpQuoteLineDetail);
                        
                    }
                }              
            }
        }
    }
    
    /*******************************************************************************************************
    * @Description  This method gets invoked atlast where the request for updating QL is invoked. 
    * 				Email notifications is being sent to the submitter on the on batch job process details.
    * @Param 1		Database.BatchableContext - ctx
    * @Return       N/A
    *********************************************************************************************************/
    public void finish(Database.BatchableContext ctx){
        
        if(quoteLine.size() > 0) {
            
            //update QL details
            //DateTime dt = System.now();
            //DateTime earlier = dt.addMinutes(1);
            //String execTime = earlier.second()+' '+earlier.minute()+' '+earlier.hour()+' '+earlier.day()+' '+earlier.month()+' ? '+earlier.year();
            //System.schedule('Mass QuoteLine Update '+UserInfo.getName()+' '+dt, execTime, new MassConfiguratorUpdateProcess());
			
            //This is creating issue - too many queuable jobs
            //System.enqueueJob(new MassConfiguratorFutureEvnts());
            
            //Initimate to user on job completion
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                              TotalJobItems, CreatedBy.Email
                              FROM AsyncApexJob WHERE Id = :ctx.getJobId()];
            
            String batchExecDetails = 'The batch is processed ' + a.TotalJobItems +
                 ' batches with '+ a.NumberOfErrors + ' failures. (Total QuoteLines: '+quoteLine.size()+')';
            String batchStatus = 'Completed';
            
            List<Regeneration_Request_Details__c> regenerationReqDetails = [SELECT Id, Job_Details__c, Status__c FROM Regeneration_Request_Details__c WHERE Batch_Job_ID__c = :ctx.getJobId()];
            
            if(regenerationReqDetails.size() > 0) {
                
                if(a.NumberOfErrors > 0) {
                    
                    batchStatus = 'Failed';
                    
                    batchExecDetails += '\n'+errorDetails;
                }
                regenerationReqDetails[0].Job_Details__c = batchExecDetails;
                
                //if(quoteId != null) {
                	
                    regenerationReqDetails[0].Status__c = batchStatus;
                //}
                update regenerationReqDetails;
            }
            
            List<QuoteLine_Mass_Update__c> qlMassUpdateRecords = new List<QuoteLine_Mass_Update__c>();
            QuoteLine_Mass_Update__c qlMassUpdateRecord;
            for(SBQQ__QuoteLine__c ql: quoteLine.values()) {
                
                qlMassUpdateRecord = new QuoteLine_Mass_Update__c();
                qlMassUpdateRecord.Quote_Line__c = ql.Id;
                qlMassUpdateRecord.QuoteLine_Description__c = ql.SBQQ__Description__c;
                qlMassUpdateRecord.Drawing_ID__c = ql.DrawingID__c;
                qlMassUpdateRecord.DimA__c = ql.DimA__c;
                qlMassUpdateRecord.DimB__c = ql.DimB__c;
                qlMassUpdateRecord.DimC__c = ql.DimC__c;
                qlMassUpdateRecord.DimD__c = ql.DimD__c;
                qlMassUpdateRecord.DimE__c = ql.DimE__c;
                qlMassUpdateRecord.DimF__c = ql.DimF__c;
                
                qlMassUpdateRecord.Batch_Job_ID__c = ctx.getJobId();
                qlMassUpdateRecord.Batch_Status__c = batchStatus;
                qlMassUpdateRecord.Batch_Job_Details__c = batchExecDetails;
                qlMassUpdateRecord.Trigger_QL_Update__c = false;
                if(quoteId == null) {
                    
                    //qlMassUpdateRecord.Trigger_QL_Update__c = true;
                }
                qlMassUpdateRecords.add(qlMassUpdateRecord);
            }
            
            if(qlMassUpdateRecords.size() > 0) {
            
                insert qlMassUpdateRecords;
            }
            
            //if(quoteId != null) {
                Map<String, String> prodMapping = new Map<String, String>();
                prodMapping.put('HLD', 'Holders');
                prodMapping.put('WGB', 'Waste Gas Burner');
                prodMapping.put('BGR', 'Blanket Gas Regulator');
                prodMapping.put('RLFVLV', 'Relief Valve');
                prodMapping.put('FlameProducts', 'Flame Products');
                prodMapping.put('PS', 'Part Selector');
                prodMapping.put('RD', 'Rupture Disc');
                
                // Send an email to the submitter notifying of job completion.
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject(prodMapping.get(prodCode) +' ReGeneration Status ' + a.Status);
                mail.setPlainTextBody(batchExecDetails);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            //}
        }
    }
    /*
    public void execute(SchedulableContext SC) {
 		
        Database.executeBatch(new MassQLUpdateProcess());
    }
    */
}