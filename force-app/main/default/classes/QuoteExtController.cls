public without sharing class QuoteExtController {
    private Id quoteId;
    private Id userId;
    
    public QuoteExtController(ApexPages.StandardController stdController) {
        quoteId = stdController.getId();
        userId = UserInfo.getUserId();
    }
    
    public PageReference onSubmit() {
        PageReference qtPage = null;
        if (quoteId != null) {
            SBAA.ApprovalAPI.submit(quoteId, SBAA__Approval__c.Quote__c);
            
            SBQQ__Quote__c qt = [
                SELECT Id,Invalid_Quote_Line_Item_Count__c,RecordTypeId,SBQQ__Status__c,SBQQ__Opportunity2__c,SBQQ__Primary__c,
                Eng_Review_Status__c,Pending_Engineering_Review_Count__c,Prod_Planning_Status__c,Pending_Production_Planning_Review_Count__c
                FROM SBQQ__Quote__c WHERE Id=:quoteId
            ];
            evalApprovalsAndUpdateQuoteStatus(qt, userId, '');
            
            update qt;
            
            // Send the user to the detail page for the quote.
            qtPage = new ApexPages.StandardController(qt).view();
            qtPage.setRedirect(true);
        }
        return qtPage;
    }
    @AuraEnabled 
    public static ResponseWrapper validateAndSubmitApproval(Id quoteId, Id userId){
        ResponseWrapper rw = new ResponseWrapper();
        SBQQ__Quote__c qt = [
            SELECT Id,Invalid_Quote_Line_Item_Count__c,RecordTypeId,SBQQ__Status__c,SBQQ__Opportunity2__c,SBQQ__Primary__c,
            Eng_Review_Status__c,Pending_Engineering_Review_Count__c,Prod_Planning_Status__c,Pending_Production_Planning_Review_Count__c
            FROM SBQQ__Quote__c
            WHERE Id=:quoteId
        ];
        User submitter = [
            SELECT IsPortalEnabled
            FROM User
            WHERE Id=:userId
        ];
        
        rw.message += (qt.Prod_Planning_Status__c != 'Completed' && qt.Pending_Production_Planning_Review_Count__c > 0) ?
            'There are ' + String.valueOf(qt.Pending_Production_Planning_Review_Count__c) + ' line items that require Prod Planning Review\n' : '';
        rw.message += (qt.Eng_Review_Status__c != 'Completed' && qt.Pending_Engineering_Review_Count__c > 0) ?
            'There are ' + String.valueOf(qt.Pending_Engineering_Review_Count__c) + ' line items that require Engineering Review\n' : '';
        
        rw.status = String.isBlank(rw.message) ? 'SUCCESS' : 'ERROR';
        
        if(String.isBlank(rw.message)) {
            evalApprovalsAndUpdateQuoteStatus(qt, userId, rw.status);
            setPrimaryQuote(qt);
        }
        
        if(!String.isBlank(rw.message) && submitter.IsPortalEnabled) {
            evalApprovalsAndUpdateQuoteStatus(qt, userId, rw.status);
            setPrimaryQuote(qt);
            rw.status = 'SUCCESS';
        }
        
        return rw;
    }
    public static void setPrimaryQuote(SBQQ__Quote__c qt) {
        List<SBQQ__Quote__c> toUpdate = new List<SBQQ__Quote__c>();
        List<SBQQ__Quote__c> siblingQuotes = [
            SELECT Id,SBQQ__Opportunity2__c,SBQQ__Primary__c
            FROM SBQQ__Quote__c
            WHERE SBQQ__Opportunity2__c=:qt.SBQQ__Opportunity2__c
        ];
        Opportunity parentOppty = [
            SELECT Id,StageName
            FROM Opportunity
            WHERE Id=:qt.SBQQ__Opportunity2__c
        ];
        if(!siblingQuotes.isEmpty()) {
            for(SBQQ__Quote__c sibling : siblingQuotes) {
                if(sibling.SBQQ__Primary__c) {
                    sibling.SBQQ__Primary__c = false;
                    toUpdate.add(sibling);
                }
            }
        }
        qt.SBQQ__Primary__c = true;
        toUpdate.add(qt);
        update qt;
        /** TODO: UPDATE OPPTY STAGENAME HERE */
    }
    public static void evalApprovalsAndUpdateQuoteStatus(SBQQ__Quote__c qt, String userId, String rwStatus) {
        System.debug(userId);
        User submitter = [
            SELECT IsPortalEnabled
            FROM User
            WHERE Id=:userId
        ];
        if(submitter.IsPortalEnabled && rwStatus == 'ERROR') {
            qt.SBQQ__Status__c = 'Partner Submitted';
            qt.RecordTypeId = RecordTypeUtil.QT_PRTNR_RECORDTYPE_ID;
        } else { 
            SBAA.ApprovalAPI.submit(qt.Id, SBAA__Approval__c.Quote__c);   // Run approvals using the Steelbrick Advanced Approvals API
            List<sbaa__Approval__c> approvalList = [                        // Query for all approvals that apply to this quote
                SELECT Id, sbaa__Status__c
                FROM sbaa__Approval__c
                WHERE Quote__c =:qt.Id
            ];
            
            qt.SBQQ__Status__c = 'Approved';                                // Initialize the Status as 'Approved'
            qt.RecordTypeId = RecordTypeUtil.QT_APP_RECORDTYPE_ID;          // Initialize the Record Type to 'Approved'
            /* LOOP: Check all approval reasons to determine what record type it should be */
            for(sbaa__Approval__c  appr : approvalList) {
                // IF a reason is set to 'Requested'
                //  Set the status to 'Requested' and change the record type to 'Pending Approvals'
                if(appr.sbaa__Status__c == 'Requested') {
                    qt.SBQQ__Status__c = 'Pending Approvals';
                    qt.RecordTypeId = RecordTypeUtil.QT_PND_APP_RECORDTYPE_ID;
                    break;
                }
            }
        }        
    }
    public PageReference onRecall() {
        System.debug('onRecall');
        if (quoteId != null) {
            try {
                SBQQ__Quote__c qt = [Select Id,RecordTypeId,SBQQ__Status__c,Revision__c from SBQQ__Quote__c where Id=:quoteId];
                System.debug('Before Revision__c: ' + qt.Revision__c);
                qt.Revision__c =  qt.Revision__c == null ? 0 + 1 : qt.Revision__c + 1; //Added by Maanas to handle Null check and Prevent null pointer ,Cannot add integer to Null 
                qt.RecordTypeId = RecordTypeUtil.QT_PND_RECORDTYPE_ID;
                qt.SBQQ__Status__c ='Pending';
                update qt;
                
                System.debug('Updated Revision__c: ' + qt.Revision__c); 
                
                SBAA.ApprovalAPI.recall(quoteId, SBAA__Approval__c.Quote__c);
                
            } catch (Exception e) {
                System.debug(e.getMessage());
            }            
        }
        
        User submitter = [
            SELECT IsPortalEnabled
            FROM User
            WHERE Id=:userId
        ];
        
        if(submitter.IsPortalEnabled){
            return new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/s/detail/' + quoteId);            
        } else{
            return new PageReference('/' + quoteId);
        }
        
    }
    
    
}