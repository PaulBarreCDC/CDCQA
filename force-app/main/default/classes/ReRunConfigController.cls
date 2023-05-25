public class ReRunConfigController {
    
    @AuraEnabled 
    public static void rerun(Id quoteLineId) {
        
        try {
            SBQQ__QuoteLine__c lineItem =[
                SELECT ID,SBQQ__ProductCode__c,Expiration_Date__c,Config_Record_Id__c
                FROM SBQQ__QuoteLine__c 
                WHERE ID=:quoteLineId
                LIMIT 1
            ];
            lineItem.Run_Config_Sync__c = true; 
            lineItem.Expiration_Date__c = date.today().addDays(60);
            update lineItem;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}