public with sharing class QuoteLineOperations {
  @AuraEnabled
  public static ResponseWrapper retrieveRecords(Id qliId) {
    ResponseWrapper rw = new ResponseWrapper();
    List<SBQQ__QuoteLine__c> referenceQlis = new List<SBQQ__QuoteLine__c>();
    try {
      referenceQlis.addAll([
        SELECT Id, Name, Delivery_Number__c, SBQQ__Quantity__c, SBQQ__Quote__c, Planned_Delivery_Date__c, Quote_Line_Reference__c
        FROM SBQQ__QuoteLine__c
        WHERE Quote_Line_Reference__c = :qliId OR Id = :qliId
        ORDER BY Name
      ]);
      // IF this is the first line item, and the Delivery Number is null, then write it
      for(SBQQ__QuoteLine__c qli : referenceQlis) {
        if(qli.Quote_Line_Reference__c == null && String.isBlank(String.valueOf(qli.Delivery_Number__c))) {
          qli.Delivery_Number__c = 1;
        }
      }
      if(referenceQlis.size() > 0) {
        rw.status = 'SUCCESS';
        rw.message = 'You got lines';
        rw.value = (Object) referenceQlis;
      }
    } catch(Exception e) {
      rw.status = 'ERROR';
      rw.message = e.getMessage();
      rw.value = new List<SBQQ__QuoteLine__c>();
    }
    return rw;
  }
  @AuraEnabled
  public static ResponseWrapper saveQuoteLineInfo(Id qliId, List<SBQQ__QuoteLine__c> qlis) {
    ResponseWrapper rw = new ResponseWrapper();
    if(qlis.isEmpty()) {
      rw.status = 'ERROR';
      rw.message = 'No payload present in request!';
    } else {
      try {
        SBQQ__QuoteLine__c sourceQli = qlis.get(0);
        List<SBQQ__QuoteLine__c> toIns = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> toUpd = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c qli : qlis) {
          if(String.isBlank(qli.Id)) {
            SBQQ__QuoteLine__c tempQli = sourceQli.clone(false,true,false,false);
            tempQli.SBQQ__Quote__c = sourceQli.SBQQ__Quote__c;
            tempQli.Quote_Line_Reference__c = sourceQli.Id;
            tempQli.Delivery_Number__c = qli.Delivery_Number__c;
            tempQli.SBQQ__Quantity__c = qli.SBQQ__Quantity__c;
            tempQli.Planned_Delivery_Date__c = qli.Planned_Delivery_Date__c;
            toIns.add(tempQli);
          } else {
            toUpd.add(qli);
          }
        }
        update toUpd;
        insert toIns;
        rw.status = 'SUCCESS';
        rw.message = 'done';
      } catch(Exception e) {
        System.debug(e.getMessage());
        rw.status = 'ERROR';
        rw.message = e.getCause() + ':' + e.getMessage();
      }
    }
    return rw;
  }
  @AuraEnabled
  public static ResponseWrapper deleteQuoteLine(Integer idx, List<SBQQ__QuoteLine__c> qlis) {
    System.debug('saveWrappers');
    ResponseWrapper rw = new ResponseWrapper();
    if(qlis.isEmpty()) {
      rw.status = 'ERROR';
      rw.message = 'No payload present in request!';
    } else {
      try {
        SBQQ__QuoteLine__c qli = qlis.remove(idx);
        delete qli;
        rw.status = 'SUCCESS';
        rw.message = 'done';
        rw.value = (Object) qlis;
      } catch(Exception e) {
        System.debug(e.getMessage());
        rw.status = 'ERROR';
        rw.message = e.getCause() + ':' + e.getMessage();
      }
    }
    return rw;
  }
}