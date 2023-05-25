/**
* @File Name          : configureFLAMEproduct.cls
* @Description        :
* @Author             : Vikram Natikar
* @Group              :
* @Last Modified By   : Vikram Natikar
* @Last Modified On   : 04/11/2020
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    09/11/2019   Vikram Natikar     Initial Version
**/

public class configureFLAMEproduct {
    public Flame_Product__c flmProd {set; get;}
  //  public id flmProdId {set;get;}
    public id quotelineId {set;get;}
    Public boolean showsales {get;set;}
    public boolean disableButton {get;set;}
    public boolean showSecB {set; get;}
    public boolean show8400A {set; get;} //used for hiding/showing of "Pallet Material", "Pressure setting" and "Spring range" if 8400A is selected as Model
    public decimal InletFlowPres {set; get;}
    public decimal sideFAif {set;get;}
    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public string strQuoteStatus {set;get;}
    public FAOutputUtility FAOU {get;set;}

    public List<SelectOption> drillingOption{get; set;}
    public Boolean drillingBoolean{get; set;}

    public List<SelectOption> bodyMaterialOptions{get; set;}
    public Boolean bodyMaterialBoolean{get; set;}

    public List<SelectOption> HousingMaterialOptions{get; set;}
    public Boolean HousingMaterialBoolean{get; set;}

    public List<SelectOption> ElementMaterialOptions{get; set;}
    public Boolean ElementMaterialBoolean{get; set;}

    public List<SelectOption> SpringRangeOptions{get; set;}
    public Boolean SpringRangeBoolean{get; set;}

    public List<SelectOption> PalletMaterialOptions{get; set;}
    public Boolean PalletMaterialBoolean{get; set;}

    public List<SelectOption> DiaphragmMaterialOptions{get; set;}
    public Boolean DiaphragmMaterialBoolean{get; set;}

    public List<SelectOption> PressureSettingOptions{get; set;}
    public Boolean PressureSettingBoolean{get; set;}

    public List<SelectOption> PaintingCoatingOptions{get; set;}
    public Boolean PaintingCoatingBoolean{get; set;}

    public List<SelectOption> InletAOptions{get; set;}
    public Boolean InletABoolean{get; set;}

    public List<SelectOption> InletBOptions{get; set;}
    public Boolean InletBBoolean{get; set;}

    public List<SelectOption> InletCOptions{get; set;}
    public Boolean InletCBoolean{get; set;}

    public List<SelectOption> OutletAOptions{get; set;}
    public Boolean OutletABoolean{get; set;}

    public List<SelectOption> OutletBOptions{get; set;}
    public Boolean OutletBBoolean{get; set;}

    public List<SelectOption> OutletCOptions{get; set;}
    public Boolean OutletCBoolean{get; set;}

    public List<SelectOption> RadiographyOptions{get; set;}
    public Boolean RadiographyBoolean{get; set;}

    public Boolean FilletWeldLiquidDyePenetrant{get;set;}
 //   public Boolean FilletWeldLiquidDyePenetrantBoolean{get;set;}

    public List<SelectOption> PositiveMaterialIdentificationOptions{get; set;}
    public Boolean PositiveMaterialIdentificationBoolean{get; set;}

    public List<SelectOption> LiquidDyePenetrantOptions{get; set;}
    public Boolean LiquidDyePenetrantBoolean{get; set;}

    public Boolean UltrasonicExamination{get; set;}
  //  public Boolean UltrasonicExaminationBoolean{get; set;}

    public Boolean MagneticParticleExamination{get; set;}
 //   public Boolean MagneticParticleExaminationBoolean{get; set;}

    public Boolean BrinellHardnessExamination{get; set;}
  //  public Boolean BrinellHardnessExaminationBoolean{get; set;}

    public Boolean CharpyImpactTesting{get; set;}
  //  public Boolean CharpyImpactTestingBoolean{get; set;}

    public Boolean VisualCastingExamination{get; set;}
  //  public Boolean VisualCastingExaminationBoolean{get; set;}

    public Boolean IntergranularCorrosionTest{get; set;}
 //   public Boolean IntergranularCorrosionTestBoolean{get; set;}

    public List<selectOption> modelOptions {get; set;}
    public List<selectOption> connSizeOptions {get; set;}
    public string fromPage;
    public boolean reorderControl = false;
//    public List<selectOption> bodyMaterialOptions {get; set;}
 //   public List<selectOption> HousingMaterialOptions {get; set;}
//    public List<selectOption> ElementMaterialOptions {get; set;}
 //   private static Map<String, Schema.SObjectField> FLMFieldMap;
   // private static Map<String,String> FLMMasterBMPicklists,FLMMasterHMPicklists,FLMMasterEMPicklists;
  //  public Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>> masterBlasterMap;
  /*  static
    {
        FLMFieldMap = FLMutility.getSobjectFieldsMap(Flame_Product__c.SObjectType);
        FLMMasterBMPicklists = FLMutility.getPicklistLabelByValue(Flame_Product__c.SObjectType,'Body_Material__c');
        FLMMasterHMPicklists = FLMutility.getPicklistLabelByValue(Flame_Product__c.SObjectType,'Housing_Material__c');
        FLMMasterEMPicklists = FLMutility.getPicklistLabelByValue(Flame_Product__c.SObjectType,'Element_Material__c');
    }*/

    //added by piyush
    public string editModeLable {get;set;}
    public boolean bShowEditButton{get;set;}
    public string quoteStatus;
    public string configStatus;
    public string defaultQuoteLineView;
    public string QuoteLIneView{get;set;}
    public boolean bShowReturnToProductSelectionButton{get;set;}
    public ProductAccessibilityConfig__mdt oPacMetaData;
    public boolean bReadOnlyChceckBox {get;set;}
    public String selectedTab {get;set;}


    public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
            strURL = '/apex/ConfigFlameProductReference?Id=' + flmProd.Id;

        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }


    public configureFLAMEproduct (ApexPages.StandardController controller)
    {


        //Nagrjuna added Tab visibility logic
         ReorderFlag=false;
         showsales = False;
         disableButton = true;
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

        showSecB=false;
        show8400A=false;
        InletFlowPres=0;
        sideFAif=0;

        quotelineId=ApexPages.currentPage().getParameters().get('qid');
        system.debug(quotelineId);
        fromPage = ApexPages.currentPage().getParameters().get('fromPage');
        this.flmProd= DataSelectorWizard.getFlameProductRecord(quotelineId);
        if(string.isNotBlank(quoteLineId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else{
            System.debug('QuoteLine Id is Missing');
        }

        // ######### added by piyush
        editModeLable = 'Edit';
        quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        system.debug('flmProd --> Configuration_Complete__c ' + flmprod.IsConfig__c);
        system.debug('flmProd Quote_Description_Engineer_Override__c --> ' + flmprod.Quote_Description_Engineer_Override__c);

        if(flmprod.IsConfig__c){
           if(flmprod.Quote_Description_Engineer_Override__c){
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

        //----------------piyush----------------

        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            if (flmprod.Price_Engineer_Override__c == true ||
                flmprod.Lead_Time_Override__c == true ||
                flmprod.Build_Cost_Override__c == true ||
                flmprod.Quote_Description_Engineer_Override__c == true
                ){
                    disableButton = true;
                    bShowEditButton = false;
            }
         }




        flmprod.Application_Parameters_flag__c=false;
        flmProd.Sizing_Flow_Area_flag__c = false;
        flmProd.Certifications_flag__c = false;
        flmProd.Product_Narrowing_flag__c = false;
        flmprod.Product_selection_flag__c = false;
      //  flmprod.Product_Material_and_Options_flag__c = false;
     //   flmprod.Examination_Option_flag__c = false;

        if (flmprod.IsConfig__c){
            FAOU=new FAOutputUtility(flmprod.Id);
        }




        FAPriceWrapperList = new list<priceWrapper>();
      //  FAPricingList = new list<FA_Price_Details__c >();
        FALeadTimeList = new list<LeadTimeWrapper>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
     //   Map<String,String> Attr = FAOU.getmapIFSAttr();

        drillingOption = new List<selectOption>();

        modelOptions = new List<selectOption>();
        connSizeOptions = new List<selectOption>();
        bodyMaterialOptions= new List<selectOption>();
        HousingMaterialOptions = new List<selectOption>();
        ElementMaterialOptions = new List<selectOption>();
        PalletMaterialOptions = new List<selectOption>();
        DiaphragmMaterialOptions = new List<selectOption>();
        PressureSettingOptions = new List<selectOption>();
        SpringRangeOptions = new List<selectOption>();
        PaintingCoatingOptions = new List<selectOption>();
        InletAOptions = new List<selectOption>();
        InletBOptions = new List<selectOption>();
        InletCOptions = new List<selectOption>();
        OutletAOptions = new List<selectOption>();
        OutletBOptions = new List<selectOption>();
        OutletCOptions = new List<selectOption>();
        RadiographyOptions = new List<selectOption>();
        PositiveMaterialIdentificationOptions = new List<selectOption>();
        LiquidDyePenetrantOptions = new List<selectOption>();

      //  faOutput = getFAOutputRecord(flmprod.Id);
		if(!Test.isRunningTest())
        {
            getRadiographyOptions();
            getBrinellHardnessExamination();
            getFilletWeldLiquidDyePenetrant();
            getUltrasonicExamination();
            getMagneticParticleExamination();
            getCharpyImpactTesting();
            getVisualCastingExamination();
            getPositiveMaterialIdentificationOptions();
            getLiquidDyePenetrantOptions();
            
            getdrillingOptions();
            getbodyMaterialOptions();
            // getOnChangeBodyMaterial();
            //  getHousingMaterialOptions();
            //   getElementMaterialOptions();
            getPalletMaterialOptions();
            getDiaphragmMaterialOptions();
            getPressureSettingOptions();
            //   getSpringRangeOptions();
            getPaintingCoatingOptions();
            getInletAOptions();
            getInletBOptions();
            getInletCOptions();
            getOutletAOptions();
            getOutletBOptions();
            getOutletCOptions(); 
        }
        

        //CheckBox Fields
   /*/*     getMagneticParticleExamination();
        getCharpyImpactTesting();
		getUltrasonicExamination();
		getVisualCastingExamination();
		getIntergranularCorrosionTest();*/


        if(String.isNotBlank(flmprod.Model__c))
        {
            modelOptions.add(new selectOption(flmprod.Model__c, flmprod.Model__c));
        }
        if(String.isNotBlank(flmprod.Connection_Size__c))
        {
            connSizeOptions.add(new selectOption(flmprod.Connection_Size__c, flmprod.Connection_Size__c));
        }


        if(String.isNotBlank(flmprod.Body_Material__c ) && null != flmprod.Body_Material__c && flmprod.Body_Material__c != 'N')
            bodyMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Housing_Material__c ) && null != flmprod.Housing_Material__c && flmprod.Housing_Material__c != 'N')
            HousingMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Element_Material__c ) && null != flmprod.Element_Material__c && flmprod.Element_Material__c != 'N')
            ElementMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Spring_Range__c ) && null != flmprod.Spring_Range__c && flmprod.Spring_Range__c != '0')
            SpringRangeBoolean = true;

        if(String.isNotBlank(flmprod.Pallet_Material__c ) && null != flmprod.Pallet_Material__c && flmprod.Pallet_Material__c != 'N')
            PalletMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Diaphragm_Material__c ) && null != flmprod.Diaphragm_Material__c && flmprod.Diaphragm_Material__c != 'N')
            DiaphragmMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Pressure_Setting__c ) && null != flmprod.Pressure_Setting__c && flmprod.Pressure_Setting__c != 'N')
            PressureSettingBoolean = true;

        if(String.isNotBlank(flmprod.Painting_Coating_Option__c ) && null != flmprod.Painting_Coating_Option__c && flmprod.Painting_Coating_Option__c != 'N')
            PaintingCoatingBoolean = true;


        if(String.isNotBlank(flmprod.Radiography__c ) && null != flmprod.Radiography__c && (flmprod.Radiography_Display_Flag__c==true))
            RadiographyBoolean = true;
        if(String.isNotBlank(flmprod.Positive_Material_Identification__c ) && null != flmprod.Positive_Material_Identification__c && (flmprod.PMI_Display_Flag__c==true))
            PositiveMaterialIdentificationBoolean = true;
		if(String.isNotBlank(flmprod.Liquid_Dye_Penetrant__c ) && null != flmprod.Liquid_Dye_Penetrant__c && (flmprod.LDP_Display_Flag__c==true))
            LiquidDyePenetrantBoolean = true;

    /*    if(String.isNotBlank(flmprod.Body_Material__c))
        {
            bodyMaterialOptions.add(new selectOption(flmprod.Body_Material__c, FLMMasterBMPicklists.get(flmprod.Body_Material__c)));
        }
        if(String.isNotBlank(flmprod.Housing_Material__c))
        {
            HousingMaterialOptions.add(new selectOption(flmprod.Housing_Material__c, FLMMasterHMPicklists.get(flmprod.Housing_Material__c)));
        }
        if(String.isNotBlank(flmprod.Element_Material__c))
        {
            ElementMaterialOptions.add(new selectOption(flmprod.Element_Material__c, FLMMasterEMPicklists.get(flmprod.Element_Material__c)));
        } */
        System.debug('****** flmprod = '+flmprod);
      /*  if(String.isNotBlank(flmprod.Model__c) && String.isNotBlank(flmprod.Connection_Size__c) && String.isNotBlank(flmprod.Element_Size__c))
        {
            masterBlasterMap = DataSelectorWizard.getFLMMasterBlaster(flmProd);
        }*/

       // System.debug('****** masterBlasterMap = '+masterBlasterMap);


       //Attributes Map
       Map<String, String> valueVsDescription = getRVInputAttrValueDesc(flmProd);
        if(valueVsDescription.size() > 0)
        {
            if(valueVsDescription.containsKey(flmProd.Body_Material__c + '_MCBODY'))
            {
                if(!bodyMaterialOptions.contains(new selectOption(flmProd.Body_Material__c, valueVsDescription.get(flmProd.Body_Material__c +'_MCBODY'))))
                	bodyMaterialOptions.add(new selectOption(flmProd.Body_Material__c, valueVsDescription.get(flmProd.Body_Material__c +'_MCBODY')));
            }
            if(valueVsDescription.containsKey(flmProd.Housing_Material__c + '_MCHOUS'))
            {
                if(!HousingMaterialOptions.contains(new selectOption(flmProd.Housing_Material__c, valueVsDescription.get(flmProd.Housing_Material__c +'_MCHOUS'))))
                	HousingMaterialOptions.add(new selectOption(flmProd.Housing_Material__c, valueVsDescription.get(flmProd.Housing_Material__c +'_MCHOUS')));
            }
            if(valueVsDescription.containsKey(flmProd.Element_Material__c  + '_MCELMT'))
            {
                if(!ElementMaterialOptions.contains(new selectOption(flmProd.Element_Material__c, valueVsDescription.get(flmProd.Element_Material__c +'_MCELMT'))))
                	ElementMaterialOptions.add(new selectOption(flmProd.Element_Material__c, valueVsDescription.get(flmProd.Element_Material__c +'_MCELMT')));
            }
            if(valueVsDescription.containsKey(flmProd.Pallet_Material__c  + '_MCPALL'))
            {
                if(!PalletMaterialOptions.contains(new selectOption(flmProd.Pallet_Material__c, valueVsDescription.get(flmProd.Pallet_Material__c +'_MCPALL'))))
                	PalletMaterialOptions.add(new selectOption(flmProd.Pallet_Material__c, valueVsDescription.get(flmProd.Pallet_Material__c +'_MCPALL')));
            }
            if(valueVsDescription.containsKey(flmProd.Diaphragm_Material__c  + '_MCDPHM'))
            {
                if(!DiaphragmMaterialOptions.contains(new selectOption(flmProd.Diaphragm_Material__c, valueVsDescription.get(flmProd.Diaphragm_Material__c +'_MCDPHM'))))
                	DiaphragmMaterialOptions.add(new selectOption(flmProd.Diaphragm_Material__c, valueVsDescription.get(flmProd.Diaphragm_Material__c +'_MCDPHM')));
            }
            if(valueVsDescription.containsKey(flmProd.Pressure_Setting__c  + '_SETTING'))
            {
                if(!PressureSettingOptions.contains(new selectOption(flmProd.Pressure_Setting__c, valueVsDescription.get(flmProd.Pressure_Setting__c +'_SETTING'))))
                	PressureSettingOptions.add(new selectOption(flmProd.Pressure_Setting__c, valueVsDescription.get(flmProd.Pressure_Setting__c +'_SETTING')));
            }
            if(valueVsDescription.containsKey(flmProd.Spring_Range__c  + '_SPRING'))
            {
                if(!SpringRangeOptions.contains(new selectOption(flmProd.Spring_Range__c, valueVsDescription.get(flmProd.Spring_Range__c +'_SPRING'))))
                	SpringRangeOptions.add(new selectOption(flmProd.Spring_Range__c, valueVsDescription.get(flmProd.Spring_Range__c +'_SPRING')));
            }
         /*   if(valueVsDescription.containsKey(flmProd.Painting_Coating_Option__c))
            {
                PaintingCoatingOptions.add(new selectOption(flmProd.Painting_Coating_Option__c, valueVsDescription.get(flmProd.Painting_Coating_Option__c +'_GPAINT')));
            }
            if(valueVsDescription.containsKey(flmProd.Inlet_Option_A__c))
            {
                InletAOptions.add(new selectOption(flmProd.Inlet_Option_A__c, valueVsDescription.get(flmProd.Inlet_Option_A__c +'_GINLOP_OptA')));
            }
            if(valueVsDescription.containsKey(flmProd.Inlet_Option_B__c))
            {
                InletBOptions.add(new selectOption(flmProd.Inlet_Option_B__c, valueVsDescription.get(flmProd.Inlet_Option_B__c +'_GINLOP_OptB')));
            }
            if(valueVsDescription.containsKey(flmProd.Inlet_Option_C__c))
            {
                InletCOptions.add(new selectOption(flmProd.Inlet_Option_C__c, valueVsDescription.get(flmProd.Inlet_Option_C__c +'_GINLOP_OptC')));
            }
            if(valueVsDescription.containsKey(flmProd.Outlet_Option_A__c))
            {
                OutletAOptions.add(new selectOption(flmProd.Outlet_Option_A__c, valueVsDescription.get(flmProd.Outlet_Option_A__c +'_GOUTOP_OptA')));
            }
            if(valueVsDescription.containsKey(flmProd.Outlet_Option_B__c))
            {
                OutletBOptions.add(new selectOption(flmProd.Outlet_Option_B__c, valueVsDescription.get(flmProd.Outlet_Option_B__c +'_GOUTOP_OptB')));
            }
            if(valueVsDescription.containsKey(flmProd.Outlet_Option_C__c))
            {
                OutletCOptions.add(new selectOption(flmProd.Outlet_Option_C__c, valueVsDescription.get(flmProd.Outlet_Option_C__c +'_GOUTOP_OptC')));
            }*/
			if(valueVsDescription.containsKey(flmProd.Radiography__c + '_XRAY'))
            {
                if(!RadiographyOptions.contains(new selectOption(flmProd.Radiography__c, valueVsDescription.get(flmProd.Radiography__c +'_XRAY'))))
                	RadiographyOptions.add(new selectOption(flmProd.Radiography__c, valueVsDescription.get(flmProd.Radiography__c +'_XRAY')));
            }
            if(valueVsDescription.containsKey(flmProd.Positive_Material_Identification__c + '_PMI'))
            {
                if(!PositiveMaterialIdentificationOptions.contains(new selectOption(flmProd.Positive_Material_Identification__c, valueVsDescription.get(flmProd.Positive_Material_Identification__c +'_PMI'))))
              		  PositiveMaterialIdentificationOptions.add(new selectOption(flmProd.Positive_Material_Identification__c, valueVsDescription.get(flmProd.Positive_Material_Identification__c +'_PMI')));
            }
            if(valueVsDescription.containsKey(flmProd.Liquid_Dye_Penetrant__c + '_LDP'))
            {
               if(!LiquidDyePenetrantOptions.contains(new selectOption(flmProd.Liquid_Dye_Penetrant__c, valueVsDescription.get(flmProd.Liquid_Dye_Penetrant__c +'_LDP'))))
               	 LiquidDyePenetrantOptions.add(new selectOption(flmProd.Liquid_Dye_Penetrant__c, valueVsDescription.get(flmProd.Liquid_Dye_Penetrant__c +'_LDP')));
            }
        }

      /*  if(String.isNotBlank(flmprod.Radiography__c ) && null != flmprod.Radiography__c && (valueVsDescription.get(flmProd.Radiography__c +'_XRAY')=='None' || flmprod.Radiography__c!='N'))
            RadiographyBoolean = true;*/

     /*   if(String.isNotBlank(flmprod.Radiography__c ) && null != flmprod.Radiography__c && (flmprod.Radiography__c != 'N'))
            RadiographyBoolean = true;
        if(String.isNotBlank(flmprod.Positive_Material_Identification__c ) && null != flmprod.Positive_Material_Identification__c && (flmprod.Positive_Material_Identification__c != 'N'))
            PositiveMaterialIdentificationBoolean = true;
		if(String.isNotBlank(flmprod.Liquid_Dye_Penetrant__c ) && null != flmprod.Liquid_Dye_Penetrant__c && (flmprod.Liquid_Dye_Penetrant__c != 'N'))
            LiquidDyePenetrantBoolean = true;*/
        if(flmprod.IsConfig__c){
            selectedTab = 'ProductReview';

          //  getTabData();
            getPricinglist();
            GetQuoteDescriptionRecords();

        }

    }

    
    //Reorder purpose Code Start
    public Boolean ReorderFlag{get;set;}
    
    public configureFLAMEproduct (Id quoteLineId)
    {
        //Nagrjuna added Tab visibility logic
         showsales = False;
         disableButton = true;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
		profilesetstr.add('CDC Prod. Planning'); 
        
        if(profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }

        showSecB=false;
        show8400A=false;
        InletFlowPres=0;
        sideFAif=0;

      /*  quotelineId=ApexPages.currentPage().getParameters().get('qid');
        system.debug(quotelineId);
        fromPage = ApexPages.currentPage().getParameters().get('fromPage');*/
        this.flmProd= DataSelectorWizard.getFlameProductRecord(quotelineId);
        if(string.isNotBlank(quoteLineId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else{
            System.debug('QuoteLine Id is Missing');
        }

        // ######### added by piyush
        editModeLable = 'Edit';
        quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;

        if(flmprod.IsConfig__c){
           if(flmprod.Quote_Description_Engineer_Override__c){
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
        oPacMetaData = fetchCurrentProductAccessibility( quoteStatus , configStatus);
        bShowEditButton = false;
        bReadOnlyChceckBox = false;
        bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;
        QuoteLIneView = oPacMetaData.View__c;

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

        flmprod.Application_Parameters_flag__c=false;
        flmProd.Sizing_Flow_Area_flag__c = false;
        flmProd.Certifications_flag__c = false;
        flmProd.Product_Narrowing_flag__c = false;
        flmprod.Product_selection_flag__c = false;
      //  flmprod.Product_Material_and_Options_flag__c = false;
     //   flmprod.Examination_Option_flag__c = false;

        if (flmprod.IsConfig__c){
            FAOU=new FAOutputUtility(flmprod.Id);
        }




        FAPriceWrapperList = new list<priceWrapper>();
      //  FAPricingList = new list<FA_Price_Details__c >();
        FALeadTimeList = new list<LeadTimeWrapper>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
     //   Map<String,String> Attr = FAOU.getmapIFSAttr();

        drillingOption = new List<selectOption>();

        modelOptions = new List<selectOption>();
        connSizeOptions = new List<selectOption>();
        bodyMaterialOptions= new List<selectOption>();
        HousingMaterialOptions = new List<selectOption>();
        ElementMaterialOptions = new List<selectOption>();
        PalletMaterialOptions = new List<selectOption>();
        DiaphragmMaterialOptions = new List<selectOption>();
        PressureSettingOptions = new List<selectOption>();
        SpringRangeOptions = new List<selectOption>();
        PaintingCoatingOptions = new List<selectOption>();
        InletAOptions = new List<selectOption>();
        InletBOptions = new List<selectOption>();
        InletCOptions = new List<selectOption>();
        OutletAOptions = new List<selectOption>();
        OutletBOptions = new List<selectOption>();
        OutletCOptions = new List<selectOption>();
        RadiographyOptions = new List<selectOption>();
        PositiveMaterialIdentificationOptions = new List<selectOption>();
        LiquidDyePenetrantOptions = new List<selectOption>();

      //  faOutput = getFAOutputRecord(flmprod.Id);
		if(!Test.isRunningTest())
        {
            getRadiographyOptions();
            getBrinellHardnessExamination();
            getFilletWeldLiquidDyePenetrant();
            getUltrasonicExamination();
            getMagneticParticleExamination();
            getCharpyImpactTesting();
            getVisualCastingExamination();
            getPositiveMaterialIdentificationOptions();
            getLiquidDyePenetrantOptions();
            
            getdrillingOptions();
            getbodyMaterialOptions();
            // getOnChangeBodyMaterial();
            //  getHousingMaterialOptions();
            //   getElementMaterialOptions();
            getPalletMaterialOptions();
            getDiaphragmMaterialOptions();
            getPressureSettingOptions();
            //   getSpringRangeOptions();
            getPaintingCoatingOptions();
            getInletAOptions();
            getInletBOptions();
            getInletCOptions();
            getOutletAOptions();
            getOutletBOptions();
            getOutletCOptions(); 
        }


        if(String.isNotBlank(flmprod.Model__c))
        {
            modelOptions.add(new selectOption(flmprod.Model__c, flmprod.Model__c));
        }
        if(String.isNotBlank(flmprod.Connection_Size__c))
        {
            connSizeOptions.add(new selectOption(flmprod.Connection_Size__c, flmprod.Connection_Size__c));
        }


        if(String.isNotBlank(flmprod.Body_Material__c ) && null != flmprod.Body_Material__c && flmprod.Body_Material__c != 'N')
            bodyMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Housing_Material__c ) && null != flmprod.Housing_Material__c && flmprod.Housing_Material__c != 'N')
            HousingMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Element_Material__c ) && null != flmprod.Element_Material__c && flmprod.Element_Material__c != 'N')
            ElementMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Spring_Range__c ) && null != flmprod.Spring_Range__c && flmprod.Spring_Range__c != '0')
            SpringRangeBoolean = true;

        if(String.isNotBlank(flmprod.Pallet_Material__c ) && null != flmprod.Pallet_Material__c && flmprod.Pallet_Material__c != 'N')
            PalletMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Diaphragm_Material__c ) && null != flmprod.Diaphragm_Material__c && flmprod.Diaphragm_Material__c != 'N')
            DiaphragmMaterialBoolean = true;

        if(String.isNotBlank(flmprod.Pressure_Setting__c ) && null != flmprod.Pressure_Setting__c && flmprod.Pressure_Setting__c != 'N')
            PressureSettingBoolean = true;

        if(String.isNotBlank(flmprod.Painting_Coating_Option__c ) && null != flmprod.Painting_Coating_Option__c && flmprod.Painting_Coating_Option__c != 'N')
            PaintingCoatingBoolean = true;


        if(String.isNotBlank(flmprod.Radiography__c ) && null != flmprod.Radiography__c && (flmprod.Radiography_Display_Flag__c==true))
            RadiographyBoolean = true;
        if(String.isNotBlank(flmprod.Positive_Material_Identification__c ) && null != flmprod.Positive_Material_Identification__c && (flmprod.PMI_Display_Flag__c==true))
            PositiveMaterialIdentificationBoolean = true;
		if(String.isNotBlank(flmprod.Liquid_Dye_Penetrant__c ) && null != flmprod.Liquid_Dye_Penetrant__c && (flmprod.LDP_Display_Flag__c==true))
            LiquidDyePenetrantBoolean = true;

        Map<String, String> valueVsDescription = getRVInputAttrValueDesc(flmProd);
        if(valueVsDescription.size() > 0)
        {
            if(valueVsDescription.containsKey(flmProd.Body_Material__c + '_MCBODY'))
            {
                if(!bodyMaterialOptions.contains(new selectOption(flmProd.Body_Material__c, valueVsDescription.get(flmProd.Body_Material__c +'_MCBODY'))))
                	bodyMaterialOptions.add(new selectOption(flmProd.Body_Material__c, valueVsDescription.get(flmProd.Body_Material__c +'_MCBODY')));
            }
            if(valueVsDescription.containsKey(flmProd.Housing_Material__c + '_MCHOUS'))
            {
                if(!HousingMaterialOptions.contains(new selectOption(flmProd.Housing_Material__c, valueVsDescription.get(flmProd.Housing_Material__c +'_MCHOUS'))))
                	HousingMaterialOptions.add(new selectOption(flmProd.Housing_Material__c, valueVsDescription.get(flmProd.Housing_Material__c +'_MCHOUS')));
            }
            if(valueVsDescription.containsKey(flmProd.Element_Material__c  + '_MCELMT'))
            {
                if(!ElementMaterialOptions.contains(new selectOption(flmProd.Element_Material__c, valueVsDescription.get(flmProd.Element_Material__c +'_MCELMT'))))
                	ElementMaterialOptions.add(new selectOption(flmProd.Element_Material__c, valueVsDescription.get(flmProd.Element_Material__c +'_MCELMT')));
            }
            if(valueVsDescription.containsKey(flmProd.Pallet_Material__c  + '_MCPALL'))
            {
                if(!PalletMaterialOptions.contains(new selectOption(flmProd.Pallet_Material__c, valueVsDescription.get(flmProd.Pallet_Material__c +'_MCPALL'))))
                	PalletMaterialOptions.add(new selectOption(flmProd.Pallet_Material__c, valueVsDescription.get(flmProd.Pallet_Material__c +'_MCPALL')));
            }
            if(valueVsDescription.containsKey(flmProd.Diaphragm_Material__c  + '_MCDPHM'))
            {
                if(!DiaphragmMaterialOptions.contains(new selectOption(flmProd.Diaphragm_Material__c, valueVsDescription.get(flmProd.Diaphragm_Material__c +'_MCDPHM'))))
                	DiaphragmMaterialOptions.add(new selectOption(flmProd.Diaphragm_Material__c, valueVsDescription.get(flmProd.Diaphragm_Material__c +'_MCDPHM')));
            }
            if(valueVsDescription.containsKey(flmProd.Pressure_Setting__c  + '_SETTING'))
            {
                if(!PressureSettingOptions.contains(new selectOption(flmProd.Pressure_Setting__c, valueVsDescription.get(flmProd.Pressure_Setting__c +'_SETTING'))))
                	PressureSettingOptions.add(new selectOption(flmProd.Pressure_Setting__c, valueVsDescription.get(flmProd.Pressure_Setting__c +'_SETTING')));
            }
            if(valueVsDescription.containsKey(flmProd.Spring_Range__c  + '_SPRING'))
            {
                if(!SpringRangeOptions.contains(new selectOption(flmProd.Spring_Range__c, valueVsDescription.get(flmProd.Spring_Range__c +'_SPRING'))))
                	SpringRangeOptions.add(new selectOption(flmProd.Spring_Range__c, valueVsDescription.get(flmProd.Spring_Range__c +'_SPRING')));
            }
			if(valueVsDescription.containsKey(flmProd.Radiography__c + '_XRAY'))
            {
                if(!RadiographyOptions.contains(new selectOption(flmProd.Radiography__c, valueVsDescription.get(flmProd.Radiography__c +'_XRAY'))))
                	RadiographyOptions.add(new selectOption(flmProd.Radiography__c, valueVsDescription.get(flmProd.Radiography__c +'_XRAY')));
            }
            if(valueVsDescription.containsKey(flmProd.Positive_Material_Identification__c + '_PMI'))
            {
                if(!PositiveMaterialIdentificationOptions.contains(new selectOption(flmProd.Positive_Material_Identification__c, valueVsDescription.get(flmProd.Positive_Material_Identification__c +'_PMI'))))
              		  PositiveMaterialIdentificationOptions.add(new selectOption(flmProd.Positive_Material_Identification__c, valueVsDescription.get(flmProd.Positive_Material_Identification__c +'_PMI')));
            }
            if(valueVsDescription.containsKey(flmProd.Liquid_Dye_Penetrant__c + '_LDP'))
            {
               if(!LiquidDyePenetrantOptions.contains(new selectOption(flmProd.Liquid_Dye_Penetrant__c, valueVsDescription.get(flmProd.Liquid_Dye_Penetrant__c +'_LDP'))))
               	 LiquidDyePenetrantOptions.add(new selectOption(flmProd.Liquid_Dye_Penetrant__c, valueVsDescription.get(flmProd.Liquid_Dye_Penetrant__c +'_LDP')));
            }
        }

        if(flmprod.IsConfig__c){
            selectedTab = 'ProductReview';

          //  getTabData();
            getPricinglist();
            GetQuoteDescriptionRecords();

        }

    }

    //Reorder purpose Code End

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


    //Attributesss Map Method
    public Map<String,String> getRVInputAttrValueDesc(Flame_Product__c flmProd)
    {
        Map<String, String> valueVsDescription = new Map<String, String>();
		Set<string> AttrCode = new Set<String>();
        if(String.isNotBlank(flmProd.Body_Material__c))
        {
            valueVsDescription.put(flmProd.Body_Material__c,'');
			AttrCode.add('MCBODY');
        }
        if(String.isNotBlank(flmProd.Housing_Material__c))
        {
            valueVsDescription.put(flmProd.Housing_Material__c,'');
			AttrCode.add('MCHOUS');
        }
        if(String.isNotBlank(flmProd.Element_Material__c))
        {
            valueVsDescription.put(flmProd.Element_Material__c,'');
			AttrCode.add('MCELMT');
        }
        if(String.isNotBlank(flmProd.Pallet_Material__c))
        {
            valueVsDescription.put(flmProd.Pallet_Material__c,'');
			AttrCode.add('MCPALL');
        }
        if(String.isNotBlank(flmProd.Diaphragm_Material__c))
        {
            valueVsDescription.put(flmProd.Diaphragm_Material__c,'');
			AttrCode.add('MCDPHM');
        }
        if(String.isNotBlank(flmProd.Pressure_Setting__c))
        {
            valueVsDescription.put(flmProd.Pressure_Setting__c,'');
			AttrCode.add('SETTING');
        }
        if(String.isNotBlank(flmProd.Spring_Range__c))
        {
            valueVsDescription.put(flmProd.Spring_Range__c,'');
			AttrCode.add('SPRING');
        }
        if(String.isNotBlank(flmProd.Painting_Coating_Option__c))
        {
            valueVsDescription.put(flmProd.Painting_Coating_Option__c,'');
			AttrCode.add('GPAINT');
        }
        if(String.isNotBlank(flmProd.Inlet_Option_A__c))
        {
            valueVsDescription.put(flmProd.Inlet_Option_A__c,'');
			AttrCode.add('GINLOP_OptA');
        }
        if(String.isNotBlank(flmProd.Inlet_Option_B__c))
        {
            valueVsDescription.put(flmProd.Inlet_Option_B__c,'');
			AttrCode.add('GINLOP_OptB');
        }
        if(String.isNotBlank(flmProd.Inlet_Option_C__c))
        {
            valueVsDescription.put(flmProd.Inlet_Option_C__c,'');
			AttrCode.add('GINLOP_OptC');
        }
        if(String.isNotBlank(flmProd.Outlet_Option_A__c))
        {
            valueVsDescription.put(flmProd.Outlet_Option_A__c,'');
			AttrCode.add('GOUTOP_OptA');
        }
        if(String.isNotBlank(flmProd.Outlet_Option_B__c))
        {
            valueVsDescription.put(flmProd.Outlet_Option_B__c,'');
			AttrCode.add('GOUTOP_OptB');
        }
        if(String.isNotBlank(flmProd.Outlet_Option_C__c))
        {
            valueVsDescription.put(flmProd.Outlet_Option_C__c,'');
			AttrCode.add('GOUTOP_OptC');
        }
		if(String.isNotBlank(flmProd.Radiography__c))
        {
            valueVsDescription.put(flmProd.Radiography__c,'');
			AttrCode.add('XRAY');
        }
        if(String.isNotBlank(flmProd.Positive_Material_Identification__c))
        {
            valueVsDescription.put(flmProd.Positive_Material_Identification__c,'');
			AttrCode.add('PMI');
        }
        if(String.isNotBlank(flmProd.Liquid_Dye_Penetrant__c))
        {
            valueVsDescription.put(flmProd.Liquid_Dye_Penetrant__c,'');
			AttrCode.add('LDP');
        }

        if(valueVsDescription.size() > 0)
        {
            for(FA_Input_Attr_Value_Desc__c fa : [SELECT ID,Attribute__c,Text_Description_of_AttributeValue__c, Value__c FROM FA_Input_Attr_Value_Desc__c WHERE
			Value__c IN:valueVsDescription.keyset() and Attribute__c IN: AttrCode])
            {
                valueVsDescription.put(fa.Value__c+ '_' + fa.Attribute__c,fa.Text_Description_of_AttributeValue__c);
            }
        }
        return valueVsDescription;
    }
    public List<string> notValidStatusForChng {
        get {
            return new List<String>{'Approved','Order Submitted'};
        }
        set {
            this.notValidStatusForChng=value;
        }
    }
    //Section F: Product Material and Options fields starts here
    //Dynamic picklist fields code
    //Drilling Method
     public void getdrillingOptions()
    {
        drillingOption.clear();
      //  flmProd.Drilling__c = null;
        drillingBoolean = true;
        //bodyMaterialOptions.clear();

            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'FA_HCLASS_Cons__c','FA_Input_Attr_Value_Desc__c'}));
            parameters.put('FA_HCLASS_Cons__c_selectedFields', 'HCLASS__c');
            parameters.put('FA_HCLASS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND SZC__c = \'' +flmProd.Size__c+'\'');
			System.debug(' DDDD PTC--' +flmprod.PTC__c);
            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'HCLASS\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_HCLASS_Cons__c-HCLASS__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_HCLASS_Cons__c-HCLASS__c');
        	parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            System.debug('DDDD inputAttrValue = '+inputAttrValue.size());
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                if(inputAttrValue.size() == 1){
                    drillingOption.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Drilling__c = inputAttrValue[0].Value__c;
                }
                else{
                    drillingOption.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        drillingOption.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                drillingBoolean = false;
                drillingOption.add(new selectOption('N','N'));
                flmProd.Drilling__c = 'N';
            }
    }

    //BodyMaterial Method
    public void getbodyMaterialOptions()
    {
       // system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        bodyMaterialOptions.clear();
        System.debug('AAAAABody');
        bodyMaterialBoolean = true;
     //   flmProd.Body_Material__c = null;
        if(flmProd.PTC__c!=null && flmProd.Size__c!=null && flmProd.Atex_Certificate_2014_34_EU__c!=null &&
           flmProd.CU_TR__c!=null && flmProd.Nace_Backend__c!=null && flmProd.US_Coast_guard__c!=null ){


            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'FA_MATL_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_MATL_Cons__c_selectedFields', 'MCBODY__c');
            parameters.put('FA_MATL_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND (SZC__c=\''+flmProd.Size__c+'\' OR SZC__c= \'-\')'+' AND (NACE__c=\''+flmProd.Nace_Backend__c+'\' OR NACE__c= \'-\')'+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')');

            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCBODY\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_MATL_Cons__c-MCBODY__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_MATL_Cons__c-MCBODY__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            System.debug('AAAAAinputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                bodyMaterialBoolean = true;
                if(inputAttrValue.size() == 1){
                    bodyMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Body_Material__c = inputAttrValue[0].Value__c;
                    System.debug('AAAAABody option1');
                    System.debug('AAAAABody Value---------' + inputAttrValue[0].Value__c);
                    System.debug('AAAAABody Description---------' + inputAttrValue[0].Text_Description_of_AttributeValue__c);
                    System.debug('AAAAAAAbodyMaterialOptions-' +bodyMaterialOptions);
                    getOnChangeBodyMaterial();
                }
                else{
                    bodyMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        System.debug('AAAAABody many options');
                        bodyMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                   // getOnChangeBodyMaterial();
                 /* 	  HousingMaterialOptions.clear();
                      ElementMaterialOptions.clear();
        */
               //     PositiveMaterialIdentificationOptions.clear();
                //    LiquidDyePenetrantOptions.clear();

                    HousingMaterialBoolean=false;
                    elementMaterialBoolean = false;
                  /*  PositiveMaterialIdentificationBoolean=false;
                    liquidDyePenetrantBoolean = false;*/
                  /*  magneticParticleExamination = false;
                    charpyImpactTesting = false;
                    visualCastingExamination = false;
                    intergranularCorrosionTest = false; */

                    /* MagneticParticleExamination.clear();
                    CharpyImpactTesting.clear();
                    VisualCastingExamination.clear();
                    IntergranularCorrosionTest.clear();
                     getPositiveMaterialIdentificationOptions();
      			    getLiquidDyePenetrantOptions(); */

                }
            }
            else
            {
                bodyMaterialOptions.add(new selectOption('N','N'));
                flmProd.Body_Material__c = 'N';
                getOnChangeBodyMaterial();
            }
        }
        else{
            bodyMaterialOptions.add(new selectOption('N','N'));
            flmProd.Body_Material__c = 'N';
            getOnChangeBodyMaterial();
        }
    }

    public void getOnChangeBodyMaterial(){
        getHousingMaterialOptions();
        getElementMaterialOptions();
      /*  getPositiveMaterialIdentificationOptions();
        getLiquidDyePenetrantOptions();
        getMagneticParticleExamination();
        getCharpyImpactTesting();
        getVisualCastingExamination();
        getIntergranularCorrosionTest();*/
    }

   //Housing Material Method

    public void getHousingMaterialOptions()
    {
       // system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        HousingMaterialOptions.clear();
        System.debug('AAAAAHousing');
        HousingMaterialBoolean = false;
      //  flmProd.Housing_Material__c = null;

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c)
        {

            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'FA_MATL_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_MATL_Cons__c_selectedFields', 'MCHOUS__c');
            parameters.put('FA_MATL_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND MCBODY__c = \''+flmProd.Body_Material__c+ '\' AND (SZC__c=\''+flmProd.Size__c+'\' OR SZC__c= \'-\')'+' AND (NACE__c=\''+flmProd.Nace_Backend__c+'\' OR NACE__c= \'-\')'+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')');

            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCHOUS\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_MATL_Cons__c-MCHOUS__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_MATL_Cons__c-MCHOUS__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                HousingMaterialBoolean = true;
                if(inputAttrValue.size() == 1){
                    HousingMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Housing_Material__c = inputAttrValue[0].Value__c;
                    getOnChangeHousingMaterial();
    				System.debug('AAAAAHousing option1');
                }
                else{
                    HousingMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        System.debug('AAAAAHousing many options');
                        HousingMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }

                  //  getOnChangeHousingMaterial();
                //    ElementMaterialOptions.clear();

                //    PositiveMaterialIdentificationOptions.clear();
               //     LiquidDyePenetrantOptions.clear();
                  /*
                    getPositiveMaterialIdentificationOptions();
      			    getLiquidDyePenetrantOptions();
      			    MagneticParticleExamination.clear();
                    CharpyImpactTesting.clear();
                    VisualCastingExamination.clear();
                    IntergranularCorrosionTest.clear();*/

                    elementMaterialBoolean = false;
                 /*   PositiveMaterialIdentificationBoolean=false;
                    liquidDyePenetrantBoolean = false;*/
                 /*   magneticParticleExamination = false;
                    charpyImpactTesting = false;
                    visualCastingExamination = false;
                    intergranularCorrosionTest = false;*/
                }

            }
            else
            {
                HousingMaterialOptions.add(new selectOption('N','N'));
                flmProd.Housing_Material__c = 'N';
                getOnChangeHousingMaterial();
            }

        }
        else{
              HousingMaterialOptions.add(new selectOption('N','N'));
              flmProd.Housing_Material__c = 'N';
              getOnChangeHousingMaterial();
        }
    }

    public void getOnChangeHousingMaterial(){
        if(!Test.isRunningTest())
        {
           	getElementMaterialOptions();
            getPositiveMaterialIdentificationOptions();
            getLiquidDyePenetrantOptions();
            getMagneticParticleExamination();
            getCharpyImpactTesting();
            getVisualCastingExamination();
            getIntergranularCorrosionTest(); 
        }
        
    }

    //Element Material Method

    public void getElementMaterialOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        ElementMaterialOptions.clear();
        System.debug('AAAAAElement');
        ElementMaterialBoolean = false;
      //  flmProd.Element_Material__c = null;

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
        {

            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'FA_MATL_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_MATL_Cons__c_selectedFields', 'MCELMT__c');
            parameters.put('FA_MATL_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND MCBODY__c = \''+flmProd.Body_Material__c+'\' AND MCHOUS__c = \''+flmProd.Housing_Material__c+  '\' AND (SZC__c=\''+flmProd.Size__c+'\' OR SZC__c= \'-\')'+' AND (NACE__c=\''+flmProd.Nace_Backend__c+'\' OR NACE__c= \'-\')'+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')');

            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCELMT\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_MATL_Cons__c-MCELMT__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_MATL_Cons__c-MCELMT__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                ElementMaterialBoolean = true;
                if(inputAttrValue.size() == 1){
                    ElementMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Element_Material__c = inputAttrValue[0].Value__c;
                    getOnChangeElementMaterial();
                    System.debug('AAAAAElement option1');
                }
                else{
                    ElementMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        System.debug('AAAAAElement option1');
                        ElementMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }

                  //    getPositiveMaterialIdentificationOptions();

                	//getOnChangeElementMaterial();
                //    positiveMaterialIdentificationOptions.clear();

				//	PositiveMaterialIdentificationBoolean=false;

                }
            }
            else
            {
                ElementMaterialOptions.add(new selectOption('N','N'));
                flmProd.Element_Material__c = 'N';
                getOnChangeElementMaterial();
            }
        }
        else{
            ElementMaterialOptions.add(new selectOption('N','N'));
            flmProd.Element_Material__c = 'N';
            getOnChangeElementMaterial();
        }
    }

    public void getOnChangeElementMaterial(){
		getPositiveMaterialIdentificationOptions();
    }


    //Pallet Material Method
    public void getPalletMaterialOptions()
    {
        PalletMaterialOptions.clear();
        PalletMaterialBoolean = true;
    //    flmProd.Pallet_Material__c=null;
		if(flmprod.PTC__c=='8400A')
        {
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = [select Value__c,Text_Description_of_AttributeValue__c from FA_Input_Attr_Value_Desc__c where Attribute__c=:'MCPALL' order by Display_Order__c];
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                if(inputAttrValue.size() == 1){
                    PalletMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Pallet_Material__c = inputAttrValue[0].Value__c;
                }
                else{
                    PalletMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        PalletMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                PalletMaterialBoolean = false;
                PalletMaterialOptions.add(new selectOption('N','N'));
                flmProd.Pallet_Material__c = 'N';
            }
        }
         else
            {
                PalletMaterialBoolean = false;
                PalletMaterialOptions.add(new selectOption('N','N'));
                flmProd.Pallet_Material__c = 'N';
            }
    }

   //Diaphragm Material Method
    public void getDiaphragmMaterialOptions()
    {
        DiaphragmMaterialOptions.clear();
        DiaphragmMaterialBoolean = true;
        flmProd.Diaphragm_Material__c = null;

        if(flmprod.PTC__c=='8400A')
        {
            // Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
		    List<FA_Input_Attr_Value_Desc__c> inputAttrValue = [select Value__c,Text_Description_of_AttributeValue__c from FA_Input_Attr_Value_Desc__c where Attribute__c=:'MCDPHM' order by Display_Order__c];
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                if(inputAttrValue.size() == 1){
                    DiaphragmMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Diaphragm_Material__c = inputAttrValue[0].Value__c;
                  //  getbodyMaterialOptions();
                }
                else{
                    DiaphragmMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        DiaphragmMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                DiaphragmMaterialBoolean = false;
                DiaphragmMaterialOptions.add(new selectOption('N','N'));
                flmProd.Diaphragm_Material__c = 'N';
            }
        }
        else
            {
                DiaphragmMaterialBoolean = false;
                DiaphragmMaterialOptions.add(new selectOption('N','N'));
                flmProd.Diaphragm_Material__c = 'N';
            }
    }

	//Pressure Setting Method
    public void getPressureSettingOptions()
    {
        PressureSettingOptions.clear();
        PressureSettingBoolean = true;
    //    flmProd.Pressure_Setting__c =null;

        if(flmprod.PTC__c=='8400A')
        {
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = [select Value__c,Text_Description_of_AttributeValue__c from FA_Input_Attr_Value_Desc__c where Attribute__c=:'SETTING' order by Display_Order__c];
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                if(inputAttrValue.size() == 1){
                    PressureSettingOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Pressure_Setting__c = inputAttrValue[0].Value__c;
                    getOnChangeSETTING();
                }
                else{
                    PressureSettingOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        PressureSettingOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                  //  getOnChangeSETTING();
                 //   SpringRangeOptions.clear();
                //    SpringRangeBoolean=false;
                }
            }
            else
            {
                PressureSettingBoolean = false;
                PressureSettingOptions.add(new selectOption('N','N'));
                flmProd.Pressure_Setting__c = 'N';
                getOnChangeSETTING();
            }
        }
        else
            {
                PressureSettingBoolean = false;
                PressureSettingOptions.add(new selectOption('N','N'));
                flmProd.Pressure_Setting__c = 'N';
                getOnChangeSETTING();
            }

    }

    public void getOnChangeSETTING(){
        getSpringRangeOptions();
    }

    //Spring Range Method
	public void getSpringRangeOptions()
    {
        SpringRangeOptions.clear();
        SpringRangeBoolean = false;
		//flmProd.Spring_Range__c =null;
		if(flmprod.PTC__c=='8400A')
        {
            if(String.isNotBlank(flmProd.Pressure_Setting__c ) && null != flmProd.Pressure_Setting__c){
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'FA_SPRING_Cons__c','FA_Input_Attr_Value_Desc__c'}));
            parameters.put('FA_SPRING_Cons__c_selectedFields', 'SPRING__c');
            parameters.put('FA_SPRING_Cons__c_whereClause', 'SZC__c = \''+flmProd.Size__c+ '\' AND SETTING__c = \'' +flmProd.Pressure_Setting__c+'\'');

            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'SPRING\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_SPRING_Cons__c-SPRING__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_SPRING_Cons__c-SPRING__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                 SpringRangeBoolean = true;
                if(inputAttrValue.size() == 1){
                    SpringRangeOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Spring_Range__c = inputAttrValue[0].Value__c;
                }
                else{
                    SpringRangeOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        SpringRangeOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                SpringRangeBoolean = false;
                SpringRangeOptions.add(new selectOption('0','0'));
                flmProd.Spring_Range__c = '0';
            }
        }
            else
            {
                    SpringRangeBoolean = false;
                    SpringRangeOptions.add(new selectOption('0','0'));
                    flmProd.Spring_Range__c = '0';
            }
       }
    	else
        {
                SpringRangeBoolean = false;
                SpringRangeOptions.add(new selectOption('0','0'));
                flmProd.Spring_Range__c = '0';
        }
    }


	//PaintingCoating Option Method
    public void getPaintingCoatingOptions()
    {
        PaintingCoatingOptions.clear();
        PaintingCoatingBoolean = true;
     //  flmProd.Painting_Coating_Option__c =null;

           // Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
		    List<FA_Input_Attr_Value_Desc__c> inputAttrValue = [select Value__c,Text_Description_of_AttributeValue__c from FA_Input_Attr_Value_Desc__c where Attribute__c=:'GPAINT' order by Display_Order__c];
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                if(inputAttrValue.size() == 1){
                    PaintingCoatingOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Painting_Coating_Option__c = inputAttrValue[0].Value__c;
                }
                else{
                    PaintingCoatingOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        PaintingCoatingOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                PaintingCoatingBoolean = false;
                PaintingCoatingOptions.add(new selectOption('N','N'));
                flmProd.Painting_Coating_Option__c = 'N';

            }
    }


    //Inlet Option A Method
  public void getInletAOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        InletAOptions.clear();
        InletABoolean = false;
  	//	flmProd.Inlet_Option_A__c =null;

            Map<String, Object> parameters = new Map<String, Object>();

            parameters.put('sObjects',(new List<String>{'FA_PORTS_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_PORTS_Cons__c_selectedFields', 'PortOptionCode__c');
            parameters.put('FA_PORTS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Port__c = \''+'Inlet-A'+ '\' AND SZC__c = \''+flmProd.Size__c+'\' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')'+' AND (ESZC__c=\''+flmProd.ESZC__c+'\' OR ESZC__c= \'-\')');
            //+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'

			parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PORTOPTIONCODE\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                InletABoolean = true;
                if(inputAttrValue.size() == 1){
                    InletAOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Inlet_Option_A__c = inputAttrValue[0].Value__c;
                }
                else{
                    InletAOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        InletAOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                InletAOptions.add(new selectOption('N','N'));
                flmProd.Inlet_Option_A__c = 'N';
            }

    }

    //Inlet Option B Method
     public void getInletBOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        InletBOptions.clear();
        InletBBoolean = false;
  	//	flmProd.Inlet_Option_B__c =null;

            Map<String, Object> parameters = new Map<String, Object>();

            parameters.put('sObjects',(new List<String>{'FA_PORTS_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_PORTS_Cons__c_selectedFields', 'PortOptionCode__c');
            parameters.put('FA_PORTS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Port__c = \''+'Inlet-B'+ '\' AND SZC__c = \''+flmProd.Size__c+'\' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')'+' AND (ESZC__c=\''+flmProd.ESZC__c+'\' OR ESZC__c= \'-\')');
            //+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'

			parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PORTOPTIONCODE\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_PORTS_Cons__c-PortOptionCode__c');
        	parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                InletBBoolean = true;
                if(inputAttrValue.size() == 1){
                    InletBOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Inlet_Option_B__c = inputAttrValue[0].Value__c;
                }
                else{
                    InletBOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        InletBOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                InletBOptions.add(new selectOption('N','N'));
                flmProd.Inlet_Option_B__c = 'N';
            }
    }

    //Inlet Option C Method
     public void getInletCOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        InletCOptions.clear();
        InletCBoolean = false;
  	//	flmProd.Inlet_Option_C__c =null;
            Map<String, Object> parameters = new Map<String, Object>();

            parameters.put('sObjects',(new List<String>{'FA_PORTS_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_PORTS_Cons__c_selectedFields', 'PortOptionCode__c');
            parameters.put('FA_PORTS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Port__c = \''+'Inlet-C'+ '\' AND SZC__c = \''+flmProd.Size__c+'\' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')'+' AND (ESZC__c=\''+flmProd.ESZC__c+'\' OR ESZC__c= \'-\')');
            //+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'

			parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PORTOPTIONCODE\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_PORTS_Cons__c-PortOptionCode__c');
        	parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                InletCBoolean = true;
                if(inputAttrValue.size() == 1){
                    InletCOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Inlet_Option_C__c = inputAttrValue[0].Value__c;
                }
                else{
                    InletCOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        InletCOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                InletCOptions.add(new selectOption('N','N'));
                flmProd.Inlet_Option_C__c = 'N';
            }
    }

    //Outlet Option A Method
     public void getOutletAOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        OutletAOptions.clear();
        OutletABoolean = false;
  	//	flmProd.Outlet_Option_A__c =null;
            Map<String, Object> parameters = new Map<String, Object>();

            parameters.put('sObjects',(new List<String>{'FA_PORTS_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_PORTS_Cons__c_selectedFields', 'PortOptionCode__c');
            parameters.put('FA_PORTS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Port__c = \''+'Outlet-A'+ '\' AND SZC__c = \''+flmProd.Size__c+'\' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')'+' AND (ESZC__c=\''+flmProd.ESZC__c+'\' OR ESZC__c= \'-\')');
            //+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'

			parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PORTOPTIONCODE\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_PORTS_Cons__c-PortOptionCode__c');
			parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                OutletABoolean = true;
                if(inputAttrValue.size() == 1){
                    OutletAOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Outlet_Option_A__c = inputAttrValue[0].Value__c;
                }
                else{
                    OutletAOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        OutletAOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                OutletAOptions.add(new selectOption('N','N'));
                flmProd.Outlet_Option_A__c = 'N';
            }
    }


    //Outlet Option B Method
    public void getOutletBOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        OutletBOptions.clear();
        OutletBBoolean = false;
    //    flmProd.Outlet_Option_B__c =null;

            Map<String, Object> parameters = new Map<String, Object>();

            parameters.put('sObjects',(new List<String>{'FA_PORTS_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_PORTS_Cons__c_selectedFields', 'PortOptionCode__c');
            parameters.put('FA_PORTS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Port__c = \''+'Outlet-B'+ '\' AND SZC__c = \''+flmProd.Size__c+'\' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')'+' AND (ESZC__c=\''+flmProd.ESZC__c+'\' OR ESZC__c= \'-\')');
            //+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'

			parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PORTOPTIONCODE\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_PORTS_Cons__c-PortOptionCode__c');
        	parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                OutletBBoolean = true;
                if(inputAttrValue.size() == 1){
                    OutletBOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Outlet_Option_B__c = inputAttrValue[0].Value__c;
                }
                else{
                    OutletBOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        OutletBOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                OutletBOptions.add(new selectOption('N','N'));
                flmProd.Outlet_Option_B__c = 'N';
            }
    }

    //Outlet Option C Method
     public void getOutletCOptions()
    {
     //   system.debug('flmProd.Drilling__c'+flmProd.Drilling__c);
        OutletCOptions.clear();
        OutletCBoolean = false;
    //    flmProd.Outlet_Option_C__c =null;

            Map<String, Object> parameters = new Map<String, Object>();

            parameters.put('sObjects',(new List<String>{'FA_PORTS_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_PORTS_Cons__c_selectedFields', 'PortOptionCode__c');
            parameters.put('FA_PORTS_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Port__c = \''+'Outlet-C'+ '\' AND SZC__c = \''+flmProd.Size__c+'\' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'+' AND (USCG__c=\''+flmProd.US_Coast_guard__c+'\' OR USCG__c= \'-\')'+' AND (ESZC__c=\''+flmProd.ESZC__c+'\' OR ESZC__c= \'-\')');
            //+' AND (ATEX__c=\''+flmProd.Atex_Certificate_2014_34_EU__c+'\' OR ATEX__c= \'-\')'+' AND (CUTR__c=\''+flmProd.CU_TR__c+'\' OR CUTR__c= \'-\')'

			parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PORTOPTIONCODE\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_PORTS_Cons__c-PortOptionCode__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_PORTS_Cons__c-PortOptionCode__c');
        	parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                OutletCBoolean = true;
                if(inputAttrValue.size() == 1){
                    OutletCOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Outlet_Option_C__c = inputAttrValue[0].Value__c;
                }
                else{
                    OutletCOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        OutletCOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                OutletCOptions.add(new selectOption('N','N'));
                flmProd.Outlet_Option_C__c = 'N';
            }
    }


    //Section F: Product Material and Options fields ends here


   /*********Section G: Examination Option fields starts here************/

    //Radiography Method
   public void getRadiographyOptions()
		{
        RadiographyOptions.clear();
        RadiographyBoolean = false;
    //    flmProd.Radiography__c =null;
      //  flmProd.Positive_Material_Identification__c = null;
       // List<String> whereList = new List<String> {flmProd.Body_Material__c,flmProd.Seat_Material__c, flmProd.Pressure_Pallet_Material__c, flmProd.Vacuum_Pallet_Material__c};
      //  options.add(new selectOption('',''));
        Map<String, Object> parameters = new Map<String, Object>();

        List<FA_EXMOPTC_Cons__c> pmiList = [Select Radiography__c from FA_EXMOPTC_Cons__c where Radiography__c = 'Y' AND (PTC__c =:flmProd.PTC__c)];
        system.debug('pmiList**'+pmiList );
        if(pmiList.size() > 0){
            parameters.put('sObjects',(new List<String>{'FA_Input_Attr_Value_Desc__c'}));
            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'XRAY\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                System.debug('VVVVV&&& inside values block = ');
                RadiographyBoolean = true;
                if(inputAttrValue.size() == 1){
                    RadiographyOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Radiography__c = inputAttrValue[0].Value__c;
                }
                else{
                    RadiographyOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        RadiographyOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
                flmprod.Radiography_Display_Flag__c=true;
            }
            else
            {
                System.debug('VVVVV&&& inside else block = ');
                RadiographyOptions.add(new selectOption('N','N'));
                flmProd.Radiography__c = 'N';
                flmprod.Radiography_Display_Flag__c=false;
                RadiographyBoolean = false;
            }
        }
        else{
            System.debug('VVVVV&&& inside last else block = ');
            RadiographyOptions.add(new selectOption('N','N'));
            flmProd.Radiography__c = 'N';
            flmprod.Radiography_Display_Flag__c=false;
            RadiographyBoolean = false;
            System.debug('VVVVV&&& inside last else block =======RadiographyBoolean ' +RadiographyBoolean);
            System.debug('VVVVV&&& inside last else block ======= ' +flmprod.Radiography_Display_Flag__c);
        }
    }


    //Fillet Weld-Liquid Dye Penetrant Method
    public void getFilletWeldLiquidDyePenetrant()
    {
        FilletWeldLiquidDyePenetrant = false;
    // 	FilletWeldLiquidDyePenetrant.clear();

        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('FA_EXMOPTC_Cons__c_selectedFields', 'FilletWeldLP__c');
        parameters.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND FilletWeldLP__c = \'Y\' ');

       /* parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c','Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,RV_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-MagneticParticle__c&&Value__c = RV_EXMOMC_Cons__c-MagneticParticle__c');
        */
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData.get('FA_EXMOPTC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            FilletWeldLiquidDyePenetrant = true;
        }
        else
        {
            flmProd.Fillet_Weld_Liquid_Dye_Penetrant__c = false;
        }
    }

    //Positive Material Identification Method
   public void getPositiveMaterialIdentificationOptions()
   {
        PositiveMaterialIdentificationOptions.clear();
        PositiveMaterialIdentificationBoolean = false;
      //  flmProd.Positive_Material_Identification__c =null;
        System.debug('Positive Material before calculation');
         if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c && String.isNotBlank(flmProd.Element_Material__c) && null != flmProd.Element_Material__c)
        {

      //  flmProd.Positive_Material_Identification__c = null;
       // List<String> whereList = new List<String> {flmProd.Body_Material__c,flmProd.Seat_Material__c, flmProd.Pressure_Pallet_Material__c, flmProd.Vacuum_Pallet_Material__c};
      //  options.add(new selectOption('',''));
        Map<String, Object> parameters = new Map<String, Object>();

        List<FA_EXMOMC_Cons__c> pmiList = [Select PMI__c from FA_EXMOMC_Cons__c where PMI__c =: 'Y' AND ( MC__c  = :flmProd.Body_Material__c OR MC__c  = :flmProd.Housing_Material__c OR MC__c  = :flmProd.Element_Material__c)];
        system.debug('pmiList**'+pmiList );
        if(pmiList.size() > 0){
            parameters.put('sObjects',(new List<String>{'FA_Input_Attr_Value_Desc__c'}));
            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PMI\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                PositiveMaterialIdentificationBoolean = true;
                if(inputAttrValue.size() == 1){
                    positiveMaterialIdentificationOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Positive_Material_Identification__c = inputAttrValue[0].Value__c;
                    System.debug('Positive Material one option calculation');
                }
                else{
                    positiveMaterialIdentificationOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        System.debug('Positive Material many option calculation');
                        PositiveMaterialIdentificationOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
                flmprod.PMI_Display_Flag__c=true;
            }
            else
            {
                positiveMaterialIdentificationOptions.add(new selectOption('N','N'));
                flmProd.Positive_Material_Identification__c = 'N';
                flmprod.PMI_Display_Flag__c=false;
            }
        }
        else{
            positiveMaterialIdentificationOptions.add(new selectOption('N','N'));
            flmProd.Positive_Material_Identification__c = 'N';
            flmprod.PMI_Display_Flag__c=false;
        }
     }
       else
       {
           positiveMaterialIdentificationOptions.add(new selectOption('N','N'));
           flmProd.Positive_Material_Identification__c = 'N';
           flmprod.PMI_Display_Flag__c=false;
       }
    }

    //Liquid Dye Penetrant Method

   public void getLiquidDyePenetrantOptions()
		{
        liquidDyePenetrantOptions.clear();
        LiquidDyePenetrantBoolean = false;
     //   flmProd.Liquid_Dye_Penetrant__c=null;
        System.debug('Liquitd Dye Penetrant before calculation');
         if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
        {

      //  flmProd.Positive_Material_Identification__c = null;
       // List<String> whereList = new List<String> {flmProd.Body_Material__c,flmProd.Seat_Material__c, flmProd.Pressure_Pallet_Material__c, flmProd.Vacuum_Pallet_Material__c};
      //  options.add(new selectOption('',''));
        Map<String, Object> parameters = new Map<String, Object>();

        List<FA_EXMOMC_Cons__c> pmiList1 = [Select DyePenetrant__c from FA_EXMOMC_Cons__c where DyePenetrant__c =: 'Y' AND ( MC__c  = :flmProd.Body_Material__c OR MC__c  = :flmProd.Housing_Material__c)];
        List<FA_EXMOPTC_Cons__c> pmiList2 = [Select DyePenetrant__c from FA_EXMOPTC_Cons__c where DyePenetrant__c =: 'Y' AND PTC__c=:flmProd.PTC__c];

		system.debug('pmiList1**'+pmiList1 );
		system.debug('pmiList2**'+pmiList2 );
        if(pmiList1.size() > 0 && pmiList2.size() > 0){
            parameters.put('sObjects',(new List<String>{'FA_Input_Attr_Value_Desc__c'}));
            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                system.debug('Options**' );
                LiquidDyePenetrantBoolean = true;
                if(inputAttrValue.size() == 1){
                    system.debug('Options 1**' );
                    liquidDyePenetrantOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Liquid_Dye_Penetrant__c = inputAttrValue[0].Value__c;
                    System.debug('Liquitd Dye Penetrant one option calculation');
                }
                else{
                    system.debug('Options 2 or more**' );
                    liquidDyePenetrantOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        System.debug('Liquitd Dye Penetrant many option calculation');
                        liquidDyePenetrantOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
                flmprod.LDP_Display_Flag__c=true;
            }
            else
            {
                liquidDyePenetrantOptions.add(new selectOption('N','N'));
                flmProd.Liquid_Dye_Penetrant__c = 'N';
                flmprod.LDP_Display_Flag__c=false;
            }
        }
        else{
            liquidDyePenetrantOptions.add(new selectOption('N','N'));
            flmProd.Liquid_Dye_Penetrant__c = 'N';
            flmprod.LDP_Display_Flag__c=false;
        }
     }
       else
       {
           liquidDyePenetrantOptions.add(new selectOption('N','N'));
           flmProd.Liquid_Dye_Penetrant__c = 'N';
           flmprod.LDP_Display_Flag__c=false;
       }
    }

/*	 public void getLiquidDyePenetrantOptions()
 {
        liquidDyePenetrantOptions.clear();
        liquidDyePenetrantBoolean = false;
        flmProd.Liquid_Dye_Penetrant__c = null;

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
		{

            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c','FA_EXMOMC_Cons__c','FA_Input_Attr_Value_Desc__c'}));

            parameters.put('FA_EXMOPTC_Cons__c_selectedFields', 'DyePenetrant__c');
            parameters.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND DyePenetrant__c = \'Y\' ');

            parameters.put('FA_EXMOMC_Cons__c_selectedFields', 'DyePenetrant__c');
      		parameters.put('FA_EXMOMC_Cons__c_whereClause','DyePenetrant__c = \'Y\''+ ' AND (MC__c=\''+flmProd.Body_Material__c+'\' OR MC__c= \''+flmProd.Housing_Material__c+'\')');
       //        parameters.put('FA_EXMOMC_Cons__c_whereClause','MC__c = \''+flmProd.Body_Material__c+'\''+' OR MC__c = \''+flmProd.Housing_Material__c+'\' AND DyePenetrant__c = \'Y\' ');

            parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
            parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,FA_EXMOMC_Cons__c-DyePenetrant__c');
            parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-DyePenetrant__c&&Value__c = FA_EXMOMC_Cons__c-DyePenetrant__c');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<FA_Input_Attr_Value_Desc__c> inputAttrValue = (List<FA_Input_Attr_Value_Desc__c>)processedData.get('FA_Input_Attr_Value_Desc__c');
            //System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                liquidDyePenetrantBoolean = true;

                if(inputAttrValue.size() == 1){
                    positiveMaterialIdentificationOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    flmProd.Liquid_Dye_Penetrant__c = inputAttrValue[0].Value__c;
                }
                else{
                    positiveMaterialIdentificationOptions.add(new selectOption('','-SELECT-'));
                    for(FA_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        liquidDyePenetrantOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                liquidDyePenetrantOptions.add(new selectOption('N','N'));
                flmProd.Liquid_Dye_Penetrant__c = 'N';
            }
        }
            else
                {
                    liquidDyePenetrantOptions.add(new selectOption('N','N'));
                    flmProd.Liquid_Dye_Penetrant__c = 'N';
                }
    }
  */

    //Ultrasonic Examination Method
		public void getUltrasonicExamination()
	{

        ultrasonicExamination = false;
        /*List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));*/
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('FA_EXMOPTC_Cons__c_selectedFields', 'Ultrasonic__c');
        parameters.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Ultrasonic__c = \'Y\' ');

       /* parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c','Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,RV_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-MagneticParticle__c&&Value__c = RV_EXMOMC_Cons__c-MagneticParticle__c');
        */
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData.get('FA_EXMOPTC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 )
        {
            ultrasonicExamination = true;
        }
        else
        {
            flmProd.Ultrasonic_Examination__c = false;
        }
    }

    //Magnetic Particle Examination Method
    	public void getMagneticParticleExamination()
	{
     //   MagneticParticleExamination.clear();
         MagneticParticleExamination = false;

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
        {

        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'FA_EXMOMC_Cons__c'}));
   //     System.debug('AAAAAAAInitial condtion');
        parameters1.put('FA_EXMOPTC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters1.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND MagneticParticle__c = \'Y\' ');
   //     System.debug('AAAAAAAFirst condtion');
        parameters.put('FA_EXMOMC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters.put('FA_EXMOMC_Cons__c_whereClause','MagneticParticle__c = \'Y\'' + ' AND (MC__c=\''+flmProd.Body_Material__c+'\' OR MC__c= \''+flmProd.Housing_Material__c+'\')');
   //		System.debug('AAAAAAASecond condtion');
       //   parameters.put('FA_EXMOMC_Cons__c_whereClause', 'MC__c = \''+flmProd.Body_Material__c+'MC__c = \''+flmProd.Housing_Material__c+'\' AND MagneticParticle__c = \'Y\' ');

        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData1.get('FA_EXMOPTC_Cons__c');
        List<FA_EXMOMC_Cons__c> inputAttrValue2 = (List<FA_EXMOMC_Cons__c>)processedData.get('FA_EXMOMC_Cons__c');
        System.debug('&&& inputAttrValue = '+inputAttrValue);
        System.debug('&&& inputAttrValue2 = '+inputAttrValue2);
        if((inputAttrValue != null && inputAttrValue.size() > 0) && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            System.debug('Magnetic Particle True condtion');
            MagneticParticleExamination = true;
        }
        else
        {
            System.debug('AAAAAAAInitial False condtion');
            flmProd.Magnetic_Particle_Examination__c = false;
        }
      }
        else
            flmProd.Magnetic_Particle_Examination__c=false;
    }

    //Brinell hardness examination Method
    	public void getBrinellHardnessExamination()
	{
        brinellHardnessExamination = false;

        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('FA_EXMOPTC_Cons__c_selectedFields', 'BrinellHardness__c');
        parameters.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND BrinellHardness__c = \'Y\' ');

        /* parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c','Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,RV_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-MagneticParticle__c&&Value__c = RV_EXMOMC_Cons__c-MagneticParticle__c');
        */
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData.get('FA_EXMOPTC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 )
        {
            brinellHardnessExamination = true;
        }
        else
        {
            flmProd.Brinell_Hardness_Examination__c = false;
        }
    }


    //Charpy Impact Testing Method
    	public void getCharpyImpactTesting()
	{
        charpyImpactTesting = false;

        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'FA_EXMOMC_Cons__c'}));

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
        {

        parameters1.put('FA_EXMOPTC_Cons__c_selectedFields', 'CharpyImpact__c');
        parameters1.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND CharpyImpact__c = \'Y\' ');

        parameters.put('FA_EXMOMC_Cons__c_selectedFields', 'CharpyImpact__c');
      	parameters.put('FA_EXMOMC_Cons__c_whereClause','CharpyImpact__c = \'Y\'' + ' AND (MC__c=\''+flmProd.Body_Material__c+'\' OR MC__c= \''+flmProd.Housing_Material__c+'\')');

        /* parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c','Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,FA_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-MagneticParticle__c&&Value__c = FA_EXMOMC_Cons__c-MagneticParticle__c');
        */
        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData1.get('FA_EXMOPTC_Cons__c');
        List<FA_EXMOMC_Cons__c> inputAttrValue2 = (List<FA_EXMOMC_Cons__c>)processedData.get('FA_EXMOMC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            System.debug('CharpyTesting True Condition');
            charpyImpactTesting = true;
        }
        else
        {
            flmProd.Charpy_Impact_Testing__c = false;
        }
      }
        else
            flmProd.Charpy_Impact_Testing__c=false;
    }

    //Visual Casting Examination Method
    public void getVisualCastingExamination()
    {
        visualCastingExamination = false;
        system.debug('flmProd.PTC__c'+flmProd.PTC__c);

        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'FA_EXMOMC_Cons__c'}));

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
        {

        parameters1.put('FA_EXMOPTC_Cons__c_selectedFields', 'VisualCasting__c');
        parameters1.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND VisualCasting__c = \'Y\' ');

        parameters.put('FA_EXMOMC_Cons__c_selectedFields', 'VisualCasting__c');
      	parameters.put('FA_EXMOMC_Cons__c_whereClause','VisualCasting__c = \'Y\'' + ' AND (MC__c=\''+flmProd.Body_Material__c+'\' OR MC__c= \''+flmProd.Housing_Material__c+'\')');

        /* parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c','Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,FA_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-MagneticParticle__c&&Value__c = FA_EXMOMC_Cons__c-MagneticParticle__c');
        */
        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData1.get('FA_EXMOPTC_Cons__c');
        List<FA_EXMOMC_Cons__c> inputAttrValue2 = (List<FA_EXMOMC_Cons__c>)processedData.get('FA_EXMOMC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            System.debug('Visual Casting True Condition');
            visualCastingExamination = true;
           // flmProd.Visual_Casting_Examination__c=true;
        }
        else
        {
            flmProd.Visual_Casting_Examination__c = false;
        }
      }
        else
            flmProd.Visual_Casting_Examination__c=false;
    }


    //Intergranular Corossion Test Method
		public void getIntergranularCorrosionTest()
	{
        intergranularCorrosionTest = false;
        /*List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));*/
        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'FA_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'FA_EXMOMC_Cons__c'}));

        if(String.isNotBlank(flmProd.Body_Material__c ) && null != flmProd.Body_Material__c && String.isNotBlank(flmProd.Housing_Material__c ) && null != flmProd.Housing_Material__c)
        {

        parameters1.put('FA_EXMOPTC_Cons__c_selectedFields', 'Intergranular_Corrosion__c');
        parameters1.put('FA_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+flmProd.PTC__c+'\' AND Intergranular_Corrosion__c = \'Y\' ');

        parameters.put('FA_EXMOMC_Cons__c_selectedFields', 'IntergranularCorrosion__c');
      	parameters.put('FA_EXMOMC_Cons__c_whereClause','IntergranularCorrosion__c = \'Y\'' + ' AND (MC__c=\''+flmProd.Body_Material__c+'\' OR MC__c= \''+flmProd.Housing_Material__c+'\')');

        /* parameters.put('FA_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c','Value__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('FA_Input_Attr_Value_Desc__c_referenceFields', 'FA_EXMOPTC_Cons__c-DyePenetrant__c,FA_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('FA_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = FA_EXMOPTC_Cons__c-MagneticParticle__c&&Value__c = FA_EXMOMC_Cons__c-MagneticParticle__c');
        */
        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<FA_EXMOPTC_Cons__c> inputAttrValue = (List<FA_EXMOPTC_Cons__c>)processedData1.get('FA_EXMOPTC_Cons__c');
        List<FA_EXMOMC_Cons__c> inputAttrValue2 = (List<FA_EXMOMC_Cons__c>)processedData.get('FA_EXMOMC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            System.debug('Intergranular True Condition');
            intergranularCorrosionTest = true;
        }
        else
        {
            flmProd.Intergranular_Corossion_Test__c = false;
        }
      }
        else
            flmProd.Intergranular_Corossion_Test__c=false;
    }


    /*******Section G: Examination Option fields ends here********/



    /******* Section H: Certificate Document Or Sourcing Restrictions fields starts here ****************/



    /******* Section H: Certificate Document Or Sourcing Restrictions fields ends here ****************/

    /* Save and continue for Product Material and Options section*/

    public PageReference saveProductMaterialAndOptions() {

        try {
                 bShowEditButton = false; //added by piyush
                 bShowReturnToProductSelectionButton = false;  //added by piyush
                flmprod.Product_Material_and_Options_flag__c = true;
                flmProd.Bypass__c=false;
                flmProd.IsConfig__c=false;//added by piyush
                update flmProd;
                getRadiographyOptions();
                System.debug('First Save and Continue button');
                getPositiveMaterialIdentificationOptions();
                getLiquidDyePenetrantOptions();
                getMagneticParticleExamination();
                getCharpyImpactTesting();
                getVisualCastingExamination();
                getIntergranularCorrosionTest();
             //   getUltrasonicExamination();
              //  getBrinellHardnessExamination();
             //   getFilletWeldLiquidDyePenetrant();
              //  getVisualCastingExamination();
             //   getIntergranularCorrosionTest();

              //  flmProd.Bypass__c=false;
              //  flmprod.Product_Material_and_Options_flag__c = true;
                update flmProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    /* Save and continue for Examination option section*/
   public PageReference saveExaminationOption() {
        try {
            bShowEditButton = false; //added by piyush
            bShowReturnToProductSelectionButton = false;  //added by piyush
            flmProd.Bypass__c=false;
            flmprod.Examination_Option_flag__c = true;
            flmprod.IsConfig__c = false;
            update flmProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    /* Save and continue for Certificate Document Or Sourcing Restrictions section*/
    public PageReference saveCertificateDocumentOrSourcingRestrictions() {
        reorderControl = true;
           flmprod.IsConfig__c=true;


		System.debug('config outside' +flmprod.IsConfig__c);
        try {
            flmProd.Bypass__c=false;
            flmprod.Certificate_and_sourcing_flag__c = true;

            System.debug('config inside' +flmprod.IsConfig__c);
            	decimal decGasGrp=0;             
             decGasGrp=[SELECT GasGroupLevel__c from FA_MasterBlaster__c where GasGroupLevel__c>=:flmprod.Gas_Group_Code__c and PTC__c=:flmprod.PTC__c][0].GasGroupLevel__c;
             flmprod.GasGroupLevel_Backend__c=string.valueOf(decGasGrp);
            FAOU=new FAOutputUtility(flmprod.Id);
            update flmprod;
            getPricinglist();
         //   getCosts();
            getLeadTimeRecords();
			GetQuoteDescriptionRecords();
		     
            //Partnumberbase calculation method
                    string strBRANDCODE='';
                    if(flmprod.Brand__c=='Groth')
                        strBRANDCODE='V';
            		else if(flmprod.Brand__c=='CDC')
                        strBRANDCODE='D';
            		else if(flmprod.Brand__c=='LAMOT')
                        strBRANDCODE='T';
            		else if(flmprod.Brand__c=='LVA')
                        strBRANDCODE='L';
            		string strPTC=flmprod.PTC__c;
					string strSZC=flmprod.Size__c;
                    System.debug('Flame1111111-----');
                    string strESZC=flmprod.ESZC__c;
					string strMCBODY=flmprod.Body_Material__c;
					string strMCHOUS=flmprod.Housing_Material__c;
					string strMCELMT=flmprod.Element_Material__c;
					string strHCLASS=flmprod.Drilling__c;
					//string strPNGPFACE=(String) sObj.get(mapFAFields.get('PNGPFACE'));
					string strGOUTOP_OptA=flmprod.Outlet_Option_A__c;
					string strGINLOP_OptA=flmprod.Inlet_Option_A__c;
					System.debug('Flame-----');
                    result FAAttributes = new Result();
                    Map<string, string> mapVals = new Map<string, string>();
                    mapVals.put('PTC',strPTC);
                    mapVals.put('MCBODY',strMCBODY);

                    List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
                        FAAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','FA_Attributes_Translation__c','FA_Attributes_Details__c',mapVals,selectCols);
                    List<string> listName = new List<string>();
                    listName.add('PNMODEL');
                    listName.add('PNGPFACE');
                    Map<string,string> mapAttValues= new Map<string,string>();
                    if (FAAttributes.bResult) {
                        for(sObject objD : FAAttributes.objResultList)
                        {
                            if(listName.contains((string) objD.get('Attribute__c'))) {
                                mapAttValues.put((string) objD.get('Attribute__c'),(string) objD.get('Text__c'));
                            }
                        }
                    }

                    String strPNMODEL=mapAttValues.get('PNMODEL');
                    String strPNGPFACE=mapAttValues.get('PNGPFACE');
                    flmProd.Part_Number_Base__c=strBRANDCODE+strPNMODEL+strSZC+strESZC+ strMCBODY + strMCHOUS + strMCELMT + strHCLASS + strPNGPFACE + strGINLOP_OptA + strGOUTOP_OptA;
			//For setting value after unchecking override checbkox
            flmprod.Part_Number_Base_Original__c=strBRANDCODE+strPNMODEL+strSZC+strESZC+ strMCBODY + strMCHOUS + strMCELMT + strHCLASS + strPNGPFACE + strGINLOP_OptA + strGOUTOP_OptA;

            System.debug('PartNumber base' +flmProd.Part_Number_Base__c);

            //partnumber section code
             if(flmProd.Quote_Description_Engineer_Override__c == true)
                {
                    flmProd.ASSYPARTEXISTING__c = '';
                }
                else
                {
                    Result partNumberResult = AssyPartDefinationProcessor.getPartNumberExisting(flmProd.Part_Number_Base__c,flmProd,'FlameProducts');
                    if(partNumberResult.bResult ==  true)
                    {
                        flmProd.ASSYPARTEXISTING__c = partNumberResult.strRetValue;
                    }
                    else
                    {
                        flmProd.ASSYPARTEXISTING__c = '';
                    }
                }

            	update flmProd;
                if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    string strProdOver='';
                    if(String.isNotBlank(flmProd.OA__c)){
                        strProdOver += flmProd.OA__c +'\n';
                    }
                    if(String.isNotBlank(flmProd.OB__c)){
                        strProdOver += flmProd.OB__c+'\n';
                    }
                    if(String.isNotBlank(flmProd.OW__c)){
                        strProdOver += flmProd.OW__c;
                    }
                    string strquoteDes1 = strProdOver;
                    strquoteDes1.replaceAll('\n', '</BR>');
                    quoteLine.Config_Record_Id__c = flmProd.id;
                    quoteLine.SBQQ__Quantity__c=flmProd.Quantity__c;
                    quoteLine.Engineering_Notes__c = flmProd.Engineering_Notes__c;
                    if(flmprod.Non_Discountable_Price__c!=9999999 && flmprod.Non_Discountable_Price__c!=8888888)
                        quoteLine.Non_Discountable_List_Price__c =  flmprod.Non_Discountable_Price__c/flmProd.Quantity__c;
                    else
                        quoteLine.Non_Discountable_List_Price__c =  flmprod.Non_Discountable_Price__c;
                    quoteLine.Discountable_List_Price__c = flmProd.Discountable_Price__c;
                    quoteLine.Leadtime_Site_10__c = flmProd.Lead_Time_Site_10__c;
                    quoteLine.Leadtime_Site_20__c = flmProd.Lead_Time_Site_20__c;
                    quoteLine.Leadtime_Site_30__c = flmProd.Lead_Time_Site_30__c;
                    quoteLine.Leadtime_Site_40__c = flmProd.Lead_Time_Site_40__c;
                    quoteLine.Body_Material__c=flmProd.Body_Material__c;
                   // quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('</BR>', '\n');
                    quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('&','&amp').replaceAll('>','&gt').replaceAll('<','&lt').replaceAll('\n', '<BR>');
                    upsert quoteLine;
                }

        }
        catch(Exception dmle)
        {
            if(!ReorderFlag)
            	ApexPages.addMessages(dmle);
            strURL = 'error';
            return null;
        }

        selectedTab = 'ProductReview';// added bu piyush

        pageReference reloadpage2 = new pageReference('/apex/ConfigFLAME?qid='+quotelineId);
        reloadpage2.setRedirect(true);
        return reloadpage2;

     //   return null;
    }


		public string strquoteDes {
        get {

            FA_Output__c faoutput = getFAOutputRecord(flmProd.Id);
            String strProdOver = '';
            if(String.isNotBlank(faOutput.OA_Override__c)){
                strProdOver += faOutput.OA_Override__c +'<BR/><BR/>';
            }
            if(String.isNotBlank(faOutput.OB_Override__c)){
                strProdOver += faOutput.OB_Override__c+'<BR/><BR/>';
            }
            if(String.isNotBlank(faOutput.OW_Override__c)){
                strProdOver += faOutput.OW_Override__c;
            }
            strquoteDes = strProdOver;
            return strquoteDes.replaceAll('\n', '<BR/>');
        }
        set {
            this.strquoteDes=value;
        }
    }

    public string strURL{get;set;}


    public pageReference goBackToQuote() {
        Id qID = [SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quotelineId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL =  '/s/detail/'+qID ;
        }else{
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }
        return null;
    }


    public pageReference goBack() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quotelineId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            //strURL =  '/s/detail/'+qID ;
            strURL = '/s/flameproductscmp?quoteId='+qID + '&configId=' + flmProd.Id;
        }else{
            //strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
            strURL = '/lightning/cmp/c__flameProductsCmp?c__configId='+flmProd.Id + '&c__quoteId=' +qID;
        }
        //PageReference pageRef = new PageReference('/lightning/r/SBQQ__Quote__c/'+qID+'/view');
        //pageRef.setRedirect(true);
        return null;
    }


     /*public pageReference goBack() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quotelineId].SBQQ__Quote__c;
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
    }*/




	//Pricing,Lead and Quote Description Methods

   //Pricing Method
   public FA_Output__c getPricefaOutputInstance()
    {
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        faOutput.BrinnellHardnessExamination__c=null;
		faOutput.CharpyImpactTesting__c=null;
		faOutput.FilletWeldLiquidDyePenetrantExamination__c=null;
		faOutput.InletOptionPriceAdder__c=null;
		faOutput.InletTWellTCouplePriceAdder__c=null;
		faOutput.IntergranularCorrosionTesting__c=null;
		faOutput.LiquidDyePenetrantExamination__c=null;
		faOutput.MagneticParticleExamination__c=null;
		faOutput.ModelBase__c=null;
		faOutput.OutletOptionPriceAdder__c=null;
		faOutput.OutletTWellTCouplePriceAdder__c	=null;
		faOutput.PaintOptions__c=null;
		faOutput.PositiveMaterialIdentification__c=null;
		faOutput.RadiographicExamination__c=null;
		faOutput.Spring__c=null;
		faOutput.UltrasonicExamination__c=null;
		faOutput.VisualCastingExamination__c=null;
		faOutput.MaterialSourcing__c=null;
        faOutput.Price_Total__c = null;

		return faOutput;
    }


	public decimal TotalFAPrice{set;get;}
    public decimal TotalFAPriceOverride{set;get;}
    public decimal NonDiscountablePriceEach{set;get;}
    public decimal ListPriceEach{set;get;}

    public list<priceWrapper > FAPriceWrapperList{set;get;}

    public class priceWrapper
    {
        public FA_Price_Details__c faPrice{get; set;}
        public Decimal faPriceOverride{get; set;}
        priceWrapper()
        {
            faPrice = new FA_Price_Details__c();
            faPriceOverride = 0.00;
        }
    }
   // public list<FA_Price_Details__c > FAPricingList{set;get;}
    //BGR Pricing outputs
    public void getPricinglist()
    {
        FAPriceWrapperList.clear();
        getPricefaOutputInstance();
     //   FAPricingList.clear();
        TotalFAPrice = 0.00;
        TotalFAPriceOverride = 0.00;
        NonDiscountablePriceEach = 0.00;
     //   FAPricingList = new list<FA_Price_Details__c >();
        result prncgResult=new result();
        // BGROutputUtility myStrcDetail = new BGROutputUtility(flmProd.Id);
        prncgResult=FAOU.getPricing();
        if(flmprod.IsConfig__c)
        {
            if(prncgResult.bResult)
            {
                boolean has9999999 = false;
                boolean has8888888 = false;

                /***********************************************/
                //Method to find missing price elements
                List<String> uniqueListSZC=new List<String>();
                list<FA_Price_Details__c> pricelementss=new list<FA_Price_Details__c>();
                for(FA_Price_Details__c eachFAMB : [SELECT Price__c,Pricing_Element__c FROM FA_Price_Details__c
                                                                                                                 order by Pricing_Element__c]){
                        if(!uniqueListSZC.contains(eachFAMB.Pricing_Element__c))
                        {
                            pricelementss.add(eachFAMB);
                            uniqueListSZC.add(eachFAMB.Pricing_Element__c);
                       }
                }
                /***************************/
				list<string> priceelements=new list<string>();

				FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
                 for (sObject sobj:prncgResult.objResultList)
                {
                    FA_Price_Details__c  FAPricingRecord = new FA_Price_Details__c ();
                    FAPricingRecord = (FA_Price_Details__c )sobj;
                    String fieldAPI;
                    fieldAPI = FAPricingRecord.Pricing_Element__c;
                        if(FAPricingRecord.Pricing_Element__c.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }

                        fieldAPI = fieldAPI+'__c';
                        Decimal priceOverride = 0.00;
                        if(faOutput.get(fieldAPI) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            faOutput.put(fieldAPI, FAPricingRecord.Price__c);
                            priceOverride = FAPricingRecord.Price__c;
                        }
                        else
                        {
                            if(flmprod.Price_Engineer_Override__c) {
                            	
                                priceOverride = (Decimal)faOutput.get(fieldAPI);
                                
                            } else {
                                
                                faOutput.put(fieldAPI, FAPricingRecord.Price__c);
                            	priceOverride = FAPricingRecord.Price__c;
                            }
                        }
                        TotalFAPrice += FAPricingRecord.Price__c;
                        if(priceOverride == 9999999)
                        {
                            has9999999 = true;
                            TotalFAPriceOverride = 9999999.00;
                        }
                    	if(priceOverride == 8888888 && has9999999==false)
                        {
                            has8888888 = true;
                            TotalFAPriceOverride = 8888888.00;
                        }
                        if(has8888888 == false && has9999999==false )
                        {
                            TotalFAPriceOverride += priceOverride;
                        }

                    	priceelements.add(FAPricingRecord.Pricing_Element__c);

                        priceWrapper priceWrapperInstance = new priceWrapper();
                    	priceWrapperInstance.faPrice = FAPricingRecord;
                        priceWrapperInstance.faPriceOverride = priceOverride.setScale(2);
                        FAPriceWrapperList.add(priceWrapperInstance);
                        //RVPricingList.add(RVPricingRecord);

                }


                for (sObject sobj1:pricelementss)
                {
                    FA_Price_Details__c  FAPricingRecord2 = new FA_Price_Details__c ();
                    FAPricingRecord2 = (FA_Price_Details__c )sobj1;
                    string fieldAPI;
                    fieldAPI = FAPricingRecord2.Pricing_Element__c;
                      if(!priceelements.contains(FAPricingRecord2.Pricing_Element__c))
                        {
                                if(FAPricingRecord2.Pricing_Element__c.contains(' '))
                            {
                                fieldAPI = fieldAPI.replace(' ', '_');
                            }

                            fieldAPI = fieldAPI+'__c';
                            Decimal priceOverride;
                            if(faOutput.get(fieldAPI) == null)
                            {
                                //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                                faOutput.put(fieldAPI, 8888888.00);
                                priceOverride = 8888888.00;
                            }
                            else
                            {
                                	priceOverride = (Decimal)faOutput.get(fieldAPI);   //8888888;
                            }
                         //   TotalFAPrice += FAPricingRecord2.Price__c;
                            if(has9999999==false && priceOverride==8888888)
                            {
                                has8888888 = true;
                                TotalFAPriceOverride = 8888888.00;
                            }
                            if(has8888888 == false && has9999999==false )
                            {
                                TotalFAPriceOverride += priceOverride;
                            }

                            FAPricingRecord2.Price__c=8888888.00;
                            priceWrapper priceWrapperInstance = new priceWrapper();
                            priceWrapperInstance.faPrice = FAPricingRecord2;
                            priceWrapperInstance.faPriceOverride =priceOverride.setScale(2);  // priceOverride.setScale(2);
                            FAPriceWrapperList.add(priceWrapperInstance);

                           /* if(has9999999 == false) //FAPricingRecord2.Price_Override__c == 8888888 &&
                            {
                                has8888888 = true;
                                TotalFAPriceOverride = 8888888.00;
                            }  */
                          //  uniqueListprice.add(FAPricingRecord2.Pricing_Element__c);
                        }

                }

                if(flmProd.Quantity__c != null && flmProd.Quantity__c != 0)
                {
                    if(has9999999==false && has8888888==false){
                        	ListPriceEach=TotalFAPriceOverride + ( NonDiscountablePriceEach / flmprod.Quantity__c);
                            flmProd.List_Price_Each__c = ListPriceEach;
                        System.debug('Price List Each---Normal' +flmprod.List_Price_Each__c);
                            flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    	}
                     if(has9999999==true)
                    {
                        ListPriceEach = TotalFAPriceOverride;
                        flmProd.List_Price_Each__c=ListPriceEach;
                        System.debug('Price List Each---999999999' +flmprod.List_Price_Each__c);
                        flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    }
                    else if(has8888888==true){
                        ListPriceEach = TotalFAPriceOverride;
                        flmProd.List_Price_Each__c=ListPriceEach;
                        flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    }
                    flmProd.Non_Discountable_Price__c = NonDiscountablePriceEach;
                }
            }
        }
    }

    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultPricing()
    {
        boolean has9999999=false;
        boolean has8888888=false;
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        if(flmProd.Price_Engineer_Override__c == false && FAPriceWrapperList != null && FAPriceWrapperList.size() > 0)
        {
            TotalFAPrice = 0.0;
            TotalFAPriceOverride = 0.0;
            for(priceWrapper prv : FAPriceWrapperList)
            {
                if(String.isNotBlank(prv.faPrice.Pricing_Element__c))
                {
                    String fieldAPI = prv.faPrice.Pricing_Element__c;
                    if(prv.faPrice.Pricing_Element__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }

                    fieldAPI = fieldAPI+'__c';

                    faOutput.put(fieldAPI, prv.faPrice.Price__c);
                    if(prv.faPrice.Price__c != 9999999)
                    {
                        TotalFAPrice += prv.faPrice.Price__c;
                        TotalFAPriceOverride += prv.faPrice.Price__c;
                    }
                }
            }

             if(flmProd.Quantity__c != null && flmProd.Quantity__c != 0)
                {
                    if(has9999999==false && has8888888==false){
                        	ListPriceEach=TotalFAPriceOverride + ( NonDiscountablePriceEach / flmprod.Quantity__c);
                            flmProd.List_Price_Each__c = ListPriceEach;
                        System.debug('Price List Each---Normal' +flmprod.List_Price_Each__c);
                            flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    	}
                     if(has9999999==true)
                    {
                        ListPriceEach = TotalFAPriceOverride;
                        flmProd.List_Price_Each__c=ListPriceEach;
                        System.debug('Price List Each---999999999' +flmprod.List_Price_Each__c);
                        flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    }
                    else if(has8888888==true){
                        ListPriceEach = TotalFAPriceOverride;
                        flmProd.List_Price_Each__c=ListPriceEach;
                        flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    }
                    flmProd.Non_Discountable_Price__c = NonDiscountablePriceEach;
                   // update flmProd;
                }
            upsert faOutput;
        }
        update flmprod;
        getPricinglist();
        return null;
    }
    //* @ Save Price Override on click on save
    Public pageReference SavePriceOverride()
    {
        boolean has9999999=false;
        boolean has8888888=false;
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        if(FAPriceWrapperList != null && FAPriceWrapperList.size() > 0)
        {
            TotalFAPriceOverride = 0.0;
            //RV_Outputs__c rvOutsideInstance = getPriceRVOutputInstance();
            for(priceWrapper prv : FAPriceWrapperList)
            {
                if(String.isNotBlank(prv.faPrice.Pricing_Element__c))
                {
                    String fieldAPI = prv.faPrice.Pricing_Element__c;
                    if(prv.faPrice.Pricing_Element__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }

                    fieldAPI = fieldAPI+'__c';

                    faOutput.put(fieldAPI, prv.faPriceOverride);
                    System.debug('---> fieldAPI = '+fieldAPI+', prv.faPriceOverride = '+faOutput.get(fieldAPI));
                   /* if(prv.faPrice.Price__c != 9999999 && prv.faPrice.Price__c != 8888888)
                    {
                        TotalFAPrice += prv.faPrice.Price__c;
                        TotalFAPriceOverride += prv.faPrice.Price__c;
                       // TotalFAPriceOverride += prv.faPriceOverride;
                    }*/
                    if(prv.faPriceOverride != 9999999 && prv.faPriceOverride != 8888888)
                    {
                        TotalFAPrice +=prv.faPriceOverride;
                        TotalFAPriceOverride += prv.faPriceOverride;
                    }
                    if(prv.faPriceOverride == 9999999)
                    {
                        has9999999=true;
                        TotalFAPriceOverride=9999999.00;
                    }
                    if(prv.faPriceOverride == 8888888 && has9999999==false){
                        has8888888=true;
                        TotalFAPriceOverride=8888888.00;
                    }

                    faOutput.Price_Total__c = TotalFAPriceOverride;

                }
            }
            System.debug('TotalFAPriceOverride----' +TotalFAPriceOverride);
            if(flmprod.Quantity__c != null && flmprod.Quantity__c != 0)
            {
                if(has9999999==false && has8888888==false){
                        	ListPriceEach=TotalFAPriceOverride + ( NonDiscountablePriceEach / flmprod.Quantity__c);
                            flmProd.List_Price_Each__c = ListPriceEach;
                            flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    	}
                     if(has9999999==true)
                    {
                        ListPriceEach = 9999999.00;
                        TotalFAPriceOverride=9999999.00;
                        flmProd.List_Price_Each__c=ListPriceEach;
                        flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    }
                    else if(has8888888==true){
                        ListPriceEach = 8888888.00;
                        TotalFAPriceOverride=8888888.00;
                        flmProd.List_Price_Each__c=ListPriceEach;
                        flmProd.Discountable_Price__c = TotalFAPriceOverride;
                    }
                    flmProd.Non_Discountable_Price__c = NonDiscountablePriceEach;
            }
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                if(flmprod.Non_Discountable_Price__c!=9999999 && flmprod.Non_Discountable_Price__c!=8888888)
                    quoteLine.Non_Discountable_List_Price__c =  flmprod.Non_Discountable_Price__c/flmProd.Quantity__c;
                else
                    quoteLine.Non_Discountable_List_Price__c =  flmprod.Non_Discountable_Price__c;
                quoteLine.Discountable_List_Price__c = flmprod.Discountable_Price__c;
                upsert quoteLine;
            }
            upsert faOutput;
            update flmprod;
        }
        return null;
    }



    //Lead Method
    public Integer Total10{set;get;}
    public Integer Total20{set;get;}
    public Integer Total30{set;get;}
    public Integer Total40{set;get;}
    public Integer Total10Override{set;get;}
    public Integer Total20Override{set;get;}
    public Integer Total30Override{set;get;}
    public Integer Total40Override{set;get;}
    public list<LeadTimeWrapper> FALeadTimeList{set;get;}

    public FA_Output__c getLeadFAOutputInstance()
    {
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        faOutput.Base_10__c=null;
		faOutput.BrinnelHardnessExam_10__c=null;
		faOutput.CharpyImpactTest_10__c=null;
		faOutput.FilWeldLiqDyePenExam_10__c=null;
		faOutput.IntergranularCorrosionTesting_10__c=null;
		faOutput.LiquidDyePenetrantExamination_10__c=null;
		faOutput.MagParticleExam_10__c=null;
		faOutput.Painting_10__c=null;
		faOutput.PositiveMaterialIdentification_10__c=null;
		faOutput.Radiography_10__c=null;
		faOutput.UltrasonicExam_10__c=null;
		faOutput.VisualCastingExamination_10__c=null;
		faOutput.Base_20__c=null;
		faOutput.BrinnelHardnessExam_20__c=null;
		faOutput.CharpyImpactTest_20__c=null;
		faOutput.FilWeldLiqDyePenExam_20__c=null;
		faOutput.IntergranularCorrosionTesting_20__c=null;
		faOutput.LiquidDyePenetrantExamination_20__c=null;
		faOutput.MagParticleExam_20__c=null;
		faOutput.Painting_20__c=null;
		faOutput.PositiveMaterialIdentification_20__c=null;
		faOutput.Radiography_20__c=null;
		faOutput.UltrasonicExam_20__c=null;
		faOutput.VisualCastingExamination_20__c=null;
		faOutput.Base_30__c=null;
		faOutput.BrinnelHardnessExam_30__c=null;
		faOutput.CharpyImpactTest_30__c=null;
		faOutput.FilWeldLiqDyePenExam_30__c=null;
		faOutput.IntergranularCorrosionTesting_30__c=null;
		faOutput.LiquidDyePenetrantExamination_30__c=null;
		faOutput.MagParticleExam_30__c=null;
		faOutput.Painting_30__c=null;
		faOutput.PositiveMaterialIdentification_30__c=null;
		faOutput.Radiography_30__c=null;
		faOutput.UltrasonicExam_30__c=null;
		faOutput.VisualCastingExamination_30__c=null;
		faOutput.Base_40__c=null;
		faOutput.BrinnelHardnessExam_40__c=null;
		faOutput.CharpyImpactTest_40__c=null;
		faOutput.FilWeldLiqDyePenExam_40__c=null;
		faOutput.IntergranularCorrosionTesting_40__c=null;
		faOutput.LiquidDyePenetrantExamination_40__c=null;
		faOutput.MagParticleExam_40__c=null;
		faOutput.Painting_40__c=null;
		faOutput.PositiveMaterialIdentification_40__c=null;
		faOutput.Radiography_40__c=null;
		faOutput.UltrasonicExam_40__c=null;
		faOutput.VisualCastingExamination_40__c=null;
		faOutput.MaterialSourceRestrictions_10__c=null;
        faOutput.MaterialSourceRestrictions_20__c=null;
        faOutput.MaterialSourceRestrictions_30__c=null;
        faOutput.MaterialSourceRestrictions_40__c=null;

        return faOutput;
    }


	public class LeadTimeWrapper
    {
        public GlobalLeadTime__c leadTimeRec{get;set;}
        public String item{get;set;}
        public Integer x10{get;set;}
        public Integer x20{get;set;}
        public Integer x30{get;set;}
        public Integer x40{get;set;}
        public Integer x10Override{get;set;}
        public Integer x20Override{get;set;}
        public Integer x30Override{get;set;}
        public Integer x40Override{get;set;}
        public Id queue10Id{get;set;}
        public Id queue20Id{get;set;}
        public Id queue30Id{get;set;}
        public Id queue40Id{get;set;}
    }
    /*@Method to retrive RV lead Time information*/
    public void getLeadTimeRecords()  //List<LeadTimeWrapper>
    {
        FALeadTimeList.clear();
        getLeadFAOutputInstance();
        Total10 = 0;
        Total20 = 0;
        Total30 = 0;
        Total40 = 0;
        Total10Override = 0;
        Total20Override = 0;
        Total30Override = 0;
        Total40Override = 0;
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        list<integer> site10=new list<integer>();
        list<integer> site20=new list<integer>();
        list<integer> site30=new list<integer>();
        list<integer> site40=new list<integer>();

        list<integer> Normalsite10=new list<integer>();
        list<integer> Normalsite20=new list<integer>();
        list<integer> Normalsite30=new list<integer>();
        list<integer> Normalsite40=new list<integer>();

        if(flmprod.IsConfig__c){
            System.debug('Lead Time block');
            Result leadResult = FAOU.getLeadTime();
            System.debug('Lead Time block 2');
            Set<String> runTimeSchedule = new Set<String>();
            Set<String> queueTimeSchedule = new Set<String>();
            Map<String,String> scheduleVsItem = new Map<String, String>();
            Map<String,List<String>> scheduleVsAllItem = new Map<String, List<String>>();
            Map<String, LeadTimeWrapper> queueTimeItemMap = new Map<String, LeadTimeWrapper>();
            LeadTimeWrapper queueTimeItem = new LeadTimeWrapper();
            queueTimeItem.item = 'Queue Time';
            queueTimeItem.x10 = 0;
            queueTimeItem.x20 = 0;
            queueTimeItem.x30 = 0;
            queueTimeItem.x40 = 0;
            queueTimeItem.x10Override = 0;
            queueTimeItem.x20Override = 0;
            queueTimeItem.x30Override = 0;
            queueTimeItem.x40Override = 0;
            queueTimeItemMap.put('QueueTimeItem', queueTimeItem);

            if(leadResult.bResult)
            {
                /*for(sObject sobj : leadResult.objResultList)
                {
                    FA_Lead_Time_Details__c leadtimeDetail = (FA_Lead_Time_Details__c)sobj;
                    //system.debug('leadtimeDetail'+leadtimeDetail);
                    if(String.isNotBlank(leadtimeDetail.RunTimeSchedule__c))
                    {
                        runTimeSchedule.add(leadtimeDetail.RunTimeSchedule__c);
                        scheduleVsItem.put(leadtimeDetail.RunTimeSchedule__c, leadtimeDetail.Lead_Time_Item__c);
                    }
                    if(String.isNotBlank(leadtimeDetail.QueueTimeSchedule__c))
                    {
                        queueTimeSchedule.add(leadtimeDetail.QueueTimeSchedule__c);
                        scheduleVsItem.put(leadtimeDetail.QueueTimeSchedule__c, leadtimeDetail.Lead_Time_Item__c);
                    }
                }*/
                for(sObject sobj : leadResult.objResultList)
                {
                    FA_Lead_Time_Details__c leadtimeDetail = (FA_Lead_Time_Details__c)sobj;
                    //system.debug('leadtimeDetail'+leadtimeDetail);
                    if(String.isNotBlank(leadtimeDetail.RunTimeSchedule__c))
                    {
                        runTimeSchedule.add(leadtimeDetail.RunTimeSchedule__c);
                        scheduleVsItem.put(leadtimeDetail.RunTimeSchedule__c, leadtimeDetail.Lead_Time_Item__c);
                        if(!scheduleVsAllItem.containsKey(leadtimeDetail.RunTimeSchedule__c))
                        {
                            scheduleVsAllItem.put(leadtimeDetail.RunTimeSchedule__c, new List<String>());
                        }
                        scheduleVsAllItem.get(leadtimeDetail.RunTimeSchedule__c).add(leadtimeDetail.Lead_Time_Item__c);
                    }
                    if(String.isNotBlank(leadtimeDetail.QueueTimeSchedule__c))
                    {
                        queueTimeSchedule.add(leadtimeDetail.QueueTimeSchedule__c);
                        scheduleVsItem.put(leadtimeDetail.QueueTimeSchedule__c, leadtimeDetail.Lead_Time_Item__c);
                        if(!scheduleVsAllItem.containsKey(leadtimeDetail.QueueTimeSchedule__c))
                        {
                            scheduleVsAllItem.put(leadtimeDetail.QueueTimeSchedule__c, new List<String>());
                        }
                        scheduleVsAllItem.get(leadtimeDetail.QueueTimeSchedule__c).add(leadtimeDetail.Lead_Time_Item__c);
                    }
                }
                System.debug('**** queueTimeSchedule = '+queueTimeSchedule+', runTimeSchedule = '+runTimeSchedule);
                if(flmprod.Quantity__c != null &&(runTimeSchedule.size() > 0 || queueTimeSchedule.size() > 0))
                {
                    for(GlobalLeadTime__c leadValue: [SELECT Id,Schedule__c,X10__c,X20__c,X30__c,X40__c
                                                      FROM GlobalLeadTime__c
                                                      WHERE (Schedule__c IN:runTimeSchedule OR Schedule__c IN: queueTimeSchedule)
                                                      AND QtyLL__c <=: flmprod.Quantity__c AND QtyUL__c >: flmprod.Quantity__c])
                        //,X10_Override__c,X20_Override__c,X30_Override__c,X40_Override__c
                    {
                       if(scheduleVsAllItem.containsKey(leadValue.Schedule__c))
                        {
                            for(String leadSchedule: scheduleVsAllItem.get(leadValue.Schedule__c))
                            {
                        
                        System.debug('**** leadValue = '+leadValue);
                        String fieldAPI = scheduleVsItem.get(leadValue.Schedule__c); //leadSchedule;
                        if(fieldAPI.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                        String x10API = fieldAPI+'_10__c';
                        if(faOutput.get(x10API) == null)
                        {
                            faOutput.put(x10API, leadValue.X10__c);
                        }
                        String x20API = fieldAPI+'_20__c';
                        if(faOutput.get(x20API) == null)
                        {
                            faOutput.put(x20API, leadValue.X20__c);
                        }
                        String x30API = fieldAPI+'_30__c';
                        if(faOutput.get(x30API) == null)
                        {
                            faOutput.put(x30API, leadValue.X30__c);
                        }
                        String x40API = fieldAPI+'_40__c';
                        if(faOutput.get(x40API) == null)
                        {
                            faOutput.put(x40API, leadValue.X40__c);
                        }

                        if(queueTimeSchedule.contains(leadValue.Schedule__c))
                        {
                            Decimal xValue = leadValue.X10__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x10)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x10 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x10Override = Integer.valueOf(faOutput.get('Queue_Time_10__c'));
                                queueTimeItemMap.get('QueueTimeItem').queue10Id = leadValue.Id;
                              //  Normalsite10.add(Integer.valueOf(faOutput.get(x10API)));
                            }
                            xValue = leadValue.X20__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x20)
                            {
                                System.debug('AAAAQueuee222222');
                                queueTimeItemMap.get('QueueTimeItem').x20 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x20Override = Integer.valueOf(faOutput.get('Queue_Time_20__c'));
                                queueTimeItemMap.get('QueueTimeItem').queue20Id = leadValue.Id;
                              //  Normalsite20.add(Integer.valueOf(faOutput.get(x20API)));
                            }
                            xValue = leadValue.X30__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x30)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x30 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x30Override = Integer.valueOf(faOutput.get('Queue_Time_30__c'));
                                queueTimeItemMap.get('QueueTimeItem').queue30Id = leadValue.Id;
                              //  Normalsite30.add(Integer.valueOf(faOutput.get(x30API)));
                            }
                            xValue = leadValue.X40__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x40)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x40 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x40Override = Integer.valueOf(faOutput.get('Queue_Time_40__c'));
                                queueTimeItemMap.get('QueueTimeItem').queue40Id = leadValue.Id;
                              //  Normalsite40.add(Integer.valueOf(faOutput.get(x40API)));
                            }
                        }
                        else
                        {
                            System.debug('AAAAAAAAElse condition');
                            LeadTimeWrapper runTimeItem = new LeadTimeWrapper();
                                    runTimeItem.leadTimeRec = leadValue;
                                    runTimeItem.item = fieldAPI;
                                    runTimeItem.x10 = Integer.valueOf(leadValue.X10__c);
                                    runTimeItem.x20 = Integer.valueOf(leadValue.X20__c);
                                    runTimeItem.x30 = Integer.valueOf(leadValue.X30__c);
                                    runTimeItem.x40 = Integer.valueOf(leadValue.X40__c);
                                    if(flmprod.Lead_Time_Override__c == false)
                                    {
                                        runTimeItem.x10Override = runTimeItem.x10;
                                        runTimeItem.x20Override = runTimeItem.x20;
                                        runTimeItem.x30Override = runTimeItem.x30;
                                        runTimeItem.x40Override = runTimeItem.x40;
                                    }
                                    else
                                    {
                                        runTimeItem.x10Override = Integer.valueOf(faOutput.get(x10API));
                                        runTimeItem.x20Override = Integer.valueOf(faOutput.get(x20API));
                                        runTimeItem.x30Override = Integer.valueOf(faOutput.get(x30API));
                                        runTimeItem.x40Override = Integer.valueOf(faOutput.get(x40API));
                                    }
                                    Total10 = computeTotal(Total10, runTimeItem.x10);
                                    Total20 = computeTotal(Total20, runTimeItem.x20);
                                    Total30 = computeTotal(Total30, runTimeItem.x30);
                                    Total40 = computeTotal(Total40, runTimeItem.x40);
                                    Total10Override = computeTotal(Total10Override, runTimeItem.x10Override);
                                    Total20Override = computeTotal(Total20Override, runTimeItem.x20Override);
                                    Total30Override = computeTotal(Total30Override, runTimeItem.x30Override);
                                    Total40Override = computeTotal(Total40Override, runTimeItem.x40Override);
                           /* LeadTimeWrapper runTimeItem = new LeadTimeWrapper();
                            runTimeItem.leadTimeRec = leadValue;
                            runTimeItem.item = scheduleVsItem.get(leadValue.Schedule__c);
                            runTimeItem.x10 = Integer.valueOf(leadValue.X10__c);
                            runTimeItem.x20 = Integer.valueOf(leadValue.X20__c);
                            runTimeItem.x30 = Integer.valueOf(leadValue.X30__c);
                            runTimeItem.x40 = Integer.valueOf(leadValue.X40__c);
                            runTimeItem.x10Override = Integer.valueOf(faOutput.get(x10API));
                            runTimeItem.x20Override = Integer.valueOf(faOutput.get(x20API));
                            runTimeItem.x30Override = Integer.valueOf(faOutput.get(x30API));
                            runTimeItem.x40Override = Integer.valueOf(faOutput.get(x40API));
                            Total10 = computeTotal(Total10, runTimeItem.x10);
                            Total20 = computeTotal(Total20, runTimeItem.x20);
                            Total30 = computeTotal(Total30, runTimeItem.x30);
                            Total40 = computeTotal(Total40, runTimeItem.x40);
                            Total10Override = computeTotal(Total10Override, runTimeItem.x10Override);
                            Total20Override = computeTotal(Total20Override, runTimeItem.x20Override);
                            Total30Override = computeTotal(Total30Override, runTimeItem.x30Override);
                            Total40Override = computeTotal(Total40Override, runTimeItem.x40Override);*/
                            Normalsite10.add(Total10);
                            Normalsite20.add(Total20);
                            Normalsite30.add(Total30);
                            Normalsite40.add(Total40);
                            site10.add(Total10Override);
                            site20.add(Total20Override);
                            site30.add(Total30Override);
                            site40.add(Total40Override);
                            FALeadTimeList.add(runTimeItem);
                        }
                            }
                        }
                       System.debug('Lead List with Runtime' +FALeadTimeList);
                    }
                    
                    if(flmprod.Lead_Time_Override__c == false)
                    {
                        System.debug('AAAAQueuee');
                        queueTimeItemMap.get('QueueTimeItem').x10Override = queueTimeItemMap.get('QueueTimeItem').x10;
                        queueTimeItemMap.get('QueueTimeItem').x20Override = queueTimeItemMap.get('QueueTimeItem').x20;
                        queueTimeItemMap.get('QueueTimeItem').x30Override = queueTimeItemMap.get('QueueTimeItem').x30;
                        queueTimeItemMap.get('QueueTimeItem').x40Override = queueTimeItemMap.get('QueueTimeItem').x40;
                    }
                    System.debug('**** Queue time = '+queueTimeItemMap.get('QueueTimeItem'));
                    FALeadTimeList.add(queueTimeItemMap.get('QueueTimeItem'));
                    Total10 = computeTotal(Total10, queueTimeItem.x10);
                    Total20 = computeTotal(Total20, queueTimeItem.x20);
                    Total30 = computeTotal(Total30, queueTimeItem.x30);
                    Total40 = computeTotal(Total40, queueTimeItem.x40);

                    Total10Override = computeTotal(Total10Override, queueTimeItem.x10Override);
                    flmprod.Lead_Time_Site_10__c = Total10Override;
                    Total20Override = computeTotal(Total20Override, queueTimeItem.x20Override);
                    flmprod.Lead_Time_Site_20__c = Total20Override;
                    Total30Override = computeTotal(Total30Override, queueTimeItem.x30Override);
                    flmprod.Lead_Time_Site_30__c = Total30Override;
                    Total40Override = computeTotal(Total40Override, queueTimeItem.x40Override);
                    flmprod.Lead_Time_Site_40__c = Total40Override;
                    Normalsite10.add(Total10);
                    Normalsite20.add(Total20);
                    Normalsite30.add(Total30);
                    Normalsite40.add(Total40);
                    site10.add(Total10Override);
                    site20.add(Total20Override);
                    site30.add(Total30Override);
                    site40.add(Total40Override);
                }
            }
        }

        System.debug('AAAAAA-----Total10Override' +Total10Override);
        System.debug('AAAAAA-----Total20Override' +Total20Override);
        System.debug('AAAAAA-----Total30Override' +Total30Override);
        System.debug('AAAAAA-----Total40Override' +Total40Override);
        if(site10.contains(7777))
            Total10Override=7777;
        else if(site10.contains(4995))
            Total10Override=4995;
        else
            Total10Override=Total10Override;

        if(Normalsite10.contains(7777))
            Total10=7777;
        else if(Normalsite10.contains(4995))
            Total10=4995;
        else
            Total10=Total10;

        if(site20.contains(7777))
            Total20Override=7777;
        else if(site20.contains(4995))
            Total20Override=4995;
        else
            Total20Override=Total20Override;

        if(Normalsite20.contains(7777))
            Total20=7777;
        else if(Normalsite20.contains(4995))
            Total20=4995;
        else
            Total20=Total20;

        if(site30.contains(7777))
            Total30Override=7777;
        else if(site30.contains(4995))
            Total30Override=4995;
        else
            Total30Override=Total30Override;

        if(Normalsite30.contains(7777))
            Total30=7777;
        else if(Normalsite30.contains(4995))
            Total30=4995;
        else
            Total30=Total30;

        if(site40.contains(7777))
            Total40Override=7777;
        else if(site40.contains(4995))
            Total40Override=4995;
        else
            Total40Override=Total40Override;

        if(Normalsite40.contains(7777))
            Total40=7777;
        else if(Normalsite40.contains(4995))
            Total40=4995;
        else
            Total40=Total40;
        
        flmprod.Lead_Time_Site_10__c = Total10Override;
        flmprod.Lead_Time_Site_20__c = Total20Override;
        flmprod.Lead_Time_Site_30__c = Total30Override;
        flmprod.Lead_Time_Site_40__c = Total40Override;
        //ApplyDefaultLeadtime();
        System.debug('Lead List' +FALeadTimeList);
    //    return FALeadTimeList;
    }
    public Integer computeTotal(Integer totalField, Integer fieldValue)
    {
 		if(fieldValue != 7777 && fieldValue != 4995 && totalField != 7777 && totalField != 4495)
          {
              totalField += fieldValue;
          }
        else if(totalField != 7777)
          {
               totalField = fieldValue;
          }
        return totalField;
    }
    public pageReference saveLeadTime()
    {
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        if(FALeadTimeList.size() > 0)
        {
          //  Map<Id,GlobalLeadTime__c> globalLeadTimeMap = new Map<Id,GlobalLeadTime__c>();
            for(LeadTimeWrapper falead: FALeadTimeList)
            {
                String fieldAPI = falead.item;
                if(fieldAPI.contains(' '))
                {
                    fieldAPI = fieldAPI.replace(' ', '_');
                }
                String x10API = fieldAPI+'_10__c';
                faOutput.put(x10API, falead.x10Override);
                String x20API = fieldAPI+'_20__c';
                faOutput.put(x20API, falead.x20Override);
                String x30API = fieldAPI+'_30__c';
                faOutput.put(x30API, falead.x30Override);
                String x40API = fieldAPI+'_40__c';
                faOutput.put(x40API, falead.x40Override);

                /*
                if(falead.leadTimeRec != null)
                {
                    globalLeadTimeMap.put(falead.leadTimeRec.Id,falead.leadTimeRec);
                }
                else
                {
                    if(falead.queue10Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(falead.queue10Id))
                        {
                            globalLeadTimeMap.get(falead.queue10Id).X10_Override__c = falead.x10Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = falead.queue10Id, X10_Override__c = falead.x10Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                    if(falead.queue20Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(falead.queue20Id))
                        {
                            globalLeadTimeMap.get(falead.queue20Id).X20_Override__c = falead.x20Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = falead.queue20Id, X20_Override__c = falead.x20Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                    if(falead.queue30Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(falead.queue30Id))
                        {
                            globalLeadTimeMap.get(falead.queue30Id).X30_Override__c = falead.x30Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = falead.queue30Id, X30_Override__c = falead.x30Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                    if(falead.queue40Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(falead.queue40Id))
                        {
                            globalLeadTimeMap.get(falead.queue40Id).X40_Override__c = falead.x40Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = falead.queue40Id, X40_Override__c = falead.x40Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                }*/
            }
            upsert faOutput;
           /* if(globalLeadTimeMap.size() > 0)
            {
                update globalLeadTimeMap.values();
            }*/
            getLeadTimeRecords();
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                // // quoteLine.Config_Record_Id__c = flmProd.id;
                // // quoteLine.SBQQ__Quantity__c=flmProd.Quantity__c;
                // // quoteLine.Engineering_Notes__c = flmProd.Engineering_Notes__c;
                // quoteLine.Non_Discountable_List_Price__c =  flmProd.Non_Discountable_Price__c;
                // quoteLine.Discountable_List_Price__c = flmProd.Discountable_Price__c;
                quoteLine.Leadtime_Site_10__c = flmProd.Lead_time_Site_10__c;
                quoteLine.Leadtime_Site_20__c = flmProd.Lead_time_Site_20__c;
                quoteLine.Leadtime_Site_30__c = flmProd.Lead_time_Site_30__c;
                quoteLine.Leadtime_Site_40__c = flmProd.Lead_time_Site_40__c;
                upsert quoteLine;
            }
        }
        return null;
    }

    //* @ Apply Default Override for Lead time
  public pageReference ApplyDefaultLeadtime()
  {
      FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
      update flmprod;
      if(flmprod.Lead_Time_Override__c == false)
      {
          if(FALeadTimeList != null && FALeadTimeList.size() > 0)
          {
                for(LeadTimeWrapper falead: FALeadTimeList)
                {
                    String fieldAPI = falead.item;
                    if(fieldAPI.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    String x10API = fieldAPI+'_10__c';
                    faOutput.put(x10API, falead.x10);
                    String x20API = fieldAPI+'_20__c';
                    faOutput.put(x20API, falead.x20);
                    String x30API = fieldAPI+'_30__c';
                    faOutput.put(x30API, falead.x30);
                    String x40API = fieldAPI+'_40__c';
                    faOutput.put(x40API, falead.x40);
                    /*
                    if(falead.leadTimeRec != null)
                    {
                        falead.leadTimeRec.X10_Override__c = falead.leadTimeRec.X10__c;
                        falead.leadTimeRec.X20_Override__c = falead.leadTimeRec.X20__c;
                        falead.leadTimeRec.X30_Override__c = falead.leadTimeRec.X30__c;
                        falead.leadTimeRec.X40_Override__c = falead.leadTimeRec.X40__c;
                    }
                    else
                    {
                        falead.x10Override = falead.x10;
                        falead.x20Override = falead.x20;
                        falead.x30Override = falead.x30;
                        falead.x40Override = falead.x40;
                    }*/
                    upsert faOutput;
                }
              //return saveLeadTime();
              getLeadTimeRecords();
          }
      }
      return null;
  }

	// Cost Method
	public List<Cost__c> assembleCost{get;set;}
    public List<Cost__c> buildCost{get;set;}
    public List<Cost__c> overridenCost{get;set;}
    public List<Cost__c> hiddenCost{get;set;}
    public void getCosts()
    {

        assembleCost = new List<Cost__c>();
        buildCost = new List<Cost__c>();
        overridenCost = new List<Cost__c>();
        WizardCostProcessor wcp = new WizardCostProcessor(flmprod.Id);
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
       // if((fromPage == 'reorder') && (!reorderControl))
      //  saveCertificateDocumentOrSourcingRestrictions();
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
        update flmprod;
        if(!Test.isRunningTest())
        	getCosts();
        return null;
    }

     public pageReference ApplyDefaultCost()
    {
        if(flmprod.Build_Cost_Override__c == false)
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
            update flmprod;
            if(!Test.isRunningTest())
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




	public static FA_Output__c getFAOutputRecord(String rvId)
    {
        List<FA_Output__c> faOutputList = new List<FA_Output__c>();
        String fieldsAPIname = FLMutility.getObjectFields('FA_Output__c');
        String soql = 'SELECT '+fieldsAPIname+' FROM FA_Output__c where FA_Output_Relation_Field__c =\''+String.escapeSingleQuotes(rvId)+'\'';
        faOutputList = Database.query(soql);//[SELECT id from BGR_Outputs__c where BGR_Outputs_Relation_Field__c =:bgrId];
        if(faOutputList.size() > 0)
        {
            return faOutputList[0];
        }
        FA_Output__c faoutput = new FA_Output__c();
        faoutput.FA_Output_Relation_Field__c = rvId;
        return faoutput;
    }


    //Quote Description Method

     public pageReference getTabData()
    {
        if(flmprod.IsConfig__c){
            System.debug('*** selectedTab = '+selectedTab);
            if(selectedTab == 'ProductReview')  // || selectedTab == 'Pricing'
            {
                // if(RVPricingList.size() == 0 )
                // {
                getPricinglist();
                // }
                // if(RVLeadTimeList.size() == 0)
                // {
                getLeadTimeRecords();
                GetQuoteDescriptionRecords();
              //  getCosts();
                // }
            }
            else if(selectedTab == 'Pricing')
            {
                 getPricinglist();
                getLeadTimeRecords();
                GetQuoteDescriptionRecords();
                getCosts();
            }
            else if(selectedTab == 'EngineeringSpecials')
            {
                // if(quoteDescriptionList.size() == 0)
                // {
                GetQuoteDescriptionRecords();
                // }
            }
            else if(selectedTab == 'Engineering')
            {
                getStructureDetails();
                getControlPlanDetails();
                getWorkGuideLines();
                getDocument();
                getRouter();
                getIFSAttributes();
                GetQuoteDescriptionRecords();
            //    getTroubleshootingAttributes();
            }
            else if(selectedTab == 'TroubleShoot')
            {
                getTroubleshootingAttributes();
            }
        }

        return null;
    }

    Public List<QuoteDescriptionWrapper> quoteDescriptionList{set;get;}

    public FA_Output__c getQuoteFAOutputInstance()
    {
        FA_Output__c faOutput = getFAOutputRecord(flmprod.Id);
        /*faOutput.OA01__c=null;
		faOutput.OA02__c=null;
        faOutput.OA04__c=null;
        faOutput.OA05__c=null;
        faOutput.OA06__c=null;
        faOutput.OB010__c=null;
        faOutput.OB020__c=null;
        faOutput.OB030__c=null;
        faOutput.OB040__c=null;
        faOutput.OB050__c=null;
        faOutput.OB110__c=null;
        faOutput.OB120__c=null;
        faOutput.OB210__c=null;
        faOutput.OB220__c=null;
        faOutput.OB230__c=null;
        faOutput.OB240__c=null;
        faOutput.OB250__c=null;
        faOutput.OB260__c=null;
        faOutput.OB310__c=null;
        faOutput.OB311__c=null;
        faOutput.OB312__c=null;
        faOutput.OB410__c=null;
        faOutput.OB411__c=null;
        faOutput.OB420__c=null;
        faOutput.OB421__c=null;
        faOutput.OB430__c=null;
        faOutput.OB431__c=null;
        faOutput.OB440__c=null;
        faOutput.OB441__c=null;
        faOutput.OB510__c=null;
        faOutput.OB520__c=null;
        faOutput.OB530__c=null;
        faOutput.OB540__c=null;
        faOutput.OB550__c=null;
        faOutput.OW110__c=null;
        faOutput.OW120__c=null;
        faOutput.OW130__c=null;
        faOutput.OW140__c=null;
        faOutput.OW150__c=null;
        faOutput.OW160__c=null;
        faOutput.OW170__c=null;
        faOutput.OW180__c=null;
        faOutput.OW190__c=null;
        faOutput.OW200__c=null;
        faOutput.OW210__c=null;
        faOutput.OW220__c=null;
        faOutput.OW230__c=null;
        faOutput.OW240__c=null;
        faOutput.OW250__c=null;
        faOutput.OW260__c=null;
        faOutput.OW270__c=null;
        faOutput.OW280__c=null;
        faOutput.OW290__c=null;
        faOutput.OW300__c=null;
        faOutput.OW310__c=null;
        faOutput.OW320__c=null;
        faOutput.OW330__c=null;
        faOutput.OW340__c=null;
        faOutput.OW910__c=null;
        faOutput.OW920__c=null;*/

        return faOutput;
    }

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
  public FA_Output__c faOutsideInstance;
  public void GetQuoteDescriptionRecords()  //List<QuoteDescriptionWrapper>
  {
      //AttributeDescription = ' ';
      quoteAttriVsDesc = new Map<String, String>();
      quoteDescriptionList.clear();
      boolean hasOA01inList = false, hasOA250inList = false;
      string OB250p1,OB250p2;
      if(flmprod.IsConfig__c)
      {
          quoteAttriVsDesc = FAOU.GetAttributeMapQuoteDescription();
          faOutsideInstance = getQuoteFAOUtputInstance();
          flmprod.OA01__c = 'Model: ' + FAOU.GMODEL;
          for(String attribute: quoteAttriVsDesc.keySet())
          {
              String attributeFieldAPI = attribute+'__c';
              flmprod.put(attributeFieldAPI,quoteAttriVsDesc.get(attribute));
              //System.debug('*** attributeFieldAPI = '+attributeFieldAPI+', flmprod value = '+flmprod.get(attributeFieldAPI));
          }
          flmprod.OA__c = flmprod.OA01__c;
          flmprod.OB__c = '';
          flmprod.OW__c = '';
          flmprod.PC__c = '';

          for(String attribute: quoteAttriVsDesc.keySet())
          {
            //   if(attribute != 'OB050')
            //   {
                  String attributeValue = flmprod.get(attribute+'__c')+'';
                  System.debug('*** attribute = '+attribute+'__c, value = '+attributeValue);
                  if(attribute.startsWith('OA') && String.isNotBlank(attributeValue))
                  {
                    flmprod.OA__c += '\n' + attributeValue;
                  }
                  else if(attribute.startsWith('OB') && String.isNotBlank(attributeValue))
                  {
                    flmprod.OB__c += attributeValue + '\n';
                  }
                  else if(attribute.startsWith('OW') && String.isNotBlank(attributeValue))
                  {
                      if(String.isBlank(flmprod.OW__c))
                      {
                        flmprod.OW__c = attributeValue;
                      }
                      else
                      {
                        flmprod.OW__c += '\n' + attributeValue;
                      }
                  }
                  else if(attribute.startsWith('PC') && String.isNotBlank(attributeValue))
                  {
                      if(String.isBlank(flmprod.PC__c))
                      {
                        flmprod.PC__c = attributeValue;
                      }
                      else
                      {
                        flmprod.PC__c += '\n' + attributeValue;
                      }
                  }
              //}
          }
          Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW'}; //,'PC'
          for(String quoteAttribute: quotesAttributeSet)
          {
              String fieldAPI = quoteAttribute+'__c';
              String quoteRow = (String)flmprod.get(fieldAPI);
              //System.debug('*** fieldAPI = '+fieldAPI+', quoteRow = '+quoteRow);
              if(String.isNotBlank(quoteRow))
              {
                  QuoteDescriptionWrapper quoteDescription = new QuoteDescriptionWrapper();
                  quoteDescription.quotes = quoteAttribute;
                  quoteDescription.descriptionList = new List<String>();
                  quoteDescription.overridedescriptionList = new List<String>();
                  String descriptionValue = flmprod.get(fieldAPI)+'';
                  for(String dec : descriptionValue.split('\n'))
                  {
                      quoteDescription.descriptionList.add(dec);
                  }
                  quoteDescription.description = flmprod.get(fieldAPI)+'';
                  //System.debug('*** faOutsideInstance = '+faOutsideInstance.get(quoteAttribute+'_Override__c'));
                  if(faOutsideInstance.get(quoteAttribute+'_Override__c') == null)
                  {
                      quoteDescription.overrideDescription = flmprod.get(fieldAPI)+'';
                  }
                  else
                  {
                      quoteDescription.overrideDescription = (String)faOutsideInstance.get(quoteAttribute+'_Override__c');
                  }
                  if(flmprod.Quote_Description_Engineer_Override__c == true && quoteAttribute == 'OA')
                  {
                      quoteDescription.overrideDescription = quoteDescription.overrideDescription;
                  }
                  System.debug('*** quoteDescription = '+quoteDescription);
                  for(String dec : quoteDescription.overrideDescription.split('\n'))
                  {
                      quoteDescription.overridedescriptionList.add(dec);
                  }
                  quoteDescriptionList.add(quoteDescription);
              }
          }
      }
   //   update flmprod;
   //   return quoteDescriptionList;
    }

     //* @ Apply Default Override for Quote Description
    public pageReference ApplyDefaultQuoteDescription()
    {
        if(flmprod.Quote_Description_Engineer_Override__c == false)
        {
            Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW'}; //,'PC'
            for(String quoteAttribute: quotesAttributeSet)
            {
                String attributeFieldAPI = quoteAttribute+'_Override__c';
                String attributeValue = (String)flmprod.get(quoteAttribute+'__c');
                faOutsideInstance.put(attributeFieldAPI, attributeValue);
            }

            update faOutsideInstance;
            GetQuoteDescriptionRecords();
            if(!Test.isRunningTest()) 
            {
                if(!notValidStatusForChng.contains(strQuoteStatus)) {
                    quoteLine.SBQQ__Description__c=strquoteDes;
                    upsert quoteLine;
                }
            }
            flmprod.Part_Number_Base__c=flmprod.Part_Number_Base_Original__c;
        }
        else
        {
            flmprod.ASSYPARTEXISTING__c = '';
        }
        update flmprod;
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
                faOutsideInstance.put(attributeFieldAPI, bgqd.overrideDescription);
            }
            if(String.isNotBlank(faOutsideInstance.Id))
            {
                update faOutsideInstance;
            }
            update faOutsideInstance;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        }
        return null;
    }



  // Manufacturing Outputs Wrapper Classes

    // Struture Wrapper
    public class structureWrapper
    {
        public string strComponent {set;get;}
        public string strComponentScrap {set;get;}
        public string strComponentPart {set;get;}
        public string strScrapFactor {set;get;}
        public string strQtrPerAssembly {set;get;}
        public string strLineItemNo {set;get;}

    }

    public list<structureWrapper> getStructureDetails() {
         list<structureWrapper> strucWrapList=new list<structureWrapper>();
         System.debug('Structure Entry beg');
       	if(flmprod.IsConfig__c)
        {
		   result res=new result();
		   res=FAOU.getStructure();

           if(res.bResult)
           {
           		List<Integer> aList = new List<Integer>();
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('ItemNo__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);
                }
                aList.sort();
                for(Integer a: aList)
                {
                    for (sObject sobj:res.objResultList)
                    {
                        string a2=(string) sobj.get('ItemNo__c');
                        Integer i2=integer.valueOf(a2);
                            if(a==i2)
                            {
                                structureWrapper stWrap=new structureWrapper();
								stWrap.strComponent = (string) sobj.get('Structure_Element__c');
								stWrap.strComponentScrap = (string) sobj.get('Component_Scrap__c');
								stWrap.strScrapFactor = (string) sobj.get('Scrap_Factor__c');
								stWrap.strQtrPerAssembly = (string) sobj.get('Qty_per_Assembly__c');
								stWrap.strComponentPart = (string) sobj.get('Component_Part__c');
								stWrap.strLineItemNo = (string) sobj.get('ItemNo__c');
								strucWrapList.add(stWrap);
                            }
                     }
           		}
        	}
        }
        return strucWrapList;
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
       if(flmprod.IsConfig__c)
        {
		   result res=new result();
		   res=FAOU.getRouting();
           string Test_Oper_Desc='';
           string RoutingVal='';
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
							  //  docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
								RoutingVal=(string) sobj.get('Outside_Operation_Item__c');
								if(RoutingVal!=null)
								 {
									if(RoutingVal.contains('[') && RoutingVal.contains(']'))
									 {
										string  Test_Oper_Desc_val='';
										Test_Oper_Desc = (string) sobj.get('Outside_Operation_Item__c');
										if(Test_Oper_Desc!=null)
										{
											Test_Oper_Desc = Test_Oper_Desc.substringBetween('[',']');
										}
										if(string.isBlank(Test_Oper_Desc) || Test_Oper_Desc == null)
										{
											docWrap.strOutside_Operation_Item = (String) sobj.get('Outside_Operation_Item__c');
										}
										else
										{
										  /*  string assypartno='';
											if(flmprod.Part_Number__c!=null)
												assypartno=flmprod.Part_Number__c;
											else
												assypartno=flmprod.Part_Number_Base__c;
											Test_Oper_Desc_val =assypartno; */
											Test_Oper_Desc_val =FAOU.mapFLMAttr.get(Test_Oper_Desc);
										}

											String[] arrPTC  =new String[5];
											arrPTC=RoutingVal.split('\\[');
											String strPTC1  = arrPTC[0];
											String strPTC2  = arrPTC[1];
											String str2SplitOB170 =strPTC2;
											String[] arrPTC2  = new String[5];
											arrPTC2=str2SplitOB170.split('\\]');
											String strPTC4  = arrPTC2[1];
											string attributeValue=strPTC1+Test_Oper_Desc_val+' '+strPTC4;
											docWrap.strOutside_Operation_Item=attributeValue;
										}
										else
											docWrap.strOutside_Operation_Item =(string) sobj.get('Outside_Operation_Item__c');
								}
								else
									docWrap.strOutside_Operation_Item =(string) sobj.get('Outside_Operation_Item__c');

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

	//Control Plan Wrapper
    public list<ControlWrapper> getControlPlanDetails() {
        list<ControlWrapper> controlWrapList=new list<ControlWrapper>();
         if(flmprod.IsConfig__c)
        {
		   result res=new result();
		   res=FAOU.getControlPlan();
		   string OuterMinValue = '';
           string NominalValue = '';
           string OuterMaxValue = '';
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
								OuterMinValue = (String) sobj.get('Outer_Min__c');
								if(OuterMinValue!=null)
								{
									OuterMinValue = OuterMinValue.substringBetween('[',']');
								}
								if(string.isBlank(OuterMinValue) || OuterMinValue == null)
								{
									ctrlWrap.strOUTER_MIN = (String) sobj.get('Outer_Min__c');
								}
								else
								{
									ctrlWrap.strOUTER_MIN = FAOU.mapFLMAttr.get(OuterMinValue);
								}
								ctrlWrap.strINNER_MIN=(string) sobj.get('INNER_MIN__c');
								 NominalValue = (String) sobj.get('Nominal_Value__c');
								if(NominalValue!=null)
								{
									NominalValue = NominalValue.substringBetween('[',']');
								}
								if(string.isBlank(NominalValue) || NominalValue == null)
								{
									ctrlWrap.strNOMINAL_VALUE = (String) sobj.get('Nominal_Value__c');
								}
								else
								{
									ctrlWrap.strNOMINAL_VALUE = FAOU.mapFLMAttr.get(NominalValue);
								}
								ctrlWrap.strINNER_MAX=(string) sobj.get('INNER_MAX__c');
								OuterMaxValue = (String) sobj.get('Outer_Max__c');
								if(OuterMaxValue!=null)
								{
									OuterMaxValue = OuterMaxValue.substringBetween('[',']');
								}
								if(string.isBlank(OuterMaxValue) || OuterMaxValue == null)
								{
									ctrlWrap.strOUTER_MAX = (String) sobj.get('Outer_Max__c');
								}
								else
								{
									ctrlWrap.strOUTER_MAX = FAOU.mapFLMAttr.get(OuterMaxValue);
								}
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

	//WorkGuideLine Wrapper
    public class WorkGuideLineWrapper
    {
        public string strOperation {set;get;}
     //   public string strStandard_Operation_ID {set;get;}
     //   public string strOutside_Operation_Item {set;get;}
        public string strGuidline_Seq{set;get;}
        public string strDescription {set;get;}
         public string strText {set;get;}
         public string strType {set;get;}
         public string strSign_Off {set;get;}
         public string strInspection_Sign_Off_Required {set;get;}

    }
       public list<WorkGuideLineWrapper> getWorkGuideLines() {
        list<WorkGuideLineWrapper> workguildeWrapList=new list<WorkGuideLineWrapper>();
         if(flmprod.IsConfig__c)
        {
		   result res=new result();
		   res=FAOU.getWorkGuideLines();
           if(res.bResult)
           {
           		List<Integer> aList = new List<Integer>();
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('GuidlineSeq__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);
                }
                aList.sort();
                for(Integer a: aList)
                {
                    for (sObject sobj:res.objResultList)
                    {
                        string a2=(string) sobj.get('GuidlineSeq__c');
                        Integer i2=integer.valueOf(a2);
                            if(a==i2)
                            {
                                WorkGuideLineWrapper stWrap=new WorkGuideLineWrapper();
								stWrap.strOperation = (string) sobj.get('Operation__c');
								//    stWrap.strStandard_Operation_ID = (string) sobj.get('Standard_Operation_ID__c');
								//    stWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
								stWrap.strGuidline_Seq = (string) sobj.get('GuidlineSeq__c');
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

	//Document Wrapper
    public class documentWrapper
    {
        public string strDocument {set;get;}
        public string strDocument_ID {set;get;}
        public string strRevision {set;get;}
    }
        public list<documentWrapper> getDocument()
        {
        list<documentWrapper> documentWrapList=new list<documentWrapper>();
        if (flmprod.IsConfig__c)
        {
            result res=new result();
           // FAOUtputUtility WGBO=new FAOUtputUtility(flmprod.id);
            res=FAOU.getDocument();
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


	//IFS Attribute Wapper class
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
        if(flmProd.IsConfig__c){
        	Attr = FAOU.getmapIFSAttr();

        for(String attribute: Attr.keySet())
            {
                IFSAttr attrDesc = new IFSAttr();
                    attrDesc.Key = attribute;
                    if(String.isBlank(attrDesc.Values))
                    {
                        attrDesc.Values = Attr.get(attribute);
                    }
                InterfaceAttrList.add(attrDesc);
            }
        }
        return InterfaceAttrList;
    }

	//TroubleShooting Attributes Wrapper Class
    public Map<String, String> Attr1;
    Public List<TroubleshootingAttr> TroubleshootingAttrList{get;set;}
    public class TroubleshootingAttr
    {
        public String Key {get;set;}
        public String Values {get;set;}
    }

    public list<TroubleshootingAttr> getTroubleshootingAttributes()
    {
        Map<String, String> Attr1 = new Map<String, String>();
        TroubleshootingAttrList = new List<TroubleshootingAttr>();
        if(flmProd.IsConfig__c){
         Attr1 = FAOU.getmapTroubleShootAttr();
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
        }

        return TroubleshootingAttrList;
    }


     public PageReference savePartNumber() {
         flmprod.PartNumberBase_Flag__c=true;
        try {
         //   flmprod.ASSYPARTNO__c=flmprod.Part_Number_Base__c;
            update flmprod;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    public PageReference saveNotes() {
        //conBGR.Product_material_options_flag__c=true;
        try {
            update flmprod;
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
            //conBGR.PartNumberBase_Checkbox__c=true;
            update flmprod;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;

    }










 /*
    //Save and continue for Application Parameters section
        public PageReference saveApplicationParameters() {
        try {
            //This is to split the Gas Group value to get the Gas group code which will be used for Narrowing
            string GasGroupCodeStr = flmprod.Gas_Group__c;
            flmprod.Gas_Group_Code__c = GasGroupCodeStr.substringBefore('"');
          //  system.debug('gas code'+flmprod.Gas_Group_Code__c);
            flmProd.Bypass__c=false;
            flmProd.Application_Parameters_flag__c= true;
            upsert flmProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    //Save and continue for Sizing/Flow Area section
     public PageReference saveSizing() {
        try {
            //Max allowable drop
             if(flmprod.Max_Allowable_Pressure_Drop_Units__c != Null)
             {
                 Result resultConvertPressure= new Result();
                 if (flmprod.Max_Allowable_Pressure_Drop__c != Null)
                 {
                     resultConvertPressure=unitConversions.convertPressure(flmprod.Max_Allowable_Pressure_Drop_Units__c,'in. water',flmprod.Max_Allowable_Pressure_Drop__c);
                     if(resultConvertPressure.bResult)
                         flmprod.Converted_Max_Allowable_Pressure_Drop__c=resultConvertPressure.dblRetValue;
                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
              }
           }
            //
            //Atmospheric pressure
            if(flmprod.Atmospheric_Pressure_Units__c != Null)
            {
                Result resultConvertPressure= new Result();
                if (flmprod.Atmospheric_Pressure__c != Null)
            {
                resultConvertPressure=unitConversions.convertPressure(flmprod.Atmospheric_Pressure_Units__c,'psia',flmprod.Atmospheric_Pressure__c);
                if(resultConvertPressure.bResult)
                    flmprod.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;

                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
            //
            //Temperature of Flowing vapor
             if(flmprod.Temperature_of_flowing_Vapor_Units__c != Null)
             {
                 Result resultConvertTemperature= new Result();
                 if (flmprod.Temperature_of_flowing_Vapor__c != Null)
                 {
                     resultConvertTemperature=unitConversions.convertTemperature(flmprod.Temperature_of_flowing_Vapor_Units__c,'Deg R',flmprod.Temperature_of_flowing_Vapor__c);
                     if(resultConvertTemperature.bResult)
                         flmprod.Converted_Temprature_of_flowing_Vapor__c=resultConvertTemperature.dblRetValue;
                     else{
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
                     }
                 }
            }
            //
            //Required Flow rate
             if(flmprod.Required_Flow_Rate_Units__c != Null)
             {
                 Result resultconvertGasFlowRate= new Result();
                 if (flmprod.Required_Flow_Rate__c != Null)
                 {
                     resultconvertGasFlowRate=unitConversions.convertGasFlowRate(flmprod.Required_Flow_Rate_Units__c,'SCFH',flmprod.Required_Flow_Rate__c,flmprod.Converted_Max_Allowable_Pressure_Drop__c,flmprod.Molecular_Weight__c,flmprod.Converted_Temprature_of_flowing_Vapor__c,flmprod.Compressibility_Factor__c);
                     if(resultconvertGasFlowRate.bResult)
                         flmprod.Converted_Required_Flow_Rate__c=resultconvertGasFlowRate.dblRetValue;
                     else
                     {
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultconvertGasFlowRate.strErrorMessage));
                     }
                 }
             }
            //
            //Pressure of Flowing Vapor
            if(flmprod.Pressure_of_flowing_Vapor_Units__c != Null)
            {
                Result resultConvertPressure= new Result();
                if (flmprod.Pressure_of_flowing_Vapor__c != Null)
                {
                    resultConvertPressure=unitConversions.convertPressure(flmprod.Pressure_of_flowing_Vapor_Units__c,'psig',flmprod.Pressure_of_flowing_Vapor__c);
                    if(resultConvertPressure.bResult)
                        flmprod.Converted_Pressure_of_flowing_Vapor__c=resultConvertPressure.dblRetValue;

                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                    }
                }
            }
            //

            flmProd.Bypass__c=false;
            flmProd.Sizing_Flow_Area_flag__c = true;
            upsert flmProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    // Save and continue for Certifications section
       public PageReference saveCertifications() {
        try {
            flmProd.Bypass__c=false;
            flmProd.Certifications_flag__c = true;
            upsert flmProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
   // Save and continue for Product Narrowing section
   public PageReference saveProductNarrowing() {
        try {
            flmProd.Bypass__c=false;
            flmProd.Product_Narrowing_flag__c = true;
            //This method is for PresRatio calculation
            // For KD value calculation we are required to calculate the "PresRatio" using which the KD value will be queried
           // PresRatio = [InletFlowPres - Converted_Max_Allowable_Pressure_Drop__c)/InletFlowPres] as per the excel configurator
           // To calculate PresRatio we are required to calculate the "InletFlowPres"
            //To fetch the If condition value to calculate the InletFlowPres
            if(flmprod.Side_of_FA_whr_flwng_prssur_is_indicated__c=='Inlet')
            {
                sideFAif = 0;
            }
            else
            {
                sideFAif = flmprod.Converted_Max_Allowable_Pressure_Drop__c;
            }
       // To calculate the InletFlowPres which is to be used to calculate the PresRatio
       InletFlowPres = flmprod.Converted_Pressure_of_flowing_Vapor__c + flmprod.Converted_Atmospheric_Pressure__c + sideFAif;
          system.debug('InletFlowPres value is: '+ InletFlowPres);
       // Calculate the PresRatio value which is to be used for KD calculation
            flmprod.PresRatio__c = (InletFlowPres - flmprod.Converted_Max_Allowable_Pressure_Drop__c)/InletFlowPres;
           system.debug('PresRatio value is: '+ flmprod.PresRatio__c);
       //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            Map<String, GasFlowRate__c> unitConversionMap = DataSelectorWizard.getFlameProductRecord();
            Map<String, list<FLM_KD__c>> KDMap = new Map<String, list<FLM_KD__c>>();
            modelVsConnection = new Map<String, Set<String>>();
            connSizeOptions.clear();
            modelOptions.clear();
            connSizeOptions.clear();
            bodyMaterialOptions.clear();
            HousingMaterialOptions.clear();
            ElementMaterialOptions.clear();
             for(FLM_KD__c KD: DataSelectorWizard.getFLMKDRecord())
            {
                if(!KDMap.containskey(KD.ConnSizeCode__c + '_' + KD.Model__c))
                {
                    KDMap.put(KD.ConnSizeCode__c + '_' + KD.Model__c, new list<FLM_KD__c>());
                }
                KDMap.get(KD.ConnSizeCode__c + '_' + KD.Model__c).add(KD);
            }
            Set<String> ModelSet = new Set<String>();
            for(String KDkey:KDMap.keyset())
            {
            Decimal previousPetro = 0,previousKD = 0,nextPetro = 0,nextKD = 0, numerator = 0, denominator = 0, criticalPresRatio = 0;
            Decimal base = 0, exp = 0, RoundFlowRate=0;
            Decimal EffDia = 0, convertedFlowRateSCFH = 0, FlowRateSCFH = 0, FirstPart = 0, SecondPart = 0, ThirdPart = 0;
            Boolean FlowRateOk;
            if(KDMap.get(KDkey).size() > 0)
            {
                previousPetro =KDMap.get(KDkey)[0].PresRatio__c;
                nextPetro = KDMap.get(KDkey)[KDMap.get(KDkey).size()-1].PresRatio__c;
                for(FLM_KD__c kdTableVal: KDMap.get(KDkey))
                {
                    EffDia = kdTableVal.EffDia__c;
                    if(previousPetro < kdTableVal.PresRatio__c &&  kdTableVal.PresRatio__c < flmprod.PresRatio__c)
                    {
                        previousPetro = kdTableVal.PresRatio__c;
                        previousKD = kdTableVal.KD__c;
                        system.debug('******Effdia value is'+EffDia);
                    }
                    else if(kdTableVal.PresRatio__c > flmprod.PresRatio__c)
                    {
                        nextPetro = kdTableVal.PresRatio__c;
                        nextKD = kdTableVal.KD__c;
                        break;
                    }
                }
            }
          system.debug('KDkey '+ KDkey);
            system.debug('Previous presRatio'+previousPetro);
           system.debug('Next PresRation'+nextPetro);
          system.debug('Previous KD'+previousKD);
            system.debug('Next KD'+nextKD);
            numerator = (flmprod.PresRatio__c - previousPetro) * (nextKD - previousKD);
            denominator = (nextPetro - previousPetro);
            if(denominator != 0)
            {
                flmprod.KD__c = (numerator / denominator) + previousKD;
            }
            system.debug('Absolute KD'+flmprod.KD__c);
            base = (2/(flmprod.Ratio_of_Specific_Heats__c + 1));
            exp = (flmprod.Ratio_of_Specific_Heats__c / (flmprod.Ratio_of_Specific_Heats__c - 1 ));
            criticalPresRatio = Math.exp(exp*Math.log(base));
           system.debug('Critical PresRatio'+criticalPresRatio);

            system.debug('The value of EffDia is :'+EffDia);
            //This to calculate Flow rate scfh
           FirstPart = flmprod.KD__c * 278700 * InletFlowPres * (Math.exp(2 * Math.log(EffDia))/4) * Math.PI;
              System.debug('***** Model = '+KDkey.substringAfter('_'));
         System.debug('***** Flow rate First part : '+FirstPart);
                Decimal numerator2 = flmprod.Ratio_of_Specific_Heats__c;
          System.debug('Numerator2*** : '+numerator2);
          System.debug('MW*** : '+flmprod.Molecular_Weight__c);
           System.debug('FT*** : '+flmprod.Converted_Temprature_of_flowing_Vapor__c);
           System.debug('CF*** : '+flmprod.Compressibility_Factor__c);
           System.debug('ROSH*** : '+flmprod.Ratio_of_Specific_Heats__c);
          Decimal denominator2 = (flmprod.Molecular_Weight__c*flmprod.Converted_Temprature_of_flowing_Vapor__c*flmprod.Compressibility_Factor__c*(flmprod.Ratio_of_Specific_Heats__c-1));
          System.debug('Denominator*** : '+denominator2);
          SecondPart = numerator2/denominator2;
         System.debug('***** Flow rate Second part : '+SecondPart);
          ThirdPart = (Math.exp((2/flmprod.Ratio_of_Specific_Heats__c) * Math.log(flmprod.PresRatio__c)) - (Math.exp(((flmprod.Ratio_of_Specific_Heats__c + 1)/flmprod.Ratio_of_Specific_Heats__c) * Math.log(flmprod.PresRatio__c))));
         System.debug('****** Flow rate Third part : '+ThirdPart);
          FlowRateSCFH = FirstPart * Math.exp(0.5 * Math.log(SecondPart * ThirdPart));
         system.debug('***** FLowRate SCFH value is: ' +FlowRateSCFH);
         //Flow rate conversion to SCFH unit
            if(FlowRateSCFH != Null) {
            Result resultconvertGasFlowRate= new Result();
            if (FlowRateSCFH != Null)
            {
                //unitConversionMap = DataSelectorWizard
             resultconvertGasFlowRate = DataSelectorWizard.convertGasFlowRate(unitConversionMap.get(flmprod.Required_Flow_Rate_Units__c+'_SCFH'),FlowRateSCFH,flmprod.Converted_Max_Allowable_Pressure_Drop__c,flmprod.Molecular_Weight__c,flmprod.Converted_Temprature_of_flowing_Vapor__c,flmprod.Compressibility_Factor__c);
                if(resultconvertGasFlowRate.bResult)
                {
                    convertedFlowRateSCFH=resultconvertGasFlowRate.dblRetValue;
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultconvertGasFlowRate.strErrorMessage));
                    return null;
                }
            }
                System.debug('***** '+convertedFlowRateSCFH >= flmprod.Converted_Required_Flow_Rate__c+' => convertedFlowRateSCFH = '+convertedFlowRateSCFH+', flmprod.Converted_Required_Flow_Rate__c = '+flmprod.Converted_Required_Flow_Rate__c);
                if(convertedFlowRateSCFH >= flmprod.Converted_Required_Flow_Rate__c)
                {
                    if(ModelSet.add(KDkey.substringAfter('_')))
                    {
                        modelOptions.add(new selectOption(KDkey.substringAfter('_'), KDkey.substringAfter('_')));
                    }
                    if(!modelVsConnection.containsKey(KDkey.substringAfter('_')))
                    {
                        modelVsConnection.put(KDkey.substringAfter('_'), new Set<String>());
                    }
                    modelVsConnection.get(KDkey.substringAfter('_')).add(KDkey.substringBefore('_'));
                }
        }
       }
            if(ModelSet.size() > 0)
            {
                flmProd.Model__c = (new List<String>(ModelSet))[0];
                flmProd.Connection_Size__c = null;
                for(String conSize: modelVsConnection.get((new List<String>(ModelSet))[0]))
                {
                    connSizeOptions.add(new selectOption(conSize, conSize));
                    if(flmProd.Connection_Size__c == null)
                    {
                        flmProd.Connection_Size__c = conSize;
                    }

                }
            }
            ElementSize();
            //Operation pressure
             if(flmprod.Operational_Pressure_Units__c != Null)
             {
                 Result resultConvertPressure= new Result();
                 if (flmprod.Operational_Pressure__c != Null)
                 {
                     resultConvertPressure=unitConversions.convertPressure(flmprod.Operational_Pressure_Units__c,'psia',flmprod.Operational_Pressure__c);
                     if(resultConvertPressure.bResult)
                         flmprod.Converted_Operational_Pressure__c=resultConvertPressure.dblRetValue;

                     else
                     {
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                     }
                 }
             }
            //
            //Run up length A
            if(flmprod.Run_Up_Length_A_Input_Units__c != Null)
            {
                Result resultConvertInches= new Result();
                if (flmprod.Run_Up_Length_A_Input__c != Null)
                {
                    resultConvertInches=unitConversions.convertDistance(flmprod.Run_Up_Length_A_Input_Units__c,'in',flmprod.Run_Up_Length_A_Input__c);
                    if(resultConvertInches.bResult)
                        flmprod.Converted_Run_up_Length_A__c=resultConvertInches.dblRetValue;

                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertInches.strErrorMessage));
                    }
                }
            }
            //
            //Run up length B
            if(flmprod.Run_Up_Length_B_Input_Units__c != Null)
            {
                Result resultConvertInches= new Result();
                if (flmprod.Run_Up_Length_B_Input__c != Null)
                {
                    resultConvertInches=unitConversions.convertDistance(flmprod.Run_Up_Length_B_Input_Units__c,'in',flmprod.Run_Up_Length_B_Input__c);
                    if(resultConvertInches.bResult)
                        flmprod.Converted_Run_up_Length_B__c=resultConvertInches.dblRetValue;

                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertInches.strErrorMessage));
                    }
                }
            }
            //
            upsert flmProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    public Map<String, Set<String>> modelVsConnection;
    //Save and continue for Product Selection section
    public boolean productSelectionProcessed = false;
   public PageReference saveProductSelection() {
         flmProd.Bypass__c=false;
            flmprod.Product_selection_flag__c = true;
        try {
            List<FLM_Model__c> FLD = new List<FLM_Model__c>();
            FLD = [Select Fillet_Weld_LP__c,Ultrasonic__c,Magnetic_Particle__c,Brinell_Hardness__c,Visual_Casting__c from FLM_Model__c
                     where Base_Model__c=: flmprod.Model__c
                  limit 1];
           if(! FLD.isEmpty())
            {
                if(FLD.get(0).Fillet_Weld_LP__c=='Y')
                {
                 flmProd.Fillet_Weld_Liquid_Dye_Penetrant__c=true;
                }
                if(FLD.get(0).Ultrasonic__c=='Y')
                {
                 flmProd.Ultrasonic_Examination__c=true;
                }
                if(FLD.get(0).Magnetic_Particle__c=='Y')
                {
                 flmProd.Magnetic_Particle_Examination__c=true;
                }
                if(FLD.get(0).Brinell_Hardness__c=='Y')
                {
                 flmProd.Brinell_hardness_examination__c=true;
                }
                if(FLD.get(0).Visual_Casting__c=='Y')
                {
                 flmProd.Visual_Casting_Examination__c=true;
                }
            }
            upsert flmProd;
            masterBlasterMap = DataSelectorWizard.getFLMMasterBlaster(flmProd);
            bodyMaterialOptions.clear();
            HousingMaterialOptions.clear();
            ElementMaterialOptions.clear();
            bodyMaterialOptions.add(new selectOption('', ''));
            HousingMaterialOptions.add(new selectOption('', ''));
            ElementMaterialOptions.add(new selectOption('', ''));
            bodyMaterialOptions.addAll(FLMutility.getInstance().getBodyMaterialOptions(flmProd, FLMMasterBMPicklists, masterBlasterMap));
            if(bodyMaterialOptions.size() > 2)
            {
                flmProd.Body_Material__c = bodyMaterialOptions[1].getValue();
            }
            HousingMaterialOptions.addAll(FLMutility.getInstance().getHouseMaterialOptions(flmProd, FLMMasterHMPicklists, masterBlasterMap));
            if(HousingMaterialOptions.size() > 2)
            {
                flmProd.Housing_Material__c = HousingMaterialOptions[1].getValue();
            }
            ElementMaterialOptions.addAll(FLMutility.getInstance().getElementMaterialOptions(flmProd, FLMMasterEMPicklists, masterBlasterMap));
            if(ElementMaterialOptions.size() > 2)
            {
                flmProd.Element_Material__c = ElementMaterialOptions[1].getValue();
            }
        }
        catch(Exception dmle)
        {
            System.debug('***** error line = '+dmle.getLineNumber());
            System.debug('***** error message = '+dmle.getMessage());
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    public pageReference getHousingMaterialOptions()
    {
        HousingMaterialOptions.clear();
        ElementMaterialOptions.clear();
        HousingMaterialOptions.add(new selectOption('', ''));
        ElementMaterialOptions.add(new selectOption('', ''));
        HousingMaterialOptions.addAll(FLMutility.getInstance().getHouseMaterialOptions(flmProd, FLMMasterHMPicklists, masterBlasterMap));
        if(HousingMaterialOptions.size() > 2)
        {
            flmProd.Housing_Material__c = HousingMaterialOptions[1].getValue();
        }
        ElementMaterialOptions.addAll(FLMutility.getInstance().getElementMaterialOptions(flmProd, FLMMasterEMPicklists, masterBlasterMap));
        if(ElementMaterialOptions.size() > 2)
        {
            flmProd.Element_Material__c = ElementMaterialOptions[1].getValue();
        }
        return null;
    }

    public pageReference getElementMaterialOptions()
    {
        ElementMaterialOptions.clear();
        ElementMaterialOptions.add(new selectOption('', ''));
        ElementMaterialOptions.addAll(FLMutility.getInstance().getElementMaterialOptions(flmProd, FLMMasterEMPicklists, masterBlasterMap));
        if(ElementMaterialOptions.size() > 2)
        {
            flmProd.Element_Material__c = ElementMaterialOptions[1].getValue();
        }
        return null;
    }


     //This method is used to hide Section B
    public PageReference showSectionB()
    {
       if(flmprod.Constrain_Product_Selection_by_Flow__c)
       {
            System.debug('If hiding'+flmprod.Constrain_Product_Selection_by_Flow__c);
            showSecB=true;
         }
         else
         {
            showSecB=false;
         }
        // System.debug('All executed'+showSecB);
         return null;
     }
    // This method is to convert the Max Allowable Pressure Drop from any unit to in.water
     public PageReference saveMaxAllwPressureDrop() {
        if(flmprod.Max_Allowable_Pressure_Drop_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (flmprod.Max_Allowable_Pressure_Drop__c != Null)
            {
             resultConvertPressure=unitConversions.convertPressure(flmprod.Max_Allowable_Pressure_Drop_Units__c,'in. water',flmprod.Max_Allowable_Pressure_Drop__c);
            if(resultConvertPressure.bResult)
                flmprod.Converted_Max_Allowable_Pressure_Drop__c=resultConvertPressure.dblRetValue;

                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        return null;
    }
    // This method is to convert the Required Flow Rate from any unit to SCFH
     public PageReference FlwRateSCFH() {
        if(flmprod.Required_Flow_Rate_Units__c != Null) {
            Result resultconvertGasFlowRate= new Result();
            if (flmprod.Required_Flow_Rate__c != Null)
            {
             resultconvertGasFlowRate=unitConversions.convertGasFlowRate(flmprod.Required_Flow_Rate_Units__c,'SCFH',flmprod.Required_Flow_Rate__c,flmprod.Converted_Max_Allowable_Pressure_Drop__c,flmprod.Molecular_Weight__c,flmprod.Converted_Temprature_of_flowing_Vapor__c,flmprod.Compressibility_Factor__c);
            if(resultconvertGasFlowRate.bResult)
                flmprod.Converted_Required_Flow_Rate__c=resultconvertGasFlowRate.dblRetValue;
                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultconvertGasFlowRate.strErrorMessage));
                }
            }
        }
        return null;
    }
    // This method is to convert the Atmospehric Pressure from any unit to psia
     public PageReference saveAtm() {
        if(flmprod.Atmospheric_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (flmprod.Atmospheric_Pressure__c != Null)
            {
             resultConvertPressure=unitConversions.convertPressure(flmprod.Atmospheric_Pressure_Units__c,'psia',flmprod.Atmospheric_Pressure__c);
            if(resultConvertPressure.bResult)
                flmprod.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;

                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        return null;
    }
    // This method is to convert the Temperature of Flowing Vapour from any unit to Deg R
     public PageReference TempUnit() {
        if(flmprod.Temperature_of_flowing_Vapor_Units__c != Null) {
            Result resultConvertTemperature= new Result();
        if (flmprod.Temperature_of_flowing_Vapor__c != Null)
            {
            resultConvertTemperature=unitConversions.convertTemperature(flmprod.Temperature_of_flowing_Vapor_Units__c,'Deg R',flmprod.Temperature_of_flowing_Vapor__c);
            if(resultConvertTemperature.bResult)
                flmprod.Converted_Temprature_of_flowing_Vapor__c=resultConvertTemperature.dblRetValue;
                else{
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
                     }
              }
            }
        return null;
    }
     //This method is to convert the Pressure of Flowing Vapor from any unit to psig
     public PageReference savePresFlwVapor() {
        if(flmprod.Pressure_of_flowing_Vapor_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (flmprod.Pressure_of_flowing_Vapor__c != Null)
            {
             resultConvertPressure=unitConversions.convertPressure(flmprod.Pressure_of_flowing_Vapor_Units__c,'psig',flmprod.Pressure_of_flowing_Vapor__c);
            if(resultConvertPressure.bResult)
                flmprod.Converted_Pressure_of_flowing_Vapor__c=resultConvertPressure.dblRetValue;

                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        return null;
    }
     // This method is to convert the Operational Pressure from any unit to psia
     public PageReference saveOprationalPress() {
        if(flmprod.Operational_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (flmprod.Operational_Pressure__c != Null)
            {
             resultConvertPressure=unitConversions.convertPressure(flmprod.Operational_Pressure_Units__c,'psia',flmprod.Operational_Pressure__c);
            if(resultConvertPressure.bResult)
                flmprod.Converted_Operational_Pressure__c=resultConvertPressure.dblRetValue;

                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                }
            }
        }
        return null;
    }
     // This method is to convert the Run Up Length A Input from any unit to Inches
       public PageReference saveLengthA() {
        if(flmprod.Run_Up_Length_A_Input_Units__c != Null) {
            Result resultConvertInches= new Result();
            if (flmprod.Run_Up_Length_A_Input__c != Null)
            {
             resultConvertInches=unitConversions.convertDistance(flmprod.Run_Up_Length_A_Input_Units__c,'in',flmprod.Run_Up_Length_A_Input__c);
            if(resultConvertInches.bResult)
                flmprod.Converted_Run_up_Length_A__c=resultConvertInches.dblRetValue;

                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertInches.strErrorMessage));
                }
            }
        }
        return null;
    }

    //This method is to convert the Run Up Length B Input from any unit to Inches
       public PageReference saveLengthB() {
        if(flmprod.Run_Up_Length_B_Input_Units__c != Null) {
            Result resultConvertInches= new Result();
            if (flmprod.Run_Up_Length_B_Input__c != Null)
            {
             resultConvertInches=unitConversions.convertDistance(flmprod.Run_Up_Length_B_Input_Units__c,'in',flmprod.Run_Up_Length_B_Input__c);
            if(resultConvertInches.bResult)
                flmprod.Converted_Run_up_Length_B__c=resultConvertInches.dblRetValue;

                else
                {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertInches.strErrorMessage));
                }
            }
        }
        return null;
    }
     //This method is to get all the Gas Media
    public List<SelectOption> getMediaList() {
       List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        options.add(new selectOption('Customer Specified','Customer Specified'));
            List<Media_Property__c> mediaPropertyList=[select Media_Phase__c,Media__c from Media_Property__c where Media_Phase__c='Gas/Vapor'];
            for (Media_Property__c mP:mediaPropertyList)
            {
                options.add(new selectOption(mP.Media__c,mP.Media__c));
            }
        return options;
        }
    //This method is to get the Media values based on Flowing Media type selected
    public PageReference MediaValues() {
        try {
            List<Media_Property__c> mD = new List<Media_Property__c>();
            mD = [select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c
                  where Media__c=:flmprod.Flowing_Media__c
                  limit 1];
            if(! mD.isEmpty())
            {
                flmprod.Media_Name__c=md.get(0).Media__c;
                flmprod.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
                flmprod.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
                flmprod.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
            }
            update flmprod;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    // This method is to convert the Picklist to Radio buttons for Atex
     public List<SelectOption> getTypes1()
     {
        List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Atex_Certificate_2014_34_EU__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
                  options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
     // This method is to convert the Picklist to Radio buttons for CU TR
     public List<SelectOption> getTypes2(){
        List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('CU_TR__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
                  options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    // This method is to convert the Picklist to Radio buttons for US Coast Guard
     public List<SelectOption> getTypes3(){
        List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('US_Coast_guard__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
                  options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
*/
   /*
    // This method is to convert the Picklist to Radio buttons for NACE
     public List<SelectOption> getTypes4()
     {
        List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('NACE__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
                  options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    //#######################################################################################################################
    public List<FLM_MasterBlaster__c> FAMBRecords {
        get {
            String queryString='Select Model__c,ConnSizeCode__c,Mounting__c,GasGroupLevel__c,CalculatedFlowUOM__c,ATEX__c,CUTR__c,USCG__c,OperationalPressurePSIA__c,OperationalTemp__c,Deflagration_Detonation__c,OffsetBases__c,RunUpLengthA_In__c,RunUpLengthB_In__c from FLM_MasterBlaster__c';
            String FirstWhereClause = 'where Mounting__c =\''+flmprod.Mounting__c+'\' and GasGroupLevel__c =\''+flmprod.Gas_Group_Code__c+'\'';
           // system.debug('whereClase'+FirstWhereClause);
            String SecondwhereClause='';
            String IntermediateWhereClasue = ' and OperationalPressurePSIA__c ='+flmprod.Converted_Operational_Pressure__c;
           // system.debug('whereClase'+IntermediateWhereClasue);
            String ThirdWhereClause = ' and OperationalTemp__c =\''+flmprod.Operational_Temperature__c+'\' and Deflagration_Detonation__c =\''+flmprod.Arrester_for_Detonation_or_Deflagration__c+'\' ';//and OffsetBases__c =\''+flmprod.Do_you_need_Offset_Bases__c+'\'';
          //  system.debug('third clause'+ThirdWhereClause);
            String FourthWhereClause = ' and RunUpLengthA_In__c >='+flmprod.Converted_Run_up_Length_A__c+' and RunUpLengthB_In__c >='+flmprod.Converted_Run_up_Length_B__c;
          // system.debug('whereClase'+FourthWhereClause);
            // Type 1 dynamic query combination
            if(flmprod.Mounting__c != 'End-of-Line' && flmprod.Arrester_for_Detonation_or_Deflagration__c=='DEF')
            {
                if(flmprod.Atex_Certificate_2014_34_EU__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and ATEX__c=\'Y\''+' '+IntermediateWhereClasue+' '+ThirdWhereClause+' '+FourthWhereClause;
                  //  system.debug('Atex'+SecondwhereClause);
                }
                if(flmprod.CU_TR__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and CUTR__c=\'Y\''+' '+IntermediateWhereClasue+' '+ThirdWhereClause+' '+FourthWhereClause;
                   // system.debug('CU TR'+SecondwhereClause);
                }
                 if(flmprod.US_Coast_guard__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and USCG__c=\'Y\''+' '+IntermediateWhereClasue+' '+ThirdWhereClause+' '+FourthWhereClause;
                   // system.debug('USCG'+SecondwhereClause);
                }
                if((flmprod.Atex_Certificate_2014_34_EU__c=='N' || string.isblank(flmprod.Atex_Certificate_2014_34_EU__c)) && (flmprod.CU_TR__c == 'N' || string.isblank(flmprod.CU_TR__c)) && (flmprod.US_Coast_guard__c == 'N' || string.isblank(flmprod.US_Coast_guard__c)))
                {
                    SecondwhereClause=SecondwhereClause+' '+IntermediateWhereClasue+' '+ThirdWhereClause+' '+FourthWhereClause;
                }
            }
           // Type 2 dynamic query combination
            if(flmprod.Mounting__c != 'End-of-Line' && flmprod.Arrester_for_Detonation_or_Deflagration__c!='DEF')
            {
                if(flmprod.Atex_Certificate_2014_34_EU__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and ATEX__c=\'Y\''+' '+IntermediateWhereClasue+' '+ThirdWhereClause;
                }
                if(flmprod.CU_TR__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and CUTR__c=\'Y\''+' '+IntermediateWhereClasue+' '+ThirdWhereClause;
                }
                 if(flmprod.US_Coast_guard__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and USCG__c=\'Y\''+' '+IntermediateWhereClasue+' '+ThirdWhereClause;
                }
                if((flmprod.Atex_Certificate_2014_34_EU__c=='N' || string.isblank(flmprod.Atex_Certificate_2014_34_EU__c)) && (flmprod.CU_TR__c == 'N' || string.isblank(flmprod.CU_TR__c)) && (flmprod.US_Coast_guard__c == 'N' || string.isblank(flmprod.US_Coast_guard__c)))
                {
                    SecondwhereClause=SecondwhereClause+' '+IntermediateWhereClasue+' '+ThirdWhereClause;
                }
            }
            if(flmprod.Mounting__c == 'End-of-Line' && flmprod.Arrester_for_Detonation_or_Deflagration__c == 'DEF')
            {
                if(flmprod.Atex_Certificate_2014_34_EU__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and ATEX__c=\'Y\''+' '+ThirdWhereClause+' '+FourthWhereClause;
                }
                if(flmprod.CU_TR__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and CUTR__c=\'Y\''+' '+ThirdWhereClause+' '+FourthWhereClause;
                }
                 if(flmprod.US_Coast_guard__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and USCG__c=\'Y\''+' '+ThirdWhereClause+' '+FourthWhereClause;
                }
                if((flmprod.Atex_Certificate_2014_34_EU__c=='N' || string.isblank(flmprod.Atex_Certificate_2014_34_EU__c)) && (flmprod.CU_TR__c == 'N' || string.isblank(flmprod.CU_TR__c)) && (flmprod.US_Coast_guard__c == 'N' || string.isblank(flmprod.US_Coast_guard__c)))
                {
                    SecondwhereClause=SecondwhereClause+' '+ThirdWhereClause+' '+FourthWhereClause;
                }
            }

            if(flmprod.Mounting__c == 'End-of-Line' && flmprod.Arrester_for_Detonation_or_Deflagration__c != 'DEF')
            {
                if(flmprod.Atex_Certificate_2014_34_EU__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and ATEX__c=\'Y\''+' '+ThirdWhereClause;
                }
                if(flmprod.CU_TR__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and CUTR__c=\'Y\''+' '+ThirdWhereClause;
                }
                 if(flmprod.US_Coast_guard__c=='Y')
                {
                    SecondwhereClause=SecondwhereClause+' and USCG__c=\'Y\''+' '+ThirdWhereClause;
                }
                if((flmprod.Atex_Certificate_2014_34_EU__c=='N' || string.isblank(flmprod.Atex_Certificate_2014_34_EU__c)) && (flmprod.CU_TR__c == 'N' || string.isblank(flmprod.CU_TR__c)) && (flmprod.US_Coast_guard__c == 'N' || string.isblank(flmprod.US_Coast_guard__c)))
                {
                    SecondwhereClause=SecondwhereClause+' '+ThirdWhereClause;
                }
            }
            queryString = queryString + ' '+ FirstWhereClause + ' ' + SecondwhereClause;
           // System.debug('query string value'+queryString);
            // List<FLM_MasterBlaster__c> sobjList = Database.query(queryString);
            List<FLM_MasterBlaster__c> sobjList = new list<FLM_MasterBlaster__c>();
           // system.debug('whereclause result'+sobjList);
            return sobjList;
        }

    }



    //#######################################################################################################################

    // This method is to Narrow down the model

    public List<SelectOption> getFlmModel()
    {
     List<selectOption> GetModels = new List<selectOption>();
        GetModels.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        for (FLM_MasterBlaster__c md: FAMBRecords ) {
            if(!uniqueList.contains(md.Model__c)){
                uniqueList.add(md.Model__c);
                GetModels.add(new selectOption(md.Model__c,md.Model__c));
            }
        }
        return GetModels;
    }

    public List<SelectOption> getFlmConnSize()
    {
     List<selectOption> GetConnSize = new List<selectOption>();
        GetConnSize.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        for (FLM_MasterBlaster__c cz: FAMBRecords ) {
            if(!uniqueList.contains(cz.ConnSizeCode__c)){
                uniqueList.add(cz.ConnSizeCode__c);
                GetConnSize.add(new selectOption(cz.ConnSizeCode__c,cz.ConnSizeCode__c));
            }
        }
        return GetConnSize;
    }
////////////////////////////////////////////////////////////////////////////////

     // This method is to Narrow down the Element Size based on Connection Size selected
    public PageReference ElementSize()
    {
        try {
            List<FLM_MasterBlaster__c> ES = new List<FLM_MasterBlaster__c>();
            ES = [Select ElemSizeCode__c from FLM_MasterBlaster__c
                     where Model__c=: flmprod.Model__c
                     and   ConnSizeCode__c=: flmProd.Connection_Size__c
                  limit 1];
            if(! ES.isEmpty())
            {
                flmProd.Element_Size__c=string.valueOf(ES.get(0).ElemSizeCode__c);
            }
           // update flmprod;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }
    // This method is to Narrow down the Drilling values
    public List<SelectOption> getDrilling() {
       List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
            List<FLM_Arrester_Drilling__c> drlng = new List<FLM_Arrester_Drilling__c>();
            Set<string> drillingset = new Set<string>();
            String BaseQuery = 'Select Description__c,Model__c,SizeCode__c from FLM_Arrester_Drilling__c';
            String WhereClause ='';
            if(flmprod.Model__c!=null &&  flmprod.Connection_Size__c!=null)
                 WhereClause = ' where Model__c =\''+flmprod.Model__c+'\' and SizeCode__c =\''+flmprod.Connection_Size__c+'\'';

            drlng=Database.query(BaseQuery+WhereClause) ;
            for (FLM_Arrester_Drilling__c dg :drlng)
            {
                if(drillingset.add(dg.Description__c))
                {
                options.add(new selectOption(dg.Description__c,dg.Description__c));
                }
            }
        return options;
        }
  //This method is to Narrow down the Body material values
    public List<SelectOption> getBodyMaterial() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        List<FLM_MasterBlaster__c> BdyMtrl = new List<FLM_MasterBlaster__c>();
        set<string> BodyMaterialSet = new set<string>();
        String BaseQuery = 'Select BodyMatlCode__c, Model__c, ConnSizeCode__c, ElemSizeCode__c from FLM_MasterBlaster__c';
        String WhereClause ='';
        if(flmprod.Model__c!=null && flmProd.Connection_Size__c!=null && flmProd.Element_Size__c!=null)
            WhereClause = ' where Model__c =\''+flmprod.Model__c+'\' and ConnSizeCode__c =\''+flmprod.Connection_Size__c+'\' and ElemSizeCode__c = \''+flmProd.Element_Size__c+'\'';

        BdyMtrl= Database.query(BaseQuery+WhereClause);
        Schema.sObjectType sobject_type = Flame_Product__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Body_Material__c').getDescribe().getPickListValues();
          for (FLM_MasterBlaster__c bm:BdyMtrl)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (bm.BodyMatlCode__c == a.getValue() && BodyMaterialSet.add(bm.BodyMatlCode__c))
                    {
                    options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
                }
        }
        return options;
    }
    //This method is to Narrow down the Housing material values
    public List<SelectOption> getHousingMaterial() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        List<FLM_MasterBlaster__c> HsngMtrl = new List<FLM_MasterBlaster__c>();
        set<string> HousingMaterialSet = new set<string>();
        String BaseQuery = 'Select BodyMatlCode__c, Model__c, ConnSizeCode__c, ElemSizeCode__c from FLM_MasterBlaster__c';
        String WhereClause ='';
        if(flmprod.Model__c!=null && flmProd.Connection_Size__c!=null && flmProd.Element_Size__c!=null)
            WhereClause = ' where Model__c =\''+flmprod.Model__c+'\' and ConnSizeCode__c =\''+flmprod.Connection_Size__c+'\' and ElemSizeCode__c = \''+flmProd.Element_Size__c+'\'';

        HsngMtrl= [Select HousingMatlCode__c,Model__c,ConnSizeCode__c,ElemSizeCode__c,BodyMatlCode__c from FLM_MasterBlaster__c where Model__c=:flmprod.Model__c];
        List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Housing_Material__c').getDescribe().getPickListValues();

        for (FLM_MasterBlaster__c hm:HsngMtrl)
            {
             if(hm.Model__c == flmprod.Model__c && hm.ConnSizeCode__c == flmProd.Connection_Size__c && hm.ElemSizeCode__c == flmProd.Element_Size__c &&  hm.BodyMatlCode__c == flmProd.Body_Material__c)
             {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (hm.HousingMatlCode__c==a.getValue()  && HousingMaterialSet.add(hm.HousingMatlCode__c))
                    options.add(new selectOption(a.getValue(),a.getLabel()));
               }
             }
        }
         if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {

        for (FLM_MasterBlaster__c hm:HsngMtrl)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (hm.HousingMatlCode__c==a.getValue()  && HousingMaterialSet.add(hm.HousingMatlCode__c))
                    options.add(new selectOption(a.getValue(),a.getLabel()));
               }
            }
        }
        return options;
    }
    //This method is to Narrow down the Element material values
    public List<SelectOption> getElementMaterial() {
        List<selectOption> options = new List<selectOption>();
        set<string> ElementMaterialSet = new set<string>();
        options.add(new selectOption('',''));
        List<FLM_MasterBlaster__c> ElmntMtrl = new List<FLM_MasterBlaster__c>();
        ElmntMtrl = [Select ElemMatlCode__c,Model__c,ConnSizeCode__c,ElemSizeCode__c,BodyMatlCode__c,HousingMatlCode__c from FLM_MasterBlaster__c];
        List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Element_Material__c').getDescribe().getPickListValues();

        for (FLM_MasterBlaster__c em:ElmntMtrl)
            {
             if(em.Model__c == flmprod.Model__c && em.ConnSizeCode__c == flmProd.Connection_Size__c && em.ElemSizeCode__c == flmProd.Element_Size__c &&  em.BodyMatlCode__c == flmProd.Body_Material__c && em.HousingMatlCode__c == flmProd.Housing_Material__c)
             {
                 for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (em.ElemMatlCode__c == a.getValue() && ElementMaterialSet.add(em.ElemMatlCode__c))
                    options.add(new selectOption(a.getValue(),a.getLabel()));
               }
             }
        }
       if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
       {
           for (FLM_MasterBlaster__c em:ElmntMtrl)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (em.ElemMatlCode__c == a.getValue() && ElementMaterialSet.add(em.ElemMatlCode__c))
                    options.add(new selectOption(a.getValue(),a.getLabel()));
               }
        }
       }
        return options;
    }
    //This method is to Narrow down the Inlet option A values
    public List<SelectOption> getInletOptionA() {
        List<selectOption> options = new List<selectOption>();
        set<string> InletOptionAset = new set<string>();
       options.add(new selectOption('',''));
        List<FLM_PortOptions__c> IoptA = new List<FLM_PortOptions__c>();
          IoptA= [Select PortOptionCode__c, Model__c, SizeCode__c, Port__c from FLM_PortOptions__c];
                List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Inlet_Option_A__c').getDescribe().getPickListValues();

          for (FLM_PortOptions__c IA:IoptA)
            {
                if(IA.Model__c == flmprod.Model__c && IA.SizeCode__c == flmProd.Connection_Size__c && IA.Port__c=='Inlet-A')
                {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (IA.PortOptionCode__c == a.getValue() && InletOptionAset.add(IA.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
              }
            }
        if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {
            for (FLM_PortOptions__c IA:IoptA)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (IA.PortOptionCode__c == a.getValue() && InletOptionAset.add(IA.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
            }
        }
        return options;
    }
     //This method is to Narrow down the Inlet option B values
    public List<SelectOption> getInletOptionB() {
        List<selectOption> options = new List<selectOption>();
       options.add(new selectOption('',''));
        set<string> InletOptionBset = new set<string>();
      // options.add(new selectOption('',''));
        List<FLM_PortOptions__c> IoptB = new List<FLM_PortOptions__c>();
          IoptB= [Select PortOptionCode__c, Model__c, SizeCode__c, Port__c from FLM_PortOptions__c];
                List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Inlet_Option_B__c').getDescribe().getPickListValues();

          for (FLM_PortOptions__c IB:IoptB)
            {
                if(IB.Model__c == flmprod.Model__c && IB.SizeCode__c == flmProd.Connection_Size__c && IB.Port__c=='Inlet-B')
                {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (IB.PortOptionCode__c == a.getValue() && InletOptionBset.add(IB.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
              }
            }
        if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {
            for (FLM_PortOptions__c IB:IoptB)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (IB.PortOptionCode__c == a.getValue() && InletOptionBset.add(IB.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
            }
        }
        return options;
    }
     //This method is to Narrow down the Inlet option C value
    public List<SelectOption> getInletOptionC() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        set<string> InletOptionCset = new set<string>();
      // options.add(new selectOption('',''));
        List<FLM_PortOptions__c> IoptC = new List<FLM_PortOptions__c>();
          IoptC= [Select PortOptionCode__c, Model__c, SizeCode__c, Port__c from FLM_PortOptions__c];
                List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Inlet_Option_C__c').getDescribe().getPickListValues();

          for (FLM_PortOptions__c IC:IoptC)
            {
                if(IC.Model__c == flmprod.Model__c && IC.SizeCode__c == flmProd.Connection_Size__c && IC.Port__c=='Inlet-C')
                {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (IC.PortOptionCode__c == a.getValue() && InletOptionCset.add(IC.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
              }
            }
        if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {
            for (FLM_PortOptions__c IC:IoptC)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (IC.PortOptionCode__c == a.getValue() && InletOptionCset.add(IC.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
            }
        }
        return options;
    }
    //This method is to Narrow down the Outlet option A values
    public List<SelectOption> getOutletOptionA() {
        List<selectOption> options = new List<selectOption>();
       options.add(new selectOption('',''));
        set<string> OutletOptionAset = new set<string>();
      // options.add(new selectOption('',''));
        List<FLM_PortOptions__c> OoptA = new List<FLM_PortOptions__c>();
          OoptA= [Select PortOptionCode__c, Model__c, SizeCode__c, Port__c from FLM_PortOptions__c];
                List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Outlet_Option_A__c').getDescribe().getPickListValues();

          for (FLM_PortOptions__c OA:OoptA)
            {
                if(OA.Model__c == flmprod.Model__c && OA.SizeCode__c == flmProd.Connection_Size__c && OA.Port__c=='Outlet-A')
                {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (OA.PortOptionCode__c == a.getValue() && OutletOptionAset.add(OA.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
              }
            }
        if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {
            for (FLM_PortOptions__c OA:OoptA)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (OA.PortOptionCode__c == a.getValue() && OutletOptionAset.add(OA.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
            }
        }
        return options;
    }
    //This method is to Narrow down the Outlet option B values
    public List<SelectOption> getOutletOptionB() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        set<string> OutletOptionBset = new set<string>();
      // options.add(new selectOption('',''));
        List<FLM_PortOptions__c> OoptB = new List<FLM_PortOptions__c>();
          OoptB= [Select PortOptionCode__c, Model__c, SizeCode__c, Port__c from FLM_PortOptions__c];
                List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Outlet_Option_B__c').getDescribe().getPickListValues();

          for (FLM_PortOptions__c OB:OoptB)
            {
                if(OB.Model__c == flmprod.Model__c && OB.SizeCode__c == flmProd.Connection_Size__c && OB.Port__c=='Outlet-B')
                {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (OB.PortOptionCode__c == a.getValue() && OutletOptionBset.add(OB.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
              }
            }
        if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {
            for (FLM_PortOptions__c OB:OoptB)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (OB.PortOptionCode__c == a.getValue() && OutletOptionBset.add(OB.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
            }
        }
        return options;
    }
    //This method is to Narrow down the Outlet option C values
    public List<SelectOption> getOutletOptionC() {
        List<selectOption> options = new List<selectOption>();
       options.add(new selectOption('',''));
        set<string> OutletOptionCset = new set<string>();
      // options.add(new selectOption('',''));
        List<FLM_PortOptions__c> OoptC = new List<FLM_PortOptions__c>();
          OoptC= [Select PortOptionCode__c, Model__c, SizeCode__c, Port__c from FLM_PortOptions__c];
                List<Schema.PicklistEntry> pick_list_values = FLMFieldMap.get('Outlet_Option_C__c').getDescribe().getPickListValues();

          for (FLM_PortOptions__c OC:OoptC)
            {
                if(OC.Model__c == flmprod.Model__c && OC.SizeCode__c == flmProd.Connection_Size__c && OC.Port__c=='Outlet-C')
                {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (OC.PortOptionCode__c == a.getValue() && OutletOptionCset.add(OC.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
              }
            }
        if(options.size() == 1 && flmprod.Model__c != null && flmprod.Connection_Size__c != null)
        {
            for (FLM_PortOptions__c OC:OoptC)
            {
                for (Schema.PicklistEntry a : pick_list_values)
                {
                    if (OC.PortOptionCode__c == a.getValue() && OutletOptionCset.add(OC.PortOptionCode__c))
                    {
                         options.add(new selectOption(a.getValue(),a.getLabel()));
                    }
               }
            }
        }
        return options;
    }
    //This method is used for hiding/showing of "Pallet Material", "Pressure setting" and "Spring range" if 8400A is selected as Model
    public PageReference setConnectionSize()
    {
        connSizeOptions.clear();
        if(String.isNotBlank(flmProd.Model__c))
        {
           // System.debug('**** Model = '+flmProd.Model__c);
            for(String conSize: modelVsConnection.get(flmProd.Model__c))
            {
              //  System.debug('**** conSize = '+conSize);
                connSizeOptions.add(new selectOption(conSize, conSize));
            }
        }
        return null;
     }
*/

}