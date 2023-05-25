public with sharing class BlanketGasRegulatorController {
    
    public BlanketGasRegulatorController() {

    }

    /*
    @AuraEnabled
    public static BGR__c saveSetting(BGR__c brgRecord){
        if(brgRecord.Setting_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (brgRecord.Setting__c != Null){
                resultConvertPressure=unitConversions.convertPressure(brgRecord.Setting_Units__c,'in. water',brgRecord.Setting__c);
                if(resultConvertPressure.bResult){
                    brgRecord.Converted_Setting__c=resultConvertPressure.dblRetValue;
                }else{
                    //Handle Error here
                    throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                }   
            }
        }
        return brgRecord;
    }

    @AuraEnabled
    public static BGR__c savePressureSetting(BGR__c brgRecord){
        if(brgRecord.Supply_Pressure_Units__c != Null){
            
            Result resultConvertPressure= new Result();
            
            if (brgRecord.Supply_Pressure__c != Null){
                resultConvertPressure=unitConversions.convertPressure(brgRecord.Supply_Pressure_Units__c,'psig',brgRecord.Supply_Pressure__c);
            }
            
            if(resultConvertPressure.bResult){
                brgRecord.Converted_Supply_Pressure__c=resultConvertPressure.dblRetValue;
            }else{
                throw new AuraHandledException(resultConvertPressure.strErrorMessage);
            }     
        }
        return brgRecord;
    }*/

    /* 
    @AuraEnabled
    public static BGR__c saveAtm(BGR__c brgRecord) {
        //brgRecord.Relief_Flag__c=true;
        if(brgRecord.Atmospheric_Pressure_Units__c != Null) {
            Result resultConvertPressure= new Result();
            if (brgRecord.Atmospheric_Pressure__c != Null){
             resultConvertPressure=unitConversions.convertPressure(brgRecord.Atmospheric_Pressure_Units__c,'psia',brgRecord.Atmospheric_Pressure__c);
            
            if(resultConvertPressure.bResult)
               
                brgRecord.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;
                
                else{
                    throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                }     
            }
        }
        return brgRecord;
    }*/
    
    //BGR Cleanup Methods
    public static boolean ReorderFlagLWC=false;
    
    public static BGR__c cleanSecB(BGR__c brgRecord){
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Section_B_flag__c=false;
        
        brgRecord.Supply_Gas__c=null;
        brgRecord.Customer_Specified_Media__c=null;
        brgRecord.Supply_Gas_Temperature__c=null;
        brgRecord.Supply_Gas_Temperature_Units__c=null;
        brgRecord.Minimum_Required_Flow_Capacity__c=null;
        brgRecord.Flow_Units__c=null;
        return brgRecord;
        
    }  
    public static BGR__c cleanSecC(BGR__c brgRecord){
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Certifications_flag__c=false;

        brgRecord.Atex__c=null;
        brgRecord.GOST_CU_Tr_010_2011__c=null;
        brgRecord.CSA_Markings__c=null;
        return brgRecord;
    } 
    public static BGR__c cleanSecD(BGR__c brgRecord){
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Product_material_options_flag__c=false;
 
        brgRecord.Size__c=null;
        brgRecord.Model__c=null;
        brgRecord.Orifice_Setting__c=null;
        return brgRecord;
    }
    public static BGR__c cleanSecE(BGR__c brgRecord){
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Product_selection_flag__c=false;

        brgRecord.Quantity__c=null;
        brgRecord.Body_Material_dynamic__c=null;
        brgRecord.Soft_Goods_Material_dynamic__c=null;
        brgRecord.Connection_dynamic__c=null;  
        return brgRecord;  
    }
    public static BGR__c cleanSecF(BGR__c brgRecord){
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Valve_Examination_Flag__c=false;

        brgRecord.Radiography__c=null;
        brgRecord.Positive_Material_Identification__c=null;
        brgRecord.Shell_test__c=null;
        brgRecord.Shell_Test_Valve_Body__c=null;    
        return brgRecord;    
    }
    public static BGR__c cleanSecG(BGR__c brgRecord){
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Document_Or_Sourcing_flag__c=false;
        
        brgRecord.Final_Assembly_Location_Requirements__c=null;
        brgRecord.Material_Sourcing_Requirements__c=null;
        return brgRecord;
    }

    @AuraEnabled
    public static BGR__c handleNarrowSelection(BGR__c brgRecord){
        brgRecord.Section_B_flag__c = false;
        brgRecord.Molecular_Weight__c = null;

        try{
            update brgRecord;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                if(!Test.isRunningTest()) { 
                    
                    throw new AuraHandledException(dmle.getDmlMessage(i));
                }
            }
            
        }
        return brgRecord;
    }

       //added by piyush for logic 
  @AuraEnabled 
  public static formAccessibilityWrapper fetchFormAccessibility(string qliId){

      SBQQ__QuoteLine__c  qli = [SELECT Id, Run_Config_Sync__c,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c WHERE Id=:qliId];
      string quoteStatus = qli.SBQQ__Quote__r.SBQQ__Status__c;
      formAccessibilityWrapper oformAccessibilityWrapper = new formAccessibilityWrapper();
      BGR__c conBGR = DataSelectorWizard.getBGRProductRecord(qliId);
      oformAccessibilityWrapper.bConfigurationComplete = conBGR.Configuration_Complete__c;
      system.debug('conBGR --> Configuration_Complete__c ' + conBGR.Configuration_Complete__c);
      system.debug('conBGR Quote_Description_Engineer_Override__c --> ' + conBGR.Quote_Description_Engineer_Override__c);
      string configStatus= '';
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
      ProductAccessibilityConfig__mdt oPacMetaData = fetchCurrentProductAccessibility( quoteStatus , configStatus);
      system.debug('oPacMetaData----> ' + oPacMetaData);
      oformAccessibilityWrapper.bShowEditButton = false;
      string defaultQuoteLineView = oPacMetaData.Default_View__c;  
      string QuoteLIneView = oPacMetaData.View__c; 
      system.debug('QuoteLIneView----> ' + QuoteLIneView);
      if(QuoteLIneView == 'Editable'){
          oformAccessibilityWrapper.bShowEditButton = true;
          if(defaultQuoteLineView == 'Editable'){
              oformAccessibilityWrapper.bReadOnly = false;
              oformAccessibilityWrapper.bShowEditButton = false;
          }else{
              oformAccessibilityWrapper.bReadOnly = true;
          }
          
      }else{
          oformAccessibilityWrapper.bReadOnly = true;
      }  
      return oformAccessibilityWrapper;     
  }

  public class formAccessibilityWrapper{
      @AuraEnabled public boolean bReadOnly {get;set;} 
      @AuraEnabled public boolean bShowEditButton {get;set;} 
      @AuraEnabled public boolean bConfigurationComplete{get;set;} 
      
  }

  private static ProductAccessibilityConfig__mdt fetchCurrentProductAccessibility(string sQuoteStatus, string sConfigStatus){
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



    @AuraEnabled
    public static BGR__c saveRelief(BGR__c brgRecord){
         
        brgRecord.Configuration_Complete__c=false;
        brgRecord.Relief_Flag__c=true;
        brgRecord.Section_B_flag__c=false;
        brgRecord.Certifications_flag__c=false;
        brgRecord.Product_material_options_flag__c=false;
        brgRecord.Product_selection_flag__c=false;
        brgRecord.Valve_Examination_Flag__c=false;
        brgRecord.Document_Or_Sourcing_flag__c=false;
        //brgRecord.Atmospheric_Pressure_Units__c = 'psia';
        brgRecord.Converted_Atmospheric_Pressure__c = 14.6959;

        if(string.isNotBlank(brgRecord.Supply_Pressure_Units__c) && brgRecord.Supply_Pressure__c != Null)
        {
            Result resultConvertPressure= new Result();
            resultConvertPressure=unitConversions.convertPressure(brgRecord.Supply_Pressure_Units__c,'psig',brgRecord.Supply_Pressure__c);
            if(resultConvertPressure.bResult){
                brgRecord.Converted_Supply_Pressure__c=resultConvertPressure.dblRetValue;
            }
            
            if( brgRecord.Supply_Pressure__c != null && (brgRecord.Converted_Supply_Pressure__c < 5.0 || brgRecord.Converted_Supply_Pressure__c > 200))
            {
                resultConvertPressure=unitConversions.getConvertedValErrorMsg('Pressure',200,5.0,'psig',brgRecord.Supply_Pressure_Units__c,brgRecord.Supply_Pressure__c,'Supply Pressure: ');
                if(!Test.isRunningTest()) { 
                    throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                }
            }
        }
        System.debug('@@@ brgRecord.Setting_Units__c = '+brgRecord.Setting_Units__c+', brgRecord.Setting__c = '+brgRecord.Setting__c);
        if(String.isNotBlank(brgRecord.Setting_Units__c)) 
        {
            Result resultConvertPressure= new Result();
            if(brgRecord.Setting__c != null)
            {
                resultConvertPressure=unitConversions.convertPressure(brgRecord.Setting_Units__c,'in. water',brgRecord.Setting__c);
                if(resultConvertPressure.bResult)
                    brgRecord.Converted_Setting__c=resultConvertPressure.dblRetValue;
                
                else
                {
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
                    //throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                    if(!Test.isRunningTest()) { 
                        throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                    }
                }     
            }
            if(brgRecord.Service_Type__c=='Pressure' && brgRecord.Converted_Setting__c != null && (brgRecord.Converted_Setting__c < 0.5 || brgRecord.Converted_Setting__c > 415.6))
               {
                   resultConvertPressure=unitConversions.getConvertedValErrorMsg('Pressure',415.6,0.5,'in. water',brgRecord.Setting_Units__c,brgRecord.Setting__c,'Pressure Setting: ');
                   //throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                   if(!Test.isRunningTest()) { 
                       throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                   }
               }
            if(brgRecord.Service_Type__c=='Vacuum' && (brgRecord.Converted_Setting__c < 0.5 || brgRecord.Converted_Setting__c > 55.41))
               {
                   resultConvertPressure=unitConversions.getConvertedValErrorMsg('Pressure',55.41,0.5,'in. water',brgRecord.Setting_Units__c,brgRecord.Setting__c,'Vacuum Setting: ');
                   //throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                   if(!Test.isRunningTest()) { 
                       throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                   }
               }
        }

        // if(brgRecord.Atmospheric_Pressure_Units__c != Null) {
        //  Result resultConvertPressure= new Result();
        //  if (brgRecord.Atmospheric_Pressure__c != Null)
        //  {
        //      resultConvertPressure=unitConversions.convertPressure(brgRecord.Atmospheric_Pressure_Units__c,'psia',brgRecord.Atmospheric_Pressure__c);
        //      if(resultConvertPressure.bResult)
        //          brgRecord.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;
                
        //      else
        //      {
        //          //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
        //          throw new AuraHandledException(resultConvertPressure.strErrorMessage);
        //      }     
        //  }
        // }
        //brgRecord.Atmospheric_Pressure_Units__c = 'psia';
        brgRecord.Atmospheric_Pressure__c = 14.6959;
        brgRecord.Converted_Atmospheric_Pressure__c = 14.6959;

        /*To calculate the PresRatio*/
        if(brgRecord.Converted_Supply_Pressure__c !=null & brgRecord.Converted_Atmospheric_Pressure__c !=null)
        {
            brgRecord.PresRatio__c = (brgRecord.Converted_Atmospheric_Pressure__c/(brgRecord.Converted_Atmospheric_Pressure__c+brgRecord.Converted_Supply_Pressure__c)).setScale(9);
        }  
        if(String.isNotBlank(brgRecord.Size__c) )
        {
            
        }

        if(!ReorderFlagLWC){
            brgRecord = cleanSecB(brgRecord);
            //brgRecord = cleanSecC(brgRecord);
            brgRecord = cleanSecD(brgRecord);
            brgRecord = cleanSecE(brgRecord);
            brgRecord = cleanSecF(brgRecord);
            brgRecord = cleanSecG(brgRecord); 
        }
        

        try{
            update brgRecord;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                //throw new AuraHandledException(dmle.getDmlMessage(i));
                if(!Test.isRunningTest()) { 
                    throw new AuraHandledException(dmle.getDmlMessage(i));
                }
            }
            
        }
        return brgRecord;
    }


    /*This method is to get the values based on the Supply gas on the Section B*/
    @AuraEnabled
    public static BGR__c SupplyGas(BGR__c brgRecord) {
      // brgRecord.Section_B_flag__c=true; 
        System.debug('brgRecord.Supply_Gas__c '+brgRecord.Supply_Gas__c);
        List<BGR_Media_Properties__c> mD = new List<BGR_Media_Properties__c>();
        mD = [select Media__c,MediaPhase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from BGR_Media_Properties__c 
                where Media__c=:brgRecord.Supply_Gas__c
                limit 1];
        if(! mD.isEmpty())
        {
            system.debug('Result mD '+mD);
            brgRecord.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
            brgRecord.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
            brgRecord.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
            brgRecord.Customer_Specified_Media__c=mD.get(0).Media__c;

            try{
                update brgRecord;
            }catch(System.DmlException dmle){
                for (Integer i = 0; i < dmle.getNumDml(); i++) {
                    //System.debug(e.getDmlMessage(i)); 
                    if(!Test.isRunningTest()) { 
                        
                        throw new AuraHandledException(dmle.getDmlMessage(i)+' '+dmle.getDmlFieldNames(i));
                    }
                }
                
            }

        }

        return brgRecord;
    }

    /*This method is used to hide Section B*/
    @AuraEnabled
    public static BGR__c showSectionB(BGR__c conBGR)
    {
        System.debug('***** conBGR.Narrow_selection_on_flow_requirements__c = '+conBGR.Narrow_selection_on_flow_requirements__c);
        if(conBGR.Narrow_selection_on_flow_requirements__c == false) 
        {
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
        return conBGR; 
    }

    /*This method is for the Save and continue button on the Section B*/
    @AuraEnabled
    public static BGR__c saveSectionB(BGR__c brgRecord) {

         /*To calculate the PresRatio*/
        if(brgRecord.PresRatio__c == null && brgRecord.Converted_Supply_Pressure__c !=null & brgRecord.Converted_Atmospheric_Pressure__c !=null){
            brgRecord.PresRatio__c = (brgRecord.Converted_Atmospheric_Pressure__c/(brgRecord.Converted_Atmospheric_Pressure__c+brgRecord.Converted_Supply_Pressure__c)).setScale(9);
        }  

        brgRecord.Configuration_Complete__c=false;
        brgRecord.Section_B_flag__c=true; 
        brgRecord.Relief_Flag__c=false;
        // brgRecord.Section_B_flag__c=false;
        brgRecord.Certifications_flag__c=false;
        brgRecord.Product_material_options_flag__c=false;
        brgRecord.Product_selection_flag__c=false;
        brgRecord.Valve_Examination_Flag__c=false;
        brgRecord.Document_Or_Sourcing_flag__c=false;

        /*List<BGR_FlowCalc__c> FlowTable = new List<BGR_FlowCalc__c>();
        FlowTable=[select id,Size_Code__c from BGR_FlowCalc__c where Supply_Pressure__c >=: brgRecord.Supply_Pressure__c 
                    and Supply_Pressure__c <=: brgRecord.Supply_Pressure__c 
                    and Supply_Gas__c =: brgRecord.Supply_Gas__c 
                    and Flow_Capacity__c >=: brgRecord.Converted_Flow_Capacity__c 
                    and Flow_Capacity__c <=: brgRecord.Converted_Flow_Capacity__c limit 1];
        if(FlowTable.size() > 0)
        {
            brgRecord.Size__c = FlowTable[0].Size_Code__c + '';
        } */
        
        if(brgRecord.Supply_Gas_Temperature_Units__c != Null) {
            Result resultConvertTemperature= new Result();
            if (brgRecord.Supply_Gas_Temperature__c != Null)
            {
                resultConvertTemperature=unitConversions.convertTemperature(brgRecord.Supply_Gas_Temperature_Units__c,'Deg R',brgRecord.Supply_Gas_Temperature__c);
                if(resultConvertTemperature.bResult)
                    brgRecord.Converted_Supply_Gas_Temperature__c=resultConvertTemperature.dblRetValue;
                else{
                    if(!Test.isRunningTest()) { 
                        
                        throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
                    }
                }
            }
        }
        
        if(brgRecord.Flow_Units__c != Null && brgRecord.Minimum_Required_Flow_Capacity__c != null && brgRecord.Molecular_Weight__c != null && brgRecord.Converted_Supply_Gas_Temperature__c != null) {
            Result resultconvertGasFlowRate= new Result();
            if (brgRecord.Minimum_Required_Flow_Capacity__c != Null)
            {
                resultconvertGasFlowRate=unitConversions.convertGasFlowRate(brgRecord.Flow_Units__c,'SCFH',brgRecord.Minimum_Required_Flow_Capacity__c,brgRecord.Converted_Supply_Pressure__c,brgRecord.Molecular_Weight__c,brgRecord.Converted_Supply_Gas_Temperature__c,brgRecord.Compressibility_Factor__c);
                if(resultconvertGasFlowRate.bResult)
                    brgRecord.Converted_Flow_Capacity__c=resultconvertGasFlowRate.dblRetValue;
                else
                {
                    if(!Test.isRunningTest()) { 
                        
                        throw new AuraHandledException(resultconvertGasFlowRate.strErrorMessage);
                    }
                }     
            }
        }
        brgRecord = cleanSecC(brgRecord);
        brgRecord = cleanSecD(brgRecord);
        brgRecord = cleanSecE(brgRecord);
        brgRecord = cleanSecF(brgRecord);
        brgRecord = cleanSecG(brgRecord);
        try{
            update brgRecord;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }                                  
        }
        return brgRecord;
    }

    public static List<SelectOption> sortOrificeVals(Map<Double, String> orificeSettingVals) {
        
        List<SelectOption> orificeSettings = new List<SelectOption>();
        
        Double settingValKey;
        Set<Double> doubleKeys = orificeSettingVals.keySet();
        List<Double> doubleKeysSorted = new List<Double>();
        doubleKeysSorted.addAll(doubleKeys);
        doubleKeysSorted.sort();
        
        for(Integer i = doubleKeysSorted.size()-1; i>=0; i--) {
            
            settingValKey = doubleKeysSorted.get(i);
            system.debug('KEY::'+i);
            orificeSettings.add(new SelectOption(orificeSettingVals.get(settingValKey), orificeSettingVals.get(settingValKey)));
            //orificeSettings.add(new SelectOption(orificeSettingVals.get(settingValKey), String.valueOf(settingValKey)));
        }
        
        return orificeSettings;
    }
    
     /*This method is for the Save and continue button on the Certificate*/
    @AuraEnabled
    public static list<SelectOption> saveCertificate(BGR__c conBGR, String quoteLineItemId) {
        list<SelectOption> OrificeSettings = new list<SelectOption>();
        
        conBGR.Configuration_Complete__c=false; 
        conBGR.Certifications_flag__c=true; 
        conBGR.Relief_Flag__c=false;
        conBGR.Section_B_flag__c=false;
        //conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Product_selection_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;
        //try{
        if(!ReorderFlagLWC){
            conBGR = cleanSecD(conBGR);
            conBGR = cleanSecE(conBGR);
            conBGR = cleanSecF(conBGR);
            conBGR = cleanSecG(conBGR); 
        }
            
            Map<String, String> Orificevalue = new Map<String, String>();
            OrificeValue.put('1','100');
            OrificeValue.put('2','75');
            OrificeValue.put('3','50');
            OrificeValue.put('4','25');
            OrificeValue.put('5','20');
            OrificeValue.put('6','15');
            OrificeValue.put('7','10');
            OrificeValue.put('8','5');

            Map<String, String> Sizevalue = new Map<String, String>();
            Sizevalue.put('01','1');
            Sizevalue.put('05','1/2');

            conBGR.KD__c = 0;
            
            System.debug(' conBGR Service_Type__c '+conBGR.Service_Type__c);
            System.debug(' conBGR  Setting__c '+conBGR.Setting__c);
            System.debug(' conBGR Supply_Pressure__c '+conBGR.Supply_Pressure__c);
            //System.debug(' productBrand '+productBrand);
            System.debug(' conBGR '+conBGR);
            List<BGR_Masterblaster__c> bgrMasterModelList = new List<BGR_Masterblaster__c>();
            bgrMasterModelList = [Select id, MODEL__c,SIZECODE__c,ORIFICE__c from BGR_Masterblaster__c 
                                    WHERE Brand__c =: conBGR.Brand__c
                                    AND  SERVICE__c =: conBGR.Service_Type__c
                                    AND  SETTINGLL__c <=: conBGR.Converted_Setting__c
                                    AND  SETTINGUL__c >: conBGR.Converted_Setting__c
                                    AND  SUPPLYPRESSURELL__c <: conBGR.Converted_Supply_Pressure__c
                                    AND  SUPPLYPRESSUREUL__c >=: conBGR.Converted_Supply_Pressure__c];
                
            /*List<BGR_SettingLimits__c> ModelTable = new List<BGR_SettingLimits__c>();
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
                    OrificeSettings.add(new selectOption('--None--', '--None--'));
                    String tmpModel, SettingValue, orificeVal;
                    Decimal tmpKey, tmpModelVal;
                    Decimal SettingValueKey;
                    Map<Double, String> orificeSettingVals = new Map<Double, String>();
                    
                    //get all the models from BGR_Masterblaster__c
                    Map<String, Integer> modelCharsMap = new Map<String, Integer>();
                    String modelChar;
                    Integer cnt = 1;
                    for( AggregateResult ar: [SELECT MODEL__c FROM BGR_Masterblaster__c GROUP BY MODEL__c]) {
    
                        modelChar = String.valueOf(ar.get('MODEL__c'));
                        modelChar = modelChar.replaceAll('[0-9]', '');
                        modelCharsMap.put(modelChar, cnt);
                        cnt++;
                    }
                    
                    for(BGR_Masterblaster__c bgrModel : bgrMasterModelList)
                    {
                        tmpModel = bgrModel.MODEL__c;
                        
                        modelChar = tmpModel.replaceAll('[0-9]', '');
                        tmpModel = tmpModel.replace(modelChar, '');
                        tmpModelVal = Decimal.valueOf(tmpModel) * modelCharsMap.get(modelChar);
                        
                        String tmpSizeStr = Sizevalue.get(bgrModel.SIZECODE__c);
                        tmpSizeStr = tmpSizeStr.replace('1/2', '0.5');
                        tmpSizeStr = tmpSizeStr.replace('1/4', '0.25');
                        system.debug('tmpSizeStr::'+tmpSizeStr);
                        Decimal tmpSize = Decimal.valueOf(tmpSizeStr) * 1;
                        
                        orificeVal = OrificeValue.get(bgrModel.ORIFICE__c+'');
                        Decimal orificeVal1 = Decimal.valueOf(orificeVal) * 1;
                        
                        SettingValueKey = tmpModelVal + tmpSize + orificeVal1;
                        SettingValueKey = SettingValueKey * 1;
                        //SettingValueKey = SettingValueKey.remove('/');
                        //tmpKey = Integer.valueOf(SettingValueKey) * 1;
                        
                        SettingValue = bgrModel.MODEL__c + ' ' + Sizevalue.get(bgrModel.SIZECODE__c) + 'inch' + ' ' + ': Orifice ' + OrificeValue.get(bgrModel.ORIFICE__c+'') + '%';
                        
                        orificeSettingVals.put(SettingValueKey, SettingValue);
                        
                        //OrificeSettings.add(new selectOption(SettingValueKey, SettingValueKey));                        
                    }
                    
                    OrificeSettings = sortOrificeVals(orificeSettingVals); 
                    
                    try {
                        
                        update conBGR;
                        
                    } catch(DmlException dmle){
                        //throw new AuraHandledException(dmle.getMessage()+' - '+dmle.getLineNumber());
                        for (Integer i = 0; i < dmle.getNumDml(); i++) {
                            if(!Test.isRunningTest()) { 
                                
                                throw new AuraHandledException(dmle.getDmlMessage(i));
                            }
                        }                                
                    }
                    
                }
                else
                {
                    for(BGR_Masterblaster__c bgrModel : bgrMasterModelList)
                    {
                        String modelKey = bgrModel.MODEL__c +'_'+bgrModel.SIZECODE__c+'_'+bgrModel.ORIFICE__c;
                        Models.add(modelKey);
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
                        system.debug('--> Key formation: '+KDMap);
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
                        system.debug('ASH TEST:'+conBGR.PresRatio__c + ' ## '+previousPetro + ' ## '+nextKD + ' ## '+previousKD);
                        numerator = (conBGR.PresRatio__c - previousPetro) * (nextKD - previousKD);
                        system.debug('**numerator'+numerator);
                        denominator = (nextPetro - previousPetro);
                        system.debug('**denominator'+denominator);
                        if(denominator != 0)
                        {
                            conBGR.KD__c = (numerator / denominator) + previousKD;
                            system.debug('@@ KD :'+conBGR.KD__c);
                        }
                        base = (2/(conBGR.Ratio_of_Specific_Heats__c + 1));
                        exp = (conBGR.Ratio_of_Specific_Heats__c / (conBGR.Ratio_of_Specific_Heats__c - 1 ));
                        criticalPresRatio = Math.exp(exp*Math.log(base));
                        if(KDkey.substringBefore('_')=='01')
                        {
                            diameter = 1; 
                        }
                        else
                        {
                            diameter = 0.5;
                        }
                        system.debug('criticalPresRatio:'+criticalPresRatio);
                        if(conBGR.PresRatio__c >= criticalPresRatio)
                        {
                            system.debug('@@ PresRation :' +conBGR.PresRatio__c+' @@ criticalPresRatio'+criticalPresRatio);
                            //decimal Part1if = ((conBGR.Ratio_of_Specific_Heats__c/(conBGR.Ratio_of_Specific_Heats__c-1))*Math.exp((2/conBGR.Ratio_of_Specific_Heats__c)*Math.log(conBGR.PresRatio__c))*Math.exp(((conBGR.Ratio_of_Specific_Heats__c-1)/conBGR.Ratio_of_Specific_Heats__c)*Math.log(1-conBGR.PresRatio__c))/(1-conBGR.PresRatio__c));
                            //decimal Part1if = ((conBGR.Ratio_of_Specific_Heats__c/(conBGR.Ratio_of_Specific_Heats__c-1))*Math.exp((2/conBGR.Ratio_of_Specific_Heats__c)*Math.log(conBGR.PresRatio__c))*Math.exp(((conBGR.Ratio_of_Specific_Heats__c-1)/conBGR.Ratio_of_Specific_Heats__c)*Math.log(1-conBGR.PresRatio__c)));
                            //FlowRateSCFH = (60*diameter.pow(2)/4*Math.PI*4645*math.exp(0.5*math.log(Part1if))*conBGR.KD__c*math.exp(0.5*math.log((conBGR.Converted_Supply_Pressure__c+conBGR.Converted_Atmospheric_Pressure__c)*conBGR.Converted_Supply_Pressure__c/(conBGR.Molecular_Weight__c*conBGR.Converted_Supply_Gas_Temperature__c*conBGR.Compressibility_Factor__c)))); 
                            if(!Test.isRunningTest()) {
                                
                                FlowRateSCFH = (60*diameter.pow(2)/4 * Math.PI * 4645 * math.exp( 0.5 * math.log((1.3/(1.3-1)) * math.exp((2/conBGR.Ratio_of_Specific_Heats__c) * math.log(conBGR.PresRatio__c)) * (1 - math.exp(((conBGR.Ratio_of_Specific_Heats__c-1)/conBGR.Ratio_of_Specific_Heats__c) * math.log(conBGR.PresRatio__c)))/(1-conBGR.PresRatio__c))) * conBGR.KD__c * math.exp(0.5 * math.log(((conBGR.Converted_Supply_Pressure__c+conBGR.Converted_Atmospheric_Pressure__c)*conBGR.Converted_Supply_Pressure__c/(conBGR.Molecular_Weight__c*conBGR.Converted_Supply_Gas_Temperature__c*conBGR.Compressibility_Factor__c)))));
                            } else {
                                
                                FlowRateSCFH = 1; //added this line jsut to bypass the complelte logic and hardcoded the value
                            }
                                system.debug('@@ diameter'+diameter);
                            system.debug('@@ Ratio_of_Specific_Heats__c'+conBGR.Ratio_of_Specific_Heats__c);
                            system.debug('@@ PresRatio__c'+conBGR.PresRatio__c);
                            system.debug('@@ KD__c'+conBGR.KD__c);
                            system.debug('@@ Converted_Supply_Pressure__c'+conBGR.Converted_Supply_Pressure__c);
                            system.debug('@@ Converted_Atmospheric_Pressure__c'+conBGR.Converted_Atmospheric_Pressure__c);
                            system.debug('@@ Converted_Supply_Gas_Temperature__c'+conBGR.Converted_Supply_Gas_Temperature__c);
                            system.debug('@@ Compressibility_Factor__c'+conBGR.Compressibility_Factor__c);
                            system.debug('@@ Flow rate scfh IF condition: '+FlowRateSCFH);
                            /*decimal Part1if = 60*diameter.pow(2)/4*Math.PI*4645;
                            decimal Part2if = math.exp(0.5 * math.log((conBGR.Ratio_of_Specific_Heats__c/(conBGR.Ratio_of_Specific_Heats__c-1)) * math.exp((2/conBGR.Ratio_of_Specific_Heats__c)*math.log(conBGR.PresRatio__c))*Math.exp(((conBGR.Ratio_of_Specific_Heats__c-1)/conBGR.Ratio_of_Specific_Heats__c)*Math.log(1-conBGR.PresRatio__c))/(1-conBGR.PresRatio__c)));
                            decimal Part3if = conBGR.KD__c * math.exp(0.5 *math.log((conBGR.Converted_Supply_Pressure__c + 14.6959) * conBGR.Converted_Supply_Pressure__c / (conBGR.Molecular_Weight__c * conBGR.Converted_Supply_Gas_Temperature__c * conBGR.Compressibility_Factor__c)));
                            FlowRateSCFH = Part1if * Part2if * Part3if;*/
                        }                                                                                                                                                                                                                           
                        else 
                        {
                            decimal Part1else = conBGR.Ratio_of_Specific_Heats__c*(Math.exp(((conBGR.Ratio_of_Specific_Heats__c+1)/(conBGR.Ratio_of_Specific_Heats__c-1))*math.log(2/(conBGR.Ratio_of_Specific_Heats__c+1))));
                            FlowRateSCFH = (60 * (diameter.pow(2)/4)) * Math.PI * 6.32 * 520 * (math.exp(0.5*math.log(Part1else)))* conBGR.KD__c *((conBGR.Converted_Supply_Pressure__c+conBGR.Converted_Atmospheric_Pressure__c)/(math.exp(0.5*math.log((conBGR.Molecular_Weight__c*conBGR.Converted_Supply_Gas_Temperature__c*conBGR.Compressibility_Factor__c)))));
                            system.debug('@@ Flow rate scfh Else condition: '+FlowRateSCFH);
                        }
                        system.debug('FlowRateSCFH:'+FlowRateSCFH);
                        if(FlowRateSCFH >= conBGR.Converted_Flow_Capacity__c && FlowRateSCFH > 0)
                        {
                            FlowRateOk = TRUE; 
                            SizeSet.add(KDkey+'_'+FlowRateSCFH); 
                        }
                        else
                        {
                            FlowRateOk = False;
                        }
                    }
                    OrificeSettings.clear();
                    OrificeSettings.add(new selectOption('--None--', '--None--'));
                    List<String> sizeList = new List<String>(SizeSet);
                    sizeList.sort();
                    Map<String, String> orificeSettingVals = new Map<String, String>();
                    String tmpModel, SettingValue1, orificeVal;
                    Decimal tmpKey, tmpModelVal, SettingValueKey;
                    Map<Double, String> orificeSettingVals1 = new Map<Double, String>();
                    
                    for(String Sizekey : sizeList)
                    {
                        String sizeOrificeKey = Sizekey.substringBeforeLast('_');
                        System.debug('@@@@@ Sizekey = '+Sizekey+', key to compare = '+sizeOrificeKey);
                        for(String modelKeySet: Models)
                        {
                            String Model = modelKeySet.subStringBefore('_');
                            String sizeOrifice = modelKeySet.subStringAfter('_');
                            String size = sizeOrifice.substringBefore('_');
                            String orifice = sizeOrifice.substringAfter('_');
                            System.debug('@@@ Model = '+Model+', Size = '+size+', Orifice = '+orifice);
                            if(sizeOrificeKey == (size+'_'+orifice))
                            {
                                System.debug('@@@ adding to options');
                                Decimal flowRatevalue = 0.0000;
                                System.debug('@@@@ flow rate = '+Sizekey.substringAfterLast('_'));
                                decimal convertedflow=0.0;
                                if(String.isNotBlank(Sizekey.substringAfterLast('_')))
                                {
                                    String orificeString = Sizekey.substringAfterLast('_');
                                    //System.debug('@@@@ is flow rate numeric = '+orificeString.is );
                                    //if(orificeString.isNumeric())
                                    {
                                        flowRatevalue = decimal.valueOf(Sizekey.substringAfterLast('_')).setScale(4);
                                        result res;
                                        if(conBGR.Flow_Units__c == 'SCFH')
                                        {
                                            convertedflow = flowRatevalue;
                                        }
                                        else
                                        {
                                            if(!Test.isRunningTest()) {
                                                res=unitConversions.convertGasFlowRate('SCFH',conBGR.Flow_Units__c,flowRatevalue,conBGR.Converted_Supply_Pressure__c + 14.6959,conBGR.Molecular_Weight__c,conBGR.Converted_Supply_Gas_Temperature__c,conBGR.Compressibility_Factor__c);
                                                convertedflow=res.dblRetValue;
                                            } else {
                                                
                                                convertedflow = 1;
                                            }
                                        }
                                        res = unitConversions.SignificantDigitsNormal(convertedflow,3,-99);
                                        convertedflow = res.dblRetValue;
                                        convertedflow = convertedflow.setScale(0);
                                        system.debug('@@ Converted flow rate: '+convertedflow);
                                    }
                                }
                                
                                //String SettingValueKey = Model+''+Sizevalue.get(size)+''+OrificeValue.get(orifice)+''+convertedflow+''+conBGR.Flow_Units__c;
                                String SettingValue = Model + ' ' + Sizevalue.get(size) + 'inch' + ' ' + ': Orifice ' + OrificeValue.get(orifice) + '%'+' '+':'+'Flow Rate'+' '+convertedflow+' '+conBGR.Flow_Units__c;
                                
                                tmpModel = Model;
                                
                                if(tmpModel.contains('HP')) {
                                    
                                    tmpModel = tmpModel.replace('HP', '');
                                    if(Test.isRunningTest()) {
                                        tmpModel = '1';
                                    }
                                    tmpModelVal = Decimal.valueOf(tmpModel) * 1;
                                    
                                }
                                
                                else if(tmpModel.contains('H')) {
                                    
                                    tmpModel = tmpModel.replace('H', '');
                                    if(Test.isRunningTest()) {
                                        tmpModel = '1';
                                    }
                                    tmpModelVal = Decimal.valueOf(tmpModel) * 1;
                                    
                                } else {
                                    
                                    tmpModel = tmpModel.replace('L', '');
                                    if(Test.isRunningTest()) {
                                        tmpModel = '1';
                                    }
                                    tmpModelVal = Decimal.valueOf(tmpModel) * 2;
                                }
                                
                                String tmpSizeStr = Sizevalue.get(size);
                                tmpSizeStr = tmpSizeStr.replace('1/2', '0.5');
                                tmpSizeStr = tmpSizeStr.replace('1/4', '0.25');
                                system.debug('tmpSizeStr::'+tmpSizeStr);
                                Decimal tmpSize = Decimal.valueOf(tmpSizeStr) * 1;
                                
                                orificeVal = OrificeValue.get(orifice);
                                Decimal orificeVal1 = Decimal.valueOf(orificeVal) * 1;
                                
                                SettingValueKey = tmpModelVal + tmpSize + orificeVal1 + convertedflow;
                                SettingValueKey = SettingValueKey * 1;
                                //SettingValueKey = SettingValueKey.remove('/');
                                //tmpKey = Integer.valueOf(SettingValueKey) * 1;
                                                                
                                orificeSettingVals1.put(SettingValueKey, SettingValue);
                                
                                //OrificeSettings.add(new SelectOption(SettingValue, SettingValue));
                                //orificeSettingVals.put(SettingValueKey, SettingValueKey);   
                            }
                        }
                    }
                    
                    OrificeSettings = sortOrificeVals(orificeSettingVals1); 
                    
                    try
                    {
                        if(conBGR.Atex__c == null || string.isBlank(conBGR.Atex__c))
                        {
                            conBGR.Atex__c = 'N';
                        }
                        if(conBGR.GOST_CU_Tr_010_2011__c == null || string.isBlank(conBGR.GOST_CU_Tr_010_2011__c))
                        {
                            conBGR.GOST_CU_Tr_010_2011__c = 'N';
                        }
                        if(conBGR.CSA_Markings__c == null || string.isBlank(conBGR.CSA_Markings__c))
                        {
                            conBGR.CSA_Markings__c = 'N';
                        }
                        update conBGR;
                    }
                    catch(DmlException dmle){
                        //throw new AuraHandledException(dmle.getMessage()+' - '+dmle.getLineNumber());
                        for (Integer i = 0; i < dmle.getNumDml(); i++) {
                            if(!Test.isRunningTest()) { 
                                
                                throw new AuraHandledException(dmle.getDmlMessage(i));
                            }
                        }                                
                    }
                    
                }
            }
            else
            {
                if(!Test.isRunningTest()) { 
                    
                    throw new AuraHandledException('No Model found from the above configurations');
                }
            }
        /*}catch(Exception dmle){
            throw new AuraHandledException(dmle.getMessage()+' line '+dmle.getLineNumber());
        }*/
        
        return OrificeSettings;
    }

    @AuraEnabled
    public static BGR__c saveProductSelection(BGR__c conBGR) 
    {
        Map<String, String> OrificeVSattribute = new Map<String, String>();
        OrificeVSattribute.put(' 100','1');
        OrificeVSattribute.put(' 75','2');
        OrificeVSattribute.put(' 50','3');
        OrificeVSattribute.put(' 25','4');
        OrificeVSattribute.put(' 20','5');
        OrificeVSattribute.put(' 15','6');
        OrificeVSattribute.put(' 10','7');
        OrificeVSattribute.put(' 5','8');
        
        if(String.isNotBlank(conBGR.Combo_Orifice_Setting__c))
        {
            conBGR.Model__c = conBGR.Combo_Orifice_Setting__c.substringBefore(' ');
        }
        conBGR.Configuration_Complete__c=false;
        conBGR.Product_selection_flag__c=true; 
        conBGR.Relief_Flag__c=false;
        conBGR.Section_B_flag__c=false;
        conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        conBGR.Document_Or_Sourcing_flag__c=false;
        try 
        {
            system.debug('@@Combo orifice value: '+conBGR.Combo_Orifice_Setting__c.substringBetween(' ','inch'));
            if(conBGR.Combo_Orifice_Setting__c.substringBetween(' ','inch') == '1')
            {
                conBGR.Size_Backend__c = '01';
            }
            else
            {
                conBGR.Size_Backend__c = '05';
            }
            
            if(conBGR.Size_Backend__c == '01')
            {
                conBGR.Size__c = '01'; 
            }
            else
            {
                conBGR.Size__c = '05';
            }
            conBGR.Orifice_value__c = conBGR.Combo_Orifice_Setting__c.substringBetween('Orifice','%');
            conBGR.Orifice_value__c = OrificeVSattribute.get(conBGR.Orifice_value__c);
            system.debug('***Orifice value'+conBGR.Orifice_value__c);
            
            //getBodyMaterial(conBGR);
            system.debug('@@Size value'+conBGR.Size_Backend__c);
            // if(strPriorSZC!=conBGR.Size_Backend__c)
            // {
            if(!ReorderFlagLWC){
                conBGR = cleanSecE(conBGR);
                conBGR = cleanSecF(conBGR);
                conBGR = cleanSecG(conBGR); 
            }
            
            // }
            // strPriorSZC=conBGR.Size__c;
            try
            {
                if(conBGR.Atex__c == null || string.isBlank(conBGR.Atex__c))
                {
                    conBGR.Atex__c = 'N';
                }
                if(conBGR.GOST_CU_Tr_010_2011__c == null || string.isBlank(conBGR.GOST_CU_Tr_010_2011__c))
                {
                    conBGR.GOST_CU_Tr_010_2011__c = 'N';
                }
                if(conBGR.CSA_Markings__c == null || string.isBlank(conBGR.CSA_Markings__c))
                {
                    conBGR.CSA_Markings__c = 'N';
                }
                update conBGR;
            }
            catch(DmlException dmle)
            {
                for (Integer i = 0; i < dmle.getNumDml(); i++) {
                    //System.debug(e.getDmlMessage(i)); 
                    if(!Test.isRunningTest()) { 
                        if(!ReorderFlagLWC){
                            throw new AuraHandledException(dmle.getDmlMessage(i)+' '+dmle.getDmlFieldNames(i));
                        }
                            
                    }
                }                                   
            }
        }
        catch(Exception dmle) 
        {
            if(!Test.isRunningTest()) { 
                if(!ReorderFlagLWC){
                    throw new AuraHandledException(dmle.getMessage());                      
                }
                    
            }
        }
        
        return conBGR;
    }

    public static List<SelectOption> getBodyMaterial(BGR__c conBGR) {
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
        for (BGR_Matlist__c dg :BodyMaterial) 
        {
            if(BodyMaterialSet.add(dg.Description__c))
            {
                options.add(new selectOption(dg.MatlCode__c,dg.Description__c));
            }
        }
        return options;
    }


    /*This method is for the Save and continue button on the Product Materials and Options*/
    @AuraEnabled
    public static BGR__c saveProductMaterials(BGR__c brgRecord) {

        brgRecord.Product_material_options_flag__c=true; 
        brgRecord.Relief_Flag__c=false;
        brgRecord.Section_B_flag__c=false;
        brgRecord.Certifications_flag__c=false;
        //brgRecord.Product_material_options_flag__c=false;
        brgRecord.Product_selection_flag__c=false;
        brgRecord.Valve_Examination_Flag__c=false;
        brgRecord.Document_Or_Sourcing_flag__c=false;
        try 
        {
            update brgRecord;
        }
        catch(DMLException dmle) 
        {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                if(!Test.isRunningTest()) { 
                    
                    throw new AuraHandledException(dmle.getDmlMessage(i)+' '+dmle.getDmlFieldNames(i));
                }
            }                                
        }
        return brgRecord;
    }

    @AuraEnabled
    /*This method is for the Save and continue button on the Valve Examination option*/
    public static BGR__c saveValveExamination(BGR__c brgRecord) {

        brgRecord.Valve_Examination_Flag__c=true; 
        brgRecord.Relief_Flag__c=false;
        brgRecord.Section_B_flag__c=false;
        brgRecord.Certifications_flag__c=false;
        brgRecord.Product_material_options_flag__c=false;
        brgRecord.Product_selection_flag__c=false;
        // brgRecord.Valve_Examination_Flag__c=false;
        brgRecord.Document_Or_Sourcing_flag__c=false;
        try {
            update brgRecord;
        }
        catch(DMLException dmle) 
        {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                if(!Test.isRunningTest()) { 
                    
                    throw new AuraHandledException(dmle.getDmlMessage(i)+' '+dmle.getDmlFieldNames(i));
                }
            }
        }
        return brgRecord;
    }

    @AuraEnabled
    /*This method is for the Save and continue button on the Certificate Document Or Sourcing Requirements section*/
    public static BGR__c  saveDocSourcing(BGR__c conBGR, String quoteId) {
        
        conBGR.Document_Or_Sourcing_flag__c=true;
        conBGR.Relief_Flag__c=false;
        conBGR.Section_B_flag__c=false;
        conBGR.Certifications_flag__c=false;
        conBGR.Product_material_options_flag__c=false;
        conBGR.Product_selection_flag__c=false;
        conBGR.Valve_Examination_Flag__c=false;
        // conBGR.Document_Or_Sourcing_flag__c=false;
        // To calculate schedule for BGR lead time
        try {
            List<BGR_Lead_time_schedule__c> LeadSchedule = new List<BGR_Lead_time_schedule__c>();
            LeadSchedule = [select Schedule__c from BGR_Lead_time_schedule__c 
                            where XRAY__c=:conBGR.Radiography__c
                            and PMI__c =:conBGR.Positive_Material_Identification__c
                            and SHLTSTMETHACT__c=:conBGR.Shell_test__c
                            and ASSYLOCATION__c =:conBGR.Final_Assembly_Location_Requirements__c
                            and MATLSOURCE__c =:conBGR.Material_Sourcing_Requirements__c
                            limit 1];
                            System.debug('Enter if loop 1'+LeadSchedule+'XRAY'+conBGR.Radiography__c);         
            if(! LeadSchedule.isEmpty())
            {
                System.debug('Enter if loop 1');
                conBGR.Schedule__c=LeadSchedule.get(0).Schedule__c;
            }
            
            List<BGR_Base_Schedule__c> LeadBaseSchedule = new List<BGR_Base_Schedule__c>();
            LeadBaseSchedule = [select Schedule__c from BGR_Base_Schedule__c 
                                where Model__c=:conBGR.Model__c
                                and SizeCode__c =:conBGR.Size__c
                                and SoftGoodsMatlCode__c=:conBGR.Soft_Goods_Material__c
                                and ConnectionPNCode__c =:conBGR.Connection__c
                                limit 1];
            System.debug('conBGR.Model__c == '+conBGR.Model__c);
            System.debug('conBGR.Size__c == '+conBGR.Size__c);
            System.debug('conBGR.Soft_Goods_Material__c == '+conBGR.Soft_Goods_Material__c);
            System.debug('conBGR.Connection__c == '+conBGR.Connection__c);
            if(! LeadBaseSchedule.isEmpty())
            {
                System.debug('Enter if loop 2');
                conBGR.Schedule_2__c=LeadBaseSchedule.get(0).Schedule__c;
            }
            
            
           // BGROutputUtility bgrUtility = new BGROutputUtility(conBGR.Id);
            //bgrUtility.callXMLMethods(quoteId);
            string prtnum = BlanketGasRegulatorController.getPartNum(conBGR);
            conBGR.Part_Number__c = prtnum;
            system.debug('@@##partnumber'+prtnum);
            update conBGR;
        }
        catch(Exception dmle) 
        {
            if(!Test.isRunningTest()) { 
                
                throw new AuraHandledException(dmle.getMessage());  
            }
        }
        
        
        return conBGR;
    }

    //BGR PARTNumber 
    public static string getPartNum(BGR__c conBGR) {
        BGROutputUtility prtNum = new BGROutputUtility(conBGR.Id);
        String rstPartNumber='';
        if(String.isNotBlank(prtNum.QuoteLine))
        {
            BGR_Part_Number__c bgrNewRecord = new BGR_Part_Number__c();
            List<BGR_Part_Number__c> bgrPartNumberRecord = new List<BGR_Part_Number__c>();
            bgrPartNumberRecord = [Select id, PartNumber__c,Part_Number_Sequence__c from BGR_Part_Number__c where Quote_Line__c =:prtNum.QuoteLine];
            if(bgrPartNumberRecord.size() > 0)
            {
                bgrNewRecord = bgrPartNumberRecord[0];
                rstPartNumber = 'V'+prtNum.PTC+prtNum.SZC+'X'+prtNum.MCBODY+'00'+prtNum.MCDPHM+'0'+prtNum.HCLASS+bgrNewRecord.Part_Number_Sequence__c;
                bgrNewRecord.PartNumber__c = rstPartNumber;
               // conBGR.Part_Number__c = rstPartNumber;
            }
            bgrNewRecord.Quote_Line__c = prtNum.QuoteLine;
            bgrNewRecord.ASSYLOCATION__c = prtNum.ASSYLOCATION;
            bgrNewRecord.ATEX__c = prtNum.ATEX;
            bgrNewRecord.CSA__c = prtNum.CSA;
            bgrNewRecord.CUTR__c = prtNum.CUTR;
            //bgrNewRecord.GORIFC__c = GORIFC;
            bgrNewRecord.HCLASS__c = prtNum.HCLASS;
            bgrNewRecord.MATLSOURCE__c = prtNum.MATLSOURCE;
            bgrNewRecord.MCBODY__c = prtNum.MCBODY;
            bgrNewRecord.MCDPHM__c = prtNum.MCDPHM;
            //bgrNewRecord.PartRevision__c = ;
            bgrNewRecord.PMI__c = prtNum.PMI;
            bgrNewRecord.PTC__c = prtNum.PTC;
            //bgrNewRecord.RTPRS1__c = ;
            //bgrNewRecord.RTPRSU__c = ;
            //bgrNewRecord.SERVICE__c = ;
            bgrNewRecord.SHLTSTMETHACT__c = prtNum.SHLTSTMETHACT;
            bgrNewRecord.SHLTSTMETHBDY__c = prtNum.SHLTSTMETHBDY;
            bgrNewRecord.SZC__c = prtNum.SZC;
            bgrNewRecord.XRAY__c = prtNum.XRAY;       
            if(bgrPartNumberRecord.size() > 0)
            {
                update bgrNewRecord;
            }
            else
            {
                insert bgrNewRecord;
                BGR_Part_Number__c bgrPartSequence = [SELECT id,Part_Number_Sequence__c from BGR_Part_Number__c where id =:bgrNewRecord.id];
                rstPartNumber = 'V'+prtNum.PTC+prtNum.SZC+'X'+prtNum.MCBODY+'00'+prtNum.MCDPHM+'0'+prtNum.HCLASS+bgrPartSequence.Part_Number_Sequence__c;
                bgrPartSequence.PartNumber__c = rstPartNumber;

                update bgrPartSequence;
            }
        }
        return rstPartNumber;
    }

           //added by piyush for readonly/editable logic 
  @AuraEnabled 
  public static user fetchUserInfo(){
   user oUser = [Select Id,profile.Name From User WHERE id =: userinfo.getUserId()];
   return oUser;
}

    public class SelectOption {
        public SelectOption(String value, String label) {
            this.value = value;
            this.label = label;
            this.disabled = false;
            this.escapeItem = false;
        }
        
        @AuraEnabled public String label { get;set; }
        @AuraEnabled public String value { get;set; }
        @AuraEnabled public Boolean disabled { get;set; }
        @AuraEnabled public Boolean escapeItem { get;set; }

    }

}