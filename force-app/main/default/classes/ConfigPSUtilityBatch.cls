public class ConfigPSUtilityBatch {
    
    public static Map<String, Object> updatePSRecords(Part_Selector__c psRecord) {
        
        String errorDetails = '';
        String quoteDesc;
        Result resData = new Result();
        SBQQ__QuoteLine__c quoteLine;
        
        configurePartSelector conObj = new configurePartSelector(psRecord.Id);      
        conObj.GetQuoteDescriptionRecords();
        
        List<configurePartSelector.QuoteDescriptionWrapper> res1 = conObj.quoteDescriptionList;
        PS_Output__c outputs = conObj.PSOutsideInstance;
        Part_Selector__c recDetail = conObj.PS;
        
        try {
         	
            update outputs;
            update recDetail;
            
            system.debug('TEST res1:'+recDetail.OA__c);
			system.debug('TEST res1:'+recDetail.OB__c);
            system.debug('TEST res1:'+recDetail.OW__c);
            
            if(recDetail.Quote_Description_Engineer_Override__c) {
                quoteDesc = '';
                if(outputs.OA_Override__c != null) {
                	
                    quoteDesc = outputs.OA_Override__c;
                }
                if(outputs.OB_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.OB_Override__c;
                }
                
                if(outputs.OW_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.OW_Override__c;
                }
                
            } else {
                
                quoteDesc = '';
                if(recDetail.OA__c != null) {
                	
                    quoteDesc = recDetail.OA__c;
                }
                if(recDetail.OB__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += recDetail.OB__c;
                }
                if(recDetail.OW__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += recDetail.OW__c;
                }
            }
            quoteDesc = quoteDesc.replace('\\n', '\n');
            quoteDesc = quoteDesc.replace('\n', '<br/>');
            quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.Id = recDetail.Quote_Line__c;
            quoteLine.SBQQ__Description__c = quoteDesc;
            
        } catch (Exception e) {
            
            errorDetails = 'Error:'+ recDetail.Quote_Line__c +' - '+e.getMessage();
            system.debug('ERROR:'+errorDetails);
        }
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('QUOTE_LINE', quoteLine);
        response.put('ERROR_DETAILS', errorDetails);
        
        return response;
    }
}