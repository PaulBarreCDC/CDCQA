public class CPQQuoteTemplateController {
  protected Id quoteId;
  public static SBQQ__Quote__c quoteObj {get;set;}
  public static String brandLogoURI {get;set;}
  public static String backgroundURI {get;set;}
  public static String shortBackgroundURI {get;set;}

  public CPQQuoteTemplateController() {
    quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
    System.debug('quoteId:' + quoteId);
  }
  public void init() {
    try {
      quoteObj = [
            SELECT Brand__c,
              SBQQ__Account__c,
              SBQQ__BillingName__c,
              SBQQ__BillingCity__c,
              SBQQ__BillingPostalCode__c,
              SBQQ__BillingState__c,
              Billing_Website__c
            FROM SBQQ__Quote__c 
            WHERE Id = :quoteId
            LIMIT 1
          ];
      //brandLogoURI = '/images/logos/Logo' + quoteObj.Brand__c + '.png';
      backgroundURI = URL.getSalesforceBaseUrl().toExternalForm() + '/resource/1585804687000/cdcOutput/images/footers/ContentPageFooter' + quoteObj.Brand__c + '.png';
      shortBackgroundURI = 'images/footers/ContentPageFooter' + quoteObj.Brand__c + '.png';
      System.debug(quoteObj);
    } catch (Exception e) {
      System.debug(e.getMessage());
    }
  }
}