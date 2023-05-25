public class QuoteLineComponentController {
  public String quoteId {get; set;} 
    
  public List<SBQQ__QuoteLine__c> quotelines {
    get {
      return [
        SELECT Id, Name, SBQQ__ListPrice__c, SBQQ__Quantity__c, SBQQ__ProductName__c 
        FROM SBQQ__QuoteLine__c 
        WHERE SBQQ__Quote__c = :quoteId
      ];
    }
  }  
}