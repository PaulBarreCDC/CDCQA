/**
* @File Name          : ConfigureWasteGasBurner.cls
* @Description        :
* @Author             : Vikram Natikar
* @Group              :
* @Last Modified By   : Vikram Natikar
* @Last Modified On   : 04/11/2020
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    29/11/2019     Vikram Natikar        Initial Version
**/

public class ConfigureWasteGasBurner {
    Public boolean ReorderFlag {get;set;}
    
    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public string strQuoteStatus {set;get;}
    public WasteGasBurner__c WGBProd {set; get;}
    Public boolean showsales {get;set;}
    public boolean disableButton {get;set;}
    public WGB_Flow_Rate__c WGBFlowRate {set;get;}
    public id WGBProdId {set;get;}    
    Public id qliId {set; get;}
    public id quotelineId {set;get;}
  //  public id quotelineId2 {set;get;}
    public WGBOutputUtility WGBOU {set;get;}
    public string refURL{get;set;}
    //public string fromPage;
    //public boolean reorderControl = false;
   
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

    public ConfigureWasteGasBurner (ApexPages.StandardController controller) {

   //Nagrjuna added Tab visibility logic
         showsales = False;
         ReorderFlag = false;
         editModeLable = 'Edit'; //added by piyush  
        
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
        quotelineId=ApexPages.currentPage().getParameters().get('qid');
        //fromPage = ApexPages.currentPage().getParameters().get('fromPage');
        if(string.isNotBlank(quoteLineId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
     
        System.debug('quotelineId------'+quotelineId);
        id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quotelineId);
        System.debug('RecordID-------'+RecordID);
        WGBProd= (WasteGasBurner__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        WGBOU=new WGBOutputUtility(WGBProd.Id);
        disableButton = (!showsales) && WGBProd.Quote_Description_Engineer_Override__c;

        WGBLeadWrapperList = new list<LeadWrapper>();
        WGBPriceWrapperList = new list<priceWrapper>();
        WGBProd.Product_Material_and_Options_Flag__c=false;
        WGBProd.Process_Parameters_Flag__c=false;
        WGBProd.Certifications_Flag__c=false;
        WGBProd.Product_Selection_Flag__c=false;


        //added by piyush         

        selectedTab = 'name1';
      
        if(WGBProd.IsConfig__c){
          selectedTab = 'ProductReview';  
          GetLeadTimeRec();
      }


        if(WGBProd.IsConfig__c){
           if(WGBProd.Quote_Description_Engineer_Override__c){
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
        disableButton = true; // old value false
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

        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            if (WGBProd.Price_Engineer_Override__c == true ||
                WGBProd.Lead_Time_Engineer_Override__c == true ||
                WGBProd.Cost_Override__c == true ||
                WGBProd.Quote_Description_Engineer_Override__c == true
                ){
                    disableButton = true;
                    bShowEditButton = false;
            }
         }

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
    
    //added by piyush
    public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
            strURL = '/apex/ConfigWgbReference?Id=' + WGBProd.Id;

        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }

    // Added for Reorder purpose
    public ConfigureWasteGasBurner (Id QuotelineId) {

        //Nagrjuna added Tab visibility logic
             showsales = False;
             disableButton = False;
             Id profileId=userinfo.getProfileId();
             String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
             set<string> profilesetstr = new set<string>();
             profilesetstr.add('System Administrator');
             profilesetstr.add('CDC Engineering');
     
             if(profilesetstr.contains(profileName )) {
                 showsales = True;
                 system.debug('=========='+showsales);
             }
     
             // visibility logic ended
             qliId = QuotelineId;
             //qli=[SELECT Id, Run_Config_Sync__c FROM SBQQ__QuoteLine__c WHERE Id=:qliId];
             //fromPage = ApexPages.currentPage().getParameters().get('fromPage');
             if(string.isNotBlank(quoteLineId)) {
                 quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :qliId];
                 strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
             }
             else
                 System.debug('QuoteLine Id is Missing');
         
             System.debug('quotelineId------'+quotelineId);
             id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(QuotelineId);
             System.debug('RecordID-------'+RecordID);
             WGBProd= (WasteGasBurner__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
             WGBOU=new WGBOutputUtility(WGBProd.Id);
             disableButton = (!showsales) && WGBProd.Quote_Description_Engineer_Override__c;
     
             //WGBPricingList = new list<WGB_Price_Detail__c >();
             WGBLeadWrapperList = new list<LeadWrapper>();
             WGBPriceWrapperList = new list<priceWrapper>();
             WGBProd.Product_Material_and_Options_Flag__c=false;
             WGBProd.Process_Parameters_Flag__c=false;
             WGBProd.Certifications_Flag__c=false;
             WGBProd.Product_Selection_Flag__c=false;
            
        }
    
    //Above  Constructor is added for Reorder Purpose
    
    public List<string> notValidStatusForChng {
        get {
            return new List<String>{'Approved','Order Submitted'};
        }
        set {
            this.notValidStatusForChng=value;
        }
    }
      //saveRecommendedProcessInformation Method
      public PageReference saveRecommendedProcessInformation() {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
          WGBProd.Product_Material_and_Options_Flag__c=false;
          WGBProd.Certifications_Flag__c=false;
          WGBProd.Product_Selection_Flag__c=false; 
          WGBProd.Process_Parameters_Flag__c=true;
          WGBProd.IsConfig__c=false; //added by piyush
        try {
            
           // System.debug('@@@@@Reorder Flag'+ ReorderFlag);
            WGBProd.Bypass__c=false;

            //Converting Pilot Supply Pressure Rate
            result resultConvertedPressure=new result();
            if(WGBProd.Pilot_Gas__c!=null && WGBProd.Pilot_Supply_Pressure__c!=null && WGBProd.Pressure_Setting_Units__c!=null)
             {
                resultConvertedPressure=unitConversions.convertPressure(WGBProd.Pressure_Setting_Units__c,'in. water',WGBProd.Pilot_Supply_Pressure__c);
                WGBProd.Converted_Pilot_Supply_Pressure__c=resultConvertedPressure.dblRetValue;

                //Gage Attribute method
                if(WGBProd.Converted_Pilot_Supply_Pressure__c!=null && WGBProd.Converted_Pilot_Supply_Pressure__c>27.7073)
                        WGBProd.Gage__c='psig';
                else
                        WGBProd.Gage__c='in. water';
                System.debug('AAAOutsidebeforeeeee-----'+WGBProd.Converted_Pilot_Supply_Pressure__c);
                //Pilot Gas Regulator Attribute method
                if(WGBProd.Converted_Pilot_Supply_Pressure__c!=null && WGBProd.Converted_Pilot_Supply_Pressure__c>138.536)
                        WGBProd.Pilot_Gas_Regulator__c='Y';
                else
                        WGBProd.Pilot_Gas_Regulator__c='N';

                System.debug('AAAPilot_Gas__c-----'+WGBProd.Pilot_Gas__c);
                decimal GasMin=[select GasMin__c from WGB_Module_Orifice__c where GasGroup__c=:WGBProd.Pilot_Gas__c order by GasMin__c ASC][0].GasMin__c;
                System.debug('AAAGasMin-----'+GasMin);
                System.debug('AAAPilot_Gas__c-----'+WGBProd.Pilot_Gas__c);
                decimal GasMax=[select GasMax__c from WGB_Module_Orifice__c where GasGroup__c=:WGBProd.Pilot_Gas__c order by GasMax__c DESC][0].GasMax__c;//order by GasMax__c DESC
                System.debug('AAAOutside-----'+WGBProd.Converted_Pilot_Supply_Pressure__c);
                System.debug('AAAGasMax-----'+GasMax);
                if(WGBProd.Pilot_Supply_Pressure__c!=null){
                    if(WGBProd.Converted_Pilot_Supply_Pressure__c<GasMin || WGBProd.Converted_Pilot_Supply_Pressure__c>GasMax){
                         //System.debug('AAA-----'+WGBProd.Converted_Pilot_Supply_Pressure__c);
                      resultConvertedPressure=unitConversions.getConvertedValErrorMsg('Pressure',GasMax,GasMin,'in. water',WGBProd.Pressure_Setting_Units__c,WGBProd.Pilot_Supply_Pressure__c,'Pilot Supply Pressure ');
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertedPressure.strErrorMessage));
                    }
                }
            }


            //Converting  Gas Flow Rate
            result resultConvertFlow_Rate=new result();
            if (WGBProd.Flow_Rate__c!=null && WGBProd.Flow_Rate_Units__c!=null)
            {
                resultConvertFlow_Rate=unitConversions.convertGasFlowRate(WGBProd.Flow_Rate_Units__c,'SCFH',WGBProd.Flow_Rate__c,1,1,1,1);
                WGBProd.Converted_Flow_Rate__c=resultConvertFlow_Rate.dblRetValue;

                decimal maxRange=[select MAX_FLOWRATE__c from WGB_Flow_Rate__c  order by MAX_FLOWRATE__c DESC][0].MAX_FLOWRATE__c;
                decimal minRange=[select MIN_FLOWRATE__c from WGB_Flow_Rate__c  order by MIN_FLOWRATE__c ASC][0].MIN_FLOWRATE__c;

            //    System.debug('Max------------' +maxRange);
             //   System.debug('Min---------' +minRange);

                if(WGBProd.Converted_Flow_Rate__c<=minRange ||  WGBProd.Converted_Flow_Rate__c > maxRange){
                        // System.debug('Converted Flow Rate should be less than ' + maxRange );|| WGBProd.Flow_Rate__c < minRange
               //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Flow Rate must be between 0.0 and ' + maxRange+ ''));
                    resultConvertFlow_Rate=unitConversions.getConvertedValErrorMsg('WGBGasFlowRate',maxRange,minRange,'SCFH',WGBProd.Flow_Rate_Units__c,WGBProd.Flow_Rate__c,'Flow Rate : ');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertFlow_Rate.strErrorMessage));
                }
            }
            
            System.debug('@@@@@ Converted Pressure'+ WGBProd.Converted_Pilot_Supply_Pressure__c);
            System.debug('@@@@@ Converted FlowRate'+ WGBProd.Converted_Flow_Rate__c);
            if(!ReorderFlag)
            {
               cleanSecC();
               cleanSecD(); 
            }

            update WGBProd;
        }
        catch(Exception dmle)
        {
            System.debug('EEEEEEEE' +dmle);
            ApexPages.addMessages(dmle);
            return null;
        }
      /*  pageReference reloadpage2 = new pageReference('/apex/ConfigWGBProduct?qid='+quotelineId);
        reloadpage2.setRedirect(true);
        return reloadpage2;*/
        return null;
    }

    //Reload method
    public PageReference reload() {
        return null;
    }

    //Certifications save method
     public PageReference SaveCertifications() {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
          WGBProd.Certifications_Flag__c=true;
          WGBProd.IsConfig__c=false; //added by piyush
        try {
            WGBProd.Bypass__c=false;
            update WGBProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    public void cleanSecC(){
        WGBProd.Product_Selection_Flag__c=false;

        WGBProd.Select_Model__c=null;
        WGBProd.Size__c=null;

    }

    public void cleanSecD(){
        WGBProd.Product_Material_and_Options_Flag__c=false;

        WGBProd.Quantity__c=1;
        WGBProd.Upper_Shroud_Stack_Matl__c=null;
        WGBProd.Lower_Stack_Pedestal_Matl__c=null;
        WGBProd.Pedestal_Connection__c=null;
        WGBProd.Ignitor_Control__c=null;
        WGBProd.Flame_Sensor__c=null;
        WGBProd.Thermocouple_Material__c=null;
        WGBProd.Enclosure_Type__c=null;
        WGBProd.Control_Panel_Alarm__c=null;
        WGBProd.Control_Panel_Heater__c=null;
        WGBProd.Stand_Control_Material__c=null;
        WGBProd.Sunshield_Control__c=null;
        WGBProd.Step_Down_Transformer__c=null;
        WGBProd.Back_up_Power_Supply__c=null;

    }

    //Size Field setting method
    public List<WGB_PartParameters_FlowRateDetail__c> WGBFlowRecords{
        get {
            String queryString='select SizeCode__c from WGB_PartParameters_FlowRateDetail__c';
            String whereClause='';

            if(WGBProd.Flow_Rate__c>0.0 && WGBProd.Converted_Flow_Rate__c!=null && WGBProd.Flow_Rate_Units__c!=null)
            {
              //   System.debug('Flow Rate Code Start');
                 whereClause=whereClause+' where NumVal1__c <'+ WGBProd.Converted_Flow_Rate__c+' and NumVal2__c>='+WGBProd.Converted_Flow_Rate__c+'';
              //   System.debug('Flow Rate Code End');
            }

            queryString = queryString + whereClause;
            string order_by=' order by SizeCode__c';
            queryString=queryString+order_by;
         //   System.debug('DynamicQuery'+queryString);
            List<WGB_PartParameters_FlowRateDetail__c> sobjList = Database.query(queryString);
        //    System.debug('rDMBRecords Query : ' + sobjList);
            return sobjList;

        }
    }
  /*
  //Size Field setting method
    public List<WGB_PartParameters_FlowRateDetail__c> WGBFlowRecords{
        get {
                result res_Size = new Result();
                res_Size=WGBOU.getFlowRate();
                return res_Size.objResultList;
            }
    }
   */

     public List<SelectOption> getSeatValues() {
        List<selectOption> seatOptions = new List<selectOption>();
        List<string> uniqueList=new List<string>();
        seatOptions.add(new selectOption('',''));
        if(WGBProd.Flow_Rate__c>=0.0 && WGBProd.Flow_Rate_Units__c==null)
                    seatOptions.add(new selectOption('',''));
         else
         {
             for (WGB_PartParameters_FlowRateDetail__c kv: WGBFlowRecords ) {
                if(!uniqueList.contains(kv.SizeCode__c)){
                    System.debug('SizeCode-----'+kv.SizeCode__c);
                    string strSize='';
                    string strSizeCode='';
                    if(kv.SizeCode__c=='02'){
                       strSize='2" (50mm)';
                        // strSizeCode='02';
                    }

                    else if(kv.SizeCode__c=='03'){
                        strSize='3" (80mm)';
                      //  strSizeCode='03';
                    }

                    else if(kv.SizeCode__c=='04'){
                        strSize='4" (100mm)';
                      //  strSizeCode='04';
                    }

                    else if(kv.SizeCode__c=='06'){
                        strSize='6" (150mm)';
                     //  strSizeCode='06';
                    }

                    else if(kv.SizeCode__c=='08'){
                        strSize='8" (200mm)';
                      //  strSizeCode='08';
                    }

                    else if(kv.SizeCode__c=='10'){
                        strSize='10" (250mm)';
                      //  strSizeCode='10';
                    }

                    else if(kv.SizeCode__c=='12'){
                        strSize='12" (300mm)';
                     //  strSizeCode='12';
                    }
                    System.debug('strSizeCode-----'+strSizeCode);
                    System.debug('strSize-----'+strSize);

                    uniqueList.add(kv.SizeCode__c);
                    seatOptions.add(new selectOption(kv.SizeCode__c,strSize));
                   // seatOptions.add(new selectOption(strSizeCode,strSize));
                }
             }
         }
         if(seatOptions.size()==2)
            seatOptions.remove(0);
         return seatOptions;
    }

    //Upper Shroud/Stack Matl Field setting method
    public List<selectOption> getUpperShroud() {
        List<selectOption> upperShroudOptions = new List<selectOption>();
        upperShroudOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Upper_Shroud_Stack_Matl__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
                  upperShroudOptions.add(new selectOption(a.getValue(),a.getLabel()));
        }
        return upperShroudOptions;
    }

    //Lower Stack/Pedestal Matl
    public List<selectOption> getLowerStack() {
        List<selectOption> lowerStackOptions = new List<selectOption>();
        lowerStackOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Lower_Stack_Pedestal_Matl__c').getDescribe().getPickListValues();

           for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
            {
                if(WGBProd.Upper_Shroud_Stack_Matl__c!=null)
                {
                    if(WGBProd.Upper_Shroud_Stack_Matl__c=='4')
                    {
                        if(a.getLabel()!='316 SS')
                        {
                            lowerStackOptions.add(new selectOption(a.getValue(),a.getLabel()));
                        }
                    }
                    else
                    {
                        if(a.getLabel()=='316 SS')
                        {
                            lowerStackOptions.add(new selectOption(a.getValue(),a.getLabel()));
                        }
                    }
                }
                else
                    lowerStackOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
        if(lowerStackOptions.size()==2)
            lowerStackOptions.remove(0);
        return lowerStackOptions;
    }

    //Pedestal Connection Field setting method
    public List<selectOption> getPedestalConnection() {
        List<selectOption> pedestalConnectionOptions = new List<selectOption>();
        pedestalConnectionOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Pedestal_Connection__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
                  pedestalConnectionOptions.add(new selectOption(a.getValue(),a.getLabel()));
        }

        return pedestalConnectionOptions;
    }

    //Ignitor Control Field setting method
    public List<selectOption> getIgnitorControl() {
        List<selectOption> ignitorControlOptions = new List<selectOption>();
        ignitorControlOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Ignitor_Control__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
                  ignitorControlOptions.add(new selectOption(a.getValue(),a.getLabel()));
        }

        return ignitorControlOptions;
    }

    //Flame Sensor Field setting method
    public List<selectOption> getFlameSensor() {
        List<selectOption> flameSensorOptions = new List<selectOption>();
        flameSensorOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Flame_Sensor__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
            {
                if(WGBProd.Ignitor_Control__c!=null){
                    if(WGBProd.Ignitor_Control__c=='automatic'){
                    if(a.getLabel()!='None')
                        flameSensorOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }
                else
                    {
                    if(a.getLabel()=='None')
                        flameSensorOptions.add(new selectOption(a.getValue(),a.getLabel()));   //if(WGBProd.Ignitor_Control__c=='manual')
                    }
                }
                else
                    flameSensorOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
        if(flameSensorOptions.size()==2)
            flameSensorOptions.remove(0);
        return flameSensorOptions;
    }

    //Thermocouple Material Field setting method
     public List<selectOption> getThermocoupleMaterial() {
        List<selectOption> thermocoupleMaterialOptions = new List<selectOption>();
        thermocoupleMaterialOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Thermocouple_Material__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
            {
                if(WGBProd.Ignitor_Control__c!=null){
                        if(WGBProd.Ignitor_Control__c=='automatic')
                    {
                        if(a.getLabel()!='N/A')
                             thermocoupleMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                    else {
                        if(a.getLabel()=='N/A')
                            thermocoupleMaterialOptions.add(new selectOption(a.getValue(),a.getLabel())); //if(WGBProd.Ignitor_Control__c=='manual')
                    }
                }
                else
                     thermocoupleMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
         if(thermocoupleMaterialOptions.size()==2)
            thermocoupleMaterialOptions.remove(0);
        return thermocoupleMaterialOptions;
    }

    //Enclosure Type Field settin method
    public List<selectOption> getEnclosureType() {
        List<selectOption> enclosureTypeOptions = new List<selectOption>();
        enclosureTypeOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Enclosure_Type__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
                  enclosureTypeOptions.add(new selectOption(a.getValue(),a.getLabel()));
        }
        return enclosureTypeOptions;
    }

    //Control Panel Alarm Field setting method
    public List<selectOption> getControlPanelAlarm() {
        List<selectOption> controlPanelAlarmOptions = new List<selectOption>();
        controlPanelAlarmOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Control_Panel_Alarm__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
            {
                if(WGBProd.Ignitor_Control__c!=null){
                         if(WGBProd.Ignitor_Control__c=='automatic')
                    {
                      //  if(a.getLabel()!='None')
                             controlPanelAlarmOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                    else {
                             if(a.getLabel()=='None')
                                    controlPanelAlarmOptions.add(new selectOption(a.getValue(),a.getLabel())); // if(WGBProd.Ignitor_Control__c=='manual')
                    }
                }
                else
                       controlPanelAlarmOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
        if(controlPanelAlarmOptions.size()==2)
            controlPanelAlarmOptions.remove(0);
        return controlPanelAlarmOptions;
    }

    //Control Panel Heater Field setting method
    public List<selectOption> getControlPanelHeater() {
        List<selectOption> controlPanelHeaterOptions = new List<selectOption>();
        controlPanelHeaterOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Control_Panel_Heater__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
                  controlPanelHeaterOptions.add(new selectOption(a.getValue(),a.getLabel()));
        }
        return controlPanelHeaterOptions;
    }

    //Stand Control Material Field setting method
     public List<selectOption> getStandControlMaterial() {
        List<selectOption> standControlMaterialOptions = new List<selectOption>();
        standControlMaterialOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Stand_Control_Material__c').getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)   {
                if(WGBProd.Select_Model__c!=null){
                        if(WGBProd.Select_Model__c=='8391B')
                    {
                        if(a.getLabel()=='None')
                           standControlMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                    else {
                        standControlMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));  //if(WGBProd.Stand_Control_Material__c!='None')
                    }
                }
                else
                     standControlMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
         if(standControlMaterialOptions.size()==2)
            standControlMaterialOptions.remove(0);
        return standControlMaterialOptions;
    }

    //Sunshield Control Field setting method
    public List<selectOption> getSunshieldControl() {
        List<selectOption> sunshieldControlOptions = new List<selectOption>();
        sunshieldControlOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Sunshield_Control__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
            {
                if(WGBProd.Select_Model__c!=null){
                        if(WGBProd.Select_Model__c=='8391B')
                    {
                        if(a.getLabel()=='No')
                           sunshieldControlOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                    else {
                        if(WGBProd.Stand_Control_Material__c!=null){
                            if(WGBProd.Stand_Control_Material__c=='N')
                            {
                                if(a.getLabel()=='No')
                                    sunshieldControlOptions.add(new selectOption(a.getValue(),a.getLabel()));
                            }
                            else
                               sunshieldControlOptions.add(new selectOption(a.getValue(),a.getLabel()));
                        }
                        else
                           sunshieldControlOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                }
                else
                     sunshieldControlOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
        if(sunshieldControlOptions.size()==2)
            sunshieldControlOptions.remove(0);
        return sunshieldControlOptions;
    }

    //Step Down Transformer Field setting method
    public List<selectOption> getStepDownTransformer() {
        List<selectOption> stepDownTransformerOptions = new List<selectOption>();
        stepDownTransformerOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Step_Down_Transformer__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
                  stepDownTransformerOptions.add(new selectOption(a.getValue(),a.getLabel()));
        }
        return stepDownTransformerOptions;
    }

    //Back-up Power Supply Field setting method
    public List<selectOption> getBackupPowerSupply() {
        List<selectOption> backupPowerSupplyOptions = new List<selectOption>();
        backupPowerSupplyOptions.add(new selectOption('',''));
        Schema.sObjectType sobject_type = WasteGasBurner__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Back_up_Power_Supply__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) {
            if (WGBProd.Size__c!=null && WGBProd.Flow_Rate__c>0.0 && WGBProd.Flow_Rate_Units__c!=null)
            {
                if(WGBProd.Ignitor_Control__c!=null){
                        if(WGBProd.Ignitor_Control__c=='manual')
                    {
                        if(a.getLabel()!='Yes')
                             backupPowerSupplyOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                    else {
                        backupPowerSupplyOptions.add(new selectOption(a.getValue(),a.getLabel()));   //if(WGBProd.Ignitor_Control__c=='automatic')
                    }
                }
                 else
                     backupPowerSupplyOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
        if(backupPowerSupplyOptions.size()==2)
            backupPowerSupplyOptions.remove(0);
        return backupPowerSupplyOptions;
    }

    public PageReference saveProductSelection() {
        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false; // added by piyush
        WGBProd.IsConfig__c=false; //added by piyush
          WGBProd.Product_Selection_Flag__c=true;
        try {
            WGBProd.Bypass__c=false;
            if(!ReorderFlag)            
                cleanSecD();
            update WGBProd;
        }
        catch(Exception dmle)
        {
            if(!ReorderFlag)  
                ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

  //  public string partnobase {get;set;}
    
     public PageReference saveSelections() {
        //reorderControl = true;
         WGBProd.IsConfig__c=true;
          WGBProd.Process_Parameters_Flag__c=false;
          WGBProd.Product_Material_and_Options_Flag__c=true;
      try {
            showPricing=true;
            WGBProd.Bypass__c=false;
            Update WGBProd;
            WGBOU=new WGBOutputUtility(WGBProd.Id);
            if(!Test.isRunningTest())
                GetLeadTimeRec();
          //  WGBPricingList=getPricinglist();
         //   PriceCheck='true';
            if(!Test.isRunningTest())
                getPricinglist();
         //  update WGBProd;
             if(!Test.isRunningTest())
                GetQuoteDescriptionRec();
            List<Cost__c> cstList = new List<Cost__c>();
            cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(WGBProd.Id)];
            if(!cstList.isEmpty() && cstList.size() >0 )
            {
                delete cstList;
            }
          if(!Test.isRunningTest())
            getCosts();

            //update WGBProd;
                result WGBAttributes = new Result();
                Map<string, string> mapVals = new Map<string, string>();
                mapVals.put('IGNCTL',WGBProd.Ignitor_Control__c);
                mapVals.put('BPS',WGBProd.Back_up_Power_Supply__c);
                mapVals.put('CPALRM',WGBProd.Control_Panel_Alarm__c);
                mapVals.put('FLMSNS',WGBProd.Flame_Sensor__c);
                mapVals.put('ENCTYP',WGBProd.Enclosure_Type__c);
                mapVals.put('CPHEAT',WGBProd.Control_Panel_Heater__c);
                mapVals.put('PilotSupplyPressConverted',String.Valueof(WGBProd.Converted_Pilot_Supply_Pressure__c));
                List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
                WGBAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','WGB_Attribute_Lookup_Translation__c','WGB_Attribute_Lookup_Detail__c',mapVals,selectCols);
                List<string> listName = new List<string>();
                listName.add('IgnitorOpt');
                listName.add('FlameSensorOpt');
                listName.add('EnclosureOpt');
               // listName.add('SpecialOpt');
                listName.add('SpecialOpt2');
                listName.add('SpecialOpt4');
                listName.add('SpecialOpt6');
                listName.add('SpecialOpt8');
                Map<string,string> mapAttValues= new Map<string,string>();
                if (WGBAttributes.bResult) {
                    for(sObject objD : WGBAttributes.objResultList)
                    {
                        if(listName.contains((string) objD.get('Attribute__c'))) {
                            mapAttValues.put((string) objD.get('Attribute__c'),(string) objD.get('Text__c'));
                        }
                    }
                }
                String IgnitorOpt=mapAttValues.get('IgnitorOpt');
                String EnclosureOpt=mapAttValues.get('EnclosureOpt');
                String FlameSensorOpt=mapAttValues.get('FlameSensorOpt');
                String SpecialOpt2;
                String SpecialOpt4;
                String SpecialOpt6;
                String SpecialOpt8;
                if(mapAttValues.get('SpecialOpt2')!=null)
                     SpecialOpt2=mapAttValues.get('SpecialOpt2');
                else
                    SpecialOpt2='';
                if(mapAttValues.get('SpecialOpt4')!=null)
                     SpecialOpt4=mapAttValues.get('SpecialOpt4');
                else
                    SpecialOpt4='';
                if(mapAttValues.get('SpecialOpt6')!=null)
                     SpecialOpt6=mapAttValues.get('SpecialOpt6');
                else
                    SpecialOpt6='';
                if(mapAttValues.get('SpecialOpt8')!=null)
                     SpecialOpt8=mapAttValues.get('SpecialOpt8');
                else
                    SpecialOpt8='';
              
                result WGBAttributes2 = new Result();
                Map<string, string> mapVals2 = new Map<string, string>();
                mapVals2.put('SpecialOpt2',SpecialOpt2);
                mapVals2.put('SpecialOpt4',SpecialOpt4);
                mapVals2.put('SpecialOpt6',SpecialOpt6);
                mapVals2.put('SpecialOpt8',SpecialOpt8);
                List<String> selectCols2 = new List<String> {'Text__c','Attribute__c','Value__c'};
                WGBAttributes2=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','WGB_Attribute_Lookup_Translation__c','WGB_Attribute_Lookup_Detail__c',mapVals2,selectCols2);
                List<string> listName2 = new List<string>();
                listName2.add('SpecialOpt');
                Map<string,string> mapAttValues2= new Map<string,string>();
                if (WGBAttributes2.bResult) {
                    for(sObject objD : WGBAttributes2.objResultList)
                    {
                        if(listName2.contains((string) objD.get('Attribute__c'))) {
                            mapAttValues2.put((string) objD.get('Attribute__c'),(string) objD.get('Text__c'));
                        }
                    }
                }
                String SpecialOpt=mapAttValues2.get('SpecialOpt');
            System.debug('@@@@@@@BRANDCODE' +WGBOU.BRANDCODE);
            WGBProd.Part_Number_Base_Original__c =WGBOU.BRANDCODE+WGBProd.Select_Model__c+'00'+WGBProd.Size__c+'00'+WGBProd.Upper_Shroud_Stack_Matl__c+WGBProd.Lower_Stack_Pedestal_Matl__c+WGBProd.Pedestal_Connection__c+IgnitorOpt+FlameSensorOpt+EnclosureOpt+SpecialOpt;
            WGBProd.Part_Number_Base__c=WGBOU.BRANDCODE+WGBProd.Select_Model__c+'00'+WGBProd.Size__c+'00'+WGBProd.Upper_Shroud_Stack_Matl__c+WGBProd.Lower_Stack_Pedestal_Matl__c+WGBProd.Pedestal_Connection__c+IgnitorOpt+FlameSensorOpt+EnclosureOpt+SpecialOpt;
          System.debug('@@@@@@@Part_Number_Base_Original__c' +WGBProd.Part_Number_Base_Original__c);
          if(WGBProd.Quote_Description_Engineer_Override__c == true)
            {
                WGBProd.ASSYPARTEXISTING__c = '';
            }
            else
            {
                Result partNumberResult = AssyPartDefinationProcessor.getPartNumberExisting(WGBProd.Part_Number_Base__c,WGBProd,'WGB');
                if(partNumberResult.bResult ==  true)
                {
                    WGBProd.ASSYPARTEXISTING__c = partNumberResult.strRetValue;
                }
                else
                {
                    WGBProd.ASSYPARTEXISTING__c = '';
                }
            }
             update WGBProd;
              
        }
        catch(Exception dmle)
        {
            if(!ReorderFlag)  
                ApexPages.addMessages(dmle);
            return null;
        }

        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //string pgRef = '';
        if(userinfo.IsPortalEnabled){
            String url = '/apex/ConfigWGBProduct?qid='+quoteLineId;
            String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
            refURL = encoded;
        }else{
            refURL ='/apex/ConfigWGBProduct?qid='+quoteLineId;
        }

         pageReference reloadpage2 = new pageReference('/apex/ConfigWGBProduct?qid='+quoteLineId);
         //pageReference reloadpage3 = Page.ConfigWGBProduct;
         //reloadpage2.getParameters().put('id',+quotelineId);
         reloadpage2.setRedirect(true);

       //  ApplyDefaultPricing();
            WGBProd.IgnitorOpt__c =WGBOU.IgnitorOpt;
            WGBProd.EnclosureOpt__c =WGBOU.EnclosureOpt;
            WGBProd.FlameSensorOpt__c =WGBOU.FlameSensorOpt;
            WGBProd.SpecialOpt__c =WGBOU.SpecialOpt;

         update WGBProd;
         if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    string strProdOver='';
                    if(String.isNotBlank(WGBProd.OA__c)){
                        strProdOver += WGBProd.OA__c +'\n';
                    }
                    if(String.isNotBlank(WGBProd.OB__c)){
                        strProdOver += WGBProd.OB__c+'\n';
                    }
                    
                    string strquoteDes1 = strProdOver;
                 //   strquoteDes1.replaceAll('\n', '</BR>'); 
            quoteLine.Leadtime_Site_10__c=WGBProd.Lead_Time_Site_10__c;
            quoteLine.Leadtime_Site_20__c=WGBProd.Lead_Time_Site_20__c;
            quoteLine.Leadtime_Site_30__c=WGBProd.Lead_Time_Site_30__c;
            quoteLine.Leadtime_Site_40__c=WGBProd.Lead_Time_Site_40__c;     
             if(!Test.isRunningTest()) 
             {
                 quoteLine.Non_Discountable_List_Price__c =  WGBProd.Non_Discountable_Price__c/WGBProd.Quantity__c;
             }
             quoteLine.Discountable_List_Price__c = WGBProd.Discountable_Price__c;
            quoteLine.Config_Record_Id__c = WGBProd.id;
            quoteLine.SBQQ__Quantity__c=WGBProd.Quantity__c;
            quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('&','&amp').replaceAll('>','&gt').replaceAll('<','&lt').replaceAll('\n', '<BR>');
            upsert quoteLine;
        }
         return reloadpage2;
         //return null;
         //system.debug('!!!!URL:'+reloadpage);
        // return null;
    }

    //WGB_Outputs__c wgboutput = getWGBOutputRecord(WGBProd.Id);
     public string strquoteDes {
        get {
            WGB_Outputs__c wgboutput = getWGBOutputRecord(WGBProd.Id);
            String strProdOver = '';
            if(String.isNotBlank(wgboutput.OA_Override__c)){
                strProdOver += wgboutput.OA_Override__c +'<BR/><BR/>';
            }
            if(String.isNotBlank(wgboutput.OB_Override__c)){
                strProdOver += wgboutput.OB_Override__c+'<BR/><BR/>';
            }            
            strquoteDes = strProdOver;
            return strquoteDes.replaceAll('\n', '<BR/>');
        }
        set {
            this.strquoteDes=value;
        }
    }
    public pageReference goBack() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :QuotelineId].SBQQ__Quote__c;
        system.debug('$$$Back URl:'+qID);

        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        //string pgRef = '';
        if(userinfo.IsPortalEnabled){
            refURL =  '/s/detail/' + qID;
        }else{
            refURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }

      /*  PageReference pageRef = new PageReference();
        pageRef.setRedirect(true);*/
        return null;
    }

     public PageReference savePartNumber() {
         WGBProd.PartNumberBase_Checkbox__c=true;
        try {
            update WGBProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    public PageReference saveNotes() {

        try {
            update WGBProd;
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
        try {
            update WGBProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    //PartNumber Wrapper
  /*  public class PartNumberWrapper
    {
        public string PartNoBase {set;get;}
    }
    public list<PartNumberWrapper> getPartNo()
        {
        list<PartNumberWrapper> PartNoList=new list<PartNumberWrapper>();

        PartNumberWrapper docWrap=new PartNumberWrapper();
        docWrap.PartNoBase  =  WGBOU.BRANDCODE+WGBProd.Select_Model__c+'00'+WGBProd.Size__c+'00'+WGBProd.Upper_Shroud_Stack_Matl__c+WGBProd.Lower_Stack_Pedestal_Matl__c+WGBProd.Pedestal_Connection__c+WGBOU.IgnitorOpt+WGBOU.FlameSensorOpt+WGBOU.EnclosureOpt+WGBOU.SpecialOpt;

        PartNoList.add(docWrap);
        return PartNoList;
    } */

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
        WizardCostProcessor wcp = new WizardCostProcessor(WGBProd.Id);
        Map<String,List<Cost__c>> getBGRCostData = wcp.getBGRCostData();
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
        
    //  if((fromPage == 'reorder') && (!reorderControl))
    //  saveSelections();
      
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
      //  update WGBProd;
     //   getCosts();
        return null;
    }
    public pageReference ApplyDefaultCost()
    {
        if(WGBProd.Cost_Override__c == false)
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
         //   update WGBProd;
        //    getCosts();
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
    
    // Output Methods

    public static WGB_Outputs__c getWGBOutputRecord(String bgrId)
    {
        List<WGB_Outputs__c> wgbOutputList = new List<WGB_Outputs__c>();
        String fieldsAPIname = FLMutility.getObjectFields('WGB_Outputs__c');
        String soql = 'SELECT '+fieldsAPIname+' FROM WGB_Outputs__c where WasteGasBurner__c =\''+String.escapeSingleQuotes(bgrId)+'\'';
        wgbOutputList = Database.query(soql);//[SELECT id from WGB_Outputs__c where WasteGasBurner__c =:wgbId];
        if(wgbOutputList.size() > 0)
        {
            return wgbOutputList[0];
        }
        WGB_Outputs__c wgboutput = new WGB_Outputs__c();
        return wgboutput;
    }
    public WGB_Outputs__c getPriceWGBOutputInstance()
    {
        WGB_Outputs__c wgboutput = getWGBOutputRecord(WGBProd.Id);
        wgboutput.Alarm__c = null;
        wgboutput.BackUpPowerSupply__c = null;
        wgboutput.Certifications__c = null;
        wgboutput.Enclosure__c = null;
        wgboutput.FlameSensor__c = null;
        wgboutput.Heater__c = null;
        wgboutput.PilotGasRegulator__c = null;
        wgboutput.StackOrifice__c = null;
        wgboutput.StandControl__c = null;
        wgboutput.StepDownTransfer__c = null;
        wgboutput.Sunshield__c = null;
        wgboutput.Price_Total__c = null;

    //    system.debug('WGB output'+wgboutput);
        return wgboutput;
    }

    public decimal TotalWGBPrice{set;get;}
    public decimal TotalWGBPriceOverride{set;get;}
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


    public String selectedTab {get;set;}
    public boolean showPricing{get;set;}
         public pageReference getTabData()
        {
            if(WGBProd.IsConfig__c){
                System.debug('*** selectedTab = '+selectedTab);
                if(selectedTab == 'PricingTab')
                {   
                    showPricing=true;
                    getPricinglist(); 
                    getLeadTimeRec();
                } 
                else if(selectedTab == 'ProductReview')
                {
                    getLeadTimeRec();
                }
                else if(selectedTab == 'Quote')
                {
                    GetQuoteDescriptionRec();
                }
                else if(selectedTab == 'EngineeringTab')
                {
                    GetStructureDetails(); 
                }
                else if(selectedTab == 'Notes')
                {
                    GetTroubleShootingAttributes();
                }                                    
            }
            return null;
        }
    
   public list<priceWrapper > WGBPriceWrapperList{set;get;}

    public class priceWrapper
    {
        public WGB_Price_Detail__c wgbPrice{get; set;}
        public Decimal wgbPriceOverride{get; set;}
        priceWrapper()
        {
            wgbPrice = new WGB_Price_Detail__c();
            wgbPriceOverride = 0.00;
        }
    }
    
    //Pricing Method
    public void getPricinglist() 
    {
        WGBPriceWrapperList.clear();
        getPriceWGBOutputInstance();
        TotalWGBPrice = 0.00;
        TotalWGBPriceOverride = 0.00;
        NonDiscountablePriceEach = 0.00;
        result prncgResult=new result();
        prncgResult=WGBOU.getPricing();
        if(WGBProd.IsConfig__c)
        {
            if(prncgResult.bResult)
            {
                boolean has9999999 = false;
                boolean has8888888 = false;
                
                /***********************************************/
                //Method to find missing price elements
               /* List<String> uniqueListSZC=new List<String>();
                list<WGB_Price_Detail__c> pricelementss=new list<WGB_Price_Detail__c>();
                for(WGB_Price_Detail__c eachFAMB : [SELECT Price__c,Pricing_Element__c,Price_Override__c FROM WGB_Price_Detail__c 
                                                                                                                 order by Pricing_Element__c]){
                        if(!uniqueListSZC.contains(eachFAMB.Pricing_Element__c))
                        {    
                            pricelementss.add(eachFAMB);
                            uniqueListSZC.add(eachFAMB.Pricing_Element__c);
                       }
                }*/
                /***************************/
                list<string> priceelements=new list<string>();                                                                        
                WGB_Outputs__c wgboutput = getWGBOutputRecord(WGBProd.Id);
                 for (sObject sobj:prncgResult.objResultList)
                {
                    WGB_Price_Detail__c  FAPricingRecord = new WGB_Price_Detail__c ();
                    FAPricingRecord = (WGB_Price_Detail__c )sobj;   
                    String fieldAPI;
                    fieldAPI = FAPricingRecord.Component__c;
                        if(FAPricingRecord.Component__c.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                        fieldAPI = fieldAPI+'__c';
                        Decimal priceOverride = 0.00;
                        if(wgbOutput.get(fieldAPI) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            wgbOutput.put(fieldAPI, FAPricingRecord.Price__c);
                            priceOverride = FAPricingRecord.Price__c;
                        }
                        else
                        {
                            if(WGBProd.Price_Engineer_Override__c) {
                            	
                                priceOverride = (Decimal)wgbOutput.get(fieldAPI);
                            } else {
                                
                                wgbOutput.put(fieldAPI, FAPricingRecord.Price__c);
                                priceOverride = FAPricingRecord.Price__c;
                            }
                        }
                        TotalWGBPrice += FAPricingRecord.Price__c;
                        if(priceOverride == 9999999)
                        {
                            has9999999 = true;
                            TotalWGBPriceOverride = 9999999.00;
                        }
                        /*if(priceOverride == 8888888 && has9999999==false)
                        {
                            has8888888 = true;
                            TotalWGBPriceOverride = 8888888;
                        }*/
                        if(has9999999 == false)
                        {
                            TotalWGBPriceOverride += priceOverride.setScale(2);
                        }
                        
                        priceWrapper priceWrapperInstance = new priceWrapper();
                        priceWrapperInstance.wgbPrice = FAPricingRecord;
                        priceWrapperInstance.wgbPriceOverride = priceOverride.setScale(2);
                        WGBPriceWrapperList.add(priceWrapperInstance);
                        System.debug('WGBPriceWrapperList------' +WGBPriceWrapperList);
                        //RVPricingList.add(RVPricingRecord);                    
                   
                }
                
                /*
                for (sObject sobj1:pricelementss)
                {
                    WGB_Price_Detail__c  FAPricingRecord2 = new WGB_Price_Detail__c ();
                    FAPricingRecord2 = (WGB_Price_Detail__c )sobj1;                    
                      if(!priceelements.contains(FAPricingRecord2.Pricing_Element__c))
                        {                            
                            FAPricingRecord2.Price_Override__c = 8888888.00;
                            FAPricingRecord2.Price__c = 8888888.00; 
                           
                            if(has9999999 == false) //FAPricingRecord2.Price_Override__c == 8888888 &&
                            {
                                has8888888 = true;    
                                TotaWGBPriceOverride = 8888888.00;
                            }                          
                            FAPricingList.add(FAPricingRecord2);
                          //  uniqueListprice.add(FAPricingRecord2.Pricing_Element__c);
                        } 
                    
                }       */      
                
                if(WGBProd.Quantity__c != null && WGBProd.Quantity__c != 0)
                {
                    if(has9999999==false){
                            ListPriceEach=(TotalWGBPriceOverride + ( NonDiscountablePriceEach / WGBProd.Quantity__c)).setscale(2);
                            WGBProd.List_Price_Each__c = ListPriceEach;
                        System.debug('Price List Each---Normal' +WGBProd.List_Price_Each__c);
                            WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                        }      // && has8888888==false
                    else if(has9999999==true)
                    {
                        ListPriceEach = TotalWGBPriceOverride;
                        WGBProd.List_Price_Each__c=ListPriceEach;
                        System.debug('Price List Each---999999999' +WGBProd.List_Price_Each__c);
                        WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                    } 
                   /* else if(has8888888==true){
                        ListPriceEach = TotalWGBPriceOverride;
                        WGBProd.List_Price_Each__c=ListPriceEach;
                        WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                    }*/
                    WGBProd.Non_Discountable_Price__c = NonDiscountablePriceEach;
                }
            }
        }       
    }

    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultPricing()
    {
        boolean has9999999=false;
        boolean has8888888=false;
        WGB_Outputs__c wgbOutput = getWGBOutputRecord(WGBProd.Id);
        if(WGBProd.Price_Engineer_Override__c == false && WGBPriceWrapperList != null && WGBPriceWrapperList.size() > 0)
        {
            TotalWGBPrice = 0.00;
            TotalWGBPriceOverride = 0.00;
            for(priceWrapper prv : WGBPriceWrapperList)
            {
                if(String.isNotBlank(prv.wgbPrice.Component__c))
                {
                    String fieldAPI = prv.wgbPrice.Component__c;
                    if(prv.wgbPrice.Component__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    fieldAPI = fieldAPI+'__c';
                    
                    wgbOutput.put(fieldAPI, prv.wgbPrice.Price__c);
                    if(prv.wgbPrice.Price__c != 9999999)
                    {
                        TotalWGBPrice += prv.wgbPrice.Price__c;
                        TotalWGBPriceOverride += prv.wgbPrice.Price__c;
                    }
                }
            }
            
             if(WGBProd.Quantity__c != null && WGBProd.Quantity__c != 0)
                {
                    if(has9999999==false){
                            ListPriceEach=TotalWGBPriceOverride + ( NonDiscountablePriceEach / WGBProd.Quantity__c);
                            WGBProd.List_Price_Each__c = ListPriceEach;
                        System.debug('Price List Each---Normal' +WGBProd.List_Price_Each__c);
                            WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                        }      // && has8888888==false
                    else if(has9999999==true)
                    {
                        ListPriceEach = TotalWGBPriceOverride;
                        WGBProd.List_Price_Each__c=ListPriceEach;
                        System.debug('Price List Each---999999999' +WGBProd.List_Price_Each__c);
                        WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                    } 
                  /*  else if(has8888888==true){
                        ListPriceEach = TotalWGBPriceOverride;
                        WGBProd.List_Price_Each__c=ListPriceEach;
                        WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                    }*/
                    WGBProd.Non_Discountable_Price__c = NonDiscountablePriceEach;
                   // update WGBProd;
                }
            upsert wgbOutput;
        }
        update WGBProd;
        getPricinglist();
        return null;       
    }

    
    //* @ Save Price Override on click on save
    Public pageReference SavePriceOverride()
    {
        boolean has9999999=false;
        boolean has8888888=false;
        WGB_Outputs__c wgbOutput = getWGBOutputRecord(WGBProd.Id);
        if(WGBPriceWrapperList != null && WGBPriceWrapperList.size() > 0)
        {
            TotalWGBPriceOverride = 0.0;
            //RV_Outputs__c rvOutsideInstance = getPriceRVOutputInstance();
            for(priceWrapper prv : WGBPriceWrapperList)
            {
                if(String.isNotBlank(prv.wgbPrice.Component__c))
                {
                    String fieldAPI = prv.wgbPrice.Component__c;
                    if(prv.wgbPrice.Component__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    fieldAPI = fieldAPI+'__c';
                    
                    wgbOutput.put(fieldAPI, prv.wgbPriceOverride);
                    System.debug('---> fieldAPI = '+fieldAPI+', prv.wgbPriceOverride = '+wgbOutput.get(fieldAPI));
                  /*  if(prv.wgbPrice.Price__c != 9999999 && prv.wgbPrice.Price__c != 8888888)
                    {
                        TotalWGBPrice += prv.wgbPrice.Price__c;
                        TotalWGBPriceOverride += prv.wgbPrice.Price__c;
                    }*/
                    if(prv.wgbPriceOverride != 9999999) // && prv.wgbPriceOverride != 8888888
                    {
                        TotalWGBPriceOverride += prv.wgbPriceOverride;
                    }
                    if(prv.wgbPriceOverride == 9999999)
                    {
                        has9999999=true;
                        TotalWGBPriceOverride=9999999.00;
                    }                    
                   /* if(prv.wgbPriceOverride == 8888888 && has9999999==false){
                        has8888888=true;
                        TotalWGBPriceOverride=8888888.00;
                    }*/
                    
                    wgbOutput.Price_Total__c = TotalWGBPriceOverride;
                }
            }
            
            if(WGBProd.Quantity__c != null && WGBProd.Quantity__c != 0)
            {
                if(has9999999==false){
                            ListPriceEach=TotalWGBPriceOverride + ( NonDiscountablePriceEach / WGBProd.Quantity__c);
                            WGBProd.List_Price_Each__c = ListPriceEach;
                            WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                        }      // && has8888888==false
                   else if(has9999999==true)
                    {
                        ListPriceEach = 9999999.00;
                        TotalWGBPriceOverride=9999999.00;
                        WGBProd.List_Price_Each__c=ListPriceEach;
                        WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                    } 
                  /*  else if(has8888888==true){
                        ListPriceEach = 8888888.00;
                        TotalWGBPriceOverride=8888888.00;
                        WGBProd.List_Price_Each__c=ListPriceEach;
                        WGBProd.Discountable_Price__c = TotalWGBPriceOverride;
                    }*/
                    WGBProd.Non_Discountable_Price__c = NonDiscountablePriceEach;
            }
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Non_Discountable_List_Price__c =  WGBProd.Non_Discountable_Price__c/WGBProd.Quantity__c;
                quoteLine.Discountable_List_Price__c = WGBProd.Discountable_Price__c;
                upsert quoteLine;
            }
            upsert wgbOutput;         
            update WGBProd;
        }
        return null;
    }


    // Price Review Tab Wrapper
    public class PriceReviewWrapper
    {
        public string strPricing {set;get;}
        public string strTotal {set;get;}
    }
    public list<PriceReviewWrapper> getPrice()
    {
        list<PriceReviewWrapper> PriceWrapList=new list<PriceReviewWrapper>();

        PriceReviewWrapper docWrap=new PriceReviewWrapper();
        docWrap.strPricing  = String.Valueof(TotalWGBPriceOverride);
        docWrap.strTotal='Total';
        PriceWrapList.add(docWrap);
        return PriceWrapList;
    }


    public WGB_Outputs__c getLeadWGBOutputInstance()
    {
        WGB_Outputs__c wgboutput = getWGBOutputRecord(WGBProd.Id);
        wgboutput.Lead_Time_10_Override__c = '';
        wgboutput.Lead_Time_20_Override__c = '';
        wgboutput.Lead_Time_30_Override__c = '';
        wgboutput.Lead_Time_40_Override__c = '';

        return wgboutput;
    }   
   
    public list<LeadWrapper> WGBLeadWrapperList{set;get;}

    public class LeadWrapper
    {
        public WGB_LeadTime__c wgbleadrecord{get; set;}
      //  public Decimal faPriceOverride{get; set;}
        public Decimal wgbsite10{get; set;}
        public Decimal wgbsite20{get; set;}
        public Decimal wgbsite30{get; set;}
        public Decimal wgbsite40{get; set;}
        LeadWrapper()
        {
            wgbleadrecord = new WGB_LeadTime__c();
            wgbsite10 = 0.00;
            wgbsite20 = 0.00;
            wgbsite30 = 0.00;
            wgbsite40 = 0.00;
        }
    }
    public void GetLeadTimeRec() 
    {       
        WGBLeadWrapperList.clear();
        Total10=0.0;
        Total20=0.0;
        Total30=0.0;
        Total40=0.0;
        Total10Override = 0.0;
        Total20Override = 0.0;
        Total30Override = 0.0;
        Total40Override = 0.0;
        result res=new result();
        res=WGBOU.getLeadTime();
        if(WGBProd.IsConfig__c)
        {
            if(res.bResult)
            {                
                
                WGB_Outputs__c wgbOutput = getWGBOutputRecord(WGBProd.Id);
                 for(sObject sobj:res.objResultList)
                {
                    WGB_LeadTime__c WGBLeadTimeRec = new WGB_LeadTime__c();
                    WGBLeadTimeRec = (WGB_LeadTime__c)sobj;
                    WGBLeadTimeRec.Schedule__c=WGBLeadTimeRec.Schedule__c; 
                    String fieldAPI10;
                    String fieldAPI20;
                    String fieldAPI30;
                    String fieldAPI40;
                        //Site 10 Calculation
                        fieldAPI10 = 'X10';
                        if(WGBLeadTimeRec.X10__c==null)
                        {
                            fieldAPI10 = fieldAPI10.replace(' ', '_');
                        }
                    
                        fieldAPI10 = fieldAPI10+'__c';
                        Decimal Site10Override = 0.00;
                        if(wgbOutput.get(fieldAPI10) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            wgbOutput.put(fieldAPI10, WGBLeadTimeRec.X10__c);
                            Site10Override = WGBLeadTimeRec.X10__c;
                            Total10Override=Site10Override;
                        }
                        else
                        {
                            if(WGBProd.Lead_Time_Engineer_Override__c) {
                            	
                                Site10Override = (Decimal)wgbOutput.get(fieldAPI10);
                            	Total10Override=Site10Override;
                                
                            } else {
                                
                                Site10Override = WGBLeadTimeRec.X10__c;
                            	Total10Override=Site10Override;
                            }
                        }                    
                        
                        //Site 20 Calculation
                        fieldAPI20 = 'X20';
                        if(WGBLeadTimeRec.X20__c==null)
                        {
                            fieldAPI20 = fieldAPI20.replace(' ', '_');
                        }
                    
                        fieldAPI20 = fieldAPI20+'__c';
                        Decimal Site20Override = 0.00;
                        if(wgbOutput.get(fieldAPI20) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            wgbOutput.put(fieldAPI20, WGBLeadTimeRec.X20__c);
                            Site20Override = WGBLeadTimeRec.X20__c;
                            Total20Override=Site20Override;
                        }
                    
                        else
                        {
                            if(WGBProd.Lead_Time_Engineer_Override__c) {
                                Site20Override = (Decimal)wgbOutput.get(fieldAPI20);
                                Total20Override=Site20Override;
                            } else {
                                
                                Site20Override = WGBLeadTimeRec.X20__c;
                                Total20Override=Site20Override;
                            }
                        }       
                        
                        //Site 30 Calculation
                        fieldAPI30 = 'X30';
                        if(WGBLeadTimeRec.X30__c==null)
                        {
                            fieldAPI30 = fieldAPI30.replace(' ', '_');
                        }
                    
                        fieldAPI30 = fieldAPI30+'__c';
                        Decimal Site30Override = 0.00;
                        if(wgbOutput.get(fieldAPI30) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            wgbOutput.put(fieldAPI30, WGBLeadTimeRec.X30__c);
                            Site30Override = WGBLeadTimeRec.X30__c;
                            Total30Override=Site30Override;
                        }
                        else
                        {
                            if(WGBProd.Lead_Time_Engineer_Override__c) {
                                Site30Override = (Decimal)wgbOutput.get(fieldAPI30);
                                Total30Override=Site30Override;
                            } else {
                                Site30Override = WGBLeadTimeRec.X30__c;
                                Total30Override=Site30Override;
                            }
                        }       
                        
                        //Site 40 Calculation
                        fieldAPI40 = 'X40';
                        if(WGBLeadTimeRec.X40__c==null)
                        {
                            fieldAPI40 = fieldAPI40.replace(' ', '_');
                        }
                    
                        fieldAPI40 = fieldAPI40+'__c';
                        Decimal Site40Override = 0.00;
                        if(wgbOutput.get(fieldAPI40) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            wgbOutput.put(fieldAPI40, WGBLeadTimeRec.X40__c);
                            Site40Override = WGBLeadTimeRec.X40__c;
                            Total40Override=Site40Override;
                        }
                        else
                        {
                            if(WGBProd.Lead_Time_Engineer_Override__c) {
                                Site40Override = (Decimal)wgbOutput.get(fieldAPI40);
                                Total40Override=Site40Override;
                            } else {
                                
                                Site40Override = WGBLeadTimeRec.X40__c;
                                Total40Override=Site40Override;
                            }
                        }       
                    
                        LeadWrapper LeadWrapperInstance = new LeadWrapper();
                        LeadWrapperInstance.wgbleadrecord=WGBLeadTimeRec;
                        System.debug('@@@@Lead10' +Site10Override);
                        System.debug('@@@@Lead20' +Site20Override);
                        System.debug('@@@@Lead30' +Site30Override);
                        System.debug('@@@@Lead40' +Site40Override);
                        LeadWrapperInstance.wgbsite10 = Site10Override.setScale(2);
                        LeadWrapperInstance.wgbsite20 = Site20Override.setScale(2);
                        LeadWrapperInstance.wgbsite30 = Site30Override.setScale(2);
                        LeadWrapperInstance.wgbsite40 = Site40Override.setScale(2);
                        System.debug('LLLLLLLLL' +LeadWrapperInstance);
                        WGBLeadWrapperList.add(LeadWrapperInstance);
                    
                        WGBProd.Lead_Time_Site_10__c = Total10Override;
                        WGBProd.Lead_Time_Site_20__c = Total20Override;
                        WGBProd.Lead_Time_Site_30__c = Total30Override;
                        WGBProd.Lead_Time_Site_40__c = Total40Override;
                        //RVPricingList.add(RVPricingRecord);                    
                   
                }                                                  
            }
        }       
    }

    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultLeadtime()
    {
        WGB_Outputs__c wgbOutput = getWGBOutputRecord(WGBProd.Id);
        System.debug('VVVVVV ---WGBProd Id---' +WGBProd.Id);
        if(WGBProd.Lead_Time_Engineer_Override__c == false && WGBLeadWrapperList != null && WGBLeadWrapperList.size() > 0)
        {
            for(LeadWrapper prv : WGBLeadWrapperList)
            {
                if(prv.wgbleadrecord.X10__c!=null)
                {
                    String fieldAPI10 = 'X10';
                  /*  if(prv.wgbleadrecord.X10__c.contains(' '))
                    {
                        fieldAPI10 = fieldAPI10.replace(' ', '_');
                    }   */                 
                    fieldAPI10 = fieldAPI10+'__c';
                    
                    wgboutput.put(fieldAPI10, prv.wgbleadrecord.X10__c);                    
                }
                if(prv.wgbleadrecord.X20__c!=null)
                {
                    String fieldAPI20 = 'X20';
                  /*  if(prv.wgbleadrecord.X20__c.contains(' '))
                    {
                        fieldAPI20 = fieldAPI20.replace(' ', '_');
                    }    */                
                    fieldAPI20 = fieldAPI20+'__c';
                    
                    wgboutput.put(fieldAPI20, prv.wgbleadrecord.X20__c);                    
                }
                if(prv.wgbleadrecord.X30__c!=null)
                {
                    String fieldAPI30 ='X30';
                  /*  if(prv.wgbleadrecord.X30__c.contains(' '))
                    {
                        fieldAPI30 = fieldAPI30.replace(' ', '_');
                    }      */              
                    fieldAPI30 = fieldAPI30+'__c';
                    
                    wgboutput.put(fieldAPI30, prv.wgbleadrecord.X30__c);                    
                }
                if(prv.wgbleadrecord.X40__c!=null)
                {
                    String fieldAPI40 ='X40';
                  /*  if(prv.wgbleadrecord.X40__c.contains(' '))
                    {
                        fieldAPI40 = fieldAPI40.replace(' ', '_');
                    }     */               
                    fieldAPI40 = fieldAPI40+'__c';
                    
                    wgboutput.put(fieldAPI40, prv.wgbleadrecord.X40__c);                    
                }
            }
          //  GetLeadTimeRec();             
            upsert wgboutput;
        }
        update WGBProd;
        GetLeadTimeRec();
        return null;       
    }
    //* @ Save Price Override on click on save
    Public pageReference SaveLeadTimeOverride()
    {        
        WGB_Outputs__c wgboutput = getwgboutputRecord(WGBProd.Id);
        if(WGBLeadWrapperList != null && WGBLeadWrapperList.size() > 0)
        {
            for(LeadWrapper prv : WGBLeadWrapperList)
            {
                if(prv.wgbsite10!=null && prv.wgbsite20!=null && prv.wgbsite30!=null && prv.wgbsite40!=null)
                {
                    String fieldAPI10 = 'X10';
                    if(prv.wgbleadrecord.X10__c==null)
                    {
                        fieldAPI10 = fieldAPI10.replace(' ', '_');
                    }
                    
                    fieldAPI10 = fieldAPI10+'__c';
                    
                    wgboutput.put(fieldAPI10, prv.wgbsite10);    
                    Total10Override=prv.wgbsite10;
                    String fieldAPI20 = 'X20';
                    if(prv.wgbleadrecord.X20__c==null)
                    {
                        fieldAPI20 = fieldAPI20.replace(' ', '_');
                    }
                    
                    fieldAPI20 = fieldAPI20+'__c';
                    
                    wgboutput.put(fieldAPI20, prv.wgbsite20);  
                    Total20Override=prv.wgbsite20;
                    String fieldAPI30 = 'X30';
                    if(prv.wgbleadrecord.X30__c==null)
                    {
                        fieldAPI30 = fieldAPI30.replace(' ', '_');
                    }
                    
                    fieldAPI30 = fieldAPI30+'__c';
                    
                    wgboutput.put(fieldAPI30, prv.wgbsite30);  
                    Total30Override=prv.wgbsite30;
                    String fieldAPI40 = 'X40';
                    if(prv.wgbleadrecord.X40__c==null)
                    {
                        fieldAPI40 = fieldAPI40.replace(' ', '_');
                    }
                    
                    fieldAPI40 = fieldAPI40+'__c';
                    
                    wgboutput.put(fieldAPI40, prv.wgbsite40); 
                    Total40Override=prv.wgbsite40;
                }                
            }
            WGBProd.Lead_Time_Site_10__c = Total10Override;
            WGBProd.Lead_Time_Site_20__c = Total20Override;
            WGBProd.Lead_Time_Site_30__c = Total30Override;
            WGBProd.Lead_Time_Site_40__c = Total40Override;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Leadtime_Site_10__c=(wgboutput.X10__c);
                quoteLine.Leadtime_Site_20__c=(wgboutput.X20__c);
                quoteLine.Leadtime_Site_30__c=(wgboutput.X30__c);
                quoteLine.Leadtime_Site_40__c=(wgboutput.X40__c);
                if(!Test.isRunningTest())
                    update quoteLine;
            }
            upsert wgboutput;           
            update WGBProd;
        }
        return null;
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
        Attr = WGBOU.getTroubleShootingWGBAttr();

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

    public WGB_Outputs__c getQuoteWGBOutputInstance()
    {
        WGB_Outputs__c wgbOutput = getWGBOutputRecord(WGBProd.Id);
      //  if(String.isBlank(wgbOutput.id)|| wgbOutput.id!=null)
      //  {
           // wgbOutput.WasteGasBurner__c = WGBProd.Id;
            wgbOutput.OA02__c=null;
            wgbOutput.OA03__c=null;
            wgbOutput.OA04__c=null;
            wgbOutput.OA05__c=null;
            wgbOutput.OA06__c=null;

            wgbOutput.OB010__c = null;
            wgbOutput.OB020__c = null;
            wgbOutput.OB030__c = null;
            wgbOutput.OB040__c = null;
            wgbOutput.OB050__c = null;
            wgbOutput.OB060__c = null;
            wgbOutput.OB070__c = null;
            wgbOutput.OB080__c = null;
            wgbOutput.OB090__c = null;
            wgbOutput.OB100__c = null;
            wgbOutput.OB110__c = null;
            wgbOutput.OB120__c = null;
            wgbOutput.OB130__c = null;
            wgbOutput.OB140__c = null;
            wgbOutput.OB150__c = null;
            wgbOutput.OB160__c = null;
            wgbOutput.OB170__c = null;
            wgbOutput.OB180__c = null;
            wgbOutput.OB190__c = null;
            wgbOutput.OB200__c = null;
            wgbOutput.OB210__c = null;
            wgbOutput.OB220__c = null;
            wgbOutput.OB230__c = null;
            wgbOutput.OB240__c = null;
            wgbOutput.OB250__c = null;
            wgbOutput.OB450__c = null;
     //   }

        return wgbOutput;
    }


  // Quote Description Method
//-----------------------------------------------------------------------------------------
public string OBval1{set;get;}
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
    public WGB_Outputs__c wgbOutsideInstance;
    Public List<QuoteDescriptionWrapper> quoteDescriptionList{get;set;}
    public list<QuoteDescriptionWrapper> GetQuoteDescriptionRec()
    {
        quoteAttriVsDesc = new Map<String, String>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        quoteAttriVsDesc = WGBOU.GetAttributeMapQuoteDescription();
        wgbOutsideInstance = getQuoteWGBOutputInstance();
       /* if(WGBProd.Quote_Description_Engineer_Override__c == false)
        {
            WGBProd.OA01__c = 'Model:'+WGBOU.GMODEL;
        }
        else
        {
            WGBProd.OA01__c = 'Special Model:'+WGBOU.GMODEL;

        }*/

      //  WGBProd.OA01__c=WGBOU.OA01;
        WGBProd.OA01__c = 'Model: '+WGBOU.GMODEL;
        for(String attribute: quoteAttriVsDesc.keySet())
        {
           System.debug('@@@@ attribute = '+attribute);
           String attributeFieldAPI = attribute+'__c';
           WGBProd.put(attributeFieldAPI,quoteAttriVsDesc.get(attribute));
           System.debug('@@@@ attributeFieldAPI = '+attributeFieldAPI+', conwgb value = '+WGBProd.get(attributeFieldAPI));
        }
        WGBProd.OA__c = WGBProd.OA01__c;
        WGBProd.OB__c = '';
        for(String attribute: quoteAttriVsDesc.keySet())
        {
                String attributeValue = WGBProd.get(attribute+'__c')+'';
                System.debug('@@@@ attribute = '+attribute+'__c, value = '+attributeValue);
                if(attribute.startsWith('OA') && String.isNotBlank(attributeValue))
                {
                    WGBProd.OA__c += '\n' + attributeValue;
                }
                else if(attribute.startsWith('OB') && String.isNotBlank(attributeValue))
                {
                    string strValOB170=attributeValue;
                 //   string checkOB170='No',strOB170val='';
                    if(attributeValue.contains('[') && attributeValue.contains(']'))
                    {
                        //Pilot Supply Pressure: [PilotSupplyPressConverted] in. water
                        string strOB170 = '';
                        if(attributeValue!=null)
                        {
                            strOB170 = attributeValue.substringBetween('[',']');
                        }
                        if(string.isBlank(strOB170) || strOB170 == null)
                        {
                            attributeValue = attributeValue;
                        }
                        else
                        {
                            attributeValue = WGBOU.mapWGBAttr.get(strOB170);
                        }
                        String strSplitOB170 =strValOB170;
                        String[] arrPTC  = strSplitOB170.split('\\[');
                        String strPTC1  = arrPTC[0];
                        String strPTC2  = arrPTC[1];
                        String str2SplitOB170 =strPTC2;
                        String[] arrPTC2  = str2SplitOB170.split('\\]');
                        String strPTC4  = arrPTC2[1];
                        attributeValue=strPTC1+attributeValue+strPTC4;
                        WGBProd.OB170__c=attributeValue;
                   //     System.debug('OB170 After updating WGBProd.OB170__c'+WGBProd.OB170__c);
                   //     System.debug('OB170+++++++'+attributeValue);
                    }
                    else
                        System.debug('AAA');
                   // if(checkOB170=='yes')
                    //    attributeValue=strOB170val;

                    if(String.isBlank(WGBProd.OB__c))
                    {
                        WGBProd.OB__c = attributeValue;
                    }
                    else
                    {
                     //   System.debug('OB170------'+attributeValue);
                        WGBProd.OB__c += '\n' + attributeValue;
                    }
                }
            }
        //System.debug('@@@ Model = '+WGBProd.Model__c+', setBlankForNull(WGBProd.OA01__c) = '+setBlankForNull(WGBProd.OA01__c)+', setBlankForNull(WGBProd.OA02__c) = '+setBlankForNull(WGBProd.OA02__c)+', setBlankForNull(WGBProd.OA04__c) = '+setBlankForNull(WGBProd.OA04__c));
        //WGBProd.OA__c = setBlankForNull(WGBProd.OA01__c)+'\n'+ setBlankForNull(WGBProd.OA02__c) + '\n ' + setBlankForNull(WGBProd.OA04__c); //Merging all the OA
        //WGBProd.OB__c = setBlankForNull(WGBProd.OB010__c)+'test '+setBlankForNull(WGBProd.OB050__c)+'\n'+setBlankForNull(OB250p1+'')+setBlankForNull(WGBProd.Setting__c+'')+'\n '+setBlankForNull(WGBProd.Setting_Units__c)+'('+setBlankForNull(OB250p2)+')'+' \n'+setBlankForNull(WGBProd.OB310__c)+' '+setBlankForNull(WGBProd.OB320__c)+'\n '+setBlankForNull(WGBProd.OB410__c)+' \n'+setBlankForNull(WGBProd.OB420__c); //Merging all the OB

        OBval1 = WGBProd.OA__c+' '+WGBProd.OB__c;

        Set<String> quotesAttributeSet = new Set<String>{'OA','OB'};
        for(String quoteAttribute: quotesAttributeSet)
        {
            String fieldAPI = quoteAttribute+'__c';
            String quoteRow = (String)WGBProd.get(fieldAPI);
        //    System.debug('@@@@ fieldAPI = '+fieldAPI+', quoteRow = '+quoteRow);
            if(String.isNotBlank(quoteRow))
            {
                QuoteDescriptionWrapper quoteDescription = new QuoteDescriptionWrapper();
                quoteDescription.quotes = quoteAttribute;
                quoteDescription.descriptionList = new List<String>();
                quoteDescription.overridedescriptionList = new List<String>();
                String descriptionValue = WGBProd.get(fieldAPI)+'';
                for(String dec : descriptionValue.split('\n'))
                {
                    quoteDescription.descriptionList.add(dec);
                }
                quoteDescription.description = WGBProd.get(fieldAPI)+'';
         //       System.debug('@@@@ wgbOutsideInstance = '+wgbOutsideInstance.get(quoteAttribute+'_Override__c'));
                if(wgbOutsideInstance.get(quoteAttribute+'_Override__c') == null)
                {
                    quoteDescription.overrideDescription = WGBProd.get(fieldAPI)+'';
                    wgbOutsideInstance.put(quoteAttribute+'_Override__c', quoteDescription.overrideDescription);
                }
                else
                {
                    quoteDescription.overrideDescription = (String)wgbOutsideInstance.get(quoteAttribute+'_Override__c');
                }
                if(WGBProd.Quote_Description_Engineer_Override__c == true && quoteAttribute == 'OA')
                {
                    quoteDescription.overrideDescription = quoteDescription.overrideDescription;      //'Special '+WGBOU.GMODEL;
                }
                for(String dec : quoteDescription.overrideDescription.split('\n'))
                  {
                      quoteDescription.overridedescriptionList.add(dec);
                  }
                quoteDescriptionList.add(quoteDescription);
            }
        }
        //update wgbOutsideInstance;
      //  system.debug('***Quote Desc'+BGRQuoteDescList);
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
        if(WGBProd.Quote_Description_Engineer_Override__c == false)
        {
            Set<String> quotesAttributeSet = new Set<String>{'OA','OB'};
            for(String quoteAttribute: quotesAttributeSet)
            {
                String attributeFieldAPI = quoteAttribute+'_Override__c';
                String attributeValue = (String)WGBProd.get(quoteAttribute+'__c');
                wgbOutsideInstance.put(attributeFieldAPI, attributeValue);
            }
            update wgbOutsideInstance;
            if(!Test.isRunningTest()) 
            {
                if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    quoteLine.SBQQ__Description__c=strquoteDes;
                    upsert quoteLine;
                }
            }
            WGBProd.Part_Number_Base__c=WGBProd.Part_Number_Base_Original__c;
        }
        else
        {
            WGBProd.ASSYPARTEXISTING__c = '';
        }
        update WGBProd;
       ////  disableButton = (!showsales) && WGBProd.Quote_Description_Engineer_Override__c;
        /*List<SBQQ__QuoteLine__c> quoteId = [select SBQQ__Quote__c from SBQQ__QuoteLine__c where Id = :WGBProd.Quote_Line__c];
        List<SBQQ__Quote__Share> quoteSharelst = new List<SBQQ__Quote__Share>();
   for(SBQQ__Quote__Share quoteShare : [select id,ParentId, AccessLevel,RowCause,UserOrGroup.name,UserOrGroup.Profile.name from SBQQ__Quote__Share
                                              where UserOrGroup.Profile.Name in ('CDC Inside Sales','CDC Prod. Planning','CDC Partner Community Users Profile')
                                              and RowCause<>'Owner' and ParentId = :quoteId.get(0).SBQQ__Quote__c]){

       if(!WGBProd.Quote_Description_Engineer_Override__c)  {
               quoteShare.AccessLevel = 'Edit';
               quoteSharelst.add(quoteShare);

       }else{
           quoteShare.AccessLevel = 'Read';
           quoteSharelst.add(quoteShare);WGBProd
       }
       }*/
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
                wgbOutsideInstance.put(attributeFieldAPI, bgqd.overrideDescription);
            }
            if(String.isNotBlank(wgbOutsideInstance.Id))
            {
                update wgbOutsideInstance;
            }
            update wgbOutsideInstance;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        }
        return null;
    }


//-----------------------------------------------------------------------------------------

    //PartNumber generation Method
    public void generatePartNumber()
    {

        WGBProd.Part_Number_Base__c = WGBProd.ASSYPARTNOBASE__c;
        Result partNumberResult = AssyPartDefinationProcessor.generatePartNumber(WGBProd);
        if(partNumberResult.bResult ==  true)
        {
            WGBProd.ASSYPARTEXISTING__c = partNumberResult.strRetValue;
            WGBProd.Part_Number__c = WGBProd.ASSYPARTEXISTING__c;
        }
        //addQliSyncFlag(qli);
        update WGBProd;
    }




    // Struture method
    public class structureWrapper
    {
        public string strComponent {set;get;}
        public string strLineItemNo {set;get;}
        public string strComponentPart {set;get;}
        public string strQtrPerAssembly {set;get;}                      
        public string strScrapFactor {set;get;}
        public string strComponentScrap {set;get;}  

    }

    public list<structureWrapper> getStructureDetails() {
        list<structureWrapper> strucWrapList=new list<structureWrapper>();        
        
        if (WGBProd.IsConfig__c)
        {        
            result res=new result();
            res=WGBOU.getStructure();
            System.debug('EEEEEEEException' +res.bResult);
            if(res.bResult) 
            {
                List<Integer> aList = new List<Integer>();
    
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('Line_Item_No__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);         
                }
                aList.sort();
                for(Integer a: aList)
                {           
                    for (sObject sobj:res.objResultList)
                    {                    
                        string a2=(string) sobj.get('Line_Item_No__c');
                        Integer i2=integer.valueOf(a2);
                            if(a==i2)
                            {
                                structureWrapper stWrap=new structureWrapper();
                                stWrap.strLineItemNo = (string) sobj.get('Line_Item_No__c');
                                stWrap.strComponent = (string) sobj.get('Component__c');
                                stWrap.strComponentPart = (string) sobj.get('Part_Number__c');
                                stWrap.strQtrPerAssembly = (string) sobj.get('Qty_per_Assembly__c');                
                                stWrap.strScrapFactor = (string) sobj.get('Scrap_Factor__c');
                                stWrap.strComponentScrap = (string) sobj.get('Component_Scrap__c');                                
                                strucWrapList.add(stWrap);
                            }                                         
                     }
                }
            }        
        }
        return strucWrapList;
    }

    // control method
    public class ControlWrapper
    {
        public string strTEST_OPERATION_DESC{set;get;}
        public string strNORM_TYPE{set;get;}
        public string strOperation_Number{set;get;}
        public string strDATA_TYPE{set;get;}
        public string strCATEGORY_ID{set;get;}
        public string strINSPECTION_CODE{set;get;}
        public string strSAMPLE_PERCENT{set;get;}
        public string strProcess_Characteristic{set;get;}
        public string strOUTER_MIN{set;get;}
        public string strINNER_MIN{set;get;}
        public string strNOMINAL_VALUE{set;get;}
        public string strINNER_MAX{set;get;}
        public string strOUTER_MAX{set;get;}
        public string strTool_ID{set;get;}
        public string strData_Point{set;get;}
        public string strTest_OpNo{set;get;}
    }

    public list<ControlWrapper> getControlPlanDetails() {
        list<ControlWrapper> controlWrapList=new list<ControlWrapper>();
        
        if(WGBProd.IsConfig__c)
        {
            result res=new result();
            res=WGBOU.getControlPlan();
            if(res.bResult)
            {
            List<Integer> aList = new List<Integer>();
    
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('Test_OPNO__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);         
                }
                aList.sort();
                for(Integer a: aList)
                {           
                    for (sObject sobj:res.objResultList)
                    {                    
                        string a2=(string) sobj.get('Test_OPNO__c');
                        Integer i2=integer.valueOf(a2);
                            if(a==i2)
                            {
                                ControlWrapper ctrlWrap=new ControlWrapper();
                                ctrlWrap.strTEST_OPERATION_DESC =(string) sobj.get('TEST_OPERATION_DESC__c');
                                ctrlWrap.strNORM_TYPE=(string) sobj.get('NORM_TYPE__c');
                                ctrlWrap.strOperation_Number=(string) sobj.get('Operation_Number__c');
                                ctrlWrap.strCATEGORY_ID=(string) sobj.get('CATEGORY_ID__c');
                                ctrlWrap.strINSPECTION_CODE=(string) sobj.get('INSPECTION_CODE__c');
                                ctrlWrap.strSAMPLE_PERCENT=(string) sobj.get('SAMPLE_PERCENT__c');
                                ctrlWrap.strProcess_Characteristic=(string) sobj.get('Process_Characteristic__c');
                                ctrlWrap.strOUTER_MIN=(string) sobj.get('OUTER_MIN__c');
                                ctrlWrap.strINNER_MIN=(string) sobj.get('INNER_MIN__c');
                                ctrlWrap.strNOMINAL_VALUE=(string) sobj.get('NOMINAL_VALUE__c');
                                ctrlWrap.strINNER_MAX=(string) sobj.get('INNER_MAX__c');
                                ctrlWrap.strOUTER_MAX=(string) sobj.get('OUTER_MAX__c');
                                ctrlWrap.strTool_ID=(string) sobj.get('Tool_ID__c');
                                ctrlWrap.strData_Point=(string) sobj.get('Data_Point__c');
                                ctrlWrap.strDATA_TYPE=(string) sobj.get('DATA_TYPE__c');
                                ctrlWrap.strTest_OpNo=(string) sobj.get('Test_OPNO__c');
                                controlWrapList.add(ctrlWrap);
                            }                                         
                     }
                }
            }
        }        
        return controlWrapList;
    }

    public class WorkGuideLineWrapper
    {
        public string strOperation {set;get;}
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
        public string strGuidline_Seq{set;get;}
        public string strDescription {set;get;}
         public string strText {set;get;}
         public string strType {set;get;}
         public string strSign_Off {set;get;}
         public string strInspection_Sign_Off_Required {set;get;}

    }
       public list<WorkGuideLineWrapper> getWorkGuideLines() {
        list<WorkGuideLineWrapper> workguildeWrapList=new list<WorkGuideLineWrapper>();
                   
        if(WGBProd.IsConfig__c)
        {
            result res=new result();
            res=WGBOU.getWorkGuideLines();

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
                    for (sObject sobj:res.objResultList)
                    {                    
                        string a2=(string) sobj.get('Operation__c');
                        Integer i2=integer.valueOf(a2);
                            if(a==i2)
                            {
                                WorkGuideLineWrapper stWrap=new WorkGuideLineWrapper();
                                stWrap.strOperation = (string) sobj.get('Operation__c');
                                stWrap.strStandard_Operation_ID = (string) sobj.get('Standard_Operation_ID__c');
                                stWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                                stWrap.strGuidline_Seq = (string) sobj.get('Guidline_Seq__c');
                                stWrap.strDescription = (string) sobj.get('Description__c');
                                stWrap.strText = (string) sobj.get('Text__c');
                                stWrap.strType = (string) sobj.get('Type__c');
                                stWrap.strSign_Off = (string) sobj.get('Sign_Off__c');
                                stWrap.strInspection_Sign_Off_Required = (string) sobj.get('Inspection_Sign_Off_Required__c');
                                workguildeWrapList.add(stWrap);
                            }                                         
                     }
                }            
            }
        }
        return workguildeWrapList;
    }

    public class documentWrapper
    {
        public string strDocument {set;get;}
        public string strDocument_ID {set;get;}
        public string strRevision {set;get;}
    }
        public list<documentWrapper> getDocument()
        {
        list<documentWrapper> documentWrapList=new list<documentWrapper>();
        result res=new result();
       // WGBOutputUtility WGBO=new WGBOutputUtility(WGBProd.id);
        res=WGBOU.getDocument();
        if(WGBProd.IsConfig__c)
         {
             if(res.bResult)
            {
                for (sObject sobj:res.objResultList)
                    { 
                        documentWrapper docWrap=new documentWrapper();
                        docWrap.strDocument = (string) sobj.get('Document__c');
                        docWrap.strDocument_ID  = (string) sobj.get('Document_ID__c');
                        docWrap.strRevision = (string) sobj.get('Revision__c');
                        documentWrapList.add(docWrap);
                    }
            }       
         }        
        return documentWrapList;
    }


     //Router Wrapper
     public class RouterWrapper
    {
        public string strOperation {set;get;}
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
        public string strDescr {set;get;}
    }
        public list<RouterWrapper> getRouter()
        {
        list<RouterWrapper> RouterWrapList=new list<RouterWrapper>();
        
         if(WGBProd.IsConfig__c)
         {
             result res=new result();
             res=WGBOU.getRouting();
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
                    for (sObject sobj:res.objResultList)
                    {                    
                        string a2=(string) sobj.get('Operation__c');
                        Integer i2=integer.valueOf(a2);
                            if(a==i2)
                            {
                                RouterWrapper docWrap=new RouterWrapper(); 
                                docWrap.strStandard_Operation_ID  = (string) sobj.get('Standard_Operation_ID__c');
                                docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                                docWrap.strDescr = (string) sobj.get('Descr__c');
                                docWrap.strOperation = (string) sobj.get('Operation__c');
                                RouterWrapList.add(docWrap); 
                            }                                         
                     }
                }
            }
         }
        
        return RouterWrapList;
    }

    public String ASYTYP {
        get {
                return WGBOU.ASYTYP;
            }
        set {
                this.ASYTYP = value;
            }
      }

      public String GMODEL{
        get {
                return WGBOU.GMODEL;
            }
        set {
                this.GMODEL= value;
            }
      }

      public String GTAG01{
        get {
                return WGBOU.GTAG01;
            }
        set {
                this.GTAG01= GTAG01;
            }
      }

       public String GTAGPN{
        get {
                return WGBOU.GTAGPN;
            }
        set {
                this.GTAGPN= GTAGPN;
            }
      }

      public String ASSEMBLYWT {
        get {
                return WGBOU.ASSEMBLYWT ;
            }
        set {
                this.ASSEMBLYWT = ASSEMBLYWT ;
            }
      }

     public String PRDLIN{
        get {
                return WGBOU.PRDLIN ;
            }
        set {
                this.PRDLIN = value;
            }
      }
    
      public String RTPRS1{
        get {
                decimal conpressval=0.0;
                 if (WGBProd.IsConfig__c)
                    conpressval=WGBProd.Pilot_Supply_Pressure__c;
                string strRTPRS1=conpressval.stripTrailingZeros().toPlainString();
                //string strRTPRS1=string.valueOf(conpressval);
                return strRTPRS1;   //.stripTrailingZeros().toPlainString();
            }
        set {
                this.RTPRS1= value;
            }
      }
      public String REQDFLOW{
        get {
                decimal conflowval=0.0;
                if (WGBProd.IsConfig__c)
                    conflowval=WGBProd.Flow_Rate__c;
                string strREQDFLOW=conflowval.stripTrailingZeros().toPlainString();
                //string strRTPRS1=string.valueOf(conpressval);
                return strREQDFLOW;   //.stripTrailingZeros().toPlainString();
            }
        set {
                this.REQDFLOW= value;
            }
      }

}