public with sharing class configureBGRProduct {
    public BGR__c conBGR {get; set;}
    public Boolean ReorderFlag{get;set;}
    public id qliId {set;get;}
    public SBQQ__QuoteLine__c qli {set;get;}
    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public string strQuoteStatus {set;get;}
    public boolean showsales {get;set;}
    public boolean disableButton {get;set;}
    public string editModeLable {get;set;}   
    public string strURL{get;set;}
    public boolean showSecB {set; get;}
    public string getcomboorifice {set; get;}
    public string selectedTab{get; set;}
    public Map<String,String> scheduleLabels{get; set;}
    public boolean showConfigutaionTab{get; set;}
    public string quoteStatus;
    public string configStatus; 
    public string defaultQuoteLineView;  
    public string QuoteLIneView{get;set;}
    public boolean bShowEditButton{get;set;}
    public boolean bShowReturnToProductSelectionButton{get;set;}
    public boolean displayPopup {get;set;}
    public boolean bReadOnlyChceckBox {get;set;}
    
    private static Map<String, Schema.SObjectField> BGRFieldMap;

    public ProductAccessibilityConfig__mdt oPacMetaData;

    //cpqproject
public configureBGRProduct(ApexPages.StandardController controller) {

    //Nagrjuna added Tab visibility logic
      ReorderFlag=false;
      showsales = false;					  
      disableButton = true;
      
                // visibility logic ended
      displayPopup = false;
      // routingOpp=new List<String>();
      qliId=ApexPages.currentPage().getParameters().get('qid');
      qli=[SELECT Id, Run_Config_Sync__c,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c WHERE Id=:qliId];
      
      if(string.isNotBlank(qliId)) {
        quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :qliId];
        strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        System.debug('@Developer --> quoteLine :' + quoteLine);
      }
      else{
        System.debug('QuoteLine Id is Missing');
      }
      
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
      
      editModeLable = 'Edit';	
      quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
      // added by piyush...
      fetchBGR();
            
      OrificeSettings = new list<selectOption>();
      if(conBGR.Id != null)
      {
          if(String.isNotBlank(conBGR.Combo_Orifice_Setting__c))
          {
              OrificeSettings.add(new selectOption(conBGR.Combo_Orifice_Setting__c,conBGR.Combo_Orifice_Setting__c));
          }
      }
      selectedTab = 'Sizing1';
      
      if(conBGR.Configuration_Complete__c){
        selectedTab = 'ProductReview';  
    }
    
    
      //selectedTab=second
      if(ApexPages.currentPage().getParameters().get('selectedTab') != 'second')
      {
      showConfigutaionTab = true;
      }
      
      if(ApexPages.currentPage().getParameters().get('selectedTab') == 'second')
      {
          //selectedTab = 'ProductReview';
          showConfigutaionTab = false;
      }
      
      if(ApexPages.currentPage().getParameters().get('selectedTab') == 'Quote')
      {
          selectedTab = 'Quote';
      }

      scheduleLabels = new Map<String, String>();
      scheduleLabels.put('BGRA','Base Lead Time');
      scheduleLabels.put('BGRB','Base Lead Time');
      scheduleLabels.put('BGRC','Base Lead Time');
      scheduleLabels.put('BGRD','Base Lead Time');
      scheduleLabels.put('BGREST','Lead Time Adder');
      scheduleLabels.put('BGRHYDRO','Lead Time Adder');
      scheduleLabels.put('BGRZERO','Lead Time Adder');
      
      BGROU = new BGROutputUtility(conBGR.Id);
      shellTestValue = BGROU.CONSTACTTST;
      shellTestValueBody = BGROU.CONSTBDYTST;
      
      BGRPriceWrapperList = new list<priceWrapper>(); 
      getStructure(); 
      GetQuoteDescriptionRec();
      //System.debug('@@@ conBGR.Shell_Test_Valve_Body__c = '+conBGR.Shell_Test_Valve_Body__c);
  }


    public void fetchBGR(){

        conBGR = DataSelectorWizard.getBGRProductRecord(qliId);

        system.debug('conBGR --> Configuration_Complete__c ' + conBGR.Configuration_Complete__c);
        system.debug('conBGR Quote_Description_Engineer_Override__c --> ' + conBGR.Quote_Description_Engineer_Override__c);

        if(conBGR.Configuration_Complete__c){
           if(conBGR.Quote_Description_Engineer_Override__c){
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
        system.debug('quoteStatus----> ' + quoteStatus);
        system.debug('configStatus----> ' + configStatus);
        oPacMetaData = fetchCurrentProductAccessibility( quoteStatus , configStatus);
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
        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            if (conBGR.Price_Engineer_Override__c == true ||
                conBGR.Lead_Time_Engineer_Override__c == true ||
                conBGR.Build_Cost_Override__c == true ||
                conBGR.Quote_Description_Engineer_Override__c == true
                ){
                    disableButton = true;
                    bShowEditButton = false;
            }
         }


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

   public configureBGRProduct(Id QuotelineId) {

        //Nagrjuna added Tab visibility logic
        showsales = false;
        disableButton = false;

        // visibility logic ended
        displayPopup = false;
        // routingOpp=new List<String>();
        qliId = QuotelineId;
        qli=[SELECT Id, Run_Config_Sync__c FROM SBQQ__QuoteLine__c WHERE Id=:qliId];
        
        quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :qliId];
        system.debug('@Developer -->quoteLine:' + quoteLine);

        strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;        
        conBGR = DataSelectorWizard.getBGRProductRecord(qliId);
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
        if(profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }
        disableButton = (!showsales) && conBGR.Quote_Description_Engineer_Override__c ;

        //strucPartList=new List<String>();

        OrificeSettings = new list<selectOption>();
        if(conBGR.Id != null)
        {
            if(String.isNotBlank(conBGR.Combo_Orifice_Setting__c))
            {
                OrificeSettings.add(new selectOption(conBGR.Combo_Orifice_Setting__c,conBGR.Combo_Orifice_Setting__c));
            }
        }
        selectedTab = 'Sizing1';
        showConfigutaionTab = true;       

        scheduleLabels = new Map<String, String>();
        scheduleLabels.put('BGRA','Base Lead Time');
        scheduleLabels.put('BGRB','Base Lead Time');
        scheduleLabels.put('BGRC','Base Lead Time');
        scheduleLabels.put('BGRD','Base Lead Time');
        scheduleLabels.put('BGREST','Lead Time Adder');
        scheduleLabels.put('BGRHYDRO','Lead Time Adder');
        scheduleLabels.put('BGRZERO','Lead Time Adder');
        BGROU = new BGROutputUtility(conBGR.Id);
        BGRPriceWrapperList = new list<priceWrapper>(); 
        shellTestValue = BGROU.CONSTACTTST;
        shellTestValueBody = BGROU.CONSTBDYTST;
        System.debug('@@@ conBGR.Shell_Test_Valve_Body__c = '+conBGR.Shell_Test_Valve_Body__c);
    }

    public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
            strURL = '/apex/ConfigBgrReference?Id=' + conBGR.Id;

        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }

    public PageReference checkoverridevalue()
    {
        System.debug('***** conBGR.Price_Engineer_Override__c = '+conBGR.Price_Engineer_Override__c);
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
    public BGROutputUtility BGROU {get;set;}
    /*This method is used to hide Section B*/
    public PageReference showSectionB()
    {
        System.debug('***** conBGR.Narrow_selection_on_flow_requirements__c = '+conBGR.Narrow_selection_on_flow_requirements__c);
        if(conBGR.Narrow_selection_on_flow_requirements__c == false) {
            conBGR.Supply_Gas__c = 'Customer Specified';
            conBGR.Customer_Specified_Media__c = '';
            conBGR.Molecular_Weight__c = null;
            conBGR.Compressibility_Factor__c = null;
            conBGR.Ratio_of_Specific_Heats__c = null;
            conBGR.Supply_Gas_Temperature__c = null;
            conBGR.Supply_Gas_Temperature_Units__c = '';
            conBGR.Minimum_Required_Flow_Capacity__c = null;
            conBGR.Flow_Units__c = null;
        }
        System.debug('***** conBGR = '+conBGR);
        update conBGR;
        return null;
    }
    /*This method is for the Go back button on the VF*/
    public pageReference goBack() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :qliId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            //strURL =  '/s/detail/'+qID ;
            strURL = '/s/blanketgasregulatorcmp?quoteId='+qID + '&configId=' + conBGR.Id;
        }else{
            //strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
            strURL = '/lightning/cmp/c__BlanketGasRegulatorCmp?c__configId='+conBGR.Id + '&c__quoteId=' +qID;
        }
        //PageReference pageRef = new PageReference('/lightning/r/SBQQ__Quote__c/'+qID+'/view');
        //pageRef.setRedirect(true);
        return null;
    }

    public pageReference goBackToQuote() {
        Id qID = [SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :qliId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL =  '/s/detail/'+qID ;
        }else{
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        } 
        return null;
    }


    //BGR Cleanup Methods
    public void cleanSecB(){
        conBGR.Configuration_Complete__c=false;
        conBGR.Section_B_flag__c=false;

        conBGR.Supply_Gas__c=null;
        conBGR.Customer_Specified_Media__c=null;
        conBGR.Supply_Gas_Temperature__c=null;
        conBGR.Supply_Gas_Temperature_Units__c=null;
        conBGR.Minimum_Required_Flow_Capacity__c=null;
        conBGR.Flow_Units__c=null;

    }
    public void cleanSecC(){
        conBGR.Configuration_Complete__c=false;
        conBGR.Certifications_flag__c=false;

        conBGR.Atex__c=null;
        conBGR.GOST_CU_Tr_010_2011__c=null;
        conBGR.CSA_Markings__c=null;
    }
    public void cleanSecD(){
        conBGR.Configuration_Complete__c=false;
        conBGR.Product_selection_flag__c=false;

        conBGR.Size__c=null;
        conBGR.Model__c=null;
        conBGR.Orifice_Setting__c=null;
    }
    public void cleanSecE(){
        conBGR.Configuration_Complete__c=false;
        conBGR.Product_material_options_flag__c=false;

        conBGR.Quantity__c=null;
        conBGR.Body_Material_dynamic__c='';
        conBGR.Soft_Goods_Material_dynamic__c='';
        conBGR.Connection_dynamic__c='';
    }
    public void cleanSecF(){
        conBGR.Configuration_Complete__c=false;
        conBGR.Valve_Examination_Flag__c=false;

        conBGR.Radiography__c=null;
        conBGR.Positive_Material_Identification__c=null;
        //conBGR.Shell_test__c=null;
        //conBGR.Shell_Test_Valve_Body__c=null;
    }
    public void cleanSecG(){
        conBGR.Configuration_Complete__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;

        conBGR.Final_Assembly_Location_Requirements__c='00';
        conBGR.Material_Sourcing_Requirements__c='00';
    }

    public PageReference SaveDocID()
    {
      /*  conBGR.PartNumberBase_Checkbox__c=true;
        update conBGR;
        return null; */

        try {
            conBGR.PartNumberBase_Checkbox__c=true;
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;

    }


    /* This method is to convert the Pressure settings from any unit to psig and Save the Section Sizing*/
    public PageReference saveRelief()
    {
        conBGR.Configuration_Complete__c=false;
        conBGR.Relief_Flag__c=true;
        conBGR.Section_B_flag__c=false;
        conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Product_selection_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;

        if(conBGR.Supply_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (conBGR.Supply_Pressure__c != Null)
            {
                resultConvertPressure=unitConversions.convertPressure(conBGR.Supply_Pressure_Units__c,'psig',conBGR.Supply_Pressure__c);
            }
            if(resultConvertPressure.bResult)
            {
                conBGR.Converted_Supply_Pressure__c=resultConvertPressure.dblRetValue;
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
            }
        }

        if(conBGR.Setting_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (conBGR.Setting__c != Null)
            {
                resultConvertPressure=unitConversions.convertPressure(conBGR.Setting_Units__c,'in. water',conBGR.Setting__c);
                if(resultConvertPressure.bResult)
                    conBGR.Converted_Setting__c=resultConvertPressure.dblRetValue;

                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }

        if(conBGR.Atmospheric_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (conBGR.Atmospheric_Pressure__c != Null)
            {
                resultConvertPressure=unitConversions.convertPressure(conBGR.Atmospheric_Pressure_Units__c,'psia',conBGR.Atmospheric_Pressure__c);
                if(resultConvertPressure.bResult)
                    conBGR.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;

                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        /*To calculate the PresRatio*/
        if(conBGR.Converted_Supply_Pressure__c !=null & conBGR.Converted_Atmospheric_Pressure__c !=null)
        {
            conBGR.PresRatio__c = (conBGR.Converted_Atmospheric_Pressure__c/(conBGR.Converted_Atmospheric_Pressure__c+conBGR.Converted_Supply_Pressure__c)).setScale(9);
        }
        if(String.isNotBlank(conBGR.Size__c) )
        {

        }

        try {
            cleanSecB();
            //cleanSecC();
            cleanSecD();
            cleanSecE();
            cleanSecF();
            cleanSecG();
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    /* This method is to convert the Pressure settings from any unit to in.water*/
    public PageReference saveSetting() {
        //conBGR.Relief_Flag__c=true;
        if(conBGR.Setting_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (conBGR.Setting__c != Null)
            {
                resultConvertPressure=unitConversions.convertPressure(conBGR.Setting_Units__c,'in. water',conBGR.Setting__c);
                if(resultConvertPressure.bResult)
                    conBGR.Converted_Setting__c=resultConvertPressure.dblRetValue;

                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        return null;
    }
    /* This method is to convert the Atmospehric Pressure from any unit to psia*/
    public PageReference saveAtm() {
        //conBGR.Relief_Flag__c=true;
        if(conBGR.Atmospheric_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (conBGR.Atmospheric_Pressure__c != Null)
            {
                resultConvertPressure=unitConversions.convertPressure(conBGR.Atmospheric_Pressure_Units__c,'psia',conBGR.Atmospheric_Pressure__c);
                if(resultConvertPressure.bResult)
                    conBGR.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;

                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        return null;
    }
    /* This method is to convert the Supply Gas Temperature settings from any unit to Deg R*/
    public PageReference TempUnit() {
        //conBGR.Relief_Flag__c=true;
        if(conBGR.Supply_Gas_Temperature_Units__c != Null) {
            Result resultConvertTemperature= new Result();
            if (conBGR.Supply_Gas_Temperature__c != Null)
            {
                resultConvertTemperature=unitConversions.convertTemperature(conBGR.Supply_Gas_Temperature_Units__c,'Deg R',conBGR.Supply_Gas_Temperature__c);
                if(resultConvertTemperature.bResult)
                    conBGR.Converted_Supply_Gas_Temperature__c=resultConvertTemperature.dblRetValue;
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
                }
            }
        }
        return null;
    }
    /* This method is to convert the Flow Units from any unit to SCFH*/
    public PageReference ConSCFH() {
        conBGR.Relief_Flag__c=true;
        if(conBGR.Flow_Units__c != Null) {
            Result resultconvertGasFlowRate= new Result();
            if (conBGR.Minimum_Required_Flow_Capacity__c != Null)
            {
                resultconvertGasFlowRate=unitConversions.convertGasFlowRate(conBGR.Flow_Units__c,'SCFH',conBGR.Minimum_Required_Flow_Capacity__c,conBGR.Converted_Supply_Pressure__c,conBGR.Molecular_Weight__c,conBGR.Converted_Supply_Gas_Temperature__c,conBGR.Compressibility_Factor__c);
                if(resultconvertGasFlowRate.bResult)
                    conBGR.Converted_Flow_Capacity__c=resultconvertGasFlowRate.dblRetValue;
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultconvertGasFlowRate.strErrorMessage));
                }
            }
        }
        try {
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    /*This method is for the Save and continue button on the Section B*/
    public PageReference saveSectionB() {
        conBGR.Configuration_Complete__c=false;
        conBGR.Section_B_flag__c=true;
        conBGR.Relief_Flag__c=false;
        // conBGR.Section_B_flag__c=false;
        conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Product_selection_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;
        try {
            /* List<BGR_FlowCalc__c> FlowTable = new List<BGR_FlowCalc__c>();
FlowTable=[select id,Size_Code__c from BGR_FlowCalc__c where Supply_Pressure__c >=: conBGR.Supply_Pressure__c
and Supply_Pressure__c <=: conBGR.Supply_Pressure__c
and Supply_Gas__c =: conBGR.Supply_Gas__c
and Flow_Capacity__c >=: conBGR.Converted_Flow_Capacity__c
and Flow_Capacity__c <=: conBGR.Converted_Flow_Capacity__c limit 1];
if(FlowTable.size() > 0)
{
//conBGR.Size__c = FlowTable[0].Size_Code__c + '';
} */

            if(conBGR.Supply_Gas_Temperature_Units__c != Null) {
                Result resultConvertTemperature= new Result();
                if (conBGR.Supply_Gas_Temperature__c != Null)
                {
                    resultConvertTemperature=unitConversions.convertTemperature(conBGR.Supply_Gas_Temperature_Units__c,'Deg R',conBGR.Supply_Gas_Temperature__c);
                    if(resultConvertTemperature.bResult)
                        conBGR.Converted_Supply_Gas_Temperature__c=resultConvertTemperature.dblRetValue;
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
                    }
                }
            }
            if(conBGR.Flow_Units__c != Null) {
                Result resultconvertGasFlowRate= new Result();
                if (conBGR.Minimum_Required_Flow_Capacity__c != Null)
                {
                    resultconvertGasFlowRate=unitConversions.convertGasFlowRate(conBGR.Flow_Units__c,'SCFH',conBGR.Minimum_Required_Flow_Capacity__c,conBGR.Converted_Supply_Pressure__c,conBGR.Molecular_Weight__c,conBGR.Converted_Supply_Gas_Temperature__c,conBGR.Compressibility_Factor__c);
                    if(resultconvertGasFlowRate.bResult)
                        conBGR.Converted_Flow_Capacity__c=resultconvertGasFlowRate.dblRetValue;
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultconvertGasFlowRate.strErrorMessage));
                    }
                }
            }
           // cleanSecC();
            cleanSecD();
            cleanSecE();
            cleanSecF();
            cleanSecG();
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    /*This method is for the Save and continue button on the Certificate*/
    public PageReference saveCertificate()
    {
        conBGR.Configuration_Complete__c=false;
        conBGR.Certifications_flag__c=true;
        conBGR.Relief_Flag__c=false;
        conBGR.Section_B_flag__c=false;
        //conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Product_selection_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;
        try
        {
            cleanSecD();
            cleanSecE();
            cleanSecF();
            cleanSecG();
            Map<String, String> Orificevalue = new Map<String, String>();
            OrificeValue.put('1','100');
            OrificeValue.put('2','75');
            OrificeValue.put('3','50');
            OrificeValue.put('4','25');
            OrificeValue.put('5','20');
            OrificeValue.put('6','15');
            OrificeValue.put('7','10');
            OrificeValue.put('8','05');
            Map<String, String> Sizevalue = new Map<String, String>();
            Sizevalue.put('1','1');
            Sizevalue.put('5','1/2');
            conBGR.KD__c = 0;
            List<BGR_Masterblaster__c> bgrMasterModelList = new List<BGR_Masterblaster__c>();
            bgrMasterModelList = [Select id, MODEL__c,SIZECODE__c,ORIFICE__c from BGR_Masterblaster__c
                                  WHERE Brand__c =: conBGR.Quote_Line__r.SBQQ__Quote__r.Brand__c
                                  AND  SERVICE__c =: conBGR.Service_Type__c
                                  AND SETTINGLL__c <=: conBGR.Converted_Setting__c
                                  AND  SETTINGUL__c >: conBGR.Converted_Setting__c
                                  AND  SUPPLYPRESSURELL__c <: conBGR.Converted_Supply_Pressure__c
                                  AND  SUPPLYPRESSUREUL__c >=: conBGR.Converted_Supply_Pressure__c];
            system.debug('@@@ The narrowed down models are'+bgrMasterModelList);

           /* List<BGR_SettingLimits__c> ModelTable = new List<BGR_SettingLimits__c>();
            ModelTable=[select id,Model__c from BGR_SettingLimits__c
                        where SETTINGLL__c <=: conBGR.Setting__c
                        and  SETTINGUL__c >=: conBGR.Setting__c
                        and  SERVICE__c =: conBGR.Service_Type__c
                        and  SUPPLYPRESSURELL__c <=: conBGR.Supply_Pressure__c
                        and  SUPPLYPRESSUREUL__c >=: conBGR.Supply_Pressure__c
                        //and Size_Code__c =: integer.valueOf(conBGR.Size__c)
                       ];*/
            Set<String> Models = new Set<String>();
            //if(ModelTable.size() > 0)
            OrificeSettings.clear();
            if(bgrMasterModelList.size() > 0)
            {
                if(conBGR.Narrow_selection_on_flow_requirements__c == False)
                {
                    for(BGR_Masterblaster__c bgrModel : bgrMasterModelList)
                    {
                        String SettingValue = bgrModel.MODEL__c + ' ' + Sizevalue.get(bgrModel.SIZECODE__c) + 'inch' + ' ' + ': Orifice ' + OrificeValue.get(bgrModel.ORIFICE__c+'') + '%';
                        OrificeSettings.add(new selectOption(SettingValue,SettingValue));
                        system.debug('Orifice values is:'+OrificeSettings);
                    }
                }
                else
                {
                    for(BGR_Masterblaster__c bgrModel : bgrMasterModelList)
                    {
                        Models.add(bgrModel.MODEL__c);
                    }
                    conBGR.Model__c = bgrMasterModelList[0].MODEL__c + '';

                    /* This is to fecth the Orifice setting value for KD calculation */
                    Map<String, list<BGR_KD__c>> KDMap = new Map<String, list<BGR_KD__c>>();

                    /*To calculate the KD value*/
                    List<BGR_KD__c> KDTable = new List<BGR_KD__c>();
                    KDTable = [select KD__c,PresRatio__c,SizeCode__c,OrificeCode__c from BGR_KD__c
                               order by PresRatio__c ASC];
                    for(BGR_KD__c KD: KDTable)
                    {
                        if(!KDMap.containskey(KD.SizeCode__c + '_' + KD.OrificeCode__c))
                        {
                            KDMap.put(KD.SizeCode__c + '_' + KD.OrificeCode__c, new list<BGR_KD__c>());
                        }
                        KDMap.get(KD.SizeCode__c + '_' + KD.OrificeCode__c).add(KD);
                    }
                    //Map<Boolean, list<String>> SizeMap = new Map<Boolean, list<String>>();
                    Set<String> SizeSet = new Set<String>();
                    for(String KDkey:KDMap.keyset())
                    {
                        Decimal previousPetro = 0,previousKD = 0,nextPetro = 0,nextKD = 0, numerator = 0, denominator = 0, criticalPresRatio = 0;
                        Decimal base = 0, exp = 0;
                        Decimal diameter = 0, FlowRateSCFH = 0;
                        Boolean FlowRateOk;
                        if(KDMap.get(KDkey).size() > 0)
                        {
                            previousPetro = KDMap.get(KDkey)[0].PresRatio__c;
                            system.debug(' initial previousPetro'+previousPetro);
                            nextPetro = KDMap.get(KDkey)[KDMap.get(KDkey).size()-1].PresRatio__c;
                            system.debug(' initial nextPetro'+nextPetro);
                            for(BGR_KD__c kdTableVal: KDMap.get(KDkey))
                            {
                                system.debug('@@QWERT = '+previousPetro+' @@TREWQ = '+kdTableVal.PresRatio__c+'and asdf = '+kdTableVal.PresRatio__c+', fsda = '+conBGR.PresRatio__c);
                                if(previousPetro < kdTableVal.PresRatio__c &&  kdTableVal.PresRatio__c < conBGR.PresRatio__c)
                                {
                                    previousPetro = kdTableVal.PresRatio__c;
                                    system.debug(' @@previousPetro'+previousPetro);
                                    previousKD = kdTableVal.KD__c;
                                    system.debug(' @@previousKD'+previousKD);
                                }
                                else if(kdTableVal.PresRatio__c > conBGR.PresRatio__c)
                                {
                                    nextPetro = kdTableVal.PresRatio__c;
                                    system.debug(' @@nextPetro'+nextPetro);
                                    nextKD = kdTableVal.KD__c;
                                    system.debug(' @@nextKD'+nextKD);
                                    break;
                                }
                            }
                        }
                        numerator = (conBGR.PresRatio__c - previousPetro) * (nextKD - previousKD);
                        system.debug('**numerator'+numerator);
                        denominator = (nextPetro - previousPetro);
                        system.debug('**denominator'+denominator);
                        if(denominator != 0)
                        {
                            conBGR.KD__c = (numerator / denominator) + previousKD;
                        }
                        base = (2/(conBGR.Ratio_of_Specific_Heats__c + 1));system.debug('$$$$$$$$$$$'+base);
                        exp = (conBGR.Ratio_of_Specific_Heats__c / (conBGR.Ratio_of_Specific_Heats__c - 1 ));system.debug('$$$$$$$$$$$'+exp);
                        criticalPresRatio = Math.exp(exp*Math.log(base));system.debug('$$$$$$$$$$$'+criticalPresRatio);
                        if(KDkey.substringBefore('_')=='1')
                        {
                            diameter = 1;
                        }
                        else
                        {
                            diameter = 0.5;
                        }
                        if(conBGR.PresRatio__c >= criticalPresRatio)
                        {
                            decimal Part1if = ((conBGR.Ratio_of_Specific_Heats__c/(conBGR.Ratio_of_Specific_Heats__c-1))*Math.exp((2/conBGR.Ratio_of_Specific_Heats__c)*Math.log(conBGR.PresRatio__c))*Math.exp(((conBGR.Ratio_of_Specific_Heats__c-1)/conBGR.Ratio_of_Specific_Heats__c)*Math.log(1-conBGR.PresRatio__c)));
                            FlowRateSCFH = (60*diameter.pow(2)/4*Math.PI*4645*math.exp(0.5*math.log(Part1if))*conBGR.KD__c*math.exp(0.5*math.log((conBGR.Converted_Supply_Pressure__c+conBGR.Converted_Atmospheric_Pressure__c)*conBGR.Converted_Supply_Pressure__c/(conBGR.Molecular_Weight__c*conBGR.Converted_Supply_Gas_Temperature__c*conBGR.Compressibility_Factor__c))));
                        }
                        else
                        {
                            decimal Part1else = conBGR.Ratio_of_Specific_Heats__c*(Math.exp(((conBGR.Ratio_of_Specific_Heats__c+1)/(conBGR.Ratio_of_Specific_Heats__c-1))*math.log(2/(conBGR.Ratio_of_Specific_Heats__c+1))));
                            FlowRateSCFH = (60 * (diameter.pow(2)/4)) * Math.PI * 6.32 * 520 * (math.exp(0.5*math.log(Part1else)))* conBGR.KD__c *((conBGR.Converted_Supply_Pressure__c+conBGR.Converted_Atmospheric_Pressure__c)/(math.exp(0.5*math.log((conBGR.Molecular_Weight__c*conBGR.Converted_Supply_Gas_Temperature__c*conBGR.Compressibility_Factor__c)))));system.debug('$$$$$$$$$$$'+FlowRateSCFH);
                        }
                        if(FlowRateSCFH >= conBGR.Converted_Flow_Capacity__c && FlowRateSCFH > 0)
                        {
                            FlowRateOk = TRUE;
                            SizeSet.add(KDkey);
                        }
                        else
                        {
                            FlowRateOk = False;
                        }
                    }
                    OrificeSettings.clear();
                    for(String Sizekey : SizeSet)
                    {
                        for(String bgrModel: Models)
                        {
                            String SettingValue = bgrModel + ' ' + Sizevalue.get(Sizekey.substringBefore('_')) + 'inch' + ' ' + ': Orifice ' + OrificeValue.get(Sizekey.substringAfter('_')) + '%'+' '+':'+'Flow Rate'+' '+conBGR.Converted_Flow_Capacity__c.setScale(2)+' '+'SCFH';
                            OrificeSettings.add(new selectOption(SettingValue,SettingValue));
                        }
                    }

                    update conBGR;
                }
            }
             else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'No Model found from the above configurations'));
            }

        }
        catch(Exception dmle) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No Model found from the above configurations'));
            return null;
        }
        return null;
    }
    /*This method is for the Save and continue button on the Product selection*/
    public PageReference saveProductSelection()
    {
        conBGR.Configuration_Complete__c=false;
        conBGR.Product_selection_flag__c=true;
        conBGR.Relief_Flag__c=false;
        conBGR.Section_B_flag__c=false;
        conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        //conBGR.Product_selection_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;
        // string strPriorSZC=conBGR.Size_Backend__c;
        try {
            if(conBGR.Combo_Orifice_Setting__c.substringBetween(' ','inch') == '1')
            {
                conBGR.Size_Backend__c = '1';
            }
            else
            {
                conBGR.Size_Backend__c = '5';
            }

            if(conBGR.Size_Backend__c == '1')
            {
                conBGR.Size__c = '1';
            }
            else
            {
                conBGR.Size__c = '5';
            }
            conBGR.Orifice_value__c = conBGR.Combo_Orifice_Setting__c.substringAfter('Orifice');

            if(String.isNotBlank(conBGR.Combo_Orifice_Setting__c))
            {
                conBGR.Model__c = conBGR.Combo_Orifice_Setting__c.substringBefore(' ');
            }
            system.debug('***Orifice value'+conBGR.Orifice_value__c);
            getBodyMaterial();
            // if(strPriorSZC!=conBGR.Size_Backend__c)
            // {
            cleanSecE();
            cleanSecF();
            cleanSecG();
            // }
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    public string shellTestValue{get;set;}
    public string shellTestValueBody{get;set;}
    /*This method is for the Save and continue button on the Product Materials and Options*/
    public PageReference saveProductMaterials() {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; 
        conBGR.Product_material_options_flag__c=true; 
        conBGR.Configuration_Complete__c = false;
		
        if(!ReorderFlag)
          ApexPages.getMessages().clear();
        // conBGR.Configuration_Complete__c=false;
        system.debug(conBGR.Quantity__c);
        system.debug(conBGR.Body_Material_dynamic__c);
        system.debug(conBGR.Connection_dynamic__c);
        system.debug(conBGR.Soft_Goods_Material_dynamic__c);

        if(conBGR.Quantity__c == 0 || conBGR.Quantity__c== null || conBGR.Body_Material_dynamic__c== null || conBGR.Soft_Goods_Material_dynamic__c== null ||conBGR.Connection_dynamic__c == null){
            system.debug('Inside error condition');
            if(conBGR.Quantity__c == 0)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Quantity:Please Enter Quantity greater than 0'));
            if(conBGR.Quantity__c == null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Quantity: Please Enter a Value'));
            if(conBGR.Body_Material_dynamic__c == null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Body Material: Please Enter a Value'));
            if(conBGR.Connection_dynamic__c == null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' Connection: Please Enter a value '));
            if(conBGR.Soft_Goods_Material_dynamic__c == null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Soft Goods Material: Please Enter a Value'));

            strURL = 'error';
            return null;
        }else{
            conBGR.Product_material_options_flag__c=true;
            // conBGR.Relief_Flag__c=false;
            // conBGR.Section_B_flag__c=false;
            // conBGR.Certifications_flag__c=false;
            // //conBGR.Product_material_options_flag__c=false;
            // conBGR.Product_selection_flag__c=false;
            // conBGR.Valve_Examination_Flag__c=false;
            // conBGR.Document_Or_Sourcing_flag__c=false;
            try
            {
                //BGROutputUtility ShellTest = new BGROutputUtility(conBGR.Id);

                system.debug('***** ShellTest = '+BGROU);
                system.debug('$$$CONSTACTTST: '+BGROU.CONSTACTTST);
                shellTestValue = BGROU.CONSTACTTST;
                shellTestValueBody = BGROU.CONSTBDYTST;
                system.debug('$$$CONSTBDYTST: '+BGROU.CONSTBDYTST);
                if(BGROU.CONSTACTTST=='PneuAutoHydAvail' || BGROU.CONSTACTTST=='PneuAutoHydNotAvail')
                {
                    conBGR.Shell_test__c = 'AIR';
                }
                else if(BGROU.CONSTACTTST=='HydAutoPneuAvail' || BGROU.CONSTACTTST=='HydAutoPneuNotAvail')
                {
                    conBGR.Shell_test__c = 'HYDRO';
                }
                if(BGROU.CONSTBDYTST=='PneuAutoHydAvail' || BGROU.CONSTBDYTST=='PneuAutoHydNotAvail')
                {
                    conBGR.Shell_Test_Valve_Body__c = 'AIR';
                }
                else if(BGROU.CONSTBDYTST=='HydAutoPneuAvail' || BGROU.CONSTBDYTST=='HydAutoPneuNotAvail')
                {
                    conBGR.Shell_Test_Valve_Body__c = 'HYDRO';
                }
                system.debug('$$$SHell Test Actuator'+conBGR.Shell_test__c);
                system.debug('$$$SHell Test Actuator'+conBGR.Shell_Test_Valve_Body__c);
                
                if(!ReorderFlag){
                  	cleanSecF();
                	cleanSecG();  
                }
                
                conBGR.Positive_Material_Identification__c = 'N';
                conBGR.Radiography__c = 'N';
                update conBGR;
            }
            catch(Exception dmle) {
                ApexPages.addMessages(dmle);
                return null;
            }
            User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
            //system.debug('$$$Back URl:'+qID);
            if(userinfo.IsPortalEnabled){
                String url = '/apex/ConfigBGR?qid='+qliId;
                String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                strURL =  encoded ;
            }else{
                strURL = '/apex/ConfigBGR?qid='+qliId;
            }
            // pageReference reloadpage = new pageReference('/apex/ConfigBGR?qid='+qliId);
            //  reloadpage.setRedirect(true);
            // system.debug('!!!!URL:'+reloadpage);
            return null;
        }
    }
    /*This method is to calculate the Lead time for the BGR schedule */
    /*try {
List<Leadtime_Global__c> lt = new List<Leadtime_Global__c>();
lt = [select CDC__c,GCI__c,GP__c from Leadtime_Global__c
where Schedule__c=:conBGR.Schedule__c
and QtyLL__c <=: conBGR.Quantity__c
and QtyUL__c >=: conBGR.Quantity__c
limit 1];
if(! lt.isEmpty())
{
conBGR.Working_days_CDC__c=lt.get(0).CDC__c*5;
conBGR.Working_days_GP__c=lt.get(0).GCI__c*5;
conBGR.Working_days_GCI__c=lt.get(0).GP__c*5;
}

}
catch(Exception dmle)
{
ApexPages.addMessages(dmle);
return null;
}

update conBGR; */
    public PageReference showPopup()
    {
        if(BGROU.CONSTACTTST == 'PneuAutoHydNotAvail')
        {
            conBGR.Shell_test__c = 'AIR';
        }
        else if(BGROU.CONSTACTTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_test__c = 'HYDRO';
        }
        if(BGROU.CONSTBDYTST=='PneuAutoHydNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'AIR';
        }
        else if(BGROU.CONSTBDYTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'HYDRO';
        }
        if(conBGR.Shell_test__c == 'HYDRO' || conBGR.Shell_Test_Valve_Body__c == 'HYDRO')
        {
            displayPopup = true;
            return null;
        }
        return saveValveExamination();
    }

    /*This method is for the Save and continue button on the Valve Examination option*/
    public PageReference saveValveExamination()
    {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; 
        displayPopup = false;
        conBGR.Configuration_Complete__c=false;
        conBGR.Valve_Examination_Flag__c=true;
        conBGR.Relief_Flag__c=false;
        conBGR.Section_B_flag__c=false;
        conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Product_selection_flag__c=false;
        // conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;
        if(BGROU.CONSTACTTST == 'PneuAutoHydNotAvail')
        {
            conBGR.Shell_test__c = 'AIR';
        }
        else if(BGROU.CONSTACTTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_test__c = 'HYDRO';
        }
        if(BGROU.CONSTBDYTST=='PneuAutoHydNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'AIR';
        }
        else if(BGROU.CONSTBDYTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'HYDRO';
        }
        try {
            if(!ReorderFlag){
                cleanSecG();
            }
            	            
            System.debug('@@@ Before update = '+conBGR.Shell_Test_Valve_Body__c);
            update conBGR;
            System.debug('@@@ After update = '+conBGR.Shell_Test_Valve_Body__c);
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    /*This method is for the Save and continue button on the Certificate Document Or Sourcing Requirements section*/
    public PageReference saveDocSourcing() 
    {
        if(!ReorderFlag)
            ApexPages.getMessages().clear();
        if(conBGR.Quantity__c == 0 || conBGR.Quantity__c== null || conBGR.Body_Material_dynamic__c== null || conBGR.Soft_Goods_Material_dynamic__c== null ||conBGR.Connection_dynamic__c == null || conBGR.Final_Assembly_Location_Requirements__c == null || conBGR.Material_Sourcing_Requirements__c == null)
        {
            
            if(conBGR.Quantity__c == 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Quantity:Please Enter Quantity greater than 0'));
            if(conBGR.Quantity__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Quantity: Please Enter a Value'));
            if(conBGR.Body_Material_dynamic__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Body Material: Please Enter a Value'));
            if(conBGR.Connection_dynamic__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' Connection: Please Enter a value '));
            if(conBGR.Soft_Goods_Material_dynamic__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Soft Goods Material: Please Enter a Value'));
            if(conBGR.Final_Assembly_Location_Requirements__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Final Assembly requirements: Please Enter a Value'));
            if(conBGR.Material_Sourcing_Requirements__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Material Sourcing requirements:Please Enter a Value'));
            
            strURL = 'error';
            return null;
        }
        else
        {
            conBGR.Configuration_Complete__c=true;
            conBGR.Document_Or_Sourcing_flag__c=true;
            conBGR.Relief_Flag__c=false;
            conBGR.Section_B_flag__c=false;
            conBGR.Certifications_flag__c=false;
            conBGR.Product_material_options_flag__c=false;
            conBGR.Product_selection_flag__c=false;
            conBGR.Valve_Examination_Flag__c=false;
            //     ASSYPARTNOBASE=strBRANDCODE+MODEL+'00'+SIZE+'00'+MCUS+MCLS+PEDCON+mapAttValues.get('IgnitorOpt')+mapAttValues.get('SpecialOpt')+mapAttValues.get('EnclosureOpt')+mapAttValues.get('FlameSensorOpt');
            
            // Storing partnobase value in a field for override purpose
            conBGR.Part_Number_Base_Original__c=BGROU.BRANDCODE + BGROU.PNMODEL + BGROU.PNSIZE+ conBGR.Body_Material_dynamic__c + '00' + conBGR.Soft_Goods_Material_dynamic__c + '0' + conBGR.Connection_dynamic__c;
            System.debug(' Part_Number_Base_Original__c-----' + conBGR.Part_Number_Base_Original__c);
            conBGR.ASSYPARTNOBASE__c = BGROU.BRANDCODE + BGROU.PNMODEL + BGROU.PNSIZE+ conBGR.Body_Material_dynamic__c + '00' + conBGR.Soft_Goods_Material_dynamic__c + '0' + conBGR.Connection_dynamic__c;
            conBGR.Part_Number_Base__c = conBGR.ASSYPARTNOBASE__c;
            
            if(conBGR.Quote_Description_Engineer_Override__c == true)
            {
                conBGR.ASSYPARTEXISTING__c = '';
            }
            else
            {
                Result partNumberResult = AssyPartDefinationProcessor.getPartNumberExisting(conBGR.Part_Number_Base__c,conBGR,'BGR');
                if(partNumberResult.bResult ==  true)
                {
                    conBGR.ASSYPARTEXISTING__c = partNumberResult.strRetValue;
                    
                }
                else
                {
                    conBGR.ASSYPARTEXISTING__c = '';
                }
            }
            // conBGR.Document_Or_Sourcing_flag__c=false;
            // To calculate schedule for BGR lead time
            //try {
            
            List<BGR_Lead_time_schedule__c> LeadSchedule = new List<BGR_Lead_time_schedule__c>();
            LeadSchedule = [select Schedule__c from BGR_Lead_time_schedule__c
                            where XRAY__c=:conBGR.Radiography__c
                            and PMI__c =:conBGR.Positive_Material_Identification__c
                            and SHLTSTMETHACT__c=:conBGR.Shell_test__c
                            and ASSYLOCATION__c =:conBGR.Final_Assembly_Location_Requirements__c
                            and MATLSOURCE__c =:conBGR.Material_Sourcing_Requirements__c
                            limit 1];
            if(! LeadSchedule.isEmpty())
            {
                conBGR.Schedule__c=LeadSchedule.get(0).Schedule__c;
            }
            
            List<BGR_Base_Schedule__c> LeadBaseSchedule = new List<BGR_Base_Schedule__c>();
            LeadBaseSchedule = [select Schedule__c from BGR_Base_Schedule__c
                                where Model__c=:conBGR.Model__c
                                and SizeCode__c =:conBGR.Size__c
                                and SoftGoodsMatlCode__c=:conBGR.Soft_Goods_Material_dynamic__c
                                and ConnectionPNCode__c =:conBGR.Connection_dynamic__c
                                limit 1];
            if(! LeadBaseSchedule.isEmpty())
            {
                conBGR.Schedule_2__c=LeadBaseSchedule.get(0).Schedule__c;
                BGROU.currentBGR = conBGR;
            }
            BGROU.currentBGR = conBGR;
            BGROU.mapBGRAttr=new Map<String, string>(); 
            BGROU.mapBGR_Attribute = new Map<String, String>();
            BGROU.mapBGR_Attribute = BGROU.getMapAttribute();
            GetLeadTimeRecs();
            getPricinglist();
            //getStructure(); 
            GetQuoteDescriptionRec();
            //Calling method to generate partnumber and store in ASSYPARTNO__c field(Purpose to display ASSYPARTNO in Routing)
            generatePartNumber();
            system.debug(conBGR);
            update conBGR;
            List<Cost__c> cstList = new List<Cost__c>();
            cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(conBGR.Id)];
            if(!cstList.isEmpty() && cstList.size() >0 )
            {
                delete cstList;
            }
            getCosts();
            /*}
catch(Exception dmle) {
ApexPages.addMessages(dmle);
system.debug(dmle);
return null;
}*/
        }
        selectedTab = 'ProductReview';
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            system.debug('---> Portal User ');
            String url = '/apex/ConfigBGR?qid='+qliId;
            String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
            strURL =  encoded ;
        }else{
            system.debug('---> Internal User');
            strURL = '/apex/ConfigBGR?qid='+qliId;
        }
        GetLeadTimeRecs();
        if(conBGR.Price_Engineer_Override__c == false)
        {
            ApplyDefaultPricing();
        }
        if(conBGR.Lead_Time_Engineer_Override__c == false)
        {
            ApplyDefaultLeadtime();
        }
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            		string strProdOver='';
                    if(String.isNotBlank(conBGR.OA__c)){
                        strProdOver += conBGR.OA__c +'\n';
                    }
                    if(String.isNotBlank(conBGR.OB__c)){
                        strProdOver += conBGR.OB__c+'\n';
                    }
                    if(String.isNotBlank(conBGR.OW__c)){
                        strProdOver += conBGR.OW__c;
                    }
                    string strquoteDes1 = strProdOver;
                    strquoteDes1.replaceAll('\n', '</BR>');
            
                SYSTEM.DEBUG('@DEVELOPER > ### :' + quoteLine );
            
            quoteLine.Non_Discountable_List_Price__c = conBGR.Non_Discountable_Price__c/conBGR.Quantity__c;
            quoteLine.Discountable_List_Price__c = conBGR.Discountable_Price__c;
            quoteLine.Leadtime_Site_10__c = conBGR.Lead_Time_Site_10__c;
            quoteLine.Leadtime_Site_20__c = conBGR.Lead_Time_Site_20__c;
            quoteLine.Leadtime_Site_30__c = conBGR.Lead_Time_Site_30__c;
            quoteLine.Leadtime_Site_40__c = conBGR.Lead_Time_Site_40__c;
            quoteLine.Config_Record_Id__c = conBGR.id;
            quoteLine.SBQQ__Quantity__c=conBGR.Quantity__c;
            quoteLine.Body_Material__c=conBGR.Body_Material__c;
          //  quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('</BR>', '\n');
            quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('&','&amp').replaceAll('>','&gt').replaceAll('<','&lt').replaceAll('\n', '<BR>');
            upsert quoteLine;
        }
        addQliSyncFlag(qli);
        system.debug(conBGR); 
        update conBGR;
        return null;
    }

    
    public string strquoteDes {
        get {
            
            BGR_Outputs__c bgroutput = getBGROutputRecord(conBGR.Id);
            String strProdOver = '';
            if(String.isNotBlank(bgroutput.OA_Override__c)){
                strProdOver += bgroutput.OA_Override__c +'<BR/><BR/>';
            }
            if(String.isNotBlank(bgroutput.OB_Override__c)){
                strProdOver += bgroutput.OB_Override__c+'<BR/><BR/>';
            }            
            if(String.isNotBlank(bgroutput.OW_Override__c)){
                strProdOver += bgroutput.OW_Override__c;
            }
            strquoteDes = strProdOver;
            return strquoteDes.replaceAll('\n', '<BR/>');
        }
        set {
            this.strquoteDes=value;
        }
    }
    
    //BGR PARTNumber "No longer in use"
    public string getPartNum() {
        // BGROutputUtility prtNum = new BGROutputUtility(conBGR.Id);
        String rstPartNumber='';
        // if(String.isNotBlank(BGROU.QuoteLine))
        // {
            BGR_Part_Number__c bgrNewRecord = new BGR_Part_Number__c();
            List<BGR_Part_Number__c> bgrPartNumberRecord = new List<BGR_Part_Number__c>();
            bgrPartNumberRecord = [Select id, PartNumber__c,Part_Number_Sequence__c from BGR_Part_Number__c where Quote_Line__c =:BGROU.QuoteLine];
            if(bgrPartNumberRecord.size() > 0)
            {
                bgrNewRecord = bgrPartNumberRecord[0];
                rstPartNumber = 'V'+BGROU.PTC+BGROU.SZC+'X'+BGROU.MCBODY+'00'+BGROU.MCDPHM+'0'+BGROU.HCLASS+bgrNewRecord.Part_Number_Sequence__c;
                bgrNewRecord.PartNumber__c = rstPartNumber;
                // conBGR.Part_Number__c = rstPartNumber;
            }
            bgrNewRecord.Quote_Line__c = BGROU.QuoteLine;
            bgrNewRecord.ASSYLOCATION__c = BGROU.ASSYLOCATION;
            bgrNewRecord.ATEX__c = BGROU.ATEX;
            bgrNewRecord.CSA__c = BGROU.CSA;
            bgrNewRecord.CUTR__c = BGROU.CUTR;
            //bgrNewRecord.GORIFC__c = GORIFC;
            bgrNewRecord.HCLASS__c = BGROU.HCLASS;
            bgrNewRecord.MATLSOURCE__c = BGROU.MATLSOURCE;
            bgrNewRecord.MCBODY__c = BGROU.MCBODY;
            bgrNewRecord.MCDPHM__c = BGROU.MCDPHM;
            //bgrNewRecord.PartRevision__c = ;
            bgrNewRecord.PMI__c = BGROU.PMI;
            bgrNewRecord.PTC__c = BGROU.PTC;
            //bgrNewRecord.RTPRS1__c = ;
            //bgrNewRecord.RTPRSU__c = ;
            //bgrNewRecord.SERVICE__c = ;
            bgrNewRecord.SHLTSTMETHACT__c = BGROU.SHLTSTMETHACT;
            bgrNewRecord.SHLTSTMETHBDY__c = BGROU.SHLTSTMETHBDY;
            bgrNewRecord.SZC__c = BGROU.SZC;
            bgrNewRecord.XRAY__c = BGROU.XRAY;
            if(bgrPartNumberRecord.size() > 0)
            {
                update bgrNewRecord;
            }
            else
            {
                insert bgrNewRecord;
                BGR_Part_Number__c bgrPartSequence = [SELECT id,Part_Number_Sequence__c from BGR_Part_Number__c where id =:bgrNewRecord.id];
                rstPartNumber = 'V'+BGROU.PTC+BGROU.SZC+'X'+BGROU.MCBODY+'00'+BGROU.MCDPHM+'0'+BGROU.HCLASS+bgrPartSequence.Part_Number_Sequence__c;
                bgrPartSequence.PartNumber__c = rstPartNumber;

                update bgrPartSequence;
            }
        //}
        return rstPartNumber;
    }
    /*This method is for the Save and continue button on Engineering Notes tab*/
    public PageReference saveNotes() {
        //conBGR.Product_material_options_flag__c=true;
        try {
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    /*Wrapper class used for BGMStructure */
    public class BGMStructureWrapper {
        public string ComponentPart {set;get;}
        public string SpringCode {set;get;}
        public string Qty {set;get;}
        public string ScrapFactor {set;get;}
        public string ComponentScrap {set;get;}
        public string LineItemNo {set;get;}
    }
    /*Wrapper class used for Bill of  Materials*/
    public class BOMWrapper
    {
        public string PartType{get;set;}
        public string Model{get;set;}
        public string Qty{get;set;}
        public string KitUp{get;set;}
        public string Phantom{get;set;}
    }
    //Method to get BGM Structure Mate
    public list<BGMStructureWrapper> getStructure() {
        list<BGMStructureWrapper> BGMStructureList = new list<BGMStructureWrapper>();
        result strcResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        strcResult=BGROU.getStructure();system.debug('$$$$$$$$$'+strcResult.bResult);
        if(strcResult.bResult)
        {
            for (sObject sobj:strcResult.objResultList)
            {
                BGMStructureWrapper bgWrap=new BGMStructureWrapper();
                bgWrap.LineItemNo = (string) sobj.get('Line_Item_No__c');
                bgWrap.ComponentPart= (String) sobj.get('Component_part__c');
                bgWrap.SpringCode =(String) sobj.get('SpringCode__c');
                bgWrap.Qty=(String) sobj.get('Qty_per_Assembly__c');
                bgWrap.ScrapFactor=(String) sobj.get('Scrap_Factor__c');
                bgWrap.ComponentScrap=(String) sobj.get('Component_Scrap__c');
                if(bgWrap.ComponentPart.startsWith('SPR'))
                {
                    conBGR.SPRINGCODE__c = bgWrap.SpringCode;
                    this.SPRINGCODE= conBGR.SPRINGCODE__c;
                    //BGROU.setScode(conBGR.SPRINGCODE__c);
                    BGROU.SPRINGCODE = conBGR.SPRINGCODE__c;
                }
                BGMStructureList.add(bgWrap);
            }
        }

        return BGMStructureList;
    }

    public decimal TotalBGRPrice{set;get;}
    public decimal TotalBGRPriceOverride{set;get;}
    public decimal NonDiscountablePriceEach{set;get;}
    public decimal ListPriceEach{set;get;}
    public decimal Total10{set;get;}
    public decimal Total20{set;get;}
    public decimal Total30{set;get;}
    public decimal Total40{set;get;}
    public decimal Total10Override{set;get;}
    public decimal Total20Override{set;get;}
    public decimal Total30Override{set;get;}
    public decimal Total40Override{set;get;}
    public string OBval1{set;get;}
    public string OBval2{set;get;}
    public string OWval1{set;get;}
    public string OWval2{set;get;}
    //public string AttributeDescription{set;get;}
   // public list<BGR_Price_Details__c > BGRPricingList{set;get;}
    public list<priceWrapper > BGRPriceWrapperList{set;get;}
    public list<BGR_lead_time__c> BGRLeadTimeList{set;get;}
    Public list<BGR_Attribute_table_lookup__c>  BGRQuoteDescList;
    Public List<QuoteDescriptionWrapper> quoteDescriptionList{set;get;}
    //BGR Pricing outputs
     public class priceWrapper
    {
        public BGR_Price_Details__c BGRPrice{get; set;}
        public Decimal BGRPriceOverride{get; set;}
        priceWrapper()
        {
            BGRPrice = new BGR_Price_Details__c();
            BGRPriceOverride = 0.00;
        }
    }
    public void getPricinglist()
    {
        BGRPriceWrapperList.clear();
        getPriceBGROutputInstance();
        TotalBGRPrice = 0.0;
        TotalBGRPriceOverride = 0.0;
        NonDiscountablePriceEach = 0.0;
        //BGRPricingList = new list<BGR_Price_Details__c >();
        result prncgResult=new result();
        // BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        prncgResult=BGROU.getPricing();
        if(prncgResult.bResult)
        {
            boolean has9999999 = false;
            boolean has8888888 = false;
            
            /***********************************************/
            //Method to find missing price elements
            List<String> uniqueListSZC=new List<String>();
            list<BGR_Price_Details__c> pricelementss=new list<BGR_Price_Details__c>();
            for(BGR_Price_Details__c eachFAMB : [SELECT Price__c,Pricing_Element__c FROM BGR_Price_Details__c 
                                                 order by Pricing_Element__c]){
                                                     if(!uniqueListSZC.contains(eachFAMB.Pricing_Element__c))
                                                     {    
                                                         pricelementss.add(eachFAMB);
                                                         uniqueListSZC.add(eachFAMB.Pricing_Element__c);
                                                     }
                                                 }
            /***************************/
            list<string> priceelements=new list<string>();
            BGR_Outputs__c bgrOutput = getBGROutputRecord(conBGR.Id);
            for (sObject sobj:prncgResult.objResultList)
            {
                BGR_Price_Details__c  BGRPricingRecord = new BGR_Price_Details__c ();
                BGRPricingRecord = (BGR_Price_Details__c )sobj;
                String fieldAPI;
                fieldAPI = BGRPricingRecord.Pricing_Element__c;
                if(BGRPricingRecord.Pricing_Element__c.contains(' '))
                {
                    fieldAPI = fieldAPI.replace(' ', '_');
                }
                
                fieldAPI = fieldAPI+'__c';
                Decimal priceOverride = 0.00;
                if(bgrOutput.get(fieldAPI) == null)
                {
                    bgrOutput.put(fieldAPI, BGRPricingRecord.Price__c);
                    priceOverride = BGRPricingRecord.Price__c;
                }
                else
                {
                    if(conBGR.Price_Engineer_Override__c) {
                    	
                        priceOverride = (Decimal)bgrOutput.get(fieldAPI);
                        
                    } else {
                        
                        bgrOutput.put(fieldAPI, BGRPricingRecord.Price__c);
                    	priceOverride = BGRPricingRecord.Price__c;
                    }
                }
                TotalBGRPrice += BGRPricingRecord.Price__c;
                if(priceOverride == 9999999)
                {
                    has9999999 = true;
                    TotalBGRPriceOverride = 9999999;
                }
                if(priceOverride == 8888888 && has9999999==false)
                {
                    has8888888 = true;
                    TotalBGRPriceOverride = 8888888;
                }
                if(has8888888 == false && has9999999==false )
                {
                    TotalBGRPriceOverride += priceOverride;
                }
                priceelements.add(BGRPricingRecord.Pricing_Element__c); 
                priceWrapper priceWrapperInstance = new priceWrapper();
                priceWrapperInstance.BGRPrice = BGRPricingRecord;
                priceWrapperInstance.BGRPriceOverride = priceOverride.setScale(2);
                BGRPriceWrapperList.add(priceWrapperInstance);                               
            }
            
              for (sObject sobj1:pricelementss)
                {
                    BGR_Price_Details__c  BGRPricingRecord2 = new BGR_Price_Details__c ();
                    BGRPricingRecord2 = (BGR_Price_Details__c )sobj1;      
                    string fieldAPI;
                    fieldAPI = BGRPricingRecord2.Pricing_Element__c;
                      if(!priceelements.contains(BGRPricingRecord2.Pricing_Element__c))
                        {                            
                                if(BGRPricingRecord2.Pricing_Element__c.contains(' '))
                            {
                                fieldAPI = fieldAPI.replace(' ', '_');
                            }
                       
                            fieldAPI = fieldAPI+'__c';
                            Decimal priceOverride;
                            if(bgrOutput.get(fieldAPI) == null)
                            {
                                //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                                bgrOutput.put(fieldAPI, 8888888.00);
                                priceOverride = 8888888.00;
                            }
                            else
                            {        
                                if(conBGR.Price_Engineer_Override__c) {
                                    priceOverride = (Decimal)bgrOutput.get(fieldAPI);  
                                } else {
                                    bgrOutput.put(fieldAPI, BGRPricingRecord2.Price__c);
                                    priceOverride = BGRPricingRecord2.Price__c;
                                }
                            }                         
                            if(has9999999==false && priceOverride==8888888)
                            {
                                has8888888 = true;
                                TotalBGRPriceOverride = 8888888.00;                          
                            }
                            if(has8888888 == false && has9999999==false )
                            {
                                TotalBGRPriceOverride += priceOverride;
                            }
                            
                            BGRPricingRecord2.Price__c=8888888.00;   
                            priceWrapper priceWrapperInstance = new priceWrapper();
                            priceWrapperInstance.BGRPrice = BGRPricingRecord2;
                            priceWrapperInstance.BGRPriceOverride =priceOverride.setScale(2);
                            BGRPriceWrapperList.add(priceWrapperInstance);
                        } 
                    
                }  
            system.debug('$$$$$$$$$$$$$$'+conBGR.Quantity__c);
            if(conBGR.Quantity__c != null && conBGR.Quantity__c != 0)
            {
                if(has9999999==false && has8888888==false)
                {
                    ListPriceEach=TotalBGRPriceOverride + ( NonDiscountablePriceEach / conBGR.Quantity__c);
                    conBGR.List_Price_Each__c = ListPriceEach;
                    conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                }      
                if(has9999999==true)
                {
                    ListPriceEach = TotalBGRPriceOverride;
                    conBGR.List_Price_Each__c=ListPriceEach;
                    conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                } 
                else if(has8888888==true)
                {
                    ListPriceEach = TotalBGRPriceOverride;
                    conBGR.List_Price_Each__c=ListPriceEach;
                    conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                }
                conBGR.List_Price_Each__c = ListPriceEach.setScale(2);
                conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                conBGR.Non_Discountable_Price__c = NonDiscountablePriceEach;
            }
        }
    }

    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultPricing()
    {
        boolean has9999999=false;
        boolean has8888888=false;
        BGR_Outputs__c bgrOutput = getBGROutputRecord(conBGR.Id);
        //conBGR.Price_Engineer_Override__c == false && 
        if(BGRPriceWrapperList != null && BGRPriceWrapperList.size() > 0)
        {
            TotalBGRPrice = 0.0;
            TotalBGRPriceOverride = 0.0;
            for(priceWrapper prv : BGRPriceWrapperList)
            {
                if(String.isNotBlank(prv.BGRPrice.Pricing_Element__c))
                {
                    String fieldAPI = prv.BGRPrice.Pricing_Element__c;
                    if(prv.BGRPrice.Pricing_Element__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    
                    fieldAPI = fieldAPI+'__c';
                    
                    bgrOutput.put(fieldAPI, prv.BGRPrice.Price__c);
                    if(prv.BGRPrice.Price__c != 9999999)
                    {
                        TotalBGRPrice += prv.BGRPrice.Price__c;
                        TotalBGRPriceOverride += prv.BGRPrice.Price__c;
                    }
                }
            }
            system.debug('$$$$$$$$$$$$$$'+conBGR.Quantity__c);
             if(conBGR.Quantity__c != null && conBGR.Quantity__c != 0)
                {
                    if(has9999999==false && has8888888==false){
                        	ListPriceEach=TotalBGRPriceOverride + ( NonDiscountablePriceEach / conBGR.Quantity__c);
                            conBGR.List_Price_Each__c = ListPriceEach;
                            conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                    	}      
                     if(has9999999==true)
                    {
                        ListPriceEach = TotalBGRPriceOverride;
                        conBGR.List_Price_Each__c=ListPriceEach;
                        conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                    } 
                    else if(has8888888==true){
                        ListPriceEach = TotalBGRPriceOverride;
                        conBGR.List_Price_Each__c=ListPriceEach;
                        conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                    }
                    conBGR.Non_Discountable_Price__c = NonDiscountablePriceEach;
                }
            upsert bgrOutput;
        }
        update conBGR;
        getPricinglist();
        return null; 
    }
    //* @ Save Price Override on click on save
    Public pageReference SavePriceOverride()
    {
        boolean has9999999=false;
        boolean has8888888=false;
        BGR_Outputs__c bgrOutput = getBGROutputRecord(conBGR.Id);
        if(BGRPriceWrapperList != null && BGRPriceWrapperList.size() > 0)
        {
            TotalBGRPriceOverride = 0.0;
            for(priceWrapper prv : BGRPriceWrapperList)
            {
                if(String.isNotBlank(prv.BGRPrice.Pricing_Element__c))
                {
                    String fieldAPI = prv.BGRPrice.Pricing_Element__c;
                    if(prv.BGRPrice.Pricing_Element__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    
                    fieldAPI = fieldAPI+'__c';
                    
                    bgrOutput.put(fieldAPI, prv.BGRPriceOverride);
                    if(prv.BGRPriceOverride != 9999999 && prv.BGRPriceOverride != 8888888)
                    {
                        TotalBGRPrice +=prv.BGRPriceOverride;
                        TotalBGRPriceOverride += prv.BGRPriceOverride;
                    }
                    if(prv.BGRPriceOverride == 9999999)
                    {
                        has9999999=true;
                        TotalBGRPriceOverride=9999999.00;
                    }                    
                    if(prv.BGRPriceOverride == 8888888 && has9999999==false){
                        has8888888=true;
                        TotalBGRPriceOverride=8888888.00;
                    }
                    
                    bgrOutput.Price_Total__c = TotalBGRPriceOverride;
                    
                }
            }
            if(conBGR.Quantity__c != null && conBGR.Quantity__c != 0)
            {
                if(has9999999==false && has8888888==false){
                    ListPriceEach=TotalBGRPriceOverride + ( NonDiscountablePriceEach / conBGR.Quantity__c);
                    conBGR.List_Price_Each__c = ListPriceEach;
                    conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                }      
                if(has9999999==true)
                {
                    ListPriceEach = 9999999.00;
                    TotalBGRPriceOverride=9999999.00;
                    conBGR.List_Price_Each__c=ListPriceEach;
                    conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                } 
                else if(has8888888==true)
                {
                    ListPriceEach = 8888888.00;
                    TotalBGRPriceOverride=8888888.00;
                    conBGR.List_Price_Each__c=ListPriceEach;
                    conBGR.Discountable_Price__c = TotalBGRPriceOverride;
                }
                conBGR.Non_Discountable_Price__c = NonDiscountablePriceEach;
            }
            if(!notValidStatusForChng.contains(strQuoteStatus)) 
            {
                quoteLine.Non_Discountable_List_Price__c =  conBGR.Non_Discountable_Price__c;
                quoteLine.Discountable_List_Price__c = conBGR.Discountable_Price__c;
                upsert quoteLine;
            }
            upsert bgrOutput;           
            update conBGR;
        }
        return null;
    }
    public static void addQliSyncFlag(SBQQ__QuoteLine__c quoteLine) {
        try {
           // quoteLine.Run_Config_Sync__c = true;
           // update quoteLine;
        } catch(Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getCause());
        }
    }
    public static BGR_Outputs__c getBGROutputRecord(String bgrId)
    {
        List<BGR_Outputs__c> bgrOutputList = new List<BGR_Outputs__c>();
        String fieldsAPIname = FLMutility.getObjectFields('BGR_Outputs__c');
        String soql = 'SELECT '+fieldsAPIname+' FROM BGR_Outputs__c where BGR_Outputs_Relation_Field__c =\''+String.escapeSingleQuotes(bgrId)+'\'';
        bgrOutputList = Database.query(soql);//[SELECT id from BGR_Outputs__c where BGR_Outputs_Relation_Field__c =:bgrId];
        if(bgrOutputList.size() > 0)
        {
            return bgrOutputList[0];
        }
        BGR_Outputs__c bgroutput = new BGR_Outputs__c();
        return bgroutput;
    }
    public BGR_Outputs__c getPriceBGROutputInstance()
    {
        BGR_Outputs__c bgrOutput = getBGROutputRecord(conBGR.Id);
        bgrOutput.AssyLocation__c = null;
        bgrOutput.ATEX__c = null;
        bgrOutput.Base__c = null;
        bgrOutput.Connection__c = null;
        bgrOutput.CSA__c = null;
        bgrOutput.CUTR__c = null;
        bgrOutput.MatlSource__c = null;
        bgrOutput.PMI__c = null;
        bgrOutput.ShellTest__c = null;
        bgrOutput.SoftGoods__c = null;
        bgrOutput.Price_Total__c = null;
        bgrOutput.XRAY__c = null;
        system.debug('BGR output'+bgrOutput);
        return bgrOutput;
    }
    public BGR_Outputs__c getLeadBGROutputInstance()
    {
        BGR_Outputs__c bgrOutput = getBGROutputRecord(conBGR.Id);
        bgrOutput.Adder_Lead_Time_10__c = '';
        bgrOutput.Adder_Lead_Time_20__c = '';
        bgrOutput.Adder_Lead_Time_30__c = '';
        bgrOutput.Adder_Lead_Time_40__c = '';
        bgrOutput.Base_Lead_Time_10__c = '';
        bgrOutput.Base_Lead_Time_20__c = '';
        bgrOutput.Base_Lead_Time_30__c = '';
        bgrOutput.Base_Lead_Time_40__c = '';
        return bgrOutput;
    }
    public BGR_Outputs__c getQuoteBGROutputInstance()
    {
        BGR_Outputs__c bgrOutput = getBGROutputRecord(conBGR.Id);
        /*bgrOutput.OA02__c = '';
        bgrOutput.OA04__c = '';
        bgrOutput.OB010__c = '';
        bgrOutput.OB050__c = '';
        bgrOutput.OB310__c = '';
        bgrOutput.OB320__c = '';
        bgrOutput.OB410__c = '';
        bgrOutput.OB420__c = '';
        bgrOutput.OW210__c = '';
        bgrOutput.OW220__c = '';
        bgrOutput.OW310__c = '';
        bgrOutput.OW610__c = '';
        bgrOutput.OW620__c = '';
        bgrOutput.OW630__c = '';
        bgrOutput.OW710__c = '';
        bgrOutput.OW720__c = '';
        bgrOutput.OW910__c = '';
        bgrOutput.OW920__c = '';*/
        return bgrOutput;
    }
    // ** New BGR Lead time method for OR condition

    public list<BGR_lead_time__c> GetLeadTimeRecs()
    {
        Total10 = 0.0;
        Total20 = 0.0;
        Total30 = 0.0;
        Total40 = 0.0;
        Total10Override = 0.0;
        Total20Override = 0.0;
        Total30Override = 0.0;
        Total40Override = 0.0;
        BGRLeadTimeList = new list<BGR_lead_time__c>();
        //BGROutputUtility BGRLTUtility = new BGROutputUtility(conBGR.Id);
        BGRLeadTimeList = BGROU.GetLeadTimeRec();
        system.debug('@@**Lead time list :'+BGRLeadTimeList); 
        Boolean stopL10Sum = false,stopL10OverrideSum = false,stopL20Sum = false,stopL20OverrideSum = false,stopL30Sum = false,stopL30OverrideSum = false,stopL40Sum = false,stopL40OverrideSum = false;
        for(BGR_lead_time__c bgl : BGRLeadTimeList)
        {
            System.debug('--> bgl.Site_10__c = '+bgl.Site_10__c);
            System.debug('--> bgl.Site_20__c = '+bgl.Site_20__c);
            System.debug('--> bgl.Site_30__c = '+bgl.Site_30__c);
            System.debug('--> bgl.Site_40__c = '+bgl.Site_40__c);
            //LT 10
            if(bgl.Site_10__c != null && (false == stopL10Sum || bgl.Site_10__c == 7777))
            {
                if(bgl.Site_10__c == 7777)
                {
                    Total10 = 7777;
                    stopL10Sum = true;
                }
                else if(bgl.Site_10__c == 4995)
                {
                    Total10 = 4995;
                    stopL10Sum = true;
                }
                else
                {
                    Total10 += bgl.Site_10__c;
                }
            }
            if(bgl.Lead_Time_10_Override__c != null && (false == stopL10OverrideSum || bgl.Lead_Time_10_Override__c == 7777))
            {
                if(bgl.Lead_Time_10_Override__c == 7777)
                {
                    Total10Override = 7777;
                    stopL10OverrideSum = true;
                }
                else if(bgl.Lead_Time_10_Override__c == 4995)
                {
                    Total10Override = 4995;
                    stopL10OverrideSum = true;
                }
                else
                {
                    Total10Override += bgl.Lead_Time_10_Override__c;
                }
            }
            System.debug('--> bgl.Site_20__c = '+bgl.Site_20__c);
            System.debug('--> stopL20Sum = '+stopL20Sum);
            System.debug('--> (false == stopL20Sum || bgl.Site_20__c == 7777) = '+(false == stopL20Sum || bgl.Site_20__c == 7777));
                
            System.debug('--> 20 condition = '+(bgl.Site_20__c != null && (false == stopL20Sum || bgl.Site_20__c == 7777)));
            
            //LT 20
            if(bgl.Site_20__c != null && (false == stopL20Sum || bgl.Site_20__c == 7777))
            {
                if(bgl.Site_20__c == 7777)
                {
                    Total20 = 7777;
                    stopL20Sum = true;
                }
                else if(bgl.Site_20__c == 4995)
                {
                    Total20 = 4995;
                    stopL20Sum = true;
                }
                else
                {
                    Total20 += bgl.Site_20__c;
                }
            }
            System.debug('--> 20 override condition = '+(bgl.Lead_Time_20_Override__c != null && (false == stopL20OverrideSum || bgl.Lead_Time_20_Override__c == 7777)));
            
            if(bgl.Lead_Time_20_Override__c != null && (false == stopL20OverrideSum || bgl.Lead_Time_20_Override__c == 7777))
            {
                if(bgl.Lead_Time_20_Override__c == 7777)
                {
                    Total20Override = 7777;
                    stopL20OverrideSum = true;
                }
                else if(bgl.Lead_Time_20_Override__c == 4995)
                {
                    Total20Override = 4995;
                    stopL20OverrideSum = true;
                }
                else
                {
                    Total20Override += bgl.Lead_Time_20_Override__c;
                }
            }
            
            //LT 30
            if(bgl.Site_30__c != null && (false == stopL30Sum || bgl.Site_30__c == 7777))
            {
                if(bgl.Site_30__c == 7777)
                {
                    Total30 = 7777;
                    stopL30Sum = true;
                }
                else if(bgl.Site_30__c == 4995)
                {
                    Total30 = 4995;
                    stopL30Sum = true;
                }
                else
                {
                    Total30 += bgl.Site_30__c;
                }
            }
            if(bgl.Lead_Time_30_Override__c != null && (false == stopL30OverrideSum || bgl.Lead_Time_30_Override__c == 7777))
            {
                if(bgl.Lead_Time_30_Override__c == 7777)
                {
                    Total30Override = 7777;
                    stopL30OverrideSum = true;
                }
                else if(bgl.Lead_Time_30_Override__c == 4995)
                {
                    Total30Override = 4995;
                    stopL30OverrideSum = true;
                }
                else
                {
                    Total30Override += bgl.Lead_Time_30_Override__c;
                }
            }
            
            //LT 40
            if(bgl.Site_40__c != null && (false == stopL40Sum || bgl.Site_40__c == 7777))
            {
                if(bgl.Site_40__c == 7777)
                {
                    Total40 = 7777;
                    stopL40Sum = true;
                }
                else if(bgl.Site_40__c == 4995)
                {
                    Total40 = 4995;
                    stopL40Sum = true;
                }
                else
                {
                    Total40 += bgl.Site_40__c;
                }
            }
            if(bgl.Lead_Time_40_Override__c != null && (false == stopL40OverrideSum || bgl.Lead_Time_40_Override__c == 7777))
            {
                if(bgl.Lead_Time_40_Override__c == 7777)
                {
                    Total40Override = 7777;
                    stopL40OverrideSum = true;
                }
                else if(bgl.Lead_Time_40_Override__c == 4995)
                {
                    Total40Override = 4995;
                    stopL40OverrideSum = true;
                }
                else
                {
                    Total40Override += bgl.Lead_Time_40_Override__c;
                }
            }
            System.debug('---> Total10 = '+Total10+', Total10Override = '+Total10Override);
        System.debug('---> Total20 = '+Total20+', Total20Override = '+Total20Override);
        System.debug('---> Total30 = '+Total30+', Total30Override = '+Total30Override);
        System.debug('---> Total40 = '+Total40+', Total40Override = '+Total40Override);
        }
        
        /*
        Decimal conbgrLead10Total = 0.00, conbgrLead20Total = 0.00, conbgrLead30Total = 0.00, conbgrLead40Total = 0.00;
        Boolean hasLead10Override = false, hasLead20Override = false, hasLead30Override = false, hasLead40Override = false;
        for(BGR_lead_time__c bgl : BGRLeadTimeList)
        {
            if(bgl.Lead_Time_10_Override__c == null)
            {
                bgl.Lead_Time_10_Override__c = bgl.Site_10__c;
            }
            if(false == hasLead10Override || bgl.Lead_Time_10_Override__c == 7777)
            {
                if(bgl.Lead_Time_10_Override__c == 4995)
                {
                    Total10Override = 4995;
                    hasLead10Override = true;
                }
                if(bgl.Lead_Time_10_Override__c == 7777)
                {
                    Total10Override = 7777;
                    hasLead10Override = true;
                }
                if(false == hasLead10Override)
                {
                    Total10Override += bgl.Lead_Time_10_Override__c;
                }
            }
            /*if(false == hasLead10Override && bgl.Lead_Time_10_Override__c != 4995)
            {
                if(bgl.Lead_Time_10_Override__c == 7777)
                {
                    conbgrLead10Total = 7777;
                }
                if(bgl.Lead_Time_10_Override__c != 7777)
                {
                    conbgrLead10Total += bgl.Lead_Time_10_Override__c;
                }
                else
                {
                    hasLead10Override = true;
                    conbgrLead10Total = bgl.Lead_Time_10_Override__c;
                }
            }
            if(bgl.Lead_Time_20_Override__c == null)
            {
                bgl.Lead_Time_20_Override__c = bgl.Site_20__c;
            }
            if(false == hasLead20Override && bgl.Lead_Time_20_Override__c != 4995)
            {
                if(bgl.Lead_Time_20_Override__c == 7777)
                {
                    conbgrLead20Total = 7777;
                }
                if(bgl.Lead_Time_20_Override__c != 7777)
                {
                    conbgrLead20Total += bgl.Lead_Time_20_Override__c;
                }
                else
                {
                    hasLead20Override = true;
                    conbgrLead20Total = bgl.Lead_Time_20_Override__c;
                }
            }
            if(bgl.Lead_Time_30_Override__c == null)
            {
                bgl.Lead_Time_30_Override__c = bgl.Site_30__c;
            }
            if(false == hasLead30Override && bgl.Lead_Time_30_Override__c != 4995)
            {
                if(bgl.Lead_Time_30_Override__c == 7777)
                {
                    conbgrLead30Total = 7777;
                }
                if(bgl.Lead_Time_30_Override__c != 7777)
                {
                    conbgrLead30Total += bgl.Lead_Time_30_Override__c;
                }
                else
                {
                    hasLead30Override = true;
                    conbgrLead30Total = bgl.Lead_Time_30_Override__c;
                }
            }
            if(bgl.Lead_Time_40_Override__c == null)
            {
                bgl.Lead_Time_40_Override__c = bgl.Site_40__c;
            }
            if(false == hasLead40Override && bgl.Lead_Time_40_Override__c != 4995)
            {
                if(bgl.Lead_Time_40_Override__c == 7777)
                {
                    conbgrLead40Total = 7777;
                }
                if(bgl.Lead_Time_40_Override__c != 7777)
                {
                    conbgrLead40Total += bgl.Lead_Time_40_Override__c;
                }
                else
                {
                    hasLead40Override = true;
                    conbgrLead40Total = bgl.Lead_Time_40_Override__c;
                }
            }
            if(bgl.Site_10__c == 7777)
            {
                Total10 = 7777;
            }
            if(bgl.Lead_Time_10_Override__c == 7777)
            {
                Total10Override = 7777;
            }
            if(bgl.Site_10__c == 4995)
            {
                Total10 = 4995;
            }
            if(bgl.Lead_Time_10_Override__c == 4995)
            {
                Total10Override = 4995;
            }
            if(bgl.Site_10__c != 7777 && bgl.Site_10__c != 4995 )
            {
                Total10 += bgl.Site_10__c;
            }
            if(bgl.Lead_Time_10_Override__c != 7777 && bgl.Lead_Time_10_Override__c != 4995 )
            {
                Total10Override += bgl.Lead_Time_10_Override__c;
            }
            if(bgl.Site_20__c == 7777)
            {
                Total20 = 7777;
            }
            if(bgl.Lead_Time_20_Override__c == 7777)
            {
                Total20Override = 7777;
            }
            if(bgl.Site_20__c == 4995)
            {
                Total20 = 4995;
            }
            if(bgl.Lead_Time_20_Override__c == 4995)
            {
                Total20Override = 4995;
            }
            if(bgl.Site_20__c != 7777 && bgl.Site_20__c != 4995 )
            {
                Total20 += bgl.Site_20__c;
            }
            if(bgl.Lead_Time_20_Override__c != 7777 && bgl.Lead_Time_20_Override__c != 4995 )
            {
                Total20Override += bgl.Lead_Time_20_Override__c;
            }
            if(bgl.Site_30__c == 7777)
            {
                Total30 = 7777;
            }
            if(bgl.Lead_Time_30_Override__c == 7777)
            {
                Total30Override = 7777;
            }
            if(bgl.Site_30__c == 4995)
            {
                Total30 = 4995;
            }
            if(bgl.Lead_Time_30_Override__c == 4995)
            {
                Total30Override = 4995;
            }
            if(bgl.Site_30__c != 7777 && bgl.Site_30__c != 4995 )
            {
                Total30 += bgl.Site_30__c;
            }
            if(bgl.Lead_Time_30_Override__c != 7777 && bgl.Lead_Time_30_Override__c != 4995 )
            {
                Total30Override += bgl.Lead_Time_30_Override__c;
            }
            if(bgl.Site_40__c == 7777)
            {
                Total40 = 7777;
            }
            if(bgl.Lead_Time_40_Override__c == 7777)
            {
                Total40Override = 7777;
            }
            if(bgl.Site_40__c == 4995)
            {
                Total40 = 4995;
            }
            if(bgl.Lead_Time_40_Override__c == 4995)
            {
                Total40Override = 4995;
            }
            if(bgl.Site_40__c != 7777 && bgl.Site_40__c != 4995 )
            {
                Total40 += bgl.Site_40__c;
            }
            if(bgl.Lead_Time_40_Override__c != 7777 && bgl.Lead_Time_40_Override__c != 4995 )
            {
                Total40Override += bgl.Lead_Time_40_Override__c;
            }
            System.debug('#***** inside loop Total10Override = '+Total10Override+', Total20Override = '+Total20Override+',Total30Overridec = '+Total30Override+',Total40Override = '+Total40Override);
        }
		*/
        System.debug('#***** outside loop Total10Override = '+Total10Override+', Total20Override = '+Total20Override+',Total30Overridec = '+Total30Override+',Total40Override = '+Total40Override);
        conBGR.Lead_Time_Site_10__c = Total10;
        conBGR.Lead_Time_Site_20__c = Total20;
        conBGR.Lead_Time_Site_30__c = Total30;
        conBGR.Lead_Time_Site_40__c = Total40;
        System.debug('#***** conBGR.Lead_Time_Site_10__c = '+conBGR.Lead_Time_Site_10__c+', conBGR.Lead_Time_Site_20__c = '+conBGR.Lead_Time_Site_20__c+',conBGR.Lead_Time_Site_30__c = '+conBGR.Lead_Time_Site_30__c+',conBGR.Lead_Time_Site_40__c = '+conBGR.Lead_Time_Site_40__c);
        //update conBGR;
        return BGRLeadTimeList;
    }


    //* @ Apply Default Override for Lead time
    public pageReference ApplyDefaultLeadtime()
    {
        if(conBGR.Lead_Time_Engineer_Override__c == false && BGRLeadTimeList != null && BGRLeadTimeList.size() > 0)
        {
            for(BGR_lead_time__c bgl : BGRLeadTimeList)
            {
                bgl.Lead_Time_10_Override__c = bgl.Site_10__c;
                bgl.Lead_Time_20_Override__c = bgl.Site_20__c;
                bgl.Lead_Time_30_Override__c = bgl.Site_30__c;
                bgl.Lead_Time_40_Override__c = bgl.Site_40__c;
            }
            update BGRLeadTimeList;
            update conBGR;
        }
        return null;
    }
    //* @ Save Lead time Override on click on save
    Public pageReference SaveLeadTimeOverride()
    {
        system.debug(BGRLeadTimeList+'---nag--');
        if(BGRLeadTimeList != null && BGRLeadTimeList.size() > 0)
        {
            BGR_Outputs__c bgrOutsideInstance = getLeadBGROutputInstance();
            for(BGR_lead_time__c bgl: BGRLeadTimeList)
            {
                // if(bgl.Schedule__c == 'BGRB')
                //{
                bgrOutsideInstance.Base_Lead_Time_10__c = bgl.Lead_Time_10_Override__c+'';
                bgrOutsideInstance.Base_Lead_Time_20__c = bgl.Lead_Time_20_Override__c+'';
                bgrOutsideInstance.Base_Lead_Time_30__c = bgl.Lead_Time_30_Override__c+'';
                bgrOutsideInstance.Base_Lead_Time_40__c = bgl.Lead_Time_40_Override__c+'';
                //}
                //else if(bgl.Schedule__c == 'BGREST')
                //{
                bgrOutsideInstance.Adder_Lead_Time_10__c = bgl.Lead_Time_10_Override__c+'';
                bgrOutsideInstance.Adder_Lead_Time_20__c = bgl.Lead_Time_20_Override__c+'';
                bgrOutsideInstance.Adder_Lead_Time_30__c = bgl.Lead_Time_30_Override__c+'';
                bgrOutsideInstance.Adder_Lead_Time_40__c = bgl.Lead_Time_40_Override__c+'';
                //}
            }
            update bgrOutsideInstance;
            update BGRLeadTimeList;
            System.debug('***** conBGR.Lead_Time_Site_10__c = '+conBGR.Lead_Time_Site_10__c+', conBGR.Lead_Time_Site_20__c = '+conBGR.Lead_Time_Site_20__c+',conBGR.Lead_Time_Site_30__c = '+conBGR.Lead_Time_Site_30__c+',conBGR.Lead_Time_Site_40__c = '+conBGR.Lead_Time_Site_40__c);

            addQliSyncFlag(qli);
            GetLeadTimeRecs();
            update conBGR;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                // quoteLine.Non_Discountable_List_Price__c =  conBGR.Discountable_Price__c;
                // quoteLine.Discountable_List_Price__c = conBGR.Non_Discountable_Price__c;
                quoteLine.Leadtime_Site_10__c = conBGR.Lead_Time_Site_10__c;
                quoteLine.Leadtime_Site_20__c = conBGR.Lead_Time_Site_20__c;
                quoteLine.Leadtime_Site_30__c = conBGR.Lead_Time_Site_30__c;
                quoteLine.Leadtime_Site_40__c = conBGR.Lead_Time_Site_40__c;
                // quoteLine.Config_Record_Id__c = conBGR.id;
                // quoteLine.SBQQ__Quantity__c=conBGR.Quantity__c;
                upsert quoteLine;
            }
        }
        return null;
    }
    //******************************************************
    //BGR Lead time outputs
    /*  public list<BGRLeadTimeWrapper> getLeadTime()
{
list<BGRLeadTimeWrapper> BGRLeadTimeList = new list<BGRLeadTimeWrapper>();
result LDTResult=new result();
BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
LDTResult=myStrcDetail.getLeadTime();
if(LDTResult.bResult)
{
for (sObject sobj:LDTResult.objResultList)
{
BGRLeadTimeWrapper bgLdt=new BGRLeadTimeWrapper();
bgLdt.CDC= String.valueOf(sobj.get('CDC__c'));
conBGR.Working_days_CDC__c = integer.valueOf(bgLdt.CDC);
bgLdt.GCI= String.valueOf(sobj.get('GCI__c'));
conBGR.Working_days_GCI__c = integer.valueOf(bgLdt.GCI);
bgLdt.GP=  String.valueOf(sobj.get('GP__c'));
conBGR.Working_days_GP__c = integer.valueOf(bgLdt.GP);
BGRLeadTimeList.add(bgLdt);
}
}
return BGRLeadTimeList;
}

public class BGRLeadTimeWrapper
{
public string CDC {set;get;}
public string GCI{set;get;}
public string GP{set;get;}
} */
    public class QuoteDescriptionWrapper
    {
        public String quotes {get;set;}
        public String description {get;set;}
        public List<String> descriptionList {get;set;}
        public List<String> overridedescriptionList {get;set;}
        public String overrideDescription {get;set;}
    }
    //** Method for Quote Description
    public Map<String, String> quoteAttriVsDesc;
    public BGR_Outputs__c bgrOutsideInstance;
    public list<QuoteDescriptionWrapper> GetQuoteDescriptionRec()
    {
        //AttributeDescription = ' ';
        quoteAttriVsDesc = new Map<String, String>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        boolean hasOA01inList = false, hasOA250inList = false;
        string OB250p1,OB250p2;
        quoteAttriVsDesc = BGROU.GetAttributeMapQuoteDescription();
        bgrOutsideInstance = getQuoteBGROutputInstance();
        //PTC & "-" & HCLASS & "-" & MCBODY & "-" & MCDPHM & "-" & GORIFC & "-" SPRINGCODE & "-" & OPTIONCODE

        //string convertedsettingval=(conBGR.Converted_Setting__c).stripTrailingZeros().toPlainString();
       // System.debug('convertedsettingval'+convertedsettingval);
		
        system.debug('conBGR.Service_Type__c:'+conBGR.Service_Type__c);
        system.debug('conBGR.Setting__c:'+conBGR.Setting__c);
        system.debug('conBGR.Setting_Units__c:'+conBGR.Setting_Units__c);
        
        conBGR.OA01__c = 'Model: '+conBGR.Model__c+'-'+BGROU.HCLASS+'-'+BGROU.MCBODY+'-'+BGROU.MCDPHM+'-'+conBGR.Orifice_value__c+'-'+BGROU.SPRINGCODE+'-'+BGROU.OPTIONCODE;
        OB250p1 = conBGR.Service_Type__c == 'Pressure' ? 'Pressure Setting: ' +(conBGR.Setting__c).stripTrailingZeros().toPlainString() +' '+ conBGR.Setting_Units__c : 'Vacuum Setting: '+(conBGR.Setting__c).stripTrailingZeros().toPlainString() +' '+ conBGR.Setting_Units__c;
        OB250p2 = conBGR.Setting_Units__c == BGROU.RGEUNT ? ' ' : '('+ BGROU.GPRSC1 + ' '+ BGROU.RGEUNT +')';

        conBGR.OB250__c = OB250p1+' '+OB250p2;
        for(String attribute: quoteAttriVsDesc.keySet())
        {
            String attributeFieldAPI = attribute+'__c';
            conBGR.put(attributeFieldAPI,quoteAttriVsDesc.get(attribute));
            System.debug('@@@@ attributeFieldAPI = '+attributeFieldAPI+', conbgr value = '+conBGR.get(attributeFieldAPI));
        }
        quoteAttriVsDesc.put('OB250', conBGR.OB250__c);
        conBGR.OA__c = conBGR.OA01__c;
        conBGR.OB__c = '';
        conBGR.OW__c = '';
        List<String> attributeList = new List<String>();
        if(quoteAttriVsDesc.size() > 0)
        {
            attributeList.addAll(quoteAttriVsDesc.keySet());
            attributeList.sort();
        }
        for(String attribute: attributeList)
        {
            //if(attribute != 'OB050')
            //{
                String attributeValue = conBGR.get(attribute+'__c')+'';
                System.debug('@@@@ attribute = '+attribute+'__c, value = '+attributeValue);
                if(attribute.startsWith('OA') && String.isNotBlank(attributeValue))
                {
                    conBGR.OA__c += '\n' + attributeValue;
                }
                else if(attribute.startsWith('OB') && String.isNotBlank(attributeValue))
                {
                    conBGR.OB__c += '\n' + attributeValue;
                }
                else if(attribute.startsWith('OW') && String.isNotBlank(attributeValue))
                {
                    if(String.isBlank(conBGR.OW__c))
                    {
                        conBGR.OW__c = attributeValue;
                    }
                    else
                    {
                        conBGR.OW__c += '\n' + attributeValue;
                    }
                }
            //}
        }
        //System.debug('@@@ Model = '+conBGR.Model__c+', setBlankForNull(conBGR.OA01__c) = '+setBlankForNull(conBGR.OA01__c)+', setBlankForNull(conBGR.OA02__c) = '+setBlankForNull(conBGR.OA02__c)+', setBlankForNull(conBGR.OA04__c) = '+setBlankForNull(conBGR.OA04__c));
        //conBGR.OA__c = setBlankForNull(conBGR.OA01__c)+'\n'+ setBlankForNull(conBGR.OA02__c) + '\n ' + setBlankForNull(conBGR.OA04__c); //Merging all the OA
        //conBGR.OB__c = setBlankForNull(conBGR.OB010__c)+'test '+setBlankForNull(conBGR.OB050__c)+'\n'+setBlankForNull(OB250p1+'')+setBlankForNull(conBGR.Setting__c+'')+'\n '+setBlankForNull(conBGR.Setting_Units__c)+'('+setBlankForNull(OB250p2)+')'+' \n'+setBlankForNull(conBGR.OB310__c)+' '+setBlankForNull(conBGR.OB320__c)+'\n '+setBlankForNull(conBGR.OB410__c)+' \n'+setBlankForNull(conBGR.OB420__c); //Merging all the OB

        //conBGR.OW__c = setBlankForNull(conBGR.OW210__c) + ' ' + setBlankForNull(conBGR.OW310__c) + ' ' + setBlankForNull(conBGR.OW410__c) + ' ' + setBlankForNull(conBGR.OW620__c) + ' ' + setBlankForNull(conBGR.OW630__c) + ' ' + setBlankForNull(conBGR.OW710__c) + ' ' + setBlankForNull(conBGR.OW720__c) + ' ' + setBlankForNull(conBGR.OW910__c) + ' ' + setBlankForNull(conBGR.OW920__c);
        OBval1 = conBGR.OA__c+' '+conBGR.OB__c+' '+conBGR.OW__c;

        Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW'};
        for(String quoteAttribute: quotesAttributeSet)
        {
            String fieldAPI = quoteAttribute+'__c';
            String quoteRow = (String)conBGR.get(fieldAPI);
            System.debug('@@@@ fieldAPI = '+fieldAPI+', quoteRow = '+quoteRow);
            if(String.isNotBlank(quoteRow))
            {
                QuoteDescriptionWrapper quoteDescription = new QuoteDescriptionWrapper();
                quoteDescription.quotes = quoteAttribute;
                quoteDescription.descriptionList = new List<String>();
                quoteDescription.overridedescriptionList = new List<String>();
                String descriptionValue = conBGR.get(fieldAPI)+'';
                for(String dec : descriptionValue.split('\n'))
                {
                    quoteDescription.descriptionList.add(dec);
                }
                quoteDescription.description = conBGR.get(fieldAPI)+'';
                System.debug('@@@@ bgrOutsideInstance = '+bgrOutsideInstance.get(quoteAttribute+'_Override__c'));
                if(bgrOutsideInstance.get(quoteAttribute+'_Override__c') == null)
                {
                    quoteDescription.overrideDescription = conBGR.get(fieldAPI)+'';
                }
                else
                {
                    quoteDescription.overrideDescription = (String)bgrOutsideInstance.get(quoteAttribute+'_Override__c');
                }
                if(conBGR.Quote_Description_Engineer_Override__c == true && quoteAttribute == 'OA')
                {
                    quoteDescription.overrideDescription = quoteDescription.overrideDescription;
                }
                for(String dec : quoteDescription.overrideDescription.split('\n'))
                {
                    quoteDescription.overridedescriptionList.add(dec);
                }
                quoteDescriptionList.add(quoteDescription);
            }
        }
        system.debug('***Quote Desc'+BGRQuoteDescList);
        return quoteDescriptionList;
    }

    public String setBlankForNull(String strValue)
    {
        if(String.isBlank(strValue))
        {
            strValue = '';
        }
        return strValue;
    }
    //* @ Apply Default Override for Quote Description
    public pageReference ApplyDefaultQuoteDescription()
    {
        if(bgrOutsideInstance == null && Test.isRunningTest()) {
            bgrOutsideInstance = [SELECT Id FROM BGR_Outputs__c];
        }
        
        if(conBGR.Quote_Description_Engineer_Override__c == false)
        {
            Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW'};
            for(String quoteAttribute: quotesAttributeSet)
            {
                String attributeFieldAPI = quoteAttribute+'_Override__c';
                String attributeValue = (String)conBGR.get(quoteAttribute+'__c');
                bgrOutsideInstance.put(attributeFieldAPI, attributeValue);
            }
            update bgrOutsideInstance;
            if(!Test.isRunningTest()) 
            {
                if(!notValidStatusForChng.contains(strQuoteStatus)) 
                {
                    quoteLine.SBQQ__Description__c=strquoteDes;
                    upsert quoteLine;
                }
            }
            conBGR.ASSYPARTNOBASE__c=conBGR.Part_Number_Base_Original__c;
            System.debug(' ASSYPARTNOBASE__c--------------' + conBGR.ASSYPARTNOBASE__c);
            System.debug(' Part_Number_Base_Original__c--------------' + conBGR.Part_Number_Base_Original__c);
        }
        else
        {
            conBGR.ASSYPARTEXISTING__c = '';
        }
        update conBGR;
        disableButton = (!showsales) && conBGR.Quote_Description_Engineer_Override__c ;
        /*List<SBQQ__QuoteLine__c> quoteId = [select SBQQ__Quote__c from SBQQ__QuoteLine__c where Id = :conBGR.Quote_Line__c];
        List<SBQQ__Quote__Share> quoteSharelst = new List<SBQQ__Quote__Share>();
   for(SBQQ__Quote__Share quoteShare : [select id,ParentId, AccessLevel,RowCause,UserOrGroup.name,UserOrGroup.Profile.name from SBQQ__Quote__Share
                                              where UserOrGroup.Profile.Name in ('CDC Inside Sales','CDC Prod. Planning','CDC Partner Community Users Profile')
											  and RowCause<>'Owner' and ParentId = :quoteId.get(0).SBQQ__Quote__c]){

       if(!conBGR.Quote_Description_Engineer_Override__c)  {
               quoteShare.AccessLevel = 'Edit';
               quoteSharelst.add(quoteShare);

       }else{
           quoteShare.AccessLevel = 'Read';
           quoteSharelst.add(quoteShare);
       }
       }*/
         pageReference reloadpage2 = new pageReference('/apex/ConfigBGR?qid='+qliId+'&selectedTab=Quote');
         //pageReference reloadpage3 = Page.ConfigWGBProduct;
         //reloadpage2.getParameters().put('id',+quotelineId);
        reloadpage2.setRedirect(true);
		return reloadpage2;
        //return null;
    }


    //* @ Save Quote Description Override on click on save
    Public pageReference SaveQuoteDescriptionOverride()
    {
        if(bgrOutsideInstance == null && Test.isRunningTest()) {
            bgrOutsideInstance = [SELECT Id FROM BGR_Outputs__c];
        }
        if(quoteDescriptionList != null && quoteDescriptionList.size() > 0)
        {
            for(QuoteDescriptionWrapper bgqd : quoteDescriptionList)
            {
                String attributeFieldAPI = bgqd.quotes+'_Override__c';
                bgrOutsideInstance.put(attributeFieldAPI, bgqd.overrideDescription);
            }
            if(String.isNotBlank(bgrOutsideInstance.Id))
            {
                update bgrOutsideInstance;
            }
            update bgrOutsideInstance;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        }
        return null;
    }

    public void generatePartNumber()
    {
        if(BGROU.CONSTACTTST == 'PneuAutoHydNotAvail')
        {
            conBGR.Shell_test__c = 'AIR';
        }
        else if(BGROU.CONSTACTTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_test__c = 'HYDRO';
        }
        if(BGROU.CONSTBDYTST=='PneuAutoHydNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'AIR';
        }
        else if(BGROU.CONSTBDYTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'HYDRO';
        }
        update conBGR;
        //conBGR.Part_Number_Base__c = conBGR.ASSYPARTNOBASE__c;
        Result partNumberResult = AssyPartDefinationProcessor.generatePartNumber(conBGR);
        conBGR.Part_Number_Base__c = conBGR.ASSYPARTNOBASE__c;
        if(partNumberResult.bResult ==  true)
        {
            if(string.isNotBlank(conBGR.ASSYPARTEXISTING__c))
            {
                conBGR.Part_Number__c = conBGR.ASSYPARTEXISTING__c; 
            }
            else
            {
                conBGR.Part_Number__c = partNumberResult.strRetValue;
            }
        }

        update conBGR;
    }

    public void saveConbgr()
    {
        if(BGROU.CONSTACTTST == 'PneuAutoHydNotAvail')
        {
            conBGR.Shell_test__c = 'AIR';
        }
        else if(BGROU.CONSTACTTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_test__c = 'HYDRO';
        }
        if(BGROU.CONSTBDYTST=='PneuAutoHydNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'AIR';
        }
        else if(BGROU.CONSTBDYTST=='HydAutoPneuNotAvail')
        {
            conBGR.Shell_Test_Valve_Body__c = 'HYDRO';
        }
        if(conBGR.Quote_Description_Engineer_Override__c == true)
        {
            conBGR.ASSYPARTEXISTING__c = '';
            conBGR.Part_Number__c = '';
        }
        update conBGR;
    }


    //******************************************************
    //BGR Product Document ouput
    public list<BGRProductDocWrapper> getProDoc()
    {
        list<BGRProductDocWrapper> BGRProductDocList = new list<BGRProductDocWrapper>();
        result PDResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        PDResult=BGROU.getProDoc();
        if(PDResult.bResult)
        {
            for (sObject sobj:PDResult.objResultList)
            {
                BGRProductDocWrapper bgLPD=new BGRProductDocWrapper();
                bgLPD.Document= (String) sobj.get('Document__c');
                bgLPD.DocumentID= (String) sobj.get('Document_ID__c');
                BGRProductDocList.add(bgLPD);
            }
        }
        return BGRProductDocList;

    }

    public class BGRProductDocWrapper
    {
        public string Document {set;get;}
        public string DocumentID {set;get;}
    }
    //******************************************************
    //BGR Work Guilde lines output
    public list<BGRWorkGuidelinesWrapper> getGuildeline()
    {
        list<BGRWorkGuidelinesWrapper> BGRWorkGuidelineList = new list<BGRWorkGuidelinesWrapper>();
        result WGResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        WGResult=BGROU.getGuildeline();
        if(WGResult.bResult)
        {
            for (sObject sobj:WGResult.objResultList)
            {
                BGRWorkGuidelinesWrapper bgWD=new BGRWorkGuidelinesWrapper();
                bgWD.Operation= (String) sobj.get('Operation__c');
                bgWD.Description= (String) sobj.get('Description__c');
                String textValue = (String) sobj.get('Text__c');
                if(String.isNotBlank(textValue))
                {
                    for(String splittedText: textValue.split('\n'))
                    {
                        bgWD.Text.add(splittedText);
                    }
                }
                
                //bgWD.Text= (String) sobj.get('Text__c');
                bgWD.Type= (String) sobj.get('Type__c');
                bgWD.SignOff= (String) sobj.get('Sign_Off__c');
                bgWD.InspectionSignOffRequired= (String) sobj.get('Inspection_Sign_Off_Required__c');
                BGRWorkGuidelineList.add(bgWD);
            }
        }
        return BGRWorkGuidelineList;
    }

    public class BGRWorkGuidelinesWrapper
    {
        public string Operation {set;get;}
        public string Description {set;get;}
        public List<string> Text {set;get;}
        public string Type {set;get;}
        public string SignOff {set;get;}
        public string InspectionSignOffRequired {set;get;}
        public BGRWorkGuidelinesWrapper()
        {
            Text = new List<String>();
        }
    }

    //******************************************************
    //BGR Routing output
    public list<BGRRoutingWrapper> GetRoutingDetails()
    {
        list<BGRRoutingWrapper> BGRRoutingList = new list<BGRRoutingWrapper>();
        result RResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        RResult=BGROU.getRouting();
        string ASSYPARTNO = '';
        map<integer,BGRRoutingWrapper> OperationVSBGRRouting = new map<integer,BGRRoutingWrapper>();
        if(RResult.bResult)
        {
            for (sObject sobj:RResult.objResultList)
            {
                BGRRoutingWrapper bgRR=new BGRRoutingWrapper();
                bgRR.Operation= (String) sobj.get('Operation_Number__c');
                bgRR.StandardOperationID= (String) sobj.get('Standard_Operation_Id__c');
                    string ControlVal=(string) sobj.get('Outside_Operation_Item__c');
                    if(ControlVal!=null){
                         if(ControlVal.contains('[') && ControlVal.contains(']'))
                    {
                        string  Test_Oper_Desc_val='';
                        ASSYPARTNO = (string) sobj.get('Outside_Operation_Item__c');
                        if(ASSYPARTNO!=null)
                        {
                            ASSYPARTNO = ASSYPARTNO.substringBetween('[',']');
                        }
                        if(string.isBlank(ASSYPARTNO) || ASSYPARTNO == null)
                        {
                            bgRR.OutsideOperationIdD = (String) sobj.get('Outside_Operation_Item__c');
                        }
                        else
                        {
                            Test_Oper_Desc_val = conBGR.Part_Number__c;
                        }

                        String[] arrPTC  =new String[5];
                        arrPTC=ControlVal.split('\\[');
                        String strPTC1  = arrPTC[0];
                        String strPTC2  = arrPTC[1];
                        String str2SplitOB170 =strPTC2;
                        String[] arrPTC2  = new String[5];
                        arrPTC2=str2SplitOB170.split('\\]');
                        String strPTC4  = arrPTC2[1];
                        string attributeValue=strPTC1+Test_Oper_Desc_val+strPTC4;
                        bgRR.OutsideOperationIdD=attributeValue;
                   }
                    else
                        bgRR.OutsideOperationIdD = (string) sobj.get('Outside_Operation_Item__c');
                    }
                    else
                        bgRR.OutsideOperationIdD = (string) sobj.get('Outside_Operation_Item__c');
                bgRR.Descr= (String) sobj.get('Descr__c');
                //routingOpp.add((String) sobj.get('Operation_Number__c'));
                //BGRRoutingList.add(bgRR);
                if(!Test.isRunningTest()) 
                {
                    OperationVSBGRRouting.put(decimal.valueOf(bgRR.Operation).intValue(),bgRR);
                }
            }
        }
        if(OperationVSBGRRouting.size() > 0)
        {
            list<integer> OperationSort = new list<integer>(OperationVSBGRRouting.keyset());
            OperationSort.sort();
            for(integer opp : OperationSort)
            {
                BGRRoutingList.add(OperationVSBGRRouting.get(opp));
            }
        }
        return BGRRoutingList;
    }

    public class BGRRoutingWrapper
    {
        public string Operation {set;get;}
        public string StandardOperationID {set;get;}
        public string OutsideOperationIdD {set;get;}
        public string Descr {set;get;}
    }

    //BGR Control plan output
    public list<BGRControlPlanWrapper> GetControlPlanDetails()
    {
        list<BGRControlPlanWrapper> BGRControlPlanList = new list<BGRControlPlanWrapper>();
        result CPResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        CPResult=BGROU.GetControlPlanDetails();
        string OuterMinValue = '';
        string InnerMinValue = '';
        string NominalValue = '';
        string InnerMaxValue = '';
        string OuterMaxValue = '';
        if(CPResult.bResult)
        {
            for (sObject sobj:CPResult.objResultList)
            {
                BGRControlPlanWrapper bgRCP=new BGRControlPlanWrapper();
                bgRCP.Test_OPNO= (String) sobj.get('Cus_Test_OPNO__c');
                bgRCP.TEST_OPERATION_DESC= (String) sobj.get('Test_Operation_Desc__c');
                bgRCP.NORM_TYPE= (String) sobj.get('Norm_Type__c');
                bgRCP.OperationNumber= (String) sobj.get('Cus_Operation_Number__c');
                bgRCP.DATA_TYPE= (String) sobj.get('Data_Type__c');
                bgRCP.CATEGORY_ID= (String) sobj.get('Category_ID__c');
                bgRCP.INSPECTION_CODE= (String) sobj.get('Inspection_Code__c');
                bgRCP.ProcessCharacteristic= (String) sobj.get('Process_Characteristic__c');
                bgRCP.SpecialCharacteristicClassification= (String) sobj.get('Special_Characteristic_Classification__c');
                OuterMinValue = (String) sobj.get('Outer_Min__c');
                if(OuterMinValue!=null)
                {
                    OuterMinValue = OuterMinValue.substringBetween('[',']');
                }
                if(string.isBlank(OuterMinValue) || OuterMinValue == null)
                {
                    bgRCP.OUTER_MIN = (String) sobj.get('Outer_Min__c');
                }
                else
                {
                    bgRCP.OUTER_MIN = BGROU.mapBGRAttr.get(OuterMinValue);
                }
                InnerMinValue = (String) sobj.get('Inner_Min__c');
                if(InnerMinValue!=null)
                {
                    InnerMinValue = InnerMinValue.substringBetween('[',']');
                }
                if(string.isBlank(InnerMinValue) || InnerMinValue == null)
                {
                    bgRCP.INNER_MIN = (String) sobj.get('Inner_Min__c');
                }
                else
                {
                    bgRCP.INNER_MIN= BGROU.mapBGRAttr.get(InnerMinValue);
                }
                NominalValue = (String) sobj.get('Nominal_Value__c');
                if(NominalValue!=null)
                {
                    NominalValue = NominalValue.substringBetween('[',']');
                }
                if(string.isBlank(NominalValue) || NominalValue == null)
                {
                    bgRCP.NOMINALVALUE = (String) sobj.get('Nominal_Value__c');
                }
                else
                {
                    bgRCP.NOMINALVALUE = BGROU.mapBGRAttr.get(NominalValue);
                }
                InnerMaxValue = (String) sobj.get('Inner_Max__c');
                if(InnerMaxValue!=null)
                {
                    InnerMaxValue = InnerMaxValue.substringBetween('[',']');
                }
                if(string.isBlank(InnerMaxValue) || InnerMaxValue == null)
                {
                    bgRCP.INNER_MAX = (String) sobj.get('Inner_Max__c');
                }
                else
                {
                    bgRCP.INNER_MAX = BGROU.mapBGRAttr.get(InnerMaxValue);
                }
                OuterMaxValue = (String) sobj.get('Outer_Max__c');
                if(OuterMaxValue!=null)
                {
                    OuterMaxValue = OuterMaxValue.substringBetween('[',']');
                }
                if(string.isBlank(OuterMaxValue) || OuterMaxValue == null)
                {
                    bgRCP.OUTER_MAX = (String) sobj.get('Outer_Max__c');
                }
                else
                {
                    bgRCP.OUTER_MAX = BGROU.mapBGRAttr.get(OuterMaxValue);
                }
                system.debug('OuterMin: '+OuterMinValue+ 'Inner Min: ' +InnerMinValue+ 'Outer Max: ' +OuterMaxValue);
                bgRCP.ToolID = (String) sobj.get('Tool_ID__c');
                bgRCP.DataPoint = (String) sobj.get('Data_Point__c');
                bgRCP.ConnectedtoTrigger = (String) sobj.get('Connected_To_Trigger__c');
                bgRCP.ConnectedToTools = (String) sobj.get('Connected_To_Tools__c');
                bgRCP.RecieptNotAllowed = (String) sobj.get('Reciept_Not_Allowed__c');
                bgRCP.Mandatory = (String) sobj.get('Mandatory__c');
                bgRCP.SimplifiedRevisionHandling = (String) sobj.get('Simplified_Revision_Handling__c');
                BGRControlPlanList.add(bgRCP);
            }
        }
        return BGRControlPlanList;
    }

    public class BGRControlPlanWrapper
    {
        public string Test_OPNO {set;get;}
        public string TEST_OPERATION_DESC {set;get;}
        public string NORM_TYPE {set;get;}
        public string OperationNumber {set;get;}
        public string DATA_TYPE {set;get;}
        public string CATEGORY_ID {set;get;}
        public string INSPECTION_CODE {set;get;}
        public string ProcessCharacteristic {set;get;}
        public string OUTER_MIN {set;get;}
        public string INNER_MIN {set;get;}
        public string NOMINALVALUE {set;get;}
        public string INNER_MAX {set;get;}
        public string OUTER_MAX {set;get;}
        public string ToolID {set;get;}
        public string DataPoint {set;get;}
        public string ConnectedtoTrigger {set;get;}
        public string ConnectedToTools {set;get;}
        public string RecieptNotAllowed {set;get;}
        public string Mandatory {set;get;}
        public string SimplifiedRevisionHandling {set;get;}
        public string SpecialCharacteristicClassification {set;get;}
    }

    /*To populate Quote description*/
    // public PageReference QuoteDesc() {
    //     try{
    //         list<BGR__c> qBGR = new list<BGR__c>();

    //         update conBGR;
    //     }
    //     catch (Exception dmle)
    //     {
    //         ApexPages.addMessages(dmle);
    //         return null;
    //     }
    //     return null;
    // }

    /*Used for Routing table*/
    /*   public list<BGR_RTG__c> getRouting()
{
list<BGR_RTG__c> RoutList = new list<BGR_RTG__c>();
RoutList = [select Operation__c,WORKCELL__c,QUEUE__c,SETUP__c,PIECESPERHOUR__c,WORKCENTER__c,DESCR__c from BGR_RTG__c
where MODEL__c =:conBGR.Model__c];
return RoutList;
} */

    /* This method is to convert the Picklist to Radio buttons for Atex */
    public List<SelectOption> getTypes1(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Atex__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for GOST CU Tr 010 2011 */
    public List<SelectOption> getTypes2(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('GOST_CU_Tr_010_2011__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for CSA Markings */
    public List<SelectOption> getTypes3(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('CSA_Markings__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for Service Type */
    public List<SelectOption> getTypes4(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Service_Type__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for Section G Radiography */
    public List<SelectOption> getTypes5(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Radiography__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for Section G Positive Material Identification */
    public List<SelectOption> getTypes6(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Positive_Material_Identification__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for Section G Shell Test */
    public List<SelectOption> getTypes7(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Shell_test__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /* This method is to convert the Picklist to Radio buttons for Section G Shell Test */
    public List<SelectOption> getTypes8(){
        Schema.sObjectType sobject_type = BGR__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Shell_Test_Valve_Body__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }
    /*This method is to get the values based on the Supply gas on the Section B*/
    public PageReference SupplyGas() {
        // conBGR.Section_B_flag__c=true;
        try {
            List<BGR_Media_Properties__c> mD = new List<BGR_Media_Properties__c>();
            mD = [select Media__c,MediaPhase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from BGR_Media_Properties__c
                  where Media__c=:conBGR.Supply_Gas__c
                  limit 1];
            if(! mD.isEmpty())
            {
                conBGR.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
                conBGR.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
                conBGR.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
                conBGR.Customer_Specified_Media__c=mD.get(0).Media__c;
            }
            update conBGR;
        }
        catch(Exception dmle) {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    public List<SelectOption> getBodyMaterial() {
        List<selectOption> options = new List<selectOption>();
        //options.add(new selectOption('',''));
        List<BGR_Matlist__c> BodyMaterial = new List<BGR_Matlist__c>();
        Set<string> BodyMaterialSet = new Set<string>();
        String BaseQuery = 'Select SZC__c,Component__c,MatlCode__c,Description__c from BGR_Matlist__c ';
        String WhereClause ='';
        String Comp = 'Body Material';
        if(conBGR.Size__c!=null) {
            WhereClause = 'where SZC__c =\''+conBGR.Size__c+'\' and Component__c=\''+Comp+'\'';
            //WhereClause = WhereClause +' '+ 'and'+' '+'Component__c=\''+Comp+'\'';
        }
        BodyMaterial=Database.query(BaseQuery+WhereClause) ;
        for (BGR_Matlist__c dg :BodyMaterial) {
            if(BodyMaterialSet.add(dg.Description__c))
            {
                options.add(new selectOption(dg.MatlCode__c,dg.Description__c));
            }
        }
        return options;
    }
    public List<SelectOption> getSoftGoodsMaterial() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        List<BGR_Matlist__c> BodyMaterial = new List<BGR_Matlist__c>();
        Set<string> BodyMaterialSet = new Set<string>();
        String BaseQuery = 'Select SZC__c,Component__c,MatlCode__c,Description__c from BGR_Matlist__c ';
        String WhereClause ='';
        String Comp = 'Soft Goods Material';
        if(conBGR.Size__c!=null) {
            BaseQuery = BaseQuery+'where SZC__c =\''+conBGR.Size__c+'\' and Component__c=\''+Comp+'\'' ;
            //WhereClause = WhereClause +' '+ 'and'+' '+'Component__c=\''+Comp+'\'';

        }
        System.debug('TSEERERG'+BaseQuery);
        //system.debug('***Where clauise'+WhereClause);
        BodyMaterial=Database.query(BaseQuery) ;
        system.debug('***Dynamic query'+BodyMaterial);
        for (BGR_Matlist__c dg :BodyMaterial) {
            if(BodyMaterialSet.add(dg.Description__c))
            {
                options.add(new selectOption(dg.MatlCode__c,dg.Description__c));
            }
        }
        return options;
    }
    public List<SelectOption> getConnection() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        List<BGR_Connections__c> Connection = new List<BGR_Connections__c>();
        Set<string> ConnectionSet = new Set<string>();
        String BaseQuery = 'Select SZC__c,ConnectionCode__c,ConnectionDesc__c from BGR_Connections__c ';
        String WhereClause ='';
        //String Comp = 'Soft Goods Material';
        if(conBGR.Size__c!=null)
            WhereClause = 'where  SZC__c =\''+conBGR.Size__c+'\'';
        //WhereClause = WhereClause +' '+ 'and'+' '+'Component__c=\''+Comp+'\'';
        system.debug('***Where clauise'+WhereClause);
        Connection=Database.query(BaseQuery+WhereClause) ;
        system.debug('***Dynamic query'+Connection);
        for (BGR_Connections__c dg :Connection) {
            if(ConnectionSet.add(dg.ConnectionDesc__c))
            {
                options.add(new selectOption(dg.ConnectionCode__c,dg.ConnectionDesc__c));
            }
        }
        return options;
    }
    public void costOnload()
    {
        getCosts();
    }
    public List<SelectOption> OrificeSettings{get;set;}
    public List<Cost__c> assembleCost{get;set;}
    public List<Cost__c> buildCost{get;set;}
    public List<Cost__c> overridenCost{get;set;}
    public List<Cost__c> hiddenCost{get;set;}
    public void getCosts()
    {
        assembleCost = new List<Cost__c>();
        buildCost = new List<Cost__c>();
        overridenCost = new List<Cost__c>();
        WizardCostProcessor wcp = new WizardCostProcessor(conBGR.Id);
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

        /*for(Cost__c cost:[select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c,Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c from Cost__c where Ref_Id__c=:String.valueOf(conBGR.Id) and Product__c='BGR'])
        {
            if(cost.Inside_Cost_Override_10__c != null)
            {
                cost.Inside_Cost_Override_10__c = cost.Inside_Cost_10__c;
            }
            if(cost.Outside_Cost_Override_10__c != null)
            {
                cost.Outside_Cost_Override_10__c = cost.Outside_Cost_10__c;
            }
            if(cost.Inside_Cost_Override_20__c != null)
            {
                cost.Inside_Cost_Override_20__c = cost.Inside_Cost_20__c;
            }
            if(cost.Outside_Cost_Override_20__c != null)
            {
                cost.Outside_Cost_Override_20__c = cost.Outside_Cost_20__c;
            }
            if(cost.Inside_Cost_Override_30__c != null)
            {
                cost.Inside_Cost_Override_30__c = cost.Inside_Cost_30__c;
            }
            if(cost.Outside_Cost_Override_30__c != null)
            {
                cost.Outside_Cost_Override_30__c = cost.Outside_Cost_30__c;
            }
            if(cost.Cost_Method__c == 'Assembly')
            {
                assembleCost.add(cost);
            }
            else if(cost.Cost_Method__c == 'Build Up')
            {
                buildCost.add(cost);
            }
        }*/
        //return assembleCost;
    }
   /* public List<Cost__c> getOverridenCost()
    {
        List<Cost__c> cstList=new List<Cost__c>();
        cstList = [select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c,Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c from Cost__c where Ref_Id__c=:String.valueOf(conBGR.Id) and Product__c='BGR' and Cost_Method__c='Overriden'];
        if(assembleCost.size() > 1)
        {
            return assembleCost;
        }
        if(cstList.size() > 0)
        {
            return cstList;
        }
        return cstList;
    }*/
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
        update conBGR;
        addQliSyncFlag(qli);
        getCosts();
        return null;
    }
    /*public List<Cost__c> getassembleCost()
    {
        List<Cost__c> cstList=new List<Cost__c>();
        cstList=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(conBGR.Id) and Product__c='BGR' and Cost_Method__c='Assembly'];

        return cstList;
    }
    public List<Cost__c> getbuildCost() {
        List<Cost__c> cstList=new List<Cost__c>();
        cstList=[select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c,Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c from Cost__c where Ref_Id__c=:String.valueOf(conBGR.Id) and Product__c='BGR' and Cost_Method__c='Build Up'];
        return cstList;
    }
    */
    public pageReference ApplyDefaultCost()
    {
        if(conBGR.Build_Cost_Override__c == false)
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
            update conBGR;
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

       //Trouble Shooting Attributes
    public Map<String, String> TroubleShootingAttr;
    public Map<String, String> Attr;
    Public List<TroubleShooting> TroubleShootingAttrList{get;set;}
    public class TroubleShooting
    {
       // public String recordId{get;set;}
        public String quotes {get;set;}
        public String description {get;set;}
      //  public String overrideDescription {get;set;}
    }

    public list<TroubleShooting> getTroubleShootingAttributes()
    {
        Attr = new Map<String, String>();
        TroubleShootingAttrList = new List<TroubleShooting>();
        Attr = BGROU.getTroubleShootingBGRAttr();

        for(String attribute: Attr.keySet())
        {
            TroubleShooting quoteDesc = new TroubleShooting();


               // quoteDesc.recordId = 'HasId';
                quoteDesc.quotes = attribute;
                if(String.isBlank(quoteDesc.description))
                {
                    quoteDesc.description = Attr.get(attribute);
                }

            TroubleShootingAttrList.add(quoteDesc);
        }
        return TroubleShootingAttrList;
    }

     public String ASYTYP{
        get {
                return BGROU.ASYTYP;
            }
        set {
                this.ASYTYP= ASYTYP;
            }
      }

      public String GMODEL{
        get {
            System.debug('*** Class BGROU.GMODEL = '+BGROU.GMODEL);
                return BGROU.GMODEL;
            }
        set {
                this.GMODEL= GMODEL;
            System.debug('*** Class set GMODEL = '+BGROU.GMODEL);
            }
      }

      public String GTAGPN {
        get {
                return BGROU.GTAGPN ;
            }
        set {
                this.GTAGPN = GTAGPN ;
            }
      }
      public String IINO {
        get {
                return BGROU.IINO ;
            }
        set {
                this.IINO = IINO ;
            }
      }
      public String PC{
        get {
                return BGROU.PC;
            }
        set {
                this.PC= PC;
            }
      }

      public String PTC {
        get {
                return BGROU.PTC ;
            }
        set {
                this.PTC = PTC ;
            }
      }

      public String RGEUNT   {
        get {
                return BGROU.RGEUNT   ;
            }
        set {
                this.RGEUNT   = RGEUNT   ;
            }
      }

    public String GPRSC1{
    get {
            decimal val=BGROU.GPRSC1;
            string strval=val.stripTrailingZeros().toPlainString();
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.GPRSC1= value;
        }
    }

      public String RTPRS1{
    get {
            decimal val=conBGR.Setting__c;
            string strval=val.stripTrailingZeros().toPlainString();
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.RTPRS1= value;
        }
    }
    public String SETINWC{
    get {
        	//Added null check before invoking the methods on the received input/value - Ashim
        	string strval = '';
        	decimal val;
            if(conBGR.Converted_Setting__c != null) {
                val =conBGR.Converted_Setting__c;
                strval = val.stripTrailingZeros().toPlainString();
            }
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.SETINWC= value;
        }
    }

    public String SETTINGMAX{
    get {
            decimal val=BGROU.SETTINGMAX;
            string strval=val.stripTrailingZeros().toPlainString();
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.SETTINGMAX= value;
        }
    }

    public String SETTINGMIN{
    get {
            decimal val=BGROU.SETTINGMIN;
            string strval=val.stripTrailingZeros().toPlainString();
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.SETTINGMIN= value;
        }
    }

      public String SHLTSTACTPSIG      {
        get {
                return BGROU.SHLTSTACTPSIG      ;
            }
        set {
                this.SHLTSTACTPSIG      = SHLTSTACTPSIG      ;
            }
      }
      public String SHLTSTACTPSIGMX      {
        get {
                return BGROU.SHLTSTACTPSIGMX      ;
            }
        set {
                this.SHLTSTACTPSIGMX      = SHLTSTACTPSIGMX      ;
            }
      }
      public String SHLTSTBDYPSIG      {
        get {
                return BGROU.SHLTSTBDYPSIG      ;
            }
        set {
                this.SHLTSTBDYPSIG      = SHLTSTBDYPSIG      ;
            }
      }
      public String SHLTSTBDYPSIGMX      {
        get {
                return BGROU.SHLTSTBDYPSIGMX      ;
            }
        set {
                this.SHLTSTBDYPSIGMX      = SHLTSTBDYPSIGMX      ;
            }
      }

    public String SHUTOFFMIN{
    get {
            decimal val=BGROU.SHUTOFFMIN;
            string strval=val.stripTrailingZeros().toPlainString();
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.SHUTOFFMIN= value;
        }
    }

public String SHUTOFFMAX{
    get {
            decimal val=BGROU.SHUTOFFMAX;
            string strval=val.stripTrailingZeros().toPlainString();
            return strval;   //.stripTrailingZeros().toPlainString();
        }
    set {
            this.SHUTOFFMAX= value;
        }
    }

      public String SPRINGCODE{
        get {
                return conBGR.SPRINGCODE__c;
            }
        set {
                this.SPRINGCODE= SPRINGCODE;
            }
      }

      public String TAGMAXACTPRES{
        get {
                return BGROU.TAGMAXACTPRES;
            }
        set {
                this.TAGMAXACTPRES= TAGMAXACTPRES;
            }
      }
       public String TAGMAXSUPPRES {
        get {
                return BGROU.TAGMAXSUPPRES ;
            }
        set {
                this.TAGMAXSUPPRES = TAGMAXSUPPRES ;
            }
      }
       public String TAGSPRGRANGE{
        get {
                return BGROU.TAGSPRGRANGE;
            }
        set {
                this.TAGSPRGRANGE= TAGSPRGRANGE;
            }
      }

      public String ASSEMBLYWT{
        get {
                return BGROU.ASSEMBLYWT;
            }
        set {
                this.ASSEMBLYWT= ASSEMBLYWT;
            }
      }
       public String ASSEMBLYWTUOM{
        get {
                return BGROU.ASSEMBLYWTUOM;
            }
        set {
                this.ASSEMBLYWTUOM= ASSEMBLYWTUOM;
            }
      }
      public String ATMPRESPSIA{
        get {
                return BGROU.ATMPRESPSIA;
            }
        set {
                this.ATMPRESPSIA= ATMPRESPSIA;
            }
      }
      public String ATTRTEMPLATE{
        get {
                return BGROU.ATTRTEMPLATE;
            }
        set {
                this.ATTRTEMPLATE= ATTRTEMPLATE;
            }
      }

      public String BRANDCODE {
        get {
                return BGROU.BRANDCODE ;
            }
        set {
                this.BRANDCODE = BRANDCODE ;
            }
      }
      public String COMPDESCRIPTION{
        get {
                return BGROU.COMPDESCRIPTION;
            }
        set {
                this.COMPDESCRIPTION= COMPDESCRIPTION;
            }
      }
      public String COMPINVSERTRK{
        get {
                return BGROU.COMPINVSERTRK;
            }
        set {
                this.COMPINVSERTRK= COMPINVSERTRK;
            }
      }
      public String SUPRS1{
        get {
                return BGROU.SUPRS1;
            }
        set {
                this.SUPRS1= SUPRS1;
            }
      }
      public String SUPRSU{
        get {
                return BGROU.SUPRSU;
            }
        set {
                this.SUPRSU= SUPRSU;
            }
      }
	
    public String PRDLIN{
        get {
                return BGROU.PRDLIN;
            }
        set {
                this.PRDLIN= PRDLIN;
            }
      }

    /* This method is used to covert the Orifice settings to the combo list



    public List<SelectOption> OrificeSettings{get;set;}
    public List<BGRCostWrapper> assemblyWrapper{get;set;}
    public List<BGRCostWrapper> bulidWrapper{get;set;}
    public class BGRCostWrapper {
        public Cost__c costItem{set;get;}
        public String costMethod{set;get;}
        public String costSubType{set;get;}
        public String costPartNum{set;get;}
        public decimal costInsite10{set;get;}
        public decimal costOutsite10{set;get;}
        public decimal costInsite20{set;get;}
        public decimal costOutsite20{set;get;}
        public decimal costInsite30{set;get;}
        public decimal costOutsite30{set;get;}

        public BGRCostWrapper(Cost__c c) {
            if(c.Inside_Cost_10__c!=null)
                this.costInsite10=decimal.valueOf(c.Inside_Cost_10__c);
            if(c.Outside_Cost_10__c!=null)
                this.costOutsite10=decimal.valueOf(c.Outside_Cost_10__c);
            if(c.Inside_Cost_20__c!=null)
                this.costInsite20=decimal.valueOf(c.Inside_Cost_20__c);
            if(c.Outside_Cost_20__c!=null)
                this.costOutsite20=decimal.valueOf(c.Outside_Cost_20__c);
            if(c.Inside_Cost_30__c!=null)
                this.costInsite30=decimal.valueOf(c.Inside_Cost_30__c);
            if(c.Outside_Cost_30__c!=null)
                this.costOutsite30=decimal.valueOf(c.Outside_Cost_30__c);
            this.costMethod=c.Cost_Method__c;
            this.costSubType=c.Cost_Sub_Type__c;
            this.costPartNum=c.Part_Number__c;
        }
    }
    /*This method is get the cost details
    public List<BGR_Cost_Routing_Inside__c> routingInCost{get;set;}
    public List<BGR_Cost_Routing_Outside__c> routingOutCost{get;set;}
    public List<String> routingOpp {get;set;}
    public List<String> strucPartList {get;set;}
    public BGR_Cost_Part_Number__c getAssemblyCost {get;set;}
    public BGR_Cost_Part_Number__c getBuiltCost {get;set;}
    //
    public list<BGR_Cost_Routing_Outside__c> getRoutingOutCost() {
        list<BGR_Cost_Routing_Outside__c> lstroutingout=new list<BGR_Cost_Routing_Outside__c>();
        string query='Select Outside_Cost__c,site__c,StdOpName__c from BGR_Cost_Routing_Outside__c  ';
        result RResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        RResult=BGROU.getRouting();
        routingOpp=new List<String>();
        if(RResult.bResult) {
            for (sObject sobj:RResult.objResultList)
            {
                routingOpp.add('\''+(String) sobj.get('Standard_Operation_Id__c')+'\'');
            }
        }
        if (conBGR.Size__c!=null && routingOpp.size()>0) {
            String s = String.join(routingOpp,',');
            query=query+'where  StdOpName__c IN ('+s+') and PTC__c=\''+BGROU.PTC+'\' and SZC__c=\''+BGROU.SZC+'\'';
        }
        System.debug('Routing Query OUt'+query);
        lstroutingout=Database.query(query) ;
        System.debug('REcords Cost'+lstroutingout) ;
        return lstroutingout;
    }
    public list<BGR_Cost_Routing_Inside__c> getRoutingInCost() {
        list<BGR_Cost_Routing_Inside__c> lstroutingIn=new list<BGR_Cost_Routing_Inside__c>();
        string query='Select Inside_Cost__c,site__c,StdOpName__c from BGR_Cost_Routing_Inside__c  ';
        result RResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        routingOpp=new List<String>();
        RResult=BGROU.getRouting();
        if(RResult.bResult) {
            for (sObject sobj:RResult.objResultList)
            {
                routingOpp.add('\''+(String) sobj.get('Standard_Operation_Id__c')+'\'');
            }
        }
        if (conBGR.Size__c!=null && routingOpp.size()>0) {
            String s = String.join(routingOpp,',');
            query=query+'where  StdOpName__c IN ('+s+')';
        }
        System.debug('Routing Query In'+query);
        lstroutingIn=Database.query(query) ;
        return lstroutingIn;
    }
    public List<BGR_Cost_Part_Number__c> getAssembleCost() {
        List<BGR_Cost_Part_Number__c> asmCost=new List<BGR_Cost_Part_Number__c>();
        string query='Select InsideCost__c,OutsideCost__c from BGR_Cost_Part_Number__c ';
        if (conBGR.Part_Number__c!=null) {
            query=query+'Where  PartNumber__c=\''+conBGR.Part_Number__c+'\' and QtyLL__c<=\''+conBGR.Quantity__c+'\' and QtyUL__c>=\''+conBGR.Quantity__c+'\'';
            asmCost=Database.query(query);
        }
        return asmCost;
    }
    public List<BGR_Cost_Part_Number__c> getBuildCost() {
        List<BGR_Cost_Part_Number__c> buldCost=new List<BGR_Cost_Part_Number__c>();
        string query='Select InsideCost__c,OutsideCost__c from BGR_Cost_Part_Number__c ';
        if (strucPartList.size()>0) {
            String s = String.join(strucPartList,',');
            query=query+'Where  PartNumber__c IN ('+s+') and QtyLL__c<='+conBGR.Quantity__c+' and QtyUL__c>='+conBGR.Quantity__c;
            system.debug('**** query = '+query);
            //buldCost=Database.query(query);
        }
        return buldCost;
    }
    public class BGRCostWrapper {
        public Cost__c costItem{set;get;}
        public String costMethod{set;get;}
        public String costSubType{set;get;}
        public String costPartNum{set;get;}
        public decimal costInsite10{set;get;}
        public decimal costOutsite10{set;get;}
        public decimal costInsite20{set;get;}
        public decimal costOutsite20{set;get;}
        public decimal costInsite30{set;get;}
        public decimal costOutsite30{set;get;}

        public BGRCostWrapper(Cost__c c) {
            if(c.Inside_Cost_10__c!=null)
                this.costInsite10=decimal.valueOf(c.Inside_Cost_10__c);
            if(c.Outside_Cost_10__c!=null)
                this.costOutsite10=decimal.valueOf(c.Outside_Cost_10__c);
            if(c.Inside_Cost_20__c!=null)
                this.costInsite20=decimal.valueOf(c.Inside_Cost_20__c);
            if(c.Outside_Cost_20__c!=null)
                this.costOutsite20=decimal.valueOf(c.Outside_Cost_20__c);
            if(c.Inside_Cost_30__c!=null)
                this.costInsite30=decimal.valueOf(c.Inside_Cost_30__c);
            if(c.Outside_Cost_30__c!=null)
                this.costOutsite30=decimal.valueOf(c.Outside_Cost_30__c);
            this.costMethod=c.Cost_Method__c;
            this.costSubType=c.Cost_Sub_Type__c;
            this.costPartNum=c.Part_Number__c;
        }
    }
    public List<BGRCostWrapper> getBGRCostData() {
        List<BGRCostWrapper> bgrCostWrap=new List<BGRCostWrapper>();
        List<Cost__c> costlist = new List<Cost__c>();
        List<BGR_Cost_Part_Number__c> asCost=getAssembleCost();
        Cost__c newCost=new Cost__c();
        newCost.Ref_Id__c=conBGR.Id;
        newCost.Product__c='BGR';
        newCost.Cost_Method__c='Assembly';
        for (BGR_Cost_Part_Number__c cst : asCost) {
            newCost.Part_Number__c=cst.PartNumber__c;
            if(cst.Site__c=='10') {
                newCost.Inside_Cost_10__c=cst.InsideCost__c;
                //newCost.Inside_Cost_Override_10__c=
                newCost.Outside_Cost_10__c=cst.OutsideCost__c;
                //newCost.Outside_Cost_Override_10__c=
            } else if (cst.Site__c=='20') {
                newCost.Inside_Cost_20__c=cst.InsideCost__c;
                newCost.Outside_Cost_20__c=cst.OutsideCost__c;
            } else if (cst.Site__c=='30') {
                newCost.Inside_Cost_30__c=cst.InsideCost__c;
                newCost.Outside_Cost_30__c=cst.OutsideCost__c;
            }
        }
        costlist.add(newCost);
        List<BGR_Cost_Part_Number__c> buldCost=getBuildCost();

        for (BGR_Cost_Part_Number__c cst : buldCost) {
            newCost=new Cost__c();
            newCost.Ref_Id__c=conBGR.Id;
            newCost.Product__c='BGR';
            newCost.Cost_Method__c='Build Up';
            newCost.Cost_Sub_Type__c='Structure';
            newCost.Part_Number__c=cst.PartNumber__c;
            if(cst.Site__c=='10') {
                newCost.Inside_Cost_10__c=cst.InsideCost__c;
                //newCost.Inside_Cost_Override_10__c=
                newCost.Outside_Cost_10__c=cst.OutsideCost__c;
                //newCost.Outside_Cost_Override_10__c=
            } else if (cst.Site__c=='20') {
                newCost.Inside_Cost_20__c=cst.InsideCost__c;
                newCost.Outside_Cost_20__c=cst.OutsideCost__c;
            } else if (cst.Site__c=='30') {
                newCost.Inside_Cost_30__c=cst.InsideCost__c;
                newCost.Outside_Cost_30__c=cst.OutsideCost__c;
            }
            costlist.add(newCost);
        }
        list<BGR_Cost_Routing_Inside__c> routIn=getRoutingInCost();
        list<BGR_Cost_Routing_Outside__c> routOut=getRoutingOutCost();
        Map<String,String> rtInList=new Map<String,String>();
        Map<String,String> rtOutList=new Map<String,String>();
        for (BGR_Cost_Routing_Inside__c rIn: routIn) {
           string key=rIn.StdOpName__c+'->'+rIn.Site__c;
           string value=rIn.Inside_Cost__c;
           rtInList.put(key,value);
        }
        for (BGR_Cost_Routing_Outside__c rOut: routOut) {
            string key=rOut.StdOpName__c+'->'+rOut.Site__c;
            string value=rOut.Outside_Cost__c;
            rtOutList.put(key,value);
        }
       System.debug('Side KEy Out'+rtOutList);
       System.debug('Side KEy In'+rtInList);
        for (string str:routingOpp) {
            newCost=new Cost__c();
            newCost.Ref_Id__c=conBGR.Id;
            newCost.Product__c='BGR';
            newCost.Cost_Method__c='Router';
            string s=str.removeEnd('\'').removeStart('\'');
            string key=s+'->10';
            string key2=s+'->20';
            string key3=s+'->30';
            System.debug('Side KEy In keyset'+rtInList.keyset());
            System.debug('Side KEy Out keyset'+rtOutList.keyset());
            newCost.Part_Number__c=str.removeEnd('\'').removeStart('\'');
            newCost.Inside_Cost_10__c=rtInList.get(key);
            newCost.Outside_Cost_10__c=rtOutList.get(key);
            newCost.Inside_Cost_20__c=rtInList.get(key2);
            newCost.Outside_Cost_20__c=rtOutList.get(key2);
            newCost.Inside_Cost_30__c=rtInList.get(key3);
            newCost.Outside_Cost_30__c=rtOutList.get(key3);
            costlist.add(newCost);
            System.debug('key1'+key);
            System.debug('key2'+key2);
            System.debug('key3'+key3);
            System.debug('Cost Routing '+rtInList.get(key2));
            System.debug('Cost Routing '+rtOutList.get(key2));
        }
        // try {
        //     upsert costlist;
        // }
        // catch (Exception e) {
        //     System.debug('Exception Cost'+e.getMessage());

        // }
        for (Cost__c cst:costlist) {
            BGRCostWrapper ab=new BGRCostWrapper(cst);
            bgrCostWrap.add(ab);
        }
        return bgrCostWrap;
    }*/
    
    public pageReference cleanBGRrecord()
    {
        conBGR.Service_Type__c  = null;
        conBGR.Setting__c  = null;
        conBGR.Setting_Units__c  = null;
        conBGR.Supply_Pressure__c  = null;
        conBGR.Supply_Gas_Temperature__c =null;
        conBGR.Supply_Pressure_Units__c  = null;
        conBGR.Atex__c  = null;
        conBGR.GOST_CU_Tr_010_2011__c  = null;
        conBGR.CSA_Markings__c  = null;
        conBGR.Combo_Orifice_Setting__c  = null; 
        conBGR.Model__c  = null;
        conBGR.Size__c  = null;
        conBGR.Size_Backend__c = null;
        conBGR.Body_Material_dynamic__c  = null;
        conBGR.Soft_Goods_Material_dynamic__c = null ;
        conBGR.Connection_dynamic__c = null;
        conBGR.Radiography__c = null ;
        conBGR.Positive_Material_Identification__c =null;
        conBGR.Shell_test__c = null;
        conBGR.Shell_Test_Valve_Body__c = null;
        conBGR.Final_Assembly_Location_Requirements__c = null;
        conBGR.Material_Sourcing_Requirements__c = null;
        conBGR.Atmospheric_Pressure_Units__c=null;
        conBGR.Supply_Gas_Temperature_Units__c=null;
        conBGR.Flow_Units__c=null;
        conBGR.Minimum_Required_Flow_Capacity__c=null;
        conBGR.Body_Material_dynamic__c  = null;
        conBGR.Soft_Goods_Material_dynamic__c = null ;
        conBGR.Connection_dynamic__c = null;
        conBGR.Radiography__c = null ;
        conBGR.Positive_Material_Identification__c =null;
        conBGR.Shell_test__c = null;
        conBGR.Shell_Test_Valve_Body__c = null;
        conBGR.Final_Assembly_Location_Requirements__c = null;
        conBGR.Material_Sourcing_Requirements__c = null;
        conBGR.Supply_Gas_Temperature__c =null;
        conBGR.Supply_Pressure_Units__c  = null;
        conBGR.Atex__c  = null;
        conBGR.GOST_CU_Tr_010_2011__c  = null;
        conBGR.Atmospheric_Pressure_Units__c=null;
        conBGR.Supply_Gas_Temperature_Units__c=null;

        return null;
    }
}