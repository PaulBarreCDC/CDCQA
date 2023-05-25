public with sharing class customQuoteLineController {
    public id quoteId {set;get;} 
    public List<quoteLineWrapper> quoteLineList {get; set;}
    public SBQQ__Quote__c quote {set;get;}
    public List<SBQQ__QuoteLine__c > quoteLines {set;get;}
    public customQuoteLineController(ApexPages.StandardController controller) {
        quoteId=ApexPages.currentPage().getParameters().get('id');
        quoteLines=new List<SBQQ__QuoteLine__c >();
        quoteLines=[SELECT Id,SBQQ__Quote__c,Name,SBQQ__Product__c,SBQQ__Discount__c,SBQQ__ProductName__c,SBQQ__ProductCode__c,SBQQ__Quantity__c,LastModifiedDate FROM SBQQ__QuoteLine__c  WHERE SBQQ__Quote__c = :quoteId order by LastModifiedDate];
        quoteLineList=new List<quoteLineWrapper>();
        System.debug(quoteLines);
        // INSERT TRY/CATCH AROUND DML, IF POSSIBLE AVOID DML IN LOOPS
        for (SBQQ__QuoteLine__c q:quoteLines ) {
          id qID=q.Id;
          String query='';
          string sObject_name='';
          query='SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c';
          if(q.SBQQ__ProductCode__c=='BGR')
              sObject_name='BGR__c';
          else if (q.SBQQ__ProductCode__c=='RD')
              sObject_name='Rupture_Disc__c';
          else if(q.SBQQ__ProductCode__c=='RLFVLV')
              sObject_name='Relief_Valve__c';
           else if(q.SBQQ__ProductCode__c=='FlameProducts')
               sObject_name='Flame_Product__c';
             else if(q.SBQQ__ProductCode__c=='WGB')
              sObject_name='WasteGasBurner__c';
             else if(q.SBQQ__ProductCode__c=='HLD')
              sObject_name='Holders__c';            
          //  This 'else' statement will cause issues if the quote has orphaned quote line items, or quote line items from another configurator
          /*else
              sObject_name='Rupture_Disc__c';
           */ 
          query=query+' FROM '+sObject_name+' WHERE Quote_Line__c=:qID';
			
          try {
            SObject pdRec=Database.query(query);
            quoteLineWrapper ab=new quoteLineWrapper (q,pdRec);
            //System.debug('ADSDFDSGF'+ab);
            quoteLineList.add(ab);
          } catch(Exception ex) {
            System.debug(ex.getLineNumber() + ': ' + ex.getMessage());
            System.debug('Prodcut: '+ q.SBQQ__ProductCode__c);
            System.debug('QuoteLine ID: '+ qID);
            System.debug('QuoteLine: ' + q);
            System.debug('Query: '+ query);
          }
        }
        //System.debug('FGFHGJ'+quoteLineList);
    }
    public class quoteLineWrapper {
        public SBQQ__QuoteLine__c ql {set;get;}
        public SObject rD {set;get;}
         public quoteLineWrapper(SBQQ__QuoteLine__c p,SObject rD) {
            this.ql = p;
            this.rD=rD;
        }
    }
    public pageReference deleteQuoteLine() {
        return null;
    }
    public pageReference addProduct() {

        PageReference pageRef = new PageReference('/apex/customReOrderScreen?qId='+quoteId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pageReference goBack() {

        PageReference pageRef = new PageReference('/'+quoteId);
        pageRef.setRedirect(true);
        return pageRef;
    }

}