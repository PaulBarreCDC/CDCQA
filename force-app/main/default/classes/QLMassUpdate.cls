public class QLMassUpdate {
    
    @InvocableMethod(label='Delete QL Mass Update Records' description='Delete QL Mass Update Records' category='QuoteLine_Mass_Update__c')
    public static void deleteMassQLRecords(List<Id> ids) {
        
        /*
List<QuoteLine_Mass_Update__c> records = [SELECT Id, Quote_Line__c, QuoteLine_Description__c, Drawing_ID__c, DimA__c, DimB__c, DimC__c, DimD__c, DimE__c, DimF__c FROM QuoteLine_Mass_Update__c WHERE Id IN :ids ORDER BY Id DESC];
List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
SBQQ__QuoteLine__c quoteLine;
for (QuoteLine_Mass_Update__c quoteLinesMassRecord: records) {

quoteLine = new SBQQ__QuoteLine__c();
quoteLine.Id  = quoteLinesMassRecord.Quote_Line__c;
quoteLine.DrawingID__c = quoteLinesMassRecord.Drawing_ID__c;
quoteLine.DimA__c = quoteLinesMassRecord.DimA__c;
quoteLine.DimB__c = quoteLinesMassRecord.DimB__c;
quoteLine.DimC__c = quoteLinesMassRecord.DimC__c;
quoteLine.DimD__c = quoteLinesMassRecord.DimD__c;
quoteLine.DimE__c = quoteLinesMassRecord.DimE__c;
quoteLine.DimF__c = quoteLinesMassRecord.DimF__c;
quoteLine.SBQQ__Description__c = quoteLinesMassRecord.QuoteLine_Description__c ;

quoteLines.add(quoteLine);
}
update quoteLines;
delete records;        
//ConfigHolderUtilityBatch.updateQLines();
*/
        
        List<QuoteLine_Mass_Update__c> deleteRecords = [SELECT Id, CreatedBy.Email, Batch_Job_Details__c, Batch_Status__c, Batch_Job_ID__c FROM QuoteLine_Mass_Update__c WHERE Delete_Record__c = true];
        
        if(deleteRecords.size() > 0) {
            
            // Send an email to the submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {deleteRecords[0].CreatedBy.Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject('ReGeneration Status ' + deleteRecords[0].Batch_Status__c);
            mail.setPlainTextBody(deleteRecords[0].Batch_Job_Details__c);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            //update batch job 
            List<Regeneration_Request_Details__c> regenerationReqDetails = [SELECT Id, Job_Details__c, Status__c FROM Regeneration_Request_Details__c WHERE Batch_Job_ID__c = :deleteRecords[0].Batch_Job_ID__c];
            if(regenerationReqDetails.size() > 0) {
                
                regenerationReqDetails[0].Status__c = deleteRecords[0].Batch_Status__c;
                update regenerationReqDetails;
            }
            
            if(deleteRecords.size() > 0) { 
                
                delete deleteRecords;
            }
        }
    }
}