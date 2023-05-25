/**
 * @File Name          : configurePartSelector.cls
 * @Description        : 
 * @Author             : ApexIT
 * @Group              : 
 * @Last Modified By   : ApexIT - SFDC Dev Team
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0        -              ApexIT                Initial Version
 * 1.1      15-APR-2021     Rohini Hathi          Service Ticket #201772, SET PS LEAD TIME OVERRIDE VALUE FOR XML
 * 1.2      02-AUG-2021     Rohini Hathi          Service Ticket #203757, Incorrect Lead Time, when PN is reused.
 **/

public with sharing class configurePartSelector {
    public string strURL{get;set;}
    public SBQQ__QuoteLine__c quoteLine {set;get;} 
    public string strQuoteStatus {set;get;}
    public Part_Selector__c PS {get; set;}
    public String PDgroup{get; set;}
    public string quoteLineId {get;set;}
    Public boolean showsales {get;set;}
    public boolean disableButton {get;set;}
    public String assyPartDefQuery{get;set;}
    public String psAssyPartDefQuery{get;set;}
    Public string partNumber {get{return partNumber?.toUpperCase();} set;}
    public String subPDgroup{get; set;}
    public string displaySelectedText {get;set;}
    public id PSId {set;get;}
    public List<AssyPartDefinitionWrapper> assyPartsList{ get{return new List<AssyPartDefinitionWrapper>(assyPartsList);} set; }
    public string gp{get;set;}
    public string subgp{get;set;}
    public PSOutputUtility PSOU {get;set;}
    Public List<String> allFieldName{get;set;}
    Public Set<String> showName{get;set;}
    Public SObject sobj{get;set;}
    public PS_AssyPartDefinition__c oPSAssyPartDefinition {get;set;}
    public string sProductAttributeData {get;set;}
    public PS_Output__c oPSOutput {get;set;}
    public List<FieldWrapper> listField{get;set;}
    public List<PS_Input_Attr_Value_Desc__c> inputvaluesList1{get;set;}
    public decimal TotalBGRPrice{set;get;}
    public decimal TotalBGRPriceOverride{set;get;}
    public decimal NonDiscountablePriceEach{set;get;}
    public decimal ListPriceEach{set;get;}
    public PS_Price__c oPsPrice{set;get;}
    public list<PSPricingWrapper> PSPricingWrapperList {get;set;}
    public list<PS_Price__c> PSPricingList{set;get;}
    public integer nPartNumberFoundStatus {get;set;}
    public decimal TotalPSPrice{set;get;}
    public decimal TotalPSPriceOverride{set;get;}
    Public List<QuoteDescriptionWrapper> quoteDescriptionList{set;get;}
    public boolean isManagedinSalesforce {get;set;}
    public boolean isValidPartNumber {get;set;}
    Public boolean isDrwaingID {get; set;}
    Public string selectedTab {get; set;}
    
    public string configStatus; // added by piyush readonly/editable
    public ProductAccessibilityConfig__mdt oPacMetaData;// added by piyush readonly/editable
    public boolean bShowEditButton{get;set;}
    public boolean bShowEditButtonImage{get;set;} 
    public boolean bReadOnlyChceckBox {get;set;}
    public boolean bReadOnlyChceckBoxImage {get;set;}
    public string defaultQuoteLineView;  
    public string QuoteLIneView{get;set;}
    public string editModeLable {get;set;}  
    Public PS_Drawing__c  previousDrawiningobj{get; set;}
    Public Boolean showvalue {get; set;}
    Public Boolean showvalue1 {get; set;}
    
    
    //COntroller begins
    public configurePartSelector(ApexPages.StandardController controller)
    {
        showvalue  = True;
        showvalue1 = False;
        system.debug('PS$$$$$$$$$: 1'+partNumber);
        editModeLable = 'Edit'; //added by piyush
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        isDrwaingID = false;
        isValidPartNumber = true;
        nPartNumberFoundStatus = -1;
        
        //Nagrjuna added Tab visibility logic
        showsales = False;
        disableButton = False;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
        profilesetstr.add('CDC Prod. Planning'); 
        profilesetstr.add('CDC Business Super User');
        
        if(profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }
        
        // visibility logic ended
        PSId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('PSId####'+PSId);
        
        PS = DataSelectorWizard.getPartSelectorRecord(PSId);
        system.debug('PS:'+PS);
        
        if(PS.Part_Number__c == null) {
            
            PS.Part_Number__c = PS.Part_Number_Backup__c;
            PS.Part_Number__c = PS.Existing_partnumber__c;
            //partNumber = PS.part_number__c;
            system.debug('PS$$$$$$$$$: 1'+partNumber);
        }else{
            //partNumber = PS.part_number__c;
            system.debug('PS$$$$$$$$$: 1'+partNumber);
        }
        if(PS.Quote_Description_Engineer_Override__c == false) {
            
            if(PS.Part_Number_Base__c == null) {
                
                PS.Part_Number_Base__c = PS.Part_Number_Base_Backup__c ;
            }
        }
        
        
        disableButton = (!showsales) && PS.Quote_Description_Engineer_Override__c;
        if(string.isNotBlank(PS.Quote_Line__c )) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,Parts_Managed_In__c FROM SBQQ__QuoteLine__c  WHERE id = :PS.Quote_Line__c ];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
        
        // added by piyush readonly/editable <
        
        
        if(PS.Finish_Configuration_Flag__c){
            if(PS.Quote_Description_Engineer_Override__c){
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
        
        system.debug('configStatus====> ' + configStatus);
        system.debug('strQuoteStatus====> ' + strQuoteStatus);
        
        oPacMetaData = fetchCurrentProductAccessibility( strQuoteStatus , configStatus);
        system.debug('oPacMetaData----> ' + oPacMetaData);
        bShowEditButton = false;
        bReadOnlyChceckBox = false;
        //   bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;  
        QuoteLIneView = oPacMetaData.View__c; 
        
        system.debug('QuoteLIneView----> ' + QuoteLIneView);
        if(QuoteLIneView == 'Editable'){
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable'){
                disableButton = false;
                bShowEditButton = false;
            }else{
                disableButton = true;
            }
            
        }else if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
            system.debug('bShowEditButton----> ' + bShowEditButton);
            system.debug('disableButton----> ' + disableButton);
            disableButton = true;
            
        }        
        system.debug('bShowEditButton----> ' + bShowEditButton);
        
        if(isManagedinSalesforce == false && PS.Quote_Description_Engineer_Override__c == True)
        {
            quoteLine.isIFSManaged__c = true;
            
        }
        
        
        //added by piyush
        bShowEditButtonImage = bShowEditButton;
        bReadOnlyChceckBoxImage = bReadOnlyChceckBox;
        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            bShowEditButtonImage = false;
            bReadOnlyChceckBoxImage = true;
            
            if (PS.Diagram_Override__c == true ||
                PS.Price_Engineer_Override__c == true ||
                PS.Lead_Time_Engineer_Override__c == true ||
                PS.Build_Cost_Override__c == true ||
                PS.Quote_Description_Engineer_Override__c == true
               ){
                   disableButton = true;
                   bShowEditButton = false;
               }
        }
        
        
        
        // >
        
        oPSAssyPartDefinition = new PS_AssyPartDefinition__c();
        if(PS.Brand__c <> null)
        {
            oPSAssyPartDefinition.BRAND__c = PS.Brand__c;
        }
        oPSAssyPartDefinition.ASSYPARTNO__c =  PS.Part_Number__c;
        oPSAssyPartDefinition.PartRevision__c = PS.PARTREV__c;
        
        PSOU = new PSOutputUtility (PS.Id);
        PDgroup = PS.ProductGroup__c;
        subPDgroup = PS.SubGroup__c;
        
        if(PDgroup == 'PartNum') {
            
            PDgroup = 'Enter Part Number';
        }
        
        //PS.Quantity__c
        //Product-Specific Attributes data
        
        listField = new List<FieldWrapper>();
        fetchfieldsList();
        system.debug(listField+'nagarjuna'+'constructor');
        if(PS.Product_Attribute_Data__c != null)
        {
            sProductAttributeData = PS.Product_Attribute_Data__c;
            System.debug('@Developer --> sProductAttributeData :' + sProductAttributeData);
            list<ProductAttribueData>lstPAD =  ( List<ProductAttribueData>) JSON.deserialize(sProductAttributeData, List<ProductAttribueData>.class);
            for(ProductAttribueData pad : lstPAD)
            {
                for(FieldWrapper wobj : listField)
                {
                    if(wobj.key == pad.sAttributeCode)
                    {
                        wobj.sValue = pad.sValue;
                        break;
                    }
                }
            }
            oPSAssyPartDefinition.ASSYPARTNO__c = PS.Part_Number__c;
            oPSAssyPartDefinition.PartRevision__c = PS.PARTREV__c;
        }
        //getPSDiaData();
        GetQuoteDescriptionRecords();
        //Added by Nagarjuna
        isManagedinSalesforce = showsales;
        /*
if(String.isNotBlank(PS.part_number__c)) {
//PDgroup = 'Enter Part Number';
partNumber = PS.part_number__c;
list<SBQQ__QuoteLine__c> Ql = [select id, isIFSManaged__c from SBQQ__QuoteLine__c where id =: PS.Quote_Line__c];
list<PS_AssyPartDefinition__c> ps_assylst= [select Id,Managed_In__c from PS_AssyPartDefinition__c where ASSYPARTNO__c =:partNumber];
if(ps_assylst.size() > 0)
{
if(ps_assylst[0].Managed_In__c <> 'Salesforce')
{
isManagedinSalesforce = false;
Ql[0].isIFSManaged__c = true;
//update Ql[0];
}
}
}
*/
        system.debug('finish config ' + PS.Finish_Configuration_Flag__c);
        if(PS.Finish_Configuration_Flag__c == true){
            system.debug('finish config ' + PS.Finish_Configuration_Flag__c);
            selectedTab = 'ProductReview';
        }       
    }
    
    public configurePartSelector(String partSelectorId) {
        
        PSId = partSelectorId;
        PS = DataSelectorWizard.getPartSelectorRecord(PSId);        
        PSDataSetup();
    }
    
    public void PSDataSetup() {
        
        showvalue  = True;
        showvalue1 = False;
        system.debug('PS$$$$$$$$$: 1'+partNumber);
        editModeLable = 'Edit'; //added by piyush
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        isDrwaingID = false;
        isValidPartNumber = true;
        nPartNumberFoundStatus = -1;
        
        //Nagrjuna added Tab visibility logic
        showsales = False;
        disableButton = False;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
        profilesetstr.add('CDC Prod. Planning'); 
        profilesetstr.add('CDC Business Super User');
        
        if(profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }
        
        if(PS.Part_Number__c == null) {
            
            PS.Part_Number__c = PS.Part_Number_Backup__c;
            PS.Part_Number__c = PS.Existing_partnumber__c;
            //partNumber = PS.part_number__c;
            system.debug('PS$$$$$$$$$: 1'+partNumber);
        }else{
            //partNumber = PS.part_number__c;
            system.debug('PS$$$$$$$$$: 1'+partNumber);
        }
        if(PS.Quote_Description_Engineer_Override__c == false) {
            
            if(PS.Part_Number_Base__c == null) {
                
                PS.Part_Number_Base__c = PS.Part_Number_Base_Backup__c ;
            }
        }
        
        
        disableButton = (!showsales) && PS.Quote_Description_Engineer_Override__c;
        if(string.isNotBlank(PS.Quote_Line__c )) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,Parts_Managed_In__c FROM SBQQ__QuoteLine__c  WHERE id = :PS.Quote_Line__c ];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
        
        // added by piyush readonly/editable <
        
        
        if(PS.Finish_Configuration_Flag__c){
            if(PS.Quote_Description_Engineer_Override__c){
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
        
        system.debug('configStatus====> ' + configStatus);
        system.debug('strQuoteStatus====> ' + strQuoteStatus);
        
        oPacMetaData = fetchCurrentProductAccessibility( strQuoteStatus , configStatus);
        system.debug('oPacMetaData----> ' + oPacMetaData);
        bShowEditButton = false;
        bReadOnlyChceckBox = false;
        //   bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;  
        QuoteLIneView = oPacMetaData.View__c; 
        
        system.debug('QuoteLIneView----> ' + QuoteLIneView);
        if(QuoteLIneView == 'Editable'){
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable'){
                disableButton = false;
                bShowEditButton = false;
            }else{
                disableButton = true;
            }
            
        }else if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
            system.debug('bShowEditButton----> ' + bShowEditButton);
            system.debug('disableButton----> ' + disableButton);
            disableButton = true;
            
        }        
        system.debug('bShowEditButton----> ' + bShowEditButton);
        
        
        //added by piyush
        bShowEditButtonImage = bShowEditButton;
        bReadOnlyChceckBoxImage = bReadOnlyChceckBox;
        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            bShowEditButtonImage = false;
            bReadOnlyChceckBoxImage = true;
            
            if (PS.Diagram_Override__c == true ||
                PS.Price_Engineer_Override__c == true ||
                PS.Lead_Time_Engineer_Override__c == true ||
                PS.Build_Cost_Override__c == true ||
                PS.Quote_Description_Engineer_Override__c == true
               ){
                   disableButton = true;
                   bShowEditButton = false;
               }
        }
        
        
        
        // >
        
        oPSAssyPartDefinition = new PS_AssyPartDefinition__c();
        if(PS.Brand__c <> null)
        {
            oPSAssyPartDefinition.BRAND__c = PS.Brand__c;
        }
        oPSAssyPartDefinition.ASSYPARTNO__c =  PS.Part_Number__c;
        oPSAssyPartDefinition.PartRevision__c = PS.PARTREV__c;
        
        PSOU = new PSOutputUtility (PS.Id);
        PDgroup = PS.ProductGroup__c;
        subPDgroup = PS.SubGroup__c;
        
        if(PDgroup == 'PartNum') {
            
            PDgroup = 'Enter Part Number';
        }
        
        //PS.Quantity__c
        //Product-Specific Attributes data
        
        listField = new List<FieldWrapper>();
        fetchfieldsList();
        system.debug(listField+'nagarjuna'+'constructor');
        if(PS.Product_Attribute_Data__c != null)
        {
            sProductAttributeData = PS.Product_Attribute_Data__c;
            System.debug('@Developer --> sProductAttributeData :' + sProductAttributeData);
            list<ProductAttribueData>lstPAD =  ( List<ProductAttribueData>) JSON.deserialize(sProductAttributeData, List<ProductAttribueData>.class);
            for(ProductAttribueData pad : lstPAD)
            {
                for(FieldWrapper wobj : listField)
                {
                    if(wobj.key == pad.sAttributeCode)
                    {
                        wobj.sValue = pad.sValue;
                        break;
                    }
                }
            }
            oPSAssyPartDefinition.ASSYPARTNO__c = PS.Part_Number__c;
            oPSAssyPartDefinition.PartRevision__c = PS.PARTREV__c;
        }
        //getPSDiaData();
        GetQuoteDescriptionRecords();
        //Added by Nagarjuna
        isManagedinSalesforce = showsales;
        /*
if(String.isNotBlank(PS.part_number__c)) {
//PDgroup = 'Enter Part Number';
partNumber = PS.part_number__c;
list<SBQQ__QuoteLine__c> Ql = [select id, isIFSManaged__c from SBQQ__QuoteLine__c where id =: PS.Quote_Line__c];
list<PS_AssyPartDefinition__c> ps_assylst= [select Id,Managed_In__c from PS_AssyPartDefinition__c where ASSYPARTNO__c =:partNumber];
if(ps_assylst.size() > 0)
{
if(ps_assylst[0].Managed_In__c <> 'Salesforce')
{
isManagedinSalesforce = false;
Ql[0].isIFSManaged__c = true;
//update Ql[0];
}
}
}
*/
        system.debug('finish config ' + PS.Finish_Configuration_Flag__c);
        if(PS.Finish_Configuration_Flag__c == true){
            system.debug('finish config ' + PS.Finish_Configuration_Flag__c);
            selectedTab = 'ProductReview';
        }
    }
    
     public void updateQLAsync() {
        
        getPSDiaData();
        
        if(String.isNotBlank(PS.part_number__c)) {
            system.debug('PS$$$$$$$$$: 2'+partNumber);
            system.debug('Inside Action Func...');
            //PDgroup = 'Enter Part Number';
            //partNumber = PS.part_number__c;            
            partNumber = PS.Partnumber_orginal__c;
            system.debug('@@partNumber' + partNumber);
            
            list<SBQQ__QuoteLine__c> Ql = [select id, isIFSManaged__c,Is_Special__c,Parts_Managed_In__c from SBQQ__QuoteLine__c where id =: PS.Quote_Line__c];
            list<PS_AssyPartDefinition__c> ps_assylst= [select Id,Managed_In__c from PS_AssyPartDefinition__c where ASSYPARTNO__c =:partNumber];
            if(ps_assylst.size() > 0) {
               system.debug('enter method');                
                if(ps_assylst[0].Managed_In__c == 'IFS') 
                {
                    system.debug('enter method1'); 
                    system.debug('@@@@@@' + PS.Quote_Description_Engineer_Override__c); 
                    isManagedinSalesforce = false;
                    PS.Is_managed_in_Salesforce__c = false;
                    Ql[0].isIFSManaged__c = true;
                    //update Ql[0];
                    system.debug('@@@@@@@ ' + Ql[0].Is_Special__c);
                    Ql[0].Is_Special__c	= PS.Quote_Description_Engineer_Override__c;
                }
                else
                {
                    PS.Is_managed_in_Salesforce__c = true;
                }
            }
            
            system.debug('@@@@@@@ ' + Ql[0].Is_Special__c);
            Ql[0].Is_Special__c	= PS.Quote_Description_Engineer_Override__c;
             
            update Ql[0];
            system.debug('@@@@@@' + Ql[0]);
            update PS;
            getCosts();
        }
    }
    
    public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
            strURL = '/apex/ConfigPartSelectorReference?Id=' + PS.Id; 
            
        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }
    
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
    
    public List<string> notValidStatusForChng {
        get {
            return new List<String>{'Approved','Order Submitted'};
                }
        set {
            this.notValidStatusForChng=value;
        }
    }
    public PS_Drawing__c psDiagram{set;get;}
    public string diagramURL{set;get;}
    public boolean showDia1{set;get;}
    public boolean showDia2{set;get;}
    public boolean isImagefromPartNumber = false ;
    public void getPSDiaData()
    {
        showDia2 = false;
        showDia1 = false;
        List<PS_Drawing__c> psDiagramList = new List<PS_Drawing__c>();
        // if(!PS.Drawing_Outside_Config__c){
        if(String.isNotBlank(PS.Part_Number__c))
        {
            system.debug('PS$$$$$$$$$: 3'+partNumber);
            system.debug('PS.Part_Number__c'+PS.Part_Number__c);
            String psPartNumber = PS.Part_Number__c;
            String psDrawingnum = PS.Drawing_id_override__c;
            system.debug('@@ before query run: '+PS.Drawing_id_override__c);
            psDiagramList = [SELECT Id, Name,DimA__c,DimA_Override__c,DimB__c,DimB_Override__c,DimC__c,DimC_Override__c,
                             DimD__c,DimD_Override__c,DimE__c,DimE_Override__c,DimF__c,DimF_Override__c,Drawing_ID_Override__c,
                             DrawingID__c,PartSelector__c,ASSYPARTNO__c FROM PS_Drawing__c WHERE (ASSYPARTNO__c =:psPartNumber ) order by ASSYPARTNO__c NULLS LAST];
            // OR DrawingID__c =:psDrawingnum
            system.debug('psDiagramList'+psDiagramList);
            
            
            if(!psDiagramList.isEmpty() && psDiagramList.size() > 0)
            {
                psDiagram=psDiagramList[0];
                // if(psDiagram.DrawingID__c == psDrawingnum){
                //     isImagefromPartNumber = false;
                // }
                if(psDiagram.ASSYPARTNO__c == psPartNumber){
                    isImagefromPartNumber = true;
                }
                diagramURL=psDiagram.DrawingID__c;
                diagramURL+='.png';
                if(diagramURL.startsWith('1'))
                {
                    showDia1=true;
                    showDia2=false;
                }
                else
                {
                    showDia2=true;
                    showDia1=false;
                }
            }
        }
        system.debug(diagramURL+'diagramURL');
        system.debug(PS.Drawing_id_override__c+'diagramURL');
        system.debug(PS.Diagram_Override__c+'diagramURL');
        // }else{
        if(PS.Diagram_Override__c){
            if(!String.Isempty(PS.Drawing_id_override__c)){
                diagramURL = PS.Drawing_id_override__c;
                diagramURL+='.png';
                if(diagramURL.startsWith('1'))
                {
                    showDia1=true;
                    showDia2=false;
                }
                else
                {
                    showDia2=true;
                    showDia1=false;
                }    
                psDiagramList = [SELECT Id, Name,DimA__c,DimA_Override__c,DimB__c,DimB_Override__c,DimC__c,DimC_Override__c,
                                 DimD__c,DimD_Override__c,DimE__c,DimE_Override__c,DimF__c,DimF_Override__c,Drawing_ID_Override__c,
                                 DrawingID__c,PartSelector__c,ASSYPARTNO__c FROM PS_Drawing__c WHERE (DrawingID__c = :PS.Drawing_id_override__c ) order by ASSYPARTNO__c NULLS LAST];      
                if(!psDiagramList.isEmpty() && psDiagramList.size() > 0)
                {  
                    PS.DimA_Override__c= psDiagramList[0].DimA__c;
                    PS.DimB_Override__c= psDiagramList[0].DimB__c;
                    PS.DimC_Override__c= psDiagramList[0].DimC__c;
                    PS.DimD_Override__c= psDiagramList[0].DimD__c;
                    PS.DimE_Override__c= psDiagramList[0].DimE__c;
                    PS.DimF_Override__c= psDiagramList[0].DimF__c;
                }
            }           
            update PS;
            
        }
        if(PS.Drawing_Outside_Config__c){
            showDia1=false;
            showDia2=false;
        }
        
        system.debug(diagramURL);
    }
    
    public pageReference goBack() {
        Id qID = [SELECT Id,SBQQ__Quote__c,Parts_Managed_In__c FROM SBQQ__QuoteLine__c  WHERE id = :PS.Quote_Line__c].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL =  '/s/detail/'+qID ;
        }else{
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }
        //PageReference pageRef = new PageReference('/lightning/r/SBQQ__Quote__c/'+qID+'/view');
        //pageRef.setRedirect(true);
        return null;
    }
    
    public pageReference applyDefalutsDiagrams()
    {
        system.debug(isImagefromPartNumber+'isImagefromPartNumber');
        if(!PS.Diagram_Override__C)
        {
            // System.debug('conProd.Diagram_Override__C: ' + conProd.Diagram_Override__C);
            PS.Drawing_ID_Override__c= null;
            PS.DimA_Override__c= null;
            PS.DimB_Override__c= null;
            PS.DimC_Override__c= null;
            PS.DimD_Override__c= null;
            PS.DimE_Override__c= null;
            PS.DimF_Override__c= null;
            // if(!isImagefromPartNumber){
            //     PS.Drawing_id_override__c = null;
            //     PS.DimA_Override__c = null;
            //     PS.DimB_Override__c = null;
            //     PS.DimC_Override__c = null;
            //     PS.DimD_Override__c = null;
            //     PS.DimE_Override__c = null;
            //     PS.DimF_Override__c = null;
            //     showDia1 = false;
            //     showDia2 = false;
            //     system.debug('Inside pppppp');
            //     psDiagram = null;
            // }
            
        }
        
        update PS;
        getPSDiaData();
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            quoteLine.Drawing_to_be_created_outside_of_Config__c=PS.Drawing_Outside_Config__c;
            quoteLine.DrawingID__c= PS.Drawing_ID_Override__c;
            quoteLine.DimA__c=PS.DimA_Override__c;
            quoteLine.DimB__c=PS.DimB_Override__c;
            quoteLine.DimC__c=PS.DimC_Override__c;
            quoteLine.DimD__c=PS.DimD_Override__c;
            quoteLine.DimE__c=PS.DimE_Override__c;
            quoteLine.DimF__c=PS.DimF_Override__c;
        }
        update quoteLine;
        system.debug( PS.Drawing_ID_Override__c);
        system.debug( PS.DimA_Override__c);
        return null;
    }
    
    
    public pageReference saveDiagrams()
    {
        //    if(PS.Diagram_Override__c == True) {
        //     showvalue  = False;
        //      showvalue1 = True;
        //      previousDrawiningobj  = new PS_Drawing__c ();
        //      //if(previousDrawiningobj.DrawingID__c != null){
        //      previousDrawiningobj.DrawingID__c = psDiagram.DrawingID__c;
        //      system.debug('@@@@@' + previousDrawiningobj.DrawingID__c);
        //      previousDrawiningobj.DimA__c = psDiagram.DimA__c;
        //      previousDrawiningobj.DimB__c = psDiagram.DimB__c;
        //      previousDrawiningobj.DimC__c = psDiagram.DimC__c;
        //      previousDrawiningobj.DimD__c = psDiagram.DimD__c;
        //      previousDrawiningobj.DimE__c = psDiagram.DimE__c;
        //      previousDrawiningobj.DimF__c = psDiagram.DimF__c;
        //      //}
        //      }  
        
        
        try
        {
            // update psDiagram;
            update PS;
            getPSDiaData();
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Drawing_to_be_created_outside_of_Config__c=PS.Drawing_Outside_Config__c;
                quoteLine.DrawingID__c= PS.Drawing_ID_Override__c;
                quoteLine.DimA__c=PS.DimA_Override__c;
                system.debug('@@@@@' +PS.DimA_Override__c);
                quoteLine.DimB__c=PS.DimB_Override__c;
                quoteLine.DimC__c=PS.DimC_Override__c;
                quoteLine.DimD__c=PS.DimD_Override__c;
                quoteLine.DimE__c=PS.DimE_Override__c;
                quoteLine.DimF__c=PS.DimF_Override__c;
            }
            update quoteLine;
        }
        
        catch (Exception e)
        {
            
        }
        system.debug(diagramURL+'diagramURL');
        return null;
    }
    public string disabledCSS
    {
        get
        {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:50px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string stlCSS2
    {
        get
        {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:80px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string stlCSS3
    {
        get
        {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:500px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    
    public void searchQuoteLineItem(){
        system.debug('$$$$$$$$$$$'+partNumber+'-'+PS.Brand__c);
        //if(String.isNotBlank(partNumber) && PS.Brand_picklist__c <> null) {
        if(String.isNotBlank(partNumber) && PS.Brand__c <> null) { // updated by @piyush 15 may 2020
            oPSAssyPartDefinition.ASSYPARTNO__c = partNumber;
            PS.Partnumber_orginal__c = partNumber;
            system.debug('@@@@@@@@@@'+PS.Partnumber_orginal__c);
            //string brandStr=PS.Brand_picklist__c;
            string brandStr = PS.Brand__c;// updated by @piyush 15 may 2020
            system.debug(partNumber);
            system.debug(brandStr);
            list<AssyPartDefinitionWrapper> lstItems = new list<AssyPartDefinitionWrapper>();
            
            assyPartDefQuery ='Select BRAND__c,ASSYPARTNO__c,Configurator__c,Product_Ref__c ';
            assyPartDefQuery += ' From AssyPartDefinition__c ';
            assyPartDefQuery += ' Where (ASSYPARTNO__c = :partNumber AND BRAND__c = :brandStr and Managed_In__c = \'IFS\')';
            System.debug('*******assyPartDefQuery'+assyPartDefQuery);
            
            List<AssyPartDefinition__c> lstAssPartDef = Database.query(assyPartDefQuery);
            system.debug('lstAssPartDef***'+lstAssPartDef.size());
            
            for(AssyPartDefinition__c apd : lstAssPartDef){
                AssyPartDefinitionWrapper oAssyPartDefinitionWrapper = new AssyPartDefinitionWrapper();
                oAssyPartDefinitionWrapper.ASSYPARTNO =  apd.ASSYPARTNO__c;
                oAssyPartDefinitionWrapper.BRAND =  apd.BRAND__c;
                lstItems.add(oAssyPartDefinitionWrapper);
            }
            
            // search part number in PS_AssyPartDefinition added by piyush
            psAssyPartDefQuery = 'Select BRAND__c,ASSYPARTNO__c,Configurator__c,PartRevision__c ';//Added PartRevision__c Nagarjuna
            psAssyPartDefQuery += ' From PS_AssyPartDefinition__c ';
            psAssyPartDefQuery += 'Where (ASSYPARTNO__c=:partNumber AND BRAND__c = :brandStr)';
            System.debug('*******psAssyPartDefQuery'+psAssyPartDefQuery);
            
            List<PS_AssyPartDefinition__c> lstPS_AssPartDef = Database.query(psAssyPartDefQuery);
            system.debug('lst PS size' + lstPS_AssPartDef.size());
            
            for(PS_AssyPartDefinition__c psApd : lstPS_AssPartDef){
                oPSAssyPartDefinition = psApd;
                AssyPartDefinitionWrapper oAssyPartDefinitionWrapper = new AssyPartDefinitionWrapper();
                oAssyPartDefinitionWrapper.ASSYPARTNO =  psApd.ASSYPARTNO__c;
                oAssyPartDefinitionWrapper.BRAND =  psApd.BRAND__c;
                lstItems.add(oAssyPartDefinitionWrapper);
            }
            
            if(lstItems.isEmpty()){
                nPartNumberFoundStatus = 0;
                isValidPartNumber = false;
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Part Number not found for the selected Brand ');
                //ApexPages.addMessage(myMsg);
            }
            else{
                nPartNumberFoundStatus = 1;
                assyPartsList = lstItems;
            }
        }
    }
    
    
    public class AssyPartDefinitionWrapper{
        public string ASSYPARTNO{get;set;}
        public string BRAND{get;set;}
    }
    
    
    /*  public List<SelectOption> getCountries()
//AssyPartDefinationProcessor.getPartNumberByRec(PS);
{
List<SelectOption> options = new List<SelectOption>();

Schema.DescribeFieldResult fieldResult =Part_Selector__c.ProductGroup__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

for( Schema.PicklistEntry f : ple)
{
options.add(new SelectOption(f.getLabel(), f.getValue()));
}
return options;
}*/
    
    
    public List<SelectOption> getPrdList() {
        List<selectOption> opt =new List<selectOption>();
        opt.add(new SelectOption('','--NONE--'));
        Set<String> catSet = new Set<String>();
        //for (PS_Input_Attr_Matrix__c gp : [select Id,ProdGroup__c from PS_Input_Attr_Matrix__c where Brand__c=:PS.Brand_picklist__c])
        for (PS_Input_Attr_Matrix__c gp : [select Id,ProdGroup__c from PS_Input_Attr_Matrix__c where Brand__c=:PS.Brand__c])
        {
            //Populate SelectList
            if(!catSet.Contains(gp.ProdGroup__c)){
                catSet.add(gp.ProdGroup__c);
                opt.add(new SelectOption(gp.ProdGroup__c, gp.ProdGroup__c));
            }
        }
        opt.add(new SelectOption('Enter Part Number','Enter Part Number'));
        System.debug('Display PrdList values' +opt);
        return opt ;
        
    }
    
    public List<SelectOption> getSubPrdctList() {
        List<selectOption> opt =new List<selectOption>();
        opt.add(new SelectOption('','--NONE--'));
        Set<String> catSet = new Set<String>();
        for (PS_Input_Attr_Matrix__c subgp: [select Id,ProdGroup__c,SubGroup__c from PS_Input_Attr_Matrix__c where  ProdGroup__c=:PDgroup And Brand__c=:PS.Brand__c ])
        {
            //Populate SelectList
            if(!catSet.Contains(subgp.SubGroup__c)){
                catSet.add(subgp.SubGroup__c);
                opt.add(new SelectOption(subgp.SubGroup__c, subgp.SubGroup__c));
            }
        }
        
        
        return opt ;
    }
    public PageReference specifyPDGroup()
    {
        displaySelectedText  = PDgroup;
        displaySelectedText  = subPDgroup;
        System.debug(PDgroup);
        subPDgroup = '';
        nPartNumberFoundStatus = -1;
        partNumber = '';
        system.debug(listField);
        return null;
    }
    
    public class FieldWrapper
    {
        public String fieldName {get; set;}
        public String sValue {get; set;}
        public String key {get; set;}
        public List<SelectOption> lstSelectOption{get;set;}
    }
    
    public Map<String, Decimal> calculateQLPrices(List<PSPricingWrapper> pr, Decimal qty) {
        
        Map<String, Decimal> qlPrices = new Map<String, Decimal>();
        
        Decimal totalPrice                  = 0.0;
        Decimal discountablePriceSingle     = 0.0;
        Decimal discountablePrice           = 0.0;
        
        Decimal nonDiscountablePriceSingle  = 0.0;
        Decimal nonDiscountablePrice        = 0.0;
        if(!Test.isRunningTest())
        {                     
            if( pr[0].nOverrideListValue != 9999999 && pr[0].nOverrideListValue != 8888888 && 
               pr[1].nOverrideListValue != 9999999 && pr[1].nOverrideListValue != 8888888 ) {
                   system.debug('$$$$$$$$$$$$$$'+PS.Quantity__c+'-'+pr[0].nOverrideListValue+'-'+pr[1].nOverrideListValue);
                   discountablePriceSingle = pr[0].nOverrideListValue + (pr[1].nOverrideListValue/PS.Quantity__c);
                   
                   discountablePrice = (pr[0].nOverrideListValue * PS.Quantity__c) + pr[1].nOverrideListValue;
                   
                   totalPrice += discountablePrice;
                   
               } else {
                   
                   discountablePriceSingle = pr[0].nOverrideListValue;
                   discountablePrice = pr[0].nOverrideListValue;
                   
                   totalPrice = discountablePriceSingle;
               }
            
            if(pr[2].nOverrideListValue != 9999999 && pr[2].nOverrideListValue != 8888888) {
                
                nonDiscountablePriceSingle = pr[2].nOverrideListValue/PS.Quantity__c;
                
                nonDiscountablePrice = pr[2].nOverrideListValue.setScale(2);
                
                totalPrice += nonDiscountablePrice;
                
            } else {
                
                nonDiscountablePriceSingle = pr[2].nOverrideListValue.setScale(2);
                nonDiscountablePrice = pr[2].nOverrideListValue.setScale(2);
                
                totalPrice = nonDiscountablePrice;
            }
        }     
        
        qlPrices.put('DIS_PRICE_SINGLE', discountablePriceSingle);
        qlPrices.put('NONDIS_PRICE_SINGLE', nonDiscountablePriceSingle);
        qlPrices.put('DIS_PRICE', discountablePrice);
        qlPrices.put('NONDIS_PRICE', nonDiscountablePrice);
        qlPrices.put('TOTAL_PRICE', totalPrice);
        
        
        system.debug('DIS_PRICE_SINGLE 0::'+pr[0].nOverrideListValue);
        system.debug('DIS_PRICE_SINGLE 1::'+pr[1].nOverrideListValue);
        system.debug('DIS_PRICE_SINGLE 2::'+pr[2].nOverrideListValue);
        system.debug('DIS_PRICE_SINGLE::'+discountablePriceSingle);
        system.debug('NONDIS_PRICE_SINGLE::'+nonDiscountablePriceSingle);
        
        return qlPrices;
    }
    
    public pagereference saveProdSpecificAttr(){
        
        ApexPages.getMessages().clear();
        Boolean validQuantity = true;
        List<string> Errormsglst = new List<string>();
        system.debug(PS.Quantity__c);
        if(PS.Quantity__c == null || PS.Quantity__c <= 0)
        {
            validQuantity = false;
            Errormsglst.add('Quantity: Please Enter a Positive Integer');
            
        }
        if(PDgroup == null)
        {
            validQuantity = false;
            Errormsglst.add('Product Group: Please Select a Value');
            
        }
        if(subPDgroup == null)
        {
            validQuantity = false;
            Errormsglst.add('Sub Product Group: Please Select a Value');
            
        }
        
        if(PS.Quote_Description_Engineer_Override__c == false)
        {
            PS.Existing_partnumber__c = PS.Part_Number_Base_Backup__c;
        }
        
        if(validQuantity)
        {
            boolean validAttr = true;
            for(FieldWrapper wobj : listField)
            {
                system.debug('@@Devloper field = '+wobj.fieldName+', wob.sValue = '+wobj.sValue);
                if((wobj.lstSelectOption.size() > 0) && (string.isBlank(wobj.sValue) || wobj.sValue == 'null'))
                {
                    validAttr= false;
                    break;
                }
            }
            if(validAttr)
            {
                system.debug('@Developer saveProdSpecificAttr ' + PS);
                system.debug('saveProdPartNumber'+'saveProdSpecificAttr'+listField);
                String fieldsAPIname = FLMutility.getObjectFields('Part_Selector__c');
                system.debug('@Developer -->fieldsAPIname: ' + fieldsAPIname);
                list<String> lstFieldAPIName = new list<String>();
                if(fieldsAPIname != '')
                {
                    lstFieldAPIName = fieldsAPIname.toLowerCase().split(',');
                }
                
                //@Piyush 20 May 2020
                sProductAttributeData = '';
                list<ProductAttribueData>lstPAD =  new list<ProductAttribueData>();
                system.debug(listField);
                if(!(listField.size() >0)) {
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No data found for selected product group and sub group. Please reset the data combinations'));
                    return null;
                    
                } else {
                    
                    for(FieldWrapper wobj : listField)
                    {
                        if(wobj.sValue == '')
                        {
                            wobj.sValue = wobj.lstSelectOption[0].getvalue();
                        }
                        lstPAD.add(new ProductAttribueData(wobj.key,wobj.sValue));
                        
                        if(wobj.key != '')
                        {
                            String sFieldApi = wobj.key + '__c';
                            System.debug('@Developer --> sFieldApi :' + sFieldApi);
                            if(lstFieldAPIName.contains(sFieldApi.toLowerCase()))
                            {
                                PS.put(sFieldApi, wobj.sValue);
                            }
                        }
                    }
                    sProductAttributeData = JSON.serialize(lstPAD);
                    System.debug('@Developer --> sProductAttributeData :' + sProductAttributeData);
                    PS.Part_Number__c  = oPSAssyPartDefinition.ASSYPARTNO__c;
                    //PS.ASSYPARTNO__c  = PS.Part_Number__c;
                    PS.Part_Number_Base__c = oPSAssyPartDefinition.ASSYPARTNO__c;
                    PS.ASSYPARTEXISTING__c = PS.Part_Number__c;
                    
                    PS.PARTREV__c = oPSAssyPartDefinition.PartRevision__c;
                    PS.Product_Attribute_Data__c = sProductAttributeData;
                    PS.NEWSPCLPARTNOBASE__c = '';
                    partNumber = oPSAssyPartDefinition.ASSYPARTNO__c;
                    system.debug(partNumber+'partNumber');
                    PS.Partnumber_orginal__c = partNumber;
                    PS.Finish_Configuration_Flag__c = true;
                    if(PS.Quote_Description_Engineer_Override__c == true) {
                        
                        PS.ASSYPARTEXISTING__c = '';
                        
                    } else {
                        
                        Result partNumberResult = AssyPartDefinationProcessor.getPartNumberExisting(PS.Part_Number_Base__c,PS,'Partselector');
                        if(partNumberResult.bResult ==  true)
                        {
                            PS.ASSYPARTEXISTING__c = partNumberResult.strRetValue;
                            
                        }
                        else
                        {
                            //PS.ASSYPARTEXISTING__c = '';
                        }
                    }
                    
                    PS.Part_Number_Base_Backup__c = PS.Part_Number_Base__c;
                    PS.Part_Number_Backup__c = PS.Part_Number__c;
                    PS.Existing_partnumber__c = PS.Part_Number__c;
                    
                    System.debug('*** PS = '+PS);
                    system.debug(PS.ASSYPARTNO__c);
                    
                    list<PSPricingWrapper> pr = getPricinglist();
                    
                    Map<String, Decimal> priceCalc = calculateQLPrices(pr, PS.Quantity__c);
                    
                    PS.Price_Total__c               = priceCalc.get('DIS_PRICE');
                    PS.Non_Discountable_Price__c    = priceCalc.get('NONDIS_PRICE');
                    
                    PSOU.currentPS = PS;
                    PSOU.IFSManaged = 'Y';
                    if(PS.Is_managed_in_Salesforce__c == true)
                    {
                        PSOU.IFSManaged = 'N';
                    }
                    if(PS.Quote_Description_Engineer_Override__c == true)
                    {
                        PSOU.PARTNUMBER = PS.Part_Number__c;
                    }
                    else
                    {
                        PSOU.PARTNUMBER = PS.Part_Number_Backup__c;
                    }
                    PSOU.mapPSAttr=new Map<String, string>();
                    PSOU.mapPS_Attribute = new Map<String, String>();
                    PSOU.mapPS_Attribute = PSOU.getMapAttribute();
                    PSOU.getmapPSInterfaceAttr();
                    PSOU.mapPSAttr.put('SERIALTRACKCODE', PSOU.mapPS_Attribute.get('SERIALTRACKCODE'));
                    GetQuoteDescriptionRecords();    
                    update PS;
                    System.debug('***** Updated PS on OA etc etc => PS.OA__c = '+PS.OA__c+', PS.OB__c = '+PS.OB__c+', PS.OW__c = '+PS.OW__c);
                
                    getLeadTimeRecs();
                    system.debug('hhhhhh'+strQuoteStatus);
                    if(!notValidStatusForChng.contains(strQuoteStatus)) {
                        getPSDiaData();
                        //quoteDescriptionList.
                        string strProdOver='';
                        if(String.isNotBlank(PS.OA__c)){
                            strProdOver += PS.OA__c +'\n';
                        }
                        if(String.isNotBlank(PS.OB__c)){
                            strProdOver += PS.OB__c+'\n';
                        }
                        if(String.isNotBlank(PS.OW__c)){
                            strProdOver += PS.OW__c +'\n';
                        }
                        if(String.isNotBlank(PS.PC__c)){
                            strProdOver += PS.PC__c;
                        }
                        string strquoteDes1 = strProdOver;
                        strquoteDes1.replaceAll('\n', '</BR>');
                        //quoteDescriptionList = new List<QuoteDescriptionWrapper>();
                        system.debug('hhhhhh'+PS.Quantity__c);
                        system.debug('quoteLine'+quoteLine.Id);
                        //system.debug('hhhhhh'+PS.Quantity__c);
                        quoteLine.Config_Record_Id__c = PS.id;
                        quoteLine.SBQQ__Quantity__c=PS.Quantity__c;
                        quoteLine.Engineering_Notes__c = PS.Engineering_Notes__c;
                        
                        system.debug('INVOKING...');
                        quoteLine.Non_Discountable_List_Price__c    = priceCalc.get('NONDIS_PRICE_SINGLE');
                        quoteLine.Discountable_List_Price__c        = priceCalc.get('DIS_PRICE_SINGLE');
                        
                        system.debug('INVOKING...'+quoteLine.Discountable_List_Price__c);
                        system.debug('INVOKING...'+quoteLine.Non_Discountable_List_Price__c);
                        
                        quoteLine.Leadtime_Site_10__c = PS.Lead_Time_Site_10__c;
                        quoteLine.Leadtime_Site_20__c = PS.Lead_Time_Site_20__c;
                        quoteLine.Leadtime_Site_30__c = PS.Lead_Time_Site_30__c;
                        quoteLine.Leadtime_Site_40__c = PS.Lead_Time_Site_40__c;
                        quoteLine.Body_Material__c=PS.MCBODY__c; 
                        quoteLine.Product_Group__c = PS.ProductGroup__c; 
                        quoteLine.Sub_Group__c = PS.SubGroup__c; 
                        //  quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('</BR>', '\n');
                        //quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('</BR>', '<BR>');
                        quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('&','&amp').replaceAll('>','&gt').replaceAll('<','&lt').replaceAll('\n', '<BR>'); 
                        if(psDiagram!=null) {
                            quoteLine.DimA__c=psDiagram.DimA_Override__c;
                            quoteLine.DimB__c=psDiagram.DimB_Override__c;
                            quoteLine.DimC__c=psDiagram.DimC_Override__c;
                            quoteLine.DimD__c=psDiagram.DimD_Override__c;
                            quoteLine.DimE__c=psDiagram.DimE_Override__c;
                            quoteLine.DimF__c=psDiagram.DimF_Override__c;
                            
                            quoteLine.DrawingID__c=psDiagram.Drawing_ID_Override__c;
                        }
                        // quoteLine.SBQQ__Description__c=strquoteDes.replaceAll('</BR>', '\n');
                        //upsert quoteLine;
                        List<Cost__c> cstList = new List<Cost__c>();
                        cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(PS.Id)];
                        if(!cstList.isEmpty() && cstList.size() >0 )
                        {
                            delete cstList;
                        }
                        getCosts();
                    }
                    //generatePartNumber();
                    // list<SBQQ__QuoteLine__c> Ql = [select id, isIFSManaged__c from SBQQ__QuoteLine__c where id =: PS.Quote_Line__c];
                    if(isManagedinSalesforce == false && PS.Quote_Description_Engineer_Override__c == True)
                    {
                        quoteLine.isIFSManaged__c = true;
                        
                    }
                    upsert quoteLine;
                    update PS;
                    pageReference reloadpage = new pageReference('/apex/ConfigPartSelector?id='+PS.id);
                    reloadpage.setRedirect(true);
                    system.debug('!!!!URL:'+reloadpage);
                    system.debug(PS.ASSYPARTNO__c);
                    return reloadpage;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select all attributes'));
                return null;
            }
        }
        else
        {
            system.debug('in error msg');
            for(string s: Errormsglst)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,s));
            return null;
        }
    }
    
    public pagereference saveProdPartNumber(){
        System.debug('PartNumber' +partNumber);
        ApexPages.getMessages().clear();
        Boolean validQuantity = true;
        Boolean ValidProductGroup = true;
        Boolean ValidSubGroup    = true;
        string Errormsg ;
        system.debug('Quantity------'+PS.Quantity__c);
        if(PS.ProductGroup__c == null){
            ValidProductGroup = false;
            Errormsg = 'Product Group: Please Select a Value';
        }
        
        if(PS.SubGroup__c == null){
            ValidSubGroup = false;
            Errormsg = 'Sub Group: Please Select a Value';
        }
        
        if(PS.Quote_Description_Engineer_Override__c == false)
        {
            PS.Existing_partnumber__c = PS.Part_Number_Base_Backup__c;
        }
        
        if(PS.Quantity__c == null || PS.Quantity__c <= 0 ){
            validQuantity = false;
            Errormsg = 'Quantity: Please Enter a Positive Integer';
        }else if(!Pattern.matches('^\\d+$', string.valueOf(PS.Quantity__c))){
            validQuantity = false;
            PS.Quantity__c = null;
            Errormsg = 'Quantity :Please enter a Positive integer value ';
        }
        if(validQuantity)
        {
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
            system.debug('partNumber'+partNumber);
            string brandStr = PS.Brand__c;
            string DynamicQueryAssyPartDefinition = DynamicQuery+ ',ProdGroup__c,SubGroup__c,PartRevision__c from PS_AssyPartDefinition__c where ASSYPARTNO__c = :partNumber and Brand__c =:brandStr' ;
            List<PS_AssyPartDefinition__c> ps_assyLst = Database.query(DynamicQueryAssyPartDefinition);
            system.debug('ps_assyLst.Isempty():'+ps_assyLst.Isempty());
            if(!ps_assyLst.Isempty())
            {
                PS.PARTREV__c = ps_assyLst[0].PartRevision__c;
                subPDgroup = ps_assyLst[0].SubGroup__c;
                PDgroup = ps_assyLst[0].ProdGroup__c;
                string DynamicQueryPS_Input_Attr_Matrix = DynamicQuery+ ' from PS_Input_Attr_Matrix__c where ProdGroup__c = :PDgroup and SubGroup__c= :subPDgroup and Brand__c =:brandStr' ;
                psinputLst = Database.query(DynamicQueryPS_Input_Attr_Matrix);
                
                system.debug(ps_assyLst);
                system.debug(psinputLst);
                for(string s2:fieldxlst)
                {
                    if(psinputLst != null && psinputLst.size() > 0)
                    {
                        if(psinputLst[0].get(s2) <> null)
                        {
                            PS.put(psinputLst[0].get(s2)+'__c',ps_assyLst[0].get(s2));
                            lstPAD.add(new ProductAttribueData(string.valueof(psinputLst[0].get(s2)),string.valueof(ps_assyLst[0].get(s2))));
                        }
                    }
                }
                sProductAttributeData = JSON.serialize(lstPAD);
                System.debug('@Developer --> sProductAttributeData :' + sProductAttributeData);
                
                //Nagarjuna 7 June 2020
                if(ps_assyLst.size() > 0)
                {
                    PS.SubGroup__c = ps_assyLst[0].SubGroup__c;
                    PS.ProductGroup__c = ps_assyLst[0].ProdGroup__c;
                }
                PS.Product_Attribute_Data__c = sProductAttributeData;
                oPSAssyPartDefinition.ASSYPARTNO__c = partNumber;
                PS.Partnumber_orginal__c = partNumber;
                
                PS.Part_Number__c  = oPSAssyPartDefinition.ASSYPARTNO__c;
                //PS.ASSYPARTNO__c  = PS.Part_Number__c;
                PS.Part_Number_Base__c = oPSAssyPartDefinition.ASSYPARTNO__c;
                PS.ASSYPARTEXISTING__c = PS.Part_Number__c;
                //PS.PARTREV__c  = oPSAssyPartDefinition.PartRevision__c;
                
                PS.Part_Number_Base_Backup__c = PS.Part_Number_Base__c;
                PS.Part_Number_Backup__c = PS.Part_Number__c;
                PS.Existing_partnumber__c = PS.Part_Number__c;
                
                PS.NEWSPCLPARTNOBASE__c = '';
                PS.Finish_Configuration_Flag__c = true;
                list<PSPricingWrapper> pr = getPricinglist();
                
                Map<String, Decimal> priceCalc = calculateQLPrices(pr, PS.Quantity__c);
                
                PS.Price_Total__c               = priceCalc.get('DIS_PRICE');
                PS.Non_Discountable_Price__c    = priceCalc.get('NONDIS_PRICE');
                
                //list<PSPricingWrapper> pr= getPricinglist();
                PSOU.currentPS = PS;
                PSOU.IFSManaged = 'Y';
                if(PS.Is_managed_in_Salesforce__c == true)
                {
                    PSOU.IFSManaged = 'N';
                }
                if(PS.Quote_Description_Engineer_Override__c == true)
                {
                    PSOU.PARTNUMBER = PS.Part_Number__c;
                }
                else
                {
                    PSOU.PARTNUMBER = PS.Part_Number_Backup__c;
                }
                PSOU.mapPSAttr=new Map<String, string>(); 
                PSOU.mapPS_Attribute = new Map<String, String>();
                PSOU.mapPS_Attribute = PSOU.getMapAttribute();
                PSOU.getmapPSInterfaceAttr();
                PSOU.mapPSAttr.put('SERIALTRACKCODE', PSOU.mapPS_Attribute.get('SERIALTRACKCODE'));
                
                GetQuoteDescriptionRecords();
                getLeadTimeRecs();
                List<Cost__c> cstList = new List<Cost__c>();
                cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(PS.Id)];
                if(!cstList.isEmpty() && cstList.size() >0 )
                {
                    delete cstList;
                }
                getCosts();
                update PS;
                System.debug('***** Updated PS on OA etc etc => PS.OA__c = '+PS.OA__c+', PS.OB__c = '+PS.OB__c+', PS.OW__c = '+PS.OW__c);
                //generatePartNumber();
                system.debug('hhhhhh'+strQuoteStatus);
                if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    getPSDiaData();
                    string strProdOver='';
                    if(String.isNotBlank(PS.OA__c)){
                        strProdOver += PS.OA__c +'\n\n';
                    }
                    if(String.isNotBlank(PS.OB__c)){
                        strProdOver += PS.OB__c+'\n\n';
                    }
                    if(String.isNotBlank(PS.ORP__c)){
                        strProdOver += PS.ORP__c+'\n\n';
                    }                    
                    if(String.isNotBlank(PS.ORV__c)){
                    strProdOver += PS.ORV__c+'\n\n';
                    }
                    if(String.isNotBlank(PS.OW__c)){
                        strProdOver += PS.OW__c+'\n\n';
                    }
                    if(String.isNotBlank(PS.PC__c)){
                        strProdOver += PS.PC__c+'\n\n';
                    }
                   
                    
                    system.debug('ASH PS.OA__c:'+PS.OA__c);
                    system.debug('ASH PS.OB__c:'+PS.OB__c);
                    system.debug('ASH PS.OW__c:'+PS.OW__c);
                    system.debug('ASH PS.PC__c:'+PS.PC__c);
                    system.debug('ASH PS.ORV__c:'+PS.ORV__c);
                    system.debug('ASH PS.ORP__c:'+PS.ORP__c);
                    string strquoteDes1 = strProdOver;
                    // strquoteDes1.replaceAll('\n', '<BR\>');
                    system.debug('ASH TEST:'+strquoteDes1);
                    system.debug('hhhhhh'+PS.Quantity__c);
                    system.debug('quoteLine'+quoteLine.Id);
                    //system.debug('hhhhhh'+PS.Quantity__c);
                    quoteLine.Config_Record_Id__c = PS.id;
                    quoteLine.SBQQ__Quantity__c=PS.Quantity__c;
                    quoteLine.Engineering_Notes__c = PS.Engineering_Notes__c;
                    quoteLine.Is_Special__c = PS.Quote_Description_Engineer_Override__c;
                    
                    quoteLine.Non_Discountable_List_Price__c    = priceCalc.get('NONDIS_PRICE_SINGLE');
                    quoteLine.Discountable_List_Price__c        = priceCalc.get('DIS_PRICE_SINGLE');
                    
                    quoteLine.Leadtime_Site_10__c = PS.Lead_Time_Site_10__c;
                    quoteLine.Leadtime_Site_20__c = PS.Lead_Time_Site_20__c;
                    quoteLine.Leadtime_Site_30__c = PS.Lead_Time_Site_30__c;
                    quoteLine.Leadtime_Site_40__c = PS.Lead_Time_Site_40__c;
                    // if(isManagedinSalesforce == false)
                    //{
                    system.debug('##strquoteDes1' +strProdOver);
                    system.debug('##strquoteDes1' +strquoteDes1);
                    quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('&','&amp').replaceAll('>','&gt').replaceAll('<','&lt').replaceAll('\n', '<br>');
                    //}
                    // else
                    // {
                    //   quoteLine.SBQQ__Description__c = PS.OA__c +'\n' + PS.OB__c +'\n' + PS.OW__c +'\n' + PS.PC__c +'\n' + PS.ORV__c +'\n' + PS.ORP__c;
                    //}
                    if(psDiagram!=null) {
                        quoteLine.DimA__c=psDiagram.DimA_Override__c;
                        quoteLine.DimB__c=psDiagram.DimB_Override__c;
                        quoteLine.DimC__c=psDiagram.DimC_Override__c;
                        quoteLine.DimD__c=psDiagram.DimD_Override__c;
                        quoteLine.DimE__c=psDiagram.DimE_Override__c;
                        quoteLine.DimF__c=psDiagram.DimF_Override__c;
                        quoteLine.DrawingID__c=psDiagram.Drawing_ID_Override__c;
                    }
                    //quoteLine.SBQQ__Description__c=strquoteDes.replaceAll('</BR>', '\n');
                     // list<SBQQ__QuoteLine__c> Ql = [select id, isIFSManaged__c from SBQQ__QuoteLine__c where id =: PS.Quote_Line__c];
                    if(isManagedinSalesforce == false && PS.Quote_Description_Engineer_Override__c == True)
                    {
                        quoteLine.isIFSManaged__c = true;
                        
                    }
                    upsert quoteLine;
                    update PS;
                    System.debug('**** Updated quoteLine = '+quoteLine);
                }
                pageReference reloadpage = new pageReference('/apex/ConfigPartSelector?id='+ps.id);
                reloadpage.setRedirect(true);
                system.debug('!!!!URL:'+reloadpage);
                system.debug(PS.ASSYPARTNO__c);
                return reloadpage;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Part Number not found for the selected Brand '));
                isValidPartNumber = false;
                return null;
            }
        }else{
            system.debug('in error msg');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Errormsg));
            return null;
        }
        
    }
    
    public void generatePartNumber()
    {
        Result partNumberResult = AssyPartDefinationProcessor.generatePartNumber(PS);
        if(partNumberResult.bResult ==  true) {
            
            PS.ASSYPARTNO__c = partNumberResult.strRetValue;
        }
        update PS;
        system.debug(PS);
        system.debug(partNumberResult.strRetValue);
    }
    
    public pageReference onSpecialPartNoChange()
    {
        if(String.isNotBlank(PS.NEWSPCLPARTNOBASE__c) && PS.NEWSPCLPARTNOBASE__c != 'None')
        {
            PS.Part_Number_Base__c = '';
        }
        else
        {
            PS.Part_Number_Base__c = oPSAssyPartDefinition.ASSYPARTNO__c;
            
            if(PS.Part_Number_Base__c == null) {
                
                PS.Part_Number_Base__c = PS.Part_Number_Base_Backup__c;
            }
        }
        return null;
    }
    
    public PageReference savePartNumber()
    {
        //ConRV.PartNumberBase_Checkbox__c=true;
        try
        {
            system.debug('PS.Quote_Description_Engineer_Override__c::'+PS.Quote_Description_Engineer_Override__c);
            system.debug('PS.NEWSPCLPARTNOBASE__c::'+PS.NEWSPCLPARTNOBASE__c);
            
            if(PS.Quote_Description_Engineer_Override__c == true && PS.NEWSPCLPARTNOBASE__c != null) {
                
                PS.Part_Number_Base__c = null;
                
            } 
            update PS;
            
            //generatePartNumber();
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
        }
        return null;
    }
    
    
    // added by piyush soni @5/11/2020
    private map<string,list<string>> mapGrpSubGrpWiseAttributes = new map<String,list<String>>();
    private map<string,string> mapGrpSubGrpWiseField = new map<String,String>();
    private map<string,string> mapFieldWiseLabel = new map<string,string>();
    private map<string,string> mapValueWiseLabel = new map<string,string>();
    
    public void fetchfieldsList()
    {
        listField = new List<FieldWrapper>();
        mapFieldWiseLabel = new map<string,string>();
        mapValueWiseLabel = new map<string,string>();
        mapGrpSubGrpWiseAttributes = new map<String,list<String>>();
        mapGrpSubGrpWiseField = new map<String,String>();
        map<string,list<SelectOption>> mapofvalues= new map<string,list<SelectOption>>();
        System.debug('**** PDgroup = '+PDgroup+', subPDgroup = '+subPDgroup);
        
        Map<String, Map<String, String>> mapOfValTmp = new Map<String, Map<String, String>>();
        Map<String, String> tmpSelectOptions;
        SelectOption so;
        
        List<PS_Input_Field_Labels__c> inputLabelsList = [SELECT id,Attribute_Text_Description__c,Attribute_Code__c,ProdGroup__c,SubGroup__c
                                                          FROM PS_Input_Field_Labels__c
                                                          WHERE ProdGroup__c = :PDgroup
                                                          AND SubGroup__c = :subPDgroup
                                                          AND Attribute_Code__c != ''];
        
        system.debug('$$$$$$$$'+inputLabelsList.size());
        for(PS_Input_Field_Labels__c inp :inputLabelsList)
        {
            //system.debug('inp----> ' + inp);
            String keyGrpSGrp = inp.ProdGroup__c + '-' + inp.SubGroup__c;
            if(!mapGrpSubGrpWiseAttributes.containsKey(keyGrpSGrp))
            {
                mapGrpSubGrpWiseAttributes.put(keyGrpSGrp, new List<String>());
            }
            mapGrpSubGrpWiseAttributes.get(keyGrpSGrp).add(inp.Attribute_Code__c);
            mapFieldWiseLabel.put(inp.Attribute_Code__c,inp.Attribute_Text_Description__c);
        }
        
        
        /*System.debug('**** mapGrpSubGrpWiseAttributes, Number of records = '+mapGrpSubGrpWiseAttributes.size());
for(String key : mapGrpSubGrpWiseAttributes.keySet())
{
System.debug('*** Key = '+key+', value = '+mapGrpSubGrpWiseAttributes.get(key));
}
System.debug('**** mapFieldWiseLabel');
for(String key : mapFieldWiseLabel.keySet())
{
System.debug('*** Key = '+key+', value = '+mapFieldWiseLabel.get(key));
}*/
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,Display_Order__c,ProdGroup__c,
                                                            SubGroup__c,Value__c
                                                            from PS_Input_Attr_Value_Desc__c
                                                            where ProdGroup__c=:PDgroup
                                                            and SubGroup__c=:subPDgroup
                                                            and Attribute__c!='' order by Display_Order__c ASC]; 
        
        
        for(PS_Input_Attr_Value_Desc__c iavd :inputvaluesList)
        {
            String sValDescKey = iavd.ProdGroup__c + '-' + iavd.SubGroup__c + '-' + iavd.Attribute__c + '-' + iavd.Value__c ;
            //System.debug('@Developer --> sValDescKey :' + sValDescKey);
            mapValueWiseLabel.put(sValDescKey, iavd.Text_Description_of_Attribute_Value__c);
            system.debug(sValDescKey+'---------'+iavd.Text_Description_of_Attribute_Value__c);
        }
        
        /*System.debug('**** mapValueWiseLabel, Number of records = '+mapValueWiseLabel.size());
for(String key : mapValueWiseLabel.keySet())
{
System.debug('*** Key = '+key+', value = '+mapValueWiseLabel.get(key));
}*/
        system.debug('$$$$$$Brand'+PS.Brand__c);
        List<PS_Input_Attr_Matrix__c > inputAttrMatrix =[SELECT id,ProdGroup__c,SubGroup__c,Brand__c,
                                                         Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,
                                                         Field9__c,Field10__c,Field11__c,Field12__c,Field13__c,Field14__c,Field15__c,Field16__c,
                                                         Field17__c,Field18__c,Field19__c,Field20__c,Field21__c,Field22__c,Field23__c
                                                         FROM PS_Input_Attr_Matrix__c
                                                         WHERE ProdGroup__c = :PDgroup
                                                         AND SubGroup__c = :subPDgroup
                                                         AND Brand__c = :PS.Brand__c];
        
        //system.debug('$$$$$$$$'+inputAttrMatrix[0].Brand__c);
        system.debug('$$$$$$$$'+inputAttrMatrix);
        for(PS_Input_Attr_Matrix__c iam :inputAttrMatrix)
        {
            for(integer i=3 ;i <= 23; i++)
            {
                String fldName = 'Field'+ i + '__c';
                String sVal = string.valueOf(iam.get(fldName));
                System.debug('@Developer --> sVal :' + sVal + '  ==>fldName ' + fldName);
                if(string.isNotBlank(sVal)){//Added Nagarjuna
                    String keyGrpSGrpFld = iam.ProdGroup__c + '-' + iam.SubGroup__c+ '-' + sVal;
                    mapGrpSubGrpWiseField.put(keyGrpSGrpFld,fldName);//PTC -> field3
                }
            }
        }
        /*System.debug('**** mapGrpSubGrpWiseField, Number of records = '+mapGrpSubGrpWiseField.size());
for(String key : mapGrpSubGrpWiseField.keySet())
{
System.debug('*** Key = '+key+', value = '+mapGrpSubGrpWiseField.get(key));
}*/
        List<PS_AssyPartDefinition__c > partselectorList = [SELECT id,ProdGroup__c,SubGroup__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,
                                                            Field9__c,Field10__c,Field11__c,Field12__c,Field13__c,Field14__c,Field15__c,Field16__c,
                                                            Field17__c,Field18__c,Field19__c,Field20__c,Field21__c,Field22__c,Notes__c
                                                            FROM PS_AssyPartDefinition__c
                                                            WHERE ProdGroup__c = :PDgroup
                                                            AND SubGroup__c = :subPDgroup
                                                            AND Brand__c = :PS.Brand__c];
        system.debug(PDgroup);
        system.debug(subPDgroup);
        system.debug(PS.Brand__c);
        system.debug(partselectorList);
        
        for(PS_AssyPartDefinition__c papd :partselectorList)
        {
            system.debug(papd);
            
            String keyGrpSGrp = papd.ProdGroup__c + '-' + papd.SubGroup__c;
            system.debug('@Developer --> keyGrpSGrp :'+keyGrpSGrp);
            //System.debug('@Developer --> partSelector list :' +papd);
            list<String> lstAttrCode = new list<String>();
            if(mapGrpSubGrpWiseAttributes.containsKey(keyGrpSGrp))
            {
                lstAttrCode = mapGrpSubGrpWiseAttributes.get(keyGrpSGrp);
            }
            
            for(String sAttrCode : lstAttrCode)
            {
                String keyGrpSGrpFld = papd.ProdGroup__c+ '-'+papd.SubGroup__c + '-'+sAttrCode ;
                System.debug('@Developer --> keyGrpSGrpFld :' + keyGrpSGrpFld);
                
                list<SelectOption> tempValue ;
                if(mapofvalues.containsKey(keyGrpSGrpFld))
                {
                    tempValue = mapofvalues.get(keyGrpSGrpFld);
                    
                    tmpSelectOptions = mapOfValTmp.get(keyGrpSGrpFld);
                }
                else
                {
                    tempValue = new list<SelectOption>();
                    
                    tmpSelectOptions = new Map<String, String>();
                }
                
                if(mapGrpSubGrpWiseField.containsKey(keyGrpSGrpFld))
                {
                    String fldName = mapGrpSubGrpWiseField.get(keyGrpSGrpFld);
                    String sVal = string.valueOf(papd.get(fldName));
                    String sValDesc = sVal;
                    String sValDescKey =  keyGrpSGrpFld + '-'+sVal ;
                    System.debug('*** sValDesc = '+sValDesc);
                    if(mapValueWiseLabel.containsKey(sValDescKey))
                    {
                        sValDesc = mapValueWiseLabel.get(sValDescKey);
                        //System.debug('*** changed sValDesc = '+sValDesc);
                    }
                    if(sVal!= null && sValDesc!=null)
                    {
                        tmpSelectOptions.put(sVal, sValDesc);
                        so = new SelectOption(sVal,sValDesc);
                        system.debug(so);
                        if(!tempValue.contains(so))
                        {
                            tempValue.add(so);
                        }
                    }
                    
                    mapofvalues.put(keyGrpSGrpFld, tempValue);
                    mapOfValTmp.put(keyGrpSGrpFld, tmpSelectOptions);
                }
            }
        }
        system.debug('mapofvalues-->'+mapofvalues);
        
        //apply the sorting - mapOfValTmp
        mapofvalues = sortSelectOptions(mapOfValTmp);
        
        /*System.debug('**** mapofvalues, Number of records = '+mapofvalues.size());
for(String key : mapofvalues.keySet())
{
System.debug('*** Key = '+key+', value = '+mapofvalues.get(key));
}*/
        String keyGrpSGrp = PDgroup + '-' + subPDgroup;
        list<String> lstAttrCode = new list<String>();
        if(mapGrpSubGrpWiseAttributes.containsKey(keyGrpSGrp))
        {
            lstAttrCode = mapGrpSubGrpWiseAttributes.get(keyGrpSGrp);
        }
        /*System.debug('@@@@ lstAttrCode');
for(String attrLabel : lstAttrCode)
{
System.debug('@@@@ currenOrderKey  = '+attrLabel);

}
System.debug('@@@@ mapGrpSubGrpWiseField');
for(String attrLabel : mapGrpSubGrpWiseField.keySet())
{
System.debug('@@@@ fieldToOrderMapKey  = '+attrLabel+', fieldToOrderMapValue = '+mapGrpSubGrpWiseField.get(attrLabel));

}
System.debug('@@@@ mapFieldWiseLabel');
for(String attrLabel : mapFieldWiseLabel.keySet())
{
System.debug('@@@@ fieldInOrderKey  = '+attrLabel+', fieldInOrderValue = '+mapFieldWiseLabel.get(attrLabel));
}*/
        for(String attrLabel : mapGrpSubGrpWiseField.keySet())
        {
            String attributeKey;
            if(attrLabel.contains('-'))
            {
                if(attrLabel.substringAfterLast('-') != 'null')
                {
                    system.debug(attrLabel);
                    attributeKey = attrLabel.substringAfterLast('-');
                    String sAttrDesc = '';
                    if(mapFieldWiseLabel.containsKey(attributeKey))
                    {
                        sAttrDesc = mapFieldWiseLabel.get(attributeKey);
                    }
                    if(mapofvalues.containsKey(attrLabel))
                    {
                        FieldWrapper wobj = new  FieldWrapper();
                        wobj.fieldName = sAttrDesc;
                        wobj.sValue = '';
                        list<SelectOption> lstSelectOpts = mapofvalues.get(attrLabel);
                        if(lstSelectOpts.size() > 1 )
                        {
                            lstSelectOpts.add(0 , new SelectOption('','--- Select ---'));
                        }
                        else if(lstSelectOpts.size() == 1)
                        {
                            wobj.sValue = lstSelectOpts[0].getValue();
                        }
                        wobj.lstSelectOption = lstSelectOpts;
                        if(wobj.lstSelectOption.size() > 0){
                            // wobj.lstSelectOption = sortList(wobj.lstSelectOption);
                        }
                        wobj.key = attributeKey;
                        listField.add(wobj);
                        
                    }
                }
            }
        }
        
        System.debug('@@listField'+listField);
        for(FieldWrapper w : listField)
        {
            if(w.fieldName == 'Maximum Pressure:'){
                Map<Decimal,string> dstr = new Map<Decimal,string>();
                for(selectOption s : w.lstSelectOption){
                    if(!string.Isempty(s.getValue()))
                        dstr.put(decimal.valueOf(s.getValue()),(string)s.getLabel());
                }
                list<Decimal> dlst= new List<decimal>(dstr.keyset());
                dlst.sort();
                list<selectOption> seloplst = new List<selectOption>();
                seloplst.add( new selectOption('','--- Select ---'));
                for(decimal d : dlst){
                    selectOption sp = new selectOption(string.valueof(d),dstr.get(d));
                    seloplst.add(sp);
                }
                w.lstSelectOption = seloplst;
            }
            if(w.fieldName == 'Pressure Scale:' && w.lstSelectOption.size()>1){
                list<selectOption> seloplst = new List<selectOption>();
                seloplst.add( new selectOption('','--- Select ---'));
                for(PS_Input_Attr_Value_Desc__c  ps : [select Display_Order__c,Text_Description_of_Attribute_Value__c,Value__c From PS_Input_Attr_Value_Desc__c where ProdGroup__c = :PDgroup and SubGroup__c = :subPDgroup and Attribute__c= 'Type' order by Display_Order__c]){
                    seloplst.add( new selectOption(ps.Value__c,ps.Text_Description_of_Attribute_Value__c));
                }
                w.lstSelectOption = seloplst;
            }
        }
        /*for(String sAttrCode : lstAttrCode)
{
String sAttrDesc = '';
if(mapFieldWiseLabel.containsKey(sAttrCode))
{
sAttrDesc = mapFieldWiseLabel.get(sAttrCode);
}
String keyGrpSGrpFld = keyGrpSGrp + '-'+sAttrCode ;
System.debug('*** keyGrpSGrpFld = '+keyGrpSGrpFld);
if(mapofvalues.containsKey(keyGrpSGrpFld))
{
FieldWrapper wobj = new  FieldWrapper();
wobj.fieldName = sAttrDesc;
list<SelectOption> lstSelectOpts = mapofvalues.get(keyGrpSGrpFld);
if(lstSelectOpts.size() > 1 )
{
lstSelectOpts.add(0 , new SelectOption('','--- Select ---'));
}
wobj.lstSelectOption = lstSelectOpts;
wobj.sValue = '';
wobj.key = sAttrCode;
listField.add(wobj);
}
}*/
        system.debug('**** list field records = '+listField);
        //  for(FieldWrapper w : listField)
        //  {
        //      //w.lstSelectOption.sort();
        //  }
        
    }
    
    
    
    /*public void fetchfieldsList()
{
listField = new List<FieldWrapper>();
map<string,string> mapFieldWiseLabelunordered = new map<string,string>();
mapFieldWiseLabel = new map<string,string>();
Map<string,list<string>> optval = new Map<string,list<string>>();
List<PS_Input_Attr_Matrix__c > inputAttrMatrix =[SELECT id,ProdGroup__c,SubGroup__c,
Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,
Field9__c,Field10__c,Field11__c,Field12__c,Field13__c,Field14__c,Field15__c,Field16__c,
Field17__c,Field18__c,Field19__c,Field20__c,Field21__c,Field22__c,Field23__c
FROM PS_Input_Attr_Matrix__c
WHERE ProdGroup__c = :PDgroup
AND SubGroup__c = :subPDgroup
AND Brand__c = :PS.Brand__c];
List<PS_Input_Field_Labels__c> inputLabelsList = [SELECT id,Attribute_Text_Description__c,Attribute_Code__c,ProdGroup__c,SubGroup__c
FROM PS_Input_Field_Labels__c
WHERE ProdGroup__c = :PDgroup
AND SubGroup__c = :subPDgroup
AND Attribute_Code__c != '' order by Display_Priority__c];   

for(PS_Input_Field_Labels__c inp :inputLabelsList)
{
mapFieldWiseLabelunordered.put(inp.Attribute_Code__c,inp.Attribute_Text_Description__c);
}
if(!(inputAttrMatrix.isempty() || inputAttrMatrix==null)){
for(Integer i=3 ; i< 24;i++){
system.debug('Field'+string.valueof(i)+'__c');
if(!string.isEmpty(string.valueof(inputAttrMatrix[0].get('Field'+string.valueof(i)+'__c')))){
mapFieldWiseLabel.put(string.valueof(inputAttrMatrix[0].get('Field'+string.valueof(i)+'__c')),mapFieldWiseLabelunordered.get(string.valueof(inputAttrMatrix[0].get('Field'+string.valueof(i)+'__c'))));
}
}
}
List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,Display_Order__c,ProdGroup__c,
SubGroup__c,Value__c
from PS_Input_Attr_Value_Desc__c
where ProdGroup__c=:PDgroup
and SubGroup__c=:subPDgroup
and Attribute__c!='' order by Display_Order__c]; 


for(PS_Input_Attr_Value_Desc__c iavd :inputvaluesList)
{
if(!optval.keyset().contains(iavd.Attribute__c))
optval.put(iavd.Attribute__c, new List<string>());
optval.get(iavd.Attribute__c).add(iavd.Value__c+'--'+iavd.Text_Description_of_Attribute_Value__c);
}
for(string s : mapFieldWiseLabel.keyset()){
FieldWrapper wobj = new  FieldWrapper();
wobj.fieldName = mapFieldWiseLabel.get(s);
wobj.key = s;
wobj.sValue = '';
list<SelectOption> lstSelectOpts = new list<SelectOption>();
for(string s1:optval.get(s)){
SelectOption option = new SelectOption(s1.split('--')[0], s1.split('--')[1]);
lstSelectOpts.add(option);
}
if(lstSelectOpts.size() > 1 )
lstSelectOpts.add(0 , new SelectOption('','--- Select ---'));
if(lstSelectOpts.size() == 1)
wobj.sValue = lstSelectOpts[0].getValue();
wobj.lstSelectOption = lstSelectOpts;
listField.add(wobj);
}               
System.debug('@@listField'+listField);
for(FieldWrapper w : listField)
{
system.debug(w);
}

}*/
    
    
    
    //PS Pricing outputs
    public list<PSPricingWrapper> getPricinglist(){
        TotalPSPrice = 0.0;
        TotalPSPriceOverride = 0.0;  
        
        PSPricingList = new list<PS_Price__c >();
        PSPricingWrapperList = new list<PSPricingWrapper>();
        PSPricingWrapper pspw;
        
        pspw = new PSPricingWrapper();
        pspw.sType = 'Price List Each';
        PSPricingWrapperList.add(pspw);
        
        pspw = new PSPricingWrapper();
        pspw.sType = 'Discountable Lot Charge';
        PSPricingWrapperList.add(pspw);
        
        pspw = new PSPricingWrapper();
        pspw.sType = 'Non-Discountable Lot Charge';
        PSPricingWrapperList.add(pspw);
        
        //string sASSYPARTNO = oPSAssyPartDefinition.ASSYPARTNO__c;
        String sASSYPARTNO  = PS.Part_Number_Base_Backup__c; //added by Ashim
        System.debug('@Developer --> sASSYPARTNO :' + sASSYPARTNO+'-'+PS.Part_Number__c);
        List<PS_Output__c> psoulst = [Select Id,Disountable_Lot_Charge_Override__c, Non_Disountable_Lot_Charge_Override__c, Price_Override__c, Price_Total__c,Part_Selector__c from PS_Output__c where Part_Selector__c = :PS.ID];
        if(!string.Isempty(PS.Part_Number__c)){
            PSPricingList = [Select Id,ASSYPARTNO__c,Price__c,Discountable_Lot_Charge_Override__c,Non_Discountable_Lot_Charge_Override__c,Price_Override__c,Discountable_Lot_Charge__c,Non_Discountable_Lot_Charge__c
                             ,QuantityLL__c,QuantityUL__c
                             From PS_Price__c
                             WHERE ASSYPARTNO__c =:sASSYPARTNO
                             And QuantityLL__c <= :PS.Quantity__c
                             And QuantityUL__c >= :PS.Quantity__c
                             LIMIT 1];
            
            if(PSPricingList == null || PSPricingList.isEmpty()){
                PSPricingWrapperList[0].nListValue = 8888888;
                PSPricingWrapperList[1].nListValue = 8888888;
                PSPricingWrapperList[2].nListValue = 8888888;
                TotalPSPrice = 8888888;
            }else{
                for(PS_Price__c psp : PSPricingList){
                    PSPricingWrapperList[0].nListValue = psp.Price__c.setscale(2);
                    PSPricingWrapperList[1].nListValue = psp.Discountable_Lot_Charge__c == null ? 0 : psp.Discountable_Lot_Charge__c.setscale(2);
                    PSPricingWrapperList[2].nListValue = psp.Non_Discountable_Lot_Charge__c == null ? 0 : psp.Non_Discountable_Lot_Charge__c.setscale(2);
                }
                TotalPSPrice =  PSPricingWrapperList[0].nListValue*PS.Quantity__c +PSPricingWrapperList[1].nListValue+PSPricingWrapperList[2].nListValue;
                if(PSPricingWrapperList[0].nListValue == 9999999 ||PSPricingWrapperList[1].nListValue == 9999999 ||PSPricingWrapperList[2].nListValue == 9999999 )
                    TotalPSPrice = 9999999;
                /*if(PSPricingWrapperList[0].nListValue == 8888888 ||PSPricingWrapperList[1].nListValue == 8888888 ||PSPricingWrapperList[2].nListValue == 8888888 )
TotalPSPrice = 8888888;*/
            }
            if(!PS.Price_Engineer_Override__c){
                PSPricingWrapperList[0].nOverrideListValue = PSPricingWrapperList[0].nListValue;
                PSPricingWrapperList[1].nOverrideListValue = PSPricingWrapperList[1].nListValue;
                PSPricingWrapperList[2].nOverrideListValue = PSPricingWrapperList[2].nListValue;
                TotalPSPriceOverride = TotalPSPrice;
            }else {
                if(psoulst == null || psoulst.isEmpty()){
                    PSPricingWrapperList[0].nOverrideListValue = PSPricingWrapperList[0].nListValue;
                    PSPricingWrapperList[1].nOverrideListValue = PSPricingWrapperList[1].nListValue;
                    PSPricingWrapperList[2].nOverrideListValue = PSPricingWrapperList[2].nListValue;
                    TotalPSPriceOverride = TotalPSPrice;
                }else{
                    
                    PSPricingWrapperList[0].nOverrideListValue = psoulst[0].Price_Override__c == null ? PSPricingWrapperList[0].nListValue : psoulst[0].Price_Override__c.setscale(2);
                    PSPricingWrapperList[1].nOverrideListValue = psoulst[0].Disountable_Lot_Charge_Override__c == null ? PSPricingWrapperList[1].nListValue : psoulst[0].Disountable_Lot_Charge_Override__c.setscale(2);
                    PSPricingWrapperList[2].nOverrideListValue = psoulst[0].Non_Disountable_Lot_Charge_Override__c == null ? PSPricingWrapperList[2].nListValue : psoulst[0].Non_Disountable_Lot_Charge_Override__c.setscale(2);                
                    TotalPSPriceOverride = PSPricingWrapperList[0].nOverrideListValue*PS.Quantity__c +PSPricingWrapperList[1].nOverrideListValue+PSPricingWrapperList[2].nOverrideListValue;
                    if(PSPricingWrapperList[0].nOverrideListValue == 9999999 ||PSPricingWrapperList[1].nOverrideListValue == 9999999 ||PSPricingWrapperList[2].nOverrideListValue == 9999999 )              
                        TotalPSPriceOverride = 9999999;
                    
                }
                
                
            }
            
        }
        
        System.debug('PSPricingWrapperList[0]'+PSPricingWrapperList[0]);
        System.debug('PSPricingWrapperList[1]'+PSPricingWrapperList[1]);
        System.debug('PSPricingWrapperList[2]'+PSPricingWrapperList[2]);
        if(PSPricingWrapperList[0].nOverrideListValue == 8888888 ||PSPricingWrapperList[1].nOverrideListValue == 8888888 ||PSPricingWrapperList[2].nOverrideListValue == 8888888 ) {            
            TotalPSPriceOverride = 8888888;
        }   
        
        
        //return PSPricingList;
        return PSPricingWrapperList;
    }
    
    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultPricing(){
        if(!PS.Price_Engineer_Override__c){
            List<PS_Output__c> psoulst = [Select Id,Disountable_Lot_Charge_Override__c, Non_Disountable_Lot_Charge_Override__c, Price_Override__c, Price_Total__c,Part_Selector__c from PS_Output__c where Part_Selector__c = :PS.ID];
            //if(!psoulst.isEmpty())
            //delete psoulst;
            //}
            // System.debug('@Developer --> ApplyDefaultPricing :');
            
            // System.debug('@Developer --> PSPricingList :' + PSPricingList);
            // System.debug('@Developer --> PS.Price_Engineer_Override__c :' + PS.Price_Engineer_Override__c);
            
            // if(PS.Price_Engineer_Override__c == false )
            // {
            //     TotalPSPrice = 0.0;
            //     TotalPSPriceOverride = 0.0;
            //     for(PS_Price__c  psp : PSPricingList){
            //         psp.Price_Override__c = psp.Price__c;
            //         psp.Discountable_Lot_Charge_Override__c = psp.Discountable_Lot_Charge__c;
            //         psp.Non_Discountable_Lot_Charge_Override__c = psp.Non_Discountable_Lot_Charge__c;
            
            //         if(PS.Quantity__c != null && PS.Quantity__c != 0){
            //             TotalPSPrice = psp.Price__c * PS.Quantity__c;
            //             TotalPSPrice += psp.Discountable_Lot_Charge__c;
            //             TotalPSPrice += psp.Non_Discountable_Lot_Charge__c;
            
            //             TotalPSPriceOverride = TotalPSPrice;
            //         }
            
            //         PSPricingWrapperList.clear();
            
            // PSPricingWrapper pspw;
            // pspw = new PSPricingWrapper();
            // pspw.nOverrideListValue = psp.Price__c;
            // PSPricingWrapperList.add(pspw);
            
            //  pspw = new PSPricingWrapper();
            //  pspw.nOverrideListValue = psp.Discountable_Lot_Charge__c;
            //   PSPricingWrapperList.add(pspw);
            
            //  pspw = new PSPricingWrapper();
            // pspw.nOverrideListValue = psp.Non_Discountable_Lot_Charge__c;
            //   PSPricingWrapperList.add(pspw);
        }
        
        //update PSPricingList;
        // }
        return null;
    }
    
    //* @ Save Price Override on click on save
    Public Void SavePriceOverride()
    {
        PS_Output__c psoutput;
        List<PS_Output__c> psoulst = [Select Id,Disountable_Lot_Charge_Override__c, Non_Disountable_Lot_Charge_Override__c, Price_Override__c, Price_Total__c,Part_Selector__c from PS_Output__c where Part_Selector__c = :PS.ID];
        if(psoulst == null || psoulst.isEmpty()){
            psoutput = new PS_Output__c();
            psoutput.Part_Selector__c = PS.ID;
        }else{
            psoutput = psoulst[0];
        }
        
        //calculate the price
        Map<String, Decimal> priceCalc = calculateQLPrices(PSPricingWrapperList, PS.Quantity__c);
        
        TotalPSPriceOverride = priceCalc.get('TOTAL_PRICE');
        
        psoutput.Price_Override__c                      =  PSPricingWrapperList[0].nOverrideListValue.setScale(2);
        psoutput.Disountable_Lot_Charge_Override__c     =  PSPricingWrapperList[1].nOverrideListValue.setScale(2);
        psoutput.Non_Disountable_Lot_Charge_Override__c =  PSPricingWrapperList[2].nOverrideListValue.setScale(2);
        psoutput.Price_Total__c                         = TotalPSPriceOverride;
        System.debug('@@TotalPSPriceOverride' +TotalPSPriceOverride);
        /*
Discountable List Price = Price List Each + (Discountable Lot Charge / Quantity)
Non Discountable List Price = (Non-Discountable Lot Charge / Quantity)
*/
        /*if(PS.Price_Engineer_Override__c){
quoteLine.Discountable_List_Price__c = TotalPSPriceOverride + (psoutput.Disountable_Lot_Charge_Override__c/PS.Quantity__c);
quoteLine.Non_Discountable_List_Price__c = psoutput.Non_Disountable_Lot_Charge_Override__c/PS.Quantity__c ;
}else{
quoteLine.Discountable_List_Price__c = TotalPSPrice + (PSPricingWrapperList[1].nListValue.setScale(0)/PS.Quantity__c);
quoteLine.Non_Discountable_List_Price__c = PSPricingWrapperList[2].nListValue.setScale(0)/PS.Quantity__c ;        
}*/
        
        //upsert quoteLine;
        
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            
            quoteLine.Non_Discountable_List_Price__c    = priceCalc.get('NONDIS_PRICE_SINGLE');
            quoteLine.Discountable_List_Price__c        = priceCalc.get('DIS_PRICE_SINGLE');        
        }
        
        upsert quoteLine;
        upsert psoutput;
        update PS; 
        /*system.debug('@@PSPricingList' + PSPricingList);
system.debug('@@PSPricingList' + PSPricingWrapperList);
if((PSPricingList == null|| PSPricingList.size() == 0 )&&((PSPricingWrapperList[0].nOverrideListValue !=8888888 ) ||
(PSPricingWrapperList[1].nOverrideListValue !=8888888 ) ||
(PSPricingWrapperList[2].nOverrideListValue !=8888888 ))){
system.debug('inside logic');
PSPricingList = new List<PS_Price__c>();
PS_Price__c price = new PS_Price__c();
price.ASSYPARTNO__c = oPSAssyPartDefinition.ASSYPARTNO__c;
price.Price__c = 8888888;
price.Discountable_Lot_Charge__c = 8888888;
price.Non_Discountable_Lot_Charge__c = 8888888;
price.Price_Override__c = PSPricingWrapperList[0].nOverrideListValue;
price.Discountable_Lot_Charge_Override__c = PSPricingWrapperList[1].nOverrideListValue;
price.Non_Discountable_Lot_Charge_Override__c = PSPricingWrapperList[2].nOverrideListValue;
price.QuantityLL__c = 1;
price.QuantityUL__c = 9999;
insert price;
PSPricingList.add(price);
}*/
        /*
if(PSPricingList != null && PSPricingList.size() > 0 )
{
PS_Output__c psOutputInstance = getPricePSOutputInstance();
TotalPSPrice = 0.0;
TotalPSPriceOverride = 0.0;
system.debug(PSPricingWrapperList);
for(PS_Price__c  psp : PSPricingList)
{
psp.Price_Override__c = PSPricingWrapperList[0].nOverrideListValue;
psp.Discountable_Lot_Charge_Override__c = PSPricingWrapperList[1].nOverrideListValue;
psp.Non_Discountable_Lot_Charge_Override__c = PSPricingWrapperList[2].nOverrideListValue;

psOutputInstance.Price_Override__c = psp.Price_Override__c;
psOutputInstance.Disountable_Lot_Charge_Override__c = psp.Discountable_Lot_Charge_Override__c;
psOutputInstance.Non_Disountable_Lot_Charge_Override__c = psp.Non_Discountable_Lot_Charge_Override__c;

if(PS.Quantity__c != null && PS.Quantity__c != 0){
TotalPSPrice = psp.Price__c * PS.Quantity__c;
TotalPSPrice += psp.Discountable_Lot_Charge__c;
TotalPSPrice += psp.Non_Discountable_Lot_Charge__c;
system.debug(psp.Price_Override__c);
if(!(psp.Price_Override__c == 9999999 || psp.Price__c== 9999999)){
TotalPSPriceOverride = psp.Price_Override__c * PS.Quantity__c;
TotalPSPriceOverride += psp.Discountable_Lot_Charge_Override__c;
TotalPSPriceOverride += psp.Non_Discountable_Lot_Charge_Override__c;
}else{
TotalPSPriceOverride = 9999999;
}

if(!(psp.Price_Override__c == 8888888)){
TotalPSPriceOverride = psp.Price_Override__c * PS.Quantity__c;
TotalPSPriceOverride += psp.Discountable_Lot_Charge_Override__c;
TotalPSPriceOverride += psp.Non_Discountable_Lot_Charge_Override__c;
}else{
TotalPSPriceOverride = 8888888;
}
}

psOutputInstance.Price_Total__c = TotalPSPriceOverride;
}
if(!notValidStatusForChng.contains(strQuoteStatus)) {
// quoteLine.Config_Record_Id__c = conProd.id;
// quoteLine.SBQQ__Quantity__c=conProd.Quantity__c;
// quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
quoteLine.Non_Discountable_List_Price__c =psOutputInstance.Non_Disountable_Lot_Charge_Override__c  ;
quoteLine.Discountable_List_Price__c = psOutputInstance.Price_Total__c;
// quoteLine.Leadtime_Site_10__c = rdOutput.Total_Lead_Time_GP_ORD__c;
// quoteLine.Leadtime_Site_20__c = rdOutput.Total_Lead_Time_GCI_ORD__c;
// quoteLine.Leadtime_Site_30__c = rdOutput.Total_Lead_Time_CDC_ORD__c;
// quoteLine.Leadtime_Site_40__c = rdOutput.Total_Lead_Time_40_ORD__c;
upsert quoteLine;

}
system.debug('@@@@@@@@@@');
upsert psOutputInstance;
update PSPricingList;
update PS;
}
*/
        //return null;
    }
    
    public static PS_Output__c getPSOutputRecord(String psId)
    {
        List<PS_Output__c> psOutputList = new List<PS_Output__c>();
        String fieldsAPIname = FLMutility.getObjectFields('PS_Output__c');
        
        String soql = 'SELECT ' + fieldsAPIname +' FROM PS_Output__c ';
        soql += ' WHERE Part_Selector__c =\''+String.escapeSingleQuotes(psId)+'\' ';
        
        System.debug('@Developer --> soql :' + soql);
        System.debug('@Developer --> soql :' + psId);
        psOutputList = Database.query(soql);
        //[SELECT id from PS_Output__c where Part_Selector__c =:psId];
        if(psOutputList.size() > 0)
        {
            return psOutputList[0];
        }
        
        PS_Output__c psoutput = new PS_Output__c();
        return psoutput;
    }
    
    public PS_Output__c getPricePSOutputInstance()
    {
        PS_Output__c psOutput = getPSOutputRecord(PS.Id);
        psOutput.Price_Override__c = null;
        psOutput.Disountable_Lot_Charge_Override__c = null;
        psOutput.Non_Disountable_Lot_Charge_Override__c = null;
        System.debug('@Developer --> psOutput :' + psOutput);
        return psOutput;
    }
    
    
    /* ===========LEAD TIME START */
    public list<PS_Lead_Time__c> PSLeadTimeList {get;set;}
    
    public decimal Total10{set;get;}
    public decimal Total20{set;get;}
    public decimal Total30{set;get;}
    public decimal Total40{set;get;}
    public decimal Total10Override{set;get;}
    public decimal Total20Override{set;get;}
    public decimal Total30Override{set;get;}
    public decimal Total40Override{set;get;}
    
    //Service Ticket #203757, changed the Return type from list of PS_Lead_Time__c to Part_Selector__c obj, so that LT references at PS record level
    public Part_Selector__c getLeadTimeRecs()
    {
        Total10 = 0.0;
        Total20 = 0.0;
        Total30 = 0.0;
        Total40 =0.0;
        Total10Override = 0.0;
        Total20Override = 0.0;
        Total30Override = 0.0;
        Total40Override = 0.0;
        
        PSLeadTimeList = new list<PS_Lead_Time__c>();
        ////PSLeadTimeList = BGROU.GetLeadTimeRec();
        
        //String sASSYPARTNO = oPSAssyPartDefinition.ASSYPARTNO__c;
        String sASSYPARTNO  = PS.Part_Number_Base_Backup__c; //added by Ashim
        
        System.debug('@Developer --> sASSYPARTNO :' + sASSYPARTNO);
        
        map<String,String> mapPartNumberWiseRunTimeSchedule = new map<String,String>();
        
        //PS_Lead_Time__c -->RunTimeSchedule__c
        //Service Ticket #203757, removed the reference of override LT field from PSLT table,  will now referene override LT on Part Selector object
        PSLeadTimeList = [Select Id,RunTimeSchedule__c,ASSYPARTNO__c,
                          Site_10__c,Site_20__c,Site_30__c,Site_40__c
                          From PS_Lead_Time__c
                          Where ASSYPARTNO__c = :sASSYPARTNO
                          Limit 1];
        System.debug('@Developer --> PSLeadTimeList :' + PSLeadTimeList);
        
        for(PS_Lead_Time__c psl :PSLeadTimeList){
            mapPartNumberWiseRunTimeSchedule.put(psl.ASSYPARTNO__c,psl.RunTimeSchedule__c);
        }
        System.debug('@Developer --> mapPartNumberWiseRunTimeSchedule :' + mapPartNumberWiseRunTimeSchedule);
        
        //GlobalLeadTime__c -->     Schedule__c + qty > <
        PS_Lead_Time__c psl;
        for(GlobalLeadTime__c glt : [Select Id,X10__c,X20__c,X30__c,X40__c
                                     From GlobalLeadTime__c
                                     Where Schedule__c = :mapPartNumberWiseRunTimeSchedule.values()
                                     And QtyLL__c <= :PS.Quantity__c
                                     And QtyUL__c >= :PS.Quantity__c
                                     Limit 1
                                    ])
        {
            if(PSLeadTimeList.size() > 0){
                psl = PSLeadTimeList[0];
                psl.Site_10__c = glt.X10__c;
                psl.Site_20__c = glt.X20__c;
                psl.Site_30__c = glt.X30__c;
                psl.Site_40__c = glt.X40__c;
                
                if(!PS.Lead_Time_Engineer_Override__c){ //ENG_OVERIDE = FALSE (UNCHKD)
                    
                    //Service Ticket #203757, set global LT, if found on PS record LT and on override LT fields
                    PS.Lead_Time_Site_10__c = psl.Site_10__c;
                    PS.Lead_Time_Site_20__c = psl.Site_20__c;
                    PS.Lead_Time_Site_30__c = psl.Site_30__c;
                    PS.Lead_Time_Site_40__c = psl.Site_40__c;
                    
                    PS.Lead_Time_10_Override__c = psl.Site_10__c;
                    PS.Lead_Time_20_Override__c = psl.Site_20__c;
                    PS.Lead_Time_30_Override__c = psl.Site_30__c;
                    PS.Lead_Time_40_Override__c = psl.Site_40__c;
                }
                else{//IF OVERRIDE IS CHECKED, and still null, set the LT( global, if any)
                    if(PS.Lead_Time_10_Override__c == null){
                        PS.Lead_Time_10_Override__c = psl.Site_10__c;
                        PS.Lead_Time_Site_10__c = psl.Site_10__c;
                    }
                    
                    if(PS.Lead_Time_20_Override__c == null){
                        PS.Lead_Time_20_Override__c = psl.Site_20__c;
                        PS.Lead_Time_Site_20__c = psl.Site_20__c;
                    }
                    
                    if(PS.Lead_Time_30_Override__c == null){
                        PS.Lead_Time_30_Override__c = psl.Site_30__c;
                        PS.Lead_Time_Site_30__c = psl.Site_30__c;
                    }
                    
                    if(PS.Lead_Time_40_Override__c == null){
                        PS.Lead_Time_40_Override__c = psl.Site_40__c;
                        PS.Lead_Time_Site_40__c = psl.Site_40__c;
                    }
                }
            }
        }
        System.debug('@Developer --> PSLeadTimeList :' + PSLeadTimeList);
        
        System.debug('***** PS.Lead_Time_Site_10__c = '+PS.Lead_Time_Site_10__c+', PS.Lead_Time_Site_20__c = '+PS.Lead_Time_Site_20__c+',PS.Lead_Time_Site_30__c = '+PS.Lead_Time_Site_30__c+',PS.Lead_Time_Site_40__c = '+PS.Lead_Time_Site_40__c);
        System.debug('***** PS.Lead_Time_10_Override__c = '+PS.Lead_Time_10_Override__c+', PS.Lead_Time_20_Override__c = '+PS.Lead_Time_20_Override__c+',PS.Lead_Time_30_Override__c = '+PS.Lead_Time_30_Override__c+',PS.Lead_Time_40_Override__c = '+PS.Lead_Time_40_Override__c);
        
        //update PS;
        return PS;//Service Ticket #203757,change the return type from list LT
    }
    
    
    //* @ Apply Default Override for Lead time
    //Service Ticket #203757,update the LT override values on PartSelector record instead of PSL record's LT override
    //ReSet override value fields of PartSelctor with similar logic of considering gbl LT if they exist
    public void ApplyDefaultLeadtime()
    {
        if(partNumber != '' && partNumber != null){
            oPSAssyPartDefinition.ASSYPARTNO__c = partNumber;
        }
        if(PS.Lead_Time_Engineer_Override__c == false && PSLeadTimeList != null && PSLeadTimeList.size() > 0)
        {
            map<String,String> mapPartNumberWiseRunTimeSchedule = new map<String,String>();
            for(PS_Lead_Time__c psl :PSLeadTimeList){
                mapPartNumberWiseRunTimeSchedule.put(psl.ASSYPARTNO__c,psl.RunTimeSchedule__c);
            }
            PS_Lead_Time__c psl;
            for(GlobalLeadTime__c glt : [Select Id,X10__c,X20__c,X30__c,X40__c
                                     From GlobalLeadTime__c
                                     Where Schedule__c = :mapPartNumberWiseRunTimeSchedule.values()
                                     And QtyLL__c <= :PS.Quantity__c
                                     And QtyUL__c >= :PS.Quantity__c
                                     Limit 1
                                    ])
            {
                psl = PSLeadTimeList[0];
                psl.Site_10__c = glt.X10__c;
                psl.Site_20__c = glt.X20__c;
                psl.Site_30__c = glt.X30__c;
                psl.Site_40__c = glt.X40__c;
            }

            PS.Lead_Time_10_Override__c = psl.Site_10__c;
            PS.Lead_Time_20_Override__c = psl.Site_20__c;
            PS.Lead_Time_30_Override__c = psl.Site_30__c;
            PS.Lead_Time_40_Override__c = psl.Site_40__c;
        
            update PS; //removed additional update of PSL
        }
        // return null;
    }
    //* @ Save Lead time Override on click on save
    Public pageReference SaveLeadTimeOverride()
    {
        PS_Output__c psOutPut = getLeadPSOutputInstance();
        psOutPut.Lead_Time_10__c = PS.Lead_Time_10_Override__c;
        psOutPut.Lead_Time_20__c = PS.Lead_Time_20_Override__c;
        psOutPut.Lead_Time_30__c = PS.Lead_Time_30_Override__c;
        psOutPut.Lead_Time_40__c = PS.Lead_Time_40_Override__c;
        
        //Service Ticket #201772, SHIFTED THE LOGIC TO PSOutputUtilityXML.cls file TO SET LEAD TIME OVERRIDE VALUE FOR XML
        
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            // quoteLine.Config_Record_Id__c = conProd.id;
            // quoteLine.SBQQ__Quantity__c=conProd.Quantity__c;
            // quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
            // quoteLine.Non_Discountable_List_Price__c =  psOutputInstance.Disountable_Lot_Charge_Override__c;
            // quoteLine.Discountable_List_Price__c = psOutputInstance.Non_Disountable_Lot_Charge_Override__c;
            quoteLine.Leadtime_Site_10__c = psOutPut.Lead_Time_10__c;
            quoteLine.Leadtime_Site_20__c = psOutPut.Lead_Time_20__c;
            quoteLine.Leadtime_Site_30__c = psOutPut.Lead_Time_30__c;
            quoteLine.Leadtime_Site_40__c = psOutPut.Lead_Time_40__c;
            upsert quoteLine;
        }
        if(psOutPut.id!=null){
            update psOutPut;
        }
        //SERVICE TICKET #203757 , no need to update PS lead time table, as it is for reading LT 
        System.debug('***** PS.Lead_Time_Site_10__c = '+PS.Lead_Time_Site_10__c+', PS.Lead_Time_Site_20__c = '+PS.Lead_Time_Site_20__c+',PS.Lead_Time_Site_30__c = '+PS.Lead_Time_Site_30__c+',PS.Lead_Time_Site_40__c = '+PS.Lead_Time_Site_40__c);
        if(ps.Id!=null){
            update PS; 
        }
        return null;
    }
    
    public PS_Output__c getLeadPSOutputInstance()
    {
        PS_Output__c psOutPut = getPSOutputRecord(PS.Id);
        
        psOutPut.Lead_Time_10__c = null;
        psOutPut.Lead_Time_20__c = null;
        psOutPut.Lead_Time_30__c = null;
        psOutPut.Lead_Time_40__c = null;
        
        ////?//psOutPut.Adder_Lead_Time_10__c = '';
        ////?//psOutPut.Adder_Lead_Time_20__c = '';
        ////?//psOutPut.Adder_Lead_Time_30__c = '';
        ////?//psOutPut.Adder_Lead_Time_40__c = '';
        ////?//psOutPut.Base_Lead_Time_10__c = '';
        ////?//psOutPut.Base_Lead_Time_20__c = '';
        ////?//psOutPut.Base_Lead_Time_30__c = '';
        ////?//psOutPut.Base_Lead_Time_40__c = '';
        return psOutPut;
    }
    
    /* ========== LEAD TIME END================*/
    
    
    
    
    public List<SelectOption> getattrvalueList() {
        List<selectOption> opt =new List<selectOption>();
        ////opt.add(new SelectOption('','--NONE--'));
        
        Set<String> catSet = new Set<String>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c!='' order by Display_Order__c ];
        List<PS_Input_Field_Labels__c> inputLabelsList=[select id,Attribute_Text_Description__c,Attribute_Code__c,ProdGroup__c,SubGroup__c from PS_Input_Field_Labels__c  where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute_Code__c!='' ];
        //for(PS_Input_Field_Labels__c obj: inputLabelsList)
        //{
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            if(obj1.Attribute__c=='SZC')
            {
                
                opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            }
            else if(obj1.Attribute__c=='PTC')
                
            {
                
                opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            }
        }
        /*for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
{


opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
map1.put(obj1.Attribute__c,obj1.Text_Description_of_Attribute_Value__c);
}*/
        
        return opt ;
    }
    
    public List<SelectOption> getsizevalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        
        inputvaluesList1=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='SZC'];
        system.debug('inputvaluesList1$$$'+inputvaluesList1);
        if(inputvaluesList1.size()>0)
        {
            for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList1)
            {
                
                
                opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
                
                
            }
        }
        return opt ;
        
    }
    
    public List<SelectOption> getPTCvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='PTC'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getMCBODYvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCBODY'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getHCLASSvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='HCLASS'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getATEXvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='ATEX'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getCUTRvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='CUTR'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getESZCvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='ESZC'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getMCDPHMvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Display_Order__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCDPHM'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    public List<SelectOption> getMCELMTvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCELMT'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getMCHOUSvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCHOUS'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getMCPALLvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCPALL'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    public List<SelectOption> getNACEvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='NACE'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getSETTINGvalueList() {
        List<selectOption> opt =new List<selectOption>();
        
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='SETTING'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    public List<SelectOption> getSPRINGvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='SPRING'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    public List<SelectOption> getWeightMatlCodevalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCWGHT'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getWeightvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='Weight'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getTypevalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,Display_Order__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='Type' order by Display_Order__c ASC];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getThicknessvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='Thickness'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getSpringRangevalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='SpringRange'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getSpringMatlCodevalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCSPRG'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getPositionvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='Position'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getPortLoadingvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='PortLoading'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getPortvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='Port'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getPilotSupplyRangevalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='PilotSupplyRange'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getPilotGasvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='PilotGas'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getMCSPRGvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCSPRG'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getMCENVGvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='MCENVG'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getGVRSC1valueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='GVRSC1'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    public List<SelectOption> getGPRSC1valueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='GPRSC1'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    public List<SelectOption> getGENOPTvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='GENOPT'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public List<SelectOption> getEnvelopeGasketvalueList() {
        List<selectOption> opt =new List<selectOption>();
        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,SubGroup__c from PS_Input_Attr_Value_Desc__c where ProdGroup__c=:PDgroup and SubGroup__c=:subPDgroup and Attribute__c='Envelope Gasket'];
        
        Map<String,String> map1 = new Map<String,String>();
        for(PS_Input_Attr_Value_Desc__c obj1: inputvaluesList)
        {
            
            
            opt.add(new SelectOption(obj1.Text_Description_of_Attribute_Value__c, obj1.Text_Description_of_Attribute_Value__c));
            
            
        }
        
        return opt ;
    }
    
    public String OA02{
        get {
            return PSOU.OA02;
        }
        set {
            this.OA02= OA02;
        }
    }
    
    public integer psaSelectedCol {get;set;}
    public string psaAllColSelection {get;set;}
    public pageReference applyFilterOnPSA()
    {
        System.debug('@Developer 1 --> applyFilterOnPSA :');
        System.debug('@Developer 2--> psaSelectedCol :' + psaSelectedCol);
        System.debug('@Developer 3--> psaAllColSelection :' + psaAllColSelection);
        
        String keyGrpSGrp = PDgroup + '-' + subPDgroup;
        map<Integer,String> mapIndexWiseAttrCode = new map<Integer,String>();
        SelectOption so;
        /*if(mapGrpSubGrpWiseAttributes.containsKey(keyGrpSGrp))
{
Integer indx = 0;
for(String attrCode : mapGrpSubGrpWiseAttributes.get(keyGrpSGrp))
{
mapIndexWiseAttrCode.put(indx,attrCode);
indx++;
}
}*/
        Integer index = 0;
        for(String attrLabel : mapGrpSubGrpWiseField.keySet())
        {
            String attributeKey;
            if(attrLabel.contains('-'))
            {
                if(attrLabel.substringAfterLast('-') != 'null')
                {
                    String attributeCode = attrLabel.substringAfterLast('-');
                    mapIndexWiseAttrCode.put(index,attributeCode);
                    index++;
                }
            }
        }
        System.debug('@Developer --> mapIndexWiseAttrCode :' + mapIndexWiseAttrCode);
        System.debug('@Developer --> mapIndexWiseAttrCode :' + keyGrpSGrp);
        String sSOQL = 'SELECT id,ASSYPARTNO__c,PartRevision__c,ProdGroup__c,SubGroup__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c ';
        sSOQL += ' ,Field9__c,Field10__c,Field11__c,Field12__c,Field13__c,Field14__c,Field15__c,Field16__c ';
        sSOQL += ' ,Field17__c,Field18__c,Field19__c,Field20__c,Field21__c,Field22__c,Notes__c ';
        sSOQL += ' FROM PS_AssyPartDefinition__c ';
        
        String sWhere = ' WHERE ProdGroup__c = \'' + PDgroup + '\'';
        sWhere += ' AND SubGroup__c = \'' + subPDgroup + '\'';
        sWhere += '  AND Brand__c = \'' + PS.Brand__c + '\'';
        
        list<String> lstFieldDetail = psaAllColSelection.split(';');
        System.debug('@Developer --> lstFieldDetail :' + lstFieldDetail);
        
        for(Integer nFld=0 ; nFld <= psaSelectedCol; nFld++)
        {
            String fldDetail = lstFieldDetail[nFld];
            System.debug('@Developer --> fldDetail :' + fldDetail);
            
            list<String> lstFldVal = fldDetail.split(':');
            System.debug('@Developer --> lstFldVal :' + lstFldVal);
            
            String keyGrpSGrpFld = keyGrpSGrp + '-' + lstFldVal[1];
            System.debug('@Developer --> keyGrpSGrpFld :' + keyGrpSGrpFld);
            
            if(mapGrpSubGrpWiseField.containsKey(keyGrpSGrpFld))
            {
                String fldName = mapGrpSubGrpWiseField.get(keyGrpSGrpFld);
                System.debug('@Developer --> fldName :' + fldName);
                if(lstFldVal.size() > 2)
                {
                    sWhere += ' And ' + fldName + '=\'' + lstFldVal[2] + '\'';
                }
            }
            
        }
        
        System.debug('@Developer --> sWhere :' + sWhere);
        
        sSoql += sWhere;
        System.debug('@Developer --> sSoql :' + sSoql);
        
        Map<String, Map<String, String>> mapOfValTmp = new Map<String, Map<String, String>>();
        Map<String, String> tmpSelectOptions;
        map<string,list<SelectOption>> mapofvalues = new map<string,list<SelectOption>>();
        list<PS_AssyPartDefinition__c> lstPSAPD = database.query(sSoql);
        for(PS_AssyPartDefinition__c papd :lstPSAPD)
        {
            //oPSAssyPartDefinition = papd;
            system.debug('@@Part number generated'+oPSAssyPartDefinition.ASSYPARTNO__c);
            
            system.debug('@@Part number generated to field:'+PS.Part_Number__c+'Part number base:'+PS.Part_Number_Base__c);
            for(Integer indx : mapIndexWiseAttrCode.keySet())
            {
                String sAttrCode = mapIndexWiseAttrCode.get(indx);
                String keyGrpSGrpFld = keyGrpSGrp + '-' + sAttrCode ;
                System.debug('@Developer --> keyGrpSGrpFld :' + keyGrpSGrpFld);
                
                list<SelectOption> tempValue;
                if(mapofvalues.containsKey(keyGrpSGrpFld)) {
                    
                    tempValue = mapofvalues.get(keyGrpSGrpFld);
                    
                    tmpSelectOptions = mapOfValTmp.get(keyGrpSGrpFld);
                    
                } else {
                    
                    tempValue = new List<SelectOption>();
                    
                    tmpSelectOptions = new Map<String, String>();
                }
                
                if(mapGrpSubGrpWiseField.containsKey(keyGrpSGrpFld)) {
                    
                    String fldName = mapGrpSubGrpWiseField.get(keyGrpSGrpFld);
                    String sVal = string.valueOf(papd.get(fldName));
                    String sValDesc = sVal;
                    String sValDescKey =  keyGrpSGrpFld + '-' + sVal ;
                    if(mapValueWiseLabel.containsKey(sValDescKey)) {
                        
                        sValDesc = mapValueWiseLabel.get(sValDescKey);
                    }
                    system.debug('$$$$$$$$$$$$$$'+sValDesc+'-savl-'+sVal);
                    tmpSelectOptions.put(sVal, sValDesc);
                    if(string.isNotBlank(sVal) && string.isNotBlank(sValDesc)){//Added Nagarjuna
                        so = new SelectOption(sVal, sValDesc);
                        if(!tempValue.contains(so)) {
                            
                            tempValue.add(so);
                        }
                    }
                    mapofvalues.put(keyGrpSGrpFld, tempValue);
                    
                    mapOfValTmp.put(keyGrpSGrpFld, tmpSelectOptions);
                }
            }
        }
        
        system.debug('mapOfValTmp:'+mapOfValTmp.size());
        system.debug('mapOfValTmp:'+mapofvalues.size());
        
        //apply the sorting - mapOfValTmp
        mapofvalues = sortSelectOptions(mapOfValTmp);
        
        if(!(lstPSAPD.size() == 0))
        {
            
            oPSAssyPartDefinition = lstPSAPD[0];
            PS.PARTREV__c = oPSAssyPartDefinition.PartRevision__c;
            
        }
        else
        {
            oPSAssyPartDefinition = new PS_AssyPartDefinition__c();
        }
        
        for(Integer indx : mapIndexWiseAttrCode.keySet())
        {
            if(indx <= psaSelectedCol) continue;
            String sAttrCode = mapIndexWiseAttrCode.get(indx);
            String sAttrDesc = '';
            if(mapFieldWiseLabel.containsKey(sAttrCode))
            {
                sAttrDesc = mapFieldWiseLabel.get(sAttrCode);
            }
            String keyGrpSGrpFld = keyGrpSGrp + '-' + sAttrCode ;
            if(mapofvalues.containsKey(keyGrpSGrpFld))
            {
                FieldWrapper wobj = listField[indx];
                wobj.fieldName = sAttrDesc;
                wobj.key = sAttrCode;
                list<SelectOption> lstSelectOpts = mapofvalues.get(keyGrpSGrpFld);
                if(wobj.fieldName == 'Maximum Pressure:'){
                    Map<Decimal,string> dstr = new Map<Decimal,string>();
                    for(selectOption s : wobj.lstSelectOption){
                        if(!string.Isempty(s.getValue()))
                            dstr.put(decimal.valueOf(s.getValue()),(string)s.getLabel());
                    }
                    list<Decimal> dlst= new List<decimal>(dstr.keyset());
                    dlst.sort();
                    list<selectOption> seloplst = new List<selectOption>();
                    seloplst.add( new selectOption('','--- Select ---'));
                    for(decimal d : dlst){
                        selectOption sp = new selectOption(string.valueof(d),dstr.get(d));
                        seloplst.add(sp);
                    }
                    wobj.lstSelectOption = seloplst;
                    lstSelectOpts = seloplst;
                }
                if(lstSelectOpts.size() > 1 )
                {
                    if(lstSelectOpts[0].getLabel() != '--- Select ---')
                    {
                        lstSelectOpts.add(0 , new SelectOption('','--- Select ---'));
                    }
                    wobj.sValue = '';
                }
                else
                {
                    wobj.sValue = lstSelectOpts[0].getValue();
                }
                wobj.lstSelectOption = lstSelectOpts;
            }
        }
        
        
        PS.ProductGroup__c = PDgroup;
        PS.SubGroup__c = subPDgroup;
        
        // PS.Part_Number__c = oPSAssyPartDefinition.ASSYPARTNO__c;
        return null;
    }
    
    public Map<String, List<SelectOption>> sortSelectOptions(Map<String, Map<String, String>> mapOfValTmp) {
        system.debug(mapOfValTmp);
        Map<String, String> tmpSelectOptions;
        SelectOption so;
        Map<String, List<SelectOption>> mapofvalues = new Map<String, List<SelectOption>>();
        Set<String> keysOptions = new Set<String>();
        List<String> keysToSort = new List<String>();
        List<SelectOption> tempValue1;
        for(String mapKey: mapOfValTmp.keySet()) {
            
            tmpSelectOptions = mapOfValTmp.get(mapKey);
            system.debug('tmpSelectOptions--'+tmpSelectOptions);
            
            keysOptions = tmpSelectOptions.keySet();
            keysToSort.addAll(keysOptions);
            keysToSort.sort();
            
            system.debug('keysToSort--'+keysToSort);
            tempValue1 = new List<SelectOption>();
            for(String tmpKey: keysToSort) {
                
                //system.debug('ASHIM:: '+tmpKey+' ## '+tmpSelectOptions.get(tmpKey));
                if(tmpSelectOptions.get(tmpKey) != null) {
                    
                    so = new SelectOption(tmpKey, tmpSelectOptions.get(tmpKey));
                    if(!tempValue1.contains(so)) {
                        
                        tempValue1.add(so);
                    }
                }
            }
            
            mapofvalues.put(mapKey, tempValue1);
        }
        system.debug('map of values ins orting'+mapofvalues);
        return mapofvalues;
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
    // **********Output code begins******//
    
    /* #############Engineering Specials START ###############*/
    
    public PS_Output__c getQuotePSOutputInstance(){
        PS_Output__c PSOutput = getPSOutputRecord(PS.Id);
        return PSOutput;
    }
    
    public class QuoteDescriptionWrapper{
        public String quotes {get;set;}
        public String description {get;set;}
        public List<String> descriptionList {get;set;}
        public List<String> overridedescriptionList {get;set;}
        public String overrideDescription {get;set;}
    }
    
    //** Method for Quote Description
    public Map<String, String> quoteAttriVsDesc;
    public PS_Output__c PSOutsideInstance;
    
    public void GetQuoteDescriptionRecords()
    {
        //AttributeDescription = ' ';
        quoteAttriVsDesc = new Map<String, String>();
        quoteDescriptionList.clear();
        system.debug('PS.Finish_Configuration_Flag__c' + PS.Finish_Configuration_Flag__c);
        if(PS.Finish_Configuration_Flag__c && PS.Part_Number__c <> NULL)
        {
            PS.OA__c = '';
            PS.OB__c = '';
            PS.ORP__c = '';
            PS.ORV__c = '';
            PS.OW__c = '';
            PS.PC__c = '';
            
            PSOU.currentPS = PS;
            Boolean isPSIFDescription = true;
            quoteAttriVsDesc = PSOU.GetPSIFSDescription();
            system.debug('quoteAttriVsDesc.size():'+quoteAttriVsDesc.size());
            if(quoteAttriVsDesc.size() == 0 )
            {
                quoteAttriVsDesc = PSOU.GetAttributeMapQuoteDescription();
                PS.OA01__c = 'Model: ' + PSOU.GMODEL;
                PS.OA__c = PS.OA01__c;
                isPSIFDescription = false;
            }
            system.debug('quoteAttriVsDesc---> ' + quoteAttriVsDesc);
            PSOutsideInstance = getQuotePSOutputInstance();
            system.debug('PSOutsideInstance---> ' + PSOutsideInstance);
            for(String attribute: quoteAttriVsDesc.keySet())
            {
                String attributeFieldAPI = attribute+'__c';
                PS.put(attributeFieldAPI,quoteAttriVsDesc.get(attribute));
                System.debug('##*** attributeFieldAPI = '+attributeFieldAPI+', PS value = '+PS.get(attributeFieldAPI));
            }
            if(false == isPSIFDescription) 
            {
                for(String attribute: quoteAttriVsDesc.keySet())
                {
                    //   if(attribute != 'OB050')
                    //   {
                    String attributeValue = PS.get(attribute+'__c')+'';
                    System.debug('*** attribute = '+attribute+'__c, value = '+attributeValue);
                    if(attribute.startsWith('OA') && String.isNotBlank(attributeValue))
                    {
                        PS.OA__c += '\n' + attributeValue;
                        system.debug('==== > attributeValue ' + attributeValue);
                        system.debug('==== > ' + PS.OA__c);
                    }
                    else if(attribute.startsWith('OB') && String.isNotBlank(attributeValue))
                    {
                        PS.OB__c += '\n' + attributeValue;
                    }
                    else if(attribute.startsWith('OW') && String.isNotBlank(attributeValue))
                    {
                        if(String.isBlank(PS.OW__c))
                        {
                            PS.OW__c = attributeValue;
                        }
                        else
                        {
                            PS.OW__c += '\n' + attributeValue;
                        }
                    }
                    else if(attribute.startsWith('PC') && String.isNotBlank(attributeValue))
                    {
                        if(String.isBlank(PS.PC__c))
                        {
                            PS.PC__c = attributeValue;
                        }
                        else
                        {
                            PS.PC__c += '\n' + attributeValue;
                        }
                    }
                    //}
                }
            }
            
            system.debug('PS.OA__c --- > ' + PS.OA__c);
            system.debug('PS.OB__c --- > ' + PS.OB__c);
            system.debug('PS.OW__c --- > ' + PS.OW__c);
            
            Set<String> quotesAttributeSet = new Set<String>{'OA','OB','ORP','ORV','OW','PC'};
            for(String quoteAttribute: quotesAttributeSet)
            {
                String fieldAPI = quoteAttribute+'__c';
                String quoteRow = (String)PS.get(fieldAPI);
                System.debug('*** fieldAPI = '+fieldAPI+', quoteRow = '+quoteRow);
                if(String.isNotBlank(quoteRow))
                {
                    QuoteDescriptionWrapper quoteDescription = new QuoteDescriptionWrapper();
                    quoteDescription.quotes = quoteAttribute;
                    quoteDescription.descriptionList = new List<String>();
                    quoteDescription.overridedescriptionList = new List<String>();
                    String descriptionValue = PS.get(fieldAPI)+'';
                    for(String dec : descriptionValue.split('\n'))
                    {
                        quoteDescription.descriptionList.add(dec);
                    }
                    quoteDescription.description = PS.get(fieldAPI)+'';
                    System.debug('*** PSOutsideInstance = '+PSOutsideInstance.get(quoteAttribute+'_Override__c'));
                    if(PSOutsideInstance.get(quoteAttribute+'_Override__c') == null)
                    {
                        quoteDescription.overrideDescription = PS.get(fieldAPI)+'';
                        PSOutsideInstance.put(quoteAttribute+'_Override__c',PS.get(fieldAPI));
                    }
                    else
                    {
                        quoteDescription.overrideDescription = (String)PSOutsideInstance.get(quoteAttribute+'_Override__c');
                    }
                    if(PS.Quote_Description_Engineer_Override__c == true && quoteAttribute == 'OA')
                    {
                        if(!quoteDescription.overrideDescription.startsWith('Special'))
                        {
                            quoteDescription.overrideDescription = quoteDescription.overrideDescription;
                        }
                    }
                    System.debug('*** quoteDescription = '+quoteDescription);
                    for(String dec : quoteDescription.overrideDescription.split('\n'))
                    {
                        quoteDescription.overridedescriptionList.add(dec);
                    }
                    quoteDescriptionList.add(quoteDescription);
                    system.debug('quoteDescriptionList=== > ' + quoteDescriptionList);
                }
            }
            //upsert PSOutsideInstance;
            PSOU.OA = (String) PSOutsideInstance.get('OA_Override__c');
            PSOU.mapPSAttr.put('OA',PSOU.OA);
            PSOU.OB = (String) PSOutsideInstance.get('OB_Override__c');
            PSOU.mapPSAttr.put('OB',PSOU.OB);
            PSOU.ORP = (String) PSOutsideInstance.get('ORP_Override__c');
            PSOU.mapPSAttr.put('ORP',PSOU.ORP);
            PSOU.ORV = (String) PSOutsideInstance.get('ORV_Override__c');
            PSOU.mapPSAttr.put('ORV',PSOU.ORV);                        
            PSOU.OW = (String) PSOutsideInstance.get('OW_Override__c');
            PSOU.mapPSAttr.put('OW',PSOU.OW);
            PSOU.PC = (String) PSOutsideInstance.get('PC_Override__c');
            PSOU.mapPSAttr.put('PC',PSOU.PC);
           
        }
    }
    public string strquoteDes {
        get {
            
            PS_Output__c PSoutput = getPSOutputRecord(PS.Id);
            
            String strProdOver = '';
            if(String.isNotBlank(PSoutput.OA_Override__c)){
                strProdOver += PSoutput.OA_Override__c +'<BR/><BR/>';
            }
            if(String.isNotBlank(PSoutput.OB_Override__c)){
                strProdOver += PSoutput.OB_Override__c+'<BR/><BR/>';
            }
            if(String.isNotBlank(PSoutput.ORP_Override__c)){
                strProdOver += PSoutput.ORP_Override__c+'<BR/><BR/>';
            }
            if(String.isNotBlank(PSoutput.ORV_Override__c)){
                strProdOver += PSoutput.ORV_Override__c+'<BR/><BR/>';
            }
            if(String.isNotBlank(PSoutput.OW_Override__c)){
                strProdOver += PSoutput.OW_Override__c+'<BR/><BR/>';
            }
            if(String.isNotBlank(PSoutput.PC_Override__c)){
                strProdOver += PSoutput.PC_Override__c;
            }
            strquoteDes = strProdOver;
            return strquoteDes.replaceAll('\n', '<BR/>');
        }
        set {
            this.strquoteDes=value;
        }
    }
    //* @ Apply Default Override for Quote Description
    public pageReference ApplyDefaultQuoteDescription()
    {
        if(PS.Quote_Description_Engineer_Override__c == false)
        {
            PS.Part_Number_Base__c = PS.Part_Number_Base_Backup__c;
            PS.ASSYPARTEXISTING__c = PS.Part_Number_Base_Backup__c;
            PS.Existing_partnumber__c = PS.Part_Number_Base_Backup__c;  
            PS.NEWSPCLPARTNOBASE__c = null;
            Set<String> quotesAttributeSet = new Set<String>{'OA','OB','ORP','ORV','OW','PC'};
                for(String quoteAttribute: quotesAttributeSet)
            {
                String attributeFieldAPI = quoteAttribute+'_Override__c';
                system.debug('TEST::'+quoteAttribute+'__c');
                String attributeValue = (String)PS.get(quoteAttribute+'__c');
                if(PSOutsideInstance == null){
                    //PSOutsideInstance.put(attributeFieldAPI, attributeValue);
                    PSOutsideInstance = new PS_Output__c();
                    
                }
                system.debug('$$$$$$$$'+attributeFieldAPI);
                PSOutsideInstance.put(attributeFieldAPI, attributeValue);
                system.debug('$$$$$$$$'+PSOutsideInstance);
            }
            if(PSOutsideInstance.Id !=null){//Added Nagarjuna
                update PSOutsideInstance;
            }
            if(!Test.isRunningTest()) 
            {
                if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    quoteLine.SBQQ__Description__c=strquoteDes;
                    upsert quoteLine;
                }
            }
            
            GetQuoteDescriptionRecords();
            quoteLine.Is_Special__c = false;
            if(quoteLine.Parts_Managed_In__c == 'IFS') 
            quoteLine.isIFSManaged__c = true;
            else
            quoteLine.isIFSManaged__c = false;
           
        }else
        {
            savePartNumber();                  
            quoteLine.isIFSManaged__c = true;
            PS.Existing_partnumber__c = '';
            quoteLine.Is_Special__c = true;
            system.debug('@@@@@@' +  quoteLine.Is_Special__c);
            update PS;
        }
        update PS;
        if(!Test.isRunningTest()) 
        {
            upsert quoteLine;
        }
        disableButton = (!showsales) && PS.Quote_Description_Engineer_Override__c;
        return null;
    }
    
    
    
    //* @ Save Quote Description Override on click on save
    Public pageReference SaveQuoteDescriptionOverride()
    {
        if(quoteDescriptionList != null && quoteDescriptionList.size() > 0)
        {
            for(QuoteDescriptionWrapper bgqd : quoteDescriptionList)
            {
                String attributeFieldAPI = bgqd.quotes+'_Override__c';
                PSOutsideInstance.put(attributeFieldAPI, bgqd.overrideDescription);
            }
            system.debug(PSOutsideInstance);
            if(String.isNotBlank(PSOutsideInstance.Id))
            {
                update PSOutsideInstance;
            }
            GetQuoteDescriptionRecords();
            if(!Test.isRunningTest()) 
            {
                if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    quoteLine.SBQQ__Description__c=strquoteDes;
                    upsert quoteLine;
                }
            }
        }
        system.debug(PS+'--------');
        if(PS.Quote_Description_Engineer_Override__c == true)
        {
            PS.ASSYPARTEXISTING__c = '';
            PS.Part_Number__c = oPSAssyPartDefinition.ASSYPARTNO__c ;
            update ps;
            //AssyPartDefinationProcessor.getPartNumberByRec(ps);
        }
        return null;
    }
    
    /* ############### Engineering Specials END ##################*/
    
    /*public void costOnload()
{
getCosts();
}*/
    public List<Cost__c> assembleCost{get;set;}
    public List<Cost__c> buildCost{get;set;}
    public List<Cost__c> overridenCost{get;set;}
    public List<Cost__c> hiddenCost{get;set;}
    public void getCosts()
    {
        assembleCost = new List<Cost__c>();
        buildCost = new List<Cost__c>();
        overridenCost = new List<Cost__c>();
        WizardCostProcessor wcp = new WizardCostProcessor(PS.Id);
        Map<String,List<Cost__c>> getBGRCostData = wcp.getBGRCostData();
        System.debug('@@@@@ getBGRCostData = '+getBGRCostData);
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
        system.debug('PS$$$$$$$$$: 4'+partNumber);
    }
    
    public pageReference saveCosting()
    {
        List<Cost__c> allCost = new List<Cost__c>();
        if(assembleCost.size() > 1)
        {
            allCost.addAll(assembleCost);
        }
        if(buildCost.size() > 0)
        {
            allCost.addAll(buildCost);
        }
        if(allCost.size() > 0)
        {
            update allCost;
        }
        update PS;
        getCosts();
        return null;
    }
    
    public pageReference ApplyDefaultCost()
    {
        if(PS.Build_Cost_Override__c == false)
        {
            List<Cost__c> allCost = new List<Cost__c>();
            if(assembleCost.size() > 1)
            {
                allCost.addAll(assembleCost);
            }
            if(buildCost.size() > 0)
            {
                allCost.addAll(buildCost);
            }
            if(allCost.size() > 0)
            {
                for(Cost__c costRecord: allCost)
                {
                    costRecord = copyCostToCostOverride(costRecord);
                }
                update allCost;
            }
            update PS;
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
    
    
    
    
    
    //Added by Vinayak and Nagarjuna
    public class PSStructureWrapper {
        public string ComponentPart {set;get;}
        public string PartNumber {set;get;}
        public string Qty {set;get;}
        public string ScrapFactor {set;get;}
        public string ComponentScrap {set;get;}
        public string LineItemNo {set;get;}
    }
    
    
    public list<PSStructureWrapper> getStructure() {
        list<PSStructureWrapper> PSStructureList = new list<PSStructureWrapper>();
        result strcResult=new result();
        strcResult=PSOU.getStructure();
        system.debug('strcResult---> ' + strcResult);
        if(strcResult.bResult)
        {
            for (sObject sobj:strcResult.objResultList)
            {
                PSStructureWrapper PSWrap=new PSStructureWrapper();
                PSWrap.ComponentPart = (string) sobj.get('Structure_Element__c');
                PSWrap.PartNumber = (string) sobj.get('Component_part__c');
                //PSWrap.Qty= (String) sobj.get('Component_part__c');
                PSWrap.ScrapFactor =(String) sobj.get('Scrap_Factor__c');
                PSWrap.Qty=(String) sobj.get('Qty_per_Assembly__c');
                PSWrap.ComponentScrap=(String) sobj.get('Component_Scrap__c');
                PSWrap.LineItemNo=(String) sobj.get('ItemNo__c');
                PSStructureList.add(PSWrap);
            }
        }
        return PSStructureList;
    }
    
    
    public class PSRoutingWrapper
    {
        public string Operation {set;get;}
        public string StandardOperationID {set;get;}
        public string OutsideOperationIdD {set;get;}
        public string Descr {set;get;}
    }
    
    public list<PSRoutingWrapper> GetRoutingDetails()
    {
        list<PSRoutingWrapper> PSRoutingList = new list<PSRoutingWrapper>();
        result RResult=new result();
        RResult=PSOU.getRouting();
        if(RResult.bResult)
        {		
            result res=new result();
            res=PSOU.getRouting();
            if(res.bResult)
            {
                List<Integer> aList = new List<Integer>();
                
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('Operation__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);         
                }
                aList.sort();
                for(Integer a: aList)
                { 	
                    for (sObject sobj:RResult.objResultList)
                    {
                        string a2=(string) sobj.get('Operation__c');
                        Integer i2=integer.valueOf(a2);
                        if(a==i2)
                        {
                            PSRoutingWrapper bgRR=new PSRoutingWrapper();
                            bgRR.Operation= (String) sobj.get('Operation__c');
                            bgRR.StandardOperationID= (String) sobj.get('Standard_Operation_Id__c');
                            bgRR.OutsideOperationIdD= (String) sobj.get('Outside_Operation_Item__c');
                            bgRR.Descr= (String) sobj.get('Descr__c');
                            //routingOpp.add((String) sobj.get('Operation_Number__c'));
                            PSRoutingList.add(bgRR);             
                        }  
                    }
                    
                }
            }		   
            
        }         
        
        return PSRoutingList;
    }
    
    public list<PSControlPlanWrapper> GetControlPlanDetails()
    {
        list<PSControlPlanWrapper> PSControlPlanList = new list<PSControlPlanWrapper>();
        result CPResult=new result();
        //PSOutputUtility myStrcDetail = new PSOutputUtility(PS.Id);
        CPResult=PSOU.getControlPlan();
        string OuterMinValue = '';
        string InnerMinValue = '';
        string NominalValue = '';
        string InnerMaxValue = '';
        string OuterMaxValue = '';
        if(CPResult.bResult)
        {
            for (sObject sobj:CPResult.objResultList)
            {
                PSControlPlanWrapper PSRCP=new PSControlPlanWrapper();
                PSRCP.Test_OPNO= (String) sobj.get('Test_OPNO__c');
                PSRCP.TEST_OPERATION_DESC= (String) sobj.get('TEST_OPERATION_DESC__c');
                PSRCP.NORM_TYPE= (String) sobj.get('NORM_TYPE__c');
                PSRCP.OperationNumber= (String) sobj.get('Operation_Number__c');
                PSRCP.DATA_TYPE= (String) sobj.get('DATA_TYPE__c');
                PSRCP.CATEGORY_ID= (String) sobj.get('CATEGORY_ID__c');
                PSRCP.INSPECTION_CODE= (String) sobj.get('INSPECTION_CODE__c');
                PSRCP.ProcessCharacteristic= (Decimal) sobj.get('Process_Characteristic__c');
                OuterMinValue = (String) sobj.get('OUTER_MIN__c');
                if(OuterMinValue!=null)
                {
                    OuterMinValue = OuterMinValue.substringBetween('[',']');
                }
                if(string.isBlank(OuterMinValue) || OuterMinValue == null)
                {
                    PSRCP.OUTER_MIN = (String) sobj.get('OUTER_MIN__c');
                }
                else
                {
                    PSRCP.OUTER_MIN = PSOU.mapPSAttr.get(OuterMinValue);
                }
                InnerMinValue = (String) sobj.get('INNER_MIN__c');
                if(InnerMinValue!=null)
                {
                    InnerMinValue = InnerMinValue.substringBetween('[',']');
                }
                if(string.isBlank(InnerMinValue) || InnerMinValue == null)
                {
                    PSRCP.INNER_MIN = (String) sobj.get('INNER_MIN__c');
                }
                else
                {
                    PSRCP.INNER_MIN= PSOU.mapPSAttr.get(InnerMinValue);
                }
                NominalValue = (String) sobj.get('NOMINAL_VALUE__c');
                if(NominalValue!=null)
                {
                    NominalValue = NominalValue.substringBetween('[',']');
                }
                if(string.isBlank(NominalValue) || NominalValue == null)
                {
                    PSRCP.NOMINALVALUE = (String) sobj.get('NOMINAL_VALUE__c');
                }
                else
                {
                    PSRCP.NOMINALVALUE = PSOU.mapPSAttr.get(NominalValue);
                }
                InnerMaxValue = (String) sobj.get('INNER_MAX__c');
                if(InnerMaxValue!=null)
                {
                    InnerMaxValue = InnerMaxValue.substringBetween('[',']');
                }
                if(string.isBlank(InnerMaxValue) || InnerMaxValue == null)
                {
                    PSRCP.INNER_MAX = (String) sobj.get('INNER_MAX__c');
                }
                else
                {
                    PSRCP.INNER_MAX = PSOU.mapPSAttr.get(InnerMaxValue);
                }
                OuterMaxValue = (String) sobj.get('OUTER_MAX__c');
                if(OuterMaxValue!=null)
                {
                    OuterMaxValue = OuterMaxValue.substringBetween('[',']');
                }
                if(string.isBlank(OuterMaxValue) || OuterMaxValue == null)
                {
                    PSRCP.OUTER_MAX = (String) sobj.get('OUTER_MAX__c');
                }
                else
                {
                    PSRCP.OUTER_MAX = PSOU.mapPSAttr.get(OuterMaxValue);
                }
                system.debug('OuterMin: '+OuterMinValue+ 'Inner Min: ' +InnerMinValue+ 'Outer Max: ' +OuterMaxValue);
                PSRCP.ToolID = (String) sobj.get('Tool_ID__c');
                PSRCP.DataPoint = (String) sobj.get('Data_Point__c');
                PSControlPlanList.add(PSRCP);
            }
        }
        
        System.debug('PSControlPlanList value ============' +PSControlPlanList);
        return PSControlPlanList;
    }
    
    public class PSControlPlanWrapper
    {
        public string Test_OPNO {set;get;}
        public string TEST_OPERATION_DESC {set;get;}
        public string NORM_TYPE {set;get;}
        public string OperationNumber {set;get;}
        public string DATA_TYPE {set;get;}
        public string CATEGORY_ID {set;get;}
        public string INSPECTION_CODE {set;get;}
        public decimal ProcessCharacteristic {set;get;}
        public string OUTER_MIN {set;get;}
        public string INNER_MIN {set;get;}
        public string NOMINALVALUE {set;get;}
        public string INNER_MAX {set;get;}
        public string OUTER_MAX {set;get;}
        public string ToolID {set;get;}
        public string DataPoint {set;get;}
        
    }
    
    public list<PSWorkGuidelinesWrapper> getGuildeline()
    {
        list<PSWorkGuidelinesWrapper> PSWorkGuidelineList = new list<PSWorkGuidelinesWrapper>();
        result WGResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(PS.Id);
        WGResult=PSOU.getWorkGuideLines();
        if(WGResult.bResult)
        {
            for (sObject sobj:WGResult.objResultList)
            {
                PSWorkGuidelinesWrapper PSWD=new PSWorkGuidelinesWrapper();
                PSWD.Operation= (String) sobj.get('Operation__c');
                PSWD.GuidlineSeq= (String) sobj.get('GuidlineSeq__c');
                PSWD.Description= (String) sobj.get('Description__c');
                PSWD.Text= (String) sobj.get('Text__c');
                PSWD.Type= (String) sobj.get('Type__c');
                PSWD.SignOff= (String) sobj.get('Sign_Off__c');
                PSWD.InspectionSignOffRequired= (String) sobj.get('Inspection_Sign_Off_Required__c');
                PSWorkGuidelineList.add(PSWD);
            }
        }
        
        System.debug('PSWorkGuidelineList value ============' +PSWorkGuidelineList);
        return PSWorkGuidelineList;
    }
    
    public class PSWorkGuidelinesWrapper
    {
        public string GuidlineSeq {set;get;}
        public string Operation {set;get;}
        public string Description {set;get;}
        public string Text {set;get;}
        public string Type {set;get;}
        public string SignOff {set;get;}
        public string InspectionSignOffRequired {set;get;}
    }
    
    public list<PSProductDocWrapper> getProDoc()
    {
        list<PSProductDocWrapper> PSProductDocList = new list<PSProductDocWrapper>();
        result PDResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(PS.Id);
        PDResult=PSOU.getDocument();
        if(PDResult.bResult)
        {
            for (sObject sobj:PDResult.objResultList)
            {
                PSProductDocWrapper PSLPD=new PSProductDocWrapper();
                PSLPD.Document= (String) sobj.get('Document__c');
                PSLPD.DocumentID= (String) sobj.get('Document_ID__c');
                PSLPD.Revision= (String) sobj.get('Revision__c');
                PSProductDocList.add(PSLPD);
            }
        }
        System.debug('@@PSProductDocList'+PSProductDocList);
        return PSProductDocList;
        
    }
    
    public class PSProductDocWrapper
    {
        public string Document {set;get;}
        public string Revision {set;get;}
        public string DocumentID {set;get;}
    }
    
    public Map<String, String> Attr;
    Public List<IFSAttr> InterfaceAttrList{get;set;}
    public class IFSAttr
    {
        public String Key {get;set;}
        public String Values {get;set;}
    }
    
    public list<IFSAttr> getIFSAttributes()
    {
        Attr = new Map<String, String>();
        InterfaceAttrList = new List<IFSAttr>();
        //PSOutputUtility PSOU1 = new PSOutputUtility (PS.Id);
        Attr = PSOU.getmapPSInterfaceAttr();
        
        for(String attribute: Attr.keySet())
        {
            system.debug(attribute + '=' +Attr.get('MCPALL'));
            IFSAttr attrDesc = new IFSAttr();
            attrDesc.Key = attribute;
            system.debug('***'+attribute+'@@Print IFS values:'+ Attr.get(attribute));
            if(String.isBlank(attrDesc.Values))
            {
                attrDesc.Values = Attr.get(attribute);
            }
            InterfaceAttrList.add(attrDesc);
        }
        system.debug(InterfaceAttrList);
        return InterfaceAttrList;
    }
    
    //Troubleshooting output
    //Added logic Nagrjuna and vinayak
    public Map<String, String> Attr1;
    Public List<TroubleshootingAttr> TroubleshootingAttrList{get;set;}
    public class TroubleshootingAttr
    {
        public String Key {get;set;}
        public String Values {get;set;}
    }
    
    
    
    public list<TroubleshootingAttr> getPSTroubleshooting()
    {
        Attr1= new Map<String, String>();
        TroubleshootingAttrList = new List<TroubleshootingAttr>();
        PSOU = new PSOutputUtility (PS.Id);
        Attr1= PSOU.getmapPSTroubleshootingAttr();
        
        for(String attribute: Attr1.keySet())
        {
            TroubleshootingAttr attrDesc = new TroubleshootingAttr();
            attrDesc.Key = attribute;
            if(String.isBlank(attrDesc.Values))
            {
                attrDesc.Values = Attr1.get(attribute);
            }
            TroubleshootingAttrList.add(attrDesc);
        }
        return TroubleshootingAttrList;
    }
    
    
    public PageReference saveNotes() {
        //conBGR.Product_material_options_flag__c=true;
        try {
            update PS;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    
    public PageReference SaveDocID()
    {
        /*  PS.PartNumberBase_Checkbox__c=true;
update PS;
return null; */
        
        try {
            
            update PS;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
        
    }
    
    /* public static List<SelectOption> sortList(List<SelectOption> options) {
List<Integer> presessureValues = new List<Integer>();
List<SelectOption> lstSelectOption = new List<SelectOption>();
Map<String,String> allOptions = new Map<String,String>();
System.debug('$$$options='+options);
Boolean isPsig = false;
try {
for(SelectOption s: options) {
if(s.getLabel().contains('psig')){
allOptions.put(s.getLabel(), s.getValue());
presessureValues.add( Integer.valueof(s.getValue())  );
isPsig = true;
}
}
if(isPsig == false){
return options;
}
for(Integer i = 0 ; i < presessureValues.size() ; i ++) {
for(integer j = i+1 ; j <= presessureValues.size() -1 ; j ++ ){
integer x = 0 ;
if(presessureValues[i] >  presessureValues[j]){
x = presessureValues[i]  ;
presessureValues[i] = presessureValues[j]  ;
presessureValues[j]  = x;
system.debug(presessureValues) ;
}
}
}
lstSelectOption.add(0 , new SelectOption('','--- Select ---'));
for(Integer i : presessureValues) {
String value = i + ' psig';
lstSelectOption.add( new SelectOption(allOptions.get(value), value) );
}
}catch(Exception e){
System.debug('$$$Exception='+e.getMessage());
return options;
}
return lstSelectOption;
}*/
    
    //*********Output code end*********//
    
    public class PSPricingWrapper {
        public string sType {get;set;}
        public decimal nListValue {get;set;}
        public decimal nOverrideListValue {get;set;}
    }
    
    
}