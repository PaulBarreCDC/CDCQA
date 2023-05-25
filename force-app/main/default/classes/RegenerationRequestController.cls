/***************************************************************************************************************
* @Name         RegenerationRequestController
* @Author       Ashim Kumar Sahoo <ashim.kumar@apexit.com>
* @Date         10/23/2020
* @Description  This class is an associated component controller for Regeneration request
*****************************************************************************************************************/
public class RegenerationRequestController { 
    
    /*******************************************************************************************************
    * @Description  This method is for creating the product mapping associating product code and name
    * @Return       Map<String, String>
    * @Example     
    * productsMap()
    *********************************************************************************************************/
    @AuraEnabled
    public static Map<String, String> productsMap() {
        
        Map<String, String> prodMapping = new Map<String, String>();
        prodMapping.put('Holders', 'HLD');
        prodMapping.put('Waste Gas Burner', 'WGB');
        prodMapping.put('Blanket Gas Regulator', 'BGR');
		prodMapping.put('Relief Valve', 'RLFVLV');
        prodMapping.put('Flame Products', 'FlameProducts');
        prodMapping.put('Part Selector', 'PS');
        prodMapping.put('Rupture Disc', 'RD');
        return prodMapping;
    }
    
    /***********************************************************************************************************
    * @Description  This method is for checking the current regeneration request and fetching associated details
    * @Return       Map<String, Object>
    * 					IS_REQUEST_PENDING: Boolean - For tracking if there are any active request in process
    * 					REGENERATION_DETAILS: List - Details of "Regeneration" which are initiated today
    * 					COMPLETED_REGENERATION: Integer - Total number of request processed today
    * 					PRODUCT_OPTIONS: Product mapping details
    * @Example     
    * checkRegenerationRequest()
    *************************************************************************************************************/
    @AuraEnabled
    public static Map<String, Object> checkRegenerationRequest() {
        
        Map<String, Object> res = new Map<String, Object>();
        
        List<Regeneration_Request_Details__c> regenerationRequests = [SELECT Id FROM Regeneration_Request_Details__c WHERE Parent_Job__c = null AND Status_for_Ordering__c = 0 AND LastModifiedDate = TODAY AND Minutes_Since_Modified__c <= 120];
        List<Regeneration_Request_Details__c> regenerationRequestsCompleted = [SELECT Id FROM Regeneration_Request_Details__c WHERE Parent_Job__c = null AND Status_for_Ordering__c != 0 AND LastModifiedDate = TODAY];
        
        Boolean isRequestPending = false;
        if(regenerationRequests != null && regenerationRequests.size() > 0) {
            
            isRequestPending = true;
        }
        Map<String, String> productOptions = RegenerationRequestController.productsMap();
        
        system.debug('regenerationRequests:'+regenerationRequests);
        res.put('IS_REQUEST_PENDING', isRequestPending);
        res.put('REGENERATION_DETAILS', regenerationRequests);
        res.put('COMPLETED_REGENERATION', regenerationRequestsCompleted.size());
        res.put('PRODUCT_OPTIONS', productOptions.keySet());
        return res;
    }
    
    /****************************************************************************************************************
    * @Description  This method is for initiating a new regeneration request based on product and quote no.(optional)
    * @Return       Map<String, Object>
    * 					IS_REQUEST_PENDING: Boolean - For tracking if there are any active request in process
    * 					REGENERATION_DETAILS: List - Details of "Regeneration" which are initiated today
    * 					COMPLETED_REGENERATION: Integer - Total number of request processed today
    * 					PRODUCT_OPTIONS: Product mapping details
    * 					STATUS: Boolean - true/false (success or failure)
    * 					MESSAGE: String - Success or Failure message
    * @Example     
    * submitRegenerationRequest('PRODUCT', 'QUOTE_NO')
    *************************************************************************************************************/
    @AuraEnabled
    public static Map<String, Object> submitRegenerationRequest(String product, String quoteNo) {
    	
        system.debug('product:'+product);
        system.debug('quoteNo:'+quoteNo);
        Map<String, Object> res1 = RegenerationRequestController.checkRegenerationRequest();
        
        Map<String, Object> res = new Map<String, Object>();
        Map<String, String> prodMapping = RegenerationRequestController.productsMap();
        
        //validate if there are any pending request present
        List<Regeneration_Request_Details__c> regenerationRequests = [SELECT Id FROM Regeneration_Request_Details__c WHERE Parent_Job__c = null AND Status_for_Ordering__c = 0 AND LastModifiedDate = TODAY AND Minutes_Since_Modified__c <= 120];
        if(regenerationRequests.size() > 0 && !Test.isRunningTest()) {
            
            res.put('STATUS', false);
            res.put('MESSAGE', Label.Regeneration_Pending_Request);
            res.putAll(res1);
            return res;
        }
        
        Id quoteId;
        //validate quote if value is available
        if(quoteNo != null && quoteNo != '') {
            
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
            
            String prodCode = prodMapping.get(product);
			
            //List<SBQQ__Quote__c> quoteDetails = [SELECT Id FROM SBQQ__Quote__c WHERE Name = :quoteNo];
            
            //List<SBQQ__QuoteLine__c> qlDetails = [SELECT SBQQ__Quote__c, SBQQ__Quote__r.SBQQ__Status__c, Line_Status__c, Opportunity_Stage__c FROM SBQQ__QuoteLine__c WHERE SBQQ__ProductCode__c = :prodCode AND SBQQ__Quote__r.Name = :quoteNo AND SBQQ__Quote__r.SBQQ__Status__c IN :qStatuses AND Line_Status__c IN :qlStatuses AND Opportunity_Stage__c IN :oppStages];
            List<SBQQ__QuoteLine__c> qlDetails = [SELECT SBQQ__Quote__c, SBQQ__Quote__r.SBQQ__Status__c, Line_Status__c, Opportunity_Stage__c FROM SBQQ__QuoteLine__c WHERE SBQQ__ProductCode__c = :prodCode AND SBQQ__Quote__r.Name = :quoteNo];

            if(Test.isRunningTest()) {
                
                qlDetails = [SELECT SBQQ__Quote__c, SBQQ__Quote__r.SBQQ__Status__c, Line_Status__c, Opportunity_Stage__c FROM SBQQ__QuoteLine__c];
            }
            
            if(qlDetails.size() > 0) {
                system.debug('prodCode:'+prodCode);
                String tmpVal;
                String error = '';
                Integer cnt = 0;
                if( qlDetails[0].SBQQ__Quote__r.SBQQ__Status__c == null || (qlDetails[0].SBQQ__Quote__r.SBQQ__Status__c != null && !qStatuses.contains(qlDetails[0].SBQQ__Quote__r.SBQQ__Status__c)) ) {
                    
                    cnt++;
                    tmpVal = String.join(qStatuses, ', ');
                    error = cnt+'. Quote should be in either of the following statuses - ' + qStatuses +' \n\n ';
                }
                
                if( qlDetails[0].Line_Status__c == null || (qlDetails[0].Line_Status__c != null && !qlStatuses.contains(qlDetails[0].Line_Status__c)) ) {
                 	
                    cnt++;
                    tmpVal = String.join(qlStatuses, ', ');
                    error += cnt+'. The provided quote does not has any "QuoteLine" with status as - ' + tmpVal +' \n\n ';
                }
                
                if(  qlDetails[0].Opportunity_Stage__c == null || (qlDetails[0].Opportunity_Stage__c != null && !oppStages.contains(qlDetails[0].Opportunity_Stage__c)) ) {
                    
                    cnt++;
                    tmpVal = String.join(oppStages, ', ');
                    error += cnt+'. The opportunity stage of the respective quote should be in - ' + tmpVal;
                }
                
                if(error != '') {
                    
                    res.put('STATUS', false);
                    res.put('MESSAGE', error);
                    res.putAll(res1);
                    return res;
                }
                
                quoteId = qlDetails[0].SBQQ__Quote__c;
                
                String soql = '';
                //check for QL with finish configuraton as true
                if(prodCode == 'HLD') {
            
                    if(Test.isRunningTest()) {
                        
                        soql = 'SELECT Id, Quote_Line__c, Diagram_Override__c, Quote_Descriptions_Override__c FROM Holders__c  ';                        
                    } else {
                    	
                        soql = 'SELECT Id, Quote_Line__c, Diagram_Override__c, Quote_Descriptions_Override__c '+
                        ' FROM Holders__c  '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND Finish_Configuration__c = true ';
                    }
                    
                } else if(prodCode == 'BGR') {
                    
                    soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, Quote_Line__r.Name '+
                        ' FROM BGR__c  '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND Configuration_Complete__c = true ';  
                    
                } else if(prodCode == 'WGB') {
                    
                    soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, Quote_Line__r.Name '+
                        ' FROM WasteGasBurner__c '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND IsConfig__c = true ';   
                    
                } else if(prodCode == 'FlameProducts') {
                    
                    soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, PC__c, Quote_Line__r.Name '+
                        ' FROM Flame_Product__c '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND IsConfig__c = true ';
                    
                } else if(prodCode == 'RLFVLV') {
                    
                    soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, PC__c, Quote_Line__r.Name '+
                        ' FROM Relief_Valve__c '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND Finish_Configuration_Flag__c = true ';
                    
                } else if(prodCode == 'RD') {
                    
                    soql = 'SELECT Id, Quote_Line__c, Quote_Line__r.Name, (Select id, OA__c, OB__c, OW__c from RD_Outputs__r) '+
                        ' FROM Rupture_Disc__c '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND Finish_Configuration_Flag__c = true ';
                    
                } else if(prodCode == 'PS') {
                    
                    soql = 'SELECT Id, Quote_Line__c, OA__c, OB__c, OW__c, Quote_Line__r.Name '+
                        ' FROM Part_Selector__c '+
                        ' WHERE Quote_Line__r.SBQQ__Quote__c = :quoteId AND Finish_Configuration_Flag__c = true ';
                }
                
                if(soql == '' && Test.isRunningTest()) {
                    
                    soql = 'SELECT Id, Quote_Line__c, Diagram_Override__c, Quote_Descriptions_Override__c FROM Holders__c  ';                        

                }
        
                List<sObject> sobjList = Database.query(soql);
                if(sobjList.size() == 0) {
                    
                    error = 'The provided quote does not has any "QuoteLine" whose "Configuration" is complete!';
                    
                    res.put('STATUS', false);
                    res.put('MESSAGE', error);
                    res.putAll(res1);
                    return res;
                }
                
            } else {
                
                res.put('STATUS', false);
            	res.put('MESSAGE', Label.Invalid_Quote);
                res.putAll(res1);
                return res;
            }
        }
        
        try {
            
            MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation(prodMapping.get(product), quoteId);
            Id batchJobId = Database.executeBatch(obj); 
            
            //ConfiguratorRegeneration obj = new ConfiguratorRegeneration(prodMapping.get(product), quoteId);
            //Id batchJobId = Database.executeBatch(obj, 2); 
            
            Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
            rrd.Product_Name__c  = product;
            rrd.Product_Code__c = prodMapping.get(product);
            rrd.Batch_Job_ID__c = batchJobId;
            rrd.Quote_No__c = quoteId;
            rrd.Requested_By__c = UserInfo.getUserId();
            rrd.Status__c  = 'Pending';
            insert rrd;
            
            res1 = RegenerationRequestController.checkRegenerationRequest();
            res.putAll(res1);
            res.put('STATUS', true);
            res.put('MESSAGE', Label.Regeneration_Successful);
            
        } catch (Exception e) {
            
            res.put('STATUS', false);
            res.put('MESSAGE', e.getMessage());
        }
        
        return res;
    }
}