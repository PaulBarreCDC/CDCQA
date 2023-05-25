public class CreateQuoteController {
    
    @AuraEnabled
    public static Id createQuote(Id oppId){
        
        if(oppid == null){return null;}
        
        try{
            SBQQ__Quote__c quoteToInsert = new SBQQ__Quote__c(SBQQ__Opportunity2__c = oppId); 
            insert quoteToInsert;
            return quoteToInsert.Id;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return null;
    }
    
}