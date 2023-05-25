public class CustomReOrderController {
    public string selectedProduct {
        get;set;
    }
    public string isManagedinIFS ;
    public string strURL{get;set;}
    public id quoteId {
        get {
            return ApexPages.currentPage().getParameters().get('qId');
        }
        set { 
            quoteId=value;
        }
    }
    public boolean showPartNumError {set;get;}
    public boolean showMfttNumError {set;get;}
    public boolean showPartBlankError {set;get;}
    public boolean showPart{set;get;}
    public boolean showReorder{set;get;}
    public boolean showMft{set;get;}
    public integer quantity{set;get;}
    public List<orderWrapper> selectedOrderWraper {get; set;}
    public string strPartNumber {get;set;}
    public string strMfgNumber {get;set;}
    public List<sObject> sObjectList {get;set;}
    public CustomReOrderController (ApexPages.StandardController controller) {
        selectedOrderWraper=new List<orderWrapper>();
        sObjectList=new List<sObject>(); 
        showPart=false;
        showMft=false;
        showReorder=true;
        showPartNumError=false;
        showMfttNumError=false;
        showPartBlankError=false;
    }
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('byPartumber','Order by Part Number')); 
        options.add(new SelectOption('bySerialNum','MFG#/Serial Number')); 
        options.add(new SelectOption('Config','Configure New Product'));
         return options; 
    }
    public List<SelectOption> getProductValues() {
        List<selectOption> Options = new List<selectOption>();
        Map<string,string> mapProduct=new Map<string,string>();
        mapProduct=wizardBaseDataProcessor.mapObjectwithProductCode;
        for(string str:mapProduct.keyset()){
            Options.add(new selectOption(str,str));
        }
        return Options;
    }
    public pageReference hidePanel() {
        showReorder=false;
        return null;
    }
    public pageReference actionSup() {
        //pageReference pg=new pageReference();
        System.debug('selectedProduct'+selectedProduct);
        if (selectedProduct=='byPartumber') {
            showPart=true;
            showMft=false;
            strMfgNumber=null;
            Quantity=null;
            return null;
        } else if (selectedProduct=='bySerialNum') {
            strPartNumber=null;
            showPart=false;
            showMft=true;
            Quantity=null;
            return null;
        } else {
            showMft=false;
            showPart=false;
            PageReference pageRef = new PageReference('/apex/customAddProductScreen?qId='+quoteId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        
    }
    public pageReference reOrderProduct() {
    
        List<SBQQ__Quote__c> quoteList=new List<SBQQ__Quote__c>();
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //sObject sOb1=new sObject();
        //string strURL;
        //System.debug('strURL'+strURL);
        System.debug('selectedOrderWraper'+selectedOrderWraper);
        for(orderWrapper pd:selectedOrderWraper ) {
            //String strPartObject=.mapPartNumObject.get(selectedProduct);
           //try {
                SBQQ__Quote__c quote=new SBQQ__Quote__c();
                string strObjName=AssyPartDefinationProcessor.mapConfiguratorwithObject.get(pd.strProduct);
                System.debug('strObjName'+strObjName);
                // sObject sObjQuoteLine=database.query('select id,Quote_Line__c from '+strObjName+'  where Part_Number__c=\''+strPartNumber+'\'')[0];
                // System.debug('sObjQuoteLine'+sObjQuoteLine);               
                // id quoteLine=(id) sObjQuoteLine.get('Quote_Line__c');
                // id custObjId=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine);
                // SBQQ__QuoteLine__c quoteLineOld=[select SBQQ__Quote__c,id from SBQQ__QuoteLine__c where id=:quoteLine][0];
                /*SBQQ__Quote__c quoteOld=[select id,SBQQ__Account__c from SBQQ__Quote__c where id=:quoteLineOld.SBQQ__Quote__c][0];
                quote.SBQQ__Account__c=quoteOld.SBQQ__Account__c;
                quoteList.add(quote);
                upsert quoteList;*/
                SBQQ__QuoteLine__c qLine=new SBQQ__QuoteLine__c();
                integer quoteLineNumber;
                //System.debug('quoteLineOld'+quoteLineOld);
                if (quoteId!=null) {
                    AggregateResult[] objAgg=[select max(QuoteLineNumber__c) max from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quoteId];
                    System.debug('QuoteID');
                    quoteLineNumber= Integer.valueOf(objAgg[0].get('max')) ;
                    if (quoteLineNumber==null) 
                        quoteLineNumber=0;
                    quoteLineNumber=quoteLineNumber+1;
                }
                System.debug('QuoteID'+quoteId);
                System.debug('VVVVV pd.strProduct------'+pd.strProduct);
                if(pd.strProduct=='DISC')
                    pd.strProduct='RD';
                qLine.SBQQ__Quote__c=quoteId;
                qLine.SBQQ__Product__c=[select id from Product2 where ProductCode=:pd.strProduct][0].id;
                qLine.SBQQ__Quantity__c=quantity; 
                //qLine.SBQQ__Quantity__c=1; 
                qLine.QuoteLineNumber__c=quoteLineNumber; 
                qLine.isIFSManaged__c = isManagedinIFS == 'IFS';
                upsert qLine;
                result resCusRec=wizardBaseDataProcessor.createRecordByProductCode(pd.strProduct,qLine.id);
                if (resCusRec.bResult)
                {
                    System.debug('ReOrder'+pd.p);
                    sObject sOb=resCusRec.objResultList[0];
                  //  sOb.get(Part_Number__c);
                    //string strQuery='Select id,Configurator__c,Field1__c,BRAND__c,Managed_In__c,Field2__c,Field3__c,ASSYPARTNO__c from AssyPartDefinition__c';
                    if(strObjName != 'Part_Selector__c'){
                        result resReOrder=AssyPartDefinationProcessor.copyValuesFromTransData(sOb,strPartNumber);
                        sOb.put('Bypass__c',true);
                        sOb.put('Part_Number__c'  , strPartNumber);
                    }else{
                        string fieldsAPIname = FLMutility.getObjectFields('PS_AssyPartDefinition__c');
                        list<String> lstFieldAPIName = new list<String>();
                        List<string> fieldxlst = new List<string>();
                        string DynamicQuery;
                        List<PS_Input_Attr_Matrix__c> psinputLst;
                        list<ProductAttribueData>lstPAD =  new list<ProductAttribueData>();
                        if(fieldsAPIname != '')
                        {
                            for(string s1 : fieldsAPIname.split(','))
                            {
                                if(s1.startsWithIgnoreCase('field'))
                                fieldxlst.add(s1);
                            }
                            DynamicQuery = 'Select Id,'+string.join(fieldxlst,',');
                        }
                        system.debug('partNumber'+strPartNumber);
                        sOb.put('ProductGroup__c', 'Enter Part Number');
                        sOb.put('Part_Number__c', strPartNumber);
                        sOb.put('Quantity__c', quantity);
                        //string brandStr = PS.Brand__c;
                        string DynamicQueryAssyPartDefinition = DynamicQuery+ ',ProdGroup__c,SubGroup__c from PS_AssyPartDefinition__c where ASSYPARTNO__c = :strPartNumber' ;
                        List<PS_AssyPartDefinition__c> ps_assyLst = Database.query(DynamicQueryAssyPartDefinition);
                        System.debug('AAAAAAA-----ps_assyLst---' +ps_assyLst);
                        if(!ps_assyLst.Isempty())
                        {
                            string subPDgroup = ps_assyLst[0].SubGroup__c;
                            string PDgroup = ps_assyLst[0].ProdGroup__c;
                            system.debug('AAA subPDgroup-------'+subPDgroup);
                            system.debug('AAA PDgroup-------' +PDgroup);
                            string DynamicQueryPS_Input_Attr_Matrix = DynamicQuery+ ' from PS_Input_Attr_Matrix__c where ProdGroup__c = :PDgroup and SubGroup__c= :subPDgroup' ;
                            psinputLst = Database.query(DynamicQueryPS_Input_Attr_Matrix);
							system.debug('AAA DynamicQueryPS_Input_Attr_Matrix-------' +DynamicQueryPS_Input_Attr_Matrix);
                            system.debug(ps_assyLst);
                            system.debug(psinputLst);
                            for(string s2:fieldxlst)
                            {
                                if(psinputLst != null && psinputLst.size() > 0)
                                {
                                    if(psinputLst[0].get(s2) <> null)
                                    {
                                        sOb.put(psinputLst[0].get(s2)+'__c',ps_assyLst[0].get(s2));
                                        lstPAD.add(new ProductAttribueData(string.valueof(psinputLst[0].get(s2)),string.valueof(ps_assyLst[0].get(s2))));
                                    }
                                }
                            }
                            string sProductAttributeData = JSON.serialize(lstPAD);
                            System.debug('@Developer --> sProductAttributeData :' + sProductAttributeData);

                            if(ps_assyLst.size() > 0)
                            {
                                sOb.put('SubGroup__c' , ps_assyLst[0].SubGroup__c);
                                sOb.put('ProductGroup__c' , ps_assyLst[0].ProdGroup__c);
                            }
                            sOb.put('Product_Attribute_Data__c' , sProductAttributeData);
                            sOb.put('Part_Number__c'  , strPartNumber);
                            sOb.put('Part_Number_Base__c' , strPartNumber);
                            sOb.put('Partnumber_orginal__c', strPartNumber);
                           // sOb.put('Finish_Configuration_Flag__c' , true);
                          /*  Part_Selector__c psrecord = [SELECT Id, Quote_Line__c FROM Part_Selector__c WHERE Id = :sOb.Id LIMIT 1];
                            configurePartSelector PS = new configurePartSelector(psrecord.Quote_Line__c);
                            PS.saveProdPartNumber();  */               
                        }	
                        
                    }
                    
                  //  ApexPages.StandardController sc = new ApexPages.StandardController(qLine);
                  //  configurePartSelector PS=new configurePartSelector(sc);
                  //  PS.partNumber=strPartNumber;
                  //  sOb.put('Partnumber_orginal__c', strPartNumber);
                  //  sOb.put('ProductGroup__c', 'Enter Part Number');
                   // sOb.put('', strPartNumber);
                  /*  Part_Selector__c psrecord = [SELECT Id, Quote_Line__c FROM Part_Selector__c WHERE Id = :sOb.Id LIMIT 1];
                    
                    
                    sOb.put('Part_Number__c'  , strPartNumber);
                    sOb.put('Part_Number_Base__c' , strPartNumber);
                    sOb.put('ProductGroup__c', 'Enter Part Number');
                    sOb.put('Quantity__c',quantity);
                    sOb.put('Partnumber_orginal__c', strPartNumber);*/
                    sOb.put('Quantity__c',quantity);
                    disableCpqTriggers.disableCPQ();                     
                    update sOb;
                    if(strObjName == 'Part_Selector__c'){
                        Part_Selector__c psrecord = [SELECT Id, Quote_Line__c FROM Part_Selector__c  WHERE Id = :sOb.Id LIMIT 1];
                        //  System.debug('1111111111111');
                        PS_Output__c psOutputInstance = new PS_Output__c();
                        psOutputInstance.Part_Selector__c = psrecord.id;
                        insert psOutputInstance;
                        configurePartSelector PS = new configurePartSelector(sOb.id);
                        PS.partNumber=strPartNumber;
                        //  System.debug('111111111111122222222222');
                        PS.saveProdPartNumber();
                    }
                    
                 //   System.debug('11111111111113333333');
                   /* configurePartSelector PS = new configurePartSelector(psrecord.Id);
                    PS.partNumber=strPartNumber;
                    PS.saveProdPartNumber();*/
                   /* Part_Selector__c psrecord = [SELECT Id, Quote_Line__c FROM Part_Selector__c WHERE Id = :sOb.Id LIMIT 1];
                    System.debug('AAAAAApsrecord----'+psrecord);
            		configurePartSelector PS = new configurePartSelector(psrecord.Id); 
                    PS.saveProdPartNumber();*/
                    system.debug(sOb+'sOb');
                  /*  if(strObjName == 'Bgr__c'){
                    Reorder.bgrReorder(sob.Id,true);
                    }*/
                    /*if(strObjName == 'WasteGasBurner__c'){
                     Reorder.WGBReorder(sob.Id,true);
                    }*/
                    System.debug('Final Output'+sOb.id);
                    System.debug('VVVVVVVstrObjName ------'+strObjName);
                    
                    if(!Test.isRunningTest()){
                       if(AssyPartDefinationProcessor.mapObjectwithConfigurator.containskey(strObjName)){
                      ID jobID1 = System.enqueueJob(new ReorderDriver(sob.Id,AssyPartDefinationProcessor.mapObjectwithConfigurator.get(strObjName),0));
                    } 
                    }
                    
                /* else if(strObjName == 'Flame_Product__c')
                   ID jobID2 = System.enqueueJob(new ReorderDemoClass(sob.Id,AssyPartDefinationProcessor.mapObjectwithConfigurator1.get(strObjName),0));*/
                   
                   // strURL='/lightning/cmp/c__BlanketGasRegulatorCmp?c__configId='+sOb.id+'&c__quoteId='+quoteId;
                   // strURL='/lightning/r/SBQQ__Quote__c/'+quoteId+'/view';
                    if(userinfo.IsPortalEnabled){
                        strURL =  '/s/detail/'+quoteId ;
                    }else{
                        strURL = '/lightning/r/SBQQ__Quote__c/'+quoteId+'/view';
                    } 
                 /*  if(strObjName == 'WasteGasBurner__c'){
                        strURL = '/apex/ConfigWGBProduct?qid='+qLine.Id+'&fromPage=reorder' ;
                    }*/
                  /*  if(strObjName == 'Flame_Product__c'){
                        strURL = '/apex/ConfigFLAME?qid='+qLine.Id+'&fromPage=reorder' ;
                    }*/ 
                    
                    
                   
                    // if(pd.strProduct=='BGR')
                    //     strURL='/apex/ConfigBGR?qid='+qLine.id;
                    // else
                    //     strURL='/apex/ConfigWGBProduct?qid='+qLine.id;
                    
                }
                //qLine.QuoteLineNumber__c=quoteLineNumber; 
          // } catch (Exception e) {
               // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>Part Number mintioned is not associated with any product.</b>&nbsp; &nbsp; Please re-enter  or Configure New Product'));
               //     return null;
           // } 
        } 
       
        //string pgRef = '';
         
       // pageReference pg=new pageReference(strURL); 
        return null;
    }
    public pageReference search() {
        string strQuery='Select id,Configurator__c,Field1__c,BRAND__c,Managed_In__c,Field2__c,Product_Ref__c,Field3__c,ASSYPARTNO__c from AssyPartDefinition__c';
        System.debug('strMfgNumber: ' + strMfgNumber);
        System.debug('strPartNumber: ' + strPartNumber);
        System.debug('selectedProduct: ' + selectedProduct);
        if (selectedProduct!=null) {
            System.debug('selectedProduct: ' + selectedProduct);
            System.debug('strPartNumber: ' + strPartNumber);
            System.debug('Quantity: ' + Quantity);
            if (selectedProduct=='byPartumber' && String.isBlank(strPartNumber))  {
                showPartNumError=true;
                strURL = 'error';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>Part Number not found</b>.&nbsp; &nbsp; Please re-enter Part Number or Configure New Product')); 
                if(Quantity==null||Quantity==0)
                    Quantity=null;
                return null;
            }
            if (String.isBlank(strMfgNumber) && selectedProduct=='bySerialNum') {
                showPartNumError=true;
                strURL = 'error';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>Part Number not found</b>.&nbsp; &nbsp; Please re-enter MFG#/Serial Number or Configure New Product')); 
                if(Quantity==null||Quantity==0)
                    Quantity=null;
                return null;
            }

            if(Quantity==null||Quantity<=0) {
                showPartNumError=true;
                System.debug('Quantity: ' + Quantity);
                strURL = 'error';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>Quantity not  found</b> &nbsp; Please enter value for Quantity')); 
                //Quantity=null;
                return null;
            }
            
        }
        if (strMfgNumber!=null && selectedProduct!=null) {
            strMfgNumber = strMfgNumber.trim();
            string strQuery1='Select id,LotSerialNo__c,PartNo__c from LotSerialPartNo__c';
            string strWhereClause1='';
            strWhereClause1=' Where LotSerialNo__c=\''+strMfgNumber+'\'';
            LotSerialPartNo__c[] sObjLst=Database.query(strQuery1+strWhereClause1);
            if(!sObjLst.isEmpty()) {
                strPartNumber=sObjLst[0].PartNo__c;
            } else {
                
                showMfttNumError=false;
                strURL = 'error';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>MFG#/Serial Number not found.</b>&nbsp; &nbsp; Please re-enter MFG#/Serial Number or Configure New Product'));
                return null;
            }
        }
        if (strPartNumber!=null && selectedProduct!=null) {
            try {
                ////SPECIAL Product Error Message
                /*string strConfigurator=[Select Configurator__c from AssyPartDefinition__c where ASSYPARTNO__c=:strPartNumber][0].Configurator__c;
                if(strConfigurator=='SPECIAL')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; Special parts are not eligible for reorder until added to the part catalog'));                    
                    strURL = 'error';
                    showPartNumError=true;
                }
                else
                {*/
                		string Flag='';
                        strPartNumber = strPartNumber.trim();
                		System.debug('AAAAA-----CD14141A0001-----' +strPartNumber);
                        List<PS_AssyPartDefinition__c> psAssylst = [Select id,ASSYPARTNO__c,BRAND__c,Managed_In__c from PS_AssyPartDefinition__c where ASSYPARTNO__c = :strPartNumber];
                        string oppBrand  = [select id,SBQQ__Opportunity2__r.Brand__c from SBQQ__Quote__c where id = :quoteId][0].SBQQ__Opportunity2__r.Brand__c;                        
                        System.debug('AAAAA-----quoteId-----' +quoteId);
                		System.debug('AAAAA-----oppBrand-----' +oppBrand);
                		System.debug('AAAAA-----psAssylst-----' +psAssylst);
                		if(!psAssylst.Isempty()){
                            System.debug('AAAAA-----Inside-----' +strPartNumber);
                            if(psAssylst[0].Managed_In__c == 'IFS')
                            isManagedinIFS = 'IFS';
                            if(oppBrand != psAssylst[0].Brand__c) 
                                throw new brandDiffException('Brands didnt match');
                            orderWrapper ab = new orderWrapper (strPartNumber);
                            selectedOrderWraper.add(ab);
                            Flag='yes';
                            return reOrderProduct();
                        }else{                        
                            system.debug('Indise error msg pge');
                            system.debug(strURL);
                            strURL = 'error';
                            showPartNumError=true;    
                            string strConfigurator=[Select Configurator__c from AssyPartDefinition__c where ASSYPARTNO__c=:strPartNumber][0].Configurator__c;
                            if(strConfigurator=='SPECIAL')
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; Special parts are not eligible for reorder until added to the part catalog'));                    
                                strURL = 'error';
                                showPartNumError=true;
                                return null;
                            }
                            
                        }
                    String strPartObject=wizardBaseDataProcessor.mapObjectwithProductCode.get(selectedProduct);
                    System.debug('hdsgfdsh'+strPartNumber);
                    System.debug('hdsgfdsh'+selectedProduct);
                    string strWhereClause='';
                    System.debug('hdsgfdsh'+strPartObject);
                    strWhereClause=' Where ASSYPARTNO__c=\''+strPartNumber+'\'';
                    System.debug('hdsgfdsh'+strQuery+strWhereClause);
                    sObjectList=Database.query(strQuery+strWhereClause);
                    selectedOrderWraper=new List<orderWrapper>();
                    System.debug('oppBrand11111sObjectList---------' +sObjectList);
                        System.debug('oppBrand22222---------' +oppBrand);
                        System.debug('oppBrandPartNumber---------' +strPartNumber);
              //  if(Flag!='yes'){
                    if(!sObjectList.isEmpty()) {                         
                        for(sObject sObj:sObjectList) {
                            if(oppBrand != sObj.get('Brand__c') ) 
                                throw new brandDiffException('Brands didnt match');
                            System.debug('sdfhdlfjhfd'+sObj);
                            orderWrapper ab=new orderWrapper (sObj,true);
                            selectedOrderWraper.add(ab);
                            break;
                        }    
                    } else {
                        system.debug('Indise error msg pge');
                        system.debug(strURL);
                        strURL = 'error';
                        showPartNumError=true;    
                        //   string strConfigurator=[Select Configurator__c from AssyPartDefinition__c where ASSYPARTNO__c=:strPartNumber][0].Configurator__c;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>Part Number not found</b>.&nbsp; &nbsp; Please re-enter Part Number or Configure New Product')); 
                        return null;
                    }
             //   }
                    
                //}
            } catch (Exception e) {
                showPartNumError=true;
                strURL = 'error';
                system.debug(string.valueof(e));
                if(string.Valueof(e) == 'brandDiffException:[]: Brands didnt match'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The Part Number entered is not applicable for the selected Brand on the Opportunity'));
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'&nbsp; &nbsp;<b>Part Number not found</b>.&nbsp; &nbsp; Please re-enter Part Number or Configure New Product')); 
                }
                return null;
            }
            
        } else 
        {
            //ApexPages.addMessages('Part Number is not found');
            strURL = 'error';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' &nbsp; &nbsp;Part Number not found.&nbsp; &nbsp; Please re-enter Part Number or Configure New Product'));                                  
        }
        System.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXx');
        return reOrderProduct();
    }
    public pageReference createReorder() {
        List<SBQQ__Quote__c> quoteList=new List<SBQQ__Quote__c>();
        for(orderWrapper pd:selectedOrderWraper ) {
            id quoteLine=(id) pd.strQuoteLine;
            SBQQ__Quote__c quote=new SBQQ__Quote__c();
            id custObjId=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine);
            SBQQ__QuoteLine__c quoteLineOld=[select SBQQ__Quote__c,id,Parts_Managed_In__c from SBQQ__QuoteLine__c where id=:quoteLine][0];
            SBQQ__Quote__c quoteOld=[select id,SBQQ__Account__c from SBQQ__Quote__c where id=:quoteLineOld.SBQQ__Quote__c][0];
            quote.SBQQ__Account__c=quoteOld.SBQQ__Account__c;
            quoteList.add(quote);
        }
        upsert quoteList;
        pageReference pg=new pageReference('https://contdisccorp--cpqproject.cs45.my.salesforce.com/'+quoteList[0].id); 
        
        return pg;
    }
    public pageReference navigateToQuote() {
        pageReference pg=new pageReference('http://www.google.com');  
        return pg;
    }
    public class orderWrapper {
        public boolean isSelected {get;set;}
        public string strPartNumber {get;set;}
        public string strProduct {get;set;}
        public string strQuoteLine  {get;set;}
        public sObject p {get;set;}
        public orderWrapper(sObject p,boolean isSel) {
            this.strPartNumber =  (String) p.get('ASSYPARTNO__c');
            this.strProduct= (String) p.get('Product_Ref__c');
            this.p=p;
            //this.strQuoteLine=(String) p.get('Quote_Line__c');
            AssyPartDefinition__c[] qLine1=[Select id,Configurator__c,Field1__c,Field2__c,Field3__c,BRAND__c,Managed_In__c,ASSYPARTNO__c,Product_Ref__c from AssyPartDefinition__c where ASSYPARTNO__c=:strPartNumber];
            //this.strProduct=(string) qLine1[0].SBQQ__ProductCode__c;
            this.isSelected=isSel;
        }  
        public orderWrapper(string partNum) {
            this.strProduct = 'PS';
            this.strPartNumber = partNum;
        }
        
    }
    public class ProductAttribueData{
        String sAttributeCode ;
        String sValue;

        public ProductAttribueData(){
            sAttributeCode = '';
            sValue = '';
        }

        public ProductAttribueData(String sAttrCode,String sVal){
            sAttributeCode = sAttrCode;
            sValue = sVal;
        }
    }
    public class brandDiffException extends Exception {}

}