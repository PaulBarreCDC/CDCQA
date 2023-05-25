public class ConfigBGRUtilityBatch {
    
    public static Map<String, Object> updateBGRRecords(BGR__c bgrRecord) {
        
        String errorDetails = '';
        String OA, OB, OW, quoteDesc;
        Result resData = new Result();
        SBQQ__QuoteLine__c quoteLine;
        
        configureBGRProduct conBGR = new configureBGRProduct(bgrRecord.Quote_Line__c);        
        List<configureBGRProduct.QuoteDescriptionWrapper> res1 = conBGR.GetQuoteDescriptionRec();
        BGR_Outputs__c bgrOutputs = conBGR.bgrOutsideInstance;
        BGR__c bgrDetail = conBGR.conBGR;
        
        try {
         	
            update bgrOutputs;
            update bgrDetail;
            
            if(bgrDetail.Quote_Description_Engineer_Override__c) {
                quoteDesc = '';
                if(bgrOutputs.OA_Override__c != null) {
                	
                    quoteDesc = bgrOutputs.OA_Override__c;
                }
                if(bgrOutputs.OB_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += bgrOutputs.OB_Override__c;
                }
                if(bgrOutputs.OW_Override__c != null) {
                	if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += bgrOutputs.OW_Override__c;
                }
            } else {
                
                quoteDesc = '';
                if(bgrDetail.OA__c != null) {
                	
                    quoteDesc = bgrDetail.OA__c;
                }
                if(bgrDetail.OB__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += bgrDetail.OB__c;
                }
                if(bgrDetail.OW__c != null) {
                	if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += bgrDetail.OW__c;
                }
            }
            quoteDesc = quoteDesc.replace('\\n', '\n');
            quoteDesc = quoteDesc.replace('\n', '<br/>');
            quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.Id = bgrRecord.Quote_Line__c;
            quoteLine.SBQQ__Description__c = quoteDesc;
            
        } catch (Exception e) {
            
            errorDetails = 'Error:'+ bgrRecord.Quote_Line__r.Name +' - '+e.getMessage();
        }
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('QUOTE_LINE', quoteLine);
        response.put('ERROR_DETAILS', errorDetails);
        
        return response;
    }
}