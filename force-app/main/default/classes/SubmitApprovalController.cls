public class SubmitApprovalController {
    
    @AuraEnabled 
    public static ResponseWrapper validateAndSubmitApproval(String quoteId){
        ResponseWrapper rw = new ResponseWrapper();
        SBQQ__Quote__c qt = [
            SELECT Id,Invalid_Quote_Line_Item_Count__c,RecordTypeId,SBQQ__Status__c,SBQQ__Opportunity2__c,SBQQ__Primary__c,
                Eng_Review_Status__c,Pending_Engineering_Review_Count__c,Prod_Planning_Status__c,Pending_Production_Planning_Review_Count__c
            FROM SBQQ__Quote__c
            WHERE Id=:quoteId
            LIMIT 1
        ];
        
        rw.message += (qt.Prod_Planning_Status__c != 'Completed' && qt.Pending_Production_Planning_Review_Count__c > 0) ?
            'There are ' + String.valueOf(qt.Pending_Production_Planning_Review_Count__c) + ' line items that require Prod Planning Review\n' : '';
        rw.message += (qt.Eng_Review_Status__c != 'Completed' && qt.Pending_Engineering_Review_Count__c > 0) ?
            'There are ' + String.valueOf(qt.Pending_Engineering_Review_Count__c) + ' line items that require Engineering Review\n' : '';
        //"message": 'Cannot Submit. Invalid Quote Line Count greater than zero!',
        //"message": 'Engineering and Product Planning Reviews must be complete before submitting this Quote',
        rw.status = String.isBlank(rw.message) ? 'SUCCESS' : 'ERROR';
        if(String.isBlank(rw.message)) {
            qt.SBQQ__Primary__c = true;
            upsert qt;
        }
        return rw;
    }
}