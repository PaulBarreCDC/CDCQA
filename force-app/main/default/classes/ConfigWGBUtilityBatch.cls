public class ConfigWGBUtilityBatch {
    
    public static Map<String, Object> updateWGBRecords(WasteGasBurner__c wgbRecord) {
        
        String errorDetails = '';
        String quoteDesc;
        Result resData = new Result();
        SBQQ__QuoteLine__c quoteLine;
        
        ConfigureWasteGasBurner conWGB = new ConfigureWasteGasBurner(wgbRecord.Quote_Line__c);        
        List<ConfigureWasteGasBurner.QuoteDescriptionWrapper> res1 = conWGB.GetQuoteDescriptionRec();
        WGB_Outputs__c wgbOutputs = conWGB.wgbOutsideInstance;
        WasteGasBurner__c wgbDetail = conWGB.WGBProd;
        
        try {
         	
            update wgbOutputs;
            update wgbDetail;
            
            if(wgbDetail.Quote_Description_Engineer_Override__c) {
                quoteDesc = '';
                if(wgbOutputs.OA_Override__c != null) {
                	
                    quoteDesc = wgbOutputs.OA_Override__c;
                }
                if(wgbOutputs.OB_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += wgbOutputs.OB_Override__c;
                }
                
            } else {
                
                quoteDesc = '';
                if(wgbDetail.OA__c != null) {
                	
                    quoteDesc = wgbDetail.OA__c;
                }
                if(wgbDetail.OB__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += wgbDetail.OB__c;
                }
            }
            quoteDesc = quoteDesc.replace('\\n', '\n');
            quoteDesc = quoteDesc.replace('\n', '<br/>');
            quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.Id = wgbDetail.Quote_Line__c;
            quoteLine.SBQQ__Description__c = quoteDesc;
            
        } catch (Exception e) {
            
            errorDetails = 'Error:'+ wgbDetail.Quote_Line__c +' - '+e.getMessage();
        }
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('QUOTE_LINE', quoteLine);
        response.put('ERROR_DETAILS', errorDetails);
        
        return response;
    }
}