/**
* @File Name          : configureRVproduct.cls
* @Description        :
* @Author             : ApexIT - SFDC Dev Team
* @Group              :
* @Modification Log   :
* Ver     Date          Author                     Modification
* 1.0     -             ApexIT - SFDC Dev Team     Initial Version
* 1.1     02 Feb 2021   Rohini Hathi               Service Ticket #203415, Too many soql queries: 101 
**/
public with sharing class configureRVproduct {
    public string strURL{get;set;}
    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public string strQuoteStatus {set;get;}
    public Map<decimal,list<String>> sizeToValMap{get;set;}
    Public boolean showsales {get;set;}
    public boolean disableButton {get;set;}
    public Relief_Valve__c conRV {set; get;}
    public RVOutputUtility RVOU;
    public id quoteId {set;get;}
    public List<SelectOption> drillingOption{get; set;}
    public List<SelectOption> bodyMaterialOptions{get; set;}
    public List<SelectOption> facingOptions{get; set;}
    public List<SelectOption> seatMaterialOptions{get; set;}
    public List<SelectOption> pressurePalletMaterialOptions{get; set;}
    public List<SelectOption> palletTypeOptions{get; set;}
    public List<SelectOption> diaphragmMaterialOptions{get; set;}
    public List<SelectOption> vacuumPalletMaterialOptions{get; set;}
    public List<SelectOption> pilotSoftGoodsMaterialOptions{get; set;}
    public List<SelectOption> weightMaterialOptions{get;set;}
    public List<SelectOption> springMaterialOptions{get; set;}
    public List<SelectOption> fastenerMaterialOptions{get; set;}
    public List<SelectOption> paintingCoatingOptions{get; set;}
    public List<SelectOption> bodyCoatingMaterialOptions{get; set;}
    public List<SelectOption> steamJacketMaterialOptions{get; set;}
    public List<SelectOption> palletFastenerCoatingMaterialOptions{get; set;}
    public List<SelectOption> elementMaterialOptions{get; set;}
    public List<SelectOption> flameArresterOptions{get; set;}
    public List<SelectOption> vacuumPortOptions{get; set;}
    public List<SelectOption> pilotActionOptions{get; set;}
    public List<SelectOption> radiographyOptions{get; set;}
    public List<SelectOption> liquidDyePenetrantOptions{get; set;}
    public List<SelectOption> positiveMaterialIdentificationOptions{get; set;}

    public String selectedTab {get;set;}
    public String selectedTab1 {get;set;}
    public list<structureWrapper> strucWrapList{get;set;}


    public Boolean pressurePortProximitySensor {get;set;}
    public Boolean vacuumPortProximitySensor {get;set;}
    public Boolean manualBlowdown {get;set;}
    public Boolean remoteSense {get;set;}
    public Boolean pilotExhaustPipedToDischargeHeader {get;set;}
    public Boolean fieldTestConnection {get;set;}
    public Boolean pilotSupplyFilter {get;set;}

    public Boolean method21LeakDetection {get;set;}
    public Boolean filletWeldLiquidDyePenetrant {get;set;}
    public Boolean ultrasonicExamination {get;set;}
    public Boolean magneticParticleExamination {get;set;}
    public Boolean brinellHardnessExamination {get;set;}
    public Boolean charpyImpactTesting {get;set;}
    public Boolean visualCastingExamination {get;set;}
    public Boolean intergranularCorrosionTest {get;set;}

    public Boolean drillingBoolean{get; set;}
    public Boolean bodyMaterialBoolean{get; set;}
    public Boolean facingBoolean{get; set;}
    public Boolean seatMaterialBoolean{get; set;}
    public Boolean pressurePalletMaterialBoolean{get; set;}
    public Boolean palletTypeBoolean{get; set;}
    public Boolean diaphragmMaterialBoolean{get; set;}
    public Boolean vacuumPalletMaterialBoolean{get; set;}
    public Boolean pilotSoftGoodsMaterialBoolean{get; set;}
    public Boolean weightMaterialBoolean{get;set;}
    public Boolean springMaterialBoolean{get; set;}
    public Boolean fastenerMaterialBoolean{get; set;}
    public Boolean paintingCoatingBoolean{get; set;}
    public Boolean bodyCoatingMaterialBoolean{get; set;}
    public Boolean steamJacketMaterialBoolean{get; set;}
    public Boolean ShowsteamJacketMaterialBoolean{get; set;}
    public Boolean palletFastenerCoatingMaterialBoolean{get; set;}
    public Boolean elementMaterialBoolean{get; set;}
    public Boolean flameArresterBoolean{get; set;}
    public Boolean vacuumPortBoolean{get; set;}
    public Boolean pilotActionBoolean{get; set;}
    public Boolean radiographyBoolean{get; set;}
    public Boolean liquidDyePenetrantBoolean{get; set;}
    public Boolean positiveMaterialIdentificationBoolean{get; set;}
    public RV_Outputs__c rvOutput;


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
     //public String selectedTab {get;set;}
    //Added for test coverage, nikhil 19 feb
    public List<RV_EXMOMC_Cons__c> pmiList;// nikhil 19 feb
    public List<RV_Input_Attr_Value_Desc__c> inputAttrValue_test = new List<RV_Input_Attr_Value_Desc__c>(); //nikhil 19 feb

     public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
         strURL = '/apex/configRVReference?Id=' + ConRV.id;

        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }

	public configureRVproduct()
    {
        RVPriceWrapperList = new list<priceWrapper>(); 
        //RVPricingList = new list<RV_Valve_Price_Details__c >();
        RVLeadTimeList = new list<LeadTimeWrapper>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        drillingOption = new List<SelectOption>();
        bodyMaterialOptions = new List<SelectOption>();
        facingOptions  = new List<SelectOption>();
        seatMaterialOptions = new List<SelectOption>();
        pressurePalletMaterialOptions  = new List<SelectOption>();
        palletTypeOptions  = new List<SelectOption>();
        diaphragmMaterialOptions = new List<SelectOption>();
        vacuumPalletMaterialOptions = new List<SelectOption>();
        pilotSoftGoodsMaterialOptions  = new List<SelectOption>();
        weightMaterialOptions = new List<SelectOption>();
        springMaterialOptions  = new List<SelectOption>();
        fastenerMaterialOptions = new List<SelectOption>();
        paintingCoatingOptions  = new List<SelectOption>();
        bodyCoatingMaterialOptions = new List<SelectOption>();
        steamJacketMaterialOptions = new List<SelectOption>();
        palletFastenerCoatingMaterialOptions = new List<SelectOption>();
        elementMaterialOptions = new List<SelectOption>();
        flameArresterOptions = new List<SelectOption>();
        vacuumPortOptions  = new List<SelectOption>();
        pilotActionOptions = new List<SelectOption>();
        radiographyOptions = new List<SelectOption>();
        liquidDyePenetrantOptions = new List<SelectOption>();
        positiveMaterialIdentificationOptions = new List<SelectOption>();
    }
    public configureRVproduct(ApexPages.StandardController controller)
    {
        //@Suraj 31 Oct start
        	assembleCost = new List<Cost__c>();
        	buildCost = new List<Cost__c>();
        //@Suraj 31 Oct end
        
        //Nagrjuna added Tab visibility logic
        ReorderFlag=false;
         showsales = False;
        // disableButton = false;
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

        // visibility logic ended
        quoteId=ApexPages.currentPage().getParameters().get('qid');
        if(string.isNotBlank(quoteId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
        
        //id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteId);
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteId);
        
      ////  disableButton = (!showsales) && conRV.Quote_Description_Engineer_Override__c;
        System.debug('Record ID--' +RecordID);
        conRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        if(conRV.Finish_Configuration_Flag__c)
        {
            //RVOU = new RVOutputUtility(conRV.id);
            RVOU = new RVOutputUtility(conRV);
            selectedTab = 'ProductReview';  
        }
        RVPriceWrapperList = new list<priceWrapper>(); 
        //RVPricingList = new list<RV_Valve_Price_Details__c >();
        RVLeadTimeList = new list<LeadTimeWrapper>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        drillingOption = new List<SelectOption>();
        bodyMaterialOptions = new List<SelectOption>();
        facingOptions  = new List<SelectOption>();
        seatMaterialOptions = new List<SelectOption>();
        pressurePalletMaterialOptions  = new List<SelectOption>();
        palletTypeOptions  = new List<SelectOption>();
        diaphragmMaterialOptions = new List<SelectOption>();
        vacuumPalletMaterialOptions = new List<SelectOption>();
        pilotSoftGoodsMaterialOptions  = new List<SelectOption>();
        weightMaterialOptions = new List<SelectOption>();
        springMaterialOptions  = new List<SelectOption>();
        fastenerMaterialOptions = new List<SelectOption>();
        paintingCoatingOptions  = new List<SelectOption>();
        bodyCoatingMaterialOptions = new List<SelectOption>();
        steamJacketMaterialOptions = new List<SelectOption>();
        palletFastenerCoatingMaterialOptions = new List<SelectOption>();
        elementMaterialOptions = new List<SelectOption>();
        flameArresterOptions = new List<SelectOption>();
        vacuumPortOptions  = new List<SelectOption>();
        pilotActionOptions = new List<SelectOption>();
        radiographyOptions = new List<SelectOption>();
        liquidDyePenetrantOptions = new List<SelectOption>();
        positiveMaterialIdentificationOptions = new List<SelectOption>();
		rvOutput = getRVOutputRecord(conRV.Id);
        if(String.isNotBlank(ConRV.Positive_Material_Identification__c ) && null != ConRV.Positive_Material_Identification__c )
        {
            positiveMaterialIdentificationBoolean = true;
        }
        // ######### added by piyush 
        editModeLable = 'Edit';	
        quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        system.debug('ConRV --> Configuration_Complete__c ' + ConRV.Finish_Configuration_Flag__c);
        system.debug('ConRV Quote_Description_Engineer_Override__c --> ' + ConRV.Quote_Description_Engineer_Override__c);

        if(conRV.Finish_Configuration_Flag__c)
        {
           if(conRV.Quote_Description_Engineer_Override__c)
           {
              // complete with override 
              configStatus = 'Complete with Override(s)';
            
           }
           else
           {
                  // complete no override 
                  configStatus = 'Complete No Overrides';
           }
        }
        else
        {
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
        if(QuoteLIneView == 'Editable')
        {
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable')
            {
                disableButton = false;
                bShowEditButton = false;
            }
            else
            {
                disableButton = true;
            }
            
        }else if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
        }        
        system.debug('bShowEditButton----> ' + bShowEditButton);
        system.debug('disableButton----> ' + disableButton);
        

        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            if (conRV.Price_Engineer_Override__c == true ||
                conRV.Lead_Time_Override__c == true ||
                conRV.Build_Cost_Override__c == true ||
                conRV.Quote_Description_Engineer_Override__c == true
                ){
                    disableButton = true;
                    bShowEditButton = false;
            }
         }


        //----------------piyush----------------

        getdrillingOptions();
        getPaintingCoatingOptions();
        if(conRV.Finish_Configuration_Flag__c == false)
        {
            getPalletTypeOptions();
            getFastenerMaterialOptions();
            getFlameArresterOptions();
            getVacuumPortOptions();
            getPressurePortProximitySensor();
            getVacuumPortProximitySensor();
            getPilotActionOptions();
            getManualBlowdown();
            getRemoteSense();
            getPilotExhaustPipedToDischargeHeader();
            getFieldTestConnection();
            getPilotSupplyFilter();
            getMethod21LeakDetection();
            getRadiographyOptions();
            getFilletWeldLiquidDyePenetrant();
            getUltrasonicExamination();
            getBrinellHardnessExamination();
            getVisualCastingExamination();
        }
        else
        {
            getManualBlowdown();
            getRemoteSense();
            getPilotExhaustPipedToDischargeHeader();
            getFieldTestConnection();
            getPilotSupplyFilter();
            getMethod21LeakDetection();
            getMethod21LeakDetection();
            getRadiographyOptions();
            getFilletWeldLiquidDyePenetrant();
            getUltrasonicExamination();
            getBrinellHardnessExamination();
            getVisualCastingExamination();
            getFlameArresterOptions();
            /*paintingCoatingBoolean = true;
            pressurePortProximitySensor = true;
            vacuumPortProximitySensor = true;*/
        }
		if(ApexPages.currentPage().getParameters().get('selectedTab') == 'EngineeringSpecials')
        {
            selectedTab = 'EngineeringSpecials';
            //getTabData();
        } 
        Map<String, String> valueVsDescription = getRVInputAttrValueDesc(conRV);
        if(valueVsDescription.size() > 0)
        {
            
            if(valueVsDescription.containsKey(conRV.Body_Material__c + '_MCBODY'))
            {
                bodyMaterialOptions.add(new selectOption(conRV.Body_Material__c, valueVsDescription.get(conRV.Body_Material__c + '_MCBODY')));
            }
            if(valueVsDescription.containsKey(conRV.Facing__c + '_GPFACE'))
            {
                FacingOptions.add(new selectOption(conRV.Facing__c, valueVsDescription.get(conRV.Facing__c + '_GPFACE')));
            }
            if(valueVsDescription.containsKey(conRV.Seat_Material__c + '_MCSEAT'))
            {
                SeatMaterialOptions.add(new selectOption(conRV.Seat_Material__c, valueVsDescription.get(conRV.Seat_Material__c + '_MCSEAT')));
            }
            if(valueVsDescription.containsKey(conRV.Pressure_Pallet_Material__c + '_MCPALL'))
            {
                PressurePalletMaterialOptions.add(new selectOption(conRV.Pressure_Pallet_Material__c, valueVsDescription.get(conRV.Pressure_Pallet_Material__c + '_MCPALL')));
            }
            if(valueVsDescription.containsKey(conRV.Diaphragm_Material__c + '_MCDPHM'))
            {
                DiaphragmMaterialOptions.add(new selectOption(conRV.Diaphragm_Material__c, valueVsDescription.get(conRV.Diaphragm_Material__c + '_MCDPHM')));
            }
            if(valueVsDescription.containsKey(conRV.Vacuum_Pallet_Material__c + '_MCPALL'))
            {
                vacuumPalletMaterialOptions.add(new selectOption(conRV.Vacuum_Pallet_Material__c, valueVsDescription.get(conRV.Vacuum_Pallet_Material__c + '_MCPALL')));
            }
            if(valueVsDescription.containsKey(conRV.Pilot_Soft_Goods_Material__c + '_MCPSGD'))
            {
                PilotSoftGoodsMaterialOptions.add(new selectOption(conRV.Pilot_Soft_Goods_Material__c, valueVsDescription.get(conRV.Pilot_Soft_Goods_Material__c + '_MCPSGD')));
            }
            if(valueVsDescription.containsKey(conRV.Flame_Arrester_Option__c + '_GOUTOP'))
            {
                flameArresterOptions.add(new selectOption(conRV.Flame_Arrester_Option__c, valueVsDescription.get(conRV.Flame_Arrester_Option__c + '_GOUTOP')));
            }
            if(valueVsDescription.containsKey(conRV.Weight_Material__c + '_MCWGHT'))
            {
                WeightMaterialOptions.add(new selectOption(conRV.Weight_Material__c, valueVsDescription.get(conRV.Weight_Material__c + '_MCWGHT')));
            }
            if(valueVsDescription.containsKey(conRV.Spring_Material__c + '_MCSPRG'))
            {
                SpringMaterialOptions.add(new selectOption(conRV.Spring_Material__c, valueVsDescription.get(conRV.Spring_Material__c + '_MCSPRG')));
            }
            if(valueVsDescription.containsKey(conRV.Steam_Jacket_Material__c + '_MCSTMJ'))
            {
                SteamJacketMaterialOptions.add(new selectOption(conRV.Steam_Jacket_Material__c, valueVsDescription.get(conRV.Steam_Jacket_Material__c + '_MCSTMJ')));
            }
            if(valueVsDescription.containsKey(conRV.Body_Coating_Material__c + '_MCCOTB'))
            {
                BodyCoatingMaterialOptions.add(new selectOption(conRV.Body_Coating_Material__c, valueVsDescription.get(conRV.Body_Coating_Material__c + '_MCCOTB')));
            }
            if(valueVsDescription.containsKey(conRV.Pallet_Fastener_Coating_Material__c + '_MCCOTP'))
            {
                PalletFastenerCoatingMaterialOptions.add(new selectOption(conRV.Pallet_Fastener_Coating_Material__c, valueVsDescription.get(conRV.Pallet_Fastener_Coating_Material__c + '_MCCOTP')));
            }
            if(valueVsDescription.containsKey(conRV.Element_Material__c + '_MCELMT'))
            {
                ElementMaterialOptions.add(new selectOption(conRV.Element_Material__c, valueVsDescription.get(conRV.Element_Material__c + '_MCELMT')));
            }
            System.debug('--> '+conRV.Vacuum_Port_Option__c );
            if(valueVsDescription.containsKey(conRV.Vacuum_Port_Option__c + '_VPRTOP'))
            {
                VacuumPortOptions.add(new selectOption(conRV.Vacuum_Port_Option__c, valueVsDescription.get(conRV.Vacuum_Port_Option__c + '_VPRTOP')));
            }
            if(valueVsDescription.containsKey(conRV.Positive_Material_Identification__c + '_PMI'))
            {
                PositiveMaterialIdentificationOptions.add(new selectOption(conRV.Positive_Material_Identification__c, valueVsDescription.get(conRV.Positive_Material_Identification__c + '_PMI')));
            }
            if(valueVsDescription.containsKey(conRV.Liquid_Dye_Penetrant__c + '_LDP'))
            {
                LiquidDyePenetrantOptions.add(new selectOption(conRV.Liquid_Dye_Penetrant__c, valueVsDescription.get(conRV.Liquid_Dye_Penetrant__c + '_LDP')));
            }
            
            if(valueVsDescription.containsKey(conRV.Pallet_Type__c + '_GPTYPE'))
            {
                PalletTypeOptions.add(new selectOption(conRV.Pallet_Type__c, valueVsDescription.get(conRV.Pallet_Type__c + '_GPTYPE')));
            }
            
            if(valueVsDescription.containsKey(conRV.Pilot_Action__c + '_GPACT'))
            {
                PilotActionOptions.add(new selectOption(conRV.Pilot_Action__c, valueVsDescription.get(conRV.Pilot_Action__c + '_GPACT')));
            }
            
            /****************Setting the values on load and checking for attribute None******************************/
            
            if(String.isNotBlank(ConRV.Body_Material__c ) && null != ConRV.Body_Material__c && (ConRV.Body_Material__c != 'N' || (valueVsDescription.get(conRV.Body_Material__c + '_MCBODY') == 'None')))
            bodyMaterialBoolean = true;

            if(String.isNotBlank(ConRV.Facing__c ) && null != ConRV.Facing__c && ConRV.Facing__c != 'N')
            {
                facingBoolean = true;
            }
            
            if(String.isNotBlank(ConRV.Seat_Material__c ) && null != ConRV.Seat_Material__c && ConRV.Seat_Material__c != 'N')
                seatMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Pressure_Pallet_Material__c ) && null != ConRV.Pressure_Pallet_Material__c && ConRV.Pressure_Pallet_Material__c != 'N')
                pressurePalletMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Diaphragm_Material__c ) && null != ConRV.Diaphragm_Material__c && ConRV.Diaphragm_Material__c != 'N')
                diaphragmMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Vacuum_Pallet_Material__c ) && null != ConRV.Vacuum_Pallet_Material__c && ConRV.Vacuum_Pallet_Material__c != 'N')
                vacuumPalletMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Pilot_Soft_Goods_Material__c ) && null != ConRV.Pilot_Soft_Goods_Material__c && ConRV.Pilot_Soft_Goods_Material__c != 'N')
                pilotSoftGoodsMaterialBoolean = true;
            
            if(String.isNotBlank(ConRV.Flame_Arrester_Option__c ) && null != ConRV.Flame_Arrester_Option__c && ConRV.Flame_Arrester_Option__c != '000')
                flameArresterBoolean = true;
           // if(ConRV.Finish_Configuration_Flag__c)flameArresterBoolean = false;
    
            if(String.isNotBlank(ConRV.Weight_Material__c ) && null != ConRV.Weight_Material__c && ConRV.Weight_Material__c != 'N')
                weightMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Spring_Material__c ) && null != ConRV.Spring_Material__c && ConRV.Spring_Material__c != 'N')
                springMaterialBoolean = true;
    
            System.debug('VVVConstructor display Flag show Flag' +conRV.SteamJacket_Display_Flag__c);
            System.debug('VVVConstructor display Flag' +ConRV.Steam_Jacket_Material__c);
            if(String.isNotBlank(ConRV.Steam_Jacket_Material__c ) && null != ConRV.Steam_Jacket_Material__c && conRV.Steam_Jacket_Material__c != '0')
                steamJacketMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Body_Coating_Material__c ) && null != ConRV.Body_Coating_Material__c && ConRV.Body_Coating_Material__c != 'N')
                bodyCoatingMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Pallet_Fastener_Coating_Material__c ) && null != ConRV.Pallet_Fastener_Coating_Material__c && ConRV.Pallet_Fastener_Coating_Material__c != 'N')
                palletFastenerCoatingMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Element_Material__c ) && null != ConRV.Element_Material__c && ConRV.Element_Material__c != 'N')
                elementMaterialBoolean = true;
              System.debug('@@@Vacuum_Port_Option__c' +conRV.Vacuum_Port_Option__c);
            if(String.isNotBlank(ConRV.Vacuum_Port_Option__c ) && null != ConRV.Vacuum_Port_Option__c && ConRV.Vacuum_Port_Option__c != 'N')
                vacuumPortBoolean = true;
            //if(ConRV.Finish_Configuration_Flag__c)vacuumPortBoolean = false;
            if(String.isNotBlank(ConRV.Pallet_Type__c ) && null != ConRV.Pallet_Type__c && ConRV.Pallet_Type__c != 'N')
                palletTypeBoolean = true;
            
            if(String.isNotBlank(ConRV.Pilot_Action__c ) && null != ConRV.Pilot_Action__c && ConRV.Pilot_Action__c != 'N')
                pilotActionBoolean = true;
    
    
            if(String.isNotBlank(ConRV.Liquid_Dye_Penetrant__c ) && null != ConRV.Liquid_Dye_Penetrant__c && ConRV.Liquid_Dye_Penetrant__c != 'N')
                liquidDyePenetrantBoolean = true;

        }
    }
    
    //Constructor for Reorder Purpose
    //Reorder Code Starts here
    public Boolean ReorderFlag{get;set;}
	
	public configureRVproduct(Id quoteId)
    {
        //Nagrjuna added Tab visibility logic
         showsales = False;
        // disableButton = false;
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

        // visibility logic ended
      //  quoteId=ApexPages.currentPage().getParameters().get('qid');
        if(string.isNotBlank(quoteId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c,SBQQ__Product__c,SBQQ__ProductCode__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        else
            System.debug('QuoteLine Id is Missing');
        
        //id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteId);
        Id RecordID = wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine, quoteId);
        
      ////  disableButton = (!showsales) && conRV.Quote_Description_Engineer_Override__c;
        System.debug('Record ID--' +RecordID);
        conRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(RecordID).objResultList[0];
        if(conRV.Finish_Configuration_Flag__c)
        {
            //RVOU = new RVOutputUtility(conRV.id);
            RVOU = new RVOutputUtility(conRV); 
            selectedTab = 'ProductReview';  
        }
        RVPriceWrapperList = new list<priceWrapper>(); 
        //RVPricingList = new list<RV_Valve_Price_Details__c >();
        RVLeadTimeList = new list<LeadTimeWrapper>();
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        drillingOption = new List<SelectOption>();
        bodyMaterialOptions = new List<SelectOption>();
        facingOptions  = new List<SelectOption>();
        seatMaterialOptions = new List<SelectOption>();
        pressurePalletMaterialOptions  = new List<SelectOption>();
        palletTypeOptions  = new List<SelectOption>();
        diaphragmMaterialOptions = new List<SelectOption>();
        vacuumPalletMaterialOptions = new List<SelectOption>();
        pilotSoftGoodsMaterialOptions  = new List<SelectOption>();
        weightMaterialOptions = new List<SelectOption>();
        springMaterialOptions  = new List<SelectOption>();
        fastenerMaterialOptions = new List<SelectOption>();
        paintingCoatingOptions  = new List<SelectOption>();
        bodyCoatingMaterialOptions = new List<SelectOption>();
        steamJacketMaterialOptions = new List<SelectOption>();
        palletFastenerCoatingMaterialOptions = new List<SelectOption>();
        elementMaterialOptions = new List<SelectOption>();
        flameArresterOptions = new List<SelectOption>();
        vacuumPortOptions  = new List<SelectOption>();
        pilotActionOptions = new List<SelectOption>();
        radiographyOptions = new List<SelectOption>();
        liquidDyePenetrantOptions = new List<SelectOption>();
        positiveMaterialIdentificationOptions = new List<SelectOption>();
		rvOutput = getRVOutputRecord(conRV.Id);
        if(String.isNotBlank(ConRV.Positive_Material_Identification__c ) && null != ConRV.Positive_Material_Identification__c )
        {
            positiveMaterialIdentificationBoolean = true;
        }
        // ######### added by piyush 
        editModeLable = 'Edit';	
        quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        system.debug('ConRV --> Configuration_Complete__c ' + ConRV.Finish_Configuration_Flag__c);
        system.debug('ConRV Quote_Description_Engineer_Override__c --> ' + ConRV.Quote_Description_Engineer_Override__c);

        if(conRV.Finish_Configuration_Flag__c)
        {
           if(conRV.Quote_Description_Engineer_Override__c)
           {
              // complete with override 
              configStatus = 'Complete with Override(s)';
            
           }
           else
           {
                  // complete no override 
                  configStatus = 'Complete No Overrides';
           }
        }
        else
        {
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
        if(QuoteLIneView == 'Editable')
        {
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable')
            {
                disableButton = false;
                bShowEditButton = false;
            }
            else
            {
                disableButton = true;
            }
            
        }else if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
        }        
        system.debug('bShowEditButton----> ' + bShowEditButton);
        system.debug('disableButton----> ' + disableButton);
        

        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            if (conRV.Price_Engineer_Override__c == true ||
                conRV.Lead_Time_Override__c == true ||
                conRV.Build_Cost_Override__c == true ||
                conRV.Quote_Description_Engineer_Override__c == true
                ){
                    disableButton = true;
                    bShowEditButton = false;
            }
         }


        //----------------piyush----------------

        getdrillingOptions();
        getPaintingCoatingOptions();
        if(conRV.Finish_Configuration_Flag__c == false)
        {
            getPalletTypeOptions();
            getFastenerMaterialOptions();
            getFlameArresterOptions();
            getVacuumPortOptions();
            getPressurePortProximitySensor();
            getVacuumPortProximitySensor();
            getPilotActionOptions();
            getManualBlowdown();
            getRemoteSense();
            getPilotExhaustPipedToDischargeHeader();
            getFieldTestConnection();
            getPilotSupplyFilter();
            getMethod21LeakDetection();
            getRadiographyOptions();
            getFilletWeldLiquidDyePenetrant();
            getUltrasonicExamination();
            getBrinellHardnessExamination();
            getVisualCastingExamination();
        }
        else
        {
            paintingCoatingBoolean = true;
            pressurePortProximitySensor = true;
            vacuumPortProximitySensor = true;
            getFlameArresterOptions();
            getVacuumPortOptions();
        }
		/*if(ApexPages.currentPage().getParameters().get('selectedTab') == 'EngineeringSpecials')
        {
            selectedTab = 'EngineeringSpecials';
            //getTabData();
        }*/ 
        Map<String, String> valueVsDescription = getRVInputAttrValueDesc(conRV);
        if(valueVsDescription.size() > 0)
        {
            
            if(valueVsDescription.containsKey(conRV.Body_Material__c + '_MCBODY'))
            {
                bodyMaterialOptions.add(new selectOption(conRV.Body_Material__c, valueVsDescription.get(conRV.Body_Material__c + '_MCBODY')));
            }
            if(valueVsDescription.containsKey(conRV.Facing__c + '_GPFACE'))
            {
                FacingOptions.add(new selectOption(conRV.Facing__c, valueVsDescription.get(conRV.Facing__c + '_GPFACE')));
            }
            if(valueVsDescription.containsKey(conRV.Seat_Material__c + '_MCSEAT'))
            {
                SeatMaterialOptions.add(new selectOption(conRV.Seat_Material__c, valueVsDescription.get(conRV.Seat_Material__c + '_MCSEAT')));
            }
            if(valueVsDescription.containsKey(conRV.Pressure_Pallet_Material__c + '_MCPALL'))
            {
                PressurePalletMaterialOptions.add(new selectOption(conRV.Pressure_Pallet_Material__c, valueVsDescription.get(conRV.Pressure_Pallet_Material__c + '_MCPALL')));
            }
            if(valueVsDescription.containsKey(conRV.Diaphragm_Material__c + '_MCDPHM'))
            {
                DiaphragmMaterialOptions.add(new selectOption(conRV.Diaphragm_Material__c, valueVsDescription.get(conRV.Diaphragm_Material__c + '_MCDPHM')));
            }
            if(valueVsDescription.containsKey(conRV.Vacuum_Pallet_Material__c + '_MCPALL'))
            {
                vacuumPalletMaterialOptions.add(new selectOption(conRV.Vacuum_Pallet_Material__c, valueVsDescription.get(conRV.Vacuum_Pallet_Material__c + '_MCPALL')));
            }
            if(valueVsDescription.containsKey(conRV.Pilot_Soft_Goods_Material__c + '_MCPSGD'))
            {
                PilotSoftGoodsMaterialOptions.add(new selectOption(conRV.Pilot_Soft_Goods_Material__c, valueVsDescription.get(conRV.Pilot_Soft_Goods_Material__c + '_MCPSGD')));
            }
            if(valueVsDescription.containsKey(conRV.Flame_Arrester_Option__c + '_GOUTOP'))
            {
                flameArresterOptions.add(new selectOption(conRV.Flame_Arrester_Option__c, valueVsDescription.get(conRV.Flame_Arrester_Option__c + '_GOUTOP')));
            }
            if(valueVsDescription.containsKey(conRV.Weight_Material__c + '_MCWGHT'))
            {
                WeightMaterialOptions.add(new selectOption(conRV.Weight_Material__c, valueVsDescription.get(conRV.Weight_Material__c + '_MCWGHT')));
            }
            if(valueVsDescription.containsKey(conRV.Spring_Material__c + '_MCSPRG'))
            {
                SpringMaterialOptions.add(new selectOption(conRV.Spring_Material__c, valueVsDescription.get(conRV.Spring_Material__c + '_MCSPRG')));
            }
            if(valueVsDescription.containsKey(conRV.Steam_Jacket_Material__c + '_MCSTMJ'))
            {
                SteamJacketMaterialOptions.add(new selectOption(conRV.Steam_Jacket_Material__c, valueVsDescription.get(conRV.Steam_Jacket_Material__c + '_MCSTMJ')));
            }
            if(valueVsDescription.containsKey(conRV.Body_Coating_Material__c + '_MCCOTB'))
            {
                BodyCoatingMaterialOptions.add(new selectOption(conRV.Body_Coating_Material__c, valueVsDescription.get(conRV.Body_Coating_Material__c + '_MCCOTB')));
            }
            if(valueVsDescription.containsKey(conRV.Pallet_Fastener_Coating_Material__c + '_MCCOTP'))
            {
                PalletFastenerCoatingMaterialOptions.add(new selectOption(conRV.Pallet_Fastener_Coating_Material__c, valueVsDescription.get(conRV.Pallet_Fastener_Coating_Material__c + '_MCCOTP')));
            }
            if(valueVsDescription.containsKey(conRV.Element_Material__c + '_MCELMT'))
            {
                ElementMaterialOptions.add(new selectOption(conRV.Element_Material__c, valueVsDescription.get(conRV.Element_Material__c + '_MCELMT')));
            }
            System.debug('--> '+conRV.Vacuum_Port_Option__c );
            if(valueVsDescription.containsKey(conRV.Vacuum_Port_Option__c + '_VPRTOP'))
            {
                VacuumPortOptions.add(new selectOption(conRV.Vacuum_Port_Option__c, valueVsDescription.get(conRV.Vacuum_Port_Option__c + '_VPRTOP')));
            }
            if(valueVsDescription.containsKey(conRV.Positive_Material_Identification__c + '_PMI'))
            {
                PositiveMaterialIdentificationOptions.add(new selectOption(conRV.Positive_Material_Identification__c, valueVsDescription.get(conRV.Positive_Material_Identification__c + '_PMI')));
            }
            if(valueVsDescription.containsKey(conRV.Liquid_Dye_Penetrant__c + '_LDP'))
            {
                LiquidDyePenetrantOptions.add(new selectOption(conRV.Liquid_Dye_Penetrant__c, valueVsDescription.get(conRV.Liquid_Dye_Penetrant__c + '_LDP')));
            }
            
            /****************Setting the values on load and checking for attribute None******************************/
            
            if(String.isNotBlank(ConRV.Body_Material__c ) && null != ConRV.Body_Material__c && (ConRV.Body_Material__c != 'N' || (valueVsDescription.get(conRV.Body_Material__c + '_MCBODY') == 'None')))
            bodyMaterialBoolean = true;

            if(String.isNotBlank(ConRV.Facing__c ) && null != ConRV.Facing__c && ConRV.Facing__c != 'N')
            {
                facingBoolean = true;
            }
            
            if(String.isNotBlank(ConRV.Seat_Material__c ) && null != ConRV.Seat_Material__c && ConRV.Seat_Material__c != 'N')
                seatMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Pressure_Pallet_Material__c ) && null != ConRV.Pressure_Pallet_Material__c && ConRV.Pressure_Pallet_Material__c != 'N')
                pressurePalletMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Diaphragm_Material__c ) && null != ConRV.Diaphragm_Material__c && ConRV.Diaphragm_Material__c != 'N')
                diaphragmMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Vacuum_Pallet_Material__c ) && null != ConRV.Vacuum_Pallet_Material__c && ConRV.Vacuum_Pallet_Material__c != 'N')
                vacuumPalletMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Pilot_Soft_Goods_Material__c ) && null != ConRV.Pilot_Soft_Goods_Material__c && ConRV.Pilot_Soft_Goods_Material__c != 'N')
                pilotSoftGoodsMaterialBoolean = true;
            
             if(String.isNotBlank(ConRV.Flame_Arrester_Option__c ) && null != ConRV.Flame_Arrester_Option__c && ConRV.Flame_Arrester_Option__c != '000')
                flameArresterBoolean = true;
            //if(ConRV.Finish_Configuration_Flag__c)flameArresterBoolean = false;
            if(String.isNotBlank(ConRV.Weight_Material__c ) && null != ConRV.Weight_Material__c && ConRV.Weight_Material__c != 'N')
                weightMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Spring_Material__c ) && null != ConRV.Spring_Material__c && ConRV.Spring_Material__c != 'N')
                springMaterialBoolean = true;
    
            System.debug('VVVConstructor display Flag show Flag' +conRV.SteamJacket_Display_Flag__c);
            System.debug('VVVConstructor display Flag' +ConRV.Steam_Jacket_Material__c);
            if(String.isNotBlank(ConRV.Steam_Jacket_Material__c ) && null != ConRV.Steam_Jacket_Material__c && conRV.SteamJacket_Display_Flag__c == true)
                steamJacketMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Body_Coating_Material__c ) && null != ConRV.Body_Coating_Material__c && ConRV.Body_Coating_Material__c != 'N')
                bodyCoatingMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Pallet_Fastener_Coating_Material__c ) && null != ConRV.Pallet_Fastener_Coating_Material__c && ConRV.Pallet_Fastener_Coating_Material__c != 'N')
                palletFastenerCoatingMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Element_Material__c ) && null != ConRV.Element_Material__c && ConRV.Element_Material__c != 'N')
                elementMaterialBoolean = true;
    
            if(String.isNotBlank(ConRV.Vacuum_Port_Option__c ) && null != ConRV.Vacuum_Port_Option__c && ConRV.Vacuum_Port_Option__c != '0')
                vacuumPortBoolean = true;
            //if(ConRV.Finish_Configuration_Flag__c)vacuumPortBoolean = false;    
            if(String.isNotBlank(ConRV.Liquid_Dye_Penetrant__c ) && null != ConRV.Liquid_Dye_Penetrant__c && ConRV.Liquid_Dye_Penetrant__c != 'N')
                liquidDyePenetrantBoolean = true;

        }
    }
    
    //Reorder Code Ends here
    
    
    

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
            return new List<String>{'Pending Approvals','Approved','Order Submitted'};
        }
        set {
            this.notValidStatusForChng=value;
        }
    }
    public Map<String,String> getRVInputAttrValueDesc(Relief_Valve__c conRV)
    {
        Map<String, String> valueVsDescription = new Map<String, String>();
        Set<string> AttrCode = new Set<String>();
        if(String.isNotBlank(conRV.Body_Material__c))
        {
            valueVsDescription.put(conRV.Body_Material__c,'');
            AttrCode.add('MCBODY');
        }
        if(String.isNotBlank(conRV.Facing__c))
        {
            valueVsDescription.put(conRV.Facing__c,'');
            AttrCode.add('GPFACE');
        }
        if(String.isNotBlank(conRV.Seat_Material__c))
        {
            valueVsDescription.put(conRV.Seat_Material__c,'');
            AttrCode.add('MCSEAT');
        }
        if(String.isNotBlank(conRV.Pressure_Pallet_Material__c))
        {
            valueVsDescription.put(conRV.Pressure_Pallet_Material__c,'');
            AttrCode.add('MCPALL');
        }
        if(String.isNotBlank(conRV.Diaphragm_Material__c))
        {
            valueVsDescription.put(conRV.Diaphragm_Material__c,'');
            AttrCode.add('MCDPHM');
        }
        if(String.isNotBlank(conRV.Vacuum_Pallet_Material__c))
        {
            valueVsDescription.put(conRV.Vacuum_Pallet_Material__c,'');
            AttrCode.add('MCPALL');
        }
        if(String.isNotBlank(conRV.Pilot_Soft_Goods_Material__c))
        {
            valueVsDescription.put(conRV.Pilot_Soft_Goods_Material__c,'');
            AttrCode.add('MCPSGD');
        }
         if(String.isNotBlank(conRV.Flame_Arrester_Option__c))
        {
            valueVsDescription.put(conRV.Flame_Arrester_Option__c,'');
            AttrCode.add('GOUTOP');
        }
        if(String.isNotBlank(conRV.Weight_Material__c))
        {
            valueVsDescription.put(conRV.Weight_Material__c,'');
            AttrCode.add('MCWGHT');
        }
        if(String.isNotBlank(conRV.Spring_Material__c))
        {
            valueVsDescription.put(conRV.Spring_Material__c,'');
            AttrCode.add('MCSPRG');
        }
        if(String.isNotBlank(conRV.Steam_Jacket_Material__c))
        {
            valueVsDescription.put(conRV.Steam_Jacket_Material__c,'');
            AttrCode.add('MCSTMJ');
        }
        if(String.isNotBlank(conRV.Body_Coating_Material__c))
        {
            valueVsDescription.put(conRV.Body_Coating_Material__c,'');
            AttrCode.add('MCCOTB');
        }
        if(String.isNotBlank(conRV.Pallet_Fastener_Coating_Material__c))
        {
            valueVsDescription.put(conRV.Pallet_Fastener_Coating_Material__c,'');
            AttrCode.add('MCCOTP');
        }
        if(String.isNotBlank(conRV.Element_Material__c))
        {
            valueVsDescription.put(conRV.Element_Material__c,'');
            AttrCode.add('MCELMT');
        }
        if(String.isNotBlank(conRV.Vacuum_Port_Option__c))
        {
            valueVsDescription.put(conRV.Vacuum_Port_Option__c,'');
            AttrCode.add('VPRTOP');
        }
        if(String.isNotBlank(conRV.Positive_Material_Identification__c))
        {
            valueVsDescription.put(conRV.Positive_Material_Identification__c,'');
            AttrCode.add('PMI');
        }
        if(String.isNotBlank(conRV.Liquid_Dye_Penetrant__c))
        {
            valueVsDescription.put(conRV.Liquid_Dye_Penetrant__c,'');
            AttrCode.add('LDP');
        }
        if(String.isNotBlank(conRV.Pallet_Type__c))
        {
            valueVsDescription.put(conRV.Pallet_Type__c,'');
            AttrCode.add('GPTYPE');
        }
         if(String.isNotBlank(conRV.Pilot_Action__c))
        {
            valueVsDescription.put(conRV.Pilot_Action__c,'');
            AttrCode.add('GPACT');
        }
        if(valueVsDescription.size() > 0)
        {
            for(RV_Input_Attr_Value_Desc__c rv : [SELECT ID, Text_Description_of_AttributeValue__c,Attribute__c, Value__c FROM RV_Input_Attr_Value_Desc__c WHERE Value__c IN:valueVsDescription.keyset() and Attribute__c IN: AttrCode])
            {
                valueVsDescription.put(rv.Value__c + '_' + rv.Attribute__c,rv.Text_Description_of_AttributeValue__c);
            }
        }
        return valueVsDescription;
    }
    public pageReference getTabData()
    {
        
        if(ConRV.Finish_Configuration_Flag__c == true)
        {
            System.debug('*** selectedTab = '+selectedTab);
            if(selectedTab == 'ProductReview')
            {
                getPricingRecords();
                getLeadTimeRecords();
                GetQuoteDescriptionRecords();
            }
            else if(selectedTab == 'Pricing')
            {
                getPricingRecords();
                getLeadTimeRecords();
                GetQuoteDescriptionRecords();
                getCosts();
            }
            else if(selectedTab == 'EngineeringSpecials') {
                GetQuoteDescriptionRecords();
            }
            else if(selectedTab == 'Engineering')
            {
                getStructureDetails();
                getControlPlanDetails();
                getWorkGuideLines();
                getDocument();
                getRouter();
                getIFSAttributes();
                getTroubleshootingAttributes();
            }
            else if(selectedTab == 'TroubleShoot')
            {
                getStructureDetails(); // added for issue 4016
                getTroubleshootingAttributes();
            }
        }

        return null;
    }
     /* This method is to Narrow down the Drilling values */
    public void getdrillingOptions()
    {
        drillingOption.clear();
        drillingBoolean = true;
        if(ConRV.EFFMop__c != null  )
        {
            Decimal EFFMop = ConRV.EFFMop__c.setscale(4);

            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'RV_HCLASS_Cons__c','RV_Input_Attr_Value_Desc__c'}));
            parameters.put('RV_HCLASS_Cons__c_selectedFields', 'HCLASS__c');
            parameters.put('RV_HCLASS_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \'' +ConRV.Size__c+'\' AND MAWP__c >= '+EFFMop);

            parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'HCLASS\'');
            parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_HCLASS_Cons__c-HCLASS__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_HCLASS_Cons__c-HCLASS__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                if(inputAttrValue.size() == 1){
                    drillingOption.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Drilling__c = inputAttrValue[0].Value__c;
                    getbodyMaterialOptions();
                }
                else{
                    drillingOption.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        drillingOption.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                drillingBoolean = false;
                drillingOption.add(new selectOption('N','N'));
                ConRV.Drilling__c = 'N';

                getbodyMaterialOptions();
            }
        }
    }

    public void getbodyMaterialOptions()
    {
        system.debug('ConRV.Drilling__c'+conRV.Drilling__c);
        bodyMaterialOptions.clear();
        bodyMaterialBoolean = false;

        if(String.isNotBlank(conRV.Drilling__c ))
        {
            Decimal EFFMop = ConRV.EFFMop__c.setscale(4);
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'RV_MCBODY_N_Cons__c','RV_MCBODY_H_Cons__c','RV_MCBODY_PS_Cons__c','RV_Input_Attr_Value_Desc__c'}));

            parameters.put('RV_MCBODY_N_Cons__c_selectedFields', 'MCBODY__c');
            parameters.put('RV_MCBODY_N_Cons__c_whereClause', 'NACE__c = \''+ConRV.Nace_Backend__c+'\'');

            parameters.put('RV_MCBODY_H_Cons__c_selectedFields', 'MCBODY__c');
            parameters.put('RV_MCBODY_H_Cons__c_whereClause', 'HCLASS__c = \''+ConRV.Drilling__c+'\'');

            parameters.put('RV_MCBODY_PS_Cons__c_selectedFields', 'MCBODY__c');
            parameters.put('RV_MCBODY_PS_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND ATEX__c = \''+ConRV.Atex_bkend__c+'\' AND MAWP__c >= '+EFFMop);

            parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCBODY\'');

            parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCBODY_N_Cons__c-MCBODY__c,RV_MCBODY_H_Cons__c-MCBODY__c,RV_MCBODY_PS_Cons__c-MCBODY__c');

            parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCBODY_N_Cons__c-MCBODY__c&&Value__c = RV_MCBODY_H_Cons__c-MCBODY__c&&Value__c = RV_MCBODY_PS_Cons__c-MCBODY__c');

            parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                bodyMaterialBoolean = true;
                if(inputAttrValue.size() == 1)
                {
                    bodyMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Body_Material__c = inputAttrValue[0].Value__c;
                    getOnChangeBodyMaterial();

                }
                else
                {
                    bodyMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        bodyMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                    facingOptions.clear();

                    seatMaterialOptions.clear();
                    pressurePalletMaterialOptions.clear();
                    weightMaterialOptions.clear();
                    positiveMaterialIdentificationOptions.clear();
                    vacuumPalletMaterialOptions.clear();
                    springMaterialOptions.clear();
                    steamJacketMaterialOptions.clear();
                    elementMaterialOptions.clear();
                    liquidDyePenetrantOptions.clear();

                    facingBoolean = false;
                    seatMaterialBoolean = false;
                    pressurePalletMaterialBoolean = false;
                    weightMaterialBoolean = false;
                    vacuumPalletMaterialBoolean = false;
                    springMaterialBoolean = false;
                    steamJacketMaterialBoolean = false;
                    conRV.SteamJacket_Display_Flag__c=false;
                    elementMaterialBoolean = false;
                    liquidDyePenetrantBoolean = false;

                    magneticParticleExamination = false;
                    charpyImpactTesting = false;
                    visualCastingExamination = false;
                    intergranularCorrosionTest = false;
                }

            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Body Material: No valid choice is available with your previous choices, please revise your configuration'));
                bodyMaterialOptions.add(new selectOption('N','N'));
                ConRV.Body_Material__c = 'N';
                getOnChangeBodyMaterial();
            }
        }
        else{
            ConRV.Body_Material__c = 'N';
            getOnChangeBodyMaterial();
        }
        if(conRV.Positive_Material_Identification__c == 'N')
        {
            PositiveMaterialIdentificationOptions.add(new selectOption('N','N'));
        }
    }

    public void getOnChangeBodyMaterial(){
        getFacingOptions();
        getSeatMaterialOptions();
        getSpringMaterialOptions();
        getSteamJacketMaterialOptions();
        getElementMaterialOptions();
        getLiquidDyePenetrantOptions();
        getMagneticParticleExamination();
        getCharpyImpactTesting();
        getVisualCastingExamination();
        getIntergranularCorrosionTest();
    }

    public void getFacingOptions()
    {

        facingOptions.clear();
        facingBoolean = false;
        ConRV.Facing__c = null;
        system.debug('ConRV.Body_Material__c'+ConRV.Body_Material__c);
        if(String.isNotBlank(ConRV.Body_Material__c) && null != ConRV.Body_Material__c){
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'RV_GPFACE_Cons__c','RV_Input_Attr_Value_Desc__c'}));

            parameters.put('RV_GPFACE_Cons__c_selectedFields', 'GPFACE__c');
            parameters.put('RV_GPFACE_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCBODY__c = \''+ConRV.Body_Material__c+'\'');

            parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'GPFACE\'');
            parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_GPFACE_Cons__c-GPFACE__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_GPFACE_Cons__c-GPFACE__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                facingBoolean = true;
                if(inputAttrValue.size() == 1){
                    facingOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Facing__c = inputAttrValue[0].Value__c;
                }
                else{
                    facingOptions.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        facingOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                facingOptions.add(new selectOption('N','N'));
                ConRV.Facing__c = 'N';
            }
        }
        else{
            ConRV.Facing__c = 'N';
        }
    }

    public void getSeatMaterialOptions()
    {
        seatMaterialOptions.clear();
        seatMaterialBoolean = false;
        ConRV.Seat_Material__c = null;
        if(String.isNotBlank(ConRV.Body_Material__c) && null != ConRV.Body_Material__c){
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'RV_MCSEAT_Cons__c','RV_Input_Attr_Value_Desc__c'}));

            parameters.put('RV_MCSEAT_Cons__c_selectedFields', 'MCSEAT__c');
            parameters.put('RV_MCSEAT_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCBODY__c = \''+ConRV.Body_Material__c+'\'');

            parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCSEAT\'');
            parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCSEAT_Cons__c-MCSEAT__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCSEAT_Cons__c-MCSEAT__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);

            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                seatMaterialBoolean = true;
                if(inputAttrValue.size() == 1){
                    seatMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Seat_Material__c = inputAttrValue[0].Value__c;
                    getOnChangeSeatMaterial();
                }
                else{
                    seatMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        seatMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                    pressurePalletMaterialOptions.clear();
                    vacuumPalletMaterialOptions.clear();
                    weightMaterialOptions.clear();
                    positiveMaterialIdentificationOptions.clear();
                    pressurePalletMaterialBoolean = false;
                    weightMaterialBoolean = false;
                    vacuumPalletMaterialBoolean = false;
                }
            }
            else
            {
                seatMaterialOptions.add(new selectOption('N','N'));
                ConRV.Seat_Material__c = 'N';
                getOnChangeSeatMaterial();
            }
        }
        else{
            ConRV.Seat_Material__c = 'N';
            getOnChangeSeatMaterial();
        }
    }

    public void getOnChangeSeatMaterial(){

        getPressurePalletMaterialOptions();
        getVacuumPalletMaterialOptions();
    }

    public void getPressurePalletMaterialOptions()
    {
        pressurePalletMaterialOptions.clear();
        pressurePalletMaterialBoolean = false;
        ConRV.Pressure_Pallet_Material__c = null;
        Decimal EFFmbp = 0.0 ;
        Decimal PosSetPresOSIG = 1.0;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCPALL_Cons__c','RV_PosSettingLimits__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCPALL_Cons__c_selectedFields', 'MCPALL__c');
        parameters.put('RV_MCPALL_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCBODY__c = \''+ConRV.Body_Material__c+'\' AND MCSEAT__c = \''+ConRV.Seat_Material__c+ '\' AND NACE__c = \''+ConRV.Nace_Backend__c+'\'');

        parameters.put('RV_PosSettingLimits__c_selectedFields', 'PalletMatlCode__c');
        parameters.put('RV_PosSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND BackpressureLL__c < '+ConRV.EFFmbp__c+' AND BackpressureUL__c >= '+ConRV.EFFmbp__c+' AND SettingLL__c < '+ConRV.PosSetPresOSIG__c+'AND SettingUL__c >= '+ConRV.PosSetPresOSIG__c);

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCPALL\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCPALL_Cons__c-MCPALL__c,RV_PosSettingLimits__c-PalletMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCPALL_Cons__c-MCPALL__c&&Value__c = RV_PosSettingLimits__c-PalletMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            pressurePalletMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                pressurePalletMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Pressure_Pallet_Material__c = inputAttrValue[0].Value__c;
                getWeightMaterialOptions();
                getPositiveMaterialIdentificationOptions();
            }
            else{
                pressurePalletMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    pressurePalletMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
                weightMaterialOptions.clear();
                positiveMaterialIdentificationOptions.clear();
                weightMaterialBoolean = false;
            }
        }
        else
        {
            pressurePalletMaterialOptions.add(new selectOption('N','N'));
            ConRV.Pressure_Pallet_Material__c = 'N';
            getWeightMaterialOptions();
            getPositiveMaterialIdentificationOptions();
        }
    }

    public void getOnChangePressurePalletMaterial(){
        getWeightMaterialOptions();
        getPositiveMaterialIdentificationOptions();
    }

    public void getPalletTypeOptions()
    {
        palletTypeOptions.clear();
        palletTypeBoolean = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_GPTYPE_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_GPTYPE_Cons__c_selectedFields', 'GPTYPE__c');
        parameters.put('RV_GPTYPE_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'GPTYPE\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_GPTYPE_Cons__c-GPTYPE__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_GPTYPE_Cons__c-GPTYPE__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            palletTypeBoolean = true;
            if(inputAttrValue.size() == 1){
                palletTypeOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Pallet_Type__c = inputAttrValue[0].Value__c;
                getDiaphragmMaterialOptions();
            }
            else{
                palletTypeOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    palletTypeOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
                diaphragmMaterialOptions.clear();
                    pilotSoftGoodsMaterialOptions.clear();
            }
        }
        else
        {
            palletTypeOptions.add(new selectOption('N','N'));
            ConRV.Pallet_Type__c = 'N';
            getDiaphragmMaterialOptions();
        }
    }

    public void getDiaphragmMaterialOptions()
    {
        diaphragmMaterialOptions.clear();
        diaphragmMaterialBoolean = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCDPHM_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCDPHM_Cons__c_selectedFields', 'MCDPHM__c');
        parameters.put('RV_MCDPHM_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND '+(ConRV.Pallet_Type__c == 'N' ? ' GPTYPE__c = Null ' : 'GPTYPE__c = \''+ConRV.Pallet_Type__c+'\''));

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCDPHM\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCDPHM_Cons__c-MCDPHM__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCDPHM_Cons__c-MCDPHM__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            diaphragmMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                diaphragmMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Diaphragm_Material__c = inputAttrValue[0].Value__c;
                getPilotSoftGoodsMaterialOptions();
            }
            else{
                diaphragmMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    diaphragmMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
                pilotSoftGoodsMaterialOptions.clear();
            }
        }
        else
        {
            diaphragmMaterialOptions.add(new selectOption('N','N'));
            ConRV.Diaphragm_Material__c = 'N';
            getPilotSoftGoodsMaterialOptions();
        }
    }

    public void getOnChangeVacuumPalletMaterial(){
        getWeightMaterialOptions();
        getPositiveMaterialIdentificationOptions();
    }

    public void getVacuumPalletMaterialOptions()
    {
        vacuumPalletMaterialOptions.clear();
        vacuumPalletMaterialBoolean = false;
        ConRV.Vacuum_Pallet_Material__c = null;
        // Decimal VacSetPresOSIG = conRV.VacSetPresOSIG__c.setscale(4);
        Decimal VacSetPresOSIG = conRV.VacSetPresOSIG__c;
        // Decimal EFFMop = ConRV.EFFMop__c.setscale(4);
        Decimal EFFMop = ConRV.EFFMop__c;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCPALL_Cons__c','RV_VacSettingLimits__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCPALL_Cons__c_selectedFields', 'MCPALL__c');
        parameters.put('RV_MCPALL_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCBODY__c = \''+ConRV.Body_Material__c+'\' AND MCSEAT__c = \''+ConRV.Seat_Material__c+ '\' AND NACE__c = \''+ConRV.Nace_Backend__c+'\'');

        parameters.put('RV_VacSettingLimits__c_selectedFields', 'PalletMatlCode__c');
        parameters.put('RV_VacSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND BackpressureLL__c < '+EFFMop+' AND BackpressureUL__c >= '+EFFMop+' AND SettingLL__c < '+VacSetPresOSIG+'AND SettingUL__c >= '+VacSetPresOSIG);

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCPALL\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCPALL_Cons__c-MCPALL__c,RV_VacSettingLimits__c-PalletMatlCode__c');

        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCPALL_Cons__c-MCPALL__c&&Value__c = RV_VacSettingLimits__c-PalletMatlCode__c');
        
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            vacuumPalletMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                vacuumPalletMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Vacuum_Pallet_Material__c = inputAttrValue[0].Value__c;
                getWeightMaterialOptions();
                getPositiveMaterialIdentificationOptions();

            }
            else{
                vacuumPalletMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    vacuumPalletMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
                positiveMaterialIdentificationOptions.clear();
                weightMaterialOptions.clear();
                weightMaterialBoolean = false;
            }
        }
        else
        {
            vacuumPalletMaterialOptions.add(new selectOption('N','N'));
            ConRV.Vacuum_Pallet_Material__c = 'N';
            getWeightMaterialOptions();
            getPositiveMaterialIdentificationOptions();
        }
    }

    public void getPilotSoftGoodsMaterialOptions()
    {
        pilotSoftGoodsMaterialOptions.clear();
        pilotSoftGoodsMaterialBoolean = false;
        ConRV.Pilot_Soft_Goods_Material__c = null;

        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCPSGD_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCPSGD_Cons__c_selectedFields', 'MCPSGD__c');
        parameters.put('RV_MCPSGD_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCDPHM__c = \''+ConRV.Diaphragm_Material__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCPSGD\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCPSGD_Cons__c-MCPSGD__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCPSGD_Cons__c-MCPSGD__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            pilotSoftGoodsMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                pilotSoftGoodsMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Pilot_Soft_Goods_Material__c = inputAttrValue[0].Value__c;
            }
            else{
                pilotSoftGoodsMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    pilotSoftGoodsMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }


        }
        else
        {
            pilotSoftGoodsMaterialOptions.add(new selectOption('N','N'));
            ConRV.Pilot_Soft_Goods_Material__c = 'N';
        }
    }

    public void getWeightMaterialOptions()
    {
        weightMaterialOptions.clear();
        weightMaterialBoolean = false;
        ConRV.Weight_Material__c = null;
        Decimal EFFMop = ConRV.EFFMop__c.setscale(4);
        Map<String, Object> parameters = new Map<String, Object>();
        //string PosLoad = 'W',VacLoad = 'W';
        List<RV_Master_Blaster__c> rvMaster = [SELECT ID, PosLoad__c, VacLoad__c FROM RV_Master_Blaster__c WHERE PTC__c = :ConRV.Model_name__c AND SZC__c = :ConRV.Size__c LIMIT 1];
       if(!Test.isRunningTest())
       {
       if((rvMaster[0].PosLoad__c == 'W' || rvMaster[0].PosLoad__c == 'F' || rvMaster[0].PosLoad__c == 'D') && (rvMaster[0].VacLoad__c == 'W'  || rvMaster[0].VacLoad__c == 'F' || rvMaster[0].VacLoad__c == 'D')){
        parameters.put('sObjects',(new List<String>{'RV_VacSettingLimits__c','RV_PosSettingLimits__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_VacSettingLimits__c_selectedFields', 'WeightMatlCode__c');
        parameters.put('RV_VacSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND BackpressureLL__c < '+EFFMop+' AND BackpressureUL__c >= '+EFFMop+' AND SettingLL__c < '+ConRV.VacSetPresOSIG__c+' AND SettingUL__c >= '+ConRV.VacSetPresOSIG__c+' AND PalletMatlCode__c =\''+ConRV.Vacuum_Pallet_Material__c+'\'');

        parameters.put('RV_PosSettingLimits__c_selectedFields', 'WeightMatlCode__c');
        parameters.put('RV_PosSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND BackpressureLL__c < '+ConRV.EFFMBP__c+' AND BackpressureUL__c >= '+ConRV.EFFMBP__c+' AND SettingLL__c < '+ConRV.PosSetPresOSIG__c+' AND SettingUL__c >= '+ConRV.PosSetPresOSIG__c+' AND PalletMatlCode__c =\''+ConRV.Pressure_Pallet_Material__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCWGHT\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_VacSettingLimits__c-WeightMatlCode__c,RV_PosSettingLimits__c-WeightMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_VacSettingLimits__c-WeightMatlCode__c&&Value__c = RV_PosSettingLimits__c-WeightMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');
       }
       else if((rvMaster[0].PosLoad__c == 'W' || rvMaster[0].PosLoad__c == 'F' || rvMaster[0].PosLoad__c == 'D') && !(rvMaster[0].VacLoad__c == 'W'  || rvMaster[0].VacLoad__c == 'F' || rvMaster[0].VacLoad__c == 'D')){
        parameters.put('sObjects',(new List<String>{'RV_PosSettingLimits__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_PosSettingLimits__c_selectedFields', 'WeightMatlCode__c');
        parameters.put('RV_PosSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND BackpressureLL__c < '+ConRV.EFFMBP__c+' AND BackpressureUL__c >= '+ConRV.EFFMBP__c+' AND SettingLL__c < '+ConRV.PosSetPresOSIG__c+' AND SettingUL__c >= '+ConRV.PosSetPresOSIG__c+' AND PalletMatlCode__c =\''+ConRV.Pressure_Pallet_Material__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCWGHT\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_PosSettingLimits__c-WeightMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_PosSettingLimits__c-WeightMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');
       }
       else if(!(rvMaster[0].PosLoad__c == 'W' || rvMaster[0].PosLoad__c == 'F' || rvMaster[0].PosLoad__c == 'D') && (rvMaster[0].VacLoad__c == 'W'  || rvMaster[0].VacLoad__c == 'F' || rvMaster[0].VacLoad__c == 'D')){
        parameters.put('sObjects',(new List<String>{'RV_VacSettingLimits__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_VacSettingLimits__c_selectedFields', 'WeightMatlCode__c');
        parameters.put('RV_VacSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND BackpressureLL__c < '+EFFMop+' AND BackpressureUL__c >= '+EFFMop+' AND SettingLL__c < '+ConRV.VacSetPresOSIG__c+' AND SettingUL__c >= '+ConRV.VacSetPresOSIG__c+' AND PalletMatlCode__c =\''+ConRV.Vacuum_Pallet_Material__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCWGHT\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_VacSettingLimits__c-WeightMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_VacSettingLimits__c-WeightMatlCode__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');
       }
       }

        if(parameters.size() > 0){

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                weightMaterialBoolean = true;
                if(inputAttrValue.size() == 1){
                    weightMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Weight_Material__c = inputAttrValue[0].Value__c;
                }
                else{
                    weightMaterialOptions.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        weightMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                weightMaterialOptions.add(new selectOption('N','N'));
                ConRV.Weight_Material__c = 'N';
            }
        }
        else{
            weightMaterialOptions.add(new selectOption('N','N'));
            ConRV.Weight_Material__c = 'N';
        }
    }

    public void getSpringMaterialOptions()
    {
        springMaterialOptions.clear();
        springMaterialBoolean = false;
        conRV.Spring_Material__c = null;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCSPRG_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCSPRG_Cons__c_selectedFields', 'MCSPRG__c');
        //Abhishek Comment Nace is checkbox is RV and Text in RV_MCSPRG_Cons__c
        parameters.put('RV_MCSPRG_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCBODY__c = \''+ConRV.Body_Material__c+'\' AND NACE__c = \''+conRV.Nace_Backend__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCSPRG\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCSPRG_Cons__c-MCSPRG__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCSPRG_Cons__c-MCSPRG__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            springMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                springMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                conRV.Spring_Material__c = inputAttrValue[0].Value__c;
            }
            else{
                springMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    springMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }
        }
        else
        {
            springMaterialOptions.add(new selectOption('N','N'));
            conRV.Spring_Material__c = 'N';
        }
    }

    public void getFastenerMaterialOptions()
    {
        fastenerMaterialOptions.clear();
        fastenerMaterialBoolean = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCFAST_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCFAST_Cons__c_selectedFields', 'MCFAST__c');
        parameters.put('RV_MCFAST_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCFAST\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCFAST_Cons__c-MCFAST__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCFAST_Cons__c-MCFAST__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            fastenerMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                fastenerMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Fastener_Material__c = inputAttrValue[0].Value__c;
            }
            else{
                fastenerMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    fastenerMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }
        }
        else
        {
            fastenerMaterialOptions.add(new selectOption('N','N'));
            ConRV.Fastener_Material__c = 'N';
        }
    }

    //Abhishek Comment MCSTMJ misspelled? RV_MCSJMT_Cons__c is the object name
    public void getSteamJacketMaterialOptions()
    {
        steamJacketMaterialOptions.clear();
        steamJacketMaterialBoolean = false;
      //  ShowsteamJacketMaterialBoolean = true;
        system.debug('&&&VVV Steam method Enter = ');
        ConRV.Steam_Jacket_Material__c = null;
        //steamJacketMaterialOptions.add(new selectOption('',''));
        //system.debug('&&& ConRV.Body_Material__c = '+ConRV.Body_Material__c);
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCSJMT_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_MCSJMT_Cons__c_selectedFields', 'MCSTMJ__c');
        //Abhishek Comment PED_2014_68_EU_CE_mark__c is checkbox is RV and Text in RV_MCSPRG_Cons__c
        parameters.put('RV_MCSJMT_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MCBODY__c = \''+ConRV.Body_Material__c+'\' AND PED__c = \''+ConRV.PED_bkend__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCSTMJ\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCSJMT_Cons__c-MCSTMJ__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCSJMT_Cons__c-MCSTMJ__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {            
            steamJacketMaterialBoolean = true;
            conRV.SteamJacket_Display_Flag__c = true;
            if(inputAttrValue.size() == 1){
                steamJacketMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Steam_Jacket_Material__c = inputAttrValue[0].Value__c;
                if(ConRV.Steam_Jacket_Material__c == '0'){
                    steamJacketMaterialBoolean = false;
                }
            }
            else{
                steamJacketMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    steamJacketMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }
			system.debug('&&&VVV Steam method Enter values block = ' +steamJacketMaterialBoolean);
        }
        else
        {
            steamJacketMaterialOptions.add(new selectOption('0','0'));
            ConRV.Steam_Jacket_Material__c = '0';
            conRV.SteamJacket_Display_Flag__c=false;
            system.debug('&&&VVV Steam method Enter else block = ' +steamJacketMaterialBoolean);
        }
      system.debug('&&&VVV Steam method Flag final value = ' +steamJacketMaterialBoolean);
      system.debug('&&&VVV Steam method Flag final value display flag = ' +ShowsteamJacketMaterialBoolean);
    }

    public void getPaintingCoatingOptions()
    {
        paintingCoatingOptions.clear();
        paintingCoatingBoolean = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_GPAINT_Cons__c','RV_Input_Attr_Value_Desc__c'}));
        //Abhishek Comment GPTYPE is the correct field?
        parameters.put('RV_GPAINT_Cons__c_selectedFields', 'GPTYPE__c');
        parameters.put('RV_GPAINT_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'GPAINT\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_GPAINT_Cons__c-GPTYPE__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_GPAINT_Cons__c-GPTYPE__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);

        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            paintingCoatingBoolean = true;
            if(inputAttrValue.size() == 1){
                paintingCoatingOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Painting_Coating_Option__c = inputAttrValue[0].Value__c;
                if(ConRV.Painting_Coating_Option__c == '0'){
                    paintingCoatingBoolean = false;
                }
                getBodyCoatingMaterialOptions();
            }
            else{
                paintingCoatingOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    paintingCoatingOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
                bodyCoatingMaterialOptions.clear();
                    palletFastenerCoatingMaterialOptions.clear();
            }
        }
        else
        {
            paintingCoatingOptions.add(new selectOption('0','0'));
            ConRV.Painting_Coating_Option__c = '0';
            getBodyCoatingMaterialOptions();
        }
    }

    public void getBodyCoatingMaterialOptions()
    {
        bodyCoatingMaterialOptions.clear();
        ConRV.Body_Coating_Material__c = null;
        bodyCoatingMaterialBoolean = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCCOTB_Cons__c','RV_Input_Attr_Value_Desc__c'}));
        parameters.put('RV_MCCOTB_Cons__c_selectedFields', 'MCCOTB__c');
        parameters.put('RV_MCCOTB_Cons__c_whereClause', 'GPAINT__c = \''+ConRV.Painting_Coating_Option__c+'\' ');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCCOTB\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCCOTB_Cons__c-MCCOTB__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCCOTB_Cons__c-MCCOTB__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            bodyCoatingMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                bodyCoatingMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Body_Coating_Material__c = inputAttrValue[0].Value__c;
                getPalletFastenerCoatingMaterialOptions();
            }
            else{
                bodyCoatingMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    bodyCoatingMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
                palletFastenerCoatingMaterialOptions.clear();
            }
        }
        else
        {
            bodyCoatingMaterialOptions.add(new selectOption('N','N'));
            ConRV.Body_Coating_Material__c = 'N';
            getPalletFastenerCoatingMaterialOptions();
        }
    }


    public void getPalletFastenerCoatingMaterialOptions()
    {
        palletFastenerCoatingMaterialOptions.clear();
        palletFastenerCoatingMaterialBoolean = false;
        ConRV.Pallet_Fastener_Coating_Material__c = null;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_MCCOTB_Cons__c','RV_Input_Attr_Value_Desc__c'}));
        parameters.put('RV_MCCOTB_Cons__c_selectedFields', 'MCCOTP__c');
        parameters.put('RV_MCCOTB_Cons__c_whereClause', 'GPAINT__c = \''+ConRV.Painting_Coating_Option__c+'\' AND MCCOTB__c = \''+ConRV.Body_Coating_Material__c+'\'');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCCOTP\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCCOTB_Cons__c-MCCOTP__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCCOTB_Cons__c-MCCOTP__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            palletFastenerCoatingMaterialBoolean = true;
            if(inputAttrValue.size() == 1){
                palletFastenerCoatingMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Pallet_Fastener_Coating_Material__c = inputAttrValue[0].Value__c;
            }
            else{
                palletFastenerCoatingMaterialOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    palletFastenerCoatingMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }
        }
        else
        {
            palletFastenerCoatingMaterialOptions.add(new selectOption('N','N'));
            ConRV.Pallet_Fastener_Coating_Material__c = 'N';
        }
    }

    public void getElementMaterialOptions()
    {
        elementMaterialOptions.clear();
        elementMaterialBoolean = false;
        ConRV.Element_Material__c = null;
        
        List<RV_Valve_Attributes_Details__c> valeAttr = [Select Text__c from RV_Valve_Attributes_Details__c where  Attribute__c='FASubModel' AND Text1Val__c = :conRV.Model_name__c LIMIT 1];
        if(!valeAttr.isEmpty() && valeAttr.size() >0)
        {
            if(valeAttr[0].Text__c != 'N'){
                Map<String, Object> parameters = new Map<String, Object>();
                parameters.put('sObjects',(new List<String>{'RV_MCELMT_Cons__c','RV_Input_Attr_Value_Desc__c'}));
                parameters.put('RV_MCELMT_Cons__c_selectedFields', 'MCELMT__c');
                parameters.put('RV_MCELMT_Cons__c_whereClause', 'MCBODY__c = \''+ConRV.Body_Material__c+'\'');
                
                parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
                parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'MCELMT\'');
                parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_MCELMT_Cons__c-MCELMT__c');
                parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_MCELMT_Cons__c-MCELMT__c');
                parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');
                
                Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
                List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
                if(Test.isRunningTest())
                inputAttrValue = inputAttrValue_test;
                if(inputAttrValue != null && inputAttrValue.size() > 0)
                {
                    elementMaterialBoolean = true;
                    if(inputAttrValue.size() == 1){
                        elementMaterialOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                        ConRV.Element_Material__c = inputAttrValue[0].Value__c;
                    }
                    else{
                        elementMaterialOptions.add(new selectOption('','-SELECT-'));
                        for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                        {
                            elementMaterialOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                        }
                    }
                }
                else
                {
                    elementMaterialOptions.add(new selectOption('N','N'));
                }
            }
            else
            {
                elementMaterialOptions.add(new selectOption('N','N'));
                ConRV.Element_Material__c = 'N';
            }
        }
        else
        {
            elementMaterialOptions.add(new selectOption('N','N'));

            ConRV.Element_Material__c = 'N';
        }
    }


    public void getFlameArresterOptions()
    {
        flameArresterOptions.clear();
        flameArresterBoolean = false;

        List<RV_Valve_Attributes_Details__c> valeAttr = [Select Text__c from RV_Valve_Attributes_Details__c where Attribute__c='FASubModel' AND Text1Val__c = :conRV.Model_name__c LIMIT 1];
        if(valeAttr.size()>0)
        {
            if(valeAttr[0].Text__c != 'N'){
                Map<String, Object> parameters = new Map<String, Object>();
                parameters.put('sObjects',(new List<String>{'RV_GOUTOP_Cons__c','RV_Input_Attr_Value_Desc__c'}));
                parameters.put('RV_GOUTOP_Cons__c_selectedFields', 'GOUTOP__c');
                parameters.put('RV_GOUTOP_Cons__c_whereClause', 'ATEX__c = \''+ConRV.Atex_bkend__c+'\' AND SZC__c = \''+ConRV.Size__c+'\'');

                parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
                parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'GOUTOP\'');
                parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_GOUTOP_Cons__c-GOUTOP__c');
                parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_GOUTOP_Cons__c-GOUTOP__c');
                parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

                Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
                List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
                if(Test.isRunningTest())
                inputAttrValue = inputAttrValue_test;
                if(inputAttrValue != null && inputAttrValue.size() > 0)
                {
                    flameArresterBoolean = true;
                    if(inputAttrValue.size() == 1){
                        flameArresterOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                        ConRV.Flame_Arrester_Option__c = inputAttrValue[0].Value__c;
                        if(ConRV.Flame_Arrester_Option__c == '000'){
                            flameArresterBoolean = false;
                        }
                    }
                    else{
                        flameArresterOptions.add(new selectOption('','-SELECT-'));
                        for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                        {
                            flameArresterOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                        }
                    }

                }
                else
                {
                    flameArresterOptions.add(new selectOption('000','000'));
                }
            }

            else{
                flameArresterOptions.add(new selectOption('000','000'));
                ConRV.Flame_Arrester_Option__c = '000';
            }
        }
    }

    public void getVacuumPortOptions()
    {
        vacuumPortOptions.clear();
        vacuumPortBoolean = false;
        Decimal EFFMop = 0.0;
        if(ConRV.EFFMop__c != null)
        {
            EFFMop = ConRV.EFFMop__c.setscale(4);
        }
        else
        {
            EFFMop = 0.0;
        }
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_VPRTOP_Cons__c','RV_Input_Attr_Value_Desc__c'}));
        parameters.put('RV_VPRTOP_Cons__c_selectedFields', 'VPRTOP__c');
        parameters.put('RV_VPRTOP_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MAWPUL__c >= '+EFFMop);

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'VPRTOP\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_VPRTOP_Cons__c-VPRTOP__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_VPRTOP_Cons__c-VPRTOP__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            vacuumPortBoolean = true;
            if(inputAttrValue.size() == 1){
                vacuumPortOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Vacuum_Port_Option__c = inputAttrValue[0].Value__c;
                if(ConRV.Vacuum_Port_Option__c == '0'){
                    vacuumPortBoolean = false;
                }
            }
            else{
                vacuumPortOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    vacuumPortOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }
        }
        else
        {
            vacuumPortOptions.add(new selectOption('0','0'));
            ConRV.Vacuum_Port_Option__c = '0';
        }
    }

    public void getPressurePortProximitySensor(){
        pressurePortProximitySensor = false;
        if(!ConRV.NACE__c){
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'RV_PosSettingLimits__c'}));
            parameters.put('RV_PosSettingLimits__c_selectedFields', 'PosProxSensorAvailable__c');
            parameters.put('RV_PosSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND PosProxSensorAvailable__c = \'Y\' ');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_PosSettingLimits__c> inputAttrValue = (List<RV_PosSettingLimits__c>)processedData.get('RV_PosSettingLimits__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                pressurePortProximitySensor = true;
            }
            else
            {
                ConRV.Pressure_Port_Proximity_Sensor__c = false;
            }
        }
        else{
            ConRV.Pressure_Port_Proximity_Sensor__c = false;
        }
    }

    public void getVacuumPortProximitySensor(){
        vacuumPortProximitySensor = false;
        if(!ConRV.NACE__c){
            Map<String, Object> parameters = new Map<String, Object>();
            parameters.put('sObjects',(new List<String>{'RV_VacSettingLimits__c'}));
            parameters.put('RV_VacSettingLimits__c_selectedFields', 'VacProxSensorAvailable__c');
            parameters.put('RV_VacSettingLimits__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND SZC__c = \''+ConRV.Size__c+'\' AND VacProxSensorAvailable__c = \'Y\' ');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_VacSettingLimits__c> inputAttrValue = (List<RV_VacSettingLimits__c>)processedData.get('RV_VacSettingLimits__c');
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                vacuumPortProximitySensor = true;
            }
            else
            {
                ConRV.Vacuum_Port_Proximity_Sensor__c = false;
            }
        }
        else{
            ConRV.Vacuum_Port_Proximity_Sensor__c = false;
        }
    }

    public string BODYDESIGN{
        get{
            string strBODYDESIGN='';
            system.debug('ConRV.EFFMop__c'+ConRV.EFFMop__c);
            system.debug('ConRV.PosSetPresOSIG__c'+ConRV.PosSetPresOSIG__c);
            if(ConRV.EFFMop__c != null && ConRV.PosSetPresOSIG__c != null && (conRV.Model_name__c != null || string.isNotBlank(conRV.Model_name__c)) )
            {
                List<RV_Valve_Attributes_Details__c> valveSubModel = [SELECT Text__c from RV_Valve_Attributes_Details__c where Attribute__c=:'ValveSubModel' and Text1Val__c=:conRV.Model_name__c LIMIT 1];
                if(!valveSubModel.isEmpty() && valveSubModel.size() >0)
                {
                    List<RV_Valve_Attributes_Details__c> bodyDesignObj =[select Text__c from RV_Valve_Attributes_Details__c where Attribute__c=:'BODYDESIGN' and Text1Val__c=:valveSubModel[0].Text__c
                                                                         and NumVal1__c<:ConRV.EFFMop__c and NumVal2__c>=:ConRV.EFFMop__c and NumVal3__c<:ConRV.PosSetPresOSIG__c and NumVal4__c>=:ConRV.PosSetPresOSIG__c];
                    if(bodyDesignObj.size() > 0){
                        return bodyDesignObj[0].Text__c;
                    }
                    else{
                        return '';
                    }
                }
                else
                {
                    return '';
                }
            }
            else{
                return '';
            }
        }
        set{
            this.BODYDESIGN=value;
        }
    }

    public void getPilotActionOptions()
    {

        pilotActionOptions.clear();
        pilotActionBoolean = false;
        Map<String, Object> parameters = new Map<String, Object>();
        if(BODYDESIGN != null || string.isNotBlank(BODYDESIGN))
        {
            parameters.put('sObjects',(new List<String>{'RV_GPACT_Cons__c','RV_Input_Attr_Value_Desc__c'}));
            parameters.put('RV_GPACT_Cons__c_selectedFields', 'GPACT__c');
            parameters.put('RV_GPACT_Cons__c_whereClause', 'BodyDesign__c = \''+BODYDESIGN+'\' ');
            parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'GPACT\'');
            parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_GPACT_Cons__c-GPACT__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_GPACT_Cons__c-GPACT__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(Test.isRunningTest())
            inputAttrValue = inputAttrValue_test;
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                pilotActionBoolean = true;
                if(inputAttrValue.size() == 1){
                    pilotActionOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Pilot_Action__c = inputAttrValue[0].Value__c;
                    getPilotSupplyFilter();
                }
                else{
                    pilotActionOptions.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        pilotActionOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                    if(ConRV.Pilot_Action__c != null && String.isNotBlank(ConRV.Pilot_Action__c)){
                        pilotSupplyFilter = true;
                    }
                }
            }
            else
            {
                pilotActionOptions.add(new selectOption('N','N'));
                ConRV.Pilot_Action__c = 'N';
                getPilotSupplyFilter();
            }
        }
    }

    public void getManualBlowdown(){

        manualBlowdown = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_PVOP_Cons__c'}));
        parameters.put('RV_PVOP_Cons__c_selectedFields', 'ManualBlowdown__c');
        parameters.put('RV_PVOP_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND BodyDesign__c = \''+BODYDESIGN+'\' AND ManualBlowdown__c = \'Y\' ');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_PVOP_Cons__c> inputAttrValue = (List<RV_PVOP_Cons__c>)processedData.get('RV_PVOP_Cons__c');
        System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            manualBlowdown = true;
        }
        else
        {
           conRV.Manual_Blowdown__c = false;
        }
    }

    public void getRemoteSense(){

        remoteSense = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_PVOP_Cons__c'}));
        parameters.put('RV_PVOP_Cons__c_selectedFields', 'RemoteSense__c');
        parameters.put('RV_PVOP_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND BodyDesign__c = \''+BODYDESIGN+'\' AND RemoteSense__c = \'Y\' ');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_PVOP_Cons__c> inputAttrValue = (List<RV_PVOP_Cons__c>)processedData.get('RV_PVOP_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            remoteSense = true;
        }
        else
        {
            conRV.Remote_Sense__c = false;
        }
    }

    public void getPilotExhaustPipedToDischargeHeader(){

        pilotExhaustPipedToDischargeHeader = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_PVOP_Cons__c'}));
        parameters.put('RV_PVOP_Cons__c_selectedFields', 'PilotExhaustPiped__c');
        parameters.put('RV_PVOP_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND BodyDesign__c = \''+BODYDESIGN+'\' AND PilotExhaustPiped__c = \'Y\' ');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_PVOP_Cons__c> inputAttrValue = (List<RV_PVOP_Cons__c>)processedData.get('RV_PVOP_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            pilotExhaustPipedToDischargeHeader = true;
        }
        else
        {
            pilotExhaustPipedToDischargeHeader = false;
        }
    }

    public void getFieldTestConnection(){

        fieldTestConnection = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_PVOP_Cons__c'}));
        parameters.put('RV_PVOP_Cons__c_selectedFields', 'FieldTestConnection__c');
        parameters.put('RV_PVOP_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND BodyDesign__c = \''+BODYDESIGN+'\' AND FieldTestConnection__c = \'Y\' ');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_PVOP_Cons__c> inputAttrValue = (List<RV_PVOP_Cons__c>)processedData.get('RV_PVOP_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            fieldTestConnection = true;
        }
        else
        {
            conRV.Field_Test_Connection__c = false;
        }
    }

    public void getPilotSupplyFilter(){

        pilotSupplyFilter = false;
        Map<String, Object> parameters = new Map<String, Object>();
        system.debug('****&&VacSetPresOSIG :'+ ConRV.VacSetPresOSIG__c + 'PosSetPresOSIG: '+ConRV.PosSetPresOSIG__c);
        if(ConRV.PosSetPresOSIG__c != null && ConRV.VacSetPresOSIG__c != null){
            parameters.put('sObjects',(new List<String>{'RV_PVSP_Cons__c'}));
            parameters.put('RV_PVSP_Cons__c_selectedFields', 'PTC__c');
            parameters.put('RV_PVSP_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND GPACT__c = \''+ConRV.Pilot_Action__c+'\' AND BodyDesign__c = \''+BODYDESIGN+'\' AND VacLimitOSIG__c < '+ ConRV.VacSetPresOSIG__c+' AND PosLimitOSIG__c < '+ConRV.PosSetPresOSIG__c);
            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_PVSP_Cons__c> inputAttrValue = (List<RV_PVSP_Cons__c>)processedData.get('RV_PVSP_Cons__c');
            System.debug('&&& inputAttrValue = '+inputAttrValue);
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                pilotSupplyFilter = true;
                system.debug('****&&pilotSupplyFilter'+pilotSupplyFilter);
            }
            else
            {
                conRV.Pilot_Supply_Filter__c = false;
            }
        }
    }


    //Section G Begins here
    public void getMethod21LeakDetection(){
        method21LeakDetection = false;
        system.debug('conRV.Pallet_Type__c'+conRV.Pallet_Type__c);
        if(conRV.Pallet_Type__c == 'Film'){
             method21LeakDetection = true;
        }
        else{
            conRV.Method21_Leak_Detection__c = false;
        }
    }

    public void getRadiographyOptions()
    {
        radiographyOptions.clear();
        radiographyBoolean = false;
        ConRV.Radiography__c = null;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c','RV_Input_Attr_Value_Desc__c'}));
        parameters.put('RV_EXMOPTC_Cons__c_selectedFields', 'Radiography__c');
        parameters.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND Radiography__c = \'Y\' ');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'XRAY\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_EXMOPTC_Cons__c-Radiography__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_EXMOPTC_Cons__c-Radiography__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            radiographyBoolean = true;
            if(inputAttrValue.size() == 1){
                radiographyOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Radiography__c = inputAttrValue[0].Value__c;
            }
            else{
                radiographyOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    radiographyOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }


        }
        else
        {
            radiographyOptions.add(new selectOption('N','N'));
            ConRV.Radiography__c = 'N';
        }
    }

    public void getFilletWeldLiquidDyePenetrant(){

        filletWeldLiquidDyePenetrant = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('RV_EXMOPTC_Cons__c_selectedFields', 'FilletWeldLP__c');
        parameters.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND FilletWeldLP__c = \'Y\' ');
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData.get('RV_EXMOPTC_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            filletWeldLiquidDyePenetrant = true;
        }
        else
        {
            ConRV.Fillet_Weld_Liquid_Dye_Penetrant__c = false;
        }
    }

    public void getLiquidDyePenetrantOptions(){
        liquidDyePenetrantOptions.clear();
        liquidDyePenetrantBoolean = false;
        ConRV.Liquid_Dye_Penetrant__c = null;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c','RV_EXMOMC_Cons__c','RV_Input_Attr_Value_Desc__c'}));

        parameters.put('RV_EXMOPTC_Cons__c_selectedFields', 'DyePenetrant__c');
        parameters.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND DyePenetrant__c = \'Y\' ');

        parameters.put('RV_EXMOMC_Cons__c_selectedFields', 'DyePenetrant__c');
        parameters.put('RV_EXMOMC_Cons__c_whereClause', 'MC__c = \''+ConRV.Body_Material__c+'\' AND DyePenetrant__c = \'Y\' ');

        parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'LDP\'');
        parameters.put('RV_Input_Attr_Value_Desc__c_referenceFields', 'RV_EXMOPTC_Cons__c-DyePenetrant__c,RV_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_dependencyCondition', 'Value__c = RV_EXMOPTC_Cons__c-DyePenetrant__c&&Value__c = RV_EXMOMC_Cons__c-DyePenetrant__c');
        parameters.put('RV_Input_Attr_Value_Desc__c_orderBy', 'Display_Order__c ASC');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
        if(Test.isRunningTest())
        inputAttrValue = inputAttrValue_test;
        if(inputAttrValue != null && inputAttrValue.size() > 0)
        {
            liquidDyePenetrantBoolean = true;

            if(inputAttrValue.size() == 1){
                positiveMaterialIdentificationOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                ConRV.Liquid_Dye_Penetrant__c = inputAttrValue[0].Value__c;
            }
            else{
                positiveMaterialIdentificationOptions.add(new selectOption('','-SELECT-'));
                for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                {
                    liquidDyePenetrantOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                }
            }
        }
        else
        {
            liquidDyePenetrantOptions.add(new selectOption('N','N'));
            ConRV.Liquid_Dye_Penetrant__c = 'N';
        }
    }

    public void getPositiveMaterialIdentificationOptions(){
        positiveMaterialIdentificationOptions.clear();
        positiveMaterialIdentificationBoolean = false;
        ConRV.Positive_Material_Identification__c = null;
       Map<String, Object> parameters = new Map<String, Object>();
       //for testcase, nikhil 19 feb 
        if(!Test.isRunningTest())
        pmiList = [Select PMI__c from RV_EXMOMC_Cons__c where PMI__c = 'Y' AND ( MC__c  = :ConRV.Body_Material__c OR MC__c  = :ConRV.Seat_Material__c OR MC__c  = :ConRV.Pressure_Pallet_Material__c OR MC__c  = :ConRV.Vacuum_Pallet_Material__c)];
        system.debug('pmiList**'+pmiList );
        if(pmiList.size() > 0){
            parameters.put('sObjects',(new List<String>{'RV_Input_Attr_Value_Desc__c'}));
            parameters.put('RV_Input_Attr_Value_Desc__c_selectedFields', 'Text_Description_of_AttributeValue__c, Value__c');
            parameters.put('RV_Input_Attr_Value_Desc__c_whereClause', 'Attribute__c = \'PMI\'');

            Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
            List<RV_Input_Attr_Value_Desc__c> inputAttrValue = (List<RV_Input_Attr_Value_Desc__c>)processedData.get('RV_Input_Attr_Value_Desc__c');
            if(Test.isRunningTest())
            inputAttrValue = inputAttrValue_test;
            if(inputAttrValue != null && inputAttrValue.size() > 0)
            {
                positiveMaterialIdentificationBoolean = true;
                if(inputAttrValue.size() == 1){
                    positiveMaterialIdentificationOptions.add(new selectOption(inputAttrValue[0].Value__c,inputAttrValue[0].Text_Description_of_AttributeValue__c));
                    ConRV.Positive_Material_Identification__c = inputAttrValue[0].Value__c;
                }
                else{
                    positiveMaterialIdentificationOptions.add(new selectOption('','-SELECT-'));
                    for(RV_Input_Attr_Value_Desc__c record : inputAttrValue)
                    {
                        positiveMaterialIdentificationOptions.add(new selectOption(record.Value__c,record.Text_Description_of_AttributeValue__c));
                    }
                }
            }
            else
            {
                positiveMaterialIdentificationOptions.add(new selectOption('N','N'));
                ConRV.Positive_Material_Identification__c = 'N';
            }
        }
        else{
            positiveMaterialIdentificationOptions.add(new selectOption('N','N'));
            ConRV.Positive_Material_Identification__c = 'N';
        }
    }

    public void getUltrasonicExamination(){

        ultrasonicExamination = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('RV_EXMOPTC_Cons__c_selectedFields', 'Ultrasonic__c');
        parameters.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND Ultrasonic__c = \'Y\' ');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData.get('RV_EXMOPTC_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0 )
        {
            ultrasonicExamination = true;
        }
        else
        {
            ConRV.Ultrasonic_Examination__c = false;
        }
    }

    public void getMagneticParticleExamination(){

        magneticParticleExamination = false;
        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'RV_EXMOMC_Cons__c'}));

        parameters1.put('RV_EXMOPTC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters1.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND MagneticParticle__c = \'Y\' ');

        parameters.put('RV_EXMOMC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters.put('RV_EXMOMC_Cons__c_whereClause', 'MC__c = \''+ConRV.Body_Material__c+'\' AND MagneticParticle__c = \'Y\' ');

        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData1.get('RV_EXMOPTC_Cons__c');
        List<RV_EXMOMC_Cons__c> inputAttrValue2 = (List<RV_EXMOMC_Cons__c>)processedData.get('RV_EXMOMC_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            magneticParticleExamination = true;
        }
        else
        {
            ConRV.Magnetic_Particle_Examination__c = false;
        }
    }

    public void getBrinellHardnessExamination(){
        brinellHardnessExamination = false;
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('RV_EXMOPTC_Cons__c_selectedFields', 'BrinellHardness__c');
        parameters.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND BrinellHardness__c = \'Y\' ');

        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData.get('RV_EXMOPTC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 )
        {
            brinellHardnessExamination = true;
        }
        else
        {
            ConRV.Brinell_hardness_examination__c = false;
        }
    }

    public void getCharpyImpactTesting(){

        charpyImpactTesting = false;
        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'RV_EXMOMC_Cons__c'}));

        parameters1.put('RV_EXMOPTC_Cons__c_selectedFields', 'CharpyImpact__c');
        parameters1.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND CharpyImpact__c = \'Y\' ');

        parameters.put('RV_EXMOMC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters.put('RV_EXMOMC_Cons__c_whereClause', 'MC__c = \''+ConRV.Body_Material__c+'\' AND CharpyImpact__c = \'Y\' ');

        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData1.get('RV_EXMOPTC_Cons__c');
        List<RV_EXMOMC_Cons__c> inputAttrValue2 = (List<RV_EXMOMC_Cons__c>)processedData.get('RV_EXMOMC_Cons__c');
        //System.debug('&&& inputAttrValue = '+inputAttrValue);
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            charpyImpactTesting = true;
        }
        else
        {
            ConRV.Charpy_Impact_Testing__c = false;
        }
    }

    public void getVisualCastingExamination(){

        visualCastingExamination = false;
        system.debug('ConRV.Model_name__c'+ConRV.Model_name__c);

        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'RV_EXMOMC_Cons__c'}));

        parameters1.put('RV_EXMOPTC_Cons__c_selectedFields', 'VisualCasting__c');
        parameters1.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND VisualCasting__c = \'Y\' ');

        parameters.put('RV_EXMOMC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters.put('RV_EXMOMC_Cons__c_whereClause', 'MC__c = \''+ConRV.Body_Material__c+'\' AND VisualCasting__c = \'Y\' ');

        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData1.get('RV_EXMOPTC_Cons__c');
        List<RV_EXMOMC_Cons__c> inputAttrValue2 = (List<RV_EXMOMC_Cons__c>)processedData.get('RV_EXMOMC_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            visualCastingExamination = true;
            system.debug('check true');
        }
        else
        {
            ConRV.Visual_Casting_Examination__c = false;
            system.debug('check false');
        }
    }

    public void getIntergranularCorrosionTest(){

        intergranularCorrosionTest = false;
        Map<String, Object> parameters = new Map<String, Object>();
        Map<String, Object> parameters1 = new Map<String, Object>();
        parameters1.put('sObjects',(new List<String>{'RV_EXMOPTC_Cons__c'}));
        parameters.put('sObjects',(new List<String>{'RV_EXMOMC_Cons__c'}));

        parameters1.put('RV_EXMOPTC_Cons__c_selectedFields', 'Intergranular_Corrosion__c');
        parameters1.put('RV_EXMOPTC_Cons__c_whereClause', 'PTC__c = \''+ConRV.Model_name__c+'\' AND Intergranular_Corrosion__c = \'Y\' ');

        parameters.put('RV_EXMOMC_Cons__c_selectedFields', 'MagneticParticle__c');
        parameters.put('RV_EXMOMC_Cons__c_whereClause', 'MC__c = \''+ConRV.Body_Material__c+'\' AND IntergranularCorrosion__c = \'Y\' ');

        Map<String, Object> processedData1 = wizardBaseDataProcessor.getObjectRecords(parameters1);
        Map<String, Object> processedData = wizardBaseDataProcessor.getObjectRecords(parameters);
        List<RV_EXMOPTC_Cons__c> inputAttrValue = (List<RV_EXMOPTC_Cons__c>)processedData1.get('RV_EXMOPTC_Cons__c');
        List<RV_EXMOMC_Cons__c> inputAttrValue2 = (List<RV_EXMOMC_Cons__c>)processedData.get('RV_EXMOMC_Cons__c');
        if(inputAttrValue != null && inputAttrValue.size() > 0 && (inputAttrValue2 != null && inputAttrValue2.size() > 0))
        {
            intergranularCorrosionTest = true;
        }
        else
        {
            ConRV.Intergranular_Corossion_Test__c = false;
        }
    }

    public string shellTestValueBody{get;set;}
    Public PageReference saveProductMaterialAndOptions()
    {
        system.debug('ConRV.Model_name__c'+ConRV.Model_name__c);
        update conRV;

        try{
            getMethod21LeakDetection();
            getRadiographyOptions();
            getFilletWeldLiquidDyePenetrant();
            getLiquidDyePenetrantOptions();
            getPositiveMaterialIdentificationOptions();
            getUltrasonicExamination();
            getMagneticParticleExamination();
            getBrinellHardnessExamination();
            getCharpyImpactTesting();
            getVisualCastingExamination();
            getIntergranularCorrosionTest();
            conRV.Section_A_Flag__c=true;
            conRV.Section_B_Flag__c=false;
            conRV.Section_C_Flag__c=false;
            conRV.Section_D_Flag__c=false;
            conRV.Section_E_Flag__c=false;
            conRV.Section_F_Flag__c=true;
            conRV.Section_G_Flag__c=false;
            if(string.isBlank(conRV.Body_Material__c) || conRV.Body_Material__c == 'N')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Body Material: No valid choice is available with your previous choices, please revise your configuration'));
            }
            bShowEditButton = false; //added by piyush  
            bShowReturnToProductSelectionButton = false;  //added by piyush
            conRV.Finish_Configuration_Flag__c =false;
            conRV.Shell_Test_Valve_Body__c = 'AIR';
            update conRV;
          
        }
        catch(Exception dmle)
        {
            conRV.Section_F_Flag__c=false;
            ApexPages.addMessages(dmle);
            return null;
        }
        system.debug('Section_F_Flag__c'+conRV.Section_F_Flag__c);
        return null;
    }

    Public PageReference saveValveExaminationOption()
    {
        ConRV.Finish_Configuration_Flag__c=false;
        try{

            if(conRV.Section_F_Flag__c){
                conRV.Section_A_Flag__c=true;
                conRV.Section_B_Flag__c=false;
                conRV.Section_C_Flag__c=false;
                conRV.Section_D_Flag__c=false;
                conRV.Section_E_Flag__c=false;
                conRV.Section_F_Flag__c=false;
                conRV.Section_G_Flag__c=true;
                if(conRV.Positive_Material_Identification__c == null || string.isBlank(conRV.Positive_Material_Identification__c))
                {
                    conRV.Positive_Material_Identification__c = 'N';
                }
                update conRV;


            }

            
            bShowEditButton = false; //added by piyush  
            bShowReturnToProductSelectionButton = false;  //added by piyush
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
    return null;
    }

    Public PageReference saveDocSourcing()
    {
       try{
            if(conRV.Section_G_Flag__c)
            {
                system.debug('Inside finish configuration');
                List<Cost__c> cstList = new List<Cost__c>();
                cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(conRV.Id)];
                if(!cstList.isEmpty() && cstList.size() >0 )
                {
                    delete cstList;
                }
                conRV.Finish_Configuration_Flag__c=true;
                conRV.Body_Design__c = BODYDESIGN;                
                system.debug('@@**RVOU value'+RVOU);
                if(RVOU ==  null)
                {
                    RVOU = new RVOutputUtility(conRV.id);
                }
                 system.debug('@@**RVOU value'+RVOU);
                String strBRANDCODE='';
                if(conRV.Brand__c!=null)
                {
                    if(conRV.Brand__c=='Groth')
                        strBRANDCODE='V';
                    else if(conRV.Brand__c=='CDC')
                        strBRANDCODE='D';
                    else if(conRV.Brand__c=='LaMOT')
                        strBRANDCODE='T';
                    else if(conRV.Brand__c=='LVA')
                        strBRANDCODE='L';
                    else
                        strBRANDCODE='';
                }
            }
            System.debug('vvvvvvstrquoteDes' + strquoteDes);
            generatePartNumber();
        if(!Test.isRunningTest()) 
        {
            getPricingRecords();
            GetQuoteDescriptionRecords();
        }
            if(!notValidStatusForChng.contains(strQuoteStatus)) 
            {
               		string strProdOver='';
                    if(String.isNotBlank(ConRV.OA__c)){
                        strProdOver += ConRV.OA__c +'\n';
                    }
                    if(String.isNotBlank(ConRV.OB__c)){
                        strProdOver += ConRV.OB__c+'\n';
                    }
                    if(String.isNotBlank(ConRV.OW__c)){
                        strProdOver += ConRV.OW__c;
                    }
                	if(String.isNotBlank(ConRV.PC__c)){
                        strProdOver += ConRV.PC__c;
                    }
                    string strquoteDes1 = strProdOver;
                    strquoteDes1.replaceAll('\n', '</BR>');
                if(!Test.isRunningTest()) 
                {
                    quoteLine.Config_Record_Id__c = conRV.id;
                    
                    quoteLine.SBQQ__Quantity__c=conRV.Quantity__c;
                    quoteLine.Engineering_Notes__c = conRV.Engineering_Notes__c;
                    quoteLine.Non_Discountable_List_Price__c =  conRV.Non_Discountable_Price__c/conRV.Quantity__c;
                    quoteLine.Discountable_List_Price__c = conRV.Discountable_Price__c;
                    System.debug('AAAAAAAAA Quote line Non_Discountable_List_Price__c' + quoteLine.Non_Discountable_List_Price__c);
                    System.debug('AAAAAAAAA Quote line Discountable_List_Price__c' +quoteLine.Discountable_List_Price__c);
                    System.debug('AAAAAAAAA Non_Discountable_List_Price__c' +conRV.Non_Discountable_Price__c/conRV.Quantity__c);
                    System.debug('AAAAAAAAA Discountable_List_Price__c' +conRV.Discountable_Price__c);
                    getLeadTimeRecords();
                    System.debug('AAAAAAAAA Lead_Time_Site_10__c' +conRV.Lead_Time_Site_10__c);
                    System.debug('AAAAAAAAA Lead_Time_Site_20__c' +conRV.Lead_Time_Site_20__c);
                    System.debug('AAAAAAAAA Lead_Time_Site_30__c' +conRV.Lead_Time_Site_30__c);
                    System.debug('AAAAAAAAA Lead_Time_Site_40__c' +conRV.Lead_Time_Site_40__c);
                    quoteLine.Leadtime_Site_10__c = conRV.Lead_Time_Site_10__c;
                    quoteLine.Leadtime_Site_20__c = conRV.Lead_Time_Site_20__c;
                    quoteLine.Leadtime_Site_30__c = conRV.Lead_Time_Site_30__c;
                    quoteLine.Leadtime_Site_40__c = conRV.Lead_Time_Site_40__c;
                    quoteLine.Body_Material__c=conRV.Body_Material__c;
                    System.debug('AAAAAAAAA Lead_Time_Site_10__c' +conRV.Lead_Time_Site_10__c);
                    System.debug('AAAAAAAAA Lead_Time_Site_20__c' +conRV.Lead_Time_Site_20__c);
                    System.debug('AAAAAAAAA Lead_Time_Site_30__c' +conRV.Lead_Time_Site_30__c);
                    System.debug('AAAAAAAAA Lead_Time_Site_40__c' +conRV.Lead_Time_Site_40__c);
                    quoteLine.SBQQ__Description__c=strquoteDes1.replaceAll('&','&amp').replaceAll('>','&gt').replaceAll('<','&lt').replaceAll('\n', '<BR>');
                    upsert quoteLine;
                }
            }
             update conRV;
        }
        catch(Exception dmle)
        {
            if(!ReorderFlag)
            	ApexPages.addMessages(dmle);
            return null;
        }
        pageReference reloadpage = new pageReference('/apex/RVConfig?qid='+quoteId);
        reloadpage.setRedirect(true);
        return reloadpage;
    }
    
    public string strquoteDes {
        get {
            
            RV_Outputs__c rvoutput = getRVOutputRecord(conRV.Id);
            String strProdOver = '';
            if(String.isNotBlank(rvoutput.OA_Override__c)){
                strProdOver += rvoutput.OA_Override__c +'<BR/><BR/>';
            }
            if(String.isNotBlank(rvoutput.OB_Override__c)){
                strProdOver += rvoutput.OB_Override__c+'<BR/><BR/>';
            }            
            if(String.isNotBlank(rvoutput.OW_Override__c)){
                strProdOver += rvoutput.OW_Override__c+'<BR/><BR/>';
            }
            if(String.isNotBlank(rvoutput.PC_Override__c)){
                strProdOver += rvoutput.PC_Override__c;
            }
            strquoteDes = strProdOver.replaceAll('\n', '<BR/>');
            return strquoteDes;
        }
        set {
            this.strquoteDes=value;
        }
    }
   

    public void generatePartNumber()
    {
        Result partNumberResult = AssyPartDefinationProcessor.generatePartNumber(conRV);
        if(partNumberResult.bResult ==  true)
        {
            conRV.ASSYPARTNO__c = partNumberResult.strRetValue;
        }
        update conRV;
    }

    public pageReference goBack() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL = '/s/reliefvalvecmp?quoteId='+qID + '&configId=' + conRV.Id;
        }else{
            strURL = '/lightning/cmp/c__reliefValveCmp?c__configId='+conRV.Id + '&c__quoteId=' +qID;
        }
        return null;
    }

    public pageReference goBackToQuote() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        if(userinfo.IsPortalEnabled){
            strURL =  '/s/detail/'+qID ;
        }else{
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }
        return null;
    }

    public PageReference savePartNumber() {
        try {
         if(conRV.Quote_Description_Engineer_Override__c == true)
         {
             conRV.Part_Number__c = '';
         }
            update conRV;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

     /* This method is to convert the Picklist to Radio buttons for Section G Shell Test Valve Body */
     public List<SelectOption> getShellTestValveBody(){
        Schema.sObjectType sobject_type = Relief_Valve__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Shell_Test_Valve_Body__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getValue(), a.getLabel()));
        }
        return options;
    }

    /*This method is for the Save and continue button on Engineering Notes tab*/
    public PageReference saveNotes() {
        //conBGR.Product_material_options_flag__c=true;
        try {
            update conRV;
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
            update conRV;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;

    }
    //Service Ticket #203415,RHATHI, changed from static method and added if condition
    //to query dbase, only if the rvOutput instance is null
    public RV_Outputs__c getRVOutputRecord(String rvId)
    {
        if(rvOutput == null){ //RHATHI #203415, 
            System.debug('RHATHI #203415 Limits.getQueries - getRVOutputRecord '+ Limits.getQueries());
            
            List<RV_Outputs__c> rvOutputList = new List<RV_Outputs__c>();
            String fieldsAPIname = FLMutility.getObjectFields('RV_Outputs__c');
            String soql = 'SELECT '+fieldsAPIname+' FROM RV_Outputs__c where RV_Outputs_Relation_Field__c =\''+String.escapeSingleQuotes(rvId)+'\'';
            rvOutputList = Database.query(soql);//[SELECT id from BGR_Outputs__c where BGR_Outputs_Relation_Field__c =:bgrId];
            if(rvOutputList != null && rvOutputList.size() > 0)
            {
                rvOutput = rvOutputList[0];
                return rvOutputList[0];
            }
        }

        return rvOutput; //else in other cases, return the current rvOutput instance, no need to create blank instance with rvid and return
        
    }
    public RV_Outputs__c getPriceRVOutputInstance()
    {
        RV_Outputs__c rvOutput = getRVOutputRecord(conRV.Id);
        rvOutput.AssemblyLocation__c = null;
        rvOutput.BrinnellHardnessExamination__c = null;
        rvOutput.CharpyImpactTesting__c = null;
        rvOutput.CUTR__c = null;
        rvOutput.Drilling__c = null;
        rvOutput.ERVHighPressureBody__c = null;
        rvOutput.FAModelBase__c  = null;
        rvOutput.FAOptionOutlet__c = null;
        rvOutput.FAPaintOptions__c = null;
        rvOutput.FiberglassFastener__c = null;
        rvOutput.FieldTestConnection__c = null;
        rvOutput.FilletWeldLiquidDyePenetrantExamination__c = null;
        rvOutput.FlangeHardware__c = null;
        rvOutput.IntergranularCorrosionTesting__c = null;
        rvOutput.LiquidDyePenetrantExamination__c = null;
        rvOutput.MagneticParticleExamination__c = null;
        rvOutput.ManualBlowdown__c = null;
        rvOutput.MaterialSourcingRequirements__c = null;
        rvOutput.Method21__c = null;
        rvOutput.ModelBase__c = null;
        rvOutput.NACE__c = null;
        rvOutput.Painting__c = null;
        rvOutput.PilotExhaustPipedtoDischargeHeader__c = null;
        rvOutput.PilotSupplyFilter__c = null;
        rvOutput.PositiveMaterialIdentification__c = null;
        rvOutput.POVPallet__c = null;
        rvOutput.Proximity_Sensor__c = null;
        rvOutput.PVRVHighPressureBody__c = null;
        rvOutput.RadiographyExamination__c = null;
        rvOutput.RemoteSense__c = null;
        rvOutput.SettingMinPressure__c = null;
        rvOutput.SettingMinVacuum__c = null;
        rvOutput.ShellTestBody__c = null;
        rvOutput.SpacerPressure__c = null;
        rvOutput.SpacerVacuum__c = null;
        rvOutput.SpringPressure__c = null;
        rvOutput.SpringVacuum__c = null;
        rvOutput.SteamJacket__c = null;
        rvOutput.UltrasonicExamination__c = null;
        rvOutput.VacuumPortOptions__c = null;
        rvOutput.VisualCastingExamination__c = null;
        rvOutput.WeightSettingPressure__c = null;
        rvOutput.WeightSettingVacuum__c = null;
        rvOutput.Total_Price__c = null;
        return rvOutput;
    }
    public RV_Outputs__c getLeadRVOutputInstance()
    {
       RV_Outputs__c rvOutput = getRVOutputRecord(conRV.Id);
        rvOutput.Base_10__c = null;
        rvOutput.SteamJacket_10__c = null;
        rvOutput.Painting_10__c = null;
        rvOutput.FilWeldLiqDyePenExam_10__c = null;
        rvOutput.LiquidDyePenetrantExamination_10__c = null;
        rvOutput.MagParticleExam_10__c = null;
        rvOutput.PositiveMaterialIdentification_10__c = null;
        rvOutput.RadiographyExam_10__c = null;
        rvOutput.VisualCastingExamination_10__c = null;
        rvOutput.CharpyImpactTest_10__c = null;
        rvOutput.UltrasonicExam_10__c = null;
        rvOutput.IntergranularCorrosionTest_10__c = null;
        rvOutput.BrinnelHardnessExam_10__c = null;
        rvOutput.ShellTestBody_10__c = null;
        rvOutput.NACE_10__c = null;
        rvOutput.ProximitySensor_10__c = null;
        rvOutput.AssemblyLocation_10__c = null;
        rvOutput.MaterialSource_10__c = null;
        rvOutput.Base_20__c = null;
        rvOutput.SteamJacket_20__c = null;
        rvOutput.Painting_20__c = null;
        rvOutput.FilWeldLiqDyePenExam_20__c = null;
        rvOutput.LiquidDyePenetrantExamination_20__c = null;
        rvOutput.MagParticleExam_20__c = null;
        rvOutput.PositiveMaterialIdentification_20__c = null;
        rvOutput.RadiographyExam_20__c = null;
        rvOutput.VisualCastingExamination_20__c = null;
        rvOutput.CharpyImpactTest_20__c = null;
        rvOutput.UltrasonicExam_20__c = null;
        rvOutput.IntergranularCorrosionTest_20__c = null;
        rvOutput.BrinnelHardnessExam_20__c = null;
        rvOutput.ShellTestBody_20__c = null;
        rvOutput.NACE_20__c = null;
        rvOutput.ProximitySensor_20__c = null;
        rvOutput.AssemblyLocation_20__c = null;
        rvOutput.MaterialSource_20__c = null;
        rvOutput.Base_30__c = null;
        rvOutput.SteamJacket_30__c = null;
        rvOutput.Painting_30__c = null;
        rvOutput.FilWeldLiqDyePenExam_30__c = null;
        rvOutput.LiquidDyePenetrantExamination_30__c = null;
        rvOutput.MagParticleExam_30__c = null;
        rvOutput.PositiveMaterialIdentification_30__c = null;
        rvOutput.RadiographyExam_30__c = null;
        rvOutput.VisualCastingExamination_30__c = null;
        rvOutput.CharpyImpactTest_30__c = null;
        rvOutput.UltrasonicExam_30__c = null;
        rvOutput.IntergranularCorrosionTest_30__c = null;
        rvOutput.BrinnelHardnessExam_30__c = null;
        rvOutput.ShellTestBody_30__c = null;
        rvOutput.NACE_30__c = null;
        rvOutput.ProximitySensor_30__c = null;
        rvOutput.AssemblyLocation_30__c = null;
        rvOutput.MaterialSource_30__c = null;
        rvOutput.Base_40__c = null;
        rvOutput.SteamJacket_40__c = null;
        rvOutput.Painting__c = null;
        rvOutput.FilWeldLiqDyePenExam_40__c = null;
        rvOutput.LiquidDyePenetrantExamination_40__c = null;
        rvOutput.MagParticleExam_40__c = null;
        rvOutput.PositiveMaterialIdentification_40__c = null;
        rvOutput.RadiographyExam_40__c = null;
        rvOutput.VisualCastingExamination_40__c = null;
        rvOutput.CharpyImpactTest_40__c = null;
        rvOutput.UltrasonicExam_40__c = null;
        rvOutput.IntergranularCorrosionTest_40__c = null;
        rvOutput.BrinnelHardnessExam_40__c = null;
        rvOutput.ShellTestBody_40__c = null;
        rvOutput.NACE_40__c = null;
        rvOutput.ProximitySensor_40__c = null;
        rvOutput.AssemblyLocation_40__c = null;
        rvOutput.MaterialSource_40__c = null;
        return rvOutput;
    }
    public RV_Outputs__c getQuoteRVOutputInstance()
    {
        /*RHATHI Service Ticket #203415, to optimize, avoid unnecessary instantiation and occupy memory
        RV_Outputs__c rvOutput = getRVOutputRecord(conRV.Id); 
        return rvOutput; 
        */
        return getRVOutputRecord(conRV.Id); //RHATHI Service Ticket #203415, no need to create instance and then return that 
    }
    /*RV Outputs Getters and Setters*/
    public decimal TotalRVPrice{set;get;}
    public decimal TotalRVPriceOverride{set;get;}
    public decimal NonDiscountablePriceEach{set;get;}
    public decimal ListPriceEach{set;get;}
    public Integer Total10{set;get;}
    public Integer Total20{set;get;}
    public Integer Total30{set;get;}
    public Integer Total40{set;get;}
    public Integer Total10Override{set;get;}
    public Integer Total20Override{set;get;}
    public Integer Total30Override{set;get;}
    public Integer Total40Override{set;get;}
    //public list<RV_Valve_Price_Details__c > RVPricingList{set;get;}
    public list<priceWrapper > RVPriceWrapperList{set;get;}
    public list<LeadTimeWrapper> RVLeadTimeList{set;get;}
    //Public list<BGR_Attribute_table_lookup__c>  RVQuoteDescList;
    Public List<QuoteDescriptionWrapper> quoteDescriptionList{set;get;}
    /*@Method to retrive RV Pricing*/
    public class priceWrapper
    {
        public RV_Valve_Price_Details__c rvPrice{get; set;}
        public Decimal rvPriceOverride{get; set;}
        priceWrapper()
        {
            rvPrice = new RV_Valve_Price_Details__c();
            rvPriceOverride = 0.00;
        }
    }
    public void getPricingRecords()
    {
        RVPriceWrapperList.clear();
        TotalRVPrice = 0.0;
        TotalRVPriceOverride = 0.0;
        NonDiscountablePriceEach = 0.00;
        ListPriceEach = 0.0;
        result prncgResult=new result();
        if(conRV.Finish_Configuration_Flag__c)
        {
            getQuoteRVOutputInstance();
            prncgResult=RVOU.getPricing();
            if(prncgResult.bResult)
            {
                boolean has9999999 = false;
                boolean has8888888 = false;
                
                Set<String> weightElements = new Set<String>{'SettingMinPressure','SettingMinVacuum','WeightSettingPressure','WeightSettingVacuum','WeightPressure','WeightVacuum'};
                Map<String, RV_Valve_Price_Details__c> WeightMap = new Map<String, RV_Valve_Price_Details__c>();                               
                
                /***********************************************/
                //Method to find missing price elements
                List<String> uniqueListSZC=new List<String>();
                list<RV_Valve_Price_Details__c> pricelementss=new list<RV_Valve_Price_Details__c>();
                for(RV_Valve_Price_Details__c eachFAMB : [
                    SELECT Price__c,Pricing_Element__c FROM RV_Valve_Price_Details__c order by Pricing_Element__c ]){
                    if(!uniqueListSZC.contains(eachFAMB.Pricing_Element__c)) {    
                        pricelementss.add(eachFAMB);
                        uniqueListSZC.add(eachFAMB.Pricing_Element__c);
                    }
                }
                /***************************/
				list<string> priceelements=new list<string>();
                
                for (sObject sobj:prncgResult.objResultList)
                {
                    RV_Valve_Price_Details__c  RVPricingRecord = new RV_Valve_Price_Details__c ();
                    RVPricingRecord = (RV_Valve_Price_Details__c )sobj;
                    String fieldAPI;
                    System.debug('*** utility Element = '+RVPricingRecord.Pricing_Element__c+', Price = '+RVPricingRecord.Price__c);
                    System.debug('###RVPricingRecord before if: '+RVPricingRecord);
                    if(weightElements.contains(RVPricingRecord.Pricing_Element__c))
                    {
                        WeightMap.put(RVPricingRecord.Pricing_Element__c,RVPricingRecord);
                    }
                    else
                    {
                        fieldAPI = RVPricingRecord.Pricing_Element__c;
                        if(RVPricingRecord.Pricing_Element__c.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                        fieldAPI = fieldAPI+'__c';
                        Decimal priceOverride = 0.00;
                        if(!Test.isRunningTest()) 
                        {
                            if(rvOutput.get(fieldAPI) == null)
                            {
                                rvOutput.put(fieldAPI, RVPricingRecord.Price__c);
                                priceOverride = RVPricingRecord.Price__c;               
                            }
                            else
                            {
                                priceOverride = (Decimal)rvOutput.get(fieldAPI);
                            }
                        }
                        TotalRVPrice += RVPricingRecord.Price__c;
                        if(priceOverride == 9999999)
                      {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999.00;
                      }
                    if(priceOverride == 8888888 && has9999999==false)
                      {
                            has8888888 = true;
                            TotalRVPriceOverride = 8888888.00;
                      }
                    if(has8888888 == false && has9999999==false )
                      {
                            TotalRVPriceOverride += priceOverride;
                      }
                    
                    priceelements.add(RVPricingRecord.Pricing_Element__c);
                        
                        priceWrapper priceWrapperInstance = new priceWrapper();
                    	priceWrapperInstance.rvPrice = RVPricingRecord;
                        priceWrapperInstance.rvPriceOverride = priceOverride.setScale(2);
                        RVPriceWrapperList.add(priceWrapperInstance);
                    }
                }
                system.debug('##PosSetPresOSIG__c : '+conRV.PosSetPresOSIG__c);
                system.debug('###WeightPressure: '+ WeightMap.containsKey('WeightPressure'));
                if(WeightMap.containsKey('WeightPressure') && conRV.PosSetPresOSIG__c != null)
                {
                    System.debug('*** utility Element weight = '+WeightMap.get('WeightPressure').Pricing_Element__c+', Price = '+WeightMap.get('WeightPressure').Price__c);
                    Decimal SettingMinPressure = 0.0, WeightSettingPressure = 0.0;
                    if(WeightMap.containsKey('SettingMinPressure'))
                    {
                        SettingMinPressure = WeightMap.get('SettingMinPressure').Price__c;
                    }
                    if(WeightMap.containsKey('WeightSettingPressure'))
                    {
                        WeightSettingPressure = WeightMap.get('WeightSettingPressure').Price__c;
                    }
                    WeightMap.get('WeightPressure').Price__c = (Math.max(((conRV.PosSetPresOSIG__c  - SettingMinPressure) * WeightSettingPressure), 0)).setScale(2);
                    System.debug('--> conRV.PosSetPresOSIG__c = '+conRV.PosSetPresOSIG__c+', SettingMinPressure = '+SettingMinPressure+', WeightSettingPressure = '+WeightSettingPressure+', Price = '+WeightMap.get('WeightPressure').Price__c);
					String fieldAPI = 'WeightPressure__c';
                    Decimal priceOverride = 0.00;
                    System.debug('&--> '+rvOutput);
                    System.debug('&--> '+rvOutput.get(fieldAPI));
                    if(rvOutput.get(fieldAPI) == null)
                    {
                        rvOutput.put(fieldAPI, WeightMap.get('WeightPressure').Price__c);
                        priceOverride = WeightMap.get('WeightPressure').Price__c;
                    }
                    else
                    {
                        priceOverride = (Decimal)rvOutput.get(fieldAPI);
                    }
                    if(priceOverride == 9999999)
                      {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999.00;
                      }
                    if(priceOverride == 8888888 && has9999999==false)
                      {
                            has8888888 = true;
                            TotalRVPriceOverride = 8888888.00;
                      }
                    if(has8888888 == false && has9999999==false )
                      {
                            TotalRVPriceOverride += priceOverride;
                      }
                    priceWrapper priceWrapperInstance = new priceWrapper();
                    priceWrapperInstance.rvPrice = WeightMap.get('WeightPressure');
                    system.debug('###WeightPressure : '+ WeightMap.get('WeightPressure'));
                    priceWrapperInstance.rvPriceOverride = priceOverride.setScale(2);
                    RVPriceWrapperList.add(priceWrapperInstance);
                }
                if(WeightMap.containsKey('WeightVacuum') && conRV.VacSetPresOSIG__c != null)
                {
                    Decimal SettingMinVacuum = 0.0, WeightSettingVacuum = 0.0;
                    if(WeightMap.containsKey('SettingMinVacuum'))
                    {
                        SettingMinVacuum = WeightMap.get('SettingMinVacuum').Price__c;
                    }
                    if(WeightMap.containsKey('WeightSettingVacuum'))
                    {
                        WeightSettingVacuum = WeightMap.get('WeightSettingVacuum').Price__c;
                    }
                    WeightMap.get('WeightVacuum').Price__c = (Math.max(((conRV.VacSetPresOSIG__c  - SettingMinVacuum) * WeightSettingVacuum), 0)).setScale(2);

                    System.debug('--> conRV.VacSetPresOSIG__c = '+conRV.VacSetPresOSIG__c+', SettingMinVacuum = '+SettingMinVacuum+', WeightSettingVacuum = '+WeightSettingVacuum+', Price = '+WeightMap.get('WeightVacuum').Price__c);

                    String fieldAPI = 'WeightVacuum__c';
                    Decimal priceOverride = 0.00;
                    if(rvOutput.get(fieldAPI) == null)
                    {                      
                        rvOutput.put(fieldAPI, WeightMap.get('WeightVacuum').Price__c);
                        priceOverride = WeightMap.get('WeightVacuum').Price__c;
                    }
                    else
                    {
                        priceOverride = (Decimal)rvOutput.get(fieldAPI);
                        System.debug('PPPPPPP  priceOverride' + priceOverride);
                        System.debug('PPPPPPP' + WeightMap.get('WeightVacuum').Price__c);
                    }
             		if(priceOverride == 9999999)
                      {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999.00;
                      }
                    if(priceOverride == 8888888 && has9999999==false)
                      {
                            has8888888 = true;
                            TotalRVPriceOverride = 8888888.00;
                      }
                    if(has8888888 == false && has9999999==false )
                      {
                            TotalRVPriceOverride += priceOverride;
                      }
                    priceWrapper priceWrapperInstance = new priceWrapper();
                    priceWrapperInstance.rvPrice = WeightMap.get('WeightVacuum');
                    priceWrapperInstance.rvPriceOverride = priceOverride.setScale(2);
                    RVPriceWrapperList.add(priceWrapperInstance);
                }

                // Adding price for missing Pricing elements with 8888888 as a dummy price
            	for (sObject sobj1:pricelementss)
                {
                    RV_Valve_Price_Details__c  RVPricingRecord2 = new RV_Valve_Price_Details__c ();
                    RVPricingRecord2 = (RV_Valve_Price_Details__c )sobj1;      
                    string fieldAPI;
                    if(RVPricingRecord2.Pricing_Element__c!='SettingMinPressure' && RVPricingRecord2.Pricing_Element__c!='WeightSettingPressure' 
                           && RVPricingRecord2.Pricing_Element__c!='SettingMinVacuum' && RVPricingRecord2.Pricing_Element__c!='WeightSettingVacuum' 
                      && RVPricingRecord2.Pricing_Element__c!='WeightPressure' && RVPricingRecord2.Pricing_Element__c!='WeightVacuum')
                    {
                        fieldAPI = RVPricingRecord2.Pricing_Element__c;
                      if(RVPricingRecord2.Pricing_Element__c != null && !priceelements.contains(RVPricingRecord2.Pricing_Element__c))
                      {                            
                          if( RVPricingRecord2.Pricing_Element__c.contains(' '))
                          {
                              fieldAPI = fieldAPI.replace(' ', '_');
                          }
                       
                            fieldAPI = fieldAPI+'__c';
                            Decimal priceOverride;
                            if(rvOutput.get(fieldAPI) == null)
                            {
                                rvOutput.put(fieldAPI, 8888888.00); //RVPricingRecord2.Price__c
                                priceOverride = 8888888.00;
                            }
                            else
                            {
                                priceOverride = (Decimal)rvOutput.get(fieldAPI);
                            }

                            if(has9999999==false && priceOverride==8888888)
                            {
                                has8888888 = true;
                                TotalRVPriceOverride = 8888888.00;                          
                            }
                            if(has8888888 == false && has9999999==false )
                            {
                                TotalRVPriceOverride += priceOverride;
                            }
                            RVPricingRecord2.Price__c=8888888.00;
                            priceWrapper priceWrapperInstance = new priceWrapper();
                            priceWrapperInstance.rvPrice =RVPricingRecord2;
                            priceWrapperInstance.rvPriceOverride =priceOverride.setScale(2); //priceOverride.setScale(2);
                            RVPriceWrapperList.add(priceWrapperInstance);
                        }                     
                    }
                   }             
                
                if(conRV.Quantity__c != null && conRV.Quantity__c != 0)
                {
                    if(has9999999==false && has8888888==false)
                    {
                        if((Decimal)rvOutput.get('NACE__c') != null)
                        {
                            NonDiscountablePriceEach = (Decimal)rvOutput.get('NACE__c');
                        }
                        if((Decimal)rvOutput.get('CUTR__c') != null)
                        {
                            NonDiscountablePriceEach = NonDiscountablePriceEach + (Decimal)rvOutput.get('CUTR__c');
                        }
                        system.debug('@@Non Discountable price : '+NonDiscountablePriceEach);
                        TotalRVPriceOverride = TotalRVPriceOverride - NonDiscountablePriceEach;
                        ListPriceEach=(TotalRVPriceOverride + ( NonDiscountablePriceEach / conRV.Quantity__c)).setScale(2);
                        conRV.List_Price_Each__c = ListPriceEach;
                        System.debug('Price List Each---Normal' +conRV.List_Price_Each__c);
                        System.debug('Price List Each---Total' +TotalRVPriceOverride);
                        conRV.Discountable_Price__c = TotalRVPriceOverride;
                    }      
                    if(has9999999==true)
                    {
                        ListPriceEach = TotalRVPriceOverride;
                        conRV.List_Price_Each__c=ListPriceEach;
                        System.debug('Price List Each---999999999' +conRV.List_Price_Each__c);
                        conRV.Discountable_Price__c = TotalRVPriceOverride;
                    } 
                    else if(has8888888==true){
                        ListPriceEach = TotalRVPriceOverride;
                        conRV.List_Price_Each__c=ListPriceEach;
                        conRV.Discountable_Price__c = TotalRVPriceOverride;
                    }
                    conRV.Non_Discountable_Price__c = NonDiscountablePriceEach;
                    if(!Test.isRunningTest())
                    {
                        quoteLine.Non_Discountable_List_Price__c =  conRV.Non_Discountable_Price__c;
                        quoteLine.Discountable_List_Price__c = conRV.Discountable_Price__c;
                        
                        if(!notValidStatusForChng.contains(strQuoteStatus)){
                            upsert quoteLine;
                        }
                    }
                }
            }
        }
    }

    //* @ Apply Default Override for Pricing
    public pageReference ApplyDefaultPricing()
    {
        // if(editOkayForQuoteLine(quoteLine) == false){
        //     return null;
        // }
        boolean has9999999=false;
        boolean has8888888=false;
        if(conRV.Price_Engineer_Override__c == false && RVPriceWrapperList != null && RVPriceWrapperList.size() > 0)
        {
            TotalRVPrice = 0.0;
            TotalRVPriceOverride = 0.0;
            for(priceWrapper prv : RVPriceWrapperList)
            {
                if(String.isNotBlank(prv.rvPrice.Pricing_Element__c))
                {
                    String fieldAPI = prv.rvPrice.Pricing_Element__c;
                    if(prv.rvPrice.Pricing_Element__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    fieldAPI = fieldAPI+'__c';
                    rvOutput.put(fieldAPI, prv.rvPrice.Price__c);
                    if(prv.rvPrice.Price__c != 9999999 && prv.rvPrice.Price__c != 8888888)
                    {
                        TotalRVPrice += prv.rvPrice.Price__c;
                        TotalRVPriceOverride += prv.rvPrice.Price__c;
                    }
                }
            }
            if(conRV.Quantity__c != null && conRV.Quantity__c != 0)
            {
                if(has9999999==false && has8888888==false)
                {
                    if((Decimal)rvOutput.get('NACE__c') != null)
                    {
                        NonDiscountablePriceEach = (Decimal)rvOutput.get('NACE__c');
                    }
                    if((Decimal)rvOutput.get('CUTR__c') != null)
                    {
                        NonDiscountablePriceEach = NonDiscountablePriceEach + (Decimal)rvOutput.get('CUTR__c');
                    }
                    TotalRVPriceOverride = TotalRVPriceOverride - NonDiscountablePriceEach;
                    ListPriceEach=TotalRVPriceOverride + ( NonDiscountablePriceEach / conRV.Quantity__c);
                    conRV.List_Price_Each__c = ListPriceEach;
                    System.debug('Price List Each---Normal' +conRV.List_Price_Each__c);
                    conRV.Discountable_Price__c = TotalRVPriceOverride;
                }      
                if(has9999999==true)
                {
                    ListPriceEach = TotalRVPriceOverride;
                    conRV.List_Price_Each__c=ListPriceEach;
                    System.debug('Price List Each---999999999' +conRV.List_Price_Each__c);
                    conRV.Discountable_Price__c = TotalRVPriceOverride;
                } 
                else if(has8888888==true){
                    ListPriceEach = TotalRVPriceOverride;
                    conRV.List_Price_Each__c=ListPriceEach;
                    conRV.Discountable_Price__c = TotalRVPriceOverride;
                }
                conRV.Non_Discountable_Price__c = NonDiscountablePriceEach;
            }
                upsert rvOutput;
        }
        update conRV;
        getPricingRecords();
        return null;
    }

    //* @ Save Price Override on click on save
    Public pageReference SavePriceOverride()
    {
        // if(editOkayForQuoteLine(quoteLine) == false){
        //     return null;
        // }
        boolean has9999999=false;
        boolean has8888888=false;
        if(RVPriceWrapperList != null && RVPriceWrapperList.size() > 0)
        {
            TotalRVPriceOverride = 0.0;
            for(priceWrapper prv : RVPriceWrapperList)
            {
                if(String.isNotBlank(prv.rvPrice.Pricing_Element__c))
                {
                    String fieldAPI = prv.rvPrice.Pricing_Element__c;
                    if(prv.rvPrice.Pricing_Element__c.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    fieldAPI = fieldAPI+'__c';
                    rvOutput.put(fieldAPI, prv.rvPriceOverride);
                    System.debug('---> fieldAPI = '+fieldAPI+', prv.rvPriceOverride = '+rvOutput.get(fieldAPI));
                } 
                if(prv.rvPriceOverride != 9999999 && prv.rvPriceOverride != 8888888)
                    {
                        TotalRVPrice +=prv.rvPriceOverride;
                        TotalRVPriceOverride += prv.rvPriceOverride;
                    }
                    if(prv.rvPriceOverride == 9999999)
                    {
                        has9999999=true;
                        TotalRVPriceOverride=9999999.00;
                    }                    
                    if(prv.rvPriceOverride == 8888888 && has9999999==false)
                    {
                        has8888888=true;
                        TotalRVPriceOverride=8888888.00;
                    }
                    rvOutput.Total_Price__c = TotalRVPriceOverride;
            }
            if(conRV.Quantity__c != null && conRV.Quantity__c != 0)
            {
                if(has9999999==false && has8888888==false)
                {
                    if((Decimal)rvOutput.get('NACE__c') != null)
                    {
                        NonDiscountablePriceEach = (Decimal)rvOutput.get('NACE__c');
                    }
                    if((Decimal)rvOutput.get('CUTR__c') != null)
                    {
                        NonDiscountablePriceEach = NonDiscountablePriceEach + (Decimal)rvOutput.get('CUTR__c');
                    }
                    system.debug('@@Non Discountable price : '+NonDiscountablePriceEach);
                    TotalRVPriceOverride = TotalRVPriceOverride - NonDiscountablePriceEach;
                    ListPriceEach=TotalRVPriceOverride + ( NonDiscountablePriceEach / conRV.Quantity__c);
                    conRV.List_Price_Each__c = ListPriceEach;
                    System.debug('Price List Each---Normal' +conRV.List_Price_Each__c);
                    conRV.Discountable_Price__c = TotalRVPriceOverride;
                }      
                if(has9999999==true)
                {
                    ListPriceEach = TotalRVPriceOverride;
                    conRV.List_Price_Each__c=ListPriceEach;
                    System.debug('Price List Each---999999999' +conRV.List_Price_Each__c);
                    conRV.Discountable_Price__c = TotalRVPriceOverride;
                } 
                else if(has8888888==true){
                    ListPriceEach = TotalRVPriceOverride;
                    conRV.List_Price_Each__c=ListPriceEach;
                    conRV.Discountable_Price__c = TotalRVPriceOverride;
                }
                conRV.Non_Discountable_Price__c = NonDiscountablePriceEach;
            }
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Non_Discountable_List_Price__c =  conRV.Non_Discountable_Price__c;
                quoteLine.Discountable_List_Price__c = conRV.Discountable_Price__c;
                if(!Test.isRunningTest())
                {
                    upsert quoteLine;
                }
            }
            upsert rvOutput;
            update conRV;
        }
        return null;
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
    public void getLeadTimeRecords()
    {
        RVLeadTimeList.clear();
        Total10 = 0;
        Total20 = 0;
        Total30 = 0;
        Total40 = 0;
        Total10Override = 0;
        Total20Override = 0;
        Total30Override = 0;
        Total40Override = 0;
        Set<integer> site10=new Set<integer>();
        Set<integer> site20=new Set<integer>();
        Set<integer> site30=new Set<integer>();
        Set<integer> site40=new Set<integer>();
        if(selectedTab == 'ProductReview' || selectedTab == 'Pricing' || conRV.Finish_Configuration_Flag__c == True)
        {
            Result leadResult = RVOU.getLeadTime();
            system.debug('@@ Lead time result: '+leadResult.objResultList);
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
                for(sObject sobj : leadResult.objResultList)
                {
                    RV_Valve_Lead_Time_Details__c leadtimeDetail = (RV_Valve_Lead_Time_Details__c)sobj;
                    system.debug('Vin *** leadtimeDetail'+leadtimeDetail);
                    if(String.isNotBlank(leadtimeDetail.RunTimeSchedule__c))
                    {
                        runTimeSchedule.add(leadtimeDetail.RunTimeSchedule__c);
                        scheduleVsItem.put(leadtimeDetail.RunTimeSchedule__c, leadtimeDetail.Lead_Time_Item_No__c);
                        if(!scheduleVsAllItem.containsKey(leadtimeDetail.RunTimeSchedule__c))
                        {
                            scheduleVsAllItem.put(leadtimeDetail.RunTimeSchedule__c, new List<String>());
                        }
                        scheduleVsAllItem.get(leadtimeDetail.RunTimeSchedule__c).add(leadtimeDetail.Lead_Time_Item_No__c);
                    }
                    if(String.isNotBlank(leadtimeDetail.QueueTimeSchedule__c))
                    {
                        queueTimeSchedule.add(leadtimeDetail.QueueTimeSchedule__c);
                        scheduleVsItem.put(leadtimeDetail.QueueTimeSchedule__c, leadtimeDetail.Lead_Time_Item_No__c);
                        if(!scheduleVsAllItem.containsKey(leadtimeDetail.QueueTimeSchedule__c))
                        {
                            scheduleVsAllItem.put(leadtimeDetail.QueueTimeSchedule__c, new List<String>());
                        }
                        scheduleVsAllItem.get(leadtimeDetail.QueueTimeSchedule__c).add(leadtimeDetail.Lead_Time_Item_No__c);
                        
                    }
                }
                System.debug('**** queueTimeSchedule = '+queueTimeSchedule+', runTimeSchedule = '+runTimeSchedule);
                if(conRV.Quantity__c != null &&(runTimeSchedule.size() > 0 || queueTimeSchedule.size() > 0))
                {
                    for(GlobalLeadTime__c leadValue: [SELECT Id,Schedule__c,X10__c,X20__c,X30__c,X40__c
                                                      FROM GlobalLeadTime__c
                                                      WHERE (Schedule__c IN:runTimeSchedule OR Schedule__c IN: queueTimeSchedule)
                                                      AND QtyLL__c <=: conRV.Quantity__c AND QtyUL__c >: conRV.Quantity__c])
                    {
                        if(scheduleVsAllItem.containsKey(leadValue.Schedule__c))
                        {
                            for(String leadSchedule: scheduleVsAllItem.get(leadValue.Schedule__c))
                            {
                                String fieldAPI = leadSchedule;
                                if(fieldAPI.contains(' '))
                                {
                                    fieldAPI = fieldAPI.replace(' ', '_');
                                }	              
                                String x10API = fieldAPI+'_10__c';
                                System.debug('@@@ fieldAPI = '+fieldAPI+', x10API = '+x10API+', X10__c = '+leadValue.X10__c+', override = '+rvOutput.get(x10API));
                                if(rvOutput.get(x10API) == null)
                                {
                                    rvOutput.put(x10API, leadValue.X10__c);
                                }
                                String x20API = fieldAPI+'_20__c';
                                if(rvOutput.get(x20API) == null)
                                {
                                    rvOutput.put(x20API, leadValue.X20__c);
                                }
                                String x30API = fieldAPI+'_30__c';
                                if(rvOutput.get(x30API) == null)
                                {
                                    rvOutput.put(x30API, leadValue.X30__c);
                                }
                                String x40API = fieldAPI+'_40__c';
                                if(rvOutput.get(x40API) == null)
                                {
                                    rvOutput.put(x40API, leadValue.X40__c);
                                }
                                System.debug('@@@ X10__c = '+leadValue.X10__c+', override = '+rvOutput.get(x10API));
                                if(queueTimeSchedule.contains(leadValue.Schedule__c))
                                {
                                    Decimal xValue = leadValue.X10__c;
                                    if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x10)
                                    {
                                        queueTimeItemMap.get('QueueTimeItem').x10 = Integer.valueOf(xValue);
                                        queueTimeItemMap.get('QueueTimeItem').x10Override = Integer.valueOf(rvOutput.get('Queue_Time_10__c'));
                                        queueTimeItemMap.get('QueueTimeItem').queue10Id = leadValue.Id;
                                    }
                                    xValue = leadValue.X20__c;
                                    if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x20)
                                    {
                                        queueTimeItemMap.get('QueueTimeItem').x20 = Integer.valueOf(xValue);
                                        queueTimeItemMap.get('QueueTimeItem').x20Override = Integer.valueOf(rvOutput.get('Queue_Time_20__c'));
                                        queueTimeItemMap.get('QueueTimeItem').queue20Id = leadValue.Id;
                                    }
                                    xValue = leadValue.X30__c;
                                    if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x30)
                                    {
                                        queueTimeItemMap.get('QueueTimeItem').x30 = Integer.valueOf(xValue);
                                        queueTimeItemMap.get('QueueTimeItem').x30Override = Integer.valueOf(rvOutput.get('Queue_Time_30__c'));
                                        queueTimeItemMap.get('QueueTimeItem').queue30Id = leadValue.Id;
                                    }
                                    xValue = leadValue.X40__c;
                                    if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x40)
                                    {
                                        queueTimeItemMap.get('QueueTimeItem').x40 = Integer.valueOf(xValue);
                                        queueTimeItemMap.get('QueueTimeItem').x40Override = Integer.valueOf(rvOutput.get('Queue_Time_40__c'));
                                        queueTimeItemMap.get('QueueTimeItem').queue40Id = leadValue.Id;
                                    }
                                } 
                                else
                                {
                                    LeadTimeWrapper runTimeItem = new LeadTimeWrapper();
                                    runTimeItem.leadTimeRec = leadValue;
                                    runTimeItem.item = fieldAPI;
                                    runTimeItem.x10 = Integer.valueOf(leadValue.X10__c);
                                    runTimeItem.x20 = Integer.valueOf(leadValue.X20__c);
                                    runTimeItem.x30 = Integer.valueOf(leadValue.X30__c);
                                    runTimeItem.x40 = Integer.valueOf(leadValue.X40__c);
                                    if(conRv.Lead_Time_Override__c == false)
                                    {
                                        runTimeItem.x10Override = runTimeItem.x10;
                                        runTimeItem.x20Override = runTimeItem.x20;
                                        runTimeItem.x30Override = runTimeItem.x30;
                                        runTimeItem.x40Override = runTimeItem.x40;
                                    }
                                    else
                                    {
                                        runTimeItem.x10Override = Integer.valueOf(rvOutput.get(x10API));
                                        runTimeItem.x20Override = Integer.valueOf(rvOutput.get(x20API));
                                        runTimeItem.x30Override = Integer.valueOf(rvOutput.get(x30API));
                                        runTimeItem.x40Override = Integer.valueOf(rvOutput.get(x40API));
                                    }
                                    Total10 = computeTotal(Total10, runTimeItem.x10);
                                    Total20 = computeTotal(Total20, runTimeItem.x20);
                                    Total30 = computeTotal(Total30, runTimeItem.x30);
                                    Total40 = computeTotal(Total40, runTimeItem.x40);
                                    Total10Override = computeTotal(Total10Override, runTimeItem.x10Override);
                                    Total20Override = computeTotal(Total20Override, runTimeItem.x20Override);
                                    Total30Override = computeTotal(Total30Override, runTimeItem.x30Override);
                                    Total40Override = computeTotal(Total40Override, runTimeItem.x40Override);
                                    site10.add(Total10Override);
                                    site20.add(Total20Override);
                                    site30.add(Total30Override);
                                    site40.add(Total40Override);
                                    RVLeadTimeList.add(runTimeItem);
                                }
                            }
                        }
                        System.debug('**** leadValue = '+leadValue);
                    }
                    System.debug('**** Queue time = '+queueTimeItemMap.get('QueueTimeItem'));
                    if(conRv.Lead_Time_Override__c == false)
                    {
                        queueTimeItemMap.get('QueueTimeItem').x10Override = queueTimeItemMap.get('QueueTimeItem').x10;
                        queueTimeItemMap.get('QueueTimeItem').x20Override = queueTimeItemMap.get('QueueTimeItem').x20;
                        queueTimeItemMap.get('QueueTimeItem').x30Override = queueTimeItemMap.get('QueueTimeItem').x30;
                        queueTimeItemMap.get('QueueTimeItem').x40Override = queueTimeItemMap.get('QueueTimeItem').x40;
                    }
                    RVLeadTimeList.add(queueTimeItemMap.get('QueueTimeItem'));
                    Total10 = computeTotal(Total10, queueTimeItem.x10);
                    Total20 = computeTotal(Total20, queueTimeItem.x20);
                    Total30 = computeTotal(Total30, queueTimeItem.x30);
                    Total40 = computeTotal(Total40, queueTimeItem.x40);
                    Total10Override = computeTotal(Total10Override, queueTimeItem.x10Override);
                    conRV.Lead_Time_Site_10__c = Total10Override;
                    Total20Override = computeTotal(Total20Override, queueTimeItem.x20Override);
                    conRV.Lead_Time_Site_20__c = Total20Override;
                    Total30Override = computeTotal(Total30Override, queueTimeItem.x30Override);
                    conRV.Lead_Time_Site_30__c = Total30Override;
                    Total40Override = computeTotal(Total40Override, queueTimeItem.x40Override);
                    conRV.Lead_Time_Site_40__c = Total40Override;
                    site10.add(Total10Override);
                    site20.add(Total20Override);
                    site30.add(Total30Override);
                    site40.add(Total40Override);
                }
            }
            if(site10.contains(7777))
                Total10Override=7777;
            else if(site10.contains(4995))
                Total10Override=4995;
            else
                Total10Override=Total10Override;
            
            if(site20.contains(7777))
                Total20Override=7777;
            else if(site20.contains(4995))
                Total20Override=4995;
            else
                Total20Override=Total20Override;
            
            if(site30.contains(7777))
                Total30Override=7777;
            else if(site30.contains(4995))
                Total30Override=4995;
            else
                Total30Override=Total30Override;
            
            if(site40.contains(7777))
                Total40Override=7777;
            else if(site40.contains(4995))
                Total40Override=4995;
            else
                Total40Override=Total40Override;
            
        }
        conRV.Lead_Time_Site_10__c = Total10Override;
        conRV.Lead_Time_Site_20__c = Total20Override;
        conRV.Lead_Time_Site_30__c = Total30Override;
        conRV.Lead_Time_Site_40__c = Total40Override;
        System.debug('VVVVV 10 = '+conRV.Lead_Time_Site_10__c+', 20 = '+conRV.Lead_Time_Site_20__c+', 30 = '+conRV.Lead_Time_Site_30__c+', 40 = '+conRV.Lead_Time_Site_40__c);
        //saveLeadTime();
        //ApplyDefaultLeadtime();
        
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
        if(RVLeadTimeList.size() > 0)
        {
            //Map<Id,GlobalLeadTime__c> globalLeadTimeMap = new Map<Id,GlobalLeadTime__c>();
            for(LeadTimeWrapper rvlead: RVLeadTimeList)
            {
                String fieldAPI = rvlead.item;
                if(fieldAPI.contains(' '))
                {
                    fieldAPI = fieldAPI.replace(' ', '_');
                }
                String x10API = fieldAPI+'_10__c';
                rvOutput.put(x10API, rvlead.x10Override);
                String x20API = fieldAPI+'_20__c';
                rvOutput.put(x20API, rvlead.x20Override);
                String x30API = fieldAPI+'_30__c';
                rvOutput.put(x30API, rvlead.x30Override);
                String x40API = fieldAPI+'_40__c';
                rvOutput.put(x40API, rvlead.x40Override);
                System.debug('@@@ fieldAPI = '+fieldAPI+', x10API = '+rvOutput.get(x10API)+', x20API = '+rvOutput.get(x20API)+', x30API = '+rvOutput.get(x30API)+', x40API = '+rvOutput.get(x40API));
                /*
                if(rvlead.leadTimeRec != null)
                {
                    globalLeadTimeMap.put(rvlead.leadTimeRec.Id,rvlead.leadTimeRec);
                }
                else
                {
                    if(rvlead.queue10Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(rvlead.queue10Id))
                        {
                            globalLeadTimeMap.get(rvlead.queue10Id).X10_Override__c = rvlead.x10Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = rvlead.queue10Id, X10_Override__c = rvlead.x10Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                    if(rvlead.queue20Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(rvlead.queue20Id))
                        {
                            globalLeadTimeMap.get(rvlead.queue20Id).X20_Override__c = rvlead.x20Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = rvlead.queue20Id, X20_Override__c = rvlead.x20Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                    if(rvlead.queue30Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(rvlead.queue30Id))
                        {
                            globalLeadTimeMap.get(rvlead.queue30Id).X30_Override__c = rvlead.x30Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = rvlead.queue30Id, X30_Override__c = rvlead.x30Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                    if(rvlead.queue40Id != null)
                    {
                        if(globalLeadTimeMap.containsKey(rvlead.queue40Id))
                        {
                            globalLeadTimeMap.get(rvlead.queue40Id).X40_Override__c = rvlead.x40Override;
                        }
                        else
                        {
                            GlobalLeadTime__c queueLead = new GlobalLeadTime__c(Id = rvlead.queue40Id, X40_Override__c = rvlead.x40Override);
                            globalLeadTimeMap.put(queueLead.Id,queueLead);
                        }
                    }
                }*/
            }
            System.debug(' rvOutput = '+rvOutput);
            upsert rvOutput;
            /*if(globalLeadTimeMap.size() > 0)
            {
                update globalLeadTimeMap.values();
            }*/
            getLeadTimeRecords();
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                // quoteLine.Config_Record_Id__c = ConRV.id;
                // quoteLine.SBQQ__Quantity__c=ConRV.Quantity__c;
                // quoteLine.Engineering_Notes__c = ConRV.Engineering_Notes__c;
                // quoteLine.Non_Discountable_List_Price__c =  conRV.Non_Discountable_Price__c;
                // quoteLine.Discountable_List_Price__c = conRV.Discountable_Price__c;
                quoteLine.Leadtime_Site_10__c = ConRV.Lead_Time_Site_10__c;
                quoteLine.Leadtime_Site_20__c = ConRV.Lead_Time_Site_20__c;
                quoteLine.Leadtime_Site_30__c = ConRV.Lead_Time_Site_30__c;
                quoteLine.Leadtime_Site_40__c = ConRV.Lead_Time_Site_40__c;
                if(!Test.isRunningTest())
                {
                    upsert quoteLine;
                }
            }
        }
        return null;
    }

    //* @ Apply Default Override for Lead time
  public pageReference ApplyDefaultLeadtime()
  {
      update conRV;
      if(conRV.Lead_Time_Override__c == false)
      {
          if(RVLeadTimeList != null && RVLeadTimeList.size() > 0)
          {
                for(LeadTimeWrapper rvlead: RVLeadTimeList)
                {
                    String fieldAPI = rvlead.item;
                    if(fieldAPI.contains(' '))
                    {
                        fieldAPI = fieldAPI.replace(' ', '_');
                    }
                    String x10API = fieldAPI+'_10__c';
                    rvOutput.put(x10API, rvlead.x10);
                    String x20API = fieldAPI+'_20__c';
                    rvOutput.put(x20API, rvlead.x20);
                    String x30API = fieldAPI+'_30__c';
                    rvOutput.put(x30API, rvlead.x30);
                    String x40API = fieldAPI+'_40__c';
                    rvOutput.put(x40API, rvlead.x40);
                    /*    
                    if(rvlead.leadTimeRec != null)
                    {
                        rvlead.leadTimeRec.X10_Override__c = rvlead.leadTimeRec.X10__c;
                        rvlead.leadTimeRec.X20_Override__c = rvlead.leadTimeRec.X20__c;
                        rvlead.leadTimeRec.X30_Override__c = rvlead.leadTimeRec.X30__c;
                        rvlead.leadTimeRec.X40_Override__c = rvlead.leadTimeRec.X40__c;
                    }
                    else
                    {
                        rvlead.x10Override = rvlead.x10;
                        rvlead.x20Override = rvlead.x20;
                        rvlead.x30Override = rvlead.x30;
                        rvlead.x40Override = rvlead.x40;
                    }*/
                    upsert rvOutput;
                }
              //return saveLeadTime();
              getLeadTimeRecords();
          }
      }
      return null;
  }

 /*
  @Method to get Quote description values to be shown on the VF page
 */
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
  public RV_Outputs__c rvOutsideInstance;
  public void GetQuoteDescriptionRecords()
  {
      //AttributeDescription = ' ';
      quoteAttriVsDesc = new Map<String, String>();
      quoteDescriptionList.clear();
      boolean hasOA01inList = false, hasOA250inList = false;
      string OB250p1,OB250p2;
      if(conRV.Finish_Configuration_Flag__c)
      {
          quoteAttriVsDesc = RVOU.GetAttributeMapQuoteDescription();
          rvOutsideInstance = getQuoteRVOutputInstance();
          conRV.OA01__c = 'Model: ' + RVOU.GMODEL;
          for(String attribute: quoteAttriVsDesc.keySet())
          {
              String attributeFieldAPI = attribute+'__c';
              conRV.put(attributeFieldAPI,quoteAttriVsDesc.get(attribute));
              //System.debug('*** attributeFieldAPI = '+attributeFieldAPI+', conrv value = '+conRV.get(attributeFieldAPI));
          }
          conRV.OA__c = conRV.OA01__c;
          conRV.OB__c = '';
          conRV.OW__c = '';
          conRV.PC__c = '';

          for(String attribute: quoteAttriVsDesc.keySet())
          {
            //   if(attribute != 'OB050')
            //   {
                  String attributeValue = conRV.get(attribute+'__c')+'';
                  System.debug('*** attribute = '+attribute+'__c, value = '+attributeValue);
                  if(attribute.startsWith('OA') && String.isNotBlank(attributeValue))
                  {
                    conRV.OA__c += '\n' + attributeValue;
                  }
                  else if(attribute.startsWith('OB') && String.isNotBlank(attributeValue))
                  {
                    conRV.OB__c += '\n' + attributeValue;
                  }
                  else if(attribute.startsWith('OW') && String.isNotBlank(attributeValue))
                  {
                      if(String.isBlank(conRV.OW__c))
                      {
                        conRV.OW__c = attributeValue;
                      }
                      else
                      {
                        conRV.OW__c += '\n' + attributeValue;
                      }
                  }
                  else if(attribute.startsWith('PC') && String.isNotBlank(attributeValue))
                  {
                      if(String.isBlank(conRV.PC__c))
                      {
                        conRV.PC__c = attributeValue;
                      }
                      else
                      {
                        conRV.PC__c += '\n' + attributeValue;
                      }
                  }
              //}
          }
          Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW','PC'};
          for(String quoteAttribute: quotesAttributeSet)
          {
              String fieldAPI = quoteAttribute+'__c';
              String quoteRow = (String)conRV.get(fieldAPI);
              //System.debug('*** fieldAPI = '+fieldAPI+', quoteRow = '+quoteRow);
              if(String.isNotBlank(quoteRow))
              {
                  QuoteDescriptionWrapper quoteDescription = new QuoteDescriptionWrapper();
                  quoteDescription.quotes = quoteAttribute;
                  quoteDescription.descriptionList = new List<String>();
                  quoteDescription.overridedescriptionList = new List<String>();
                  String descriptionValue = conRV.get(fieldAPI)+'';
                  for(String dec : descriptionValue.split('\n'))
                  {
                      quoteDescription.descriptionList.add(dec);
                  }
                  quoteDescription.description = conRV.get(fieldAPI)+'';
                  //System.debug('*** rvOutsideInstance = '+rvOutsideInstance.get(quoteAttribute+'_Override__c'));
                  if(rvOutsideInstance.get(quoteAttribute+'_Override__c') == null)
                  {
                      quoteDescription.overrideDescription = conRV.get(fieldAPI)+'';
                  }
                  else
                  {
                      quoteDescription.overrideDescription = (String)rvOutsideInstance.get(quoteAttribute+'_Override__c');
                  }
                  if(conRV.Quote_Description_Engineer_Override__c == true && quoteAttribute == 'OA')
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
          //system.debug('***Quote Desc'+BGRQuoteDescList);
          //return quoteDescriptionList;
          //conRV.Part_Number_Base__c = RVOU.BRAND + RVOU.PNMODEL + RVOU.SZC + RVOU.MCBODY + RVOU.MCSEAT + RVOU.PNMCPALL + RVOU.PNMCDPHM + RVOU.HCLASS;
          String strBRANDCODE='';
          if(ConRV.Brand__c!=null)
          {
              if(ConRV.Brand__c=='Groth')
                  strBRANDCODE='V';
              else if(ConRV.Brand__c=='CDC')
                  strBRANDCODE='D';
              else if(ConRV.Brand__c=='LaMOT')
                  strBRANDCODE='T';
              else if(ConRV.Brand__c=='LVA')
                  strBRANDCODE='L';
              else
                  strBRANDCODE='';
          }
          String strSZC=RVOU.SZC;
                    integer strLEN=strSZC.length();
                    if(strLEN<2)
                       strSZC='0'+strSZC;
                    else
                       strSZC=strSZC;
          if(string.isBlank(conRV.Part_Number_Base__c))
          {
              conRV.Part_Number_Base__c = strBRANDCODE + RVOU.PNMODEL +strSZC + RVOU.MCBODY + RVOU.MCSEAT + RVOU.PNMCPALL + RVOU.PNMCDPHM + RVOU.HCLASS;
          }
      }
      update ConRV;
    }

     //* @ Apply Default Override for Quote Description
    public pageReference ApplyDefaultQuoteDescription()
    {
        if(conRV.Quote_Description_Engineer_Override__c == false)
        {
            Set<String> quotesAttributeSet = new Set<String>{'OA','OB','OW','PC'};
            for(String quoteAttribute: quotesAttributeSet)
            {
                String attributeFieldAPI = quoteAttribute+'_Override__c';
                String attributeValue = (String)conRV.get(quoteAttribute+'__c');
                system.debug(attributeFieldAPI);
                system.debug(attributeValue);
                system.debug(rvOutsideInstance);
                rvOutsideInstance.put(attributeFieldAPI, attributeValue);
            }
            System.debug('@@rvOutsideInstance' +rvOutsideInstance);
            update rvOutsideInstance;
            GetQuoteDescriptionRecords();
            if(!Test.isRunningTest()) 
            {
                if(!notValidStatusForChng.contains(strQuoteStatus)) 
                {
                    quoteLine.SBQQ__Description__c=strquoteDes;
                    upsert quoteLine;
                }
            }
            String strBRANDCODE='';
          if(ConRV.Brand__c!=null)
          {
              if(ConRV.Brand__c=='Groth')
                  strBRANDCODE='V';
              else if(ConRV.Brand__c=='CDC')
                  strBRANDCODE='D';
              else if(ConRV.Brand__c=='LaMOT')
                  strBRANDCODE='T';
              else if(ConRV.Brand__c=='LVA')
                  strBRANDCODE='L';
              else
                  strBRANDCODE='';
          }
          String strSZC=RVOU.SZC;
                    integer strLEN=strSZC.length();
                    if(strLEN<2)
                       strSZC='0'+strSZC;
                    else
                       strSZC=strSZC;
            conRV.Part_Number_Base__c = strBRANDCODE + RVOU.PNMODEL +strSZC + RVOU.MCBODY + RVOU.MCSEAT + RVOU.PNMCPALL + RVOU.PNMCDPHM + RVOU.HCLASS;

        }
        else
        {
            conRV.Part_Number__c = '';
        }
        update conRV;
        disableButton = (!showsales) && conRV.Quote_Description_Engineer_Override__c;
        pageReference reloadpage2 = new pageReference('/apex/RVConfig?qid='+quoteId+'&selectedTab=EngineeringSpecials');
        reloadpage2.setRedirect(true);
        return reloadpage2;
    }


    //* @ Save Quote Description Override on click on save
    Public pageReference SaveQuoteDescriptionOverride()
    {
        if(quoteDescriptionList != null && quoteDescriptionList.size() > 0)
        {
            for(QuoteDescriptionWrapper bgqd : quoteDescriptionList)
            {
                String attributeFieldAPI = bgqd.quotes+'_Override__c';
                rvOutsideInstance.put(attributeFieldAPI, bgqd.overrideDescription);
            }
            if(String.isNotBlank(rvOutsideInstance.Id))
            {
                update rvOutsideInstance;
            }
            update rvOutsideInstance;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        }
        return null;
    }


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
        WizardCostProcessor wcp = new WizardCostProcessor(conRV.Id);
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
        update conRV;
        getCosts();
        return null;
    }

     public pageReference ApplyDefaultCost()
    {
        if(conRV.Build_Cost_Override__c == false)
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
            update conRV;
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

    //Output methods ControlPlan,Document,Routing,Structure and WorkGuidLines starts here(Vikram Code)
    // Struture method
    public class structureWrapper
    {
        public string strComponent {set;get;}
        public string strComponentScrap {set;get;}
        public string strComponentPart {set;get;}
        public string strScrapFactor {set;get;}
        public string strQtrPerAssembly {set;get;}
        public string strLineItemNo {set;get;}

    }

    public void getStructureDetails()
    {
        String componentpart;
        strucWrapList=new list<structureWrapper>();
        if(conRV.Finish_Configuration_Flag__c)
        {
            result res=new result();
            res=RVOU.getStructure();
            Map<String, String> mapWeight = RVOU.mapWeight;
             map<integer,structureWrapper> OperationVSRVRouting = new map<integer,structureWrapper>();
            if(res.bResult)
            {
                for (sObject sobj:res.objResultList)
                {
                    structureWrapper stWrap=new structureWrapper();
                    stWrap.strComponent = (string) sobj.get('Structure_Element__c');
                    stWrap.strComponentScrap = (string) sobj.get('Component_Scrap__c');
                    stWrap.strScrapFactor = (string) sobj.get('Scrap_Factor__c');
                    stWrap.strQtrPerAssembly = (string) sobj.get('Qty_per_Assembly__c');
                    stWrap.strComponentPart = (string) sobj.get('Component_Part__c');
                    stWrap.strLineItemNo = (string) sobj.get('ItemNo__c');
                    strucWrapList.add(stWrap);

                    // added by John Vaughan Coastal Cloud Issue 4016
                    componentpart = '';
                    componentpart = stWrap.strComponentPart;
                    if(stWrap.strComponent == 'PosPallet'){
                        if(!String.isBlank(componentpart)){
                            RVOU.posPalletComponentPart = componentpart;
                            RVOU.mapweight.put('PosPalletPartNum',componentpart);
                        }
                    }
                    // added this in due to missing PGDS06/7/8/9 values on the manufacturing outputs tab for relief valve - John Vaughan Coastal Cloud
                    // see also RVOutputUtility, where the PDGS06 etc. values are added into the map
                    if(stWrap.strComponent == 'PosDiaphragm'){
                        if(!String.isBlank(componentpart)){
                            RVOU.posDiaphragmComponentPart = componentpart;
                        }
                    }
                    if(stWrap.strComponent == 'PosDiaphragmBackup'){
                        if(!String.isBlank(componentpart)){
                            RVOU.posDiaphragmBackupComponentPart = componentpart;
                        }
                    }
                    if(stWrap.strComponent == 'VacDiaphragm'){
                        if(!String.isBlank(componentpart)){
                            RVOU.vacDiaphragmComponentPart = componentpart;
                        }
                    }
                    if(stWrap.strComponent == 'VacDiaphragmBackup'){
                        if(!String.isBlank(componentpart)){
                            RVOU.vacDiaphragmBackupComponentPart = componentpart;
                        }
                    }
                }
                for(Valve_Structure_Details_Appx__c valveStructureDetail : [SELECT Id,ItemNo__c, Component_Part__c,
                                                                            Component_Scrap__c,Qty_per_Assembly__c,
                                                                            Scrap_Factor__c,Stucture_Element__c
                                                                           FROM Valve_Structure_Details_Appx__c])
                {
                    if(String.isNotBlank(valveStructureDetail.Component_Part__c))
                    {
                        String valveStructDetailPartNumber = valveStructureDetail.Component_Part__c;
                        String valveStructDetailQty = valveStructureDetail.Qty_per_Assembly__c;
                        if(valveStructDetailPartNumber.contains('['))
                        {
                            valveStructDetailPartNumber = valveStructDetailPartNumber.substringBetween('[', ']');
                        }
                        if(valveStructDetailQty.contains('['))
                        {
                            valveStructDetailQty = valveStructDetailQty.substringBetween('[', ']');
                        }
                        if(mapWeight.containsKey(valveStructDetailPartNumber) && String.isNotBlank(mapWeight.get(valveStructDetailPartNumber)))
                        {
                            if(!mapWeight.containsKey(valveStructDetailQty))
                            {
                                mapWeight.put(valveStructDetailQty,valveStructureDetail.Qty_per_Assembly__c);
                            }
                            structureWrapper stWrap=new structureWrapper();
                            stWrap.strComponent = valveStructureDetail.Stucture_Element__c;
                            stWrap.strComponentScrap = valveStructureDetail.Component_Scrap__c;
                            stWrap.strScrapFactor = valveStructureDetail.Scrap_Factor__c;
                            stWrap.strQtrPerAssembly = mapWeight.get(valveStructDetailQty);
                            stWrap.strComponentPart = mapWeight.get(valveStructDetailPartNumber);
                            stWrap.strLineItemNo = valveStructureDetail.ItemNo__c;
                            //strucWrapList.add(stWrap);
                            if(!Test.isRunningTest()) 
                            {
                                OperationVSRVRouting.put(decimal.valueOf(stWrap.strLineItemNo).intValue(),stWrap);
                            }
                        }
                    }
                    
                    
                }
            }
            
            if(OperationVSRVRouting.size() > 0)
            {
                list<integer> OperationSort = new list<integer>(OperationVSRVRouting.keyset());
                OperationSort.sort();
                for(integer opp : OperationSort)
                {
                    strucWrapList.add(OperationVSRVRouting.get(opp));
                }
            }
        }

        if(String.isNotBlank(RVOU.posPalletComponentPart)){
            List<RV_PartWgtThickness__c> partWtThickness = new List<RV_PartWgtThickness__c>();
            partWtThickness = [SELECT Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :RVOU.posPalletComponentPart LIMIT 1];
            if(partWtThickness.size() > 0){
                RVOU.mapWeight.put('PosPalletThk',String.valueOf(partWtThickness[0].Thickness__c));
                RVOU.mapWeight.put('PosPalletWt',String.valueOf(partWtThickness[0].Weight__c));
            }
        }
        if(String.isNotBlank(RVOU.posDiaphragmComponentPart)){
            RVOU.mapWeight.put('GPDS05',RVOU.posDiaphragmComponentPart);
        }
        if(String.isNotBlank(RVOU.posDiaphragmBackupComponentPart)){
            RVOU.mapWeight.put('GPDS06',RVOU.posDiaphragmBackupComponentPart);
        }
        if(String.isNotBlank(RVOU.vacDiaphragmComponentPart)){
            RVOU.mapWeight.put('GPDS07',RVOU.vacDiaphragmComponentPart);
        }
        if(String.isNotBlank(RVOU.vacDiaphragmBackupComponentPart)){
            RVOU.mapWeight.put('GPDS08',RVOU.vacDiaphragmBackupComponentPart);
        }
        

        //return strucWrapList;
    }

    // control method
    public class ControlWrapper
    {
        public string strTEST_OPNO{set;get;}
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
    }

    public list<ControlWrapper> controlWrapList{get;set;}
    public void getControlPlanDetails()
    {
        controlWrapList=new list<ControlWrapper>();
        if(conRV.Finish_Configuration_Flag__c){
         result resCP=new result();
        //RVOutputUtility RVOU=new RVOutputUtility(conRV.id);
        resCP=RVOU.getControlPlan();
        //System.debug('getControlPlan----------'+resCP.objResultList);
        string OuterMinValue = '';
        string InnerMinValue = '';
        string NominalValue = '';
        string InnerMaxValue = '';
        string OuterMaxValue = '';
        string Test_Oper_Desc='';
        if(resCP.bResult){
            for (sObject sobj:resCP.objResultList)
            {
                ControlWrapper ctrlWrap=new ControlWrapper();
                ctrlWrap.strTEST_OPNO =(string) sobj.get('Test_OPNO__c');
                //ctrlWrap.strTEST_OPERATION_DESC =(string) sobj.get('TEST_OPERATION_DESC__c');
                string ControlVal=(string) sobj.get('TEST_OPERATION_DESC__c');
                if(ControlVal.contains('[') && ControlVal.contains(']'))
                {
                    string  Test_Oper_Desc_val='';
                    Test_Oper_Desc = (string) sobj.get('TEST_OPERATION_DESC__c');
                    if(Test_Oper_Desc!=null)
                    {
                        Test_Oper_Desc = Test_Oper_Desc.substringBetween('[',']');
                    }
                    if(string.isBlank(Test_Oper_Desc) || Test_Oper_Desc == null)
                    {
                        ctrlWrap.strTEST_OPERATION_DESC = (String) sobj.get('TEST_OPERATION_DESC__c');
                    }
                    else
                    {
                        Test_Oper_Desc_val = RVOU.mapRVAttr.get(Test_Oper_Desc);
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
                    ctrlWrap.strTEST_OPERATION_DESC=attributeValue;
                }
                else
                    ctrlWrap.strTEST_OPERATION_DESC =(string) sobj.get('TEST_OPERATION_DESC__c');
                ctrlWrap.strNORM_TYPE=(string) sobj.get('NORM_TYPE__c');
                ctrlWrap.strOperation_Number=(string) sobj.get('Operation_Number__c');
                ctrlWrap.strCATEGORY_ID=(string) sobj.get('CATEGORY_ID__c');
                ctrlWrap.strINSPECTION_CODE=(string) sobj.get('INSPECTION_CODE__c');
                ctrlWrap.strSAMPLE_PERCENT=(string) sobj.get('SAMPLE_PERCENT__c');
                ctrlWrap.strProcess_Characteristic=(string) sobj.get('Process_Characteristic__c');
                //ctrlWrap.strOUTER_MIN =(string) sobj.get('Outer_Min__c');
                //ctrlWrap.strINNER_MIN =(string) sobj.get('Inner_Min__c');
                //ctrlWrap.strOUTER_MAX =(string) sobj.get('Outer_Max__c');
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
                    ctrlWrap.strOUTER_MIN = RVOU.mapRVAttr.get(OuterMinValue);
                }
                InnerMinValue = (String) sobj.get('Inner_Min__c');
                if(InnerMinValue!=null)
                {
                    InnerMinValue = InnerMinValue.substringBetween('[',']');
                }
                if(string.isBlank(InnerMinValue) || InnerMinValue == null)
                {
                    ctrlWrap.strINNER_MIN = (String) sobj.get('Inner_Min__c');
                }
                else
                {
                    ctrlWrap.strINNER_MIN= RVOU.mapRVAttr.get(InnerMinValue);
                }
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
                    ctrlWrap.strNOMINAL_VALUE = RVOU.mapRVAttr.get(NominalValue);
                }
                InnerMaxValue = (String) sobj.get('Inner_Max__c');
                if(InnerMaxValue!=null)
                {
                    InnerMaxValue = InnerMaxValue.substringBetween('[',']');
                }
                if(string.isBlank(InnerMaxValue) || InnerMaxValue == null)
                {
                    ctrlWrap.strINNER_MAX = (String) sobj.get('Inner_Max__c');
                }
                else
                {
                    ctrlWrap.strINNER_MAX = RVOU.mapRVAttr.get(InnerMaxValue);
                }
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
                    ctrlWrap.strOUTER_MAX = RVOU.mapRVAttr.get(OuterMaxValue);
                }
                ctrlWrap.strTool_ID=(string) sobj.get('Tool_ID__c');
                ctrlWrap.strData_Point=(string) sobj.get('Data_Point__c');
                ctrlWrap.strDATA_TYPE=(string) sobj.get('DATA_TYPE__c');

                controlWrapList.add(ctrlWrap);
            }
        }
        }
        //return controlWrapList;
    }

    public class WorkGuideLineWrapper
    {
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
        public string strGuidline_Seq{set;get;}
        public string strDescription {set;get;}
         public string strText {set;get;}
         public string strType {set;get;}
         public string strSign_Off {set;get;}
         public string strInspection_Sign_Off_Required {set;get;}

    }
    public list<WorkGuideLineWrapper> workguildeWrapList{get;set;}
    public void getWorkGuideLines()
    {
        workguildeWrapList=new list<WorkGuideLineWrapper>();
        if(conRV.Finish_Configuration_Flag__c){
        result res=new result();
        res=RVOU.getWorkGuideLines();
        if(res.bResult)
        {
            for (sObject sobj:res.objResultList)
            {
                WorkGuideLineWrapper stWrap=new WorkGuideLineWrapper();
                stWrap.strStandard_Operation_ID = (string) sobj.get('Operation__c');
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

        //return workguildeWrapList;
    }

    public class documentWrapper
    {
        public string strDocument_ID {set;get;}
        public string strRevision {set;get;}
        public string strDocument {set;get;}
    }
    public list<documentWrapper> documentWrapList{get;set;}
    public void getDocument()
    {
        documentWrapList=new list<documentWrapper>();
        if(conRV.Finish_Configuration_Flag__c){
        result res=new result();
        //RVOutputUtility RVOU=new RVOutputUtility(conRV.id);
        res=RVOU.getDocument();
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

        //return documentWrapList;
    }


     //Router Wrapper
     public class RouterWrapper
    {
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
        public string strDescr {set;get;}
        public string strOperation {set;get;}
    }
    public list<RouterWrapper> RouterWrapList{get;set;}
    public void getRouter()
    {
        RouterWrapList=new list<RouterWrapper>();
        if(conRV.Finish_Configuration_Flag__c)
        {
            result res=new result();
            res=RVOU.getRouting();
            string ASSYPARTNO = '';
            if(res.bResult)
            {
                Map<Integer, RouterWrapper> routingStepsMap = new Map<Integer, RouterWrapper>();
                for (sObject sobj:res.objResultList)
                {
                    RouterWrapper docWrap=new RouterWrapper();
                    docWrap.strOperation = (string) sobj.get('Operation__c');
                    docWrap.strStandard_Operation_ID  = (string) sobj.get('Standard_Operation_ID__c');
                    //docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                    string ControlVal=(string) sobj.get('Outside_Operation_Item__c');
                    if(ControlVal!=null)
                    {
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
                                docWrap.strOutside_Operation_Item = (String) sobj.get('Outside_Operation_Item__c');
                            }
                            else
                            {
                                Test_Oper_Desc_val = RVOU.mapRVAttr.get(ASSYPARTNO);
                            }
    
                            String[] arrPTC  =new String[5];
                            arrPTC=ControlVal.split('\\[');
                            String strPTC1  = arrPTC[0];
                            String strPTC2  = arrPTC[1];
                            String str2SplitOB170 =strPTC2;
                            String[] arrPTC2  = new String[5];
                            arrPTC2=str2SplitOB170.split('\\]');
                            String strPTC4 = '';
                            if(arrPTC2.size()>1)
                            {
                                strPTC4  = arrPTC2[1];
                            }
                            else
                            {
                                strPTC4 = '';
                            }
                            string attributeValue=strPTC1+Test_Oper_Desc_val+strPTC4;
                            docWrap.strOutside_Operation_Item=attributeValue;
                       }
                       else
                       {
                           docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                       }
                    }
                    else
                    {
                        docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                    }
                    docWrap.strDescr = (string) sobj.get('Descr__c');
                    //RouterWrapList.add(docWrap);
                    routingStepsMap.put(Integer.valueOf(docWrap.strOperation),docWrap);
                }
                if(routingStepsMap.size() > 0)
                {
                    List<Integer> operationsList = new List<Integer>(routingStepsMap.KeySet());
                    operationsList.sort();
                    for(Integer operationNumber: operationsList)
                    {
                        RouterWrapList.add(routingStepsMap.get(operationNumber));
                    }
                }
                
            }
        }
        //return RouterWrapList;
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
        if(conRV.Finish_Configuration_Flag__c){
         Attr = RVOU.getmapRVInterfaceAttr();

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

    public Map<String, String> Attr1;
    Public List<TroubleshootingAttr> TroubleshootingAttrList{get;set;}
    public class TroubleshootingAttr
    {
        public String Key {get;set;}
        public String Values {get;set;}
    }

    public list<TroubleshootingAttr> getTroubleshootingAttributes()
    {
        Attr1 = new Map<String, String>();
        TroubleshootingAttrList = new List<TroubleshootingAttr>();
        if(conRV.Finish_Configuration_Flag__c)
        {
            //RVOU = new RVOutputUtility(conRV);
            system.debug('##printing RVOU: '+RVOU);
            Attr1 = RVOU.getmapTroubleShootingRVAttr();
            for(String attribute: Attr1.keySet())
            {
                system.debug('##printing attribute: '+attribute);
                TroubleshootingAttr attrDesc = new TroubleshootingAttr();
                attrDesc.Key = attribute;
                system.debug('##printing attrDesc.Values: '+attrDesc.Values);
                if(String.isBlank(attrDesc.Values))
                {
                    attrDesc.Values = Attr1.get(attribute);
                }
                system.debug('##printing attrDesc.Values: '+attrDesc.Values);
                TroubleshootingAttrList.add(attrDesc);
            }
        }

        return TroubleshootingAttrList;
    }
    
    public pageReference cleanRVrecord(Relief_Valve__c curRV)
    {
        //Relief_Valve__c curRV ;
        //curRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(curRV.id).objResultList[0];
        curRV.Relief_Type__c = null;
        curRV.Part_Number__c= null;
        curRV.Lead_Time_Site_10__c=null;
        curRV.Lead_Time_Site_20__c=null;
        curRV.Lead_Time_Site_30__c=null;
        curRV.Lead_Time_Site_40__c=null;
        curRV.Pressure_Setting__c = null;
        curRV.Pressure_Setting_Units__c = null; 
        curRV.Back_Pressure__c = null;
        curRV.Back_Pressure_Units__c = null;
        curRV.Max_Process_Pressure__c = null;
        curRV.Vacuum_Setting__c = null;
        curRV.Vacuum_Setting_Units__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Constraint_Product_Selection_By_Flow__c = true;
        
        //Section B
        
        curRV.Atmospheric_Pressure__c = null;
        curRV.Media_Type__c = null;
        curRV.V_Ratio_of_Specific_Heats__c= null;
        curRV.V_Molecular_Weight__c= null;
        curRV.V_Compressibility_Factor__c= null;
        curRV.Pressure_Relief_Req_Flow_Rate__c= null;
        curRV.Pressure_Relief_Req_Flow_Units__c= null;
        curRV.Enter_Relieving_Pressure_Value__c = null;
        curRV.Enter_Relieving_Pressure_Units__c= null;
        curRV.Pressure_Relieving_Temperature__c= null;
        curRV.Pressure_Relieving_Temperature_Units__c= null;
        curRV.Vacuum_Media__c= null;
        curRV.Ratio_of_Specific_Heats__c=null;
        curRV.Molecular_Weight__c = null;
        curRV.Compressibility_Factor__c = null;
        curRV.Vacuum_Relief_Req_Flow__c = null;
        curRV.Vacuum_Relief_Required_Flow_Units__c=null;
        curRV.V_Enter_Relieving_Vacuum_Value__c = null;
        curRV.V_Enter_Relieving_Vacuum_units__c = null;
        curRV.V_Overpressure_Vacuum_Value__c = null;
        curRV.V_Vacuum_Relieving_Temperature__c = null;
        curRV.V_Vacuum_Relieving_Temperature_Units__c = null;
        curRV.Converted_Pressure_Setting__c = null;
        curRV.Converted_Max_Process_Pressure__c = null;
        curRV.Converted_Vacuum_Setting__c = null;
        curRV.Converted_Atmospheric_Pressure__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Converted_Back_Pressure__c = null;
        curRV.V_Converted_Relieving_Vacuum_Value__c = null;
        curRV.Converted_Pressure_Relief_Req_Flow__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Converted_Pressure_Relieving_Temperature__c = null;
        curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
        curRV.V_Converted_Relieving_Vacuum_Value__c = null;
        curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
        //Section C
        curRV.PED_2014_68_EU_CE_mark__c=false;
        curRV.CU_TR__c=false;
        curRV.Atex_Certificate__c=true;
        curRV.Gas_Group__c = null;
        curRV.Zone__c = null;
        curRV.NACE__c=false;
        
        //Section D
        curRV.Type_of_model__c='';
        curRV.Type_of_overpressure_valve__c='100';
        curRV.Is_flame_arrester_needed_with_your_valve__c='';
        
        //Section E        
        curRV.Size_Preference__c=null;
        curRV.Model_Size__c=null;
        curRV.Size__c=null;
        curRV.Model_name__c=null;
        curRV.Size_Preference__c = null;
        curRV.Schedule_BaseLead__c = null;
        curRV.EFFMop__c = 1.000;
        curRV.EffMBP__c = 1.000;
        curRV.PosSetPresOSIG__c = 1.000;
        curRV.VacSetPresOSIG__c = 1.000;
        //VF Page Fields
        curRV.Quantity__c=1;
        curRV.Drilling__c='B';
        curRV.Body_Material__c='6';
        curRV.Facing__c='FF';
        curRV.Seat_Material__c='6';
        curRV.Pallet_Type__c='N';
        curRV.Pressure_Pallet_Material__c='6';
        curRV.Diaphragm_Material__c='T';
        curRV.Vacuum_Pallet_Material__c='6';
        curRV.Pilot_Soft_Goods_Material__c='N';
        curRV.Weight_Material__c='RL';
        curRV.Spring_Material__c='P';
        curRV.Fastener_Material__c = '8';
        curRV.Steam_Jacket_Material__c='0';
        curRV.Body_Coating_Material__c='N';
        curRV.Pallet_Fastener_Coating_Material__c='N';
        curRV.Element_Material__c='N';
        curRV.Flame_Arrester_Option__c = '000';
        curRV.Vacuum_Port_Option__c='V';
        curRV.Pressure_Port_Proximity_Sensor__c = false;
        curRV.Vacuum_Port_Proximity_Sensor__c = false;
        curRV.Pilot_Action__c = 'N';
        curRV.Positive_Material_Identification__c='N';
        curRV.Liquid_Dye_Penetrant__c='N';
        curRV.Painting_Coating_Option__c = '0';
        curRV.Manual_Blowdown__c=false; //checkboxes
        curRV.Remote_Sense__c=false;
        curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
        curRV.Field_Test_Connection__c=false;
        curRV.Pilot_Supply_Filter__c=false;
        curRV.Method21_Leak_Detection__c=false;
        curRV.Radiography__c='N';
        curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
        curRV.Ultrasonic_Examination__c=false;
        curRV.Magnetic_Particle_Examination__c=false;        
        curRV.Brinell_hardness_examination__c=false;
        curRV.Charpy_Impact_Testing__c=false;
        curRV.Visual_Casting_Examination__c=false;
        curRV.Intergranular_Corossion_Test__c = false;
        curRV.Shell_Test_Valve_Body__c = 'AIR';
        curRV.Final_Assembly_Location_Requirements__c = '00';
        curRV.Material_Sourcing_Requirements__c = '00';
        curRV.Finish_Configuration_Flag__c = true;
        curRV.Body_Design__c = 'STD';
        
        curRV.Relief_Type__c = null;
        curRV.Part_Number__c= null;
        curRV.Lead_Time_Site_10__c=null;
        curRV.Lead_Time_Site_20__c=null;
        curRV.Lead_Time_Site_30__c=null;
        curRV.Lead_Time_Site_40__c=null;
        curRV.Pressure_Setting__c = null;
        curRV.Pressure_Setting_Units__c = null; 
        curRV.Back_Pressure__c = null;
        curRV.Back_Pressure_Units__c = null;
        curRV.Max_Process_Pressure__c = null;
        curRV.Vacuum_Setting__c = null;
        curRV.Vacuum_Setting_Units__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Constraint_Product_Selection_By_Flow__c = true;
        
        //Section B
        
        curRV.Atmospheric_Pressure__c = null;
        curRV.Media_Type__c = null;
        curRV.V_Ratio_of_Specific_Heats__c= null;
        curRV.V_Molecular_Weight__c= null;
        curRV.V_Compressibility_Factor__c= null;
        curRV.Pressure_Relief_Req_Flow_Rate__c= null;
        curRV.Pressure_Relief_Req_Flow_Units__c= null;
        curRV.Enter_Relieving_Pressure_Value__c = null;
        curRV.Enter_Relieving_Pressure_Units__c= null;
        curRV.Pressure_Relieving_Temperature__c= null;
        curRV.Pressure_Relieving_Temperature_Units__c= null;
        curRV.Vacuum_Media__c= null;
        curRV.Ratio_of_Specific_Heats__c=null;
        curRV.Molecular_Weight__c = null;
        curRV.Compressibility_Factor__c = null;
        curRV.Vacuum_Relief_Req_Flow__c = null;
        curRV.Vacuum_Relief_Required_Flow_Units__c=null;
        curRV.V_Enter_Relieving_Vacuum_Value__c = null;
        curRV.V_Enter_Relieving_Vacuum_units__c = null;
        curRV.V_Overpressure_Vacuum_Value__c = null;
        curRV.V_Vacuum_Relieving_Temperature__c = null;
        curRV.V_Vacuum_Relieving_Temperature_Units__c = null;
        curRV.Converted_Pressure_Setting__c = null;
        curRV.Converted_Max_Process_Pressure__c = null;
        curRV.Converted_Vacuum_Setting__c = null;
        curRV.Converted_Atmospheric_Pressure__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Converted_Back_Pressure__c = null;
        curRV.V_Converted_Relieving_Vacuum_Value__c = null;
        curRV.Converted_Pressure_Relief_Req_Flow__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Converted_Pressure_Relieving_Temperature__c = null;
        curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
        curRV.V_Converted_Relieving_Vacuum_Value__c = null;
        curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
        //Section C
        curRV.PED_2014_68_EU_CE_mark__c=false;
        curRV.CU_TR__c=false;
        curRV.Atex_Certificate__c=true;
        curRV.Gas_Group__c = null;
        curRV.Zone__c = null;
        curRV.NACE__c=false;
        
        //Section D
        curRV.Type_of_model__c='';
        curRV.Type_of_overpressure_valve__c='100';
        curRV.Is_flame_arrester_needed_with_your_valve__c='';
        
        //Section E        
        curRV.Size_Preference__c=null;
        curRV.Model_Size__c=null;
        curRV.Size__c=null;
        curRV.Model_name__c=null;
        curRV.Size_Preference__c = null;
        curRV.Schedule_BaseLead__c = null;
        curRV.EFFMop__c = 1.000;
        curRV.EffMBP__c = 1.000;
        curRV.PosSetPresOSIG__c = 1.000;
        curRV.VacSetPresOSIG__c = 1.000;
        //VF Page Fields
        curRV.Quantity__c=1;
        curRV.Drilling__c='B';
        curRV.Body_Material__c='6';
        curRV.Facing__c='FF';
        curRV.Seat_Material__c='6';
        curRV.Pallet_Type__c='N';
        curRV.Pressure_Pallet_Material__c='6';
        curRV.Diaphragm_Material__c='T';
        curRV.Vacuum_Pallet_Material__c='6';
        curRV.Pilot_Soft_Goods_Material__c='N';
        curRV.Weight_Material__c='RL';
        curRV.Spring_Material__c='P';
        curRV.Fastener_Material__c = '8';
        curRV.Steam_Jacket_Material__c='0';
        curRV.Body_Coating_Material__c='N';
        curRV.Pallet_Fastener_Coating_Material__c='N';
        curRV.Element_Material__c='N';
        curRV.Flame_Arrester_Option__c = '000';
        curRV.Vacuum_Port_Option__c='V';
        curRV.Pressure_Port_Proximity_Sensor__c = false;
        curRV.Vacuum_Port_Proximity_Sensor__c = false;
        curRV.Pilot_Action__c = 'N';
        curRV.Positive_Material_Identification__c='N';
        curRV.Liquid_Dye_Penetrant__c='N';
        curRV.Painting_Coating_Option__c = '0';
        curRV.Manual_Blowdown__c=false; //checkboxes
        curRV.Remote_Sense__c=false;
        curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
        curRV.Field_Test_Connection__c=false;
        curRV.Pilot_Supply_Filter__c=false;
        curRV.Method21_Leak_Detection__c=false;
        curRV.Radiography__c='N';
        curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
        curRV.Ultrasonic_Examination__c=false;
        curRV.Magnetic_Particle_Examination__c=false;        
        curRV.Brinell_hardness_examination__c=false;
        curRV.Charpy_Impact_Testing__c=false;
        curRV.Visual_Casting_Examination__c=false;
        curRV.Intergranular_Corossion_Test__c = false;
        curRV.Shell_Test_Valve_Body__c = 'AIR';
        curRV.Final_Assembly_Location_Requirements__c = '00';
        curRV.Material_Sourcing_Requirements__c = '00';
        curRV.Finish_Configuration_Flag__c = true;
        curRV.Body_Design__c = 'STD';
        
        curRV.Relief_Type__c = null;
        curRV.Part_Number__c= null;
        curRV.Lead_Time_Site_10__c=null;
        curRV.Lead_Time_Site_20__c=null;
        curRV.Lead_Time_Site_30__c=null;
        curRV.Lead_Time_Site_40__c=null;
        curRV.Pressure_Setting__c = null;
        curRV.Pressure_Setting_Units__c = null; 
        curRV.Back_Pressure__c = null;
        curRV.Back_Pressure_Units__c = null;
        curRV.Max_Process_Pressure__c = null;
        curRV.Vacuum_Setting__c = null;
        curRV.Vacuum_Setting_Units__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Constraint_Product_Selection_By_Flow__c = true;
        
        //Section B
        
        curRV.Atmospheric_Pressure__c = null;
        curRV.Media_Type__c = null;
        curRV.V_Ratio_of_Specific_Heats__c= null;
        curRV.V_Molecular_Weight__c= null;
        curRV.V_Compressibility_Factor__c= null;
        curRV.Pressure_Relief_Req_Flow_Rate__c= null;
        curRV.Pressure_Relief_Req_Flow_Units__c= null;
        curRV.Enter_Relieving_Pressure_Value__c = null;
        curRV.Enter_Relieving_Pressure_Units__c= null;
        curRV.Pressure_Relieving_Temperature__c= null;
        curRV.Pressure_Relieving_Temperature_Units__c= null;
        curRV.Vacuum_Media__c= null;
        curRV.Ratio_of_Specific_Heats__c=null;
        curRV.Molecular_Weight__c = null;
        curRV.Compressibility_Factor__c = null;
        curRV.Vacuum_Relief_Req_Flow__c = null;
        curRV.Vacuum_Relief_Required_Flow_Units__c=null;
        curRV.V_Enter_Relieving_Vacuum_Value__c = null;
        curRV.V_Enter_Relieving_Vacuum_units__c = null;
        curRV.V_Overpressure_Vacuum_Value__c = null;
        curRV.V_Vacuum_Relieving_Temperature__c = null;
        curRV.V_Vacuum_Relieving_Temperature_Units__c = null;
        curRV.Converted_Pressure_Setting__c = null;
        curRV.Converted_Max_Process_Pressure__c = null;
        curRV.Converted_Vacuum_Setting__c = null;
        curRV.Converted_Atmospheric_Pressure__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Converted_Back_Pressure__c = null;
        curRV.V_Converted_Relieving_Vacuum_Value__c = null;
        curRV.Converted_Pressure_Relief_Req_Flow__c = null;
        curRV.Converted_Relieving_Pressure_Value__c = null;
        curRV.Converted_Pressure_Relieving_Temperature__c = null;
        curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
        curRV.V_Converted_Relieving_Vacuum_Value__c = null;
        curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
        //Section C
        curRV.PED_2014_68_EU_CE_mark__c=false;
        curRV.CU_TR__c=false;
        curRV.Atex_Certificate__c=true;
        curRV.Gas_Group__c = null;
        curRV.Zone__c = null;
        curRV.NACE__c=false;
        
        //Section D
        curRV.Type_of_model__c='';
        curRV.Type_of_overpressure_valve__c='100';
        curRV.Is_flame_arrester_needed_with_your_valve__c='';
        
        //Section E        
        curRV.Size_Preference__c=null;
        curRV.Model_Size__c=null;
        curRV.Size__c=null;
        curRV.Model_name__c=null;
        curRV.Size_Preference__c = null;
        curRV.Schedule_BaseLead__c = null;
        curRV.EFFMop__c = 1.000;
        curRV.EffMBP__c = 1.000;
        curRV.PosSetPresOSIG__c = 1.000;
        curRV.VacSetPresOSIG__c = 1.000;
        //VF Page Fields
        curRV.Quantity__c=1;
        curRV.Drilling__c='B';
        curRV.Body_Material__c='6';
        curRV.Facing__c='FF';
        curRV.Seat_Material__c='6';
        curRV.Pallet_Type__c='N';
        curRV.Pressure_Pallet_Material__c='6';
        curRV.Diaphragm_Material__c='T';
        curRV.Vacuum_Pallet_Material__c='6';
        curRV.Pilot_Soft_Goods_Material__c='N';
        curRV.Weight_Material__c='RL';
        curRV.Spring_Material__c='P';
        curRV.Fastener_Material__c = '8';
        curRV.Steam_Jacket_Material__c='0';
        curRV.Body_Coating_Material__c='N';
        curRV.Pallet_Fastener_Coating_Material__c='N';
        curRV.Element_Material__c='N';
        curRV.Flame_Arrester_Option__c = '000';
        curRV.Vacuum_Port_Option__c='V';
        curRV.Pressure_Port_Proximity_Sensor__c = false;
        curRV.Vacuum_Port_Proximity_Sensor__c = false;
        curRV.Pilot_Action__c = 'N';
        curRV.Positive_Material_Identification__c='N';
        curRV.Liquid_Dye_Penetrant__c='N';
        curRV.Painting_Coating_Option__c = '0';
        curRV.Manual_Blowdown__c=false; //checkboxes
        curRV.Remote_Sense__c=false;
        curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
        curRV.Field_Test_Connection__c=false;
        curRV.Pilot_Supply_Filter__c=false;
        curRV.Method21_Leak_Detection__c=false;
        curRV.Radiography__c='N';
        curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
        curRV.Ultrasonic_Examination__c=false;
        curRV.Magnetic_Particle_Examination__c=false;        
        curRV.Brinell_hardness_examination__c=false;
        curRV.Charpy_Impact_Testing__c=false;
        curRV.Visual_Casting_Examination__c=false;
        curRV.Intergranular_Corossion_Test__c = false;
        curRV.Shell_Test_Valve_Body__c = 'AIR';
        curRV.Final_Assembly_Location_Requirements__c = '00';
        curRV.Material_Sourcing_Requirements__c = '00';
        curRV.Finish_Configuration_Flag__c = true;
        curRV.Body_Design__c = 'STD';
         //Section E        
        curRV.Size_Preference__c=null;
        curRV.Model_Size__c=null;
        curRV.Size__c=null;
        curRV.Model_name__c=null;
        curRV.Size_Preference__c = null;
        curRV.Schedule_BaseLead__c = null;
        curRV.EFFMop__c = 1.000;
        curRV.EffMBP__c = 1.000;
        curRV.PosSetPresOSIG__c = 1.000;
        curRV.VacSetPresOSIG__c = 1.000;
        //VF Page Fields
        curRV.Quantity__c=1;
        curRV.Drilling__c='B';
        curRV.Body_Material__c='6';
        curRV.Facing__c='FF';
        curRV.Seat_Material__c='6';
        curRV.Pallet_Type__c='N';
        curRV.Pressure_Pallet_Material__c='6';
        curRV.Diaphragm_Material__c='T';
        curRV.Vacuum_Pallet_Material__c='6';
        curRV.Pilot_Soft_Goods_Material__c='N';
        curRV.Weight_Material__c='RL';
        curRV.Spring_Material__c='P';
        curRV.Fastener_Material__c = '8';
        curRV.Steam_Jacket_Material__c='0';
        curRV.Body_Coating_Material__c='N';
        curRV.Pallet_Fastener_Coating_Material__c='N';
        curRV.Element_Material__c='N';
        curRV.Flame_Arrester_Option__c = '000';
        curRV.Vacuum_Port_Option__c='V';
        curRV.Pressure_Port_Proximity_Sensor__c = false;
        curRV.Vacuum_Port_Proximity_Sensor__c = false;
        curRV.Pilot_Action__c = 'N';
        curRV.Positive_Material_Identification__c='N';
        curRV.Liquid_Dye_Penetrant__c='N';
        curRV.Painting_Coating_Option__c = '0';
        curRV.Manual_Blowdown__c=false; //checkboxes
        curRV.Remote_Sense__c=false;
        curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
        curRV.Field_Test_Connection__c=false;
        curRV.Pilot_Supply_Filter__c=false;
        curRV.Method21_Leak_Detection__c=false;
        curRV.Radiography__c='N';
        curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
        curRV.Ultrasonic_Examination__c=false;
        curRV.Magnetic_Particle_Examination__c=false;        
        curRV.Brinell_hardness_examination__c=false;
        curRV.Charpy_Impact_Testing__c=false;
        curRV.Visual_Casting_Examination__c=false;
        curRV.Intergranular_Corossion_Test__c = false;
        curRV.Shell_Test_Valve_Body__c = 'AIR';
        curRV.Final_Assembly_Location_Requirements__c = '00';
        curRV.Material_Sourcing_Requirements__c = '00';
        curRV.Finish_Configuration_Flag__c = true;
        curRV.Body_Design__c = 'STD';
        return null;
    }
}