public class UpdateRevisionNumber {

    public UpdateRevisionNumber(ApexPages.StandardController stdController) {
        SBQQ__Quote__c qtRec = (SBQQ__Quote__c)stdController.getRecord();
        updateRevision(qtRec.Id);
    }
    public void updateRevision(Id qId)
    {
        SBQQ__Quote__c qt = [Select Id,Revision__c from SBQQ__Quote__c where Id=:qId];
        qt.Revision__c = qt.Revision__c + 1;
        update qt;
        SYstem.debug('Revision__c'+qt.Revision__c); 

    }
}