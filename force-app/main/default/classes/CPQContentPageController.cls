public class CPQContentPageController {
  protected Id quoteId;
  public static List<SBQQ__QuoteLine__c> quoteLineObj {get; set;}
  
  public CPQContentPageController() {
      quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
      System.debug('\n****quoteId'+quoteId);
  }
  
  public PageReference init() {
      quoteLineObj = [
          SELECT	id, 
          			SBQQ__ListPrice__c,
          			Leadtime__c,
          			SBQQ__Quantity__c,
          			SBQQ__OriginalQuoteLineId__c,
          			SBQQ__ProductName__c
          FROM SBQQ__QuoteLine__c
          WHERE SBQQ__Quote__c = :quoteId];
      
      System.debug('\n****quoteLineObj'+quoteLineObj);
      return null;
  }
}