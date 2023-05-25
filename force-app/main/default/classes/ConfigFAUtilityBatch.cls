public class ConfigFAUtilityBatch {
    
    public static Map<String, Object> updateFARecords(Flame_Product__c faRecord) {
        
        String errorDetails = '';
        String quoteDesc;
        Result resData = new Result();
        SBQQ__QuoteLine__c quoteLine;
        
        configureFLAMEproduct conObj = new configureFLAMEproduct(faRecord.Quote_Line__c);      
        conObj.GetQuoteDescriptionRecords();
        
        List<configureFLAMEproduct.QuoteDescriptionWrapper> res1 = conObj.quoteDescriptionList;
        FA_Output__c outputs = conObj.faOutsideInstance;
        Flame_Product__c recDetail = conObj.flmprod;
        
        try {
         	
            update outputs;
            update recDetail;
            
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
                
                if(outputs.PC_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.PC_Override__c;
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
                if(recDetail.PC__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += recDetail.PC__c;
                }
            }
            quoteDesc = quoteDesc.replace('\\n', '\n');
            quoteDesc = quoteDesc.replace('\n', '<br/>');
            quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.Id = recDetail.Quote_Line__c;
            quoteLine.SBQQ__Description__c = quoteDesc;
            
        } catch (Exception e) {
            
            errorDetails = 'Error:'+ recDetail.Quote_Line__r.Name +' - '+e.getMessage();
        }
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('QUOTE_LINE', quoteLine);
        response.put('ERROR_DETAILS', errorDetails);
        
        return response;
    }
}