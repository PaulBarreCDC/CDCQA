/**
* @File Name          : ConfigHolderController.cls
* @Description        :
* @Author             : Nikhil Arpally
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 18/6/2020, 3:11:38 pm
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    16/6/2020   Nikhil Arpally     Initial Version
**/
public with sharing class ConfigHolderController {
    public string strQuoteStatus {set;get;}
    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public Holders__c conHolder {get; set;}
    public id quoteId {set;get;}
    public User oUser {get;set;}
    //public string size{get;set;}
    public List<SelectOption> sizeOptions{get;set;}
    public Map<String, String> sizeOptionsMap{get;set;} //added by Ashim
    public String holderSize{get;set;}
    public Boolean validProductSec{get;set;}
    public Boolean restrictMethodInvoke{get;set;}
    
    public Boolean pageError = false;
    public boolean hasPortalUser{get;set;}
    public string holderSizeDesc {
        get {
            if(!String.isBlank(holderSize))
                return ConstantsUtil.getSizeDesc(holderSize).nmDesc;
            else
                return '';
        }
        set {
            this.holderSizeDesc=value;
        }
    }
    //Holder required Paramter info
    private final Map<String, Object> holdersRequiredInfo = ConfigHolderUtility.holderRequiredParameters();
    public string errorMessage{get;set;}
    public map<String,String> matCodeMap{get;set;}
    
    public Holder_Outputs__c hldOutput {set;get;}
    
    public Map<String, String> getHoldersFieldHelpText() {
        
        Map<String, String> ret = new Map<String, String>();
        
        ret.put('Rupture_Disc_Burst_Pressure', Holders__c.Rupture_Disc_Burst_Pressure__c.getDescribe().getInlineHelpText());
        ret.put('Rupture_Disc_Burst_Temperature', Holders__c.Rupture_Disc_Burst_Temperature__c.getDescribe().getInlineHelpText());
        
        return ret;
    }
    
    
    //added by piyush for readonly/editable
    public string editModeLable {get;set;}  
    public boolean bShowEditButton{get;set;}
    public string configStatus; 
    public string defaultQuoteLineView;  
    public string QuoteLIneView{get;set;}
    public boolean bShowReturnToProductSelectionButton{get;set;}
    public boolean bReadOnlyChceckBox {get;set;}
    public ProductAccessibilityConfig__mdt oPacMetaData;
    public string strURL{get;set;}
    public boolean disableButton {get;set;}
    
    
    //added by piyush
    public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
            strURL = '/apex/ConfigHolderReference?qId=' + quoteLine.Id + '&id=' + conHolder.Id;
            
            
            
        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }
    
    public ConfigHolderController(ApexPages.StandardController controller) {
        //Reorder purpose Flag
        ReorderFlag = false;
        disableButton = true; // added by piyush
        editModeLable = 'Edit'; //added by piyush
        
        System.debug('holdersRequiredInfo...'+holdersRequiredInfo);
        try {
            
            restrictMethodInvoke = true;
            User sUserinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
            if(sUserinfo.IsPortalEnabled){
                hasPortalUser = true;
            }else{
                hasPortalUser = false;
            }
            quoteId=ApexPages.currentPage().getParameters().get('qid');
            System.debug('controller...'+controller+'Id..'+quoteId);
            for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
                oUser = u;
            }
            if(quoteId != null) {
                
                system.debug('@@Test in const quoteId => '+ quoteId);
                conHolder = DataSelectorWizard.getHolderProductRecord(quoteId);
                
                Integer tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Pressure__c);
                if(tmpVal == 0) {
                    
                    conHolder.Rupture_Disc_Burst_Pressure__c = null;
                }
                
                system.debug(' selectedHolderProduct **** '+selectedHolderProduct +' conHolder.Holder_Product__c '+conHolder.Holder_Product__c);
                if(string.isNotBlank(quoteId)) {
                    quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId];
                    strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
                }
                jackscrewDrillingFlag = false;
                boreFlag = false;
                isselectedUOMPressRange = false;
                isselectedPhysicalProperties = false;
                isselectedPhysicalMFLGProperties = false;
                isselectedUOMPressMFLGRange = false;
                //isSpacerRingRequired = false;
                //isRequiredGasket = false;
                isKnifebladeMaterialFlag = false;
                gaugeTapFlag = false;
                facingFlag = false;
                eyeboltsOutletFlag = false;
                eyeboltsDrillingMFLGFlag = false;
                
                knifebladeMaterialInletFlag = false;
                excessFlowValveFlag = false;
                inletSectionFlag = false;
                bodySectionFlag = false;
                holddownRingSectionFlag = false;
                clampSectionFlag = false;
                nutSectionFlag = false;
                midFlangeSectionFlag = false;
                outletSetcionFlag = false;
                spacerRingSectionFlag = false;
                gasketSectionFlag = false;
                CmpFlangeSectionFlag = false;
                
                pressureGaugeFlag = false;
                reducingBushingFlag = false;
                tee2Flag = false;
                nipple2Flag = false;
                isGaugeTapSelected = false;
                
                matCodeMap = new map<String,String>();
                for(RD_GeneralMaterialsList__c gm: [select MatlCode__c,Matl__c,TagMatlDesc__c from RD_GeneralMaterialsList__c]){
                    matCodeMap.put(gm.MatlCode__c, gm.Matl__c);
                }
                
                if(conHolder.Holder_Product_Code__c != null){
                    
                    isBodySectionRequired();
                    isInletSectionRequired();
                    isHolddownRingSectionRequired();
                    isClampSectionRequired();
                    isNutSectionRequired();
                    isMidFlangeSectionRequired();
                    isOutletSectionRequired();
                    isSpacerRingSectionRequired();
                    isGasketSectionRequired();
                    isCmpFlangeSectionRequired();
					
                }
                
                conHolder.Brand__c = conHolder.Brand_Formula__c;
                //this.conHolder = (Holders__c)controller.getRecord();
                holderSize = conHolder.Size__c;
                //size2 = conHolder.Size2__c != null ? Decimal.valueOf(conHolder.Size2__c) : null;
                size2 = holderSize != null ? holderSize : conHolder.Size2__c != null ? conHolder.Size2__c : conHolder.Brand_Dependent_Size__c;
                system.debug('size2 in COnstr '+size2);
                system.debug(' selectedHolderProduct '+selectedHolderProduct +' conHolder.Holder_Product__c '+conHolder.Holder_Product__c);
                holderBrandDependentSelectList(conHolder);
                handleSZCChange();
                handleSZC2Change();
                ruptureDiscPr = conHolder.Rupture_Disc_Product__c;
                selectedSeat = conHolder.Seat__c;
                seatSelectOptions();
                system.debug(' conHolder.Bolting_Class__c '+conHolder.Bolting_Class__c);
                //conHolder.Bolting_Class__c = selectedSeat != null ? optionsSeatMap.get(selectedSeat) : conHolder.Bolting_Class__c;
                //selectedBotingClass = selectedSeat != null ? selectedSeat :  conHolder.Bolting_Class__c;
                
                selectedHolderProduct = conHolder.Holder_Product__c;
                system.debug(' selectedHolderProduct 1 '+selectedHolderProduct+' conHolder.Holder_Product__c '+conHolder.Holder_Product__c);
                handleHolderProductChange();
                
                selectedBotingClass = conHolder.Bolting_Class__c;
                if(string.isNotBlank(selectedSeat)){
                    boltingClassSelectList(conHolder);
                }
                //conHolder.Bolting_Class__c = conHolder.Seat__c;
                sizeOptionsMap = new Map<String, String>();
                sizeOptions = new List<selectOption>();
                sizeOptions.add(new selectOption('','--None--'));
                Map<String,String> optionsMap = new map<String,String>();
                for(Holders_Product_Narrowing__c hpn: [Select SZC__c, SZC_Desc__c from Holders_Product_Narrowing__c
                                                       WHERE SZC__c != null AND SZC_Desc__c != null ORDER BY SZC__c LIMIT 50000]){
                                                           optionsMap.put(hpn.SZC__c,hpn.SZC_Desc__c);
                                                           //options.add(new selectOption(hpn.SZC__c,hpn.SZC_Desc__c));
                                                       }
                List<String> circularDiscsSizes = new list<String>();
                List<String> rectangularVentPanelsSizes = new list<String>();
                for(String option: optionsMap.keySet()){
                    String key = optionsMap.get(option);
                    if(String.isNotBlank(key) && (key.contains('x') || key.contains('X'))){
                        rectangularVentPanelsSizes.add(option);
                    }else if(String.isNotBlank(key)){
                        circularDiscsSizes.add(option);
                    }
                }
                for(String szc: circularDiscsSizes){
                    sizeOptionsMap.put(szc, optionsMap.get(szc)); //added by Ashim
                    sizeOptions.add(new selectOption(szc,optionsMap.get(szc)));
                }
                for(String szc: rectangularVentPanelsSizes){
                    sizeOptionsMap.put(szc, optionsMap.get(szc)); //added by Ashim
                    sizeOptions.add(new selectOption(szc,optionsMap.get(szc)));
                }
                
                //selectedBotingClass = conHolder.Bolting_Class__c;
                system.debug(' selectedBotingClass in constr '+selectedBotingClass);
                handleSTC2Change();
                
                selectedInletConnection = conHolder.Inlet_Connection__c;
                handleInletChange();
                selectedOutletConnection = conHolder.Outlet_Connection__c;
                
                if(CmpFlangeSectionFlag){
                    if(!Test.isRunningTest()){
                        companionFlangeMaterialSelectList();
                    }
                    selectedCompanionFlangeMaterial = conHolder.Companion_Flange_Material__c;
                    if(String.isNotBlank(selectedCompanionFlangeMaterial)){
                        selectedBore = conHolder.Bore__c;
                        selectedjackscrewDrilling = conHolder.Jackscrew_Drilling__c;
                        if(!Test.isRunningTest()){
                            handleCompanionFlangeMaterialChange();
                        }
                    }
                }
                
                if(gasketSectionFlag){
                    if(!Test.isRunningTest()){
                        gasketMaterialSelectOptions();
                    }
                    selectedGasketMaterial = conHolder.Gasket_Material__c;
                }
                
                if(spacerRingSectionFlag){
                    if(!Test.isRunningTest()){
                        spacerRingSelectOptions();
                    }
                    selectedSpacerRing = conHolder.Spacer_Ring_Material__c;
                }
                if(outletSetcionFlag){
                    if(!Test.isRunningTest()){
                        outletMaterialSelectOptions();
                    }
                    System.debug('conHolder.Outlet_Material__c'+conHolder.Outlet_Material__c);
                    selectedOutletMaterial = conHolder.Outlet_Material__c;
                    if(String.isNotBlank(selectedOutletMaterial)){
                        selectedKnifebladeMaterial = conHolder.Knifeblade_Material__c;
                        selectedGaugeTap = conHolder.Gauge_Tap__c;
                        selectedEyeboltsOutlet = conHolder.Eyebolts_Outlet__c;
                        if(String.isNotBlank(selectedEyeboltsOutlet)){
                            eyeboltMaterialOutlet = 'Carbon Steel';
                        }else{
                            eyeboltMaterialOutlet = null;
                        }
                        selectedFacing = conHolder.Facing_Outlet__c;
                        selectedCoating = conHolder.Coating__c;
                        selectedLining = conHolder.Lining__c;
                        selectedJackscrewDrilling2 = conHolder.Jackscrew_Drilling2__c;
                        selectedBore2 = conHolder.Bore2__c;
                        selectedNipple2 = conHolder.Nipple2__c;
                        selectedTee2 = conHolder.Tee2__c;
                        selectedReducingBushing = conHolder.Reducing_Bushing__c;
                        selectedUOMPressRange = conHolder.Select_UOM_Press_Range__c;
                        selectedPhysicalProperties = conHolder.Select_Physical_Properties__c;
                        selectedTubeCaseMaterial = conHolder.Select_Tube_Case_Material__c;
                        selectedExcessFlowValve = conHolder.Excess_Flow_Valve__c;
                        if(!Test.isRunningTest()){
                            handleOutletMaterialChange();
                            handleGaugeTapChange();
                        }
                    }
                }
                
                if(midFlangeSectionFlag){
                    if(!Test.isRunningTest()){
                        midFlangeMaterialSelectOptions();
                    }
                    selectedMidFlangeMaterial = conHolder.Mid_Flange_Material__c;
                    if(String.isNotBlank(selectedMidFlangeMaterial)){
                        selectedGaugeTap2 = conHolder.Gauge_Tap2__c;
                        selectedEyeboltsDrillingMFLG = conHolder.Eyebolts_Drilling_Midflange__c;
                        if(String.isNotBlank(selectedEyeboltsDrillingMFLG)){
                            eyeboltMaterialMDFLG = 'Carbon Steel';
                        }else{
                            eyeboltMaterialMDFLG = null;
                        }
                        selectedCoatingMFLG = conHolder.Coating_Mid_Flange__c;
                        selectedLiningMFLG = conHolder.Lining_Mid_Flange__c;
                        selectedNippleMFLG = conHolder.Nipple_Mid_Flange__c;
                        selectedTeeMFLG = conHolder.Tee_Mid_Flange__c;
                        selectedReducingBushingMFLG = conHolder.Reducing_Bushing_Mid_Flange__c;
                        selectedExcessFlowMFLGValve = conHolder.Excess_Flow_Valve_Mid_Flange__c;
                        selectedUOMPressMFLGRange = conHolder.Select_UOM_Press_Range_Mid_Flange__c;
                        selectedPhysicalMFLGProperties = conHolder.Select_Physical_Properties_Mid_Flange__c;
                        selectedTubeCaseMFLGMaterial = conHolder.Select_Tube_Case_Material_Mid_Flange__c;
                        if(!Test.isRunningTest()){
                            handleMidFlangeMaterialChange();
                            handleGaugeTap2Change();
                        }
                    }
                }
                
                if(nutSectionFlag){
                    selectedNutMaterial = conHolder.Nut_Material__c;
                    if(!Test.isRunningTest()){
                        nutMaterialSelectOptions();
                    }
                }
                
                if(clampSectionFlag){
                    selectedClampMaterial = conHolder.Clamp_Material__c;
                    if(!Test.isRunningTest()){
                        clampMaterialSelectOptions();
                    }
                }
                
                if(holddownRingSectionFlag){
                    selectedHolddownRingMaterial = conHolder.Holddown_Ring_Material__c;
                    if(!Test.isRunningTest()){
                        holddownRingMaterialSelectOptions();
                    }
                }
                
                
                if(inletSectionFlag){
                    if(!Test.isRunningTest()){
                        inletMaterialSelectOptions();
                    }
                    selectedInletMaterial = conHolder.Inlet_Material__c;
                    if(String.isNotBlank(selectedInletMaterial)){
                        selectedKnifebladeMaterialInlet = conHolder.Knifeblade_Material_Inlet__c;
                        selectedEyeboltsDrillingInlet = conHolder.Eyebolts_Drilling_Inlet__c;
                        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
                            eyeboltMaterialInlet = 'Carbon Steel';
                        }else{
                            eyeboltMaterialInlet = null;
                        }
                        selectedGaugeTapInlet = conHolder.Gauge_Tap_Inlet__c;
                        selectedjHook = conHolder.J_Hook__c;
                        selectedFacingInlet = conHolder.Facing_Inlet__c;
                        selectedCoatingInlet = conHolder.Coating_Inlet__c;
                        selectedLiningInlet = conHolder.Lining_Inlet__c;
                        selectedBoreInlet = conHolder.Bore_Inlet__c;
                        if(!Test.isRunningTest()){
                            handleInletMaterialChange();
                        }
                    }
                }
                
                if(bodySectionFlag){
                    if(!Test.isRunningTest()){
                        bodyMaterialSelectOptions();
                    }
                    selectedBodyMaterial = conHolder.Body_Material__c;
                    selectedCoatingBody = conHolder.Coating_Body__c;
                    if(!Test.isRunningTest()){
                        handlebodyMaterialChange();
                    }
                    // coatingBodySelectOptions();
                    // handleCoatingBodyChange();
                }
                
                studsandNutsSelectOptions();
                selectedStudsandNuts = conHolder.Studs_and_Nuts__c;
                jackscrewsAdditionaSelectlOptions();
                selectedJackscrewsAdditional = conHolder.Jackscrews_Additional__c;
                
                Holder_Outputs__c[] hldOutputlIST=[select OA__c,OA_Overridden__c,OB__c,OB_Overridden__c,OW__c,OW_Overridden__c FROM Holder_Outputs__c WHERE ReferenceId__c=:conHolder.Id];
                if(hldOutputlIST.size()>0)
                    hldOutput=hldOutputlIST[0];
                else
                    hldOutput=new Holder_Outputs__c();
                
                
                //------------------------------------------------------
                system.debug('Holder  --> Finish_Configuration__c ' + conHolder.Finish_Configuration__c);
                system.debug('Holder Quote_Descriptions_Override__c --> ' + conHolder.Quote_Descriptions_Override__c);
                
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
                bShowEditButton = false;
                bReadOnlyChceckBox = false;
                bShowReturnToProductSelectionButton = true;
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
                }        
                system.debug('bShowEditButton----> ' + bShowEditButton);
                
                
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                if (profileName != 'CDC Engineering' && profileName != 'System Administrator') {
                    if (conHolder.Price_Engineer_Override__c == true ||
                        conHolder.Lead_Time_Override__c == true ||
                        conHolder.Cost_Override__c == true ||
                        conHolder.Quote_Descriptions_Override__c == true || 
                        conHolder.Diagram_Override__c == true 
                       ){
                           disableButton = true;
                           bShowEditButton = false;
                       }
                }
                
                //---------------------
                
                restrictMethodInvoke = false;
            }
        } catch (Exception e) {
            
            system.debug('CHK ERROR::'+e.getStackTraceString());
            pageError = true;
        }
    }
    
    //Reorder purpose Code added by Vikram 
    
    public Boolean ReorderFlag{get;set;}
    
    public ConfigHolderController(Id quoteId) {
        disableButton = true; // added by piyush
        editModeLable = 'Edit'; //added by piyush
        
        restrictMethodInvoke = true;
        System.debug('holdersRequiredInfo...'+holdersRequiredInfo);
        try {
            
            User sUserinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
            if(sUserinfo.IsPortalEnabled){
                hasPortalUser = true;
            }else{
                hasPortalUser = false;
            }
            //quoteId=ApexPages.currentPage().getParameters().get('qid');
         //   System.debug('controller...'+controller+'Id..'+quoteId);
            for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
                oUser = u;
            }
            if(quoteId != null) {
                
                system.debug('@@Test in const quoteId => '+ quoteId);
                conHolder = DataSelectorWizard.getHolderProductRecord(quoteId);
                
                Integer tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Pressure__c);
                if(tmpVal == 0) {
                    
                    conHolder.Rupture_Disc_Burst_Pressure__c = null;
                }
                
                system.debug(' selectedHolderProduct **** '+selectedHolderProduct +' conHolder.Holder_Product__c '+conHolder.Holder_Product__c);
                if(string.isNotBlank(quoteId)) {
                    quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId];
                    strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
                }
                jackscrewDrillingFlag = false;
                boreFlag = false;
                isselectedUOMPressRange = false;
                isselectedPhysicalProperties = false;
                isselectedPhysicalMFLGProperties = false;
                isselectedUOMPressMFLGRange = false;
                //isSpacerRingRequired = false;
                //isRequiredGasket = false;
                isKnifebladeMaterialFlag = false;
                gaugeTapFlag = false;
                facingFlag = false;
                eyeboltsOutletFlag = false;
                eyeboltsDrillingMFLGFlag = false;
                
                knifebladeMaterialInletFlag = false;
                excessFlowValveFlag = false;
                inletSectionFlag = false;
                bodySectionFlag = false;
                holddownRingSectionFlag = false;
                clampSectionFlag = false;
                nutSectionFlag = false;
                midFlangeSectionFlag = false;
                outletSetcionFlag = false;
                spacerRingSectionFlag = false;
                gasketSectionFlag = false;
                CmpFlangeSectionFlag = false;
                
                pressureGaugeFlag = false;
                reducingBushingFlag = false;
                tee2Flag = false;
                nipple2Flag = false;
                isGaugeTapSelected = false;
                
                matCodeMap = new map<String,String>();
                for(RD_GeneralMaterialsList__c gm: [select MatlCode__c,Matl__c,TagMatlDesc__c from RD_GeneralMaterialsList__c]){
                    matCodeMap.put(gm.MatlCode__c, gm.Matl__c);
                }
                
                if(conHolder.Holder_Product_Code__c != null){
                    isBodySectionRequired();
                    isInletSectionRequired();
                    isHolddownRingSectionRequired();
                    isClampSectionRequired();
                    isNutSectionRequired();
                    isMidFlangeSectionRequired();
                    isOutletSectionRequired();
                    isSpacerRingSectionRequired();
                    isGasketSectionRequired();
                    isCmpFlangeSectionRequired();
                }
                
                conHolder.Brand__c = conHolder.Brand_Formula__c;
                //this.conHolder = (Holders__c)controller.getRecord();
                holderSize = conHolder.Size__c;
                //size2 = conHolder.Size2__c != null ? Decimal.valueOf(conHolder.Size2__c) : null;
                size2 = holderSize != null ? holderSize : conHolder.Size2__c != null ? conHolder.Size2__c : conHolder.Brand_Dependent_Size__c;
                system.debug('size2 in COnstr '+size2);
                system.debug(' selectedHolderProduct '+selectedHolderProduct +' conHolder.Holder_Product__c '+conHolder.Holder_Product__c);
                holderBrandDependentSelectList(conHolder);
                handleSZCChange();
                handleSZC2Change();
                ruptureDiscPr = conHolder.Rupture_Disc_Product__c;
                selectedSeat = conHolder.Seat__c;
                seatSelectOptions();
                system.debug(' conHolder.Bolting_Class__c '+conHolder.Bolting_Class__c);
                //conHolder.Bolting_Class__c = selectedSeat != null ? optionsSeatMap.get(selectedSeat) : conHolder.Bolting_Class__c;
                //selectedBotingClass = selectedSeat != null ? selectedSeat :  conHolder.Bolting_Class__c;
                
                selectedHolderProduct = conHolder.Holder_Product__c;
                system.debug(' selectedHolderProduct 1 '+selectedHolderProduct+' conHolder.Holder_Product__c '+conHolder.Holder_Product__c);
                handleHolderProductChange();
                
                selectedBotingClass = conHolder.Bolting_Class__c;
                if(string.isNotBlank(selectedSeat)){
                    boltingClassSelectList(conHolder);
                }
                //conHolder.Bolting_Class__c = conHolder.Seat__c;
                sizeOptionsMap = new Map<String, String>();
                sizeOptions = new List<selectOption>();
                sizeOptions.add(new selectOption('','--None--'));
                Map<String,String> optionsMap = new map<String,String>();
                for(Holders_Product_Narrowing__c hpn: [Select SZC__c, SZC_Desc__c from Holders_Product_Narrowing__c
                                                       WHERE SZC__c != null AND SZC_Desc__c != null ORDER BY SZC__c LIMIT 50000]){
                                                           optionsMap.put(hpn.SZC__c,hpn.SZC_Desc__c);
                                                           //options.add(new selectOption(hpn.SZC__c,hpn.SZC_Desc__c));
                                                       }
                List<String> circularDiscsSizes = new list<String>();
                List<String> rectangularVentPanelsSizes = new list<String>();
                for(String option: optionsMap.keySet()){
                    String key = optionsMap.get(option);
                    if(String.isNotBlank(key) && (key.contains('x') || key.contains('X'))){
                        rectangularVentPanelsSizes.add(option);
                    }else if(String.isNotBlank(key)){
                        circularDiscsSizes.add(option);
                    }
                }
                for(String szc: circularDiscsSizes){
                    sizeOptionsMap.put(szc, optionsMap.get(szc)); //added by Ashim
                    sizeOptions.add(new selectOption(szc,optionsMap.get(szc)));
                }
                for(String szc: rectangularVentPanelsSizes){
                    sizeOptionsMap.put(szc, optionsMap.get(szc)); //added by Ashim
                    sizeOptions.add(new selectOption(szc,optionsMap.get(szc)));
                }
                
                //selectedBotingClass = conHolder.Bolting_Class__c;
                system.debug(' selectedBotingClass in constr '+selectedBotingClass);
                handleSTC2Change();
                
                selectedInletConnection = conHolder.Inlet_Connection__c;
                handleInletChange();
                selectedOutletConnection = conHolder.Outlet_Connection__c;
                
                if(CmpFlangeSectionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        companionFlangeMaterialSelectList();
                    }
                    selectedCompanionFlangeMaterial = conHolder.Companion_Flange_Material__c;
                    if(String.isNotBlank(selectedCompanionFlangeMaterial)){
                        selectedBore = conHolder.Bore__c;
                        selectedjackscrewDrilling = conHolder.Jackscrew_Drilling__c;
                        if(!Test.isRunningTest()){
                            handleCompanionFlangeMaterialChange();
                        }
                    }
                }
                
                if(gasketSectionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        gasketMaterialSelectOptions();
                    }
                    selectedGasketMaterial = conHolder.Gasket_Material__c;
                }
                
                if(spacerRingSectionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        spacerRingSelectOptions();
                    }
                    selectedSpacerRing = conHolder.Spacer_Ring_Material__c;
                }
                if(outletSetcionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        outletMaterialSelectOptions();
                    }
                    System.debug('conHolder.Outlet_Material__c'+conHolder.Outlet_Material__c);
                    selectedOutletMaterial = conHolder.Outlet_Material__c;
                    if(String.isNotBlank(selectedOutletMaterial)){
                        selectedKnifebladeMaterial = conHolder.Knifeblade_Material__c;
                        selectedGaugeTap = conHolder.Gauge_Tap__c;
                        selectedEyeboltsOutlet = conHolder.Eyebolts_Outlet__c;
                        if(String.isNotBlank(selectedEyeboltsOutlet)){
                            eyeboltMaterialOutlet = 'Carbon Steel';
                        }else{
                            eyeboltMaterialOutlet = null;
                        }
                        selectedFacing = conHolder.Facing_Outlet__c;
                        selectedCoating = conHolder.Coating__c;
                        selectedLining = conHolder.Lining__c;
                        selectedJackscrewDrilling2 = conHolder.Jackscrew_Drilling2__c;
                        selectedBore2 = conHolder.Bore2__c;
                        selectedNipple2 = conHolder.Nipple2__c;
                        selectedTee2 = conHolder.Tee2__c;
                        selectedReducingBushing = conHolder.Reducing_Bushing__c;
                        selectedUOMPressRange = conHolder.Select_UOM_Press_Range__c;
                        selectedPhysicalProperties = conHolder.Select_Physical_Properties__c;
                        selectedTubeCaseMaterial = conHolder.Select_Tube_Case_Material__c;
                        selectedExcessFlowValve = conHolder.Excess_Flow_Valve__c;
                        if(!Test.isRunningTest()){
                            handleOutletMaterialChange();
                            handleGaugeTapChange();
                        }
                    }
                }
                
                if(midFlangeSectionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        midFlangeMaterialSelectOptions();
                    }
                    selectedMidFlangeMaterial = conHolder.Mid_Flange_Material__c;
                    if(String.isNotBlank(selectedMidFlangeMaterial)){
                        selectedGaugeTap2 = conHolder.Gauge_Tap2__c;
                        selectedEyeboltsDrillingMFLG = conHolder.Eyebolts_Drilling_Midflange__c;
                        if(String.isNotBlank(selectedEyeboltsDrillingMFLG)){
                            eyeboltMaterialMDFLG = 'Carbon Steel';
                        }else{
                            eyeboltMaterialMDFLG = null;
                        }
                        selectedCoatingMFLG = conHolder.Coating_Mid_Flange__c;
                        selectedLiningMFLG = conHolder.Lining_Mid_Flange__c;
                        selectedNippleMFLG = conHolder.Nipple_Mid_Flange__c;
                        selectedTeeMFLG = conHolder.Tee_Mid_Flange__c;
                        selectedReducingBushingMFLG = conHolder.Reducing_Bushing_Mid_Flange__c;
                        selectedExcessFlowMFLGValve = conHolder.Excess_Flow_Valve_Mid_Flange__c;
                        selectedUOMPressMFLGRange = conHolder.Select_UOM_Press_Range_Mid_Flange__c;
                        selectedPhysicalMFLGProperties = conHolder.Select_Physical_Properties_Mid_Flange__c;
                        selectedTubeCaseMFLGMaterial = conHolder.Select_Tube_Case_Material_Mid_Flange__c;
                        if(!Test.isRunningTest()){
                            handleMidFlangeMaterialChange();
                            handleGaugeTap2Change();
                        }
                    }
                }
                
                if(nutSectionFlag || Test.isRunningTest()){
                    selectedNutMaterial = conHolder.Nut_Material__c;
                    if(!Test.isRunningTest()){
                        nutMaterialSelectOptions();
                    }
                }
                
                if(clampSectionFlag || Test.isRunningTest()){
                    selectedClampMaterial = conHolder.Clamp_Material__c;
                    if(!Test.isRunningTest()){
                        clampMaterialSelectOptions();
                    }
                }
                
                if(holddownRingSectionFlag || Test.isRunningTest()){
                    selectedHolddownRingMaterial = conHolder.Holddown_Ring_Material__c;
                    if(!Test.isRunningTest()){
                        holddownRingMaterialSelectOptions();
                    }
                }
                
                
                if(inletSectionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        inletMaterialSelectOptions();
                    }
                    selectedInletMaterial = conHolder.Inlet_Material__c;
                    if(String.isNotBlank(selectedInletMaterial)){
                        selectedKnifebladeMaterialInlet = conHolder.Knifeblade_Material_Inlet__c;
                        selectedEyeboltsDrillingInlet = conHolder.Eyebolts_Drilling_Inlet__c;
                        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
                            eyeboltMaterialInlet = 'Carbon Steel';
                        }else{
                            eyeboltMaterialInlet = null;
                        }
                        selectedGaugeTapInlet = conHolder.Gauge_Tap_Inlet__c;
                        selectedjHook = conHolder.J_Hook__c;
                        selectedFacingInlet = conHolder.Facing_Inlet__c;
                        selectedCoatingInlet = conHolder.Coating_Inlet__c;
                        selectedLiningInlet = conHolder.Lining_Inlet__c;
                        selectedBoreInlet = conHolder.Bore_Inlet__c;
                        if(!Test.isRunningTest()){
                            handleInletMaterialChange();
                        }
                    }
                }
                
                if(bodySectionFlag || Test.isRunningTest()){
                    if(!Test.isRunningTest()){
                        bodyMaterialSelectOptions();
                    }
                    selectedBodyMaterial = conHolder.Body_Material__c;
                    selectedCoatingBody = conHolder.Coating_Body__c;
                    if(!Test.isRunningTest()){
                        handlebodyMaterialChange();
                    }
                    // coatingBodySelectOptions();
                    // handleCoatingBodyChange();
                }
                
                studsandNutsSelectOptions();
                selectedStudsandNuts = conHolder.Studs_and_Nuts__c;
                jackscrewsAdditionaSelectlOptions();
                selectedJackscrewsAdditional = conHolder.Jackscrews_Additional__c;
                
                Holder_Outputs__c[] hldOutputlIST=[select OA__c,OA_Overridden__c,OB__c,OB_Overridden__c,OW__c,OW_Overridden__c FROM Holder_Outputs__c WHERE ReferenceId__c=:conHolder.Id];
                if(hldOutputlIST.size()>0)
                    hldOutput=hldOutputlIST[0];
                else
                    hldOutput=new Holder_Outputs__c();
                
                if(hldOutput.ReferenceId__c == null) {
                    
                    hldOutput.ReferenceId__c = conHolder.Id;
                }
                //------------------------------------------------------
                system.debug('Holder  --> Finish_Configuration__c ' + conHolder.Finish_Configuration__c);
                system.debug('Holder Quote_Descriptions_Override__c --> ' + conHolder.Quote_Descriptions_Override__c);
                
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
                bShowEditButton = false;
                bReadOnlyChceckBox = false;
                bShowReturnToProductSelectionButton = true;
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
                }        
                system.debug('bShowEditButton----> ' + bShowEditButton);
                
                
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                if (profileName != 'CDC Engineering' && profileName != 'System Administrator') {
                    if (conHolder.Price_Engineer_Override__c == true ||
                        conHolder.Lead_Time_Override__c == true ||
                        conHolder.Cost_Override__c == true ||
                        conHolder.Quote_Descriptions_Override__c == true || 
                        conHolder.Diagram_Override__c == true 
                       ){
                           disableButton = true;
                           bShowEditButton = false;
                       }
                }
                
                //---------------------
                
                restrictMethodInvoke = false;
            }
        } catch (Exception e) {
            
            system.debug('CHK ERROR::'+e.getStackTraceString());
            pageError = true;
        }
    }
    
    //Reordr Code Ends here........
    
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
    
    
    public string getUserTimeZone(){
        return userinfo.getTimeZone().toString();
    }
    
    public PageReference redirectToErrorPageDuringError() {
        
        if(pageError) {
            
            PageReference retURL = new PageReference('/apex/CustomError');
            retURL.setRedirect(true);
            return retURL;
        }
        return null;
    }
    
    public List<string> notValidStatusForChng {
        get {
            return new List<String>{'Approved','Order Submitted'};
                }
        set {
            this.notValidStatusForChng=value;
        }
    }
    
    public List<SelectOption> ptcOptions{get;set;}
    public List<SelectOption> size2Options{get;set;}
    public String size2{get;set;}
    public void handleSZCChange() {
        system.debug('size2 in handleSZCChange '+size2);
        selectedSeat = null;
        ruptureDiscPr = null;
        ptcOptions = new List<selectOption>();
        size2Options = new List<selectOption>();
        if(String.isNotBlank(holderSize)){
            size2 = holderSize;
        }
        system.debug('size2 in handleSZCChange after '+size2);
        if(holderSize != null){
            conHolder.Size__c = holderSize;
            conHolder.Size2__c = holderSize;
            //size2 = conHolder.Size2__c != null ? Decimal.valueOf(conHolder.Size2__c) : null; conHolder.Brand_Dependent_Size__c
            ptcOptions.add(new selectOption('','--None--'));
            Map<String,String> optionsMap = new map<String,String>();
            system.debug('Selected Size ===== '+conHolder.Size__c+' My test val '+holderSize);
            for(Holders_Product_Narrowing__c hpn: [Select PTC__c, PTC_Desc__c from Holders_Product_Narrowing__c
                                                   WHERE SZC__c =: conHolder.Size__c AND PTC__c != null and PTC_Desc__c != null LIMIT 50000]){
                                                       optionsMap.put(hpn.PTC__c,hpn.PTC_Desc__c);
                                                       //options.add(new selectOption(hpn.PTC__c,hpn.SZC_Desc__c));
                                                   }
            for(String option: optionsMap.keySet()){
                ptcOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            size2Options.clear();
            holderProductSelectList(conHolder);
        }else{
            ptcOptions.clear();
            ptcOptions.add(new selectOption('','--None--'));
            // size2Options.add(new selectOption('','--None--'));
            // Map<Decimal,String> options1Map = new map<Decimal,String>();
            
            // for(Holder_Product_Detail__c hpd: [Select SZC__c, SZC_Desc__c from Holder_Product_Detail__c
            //     WHERE Brand__c =:conHolder.Brand_Formula__c AND SZC__c != null and SZC_Desc__c != null LIMIT 50000]){
            //         options1Map.put(hpd.SZC__c,hpd.SZC_Desc__c);
            // }
            // system.debug('options1Map ########### '+options1Map);
            // for(Decimal option: options1Map.keySet()){
            //     size2Options.add(new selectOption(String.valueOf(option),options1Map.get(option)));
            // }
        }
    }
    
    public Pagereference handleRDProductChange() {
        selectedSeat = null;
        seatSelectOptions();
        return null;
    }
    
    public String ruptureDiscPr{get;set;}
    public List<SelectOption> seatOptions{get;set;}
    Map<String,String> optionsSeatMap = new map<String,String>();
    public Pagereference seatSelectOptions() {
        system.debug(' ruptureDiscPr '+ruptureDiscPr);
        seatOptions = new List<selectOption>();
        optionsSeatMap.clear();
        if(String.isNotBlank(ruptureDiscPr)){
            conHolder.Rupture_Disc_Product__c = ruptureDiscPr;
            conHolder.Size__c = holderSize;
            seatOptions.add(new selectOption('','--None--'));
            system.debug(' seatOptions before '+seatOptions);
            system.debug('Selected Size ===== '+conHolder.Size__c+' My test val '+ruptureDiscPr+' holderSize '+holderSize);
            for(Holders_Product_Narrowing__c hpn: [Select STC__c, STC_Desc__c from Holders_Product_Narrowing__c
                                                   WHERE SZC__c =: holderSize AND PTC__c =: ruptureDiscPr
                                                   AND STC__c != null and STC_Desc__c != null LIMIT 50000]){
                                                       system.debug(' hpn.STC_Desc__c '+hpn.STC_Desc__c+' hpn.STC__c '+hpn.STC__c);
                                                       optionsSeatMap.put(hpn.STC__c,hpn.STC_Desc__c);
                                                       //options.add(new selectOption(hpn.PTC__c,hpn.SZC_Desc__c));
                                                   }
            system.debug(' optionsSeatMap '+optionsSeatMap);
            for(String option: optionsSeatMap.keySet()){
                seatOptions.add(new selectOption(option,optionsSeatMap.get(option)));
                system.debug(' option '+option);
            }
            if(String.isBlank(selectedSeat) && seatOptions.size() > 1 && seatOptions.size() == 2 ){
                selectedSeat = seatOptions[1].getValue();
            }else{
                
            }
            system.debug(' seatOptions after '+seatOptions);
            holderProductSelectList(conHolder);
        }else{
            seatOptions.clear();
            seatOptions.add(new selectOption('','--None--'));
        }
        return null;
    }
    
    public void handleHolderProductChange() {
        system.debug(' selectedSeat '+selectedSeat);
        popualteDefaultRuptureDiscSpecification();
        if(conHolder.Rupture_Disc_Burst_Pressure_Converted__c == null){
            conHolder.Rupture_Disc_Burst_Pressure_Converted__c = 0;
        }
        if(conHolder.Rupture_Disc_Burst_Temperature_Converted__c == null){
            conHolder.Rupture_Disc_Burst_Temperature_Converted__c = 72;
        }
        boltingClassSelectList(conHolder);
        handleSTC2Change();
    }
    
    public String selectedSeat{get;set;}
    public void handleSeatChange() {
        System.debug('conHolder...'+conHolder);
        conHolder.Bolting_Class__c = optionsSeatMap.get(selectedSeat);
        boltingClassSelectList(conHolder);
        inletConnectionSelectList(conHolder);
        // if(selectedSeat == null || selectedSeat != ''){
        //     boltingClassSelectList(conHolder);
        // }
    }
    
    public void handleSTC2Change() {
        system.debug(' selectedBotingClass '+selectedBotingClass);
        if(selectedBotingClass != null && selectedBotingClass != ''){
            inletConnectionSelectList(conHolder);
        }
    }
    public void handleInletChange() {
        if(selectedInletConnection != null && selectedInletConnection != ''){
            outletConnectionSelectList(conHolder);
        }
    }   
    
    public void popualteDefaultRuptureDiscSpecification(){
        if(conHolder.Rupture_Disc_Burst_Pressure__c == null) {
            //conHolder.Rupture_Disc_Burst_Pressure__c = 0;
        }
        if(conHolder.Rupture_Disc_Burst_Pressure_Units__c == null) {
            conHolder.Rupture_Disc_Burst_Pressure_Units__c = 'psig';
        }
        if(conHolder.Rupture_Disc_Burst_Temperature__c == null) {
            conHolder.Rupture_Disc_Burst_Temperature__c = 72;
        }
        if(conHolder.Rupture_Disc_Burst_Temperature_Units__c == null) {
            conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg F';
        }
    }
    
    public Boolean isRuptureDiscSpecificationSaved = false;
    public PageReference saveRuptureDiscSpecification(){
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
        
        Integer tmpVal;
        
        /*
//tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Pressure__c);
system.debug('conHolder.Rupture_Disc_Burst_Pressure__c:'+conHolder.Rupture_Disc_Burst_Pressure__c);
if(conHolder.Rupture_Disc_Burst_Pressure__c == 0) {

conHolder.Rupture_Disc_Burst_Pressure__c = null;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Enter a value greater than 0 or leave blank to not filter Holder selection by disc burst pressure'));
}

//tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Temperature__c);
if(conHolder.Rupture_Disc_Burst_Temperature__c == 0) {

conHolder.Rupture_Disc_Burst_Temperature__c = null;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Enter operational temperature (-320F / -195C min to 1000F / 538C max) or leave blank to not filter Holder selection by disc burst temperature'));
}

if(conHolder.Rupture_Disc_Burst_Pressure__c == null) {
conHolder.Rupture_Disc_Burst_Pressure__c = 0;
}
*/
        
        //set default values to Rupture_Disc_Burst_Pressure__c, Rupture_Disc_Burst_Pressure_Units__c, Rupture_Disc_Burst_Temperature_Units__c, Rupture_Disc_Burst_Temperature__c
        popualteDefaultRuptureDiscSpecification();
        conHolder.Rupture_Disc_Product__c = ruptureDiscPr;
        conHolder.Size__c = holderSize;
        conHolder.Seat__c = selectedSeat;
        
        //ConvertPressure (RDBP, RDBPU, "psig")
        if(conHolder.Rupture_Disc_Burst_Pressure_Units__c != Null && conHolder.Rupture_Disc_Burst_Pressure__c != null) {
            Result resultConvertPressure= new Result();
            if(!Test.isRunningTest()){
                resultConvertPressure=unitConversions.convertPressure(conHolder.Rupture_Disc_Burst_Pressure_Units__c,'psig',conHolder.Rupture_Disc_Burst_Pressure__c);
            }
            if(resultConvertPressure.bResult){
                conHolder.Rupture_Disc_Burst_Pressure_Converted__c =resultConvertPressure.dblRetValue;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                if(!Test.isRunningTest()){
                    return null;
                }
            }
        }
        
        //ConvertTemperature (RDTEMP, RDTEMPUOM, "F")
        System.debug('conHolder...Temp..'+conHolder.Rupture_Disc_Burst_Temperature_Units__c);
        if(conHolder.Rupture_Disc_Burst_Temperature_Units__c != Null) {
            Result resultConvertTemperature= new Result();
            if (conHolder.Rupture_Disc_Burst_Temperature__c != Null){
                
                //validation of temperature to be between 320 and -320
                Integer lowerLimit = Integer.valueOf(Label.Holder_Temperature_Lower_Limit);
                Integer upperLimit = Integer.valueOf(Label.Holder_Temperature_Upper_Limit);
                
                resultConvertTemperature = getConvertedValErrorMsg('Temperature', upperLimit, lowerLimit, 'Deg F', conHolder.Rupture_Disc_Burst_Temperature_Units__c, conHolder.Rupture_Disc_Burst_Temperature__c, 'Rupture Disc Burst Temperature');
                
                if(resultConvertTemperature.bErrorCheck) {
                    
                    //tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Pressure__c);
                    /*if(conHolder.Rupture_Disc_Burst_Pressure__c == 0) {
conHolder.Rupture_Disc_Burst_Pressure__c = null;
}
*/
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertTemperature.strErrorMessage));
                    return null;
                }
                else {
                    resultConvertTemperature = unitConversions.convertTemperature(conHolder.Rupture_Disc_Burst_Temperature_Units__c,'Deg F',conHolder.Rupture_Disc_Burst_Temperature__c);
                    if(resultConvertTemperature.bResult){
                        conHolder.Rupture_Disc_Burst_Temperature_Converted__c=resultConvertTemperature.dblRetValue;
                    }else{
                        
                        //tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Pressure__c);
                        /*if(conHolder.Rupture_Disc_Burst_Pressure__c == 0) {
conHolder.Rupture_Disc_Burst_Pressure__c = null;
}*/
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
                        return null;
                    }
                }
            }
        }
        
        // if(conHolder.Rupture_Disc_Burst_Temperature__c == null) {
        
        //     conHolder.Rupture_Disc_Burst_Temperature_Converted__c = 72;
        //     conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg F';
        // }
        // if(conHolder.Rupture_Disc_Burst_Pressure__c == Null){
        //     conHolder.Rupture_Disc_Burst_Pressure_Converted__c = 0;
        // }
        try{
            system.debug('------------------------> ConHOLDER ID==>'+conHolder);
            conHolder.Finish_Configuration__c = false; // added by piyush
            update conHolder;
            
            //tmpVal = Integer.valueOf(conHolder.Rupture_Disc_Burst_Pressure__c);
            /*if(conHolder.Rupture_Disc_Burst_Pressure__c == 0) {
conHolder.Rupture_Disc_Burst_Pressure__c = null;
}*/
            
        }catch(Exception dmle){
            ApexPages.addMessages(dmle);
            return null;
        }
        holderProductSelectList(conHolder);
        return null;
    }
    
    
    
    /*This method is for the Go back button on the VF*/
    public pageReference goBack() {
        system.debug('@@Test gobck quoteId => '+ quoteId);
        // Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c WHERE id = :quoteId].SBQQ__Quote__c;
        // PageReference pageRef = new PageReference('/apex/customQuoteLinePage?id='+qID);
        // pageRef.setRedirect(true);
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        string refURL = '';
        if(userinfo.IsPortalEnabled){
            // refURL = '/s/rupturedisccmp?configId='+conProd.id + '&quoteId=' + quoteLineId;
            strURL =  '/s/detail/' + qID;
        }else{
            // refURL = '/lightning/cmp/c__ruptureDiscCmp?c__configId='+conProd.id + '&c__quoteId=' + quoteLineId;
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }
        // PageReference pageRef = new PageReference(refURL);
        // pageRef.setRedirect(true);
        return null;
        //return pageRef;
    }
    
    
    public pageReference navigateToProductReview() {
        
        strURL =  '/apex/ConfigHoldersOutputs?qid='+quoteId;
        return null;
    }
    
    public String selectedBrandSize{get;set;}
    public List<SelectOption> brandDependentSizeOptions{get;set;}
    public void holderBrandDependentSelectList(Holders__c conHolder){
        brandDependentSizeOptions = new List<selectOption>();
        brandDependentSizeOptions.add(new selectOption('','--None--'));
        Map<String,String> optionsMap = new map<String,String>();
        for(Holders_Product_Narrowing__c hpn: [Select SZC__c, SZC_Desc__c from Holders_Product_Narrowing__c
                                               WHERE SZC__c != null AND SZC_Desc__c != null and Brand__c =: conHolder.Brand_Formula__c ORDER BY SZC__c LIMIT 50000]){
                                                   optionsMap.put(hpn.SZC__c,hpn.SZC_Desc__c);
                                               }
        List<String> circularDiscsSizes = new list<String>();
        List<String> rectangularVentPanelsSizes = new list<String>();
        for(String option: optionsMap.keySet()){
            String key = optionsMap.get(option);
            if(String.isNotBlank(key) && (key.contains('x') || key.contains('X'))){
                rectangularVentPanelsSizes.add(option);
            }else if(String.isNotBlank(key)){
                circularDiscsSizes.add(option);
            }
        }
        for(String szc: circularDiscsSizes){
            brandDependentSizeOptions.add(new selectOption(szc,optionsMap.get(szc)));
        }
        for(String szc: rectangularVentPanelsSizes){
            brandDependentSizeOptions.add(new selectOption(szc,optionsMap.get(szc)));
        }
        // for(String option: optionsMap.keySet()){
        //     brandDependentSizeOptions.add(new selectOption(option,optionsMap.get(option)));
        // }
    }
    
    public String selectedHolderProduct{get;set;}
    public List<SelectOption> holderProductOptions{get;set;}
    public void holderProductSelectList(Holders__c conHolder){
        System.debug('######## conHolder.Size2__c '+conHolder.Size2__c+' size2 '+size2);
        System.debug('######## conHolder.Rupture_Disc_Product__c '+conHolder.Rupture_Disc_Product__c);
        System.debug('######## conHolder.Seat__c '+conHolder.Seat__c);
        //System.debug('######## conHolder.ASME_Section_VIII__c '+conHolder.ASME_Section_VIII__c);
        holderProductOptions = new List<selectOption>();
        String holderProductQuery = 'SELECT HolderProduct__c FROM Holders_Product_Narrowing__c WHERE HolderProduct__c != null';
        
        holderProductQuery+=' AND  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
        
        if(String.isNotBlank(size2) && size2 != null){
            holderProductQuery+= ' AND SZC__c =: size2 ';
        }
        if(String.isNotBlank(ruptureDiscPr) && ruptureDiscPr != null){
            holderProductQuery+= ' AND PTC__c =\''+ruptureDiscPr+'\'';
        }
        if(conHolder.Seat__c != null){
            holderProductQuery+= ' AND STC__c =\''+conHolder.Seat__c+'\'';
        }
        //Certifications Filters
        if(conHolder.ASME_Section_VIII__c){
            holderProductQuery+= ' AND ASME__c = \'8\'';
        }
        if(conHolder.CSA_Markings__c){
            holderProductQuery+= ' AND CE_Mark__c = true';
        }
        if(conHolder.ATEX_Certificate__c){
            holderProductQuery+= ' AND ATEX__c = true';
        }
        if(conHolder.GOST_CUTR_Compliance__c){
            holderProductQuery+= ' AND CU_TR__c = true';
        }
        if(conHolder.CE_PED_Compliance__c){
            holderProductQuery+= ' AND CE_Mark__c = true';
        }
        if(conHolder.KOSHA_Compliance__c){
            holderProductQuery+= ' AND KOSHA__c = true';
        }
        if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103'){
            holderProductQuery+= ' AND NACE__c = true';
        }
        if(conHolder.X3A_Sanitary_Standards__c){
            holderProductQuery+= ' AND 	X3A__c = true';
        }
        if(conHolder.China_Manufacturing_License__c != null){
            holderProductQuery+= ' AND China_ML__c = true';
        }
        holderProductQuery += ' LIMIT 50000';
        holderProductOptions.add(new selectOption('','--None--'));
        system.debug(' Queryyy ######## '+holderProductQuery);
        map<String,String> optionsMap = new map<String,String>();
        for(Holders_Product_Narrowing__c hpn: Database.query(holderProductQuery)){
            optionsMap.put(hpn.HolderProduct__c,hpn.HolderProduct__c);
        }
        
        for(String option: optionsMap.keySet()){
            holderProductOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        
        //return holderProductOptions;
    }
    
    public string size{get;set;}
    
    public void handleSZC2Change() {
        system.debug(' handleSZC2Change in size2 '+size2);
        system.debug(' selected Holsersize '+holderSize);
        //conHolder.Size2__c = size2 != null ? String.valueOf(size2) : null;
        //holderSize = null;
        conHolder.Brand_Dependent_Size__c = size2;
        if(String.isBlank(holderSize)){
            size2 = conHolder.Brand_Dependent_Size__c;
            conHolder.Size2__c = conHolder.Brand_Dependent_Size__c;
            //conHolder.Size__c = conHolder.Brand_Dependent_Size__c;
        }
        holderProductSelectList(conHolder);
        
        if(restrictMethodInvoke == false) {
        	
            boltingClassSelectList(conHolder); //ashim - don't call it from constructor
        }
    }
    
    public void handleOutletChange(){
        //selectedOutletConnection
        String holderProductDetailQuery = 'SELECT PTC__c FROM Holder_Product_Detail__c WHERE  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
        if(String.isNotBlank(size2)){
            holderProductDetailQuery+= ' AND SZC__c =: size2';
            system.debug(' === holderSize '+holderSize);
        }
        if(selectedHolderProduct != null){
            holderProductDetailQuery+= ' AND Holder_Type__c = \''+selectedHolderProduct+'\'';
        }
        
        if(selectedBotingClass != null){
            holderProductDetailQuery+= ' AND HCLASS__c = \''+selectedBotingClass+'\'';
        }
        
        if(selectedInletConnection != null){
            holderProductDetailQuery+= ' AND HIC__c = \''+selectedInletConnection+'\'';
        }
        
        if(selectedOutletConnection != null){
            holderProductDetailQuery+= ' AND HOC__c = \''+selectedOutletConnection+'\'';
        }
        holderProductDetailQuery += ' LIMIT 50000';
        system.debug(' === holderProductDetailQuery '+holderProductDetailQuery);
        //list<Holder_Product_Detail__c> ptcResults = Database.query(holderProductDetailQuery);
        Set<String> PTCResults = new set<String>();
        for(Holder_Product_Detail__c hpd: Database.query(holderProductDetailQuery)){
            PTCResults.add(hpd.PTC__c);
        }
        if(PTCResults != null && PTCResults.size() == 1){
            for(String ptc: PTCResults){
                conHolder.Holder_Product_Code__c = ptc;
            }
        }else{
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a valid product selection'));
            // return null;
        }
        //return null;
    }
    
    public String selectedBotingClass{get;set;}
    public String selectedBotingClassDesc{get;set;}
    public List<SelectOption> boltingClassOptions{get;set;}
    public void boltingClassSelectList(Holders__c conHolder){
        boltingClassOptions = new List<selectOption>();
        boltingClassOptions.add(new selectOption('','--None--'));
        String holderProductDetailQuery = 'SELECT Bolting_Class_Desc__c, HCLASS__c FROM Holder_Product_Detail__c WHERE  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
        
        if(String.isNotBlank(size2)){
            holderProductDetailQuery+= ' AND SZC__c =: size2';
            system.debug('size in Boltinglist '+size2);
        }
        
        if(selectedHolderProduct != null){
            system.debug('selectedHolderProduct in Boltinglist '+selectedHolderProduct);
            holderProductDetailQuery+= ' AND Holder_Type__c = \''+selectedHolderProduct+'\'';
        }
        
        //add wherecondition for TempLL and TempUL (RTTMDF)
        //ConvertTemperature (RDTEMP, RDTEMPUOM, "F")
        if(conHolder.Rupture_Disc_Burst_Temperature_Converted__c != null){
            Decimal tempLimit = 0;
            String tempLimitStr = String.valueOf(conHolder.Rupture_Disc_Burst_Temperature_Converted__c);
            if(!tempLimitStr.contains('0E')) {
                
                tempLimit = conHolder.Rupture_Disc_Burst_Temperature_Converted__c;
            }
            
            system.debug('Rupture_Disc_Burst_Temperature_Converted__c in Boltinglist '+conHolder.Rupture_Disc_Burst_Temperature_Converted__c);
            holderProductDetailQuery+= ' AND TempLL__c < '+tempLimit+' AND TempUL__c >='+tempLimit;
        }
        
        if(conHolder.Rupture_Disc_Burst_Pressure_Converted__c != null){
            Decimal rdBusrstPressureConv = 0;
            String rdBusrstPressureConvStr = String.valueOf(conHolder.Rupture_Disc_Burst_Pressure_Converted__c);
            if(!rdBusrstPressureConvStr.contains('0E')) {
                
                rdBusrstPressureConv = conHolder.Rupture_Disc_Burst_Pressure_Converted__c;
            }
            system.debug('conHolder.Rupture_Disc_Burst_Pressure_Converted__c in Boltinglist '+conHolder.Rupture_Disc_Burst_Pressure_Converted__c);
            if(rdBusrstPressureConv > 0){
                holderProductDetailQuery+= ' AND Max_Pressure__c >= '+rdBusrstPressureConv;
            }
        }
        holderProductDetailQuery+= ' LIMIT 50000';
        system.debug(' holderProductDetailQuery Queryyy ######## '+holderProductDetailQuery);
        map<String,String> optionsMap = new map<String,String>();
        for(Holder_Product_Detail__c hpd: Database.query(holderProductDetailQuery)){
            system.debug(' hpd.HCLASS__c '+hpd.HCLASS__c+' Bolting_Class_Desc__c: '+hpd.Bolting_Class_Desc__c);
            optionsMap.put(hpd.HCLASS__c,hpd.Bolting_Class_Desc__c);
        }
        
        for(String option: optionsMap.keySet()){
            boltingClassOptions.add(new selectOption(option,optionsMap.get(option)));
            if(conHolder.Bolting_Class__c != null && conHolder.Bolting_Class__c == option){
                selectedBotingClassDesc = optionsMap.get(option);
            }
        }
        if(String.isNotBlank(selectedSeat) && boltingClassOptions.size() > 1 && boltingClassOptions.size() == 2){
            System.debug(' boltingClassOptions '+boltingClassOptions);
            system.debug(' boltingClassOptions[0].getValue() '+boltingClassOptions[0].getValue());
            selectedBotingClassDesc = boltingClassOptions[1].getLabel();
            conHolder.Bolting_Class__c = boltingClassOptions[1].getValue();
            selectedBotingClass = conHolder.Bolting_Class__c;
            handleSTC2Change();
        }
    }
    
    public String selectedInletConnection{get;set;}
    public String selectedInletConnectionDesc{get;set;}
    public List<SelectOption> inletConnectionOptions{get;set;}
    public void inletConnectionSelectList(Holders__c conHolder){
        inletConnectionOptions = new List<selectOption>();
        inletConnectionOptions.add(new selectOption('N','None'));
        system.debug('selectedBotingClass 1 '+selectedBotingClass);
        String holderProductDetailQuery = 'SELECT HIC_Desc__c, HIC__c FROM Holder_Product_Detail__c WHERE  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
        boolean isFiltered=false;
        if(String.isNotBlank(size2)){
            isFiltered=true;
            holderProductDetailQuery+= ' AND SZC__c =: size2';
            system.debug('size in inletConnectionSelectList '+size2);
        }
        if(selectedHolderProduct != null){
            isFiltered=true;
            holderProductDetailQuery+= ' AND Holder_Type__c = \''+selectedHolderProduct+'\'';
            system.debug(' selectedHolderProduct '+selectedHolderProduct);
        }
        
        if(selectedBotingClass != null){
            isFiltered=true;
            holderProductDetailQuery+= ' AND HCLASS__c = \''+selectedBotingClass+'\'';
            system.debug(' selectedBotingClass '+selectedBotingClass);
        }
        holderProductDetailQuery+= ' AND HIC__c != \'N\' LIMIT 50000';
        system.debug(' inletConnectionOptions Queryyy ######## '+holderProductDetailQuery);
        map<String,String> optionsMap = new map<String,String>();
        if(isFiltered) {
            for(Holder_Product_Detail__c hpd: Database.query(holderProductDetailQuery)){
                optionsMap.put(hpd.HIC__c,hpd.HIC_Desc__c);
            }
        } else {
            String holderProductDetailQuery1 = 'SELECT HIC_Desc__c, HIC__c,count(id) FROM Holder_Product_Detail__c WHERE  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
            AggregateResult[] aggResult=Database.query(holderProductDetailQuery1+ 'GROUP BY HIC_Desc__c, HIC__c');
            for (AggregateResult ar : aggResult)  {
                if((string) ar.get('HIC__c')!='N') {
                    optionsMap.put((string) ar.get('HIC__c'),(string) ar.get('HIC_Desc__c'));
                }
            }
        }
        for(String option: optionsMap.keySet()){
            inletConnectionOptions.add(new selectOption(option,optionsMap.get(option)));
            if(conHolder.Inlet_Connection__c != null && conHolder.Inlet_Connection__c == option){
                selectedInletConnectionDesc = optionsMap.get(option);
            }
        }
        
        if(String.isBlank(selectedInletConnection) && inletConnectionOptions.size() > 0 && inletConnectionOptions.size() == 2){
            selectedInletConnection = inletConnectionOptions[1].getValue();
            selectedInletConnectionDesc = inletConnectionOptions[1].getLabel();
            handleInletChange();
        }else if(inletConnectionOptions.size() == 1){
            selectedInletConnection = inletConnectionOptions[0].getValue();
            selectedInletConnectionDesc = inletConnectionOptions[0].getLabel();
            handleInletChange();
        }
    }
    
    public String selectedOutletConnection{get;set;}
    public String selectedOutletConnectionDesc{get;set;}
    public List<SelectOption> outletConnectionOptions{get;set;}
    public void outletConnectionSelectList(Holders__c conHolder){
        outletConnectionOptions = new List<selectOption>();
        outletConnectionOptions.add(new selectOption('N','None'));
        String holderProductDetailQuery = 'SELECT HOC_Desc__c, HOC__c FROM Holder_Product_Detail__c WHERE  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
        boolean isFiltered1=false;
        if(String.isNotBlank(size2)){
            isFiltered1=true;
            holderProductDetailQuery+= ' AND SZC__c =: size2';
            system.debug('size in outletConnectionSelectList '+size2);
        }
        if(selectedHolderProduct != null){
            isFiltered1=true;
            holderProductDetailQuery+= ' AND Holder_Type__c = \''+selectedHolderProduct+'\'';
        }
        
        if(selectedBotingClass != null){
            isFiltered1=true;
            holderProductDetailQuery+= ' AND HCLASS__c >= \''+selectedBotingClass+'\'';
        }
        
        if(selectedInletConnection != null){
            isFiltered1=true;
            holderProductDetailQuery+= ' AND HIC__c >= \''+selectedInletConnection+'\'';
        }
        holderProductDetailQuery+= ' AND HOC__c != \'N\' LIMIT 50000';
        system.debug(' outletConnectionOptions Queryyy ######## '+holderProductDetailQuery);
        map<String,String> optionsMap = new map<String,String>();
        if(isFiltered1) {
            for(Holder_Product_Detail__c hpd: Database.query(holderProductDetailQuery)){
                optionsMap.put(hpd.HOC__c,hpd.HOC_Desc__c);
            }
        }  else {
            String holderProductDetailQuery2 = 'SELECT HOC_Desc__c, HOC__c,count(id) FROM Holder_Product_Detail__c WHERE  Brand__c = \''+conHolder.Brand_Formula__c+'\'';
            AggregateResult[] aggResult1=Database.query(holderProductDetailQuery2+ 'GROUP BY HOC_Desc__c, HOC__c');
            for (AggregateResult ar : aggResult1)  {
                if((string) ar.get('HOC__c')!='N') {
                    optionsMap.put((string) ar.get('HOC__c'),(string) ar.get('HOC_Desc__c'));
                }
            }
        }
        
        for(String option: optionsMap.keySet()){
            outletConnectionOptions.add(new selectOption(option,optionsMap.get(option)));
            if(conHolder.Outlet_Connection__c != null && conHolder.Outlet_Connection__c == option){
                selectedOutletConnectionDesc = optionsMap.get(option);
            }
        }
        
        if(String.isBlank(selectedOutletConnection) && outletConnectionOptions.size() > 0 && outletConnectionOptions.size() == 2){
            selectedOutletConnection = outletConnectionOptions[1].getValue();
            selectedOutletConnectionDesc = outletConnectionOptions[1].getLabel();
        }else if(outletConnectionOptions.size() == 1){
            selectedOutletConnection = outletConnectionOptions[0].getValue();
            selectedOutletConnectionDesc = outletConnectionOptions[0].getLabel();
        }
    }
    
    public List<SelectOption> getNACEComplianceOptions(){
        Schema.sObjectType sobject_type = Holders__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('NACE_Compliance__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getChinaManufacturingLicenseOptions(){
        Schema.sObjectType sobject_type = Holders__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('China_Manufacturing_License__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    
    public Boolean isCertificationsSaved = false;
    public PageReference saveCertifications()
    {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
        try
        {
            if(String.isNotBlank(size2)){
                conHolder.Size2__c = size2;
                //conHolder.Size__c = size2;
            }
            system.debug('@@Test saveSecB conHolder => '+conHolder);
            conHolder.Finish_Configuration__c = false; // added by piyush
            update conHolder;
            
            holderProductSelectList(conHolder);
            boltingClassSelectList(conHolder);
            inletConnectionSelectList(conHolder);
            
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    
    public Boolean validateProductSelection(){
        if(String.isBlank(conHolder.Size_Unit__c)){
        	if(!ReorderFlag)
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Size Units'));
            return true;
        }
        if(String.isBlank(conHolder.Holder_Product_Code__c)){
            if(!ReorderFlag)
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a valid product selection'));
            return true;
        }
        //
        //conHolder.Holder_Product_Code__c
        return false;
    }
    
    public Boolean isProductSelectionSaved = false;
    public PageReference saveProductSelection()
    {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
        if(String.isBlank(conHolder.Size_Unit__c)){
            if(!ReorderFlag)
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Size Units'));
            return null;
        }
        //cleanSecB();
        // conHolder.Size2__c = size2;
        // conHolder.Size__c = size2;
        string strSZC='';
        if(String.isNotBlank(conHolder.Size__c))
            strSZC=conHolder.Size__c;
        else
            strSZC=conHolder.Brand_Dependent_Size__c;
        if(String.isBlank(strSZC)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Size'));
            return null;
        }
        if(ReorderFlag){
             selectedHolderProduct=[select Holder_Type__c from Holder_Product_Detail__c where Brand__c=:conHolder.Brand_Formula__c and SZC__c=:conHolder.Size2__c
                    and HCLASS__c=:conHolder.Bolting_Class__c and HIC__c=:conHolder.Inlet_Connection__c and HOC__c=:conHolder.Outlet_Connection__c
                    and PTC__c=:conHolder.Holder_Product_Code__c][0].Holder_Type__c;
        }
	
    	conHolder.Holder_Product__c = selectedHolderProduct;            
        
        if(String.isNotBlank(selectedBotingClass)){
            conHolder.Bolting_Class__c = selectedBotingClass;
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Bolting Class'));
            return null;
        }
        conHolder.Inlet_Connection__c = selectedInletConnection;
        conHolder.Outlet_Connection__c = selectedOutletConnection;
        
        handleOutletChange();
        system.debug('Size in Lookup Detail '+size2+' selectedBotingClass '+selectedBotingClass);
        //calculate Holder_Max_Pressure__c
        map<String,String> holderInputs = new map<String,String>();
        if(!Test.isRunningTest()){
            holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        }
        
        system.debug(' holderInputs HRTMAXPSIG :::: '+holderInputs.get('HRTMAXPSIG'));
        if(holderInputs.get('HRTMAXPSIG') != null){
            conHolder.Holder_Max_Pressure__c = Decimal.valueOf(holderInputs.get('HRTMAXPSIG'));
        }
        
        /*Result lookupDetailList = new Result();
List<String> selectCols = new List<String> {'Value__c'};
lookupDetailList=ConfigHolderUtility.getDataFromTranslationObj('Attribute__c','Holder_Lookup_Translation__c','Holder_Lookup_Detail__c',holderInputs,selectCols, new List<String> {'HRTMAXPSIG'});
if(lookupDetailList.bResult){
system.debug('***lookupDetailList Result' +lookupDetailList.objResultList);
for(sObject sobj:lookupDetailList.objResultList){
Holder_Lookup_Detail__c  holderLookupDeatilRecord = new Holder_Lookup_Detail__c ();
holderLookupDeatilRecord = (Holder_Lookup_Detail__c )sobj;
if(holderLookupDeatilRecord.Value__c != null){
conHolder.Holder_Max_Pressure__c =  Decimal.valueOf(holderLookupDeatilRecord.Value__c);
}
}
}*/
        
        // calculate Converted_Holder_Max_Pressure__c
        // ConvertPressure (HRTMAXPSIG, "psig", HRTMAXUOM) and concatenate on the end " [HRTMAXUOM]"
        if(conHolder.Holder_Max_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (conHolder.Holder_Max_Pressure__c != Null){
                resultConvertPressure=unitConversions.convertPressure('psig',conHolder.Holder_Max_Pressure_Units__c,conHolder.Holder_Max_Pressure__c);
            }
            if(resultConvertPressure.bResult){
                conHolder.Converted_Holder_Max_Pressure__c =resultConvertPressure.dblRetValue + ' ' +conHolder.Holder_Max_Pressure_Units__c;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                return null;
            }
        }
        if(string.IsBlank(conHolder.Bolting_Class__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value Bolting Class'));
        }
        if(string.IsBlank(conHolder.Inlet_Connection__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value Inlet Connection'));
        }
        if(string.IsBlank(conHolder.Outlet_Connection__c)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value Outlet Connection'));
        }
        
        
        
        String strQury='SELECT id FROM Holder_Product_Detail__c WHERE Brand__c=\''+conHolder.Brand_Formula__c+'\' ANd SZC__c = \''+strSZC+'\' AND Holder_Type__c=\''+conHolder.Holder_Product__c+
            '\' AND HCLASS__c=\''+conHolder.Bolting_Class__c+'\' AND HIC__c=\''+conHolder.Inlet_Connection__c+'\' AND HOC__c=\''+conHolder.Outlet_Connection__c+'\'';
        Holder_Product_Detail__c[] isVaildSelection =Database.query(strQury);
        system.debug('Ashim strQury: '+strQury);
        if(isVaildSelection.size()==0) {
        	if(!ReorderFlag)
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a valid product selection'));
        }
        System.debug('isVaildSelection -------->'+strQury);
        if(!ReorderFlag && !Test.isRunningTest()){
            if(ApexPages.getMessages().size()>0) {
                // conProd.Components_Flag__c=false;
                // update conProd;
                return null;
                
        	}
        }
        
        // SELECT SZC__c, CSSUM__c, Holder_Type__c, Bolting_Class_Desc__c, HCLASS__c, HIC_Desc__c, HIC__c, HOC_Desc__c, HOC__c, PTC__c FROM Holder_Product_Detail__c where Brand__c = 'LaMOT' AND SZC__c = '0008' AND Holder_Type__c='Screw Type (LaMOT)' AND Max_Pressure__c >=15000
        system.debug('Check after saving Holders-->@885');
        
        
        
        // Holder_Product_Detail__c[] isVaildSelection =[SELECT id FROM Holder_Product_Detail__c WHERE Brand__c=:conHolder.Brand_Formula__c ANd SZC__c = :conHolder.Size__c AND Holder_Type__c=:conHolder.Holder_Product__c AND Bolting_Class_Desc__c=:conHolder.Bolting_Class__c AND HIC__c=:conHolder.Inlet_Connection__c AND HOC__c=:conHolder.Outlet_Connection__c];
        try
        {
            system.debug('@@Test saveSecC conHolder => '+conHolder);
            conHolder.IsProductSelection__c=true;
            conHolder.Finish_Configuration__c = false; // added by piyush
            update conHolder;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        system.debug('Check after saving Holders-->');
        isBodySectionRequired();
        isInletSectionRequired();
        isHolddownRingSectionRequired();
        isClampSectionRequired();
        isNutSectionRequired();
        isMidFlangeSectionRequired();
        isOutletSectionRequired();
        isSpacerRingSectionRequired();
        isGasketSectionRequired();
        isCmpFlangeSectionRequired();
        
        if(CmpFlangeSectionFlag){
            companionFlangeMaterialSelectList();
        }
        
        if(gasketSectionFlag){
            gasketMaterialSelectOptions();
        }
        
        if(spacerRingSectionFlag){
            spacerRingSelectOptions();
        }
        
        if(outletSetcionFlag){
            if(!Test.isRunningTest()){
                outletMaterialSelectOptions();
            }
        }
        
        if(midFlangeSectionFlag){
            if(!Test.isRunningTest()){
                midFlangeMaterialSelectOptions();
            }
        }
        
        if(nutSectionFlag){
            if(!Test.isRunningTest()){
                nutMaterialSelectOptions();
            }
        }
        
        if(clampSectionFlag){
            if(!Test.isRunningTest()){
                clampMaterialSelectOptions();
            }
        }
        
        if(holddownRingSectionFlag){
            if(!Test.isRunningTest()){
                holddownRingMaterialSelectOptions();
            }
        }
        
        if(inletSectionFlag){
            if(!Test.isRunningTest()){
                inletMaterialSelectOptions();
            }
            // if(String.isNotBlank(selectedInletMaterial)){
            //     knifebladeMaterialInletSelectOptions();
            //     gaugeTapInletSelectOptions();
            //     eyeboltsDrillingInletSelectOptions();
            //     jHookSelectOptions();
            //     facingInletSelectOptions();
            //     coatingInletSelectOptions();
            //     liningInletSelectOptions();
            //     boreInletSelectOptions();
            //     inletOptionAssignment();
            // }
        }
        
        if(bodySectionFlag){
            if(!Test.isRunningTest()){
                bodyMaterialSelectOptions();
                coatingBodySelectOptions();
            }
        }
        if(!Test.isRunningTest()){
            studsandNutsSelectOptions();
            jackscrewsAdditionaSelectlOptions();
        }
        isProductSelectionSaved = true;
        if(String.isNotBlank(selectedInletMaterial)){
            isInletMaterialSelected = true;
        }
        if(String.isNotBlank(selectedOutletMaterial)){
            isOutletMaterialSelected = true;
        }
        return null;
    }
    
    public boolean CmpFlangeSectionFlag{get;set;}
    public void isCmpFlangeSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            CmpFlangeSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Companion_Flange__c');
        }
        System.debug(' CmpFlangeSectionFlag '+CmpFlangeSectionFlag);
    }
    
    
    //prepare Companion_Flange_Material__c select options
    public String selectedCompanionFlangeMaterial{get;set;}
    public List<SelectOption> companionFlangeMaterialOptions{get;set;}
    //public Boolean isRequiredCmpFlange{get;set;}
    public Pagereference companionFlangeMaterialSelectList(){
        companionFlangeMaterialOptions = new List<selectOption>();
        companionFlangeMaterialOptions.add(new selectOption('','None'));
        if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null){
            system.debug(' holdersRequiredInfo.get(conHolder.Holder_Product_Code__c) '+holdersRequiredInfo.get(conHolder.Holder_Product_Code__c));
            map<String,String> optionsMap = new map<String,String>();
            system.debug(' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+ ' size2 '+size2);
            for(Holder_Structure__c hscf: [SELECT MCCF__c FROM Holder_Structure__c
                                           WHERE Holder_Structure_Type__c = 'Companion Flange2'
                                           AND PTC__c =: conHolder.Holder_Product_Code__c
                                           AND SZC__c =: size2 LIMIT 50000]){
                                               if(hscf.MCCF__c != null){
                                                   optionsMap.put(hscf.MCCF__c, matCodeMap.containsKey(hscf.MCCF__c) ? matCodeMap.get(hscf.MCCF__c) : hscf.MCCF__c);
                                               }
                                           }
            for(String option: optionsMap.keySet()){
                companionFlangeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        system.debug(' companionFlangeMaterialOptions ######## '+companionFlangeMaterialOptions);
        return null;
    }
    
    set<String> COCFArray = new Set<String>();
    public Boolean isCompanionFlangeMaterialSelected{get;set;}
    public Pagereference handleCompanionFlangeMaterialChange(){
        String COCFString = '';
        system.debug(' size2 '+size2+' conHolder.Holder_Product_Code__c '+
                     conHolder.Holder_Product_Code__c+' selectedCompanionFlangeMaterial '+
                     selectedCompanionFlangeMaterial+' selectedBotingClass '+selectedBotingClass);
        system.debug(' selectedCompanionFlangeMaterial ######### '+selectedCompanionFlangeMaterial);
        if(String.isNotBlank(selectedCompanionFlangeMaterial)){
            isCompanionFlangeMaterialSelected = true;
            if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && selectedBotingClass != null){
                for(Holder_Structure__c hscf: [SELECT OptionCode__c FROM Holder_Structure__c
                                               WHERE Holder_Structure_Type__c = 'Companion Flange2'
                                               AND PTC__c =: conHolder.Holder_Product_Code__c
                                               AND SZC__c =: size2
                                               AND MCCF__c =: selectedCompanionFlangeMaterial
                                               AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                                   if(hscf.OptionCode__c != null){
                                                       COCFArray.add(hscf.OptionCode__c);
                                                       COCFString += hscf.OptionCode__c+' ,';
                                                   }
                                               }
                system.debug('##  COCFString '+COCFString);
                conHolder.Companion_Flange_Options__c = COCFString;
                boreSelectOptions();
                jackscrewDrillingSelectOptions();
                assignCompanionFlangeOption();
            }
        }else{
            isCompanionFlangeMaterialSelected = false;
        }
        system.debug('##  COCFArray '+COCFArray);
        return null;
    }
    
    public String selectedBore{get;set;}
    public List<SelectOption> boreOptions{get;set;}
    public Boolean boreFlag{get;set;}
    public Pagereference boreSelectOptions() {
        boreOptions = new List<selectOption>();
        boreOptions.add(new selectOption('','None'));
        // if(selectedCompanionFlangeMaterial == null || selectedCompanionFlangeMaterial == ''){
        //     isRequiredGasket = false;
        // }
        map<String,String> optionsMap = new map<String,String>();
        String cmpBoreQuery = 'SELECT Bore__c FROM Holder_Option__c WHERE Bore__c != \'None\' ';
        if(COCFArray != null && COCFArray.size() > 0){
            cmpBoreQuery += ' AND OptionCode__c IN: COCFArray';
        }
        for(Holder_Option__c ho: Database.query(cmpBoreQuery)){
            optionsMap.put(ho.Bore__c,ho.Bore__c);
            System.debug('Bore...'+ho.Bore__c);
        }
        //conHolder.Companion_Flange_Options__c = '';
        for(String option: optionsMap.keySet()){
            boreOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug(' boreOptions ########### '+boreOptions);
        if(boreOptions.size() == 1 && boreOptions[0].getValue() == ''){
            boreFlag = false;
            selectedBore = null;
        }else{
            boreFlag = true;
        }
        return null;
    }
    
    public Pagereference handleboreOptionsChange(){
        jackscrewDrillingSelectOptions();
        assignCompanionFlangeOption();
        return null;
    }
    
    public String selectedjackscrewDrilling{get;set;}
    public List<SelectOption> jackscrewDrillingOptions{get;set;}
    public Boolean jackscrewDrillingFlag{get;set;}
    public Pagereference jackscrewDrillingSelectOptions(){
        jackscrewDrillingOptions = new List<selectOption>();
        jackscrewDrillingOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        String cmpJackscrewDrillingQuery = 'SELECT JackscrewDrilling__c FROM Holder_Option__c WHERE JackscrewDrilling__c != \'None\'';
        if(COCFArray != null && COCFArray.size() > 0){
            cmpJackscrewDrillingQuery += ' AND OptionCode__c IN: COCFArray';
        }
        if(String.isNotBlank(selectedBore)){
            cmpJackscrewDrillingQuery += ' AND Bore__c =: selectedBore';
            //}else if(! boreFlag){
        }else{
            cmpJackscrewDrillingQuery += ' AND Bore__c = \'None\' ';
        }
        //if(String.isNotBlank(selectedBore) && COCFArray.size() > 0){
        for(Holder_Option__c ho: Database.query(cmpJackscrewDrillingQuery)){
            optionsMap.put(ho.JackscrewDrilling__c,ho.JackscrewDrilling__c);
        }
        for(String option: optionsMap.keySet()){
            jackscrewDrillingOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug(' jackscrewDrillingOptions ########### '+jackscrewDrillingOptions);
        if(jackscrewDrillingOptions.size() == 1 && jackscrewDrillingOptions[0].getValue() == ''){
            jackscrewDrillingFlag = false;
            selectedjackscrewDrilling = null;
        }else{
            jackscrewDrillingFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handlejackscrewDrillingChange(){
        boreSelectOptions();
        assignCompanionFlangeOption();
        return null;
    }
    
    public void assignCompanionFlangeOption(){
        String cmpFlangeOptionQuery = 'SELECT OptionCode__c FROM Holder_Option__c WHERE Bore__c != \'None\' ';
        if(COCFArray != null && COCFArray.size() > 0){
            cmpFlangeOptionQuery += ' AND OptionCode__c IN: COCFArray';
        }
        if(String.isNotBlank(selectedBore)){
            cmpFlangeOptionQuery += ' AND Bore__c =: selectedBore';
            //}else if(! boreFlag){
        }else{
            cmpFlangeOptionQuery += ' AND Bore__c = \'None\' ';
        }
        if(String.isNotBlank(selectedjackscrewDrilling)){
            cmpFlangeOptionQuery += ' AND JackscrewDrilling__c =: selectedjackscrewDrilling';
            // }else if(! jackscrewDrillingFlag){
        }else{
            cmpFlangeOptionQuery += ' AND JackscrewDrilling__c = \'None\' ';
        }
        //if(String.isNotBlank(selectedBore) && COCFArray.size() > 0 && String.isNotBlank(selectedjackscrewDrilling)){
        for(Holder_Option__c ho: Database.query(cmpFlangeOptionQuery)){
            if(ho.OptionCode__c != null){
                conHolder.Companion_Flange_Option__c = ho.OptionCode__c;
            }
        }
        //}
    }
    
    public Pagereference clearCFMSection(){
        selectedBore = null;
        selectedjackscrewDrilling = null;
        boreSelectOptions();
        jackscrewDrillingSelectOptions();
        assignCompanionFlangeOption();
        return null;
    }
    
    public boolean gasketSectionFlag{get;set;}
    public void isGasketSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            gasketSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Gasket__c');
        }
        System.debug(' gasketSectionFlag '+gasketSectionFlag);
    }
    
    public String selectedGasketMaterial{get;set;}
    public List<SelectOption> gasketMaterialOptions{get;set;}
    //public boolean isRequiredGasket{get;set;}
    public Pagereference gasketMaterialSelectOptions(){
        gasketMaterialOptions = new List<selectOption>();
        gasketMaterialOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' size2 '+size2+' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+' selectedBotingClass '+selectedBotingClass);
        if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && selectedBotingClass != null){
            for(Holder_Structure__c ho: [SELECT MCHG__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Gasket2' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                             optionsMap.put(ho.MCHG__c, matCodeMap.containsKey(ho.MCHG__c) ? matCodeMap.get(ho.MCHG__c) : ho.MCHG__c);
                                         }
            for(String option: optionsMap.keySet()){
                gasketMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        system.debug(' gasketMaterialOptions ########## '+gasketMaterialOptions);
        return null;
    }
    
    public boolean spacerRingSectionFlag{get;set;}
    public void isSpacerRingSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            spacerRingSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Spacer_Ring__c');
        }
        System.debug(' spacerRingSectionFlag '+spacerRingSectionFlag);
    }
    
    public String selectedSpacerRing{get;set;}
    public List<SelectOption> spacerRingOptions{get;set;}
    //public boolean isSpacerRingRequired{get;set;}
    public Pagereference spacerRingSelectOptions(){
        spacerRingOptions = new List<selectOption>();
        spacerRingOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' size2 '+size2+' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c +' selectedBotingClass '+selectedBotingClass);
        if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && selectedBotingClass != null){
            for(Holder_Structure__c ho: [SELECT MCHRNG__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Ring2' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                             optionsMap.put(ho.MCHRNG__c, matCodeMap.containsKey(ho.MCHRNG__c) ? matCodeMap.get(ho.MCHRNG__c) : ho.MCHRNG__c);
                                         }
            for(String option: optionsMap.keySet()){
                spacerRingOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        system.debug(' spacerRingOptions ########### '+spacerRingOptions);
        return null;
    }
    
    
    public boolean outletSetcionFlag{get;set;}
    public void isOutletSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            outletSetcionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Outlet__c');
        }
        System.debug(' outletSetcionFlag '+outletSetcionFlag);
    }
    
    public String selectedOutletMaterial{get;set;}
    public List<SelectOption> outletMaterialOptions{get;set;}
    public boolean isOutletMaterialSelected{get;set;}
    set<String> ptcOutletList = new set<String>();
    public void outletMaterialSelectOptions(){
        isOutletMaterialSelected = false;
        outletMaterialOptions = new List<selectOption>();
        outletMaterialOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' size2 '+size2+' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c +' selectedBotingClass '+selectedBotingClass);
        if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && selectedBotingClass != null){
            /*for(Holder_Lookup_Detail__c hld: [Select Text__c FROM Holder_Lookup_Detail__c
WHERE Holder_Lookup_Translation__r.Attribute__c = 'OUTLETCOMPPTC'
AND TextVal1__c =: conHolder.Holder_Product_Code__c LIMIT 50000]){
ptcOutletList.add(hld.Text__c);
}*/
            map<String,String> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
            System.debug(' OUTLETCOMPPTC :::::: '+holderInputs.get('OUTLETCOMPPTC'));
            if(holderInputs.get('OUTLETCOMPPTC') != null){
                ptcOutletList.add(holderInputs.get('OUTLETCOMPPTC'));
            }
            /*
Result lookupDetailList = new Result();
List<String> selectCols = new List<String> {'Text__c'};
lookupDetailList=ConfigHolderUtility.getDataFromTranslationObj('Attribute__c','Holder_Lookup_Translation__c','Holder_Lookup_Detail__c',holderInputs,selectCols, new List<String> {'OUTLETCOMPPTC'});
if(lookupDetailList.bResult){
system.debug('***lookupDetailList Result' +lookupDetailList.objResultList);
for(sObject sobj:lookupDetailList.objResultList){
Holder_Lookup_Detail__c  holderLookupDeatilRecord = new Holder_Lookup_Detail__c ();
holderLookupDeatilRecord = (Holder_Lookup_Detail__c )sobj;
if(holderLookupDeatilRecord.Text__c != null){
ptcOutletList.add(holderLookupDeatilRecord.Text__c);
}
}
}*/
            if(ptcOutletList.size() > 0 ){
                system.debug('OUT LET MATERIALS ptcOutletList'+ptcOutletList);
                system.debug('OUT LET MATERIALS SZC__c'+size2);
                system.debug('OUT LET MATERIALS selectedBotingClass'+selectedBotingClass);
                system.debug('OUT LET MATERIALS ptcOutletList'+ptcOutletList);
                for(Holder_Structure__c ho: [SELECT MCHO__c FROM Holder_Structure__c
                                             WHERE Holder_Structure_Type__c = 'Outlet'
                                             AND OUTLETCOMPPTC__c IN: ptcOutletList
                                             AND SZC__c =: size2
                                             AND HCLASS__c =: selectedBotingClass
                                             AND MCHO__c != null
                                             LIMIT 50000]){
                                                 optionsMap.put(ho.MCHO__c, matCodeMap.containsKey(ho.MCHO__c) ? matCodeMap.get(ho.MCHO__c) : ho.MCHO__c);
                                             }
            }
            for(String option: optionsMap.keySet()){
                //outletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                if (conHolder.ATEX_Certificate__c)
                {
                    if (!AtexExcludeMatOptions.contains(option)) {
                        if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103') {
                            if(NACEIncludeMatOptions.contains(option))
                                outletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                        } else {
                            outletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                        }
                    }
                } else {
                    if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103') {
                        if(NACEIncludeMatOptions.contains(option))
                            outletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                    } else {
                        outletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                    }
                }
            }
            System.debug(' outletMaterialOptions ####### '+outletMaterialOptions);
        }
    }
    
    set<String> COOUTArray = new set<String>();
    public void handleOutletMaterialChange(){
        system.debug(' selectedOutletMaterial '+selectedOutletMaterial+ ' size2 '+size2 +' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+' selectedBotingClass '+selectedBotingClass);
        system.debug(' ptcOutletList ######### '+ptcOutletList);
        if(String.isNotBlank(selectedOutletMaterial)){
            isOutletMaterialSelected = true;
            if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && selectedBotingClass != null){
                for(Holder_Structure__c ho: [SELECT OptionCode__c FROM Holder_Structure__c
                                             WHERE Holder_Structure_Type__c = 'Outlet'
                                             AND OUTLETCOMPPTC__c IN: ptcOutletList
                                             AND MCHO__c =: selectedOutletMaterial
                                             AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                                 COOUTArray.add(ho.OptionCode__c);
                                             }
                String COOUTArrayStr = '';
                for(String str: COOUTArray){
                    COOUTArrayStr += str +', ';
                }
                conHolder.Outlet_Options__c = COOUTArrayStr;
                system.debug(' COOUTArrayStr '+COOUTArrayStr);
                system.debug(' COOUTArray '+COOUTArray);
                knifebladeMaterialSelectOptions();
                gaugeTapSelectOptions();
                eyeboltsOutletSelectOptions();
                facingSelectOptions();
                coatingSelectOptions();
                LiningSelectOptions();
                jackscrewDrillingSelectOptions2();
                bore2SelectOptions();
                outletOptionsAssignment();
            }
        }else{
            isOutletMaterialSelected = false;
        }
        
    }
    
    public String selectedKnifebladeMaterial{get;set;}
    public List<SelectOption> KnifebladeMaterialOptions{get;set;}
    public boolean isKnifebladeMaterialFlag{get;set;}
    public Pagereference knifebladeMaterialSelectOptions(){
        KnifebladeMaterialOptions = new List<selectOption>();
        KnifebladeMaterialOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' COOUTArray '+COOUTArray);
        String knifebladeMaterialOutletQuery = 'SELECT Knifeblade_Material__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND  Knifeblade_Material__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            knifebladeMaterialOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        System.debug(' knifebladeMaterialOutletQuery ####### '+knifebladeMaterialOutletQuery);
        //if(COOUTArray != null && COOUTArray.size() > 0){
        for(Holder_Option__c ho: Database.query(knifebladeMaterialOutletQuery)){
            if(String.isNotBlank(ho.Knifeblade_Material__c)){
                optionsMap.put(ho.Knifeblade_Material__c,ho.Knifeblade_Material__c);
            }
        }
        for(String option: optionsMap.keySet()){
            //KnifebladeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
            if (conHolder.ATEX_Certificate__c)
            {
                if (!AtexExcludeMatOptions.contains(option)) {
                    KnifebladeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                }
            } else {
                KnifebladeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        System.debug(' KnifebladeMaterialOptions ####### '+KnifebladeMaterialOptions);
        if(KnifebladeMaterialOptions.size() == 1 && KnifebladeMaterialOptions[0].getValue() == ''){
            isKnifebladeMaterialFlag = false;
            selectedKnifebladeMaterial = null;
        }else{
            isKnifebladeMaterialFlag = true;
        }
        return null;
        //}
    }
    
    public Pagereference handleKnifebladeMaterialChange(){
        gaugeTapSelectOptions();
        eyeboltsOutletSelectOptions();
        facingSelectOptions();
        coatingSelectOptions();
        LiningSelectOptions();
        jackscrewDrillingSelectOptions2();
        bore2SelectOptions();
        outletOptionsAssignment();
        return null;
    }
    
    public String selectedGaugeTap{get;set;}
    public List<SelectOption> gaugeTapOptions{get;set;}
    public boolean gaugeTapFlag{get;set;}
    public Pagereference gaugeTapSelectOptions(){
        gaugeTapOptions = new List<selectOption>();
        gaugeTapOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        String gaugeTapOutletQuery = 'SELECT GaugeTap__c FROM Holder_Option__c WHERE JHook__c = \'None\'  AND  GaugeTap__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            gaugeTapOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            gaugeTapOutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag){
        }else{
            gaugeTapOutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        //System.debug(' COOUTArray '+COOUTArray);
        //if(String.isNotBlank(selectedKnifebladeMaterial) && COOUTArray != null && COOUTArray.size() > 0){
        for(Holder_Option__c ho: Database.query(gaugeTapOutletQuery)){
            if(String.isNotBlank(ho.GaugeTap__c)){
                optionsMap.put(ho.GaugeTap__c,ho.GaugeTap__c);
            }
        }
        for(String option: optionsMap.keySet()){
            gaugeTapOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' gaugeTapOptions ########### '+gaugeTapOptions);
        System.debug(' selectedGaugeTap 1 ########### '+selectedGaugeTap);
        if(gaugeTapOptions.size() == 1 && gaugeTapOptions[0].getValue() == ''){
            gaugeTapFlag = false;
            selectedGaugeTap = null;
        }else{
            gaugeTapFlag = true;
        }
        //}
        System.debug(' selectedGaugeTap 2 ########### '+selectedGaugeTap);
        return null;
    }
    
    public Boolean pressureGaugeFlag{get;set;}
    public Boolean reducingBushingFlag{get;set;}
    public Boolean tee2Flag{get;set;}
    public Boolean nipple2Flag{get;set;}
    public Boolean excessFlowValveFlag{get;set;}
    public Boolean isGaugeTapSelected{get;set;}
    public Pagereference handleGaugeTapChange(){
        System.debug('selectedGaugeTap...'+selectedGaugeTap);
        pressureGaugeFlag = false;
        reducingBushingFlag = false;
        tee2Flag = false;
        nipple2Flag = false;
        isGaugeTapSelected = false;
        if(String.isNotBlank(selectedGaugeTap)){
            isGaugeTapSelected = true;
            for(Holder_Option__c ho: [SELECT Nipple__c, Pressure_Gauge__c, Tee__c, Excess_Flow_Valve__c, Reducing_Bushing__c FROM Holder_Option__c
                                      WHERE GaugeTap__c =: selectedGaugeTap LIMIT 1]){
                                          nipple2Flag = ho.Nipple__c;
                                          pressureGaugeFlag = ho.Pressure_Gauge__c;
                                          tee2Flag = ho.Tee__c;
                                          reducingBushingFlag = ho.Reducing_Bushing__c;
                                          excessFlowValveFlag = ho.Excess_Flow_Valve__c;
                                      }
        }
        else{
            selectedTubeCaseMaterial = null;
            selectedPhysicalProperties = null;
            selectedUOMPressRange = null;
            selectedExcessFlowValve = null;
            selectedNipple2 = null;
            selectedTee2 = null;
            selectedReducingBushing = null;
        }
        knifebladeMaterialSelectOptions();
        eyeboltsOutletSelectOptions();
        facingSelectOptions();
        coatingSelectOptions();
        LiningSelectOptions();
        jackscrewDrillingSelectOptions2();
        bore2SelectOptions();
        outletOptionsAssignment();
        
        //Guage related fields
        NippleSelectOptions();
        tee2SelectOptions();
        reducingBushingSelectOptions();
        excessFlowValveSelectOptions();
        
        uOMPressRangeSelectList();
        physicalPropertiesSelectOptions();
        tubeCaseMaterialSelectOptions();
        return null;
    }
    
    public String selectedEyeboltsOutlet{get;set;}
    public List<SelectOption> eyeboltsOutletOptions{get;set;}
    public boolean eyeboltsOutletFlag{get;set;}
    public Pagereference eyeboltsOutletSelectOptions(){
        eyeboltsOutletOptions = new List<selectOption>();
        eyeboltsOutletOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        String eyeboltsOutletQuery = 'SELECT EyeboltDrilling__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND EyeboltDrilling__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            eyeboltsOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            eyeboltsOutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            // }else if(! isKnifebladeMaterialFlag){
        }else{
            eyeboltsOutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            eyeboltsOutletQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            eyeboltsOutletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        //if(String.isNotBlank(selectedKnifebladeMaterial) && String.isNotBlank(selectedGaugeTap) && COOUTArray != null && COOUTArray.size() > 0){
        for(Holder_Option__c ho: Database.query(eyeboltsOutletQuery)){
            if(String.isNotBlank(ho.EyeboltDrilling__c)){
                optionsMap.put(ho.EyeboltDrilling__c,ho.EyeboltDrilling__c);
            }
        }
        for(String option: optionsMap.keySet()){
            eyeboltsOutletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' eyeboltsOutletOptions ######### '+eyeboltsOutletOptions);
        if(eyeboltsOutletOptions.size() == 1 && eyeboltsOutletOptions[0].getValue() == ''){
            eyeboltsOutletFlag = false;
            selectedEyeboltsOutlet = null;
        }else{
            eyeboltsOutletFlag = true;
        }
        
        //}
        return null;
    }
    
    public String eyeboltMaterialOutlet{get;set;}
    public Pagereference handleEyeboltsOutletChange(){
        knifebladeMaterialSelectOptions();
        gaugeTapSelectOptions();
        facingSelectOptions();
        coatingSelectOptions();
        LiningSelectOptions();
        jackscrewDrillingSelectOptions2();
        bore2SelectOptions();
        outletOptionsAssignment();
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            eyeboltMaterialOutlet = 'Carbon Steel';
        }else{
            eyeboltMaterialOutlet = null;
        }
        return null;
    }
    
    public String selectedFacing{get;set;}
    public List<SelectOption> facingOptions{get;set;}
    public boolean facingFlag{get;set;}
    public Pagereference facingSelectOptions(){
        facingOptions = new List<selectOption>();
        facingOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        //System.debug(' COOUTArray '+COOUTArray);
        String facingOutletQuery = 'SELECT Facing__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND Facing__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            facingOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            facingOutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag){
        }else{
            facingOutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            facingOutletQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            facingOutletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            facingOutletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsOutlet';
            //}else if(! eyeboltsOutletFlag){
        }else{
            facingOutletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        //if(String.isNotBlank(selectedEyeboltsOutlet) && String.isNotBlank(selectedKnifebladeMaterial) && String.isNotBlank(selectedGaugeTap) && COOUTArray != null && COOUTArray.size() > 0){
        for(Holder_Option__c ho: Database.query(facingOutletQuery)){
            if(String.isNotBlank(ho.Facing__c)){
                optionsMap.put(ho.Facing__c,ho.Facing__c);
            }
        }
        for(String option: optionsMap.keySet()){
            facingOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' facingOptions ############## '+facingOptions);
        if(facingOptions.size() == 1 && facingOptions[0].getValue() == ''){
            facingFlag = false;
            selectedFacing = null;
        }else{
            facingFlag = true;
        }
        
        //}
        return null;
    }
    
    public Pagereference handleFacingChange(){
        knifebladeMaterialSelectOptions();
        gaugeTapSelectOptions();
        eyeboltsOutletSelectOptions();
        coatingSelectOptions();
        LiningSelectOptions();
        jackscrewDrillingSelectOptions2();
        bore2SelectOptions();
        outletOptionsAssignment();
        return null;
    }
    
    public String selectedCoating{get;set;}
    public List<SelectOption> coatingOptions{get;set;}
    public boolean CoatingFlag{get;set;}
    public Pagereference coatingSelectOptions(){
        coatingOptions = new List<selectOption>();
        coatingOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        String coatingOutletQuery = 'SELECT Coating__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND Coating__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            coatingOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            coatingOutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag){
        }else{
            coatingOutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            coatingOutletQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            coatingOutletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            coatingOutletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsOutlet';
            //}else if(! eyeboltsOutletFlag){
        }else{
            coatingOutletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacing)){
            coatingOutletQuery += ' AND Facing__c =: selectedFacing';
            //}else if(! facingFlag){
        }else{
            coatingOutletQuery += ' AND Facing__c = \'None\' ';
        }
        //System.debug(' COOUTArray '+COOUTArray);
        // if(String.isNotBlank(selectedFacing) && String.isNotBlank(selectedEyeboltsOutlet) && String.isNotBlank(selectedKnifebladeMaterial) && String.isNotBlank(selectedGaugeTap)
        //     && COOUTArray != null && COOUTArray.size() > 0){
        for(Holder_Option__c ho: Database.query(coatingOutletQuery)){
            if(String.isNotBlank(ho.Coating__c)){
                optionsMap.put(ho.Coating__c,ho.Coating__c);
            }
        }
        for(String option: optionsMap.keySet()){
            coatingOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' coatingOptions ########## '+coatingOptions);
        if(coatingOptions.size() == 1 && coatingOptions[0].getValue() == ''){
            CoatingFlag = false;
            selectedCoating = null;
        }else{
            CoatingFlag = true;
        }
        
        //}
        return null;
    }
    
    public Pagereference handleCoatingChange(){
        knifebladeMaterialSelectOptions();
        gaugeTapSelectOptions();
        eyeboltsOutletSelectOptions();
        facingSelectOptions();
        LiningSelectOptions();
        jackscrewDrillingSelectOptions2();
        bore2SelectOptions();
        outletOptionsAssignment();
        return null;
    }
    
    public String selectedLining{get;set;}
    public List<SelectOption> LiningOptions{get;set;}
    public boolean LiningFlag{get;set;}
    public Pagereference LiningSelectOptions(){
        LiningOptions = new List<selectOption>();
        LiningOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        //System.debug(' COOUTArray '+COOUTArray);
        String LiningOutletQuery = 'SELECT Lining__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND Lining__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            LiningOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            LiningOutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag){
        }else{
            LiningOutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            LiningOutletQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            LiningOutletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            LiningOutletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsOutlet';
            //}else if(! eyeboltsOutletFlag){
        }else{
            LiningOutletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacing)){
            LiningOutletQuery += ' AND Facing__c =: selectedFacing';
            //}else if(! facingFlag){
        }else{
            LiningOutletQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoating)){
            LiningOutletQuery += ' AND Coating__c =: selectedCoating';
            //}else if(! CoatingFlag){
        }else{
            LiningOutletQuery += ' AND Coating__c = \'None\' ';
        }
        // if(String.isNotBlank(selectedCoating) && String.isNotBlank(selectedFacing) && String.isNotBlank(selectedEyeboltsOutlet) &&
        //     String.isNotBlank(selectedKnifebladeMaterial) && String.isNotBlank(selectedGaugeTap) && COOUTArray != null && COOUTArray.size() > 0){
        for(Holder_Option__c ho: Database.query(LiningOutletQuery)){
            if(String.isNotBlank(ho.Lining__c)){
                optionsMap.put(ho.Lining__c,ho.Lining__c);
            }
        }
        for(String option: optionsMap.keySet()){
            LiningOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' LiningOptions ########### '+LiningOptions);
        if(LiningOptions.size() == 1 && LiningOptions[0].getValue() == ''){
            LiningFlag = false;
            selectedLining = null;
        }else{
            LiningFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleLiningChange(){
        knifebladeMaterialSelectOptions();
        gaugeTapSelectOptions();
        eyeboltsOutletSelectOptions();
        facingSelectOptions();
        coatingSelectOptions();
        jackscrewDrillingSelectOptions2();
        bore2SelectOptions();
        outletOptionsAssignment();
        return null;
    }
    
    public String selectedJackscrewDrilling2{get;set;}
    public List<SelectOption> jackscrewDrillingOptions2{get;set;}
    public boolean jackscrewDrillingFlag2{get;set;}
    public Pagereference jackscrewDrillingSelectOptions2(){
        jackscrewDrillingOptions2 = new List<selectOption>();
        jackscrewDrillingOptions2.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        //System.debug(' COOUTArray '+COOUTArray);
        String jackscrewDrillingOutletQuery = 'SELECT JackscrewDrilling__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND JackscrewDrilling__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            jackscrewDrillingOutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            jackscrewDrillingOutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag){
        }else{
            jackscrewDrillingOutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            jackscrewDrillingOutletQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            jackscrewDrillingOutletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            jackscrewDrillingOutletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsOutlet';
            //}else if(! eyeboltsOutletFlag){
        }else{
            jackscrewDrillingOutletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacing)){
            jackscrewDrillingOutletQuery += ' AND Facing__c =: selectedFacing';
            //}else if(! facingFlag){
        }else{
            jackscrewDrillingOutletQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoating)){
            jackscrewDrillingOutletQuery += ' AND Coating__c =: selectedCoating';
            //}else if(! CoatingFlag){
        }else{
            jackscrewDrillingOutletQuery += ' AND Coating__c = \'None\' ';
        }
        if(String.isNotBlank(selectedLining)){
            jackscrewDrillingOutletQuery += ' AND Lining__c =: selectedLining';
            //}else if(! LiningFlag){
        }else{
            jackscrewDrillingOutletQuery += ' AND Lining__c = \'None\' ';
        }
        
        // if(String.isNotBlank(selectedLining) && String.isNotBlank(selectedCoating) && String.isNotBlank(selectedFacing) && String.isNotBlank(selectedEyeboltsOutlet) &&
        //     String.isNotBlank(selectedKnifebladeMaterial) && String.isNotBlank(selectedGaugeTap) && COOUTArray != null && COOUTArray.size() > 0){
        List<Holder_Option__c> hldOptList = Database.query(jackscrewDrillingOutletQuery);
        for(Holder_Option__c ho: hldOptList){
            if(String.isNotBlank(ho.JackscrewDrilling__c)){
                optionsMap.put(ho.JackscrewDrilling__c,ho.JackscrewDrilling__c);
            }
        }
        for(String option: optionsMap.keySet()){
            jackscrewDrillingOptions2.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' jackscrewDrillingOptions2 ########### '+jackscrewDrillingOptions2);
        if(jackscrewDrillingOptions2.size() == 1 && jackscrewDrillingOptions2[0].getValue() == ''){
            jackscrewDrillingFlag2 = false;
            selectedJackscrewDrilling2 = null;
        }else{
            jackscrewDrillingFlag2 = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleJackscrewDrilling2Change(){
        knifebladeMaterialSelectOptions();
        gaugeTapSelectOptions();
        eyeboltsOutletSelectOptions();
        facingSelectOptions();
        coatingSelectOptions();
        LiningSelectOptions();
        bore2SelectOptions();
        outletOptionsAssignment();
        return null;
    }
    
    public String selectedBore2{get;set;}
    public List<SelectOption> bore2Options{get;set;}
    public boolean bore2Flag{get;set;}
    public Pagereference bore2SelectOptions(){
        bore2Options = new List<selectOption>();
        bore2Options.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        //System.debug(' COOUTArray '+COOUTArray);
        String bore2OutletQuery = 'SELECT Bore__c FROM Holder_Option__c WHERE JHook__c = \'None\' AND Bore__c != \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            bore2OutletQuery += ' AND OptionCode__c IN: COOUTArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            bore2OutletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag){
        }else{
            bore2OutletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            bore2OutletQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            bore2OutletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            bore2OutletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsOutlet';
            //}else if(! eyeboltsOutletFlag){
        }else{
            bore2OutletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacing)){
            bore2OutletQuery += ' AND Facing__c =: selectedFacing';
            //}else if(! facingFlag){
        }else{
            bore2OutletQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoating)){
            bore2OutletQuery += ' AND Coating__c =: selectedCoating';
            //}else if(! CoatingFlag){
        }else{
            bore2OutletQuery += ' AND Coating__c = \'None\' ';
        }
        if(String.isNotBlank(selectedLining)){
            bore2OutletQuery += ' AND Lining__c =: selectedLining';
            //}else if(! LiningFlag){
        }else{
            bore2OutletQuery += ' AND Lining__c = \'None\' ';
        }
        if(String.isNotBlank(selectedJackscrewDrilling2)){
            bore2OutletQuery += ' AND JackscrewDrilling__c =: selectedJackscrewDrilling2';
            //}else if(! jackscrewDrillingFlag2){
        }else{
            bore2OutletQuery += ' AND JackscrewDrilling__c = \'None\' ';
        }
        // if(String.isNotBlank(selectedJackscrewDrilling2) && String.isNotBlank(selectedLining) && String.isNotBlank(selectedCoating) && String.isNotBlank(selectedFacing)
        //     && String.isNotBlank(selectedEyeboltsOutlet) && String.isNotBlank(selectedKnifebladeMaterial) && String.isNotBlank(selectedGaugeTap)
        //     && COOUTArray != null && COOUTArray.size() > 0){
        System.debug(' bore2Query ########### '+bore2OutletQuery);
        for(Holder_Option__c ho: Database.query(bore2OutletQuery)){
            if(String.isNotBlank(ho.Bore__c)){
                optionsMap.put(ho.Bore__c,ho.Bore__c);
            }
        }
        for(String option: optionsMap.keySet()){
            bore2Options.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' bore2Options ########### '+bore2Options);
        if(bore2Options.size() == 1 && bore2Options[0].getValue() == ''){
            bore2Flag = false;
            selectedBore2 = null;
        }else{
            bore2Flag = true;
        }
        
        //}
        return null;
    }
    
    public Pagereference handleBore2Change(){
        knifebladeMaterialSelectOptions();
        gaugeTapSelectOptions();
        eyeboltsOutletSelectOptions();
        facingSelectOptions();
        coatingSelectOptions();
        LiningSelectOptions();
        jackscrewDrillingSelectOptions2();
        outletOptionsAssignment();
        return null;
    }
    
    set<String> COOUTArray2 = new set<String>();
    public void outletOptionsAssignment(){
        String outletOptionsQuery = 'SELECT OptionCode__c FROM Holder_Option__c WHERE JHook__c = \'None\' ';
        if(COOUTArray != null && COOUTArray.size() > 0){
            outletOptionsQuery += ' AND OptionCode__c IN: COOUTArray';
            for(String str: COOUTArray){
                system.debug(' COOUT '+str);
            }
        }
        if(String.isNotBlank(selectedKnifebladeMaterial)){
            system.debug(' selectedKnifebladeMaterial '+selectedKnifebladeMaterial);
            outletOptionsQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterial';
            //}else if(! isKnifebladeMaterialFlag)
        }else{
            outletOptionsQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTap)){
            system.debug(' selectedGaugeTap '+selectedGaugeTap);
            outletOptionsQuery += ' AND GaugeTap__c =: selectedGaugeTap';
            //}else if(! gaugeTapFlag){
        }else{
            outletOptionsQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsOutlet)){
            system.debug(' selectedEyeboltsOutlet '+selectedEyeboltsOutlet);
            outletOptionsQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsOutlet';
            //}else if(! eyeboltsOutletFlag){
        }else{
            outletOptionsQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacing)){
            system.debug(' selectedFacing '+selectedFacing);
            outletOptionsQuery += ' AND Facing__c =: selectedFacing';
            //}else if(! facingFlag){
        }else{
            outletOptionsQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoating)){
            system.debug(' selectedCoating '+selectedCoating);
            outletOptionsQuery += ' AND Coating__c =: selectedCoating';
            //}else if(! CoatingFlag){
        }else{
            outletOptionsQuery += ' AND Coating__c = \'None\' ';
        }
        if(String.isNotBlank(selectedLining)){
            system.debug(' selectedLining '+selectedLining);
            outletOptionsQuery += ' AND Lining__c =: selectedLining';
            //}else if(! LiningFlag){
        }else{
            outletOptionsQuery += ' AND Lining__c = \'None\' ';
        }
        if(String.isNotBlank(selectedJackscrewDrilling2)){
            system.debug(' selectedJackscrewDrilling2 '+selectedJackscrewDrilling2);
            outletOptionsQuery += ' AND JackscrewDrilling__c =: selectedJackscrewDrilling2';
            //}else if(! jackscrewDrillingFlag2){
        }else{
            outletOptionsQuery += ' AND JackscrewDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedBore2)){
            system.debug(' selectedBore2 '+selectedBore2);
            outletOptionsQuery += ' AND Bore__c =: selectedBore2';
            //}else if(! bore2Flag){
        }else{
            outletOptionsQuery += ' AND Bore__c = \'None\' ';
        }
        // if(String.isNotBlank(selectedBore2) && String.isNotBlank(selectedJackscrewDrilling2) && String.isNotBlank(selectedLining) && String.isNotBlank(selectedCoating)
        //     && String.isNotBlank(selectedFacing) && String.isNotBlank(selectedEyeboltsOutlet) && String.isNotBlank(selectedKnifebladeMaterial)
        //     && String.isNotBlank(selectedGaugeTap)){
        system.debug('outletOptionsQuery '+outletOptionsQuery);
        system.debug('COOUTArray '+COOUTArray);
        for(Holder_Option__c ho: Database.query(outletOptionsQuery)){
            conHolder.Outlet_Option2__c = ho.OptionCode__c;
        }
        // String COOUTArray2Str = '';
        // for(String str: COOUTArray2){
        //     COOUTArray2Str += str +', ';
        // }
        // conHolder.Outlet_Option2__c = COOUTArray2Str;
        // System.debug(' conHolder.Outlet_Option2__c ########### '+conHolder.Outlet_Option2__c);
        if(COOUTArray2.size() > 0 ){
            //NippleSelectOptions();
        }
        //}
    }
    
    public String selectedNipple2{get;set;}
    public List<SelectOption> nipple2Options{get;set;}
    public Pagereference NippleSelectOptions(){
        if(nipple2Flag){
            nipple2Options = new List<selectOption>();
            nipple2Options.add(new selectOption('','None'));
            map<String,String> optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT Desc__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Nipple']){
                                             optionsMap.put(ho.Desc__c,ho.Desc__c);
                                         }
            for(String option: optionsMap.keySet()){
                nipple2Options.add(new selectOption(option,optionsMap.get(option)));
            }
            system.debug(' nipple2Options ############## '+nipple2Options);
        }
        return null;
    }
    
    public Pagereference handleNipple2Change(){
        return null;
    }
    
    public String selectedTee2{get;set;}
    public List<SelectOption> tee2Options{get;set;}
    public Pagereference tee2SelectOptions(){
        if(tee2Flag){
            tee2Options = new List<selectOption>();
            tee2Options.add(new selectOption('','None'));
            map<String,String> optionsMap = new map<String,String>();
            //Query to be modified - SELECT Desc__c FROM Holder_Structure__c WHERE Holder_Structure_Type__c = 'Tee' AND PTC__c =:conHolder.Holder_Product_Code__c
            for(Holder_Structure__c ho: [SELECT Desc__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Tee']){
                                             optionsMap.put(ho.Desc__c,ho.Desc__c);
                                         }
            for(String option: optionsMap.keySet()){
                tee2Options.add(new selectOption(option,optionsMap.get(option)));
            }
            system.debug(' tee2Options ########### '+tee2Options);
        }
        return null;
    }
    
    public Pagereference handleTee2Change(){
        System.debug('*****selectedTee2**'+selectedTee2);
        return null;
    }
    
    public String selectedReducingBushing{get;set;}
    public List<SelectOption> reducingBushingOptions{get;set;}
    public list<String> dummyList{get;set;}
    public Pagereference reducingBushingSelectOptions(){
        if(reducingBushingFlag){
            reducingBushingOptions = new List<selectOption>();
            reducingBushingOptions.add(new selectOption('','None'));
            map<String,String> optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT ReducerBushingSelection__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Reducer Bushing' LIMIT 50000]){
                                             optionsMap.put(ho.ReducerBushingSelection__c,ho.ReducerBushingSelection__c);
                                         }
            for(String option: optionsMap.keySet()){
                reducingBushingOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            System.debug(' reducingBushingOptions ############### '+reducingBushingOptions);
        }
        return null;
    }
    
    public String selectedUOMPressRange{get;set;}
    public List<SelectOption> UOMPressRangeOptions{get;set;}
    public Boolean isselectedUOMPressRange{get;set;}
    public Pagereference uOMPressRangeSelectList(){
        UOMPressRangeOptions = new List<selectOption>();
        UOMPressRangeOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        if(pressureGaugeFlag){
            for(Holder_Structure__c ho: [SELECT PressUnits__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Gauge' LIMIT 50000]){
                                             optionsMap.put(ho.PressUnits__c,ho.PressUnits__c);
                                         }
            for(String option: optionsMap.keySet()){
                UOMPressRangeOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        return null;
    }
    
    public Pagereference handleUOMPressRangeChange(){
        if(String.isBlank(selectedUOMPressRange)) {
            conHolder.Gauge_Selection_Outlet__c = '';
            selectedTubeCaseMaterial = null;
            selectedPhysicalProperties = null;
        }
        physicalPropertiesSelectOptions();
        tubeCaseMaterialSelectOptions();
        return null;
    }
    
    public String selectedPhysicalProperties{get;set;}
    public List<SelectOption> physicalPropertiesOptions{get;set;}
    public Pagereference physicalPropertiesSelectOptions(){
        physicalPropertiesOptions = new List<selectOption>();
        physicalPropertiesOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        if(pressureGaugeFlag){
            String UOMPressRangeQuery = 'SELECT PhysicalProps__c FROM Holder_Structure__c WHERE Holder_Structure_Type__c = \'Gauge\'';
            if(String.isNotBlank(selectedUOMPressRange)){
                UOMPressRangeQuery += ' AND PressUnits__c =: selectedUOMPressRange';
                isselectedUOMPressRange = true;
            }else{
                isselectedUOMPressRange = false;
            }
            for(Holder_Structure__c ho: Database.query(UOMPressRangeQuery)){
                optionsMap.put(ho.PhysicalProps__c,ho.PhysicalProps__c);
                
            }
            for(String option: optionsMap.keySet()){
                physicalPropertiesOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            system.debug('physicalPropertiesOptions ########### '+physicalPropertiesOptions);
        }
        return null;
    }
    
    public Pagereference handlePhysicalPropertiesChange(){
        System.debug('######physicalPropertiesOptions**'+physicalPropertiesOptions);
        System.debug('######selectedPhysicalProperties**'+selectedPhysicalProperties);
        tubeCaseMaterialSelectOptions();
        return null;
    }
    
    public String selectedTubeCaseMaterial{get;set;}
    public List<SelectOption> tubeCaseMaterialOptions{get;set;}
    public Boolean isselectedPhysicalProperties{get;set;}
    public Pagereference tubeCaseMaterialSelectOptions(){
        tubeCaseMaterialOptions = new List<selectOption>();
        tubeCaseMaterialOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug('********************selectedPhysicalProperties**'+selectedPhysicalProperties);
        if(pressureGaugeFlag){
            String tubeCaseMaterialQuery = 'SELECT TubeCaseMatl__c FROM Holder_Structure__c WHERE Holder_Structure_Type__c = \'Gauge\'';
            if(String.isNotBlank(selectedUOMPressRange)){
                tubeCaseMaterialQuery += ' AND PressUnits__c =: selectedUOMPressRange';
            }
            if(String.isNotBlank(selectedPhysicalProperties)){
                isselectedPhysicalProperties = true;
                tubeCaseMaterialQuery += ' AND PhysicalProps__c =: selectedPhysicalProperties';
            }else{
                isselectedPhysicalProperties = false;
            }
            for(Holder_Structure__c ho: Database.query(tubeCaseMaterialQuery)){
                optionsMap.put(ho.TubeCaseMatl__c,ho.TubeCaseMatl__c);
            }
            for(String option: optionsMap.keySet()){
                if(option != null) {
                    
                    tubeCaseMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                }
            }
        }
        return null;
    }
    
    public Pagereference handleTubeCaseMaterialChange(){
        physicalPropertiesSelectOptions();
        if(pressureGaugeFlag && String.isNotBlank(selectedUOMPressRange) && String.isNotBlank(selectedPhysicalProperties)
           && String.isNotBlank(selectedTubeCaseMaterial)){
               for(Holder_Structure__c ho: [SELECT Gauge_Selection__c FROM Holder_Structure__c
                                            WHERE Holder_Structure_Type__c = 'Gauge'
                                            AND PressUnits__c =: selectedUOMPressRange
                                            AND PhysicalProps__c =:selectedPhysicalProperties
                                            AND TubeCaseMatl__c =: selectedTubeCaseMaterial LIMIT 1]){
                                                conHolder.Gauge_Selection_Outlet__c = ho.Gauge_Selection__c;
                                            }
               //excessFlowValveSelectOptions();
           }
        return null;
    }
    
    
    public String selectedExcessFlowValve{get;set;}
    public List<SelectOption> excessFlowValveOptions{get;set;}
    public Pagereference excessFlowValveSelectOptions(){
        if(excessFlowValveFlag){
            excessFlowValveOptions = new List<selectOption>();
            excessFlowValveOptions.add(new selectOption('','None'));
            map<String,String> optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT Desc__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Excess Flow Valve' LIMIT 50000]){
                                             optionsMap.put(ho.Desc__c,ho.Desc__c);
                                         }
            for(String option: optionsMap.keySet()){
                excessFlowValveOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            system.debug(' excessFlowValveOptions ############## '+excessFlowValveOptions);
        }
        return null;
    }
    
    public Pagereference clearOutletSection(){
        //selectedOutletMaterial = null;
        selectedKnifebladeMaterial = null;
        selectedGaugeTap = null;
        selectedEyeboltsOutlet = null;
        selectedFacing = null;
        selectedCoating = null;
        selectedLining = null;
        selectedJackscrewDrilling2 = null;
        selectedBore2 = null;
        selectedNipple2 = null;
        selectedTee2 = null;
        selectedReducingBushing = null;
        selectedUOMPressRange = null;
        selectedPhysicalProperties = null;
        selectedTubeCaseMaterial = null;
        selectedExcessFlowValve = null;
        eyeboltMaterialOutlet = null;
        isselectedUOMPressRange = false;
        isselectedPhysicalProperties = false;
        conHolder.Gauge_Selection_Outlet__c = '';
        handleOutletMaterialChange();
        handleGaugeTapChange();
        return null;
    }
    
    
    public boolean midFlangeSectionFlag{get;set;}
    public void isMidFlangeSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            midFlangeSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Mid_Flange__c');
        }
        System.debug(' Holder_Product_Code__c '+conHolder.Holder_Product_Code__c);
        System.debug(' midFlangeSectionFlag '+midFlangeSectionFlag);
    }
    
    public String selectedMidFlangeMaterial{get;set;}
    public List<SelectOption> midFlangeMaterialOptions{get;set;}
    //public boolean midFlangeMaterialFlag{get;set;}
    public Pagereference midFlangeMaterialSelectOptions(){
        midFlangeMaterialOptions = new List<selectOption>();
        //midFlangeMaterialFlag = false;
        midFlangeMaterialOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' size2 '+size2+' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c +' selectedBotingClass '+selectedBotingClass);
        if(conHolder.Holder_Product_Code__c != null && selectedBotingClass != null && String.isNotBlank(size2)){
            for(Holder_Structure__c ho: [SELECT MCMFLG__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Mid Flange' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                             optionsMap.put(ho.MCMFLG__c, matCodeMap.containsKey(ho.MCMFLG__c) ? matCodeMap.get(ho.MCMFLG__c) : ho.MCMFLG__c);
                                         }
            for(String option: optionsMap.keySet()){
                if (conHolder.ATEX_Certificate__c)
                {
                    if (!AtexExcludeMatOptions.contains(option)) {
                        if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103') {
                            if(NACEIncludeMatOptions.contains(option))
                                midFlangeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                        } else {
                            midFlangeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                        }
                    }
                } else {
                    if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103') {
                        if(NACEIncludeMatOptions.contains(option))
                            midFlangeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                    } else {
                        midFlangeMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                    }
                }
                
            }
        }
        system.debug(' midFlangeMaterialOptions ########### '+midFlangeMaterialOptions);
        return null;
    }
    public List<String> AtexExcludeMatOptions = new List<String>{'001','009'};
        public List<String> NACEIncludeMatOptions = new List<String>{'002', '003', '005', '007', '020', '022', '050', '051', '052'};
            //calculate Mid_Flange_Options__c
            set<String> MIDFLGArray = new set<String>();
    public boolean isMidFlangeMaterialSelected{get;set;}
    public Pagereference handleMidFlangeMaterialChange(){
        if(String.isNotBlank(selectedMidFlangeMaterial)){
            isMidFlangeMaterialSelected = true;
            for(Holder_Structure__c ho: [SELECT OptionCode__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Mid Flange' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass
                                         AND MCMFLG__c =: selectedMidFlangeMaterial LIMIT 50000]){
                                             MIDFLGArray.add(ho.OptionCode__c);
                                         }
            String opCodes = '';
            for(String opCode: MIDFLGArray){
                opCodes += opCode + ', ';
            }
            system.debug('Mid fl opCodes '+opCodes);
            conHolder.Mid_Flange_Options__c = opCodes;
            gaugeTap2SelectOptions();
            eyeboltsDrillingMFLGSelectOptions();
            coatingMFLGSelectOptions();
            LiningMFLGSelectOptions();
            assignMidFlangeOptions();
            
        }else{
            isMidFlangeMaterialSelected = false;
        }
        return null;
    }
    
    
    public String selectedGaugeTap2{get;set;}
    public List<SelectOption> gaugeTap2Options{get;set;}
    public boolean gaugeTap2Flag{get;set;}
    public Pagereference gaugeTap2SelectOptions(){
        gaugeTap2Options = new List<selectOption>();
        gaugeTap2Options.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' MIDFLGArray '+MIDFLGArray);
        String gaugeTap2Query = 'SELECT GaugeTap__c FROM Holder_Option__c WHERE Knifeblade_Material__c = \'None\' AND GaugeTap__c != \'None\' ';
        gaugeTap2Query += ' AND JHook__c = \'None\' ';
        gaugeTap2Query += ' AND Facing__c = \'None\' ';
        gaugeTap2Query += ' AND JackscrewDrilling__c = \'None\'';
        gaugeTap2Query += ' AND Bore__c = \'None\'';
        if(MIDFLGArray != null && MIDFLGArray.size() > 0){
            gaugeTap2Query += ' AND OptionCode__c IN: MIDFLGArray';
        }
        for(Holder_Option__c ho: Database.query(gaugeTap2Query)){
            if(String.isNotBlank(ho.GaugeTap__c)){
                optionsMap.put(ho.GaugeTap__c,ho.GaugeTap__c);
            }
        }
        for(String option: optionsMap.keySet()){
            gaugeTap2Options.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug(' gaugeTap2Options ########### '+gaugeTap2Options);
        if(gaugeTap2Options.size() == 1 && gaugeTap2Options[0].getValue() == ''){
            gaugeTap2Flag = false;
            selectedGaugeTap2 = null;
        }else{
            gaugeTap2Flag = true;
        }
        return null;
    }
    
    
    public boolean nippleMFLGFlag{get;set;}
    public boolean teeMFLGFlag{get;set;}
    public boolean reducingBushingMFLGFlag{get;set;}
    public boolean pressureGaugeMFLGFlag{get;set;}
    public Boolean excessFlowMFLGValveFlag{get;set;}
    public Boolean isGaugeTap2Selected{get;set;}
    public Pagereference handleGaugeTap2Change(){
        nippleMFLGFlag = false;
        teeMFLGFlag = false;
        reducingBushingMFLGFlag = false;
        pressureGaugeMFLGFlag = false;
        excessFlowMFLGValveFlag = false;
        system.debug('selectedGaugeTap2 '+selectedGaugeTap2+' conHolder.Mid_Flange_Option__c '+conHolder.Mid_Flange_Option__c);
        if(String.isNotBlank(selectedGaugeTap2)){
            isGaugeTap2Selected = true;
            for(Holder_Option__c ho: [SELECT Nipple__c, Tee__c, Reducing_Bushing__c, Pressure_Gauge__c, Excess_Flow_Valve__c FROM Holder_Option__c
                                      WHERE GaugeTap__c =: selectedGaugeTap2 LIMIT 1]){
                                          nippleMFLGFlag = ho.Nipple__c;
                                          teeMFLGFlag = ho.Tee__c;
                                          reducingBushingMFLGFlag = ho.Reducing_Bushing__c;
                                          pressureGaugeMFLGFlag = ho.Pressure_Gauge__c;
                                          excessFlowMFLGValveFlag = ho.Excess_Flow_Valve__c;
                                      }
        }else{
            isGaugeTap2Selected = false;
            selectedNippleMFLG = null;
            selectedTeeMFLG = null;
            selectedReducingBushingMFLG = null;
            selectedExcessFlowMFLGValve = null;
            selectedUOMPressMFLGRange = null;
            selectedPhysicalMFLGProperties = null;
            selectedTubeCaseMFLGMaterial = null;
        }
        eyeboltsDrillingMFLGSelectOptions();
        coatingMFLGSelectOptions();
        LiningMFLGSelectOptions();
        assignMidFlangeOptions();
        
        nippleMFLGSelectOptions();
        excessFlowMFLGValveSelectOptions();
        
        physicalMFLGPropertiesSelectOptions();
        tubeCaseMFLGMaterialSelectOptions();
        gaugeSelectionMidFlangeAssignment();
        return null;
    }
    
    public String selectedEyeboltsDrillingMFLG{get;set;}
    public List<SelectOption> eyeboltsDrillingMFLGOptions{get;set;}
    public boolean eyeboltsDrillingMFLGFlag{get;set;}
    public Pagereference eyeboltsDrillingMFLGSelectOptions(){
        eyeboltsDrillingMFLGOptions = new List<selectOption>();
        eyeboltsDrillingMFLGOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        String eyeboltsDrillingMFLGQuery = 'SELECT EyeboltDrilling__c FROM Holder_Option__c WHERE Knifeblade_Material__c = \'None\' AND EyeboltDrilling__c != \'None\' ';
        eyeboltsDrillingMFLGQuery += ' AND JHook__c = \'None\' ';
        eyeboltsDrillingMFLGQuery += ' AND Facing__c = \'None\' ';
        eyeboltsDrillingMFLGQuery += ' AND JackscrewDrilling__c = \'None\'';
        eyeboltsDrillingMFLGQuery += ' AND Bore__c = \'None\'';
        if(MIDFLGArray != null && MIDFLGArray.size() > 0){
            eyeboltsDrillingMFLGQuery += ' AND OptionCode__c IN: MIDFLGArray';
        }
        if(String.isNotBlank(selectedGaugeTap2)){
            eyeboltsDrillingMFLGQuery += ' AND GaugeTap__c =: selectedGaugeTap2';
            //}else if(! gaugeTap2Flag){
        }else{
            eyeboltsDrillingMFLGQuery += ' AND GaugeTap__c = \'None\' ';
        }
        for(Holder_Option__c ho: Database.query(eyeboltsDrillingMFLGQuery)){
            if(String.isNotBlank(ho.EyeboltDrilling__c)){
                optionsMap.put(ho.EyeboltDrilling__c,ho.EyeboltDrilling__c);
            }
        }
        for(String option: optionsMap.keySet()){
            eyeboltsDrillingMFLGOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug(' eyeboltsDrillingMFLGOptions ########### '+eyeboltsDrillingMFLGOptions);
        if(eyeboltsDrillingMFLGOptions.size() == 1 && eyeboltsDrillingMFLGOptions[0].getValue() == ''){
            eyeboltsDrillingMFLGFlag = false;
            selectedEyeboltsDrillingMFLG = null;
        }else{
            eyeboltsDrillingMFLGFlag = true;
        }
        return null;
    }
    
    public String eyeboltMaterialMDFLG{get;set;}
    public Pagereference handleEyeboltsDrillingMFLGChange(){
        gaugeTap2SelectOptions();
        coatingMFLGSelectOptions();
        LiningMFLGSelectOptions();
        assignMidFlangeOptions();
        if(String.isNotBlank(selectedEyeboltsDrillingMFLG)){
            eyeboltMaterialMDFLG = 'Carbon Steel';
        }else{
            eyeboltMaterialMDFLG = null;
        }
        return null;
    }
    
    public String selectedCoatingMFLG{get;set;}
    public List<SelectOption> coatingMFLGOptions{get;set;}
    public boolean coatingMFLGFlag{get;set;}
    public Pagereference coatingMFLGSelectOptions(){
        coatingMFLGOptions = new List<selectOption>();
        coatingMFLGOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' MIDFLGArray '+MIDFLGArray);
        String  coatingMFLGQuery = 'SELECT Coating__c FROM Holder_Option__c WHERE Knifeblade_Material__c = \'None\' AND Coating__c != \'None\' ';
        coatingMFLGQuery += ' AND JHook__c = \'None\' ';
        coatingMFLGQuery += ' AND Facing__c = \'None\' ';
        coatingMFLGQuery += ' AND JackscrewDrilling__c = \'None\'';
        coatingMFLGQuery += ' AND Bore__c = \'None\'';
        if(MIDFLGArray != null && MIDFLGArray.size() > 0){
            coatingMFLGQuery += ' AND OptionCode__c IN: MIDFLGArray';
        }
        if(String.isNotBlank(selectedGaugeTap2)){
            coatingMFLGQuery += ' AND GaugeTap__c =: selectedGaugeTap2';
            //}else if(! gaugeTap2Flag){
        }else{
            coatingMFLGQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingMFLG)){
            coatingMFLGQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingMFLG';
            //}else if(! eyeboltsDrillingMFLGFlag){
        }else{
            coatingMFLGQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        //if(String.isNotBlank(selectedEyeboltsDrillingMFLG) && String.isNotBlank(selectedGaugeTap2) && MIDFLGArray != null && MIDFLGArray.size() > 0){
        for(Holder_Option__c ho: Database.query(coatingMFLGQuery)){
            if(String.isNotBlank(ho.Coating__c)){
                optionsMap.put(ho.Coating__c,ho.Coating__c);
            }
        }
        for(String option: optionsMap.keySet()){
            coatingMFLGOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug('coatingMFLGOptions ############ '+coatingMFLGOptions);
        if(coatingMFLGOptions.size() == 1 && coatingMFLGOptions[0].getValue() == ''){
            coatingMFLGFlag = false;
            selectedCoatingMFLG = null;
        }else{
            coatingMFLGFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleCoatingMFLGChange(){
        gaugeTap2SelectOptions();
        eyeboltsDrillingMFLGSelectOptions();
        LiningMFLGSelectOptions();
        assignMidFlangeOptions();
        return null;
    }
    
    public String selectedLiningMFLG{get;set;}
    public List<SelectOption> LiningMFLGOptions{get;set;}
    public boolean liningMFLGFlag{get;set;}
    public Pagereference LiningMFLGSelectOptions(){
        LiningMFLGOptions = new List<selectOption>();
        LiningMFLGOptions.add(new selectOption('','None'));
        map<String,String> optionsMap = new map<String,String>();
        System.debug(' MIDFLGArray '+MIDFLGArray);
        String  LiningMFLGQuery = 'SELECT Lining__c FROM Holder_Option__c WHERE Knifeblade_Material__c = \'None\' AND Lining__c != \'None\' ';
        LiningMFLGQuery += ' AND JHook__c = \'None\' ';
        LiningMFLGQuery += ' AND Facing__c = \'None\' ';
        LiningMFLGQuery += ' AND JackscrewDrilling__c = \'None\'';
        LiningMFLGQuery += ' AND Bore__c = \'None\'';
        if(MIDFLGArray != null && MIDFLGArray.size() > 0){
            LiningMFLGQuery += ' AND OptionCode__c IN: MIDFLGArray';
        }
        if(String.isNotBlank(selectedGaugeTap2)){
            LiningMFLGQuery += ' AND GaugeTap__c =: selectedGaugeTap2';
            //}else if(! gaugeTap2Flag){
        }else{
            LiningMFLGQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingMFLG)){
            LiningMFLGQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingMFLG';
            //}else if(! eyeboltsDrillingMFLGFlag){
        }else{
            LiningMFLGQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoatingMFLG)){
            LiningMFLGQuery += ' AND Coating__c =: selectedCoatingMFLG';
            //}else if(! coatingMFLGFlag){
        }else{
            LiningMFLGQuery += ' AND Coating__c = \'None\' ';
        }
        // if(String.isNotBlank(selectedCoatingMFLG) && String.isNotBlank(selectedEyeboltsDrillingMFLG) && String.isNotBlank(selectedGaugeTap2) && MIDFLGArray != null
        //     && MIDFLGArray.size() > 0){
        for(Holder_Option__c ho: Database.query(LiningMFLGQuery)){
            if(String.isNotBlank(ho.Lining__c)){
                optionsMap.put(ho.Lining__c,ho.Lining__c);
            }
        }
        for(String option: optionsMap.keySet()){
            LiningMFLGOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        if(LiningMFLGOptions.size() == 1 && LiningMFLGOptions[0].getValue() == ''){
            liningMFLGFlag = false;
            selectedLiningMFLG = null;
        }else{
            liningMFLGFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleLiningMFLGChange(){
        gaugeTap2SelectOptions();
        eyeboltsDrillingMFLGSelectOptions();
        coatingMFLGSelectOptions();
        assignMidFlangeOptions();
        return null;
    }
    
    //calculate Mid_Flange_Options__c
    public Pagereference assignMidFlangeOptions(){
        String  midFlangeOptionQuery = 'SELECT OptionCode__c FROM Holder_Option__c WHERE Knifeblade_Material__c = \'None\'  ';
        midFlangeOptionQuery += ' AND JHook__c = \'None\' ';
        midFlangeOptionQuery += ' AND Facing__c = \'None\' ';
        midFlangeOptionQuery += ' AND JackscrewDrilling__c = \'None\'';
        midFlangeOptionQuery += ' AND Bore__c = \'None\'';
        if(MIDFLGArray != null && MIDFLGArray.size() > 0){
            midFlangeOptionQuery += ' AND OptionCode__c IN: MIDFLGArray';
        }
        if(String.isNotBlank(selectedGaugeTap2)){
            midFlangeOptionQuery += ' AND GaugeTap__c =: selectedGaugeTap2';
            //}else if(! gaugeTap2Flag){
        }else{
            midFlangeOptionQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingMFLG)){
            midFlangeOptionQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingMFLG';
            //}else if(! eyeboltsDrillingMFLGFlag){
        }else{
            midFlangeOptionQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoatingMFLG)){
            midFlangeOptionQuery += ' AND Coating__c =: selectedCoatingMFLG';
            //}else if(! coatingMFLGFlag){
        }else{
            midFlangeOptionQuery += ' AND Coating__c = \'None\' ';
        }
        if(String.isNotBlank(selectedLiningMFLG)){
            midFlangeOptionQuery += ' AND Lining__c =: selectedLiningMFLG';
            //}else if(! liningMFLGFlag){
        }else{
            midFlangeOptionQuery += ' AND Lining__c = \'None\' ';
        }
        for(Holder_Option__c ho: Database.query(midFlangeOptionQuery)){
            conHolder.Mid_Flange_Option__c = ho.OptionCode__c;
        }
        // if(conHolder.Mid_Flange_Option__c != null){
        //     nippleMFLGSelectOptions();
        // }
        return null;
    }
    
    
    public String selectedNippleMFLG{get;set;}
    public List<SelectOption> nippleMFLGOptions{get;set;}
    public String selectedTeeMFLG{get;set;}
    public List<SelectOption> teeMFLGOptions{get;set;}
    public String selectedReducingBushingMFLG{get;set;}
    public List<SelectOption> reducingBushingMFLGOptions{get;set;}
    public String selectedUOMPressMFLGRange{get;set;}
    public List<SelectOption> UOMPressRangeMFLGOptions{get;set;}
    public Pagereference nippleMFLGSelectOptions(){
        nippleMFLGOptions = new List<selectOption>();
        nippleMFLGOptions.add(new selectOption('','None'));
        teeMFLGOptions = new List<selectOption>();
        teeMFLGOptions.add(new selectOption('','None'));
        reducingBushingMFLGOptions = new List<selectOption>();
        reducingBushingMFLGOptions.add(new selectOption('','None'));
        UOMPressRangeMFLGOptions = new List<selectOption>();
        UOMPressRangeMFLGOptions.add(new selectOption('','None'));
        map<String,String> teeOptionsMap = new map<String,String>();
        map<String,String> nippleOptionsMap = new map<String,String>();
        map<String,String> reducingBushingOptionsMap = new map<String,String>();
        map<String,String> UOMPressRangeMFLGOptionsMap = new map<String,String>();
        System.debug(' MIDFLGArray '+MIDFLGArray);
        //if(conHolder.Mid_Flange_Option__c != null && String.isNotBlank(selectedGaugeTap2)){
        list<String> holderStructureTypes = new list<String>{'Nipple', 'Tee', 'Reducer Bushing','Gauge'};
            for(Holder_Structure__c ho: [SELECT Desc__c, ReducerBushingSelection__c, PressUnits__c, Holder_Structure_Type__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c IN: holderStructureTypes LIMIT 50000]){
                                             if(nippleMFLGFlag && ho.Holder_Structure_Type__c == 'Nipple' && ho.Desc__c != null){
                                                 nippleOptionsMap.put(ho.Desc__c,ho.Desc__c);
                                             }else if(teeMFLGFlag && ho.Holder_Structure_Type__c == 'Tee'  && ho.Desc__c != null){
                                                 teeOptionsMap.put(ho.Desc__c,ho.Desc__c);
                                             }else if(reducingBushingMFLGFlag && ho.Holder_Structure_Type__c == 'Reducer Bushing' && ho.ReducerBushingSelection__c != null){
                                                 reducingBushingOptionsMap.put(ho.ReducerBushingSelection__c,ho.ReducerBushingSelection__c);
                                             }else if(ho.Holder_Structure_Type__c == 'Gauge'){
                                                 if(reducingBushingMFLGFlag && ho.ReducerBushingSelection__c != null){
                                                     reducingBushingOptionsMap.put(ho.ReducerBushingSelection__c,ho.ReducerBushingSelection__c);
                                                 }
                                                 if(pressureGaugeMFLGFlag && ho.PressUnits__c != null){
                                                     UOMPressRangeMFLGOptionsMap.put(ho.PressUnits__c,ho.PressUnits__c);
                                                 }
                                             }
                                         }
        for(String option: teeOptionsMap.keySet()){
            teeMFLGOptions.add(new selectOption(option,teeOptionsMap.get(option)));
        }
        for(String option: nippleOptionsMap.keySet()){
            nippleMFLGOptions.add(new selectOption(option,nippleOptionsMap.get(option)));
        }
        for(String option: reducingBushingOptionsMap.keySet()){
            reducingBushingMFLGOptions.add(new selectOption(option,reducingBushingOptionsMap.get(option)));
        }
        for(String option: UOMPressRangeMFLGOptionsMap.keySet()){
            UOMPressRangeMFLGOptions.add(new selectOption(option,UOMPressRangeMFLGOptionsMap.get(option)));
        }
        //}
        return null;
    }
    
    public Pagereference handleUOMPressRangeMFLGChange(){
        if(selectedUOMPressMFLGRange == null) {
            conHolder.Gauge_Selection_Mid_Flange__c = '';
            selectedTubeCaseMFLGMaterial = null;
            selectedPhysicalMFLGProperties = null;
        } 
        physicalMFLGPropertiesSelectOptions();
        tubeCaseMFLGMaterialSelectOptions();
        gaugeSelectionMidFlangeAssignment();
        return null;
    }
    
    public String selectedPhysicalMFLGProperties{get;set;}
    public List<SelectOption> physicalMFLGPropertiesOptions{get;set;}
    public Boolean isselectedUOMPressMFLGRange{get;set;}
    public Pagereference physicalMFLGPropertiesSelectOptions(){
        physicalMFLGPropertiesOptions = new List<selectOption>();
        physicalMFLGPropertiesOptions.add(new selectOption('','None'));
        String physicalMFLGPropertiesQuery = 'SELECT PhysicalProps__c  FROM Holder_Structure__c WHERE Holder_Structure_Type__c = \'Gauge\'';
        if(String.isNotBlank(selectedUOMPressMFLGRange)){
            isselectedUOMPressMFLGRange = true;
            physicalMFLGPropertiesQuery += ' AND PressUnits__c =: selectedUOMPressMFLGRange';
        }else{
            isselectedUOMPressMFLGRange = false;
        }
        map<String,String>  optionsMap = new map<String,String>();
        System.debug(' selectedUOMPressMFLGRange '+selectedUOMPressMFLGRange);
        for(Holder_Structure__c ho: Database.query(physicalMFLGPropertiesQuery)){
            optionsMap.put(ho.PhysicalProps__c,ho.PhysicalProps__c);
        }
        for(String option: optionsMap.keySet()){
            physicalMFLGPropertiesOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        return null;
    }
    
    public Pagereference handlePhysicalMFLGPropertiesChange(){
        tubeCaseMFLGMaterialSelectOptions();
        gaugeSelectionMidFlangeAssignment();
        return null;
    }
    
    public String selectedTubeCaseMFLGMaterial{get;set;}
    public List<SelectOption> tubeCaseMFLGMaterialOptions{get;set;}
    public Boolean isselectedPhysicalMFLGProperties{get;set;}
    public Pagereference tubeCaseMFLGMaterialSelectOptions(){
        tubeCaseMFLGMaterialOptions = new List<selectOption>();
        tubeCaseMFLGMaterialOptions.add(new selectOption('','None'));
        String tubeCaseMFLGMaterialQuery = 'SELECT TubeCaseMatl__c  FROM Holder_Structure__c WHERE Holder_Structure_Type__c = \'Gauge\'';
        if(String.isNotBlank(selectedUOMPressMFLGRange)){
            tubeCaseMFLGMaterialQuery += ' AND PressUnits__c =: selectedUOMPressMFLGRange';
        }
        if(String.isNotBlank(selectedPhysicalMFLGProperties)){
            tubeCaseMFLGMaterialQuery += ' AND PhysicalProps__c =: selectedPhysicalMFLGProperties';
            isselectedPhysicalMFLGProperties = true;
        }else{
            isselectedPhysicalMFLGProperties = false;
        }
        map<String,String>  optionsMap = new map<String,String>();
        for(Holder_Structure__c ho: Database.query(tubeCaseMFLGMaterialQuery)){
            optionsMap.put(ho.TubeCaseMatl__c,ho.TubeCaseMatl__c);
        }
        for(String option: optionsMap.keySet()){
            tubeCaseMFLGMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        return null;
    }
    
    public Pagereference handleTubeCaseMFLGMaterialChange(){
        physicalMFLGPropertiesSelectOptions();
        gaugeSelectionMidFlangeAssignment();
        return null;
    }
    //calculate Gauge_Selection_Mid_Flange__c
    public Pagereference gaugeSelectionMidFlangeAssignment(){
        String gaugeSelectionMidFlangeQuery = 'SELECT Gauge_Selection__c  FROM Holder_Structure__c WHERE Holder_Structure_Type__c = \'Gauge\'';
        if(String.isNotBlank(selectedUOMPressMFLGRange)){
            gaugeSelectionMidFlangeQuery += ' AND PressUnits__c =: selectedUOMPressMFLGRange';
        }
        if(String.isNotBlank(selectedPhysicalMFLGProperties)){
            gaugeSelectionMidFlangeQuery += ' AND PhysicalProps__c =: selectedPhysicalMFLGProperties';
        }
        if(String.isNotBlank(selectedTubeCaseMFLGMaterial)){
            gaugeSelectionMidFlangeQuery += ' AND TubeCaseMatl__c =: selectedTubeCaseMFLGMaterial';
        }
        for(Holder_Structure__c ho: Database.query(gaugeSelectionMidFlangeQuery)){
            conHolder.Gauge_Selection_Mid_Flange__c = ho.Gauge_Selection__c;
        }
        return null;
    }
    
    public String selectedExcessFlowMFLGValve{get;set;}
    public List<SelectOption> excessFlowMFLGValveOptions{get;set;}
    public Pagereference excessFlowMFLGValveSelectOptions(){
        excessFlowMFLGValveOptions = new List<selectOption>();
        excessFlowMFLGValveOptions.add(new selectOption('','None'));
        System.debug(' excessFlowMFLGValveFlag '+excessFlowMFLGValveFlag);
        if(excessFlowMFLGValveFlag){
            map<String,String>  optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT Desc__c  FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Excess Flow Valve' LIMIT 50000]){
                                             if(string.isNotBlank(ho.Desc__c)){
                                                 optionsMap.put(ho.Desc__c,ho.Desc__c);
                                             }
                                         }
            for(String option: optionsMap.keySet()){
                excessFlowMFLGValveOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        return null;
    }
    
    public Pagereference clearMidFlangeSection(){
        selectedGaugeTap2 = null;
        selectedEyeboltsDrillingMFLG = null;
        selectedCoatingMFLG = null;
        selectedLiningMFLG = null;
        selectedNippleMFLG = null;
        selectedTeeMFLG = null;
        selectedReducingBushingMFLG = null;
        selectedExcessFlowMFLGValve = null;
        selectedUOMPressMFLGRange = null;
        selectedPhysicalMFLGProperties = null;
        selectedTubeCaseMFLGMaterial = null;
        eyeboltMaterialMDFLG = null;
        conHolder.Gauge_Selection_Mid_Flange__c = '';
        handleMidFlangeMaterialChange();
        handleGaugeTap2Change();
        return null;
    }
    
    public boolean nutSectionFlag{get;set;}
    public void isNutSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            nutSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Nut__c');
        }
        System.debug(' nutSectionFlag '+nutSectionFlag);
    }
    
    
    public String selectedNutMaterial{get;set;}
    public List<SelectOption> nutMaterialOptions{get;set;}
    public Pagereference nutMaterialSelectOptions(){
        nutMaterialOptions = new List<selectOption>();
        nutMaterialOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        for(Holder_Structure__c ho: [SELECT MCHN__c FROM Holder_Structure__c
                                     WHERE Holder_Structure_Type__c = 'Nut2'
                                     AND PTC__c =:conHolder.Holder_Product_Code__c
                                     AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                         if(string.isNotBlank(ho.MCHN__c)){
                                             optionsMap.put(ho.MCHN__c, matCodeMap.containsKey(ho.MCHN__c) ? matCodeMap.get(ho.MCHN__c) : ho.MCHN__c);
                                         }
                                     }
        for(String option: optionsMap.keySet()){
            nutMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug(' nutMaterialOptions ########### '+nutMaterialOptions);
        return null;
    }
    
    public boolean clampSectionFlag{get;set;}
    public void isClampSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            clampSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Clamp__c');
        }
        System.debug(' clampSectionFlag '+clampSectionFlag);
    }
    
    public String selectedClampMaterial{get;set;}
    public List<SelectOption> clampMaterialOptions{get;set;}
    public Pagereference clampMaterialSelectOptions(){
        clampMaterialOptions = new List<selectOption>();
        clampMaterialOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        for(Holder_Structure__c ho: [SELECT MCCLMP__c FROM Holder_Structure__c
                                     WHERE Holder_Structure_Type__c = 'Clamp2'
                                     AND PTC__c =:conHolder.Holder_Product_Code__c
                                     AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                         if(String.isNotBlank(ho.MCCLMP__c)){
                                             optionsMap.put(ho.MCCLMP__c, matCodeMap.containsKey(ho.MCCLMP__c) ? matCodeMap.get(ho.MCCLMP__c) : ho.MCCLMP__c);
                                         }
                                     }
        for(String option: optionsMap.keySet()){
            clampMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        system.debug(' clampMaterialOptions ######### '+clampMaterialOptions);
        return null;
    }
    
    public boolean holddownRingSectionFlag{get;set;}
    public void isHolddownRingSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            holddownRingSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Holddown_Ring__c');
        }
        System.debug(' Holder_Product_Code__c '+conHolder.Holder_Product_Code__c);
        // System.debug(' midFlangeSectionFlag '+midFlangeSectionFlag);
        System.debug(' holddownRingSectionFlag '+holddownRingSectionFlag);
    }
    
    public String selectedHolddownRingMaterial{get;set;}
    public List<SelectOption> holddownRingMaterialOptions{get;set;}
    public Pagereference holddownRingMaterialSelectOptions(){
        holddownRingMaterialOptions = new List<selectOption>();
        holddownRingMaterialOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        for(Holder_Structure__c ho: [SELECT MCHRNG__c FROM Holder_Structure__c
                                     WHERE Holder_Structure_Type__c = 'Ring2'
                                     AND PTC__c =:conHolder.Holder_Product_Code__c
                                     AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                         if(String.isNotBlank(ho.MCHRNG__c)){
                                             optionsMap.put(ho.MCHRNG__c, matCodeMap.containsKey(ho.MCHRNG__c) ? matCodeMap.get(ho.MCHRNG__c) : ho.MCHRNG__c);
                                         }
                                     }
        for(String option: optionsMap.keySet()){
            holddownRingMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        return null;
    }
    
    public boolean inletSectionFlag{get;set;}
    public void isInletSectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            inletSectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Inlet__c');
        }
        System.debug(' inletSectionFlag '+inletSectionFlag);
    }
    
    public String selectedInletMaterial{get;set;}
    public List<SelectOption> inletMaterialOptions{get;set;}
    public boolean isInletMaterialSelected{get;set;}
    set<String> INLETCOMPPTCList = new set<String>();
    public Pagereference inletMaterialSelectOptions(){
        isInletMaterialSelected = false;
        system.debug(' size2 '+size2+' selectedBotingClass '+selectedBotingClass+' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c);
        inletMaterialOptions = new List<selectOption>();
        inletMaterialOptions.add(new selectOption('','None'));
        if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && selectedBotingClass != null){
            map<String,String>  optionsMap = new map<String,String>();
            
            /*for(Holder_Lookup_Detail__c hld: [Select Text__c FROM Holder_Lookup_Detail__c
WHERE Holder_Lookup_Translation__r.Attribute__c = 'INLETCOMPPTC'
AND TextVal1__c =: conHolder.Holder_Product_Code__c LIMIT 50000]){
INLETCOMPPTCList.add(hld.Text__c);
}*/
            map<String,String> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
            system.debug('INLETCOMPPTC ::::::  '+holderInputs.get('INLETCOMPPTC'));
            if(holderInputs.get('INLETCOMPPTC') != null){
                INLETCOMPPTCList.add(holderInputs.get('INLETCOMPPTC'));
            }
            /*
Result lookupDetailList = new Result();
List<String> selectCols = new List<String> {'Text__c'};
lookupDetailList=ConfigHolderUtility.getDataFromTranslationObj('Attribute__c','Holder_Lookup_Translation__c','Holder_Lookup_Detail__c',holderInputs,selectCols, new List<String> {'INLETCOMPPTC'});
if(lookupDetailList.bResult){
system.debug('***lookupDetailList Result' +lookupDetailList.objResultList);
for(sObject sobj:lookupDetailList.objResultList){
Holder_Lookup_Detail__c  holderLookupDeatilRecord = new Holder_Lookup_Detail__c ();
holderLookupDeatilRecord = (Holder_Lookup_Detail__c )sobj;
if(holderLookupDeatilRecord.Text__c != null){
INLETCOMPPTCList.add(holderLookupDeatilRecord.Text__c);
}
}
}*/
            system.debug(' INLETCOMPPTCList '+INLETCOMPPTCList+' conHolder.Size2__c');
            for(Holder_Structure__c ho: [SELECT MCHI__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Inlet'
                                         AND INLETCOMPPTC__c IN: INLETCOMPPTCList
                                         AND SZC__c =: size2
                                         AND HCLASS__c =: selectedBotingClass
                                         AND MCHI__c != null
                                         LIMIT 50000]){
                                             optionsMap.put(ho.MCHI__c, matCodeMap.containsKey(ho.MCHI__c) ? matCodeMap.get(ho.MCHI__c) : ho.MCHI__c);
                                         }
            for(String option: optionsMap.keySet()){
                //inletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                if (conHolder.ATEX_Certificate__c)
                {
                    if (!AtexExcludeMatOptions.contains(option)) {
                        if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103') {
                            if(NACEIncludeMatOptions.contains(option))
                                inletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                        } else {
                            inletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                        }
                    }
                } else {
                    if(conHolder.NACE_Compliance__c == 'MR0175' || conHolder.NACE_Compliance__c == 'MR0103') {
                        if(NACEIncludeMatOptions.contains(option))
                            inletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                    } else {
                        inletMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
                    }
                }
            }
            System.debug(' inletMaterialOptions ####### '+inletMaterialOptions);
        }
        return null;
    }
    
    set<String> COINArray;
    public Pagereference handleInletMaterialChange(){
        COINArray = new set<String>();
        System.debug('selectedInletMaterial '+selectedInletMaterial+' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+' size2 '+size2
                     +' selectedBotingClass '+selectedBotingClass+' INLETCOMPPTCList '+INLETCOMPPTCList);
        system.debug('COINArray 1st '+COINArray);
        if(String.isNotBlank(selectedInletMaterial)){
            isInletMaterialSelected = true;
            for(Holder_Structure__c ho: [SELECT OptionCode__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Inlet' AND INLETCOMPPTC__c IN: INLETCOMPPTCList /* INLETCOMPPTC or PTC? */
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass
                                         AND MCHI__c =: selectedInletMaterial LIMIT 50000]){
                                             system.debug(' ho.OptionCode__c == '+ho.OptionCode__c);
                                             COINArray.add(ho.OptionCode__c);
                                         }
            String opCodes = '';
            for(String opCode: COINArray){
                opCodes += opCode + ', ';
            }
            conHolder.Inlet_Options__c = opCodes;
            system.debug(' opCodes '+opCodes);
            system.debug(' COINArray '+COINArray);
            //knifebladeMaterialInletSelectOptions();
            //inletMaterialSelectOptions();
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }else{
            isInletMaterialSelected = false;
        }
        return null;
    }
    
    public String selectedKnifebladeMaterialInlet{get;set;}
    public List<SelectOption> knifebladeMaterialInletOptions{get;set;}
    public Boolean knifebladeMaterialInletFlag{get;set;}
    public Pagereference knifebladeMaterialInletSelectOptions(){
        knifebladeMaterialInletOptions = new List<selectOption>();
        knifebladeMaterialInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        //system.debug('COINArray 2'+COINArray.toString());
        String knifebladeMaterialInletQuery = 'SELECT Knifeblade_Material__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND Knifeblade_Material__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            knifebladeMaterialInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        //if(COINArray != null && COINArray.size() > 0){
        for(Holder_Option__c ho: Database.query(knifebladeMaterialInletQuery)){
            if(String.isNotBlank(ho.Knifeblade_Material__c)){
                optionsMap.put(ho.Knifeblade_Material__c,ho.Knifeblade_Material__c);
            }
        }
        for(String option: optionsMap.keySet()){
            if (conHolder.ATEX_Certificate__c)
            {
                if (!AtexExcludeMatOptions.contains(option)) {
                    knifebladeMaterialInletOptions.add(new selectOption(option,optionsMap.get(option)));
                }
            } else {
                knifebladeMaterialInletOptions.add(new selectOption(option,optionsMap.get(option)));
            }
        }
        System.debug(' knifebladeMaterialInletOptions ####### '+knifebladeMaterialInletOptions);
        if(knifebladeMaterialInletOptions.size() == 1 && knifebladeMaterialInletOptions[0].getValue() == ''){
            knifebladeMaterialInletFlag = false;
            selectedKnifebladeMaterialInlet = null;
        }else{
            knifebladeMaterialInletFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleKnifebladeMaterialInletChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    public String selectedGaugeTapInlet{get;set;}
    public List<SelectOption> gaugeTapInletOptions{get;set;}
    public Boolean gaugeTapInletFlag{get;set;}
    public Pagereference gaugeTapInletSelectOptions(){
        gaugeTapInletFlag = false;
        gaugeTapInletOptions = new List<selectOption>();
        gaugeTapInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String gaugeTapInletQuery = 'SELECT GaugeTap__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND GaugeTap__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            gaugeTapInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            gaugeTapInletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            gaugeTapInletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        //if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet)){
        for(Holder_Option__c ho: Database.query(gaugeTapInletQuery)){
            if(String.isNotBlank(ho.GaugeTap__c)){
                optionsMap.put(ho.GaugeTap__c,ho.GaugeTap__c);
            }
        }
        //system.debug('optionsMap Gauge inlet '+optionsMap);
        for(String option: optionsMap.keySet()){
            gaugeTapInletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' gaugeTapInletOptions ####### '+gaugeTapInletOptions);
        if(gaugeTapInletOptions.size() == 1 && gaugeTapInletOptions[0].getValue() == ''){
            gaugeTapInletFlag = false;
            selectedGaugeTapInlet = null;
        }else{
            gaugeTapInletFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleGaugeTapInletChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    public String selectedEyeboltsDrillingInlet{get;set;}
    public List<SelectOption> eyeboltsDrillingInletOptions{get;set;}
    public Boolean eyeboltsDrillingInletFlag{get;set;}
    public Pagereference eyeboltsDrillingInletSelectOptions(){
        eyeboltsDrillingInletFlag = false;
        eyeboltsDrillingInletOptions = new List<selectOption>();
        eyeboltsDrillingInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String eyeboltsDrillingInletQuery = 'SELECT EyeboltDrilling__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND EyeboltDrilling__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            eyeboltsDrillingInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            eyeboltsDrillingInletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            eyeboltsDrillingInletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            eyeboltsDrillingInletQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            eyeboltsDrillingInletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        //if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)){
        for(Holder_Option__c ho: Database.query(eyeboltsDrillingInletQuery)){
            if(String.isNotBlank(ho.EyeboltDrilling__c)){
                optionsMap.put(ho.EyeboltDrilling__c,ho.EyeboltDrilling__c);
            }
        }
        for(String option: optionsMap.keySet()){
            eyeboltsDrillingInletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' eyeboltsDrillingInletOptions ####### '+eyeboltsDrillingInletOptions);
        if(eyeboltsDrillingInletOptions.size() == 1 && eyeboltsDrillingInletOptions[0].getValue() == ''){
            eyeboltsDrillingInletFlag = false;
            selectedEyeboltsDrillingInlet = null;
        }else{
            eyeboltsDrillingInletFlag = true;
        }
        //}
        return null;
    }
    
    public String eyeboltMaterialInlet{get;set;}
    public Pagereference handleEyeboltsDrillingInletChange(){
        system.debug('ASHIM TEST::'+selectedInletMaterial);
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
            if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
                eyeboltMaterialInlet = 'Carbon Steel';
            }else{
                eyeboltMaterialInlet = null;
            }
        }
        if(string.isNotBlank(selectedEyeboltsDrillingInlet)){
            System.debug('.....isInletMaterialSelected.'+isInletMaterialSelected);
            System.debug('.....eyeboltsDrillingInletFlag'+eyeboltsDrillingInletFlag);
            eyeboltsDrillingInletFlag = true;
        }
        return null;
    }
    
    public String selectedjHook{get;set;}
    public List<SelectOption> jHookOptions{get;set;}
    public Boolean jHookFlag{get;set;}
    public Pagereference jHookSelectOptions(){
        jHookFlag = false;
        jHookOptions = new List<selectOption>();
        jHookOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String jHookQuery = 'SELECT JHook__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND JHook__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            jHookQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            jHookQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            jHookQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            jHookQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            jHookQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
            jHookQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingInlet';
            //}else if(! eyeboltsDrillingMFLGFlag){
        }else{
            jHookQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        // if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)
        //     && String.isNotBlank(selectedEyeboltsDrillingInlet)){
        for(Holder_Option__c ho: Database.query(jHookQuery)){
            if(String.isNotBlank(ho.JHook__c)){
                optionsMap.put(ho.JHook__c,ho.JHook__c);
            }
        }
        for(String option: optionsMap.keySet()){
            jHookOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' jHookOptions ####### '+jHookOptions);
        if(jHookOptions.size() == 1 && jHookOptions[0].getValue() == ''){
            jHookFlag = false;
            selectedjHook = null;
        }else{
            jHookFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handlejHookChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    public String selectedFacingInlet{get;set;}
    public List<SelectOption> facingInletOptions{get;set;}
    public Boolean facingInletFlag{get;set;}
    public Pagereference facingInletSelectOptions(){
        facingInletFlag = false;
        facingInletOptions = new List<selectOption>();
        facingInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String facingInletQuery = 'SELECT Facing__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND Facing__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            facingInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            facingInletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            facingInletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            facingInletQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            facingInletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
            facingInletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingInlet';
            //}else if(! eyeboltsDrillingInletFlag){
        }else{
            facingInletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedjHook)){
            facingInletQuery += ' AND JHook__c =: selectedjHook';
            //}else if(! jHookFlag){
        }else{
            facingInletQuery += ' AND JHook__c = \'None\' ';
        }
        // if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)
        //     && String.isNotBlank(selectedEyeboltsDrillingInlet) && String.isNotBlank(selectedjHook)){
        for(Holder_Option__c ho: Database.query(facingInletQuery)){
            if(String.isNotBlank(ho.Facing__c)){
                optionsMap.put(ho.Facing__c,ho.Facing__c);
            }
        }
        for(String option: optionsMap.keySet()){
            facingInletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' facingInletOptions ####### '+facingInletOptions);
        if(facingInletOptions.size() == 1 && facingInletOptions[0].getValue() == ''){
            facingInletFlag = false;
            selectedFacingInlet = null;
        }else{
            facingInletFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleFacingInletChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    public String selectedCoatingInlet{get;set;}
    public List<SelectOption> coatingInletOptions{get;set;}
    public Boolean coatingInletFlag{get;set;}
    public Pagereference coatingInletSelectOptions(){
        coatingInletFlag = false;
        coatingInletOptions = new List<selectOption>();
        coatingInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String coatingInletQuery = 'SELECT Coating__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND Coating__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            coatingInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            coatingInletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            coatingInletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            coatingInletQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            coatingInletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
            coatingInletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingInlet';
            //}else if(! eyeboltsDrillingInletFlag){
        }else{
            coatingInletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedjHook)){
            coatingInletQuery += ' AND JHook__c =: selectedjHook';
            //}else if(! jHookFlag){
        }else{
            coatingInletQuery += ' AND JHook__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacingInlet)){
            coatingInletQuery += ' AND Facing__c =: selectedFacingInlet';
            //}else if(! facingInletFlag){
        }else{
            coatingInletQuery += ' AND Facing__c = \'None\' ';
        }
        // if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)
        //     && String.isNotBlank(selectedEyeboltsDrillingInlet) && String.isNotBlank(selectedjHook) && String.isNotBlank(selectedFacingInlet)){
        System.debug(' coatingInletQuery '+coatingInletQuery);
        for(Holder_Option__c ho: Database.query(coatingInletQuery)){
            if(String.isNotBlank(ho.Coating__c)){
                optionsMap.put(ho.Coating__c,ho.Coating__c);
            }
        }
        for(String option: optionsMap.keySet()){
            coatingInletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' coatingInletOptions ####### '+coatingInletOptions);
        if(coatingInletOptions.size() == 1 && coatingInletOptions[0].getValue() == ''){
            coatingInletFlag = false;
            selectedCoatingInlet = null;
        }else{
            coatingInletFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleCoatingInletChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            liningInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    public String selectedLiningInlet{get;set;}
    public List<SelectOption> liningInletOptions{get;set;}
    public Boolean liningInletFlag{get;set;}
    public Pagereference liningInletSelectOptions(){
        liningInletFlag = false;
        liningInletOptions = new List<selectOption>();
        liningInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String liningInletQuery = 'SELECT Lining__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND Lining__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            liningInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            liningInletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            liningInletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            liningInletQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            liningInletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
            liningInletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingInlet';
            //}else if(! eyeboltsDrillingInletFlag){
        }else{
            liningInletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedjHook)){
            liningInletQuery += ' AND JHook__c =: selectedjHook';
            //}else if(! jHookFlag){
        }else{
            liningInletQuery += ' AND JHook__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacingInlet)){
            liningInletQuery += ' AND Facing__c =: selectedFacingInlet';
            //}else if(! facingInletFlag){
        }else{
            liningInletQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoatingInlet)){
            liningInletQuery += ' AND Coating__c =: selectedCoatingInlet';
            //}else if(! coatingInletFlag){
        }else{
            liningInletQuery += ' AND Coating__c = \'None\' ';
        }
        // if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)
        //     && String.isNotBlank(selectedEyeboltsDrillingInlet) && String.isNotBlank(selectedjHook) && String.isNotBlank(selectedFacingInlet)
        //     && String.isNotBlank(selectedCoatingInlet)){
        System.debug(' liningInletQuery '+liningInletQuery);
        for(Holder_Option__c ho: Database.query(liningInletQuery)){
            if(String.isNotBlank(ho.Lining__c)){
                optionsMap.put(ho.Lining__c,ho.Lining__c);
            }
        }
        for(String option: optionsMap.keySet()){
            liningInletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' liningInletOptions ####### '+liningInletOptions);
        if(liningInletOptions.size() == 1 && liningInletOptions[0].getValue() == ''){
            liningInletFlag = false;
            selectedLiningInlet = null;
        }else{
            liningInletFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleLiningInletChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            boreInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    public String selectedBoreInlet{get;set;}
    public List<SelectOption> boreInletOptions{get;set;}
    public Boolean boreInletFlag{get;set;}
    public Pagereference boreInletSelectOptions(){
        boreInletFlag = false;
        boreInletOptions = new List<selectOption>();
        boreInletOptions.add(new selectOption('','None'));
        map<String,String>  optionsMap = new map<String,String>();
        String boreInletQuery = 'SELECT Bore__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' AND Bore__c != \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            boreInletQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            boreInletQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            boreInletQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            boreInletQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            boreInletQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
            boreInletQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingInlet';
            //}else if(! eyeboltsDrillingInletFlag){
        }else{
            boreInletQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedjHook)){
            boreInletQuery += ' AND JHook__c =: selectedjHook';
            //}else if(! jHookFlag){
        }else{
            boreInletQuery += ' AND JHook__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacingInlet)){
            boreInletQuery += ' AND Facing__c =: selectedFacingInlet';
            //}else if(! facingInletFlag){
        }else{
            boreInletQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoatingInlet)){
            boreInletQuery += ' AND Coating__c =: selectedCoatingInlet';
            //}else if(! coatingInletFlag){
        }else{
            boreInletQuery += ' AND Coating__c = \'None\' ';
        }
        if(String.isNotBlank(selectedLiningInlet)){
            boreInletQuery += ' AND Lining__c =: selectedLiningInlet';
            //}else if(! liningInletFlag){
        }else{
            boreInletQuery += ' AND Lining__c = \'None\' ';
        }
        // if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)
        //     && String.isNotBlank(selectedEyeboltsDrillingInlet) && String.isNotBlank(selectedjHook) && String.isNotBlank(selectedFacingInlet)
        //     && String.isNotBlank(selectedCoatingInlet) && string.isNotBlank(selectedLiningInlet)){
        for(Holder_Option__c ho: Database.query(boreInletQuery)){
            if(String.isNotBlank(ho.Bore__c) && ho.Bore__c != 'None'){
                optionsMap.put(ho.Bore__c,ho.Bore__c);
            }
        }
        for(String option: optionsMap.keySet()){
            boreInletOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        System.debug(' boreInletOptions ####### '+boreInletOptions);
        if(boreInletOptions.size() == 1 && boreInletOptions[0].getValue() == ''){
            boreInletFlag = false;
            selectedBoreInlet = null;
        }else{
            boreInletFlag = true;
        }
        //}
        return null;
    }
    
    public Pagereference handleBoreInletChange(){
        if(String.isNotBlank(selectedInletMaterial)){
            knifebladeMaterialInletSelectOptions();
            gaugeTapInletSelectOptions();
            eyeboltsDrillingInletSelectOptions();
            jHookSelectOptions();
            facingInletSelectOptions();
            coatingInletSelectOptions();
            liningInletSelectOptions();
            inletOptionAssignment();
        }
        return null;
    }
    
    //calculate Inlet_Option__c
    public Pagereference inletOptionAssignment(){
        // if(COINArray != null && COINArray.size() > 0 && String.isNotBlank(selectedKnifebladeMaterialInlet) && String.isNotBlank(selectedGaugeTapInlet)
        //     && String.isNotBlank(selectedEyeboltsDrillingInlet) && String.isNotBlank(selectedjHook) && String.isNotBlank(selectedFacingInlet)
        //     && String.isNotBlank(selectedCoatingInlet) && string.isNotBlank(selectedLiningInlet) && String.isNotBlank(selectedBoreInlet)){
        String inletOptionQuery = 'SELECT OptionCode__c FROM Holder_Option__c WHERE JackscrewDrilling__c = \'None\' ';
        if(COINArray != null && COINArray.size() > 0){
            inletOptionQuery += ' AND OptionCode__c IN: COINArray';
        }
        if(String.isNotBlank(selectedKnifebladeMaterialInlet)){
            inletOptionQuery += ' AND Knifeblade_Material__c =: selectedKnifebladeMaterialInlet';
            //}else if(! knifebladeMaterialInletFlag){
        }else{
            inletOptionQuery += ' AND Knifeblade_Material__c = \'None\' ';
        }
        if(String.isNotBlank(selectedGaugeTapInlet)){
            inletOptionQuery += ' AND GaugeTap__c =: selectedGaugeTapInlet';
            //}else if(! gaugeTapInletFlag){
        }else{
            inletOptionQuery += ' AND GaugeTap__c = \'None\' ';
        }
        if(String.isNotBlank(selectedEyeboltsDrillingInlet)){
            inletOptionQuery += ' AND EyeboltDrilling__c =: selectedEyeboltsDrillingInlet';
            //}else if(! eyeboltsDrillingInletFlag){
        }else{
            inletOptionQuery += ' AND EyeboltDrilling__c = \'None\' ';
        }
        if(String.isNotBlank(selectedjHook)){
            inletOptionQuery += ' AND JHook__c =: selectedjHook';
            //}else if(! jHookFlag){
        }else{
            inletOptionQuery += ' AND JHook__c = \'None\' ';
        }
        if(String.isNotBlank(selectedFacingInlet)){
            inletOptionQuery += ' AND Facing__c =: selectedFacingInlet';
            //}else if(! facingInletFlag){
        }else{
            inletOptionQuery += ' AND Facing__c = \'None\' ';
        }
        if(String.isNotBlank(selectedCoatingInlet)){
            inletOptionQuery += ' AND Coating__c =: selectedCoatingInlet';
            //}else if(!coatingInletFlag){
        }else{
            inletOptionQuery += ' AND Coating__c = \'None\' ';
        }
        if(String.isNotBlank(selectedLiningInlet)){
            inletOptionQuery += ' AND Lining__c =: selectedLiningInlet';
            //}else if(! liningInletFlag){
        }else{
            inletOptionQuery += ' AND Lining__c = \'None\' ';
        }
        if(String.isNotBlank(selectedBoreInlet)){
            inletOptionQuery += ' AND Bore__c =: selectedBoreInlet';
            //}else if(! boreInletFlag){
        }else{
            inletOptionQuery += ' AND Bore__c = \'None\' ';
        }
        system.debug(' inletOptionQuery '+inletOptionQuery);
        map<String,String>  optionsMap = new map<String,String>();
        for(Holder_Option__c ho: Database.query(inletOptionQuery)){
            conHolder.Inlet_Option__c = ho.OptionCode__c;
        }
        if(conHolder.Inlet_Option__c != null){
            //excessFlowMFLGValveSelectOptions();
        }
        //}
        return null;
    }
    
    
    public Pagereference clearInletSection(){
        // COINArray = new Set<String>();
        // selectedInletMaterial = null;
        // inletMaterialSelectOptions();
        selectedKnifebladeMaterialInlet = null;
        knifebladeMaterialInletSelectOptions();
        selectedGaugeTapInlet = null;
        gaugeTapInletSelectOptions();
        selectedEyeboltsDrillingInlet = null;
        eyeboltsDrillingInletSelectOptions();
        selectedjHook = null;
        jHookSelectOptions();
        selectedFacingInlet = null;
        facingInletSelectOptions();
        selectedCoatingInlet = null;
        coatingInletSelectOptions();
        selectedLiningInlet = null;
        liningInletSelectOptions();
        selectedBoreInlet = null;
        boreInletSelectOptions();
        conHolder.Inlet_Option__c = null;
        inletOptionAssignment();
        return null;
    }
    
    public boolean bodySectionFlag{get;set;}
    public void isBodySectionRequired(){
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            bodySectionFlag = ConfigHolderUtility.isHolderParamterRequired((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Body__c');
        }
        System.debug(' bodySectionFlag '+bodySectionFlag);
    }
    
    
    public String selectedBodyMaterial{get;set;}
    public List<SelectOption> bodyMaterialOptions{get;set;}
    public void bodyMaterialSelectOptions(){
        bodyMaterialOptions = new List<selectOption>();
        bodyMaterialOptions.add(new selectOption('','None'));
        system.debug(' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+ ' size2 '+size2+' selectedBotingClass '+selectedBotingClass);
        if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && String.isNotBlank(selectedBotingClass)){
            map<String,String> optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT MCBODY__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Body2' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                             optionsMap.put(ho.MCBODY__c, matCodeMap.containsKey(ho.MCBODY__c) ? matCodeMap.get(ho.MCBODY__c) : ho.MCBODY__c);
                                         }
            for(String option: optionsMap.keySet()){
                bodyMaterialOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            
        }else{
            bodyMaterialOptions.clear();
        }
        system.debug(' bodyMaterialOptions ######## '+bodyMaterialOptions);
        
    }
    
    set<String> COBODYArray = new set<String>();
    public Boolean isBodyMaterialSelected{get;set;}
    public void handlebodyMaterialChange(){
        isBodyMaterialSelected = false;
        system.debug(' selectedOutletMaterial '+selectedOutletMaterial+ ' size2 '+size2 +' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+' selectedBotingClass '+selectedBotingClass);
        if(String.isNotBlank(selectedBodyMaterial)){
            isBodyMaterialSelected = true;
            if(String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && String.isNotBlank(selectedBotingClass)){
                for(Holder_Structure__c ho: [SELECT OptionCode__c FROM Holder_Structure__c
                                             WHERE Holder_Structure_Type__c = 'Body2' AND PTC__c =:conHolder.Holder_Product_Code__c
                                             AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass
                                             AND MCBODY__c =:selectedBodyMaterial LIMIT 50000]){
                                                 COBODYArray.add(ho.OptionCode__c);
                                             }
                String COBODYArrayStr = '';
                for(String str: COBODYArray){
                    COBODYArrayStr += str +', ';
                }
                conHolder.Body_Options_Array__c = COBODYArrayStr;
                // if(COBODYArray.size() > 0 ){
                //     coatingBodySelectOptions();
                // }
            }
        }
        coatingBodySelectOptions();
        handleCoatingBodyChange();
    }
    
    public String selectedCoatingBody{get;set;}
    public List<SelectOption> coatingBodyOptions{get;set;}
    public Boolean coatingBodyFlag{get;set;}
    public Pagereference coatingBodySelectOptions(){
        coatingBodyFlag = false;
        coatingBodyOptions = new List<selectOption>();
        coatingBodyOptions.add(new selectOption('','None'));
        //if(COBODYArray != null && COBODYArray.size() > 0 && String.isNotBlank(selectedBodyMaterial) ){
        map<String,String>  optionsMap = new map<String,String>();
        String holderOptionsQuery = 'SELECT Coating__c FROM Holder_Option__c WHERE Knifeblade_Material__c = \'None\'  AND GaugeTap__c = \'None\'  AND EyeboltDrilling__c = \'None\' ';
        holderOptionsQuery += ' AND JHook__c = \'None\'  AND Facing__c = \'None\'  AND Lining__c = \'None\'  AND JackscrewDrilling__c = \'None\' AND Bore__c = \'None\'';
        if(COBODYArray != null && COBODYArray.size() > 0){
            holderOptionsQuery+= ' AND OptionCode__c IN: COBODYArray';
            system.debug('COBODYArray in coatingBodySelectOptions '+COBODYArray);
        }
        System.debug('holderOptionsQuery'+holderOptionsQuery);
        for(Holder_Option__c ho: Database.query(holderOptionsQuery)){
            // if(String.isBlank(ho.Coating__c)){
            //     ho.Coating__c = 'None';
            // }
            if(String.isNotBlank(ho.Coating__c)){
                optionsMap.put(ho.Coating__c,ho.Coating__c);
            }
        }
        
        //removing None options if from DB None is fetched - Ashim
        if(optionsMap.keySet().contains('None')) {
            
            coatingBodyOptions = new List<selectOption>();
        }
        for(String option: optionsMap.keySet()){
            coatingBodyOptions.add(new selectOption(option,optionsMap.get(option)));
        }
        if(coatingBodyOptions.size() == 1 && coatingBodyOptions[0].getValue() == ''){
            //coatingBodyFlag = false;
            coatingBodyFlag = false;
        }else{
            coatingBodyFlag = true;
        }
        
        //}
        return null;
    }
    
    // populate Body_Option__c
    public void handleCoatingBodyChange(){
        set<String> bodyOptions = new set<String>();
        system.debug(' COBODYArray '+COBODYArray+ ' selectedBodyMaterial '+selectedBodyMaterial +' selectedCoatingBody '+selectedCoatingBody);
        if( (COBODYArray != null && COBODYArray.size() > 0 && String.isNotBlank(selectedBodyMaterial)) || Test.isRunningTest()) {
            String coatingBodyVal = selectedCoatingBody;
            if(string.isBlank(selectedCoatingBody))
                coatingBodyVal = 'None';
            for(Holder_Option__c ho: [SELECT OptionCode__c FROM Holder_Option__c
                                      WHERE OptionCode__c =: COBODYArray
                                      AND Knifeblade_Material__c = 'None'
                                      AND GaugeTap__c = 'None'
                                      AND EyeboltDrilling__c = 'None'
                                      AND JHook__c = 'None'
                                      AND Facing__c = 'None'
                                      AND Lining__c = 'None'
                                      AND JackscrewDrilling__c = 'None'
                                      AND Bore__c = 'None'
                                      AND Coating__c =: coatingBodyVal LIMIT 50000]){
                                          conHolder.Body_Option__c = ho.OptionCode__c;
                                      }
        }
        
    }
    
    public Pagereference clearBodySection(){
        COBODYArray = new Set<String>();
        selectedBodyMaterial = null;
        conHolder.Body_Options_Array__c = null;
        selectedCoatingBody = null;
        conHolder.Body_Option__c = null;
        bodyMaterialSelectOptions();
        coatingBodySelectOptions();
        return null;
    }
    
    public boolean additionalAccessoriesSectionFlag{get;set;}
    public String selectedStudsandNuts{get;set;}
    public List<SelectOption> studsandNutsOptions{get;set;}
    public Boolean studsandNutsFlag{get;set;}
    public Boolean isStudsandNutsRequired{get;set;}
    public void studsandNutsSelectOptions(){
        studsandNutsOptions = new List<selectOption>();
        studsandNutsOptions.add(new selectOption('','None'));
        isStudsandNutsRequired = false;
        studsandNutsFlag = false;
        boolean isStundsNutsUnavailable = false;
        system.debug(' holdersRequiredInfo.get(conHolder.Holder_Product_Code__c) '+holdersRequiredInfo.get(conHolder.Holder_Product_Code__c));
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            String stundsNutsRquiredInfo = ConfigHolderUtility.isHolderParamterRequiredString((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Studs_and_Nuts__c');
            if(stundsNutsRquiredInfo == 'Required'){
                isStudsandNutsRequired = true;
            }else if(stundsNutsRquiredInfo == 'Optional'){
                isStudsandNutsRequired = false;
            }else{
                isStundsNutsUnavailable = true;
            }
        }
        System.debug(' isStundsNutsUnavailable '+isStundsNutsUnavailable);
        System.debug(' isStudsandNutsRequired '+isStudsandNutsRequired);
        system.debug(' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+ ' size2 '+size2+' selectedBotingClass '+selectedBotingClass);
        if(! isStundsNutsUnavailable && String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && String.isNotBlank(selectedBotingClass)){
            map<String,String>  optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT MCSTUD__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'StudsandNuts' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                             optionsMap.put(ho.MCSTUD__c, matCodeMap.containsKey(ho.MCSTUD__c) ? matCodeMap.get(ho.MCSTUD__c) : ho.MCSTUD__c);
                                         }
            
            for(String option: optionsMap.keySet()){
                studsandNutsOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            if(studsandNutsOptions.size() == 1 && studsandNutsOptions[0].getValue() == ''){
                studsandNutsFlag = false;
            }else{
                studsandNutsFlag = true;
            }
            
        }
    }
    
    public String selectedJackscrewsAdditional{get;set;}
    public List<SelectOption> jackscrewsAdditionalOptions{get;set;}
    public Boolean jackscrewsAdditionalFlag{get;set;}
    public Boolean isJackscrewsAdditionalRequired{get;set;}
    public void jackscrewsAdditionaSelectlOptions(){
        jackscrewsAdditionalOptions = new List<selectOption>();
        jackscrewsAdditionalOptions.add(new selectOption('','None'));
        isJackscrewsAdditionalRequired = false;
        jackscrewsAdditionalFlag = false;
        boolean jackscrewsUnavailable = false;
        system.debug(' holdersRequiredInfo.get(conHolder.Holder_Product_Code__c) '+holdersRequiredInfo.get(conHolder.Holder_Product_Code__c));
        if(holdersRequiredInfo.containsKey(conHolder.Holder_Product_Code__c)){
            String jackscrewsRquiredInfo = ConfigHolderUtility.isHolderParamterRequiredString((sObject)holdersRequiredInfo.get(conHolder.Holder_Product_Code__c), 'Jackscrews__c');
            if(jackscrewsRquiredInfo == 'Required'){
                isJackscrewsAdditionalRequired = true;
            }else if(jackscrewsRquiredInfo == 'Optional'){
                isJackscrewsAdditionalRequired = false;
            }else{
                jackscrewsUnavailable = true;
            }
        }
        System.debug(' jackscrewsUnavailable '+jackscrewsUnavailable);
        System.debug(' isJackscrewsAdditionalRequired '+isJackscrewsAdditionalRequired);
        system.debug(' conHolder.Holder_Product_Code__c '+conHolder.Holder_Product_Code__c+ ' size2 '+size2+' selectedBotingClass '+selectedBotingClass);
        if(! jackscrewsUnavailable && String.isNotBlank(size2) && conHolder.Holder_Product_Code__c != null && String.isNotBlank(selectedBotingClass)){
            map<String,String>  optionsMap = new map<String,String>();
            for(Holder_Structure__c ho: [SELECT MatlCode__c FROM Holder_Structure__c
                                         WHERE Holder_Structure_Type__c = 'Jackscrews' AND PTC__c =:conHolder.Holder_Product_Code__c
                                         AND SZC__c =: size2 AND HCLASS__c =: selectedBotingClass LIMIT 50000]){
                                             optionsMap.put(ho.MatlCode__c,matCodeMap.containsKey(ho.MatlCode__c) ? matCodeMap.get(ho.MatlCode__c) : ho.MatlCode__c);
                                         }
            
            for(String option: optionsMap.keySet()){
                jackscrewsAdditionalOptions.add(new selectOption(option,optionsMap.get(option)));
            }
            if(jackscrewsAdditionalOptions.size() == 1 && jackscrewsAdditionalOptions[0].getValue() == ''){
                jackscrewsAdditionalFlag = false;
            }else{
                jackscrewsAdditionalFlag = true;
                if(String.isNotBlank(selectedjackscrewDrilling) || String.isNotBlank(selectedJackscrewDrilling2)){
                    isJackscrewsAdditionalRequired = true;
                }
            }
            
        }
    }
    
    public Boolean validateComponentMaterialOptionSelection(){
        validProductSec = false;
        if(CmpFlangeSectionFlag && String.isBlank(selectedCompanionFlangeMaterial)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Companion Flange Material in Companion Flange'));
            return true;
        }
        
        if(gasketSectionFlag && String.isBlank(selectedGasketMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Gasket Materail in Gasket Section'));
            return true;
        }
        
        if(spacerRingSectionFlag && String.isBlank(selectedSpacerRing)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Spacer Ring Material in Spacer Ring Section'));
            return true;
        }
        
        if(outletSetcionFlag && String.isBlank(selectedOutletMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Outlet Material in Outlet Section'));
            return true;
        }
        
        if(midFlangeSectionFlag && String.isBlank(selectedMidFlangeMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Mid Flange Material in Mid Flange Section'));
            return true;
        }
        
        if(nutSectionFlag && String.isBlank(selectedNutMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Nut Material in Nut Section'));
            return true;
        }
        
        if(clampSectionFlag && String.isBlank(selectedClampMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Clamp Material in Clamp Section'));
            return true;
        }
        
        if(holddownRingSectionFlag && String.isBlank(selectedHolddownRingMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Holddown Ring Material in Holddown Ring Section'));
            return true;
        }
        
        if(inletSectionFlag && String.isBlank(selectedInletMaterial)){
            //errorMessage = 'Please select Gasket Materail in Gasket Section';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Inlet Material in Inlet Section'));
            return true;
        }
        
        if(bodySectionFlag && String.isBlank(selectedBodyMaterial)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Body Materail in Body Section'));
            return true;
        }
        
        if(isStudsandNutsRequired && String.isBlank(selectedStudsandNuts)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Studs and Nuts is required in Additional Accessories'));
            return true;
        }
        if(isJackscrewsAdditionalRequired){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Jackscrews is required in Additional Accessories'));
            return true;
        }
        return false;
    }
    
    public boolean isComponentMaterialOptionSaved = false;
    public PageReference saveComponentMaterialOptionSelection()
    {
        System.debug('selectedGaugeTap..'+selectedGaugeTap);
        if(selectedGaugeTap == null){
            selectedNipple2 = null;
            selectedTee2 = null;
            selectedReducingBushing = null;
            selectedUOMPressRange = null;
            selectedPhysicalProperties = null;
            selectedTubeCaseMaterial = null;
            selectedExcessFlowValve = null;
            isselectedUOMPressRange = false;
            isselectedPhysicalProperties = false;
            conHolder.Gauge_Selection_Outlet__c = '';
            conHolder.Gauge_Selection_Mid_Flange__c = '';
            //handleOutletMaterialChange();
            if(!Test.isRunningTest()){
                handleGaugeTapChange();
                handleUOMPressRangeChange();
                handleUOMPressRangeMFLGChange();
            }
            
            System.debug('selectedGaugeTap');
        }
        
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
        validProductSec = false;
        //validate data
        if(validateProductSelection()){
            return null;
        }
        if(validateComponentMaterialOptionSelection()){
            return null;
        }
        System.debug('*******selectedPhysicalProperties'+selectedPhysicalProperties);
        if(String.isBlank(selectedPhysicalProperties) && isselectedUOMPressRange){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Physical Properties is required in Outlet Section'));
            return null;
        }
        
        if(String.isBlank(selectedTubeCaseMaterial) && isselectedPhysicalProperties){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Tube/Case Material is required in Outlet Section'));
            return null;
        }
        
        if(String.isBlank(selectedPhysicalMFLGProperties) && isselectedUOMPressMFLGRange){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Physical Properties is required in Mid Flange Section'));
            return null;
        }
        
        if(String.isBlank(selectedTubeCaseMFLGMaterial) && isselectedPhysicalMFLGProperties){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Tube/Case Material is required in Mid Flange Section'));
            return null;
        }
        
        boolean isValid=true;
        if(CmpFlangeSectionFlag){
            conHolder.Companion_Flange_Material__c = selectedCompanionFlangeMaterial;
            conHolder.Bore__c = selectedBore;
            conHolder.Jackscrew_Drilling__c = selectedjackscrewDrilling;
            List<String> listStrings = new List<String>(COCFArray);
            String s = String.join( listStrings, ',');
            system.debug(' COMPANION SECTION s'+s);
            string query='SELECT ID from Holder_Option__c where id!=NULL AND OptionCode__c IN: COCFArray';
            string whereClause='';
            whereClause+=' AND Knifeblade_Material__c=\'None\'';
            whereClause+=' AND GaugeTap__c=\'None\'';
            whereClause+=' AND EyeboltDrilling__c=\'None\'';
            whereClause+=' AND Facing__c=\'None\'';
            whereClause+=' AND Coating__c=\'None\'';
            whereClause+=' AND Lining__c=\'None\'';
            if(string.isNotBlank(selectedjackscrewDrilling))
                whereClause+=' AND JackscrewDrilling__c=\''+selectedjackscrewDrilling+'\'';
            else
                whereClause+=' AND JackscrewDrilling__c=\'None\'';
            if(string.isNotBlank(selectedBore))
                whereClause+=' AND Bore__c=\''+selectedBore+'\'';
            else
                whereClause+=' AND Bore__c=\'None\'';
            system.debug('COMPANION SECTION Query'+query+whereClause);
            Holder_Option__c[] isVaildSel=Database.query(query+whereClause);
            system.debug(' COMPANION SECTION isVaildSel'+isVaildSel);
            if(isVaildSel.size()==0) {
                system.debug(' COMPANION SECTION isVaildSel'+isVaildSel);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select a Valid combination for Companion Flange Components'));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select valid combination for Outlet Components'));
                //isValid=false;
                return null;
            }
        }
        
        if(gasketSectionFlag){
            conHolder.Gasket_Material__c = selectedGasketMaterial;
        }
        
        if(spacerRingSectionFlag){
            conHolder.Spacer_Ring_Material__c = selectedSpacerRing;
        }
        
        if(outletSetcionFlag || Test.isRunningTest()){
            system.debug(' OUTLET SECTION COOUTArray'+COOUTArray);
            // SELECT Id, JHook__c, Knifeblade_Material__c, GaugeTap__c, OptionCode__c, EyeboltDrilling__c, Facing__c, Coating__c, Lining__c, JackscrewDrilling__c, Bore__c FROM Holder_Option__c
            // conHolder.Outlet_Material__c = selectedOutletMaterial;
            List<String> listStrings = new List<String>(COOUTArray);
            String s = String.join( listStrings, ',');
            system.debug(' OUTLET SECTION s'+s);
            string query='SELECT ID from Holder_Option__c where id!=NULL AND OptionCode__c IN: COOUTArray';
            string whereClause='';
            if(string.isNotBlank(selectedKnifebladeMaterial))
                whereClause+=' AND Knifeblade_Material__c=\''+selectedKnifebladeMaterial+'\'';
            else
                whereClause+=' AND Knifeblade_Material__c=\'None\'';
            if(string.isNotBlank(selectedGaugeTap))
                whereClause+=' AND GaugeTap__c=\''+selectedGaugeTap+'\'';
            else
                whereClause+=' AND GaugeTap__c=\'None\'';
            if(string.isNotBlank(selectedEyeboltsOutlet))
                whereClause+=' AND EyeboltDrilling__c=\''+selectedEyeboltsOutlet+'\'';
            else
                whereClause+=' AND EyeboltDrilling__c=\'None\'';
            if(string.isNotBlank(selectedFacing))
                whereClause+='AND Facing__c=\''+selectedFacing+'\'';
            else
                whereClause+=' AND Facing__c=\'None\'';
            if(string.isNotBlank(selectedCoating))
                whereClause+=' AND Coating__c=\''+selectedCoating+'\'';
            else
                whereClause+=' AND Coating__c=\'None\'';
            if(string.isNotBlank(selectedLining))
                whereClause+=' AND Lining__c=\''+selectedLining+'\'';
            else
                whereClause+=' AND Lining__c=\'None\'';
            if(string.isNotBlank(selectedJackscrewDrilling2))
                whereClause+=' AND JackscrewDrilling__c=\''+selectedJackscrewDrilling2+'\'';
            else
                whereClause+=' AND JackscrewDrilling__c=\'None\'';
            if(string.isNotBlank(selectedBore2))
                whereClause+=' AND Bore__c=\''+selectedBore2+'\'';
            else
                whereClause+=' AND Bore__c=\'None\'';
            system.debug('OUTLET SECTION Query'+query+whereClause);
            Holder_Option__c[] isVaildSel=Database.query(query+whereClause);
            system.debug(' OUTLET SECTION isVaildSel'+isVaildSel);
            if(isVaildSel.size()==0) {
                system.debug(' OUTLET SECTION isVaildSel'+isVaildSel);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select a Valid combination for Outlet Components'));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select valid combination for Outlet Components'));
                //isValid=false;
                if(!Test.isRunningTest()){
                    return null;
                }
            }
            conHolder.Outlet_Material__c = selectedOutletMaterial;
            conHolder.Knifeblade_Material__c = selectedKnifebladeMaterial;
            conHolder.Gauge_Tap__c = selectedGaugeTap;
            conHolder.Eyebolts_Outlet__c = selectedEyeboltsOutlet;
            conHolder.Facing_Outlet__c = selectedFacing;
            conHolder.Coating__c = selectedCoating;
            conHolder.Lining__c = selectedLining;
            conHolder.Jackscrew_Drilling2__c = selectedJackscrewDrilling2;
            conHolder.Bore2__c = selectedBore2;
            conHolder.Nipple2__c = selectedNipple2;
            conHolder.Tee2__c = selectedTee2;
            conHolder.Reducing_Bushing__c = selectedReducingBushing;
            conHolder.Select_UOM_Press_Range__c = selectedUOMPressRange;
            conHolder.Select_Physical_Properties__c = selectedPhysicalProperties;
            conHolder.Select_Tube_Case_Material__c = selectedTubeCaseMaterial;
            conHolder.Excess_Flow_Valve__c = selectedExcessFlowValve;
        }
        
        
        if(midFlangeSectionFlag){
            List<String> listStrings = new List<String>(MIDFLGArray);
            String s = String.join( listStrings, ',');
            system.debug(' MIDFLG SECTION s'+s);
            string query='SELECT ID from Holder_Option__c where id!=NULL AND OptionCode__c IN: MIDFLGArray';
            string whereClause='';
            
            whereClause+=' AND Knifeblade_Material__c=\'None\'';
            if(string.isNotBlank(selectedGaugeTap2))
                whereClause+=' AND GaugeTap__c=\''+selectedGaugeTap2+'\'';
            else
                whereClause+=' AND GaugeTap__c=\'None\'';
            if(string.isNotBlank(selectedEyeboltsDrillingMFLG))
                whereClause+=' AND EyeboltDrilling__c=\''+selectedEyeboltsDrillingMFLG+'\'';
            else
                whereClause+=' AND EyeboltDrilling__c=\'None\'';
            
            whereClause+=' AND Facing__c=\'None\'';
            if(string.isNotBlank(selectedCoatingMFLG))
                whereClause+=' AND Coating__c=\''+selectedCoatingMFLG+'\'';
            else
                whereClause+=' AND Coating__c=\'None\'';
            if(string.isNotBlank(selectedLiningMFLG))
                whereClause+=' AND Lining__c=\''+selectedLiningMFLG+'\'';
            else
                whereClause+=' AND Lining__c=\'None\'';
            
            whereClause+=' AND JackscrewDrilling__c=\'None\'';
            whereClause+=' AND Bore__c=\'None\'';
            system.debug('MIDFLG SECTION Query'+query+whereClause);
            Holder_Option__c[] isVaildSel=Database.query(query+whereClause);
            system.debug(' MIDFLG SECTION isVaildSel'+isVaildSel);
            if(isVaildSel.size()==0) {
                system.debug(' MIDFLG SECTION isVaildSel'+isVaildSel);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select a Valid combination for Mid Flange Components'));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select valid combination for Outlet Components'));
                //isValid=false;
                if(!Test.isRunningTest()){
                    return null;
                }
            }
            conHolder.Mid_Flange_Material__c = selectedMidFlangeMaterial;
            conHolder.Gauge_Tap2__c = selectedGaugeTap2;
            conHolder.Eyebolts_Drilling_Midflange__c = selectedEyeboltsDrillingMFLG;
            conHolder.Coating_Mid_Flange__c = selectedCoatingMFLG;
            conHolder.Lining_Mid_Flange__c = selectedLiningMFLG;
            conHolder.Nipple_Mid_Flange__c = selectedNippleMFLG;
            conHolder.Tee_Mid_Flange__c = selectedTeeMFLG;
            conHolder.Reducing_Bushing_Mid_Flange__c = selectedReducingBushingMFLG;
            conHolder.Select_UOM_Press_Range_Mid_Flange__c = selectedUOMPressMFLGRange;
            conHolder.Select_Physical_Properties_Mid_Flange__c = selectedPhysicalMFLGProperties;
            conHolder.Select_Tube_Case_Material_Mid_Flange__c = selectedTubeCaseMFLGMaterial;
            conHolder.Excess_Flow_Valve_Mid_Flange__c = selectedExcessFlowMFLGValve;
            // system.debug(' selectedMidFlangeMaterial '+selectedMidFlangeMaterial);
            // system.debug(' selectedGaugeTap2 '+selectedGaugeTap2);
            // system.debug(' selectedCoatingMFLG '+selectedCoatingMFLG);
            // system.debug(' selectedNippleMFLG '+selectedNippleMFLG);
            // system.debug(' selectedTeeMFLG '+selectedTeeMFLG);
            // system.debug(' selectedEyeboltsDrillingMFLG '+selectedEyeboltsDrillingMFLG);
            // system.debug(' Select_UOM_Press_Range_Mid_Flange__c '+selectedUOMPressMFLGRange);
            // system.debug(' Select_Physical_Properties_Mid_Flange__c '+selectedPhysicalMFLGProperties);
            // system.debug(' Select_Tube_Case_Material_Mid_Flange__c '+selectedTubeCaseMFLGMaterial);
            // system.debug(' Excess_Flow_Valve_Mid_Flange__c '+selectedExcessFlowMFLGValve);
            // system.debug(' Reducing_Bushing_Mid_Flange__c '+selectedReducingBushingMFLG);
            
            
        }
        
        if(nutSectionFlag){
            conHolder.Nut_Material__c = selectedNutMaterial;
        }
        
        if(clampSectionFlag){
            conHolder.Clamp_Material__c = selectedClampMaterial;
        }
        
        if(holddownRingSectionFlag){
            conHolder.Holddown_Ring_Material__c = selectedHolddownRingMaterial;
        }
        
        if(inletSectionFlag){
            string query='SELECT ID from Holder_Option__c where id!=NULL AND OptionCode__c IN: COINArray';
            string whereClause='';
            if(string.isNotBlank(selectedKnifebladeMaterialInlet))
                whereClause+=' AND Knifeblade_Material__c=\''+selectedKnifebladeMaterialInlet+'\'';
            else
                whereClause+=' AND Knifeblade_Material__c=\'None\'';
            if(string.isNotBlank(selectedGaugeTapInlet))
                whereClause+=' AND GaugeTap__c=\''+selectedGaugeTapInlet+'\'';
            else
                whereClause+=' AND GaugeTap__c=\'None\'';
            if(string.isNotBlank(selectedEyeboltsDrillingInlet))
                whereClause+=' AND EyeboltDrilling__c=\''+selectedEyeboltsDrillingInlet+'\'';
            else
                whereClause+=' AND EyeboltDrilling__c=\'None\'';
            if(string.isNotBlank(selectedFacingInlet))
                whereClause+='AND Facing__c=\''+selectedFacingInlet+'\'';
            else
                whereClause+=' AND Facing__c=\'None\'';
            if(string.isNotBlank(selectedCoatingInlet))
                whereClause+=' AND Coating__c=\''+selectedCoatingInlet+'\'';
            else
                whereClause+=' AND Coating__c=\'None\'';
            if(string.isNotBlank(selectedLiningMFLG))
                whereClause+=' AND Lining__c=\''+selectedLiningMFLG+'\'';
            else
                whereClause+=' AND Lining__c=\'None\'';
            if(string.isNotBlank(selectedjHook))
                whereClause+=' AND JHook__c=\''+selectedjHook+'\'';
            else
                whereClause+=' AND JHook__c=\'None\'';
            if(string.isNotBlank(selectedBoreInlet))
                whereClause+=' AND Bore__c=\''+selectedBoreInlet+'\'';
            else
                whereClause+=' AND Bore__c=\'None\'';
            if(!Test.isRunningTest()){
                Holder_Option__c[] isVaildSel=Database.query(query+whereClause);
                system.debug(' INLET SECTION isVaildSel'+isVaildSel);
                if(isVaildSel.size()==0) {
                    system.debug(' INLET SECTION isVaildSel'+isVaildSel);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select a Valid combination for Inlet Components'));
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select valid combination for Outlet Components'));
                    //isValid=false;
                    return null;
                }
            }
            conHolder.Inlet_Material__c = selectedInletMaterial;
            conHolder.Knifeblade_Material_Inlet__c = selectedKnifebladeMaterialInlet;
            conHolder.Gauge_Tap_Inlet__c = selectedGaugeTapInlet;
            conHolder.Eyebolts_Drilling_Inlet__c = selectedEyeboltsDrillingInlet;
            conHolder.J_Hook__c = selectedjHook;
            conHolder.Facing_Inlet__c = selectedFacingInlet;
            conHolder.Coating_Inlet__c = selectedCoatingInlet;
            conHolder.Lining_Inlet__c = selectedLiningInlet;
            conHolder.Bore_Inlet__c = selectedBoreInlet;
        }
        
        if(bodySectionFlag){
            conHolder.Body_Material__c = selectedBodyMaterial;
            conHolder.Coating_Body__c = selectedCoatingBody;
        }
        
        if(studsandNutsFlag){
            conHolder.Studs_and_Nuts__c = selectedStudsandNuts;
        }
        
        if(jackscrewsAdditionalFlag){
            conHolder.Jackscrews_Additional__c = selectedJackscrewsAdditional;
        }
        
        if(String.isBlank(selectedUOMPressMFLGRange)) {
			conHolder.Gauge_Selection_Mid_Flange__c = '';
        }
        
        //cleanSecB();
        if(isValid) {
            try
            {
                system.debug('@@Test saveSecD conHolder => '+conHolder);
                conHolder.Finish_Configuration__c = false; // added by piyush
                update conHolder;
                validProductSec = true;
            }
            catch(Exception dmle) {
                ApexPages.addMessages(dmle);
                return null;
            }
        } else {
            return null;
        }
        isComponentMaterialOptionSaved = true;
        return null;
    }
    
    public static Holders__c generateHolderPartBaseNumber(Holders__c conHolder) {
        
        string strBRANDCODE = AssyPartDefinationProcessor.mapBrandwithCode.get(conHolder.Brand__c.ToUpperCase());
        String ASSYPARTNOBASE = strBRANDCODE+conHolder.Holder_Product_Code__c+conHolder.Size2__c+conHolder.Bolting_Class__c;
        conHolder.Part_Number_Base__c = ASSYPARTNOBASE;
        
        Result resPartEx = new Result();
        if(!Test.isRunningTest())
        {
            resPartEx = AssyPartDefinationProcessor.getPartNumberExisting(ASSYPARTNOBASE, conHolder, 'HLD');
        }        
        System.debug('resPartEx: ' + resPartEx);
        if(resPartEx.bResult)
            conHolder.ASSYPARTEXISTING__c = resPartEx.strRetValue;
        else
            conHolder.ASSYPARTEXISTING__c = null;
        
        //string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(conHolder.Brand__c.ToUpperCase());
        
        return conHolder;
    }
    
    public PageReference saveCleaningMarkingsTesting()
    {
        saveCertifications();
        //cleanSecB();
        //validate data
        if(validateProductSelection()){
            return null;
        }
        if(!Test.isRunningTest()){
            saveProductSelection();
        }
        if(validateComponentMaterialOptionSelection()){
            return null;
        }
        saveComponentMaterialOptionSelection();
        if(String.isNotBlank(selectedInletMaterial)){
            isInletMaterialSelected = true;
        }
        if(String.isNotBlank(selectedOutletMaterial)){
            isOutletMaterialSelected = true;
        }
        
        if(validProductSec == false) {
            if(!Test.isRunningTest()){
                return null;
            }
        }
        System.debug('##################################');
        if(String.isBlank(selectedHolderProduct)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a valid product selection'));
            return null;
        }
        try
        {
            system.debug('@@Test saveSecG conHolder => '+conHolder);
            
            if( !conHolder.Quote_Descriptions_Override__c) {
                
                conHolder = ConfigHolderController.generateHolderPartBaseNumber(conHolder);
            }
            conHolder.Finish_Configuration__c = true; // added by piyush
            update conHolder;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        
        if(!conHolder.Drawing_Outside_Config__c) {
            
            result res = loadDiagramData();
        }
        
        string OA='';
        string OB='';
        string OW='';
        map<String,String> holderInputs = new map<String,String>();
        
        if(!Test.isRunningTest()) {
            holderInputs = ConfigHolderUtility.holderInputs(conHolder);
        }
        Result resDesc=ConfigHolderUtility.getHolderDescription(holderInputs);
        if(Test.isRunningTest()){
            resDesc.bResult = true;
        }
        if(resDesc.bResult) {
            for(sObject sobj:resDesc.objResultList){
                Holder_Description_Detail__c  descRec = new Holder_Description_Detail__c ();
                descRec = (Holder_Description_Detail__c )sobj;
                if (descRec.Attribute__c.startsWith('OA'))
                    OA+=String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                else if (descRec.Attribute__c.startsWith('OB'))
                    OB+=String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                else if (descRec.Attribute__c.startsWith('OW'))
                    OW+=String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
            }
            system.debug('OA:::'+OA);
            hldOutput.put('OA__c',OA);
            hldOutput.put('OB__c',OB);
            hldOutput.put('OW__c',OW);
            if(conHolder.Quote_Descriptions_Override__c == false){
                hldOutput.put('OA_Overridden__c',OA);
                hldOutput.put('OB_Overridden__c',OB);
                hldOutput.put('OW_Overridden__c',OW);
            }
        }
        upsert hldOutput;
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            system.debug('ASHIM DIAGRAM TEST');
            getDiaData();
            quoteLine.Run_Config_Sync__c = false;
            quoteLine.Body_Material__c = conHolder.Body_Material__c;
            quoteLine.Config_Record_Id__c = conHolder.id;
            quoteLine.SBQQ__Quantity__c=conHolder.Quantity__c;
            // quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
            // quoteLine.Non_Discountable_List_Price__c =  rdPricing.Non_Discountable_Price_Each__c.setscale(2);
            // quoteLine.Discountable_List_Price__c = rdPricing.Discountable_Price_Each__c.setscale(2);
            // quoteLine.Leadtime_Site_10__c = rdOutput.Total_Lead_Time_GP_ORD__c;
            // quoteLine.Leadtime_Site_20__c = rdOutput.Total_Lead_Time_GCI_ORD__c;
            // quoteLine.Leadtime_Site_30__c = rdOutput.Total_Lead_Time_CDC_ORD__c;
            // quoteLine.Leadtime_Site_40__c = rdOutput.Total_Lead_Time_40_ORD__c;
            quoteLine.Drawing_to_be_created_outside_of_Config__c=conHolder.Drawing_Outside_Config__c;
            quoteLine.DimA__c=holderDiagram.Dim_A_Override__c;
            quoteLine.DimB__c=holderDiagram.Dim_B_Override__c;
            quoteLine.DimC__c=holderDiagram.Dim_C_Override__c;
            quoteLine.DimD__c=holderDiagram.Dim_D_Override__c;
            quoteLine.DimE__c=holderDiagram.Dim_E_Override__c;
            quoteLine.DimF__c=holderDiagram.Dim_F_Override__c;
            quoteLine.DrawingID__c=holderDiagram.Drawing_ID_Override__c;
            quoteLine.SBQQ__Description__c=strquoteDes.replaceAll('</BR>', '<BR>');
            if(!Test.isRunningTest()){
                upsert quoteLine;
            }
        }
        return new Pagereference('/apex/ConfigHoldersOutputs?qid='+quoteId);
        
    }
    public string strquoteDes {
        get {
            String strProdOver = '';
            if(String.isNotBlank(hldOutput.OA_Overridden__c)){
                strProdOver += hldOutput.OA_Overridden__c +'\n';
            }
            if(String.isNotBlank(hldOutput.OB_Overridden__c)){
                strProdOver += hldOutput.OB_Overridden__c+'\n';
            }
            if(String.isNotBlank(hldOutput.OW_Overridden__c)){
                strProdOver += hldOutput.OW_Overridden__c+'\n' ;
            }
            
            strquoteDes = strProdOver;
            return strquoteDes.replaceAll('\n', '</BR>');
            //return rdOutput.OA_Override__c+'\n'+rdOutput.OB_Override__c+'\n'+rdOutput.ORP_Override__c+'\n'+rdOutput.ORV_Override__c+'\n'+rdOutput.OW_Override__c;
        }
        set {
            this.strquoteDes=value;
        }
    }
    public map<string,string> mapDocData{get;set;}
    public string diagramURL {set;get;}
    public boolean showDia1 {set;get;}
    public boolean showDia2 {set;get;}
    public result loadDiagramData(){
        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();
        /*
mapDia.put('HPTC',conHolder.Holder_Product_Code__c);
mapDia.put ('Entity',conHolder.Brand__c);
mapDia.put ('COIN',conHolder.Inlet_Option__c);
mapDia.put ('SZC',conHolder.Size2__c);
mapDia.put ('HCLASS',conHolder.Bolting_Class__c);
*/
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
        selectCols.add('DWGNO__c');
        selectCols.add('Revision__c');
        
        resDiaData = ConfigHolderUtility.getDataFromTranslationObj('Drawing_Type__c','Holder_Drawings_Translation__c','Holder_Drawings_Detail__c',mapDia,selectCols, null);
        result resD = new result ();
        List<Holder_Drawings__c> holderDiagramList1 = [SELECT Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,
                                                       Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,
                                                       Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c, 
                                                       IINO_DWGNO__c, JHOOK_IINO_DWGNO__c, Submittal_Drawing_DWGNO__c, Revision__c  
                                                       FROM Holder_Drawings__c 
                                                       WHERE Holders__c = :conHolder.id];
        Holder_Drawings__c holderD = new Holder_Drawings__c();
        if(holderDiagramList1.size()>0){
            holderD = holderDiagramList1[0];
        } else{
            holderD.Holders__c = conHolder.id;
        }
        Integer submittalDrawingFound = 0;
        List<Holder_Drawings__c> holderDiaList = new List<Holder_Drawings__c>();
        
        if(!conHolder.Diagram_Override__c) {
            
            if(resDiaData.bResult) {
                for (sObject sObj: resDiaData.objResultList) {
                    if ((string) sObj.get('Drawing_Type__c') == 'Submittal Drawing') {
                        
                        holderD.Drawing_ID__c = (string) sObj.get('DrawingID__c');
                        holderD.Submittal_Drawing_DWGNO__c = (string) sObj.get('DWGNO__c');
                        holderD.Drawing_ID_Override__c = (string) sObj.get('DrawingID__c');
                        holderD.Revision__c = (string) sObj.get('Revision__c');  
                        
                        holderD.Dim_A__c = (string) sObj.get('DimA__c');
                        holderD.Dim_B__c = (string) sObj.get('DimB__c');
                        holderD.Dim_C__c = (string) sObj.get('DimC__c');
                        holderD.Dim_D__c = (string) sObj.get('DimD__c');
                        holderD.Dim_E__c = (string) sObj.get('DimE__c');
                        holderD.Dim_F__c = (string) sObj.get('DimF__c');
                        
                        holderD.HIC__c = (string) sObj.get('HIC__c');
                        holderD.HOC__c = (string) sObj.get('HOC__c');
                        holderD.SizeClassDesc__c = (string) sObj.get('SizeClassDesc__c');
                        
                        if(conHolder.Diagram_Override__c == false) {
                            
                            holderD.Dim_A_Override__c = (string) sObj.get('DimA__c');
                            holderD.Dim_B_Override__c = (string) sObj.get('DimB__c');
                            holderD.Dim_C_Override__c = (string) sObj.get('DimC__c');
                            holderD.Dim_D_Override__c = (string) sObj.get('DimD__c');
                            holderD.Dim_E_Override__c = (string) sObj.get('DimE__c');
                            holderD.Dim_F_Override__c = (string) sObj.get('DimF__c');
                        }
                        
                        submittalDrawingFound = 1;
                    }
                    if ((string) sObj.get('Drawing_Type__c') == 'J-Hook IINO') {
                        
                        holderD.JHOOK_IINO_DWGNO__c = (string) sObj.get('DWGNO__c');
                        holderD.J_Hook_IINO__c=(string) sObj.get('DrawingID__c');
                    }
                    if ((string) sObj.get('Drawing_Type__c') == 'IINO'){
                        
                        holderD.IINO_DWGNO__c = (string) sObj.get('DWGNO__c');
                        holderD.IINO__c=(string) sObj.get('DrawingID__c');
                    }
                }
            }
            
            //If no drawing found then set the default drawing for "submittal drawing" to 9999
            if(submittalDrawingFound == 0 || holderD.Drawing_ID__c == null) {
                
                holderD.Drawing_ID__c = Label.Default_Submittal_Drawing;
                holderD.Drawing_ID_Override__c = Label.Default_Submittal_Drawing;
            }
            
        }
        
        try {
            holderDiaList.add(holderD);
            upsert holderD;
            
            if(holderD.Submittal_Drawing_DWGNO__c != null) {
                
                conHolder.DWGNO__c = holderD.Submittal_Drawing_DWGNO__c;
            }
            update conHolder;
            
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
        holderDiagramList=[select IINO__c,J_Hook_IINO__c,Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c from Holder_Drawings__c where Holders__c=:conHolder.id];
        if (!holderDiagramList.isEmpty()) {
            holderDiagram=holderDiagramList[0];
            diagramURL=holderDiagram.Drawing_ID_Override__c;
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
            result abc=loadDiagramData();
            if (abc.bResult)
                holderDiagram=(Holder_Drawings__c) abc.objResultList[0];
        }
        if(mapDocData == null) {
            
            mapDocData = new Map<String, String>();
        }
        System.debug('mapDocData: ' + mapDocData);
        if(holderDiagram != null && holderDiagram.Drawing_ID__c!=null)
            mapDocData.put('Submittal Drawing', holderDiagram.Drawing_ID__c);
        // if(holderDiagram.IINO__c!=null)
        //     mapDocData.put('IINO',holderDiagram.IINO__c);
        // if(holderDiagram.J_Hook_IINO__c!=null)
        //     mapDocData.put('J-Hook IINO',holderDiagram.J_Hook_IINO__c);
        System.debug('mapDocData: ' + mapDocData);
    }
    
    public void cleanSecB(){
        /*        conHolder.ASME_Section_VIII__c='';
conHolder.CSA_Markings__c=false;
conHolder.ATEX_Certificate__c='';
conHolder.GOST_CUTR_Compliance__c=false;
conHolder.CE_PED_Compliance__c=false;
conHolder.KOSHA_Compliance__c=false;
conHolder.NACE_Compliance__c='';
conHolder.X3A_Sanitary_Standards__c=false;
conHolder.China_Manufacturing_License__c='';
*/
    }
    
    public static Result getConvertedValErrorMsg(string strConvType, decimal decMaxVal, decimal decMinVal, 
                                                 string strBaseUnits,string strUserUnits,decimal value, 
                                                 string fieldname) {
                                                     
                                                     Result res1, res2;
                                                     Result res = new Result();
                                                     if (strConvType == 'Temperature') {
                                                         System.debug('temp: ' + strConvType);
                                                         try{
                                                             List<Temparature__c> temp = [SELECT Multiplier__c,Adder__c,Divider__c FROM Temparature__c 
                                                                                          WHERE Temperature_UOM_From__c=:strBaseUnits AND 
                                                                                          Temperature_UOM_To__c=:strUserUnits  LIMIT 1];
                                                             System.debug('temp: ' + temp);
                                                             System.debug('units: ' + strBaseUnits);
                                                             System.debug('strUserUnits: ' + strUserUnits);
                                                             
                                                             if (!temp.isEmpty()) {
                                                                 
                                                                 System.debug('value: ' + value);
                                                                 decimal maxVal = ((decMaxVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                                                                 decimal minVal = ((decMinVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                                                                 
                                                                 maxVal = maxVal.setScale(2);
                                                                 minVal = minVal.setScale(2);
                                                                 System.debug('value: ' + value);
                                                                 System.debug('minVal: ' + minVal);
                                                                 System.debug('maxVal: ' + maxVal);
                                                                 
                                                                 //res1 = unitConversions.SignificantDigitsUp(minVal,4,-99);
                                                                 //decimal minvalmsg = res1.dblRetValue;
                                                                 //system.debug('minvalmsg::'+minvalmsg+' ## '+minVal);
                                                                 //res2 = unitConversions.SignificantDigitsDown(maxVal,4,-99);
                                                                 //decimal maxvalmsg = res2.dblRetValue;
                                                                 
                                                                 if (value < minVal || value > maxVal) {
                                                                     
                                                                     res.bResult = true;
                                                                     res.bErrorCheck = true;
                                                                     res.strErrorMessage = fieldname+' : Please enter valid value between '+minVal+' '+strUserUnits+' and '+maxVal+' '+strUserUnits;
                                                                     //res.strErrorMessage=fieldname+' : Temperature Setting must be Greater than '+minVal.setScale(2)+' '+strUserUnits+' and less than '+maxVal.setScale(2)+' '+strUserUnits;
                                                                 } else {
                                                                     
                                                                     res.bResult = true;
                                                                     res.bErrorCheck = false;
                                                                 }
                                                             }
                                                         } catch (Exception e) {
                                                             
                                                             System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                                                             res.bResult = false;
                                                             res.dblRetValue = 0;
                                                             //objResult.strErrorMessage = e.getMessage();
                                                             System.debug(res.strErrorMessage);
                                                         }
                                                     }
                                                     return res;
                                                 }
}