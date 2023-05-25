public class customAddProductScreen {
    public List<productWrapper> selectedProductList {get; set;}
    public List<SBQQ__QuoteLine__c> qouteLine {get;set;}
    public List<Rupture_Disc__c> ruptureLine {get;set;}
    public List<Relief_Valve__c> rfLine {get;set;}
    public List<Flame_Product__c> FlameLine {get;set;}
    public List<WasteGasBurner__c> WasteGasBurnerLine {get;set;}
    public List<Holders__c> HoldersLine {get;set;}
    public id quoteId {set;get;}
    public integer quoteLineNumber {set;get;}
    public customAddProductScreen (ApexPages.StandardController controller) {
        list<Product2> prodList=[select id,ProductCode,Description,Name from Product2 where IsActive=true];
        quoteId=ApexPages.currentPage().getParameters().get('qId');
        qouteLine=new List<SBQQ__QuoteLine__c>();
        ruptureLine=new List<Rupture_Disc__c>();
        rfLine=new List<Relief_Valve__c>();
        FlameLine=new List<Flame_Product__c>();
        WasteGasBurnerLine=new List<WasteGasBurner__c>();
        HoldersLine=new List<Holders__c>();
        selectedProductList=new List<productWrapper>();
        AggregateResult[] objAgg=[select max(QuoteLineNumber__c) max from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quoteId];
        System.debug('QuoteID');
        quoteLineNumber= Integer.valueOf(objAgg[0].get('max')) ;
        if (quoteLineNumber==null) 
            quoteLineNumber=0;
        quoteLineNumber=quoteLineNumber+1;
        for(Product2 pdList: prodList) {          
            productWrapper ab=new productWrapper (pdList,false);
            selectedProductList.add(ab);
        }
        system.debug('asdfghjkl'+prodList);
        system.debug('asdfghjkl'+selectedProductList);
    }
    public PageReference addProduct() {
        List<BGR__c> bgrRecordList = new List<BGR__c>();
        List<WasteGasBurner__c> wgbRecordList = new List<WasteGasBurner__c>();
        Set<String> productCode = new Set<String>();
        for(productWrapper pd:selectedProductList ) {
           if(pd.isSelected) {
               SBQQ__QuoteLine__c qLine=new SBQQ__QuoteLine__c ();        
               qLine.SBQQ__Quote__c=quoteId;
               qLine.SBQQ__Product__c=pd.p.id;
               qLine.SBQQ__Quantity__c=1; 
               qLine.QuoteLineNumber__c=quoteLineNumber;             
               qouteLine.add(qLine);
               productCode.add(pd.p.ProductCode);
               system.debug('Product code'+productCode);
            }
        }
        upsert qouteLine;
        integer i=0;
        if(productCode.size() > 0)
        {
                for(String pcode: productCode)
                {
                    System.debug('___'+pcode);
                    if(pcode == 'BGR')
                    { 
                        
                        BGR__c bgrRecord = new BGR__c();
                        bgrRecord.Quote_Line__c = qouteLine[i].id;
                        bgrRecordList.add(bgrRecord);
                    }
                    else if(pcode == 'RD')
                    {
                        Rupture_Disc__c rDisc=new Rupture_Disc__c();
                        rDisc.Quote_Line__c=qouteLine[i].id;
                        ruptureLine.add(rDisc);
                    }
                    else if(pcode == 'RLFVLV')
                    {
                        Relief_Valve__c rDisc=new Relief_Valve__c();
                        rDisc.Quote_Line__c=qouteLine[i].id;
                        rfLine.add(rDisc);
                    }
                    
                    
                     else if(pcode == 'FlameProducts')
                    {
                        System.debug('bfbfkfbjkbkjdb');
                        Flame_Product__c fLM=new Flame_Product__c();
                        fLM.Quote_Line__c=qouteLine[i].id;
                        FlameLine.add(fLM);
                    }
                    
                     else if(pcode == 'WGB')
                    {
                        System.debug('bfsdfghjkldfddhfdjbfkfbjkbkjdb');
                        WasteGasBurner__c WGB=new WasteGasBurner__c();
                        WGB.Quote_Line__c=qouteLine[i].id;
                        wgbRecordList.add(WGB);
                    }
                    else if(pcode == 'HLD')
                    {
                        System.debug('Inside Holder');
                        Holders__c hld=new Holders__c();
                        hld.Quote_Line__c=qouteLine[i].id;
                        HoldersLine.add(hld);
                        System.debug('Inside Holder'+HoldersLine);
                    }
                    i++;
                }
        }
        System.debug('bfbfkfbjkbkjdb'+FlameLine);
        if(wgbRecordList.size() > 0)
        {            
        	insert wgbRecordList;
            List<WGB_Outputs__c> wgbOutputList = new List<WGB_Outputs__c>();
            for(WasteGasBurner__c wgb: wgbRecordList)
            {
                WGB_Outputs__c wgbOutputInstance = new WGB_Outputs__c();
            	wgbOutputInstance.WasteGasBurner__c = wgb.id;
                wgbOutputList.add(wgbOutputInstance); 
            }
            insert wgbOutputList;       
        }
        
        if(bgrRecordList.size() > 0)
        {            
        	insert bgrRecordList;
            List<BGR_Outputs__c> bgrOutputList = new List<BGR_Outputs__c>();
            for(BGR__c bgr: bgrRecordList)
            {
                BGR_Outputs__c bgrOutputInstance = new BGR_Outputs__c();
            	bgrOutputInstance.BGR_Outputs_Relation_Field__c = bgr.id;
                bgrOutputList.add(bgrOutputInstance); 
            }
            insert bgrOutputList;
        
        }
        if(ruptureLine.size() > 0)
        {
        	insert ruptureLine;
        }
        if(rfLine.size() > 0)
        {
            insert rfLine;
        }
          if(FlameLine.size() > 0)
        {
            insert FlameLine;
        }
/*          if(WasteGasBurnerLine.size() > 0)
        {
            insert WasteGasBurnerLine;
        }
*/
        if(HoldersLine.size()>0)
        {
            insert HoldersLine;
            System.debug('HoldersLine___'+HoldersLine);
        }
        /*for (SBQQ__QuoteLine__c qL : qouteLine) {
            Rupture_Disc__c rDisc=new Rupture_Disc__c();
            rDisc.Quote_Line__c=qL.id;
            ruptureLine.add(rDisc);
        }
        upsert ruptureLine;
        */
PageReference pageRef = new PageReference('/apex/customQuoteLinePage?id='+quoteId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public class productWrapper {
        Public Product2 p {get;set;}
        public boolean isSelected {get;set;}
        public productWrapper(Product2 p,boolean isSel) {
            this.p = p;
            this.isSelected=isSel;
        }
       
    }
   

}