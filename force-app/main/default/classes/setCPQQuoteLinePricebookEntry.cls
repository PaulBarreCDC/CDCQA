public class setCPQQuoteLinePricebookEntry{
    public static void setQuoteLinePricebookEntryId(List<SBQQ__Quote__c> quotes, List<SBQQ__QuoteLine__c> quoteLines, Set<Id> Pricebook){
    //system.debug('start');
    Map<Id, Id> quotePricebookCollection = new Map<Id, Id>();
    for(SBQQ__Quote__c quote : quotes){
        quotePricebookCollection.put( quote.Id, quote.SBQQ__Pricebook__c);
    }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        List<Id>productIds = new List<Id>();
        List<String> currencyIsoCode = new List<String>();
        String[] currencyIsoCodeArray = new String[1];
        Map<String, Id> productIdToPricebookEntryIdMap = new Map<String, Id>();
        for(SBQQ__QuoteLine__c ql : quoteLines){
            currencyIsoCodeArray.add(ql.currencyIsoCode);
            productIds.add(ql.SBQQ__Product__c);
        }
        //system.debug(' currency ' + currencyIsoCode);
        //system.debug('Product2Id ' + productIds);

        //system.debug('pricebook! ' + Pricebook);
        
        priceBookEntries = [SELECT Id, ProductCode, currencyIsoCode, Pricebook2Id, Product2Id, IsActive  FROM Pricebookentry WHERE Product2Id IN : productIds AND currencyIsoCode IN : currencyIsoCodeArray AND Pricebook2Id IN :Pricebook];
        for(pricebookEntry pbe : priceBookEntries){
            if(pbe.IsActive){
                String pbeUniqueKey = String.valueOf(pbe.Product2Id) + String.valueOf(pbe.Pricebook2Id) + String.valueOf(pbe.currencyIsoCode);
                productIdToPricebookEntryIdMap.put(pbeUniqueKey, pbe.Id);
            }
        }
        for(SBQQ__QuoteLine__c ql :  quoteLines){
            String quotePricebook =  quotePricebookCollection.get(ql.SBQQ__Quote__c);
            String productIdString = String.valueOf(ql.SBQQ__Product__c);
            String currencyIsoCodeString = String.valueOf(ql.CurrencyIsoCode);
            String uniqueKey = productIdString + quotePricebook + currencyIsoCodeString;
            ql.SBQQ__PricebookEntryId__c = String.valueOf(productIdToPricebookEntryIdMap.get(uniqueKey) );
        }
    }
}