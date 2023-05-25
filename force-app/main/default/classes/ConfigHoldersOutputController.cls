/**
* @File Name          : ConfigHoldersOutputController.cls
* @Description        :
* @Author             : Nikhil Arpally
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 11/6/2020, 2:11:48 pm
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    11/6/2020     Nikhil Arpally                Initial Version
* 1.1    23-APR-2021   Rohini Hathi               Service Ticket #202464
**/
public with sharing class ConfigHoldersOutputController {
    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public string strQuoteStatus {set;get;}
    public String selectedTab{get;set;}
    public Holders__c conHolder {get; set;}
    public boolean showsales {get;set;}
    public ConfigHolderUtility HLDU {get; set;}
    public String prodDesc1 {get; set;}
    public String prodDesc2 {get; set;}
    public String prodDesc3 {get; set;}
    private id quoteId;
    public List<HLDRStructureWrapper> strucData{get;set;}

    public List<Holder_Leadtime_Schedule__c> listScheduleName = new List<Holder_Leadtime_Schedule__c>();
    public map<String,String> holderAllIFSAttributes {set;get;}
    public map<String,String> holderInputs {set; get;}
    public map<String,String> lookupAttributes {set; get;}
    public map<String,String> lookupAttributesAll {set; get;}
    public map<String,String> additionalCodeAttributesMap {set; get;}
    public map<String,String> testingCodeAttributesMap {set; get;}
    public list<Holder_Price_Details__c> holderPricingList;
    private static final set<String> discuontablePriceElements = ConfigHolderUtility.discuontablePriceElements();
    public List<Holder_Outputs__c> hldOutputlIST {set;get;}
    public Holder_Outputs__c hldOutput {set;get;}
    public string strURL{get;set;}
    // private string INLETCOMPPTC;
    // private String OUTLETCOMPPTC;
    public boolean bReadOnlyChceckBox {get;set;} // added by piyush
    public boolean bHasPortalUser {get;set;} // added by piyush
    public ProductAccessibilityConfig__mdt oPacMetaData;
    public map<string,Holder_Price_Output__c> pricingOverrideOutputs;
    public boolean bReadOnlyChceckBoxImage {get;set;} //added by piyush
    public ConfigHoldersOutputController(ApexPages.StandardController controller) {

        //Nagrjuna added Tab visibility logic
        showsales = False;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('CDC Inside Sales');
        profilesetstr.add('CDC Partner Community Users Profile');
        //profilesetstr.add('CDC Prod. Planning');
        profilesetstr.add('CDC Business Super User');
        if(!profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }

        // visibility logic ended

        quoteId=ApexPages.currentPage().getParameters().get('qid');
        system.debug('@@Test in const quoteId => '+ quoteId);
        conHolder = DataSelectorWizard.getHolderProductRecord(quoteId);

        if(conHolder.Part_Number_Base__c != null) {

            conHolder.Part_Number_Base_Backup__c = conHolder.Part_Number_Base__c;
        }
        if(conHolder.ASSYPARTEXISTING_Backup__c == null && conHolder.ASSYPARTEXISTING__c != null) {

            conHolder.ASSYPARTEXISTING_Backup__c = conHolder.ASSYPARTEXISTING__c ;
        }
        system.debug(' conHolder Size '+conHolder.Size__c);
        if(string.isNotBlank(quoteId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
        strBrand=[select Quote_Line__r.SBQQ__Quote__r.Brand__c from Holders__c where id=:conHolder.Id].Quote_Line__r.SBQQ__Quote__r.Brand__c;

        holderPricingList = new list<Holder_Price_Details__c >();

        listScheduleName=[SELECT Entity__c,Leadtime__c,QtyLL__c,QtyUL__c,Schedule__c FROM Holder_Leadtime_Schedule__c WHERE Entity__c=:strBrand ];

        holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        System.debug('holderInputs...'+holderInputs.get('InletTest'));
        lookupAttributes = ConfigHolderUtility.lookupAttributes(holderInputs);
        lookupAttributesAll=ConfigHolderUtility.lookupAttributesAll(holderInputs);
        testingCodeAttributesMap=ConfigHolderUtility.testingCodeAttributesMap(holderInputs);
        System.debug('holderInputs...'+testingCodeAttributesMap.get('InletTest'));
        additionalCodeAttributesMap=ConfigHolderUtility.additionalCodeAttributesMap(holderInputs);
        mapDocData=new Map<String,String>();
        //getDiaData();

        strucData = new List<HLDRStructureWrapper>();
        //strucData=getStructures();

        hldOutputlIST=[select OA__c,OA_Overridden__c,OB__c,OB_Overridden__c,OW__c,OW_Overridden__c,Lead_Time__c,Lead_Time_Override__c FROM Holder_Outputs__c WHERE ReferenceId__c=:conHolder.Id];
        if(hldOutputlIST.size()>0)
            hldOutput=hldOutputlIST[0];
        else
            hldOutput=new Holder_Outputs__c();
        conHolder.ASSYPARTNOBASE__c = conHolder.Part_Number_Base__c;
        System.debug('Holder ID=====================>>>>>' +conHolder.id);

        // added by piyush
        bReadOnlyChceckBox = false;

        system.debug('Holder  --> Finish_Configuration__c ' + conHolder.Finish_Configuration__c);
        system.debug('Holder Quote_Descriptions_Override__c --> ' + conHolder.Quote_Descriptions_Override__c);
        string configStatus;
        string defaultQuoteLineView;
        string QuoteLIneView;
        if(conHolder.Finish_Configuration__c){
           if(conHolder.Quote_Descriptions_Override__c){
              // complete with override
              configStatus = 'Complete with Override(s)';

           }else{
                  // complete no override
                  configStatus = 'Complete No Overrides';
           }
        }else{
            configStatus = 'Incomplete';
                 // incomplete
        }
        system.debug('quoteStatus----> ' + strQuoteStatus);
        system.debug('configStatus----> ' + configStatus);
        oPacMetaData = fetchCurrentProductAccessibility( strQuoteStatus , configStatus);
        system.debug('oPacMetaData----> ' + oPacMetaData);
       // bShowEditButton = false;
        bReadOnlyChceckBox = false;
        //bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;
        QuoteLIneView = oPacMetaData.View__c;

        system.debug('QuoteLIneView----> ' + QuoteLIneView);
       /* if(QuoteLIneView == 'Editable'){
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable'){
                disableButton = false;
                bShowEditButton = false;
            }else{
                disableButton = true;
            }

        }else*/
        if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
        }
        system.debug('bReadOnlyChceckBox----> ' + bReadOnlyChceckBox);


         //added by piyush
        // bShowEditButtonImage = bShowEditButton;
         bReadOnlyChceckBoxImage = bReadOnlyChceckBox;
         if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
           // bShowEditButtonImage = false;
            bReadOnlyChceckBoxImage = true;
         }


        bHasPortalUser = false;

        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            bHasPortalUser = true;
        }

    }

	//Reorder purpose Code added by Vikram

    public ConfigHoldersOutputController(Id quoteId) {

        //Nagrjuna added Tab visibility logic
        showsales = False;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('CDC Inside Sales');
        profilesetstr.add('CDC Partner Community Users Profile');
        //profilesetstr.add('CDC Prod. Planning');
        profilesetstr.add('CDC Business Super User');
        if(!profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }

        // visibility logic ended
      //  	quoteId=ApexPages.currentPage().getParameters().get('qid');
        system.debug('@@Test in const quoteId => '+ quoteId);
        conHolder = DataSelectorWizard.getHolderProductRecord(quoteId);

        if(conHolder.Part_Number_Base__c != null) {

            conHolder.Part_Number_Base_Backup__c = conHolder.Part_Number_Base__c;
        }
        if(conHolder.ASSYPARTEXISTING_Backup__c == null && conHolder.ASSYPARTEXISTING__c != null) {

            conHolder.ASSYPARTEXISTING_Backup__c = conHolder.ASSYPARTEXISTING__c ;
        }
        system.debug(' conHolder Size '+conHolder.Size__c);
        if(string.isNotBlank(quoteId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
        strBrand=[select Quote_Line__r.SBQQ__Quote__r.Brand__c from Holders__c where id=:conHolder.Id].Quote_Line__r.SBQQ__Quote__r.Brand__c;

        holderPricingList = new list<Holder_Price_Details__c >();

        listScheduleName=[SELECT Entity__c,Leadtime__c,QtyLL__c,QtyUL__c,Schedule__c FROM Holder_Leadtime_Schedule__c WHERE Entity__c=:strBrand ];

        holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        lookupAttributes = ConfigHolderUtility.lookupAttributes(holderInputs);
        lookupAttributesAll=ConfigHolderUtility.lookupAttributesAll(holderInputs);
        testingCodeAttributesMap=ConfigHolderUtility.testingCodeAttributesMap(holderInputs);
        additionalCodeAttributesMap=ConfigHolderUtility.additionalCodeAttributesMap(holderInputs);
        mapDocData=new Map<String,String>();
        //getDiaData();

        strucData = new List<HLDRStructureWrapper>();
        //strucData=getStructures();

        hldOutputlIST=[select OA__c,OA_Overridden__c,OB__c,OB_Overridden__c,OW__c,OW_Overridden__c,Lead_Time__c,Lead_Time_Override__c FROM Holder_Outputs__c WHERE ReferenceId__c=:conHolder.Id];
        if(hldOutputlIST.size()>0)
            hldOutput=hldOutputlIST[0];
        else
            hldOutput=new Holder_Outputs__c();
        conHolder.ASSYPARTNOBASE__c = conHolder.Part_Number_Base__c;
        System.debug('Holder ID=====================>>>>>' +conHolder.id);

        // added by piyush
        bReadOnlyChceckBox = false;

        system.debug('Holder  --> Finish_Configuration__c ' + conHolder.Finish_Configuration__c);
        system.debug('Holder Quote_Descriptions_Override__c --> ' + conHolder.Quote_Descriptions_Override__c);
        string configStatus;
        string defaultQuoteLineView;
        string QuoteLIneView;
        if(conHolder.Finish_Configuration__c){
           if(conHolder.Quote_Descriptions_Override__c){
              // complete with override
              configStatus = 'Complete with Override(s)';

           }else{
                  // complete no override
                  configStatus = 'Complete No Overrides';
           }
        }else{
            configStatus = 'Incomplete';
                 // incomplete
        }
        system.debug('quoteStatus----> ' + strQuoteStatus);
        system.debug('configStatus----> ' + configStatus);
        oPacMetaData = fetchCurrentProductAccessibility( strQuoteStatus , configStatus);
        system.debug('oPacMetaData----> ' + oPacMetaData);
       // bShowEditButton = false;
        bReadOnlyChceckBox = false;
        //bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;
        QuoteLIneView = oPacMetaData.View__c;

        system.debug('QuoteLIneView----> ' + QuoteLIneView);
       /* if(QuoteLIneView == 'Editable'){
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable'){
                disableButton = false;
                bShowEditButton = false;
            }else{
                disableButton = true;
            }

        }else*/
        if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
        }
        system.debug('bReadOnlyChceckBox----> ' + bReadOnlyChceckBox);


         //added by piyush
        // bShowEditButtonImage = bShowEditButton;
         bReadOnlyChceckBoxImage = bReadOnlyChceckBox;
         if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
           // bShowEditButtonImage = false;
            bReadOnlyChceckBoxImage = true;
         }


        bHasPortalUser = false;

        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            bHasPortalUser = true;
        }

    }

    //Reorder Code Ends here

    public pageReference goBackToProdConfig() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId].Id;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL =  '/apex/ConfigHolders?qId=' + qID + '&id=' + conHolder.Id;
        }else{
            strURL =  '/apex/ConfigHolders?qId=' + qID + '&id=' + conHolder.Id;

        }
        return null;
    }
    public pageReference goBackToQuote() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL =  '/s/detail/'+qID ;
        }else{
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }
        //PageReference pageRef = new PageReference('/lightning/r/SBQQ__Quote__c/'+qID+'/view');
        //pageRef.setRedirect(true);
        return null;
    }

       // added by piyush

       private ProductAccessibilityConfig__mdt fetchCurrentProductAccessibility(string sQuoteStatus, string sConfigStatus){
        ProductAccessibilityConfig__mdt oPac;
       system.debug('meta --> ' + UtilityHelper.self.lstProductAccessibilityConfigs);
     for(ProductAccessibilityConfig__mdt pac : UtilityHelper.self.lstProductAccessibilityConfigs){
      list<string> lstQuoteStatus = pac.Quote_Status__c.split(';');
      if(lstQuoteStatus.contains(sQuoteStatus)){
        if(pac.Config_Status__c == 'All' && oPac == null){
            oPac = pac;
        }else{
            if(pac.Config_Status__c == sConfigStatus){
                oPac = pac;
            }
        }
      }
     }

     return oPac == null ? new ProductAccessibilityConfig__mdt() : oPac;
    }

    public string strBrand {set;get;}
    public Map<string,string> mapHLDRAttr{
        get{
            Map<String, string> myMap1 = new Map<String, string>();
            myMap1.put('SZC',conHolder.Size__c);
            //myMap1.put('',RGEUNT);
            return myMap1;
        }
        set{
            this.mapHLDRAttr=value;
        }
    }
    public List<string> notValidStatusForChng {
        get {
            return new List<String>{'Approved','Order Submitted'};
                }
        set {
            this.notValidStatusForChng=value;
        }
    }

    public Pagereference SavePriceOverride(){
        system.debug('in price oveeride ========= ');

        Holder_Price_Output__c holderPriceEle;
        if(conHolder.Price_Engineer_Override__c){
            list<Holder_Price_Output__c> holderPriceElementList = new list<Holder_Price_Output__c>();
            for(Holder_Price_Details__c pd: holderPricingList){
                if(pd.Price_Override__c != pd.Price__c){
                    if(pricingOverrideOutputs.containsKey(pd.Pricing_Element__c)){

                        holderPriceEle = pricingOverrideOutputs.get(pd.Pricing_Element__c);
                        holderPriceEle.List_Price__c = pd.Price__c;
                        holderPriceEle.List_Price_Override__c = pd.Price_Override__c;
                        holderPriceElementList.add(holderPriceEle);

                    }else{

                        holderPriceEle = new Holder_Price_Output__c();
                        holderPriceEle.Holders__c = conHolder.Id;
                        holderPriceEle.List_Price__c = pd.Price__c;
                        holderPriceEle.List_Price_Override__c = pd.Price_Override__c;
                        holderPriceEle.Price_Element__c = pd.Pricing_Element__c;
                        holderPriceElementList.add(holderPriceEle);
                    }

                    system.debug('Pricing_Element :: '+pd.Pricing_Element__c + ' ## '+pd.Price_Override__c);
                }
            }
            if(holderPriceElementList.size() > 0){
                list<Holder_Price_Output__c> holderPriceListToDelete = new list<Holder_Price_Output__c>();
                for(Holder_Price_Output__c hpo: holderPriceElementList){
                    system.debug(' holderPriceElementList '+hpo);
                    if(! pricingOverrideOutputs.containsKey(hpo.Price_Element__c)){
                        if(pricingOverrideOutputs.get(hpo.Price_Element__c) != null){
                            holderPriceListToDelete.add(pricingOverrideOutputs.get(hpo.Price_Element__c));
                        }
                    }
                }

                upsert holderPriceElementList;
                if(holderPriceListToDelete.size() > 0){
                    delete holderPriceListToDelete;
                }
            }
        }else{
            if(pricingOverrideOutputs != null && pricingOverrideOutputs.size() > 0){
                delete pricingOverrideOutputs.values();
            }
        }
        list<Holder_Price_Details__c >abc2= getPricinglist();
        TotalListPrice = (conHolder.Discountable_Price__c + (conHolder.Non_Discountable_Price__c / conHolder.Quantity__c)).setScale(2);
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            // quoteLine.Config_Record_Id__c = conHolder.id;
            // quoteLine.SBQQ__Quantity__c=conHolder.Quantity__c;
            //quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
            if(conHolder.Non_Discountable_Price__c!=9999999 && conHolder.Non_Discountable_Price__c!=8888888)
                quoteLine.Non_Discountable_List_Price__c =  conHolder.Non_Discountable_Price__c/ conHolder.Quantity__c;
            else
                quoteLine.Non_Discountable_List_Price__c =  conHolder.Non_Discountable_Price__c ;
            quoteLine.Discountable_List_Price__c = conHolder.Discountable_Price__c;
            // quoteLine.Leadtime_Site_10__c = hldOutput.Lead_Time_Override__c;
            // quoteLine.Leadtime_Site_20__c = 7777;
            // quoteLine.Leadtime_Site_30__c = 7777;
            // quoteLine.Leadtime_Site_40__c = 7777;
            upsert quoteLine;
        }
        update conHolder;
        return null;
    }

    public decimal TotalHolderPrice{set;get;}
    public decimal NonDiscountablePriceEach{set;get;}
    public decimal discountablePrice{set;get;}
    public decimal discountablePriceOverride{set;get;}
    public decimal NonDiscountablePriceEachOverride{set;get;}

    //public decimal TotalHolderPriceOverride{set;get;}
    //public decimal ListPriceEach{set;get;}
    //public decimal NonDiscountableLOTPrice{set;get;}

    public decimal TotalDiscountablePrice{set;get;}
    public decimal TotalNonDiscountablePrice{set;get;}
    public decimal TotalListPrice{set;get;}

    public Map<String, Object> getPricingListCust(String holderId, Boolean returnConHolder){

        Map<String, Object> response = new Map<String, Object>();

        Holders__c holderProduct;
        String fieldsAPIname = FLMutility.getObjectFields('Holders__c');
        String soql = 'SELECT '+fieldsAPIname+' FROM Holders__c WHERE Id =\''+String.escapeSingleQuotes(holderId)+'\' LIMIT 1';
        List<Holders__c> holders  = Database.query(soql);

        if(holders.size() > 0) {

            holderProduct = holders[0];
        }

        map<String,String> holderInputs1 = ConfigHolderUtility.holderInputs(holderProduct);

        pricingOverrideOutputs = new map<String,Holder_Price_Output__c>();

        if(holderProduct.Price_Engineer_Override__c) {

            for(Holder_Price_Output__c hpo: [Select Id, List_Price__c, List_Price_Override__c, Price_Element__c FROM Holder_Price_Output__c where Holders__c = :holderId]){

                pricingOverrideOutputs.put(hpo.Price_Element__c, hpo);
            }
        }

        /* Handling the missing components with default price */
        Map<String, String> fieldsToComponentMapping = new Map<String, String>();
        fieldsToComponentMapping.put('Coating Price - Outlet', 'CoatingOut');
        fieldsToComponentMapping.put('Facing Price - Outlet', 'FACINGOUT_NEW');
        fieldsToComponentMapping.put('Reducer Bushing Price - Outlet', 'ReducingBushingSelectionOut');
        fieldsToComponentMapping.put('Nipple Price - Outlet', 'NippleSelectionOut');
        fieldsToComponentMapping.put('Excess Flow Valve Price - Outlet', 'ExcessFlowValveSelectionOut');
        fieldsToComponentMapping.put('Tee Price - Outlet', 'TeeSelectionOut');
        fieldsToComponentMapping.put('Component-Outlet', 'MCHO');
        fieldsToComponentMapping.put('Gauge Tap Price - Outlet', 'GAUGETAPOUT');
        //fieldsToComponentMapping.put('Component-Outlet Knifeblade', 'MCKBLDOUT');
        fieldsToComponentMapping.put('Eyebolt Price - Outlet', 'EyeboltMatlOut');
        fieldsToComponentMapping.put('Pressure Gauge Price - Outlet', 'GaugeSelectionOut');

        fieldsToComponentMapping.put('Coating Price - Inlet', 'CoatingIn');
        fieldsToComponentMapping.put('Component-Inlet', 'MCHI');
        //fieldsToComponentMapping.put('Component-Inlet Knifeblade', 'MCKBLDIN');
        fieldsToComponentMapping.put('Eyebolt Price - Inlet', 'EyeboltMatlIn');
        fieldsToComponentMapping.put('Facing Price - Inlet', 'FACINGIN');
        fieldsToComponentMapping.put('Gauge Tap Price - Inlet', 'GAUGETAPIN');

        fieldsToComponentMapping.put('Gauge Tap Price - Midflange', 'GAUGETAPMFLG');
        fieldsToComponentMapping.put('Component-Tee Handle', 'TEEHANDLEMATERIAL');
        fieldsToComponentMapping.put('Eyebolt Price - Midflange', 'EyeboltMatlMFLG');
        fieldsToComponentMapping.put('Pressure Gauge Price - Mid Flange', 'GaugeSelectionMFLG');
        fieldsToComponentMapping.put('Jackscrew Pricing', 'MCJackscrews'); //TBD
        fieldsToComponentMapping.put('Excess Flow Valve Price - Mid Flange', 'ExcessFlowValveSelectionMFLG');
        fieldsToComponentMapping.put('China MFG Licence Lot Charge', 'CHINAMFG');
        fieldsToComponentMapping.put('PED Lot Charge', 'PED');
        fieldsToComponentMapping.put('ATEX Lot Charge', 'ATEX');
        fieldsToComponentMapping.put('NACE Lot Charge', 'NACE');
        fieldsToComponentMapping.put('Material Sourcing Lot Charge', 'MATLSOURCE');
        fieldsToComponentMapping.put('Component-Ring', 'MCHRNG'); //MCHRNG - TODO
        fieldsToComponentMapping.put('Component-Midflange', 'MCMFLG');
        fieldsToComponentMapping.put('ASME Lot Charge', 'ASME');
        fieldsToComponentMapping.put('Coating Price - Midflange', 'CoatingMFLG');
        fieldsToComponentMapping.put('Cleaning', 'CLEAN');
        fieldsToComponentMapping.put('Tee Price - Mid Flange', 'TeeMFLG');
        fieldsToComponentMapping.put('Studs and Nuts Pricing', 'MCStudsNuts');
        fieldsToComponentMapping.put('Reducer Bushing Price - Mid Flange', 'ReducingBushingSelectionMFLG');
        fieldsToComponentMapping.put('Nipple Price - Mid Flange', 'NippleMFLG');
        fieldsToComponentMapping.put('KOSHA Price', 'KOSHA');
        fieldsToComponentMapping.put('CUTR Lot Charge', 'CUTR');
        //fieldsToComponentMapping.put('PMI Price', 'PMI');
        fieldsToComponentMapping.put('Testing-3A', 'H3ASRV');
        fieldsToComponentMapping.put('Component-Body', 'MCBODY');
        //fieldsToComponentMapping.put('PMI Lot Charge', ''); //TBD
        fieldsToComponentMapping.put('Component-Gasket', 'MCHG');
        fieldsToComponentMapping.put('Component-Nut', 'MCHN');
        fieldsToComponentMapping.put('Assembly Location Lot Charge', 'ASSYLOCATION');
        fieldsToComponentMapping.put('Shell Test Lot Charge', 'SHELLTEST');
        fieldsToComponentMapping.put('Component-Companion Flange', 'COCF');
        fieldsToComponentMapping.put('Component-Spacer Ring', 'MCSpacerRing');

        String val;
        Holder_Price_Output__c tmpHld;

        TotalHolderPrice = 0.0;
        discountablePriceOverride=0.0;
        NonDiscountablePriceEachOverride=0.0;
        NonDiscountablePriceEach = 0.0;
        discountablePrice = 0.0;

        TotalDiscountablePrice = 0.0;
        TotalNonDiscountablePrice = 0.0;
        TotalListPrice = 0.0;

        holderPricingList = new list<Holder_Price_Details__c >();
        result prncgResult = new result();
        prncgResult = ConfigHolderUtility.getPricing(holderInputs1);
        Holder_Price_Details__c  holderPricingRecord;
        Map<String, Holder_Price_Details__c> hldPriceDetails = new Map<String, Holder_Price_Details__c>();
        for(sObject sobj: prncgResult.objResultList){

            holderPricingRecord = new Holder_Price_Details__c ();
            holderPricingRecord = (Holder_Price_Details__c) sobj;
            hldPriceDetails.put(holderPricingRecord.Pricing_Element__c, holderPricingRecord);
        }

        String fieldKey;

        for(String reqKey: fieldsToComponentMapping.keySet()) {

            reqKey = reqKey.trim();
            fieldKey = fieldsToComponentMapping.get(reqKey);
            fieldKey = fieldKey.trim();

            if(!hldPriceDetails.containsKey(reqKey) && holderInputs1.get(fieldKey) != null
               && holderInputs1.get(fieldKey) != '' && holderInputs1.get(fieldKey) != 'N'
               && holderInputs1.get(fieldKey) != '000') {

                   holderPricingRecord = new Holder_Price_Details__c ();
                   holderPricingRecord.Price__c = 9999999.00;
                   holderPricingRecord.Price_Override__c = 9999999.00;
                   holderPricingRecord.Pricing_Element__c = reqKey;
                   hldPriceDetails.put(reqKey, holderPricingRecord);
               }
        }

        Set<String> sortKeysSet =  hldPriceDetails.keySet();
        List<String> sortKeys = new List<String>();
        sortKeys.addAll(sortKeysSet);
        system.debug('sortKeys:'+sortKeys);
        sortKeys.sort();

        if(prncgResult.bResult){
            boolean has9999999 = false;

            //for(sObject sobj: prncgResult.objResultList){
            for(String key: sortKeys) {

                holderPricingRecord = hldPriceDetails.get(key);
                //holderPricingRecord = new Holder_Price_Details__c ();
                //holderPricingRecord = (Holder_Price_Details__c)sobj;
                system.debug(' holderPricingRecord ##### '+holderPricingRecord);

                if(holderProduct.Price_Engineer_Override__c && pricingOverrideOutputs.containsKey(holderPricingRecord.Pricing_Element__c)){

                    holderPricingRecord.Price_Override__c = pricingOverrideOutputs.get(holderPricingRecord.Pricing_Element__c).List_Price_Override__c;

                } else {

                    if(holderPricingRecord.Price_Override__c == null){
                        holderPricingRecord.Price_Override__c = holderPricingRecord.Price__c;
                        system.debug('@@Override value'+ holderPricingRecord.Price_Override__c);
                    }
                }

                //discountable price element check
                if(((holderPricingRecord.Pricing_Element__c).toLowercase()).contains('lot charge')) {

                    if(holderPricingRecord.Price_Override__c != 9999999 && TotalNonDiscountablePrice != 9999999) {

                        //NonDiscountablePriceEachOverride += holderPricingRecord.Price_Override__c ;
                        TotalNonDiscountablePrice += holderPricingRecord.Price_Override__c;

                    } else {

                        system.debug('MATCHING 9999999 VAL2');
                        TotalNonDiscountablePrice = 9999999;
                    }

                } else {

                    //if(discuontablePriceElements.contains(holderPricingRecord.Pricing_Element__c)) {

                    if(holderPricingRecord.Price_Override__c != 9999999 && TotalDiscountablePrice != 9999999) {

                        discountablePriceOverride += holderPricingRecord.Price_Override__c ;
                        TotalDiscountablePrice += holderPricingRecord.Price_Override__c ;
                    } else {

                        system.debug('MATCHING 9999999 VAL');
                        TotalDiscountablePrice = 9999999;
                    }

                    //}
                }

                if(holderPricingRecord.Price__c != 9999999) {

                    TotalHolderPrice += holderPricingRecord.Price__c;
                }

                if(holderProduct != null && (holderProduct.Quantity__c == null || holderProduct.Quantity__c == 0)){

                    holderProduct.Quantity__c = 1;
                }

                if(conHolder != null && (conHolder.Quantity__c == null || conHolder.Quantity__c == 0)){

                    conHolder.Quantity__c = 1;
                }

                if(holderPricingRecord.Price_Override__c == 9999999){

                    has9999999 = true;
                }
                holderPricingList.add(holderPricingRecord);
            }


            if(holderProduct.Quantity__c != null && holderProduct.Quantity__c != 0){

                if(has9999999) {

                    TotalListPrice = 9999999;
                    //TotalDiscountablePrice = 9999999;
                    //TotalNonDiscountablePrice = 9999999;

                } else {
                    if(conHolder != null){
                        TotalListPrice = (TotalDiscountablePrice + (TotalNonDiscountablePrice / conHolder.Quantity__c)).setScale(2);
                    }

                }

                system.debug('conHolder::'+conHolder);
                if(conHolder != null) {

                    conHolder.List_Price_Each__c 		= TotalListPrice.setScale(2);
                    conHolder.Discountable_Price__c 	= TotalDiscountablePrice;
                    conHolder.Non_Discountable_Price__c = TotalNonDiscountablePrice;
                }

                holderProduct.List_Price_Each__c 		= TotalListPrice.setScale(2);
                holderProduct.Discountable_Price__c 	= TotalDiscountablePrice;
                holderProduct.Non_Discountable_Price__c = TotalNonDiscountablePrice;
            }
        }

        if(returnConHolder) {

            response.put('RES', holderProduct);

        } else {

            response.put('RES', holderPricingList);
        }

        return response;
    }

    public list<Holder_Price_Details__c> getPricinglist(){

        Map<String, Object> res = getPricingListCust(conHolder.Id, false);

        holderPricingList = (List<Holder_Price_Details__c>) res.get('RES');

        return holderPricingList;
    }


    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultPricing(){

        List<Holder_Price_Details__c > priceDetails = getPricinglist();

        if(conHolder.Price_Engineer_Override__c == false && holderPricingList != null && holderPricingList.size() > 0){
            TotalHolderPrice = 0.0;
            TotalDiscountablePrice = 0.0;
            for(Holder_Price_Details__c  bgra : holderPricingList){
                bgra.Price_Override__c = bgra.Price__c;
                if(bgra.Price__c != 9999999){
                    TotalDiscountablePrice += bgra.Price__c;
                }
                if(bgra.Price_Override__c != 9999999){
                    TotalDiscountablePrice += bgra.Price_Override__c;
                }
            }
            //update holderPricingList;
            update conHolder;

            TotalListPrice = conHolder.List_Price_Each__c;
            TotalDiscountablePrice = conHolder.Discountable_Price__c;
            TotalNonDiscountablePrice = conHolder.Non_Discountable_Price__c;

            system.debug('DELETE ::: '+pricingOverrideOutputs.values());

            List<Holder_Price_Output__c> tmpPricingOverrideOutputs = [Select Id, List_Price__c, List_Price_Override__c, Price_Element__c FROM Holder_Price_Output__c where Holders__c =: conHolder.Id];
            if(tmpPricingOverrideOutputs != null && tmpPricingOverrideOutputs.size() > 0){

                //delete pricingOverrideOutputs.values();
                delete tmpPricingOverrideOutputs;
            }

        }
        return null;
    }

    public ConfigHoldersOutputController(){

    }
    public list<HLDRStructureWrapper> getStructuresCust(Map<String,String> holderInputsCust) {

        if(lookupAttributes == null) {

            lookupAttributes = ConfigHolderUtility.lookupAttributes(holderInputsCust);
        }

        if(lookupAttributesAll == null) {

            lookupAttributesAll = ConfigHolderUtility.lookupAttributesAll(holderInputsCust);
        }

        if(testingCodeAttributesMap == null) {

            testingCodeAttributesMap = ConfigHolderUtility.testingCodeAttributesMap(holderInputsCust);
        }

        if(additionalCodeAttributesMap == null) {

            additionalCodeAttributesMap = ConfigHolderUtility.additionalCodeAttributesMap(holderInputsCust);
        }

        List<HLDRStructureWrapper> structureList = new list<HLDRStructureWrapper>();
        String SZCVal = holderInputsCust.get('SZC');
        String HCLASSVal = holderInputsCust.get('HCLASS');
        String COINVal = holderInputsCust.get('COIN');
        String PTCVal = holderInputsCust.get('PTC');

        map<String,String> testingCodeAttributes = ConfigHolderUtility.testingCodeAttributesMap(holderInputsCust);
        map<String,String> additionalCodeAttributes = ConfigHolderUtility.additionalCodeAttributesMap(holderInputsCust);
        map<string,Holder_Additional_Acc_Details__c> additionalAccAttributes =  ConfigHolderUtility.additionalAccAttributes(holderInputsCust);

        map<String,String> initialHolderStructureInputs = new map<String, String>();
        String initialHolderStructureInputsQuery = 'SELECT Id, InletSC__c, OutletSC__c, MidFlangeSC__c, NutSC__c, RingSC__c, BodySC__c, ClampSC__c, CompanionFlangeSC__c, GasketSC__c, EyeboltsSC__c, ';
        initialHolderStructureInputsQuery += ' StudsSC__c, JackscrewSC__c, CapscrewSC__c, Holder_Structure_Type__c from Holder_Structure__c ';
        boolean isWhereClauseAdded = false;
        String MATLSOURCEVal = holderInputsCust.get('MATLSOURCE');
        if(String.isNotBlank(MATLSOURCEVal)){
            isWhereClauseAdded = true;
            initialHolderStructureInputsQuery += ' WHERE Holder_Structure_Type__c = \'SourceCode\' AND Material_Sourcing_Requirements__c =: MATLSOURCEVal ';
        }
        if(isWhereClauseAdded){
            for(Holder_Structure__c hs: Database.query(initialHolderStructureInputsQuery)){

                //InletSC
                if(String.isNotBlank(MATLSOURCEVal) && hs.Holder_Structure_Type__c == 'SourceCode'){
                    initialHolderStructureInputs.put('InletSC', hs.InletSC__c);
                    initialHolderStructureInputs.put('OutletSC', hs.OutletSC__c);
                    initialHolderStructureInputs.put('MidFlangeSC', hs.MidFlangeSC__c);
                    initialHolderStructureInputs.put('NutSC', hs.NutSC__c);
                    initialHolderStructureInputs.put('RingSC', hs.RingSC__c);
                    initialHolderStructureInputs.put('BodySC', hs.BodySC__c);
                    initialHolderStructureInputs.put('ClampSC', hs.ClampSC__c);
                    initialHolderStructureInputs.put('CompanionFlangeSC', hs.CompanionFlangeSC__c);
                    initialHolderStructureInputs.put('GasketSC', hs.GasketSC__c);
                    initialHolderStructureInputs.put('EyeboltsSC', hs.EyeboltsSC__c);
                    initialHolderStructureInputs.put('StudsSC', hs.StudsSC__c);
                    initialHolderStructureInputs.put('JackscrewSC', hs.JackscrewSC__c);
                    initialHolderStructureInputs.put('CapscrewSC', hs.CapscrewSC__c);
                }

            }
        }

        String holderStructureQuery = 'SELECT Holder_Structure_Type__c,Id, Component_Part_Number__c, MCKBLD__c, ROP__c, Qty_Per_Assembly__c, Scrap_Factor__c, Component_Scrap__c,LeadtimeSchedule__c from Holder_Structure__c ';
        String PartNoInletWhereClause;
        String MCHIVal = holderInputsCust.get('MCHI');
        String InletTestVal = testingCodeAttributes.get('InletTest');
        String InletACVal = additionalCodeAttributes.get('InletAC');
        String InletSCVal = initialHolderStructureInputs.get('InletSC');
        String INLETCOMPPTCVal = lookupAttributes.get('INLETCOMPPTC');
        System.debug(' MCHIVal :'+MCHIVal+' InletTestVal :'+InletTestVal+' InletACVal :'+InletACVal+' InletSCVal :'+InletSCVal+' INLETCOMPPTCVal :'+INLETCOMPPTCVal+' SZC__c :'+SZCVal+' HCLASSVal :'+HCLASSVal+' COINVal :'+COINVal);
        if(String.isNotBlank(MCHIVal)){
            holderStructureQuery += ' WHERE (Holder_Structure_Type__c = \'Inlet\' AND INLETCOMPPTC__c =: INLETCOMPPTCVal AND SZC__c =: SZCVal AND MCHI__c =: MCHIVal ';
            holderStructureQuery += ' AND Source_Code__c =: InletSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COINVal AND Testing_Code__c =: InletTestVal AND Additional_Code__c =: InletACVal) ';
        }

        String MCHOVal = holderInputsCust.get('MCHO');
        String OutletSCVal = initialHolderStructureInputs.get('OutletSC');
        String COOUTVal = holderInputsCust.get('COOUT');
        String OutletTestVal = testingCodeAttributes.get('OutletTest');
        String OutletACVal = additionalCodeAttributes.get('OutletAC');
        String OUTLETCOMPPTCVal = lookupAttributes.get('OUTLETCOMPPTC');

        if(String.isNotBlank(MCHOVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Outlet\' AND OUTLETCOMPPTC__c =: OUTLETCOMPPTCVal AND SZC__c =: SZCVal AND MCHO__c =: MCHOVal ';
            holderStructureQuery += ' AND Source_Code__c =: OutletSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COOUTVal AND Testing_Code__c =: OutletTestVal AND Additional_Code__c =: OutletACVal) ';
        }

        String MCMFLGVal = holderInputsCust.get('MCMFLG');
        String MidFlangeSCVal = initialHolderStructureInputs.get('MidFlangeSC');
        String COMFLGVal = holderInputsCust.get('COMFLG');
        String MidFlangeTestVal = testingCodeAttributes.get('MidFlangeTest');
        String MidFlangACVal = additionalCodeAttributes.get('MidFlangAC');

        if(String.isNotBlank(MCMFLGVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Mid Flange\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCMFLG__c =: MCMFLGVal ';
            holderStructureQuery += ' AND Source_Code__c =: MidFlangeSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COMFLGVal AND Testing_Code__c =: MidFlangeTestVal AND Additional_Code__c =: MidFlangACVal) ';
        }

        String MCHNVal = holderInputsCust.get('MCHN');
        String NutSCVal = initialHolderStructureInputs.get('NutSC');
        String NutTestVal = testingCodeAttributes.get('NutTest');
        String NutACVal = additionalCodeAttributes.get('NutAC');

        if(String.isNotBlank(MCHNVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Nut2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHN__c =: MCHNVal ';
            holderStructureQuery += ' AND Source_Code__c =: NutSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: NutTestVal AND Additional_Code__c =: NutACVal) ';
        }

        String MCSpacerRingVal = holderInputsCust.get('MCSpacerRing');
        String RingSCVal = initialHolderStructureInputs.get('RingSC');
        String RingTestVal = testingCodeAttributes.get('RingTest');
        String RingACVal = additionalCodeAttributes.get('RingAC');

        if(String.isNotBlank(MCSpacerRingVal) && (PTCVal == 'CR8' || PTCVal == 'CR9')){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHRNG__c =: MCSpacerRingVal ';//AND MCSpacerRing__c =: MCSpacerRingVal
            holderStructureQuery += ' AND Source_Code__c =: RingSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: RingTestVal AND Additional_Code__c =: RingACVal) ';
        }

        String MCHRNGVal = holderInputsCust.get('MCHRNG');

        if(String.isNotBlank(MCHRNGVal) ){ //RHATHI, Service Ticket #202464 && (PTCVal != 'CR8' || PTCVal != 'CR9')){ , does not filter anything, so commented
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHRNG__c =: MCHRNGVal ';
            holderStructureQuery += ' AND Source_Code__c =: RingSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: RingTestVal AND Additional_Code__c =: RingACVal) ';
        }

        String MCBODYVal = holderInputsCust.get('MCBODY');
        String COBODYVal = holderInputsCust.get('COBODY');
        String BodySCVal = initialHolderStructureInputs.get('BodySC');
        String BodyTestVal = testingCodeAttributes.get('BodyTest');
        String BodyACVal = additionalCodeAttributes.get('BodyAC');

        if(String.isNotBlank(MCBODYVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Body2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCBODY__c =: MCBODYVal AND OptionCode__c =: COBODYVal ';
            holderStructureQuery += ' AND Source_Code__c =: BodySCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: BodyTestVal AND Additional_Code__c =: BodyACVal) ';
        }

        String MCCLMPVal = holderInputsCust.get('MCCLMP');
        String ClampSCVal = initialHolderStructureInputs.get('ClampSC');
        String ClampTestVal = testingCodeAttributes.get('ClampTest');
        String ClampACVal = additionalCodeAttributes.get('ClampAC');

        if(String.isNotBlank(MCCLMPVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Clamp2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCCLMP__c =: MCCLMPVal ';
            holderStructureQuery += ' AND Source_Code__c =: ClampSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: ClampTestVal AND Additional_Code__c =: ClampACVal) ';
        }

        String MCCFVal = holderInputsCust.get('MCCF');
        String COCFVal = holderInputsCust.get('COCF');
        String CompanionFlangeSCVal = initialHolderStructureInputs.get('CompanionFlangeSC');
        String CompanionFlangeTestVal = testingCodeAttributes.get('CompanionFlangeTest')==null?'000':testingCodeAttributes.get('CompanionFlangeTest');
        String CompanionFlangeACVal = additionalCodeAttributes.get('CompanionFlangeAC');
        system.debug('CompanionFlangeSCVal'+CompanionFlangeSCVal);
        system.debug('CompanionFlangeTestVal'+CompanionFlangeTestVal);
        system.debug('CompanionFlangeACVal'+CompanionFlangeACVal);
        system.debug('MCCFVal'+MCCFVal);
        system.debug('COCFVal'+COCFVal);
        if(String.isNotBlank(MCCFVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Companion Flange2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCCF__c =: MCCFVal AND OptionCode__c =: COCFVal';
            holderStructureQuery += ' AND Source_Code__c =: CompanionFlangeSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: CompanionFlangeTestVal AND Additional_Code__c =: CompanionFlangeACVal) ';
        }

        String MCHGVal = holderInputsCust.get('MCHG');
        String GasketSCVal = initialHolderStructureInputs.get('GasketSC');
        String GasketTestVal = testingCodeAttributes.get('GasketTest');
        String GasketACVal = additionalCodeAttributes.get('GasketAC');

        if(String.isNotBlank(MCHGVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Gasket2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHG__c =: MCHGVal ';
            holderStructureQuery += ' AND Source_Code__c =: GasketSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: GasketTestVal AND Additional_Code__c =: GasketACVal) ';
        }

        String MCTHDLVal = lookupAttributes.get('MCTHDL');
        if(String.isNotBlank(MCTHDLVal)){
            String WhereORAnd;
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Tee Handle\' AND PTC__c =: PTCVal) ';
        }

        String EyeboltMatlInVal = holderInputsCust.get('EyeboltMatlIn');
        String EyeboltsSCVal = initialHolderStructureInputs.get('EyeboltsSC');
        String EyeboltsTestVal = testingCodeAttributes.get('EyeboltsTest');
        String EyeboltsACVal = additionalCodeAttributes.get('EyeboltsAC');
        String partCodeVal = '01';

        if(holderStructureQuery.contains('WHERE')){
            holderStructureQuery += ' OR';
        }else{
            holderStructureQuery += ' WHERE';
        }
        holderStructureQuery += ' (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlInVal AND PartCode__c =: partCodeVal';
        holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

        if(String.isNotBlank(EyeboltMatlInVal)){
            holderStructureQuery += ' )';
        }else{
            holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
        }

        String EyeboltMatlOutVal = holderInputsCust.get('EyeboltMatlOut');
        String eboPartCodeVal = '02';

        holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlOutVal AND PartCode__c =: eboPartCodeVal';
        holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

        if(String.isNotBlank(EyeboltMatlOutVal)){
            holderStructureQuery += ' )';
        }else{
            holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
        }

        String EyeboltMatlMFLGVal = holderInputsCust.get('EyeboltMatlMFLG');
        String ebMFLGPartCodeVal = '03';

        holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlMFLGVal AND PartCode__c =: ebMFLGPartCodeVal';
        holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

        if(String.isNotBlank(EyeboltMatlMFLGVal)){
            holderStructureQuery += ' )';
        }else{
            holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
        }

        String MCStudsNutsVal = holderInputsCust.get('MCStudsNuts');
        String StudsSCVal = initialHolderStructureInputs.get('StudsSC');
        String StudsTestVal = testingCodeAttributes.get('StudsTest');
        String StudsACVal = additionalCodeAttributes.get('StudsAC');

        if(String.isNotBlank(MCStudsNutsVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'StudsandNuts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCSTUD__c =: MCStudsNutsVal ';
            holderStructureQuery += ' AND Source_Code__c =: StudsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: StudsTestVal AND Additional_Code__c =: StudsACVal) ';
        }

        String ReducingBushingSelectionOutVal = holderInputsCust.get('ReducingBushingSelectionOut');
        if(String.isNotBlank(ReducingBushingSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Reducer Bushing\' AND ReducerBushingSelection__c =: ReducingBushingSelectionOutVal )';
        }

        String ReducingBushingSelectionMFLGVal = holderInputsCust.get('ReducingBushingSelectionMFLG');
        if(String.isNotBlank(ReducingBushingSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Reducer Bushing\' AND ReducerBushingSelection__c =: ReducingBushingSelectionMFLGVal )';
        }

        String MCJackscrewsVal = holderInputsCust.get('MCJackscrews');
        String JackscrewSCVal = initialHolderStructureInputs.get('JackscrewSC');
        String JackTestrewTestVal = testingCodeAttributes.get('JackTestrewTest');
        String JackscrewACVal = additionalCodeAttributes.get('JackscrewAC');
        if(String.isNotBlank(MCJackscrewsVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Jackscrews\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MatlCode__c =: MCStudsNutsVal ';
            holderStructureQuery += ' AND Source_Code__c =: JackscrewSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: JackTestrewTestVal AND Additional_Code__c =: JackscrewACVal) ';
        }

        String CapscrewSCVal = initialHolderStructureInputs.get('CapscrewSC');
        String CapTestrewTestVal = testingCodeAttributes.get('CapTestrewTest');
        String CapscrewACVal = additionalCodeAttributes.get('CapscrewAC');
        holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Capscrews\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal ';
        holderStructureQuery += ' AND Source_Code__c =: CapscrewSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: CapTestrewTestVal AND Additional_Code__c =: CapscrewACVal AND Required__c = true) ';

        String GaugeSelectionOutVal = holderInputsCust.get('GaugeSelectionOut');
        System.debug('************GaugeSelectionOutVal***'+GaugeSelectionOutVal);
        String PressUnitsOutVal = holderInputsCust.get('PressUnitsOut');
        String PhysicalPropsOutVal = holderInputsCust.get('PhysicalPropsOut');
        String TubeCaseMatlOutVal = holderInputsCust.get('TubeCaseMatlOut');
        if(String.isNotBlank(GaugeSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Gauge\' AND PressUnits__c =: PressUnitsOutVal AND PhysicalProps__c =: PhysicalPropsOutVal AND TubeCaseMatl__c =: TubeCaseMatlOutVal)';
        }

        String GaugeSelectionMFLGVal = holderInputsCust.get('GaugeSelectionMFLG');
        String PressUnitsMFLGVal = holderInputsCust.get('PressUnitsMFLG');
        String PhysicalPropsMFLGVal = holderInputsCust.get('PhysicalPropsMFLG');
        String TubeCaseMatlMFLGVal = holderInputsCust.get('TubeCaseMatlMFLG');
        if(String.isNotBlank(GaugeSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Gauge\' AND PressUnits__c =: PressUnitsMFLGVal AND PhysicalProps__c =: PhysicalPropsMFLGVal AND TubeCaseMatl__c =: TubeCaseMatlMFLGVal)';
        }

        String NippleSelectionOutVal = holderInputsCust.get('NippleSelectionOut');
        if(String.isNotBlank(NippleSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Nipple\' AND Desc__c =: NippleSelectionOutVal)';
        }

        String NippleSelectionMFLGVal = holderInputsCust.get('NippleSelectionMFLG');
        if(String.isNotBlank(NippleSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Nipple\' AND Desc__c =: NippleSelectionMFLGVal)';
        }

        String TeeSelectionOutVal = holderInputsCust.get('TeeSelectionOut');
        if(String.isNotBlank(TeeSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Tee\' AND Desc__c =: TeeSelectionOutVal)';
        }

        String TeeSelectionMFLGVal = holderInputsCust.get('TeeSelectionMFLG');
        if(String.isNotBlank(TeeSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Tee\' AND Desc__c =: TeeSelectionMFLGVal)';
        }

        String ExcessFlowValveSelectionOutVal = holderInputsCust.get('ExcessFlowValveSelectionOut');
        if(String.isNotBlank(ExcessFlowValveSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Excess Flow Valve\' AND Desc__c =: ExcessFlowValveSelectionOutVal)';
        }

        String ExcessFlowValveSelectionMFLGVal = holderInputsCust.get('ExcessFlowValveSelectionMFLG');
        if(String.isNotBlank(ExcessFlowValveSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Excess Flow Valve\' AND Desc__c =: ExcessFlowValveSelectionMFLGVal)';
        }

        String tmpVal;
        System.debug('STRUCT holderStructureQuery '+holderStructureQuery);
        for(Holder_Structure__c hs: Database.query(holderStructureQuery)){
            system.debug('STRUCT HS Record '+hs);
            //System.debug('STRUCT HS Record InletSc..'+hs.InletSC__c+' Holder struct type..'+hs.Holder_Structure_Type__c);
            if(String.isNotBlank(hs.Component_Part_Number__c)){
                HLDRStructureWrapper hsw = new HLDRStructureWrapper();
                hsw.ComponentPart = hs.Component_Part_Number__c;
                hsw.MCKBLD = hs.MCKBLD__c;
                if(hs.ROP__c != null)
                    hsw.ROP = String.valueOf(hs.ROP__c);
                if(hs.Qty_Per_Assembly__c != null)
                    hsw.Qty = String.valueOf(hs.Qty_Per_Assembly__c);
                if(hs.Scrap_Factor__c != null)
                    hsw.ScrapFactor = String.valueOf(hs.Scrap_Factor__c);
                if(hs.Holder_Structure_Type__c != null) {

                    tmpVal = String.valueOf(hs.Holder_Structure_Type__c);
                    tmpVal = tmpVal.replace('2', '');
                    if(tmpVal.contains('StudsandNuts')){
                        tmpVal = tmpVal.replace('StudsandNuts', 'Studs and Nuts');
                    }
                    hsw.structureType = tmpVal;

                }
                if(hs.LeadtimeSchedule__c != null)
                    hsw.leadTime = String.valueOf(hs.LeadtimeSchedule__c);
                hsw.ComponentScrap = hs.Component_Scrap__c;
                //hsw.HolderStructureType = hs.Holder_Structure_Type__c;

                system.debug('hsw.leadTime:::'+hsw.leadTime);
                structureList.add(hsw);
                // if(hs.Holder_Structure_Type__c == 'Inlet'){
                // }else if(hs.Holder_Structure_Type__c == 'Outlet'){
                // }
            }

        }

        //where is the Acc1 attribute ?
        System.debug(' haccd Vals === '+additionalAccAttributes.values());
        for(Holder_Additional_Acc_Details__c haccd : additionalAccAttributes.values()){
            System.debug(' haccd === '+haccd);
            if(String.isNotBlank(haccd.Accessory_Part_Number__c)){
                HLDRStructureWrapper hsw = new HLDRStructureWrapper();
                hsw.Qty = haccd.Qty_Per_Assembly__c;
                hsw.ScrapFactor = haccd.Scrap_Factor__c;
                hsw.ComponentScrap = haccd.Component_Scrap__c;
                hsw.ComponentPart = haccd.Accessory_Part_Number__c;
                structureList.add(hsw);
                System.debug('haccd.ScrapFactor...'+haccd.Scrap_Factor__c);
                System.debug('haccd.Accessory_Part_Number__c...'+haccd.Accessory_Part_Number__c);
            }
        }

        //strucData.addAll(structureList);
        return structureList;
    }

    public list<HLDRStructureWrapper> getStructures(){

        list<HLDRStructureWrapper> structureList = getStructuresCust(holderInputs);

        /*
String SZCVal = holderInputs.get('SZC');
String HCLASSVal = holderInputs.get('HCLASS');
String COINVal = holderInputs.get('COIN');
String PTCVal = holderInputs.get('PTC');

map<String,String> testingCodeAttributes = ConfigHolderUtility.testingCodeAttributesMap(holderInputs);
map<String,String> additionalCodeAttributes = ConfigHolderUtility.additionalCodeAttributesMap(holderInputs);
map<string,Holder_Additional_Acc_Details__c> additionalAccAttributes =  ConfigHolderUtility.additionalAccAttributes(holderInputs);

map<String,String> initialHolderStructureInputs = new map<String, String>();
String initialHolderStructureInputsQuery = 'SELECT Id, InletSC__c, OutletSC__c, MidFlangeSC__c, NutSC__c, RingSC__c, BodySC__c, ClampSC__c, CompanionFlangeSC__c, GasketSC__c, EyeboltsSC__c, ';
initialHolderStructureInputsQuery += ' StudsSC__c, JackscrewSC__c, CapscrewSC__c, Holder_Structure_Type__c from Holder_Structure__c ';
boolean isWhereClauseAdded = false;
String MATLSOURCEVal = holderInputs.get('MATLSOURCE');
if(String.isNotBlank(MATLSOURCEVal)){
isWhereClauseAdded = true;
initialHolderStructureInputsQuery += ' WHERE Holder_Structure_Type__c = \'SourceCode\' AND Material_Sourcing_Requirements__c =: MATLSOURCEVal ';
}
if(isWhereClauseAdded){
for(Holder_Structure__c hs: Database.query(initialHolderStructureInputsQuery)){

//InletSC
if(String.isNotBlank(MATLSOURCEVal) && hs.Holder_Structure_Type__c == 'SourceCode'){
initialHolderStructureInputs.put('InletSC', hs.InletSC__c);
initialHolderStructureInputs.put('OutletSC', hs.OutletSC__c);
initialHolderStructureInputs.put('MidFlangeSC', hs.MidFlangeSC__c);
initialHolderStructureInputs.put('NutSC', hs.NutSC__c);
initialHolderStructureInputs.put('RingSC', hs.RingSC__c);
initialHolderStructureInputs.put('BodySC', hs.BodySC__c);
initialHolderStructureInputs.put('ClampSC', hs.ClampSC__c);
initialHolderStructureInputs.put('CompanionFlangeSC', hs.CompanionFlangeSC__c);
initialHolderStructureInputs.put('GasketSC', hs.GasketSC__c);
initialHolderStructureInputs.put('EyeboltsSC', hs.EyeboltsSC__c);
initialHolderStructureInputs.put('StudsSC', hs.StudsSC__c);
initialHolderStructureInputs.put('JackscrewSC', hs.JackscrewSC__c);
initialHolderStructureInputs.put('CapscrewSC', hs.CapscrewSC__c);
}

}
}

String holderStructureQuery = 'SELECT Holder_Structure_Type__c,Id, Component_Part_Number__c, MCKBLD__c, ROP__c, Qty_Per_Assembly__c, Scrap_Factor__c, Component_Scrap__c,LeadtimeSchedule__c from Holder_Structure__c ';
String PartNoInletWhereClause;
String MCHIVal = holderInputs.get('MCHI');
String InletTestVal = testingCodeAttributes.get('InletTest');
String InletACVal = additionalCodeAttributes.get('InletAC');
String InletSCVal = initialHolderStructureInputs.get('InletSC');
String INLETCOMPPTCVal = lookupAttributes.get('INLETCOMPPTC');
System.debug(' MCHIVal :'+MCHIVal+' InletTestVal :'+InletTestVal+' InletACVal :'+InletACVal+' InletSCVal :'+InletSCVal+' INLETCOMPPTCVal :'+INLETCOMPPTCVal+' SZC__c :'+SZCVal+' HCLASSVal :'+HCLASSVal+' COINVal :'+COINVal);
if(String.isNotBlank(MCHIVal)){
holderStructureQuery += ' WHERE (Holder_Structure_Type__c = \'Inlet\' AND INLETCOMPPTC__c =: INLETCOMPPTCVal AND SZC__c =: SZCVal AND MCHI__c =: MCHIVal ';
holderStructureQuery += ' AND Source_Code__c =: InletSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COINVal AND Testing_Code__c =: InletTestVal AND Additional_Code__c =: InletACVal) ';
}

String MCHOVal = holderInputs.get('MCHO');
String OutletSCVal = initialHolderStructureInputs.get('OutletSC');
String COOUTVal = holderInputs.get('COOUT');
String OutletTestVal = testingCodeAttributes.get('OutletTest');
String OutletACVal = additionalCodeAttributes.get('OutletAC');
String OUTLETCOMPPTCVal = lookupAttributes.get('OUTLETCOMPPTC');

if(String.isNotBlank(MCHOVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Outlet\' AND OUTLETCOMPPTC__c =: OUTLETCOMPPTCVal AND SZC__c =: SZCVal AND MCHO__c =: MCHOVal ';
holderStructureQuery += ' AND Source_Code__c =: OutletSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COOUTVal AND Testing_Code__c =: OutletTestVal AND Additional_Code__c =: OutletACVal) ';
}

String MCMFLGVal = holderInputs.get('MCMFLG');
String MidFlangeSCVal = initialHolderStructureInputs.get('MidFlangeSC');
String COMFLGVal = holderInputs.get('COMFLG');
String MidFlangeTestVal = testingCodeAttributes.get('MidFlangeTest');
String MidFlangACVal = additionalCodeAttributes.get('MidFlangAC');

if(String.isNotBlank(MCMFLGVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Mid Flange\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCMFLG__c =: MCMFLGVal ';
holderStructureQuery += ' AND Source_Code__c =: MidFlangeSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COMFLGVal AND Testing_Code__c =: MidFlangeTestVal AND Additional_Code__c =: MidFlangACVal) ';
}

String MCHNVal = holderInputs.get('MCHN');
String NutSCVal = initialHolderStructureInputs.get('NutSC');
String NutTestVal = testingCodeAttributes.get('NutTest');
String NutACVal = additionalCodeAttributes.get('NutAC');

if(String.isNotBlank(MCHNVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Nut2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHN__c =: MCHNVal ';
holderStructureQuery += ' AND Source_Code__c =: NutSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: NutTestVal AND Additional_Code__c =: NutACVal) ';
}

String MCSpacerRingVal = holderInputs.get('MCSpacerRing');
String RingSCVal = initialHolderStructureInputs.get('RingSC');
String RingTestVal = testingCodeAttributes.get('RingTest');
String RingACVal = additionalCodeAttributes.get('RingAC');

if(String.isNotBlank(MCSpacerRingVal) && (PTCVal == 'CR8' || PTCVal == 'CR9')){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHRNG__c =: MCSpacerRingVal ';//AND MCSpacerRing__c =: MCSpacerRingVal
holderStructureQuery += ' AND Source_Code__c =: RingSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: RingTestVal AND Additional_Code__c =: RingACVal) ';
}

String MCHRNGVal = holderInputs.get('MCHRNG');

if(String.isNotBlank(MCHRNGVal) && (PTCVal != 'CR8' || PTCVal != 'CR9')){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHRNG__c =: MCHRNGVal ';
holderStructureQuery += ' AND Source_Code__c =: RingSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: RingTestVal AND Additional_Code__c =: RingACVal) ';
}

String MCBODYVal = holderInputs.get('MCBODY');
String COBODYVal = holderInputs.get('COBODY');
String BodySCVal = initialHolderStructureInputs.get('BodySC');
String BodyTestVal = testingCodeAttributes.get('BodyTest');
String BodyACVal = additionalCodeAttributes.get('BodyAC');

if(String.isNotBlank(MCBODYVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Body2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCBODY__c =: MCBODYVal AND OptionCode__c =: COBODYVal ';
holderStructureQuery += ' AND Source_Code__c =: BodySCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: BodyTestVal AND Additional_Code__c =: BodyACVal) ';
}

String MCCLMPVal = holderInputs.get('MCCLMP');
String ClampSCVal = initialHolderStructureInputs.get('ClampSC');
String ClampTestVal = testingCodeAttributes.get('ClampTest');
String ClampACVal = additionalCodeAttributes.get('ClampAC');

if(String.isNotBlank(MCCLMPVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Clamp2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCCLMP__c =: MCCLMPVal ';
holderStructureQuery += ' AND Source_Code__c =: ClampSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: ClampTestVal AND Additional_Code__c =: ClampACVal) ';
}

String MCCFVal = holderInputs.get('MCCF');
String COCFVal = holderInputs.get('COCF');
String CompanionFlangeSCVal = initialHolderStructureInputs.get('CompanionFlangeSC');
String CompanionFlangeTestVal = testingCodeAttributes.get('CompanionFlangeTest')==null?'000':testingCodeAttributes.get('CompanionFlangeTest');
String CompanionFlangeACVal = additionalCodeAttributes.get('CompanionFlangeAC');
system.debug('CompanionFlangeSCVal'+CompanionFlangeSCVal);
system.debug('CompanionFlangeTestVal'+CompanionFlangeTestVal);
system.debug('CompanionFlangeACVal'+CompanionFlangeACVal);
system.debug('MCCFVal'+MCCFVal);
system.debug('COCFVal'+COCFVal);
if(String.isNotBlank(MCCFVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Companion Flange2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCCF__c =: MCCFVal AND OptionCode__c =: COCFVal';
holderStructureQuery += ' AND Source_Code__c =: CompanionFlangeSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: CompanionFlangeTestVal AND Additional_Code__c =: CompanionFlangeACVal) ';
}

String MCHGVal = holderInputs.get('MCHG');
String GasketSCVal = initialHolderStructureInputs.get('GasketSC');
String GasketTestVal = testingCodeAttributes.get('GasketTest');
String GasketACVal = additionalCodeAttributes.get('GasketAC');

if(String.isNotBlank(MCHGVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Gasket2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHG__c =: MCHGVal ';
holderStructureQuery += ' AND Source_Code__c =: GasketSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: GasketTestVal AND Additional_Code__c =: GasketACVal) ';
}

String MCTHDLVal = lookupAttributes.get('MCTHDL');
if(String.isNotBlank(MCTHDLVal)){
String WhereORAnd;
if(holderStructureQuery.contains('WHERE')){
WhereORAnd = ' OR';
}else{
WhereORAnd = ' WHERE';
}
holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Tee Handle\' AND PTC__c =: PTCVal) ';
}

String EyeboltMatlInVal = holderInputs.get('EyeboltMatlIn');
String EyeboltsSCVal = initialHolderStructureInputs.get('EyeboltsSC');
String EyeboltsTestVal = testingCodeAttributes.get('EyeboltsTest');
String EyeboltsACVal = additionalCodeAttributes.get('EyeboltsAC');
String partCodeVal = '01';

if(holderStructureQuery.contains('WHERE')){
holderStructureQuery += ' OR';
}else{
holderStructureQuery += ' WHERE';
}
holderStructureQuery += ' (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlInVal AND PartCode__c =: partCodeVal';
holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

if(String.isNotBlank(EyeboltMatlInVal)){
holderStructureQuery += ' )';
}else{
holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
}

String EyeboltMatlOutVal = holderInputs.get('EyeboltMatlOut');
String eboPartCodeVal = '02';

holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlOutVal AND PartCode__c =: eboPartCodeVal';
holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

if(String.isNotBlank(EyeboltMatlOutVal)){
holderStructureQuery += ' )';
}else{
holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
}

String EyeboltMatlMFLGVal = holderInputs.get('EyeboltMatlMFLG');
String ebMFLGPartCodeVal = '03';

holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlMFLGVal AND PartCode__c =: ebMFLGPartCodeVal';
holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

if(String.isNotBlank(EyeboltMatlMFLGVal)){
holderStructureQuery += ' )';
}else{
holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
}

String MCStudsNutsVal = holderInputs.get('MCStudsNuts');
String StudsSCVal = initialHolderStructureInputs.get('StudsSC');
String StudsTestVal = testingCodeAttributes.get('StudsTest');
String StudsACVal = additionalCodeAttributes.get('StudsAC');

if(String.isNotBlank(MCStudsNutsVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'StudsandNuts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCSTUD__c =: MCStudsNutsVal ';
holderStructureQuery += ' AND Source_Code__c =: StudsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: StudsTestVal AND Additional_Code__c =: StudsACVal) ';
}

String ReducingBushingSelectionOutVal = holderInputs.get('ReducingBushingSelectionOut');
if(String.isNotBlank(ReducingBushingSelectionOutVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Reducer Bushing\' AND ReducerBushingSelection__c =: ReducingBushingSelectionOutVal )';
}

String ReducingBushingSelectionMFLGVal = holderInputs.get('ReducingBushingSelectionMFLG');
if(String.isNotBlank(ReducingBushingSelectionMFLGVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Reducer Bushing\' AND ReducerBushingSelection__c =: ReducingBushingSelectionMFLGVal )';
}

String MCJackscrewsVal = holderInputs.get('MCJackscrews');
String JackscrewSCVal = initialHolderStructureInputs.get('JackscrewSC');
String JackTestrewTestVal = testingCodeAttributes.get('JackTestrewTest');
String JackscrewACVal = additionalCodeAttributes.get('JackscrewAC');
if(String.isNotBlank(MCJackscrewsVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Jackscrews\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MatlCode__c =: MCStudsNutsVal ';
holderStructureQuery += ' AND Source_Code__c =: JackscrewSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: JackTestrewTestVal AND Additional_Code__c =: JackscrewACVal) ';
}

String CapscrewSCVal = initialHolderStructureInputs.get('CapscrewSC');
String CapTestrewTestVal = testingCodeAttributes.get('CapTestrewTest');
String CapscrewACVal = additionalCodeAttributes.get('CapscrewAC');
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Capscrews\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal ';
holderStructureQuery += ' AND Source_Code__c =: CapscrewSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: CapTestrewTestVal AND Additional_Code__c =: CapscrewACVal AND Required__c = true) ';

String GaugeSelectionOutVal = holderInputs.get('GaugeSelectionOut');
String PressUnitsOutVal = holderInputs.get('PressUnitsOut');
String PhysicalPropsOutVal = holderInputs.get('PhysicalPropsOut');
String TubeCaseMatlOutVal = holderInputs.get('TubeCaseMatlOut');
if(String.isNotBlank(GaugeSelectionOutVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Gauge\' AND PressUnits__c =: PressUnitsOutVal AND PhysicalProps__c =: PhysicalPropsOutVal AND TubeCaseMatl__c =: TubeCaseMatlOutVal)';
}

String GaugeSelectionMFLGVal = holderInputs.get('GaugeSelectionMFLG');
String PressUnitsMFLGVal = holderInputs.get('PressUnitsMFLG');
String PhysicalPropsMFLGVal = holderInputs.get('PhysicalPropsMFLG');
String TubeCaseMatlMFLGVal = holderInputs.get('TubeCaseMatlMFLG');
if(String.isNotBlank(GaugeSelectionMFLGVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Gauge\' AND PressUnits__c =: PressUnitsMFLGVal AND PhysicalProps__c =: PhysicalPropsMFLGVal AND TubeCaseMatl__c =: TubeCaseMatlMFLGVal)';
}

String NippleSelectionOutVal = holderInputs.get('NippleSelectionOut');
if(String.isNotBlank(NippleSelectionOutVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Nipple\' AND Desc__c =: NippleSelectionOutVal)';
}

String NippleSelectionMFLGVal = holderInputs.get('NippleSelectionMFLG');
if(String.isNotBlank(NippleSelectionMFLGVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Nipple\' AND Desc__c =: NippleSelectionMFLGVal)';
}

String TeeSelectionOutVal = holderInputs.get('TeeSelectionOut');
if(String.isNotBlank(TeeSelectionOutVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Tee\' AND Desc__c =: TeeSelectionOutVal)';
}

String TeeSelectionMFLGVal = holderInputs.get('TeeSelectionMFLG');
if(String.isNotBlank(TeeSelectionMFLGVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Tee\' AND Desc__c =: TeeSelectionMFLGVal)';
}

String ExcessFlowValveSelectionOutVal = holderInputs.get('ExcessFlowValveSelectionOut');
if(String.isNotBlank(ExcessFlowValveSelectionOutVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Excess Flow Valve\' AND Desc__c =: ExcessFlowValveSelectionOutVal)';
}

String ExcessFlowValveSelectionMFLGVal = holderInputs.get('ExcessFlowValveSelectionMFLG');
if(String.isNotBlank(ExcessFlowValveSelectionMFLGVal)){
holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Excess Flow Valve\' AND Desc__c =: ExcessFlowValveSelectionMFLGVal)';
}

String tmpVal;
System.debug('STRUCT holderStructureQuery '+holderStructureQuery);
for(Holder_Structure__c hs: Database.query(holderStructureQuery)){
system.debug('STRUCT HS Record '+hs);
if(String.isNotBlank(hs.Component_Part_Number__c)){
HLDRStructureWrapper hsw = new HLDRStructureWrapper();
hsw.ComponentPart = hs.Component_Part_Number__c;
hsw.MCKBLD = hs.MCKBLD__c;
if(hs.ROP__c != null)
hsw.ROP = String.valueOf(hs.ROP__c);
if(hs.Qty_Per_Assembly__c != null)
hsw.Qty = String.valueOf(hs.Qty_Per_Assembly__c);
if(hs.Scrap_Factor__c != null)
hsw.ScrapFactor = String.valueOf(hs.Scrap_Factor__c);
if(hs.Holder_Structure_Type__c != null) {

tmpVal = String.valueOf(hs.Holder_Structure_Type__c);
tmpVal = tmpVal.replace('2', '');
if(tmpVal.contains('StudsandNuts')){
tmpVal = tmpVal.replace('StudsandNuts', 'Studs and Nuts');
}
hsw.structureType = tmpVal;

}
if(hs.LeadtimeSchedule__c != null)
hsw.leadTime = String.valueOf(hs.LeadtimeSchedule__c);
hsw.ComponentScrap = hs.Component_Scrap__c;
//hsw.HolderStructureType = hs.Holder_Structure_Type__c;


structureList.add(hsw);
// if(hs.Holder_Structure_Type__c == 'Inlet'){
// }else if(hs.Holder_Structure_Type__c == 'Outlet'){
// }
}

}

//where is the Acc1 attribute ?
System.debug(' haccd Vals === '+additionalAccAttributes.values());
for(Holder_Additional_Acc_Details__c haccd : additionalAccAttributes.values()){
System.debug(' haccd === '+haccd);
if(String.isNotBlank(haccd.Accessory_Part_Number__c)){
HLDRStructureWrapper hsw = new HLDRStructureWrapper();
hsw.Qty = haccd.Qty_Per_Assembly__c;
hsw.ScrapFactor = haccd.Scrap_Factor__c;
hsw.ComponentScrap = haccd.Component_Scrap__c;
hsw.ComponentPart = haccd.Accessory_Part_Number__c;
structureList.add(hsw);
System.debug('haccd.ScrapFactor...'+haccd.Scrap_Factor__c);
System.debug('haccd.Accessory_Part_Number__c...'+haccd.Accessory_Part_Number__c);
}
}

//strucData.addAll(structureList);
*/
        return structureList;
    }

    public Holder_Leadtime_Schedule__c filterSchedule(decimal deQty,string sch) {

        System.debug('LEAD deQty'+deQty);
        System.debug('LEAD sch'+sch);
        Holder_Leadtime_Schedule__c ldRec=new Holder_Leadtime_Schedule__c();
        for(Holder_Leadtime_Schedule__c lRec:listScheduleName) {
            if(lRec.Schedule__c==sch && (lRec.QtyLL__c<=deQty && lRec.QtyUL__c>=deQty)) {
                ldRec=lRec;
                break;
            }
        }
        return ldRec;
    }
    public List<HLDRLeadWrapper> getLeadTimeCust(List<HLDRStructureWrapper> strucDataCust, Decimal qty, String conHolderId) {

        strBrand = [select Quote_Line__r.SBQQ__Quote__r.Brand__c from Holders__c where id = :conHolderId].Quote_Line__r.SBQQ__Quote__r.Brand__c;
        listScheduleName = [SELECT Entity__c,Leadtime__c,QtyLL__c,QtyUL__c,Schedule__c FROM Holder_Leadtime_Schedule__c WHERE Entity__c= :strBrand];
        System.debug('listScheduleName..is..'+listScheduleName);
        List<HLDRLeadWrapper> resLeadTime = new List<HLDRLeadWrapper>();
        String leadQuery='SELECT Entity__c,Leadtime__c,QtyLL__c,QtyUL__c,Schedule__c FROM Holder_Leadtime_Schedule__c';
        String leadWhereClause =' WHERE ID!=NULL AND Entity__c=\'CDC\'';
        integer cnt=1;
        decimal maxLeadTime=0;
        for(HLDRStructureWrapper hldS: strucDataCust) {
            // if (cnt==1)
            //     leadWhereClause+=' AND ((';
            // else
            //     leadWhereClause+=' OR (';
            decimal qtyAsy=decimal.valueOf(hldS.Qty);
            decimal decROP=1.0;
            if(hldS.ROP!=null)
                decROP=decimal.valueOf(hldS.ROP);
            decimal decQty;
            if(decROP != null && decROP != 0){
                if(qty != null){
                decQty = (qty * qtyAsy)/decROP;
            }else{
                decQty = qtyAsy/decROP;
            }
            }

            string schedule=hldS.leadTime;
            Holder_Leadtime_Schedule__c flDTM=filterSchedule(decQty,schedule);
            String tmpVal;
            if(flDTM!=null) {
                HLDRLeadWrapper hldlm=new HLDRLeadWrapper();
                hldlm.componentType = hldS.structureType;
                tmpVal = hldS.structureType;
                if(tmpVal != null) {

                    tmpVal = tmpVal.replace('2', '');
                }
                hldlm.componentTypeNew = tmpVal;
                hldlm.schedule=flDTM.Schedule__c;
                hldlm.leadtime=flDTM.Leadtime__c;
                if(flDTM.Leadtime__c>maxLeadTime)
                    maxLeadTime=flDTM.Leadtime__c;
                resLeadTime.add(hldlm);
            }
            // leadWhereClause+=' Schedule__c=\''+schedule+'\' AND QtyLL__c<'+decQty+' AND QtyUL__c>='+decQty;
            // leadWhereClause+=' )';
            // if(strucData.size()==cnt)
            //     leadWhereClause+=' )';
            // cnt+=1;
        }
        HLDRLeadWrapper hldlm=new HLDRLeadWrapper();
        hldlm.componentType='TOTAL';
        hldlm.schedule='';
        hldlm.leadtime=maxLeadTime;
        resLeadTime.add(hldlm);
        // System.debug('leadWhereClause'+leadWhereClause);
        // List<Holder_Leadtime_Schedule__c> leadTm=Database.query(leadQuery+leadWhereClause);
        // decimal maxLeadTime=0;
        // if(leadTm.size()>0) {
        //     for(Holder_Leadtime_Schedule__c ldT:leadTm) {
        //         HLDRLeadWrapper hldlm=new HLDRLeadWrapper();
        //         hldlm.componentType='';
        //         hldlm.schedule=ldT.Schedule__c;
        //         hldlm.leadtime=ldT.Leadtime__c;
        //         if(ldT.Leadtime__c>maxLeadTime)
        //             maxLeadTime=ldT.Leadtime__c;
        //         resLeadTime.add(hldlm);
        //     }
        // }
        System.debug('LEAD TIME--->'+maxLeadTime);
        system.debug('resLeadTimeCust::'+resLeadTime);
        return resLeadTime;
    }

    public List<HLDRLeadWrapper> getLeadTime() {

        if(strucData.size() == 0){
            strucData = getStructures();
        }
        List<HLDRLeadWrapper> resLeadTime = getLeadTimeCust(strucData, conHolder.Quantity__c, conHolder.Id);

        return resLeadTime;
    }
    public void saveLead(){
        List<HLDRLeadWrapper> ldtL=new List<HLDRLeadWrapper>();
        ldtL=getLeadTime();
        System.debug('LEAAD---ldtL'+ldtL);
        decimal leadtime=0;
        for(HLDRLeadWrapper l:ldtL) {
            if(l.componentType=='TOTAL') {
                System.debug('LEAAD---leadtime'+l.leadtime);
                leadtime=l.leadtime;
                leadtime=l.leadtime;
                break;
            }
        }
        hldOutput.Lead_Time__c=leadtime;
        if(conHolder.Lead_Time_Override__c == false){
            hldOutput.Lead_Time_Override__c=leadtime;
        }
        System.debug('LEAAD---hldOutput'+hldOutput.id);
        upsert hldOutput;
        // return null;
    }
    public Pagereference saveLeadTime() {
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            quoteLine.Leadtime_Site_10__c = hldOutput.Lead_Time_Override__c;
            upsert quoteLine;
        }
        update hldOutput;
        update conHolder;
        return null;
    }
    public Pagereference applyDefaultsLead() {
        if(!conHolder.Lead_Time_Override__c) {
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Leadtime_Site_10__c = hldOutput.Lead_Time_Override__c;
                upsert quoteLine;
            }
            hldOutput.Lead_Time_Override__c=hldOutput.Lead_Time__c;
        }
        update hldOutput;
        update conHolder;
        return null;
    }

    //*****************************************************************************************************
    //Quote Description
    //*****************************************************************************************************
    public class QuoteDescriptionWrapper {
        public string attribute {set;get;}
        public string strDesc {set;get;}
        public string strDescOverride {set;get;}
        public Integer noOfLines {set;get;}
    }
    public List<QuoteDescriptionWrapper> quoteDescriptionList{get;set;}
    Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW'};
        public list<QuoteDescriptionWrapper> getQuoteDescriptionRec()
    {
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        String decOver;

        for(string strAttr:quotesAttributeSet) {
            QuoteDescriptionWrapper quoteWrapper=new QuoteDescriptionWrapper();
            quoteWrapper.attribute=strAttr;
            String attributeFieldAPI = strAttr+'__c';
            String dec=(string) hldOutput.get(attributeFieldAPI);
            if(dec != null) {
                List<String> lines = dec.split('\n');
                if(lines.size() == 0) {

                    lines = dec.split('\\n');
                }
                quoteWrapper.noOfLines = lines.size();
            } else {
                quoteWrapper.noOfLines=0;
            }

            if(dec != null) {

                dec = dec.replace('\\n', '\n');
            }
            quoteWrapper.strDesc = dec;

            decOver = (string) hldOutput.get(strAttr+'_Overridden__c');
            if(decOver != null) {

                decOver = decOver.replace('\\n', '\n');
            }
            hldOutput.put(strAttr+'_Overridden__c', decOver);
            quoteWrapper.strDescOverride = decOver;
            quoteDescriptionList.add(quoteWrapper);
            System.debug('quoteWrapper: ' + quoteWrapper);
        }
        return quoteDescriptionList;
    }
    public pageReference saveQuoteDescription() {
        System.debug('saveQuoteDescription...'+conHolder.Quote_Descriptions_Override__c);
        update conHolder;
        if(quoteDescriptionList != null && quoteDescriptionList.size() > 0)
        {
            for(QuoteDescriptionWrapper rdQ : quoteDescriptionList)
            {
                String attributeFieldAPI = rdQ.attribute+'_Overridden__c';
                hldOutput.put(attributeFieldAPI, rdQ.strDescOverride);
            }
            update hldOutput;
        }

        if(!notValidStatusForChng.contains(strQuoteStatus)) {

            String strquoteDes1 = strquoteDes;
        	strquoteDes1 = strquoteDes1.replace('\n', '<br/>');

            quoteLine.SBQQ__Description__c = strquoteDes1;
            upsert quoteLine;
        }
        //update conProd;
        return null;
    }
    public PageReference savePartNumber() {

        if(String.isBlank(conHolder.NEWSPCLPARTNOBASE__c) && String.isBlank(conHolder.Part_Number_Base__c)) {

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.HLD_ERROR_MSG_PARTBASE_MISSING ));
            return null;
        }
        if(String.isNotBlank(conHolder.NEWSPCLPARTNOBASE__c) && String.isNotBlank(conHolder.Part_Number_Base__c)) {

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.HLD_ERROR_MSG_PARTBASE_SINGLE_OPTION));
            return null;
        }
        if(!conHolder.Quote_Descriptions_Override__c)
        {
            conHolder.NEWSPCLPARTNOBASE__c =NULL;
            conHolder.PartNumberBase_Checkbox__c=false;
        } else {
        	conHolder.PartNumberBase_Checkbox__c=true;
		}
        if(conHolder.Part_Number_Base__c != null) {

            conHolder.Part_Number_Base_Backup__c = conHolder.Part_Number_Base__c;
        }
        if(conHolder.ASSYPARTEXISTING__c != null) {

            conHolder.ASSYPARTEXISTING_Backup__c = conHolder.ASSYPARTEXISTING__c;
        }

        try {
            update conHolder;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    //PartNumber generation Method
    public void generatePartNumber()
    {

        conHolder.Part_Number_Base__c = conHolder.ASSYPARTNOBASE__c;
        //Commented For Deployement********************************************************************************
        Result partNumberResult = AssyPartDefinationProcessor.generatePartNumber(conHolder);
       // *********************************************************************************************************
       //Result partNumberResult =new Result();
        //Till here new lines
        if(partNumberResult.bResult ==  true)
        {
            conHolder.ASSYPARTEXISTING__c = partNumberResult.strRetValue;
            conHolder.Part_Number__c = conHolder.ASSYPARTEXISTING__c;
        }

        update conHolder;
    }

    public pageReference ApplyDefaultQuoteDescription() {
        if(!conHolder.Quote_Descriptions_Override__c)
        {
            string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(strBrand.ToUpperCase());
            string MODEL=conHolder.Holder_Product_Code__c;
            string SIZE=conHolder.Size2__c;
            string HCLASS=conHolder.Bolting_Class__c;
            conHolder.PartNumberBase_Checkbox__c=false;
            //ASSYPARTNOBASE=strBRANDCODE+MODEL+SIZE+HCLASS;
            conHolder.Part_Number_Base__c = strBRANDCODE+MODEL+SIZE+HCLASS;
           /* conHolder = ConfigHolderController.generateHolderPartBaseNumber(conHolder);

            conHolder.Part_Number_Base__c = conHolder.ASSYPARTNOBASE__c;
            if(conHolder.Part_Number_Base__c == null) {

                conHolder.Part_Number_Base__c = conHolder.Part_Number_Base_Backup__c;
            } else {

                conHolder.Part_Number_Base_Backup__c  = conHolder.Part_Number_Base__c;
            }*/

            if(conHolder.ASSYPARTEXISTING__c == null) {

                conHolder.ASSYPARTEXISTING__c = conHolder.ASSYPARTEXISTING_Backup__c;
            } else {

                conHolder.ASSYPARTEXISTING_Backup__c  = conHolder.ASSYPARTEXISTING__c;
            }

            conHolder.Engineering_Notes__c = null;
            conHolder.Additional_Documents__c = null;
            conHolder.NEWSPCLPARTNOBASE__c=null;
            conHolder.ASSYPARTNOBASE__c=null;
            conHolder.NEWSPCLPARTNOBASE__c =null;
            for(string strAttr:quotesAttributeSet) {
                //quoteWrapper.attribute=strAttr;
                String attributeFieldAPI = strAttr+'__c';
                String dec=(string) hldOutput.get(attributeFieldAPI);
                string attributeOverride=strAttr+'_Overridden__c';
                hldOutput.put(attributeOverride, dec);

            }
            //conProd.NEWSPCLPARTNOBASE__c=null;
            System.debug('NEWSPCLPARTNOBASE__c'+ conHolder.NEWSPCLPARTNOBASE__c);
            upsert hldOutput;
            update conHolder;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        } else {

            conHolder.ASSYPARTEXISTING__c = null;
            update conHolder;
        }

        return null;
    }
    //**************************************************************************************************** */
    //END OF Description
    //**************************************************************************************************** */
    public string strquoteDes {
        get {

            //always fetch the updated details from master data description
            //start...
            Result resDescTmp = ConfigHolderUtility.getHolderDescription(holderInputs);
            if(resDescTmp.bResult) {

                String OA, OB, OW;
                Holder_Description_Detail__c  descRec;
                OA = '';
                OB = '';
                OW = '';
                for(sObject sobj: resDescTmp.objResultList){

                    descRec = new Holder_Description_Detail__c();
                    descRec = (Holder_Description_Detail__c) sobj;
                    if (descRec.Attribute__c.startsWith('OA'))
                        OA+=String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                    else if (descRec.Attribute__c.startsWith('OB'))
                        OB+=String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                    else if (descRec.Attribute__c.startsWith('OW'))
                        OW+=String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                }
                hldOutput.put('OA__c', OA);
                hldOutput.put('OB__c', OB);
                hldOutput.put('OW__c', OW);
                if(conHolder.Quote_Descriptions_Override__c == false){
                    hldOutput.put('OA_Overridden__c', OA);
                    hldOutput.put('OB_Overridden__c', OB);
                    hldOutput.put('OW_Overridden__c', OW);
                }

                update hldOutput;
            }
            //end...

            String strProdOver = '';
            if(String.isNotBlank(hldOutput.OA_Overridden__c)){
                strProdOver += hldOutput.OA_Overridden__c + '\n\n';
            }
            if(String.isNotBlank(hldOutput.OB_Overridden__c)){
                strProdOver += hldOutput.OB_Overridden__c + '\n\n';
            }
            if(String.isNotBlank(hldOutput.OW_Overridden__c)){
                strProdOver += hldOutput.OW_Overridden__c + '\n\n';
            }

            strProdOver = strProdOver.replaceAll('\\n', '\n');
            strProdOver = strProdOver.replace('\\n', '\n');
            strquoteDes = strProdOver;

            return strquoteDes;
            //return rdOutput.OA_Override__c+'\n'+rdOutput.OB_Override__c+'\n'+rdOutput.ORP_Override__c+'\n'+rdOutput.ORV_Override__c+'\n'+rdOutput.OW_Override__c;
        }
        set {
            this.strquoteDes=value;
        }
    }

    //Holder Router Wrapper
    public class HolderRouterWrapper
    {
        public string strOPERATION {set;get;}
        //public string strType {set;get;}
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
        public string strDescr {set;get;}
    }
    public list<HolderRouterWrapper> getHolderRouter()
    {
        list<HolderRouterWrapper> HolderRouterWrapList=new list<HolderRouterWrapper>();

        {
            result res=new result();

            res = ConfigHolderUtility.getHLDRouting(holderInputs);
            if(res.bResult)
            {
                for (sObject sobj:res.objResultList)
                {
                    HolderRouterWrapper docWrap=new HolderRouterWrapper();
                    docWrap.strOPERATION  = (string) sobj.get('OPERATION__c');
                    //docWrap.strType  = (string) sobj.get('Type__c');
                    docWrap.strStandard_Operation_ID = (string) sobj.get('Standard_Operation_ID__c');
                    docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                    docWrap.strDescr = (string) sobj.get('Descr__c');
                    HolderRouterWrapList.add(docWrap);
                }
            }

        }
        return HolderRouterWrapList;
    }
    //Holder ControlPlan Wrapper
    public class HolderControlPlanWrapper
    {
        public string strTest_OPNO_1 {set;get;}
        public string strTEST_OPERATION_DESC {set;get;}
        public string strNORM_TYPE {set;get;}
        public string strOperation_Number {set;get;}
        public string strDATA_TYPE {set;get;}
        public string strCATEGORY_ID {set;get;}
        public string strINSPECTION_CODE {set;get;}
        public string strSAMPLE_PERCENT {set;get;}
        public string strProcess_Characteristic {set;get;}
        public string strSpecial_Characteristic_Classification {set;get;}
        public string strOUTER_MIN {set;get;}
        public string strINNER_MIN {set;get;}
        public string strNOMINAL_VALUE {set;get;}
        public string strINNER_MAX {set;get;}
        public string strOUTER_MAX {set;get;}
        public string strTool_ID {set;get;}
        public string strData_Point {set;get;}
    }
    public list<HolderControlPlanWrapper> getHolderControlPlan()
    {
        list<HolderControlPlanWrapper> HolderControlPlanWrapList=new list<HolderControlPlanWrapper>();

        {
            result res=new result();
            res=ConfigHolderUtility.getHolderControlPlan(holderInputs);
            if(res.bResult)
            {
                for (sObject sobj:res.objResultList)
                {
                    HolderControlPlanWrapper docWrap=new HolderControlPlanWrapper();
                    docWrap.strTest_OPNO_1  = (string) sobj.get('Test_OPNO_1__c');
                    docWrap.strTEST_OPERATION_DESC  = (string) sobj.get('TEST_OPERATION_DESC__c');
                    docWrap.strNORM_TYPE = (string) sobj.get('NORM_TYPE__c');
                    docWrap.strOperation_Number = (string) sobj.get('Operation_Number__c');
                    docWrap.strDATA_TYPE = (string) sobj.get('DATA_TYPE__c');
                    docWrap.strCATEGORY_ID = (string) sobj.get('CATEGORY_ID__c');
                    docWrap.strINSPECTION_CODE = (string) sobj.get('INSPECTION_CODE__c');
                    docWrap.strSAMPLE_PERCENT = (string) sobj.get('SAMPLE_PERCENT__c');
                    docWrap.strProcess_Characteristic = (string) sobj.get('Process_Characteristic__c');
                    docWrap.strSpecial_Characteristic_Classification = (string) sobj.get('Special_Characteristic_Classification__c');
                    docWrap.strOUTER_MIN = (string) sobj.get('OUTER_MIN__c');
                    docWrap.strINNER_MIN = (string) sobj.get('INNER_MIN__c');
                    docWrap.strNOMINAL_VALUE = (string) sobj.get('NOMINAL_VALUE__c');
                    docWrap.strINNER_MAX = (string) sobj.get('INNER_MAX__c');
                    docWrap.strOUTER_MAX = (string) sobj.get('OUTER_MAX__c');
                    docWrap.strTool_ID = (string) sobj.get('Tool_ID__c');
                    docWrap.strData_Point = (string) sobj.get('Data_Point__c');
                    HolderControlPlanWrapList.add(docWrap);
                }
            }

        }
        return HolderControlPlanWrapList;
    }
    //Holder Workguidelines Wrapper
    public class HolderWorkGLWrapper
    {
        public string strOperation {set;get;}
        public string strTest {set;get;}
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
        public string strGuideline_Seq {set;get;}
        public string strDescription {set;get;}
        public string strText {set;get;}
        public string strType {set;get;}
        public string strSign_Off {set;get;}
        public string strInspection_Sign_Off_Required {set;get;}
    }
    public map<string,string> getAllHolderIFSAttributes() {
        map<string,string> myMap=new map<string,string>();
        map<string,string> myMap1=new map<string,string>();
        String attrCode;
        myMap.putAll(holderInputs);
        myMap.putAll(lookupAttributesAll);
        myMap.putAll(additionalCodeAttributesMap);
        myMap.putAll(testingCodeAttributesMap);
        IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='HLD'];
        for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            attrCode = ifsAtt.Attribute_Code__c;

            //replace HNDSPSC with HNPDSC
            attrCode = attrCode.replace('HNDSPSC', 'HNPDSC');
            if(myMap.get(attrCode)!=null)
                myMap1.put(attrCode, myMap.get(attrCode));
            else
                myMap1.put(attrCode, '');
        }
        return myMap1;
    }
    public map<string,string> getHolderIFSAttributesWithFalse() {
        map<string,string> myMap=new map<string,string>();
        map<string,string> myMap1=new map<string,string>();
        myMap.putAll(holderInputs);
        myMap.putAll(lookupAttributesAll);
        myMap.putAll(additionalCodeAttributesMap);
        myMap.putAll(testingCodeAttributesMap);

        List<IFS_character_codes__c> recordList = [SELECT Attribute_Code__c,Element__c,Interface_to_IFS_Attributes__c FROM IFS_character_codes__c WHERE Product__c = 'HLD' AND Interface_to_IFS_Attributes__c = false];
        String attrCode;
        for(IFS_character_codes__c record : recordList)
        {
            attrCode = record.Attribute_Code__c ;

            if(myMap.containsKey(attrCode)){
                if(myMap.get(attrCode)!=null)
                    myMap1.put(attrCode, myMap.get(attrCode));
                else
                    myMap1.put(attrCode, '');
            }
        }
        return myMap1;
    }
    public list<HolderWorkGLWrapper> getHolderWorkGL()
    {
        list<HolderWorkGLWrapper> HolderRouterWGLList=new list<HolderWorkGLWrapper>();

        {
            result res=new result();

            res=ConfigHolderUtility.getHolderWorkGuideLines(holderInputs);
            if(res.bResult)
            {
                for (sObject sobj:res.objResultList)
                {
                    HolderWorkGLWrapper docWrap=new HolderWorkGLWrapper();
                    docWrap.strOperation  = (string) sobj.get('Operation__c');
                    docWrap.strTest  = (string) sobj.get('Test__c');
                    docWrap.strStandard_Operation_ID = (string) sobj.get('Standard_Operation_ID__c');
                    docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                    docWrap.strGuideline_Seq  = (string) sobj.get('Guideline_Seq__c');
                    docWrap.strDescription  = (string) sobj.get('Description__c');
                    docWrap.strText  = (string) sobj.get('Text__c');
                    docWrap.strType  = (string) sobj.get('Type__c');
                    docWrap.strSign_Off  = (string) sobj.get('Sign_Off__c');
                    docWrap.strInspection_Sign_Off_Required  = (string) sobj.get('Inspection_Sign_Off_Required__c');
                    HolderRouterWGLList.add(docWrap);
                }
            }

        }
        return HolderRouterWGLList;
    }

    /*********************************
*Holder Cost Logic
******************************************/
    /* List<Cost__c> cstList = new List<Cost__c>();
cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(conHolder.Id)];
if(!cstList.isEmpty() && cstList.size() >0 )
{
delete cstList;
}
getCosts();*/
    public void costOnload()
    {
        getCosts();
    }
    //public List<SelectOption> OrificeSettings{get;set;}
    public List<Cost__c> assembleCost{get;set;}
    public List<Cost__c> buildCost{get;set;}
    public List<Cost__c> overridenCost{get;set;}
    public List<Cost__c> hiddenCost{get;set;}
    public void getCosts()
    {
        saveLead();
        List<Holder_Price_Details__c> abc = getPricinglist();
        assembleCost = new List<Cost__c>();
        buildCost = new List<Cost__c>();
        overridenCost = new List<Cost__c>();
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            quoteLine.Config_Record_Id__c = conHolder.id;
            quoteLine.SBQQ__Quantity__c=conHolder.Quantity__c;
            //quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
            if(conHolder.Non_Discountable_Price__c != 9999999 && conHolder.Non_Discountable_Price__c != 8888888)
                quoteLine.Non_Discountable_List_Price__c =  conHolder.Non_Discountable_Price__c/ conHolder.Quantity__c;
            else
                quoteLine.Non_Discountable_List_Price__c =  conHolder.Non_Discountable_Price__c ;

            quoteLine.Discountable_List_Price__c = conHolder.Discountable_Price__c;
            quoteLine.Leadtime_Site_10__c = hldOutput.Lead_Time_Override__c;
            quoteLine.Leadtime_Site_20__c = 7777;
            quoteLine.Leadtime_Site_30__c = 7777;
            quoteLine.Leadtime_Site_40__c = 7777;
            upsert quoteLine;
        }
        //Commented For Deployement********************************************************************************
        WizardCostProcessor wcp = new WizardCostProcessor(conHolder.Id);
        Map<String,List<Cost__c>> getBGRCostData = wcp.getBGRCostData();
	   //*****************************************************************************************************

      // Map<String,List<Cost__c>> getBGRCostData = new  Map<String,List<Cost__c>>();
        //NEW LINE ADDED TILL HERE###########################################################################
        //    System.debug('@@@@@ getBGRCostData = '+getBGRCostData);
        if(getBGRCostData.containsKey('Assembly'))
        {
            assembleCost.addAll(getBGRCostData.get('Assembly'));
        }
        if(getBGRCostData.containsKey('Build Up'))
        {
            buildCost.addAll(getBGRCostData.get('Build Up'));
        }
        if(getBGRCostData.containsKey('Overriden'))
        {
            overridenCost.addAll(getBGRCostData.get('Overriden'));
        }
        //  System.debug('@@@@@1111111111111111111111111111111111111111111 buildCost = '+buildCost);

    }
    public pageReference saveCosting()
    {
        List<Cost__c> allCost = new List<Cost__c>();
        if(assembleCost != null && assembleCost.size() > 1)
        {
            allCost.addAll(assembleCost);
        }
        if(buildCost != null && buildCost.size() > 0)
        {
            allCost.addAll(buildCost);
        }
        if(allCost.size() > 0)
        {
            update allCost;
        }
        update conHolder;
        getCosts();
        return null;
    }
    public pageReference ApplyDefaultCost()
    {
        if(conHolder.Cost_Override__c == false)
        {
            List<Cost__c> allCost = new List<Cost__c>();
            if(assembleCost != null && assembleCost.size() > 1)
            {
                allCost.addAll(assembleCost);
            }
            if(buildCost != null && buildCost.size() > 0)
            {
                allCost.addAll(buildCost);
            }
            if(allCost != null && allCost.size() > 0)
            {
                for(Cost__c costRecord: allCost)
                {
                    costRecord = copyCostToCostOverride(costRecord);
                }
                update allCost;
            }
            update conHolder;
            getCosts();
        }
        return null;
    }
    public Cost__c copyCostToCostOverride(Cost__c costRecord)
    {
        costRecord.Inside_Cost_Override_10__c = costRecord.Inside_Cost_10__c;
        costRecord.Outside_Cost_Override_10__c = costRecord.Outside_Cost_10__c;
        costRecord.Inside_Cost_Override_20__c = costRecord.Inside_Cost_20__c;
        costRecord.Outside_Cost_Override_20__c = costRecord.Outside_Cost_20__c;
        costRecord.Inside_Cost_Override_30__c = costRecord.Inside_Cost_30__c;
        costRecord.Outside_Cost_Override_30__c = costRecord.Outside_Cost_30__c;
        return costRecord;
    }

    /**********************************************************
* Holder Diagram Logic
* ********************************************************/
    /************************************************************************
Holder Diagram Logic
*******************************************************************************/
    public map<string,string> mapDocData{get;set;}
    public string diagramURL {set;get;}
    public boolean showDia1 {set;get;}
    public boolean showDia2 {set;get;}

    public Result getHolderDiagramData() {

        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();

        mapDia.put ('Entity',conHolder.Brand__c);
        mapDia.put('HPTC', conHolder.Holder_Product_Code__c);
        mapDia.put('SZC', conHolder.Size2__c);
        mapDia.put('HCLASS', conHolder.Bolting_Class__c);
        mapDia.put('HIC', conHolder.Inlet_Connection__c);
        mapDia.put('HOC', conHolder.Outlet_Connection__c);
        mapDia.put('COIN', conHolder.Inlet_Option__c);
        mapDia.put('COOUT', conHolder.Outlet_Option2__c);
        mapDia.put('COMF', conHolder.Mid_Flange_Option__c);

        List <String> selectCols=new List <String>();
        selectCols.add('Drawing_Type__c');
        selectCols.add('DrawingID__c');
        selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');
        selectCols.add('HIC__c');
        selectCols.add('HOC__c');
        selectCols.add('SizeClassDesc__c');
        resDiaData = ConfigHolderUtility.getDataFromTranslationObj('Drawing_Type__c','Holder_Drawings_Translation__c','Holder_Drawings_Detail__c',mapDia,selectCols, null);

        return resDiaData;
    }
    public result loadDiagramData(){
        system.debug('loadDiagramData');

        result resDiaData = getHolderDiagramData();

        //map<string,string> mapDia=new map<string,string>();
        /*
mapDia.put('HPTC',conHolder.Holder_Product_Code__c);
mapDia.put ('Entity',conHolder.Brand__c);
mapDia.put ('COIN',conHolder.Inlet_Option__c);
mapDia.put ('SZC',conHolder.Size__c);
mapDia.put ('HCLASS',conHolder.Bolting_Class__c);
*/
        /*
mapDia.put ('Entity',conHolder.Brand__c);
mapDia.put('HPTC', conHolder.Holder_Product_Code__c);
mapDia.put('SZC', conHolder.Size2__c);
mapDia.put('HCLASS', conHolder.Bolting_Class__c);
mapDia.put('HIC', conHolder.Inlet_Connection__c);
mapDia.put('HOC', conHolder.Outlet_Connection__c);
mapDia.put('COIN', conHolder.Inlet_Option__c);
mapDia.put('COOUT', conHolder.Outlet_Option2__c);
mapDia.put('COMF', conHolder.Mid_Flange_Option__c);

List <String> selectCols=new List <String>();
selectCols.add('Drawing_Type__c');
selectCols.add('DrawingID__c');
selectCols.add('DimA__c');
selectCols.add('DimB__c');
selectCols.add('DimC__c');
selectCols.add('DimD__c');
selectCols.add('DimE__c');
selectCols.add('DimF__c');
selectCols.add('HIC__c');
selectCols.add('HOC__c');
selectCols.add('SizeClassDesc__c');
resDiaData=ConfigHolderUtility.getDataFromTranslationObj('Drawing_Type__c','Holder_Drawings_Translation__c','Holder_Drawings_Detail__c',mapDia,selectCols, null);
*/

        result resD=new result ();
        List<Holder_Drawings__c> holderDiagramList1=[select Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c from Holder_Drawings__c where Holders__c=:conHolder.id];
        Holder_Drawings__c holderD= new Holder_Drawings__c();
        if(holderDiagramList1.size()>0){
            holderD =holderDiagramList1[0];
        } else{
            holderD.Holders__c=conHolder.id;
        }
        Integer submittalDrawingFound = 0;
        List<Holder_Drawings__c> holderDiaList = new List<Holder_Drawings__c>();
        if(resDiaData.bResult) {
            for (sObject sObj: resDiaData.objResultList) {
                if ((string) sObj.get('Drawing_Type__c')=='Submittal Drawing') {
                    holderD.Drawing_ID__c=(string) sObj.get('DrawingID__c');
                    holderD.Drawing_ID_Override__c=(string) sObj.get('DrawingID__c');
                    holderD.Dim_A__c=(string) sObj.get('DimA__c');
                    holderD.Dim_A_Override__c=(string) sObj.get('DimA__c');
                    holderD.Dim_B__c=(string) sObj.get('DimB__c');
                    holderD.Dim_B_Override__c=(string) sObj.get('DimB__c');
                    holderD.Dim_C__c=(string) sObj.get('DimC__c');
                    holderD.Dim_C_Override__c=(string) sObj.get('DimC__c');
                    holderD.Dim_D__c=(string) sObj.get('DimD__c');
                    holderD.Dim_D_Override__c=(string) sObj.get('DimD__c');
                    holderD.Dim_E__c=(string) sObj.get('DimE__c');
                    holderD.Dim_E_Override__c=(string) sObj.get('DimE__c');
                    holderD.Dim_F__c=(string) sObj.get('DimF__c');
                    holderD.Dim_F_Override__c=(string) sObj.get('DimF__c');
                    holderD.HIC__c=(string) sObj.get('HIC__c');
                    holderD.HOC__c=(string) sObj.get('HOC__c');
                    holderD.SizeClassDesc__c=(string) sObj.get('SizeClassDesc__c');

                    submittalDrawingFound = 1;
                }
                if ((string) sObj.get('Drawing_Type__c')=='J-Hook IINO') {
                    holderD.J_Hook_IINO__c=(string) sObj.get('DrawingID__c');
                }
                else{
                    holderD.IINO__c=(string) sObj.get('DrawingID__c');
                }
            }
        }

        //If no drawing found then set the default drawing for "submittal drawing" to 9999
        if(submittalDrawingFound == 0 || holderD.Drawing_ID__c == null) {

            holderD.Drawing_ID__c = Label.Default_Submittal_Drawing;
            holderD.Drawing_ID_Override__c = Label.Default_Submittal_Drawing;
        }

        try {
            holderDiaList.add(holderD);
            upsert holderD;
            resD.objResultList= holderDiaList;
            resD.bResult=true;
        } catch (Exception e) {
            resD.bResult=false;
            resD.strErrorMessage='RECORDS ARE NOT FOUND';
        }


        //resDiaData.objResultList.add(holderD);
        resDiaData.bResult=true;


        return resD;
    }
    public Holder_Drawings__c holderDiagram{set;get;}
    public Holder_Drawings__c prodDiagram{set;get;}
    public List<Holder_Drawings__c> holderDiagramList {set;get;}
    public void getDiaData() {

        system.debug('conHolder.id::'+conHolder.id);
        holderDiagramList=[SELECT IINO__c,J_Hook_IINO__c,Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,
                           Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,
                           Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,
                           Dim_F_Override__c, IINO_DWGNO__c, JHOOK_IINO_DWGNO__c, Submittal_Drawing_DWGNO__c
                           FROM Holder_Drawings__c WHERE Holders__c=:conHolder.id];
        if (!holderDiagramList.isEmpty()) {
            system.debug('holderDiagramList:1');
            holderDiagram=holderDiagramList[0];
            diagramURL=holderDiagram.Drawing_ID_Override__c;

            if(conHolder.Drawing_Outside_Config__c) {

                diagramURL = '9999';
                holderDiagram.Drawing_ID_Override__c = '9999';
                holderDiagram.Drawing_ID__c = '9999';

                if(!conHolder.Diagram_Override__c) {

                    holderDiagram.Dim_A_Override__c = '';
                    holderDiagram.Dim_B_Override__c = '';
                    holderDiagram.Dim_C_Override__c = '';
                    holderDiagram.Dim_D_Override__c = '';
                    holderDiagram.Dim_E_Override__c = '';
                    holderDiagram.Dim_F_Override__c = '';

                    holderDiagram.Dim_A__c = '';
                    holderDiagram.Dim_B__c = '';
                    holderDiagram.Dim_C__c = '';
                    holderDiagram.Dim_D__c = '';
                    holderDiagram.Dim_E__c = '';
                    holderDiagram.Dim_F__c = '';
                }

            }
            diagramURL+='.png';
            if(diagramURL.startsWith('1')) {
                showDia1=true;
                showDia2=false;
            }
            else {
                showDia2=true;
                showDia1=false;
            }

        } else {
            system.debug('holderDiagramList:0');
            result abc=loadDiagramData();
            if (abc.bResult)
                holderDiagram=(Holder_Drawings__c) abc.objResultList[0];
        }
        System.debug('mapDocData: ' + mapDocData);
        /*
if(holderDiagram.Drawing_ID__c!=null)
mapDocData.put('Submittal Drawing',holderDiagram.Drawing_ID__c);
if(holderDiagram.IINO__c!=null)
mapDocData.put('IINO',holderDiagram.IINO__c);
if(holderDiagram.J_Hook_IINO__c!=null)
mapDocData.put('J-Hook IINO',holderDiagram.J_Hook_IINO__c);
*/

        if(holderDiagram.Submittal_Drawing_DWGNO__c != null)
            mapDocData.put('Submittal Drawing', holderDiagram.Submittal_Drawing_DWGNO__c);

        if(holderDiagram.IINO_DWGNO__c != null)
            mapDocData.put('IINO', holderDiagram.IINO_DWGNO__c);

        if(holderDiagram.JHOOK_IINO_DWGNO__c != null)
            mapDocData.put('J-Hook IINO', holderDiagram.JHOOK_IINO_DWGNO__c);

        System.debug('mapDocData: ' + mapDocData);
    }
    public pageReference generalSave() {
        try {
            update conHolder;
        } catch (Exception e) {

        }
        return null;
    }
    public pageReference saveDiagrams() {
        try {
            update holderDiagram;
            update conHolder;
            getDiaData();
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Drawing_to_be_created_outside_of_Config__c=conHolder.Drawing_Outside_Config__c;
                quoteLine.DimA__c=holderDiagram.Dim_A_Override__c;
                quoteLine.DimB__c=holderDiagram.Dim_B_Override__c;
                quoteLine.DimC__c=holderDiagram.Dim_C_Override__c;
                quoteLine.DimD__c=holderDiagram.Dim_D_Override__c;
                quoteLine.DimE__c=holderDiagram.Dim_E_Override__c;
                quoteLine.DimF__c=holderDiagram.Dim_F_Override__c;
                quoteLine.DrawingID__c=holderDiagram.Drawing_ID_Override__c;
                //quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        } catch (Exception e) {

        }
        return null;
    }
    public string disabledCSS {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:50px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string stlCSS2 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:80px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string stlCSS3 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:500px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public pageReference applyDefalutsDiagrams() {
        if(!conHolder.Diagram_Override__c) {
            System.debug('conHolder.Diagram_Override__C: ' + conHolder.Diagram_Override__C);
            holderDiagram.Drawing_ID_Override__c=holderDiagram.Drawing_ID__c;
            holderDiagram.Dim_A_Override__c=holderDiagram.Dim_A__c;
            holderDiagram.Dim_B_Override__c=holderDiagram.Dim_B__c;
            holderDiagram.Dim_C_Override__c=holderDiagram.Dim_C__c;
            holderDiagram.Dim_D_Override__c=holderDiagram.Dim_D__c;
            holderDiagram.Dim_E_Override__c=holderDiagram.Dim_E__c;
            holderDiagram.Dim_F_Override__c=holderDiagram.Dim_F__c;
        }

        if(conHolder.Drawing_Outside_Config__c) {

            holderDiagram.Drawing_ID_Override__c = '9999';
            holderDiagram.Dim_A_Override__c = '';
            holderDiagram.Dim_B_Override__c = '';
            holderDiagram.Dim_C_Override__c = '';
            holderDiagram.Dim_D_Override__c = '';
            holderDiagram.Dim_E_Override__c = '';
            holderDiagram.Dim_F_Override__c = '';
            diagramURL = '9999.png';

            /* holderDiagram.Drawing_ID__c = '9999';
holderDiagram.Dim_A__c = '';
holderDiagram.Dim_B__c = '';
holderDiagram.Dim_C__c = '';
holderDiagram.Dim_D__c = '';
holderDiagram.Dim_E__c = '';
holderDiagram.Dim_F__c = ''; */

        } else {

            result resDiaData = getHolderDiagramData();
            if(resDiaData.bResult) {
                for (sObject sObj: resDiaData.objResultList) {

                    if ((string) sObj.get('Drawing_Type__c') == 'Submittal Drawing') {

                        holderDiagram.Drawing_ID__c=(string) sObj.get('DrawingID__c');
                        holderDiagram.Drawing_ID_Override__c=(string) sObj.get('DrawingID__c');

                        if(!conHolder.Diagram_Override__c) {

                            holderDiagram.Dim_A__c=(string) sObj.get('DimA__c');
                            holderDiagram.Dim_A_Override__c=(string) sObj.get('DimA__c');

                            holderDiagram.Dim_B__c=(string) sObj.get('DimB__c');
                            holderDiagram.Dim_B_Override__c=(string) sObj.get('DimB__c');

                            holderDiagram.Dim_C__c=(string) sObj.get('DimC__c');
                            holderDiagram.Dim_C_Override__c=(string) sObj.get('DimC__c');

                            holderDiagram.Dim_D__c=(string) sObj.get('DimD__c');
                            holderDiagram.Dim_D_Override__c=(string) sObj.get('DimD__c');

                            holderDiagram.Dim_E__c=(string) sObj.get('DimE__c');
                            holderDiagram.Dim_E_Override__c=(string) sObj.get('DimE__c');

                            holderDiagram.Dim_F__c=(string) sObj.get('DimF__c');
                            holderDiagram.Dim_F_Override__c=(string) sObj.get('DimF__c');
                        }
                    }
                }
            }

            holderDiagram.Drawing_ID_Override__c = holderDiagram.Drawing_ID__c;
            holderDiagram.Dim_A_Override__c=holderDiagram.Dim_A__c;
            holderDiagram.Dim_B_Override__c=holderDiagram.Dim_B__c;
            holderDiagram.Dim_C_Override__c=holderDiagram.Dim_C__c;
            holderDiagram.Dim_D_Override__c=holderDiagram.Dim_D__c;
            holderDiagram.Dim_E_Override__c=holderDiagram.Dim_E__c;
            holderDiagram.Dim_F_Override__c=holderDiagram.Dim_F__c;

            diagramURL=holderDiagram.Drawing_ID_Override__c+'.png';
        }
        update holderDiagram;
        update conHolder;
        getDiaData();
        return null;
    }
    public pageReference onSpecialPartNoChange()
    {
        if(String.isNotBlank(conHolder.NEWSPCLPARTNOBASE__c) && conHolder.NEWSPCLPARTNOBASE__c != 'None')
        {
            conHolder.Part_Number_Base__c = '';
            conHolder.ASSYPARTEXISTING__c = '';
            System.debug('part..assy..if..'+conHolder.ASSYPARTNOBASE__c);
            System.debug('part..number..else..'+conHolder.Part_Number_Base__c);
        }
        else
        {
            //conHolder.Part_Number_Base__c = '';
            //conHolder.ASSYPARTEXISTING__c = conHolder.ASSYPARTEXISTING_Backup__c;
            //if(conHolder.Part_Number_Base__c == null) {
                string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(strBrand.ToUpperCase());
                string MODEL=conHolder.Holder_Product_Code__c;
                string SIZE=conHolder.Size2__c;
                string HCLASS=conHolder.Bolting_Class__c;
                //ASSYPARTNOBASE=strBRANDCODE+MODEL+SIZE+HCLASS;
                conHolder.Part_Number_Base__c = strBRANDCODE+MODEL+SIZE+HCLASS;
                conHolder.ASSYPARTEXISTING__c = conHolder.ASSYPARTEXISTING_Backup__c;
           // }
            System.debug('part..assy...'+conHolder.ASSYPARTNOBASE__c);
            System.debug('part..number...'+conHolder.Part_Number_Base__c);

        }
        return null;
    }
    public boolean showPricing{get;set;}
    public boolean showProductReview{get;set;}
    public boolean showProductDiagram{get;set;}
    public boolean showProductEngSpl{get;set;}
    public boolean showProductMnfOutputs{get;set;}
    public boolean showProductTroubleSouting{get;set;}
    public pageReference getTabData(){
        System.debug('*** selectedTab = '+selectedTab);
        if(selectedTab == 'ProductReview')
        {
            getLeadTime();
            showPricing=false;
            showProductReview=true;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;
            System.debug('showProductReview'+showProductReview);
        }
        else if (selectedTab == 'Diagram') {
            getDiaData();
            showPricing=false;
            showProductReview=false;
            showProductDiagram=true;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;
        }
        else if(selectedTab == 'Pricing') {

            strucData=getStructures();
            getCosts();

            showPricing=true;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;
        }else if(selectedTab == 'EngineeringSpl')
        {
            showPricing=false;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=true;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;

        }
        else if(selectedTab == 'MfgOutputs')
        {
            getDiaData();
            strucData=getStructures();
            showPricing=false;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=true;
            showProductTroubleSouting=false;


        }else if(selectedTab == 'TroubleShooting')
        {
            showPricing=false;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=true;
        }
        return null;
    }
}