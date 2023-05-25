public class ChangeOrderControllerV2 {
    
    public list<ChangeOrderConfigWrapper> lstCOCW {get;set;}
    public String activeActionType {get;set;}
    public decimal activeQNum {get;set;}
    public String activeAlert {get;set;}
    public map<String,List<Change_Order_Option_Details__mdt>> mapChangeOrderOptionWiseCOODs{get;set;}
    public SBQQ__Quote__c oQuote {get;set;}
    
    public string quoteId {get;set;}    
    public list<ChargeWrapper> lstChargeWrapper {get;set;}
    public Integer nDelChargeIndx {get;set;}
	public Boolean bCommercialSelected  {get;set;}
    public Boolean bCommercialNonChargesSelected {get;set;}   
    public Boolean bCommercialChargesSelected {get;set;}   
    public Boolean bConfigSelected  {get;set;}
    public Boolean bConfigOrderLinesSelected {get;set;}
    public Boolean showPrevious{
        get{
            return !navigationTrack.isEmpty();
        }
        set;
    }
    //public Boolean bShowAddAttachment {get;set;}    
    
    private Stack navigationTrack = new Stack();
    private set<String>setCommercialType = new set<String>();
    private set<String>setConfigType = new set<String>();
            
    public ChangeOrderControllerV2(){
        System.debug('@Developer -->ChangeOrderControllerV2:' );
        
        setCommercialType.add('Delivery Information');
        setCommercialType.add('Freight Info');
        setCommercialType.add('Header');
        setCommercialType.add('Misc Order Info');
        setCommercialType.add('Charges');
        //setConfigType.add('Attachments');
        
        setConfigType.add('Order Lines');
        //bShowAddAttachment = false;
        
        mapChangeOrderOptionWiseCOODs = new map<String,List<Change_Order_Option_Details__mdt>>();
        if(ApexPages.currentPage().getParameters().get('quoteid') != null){
            quoteId = ApexPages.currentPage().getParameters().get('quoteid');
            System.debug('@Developer --> quoteId :' + quoteId);
            for(SBQQ__Quote__c qt :[Select Id,Name,SBQQ__Status__c,Change_Order_Status__c,Status_Reason__c,IFS_Order_Status__c,Change_Order_No__c,Shipping_Account__c,
                                    (Select Id,Name,SBQQ__Quantity__c,Product_Name__c,PARTNUMBER__c,Line_Status__c,Status_Reason__c, Change_Order_Status__c  
                                     From SBQQ__LineItems__r)
                                    From SBQQ__Quote__c 
                                    Where Id=: quoteId
                                    Limit 1])
            {
                oQuote = qt;
                System.debug('@Developer --> oQuote :' + oQuote);
                System.debug('@Developer --> oQuote.Change_Order_No__c :' + oQuote.Change_Order_No__c);
            }
        }       
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid Quote Reference'));
            return;
        }
        
        activeQNum = 1;
        
        if(/*userinfo.getUserType() == 'Standard' &&*/ 
           (oQuote.IFS_Order_Status__c == null || oQuote.IFS_Order_Status__c == 'Planned')){
            activeQNum = 5; 
        }
        else if(/*userinfo.getUserType() != 'Standard' &&*/ oQuote.IFS_Order_Status__c == 'Released'){
            activeQNum = 1; 
        }
           
        lstCOCW = new list<ChangeOrderConfigWrapper>();
        list<Change_Order_Config_V2__mdt> lstChangeOrderConfig = [Select Id,Question__c,Option__c,Action__c,Order__c,Type__c,Question_Hint__c,
                                                                  Force_Next__c
                                                                  From Change_Order_Config_V2__mdt
                                                                  Where Active__c = true
                                                                  Order By Order__c];
        if(lstChangeOrderConfig.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid Change Order Configuration'));
            return;
        }
        
        for(Change_Order_Config_V2__mdt coc : lstChangeOrderConfig)
        {
            ChangeOrderConfigWrapper oCOCW = new ChangeOrderConfigWrapper(oQuote,coc);
            lstCOCW.add(oCOCW);
        }
        System.debug('@Developer --> lstCOCW :' + lstCOCW);  
    }
    
    public void onBack(){
        System.debug('@Developer --> onBack :');
        System.debug('@Developer --> activeQNum :' + activeQNum);
        navigationTrack.printStack();
        bCommercialSelected = false;
        bCommercialNonChargesSelected = false;
        bCommercialChargesSelected = false;
        
        ChangeOrderConfigWrapper oCOCW = lstCOCW.get(integer.valueOf(activeQNum)-1);
        System.debug('@Developer --> oCOCW.selectedAnswer :' + oCOCW.selectedAnswer);
        oCOCW.selectedAnswer = '';
        oCOCW.lstSelectedAnswer = null;
        if(oCOCW.oChangeOrderConfig.Type__c == 'QuoteLineGrid'){
            for(QuoteLineWrapper qlw : oCOCW.lstQuoteLineWrapper){
                qlw.selectedAnswer = '';
            }
        }
        
        if(!navigationTrack.isEmpty()){
            Integer prevQNum = navigationTrack.pop();
            System.debug('@Developer --> prevQNum :' + prevQNum);
            activeQNum = prevQNum;   
            oCOCW = lstCOCW.get(integer.valueOf(activeQNum)-1);
            oCOCW.selectedAnswer = '';
            oCOCW.lstSelectedAnswer = null;
            if(oCOCW.oChangeOrderConfig.Type__c == 'QuoteLineGrid'){
                for(QuoteLineWrapper qlw : oCOCW.lstQuoteLineWrapper){
                    qlw.selectedAnswer = '';
                }
            }
        }
    }
    
    public PageReference onAnswer(){
        System.debug('@Developer --> onAnswer :');
        System.debug('@Developer --> activeQNum :' + activeQNum);      
        bConfigSelected = false;
        bCommercialSelected = false;
        bCommercialNonChargesSelected = false;
        bCommercialChargesSelected = false;
        bConfigOrderLinesSelected = false;
        
        ChangeOrderConfigWrapper oCOCW = lstCOCW.get(integer.valueOf(activeQNum)-1);
        activeActionType = '';
        activeAlert = '';
        System.debug('@Developer --> oCOCW.oChangeOrderConfig.Type__c :' + oCOCW.oChangeOrderConfig.Type__c);
        System.debug('@Developer --> oCOCW.selectedAnswer :' + oCOCW.selectedAnswer);
        System.debug('@Developer --> oCOCW.lstSelectedAnswer :' + oCOCW.lstSelectedAnswer);
        
        System.debug('@Developer --> oCOCW.lstAnswer :' + oCOCW.lstAnswer);     
        System.debug('@Developer --> oCOCW.lstAction :' + oCOCW.lstAction);     
        
        if(oCOCW.oChangeOrderConfig.Type__c == 'Checkbox'){
            System.debug('@Developer -->Checkbox:' );
            for(String sChkbox : oCOCW.lstSelectedAnswer){
                if(setConfigType.contains(sChkBox)){
                    bConfigSelected = true;
                    if(sChkBox == 'Order Lines'){
                        bConfigOrderLinesSelected = true;
                    }
                }
                else if(setCommercialType.contains(sChkBox)){
                    bCommercialSelected = true;
                    if(sChkBox == 'Charges'){
                        bCommercialChargesSelected = true;
                    }
                }
            }
        }
        
        if(oCOCW.oChangeOrderConfig.Type__c == 'QuoteLineGrid'){
            System.debug('@Developer -->QuoteLineGrid:' );
            
            for(QuoteLineWrapper qlw : oCOCW.lstQuoteLineWrapper){
                System.debug('@Developer --> qlw.selectedAnswer :' + qlw.selectedAnswer);
                if(qlw.selectedAnswer != '' && qlw.selectedAnswer != null){
                    oCOCW.lstSelectedAnswer = new list<String>{qlw.selectedAnswer};
                    //break;
                }
            }
        }
        
        mapChangeOrderOptionWiseCOODs = new map<String,List<Change_Order_Option_Details__mdt>>();
        set<String> setChangeOrderConfigDetail = new set<String>();
        Boolean bChangeOrderLogUpdated = false;
        
        for(Integer indx=0; indx < oCOCW.lstAnswer.size();indx++){
            String sAnswer ;
            
            if(oCOCW.lstAnswer[indx].contains(':')){
                list<String> lstAnswerDetails = oCOCW.lstAnswer[indx].split(':');
                sAnswer = lstAnswerDetails[1];
            }
            else{
                sAnswer = oCOCW.lstAnswer[indx];
            }
            System.debug('@Developer --> sAnswer :' + sAnswer);  
            
            if(oCOCW.lstSelectedAnswer.contains(sAnswer)){
                String actions = oCOCW.lstAction[indx];
                System.debug('@Developer --> actions :' + actions);
                
                for(String action : actions.replace('\n','').replace('\r','').split('\\|')){
                    List<String> lstActionDetail = action.split(':');
                    System.debug('@Developer --> lstActionDetail :' + lstActionDetail);
                    
                    if(lstActionDetail.size() > 1){
                        activeActionType = lstActionDetail[0];
                        System.debug('@Developer --> activeActionType :*' + activeActionType);
                        
                        if(lstActionDetail[0] == 'Question'){
                            navigationTrack.push(Integer.valueOf(activeQNum));  
                            activeQNum = decimal.valueOf(lstActionDetail[1]);
                            
                            if(!navigationTrack.isEmpty()){
                                Integer prevQNum = navigationTrack.pop();
                                if(prevQNum != activeQNum){
                                    navigationTrack.push(Integer.valueOf(prevQNum));    
                                }
                            }
                        }
                        else if(lstActionDetail[0] == 'Action'){
                            if(lstActionDetail[1] == 'UpdateQuote'){
                                SBQQ__Quote__c qt = oQuote;
                                //qt.Id = quoteId;
                                if(!bChangeOrderLogUpdated && lstActionDetail[2] == 'ChangeOrderLog'){
                                    qt.Change_Order_Log__c = String.join(oCOCW.lstSelectedAnswer,';');
                                    System.Debug('Commercial=>'+bCommercialSelected+'<=Config=>'+bConfigSelected);
                                    if(bCommercialSelected && !bConfigSelected){
                                    	System.debug('Change Order No Old=>'+qt.Change_Order_No__c);
                                        qt.Change_Order_No__c =  qt.Change_Order_No__c == null ? 1 : qt.Change_Order_No__c + 1;
                                        System.debug('Change Order No New=>'+qt.Change_Order_No__c);
                                    }
                                    update qt;
                                    bChangeOrderLogUpdated = true;
                                }
                                else if(qt.Change_Order_Status__c != lstActionDetail[2]){
                                    if(lstActionDetail[2] == 'Blocked'){
                                        //qt.SBQQ__Status__c = 'Blocked';
                                        qt.Change_Order_Status__c = 'Blocked';
                                        qt.Status_Reason__c = sAnswer;
                                        update qt;
                                        if(lstActionDetail[3] == 'IFSOperations.cancelOrderIFS'){
                                            IFSOperations.cancelOrderIFS(NULL, quoteId);
                                        }
                                    }
                                    if(lstActionDetail[2] == 'Cancel'){
                                        //qt.SBQQ__Status__c = 'Cancel';
                                        qt.Change_Order_Status__c = 'Cancel';
                                        qt.Status_Reason__c = sAnswer;
                                        update qt;
                                        if(lstActionDetail[3] == 'IFSOperations.cancelOrderIFS'){
                                            IFSOperations.cancelOrderIFS(NULL, quoteId);
                                            IFSOperations.createCreditsAndBooking(quoteId);
                                        }
                                    }
                                    if(lstActionDetail[2] == 'Unblock'){
                                        qt.Change_Order_Status__c = 'Unblock';
                                        qt.Status_Reason__c = null;
                                        update qt;
                                        if(lstActionDetail[3] == 'IFSOperations.cancelOrderIFS'){
                                            IFSOperations.cancelOrderIFS(NULL, quoteId);
                                        }
                                    }
                                }
                            }
                            
                            if(lstActionDetail[1] == 'UpdateQuoteLines'){
                                list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>();
                                
                                for(QuoteLineWrapper qlw : oCOCW.lstQuoteLineWrapper){
                                    System.debug('@Developer --> qlw.selectedAnswer :' + qlw.selectedAnswer);
                                    
                                    if(qlw.selectedAnswer != '' && qlw.selectedAnswer != null){
                                        if(qlw.oQuoteLine.Change_Order_Status__c != lstActionDetail[2]){
                                            if(lstActionDetail[2] == 'Blocked'){
                                                //qlw.oQuoteLine.Line_Status__c = 'Blocked';
                                                qlw.oQuoteLine.Change_Order_Status__c = 'Blocked';
                                                qlw.oQuoteLine.Status_Reason__c = qlw.selectedAnswer;
                                                lstQuoteLine.add(qlw.oQuoteLine);
                                            }
                                            if(lstActionDetail[2] == 'Cancel'){
                                                //qlw.oQuoteLine.Line_Status__c = 'Cancel';
                                                qlw.oQuoteLine.Change_Order_Status__c = 'Cancel';
                                                qlw.oQuoteLine.Status_Reason__c = qlw.selectedAnswer;
                                                lstQuoteLine.add(qlw.oQuoteLine);
                                            }
                                        }
                                    }
                                    else{
                                        if(lstActionDetail[2] == 'Unblock'){
                                            if(qlw.oQuoteLine.Change_Order_Status__c == 'Blocked'){   
                                                qlw.oQuoteLine.Change_Order_Status__c = 'Unblock';
                                                qlw.oQuoteLine.Status_Reason__c = null;
                                                lstQuoteLine.add(qlw.oQuoteLine);
                                            }
                                        }
                                    }
                                }
                                
                                System.debug('@Developer --> lstQuoteLine.size() :' + lstQuoteLine.size());
                                if(lstQuoteLine.size() > 0 ){
                                    update lstQuoteLine;
                                    if(lstActionDetail[3] == 'IFSOperations.cancelOrderIFS'){
                                        IFSOperations.cancelOrderIFS(NULL, quoteId);
                                        IFSOperations.createCreditsAndBooking(quoteId);
                                        System.debug('@Developer -->UpdateQuoteLines:IFSOperations.cancelOrderIFS called...' );
                                    }
                                }
                            }
                        }
                        else if(lstActionDetail[0] == 'Alert'){
                            activeAlert = lstActionDetail[1];
                            System.debug('@Developer --> activeAlert :' + activeAlert);
                        }
                        else if(lstActionDetail[0] == 'UpdateFields'){
                            setChangeOrderConfigDetail.add(lstActionDetail[1]);
                        }
                        else if(lstActionDetail[0] == 'Submit'){
                            System.debug('@Developer --> Submit :');
                            
                            if(!bCommercialSelected){
                                if(lstActionDetail[1] == 'QuoteCommentController.callPageReference'){
                                    Id newCloneQuoteId = QuoteCommentController.callPageReference(quoteId); 
                                    
                                    if(lstActionDetail[2] == 'NavigateClonedQuote'){
                                        return new PageReference('/lightning/r/SBQQ__Quote__c/' + newCloneQuoteId + '/view');
                                    }
                                }
                            }
                            
                            if(lstActionDetail[1] == 'NavigateQuote'){
                               return new PageReference('/lightning/r/SBQQ__Quote__c/' + quoteId + '/view');
                            }
                        }
                    }
                }
            }
        }
        
        if(setChangeOrderConfigDetail.size() > 0){
            bCommercialNonChargesSelected = true;
            System.debug('@Developer --> setChangeOrderConfigDetail :' + setChangeOrderConfigDetail);
            fetchChangeOrderConfigDetails(setChangeOrderConfigDetail);
        }
        
        if(bCommercialSelected && bCommercialChargesSelected){
            lstChargeWrapper = fetchCharges(quoteId);
        }
        
        navigationTrack.printStack();
        return null;
    }
    
    public list<ChargeWrapper> fetchCharges(String quoteId){
        list<ChargeWrapper> lstChargeWrapper = new list<ChargeWrapper>();
        Integer indx = 0;
        for(Charge__c charge : [Select Id, Amount__c, Quantity__c, Type__c, Status__c,
                                Update__c,Status_Updated__c,Quantity_Updated__c,Amount_Updated__c,
                                Previous_Amount__c,Previous_Quantity__c
                                From Charge__c 
                                Where Parent_Quote__c =:quoteId
                                Order By CreatedDate
                               ]){
            ChargeWrapper oCW = new ChargeWrapper(indx++,charge);
            lstChargeWrapper.add(oCW);
        }
        return lstChargeWrapper;
    }
    
    public void addCharge(){
        System.debug('@Developer -->deleteCharge:' );
        Integer nIndx = lstChargeWrapper.size();
        Charge__c oCharge = new Charge__c();
        oCharge.Parent_Quote__c = quoteId;
        lstChargeWrapper.add(new ChargeWrapper(nIndx,oCharge));
    }
    
    public void deleteCharge(){
        System.debug('@Developer -->deleteCharge:' );
        System.debug('@Developer --> nDelChargeIndx :' + nDelChargeIndx);
        ChargeWrapper cw = lstChargeWrapper.get(nDelChargeIndx);
        if(cw.oCharge.Id != null){
            delete cw.oCharge;
        }
        lstChargeWrapper.remove(nDelChargeIndx);
        for(Integer nIndx = nDelChargeIndx ; nIndx < lstChargeWrapper.size() ; nIndx++){
            cw = lstChargeWrapper.get(nIndx);
            cw.nIndex -= 1; 
        }
    }
    
    public void saveCharges(){
        try{
            list<Charge__c> lstCharge = new list<Charge__c>();
            for(ChargeWrapper cw : lstChargeWrapper){
                System.debug('@Developer --> cw.oCharge :' + cw.oCharge);
                
                cw.oCharge.Update__c = false;
                cw.oCharge.Amount_Updated__c = false;
                cw.oCharge.Quantity_Updated__c = false;
                cw.oCharge.Status_Updated__c = false;
                
                if(cw.oCharge.Id != null){
                    cw.oCharge.Update__c = true;
                    
                    System.debug('@Developer --> cw.amount :' + cw.amount);
                    System.debug('@Developer --> cw.oCharge.Amount__c :' + cw.oCharge.Amount__c);
                    if(cw.amount != null &&  cw.amount != cw.oCharge.Amount__c){
                        cw.oCharge.Previous_Amount__c = cw.amount;
                        cw.oCharge.Amount_Updated__c = true;
                    }
                    
                    System.debug('@Developer --> cw.quantity :' + cw.quantity);
                    System.debug('@Developer --> cw.oCharge.Quantity__c :' + cw.oCharge.Quantity__c);
                    if(cw.quantity != null && cw.quantity != cw.oCharge.Quantity__c){
                        cw.oCharge.Previous_Quantity__c = cw.quantity;
                        cw.oCharge.Quantity_Updated__c = true;
                    }
                    
                    System.debug('@Developer --> cw.status :' + cw.status+'*');
                    System.debug('@Developer --> cw.oCharge.Status__c :' + cw.oCharge.Status__c+'*');
                    if(cw.status != null &&  cw.status != cw.oCharge.Status__c){
                        cw.oCharge.Status_Updated__c = true;
                    }
                }
                else{ // when new charge is created
                    if(cw.oCharge.Status__c == null){
                        cw.oCharge.Status__c = 'Charged';
                    }
                }
                lstCharge.add(cw.oCharge);
            }
            if(lstCharge.size() > 0){
                upsert lstCharge;
                lstChargeWrapper.clear();
                lstChargeWrapper = fetchCharges(quoteId);
            }
            system.debug('line #385:=>'+lstCharge);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    /*public void toggleAttachmentPanel(){
        System.debug('@Developer -->toggleAttachmentPanel:' );
    	bShowAddAttachment = !bShowAddAttachment;    
    }*/
    
    public PageReference navigateToQuote(){
        System.debug('@Developer -->navigateToQuote:');
        PageReference oPR = new PageReference('/lightning/r/SBQQ__Quote__c/' + quoteId + '/view');
        return oPR;
    }
    
    public PageReference saveQuoteDetails(){
        System.debug('@Developer -->saveQuoteDetails:' );
        try{
            update oQuote;
            
            if(bCommercialSelected && !bConfigSelected){
                IFSOperations.generateAndSyncPartsAndOrder(oQuote.Id);
            }
            
            if(bConfigSelected){
                Id newCloneQuoteId = QuoteCommentController.callPageReference(oQuote.Id);
                return new PageReference('/lightning/r/SBQQ__Quote__c/' + newCloneQuoteId + '/view');
            }
            
            return new PageReference('/lightning/r/SBQQ__Quote__c/' + oQuote.Id + '/view');
        }
        catch (DMLException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getdmlMessage(0)));
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }     
        return null;
    }
    
    public void fetchChangeOrderConfigDetails(set<String> setChangeOrderConfigDetail){
        System.debug('@Developer -->fetchChangeOrderConfigDetails:' );
        System.debug('@Developer --> setChangeOrderConfigDetail :' + setChangeOrderConfigDetail);
        list<String> lstFieldApi = new list<String>();
        for(Change_Order_Option_Details__mdt cood: [Select Id,Change_Order_Option__c,Field_Label__c,Field_API__c,Order__c,
                                                    Section_Header__c,Section_Description__c
                                                    From Change_Order_Option_Details__mdt
                                                    Where Change_Order_Option__c In :setChangeOrderConfigDetail
                                                    And Active__c = true
                                                    Order By Change_Order_Option__c, Order__c 
                                                   ])
        {
            list<Change_Order_Option_Details__mdt> lstCOOD;
            String key = cood.Change_Order_Option__c;
            if(mapChangeOrderOptionWiseCOODs.containsKey(key)){
                lstCOOD = mapChangeOrderOptionWiseCOODs.get(key);
            }  
            else{
                lstCOOD = new list<Change_Order_Option_Details__mdt>();
            }
            lstCOOD.add(cood);
            mapChangeOrderOptionWiseCOODs.put(key,lstCOOd);
            
            if(!lstFieldApi.contains(cood.Field_API__c)){
                lstFieldApi.add(cood.Field_API__c);
            }
        }
        System.debug('@Developer --> mapChangeOrderOptionWiseCOODs :' + mapChangeOrderOptionWiseCOODs);
        System.debug('@Developer --> lstFieldApi :' + lstFieldApi);
        String sSOQL = 'Select Id,Name,Change_Order_No__c,Change_Order_Status__c';
        if(lstFieldApi.size() > 0){
            sSOQL += ',' + String.join(lstFieldApi,',');    
        }
        sSOQL += ' From SBQQ__Quote__c ';
        sSOQL += ' Where Id = \'' + quoteId + '\' ';
        System.debug('@Developer --> sSOQL :' + sSOQL);
        
        for(SBQQ__Quote__c q : database.query(sSOQL)){
            oQuote = q;    
        }
        System.debug('@Developer --> oQuote :' + oQuote);
        if(oQuote == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid Quote reference.'));
        }
    }
    
    public class ChargeWrapper{
        public Integer nIndex {get;set;}
        public Charge__c oCharge {get;set;}
        public decimal amount{get;set;}
        public decimal quantity{get;set;}
        public string status{get;set;}
        public ChargeWrapper(Integer indx,Charge__c charge){
            nIndex = indx;
            oCharge = charge;
            amount = charge.Amount__c;
            quantity = charge.Quantity__c;
            status = charge.Status__c;
        }
    }
    
    public class QuoteLineWrapper{
        public String selectedAnswer {get;set;}
        public SBQQ__QuoteLine__c oQuoteLine {get;set;}
        
        public QuoteLineWrapper(SBQQ__QuoteLine__c qli){
            selectedAnswer = '';
            oQuoteLine = qli;
        }
    }
    
    public class ChangeOrderConfigWrapper{
        public SBQQ__Quote__c oQuote {get;set;}
        public list<QuoteLineWrapper> lstQuoteLineWrapper {
            get{
                if(lstQuoteLineWrapper == null){
                    lstQuoteLineWrapper = new list<QuoteLineWrapper>();
                    for(SBQQ__QuoteLine__c qli : oQuote.SBQQ__LineItems__r){
                        QuoteLineWrapper qlw = new QuoteLineWrapper(qli);
                        lstQuoteLineWrapper.add(qlw);
                    }
                }
                return lstQuoteLineWrapper;
            }
            set;}
        
        public Change_Order_Config_V2__mdt oChangeOrderConfig {get;set;}
        public list<String> lstAnswer {get;set;}
        public list<selectOption> lstAnswerOption {get;set;}
        
        public list<String> lstAction {get;set;}        
        public String selectedAnswer {get;set;} 
        
        public list<String> lstSelectedAnswer {
            get{
                if(lstSelectedAnswer == null){
                    return new list<String>{this.selectedAnswer};    
                        }
                return lstSelectedAnswer; 
            }
            set;}
        
        public ChangeOrderConfigWrapper(SBQQ__Quote__c qt, Change_Order_Config_V2__mdt coc){
            oQuote = qt;
            oChangeOrderConfig = coc;
            lstAnswer = new list<String>();
            lstAnswerOption = new list<SelectOption>();
            
            lstAction = new list<String>();
            
            if(oChangeOrderConfig.type__c == 'QuoteLineGrid'){
                lstAnswerOption.add(new SelectOption('','--Select--'));
                for(String s:oChangeOrderConfig.Option__c.split(';')){
                    s = s.replace('\n','').replace('\r','');
                    System.debug('@Developer --> ans :' + s);
                    list<String>lstOptionDetail = s.split(':');
                    System.debug('@Developer --> lstOptionDetail :' + lstOptionDetail);
                    if(lstOptionDetail.size() > 1){
                        lstAnswer.add(lstOptionDetail[1]);
                        lstAnswerOption.add(new SelectOption(lstOptionDetail[1],lstOptionDetail[0]));
                    }
                }
            }
            else{
                if(oChangeOrderConfig.type__c == 'Picklist'){
                    lstAnswerOption.add(new SelectOption('','--Select--'));
                    for(String s:oChangeOrderConfig.Option__c.split(';')){
                        s = s.replace('\n','').replace('\r','');
                        System.debug('@Developer --> ans :' + s);
                        list<String>lstOptionDetail = s.split(':');
                        System.debug('@Developer --> lstOptionDetail :' + lstOptionDetail);
                        if(lstOptionDetail.size() > 1){
                            lstAnswer.add(lstOptionDetail[1]);
                            lstAnswerOption.add(new SelectOption(lstOptionDetail[1],lstOptionDetail[0]));
                        }
                    }
                }
                else{
                    for(String s:oChangeOrderConfig.Option__c.split(';')){
                        s = s.replace('\n','').replace('\r','');
                        System.debug('@Developer --> ans :' + s);
                        lstAnswer.add(s);
                        lstAnswerOption.add(new SelectOption(s,s));
                    }
                }
            }
            
            for(String s:oChangeOrderConfig.Action__c.split(';')){
                s = s.replace('\n','').replace('\r','');
                System.debug('@Developer --> act :' + s);
                lstAction.add(s.replace('\n','').replace('\r',''));
            }
        }
    }
    
    public class Stack {
        private List<Integer> items {get; set;}
        
        public Stack() {
            this.items = new List<Integer>();
        }
        
        public Integer size() {
            return this.items.size();
        }
        
        public Boolean isEmpty() {
            return size() == 0;
        }
        
        public void push(Integer itemToPush) {
            this.items.add(itemToPush);
        }
        
        public Integer pop() {
            if (isEmpty()) {
                throw new StackUnderflowException();
            }
            
            return this.items.remove(size() - 1);
        }
        
        public Integer peek() {
            if (isEmpty()) {
                throw new StackUnderflowException();
            }
            
            return this.items.get(size() - 1);
        }    
        
        public void printStack(){
            System.debug('@Developer --> printStack: items :' + this.items);
        }
    }
    
    public class StackUnderflowException extends Exception {}
}