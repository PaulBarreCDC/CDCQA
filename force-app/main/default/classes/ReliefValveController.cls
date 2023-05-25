/**
 * @File Name          : ReliefValveController.cls
 * @Description        :
 * @Author             : ApexIT
 * @Group              :
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0        -              ApexIT                 Initial Version
 * 1.1      21-Feb-2021      Rohini Hathi           Support Ticket# 161771
 **/
public with sharing class ReliefValveController {
    
    public ReliefValveController() {

    }

    //Flag for Reorder purpose
    public static boolean ReorderFlagLWC=false;
    
    //Used in lwcReliefValve
    public static Relief_Valve__c cleanSecE(Relief_Valve__c conRv){

        conRv.Section_E_Flag__c = false;
        conRv.Model_Size__c = null;
        conRv.Size_Preference__c = null; 

        return conRv;  
    }

    //Used in lwcReliefValve
    public static Relief_Valve__c cleanSecD(Relief_Valve__c conRv){

        conRv.Section_D_Flag__c = false;
        conRv.Type_of_model__c = null;
        conRv.Type_of_overpressure_valve__c = '100'; 
        conRv.Is_flame_arrester_needed_with_your_valve__c = '';
   

        return conRv;  
    }

    //Used in lwcReliefValve
    public static Relief_Valve__c cleanSecC(Relief_Valve__c conRv){

        conRv.Section_C_Flag__c = false;
    
        conRv.Atex_Certificate__c = false;
        conRv.CU_TR__c = false;
        conRv.PED_2014_68_EU_CE_mark__c = false;
        conRv.NACE__c = false;
        conRv.Zone__c = '';
        conRv.Gas_Group__c = '';

        return conRv;  
    }

    //Used in Product selection clean up
    public static Relief_Valve__c cleanSecF(Relief_Valve__c conRv){

        conRv.Section_F_Flag__c = false;
    
        conRv.Quantity__c = null;
        conRv.Drilling__c = '';
        conRv.Body_Material__c = '';
        conRv.Facing__c = '';
        conRv.Seat_Material__c = '';
        conRv.Pressure_Pallet_Material__c = '';
        conRv.Pallet_Type__c = '';
        conRv.Diaphragm_Material__c = '';
        conRv.Vacuum_Pallet_Material__c = '';
        conRv.Pilot_Soft_Goods_Material__c = '';
        conRv.Weight_Material__c = '';
        conRv.Spring_Material__c = '';
        conRv.Fastener_Material__c = '';
        conRv.Steam_Jacket_Material__c = '';
        conRv.Painting_Coating_Option__c = '';
        conRv.Body_Coating_Material__c = '';
        conRv.Pallet_Fastener_Coating_Material__c = '';
        conRv.Element_Material__c = '';
        conRv.Flame_Arrester_Option__c = '';
        conRv.Vacuum_Port_Option__c = '';
        conRv.Pressure_Port_Proximity_Sensor__c = false;
        conRv.Pilot_Action__c = '';
        conRv.Vacuum_Port_Proximity_Sensor__c = false;
        conRv.Manual_Blowdown__c = false;
        conRv.Remote_Sense__c = false;
        conRv.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
        conRv.Field_Test_Connection__c = false;
        conRv.Pilot_Supply_Filter__c = false;

        return conRv;  
    }

    public static Relief_Valve__c cleanSecG(Relief_Valve__c conRv){

        conRv.Method21_Leak_Detection__c = false;
        conRv.Radiography__c = '';
        conRv.Fillet_Weld_Liquid_Dye_Penetrant__c = false;
        conRv.Positive_Material_Identification__c = '';
        conRv.Liquid_Dye_Penetrant__c = '';
        conRv.Ultrasonic_Examination__c = false;
        conRv.Magnetic_Particle_Examination__c = false;
        conRv.Brinell_hardness_examination__c = false;
        conRv.Charpy_Impact_Testing__c = false;
        conRv.Visual_Casting_Examination__c = false;
        conRv.Intergranular_Corossion_Test__c = false;
        conRv.Shell_Test_Valve_Body__c = '';

        return conRv;  
    }

    //Used in lwcReliefValve
    public static Relief_Valve__c cleanSecB(Relief_Valve__c conRv){

        conRv.Section_B_Flag__c = false;
       
        conRv.Atmospheric_Pressure__c = 14.6959;
        conRv.Atmospheric_Pressure_Units__c = 'psia';
        
        

        if(conRv.Relief_Type__c == 'Pressure' ){


            conRv.Vacuum_Setting__c = null;
            conRv.Max_Process_Pressure__c = null;

            conRv.Media_Type__c = 'Air';
            conRv.Customer_Specified_Media_Name__c = null;
            conRv.Ratio_of_Specific_Heats__c = 1.4;
            conRv.Molecular_Weight__c = 28.964;
            conRv.Compressibility_Factor__c = 1;
            //Pressure Media and corresponding fields js side
            conRv.Pressure_Relief_Req_Flow_Rate__c = null;
            // conRv.Pressure_Relief_Req_Flow_Units__c = '';
            conRv.Converted_Pressure_Relief_Req_Flow__c = null;
            conRv.Converted_Relieving_Pressure_Value__c = null;
            conRv.Enter_Relieving_Pressure_Value__c = 0;
            //conRv.Enter_Relieving_Pressure_Units__c = '';
            conRv.Overpressure__c = null;
            conRv.Pressure_Relieving_Temperature__c = null;
            //conRv.Pressure_Relieving_Temperature_Units__c = '';
            conRv.Converted_Pressure_Relieving_Temperature__c = null;

        }
        if(conRv.Relief_Type__c == 'Vacuum'){

            conRv.Pressure_Setting__c = null;
            conRv.Back_Pressure__c = null;
            conRv.V_Customer_Specified_Media_Name__c = null;
            conRv.Vacuum_Media__c = 'Air';
            conRv.V_Ratio_of_Specific_Heats__c = 1.4;
            conRv.V_Molecular_Weight__c = 28.964;
            conRv.V_Compressibility_Factor__c = 1;
            conRv.Vacuum_Relief_Req_Flow__c = null;
            conRv.Converted_Vacuum_Relief_Req_Flow__c = null;

            conRv.V_Enter_Relieving_Vacuum_Value__c = 0;
            conRv.V_Converted_Relieving_Vacuum_Value__c = null;

            conRv.V_Overpressure_Vacuum_Value__c = null;
            conRv.V_Vacuum_Relieving_Temperature__c = null;
            conRv.V_Converted_Vacuum_Relieving_Temperature__c = null;

        }
        if( conRv.Relief_Type__c == 'Pressure & Vacuum'){

            conRv.Media_Type__c = 'Air';
            conRv.Ratio_of_Specific_Heats__c = 1.4;
            conRv.V_Customer_Specified_Media_Name__c = null;
            conRv.Customer_Specified_Media_Name__c = null;
            conRv.Molecular_Weight__c = 28.964;
            conRv.Compressibility_Factor__c = 1;
            //Pressure Media and corresponding fields js side
            conRv.Pressure_Relief_Req_Flow_Rate__c = null;
            // conRv.Pressure_Relief_Req_Flow_Units__c = '';
            conRv.Converted_Pressure_Relief_Req_Flow__c = null;
            conRv.Converted_Relieving_Pressure_Value__c = null;
            conRv.Enter_Relieving_Pressure_Value__c = 0;
            //conRv.Enter_Relieving_Pressure_Units__c = '';
            conRv.Overpressure__c = null;
            conRv.Pressure_Relieving_Temperature__c = null;
            //conRv.Pressure_Relieving_Temperature_Units__c = '';
            conRv.Converted_Pressure_Relieving_Temperature__c = null;

            conRv.Vacuum_Media__c = 'Air';
            conRv.V_Ratio_of_Specific_Heats__c = 1.4;
            conRv.V_Molecular_Weight__c = 28.964;
            conRv.V_Compressibility_Factor__c = 1;
            conRv.Vacuum_Relief_Req_Flow__c = null;
            conRv.Converted_Vacuum_Relief_Req_Flow__c = null;

            conRv.V_Enter_Relieving_Vacuum_Value__c = 0;
            conRv.V_Converted_Relieving_Vacuum_Value__c = null;

            conRv.V_Overpressure_Vacuum_Value__c = null;
            conRv.V_Vacuum_Relieving_Temperature__c = null;
            conRv.V_Converted_Vacuum_Relieving_Temperature__c = null;
        }
        

		return conRv;    
    }
    


    //Used in lwcReliefValve
    @AuraEnabled
    public static Relief_Valve__c getRvRecord(Id recordId){
        return [SELECT  Converted_Back_Pressure__c, Converted_Relieving_Pressure_Value__c,
        Converted_Max_Process_Pressure__c, Converted_Pressure_Relieving_Temperature__c, V_Converted_Vacuum_Relieving_Temperature__c,
        V_Converted_Relieving_Vacuum_Value__c, Converted_Pressure_Relief_Req_Flow__c, Converted_Vacuum_Relief_Req_Flow__c, Converted_Atmospheric_Pressure__c, 
        Converted_Pressure_Setting__c, Converted_Vacuum_Setting__c, Is_flame_arrester_needed_with_your_valve__c, Type_of_overpressure_valve__c, Type_of_model__c, Constraint_Product_Selection_By_Flow__c, 
        Molecular_Weight__c, Compressibility_Factor__c, Ratio_of_Specific_Heats__c,
        V_Ratio_of_Specific_Heats__c, V_Molecular_Weight__c, V_Compressibility_Factor__c, Model_name__c, Size__c, 
       // Drilling__c, Body_Material__c,  Facing__c, Seat_Material__c,Pressure_Pallet_Material__c, Pallet_Type__c,         
        Atex_Certificate__c, CU_TR__c,  PED_2014_68_EU_CE_mark__c, Gas_Group__c, Zone__c, NACE__c, Model_Size__c, Size_Preference__c, 
        Pressure_Setting__c, Pressure_Setting_Units__c, Vacuum_Setting__c, Vacuum_Setting_Units__c //Service Ticket 161771
        FROM Relief_Valve__C where id = :recordId];
    }

    /*This method is to get Pressure Media*/
    @AuraEnabled(cacheable=true)
    public static List<SelectOption> fetchMediaList() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Customer Specified','Customer Specified'));
        List<Media_Property__c> mediaPropertyList=[select Media_Phase__c,Media__c from Media_Property__c where ValveDisp__c != 0 ORDER BY Media__c];
        for (Media_Property__c mP:mediaPropertyList) 
        {
            options.add(new selectOption(mP.Media__c,mP.Media__c));
        }
        return options;
    }

    /*This method is to get Vacuum Media*/
    @AuraEnabled(cacheable=true)
    public static List<SelectOption> fetchVacMediaList() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Customer Specified','Customer Specified'));
        List<Media_Property__c> mediaPropertyList=[select Media_Phase__c,Media__c from Media_Property__c where ValveDisp__c != 0 ORDER BY Media__c];
        for (Media_Property__c mP:mediaPropertyList) 
        {
            options.add(new selectOption(mP.Media__c,mP.Media__c));
        }
        return options;
    }

    @AuraEnabled
    /*This method is to get the Media values based on Media type selected for pressure*/
    public static Relief_Valve__c pressureMediaValues(Relief_Valve__c conRV) {
        
        List<Media_Property__c> mD = new List<Media_Property__c>();
        mD = [select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c 
                where Media__c=:conRV.Media_Type__c
                limit 1];
        if(! mD.isEmpty())
        {
            conRV.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
            conRV.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
            conRV.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
        }
        conRV.Section_B_Flag__c = false;
        try{
            update conRV;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return conRV;
    }

    @AuraEnabled
    /*This method is to get the Media values based on Media type selected for Vacuum*/
    public static Relief_Valve__c vacuumMediaValues(Relief_Valve__c conRV) {
        
        system.debug('conRV.Vacuum_Media__c**'+conRV.Vacuum_Media__c);
        List<Media_Property__c> mD = new List<Media_Property__c>();
        mD = [select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c 
                where Media__c=:conRV.Vacuum_Media__c
                limit 1];
        if(! mD.isEmpty())
        {
            conRV.V_Molecular_Weight__c=mD.get(0).MolecularWeight__c;
            conRV.V_Compressibility_Factor__c=mD.get(0).CompressFactor__c;
            conRV.V_Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
        }
        conRV.Section_B_Flag__c = false;
        try{
            update conRV;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
       return conRV;
    }

    /* This is Save and Continue on Section A alongwith Unit Conversions in Section-A 
    Used in lwcReliefValve*/
    @AuraEnabled
    public static Relief_Valve__c saveRelief(Relief_Valve__c conRV) {
        conRV.Section_A_Flag__c=true;
        conRV.Section_B_Flag__c=false;
        conRV.Section_C_Flag__c=false;
        conRV.Section_D_Flag__c=false;
        conRV.Section_E_Flag__c=false;
        conRV.Section_F_Flag__c=false;
        conRV.Section_G_Flag__c=false;
        system.debug('conRV.Pressure_Setting_Units__c'+conRV.Pressure_Setting_Units__c);

        
        if(string.isNotBlank(conRV.Pressure_Setting_Units__c) && conRV.Pressure_Setting_Units__c != Null) {
            Result resultConvertPressureSetting = new Result();
            if (conRV.Pressure_Setting__c != Null)
            {
                resultConvertPressureSetting=unitConversions.convertPressure(conRV.Pressure_Setting_Units__c,'psig',conRV.Pressure_Setting__c);
                if(resultConvertPressureSetting.bResult)
                    conRV.Converted_Pressure_Setting__c=resultConvertPressureSetting.dblRetValue;
                else
                {
                    throw new AuraHandledException(resultConvertPressureSetting.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressureSetting.strErrorMessage));
                }     
            }
        }
        system.debug('conRV.Back_Pressure_Units__c'+conRV.Back_Pressure_Units__c);
        if(string.isNotBlank(conRV.Back_Pressure_Units__c) && conRV.Back_Pressure_Units__c != Null ) {
            Result resultConvertBackPressure= new Result();
            if ( conRV.Back_Pressure__c != null)
            {
                resultConvertBackPressure=unitConversions.convertPressure(conRV.Back_Pressure_Units__c,'psig',conRV.Back_Pressure__c);
                if(resultConvertBackPressure.bResult)
                    conRV.Converted_Back_Pressure__c=resultConvertBackPressure.dblRetValue;
                else
                {
                    throw new AuraHandledException(resultConvertBackPressure.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertBackPressure.strErrorMessage));
                }     
            }
            else{
                conRV.Converted_Back_Pressure__c=0;  
            }
        }
        else{
            conRV.Converted_Back_Pressure__c=0;
        }
        system.debug('conRV.Max_Process_Pressure_Unit__c'+conRV.Max_Process_Pressure_Unit__c);
        if(string.isNotBlank(conRV.Max_Process_Pressure_Unit__c) && conRV.Max_Process_Pressure_Unit__c != Null) {
            Result resultConvertMaxProcessPres= new Result();
            if (conRV.Max_Process_Pressure__c != Null)
            {
                resultConvertMaxProcessPres=unitConversions.convertPressure(conRV.Max_Process_Pressure_Unit__c,'psig',conRV.Max_Process_Pressure__c);
                if(resultConvertMaxProcessPres.bResult)
                    conRV.Converted_Max_Process_Pressure__c=resultConvertMaxProcessPres.dblRetValue;
                else
                {
                    throw new AuraHandledException(resultConvertMaxProcessPres.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertMaxProcessPres.strErrorMessage));
                }     
            }
            
        } 
        system.debug('conRV.Vacuum_Setting_Units__c'+conRV.Vacuum_Setting_Units__c);
        if(string.isNotBlank(conRV.Vacuum_Setting_Units__c) && conRV.Vacuum_Setting_Units__c != Null) {
            Result resultConvertVacuumSetting= new Result();
            if (conRV.Vacuum_Setting__c != Null)
            {
                resultConvertVacuumSetting=unitConversions.convertPressure(conRV.Vacuum_Setting_Units__c,'psig',conRV.Vacuum_Setting__c);
                if(resultConvertVacuumSetting.bResult)
                    conRV.Converted_Vacuum_Setting__c=resultConvertVacuumSetting.dblRetValue;
                else
                {
                    throw new AuraHandledException(resultConvertVacuumSetting.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVacuumSetting.strErrorMessage));
                }     
            }
        }

        if(conRV.Max_Process_Pressure__c == null){
            conRV.Max_Process_Pressure__c = 0;
            conRV.Converted_Max_Process_Pressure__c = 0;
        }
        
        if(!ReorderFlagLWC){
            conRV = cleanSecB(conRV);
            conRV = cleanSecC(conRV);
            conRV = cleanSecD(conRV);
            conRV =  cleanSecE(conRV);
        }
        
        try{
            update conRV;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
            
        }
        return conRV;
    }

    @AuraEnabled
    /* This is Save and Continue on Section B alongwith Unit Conversions in SectionB*/
    public static Relief_Valve__c saveSizingFLowArea(Relief_Valve__c conRV) {
        system.debug('conRV   '+conRV);
        system.debug('V_Vacuum_Relieving_Temperature__c '+conRV.V_Vacuum_Relieving_Temperature__c);
        system.debug('V_Vacuum_Relieving_Temperature_Units__c '+conRV.V_Vacuum_Relieving_Temperature_Units__c);
        system.debug('Vacuum_Relief_Req_Flow__c '+conRV.Vacuum_Relief_Req_Flow__c);
        system.debug('Vacuum_Relief_Required_Flow_Units__c '+conRV.Vacuum_Relief_Required_Flow_Units__c);
        conRV.Section_A_Flag__c=false;
        conRV.Section_B_Flag__c=true;
        conRV.Section_C_Flag__c=false;
        conRV.Section_D_Flag__c=false;
        conRV.Section_E_Flag__c=false;
        conRV.Section_F_Flag__c=false;
        conRV.Section_G_Flag__c=false; 
        
        system.debug('conRV.Vacuum_Media__c*** '+conRV.Vacuum_Media__c);
        if(string.isNotBlank(conRV.Atmospheric_Pressure_Units__c) && conRV.Atmospheric_Pressure_Units__c != Null) {
            Result resultConvertAtmPressure = new Result();
            if (conRV.Atmospheric_Pressure__c != Null)
            {
                resultConvertAtmPressure=unitConversions.convertPressure(conRV.Atmospheric_Pressure_Units__c,'psia',conRV.Atmospheric_Pressure__c);
                if(resultConvertAtmPressure.bResult)
                    conRV.Converted_Atmospheric_Pressure__c=resultConvertAtmPressure.dblRetValue;
                else
                {
                    new AuraHandledException(resultConvertAtmPressure.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertAtmPressure.strErrorMessage));
                }     
            }
        }
        
        /*if(string.isNotBlank(conRV.Enter_Relieving_Pressure_Units__c) && conRV.Enter_Relieving_Pressure_Units__c != Null) {
            Result resultConvertRelievingPressure = new Result();
            if (conRV.Enter_Relieving_Pressure_Value__c != Null)
            {
                resultConvertRelievingPressure=unitConversions.convertPressure(conRV.Enter_Relieving_Pressure_Units__c,'psig',conRV.Enter_Relieving_Pressure_Value__c);
                if(resultConvertRelievingPressure.bResult)
                    conRV.Converted_Relieving_Pressure_Value__c=resultConvertRelievingPressure.dblRetValue;
                else
                {
                    new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingPressure.strErrorMessage));
                }     
            }
        }*/

        //  If(IsNull(GPOPCT), ConvertPressure (PosFlowPres, PosFlowPresUOM, "psig"), ConvertPressure (RTPRS1 * (GPOPCT + 100%), RTPRSU, "psig")
        if (conRV.Enter_Relieving_Pressure_Value__c != Null && string.isNotBlank(conRV.Enter_Relieving_Pressure_Units__c) && conRV.Enter_Relieving_Pressure_Units__c != Null){
            System.debug('chkkk Found 1');
            Result resultConvertRelievingPressure = new Result();
            resultConvertRelievingPressure=unitConversions.convertPressure(conRV.Enter_Relieving_Pressure_Units__c,'psig',conRV.Enter_Relieving_Pressure_Value__c);
            if(resultConvertRelievingPressure.bResult)
                conRV.Converted_Relieving_Pressure_Value__c=resultConvertRelievingPressure.dblRetValue;
            else
            {
                new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingPressure.strErrorMessage));
            }    

        }else if(conRV.Overpressure__c != Null && conRV.Pressure_Setting__c != Null && string.isNotBlank(conRV.Pressure_Setting_Units__c) && conRV.Pressure_Setting_Units__c != Null){
            System.debug('chkkk Found 2');
            Result resultConvertRelievingPressure = new Result();
            resultConvertRelievingPressure=unitConversions.convertPressure(conRV.Pressure_Setting_Units__c,'psig',(conRV.Pressure_Setting__c)*(1 + conRV.Overpressure__c/100));
            if(resultConvertRelievingPressure.bResult)
                conRV.Converted_Relieving_Pressure_Value__c = resultConvertRelievingPressure.dblRetValue;
            else
            {
                throw new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingPressure.strErrorMessage));
            }     
   
        }
        System.debug('Converted_Relieving_Pressure_Value__c is '+ conRV.Converted_Relieving_Pressure_Value__c);
        //If(IsNull(GVOPCT), ConvertPressure (VacFlowPres, VacFlowPresUOM, "psig"), ConvertPressure (VTPRS1 * (GVOPCT + 100%), VTPRSU, "psig")
        if (RVProductNarrowing.checkForNullAndZero(conRV.V_Enter_Relieving_Vacuum_Value__c) == false && string.isNotBlank(conRV.V_Enter_Relieving_Vacuum_units__c)){

            Result resultConvertRelievingVacuum = new Result();
            resultConvertRelievingVacuum=unitConversions.convertPressure(conRV.V_Enter_Relieving_Vacuum_units__c,'psig',conRV.V_Enter_Relieving_Vacuum_Value__c);
            if(resultConvertRelievingVacuum.bResult)
                conRV.V_Converted_Relieving_Vacuum_Value__c = resultConvertRelievingVacuum.dblRetValue;
            else
            {
                new AuraHandledException(resultConvertRelievingVacuum.strErrorMessage);
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingVacuum.strErrorMessage));
            }        

        }else if(conRV.V_Overpressure_Vacuum_Value__c != Null && conRV.Vacuum_Setting__c != Null && string.isNotBlank(conRV.Vacuum_Setting_Units__c) && conRV.Vacuum_Setting_Units__c != Null){
            
            Result resultConvertRelievingVacuum = new Result();
            resultConvertRelievingVacuum=unitConversions.convertPressure(conRV.Vacuum_Setting_Units__c,'psig',(conRV.Vacuum_Setting__c)*(1 + conRV.V_Overpressure_Vacuum_Value__c/100));
            if(resultConvertRelievingVacuum.bResult)
                conRV.V_Converted_Relieving_Vacuum_Value__c = resultConvertRelievingVacuum.dblRetValue;
            else
            {
                throw new AuraHandledException(resultConvertRelievingVacuum.strErrorMessage);
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingVacuum.strErrorMessage));
            }     
   
        }

        
        /*if(string.isNotBlank(conRV.V_Enter_Relieving_Vacuum_units__c) && conRV.V_Enter_Relieving_Vacuum_units__c != Null) {
            Result resultConvertRelievingVacuum = new Result();
            if (conRV.V_Enter_Relieving_Vacuum_Value__c != Null)
            {
                resultConvertRelievingVacuum=unitConversions.convertPressure(conRV.V_Enter_Relieving_Vacuum_units__c,'psig',conRV.V_Enter_Relieving_Vacuum_Value__c);
                if(resultConvertRelievingVacuum.bResult)
                    conRV.V_Converted_Relieving_Vacuum_Value__c=resultConvertRelievingVacuum.dblRetValue;
                else
                {
                    new AuraHandledException(resultConvertRelievingVacuum.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingVacuum.strErrorMessage));
                }     
            }
        }*/
        
        if(string.isNotBlank(conRV.Pressure_Relieving_Temperature_Units__c) && conRV.Pressure_Relieving_Temperature_Units__c != Null) {
            Result resultConvertPressureRelievTemp = new Result();
            if (conRV.Pressure_Relieving_Temperature__c != Null)
            {
                Result resultConvertTemperature= new Result();
                resultConvertTemperature=getConvertedValErrorMsgRV('RVTemperature',0,'Deg R',conRV.Pressure_Relieving_Temperature_Units__c,conRV.Pressure_Relieving_Temperature__c,'Pressure Relieving Temperature');
                if(resultConvertTemperature.bErrorCheck)
                	throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
                else
                {					
                    resultConvertPressureRelievTemp=unitConversions.convertTemperature(conRV.Pressure_Relieving_Temperature_Units__c,'Deg R',conRV.Pressure_Relieving_Temperature__c);
                    if(resultConvertPressureRelievTemp.bResult)
                        conRV.Converted_Pressure_Relieving_Temperature__c=resultConvertPressureRelievTemp.dblRetValue;
                    else
                    {
                        new AuraHandledException(resultConvertPressureRelievTemp.strErrorMessage);
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressureRelievTemp.strErrorMessage));
                    }
                }     
            }
        } 
        
        if(string.isNotBlank(conRV.V_Vacuum_Relieving_Temperature_Units__c) && conRV.V_Vacuum_Relieving_Temperature_Units__c != Null) {
            Result resultConvertVacuumRelievingTemp = new Result();
            if (conRV.V_Vacuum_Relieving_Temperature__c != Null)
            { 
                    Result resultConvertTemperatureerrormsg= new Result();           
                    resultConvertVacuumRelievingTemp=unitConversions.convertTemperature(conRV.V_Vacuum_Relieving_Temperature_Units__c,'Deg R',conRV.V_Vacuum_Relieving_Temperature__c);
                    if(resultConvertVacuumRelievingTemp.bResult)
                        conRV.V_Converted_Vacuum_Relieving_Temperature__c=resultConvertVacuumRelievingTemp.dblRetValue;
                    else
                    {
                        new AuraHandledException(resultConvertVacuumRelievingTemp.strErrorMessage);
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVacuumRelievingTemp.strErrorMessage));
                    }
                	if(conRV.V_Converted_Vacuum_Relieving_Temperature__c<=0)
                    {
                        resultConvertTemperatureerrormsg=getConvertedValErrorMsgRV('RVTemperature',0,'Deg R',conRV.V_Vacuum_Relieving_Temperature_Units__c,conRV.V_Vacuum_Relieving_Temperature__c,'Vacuum Relieving Temperature');
                        throw new AuraHandledException(resultConvertTemperatureerrormsg.strErrorMessage);
                    }                
             }
        }
        
        if(string.isNotBlank(conRV.Pressure_Relief_Req_Flow_Units__c) && conRV.Pressure_Relief_Req_Flow_Units__c != Null) {
            Result resultConvertPressureReliefReqFlow = new Result();
            if (conRV.Pressure_Relief_Req_Flow_Rate__c != Null)
            {
                resultConvertPressureReliefReqFlow=unitConversions.convertGasFlowRate(conRV.Pressure_Relief_Req_Flow_Units__c,'SCFH',conRV.Pressure_Relief_Req_Flow_Rate__c,conRV.Converted_Pressure_Setting__c,conRV.Molecular_Weight__c,conRV.Converted_Pressure_Relieving_Temperature__c,conRV.Compressibility_Factor__c);
              //  System.debug('resultConvertPressureReliefReqFlow.dblRetValue' +resultConvertPressureReliefReqFlow.dblRetValue);
                if(resultConvertPressureReliefReqFlow.bResult)
                    conRV.Converted_Pressure_Relief_Req_Flow__c=resultConvertPressureReliefReqFlow.dblRetValue;
                else
                {
                    new AuraHandledException(resultConvertPressureReliefReqFlow.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressureReliefReqFlow.strErrorMessage));
                }     
            }
        }
        
        if(string.isNotBlank(conRV.Vacuum_Relief_Required_Flow_Units__c) && conRV.Vacuum_Relief_Required_Flow_Units__c != Null) {
            Result resultConvertVacuumReliefReqFlow = new Result();
            if (conRV.Vacuum_Relief_Req_Flow__c != Null)
            {
                System.debug('DDDD conRV.V_Compressibility_Factor__c' +conRV.V_Compressibility_Factor__c);
                resultConvertVacuumReliefReqFlow=unitConversions.convertGasFlowRate(conRV.Vacuum_Relief_Required_Flow_Units__c,'SCFH',conRV.Vacuum_Relief_Req_Flow__c,conRV.Converted_Vacuum_Setting__c,conRV.V_Molecular_Weight__c,conRV.V_Converted_Vacuum_Relieving_Temperature__c,conRV.V_Compressibility_Factor__c);
                if(resultConvertVacuumReliefReqFlow.bResult)
                    conRV.Converted_Vacuum_Relief_Req_Flow__c=resultConvertVacuumReliefReqFlow.dblRetValue;
                else
                {
                    throw new AuraHandledException(resultConvertVacuumReliefReqFlow.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVacuumReliefReqFlow.strErrorMessage));
                }     
            }
        }

        if(conRV.Converted_Relieving_Pressure_Value__c == null){
            conRV.Converted_Relieving_Pressure_Value__c = 0;
        }
        if(conRV.V_Converted_Relieving_Vacuum_Value__c == null){
            conRV.V_Converted_Relieving_Vacuum_Value__c = 0;
        }
        
            conRV = cleanSecC(conRV);
            conRV = cleanSecD(conRV);
            conRV =  cleanSecE(conRV);
        
         try{
            update conRV;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return conRV;
    }

    //Dynamic UOM errormsg method for Temperature
    public static result getConvertedValErrorMsgRV(string strConvType,decimal decMinVal,string strBaseUnits,string strUserUnits,decimal value, string fieldname) {
        result res=new result();
		 if (strConvType=='RVTemperature') 
		{
            try{
                List<Temparature__c> temp=[select Multiplier__c,Adder__c,Divider__c from Temparature__c where Temperature_UOM_From__c=:strBaseUnits and Temperature_UOM_To__c=:strUserUnits  LIMIT 1];
                if ( ! temp.isEmpty()) {
                    decimal minVal=((decMinVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                    if (value<=minVal) {
                        res.bResult=true;
                        res.bErrorCheck=true;
                        res.strErrorMessage=fieldname+' : Please enter value greater than '+minVal+' '+strUserUnits;
                    } else {
                        res.bResult=true;
                        res.bErrorCheck=false;
                    }
                }
            } catch (Exception e) {
                res.bResult = false;
                res.dblRetValue=0;
            }
        }

        return res;
    }
        
    /****************Dynamic UOM errormsg method end here***************/
    
    @AuraEnabled
    public static Relief_Valve__c SaveCertifications(Relief_Valve__c conRV){
        // system.debug('conRV record '+conRV);
        // Map<String, Set<String>> modelVsSize;
        // List<selectOption> ModelSizeOptions = new List<selectOption>();
        // List<selectOption> SizePreferenceOptions = new List<selectOption>();
        // Set<String> ModelSet = new Set<String>();
        // Set<String> SizeSet = new Set<String>();
        // Map<String, Set<String>> sizePreferenceVsModelSizeMap = new Map<String, Set<String>>();
        conRV.Section_A_Flag__c=true;
        conRV.Section_B_Flag__c=false;
        conRV.Section_C_Flag__c=true;
        conRV.Section_D_Flag__c=false;
        conRV.Section_E_Flag__c=false;
        conRV.Section_F_Flag__c=false;
        conRV.Section_G_Flag__c=false; 
        
        if(!ReorderFlagLWC){
            conRV = cleanSecD(conRV);
        	conRV =  cleanSecE(conRV);
        }        

        try{
            update conRV;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                //System.debug(e.getDmlMessage(i)); 
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
    
         return conRV;
    }

    /* This is Save and Continue on Section D */
    @AuraEnabled
    public static productNarrowedWrapper SaveProductNarrowing(Relief_Valve__c conRV) {

        productNarrowedWrapper proNar = new productNarrowedWrapper();
        conRV.Section_A_Flag__c=true;
        conRV.Section_B_Flag__c=false;
        conRV.Section_C_Flag__c=false;
        conRV.Section_D_Flag__c=true;
        conRV.Section_E_Flag__c=false;
        conRV.Section_F_Flag__c=false;
        conRV.Section_G_Flag__c=false; 

        if(conRV.Constraint_Product_Selection_By_Flow__c == false){ //Service Ticket 161771
            
            // set PosFlowPresPSIG as double of pressure setting
            System.debug('chkkk found pressure setting  ??? ' +conRV.Pressure_Setting__c + ':: '+ conRV.Pressure_Setting_Units__c);
                       
            if(conRV.Relief_Type__c == 'Pressure' || conRV.Relief_Type__c == 'Pressure & Vacuum'){
                Result resultConvertRelievingPressure = new Result();
            
                resultConvertRelievingPressure=unitConversions.convertPressure(conRV.Pressure_Setting_Units__c,'psig',(conRV.Pressure_Setting__c*2));
                if(resultConvertRelievingPressure.bResult)
                    conRV.Converted_Relieving_Pressure_Value__c = resultConvertRelievingPressure.dblRetValue; //PosFlowPresPSIG
                else
                {
                    throw new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingPressure.strErrorMessage));
                }
            }
            // set VacFlowPresPSIG as double of pressure setting
            if( conRV.Relief_Type__c == 'Vacuum' || conRV.Relief_Type__c == 'Pressure & Vacuum'){
                Result resultConvertRelievingVacuum = new Result();

                System.debug('chkkk found vacuum setting '+ conRV.Vacuum_Setting_Units__c +' :: '+ conRV.Vacuum_Setting__c);
                resultConvertRelievingVacuum=unitConversions.convertPressure(conRV.Vacuum_Setting_Units__c,'psig',(conRV.Vacuum_Setting__c*2));
                if(resultConvertRelievingVacuum.bResult)
                    conRV.V_Converted_Relieving_Vacuum_Value__c = resultConvertRelievingVacuum.dblRetValue;
                else
                {
                    throw new AuraHandledException(resultConvertRelievingVacuum.strErrorMessage);
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertRelievingVacuum.strErrorMessage));
                } 
            }
        }
        
        conRV.EFFMop__c = RVProductNarrowing.getEFFMop(conRV);
        if(conRV.Relief_Type__c == 'Pressure' || conRV.Relief_Type__c == 'Pressure & Vacuum' ){
            
            conRV.PosSetPresOSIG__c = RVProductNarrowing.getPosSetPresOSIG(conRV);
            conRV.EffMBP__c = RVProductNarrowing.getEffMBP(conRV);
           
        }
        else{
            conRV.PosSetPresOSIG__c = 0;
            conRV.EffMBP__c = 0;
        }

        if(conRV.Relief_Type__c == 'Vacuum' || conRV.Relief_Type__c == 'Pressure & Vacuum'){
            conRV.VacSetPresOSIG__c =  RVProductNarrowing.getVacSetPresOSIG(conRV);
        }
        else{
            conRV.VacSetPresOSIG__c = 0;
        }
       
       
        system.debug('Type_of_overpressure_valve__c********** '+conRV.Type_of_overpressure_valve__c);
        system.debug('Type_of_overpressure_valve__c********** '+conRV.Relief_Type__c);
        Set<String> productNarrowedRecords = RVProductNarrowing.getInitialNarrowingRecords(conRV);
        system.debug('productNarrowedRecords********** '+productNarrowedRecords);
        system.debug('productNarrowedRecords.size()********** '+productNarrowedRecords.size());

        if(productNarrowedRecords.size() > 0) 
            proNar.productNarrowedRecords = productNarrowedRecords;
            
        if(!ReorderFlagLWC){
        	conRV =  cleanSecE(conRV);               
        }
        
        try {
            update conRV;
        }
        catch(Exception dmle) 
        {
            //ApexPages.addMessages(dmle);
            throw new AuraHandledException(dmle.getMessage());
        }
        return proNar;
    }

    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class productNarrowedWrapper {
        @AuraEnabled
        public Set<String> productNarrowedRecords{get;set;}

        public productNarrowedWrapper() {
            
            this.productNarrowedRecords = productNarrowedRecords;
        }
    }


    /* This is Save and Continue on Section E and hiding-showing as well as value passing on Section F&G */
    @AuraEnabled
    public static Relief_Valve__c SaveProductSelection(Relief_Valve__c conRV) {
        conRV.Section_A_Flag__c=true;
        conRV.Section_B_Flag__c=false;
        conRV.Section_C_Flag__c=false;
        conRV.Section_D_Flag__c=false;
        conRV.Section_E_Flag__c=true;
        conRV.Section_F_Flag__c=false;
        conRV.Section_G_Flag__c=false; 
        boolean showMultiselect = false;
        Boolean showFlameArrester = false; 

        String[] arrTest;
        if(ReorderFlagLWC){
           // arrTest =  conRV.Model_Size__c.split('\'');
            conRV.Model_name__c = conRV.Model_name__c;
            conRV.Size__c = conRV.Size__c;
          //  string strmodel='';
           // strmodel=[select Description__c from RV_Master_Blaster__c where PTC__c=:conRV.Model_name__c and SZC__c=:conRV.Size__c][0].Description__c;
            
            string szc=conRV.Size__c;
            decimal dec=decimal.valueOf(szc);
            dec=dec/1;
            szc=string.valueOf(dec);
            
            conRV.Model_Size__c=szc+'\" '+conRV.Model_name__c;
           // conRV.Model_Size__c=conRV.Size__c+conRV.Model_name__c;
            
            conRV.Smallest__c=szc;
        }
        else
        {
            arrTest =  conRV.Model_Size__c.split('\"');
            if(!Test.isRunningTest()) 
            {
                conRV.Model_name__c = arrTest[1].trim();
                conRV.Size__c = arrTest[0];
            }
        }
       
        //Added logic to consider the leading zero to size field
        if(conRV.Size__c.length() == 1)
        {
            conRV.Size__c = '0'+conRV.Size__c;
        }
        else
        {
            if(ReorderFlagLWC)
                conRV.Size__c = conRV.Size__c;
            else
            	conRV.Size__c = arrTest[0];
        }
        conRV.Finish_Configuration_Flag__c = false;
        if(!ReorderFlagLWC){
           conRV =  cleanSecF(conRV);
           conRV =  cleanSecG(conRV); 
        }        
        //Added By Abhishek 21stMay
        if(!Test.isRunningTest()) 
        {
            conRV = RVProductNarrowing.getStandardValues(conRV);
        }
        try 
        {
            /*
            if(conRV.Model_Size__c.contains('Fiberglass'))     //check to hide fields in SectionG based on model selected as Fiberglass
            {
                FiberGlass=true;
            } 
            else {
                FiberGlass=false;
            }
            //splitting model &  size
            String strFieldVal= conRV.Model_Size__c;     
            conRV.Size__c = strFieldVal.substringBefore('"').trim(); 
            conRV.Model_name__c = strFieldVal.substringAfter('"').trim();
            //To get value of field Body design
            List<GRV_Models__c> GRVMod = new List<GRV_Models__c>();        
                GRVMod=[Select ASYTYP__c from GRV_Models__c where PTC__c=: conRV.Model_name__c];
                if(GRVMod.get(0).ASYTYP__c=='POV' || GRVMod.get(0).ASYTYP__c=='ERV')
                {
                    if(! GRVMod.isEmpty())  
                    {
                        if(conRV.Relief_Type__c=='Pressure' || conRV.Relief_Type__c=='Pressure / Vacuum')
                        {
                            List<ERV_BodyDesignSet__c> ERVBD = new List<ERV_BodyDesignSet__c>();
                            ERVBD=[Select BodyDesign__c from ERV_BodyDesignSet__c  
                                   where SZC__c=: conRV.Size__c
                                   and ValveSubModel__c=: conRV.Model_name__c   
                                   and SettingLL__c <=: conRV.Pressure_Setting__c 
                                   and SettingUL__c >=: conRV.Pressure_Setting__c 
                                   limit 1];
                            if(! ERVBD.isEmpty())
                            {
                                conRV.Body_Design__c= ERVBD.get(0).BodyDesign__c;
                            }
                        } 
                        else if(conRV.Relief_Type__c=='Vacuum')
                        {
                            List<ERV_BodyDesignSet__c> ERVBD = new List<ERV_BodyDesignSet__c>();
                            ERVBD=[Select BodyDesign__c from ERV_BodyDesignSet__c  
                                   where SZC__c=: conRV.Size__c
                                   and ValveSubModel__c=: conRV.Model_name__c   
                                   and SettingLL__c <=: conRV.Vacuum_Setting__c
                                   and SettingUL__c >=: conRV.Vacuum_Setting__c 
                                   limit 1];
                            if(! ERVBD.isEmpty())
                            {
                                conRV.Body_Design__c= ERVBD.get(0).BodyDesign__c;
                            }
                        }
                    }
                }
                else
                {
                    List<GRV_BodyDesignMAWP__c> BodyDesign = new List<GRV_BodyDesignMAWP__c>();    
                    BodyDesign= [Select ValveSubModel__c, SZC__c, MAWPLL__c, MAWPUL__c, BodyDesign__c from GRV_BodyDesignMAWP__c 
                                 where SZC__c=: integer.valueOf(conRV.Size__c)
                                 and ValveSubModel__c=: conRV.Model_name__c 
                                 and MAWPLL__c <=: conRV.Converted_Max_Process_Pressure__c 
                                 and MAWPUL__c >=: conRV.Converted_Max_Process_Pressure__c 
                                 limit 1];
                    if(! BodyDesign.isEmpty())
                    {
                        conRV.Body_Design__c= BodyDesign.get(0).BodyDesign__c;
                    } 
                }
                //to show-hide based on POV model in SectionF//
                List<GRV_Models__c> GRVModels = new List<GRV_Models__c>();  
                GRVModels= [Select ASYTYP__c from GRV_Models__c where PTC__c=: conRV.Model_name__c];
                if(GRVModels.get(0).ASYTYP__c=='POV')
                {
                    if(! GRVModels.isEmpty())
                    {
                        showMultiselect=true;
                    } 
                }
                else
                {
                    showMultiselect=false;
                }
                //to show-hide based on flame arrester attached model in SectionF//
                List<GRV_PVRVFA__c> PVRVFA = new List<GRV_PVRVFA__c>();  
                PVRVFA= [Select PTC__c from GRV_PVRVFA__c where PTC__c=: conRV.Model_name__c];
                if(! PVRVFA.isEmpty())
                {
                    showFlameArrester=true;
                } 
                else
                {
                    showFlameArrester=false;
                }
                //passing values from Models table to SectionG fields//
                List<GRV_Models__c> RVM = new List<GRV_Models__c>();     
                RVM = [Select FilWeldLiqDyePenExam__c, UltrasonicExam__c, MagParticleExam__c, BrinnelHardnessExam__c, VisualCastingExam__c from GRV_Models__c
                       where PTC__c=:conRV.Model_name__c
                       limit 1];
                if(! RVM.isEmpty())
                {
                    if(RVM.get(0).FilWeldLiqDyePenExam__c=='N')
                    {
                        conRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false; 
                    }
                    else{
                        conRV.Fillet_Weld_Liquid_Dye_Penetrant__c=true;
                    }
                    if(RVM.get(0).UltrasonicExam__c=='N')
                    {
                        conRV.Ultrasonic_Examination__c=false; 
                    }
                    else{
                        conRV.Ultrasonic_Examination__c=true;
                    }
                    if(RVM.get(0).MagParticleExam__c=='N')
                    {
                        conRV.Magnetic_Particle_Examination__c=false; 
                    }
                    else{
                        conRV.Magnetic_Particle_Examination__c=true;
                    }
                    if(RVM.get(0).BrinnelHardnessExam__c=='N')
                    {
                        conRV.Brinell_hardness_examination__c=false; 
                    }
                    else{
                        conRV.Brinell_hardness_examination__c=true;
                    }
                    if(RVM.get(0).VisualCastingExam__c=='N')
                    {
                        conRV.Visual_Casting_Examination__c=false; 
                    }
                    else{
                        conRV.Visual_Casting_Examination__c=true;
                    }
                }*/
            update conRV;
        }
        catch(Exception dmle) 
        {
            throw new AuraHandledException(dmle.getMessage());
            //ApexPages.addMessages(dmle);
        }
        return conRV;
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

    /*This method is for passing preset values automatically to other sections
    Not used
    @AuraEnabled
    public static Relief_Valve__c applyDefaluts(Relief_Valve__c conRV) {
        if (conRV.Pressure_Units__c!=null) {
            conRV.Pressure_Setting_Units__c=conRV.Pressure_Units__c;
            conRV.Back_Pressure_Units__c=conRV.Pressure_Units__c;
            conRV.Max_Process_Pressure_Unit__c=conRV.Pressure_Units__c;
            conRV.Enter_Relieving_Pressure_units__c=conRV.Pressure_Units__c;    
            conRV.Vacuum_Setting_Units__c=conRV.Pressure_Units__c;      
            conRV.Atmospheric_Pressure_Units__c=conRV.Pressure_Units__c;
            conRV.V_Enter_Relieving_Vacuum_units__c=conRV.Pressure_Units__c;
        }
        if (conRV.Temperature_Units__c!=null) {
            conRV.Pressure_Relieving_Temperature_Units__c =conRV.Temperature_Units__c;
            conRV.V_Vacuum_Relieving_Temperature_Units__c =conRV.Temperature_Units__c;
        }
        if(conRV.Flow_Rate_Units__c!=null) {
            conRV.Pressure_Relief_Req_Flow_Units__c=conRV.Flow_Rate_Units__c;
            conRV.Vacuum_Relief_Required_Flow_Units__c=conRV.Flow_Rate_Units__c;
        } 
        return conRV;
    }*/


    /*@AuraEnabled(cacheable=true)
    public static ProductMaterialOptionsWrapper productMaterialAndOptions(Relief_Valve__c conRV, String rvId) {
        system.debug('rvId '+rvId+' ==> conRV '+conRV);
        ProductMaterialOptionsWrapper pmo = new ProductMaterialOptionsWrapper();
        if(conRV == null && rvId != null){
            Relief_Valve__c  rvRecord = [SELECT 
                        Id,
                        Model_name__c,
                        Size__c,
                        Converted_Max_Process_Pressure__c, 
                        Drilling__c, 
                        Dummy_Atex__c,
                        Dummy_Nace__c,
                        Body_Material__c,
                        Seat_Material__c,
                        Pallet_Type__c,
                        Diaphragm_Material__c,
                        Dummy_PED__c,
                        Body_Design__c
                        FROM Relief_Valve__c 
                        WHERE Id =: rvId];
            pmo = productMaterialOptions(rvRecord);
        }else if(conRV != null && rvId == null){
            pmo = productMaterialOptions(conRV);
        }
        return pmo;
    }*/

   /* public static ProductMaterialOptionsWrapper productMaterialOptions(Relief_Valve__c conRV) {
        
        Schema.sObjectType sobject_type = Relief_Valve__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

        ProductMaterialOptionsWrapper pmoWrapper = new ProductMaterialOptionsWrapper();
        List<selectOption> drillingOptions = new List<selectOption>();
        drillingOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Size__c != null){
            List<GRV_HCLASS__c> Hclass = new List<GRV_HCLASS__c>();
            Hclass= [Select HCLASS__c from GRV_HCLASS__c 
                    where PTC__c=: conRV.Model_name__c
                    and SZC__c=: conRV.Size__c
                    and MaxMAWP__c>=: conRV.Converted_Max_Process_Pressure__c];
            for (GRV_HCLASS__c HC:Hclass) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Drilling__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (HC.HCLASS__c==a.getValue())
                    drillingOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.drillingOptions = drillingOptions;

       // Narrowing for 'BodyMaterial' in SectionF 
        List<selectOption> bodyMaterialOptions = new List<selectOption>(); 
        bodyMaterialOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Size__c != null && conRV.Model_name__c != null && conRV.Converted_Max_Process_Pressure__c != null && conRV.Drilling__c != null 
            && conRV.Dummy_Atex__c != null && conRV.Dummy_Nace__c != null){
            
            List<GRV_MCBODY__c> MCBODY = new List<GRV_MCBODY__c>();
            MCBODY= [Select MCBODY__c from GRV_MCBODY__c 
                    where SZC__c=: conRV.Size__c
                    and PTC__c=: conRV.Model_name__c
                    and MaxMAWP__c=: conRV.Converted_Max_Process_Pressure__c
                    and HCLASS__c=: conRV.Drilling__c
                    and ATEX__c=: conRV.Dummy_Atex__c
                    and NACE__c=: conRV.Dummy_Nace__c];
            for (GRV_MCBODY__c MB:MCBODY) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Body_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (string.valueOf(MB.MCBODY__c)==a.getValue())
                    bodyMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }    
            }
        }
        pmoWrapper.bodyMaterialOptions = bodyMaterialOptions;

        // Narrowing for 'Facing' in SectionF     
        List<selectOption> facingOptions = new List<selectOption>();
        facingOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Body_Material__c != null && conRV.Model_name__c != null){
            List<AggregateResult> GPFace = new List<AggregateResult>();
            GPFace= [Select GPFACE__c from GRV_MCDPHM__c 
                    where MCBODY__c=: conRV.Body_Material__c
                    and PTC__c=: conRV.Model_name__c 
                    group by GPFACE__c];
            for (AggregateResult GPF:GPFace) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Facing__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (GPF.get('GPFACE__c')==a.getValue())
                    facingOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.facingOptions = facingOptions;
        
        //Narrowing for 'SeatMaterial' in SectionF 
        List<selectOption> seatMaterialOptions = new List<selectOption>();
        seatMaterialOptions.add(new selectOption('','--None--'));
        if(conRv != null && conRv.Model_name__c != null && conRv.Size__c != null && conRv.Body_Material__c != null){

            List<AggregateResult> SeatMat = new List<AggregateResult>();
            SeatMat= [Select MCSEAT__c from GRV_MCSPRG__c 
                    where PTC__c=: conRV.Model_name__c 
                    and SZC__c=: conRV.Size__c
                    and MCBODY__c=: conRV.Body_Material__c 
                    group by MCSEAT__c];
            for (AggregateResult SM:SeatMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Seat_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (SM.get('MCSEAT__c')==a.getValue())
                    seatMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }

        }
        pmoWrapper.seatMaterialOptions = seatMaterialOptions;


        //pressurePalletMaterialOptions /* Narrowing for 'PressurePalletMaterial' in SectionF 
        List<selectOption> pressurePalletMaterialOptions = new List<selectOption>();
        pressurePalletMaterialOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Size__c != null && conRV.Body_Material__c != null && conRV.Seat_Material__c != null){
            List<AggregateResult> PresPalMat = new List<AggregateResult>();
            PresPalMat= [Select MCPALL__c from GRV_MCSPRG__c 
                        where PTC__c=: conRV.Model_name__c 
                        and SZC__c=: conRV.Size__c
                        and MCBODY__c=: conRV.Body_Material__c
                        and MCSEAT__c=: conRV.Seat_Material__c
                        group by MCPALL__c];
            for (AggregateResult PPM:PresPalMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Pressure_Pallet_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (PPM.get('MCPALL__c')==a.getValue())
                    pressurePalletMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.pressurePalletMaterialOptions = pressurePalletMaterialOptions;

        // Narrowing for 'PalletType' in SectionF  
        List<selectOption> palletTypeOptions = new List<selectOption>();
        palletTypeOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null){
            List<AggregateResult> PType = new List<AggregateResult>();
            PType= [Select GPTYPE__c from GRV_MCDPHM__c 
                    where PTC__c=: conRV.Model_name__c 
                    group by GPTYPE__c];
            for (AggregateResult PT:PType) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Pallet_Type__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (PT.get('GPTYPE__c')==a.getValue())
                        palletTypeOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }  
            }
        }
        pmoWrapper.palletTypeOptions = palletTypeOptions;
        
        //Narrowing for 'Diaphragm' in SectionF 
        List<selectOption> diaphragmOptions = new List<selectOption>();
        diaphragmOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Pallet_Type__c != null){
            List<AggregateResult> Dia = new List<AggregateResult>();
            Dia= [Select MCDPHM__c from GRV_MCDPHM__c 
                where PTC__c=: conRV.Model_name__c 
                and GPTYPE__c=: conRV.Pallet_Type__c 
                group by MCDPHM__c];
            for (AggregateResult DP:Dia) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Diaphragm_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (DP.get('MCDPHM__c')==a.getValue())
                        diaphragmOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.diaphragmOptions = diaphragmOptions;

        //Narrowing for 'VacuumPalletMaterial' in SectionF 
        List<selectOption> vacuumPalletMaterialOptions = new List<selectOption>();
        vacuumPalletMaterialOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Size__c != null && conRV.Body_Material__c != null && conRV.Seat_Material__c != null){
            List<AggregateResult> VacPalMat = new List<AggregateResult>();
            VacPalMat= [Select MCPALL__c from GRV_MCSPRG__c 
                        where PTC__c=: conRV.Model_name__c 
                        and SZC__c=: conRV.Size__c
                        and MCBODY__c=: conRV.Body_Material__c
                        and MCSEAT__c=: conRV.Seat_Material__c
                        group by MCPALL__c];
            for (AggregateResult VPM:VacPalMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Vacuum_Pallet_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (VPM.get('MCPALL__c')==a.getValue())
                        vacuumPalletMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.vacuumPalletMaterialOptions = vacuumPalletMaterialOptions;

        // Narrowing for 'PilotSoftGoodsMaterial' in SectionF 
        List<selectOption> pilotSoftGoodsMaterialOptions = new List<selectOption>();
        pilotSoftGoodsMaterialOptions.add(new selectOption('','--None--'));
        List<AggregateResult> Pilot = new List<AggregateResult>();
        Pilot= [Select MCPSGD__c from GRV_MCDPHM__c 
                where PTC__c=: conRV.Model_name__c 
                and MCBODY__c=: conRV.Body_Material__c
                and MCDPHM__c=: conRV.Diaphragm_Material__c 
                group by MCPSGD__c];
        if(! Pilot.isEmpty()) 
        {
            for (AggregateResult PG:Pilot) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Pilot_Soft_Goods_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (PG.get('MCPSGD__c')==a.getValue())
                        pilotSoftGoodsMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));                }     
            }
        }
        else
        {
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Pilot_Soft_Goods_Material__c').getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : pick_list_values)
            { 
                pilotSoftGoodsMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
            }
        }
        pmoWrapper.pilotSoftGoodsMaterialOptions = pilotSoftGoodsMaterialOptions;


        // Narrowing for 'WeightMaterial' in SectionF 
        List<selectOption> weightMaterialOptions = new List<selectOption>();
        weightMaterialOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null){
            List<GRV_MCWGHT__c> WeightMat = new List<GRV_MCWGHT__c>();
            WeightMat= [Select MCWGHT__c from GRV_MCWGHT__c 
                    where PTC__c=: conRV.Model_name__c];
            for (GRV_MCWGHT__c WM:WeightMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Weight_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (WM.MCWGHT__c==a.getValue())
                        weightMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.weightMaterialOptions = weightMaterialOptions;
        
        // Narrowing for 'SpringMaterial' in SectionF 
        List<selectOption> springMaterialOptions = new List<selectOption>();
        springMaterialOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Body_Material__c != null && conRV.Dummy_Nace__c != null){
            List<AggregateResult> SpringMat = new List<AggregateResult>();
            SpringMat= [Select MCSPRG__c from GRV_MCSPRG__c 
                        where PTC__c=: conRV.Model_name__c 
                        and MCBODY__c=: conRV.Body_Material__c
                        and NACE__c=: conRV.Dummy_Nace__c
                        group by MCSPRG__c];
            for (AggregateResult SM:SpringMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Spring_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (SM.get('MCSPRG__c')==a.getValue())
                        springMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.springMaterialOptions = springMaterialOptions;
        
        // Narrowing for 'FastenerMaterial' in SectionF    
        List<selectOption> fastenerMaterialOptions = new List<selectOption>();
        fastenerMaterialOptions.add(new selectOption('Stainless Steel','Stainless Steel'));
        if(conRV != null && conRV.Model_name__c != null){
            List<GRV_MCFAST__c> Fastener = new List<GRV_MCFAST__c>();
            Fastener= [Select MCFAST__c from GRV_MCFAST__c 
                    where PTC__c=: conRV.Model_name__c];
            for (GRV_MCFAST__c FM:Fastener) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Fastener_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (FM.MCFAST__c==a.getValue())
                        fastenerMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.fastenerMaterialOptions = fastenerMaterialOptions;
        
        // Narrowing for 'SteamJacketMaterial' in SectionF 
        List<selectOption> steamJacketMaterialOptions = new List<selectOption>();
        steamJacketMaterialOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Body_Material__c != null && conRV.Dummy_PED__c != null){
            List<AggregateResult> SteamJacMat = new List<AggregateResult>();
            SteamJacMat= [Select MCSTMJ__c from GRV_MCSTMJ__c 
                        where PTC__c=: conRV.Model_name__c 
                        and MCBODY__c=: conRV.Body_Material__c
                        and PED__c=: conRV.Dummy_PED__c 
                        group by MCSTMJ__c];
            for (AggregateResult SJM:SteamJacMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Steam_Jacket_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (SJM.get('MCSTMJ__c')==a.getValue())
                        steamJacketMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.steamJacketMaterialOptions = steamJacketMaterialOptions;
        
        // Narrowing for 'ElementMaterial' in SectionF
        List<selectOption> elementMaterialOptions = new List<selectOption>();
        elementMaterialOptions.add(new selectOption('','--None--'));
        List<GRV_PVRVFA__c> PVRVFA = new List<GRV_PVRVFA__c>();
        PVRVFA= [Select PTC__c from GRV_PVRVFA__c where PTC__c=: conRV.Model_name__c];
        if(! PVRVFA.isEmpty())
        {
            conRV.Element_Material_Flag__c=true;
            List<GRV_MCELMT__c> ElementMat = new List<GRV_MCELMT__c>();
            ElementMat= [Select MCELMT__c from GRV_MCELMT__c 
                        where MCBODY__c=: conRV.Body_Material__c];
            for (GRV_MCELMT__c EM:ElementMat) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Element_Material__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (EM.MCELMT__c==a.getValue())
                        elementMaterialOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }         
        }
        else
        {
            conRV.Element_Material_Flag__c=false;
        }
        pmoWrapper.elementMaterialOptions = elementMaterialOptions;

        // Narrowing for 'FlameArresterOption' in SectionF 
        List<selectOption> flameArresterOptions = new List<selectOption>();
        flameArresterOptions.add(new selectOption('','--None--'));
        boolean showFlameArrester = false;
        if(conRV != null && conRV.Model_name__c != null){
            List<GRV_PVRVFA__c> PVRVFAF = new List<GRV_PVRVFA__c>();
            PVRVFAF= [Select PTC__c from GRV_PVRVFA__c where PTC__c=: conRV.Model_name__c];
            if(! PVRVFAF.isEmpty())
            {
                showFlameArrester = true;
                conRV.Flame_Arrester_Flag__c=true;
                List<GRV_GOUTOP__c> Flame = new List<GRV_GOUTOP__c>();
                Flame= [Select GOUTOP__c from GRV_GOUTOP__c 
                        where SZC__c=: conRV.Size__c
                        and ATEX__c=: conRV.Dummy_Atex__c];
                for (GRV_GOUTOP__c FAO:Flame) 
                {
                    List<Schema.PicklistEntry> pick_list_values = field_map.get('Flame_Arrester_Option__c').getDescribe().getPickListValues();
                    for (Schema.PicklistEntry a : pick_list_values) {
                        if (FAO.GOUTOP__c==a.getValue())
                            flameArresterOptions.add(new selectOption(a.getValue(),a.getLabel()));
                    }     
                }         
            }
        }
        pmoWrapper.flameArresterOptions = flameArresterOptions;
        pmoWrapper.showFlameArrester = showFlameArrester;
        //Narrowing for 'VacuumPortOption' in SectionF 
        List<selectOption> vacuumPortOptions = new List<selectOption>();
        vacuumPortOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null && conRV.Converted_Max_Process_Pressure__c != null){
            List<GRV_VPRTOP__c> Vacuum = new List<GRV_VPRTOP__c>();
            Vacuum= [Select VPRTOP__c from GRV_VPRTOP__c 
                    where PTC__c=: conRV.Model_name__c 
                    and MAWPUL__c>=: conRV.Converted_Max_Process_Pressure__c];
            for (GRV_VPRTOP__c VPO:Vacuum) 
            {
                List<Schema.PicklistEntry> pick_list_values = field_map.get('Vacuum_Port_Option__c').getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values) {
                    if (VPO.VPRTOP__c==a.getValue())
                        vacuumPortOptions.add(new selectOption(a.getValue(),a.getLabel()));
                }     
            }
        }
        pmoWrapper.vacuumPortOptions = vacuumPortOptions;

        // Narrowing for 'PilotAction' in SectionF 
        List<selectOption> pilotActionOptions = new List<selectOption>();
        Boolean showMultiselect = false;
        Boolean showMethod21Leak = false;
        pilotActionOptions.add(new selectOption('','--None--'));
        if(conRV != null && conRV.Model_name__c != null){
            List<GRV_Models__c> GRVModels = new List<GRV_Models__c>();
            GRVModels= [Select ASYTYP__c from GRV_Models__c where PTC__c=: conRV.Model_name__c];
            if(GRVModels.get(0).ASYTYP__c=='POV')
            {
                if(! GRVModels.isEmpty())
                {
                    if(conRV.Pallet_Type__c=='Film'){
                        showMethod21Leak = true;
                    }
                    showMultiselect=true;
                    conRV.Pilot_Action_Flag__c=true;
                    List<GRV_GPACT__c> PilotList = new List<GRV_GPACT__c>();
                    PilotList= [Select GPACT__c from GRV_GPACT__c 
                            where BodyDesign__c=: conRV.Body_Design__c];
                    for (GRV_GPACT__c PA:PilotList) 
                    {
                        List<Schema.PicklistEntry> pick_list_values = field_map.get('Pilot_Action__c').getDescribe().getPickListValues();
                        for (Schema.PicklistEntry a : pick_list_values) {
                            if (PA.GPACT__c==a.getValue())
                                pilotActionOptions.add(new selectOption(a.getValue(),a.getLabel()));
                        }     
                    }         
                }
            }
        }
        pmoWrapper.pilotActionOptions = pilotActionOptions;
        pmoWrapper.showMultiselect = showMultiselect;
        pmoWrapper.showMethod21Leak = showMethod21Leak;
        return pmoWrapper;
    }*/

    /* This is Save and Continue on Section F */
   /* @AuraEnabled
   public static Relief_Valve__c SaveProductMaterialOptions(Relief_Valve__c conRV) {
        conRV.Section_A_Flag__c=true;
        conRV.Section_B_Flag__c=false;
        conRV.Section_C_Flag__c=false;
        conRV.Section_D_Flag__c=false;
        conRV.Section_E_Flag__c=false;
        conRV.Section_F_Flag__c=true;
        conRV.Section_G_Flag__c=false; 
        try {
            List<RV_LeadTime_BaseLead__c> BaseLeadSchedule = new List<RV_LeadTime_BaseLead__c>();   //To get the schedule for BaseLead
            BaseLeadSchedule = [Select Schedule__c from RV_LeadTime_BaseLead__c 
                  where SubModel__c =: conRV.Model_name__c
                  and SizeCode__c =: conRV.Size_Preference__c
                  and DrillingCode__c =: conRV.Drilling__c
                  and BodyMatlCode__c =: conRV.Body_Material__c
                  limit 1];
            if(! BaseLeadSchedule.isEmpty())
            {
                conRV.Schedule_BaseLead__c=BaseLeadSchedule.get(0).Schedule__c;
            }
            update conRV;
            system.debug('Schedule_BaseLead__c>>>'+ conRV.Schedule_BaseLead__c);
        }
        catch(Exception dmle) 
        {
            //ApexPages.addMessages(dmle);
            throw new AuraHandledException(dmle.getMessage());
        } 
        return conRV;
    }*/

    @AuraEnabled
    /* This is Save and Continue on Section G */
    public static Relief_Valve__c SaveValveExaminationOption(Relief_Valve__c conRv) {
        conRV.Section_A_Flag__c=true;
        conRV.Section_B_Flag__c=false;
        conRV.Section_C_Flag__c=false;
        conRV.Section_D_Flag__c=false;
        conRV.Section_E_Flag__c=false;
        conRV.Section_F_Flag__c=false;
        conRV.Section_G_Flag__c=true; 
        try {
            update conRV;
        }
        catch(Exception dmle) 
        {
            //ApexPages.addMessages(dmle);
            throw new AuraHandledException(dmle.getMessage());                                
        }
        return conRV;
    }

   /* Wrapper Class
    public class ProductMaterialOptionsWrapper {
        @AuraEnabled public list<SelectOption> drillingOptions;
        @AuraEnabled public list<SelectOption> bodyMaterialOptions; 
        @AuraEnabled public list<SelectOption> facingOptions;
        @AuraEnabled public list<SelectOption> seatMaterialOptions;
        @AuraEnabled public list<SelectOption> pressurePalletMaterialOptions;
        @AuraEnabled public list<SelectOption> palletTypeOptions;
        @AuraEnabled public list<SelectOption> diaphragmOptions;
        @AuraEnabled public list<SelectOption> vacuumPalletMaterialOptions;
        @AuraEnabled public list<SelectOption> pilotSoftGoodsMaterialOptions; 
        @AuraEnabled public list<SelectOption> weightMaterialOptions;
        @AuraEnabled public list<SelectOption> springMaterialOptions;
        @AuraEnabled public list<SelectOption> fastenerMaterialOptions;
        @AuraEnabled public list<SelectOption> steamJacketMaterialOptions;
        @AuraEnabled public list<SelectOption> elementMaterialOptions;
        @AuraEnabled public list<SelectOption> flameArresterOptions;
        @AuraEnabled public list<SelectOption> vacuumPortOptions; 
        @AuraEnabled public list<SelectOption> pilotActionOptions;
        @AuraEnabled public Boolean showMultiselect;
        @AuraEnabled public Boolean showMethod21Leak;
        @AuraEnabled public Boolean showFlameArrester;
        
        public ProductMaterialOptionsWrapper() {
        }
    }*/

    /* Wrapper Class
    public class ReliefValveWrapper {
        @AuraEnabled public list<SelectOption> SizePreferenceOptions;
        @AuraEnabled public list<SelectOption> ModelSizeOptions;
        @AuraEnabled public Relief_Valve__c rvObjData;
        //@AuraEnabled public Boolean showFlameArrester;
        
        public ReliefValveWrapper() {
        }
    }*/
  
     //added by piyush for readonly/editable logic 

     		       //added by piyush for readonly/editable logic 
  @AuraEnabled 
  public static user fetchUserInfo(){
   user oUser = [Select Id,profile.Name From User WHERE id =: userinfo.getUserId()];
   return oUser;
}



  @AuraEnabled 
  public static formAccessibilityWrapper fetchFormAccessibility(string rvId, string qliId){

      SBQQ__QuoteLine__c  qli = [SELECT Id, Run_Config_Sync__c,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c
         FROM SBQQ__QuoteLine__c WHERE Id=:qliId];
      string quoteStatus = qli.SBQQ__Quote__r.SBQQ__Status__c;
      formAccessibilityWrapper oformAccessibilityWrapper = new formAccessibilityWrapper();
     // Flame_Product__c FA = DataSelectorWizard.getFlameProductRecord(qliId);

      Relief_Valve__c RV = [SELECT  Converted_Back_Pressure__c, Converted_Relieving_Pressure_Value__c,
        Converted_Max_Process_Pressure__c, Converted_Pressure_Relieving_Temperature__c, V_Converted_Vacuum_Relieving_Temperature__c,
        V_Converted_Relieving_Vacuum_Value__c, Converted_Pressure_Relief_Req_Flow__c, Converted_Vacuum_Relief_Req_Flow__c, Converted_Atmospheric_Pressure__c, 
        Converted_Pressure_Setting__c, Converted_Vacuum_Setting__c, Is_flame_arrester_needed_with_your_valve__c, Type_of_overpressure_valve__c, Type_of_model__c, Constraint_Product_Selection_By_Flow__c, 
        Molecular_Weight__c, Compressibility_Factor__c, Ratio_of_Specific_Heats__c,
        V_Ratio_of_Specific_Heats__c, V_Molecular_Weight__c, V_Compressibility_Factor__c, Model_name__c, Size__c, 
        Atex_Certificate__c,Finish_Configuration_Flag__c, CU_TR__c,Quote_Description_Engineer_Override__c,  PED_2014_68_EU_CE_mark__c, Gas_Group__c, Zone__c, NACE__c, Model_Size__c,
        Pressure_Setting__c, Pressure_Setting_Units__c, Vacuum_Setting__c, Vacuum_Setting_Units__c, //Service Ticket 161771
         Size_Preference__c FROM Relief_Valve__C where id = :rvId];



      oformAccessibilityWrapper.bConfigurationComplete = RV.Finish_Configuration_Flag__c;
      system.debug('Flame_Product__c --> Finish_Configuration_Flag__c ' + RV.Finish_Configuration_Flag__c);
      system.debug('Flame_Product__c Quote_Description_Engineer_Override__c --> ' + RV.Quote_Description_Engineer_Override__c);
      string configStatus= '';
      if(RV.Finish_Configuration_Flag__c){
         if(RV.Quote_Description_Engineer_Override__c){
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

    //#######################################################################################################################

}