public class UpdateChangeOrderExtension {
     private final SBQQ__Quote__c qtRec;

    public UpdateChangeOrderExtension(ApexPages.StandardController stdController) {
        this.qtRec = (SBQQ__Quote__c)stdController.getRecord();
        SYstem.debug(qtRec.IFS_Order_Status__c); 
    }
}