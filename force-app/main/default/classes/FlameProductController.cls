public class FlameProductController {
    
    public static boolean ReorderFlagLWC=false;
    
    @AuraEnabled
    public static Flame_Product__c saveApplicationParameters(Flame_Product__c conFA) {
        conFA.Application_Parameters_flag__c=true;
        conFA.Sizing_Flow_Area_flag__c=false;
        conFA.Certifications_flag__c=false;
        conFA.Product_Narrowing_flag__c=false;
        conFA.Product_selection_flag__c=false;
        conFA.Product_Material_and_Options_flag__c=false;
        conFA.Examination_Option_flag__c=false;
        conFA.Certificate_and_sourcing_flag__c=false;
        conFA.Certification_Save_Check_Flag__c=false;
        if(conFA.GasGroupDynamic__c!=null)
        {
             conFA.Gas_Group_Code__c = Decimal.valueOf(conFA.GasGroupDynamic__c);   
        }
        else
            throw new AuraHandledException('Gas Group: Please Select any one of the following');
        	
        if(!ReorderFlagLWC){ 
            System.debug('AAAAAAAAAAAAAVVVc');
            conFA = clearSectBSizingFlowArea(conFA);
            conFA = clearSectCCertifications(conFA);
            conFA = clearSectDProductNarrowing(conFA);
            conFA = clearSectEProductSelection(conFA);
        }

        
        try{
            update conFA;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }            
        }
        return conFA;
    }

    //Method for GasGroup picklist field
    @AuraEnabled(cacheable=true)
    public static List<SelectOption> GasGroupPickValues() {
        List<selectOption> options = new List<selectOption>();       
        List<FA_Input_Attr_Value_Desc__c> GasGroupList=[SELECT Value__c,Attribute__c,
        Text_Description_of_AttributeValue__c, Display_Order__c FROM FA_Input_Attr_Value_Desc__c WHERE Attribute__c=:'ReqdGasGroupLevel' ORDER BY Display_Order__c ASC];
        for (FA_Input_Attr_Value_Desc__c GG:GasGroupList) {
            options.add(new SelectOption(GG.Value__c,GG.Text_Description_of_AttributeValue__c));
        }
        return options;
    }
            
	
    //Commenting out the below as the GasGroup dropdown values are now being fetched from "Input Attr Desc" table
    /*
    public static Map<String,Integer> mapOfGroupGas = new Map<String,Integer> {
        'Methane (MESG ≥ 1.14)' => 0,
        'NEC D (MESG > 0.75)' => 2,
        'NEC C ( MESG > 0.45 ≤ 0.75)' => 4,
        'IEC IIA1 ( MESG ≥ 1.14)' => 0,
        'IEC IIA ( MESG > 0.90)' => 2,
        'IEC IIB3 ( MESG ≥ 0.65)' => 4
    };
	*/
    
    public static FA_Input_Attr_Value_Desc__c[] FASZCList=[SELECT Value__c,Attribute__c,
        Text_Description_of_AttributeValue__c FROM FA_Input_Attr_Value_Desc__c WHERE Attribute__c=:'SZC'];
     
	public static Map<String, String> SZCMAP() {
        Map<String,string> szclist = new Map<String, String>();
        for (FA_Input_Attr_Value_Desc__c sz : FASZCList) {
            if(!szclist.containsKey(sz.Value__c)) {
                szclist.put(sz.Value__c,sz.Text_Description_of_AttributeValue__c);
            }
        }
        return szclist;
    }	
	
    public static map<string,string> mapOfSZC=new map<string,string>(SZCMAP());
    
   /* public static Map<String,String> mapOfSZC = new Map<String,String> {
        '01' => '1" dia connections',
        '02' => '2" dia connections',
        '03' => '3" dia connections',
        '04' => '4" dia connections',
        '06' => '6" dia connections',
        '08' => '8" dia connections',
        '10' => '10" dia connections',
        '12' => '12" dia connections'
    };*/

    public static FA_Input_Attr_Value_Desc__c[] FA_ESZCList=[SELECT Value__c,Attribute__c,
        Text_Description_of_AttributeValue__c, Display_Order__c FROM FA_Input_Attr_Value_Desc__c WHERE Attribute__c=:'ESZC' ORDER BY Display_Order__c ASC];
     
	public static Map<String, String> ESZCMAP() {
        Map<String,string> eszclist = new Map<String, String>();
        for (FA_Input_Attr_Value_Desc__c sz : FA_ESZCList) {
            if(!eszclist.containsKey(sz.Value__c)) {
                eszclist.put(sz.Value__c,sz.Text_Description_of_AttributeValue__c);
            }
        }
        return eszclist;
    }	
	
    public static map<string,string> mapOfESZC=new map<string,string>(ESZCMAP());
    
    /*public static Map<String,String> mapOfESZC = new Map<String,String> {
        '04' => '4" dia element',
        '05' => '5" dia element',
        '06' => '6" dia element',
        '08' => '8" dia element',
        '10' => '10" dia element',
        '12' => '12" dia element',
        '16' => '16" dia element',
        '20' => '20" dia element',
        '24' => '24" dia element',
        '26' => '26" dia element',
        '28' => '28" dia element',
        '30' => '30" dia element'
    };*/

   /**** public static Map<String,String> mapOfModelDesc = new Map<String,String> {
        '7588' => 'Model: 7588',
        '7598' => 'Model: 7598',
        '7618 (End-of-Line)' => 'Model: 7618 (End-of-Line)',
        '7618 (In-Line)' => 'Model: 7618 (In-Line)',
        '7628' => 'Model: 7628',
        '7658A' => 'Model: 7658A',
        '7661' => 'Model: 7661',
        '7678' => 'Model: 7678',
        '7688' => 'Model: 7688',
        '7698' => 'Model: 7698',
        '7758A' => 'Model: 7758A',
        '8400A' => 'Model: 8400A',
        '8500A' => 'Model: 8500A',
        '76C-AF' => 'Model: 76C-AF',
        '76C-UF' => 'Model: 76C-UF',
        '76L-UF' => 'Model: 76L-UF',
        '76T-AF' => 'Model: 76T-AF',
        '76T-UF' => 'Model: 76T-UF',
        '76V-SF (316SS)' => 'Model: 76V-SF (316SS)',
        '76V-SF (Alum)' => 'Model: 76V-SF (Alum)',
        '76W-SF' => 'Model: 76W-SF'
    };*****/
    
    public class SelectOption {
        public SelectOption(String value, String label) {
            this.value = value;
            this.label = label;
            this.disabled = false;
            this.escapeItem = false;
        }
        
        public SelectOption(String value, String label, Boolean isDisabled) {
            this.value = value;
            this.label = label;
            this.disabled = isDisabled;
            this.escapeItem = false;
        }
        
        @AuraEnabled
        public String label { get;set; }
        @AuraEnabled
        public String value { get;set; }
        @AuraEnabled
        public Boolean disabled { get;set; }
        @AuraEnabled
        public Boolean escapeItem { get;set; }        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<SelectOption> fetchFlowingMedia() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Customer Specified','Customer Specified'));
        //List<Media_Property__c> mediaPropertyList=[select Media_Phase__c,Media__c from Media_Property__c where ValveDisp__c != 0 ORDER BY Media__c];
        List<Media_Property__c> mediaPropertyList=[SELECT Media_Phase__c,Media__c,FlameDisp__c FROM Media_Property__c WHERE FlameDisp__c != null ORDER BY FlameDisp__c];
        for (Media_Property__c mP:mediaPropertyList) {
            options.add(new selectOption(mP.Media__c,mP.Media__c));
        }
        return options;
    }    
    
    @AuraEnabled
    /*This method is to get the Media values based on Media type selected for pressure*/
    public static Flame_Product__c flowingMediaValues(Flame_Product__c flmprod) {
        List<Media_Property__c> mD = new List<Media_Property__c>();
        mD = [SELECT Media__c, Media_Phase__c,  MolecularWeight__c,SpecificHeatRatio__c, Density__c, CompressFactor__c 
                FROM Media_Property__c 
                WHERE Media__c=:flmprod.Flowing_Media__c
                LIMIT 1];
        
        if(! mD.isEmpty()) {
            flmprod.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
            flmprod.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
            flmprod.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
        }
        //flmprod.Sizing_Flow_Area_flag__c = false;
        try{
            update flmprod;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return flmprod;
    }
    
    @AuraEnabled
    public static Flame_Product__c saveSizing(Flame_Product__c flmprod){
        flmprod.Application_Parameters_flag__c=false;
        flmprod.Sizing_Flow_Area_flag__c=true;
        flmprod.Certifications_flag__c=false;
        flmprod.Product_Narrowing_flag__c=false;
        flmprod.Product_selection_flag__c=false;
        flmprod.Product_Material_and_Options_flag__c=false;
        flmprod.Examination_Option_flag__c=false;
        flmprod.Certificate_and_sourcing_flag__c=false;

        if (flmprod.Max_Allowable_Pressure_Drop__c == null)
            throw new AuraHandledException('Max. Allowable Pressure Drop: Please Enter a Value');
        if (flmprod.Max_Allowable_Pressure_Drop_Units__c == '' || flmprod.Max_Allowable_Pressure_Drop_Units__c == null)
            throw new AuraHandledException('Max. Allowable Pressure Drop Units: Please Select a Value from the drop down');
        if (flmprod.Required_Flow_Rate__c == null)
            throw new AuraHandledException('Required Flow Rate: Please Enter a Value');
        if (flmprod.Required_Flow_Rate_Units__c == '' || flmprod.Required_Flow_Rate_Units__c == null)
            throw new AuraHandledException('Required Flow Rate Units: Please Select a Value from the drop down');
        if (flmprod.Flowing_Media__c == null || flmprod.Flowing_Media__c == '')
            throw new AuraHandledException('Flowing Media: Please Select a Value from the drop down');
        if (flmprod.Flowing_Media__c == 'Customer Specified' && String.isBlank(flmprod.Media_Name__c))
            throw new AuraHandledException('Customer Specified Media Name: Please Enter a Name');	
        if (flmprod.Flowing_Media__c == 'Customer Specified' && flmprod.Ratio_of_Specific_Heats__c == null)
            throw new AuraHandledException('Ratio of Specific Heats (k): Please Enter a Value');
        if (flmprod.Flowing_Media__c == 'Customer Specified' && flmprod.Molecular_Weight__c == null)
            throw new AuraHandledException('Molecular Weight (MW): Please Enter a Value');
        if (flmprod.Flowing_Media__c == 'Customer Specified' && flmprod.Compressibility_Factor__c == Null)
            throw new AuraHandledException('Compressibility Factor (Z): Please Enter a Value');
        if (flmprod.Atmospheric_Pressure__c == null)
            throw new AuraHandledException('Atmospheric Pressure: Please Enter a Value');
        if (flmprod.Atmospheric_Pressure_Units__c == '' || flmprod.Atmospheric_Pressure_Units__c == null)
            throw new AuraHandledException('Atmospheric Pressure Units: Please Select a Value from the drop down');
        if (flmprod.Temperature_of_flowing_Vapor__c == null)
            throw new AuraHandledException('Temperature of Flowing Vapor: Please Enter a Value');
        if (flmprod.Temperature_of_flowing_Vapor_Units__c == '' || flmprod.Temperature_of_flowing_Vapor_Units__c == null)
            throw new AuraHandledException('Temperature of flowing Vapor Units: Please Select a Value from the drop down');
        if (flmprod.Pressure_of_flowing_Vapor__c == null && flmprod.Mounting__c != 'End-of-Line' )
            throw new AuraHandledException('Pressure of Flowing Vapor: Please Enter a Value');
        if ((flmprod.Pressure_of_flowing_Vapor_Units__c == '' || flmprod.Pressure_of_flowing_Vapor_Units__c == null) && flmprod.Mounting__c != 'End-of-Line')
            throw new AuraHandledException('Pressure of Flowing Vapor Units: Please Select a Value from the drop down');
        if (flmprod.Location_of_Flowing_Pressure_Specificati__c == null && flmprod.Mounting__c != 'End-of-Line')
            throw new AuraHandledException('Location of Flowing Pressure Specification: Please select any of the following');

        if(flmprod.Mounting__c == 'End-of-Line'){
            flmprod.Location_of_Flowing_Pressure_Specificati__c = 'Outlet';
            flmprod.Pressure_of_flowing_Vapor_Units__c = 'psig';
            flmprod.Pressure_of_flowing_Vapor__c = 0;
        }

        System.debug('flmprod.Location_of_Flowing_Pressure_Specificati__c'+flmprod.Location_of_Flowing_Pressure_Specificati__c);
        System.debug('flmprod.Pressure_of_flowing_Vapor_Units__c'+flmprod.Pressure_of_flowing_Vapor_Units__c);
        System.debug('flmprod.Pressure_of_flowing_Vapor__c'+flmprod.Pressure_of_flowing_Vapor__c);
        
        //Max Allowable Pressure Drop and Max Allowable Pressure Drop Units - ConvertPressure ( MaxAlowdPresDrop, MaxAlowdPresDropUOM, "psig" )
        // if(flmprod.Max_Allowable_Pressure_Drop_Units__c != '' && flmprod.Max_Allowable_Pressure_Drop__c != Null){
        //     Result resultConvertPressure= new Result();
        //     resultConvertPressure=unitConversions.convertPressure(flmprod.Max_Allowable_Pressure_Drop_Units__c,'psig',flmprod.Max_Allowable_Pressure_Drop__c);
        //     if(resultConvertPressure.bResult)
        //         flmprod.Converted_Max_Allowable_Pressure_Drop__c=resultConvertPressure.dblRetValue;
        //     else{
        //         throw new AuraHandledException(resultConvertPressure.strErrorMessage);
        //     }
        // }

        if(flmprod.Max_Allowable_Pressure_Drop_Units__c != '' && flmprod.Max_Allowable_Pressure_Drop__c != Null) {
            Result resultConvertPressure= new Result();
            resultConvertPressure=getConvertedValErrorMsg('Pressure',99999999,0.4,'in. water',flmprod.Max_Allowable_Pressure_Drop_Units__c,flmprod.Max_Allowable_Pressure_Drop__c,'Max. Allowable Pressure Drop');
            if(resultConvertPressure.bErrorCheck)
                throw new AuraHandledException(resultConvertPressure.strErrorMessage);
            else {
                resultConvertPressure=unitConversions.convertPressure(flmprod.Max_Allowable_Pressure_Drop_Units__c,'psig',flmprod.Max_Allowable_Pressure_Drop__c);
                if(resultConvertPressure.bResult)
                    flmprod.Converted_Max_Allowable_Pressure_Drop__c=resultConvertPressure.dblRetValue;
                else{
                    throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                }           
            }            
        } 
        System.debug('flmprod.Converted_Max_Allowable_Pressure_Drop__c: -- '+flmprod.Converted_Max_Allowable_Pressure_Drop__c);

        //Temperature of Flowing vapor
        // if(flmprod.Temperature_of_flowing_Vapor_Units__c != '' && flmprod.Temperature_of_flowing_Vapor__c != Null) {
        //     Result resultConvertTemperature= new Result();
        //     resultConvertTemperature=unitConversions.convertTemperature(flmprod.Temperature_of_flowing_Vapor_Units__c,'Deg R',flmprod.Temperature_of_flowing_Vapor__c);
        //     if(resultConvertTemperature.bResult)
        //         flmprod.Converted_Temprature_of_flowing_Vapor__c=resultConvertTemperature.dblRetValue;
        //     else{
        //         throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
        //     }
        // }

        if(flmprod.Temperature_of_flowing_Vapor_Units__c != '' && flmprod.Temperature_of_flowing_Vapor__c != Null) {
            Result resultConvertTemperature= new Result();
            resultConvertTemperature=getConvertedValErrorMsg('Temperature',760,140,'Deg R',flmprod.Temperature_of_flowing_Vapor_Units__c,flmprod.Temperature_of_flowing_Vapor__c,'Temperature of Flowing Vapor');
            if(resultConvertTemperature.bErrorCheck)
                throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
            else {
                resultConvertTemperature=unitConversions.convertTemperature(flmprod.Temperature_of_flowing_Vapor_Units__c,'Deg R',flmprod.Temperature_of_flowing_Vapor__c);
                if(resultConvertTemperature.bResult)
                    flmprod.Converted_Temprature_of_flowing_Vapor__c=resultConvertTemperature.dblRetValue;
                else{
                    throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
                }            
            }            
        } 
        System.debug('flmprod.Converted_Temprature_of_flowing_Vapor__c: -- '+flmprod.Converted_Temprature_of_flowing_Vapor__c);

        //Required Flow rate and Required Flow rate Units
        if(flmprod.Required_Flow_Rate_Units__c != '' && flmprod.Required_Flow_Rate__c != Null) {
            Result resultconvertGasFlowRate= new Result();
            resultconvertGasFlowRate=unitConversions.convertGasFlowRate(flmprod.Required_Flow_Rate_Units__c,'SCFH',flmprod.Required_Flow_Rate__c,flmprod.Converted_Max_Allowable_Pressure_Drop__c,flmprod.Molecular_Weight__c,flmprod.Converted_Temprature_of_flowing_Vapor__c,flmprod.Compressibility_Factor__c);
            if(resultconvertGasFlowRate.bResult){
                flmprod.Converted_Required_Flow_Rate__c=resultconvertGasFlowRate.dblRetValue;
            }else
                throw new AuraHandledException(resultconvertGasFlowRate.strErrorMessage);
        }
        System.debug('flmprod.Converted_Required_Flow_Rate__c: -- '+flmprod.Converted_Required_Flow_Rate__c);

        //Atmospheric Pressure - AtmPresPSIA - ConvertPressure (AtmPres, AtmPresUOM, "psia")
        if(flmprod.Atmospheric_Pressure_Units__c != '' && flmprod.Atmospheric_Pressure__c != Null){
            Result resultConvertPressure= new Result();            
            resultConvertPressure=unitConversions.convertPressure(flmprod.Atmospheric_Pressure_Units__c,'psia',flmprod.Atmospheric_Pressure__c);
            if(resultConvertPressure.bResult)
                flmprod.Converted_Atmospheric_Pressure__c=resultConvertPressure.dblRetValue;            
            else
                throw new AuraHandledException(resultConvertPressure.strErrorMessage);
        }
        System.debug('flmprod.Converted_Atmospheric_Pressure__c: -- '+flmprod.Converted_Atmospheric_Pressure__c);

        //Pressure of Flowing Vapor - FlowPresPSIG - ConvertPressure (FlowPres, FlowPresUOM, "psig")
        if(flmprod.Pressure_of_flowing_Vapor_Units__c != '' && flmprod.Pressure_of_flowing_Vapor_Units__c != null && flmprod.Pressure_of_flowing_Vapor__c != Null) {
            Result resultConvertPressure= new Result();
            resultConvertPressure=unitConversions.convertPressure(flmprod.Pressure_of_flowing_Vapor_Units__c,'psig',flmprod.Pressure_of_flowing_Vapor__c);
            if(resultConvertPressure.bResult)
                flmprod.Converted_Pressure_of_flowing_Vapor__c=resultConvertPressure.dblRetValue;                
            else
                throw new AuraHandledException(resultConvertPressure.strErrorMessage);
        }
        System.debug('flmprod.Converted_Pressure_of_flowing_Vapor__c: -- '+flmprod.Converted_Pressure_of_flowing_Vapor__c);

        //CriticalPresRatio - ( 2 / (K + 1) ) ^ (K / (K - 1) )
        if(flmprod.Ratio_of_Specific_Heats__c != Null ){//&& flmprod.Ratio_of_Specific_Heats__c > 1){
            flmprod.CriticalPresRatio__c = Math.pow(Double.valueOf(2/(flmprod.Ratio_of_Specific_Heats__c + 1)), Double.valueOf(flmprod.Ratio_of_Specific_Heats__c/(flmprod.Ratio_of_Specific_Heats__c - 1)));
        }
        System.debug('flmprod.CriticalPresRatio__c:--'+flmprod.CriticalPresRatio__c);

        //MinReqdFlowRateSCFH -- ConvertGasFlowRate ( MinReqdFlowRate, MinReqdFlowRateUOM, "SCFH", (FlowPresPSIG + AtmPresPSIA), MW, FlowTempDEGR, Z )
        if(flmprod.Required_Flow_Rate_Units__c != '' && flmprod.Required_Flow_Rate__c != Null && flmprod.Converted_Pressure_of_flowing_Vapor__c != Null && flmprod.Converted_Atmospheric_Pressure__c != Null && flmprod.Molecular_Weight__c != Null && flmprod.Converted_Temprature_of_flowing_Vapor__c != Null && flmprod.Compressibility_Factor__c != Null){
            Result resultconvertGasFlowRate= new Result();
            resultconvertGasFlowRate=unitConversions.convertGasFlowRate(flmprod.Required_Flow_Rate_Units__c,'SCFH',flmprod.Required_Flow_Rate__c,(flmprod.Converted_Pressure_of_flowing_Vapor__c + flmprod.Converted_Atmospheric_Pressure__c),flmprod.Molecular_Weight__c,flmprod.Converted_Temprature_of_flowing_Vapor__c,flmprod.Compressibility_Factor__c);
            if(resultconvertGasFlowRate.bResult)
                flmprod.MinReqdFlowRateSCFH__c =resultconvertGasFlowRate.dblRetValue;                
            else
                throw new AuraHandledException(resultconvertGasFlowRate.strErrorMessage);
        }
        System.debug('flmprod.MinReqdFlowRateSCFH__c:--'+flmprod.MinReqdFlowRateSCFH__c);

        Decimal InletFlowPresPSIA = 0.0;
        //InletFlowPresPSIA - FlowPresPSIG + AtmPresPSIA + IF ( PressureSide = "Inlet", 0, MaxAlowdPresDropPSIG )
        if(flmprod.Location_of_Flowing_Pressure_Specificati__c != '' && flmprod.Converted_Max_Allowable_Pressure_Drop__c != Null && flmprod.Converted_Pressure_of_flowing_Vapor__c != Null && flmprod.Converted_Atmospheric_Pressure__c != Null){
            Decimal presureSide = 0.0;            
            if(flmprod.Location_of_Flowing_Pressure_Specificati__c=='Inlet'){
                presureSide=0.0;
            } else {
                presureSide=flmprod.Converted_Max_Allowable_Pressure_Drop__c;
            }                
            //InletFlowPresPSIA = flmprod.Converted_Pressure_of_flowing_Vapor__c + flmprod.Converted_Atmospheric_Pressure__c + presureSide;
            flmprod.InletFlowPresPSIA__c = flmprod.Converted_Pressure_of_flowing_Vapor__c + flmprod.Converted_Atmospheric_Pressure__c + presureSide;
        }
        System.debug('flmprod.InletFlowPresPSIA__c: -- '+flmprod.InletFlowPresPSIA__c);


        //PresRatio__c - ( InletFlowPresPSIA - MaxAlowdPresDropPSIG ) / InletFlowPresPSIA
        if(flmprod.InletFlowPresPSIA__c != Null && flmprod.Converted_Max_Allowable_Pressure_Drop__c != Null){
            flmprod.PresRatio__c = (flmprod.InletFlowPresPSIA__c - flmprod.Converted_Max_Allowable_Pressure_Drop__c)/flmprod.InletFlowPresPSIA__c;
        }
        System.debug('flmprod.PresRatio__c : --'+flmprod.PresRatio__c);
        
        if(!ReorderFlagLWC){
            flmprod = clearSectCCertifications(flmprod);
            flmProd = clearSectDProductNarrowing(flmProd);
            flmProd = clearSectEProductSelection(flmProd);
        }
        
        try{
            update flmprod;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }           
        }
        return flmprod;
    }

    //UNIT Converstions 
    public static result getConvertedValErrorMsg(string strConvType,decimal decMaxVal,decimal decMinVal,string strBaseUnits,string strUserUnits,decimal value, string fieldname) {
        result res=new result();
        if (strConvType=='Temperature') {
            try{
                List<Temparature__c> temp=[select Multiplier__c,Adder__c,Divider__c from Temparature__c where Temperature_UOM_From__c=:strBaseUnits and Temperature_UOM_To__c=:strUserUnits  LIMIT 1];
                if ( ! temp.isEmpty()) {
                    System.debug('value: ' + value);
                    System.debug('temp.get(0).Divider__c: ' + temp.get(0).Divider__c);
                    decimal maxVal=((decMaxVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                    decimal minVal=((decMinVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                    if (value<minVal || value>maxVal) {
                        res.bResult=true;
                        res.bErrorCheck=true;
                        //res.strErrorMessage=fieldname+' : Please enter valid value between '+minVal.setScale(2)+' '+strUserUnits+' and '+maxVal.setScale(2)+' '+strUserUnits;    
                        res.strErrorMessage=fieldname+' : Please enter value between '+minVal.setScale(2)+' '+strUserUnits+' and '+maxVal.setScale(2)+' '+strUserUnits;   
                    } else {
                        res.bResult=true;
                        res.bErrorCheck=false;
                    }
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue=0;
                System.debug(res.strErrorMessage);
            }
        } else if (strConvType=='Pressure') {
            try{
                List<Pressure__c> pressure=[select Multiplier__c,Adder__c from Pressure__c where Pressure_UOM_From__c=:strBaseUnits and Pressure_UOM_To__c=:strUserUnits  LIMIT 1];
                decimal maxVal=(decMaxVal*pressure.get(0).Multiplier__c)+pressure.get(0).Adder__c;
                decimal minVal=(decMinVal*pressure.get(0).Multiplier__c)+pressure.get(0).Adder__c;
                System.debug('minVal: ' + minVal);
                System.debug('maxVal: ' + maxVal);
                Result res1;
                Result res2;
                res1=unitConversions.SignificantDigitsUp(minVal,4,-99);
                decimal minvalmsg=res1.dblRetValue;
                res2=unitConversions.SignificantDigitsDown(maxVal,4,-99);
                decimal maxvalmsg=res2.dblRetValue;
                
                if (value<minVal) {
                    System.debug('Try block:-----');
                    res.bResult=true;
                    res.bErrorCheck=true;
                    res.strErrorMessage=fieldname+' : Please enter value greater than '+minvalmsg+' '+strUserUnits;                    
                } else {
                    res.bResult=true;
                    res.bErrorCheck=false;
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue=0;
               //objResult.strErrorMessage = e.getMessage();
                System.debug(res.strErrorMessage);
            }

        } 
        return res;
    }

    @AuraEnabled
    public static List<SelectOption> connectedCallBackMethod(String flmprodId){
        List<SelectOption> selList = new List<SelectOption>();
        Flame_Product__c flmProd = [SELECT Id, Model__c FROM Flame_Product__c WHERE Id =: flmprodId];
        if(flmProd!=Null)
            selList.add(new SelectOption(flmProd.Model__c,flmProd.Model__c));
        return selList;
    }
    
   // public static boolean CertFlag{get;set;}
    @AuraEnabled
    public static Flame_Product__c saveCertifications(Flame_Product__c flmProd){
        flmProd.Application_Parameters_flag__c=false;
        flmProd.Sizing_Flow_Area_flag__c=false;
        flmProd.Certifications_flag__c=true;
        flmProd.Product_Narrowing_flag__c=false;
        flmProd.Product_selection_flag__c=false;
        flmProd.Product_Material_and_Options_flag__c=false;
        flmProd.Examination_Option_flag__c=false;
        flmProd.Certificate_and_sourcing_flag__c=false;

        if(flmProd.Certfication_Requirement__c == 'USCG'){
            flmProd.US_Coast_guard__c = 'Y';
            flmProd.CU_TR__c = 'N';
            flmProd.Atex_Certificate_2014_34_EU__c = 'N';
        } else if(flmProd.Certfication_Requirement__c == 'ATEX'){
            flmProd.US_Coast_guard__c = 'N';
            flmProd.CU_TR__c = 'N';
            flmProd.Atex_Certificate_2014_34_EU__c = 'Y';
        } else if(flmProd.Certfication_Requirement__c == 'CUTR'){
            flmProd.US_Coast_guard__c = 'N';
            flmProd.CU_TR__c = 'Y';
            flmProd.Atex_Certificate_2014_34_EU__c = 'N';
        } else {
            flmProd.US_Coast_guard__c = 'N';
            flmProd.CU_TR__c = 'N';
            flmProd.Atex_Certificate_2014_34_EU__c = 'N';
        }
        if(!ReorderFlagLWC){
            flmProd = clearSectDProductNarrowing(flmProd);
        	flmProd = clearSectEProductSelection(flmProd);
        }
        
        try{
            flmProd.Certification_Save_Check_Flag__c=true;
            update flmProd;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return flmProd;
    }

    @AuraEnabled
    public static FAWrapper saveProductNarrowing(Flame_Product__c flmProd, String flmProdId){        
        flmProd.Application_Parameters_flag__c=false;
        flmProd.Sizing_Flow_Area_flag__c=false;
        flmProd.Certifications_flag__c=false;
        flmProd.Product_Narrowing_flag__c=true;
        flmProd.Product_selection_flag__c=false;
        flmProd.Product_Material_and_Options_flag__c=false;
        flmProd.Examination_Option_flag__c=false;
        flmProd.Certificate_and_sourcing_flag__c=false;
		System.debug('Certttttttt----222222---' +flmProd.Certification_Save_Check_Flag__c);
        if(flmProd.Certification_Save_Check_Flag__c==false){
            System.debug('Certttttttt----111111111');
            flmProd.US_Coast_guard__c = 'N';
            flmProd.CU_TR__c = 'N';
            flmProd.Atex_Certificate_2014_34_EU__c = 'N';
        }
            
        
        if(flmProd.Mounting__c == 'End-of-Line'){
            flmProd.Operational_Pressure__c = 14.7;
            flmProd.Operational_Pressure_Units__c = 'psia';            
        }

        // if(flmProd.Arrester_for_Detonation_or_Deflagration__c == 'Detonation'){
        //     flmProd.Run_Up_Length_A_Input__c = 0;
        //     flmProd.Run_Up_Length_B_Input__c = 0;
        //     flmProd.Run_Up_Length_A_Input_Units__c = 'in';
        //     flmProd.Run_Up_Length_B_Input_Units__c = 'in';
        // }

        // if(flmProd.Mounting__c == 'In-Line Pipe with Bend' && flmProd.Arrester_for_Detonation_or_Deflagration__c == 'Detonation'){
        //     flmProd.Run_Up_Length_B_Input__c = 0;
        //     flmProd.Run_Up_Length_B_Input_Units__c = 'in';
        // }

        //Operational Pressure and Units
        if(flmProd.Operational_Pressure_Units__c != '' && flmProd.Operational_Pressure__c != Null) {
            Result resultConvertPressure= new Result();
            if(flmProd.Operational_Pressure_Units__c=='psia')
            	resultConvertPressure=unitConversions.convertPressure(flmProd.Operational_Pressure_Units__c,'psia',flmProd.Operational_Pressure__c);
            else
                resultConvertPressure=unitConversions.convertPressure(flmProd.Operational_Pressure_Units__c+'.','psia',flmProd.Operational_Pressure__c);
            System.debug('AAAA---' +flmprod.Operational_Pressure_Units__c);
            System.debug('AAAA11---' +flmprod.Operational_Pressure__c);
            if(resultConvertPressure.bResult)
                flmProd.Converted_Operational_Pressure__c=resultConvertPressure.dblRetValue;                
            else
                throw new AuraHandledException(resultConvertPressure.strErrorMessage);
        }

        //Run Length A and Units
        if(flmProd.Run_Up_Length_A_Input_Units__c != '' && flmProd.Run_Up_Length_A_Input_Units__c != null && flmProd.Run_Up_Length_A_Input__c != Null) {
            Result resultConvertDistance= new Result();
            resultConvertDistance=unitConversions.convertDistance(flmProd.Run_Up_Length_A_Input_Units__c,'in',flmProd.Run_Up_Length_A_Input__c);
            if(resultConvertDistance.bResult)
                flmProd.Converted_Run_up_Length_A__c=resultConvertDistance.dblRetValue;                
            else
                throw new AuraHandledException(resultConvertDistance.strErrorMessage);
        }

        //Run Length B and Units
        if(flmProd.Run_Up_Length_B_Input_Units__c != '' && flmProd.Run_Up_Length_B_Input_Units__c != null && flmProd.Run_Up_Length_B_Input__c != Null) {
            Result resultConvertDistance= new Result();
            resultConvertDistance=unitConversions.convertDistance(flmProd.Run_Up_Length_B_Input_Units__c,'in',flmProd.Run_Up_Length_B_Input__c);
            if(resultConvertDistance.bResult)
                flmProd.Converted_Run_up_Length_B__c=resultConvertDistance.dblRetValue;                
            else
                throw new AuraHandledException(resultConvertDistance.strErrorMessage);
        }
        System.debug('Run Up Length A : -- '+flmProd.Run_Up_Length_A_Input__c);
        System.debug('Run Up Length A Units : -- '+flmProd.Run_Up_Length_A_Input_Units__c);
        System.debug('Run Up Length B : -- '+flmProd.Run_Up_Length_B_Input__c);
        System.debug('Run Up Length B Units : -- '+flmProd.Run_Up_Length_B_Input_Units__c);
        System.debug('Operational Pressure : -- '+flmProd.Operational_Pressure__c);
        System.debug('Operational Pressure: -- '+flmProd.Operational_Pressure_Units__c);

		if(!ReorderFlagLWC)
        	flmProd = clearSectEProductSelection(flmProd);
        
        try{
            update flmProd;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        FAWrapper wrapperObj = new FAWrapper();
        wrapperObj = getFAProdNarrowFilter(flmProd,flmProdId);
        wrapperObj.flameProd = flmProd;
        return wrapperObj;
    }

    public class FAWrapper {
        @AuraEnabled public Flame_Product__c flameProd { get;set; }
        // @AuraEnabled public Set<String> connSizeOptions { get;set; }
        // @AuraEnabled public Set<String> eleSizeOptions { get;set; }
        // @AuraEnabled public Set<String> modelDesc { get;set; }
        @AuraEnabled public List<SelectOption> connSizeOptions { get;set; }
        @AuraEnabled public List<SelectOption> eleSizeOptions { get;set; }
        @AuraEnabled public List<SelectOption> modelDesc { get;set; }
        public FAWrapper(){
            this.flameProd = flameProd;
            this.connSizeOptions = connSizeOptions;
            this.eleSizeOptions = eleSizeOptions;
            this.modelDesc = modelDesc;
        }
    }
    
    @AuraEnabled
    public static Flame_Product__c saveProductSelection(Flame_Product__c flmProd){
        flmProd.Application_Parameters_flag__c=true;
        flmProd.Sizing_Flow_Area_flag__c=false;
        flmProd.Certifications_flag__c=false;
        flmProd.Product_Narrowing_flag__c=false;
        flmProd.Product_selection_flag__c=true;
        flmProd.Product_Material_and_Options_flag__c=false;
        flmProd.Examination_Option_flag__c=false;
        flmProd.Certificate_and_sourcing_flag__c=false;
      
        if(flmProd.Certification_Save_Check_Flag__c==false){
            System.debug('Certttttttt----111111111');
            flmProd.US_Coast_guard__c = 'N';
            flmProd.CU_TR__c = 'N';
            flmProd.Atex_Certificate_2014_34_EU__c = 'N';
        }
        
        if(flmProd.Model__c != Null){
            string strmodel='';
            strmodel=[select PTC__c from FA_MasterBlaster__c where Description__c=:flmProd.Model__c][0].PTC__c;
            flmProd.PTC__c = strmodel;
            /*******
            for(String eachStr: mapOfModelDesc.keySet()){
                //system.debug('eachStr: ' + eachStr);
                //system.debug('Model__c: ' + flmProd.Model__c);
                //Boolean Test = flmProd.Model__c.contains(eachStr);
                //system.debug('Test: ' + Test);
                if(flmProd.Model__c.contains(eachStr)){
                    flmProd.PTC__c = eachStr;
                }
            }********/
        }                      
        if(ReorderFlagLWC){
            string strmodel='';
            strmodel=[select Description__c from FA_MasterBlaster__c where PTC__c=:flmProd.PTC__c and SZC__c=:flmProd.Size__c
                      and ESZC__c=:flmProd.ESZC__c][0].Description__c;
            flmProd.Model__c=strmodel;
        }
        
        try{
            update flmProd;
        }catch(System.DmlException dmle){
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return flmProd;
    } 
    
    public static FAWrapper getFAProdNarrowFilter(Flame_Product__c flmProd, String flmProdId){
        
        FAWrapper fawrapObj = new FAWrapper();
        
        //Flame_Product__c flmProd = [SELECT Id, Max_Allowable_Pressure_Drop__c, Max_Allowable_Pressure_Drop_Units__c, Converted_Max_Allowable_Pressure_Drop__c, Required_Flow_Rate__c, Required_Flow_Rate_Units__c, Converted_Required_Flow_Rate__c, Flowing_Media__c, Media_Name__c, Ratio_of_Specific_Heats__c, Molecular_Weight__c, Compressibility_Factor__c, Atmospheric_Pressure__c, Atmospheric_Pressure_Units__c, Converted_Atmospheric_Pressure__c, Temperature_of_flowing_Vapor__c, Temperature_of_flowing_Vapor_Units__c, Converted_Temprature_of_flowing_Vapor__c, Pressure_of_flowing_Vapor__c, Pressure_of_flowing_Vapor_Units__c, Converted_Pressure_of_flowing_Vapor__c, Side_of_FA_whr_flwng_prssur_is_indicated__c, Flow_Rate__c, Run_Up_Length_A_Input__c, Run_Up_Length_B_Input__c, Price_Engineer_Override__c, Lead_Time_Override__c, Operational_Pressure__c, Operational_Pressure_Units__c, Converted_Operational_Pressure__c, Lead_Time_Site_10__c, Operational_Temperature_Units__c, Arrester_for_Detonation_or_Deflagration__c, Do_you_need_Offset_Bases__c, Lead_Time_Site_20__c, Run_Up_Length_A_Input_Units__c, Converted_Run_up_Length_A__c, Sizing_Flow_Area_flag__c, Brand__c, Certifications_flag__c, Quote_Line__c, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c, Bypass__c, Quantity__c, Lead_Time_Site_30__c, Fillet_Weld_Liquid_Dye_Penetrant__c, Lead_Time_Site_40__c, Schedule_BaseLead__c, Quote_Description_Engineer_Override__c, Ultrasonic_Examination__c, ASSYPARTNO__c, Magnetic_Particle_Examination__c, Brinell_Hardness_Examination__c, Charpy_Impact_Testing__c, Visual_Casting_Examination__c, Intergranular_Corossion_Test__c, Final_Assembly_Location_Requirements__c, Part_Number_Base__c, Run_Up_Length_B_Input_Units__c, Converted_Run_up_Length_B__c, Drilling__c, Do_you_have_a_closed_or_open_end_pipe__c, PresRatio__c, KD__c, Build_Cost_Override__c, List_Price_Each__c, Brinell_hardness_examination_Backend__c, Certfication_Requirement__c, Charpy_Impact_Testing_Backend__c, Diaphragm_Material__c, ESZC__c, Fillet_Weld_Liquid_Dye_Penetrant_Backend__c, Material_Sourcing_Requirements__c, Engineering_Notes__c, Document_IDs__c, Model__c, Connection_Size__c, Element_Size__c, Product_Narrowing_flag__c, Product_selection_flag__c, Product_Material_and_Options_flag__c, Examination_Option_flag__c, Certificate_and_sourcing_flag__c, Mounting__c, Operational_Temperature__c, Gas_Group_Code__c, Intergranular_Corossion_Test_Backend__c, Liquid_Dye_Penetrant__c, Location_of_Flowing_Pressure_Specificati__c, Magnetic_Particle_Examination_Backend__c, NACE__c, Nace_Backend__c, Offset_or_Concentric_Bases__c, PTC__c, Painting_Coating_Option__c, Pipe_Design__c, Positive_Material_Identification__c, Radiography__c, SZC__c, Ultrasonic_Examination_Backend__c, Visual_Casting_Examination_Backend__c, Body_Material__c, Constrain_Product_Selection_by_Flow__c, Element_Material__c, Housing_Material__c, Inlet_Option_A__c, Inlet_Option_B__c, Inlet_Option_C__c, Outlet_Option_A__c, Outlet_Option_B_ FROM Flame_Product__c WHERE Id =:flmProdId];
        List<FA_MasterBlaster__c> lstFSRecords = new List<FA_MasterBlaster__c>();  
        String strDynamicQuery = 'SELECT Id, Name, SZC__c, BRAND__c, Description__c, EndCondition__c, FlameType__c, Mounting__c, ATEX__c, RunUpLengthAIn__c, OffsetBases__c, CUTR__c, PTC__c, GasGroupLevel__c, USCG__c, EffDia__c, OpPresPSIA__c, RunUpLengthBIn__c, ESZC__c, NACE__c, OpTemp__c FROM FA_MasterBlaster__c WHERE ';
        String strBrand=[select Quote_Line__r.SBQQ__Quote__r.Brand__c from Flame_Product__c where id=:flmProdId].Quote_Line__r.SBQQ__Quote__r.Brand__c;
        String strdynamicWhereClause='Id != null';

        //Filter For Brand this is the first filter on the Master Blaster table.
        if(strBrand!=null)
            strdynamicWhereClause+=' AND Brand__c=\''+strBrand+'\'';        
        
        //Filter For Mounting on the Master Blaster table.
        if(String.isNotBlank(flmProd.Mounting__c))
            strdynamicWhereClause+=' AND (Mounting__c=\''+flmProd.Mounting__c+'\' OR Mounting__c= \'-\')';

        //Filter For Pipe-Design(End-Condition) on the Master Blaster table.
        if(flmProd.Pipe_Design__c == 'Closed End')
            strdynamicWhereClause+=' AND EndCondition__c=\'Open-Closed\'';

        //Filter For GroupGasLevel on the Master Blaster table
        // if(flmProd.Gas_Group_Code__c != Null)
        //     strdynamicWhereClause+=' AND GasGroupLevel__c>=\''+flmProd.Gas_Group_Code__c+'\'';
        if(flmProd.Gas_Group_Code__c != Null)
            strdynamicWhereClause+=' AND GasGroupLevel__c>='+flmProd.Gas_Group_Code__c;

        //Filter For ATEX on the Master Blaster table.
        if(flmProd.Atex_Certificate_2014_34_EU__c == 'Y')
            strdynamicWhereClause+=' AND ATEX__c=\'Y\'';

        //Filter For CUTR on the Master Blaster table.
        if(flmProd.CU_TR__c == 'Y')
            strdynamicWhereClause+=' AND CUTR__c=\'Y\'';

        //Filter For US Coast Guard on the Master Blaster table.
        if(flmProd.US_Coast_guard__c == 'Y')
            strdynamicWhereClause+=' AND USCG__c=\'Y\'';

        //Filter For NACE on the Master Blaster table.
        if(flmProd.Nace_Backend__c == 'Y')
            strdynamicWhereClause+=' AND NACE__c=\'Y\'';

        //Filter For Operational Pressure on the Master Blaster table.
        // if(flmProd.Operational_Pressure__c != Null)
        //     strdynamicWhereClause+=' AND OpPresPSIA__c>=\''+flmProd.Operational_Pressure__c+'\'';
        if(flmProd.Operational_Pressure__c != Null)
            strdynamicWhereClause+=' AND OpPresPSIA__c>='+flmProd.Operational_Pressure__c;

        //Filter For Operational Temperature on the Master Blaster table.
        if(flmProd.Operational_Temperature__c != Null)
            strdynamicWhereClause+=' AND OpTemp__c=\''+flmProd.Operational_Temperature__c+'\'';

        //Filter For Flame Type on the Master Blaster table.
        if(flmProd.Arrester_for_Detonation_or_Deflagration__c != 'Both')
            strdynamicWhereClause+=' AND FlameType__c=\''+flmProd.Arrester_for_Detonation_or_Deflagration__c+'\'';

        //Filter For OffSetBases on the Master Blaster table.
        if(flmProd.Offset_or_Concentric_Bases__c != 'BothOffCon'){
            if(flmProd.Offset_or_Concentric_Bases__c == 'Offset'){
                strdynamicWhereClause+=' AND OffsetBases__c=\'Y\'';
            } else if(flmProd.Offset_or_Concentric_Bases__c == 'Concentric'){
                strdynamicWhereClause+=' AND OffsetBases__c=\'N\'';
            }
        }
            

        //Filter For RunUpLengthA on the Master Blaster table.
        // if(flmProd.Run_Up_Length_A_Input__c != Null)
        //     strdynamicWhereClause+=' AND RunUpLengthAIn__c>=\''+flmProd.Run_Up_Length_A_Input__c+'\'';
        if(flmProd.Run_Up_Length_A_Input__c != Null)
            strdynamicWhereClause+=' AND RunUpLengthAIn__c>='+flmProd.Run_Up_Length_A_Input__c;

        //Filter For RunUpLengthB on the Master Blaster table.
        // if(flmProd.Run_Up_Length_B_Input__c != Null)
        //     strdynamicWhereClause+=' AND RunUpLengthBIn__c>=\''+flmProd.Run_Up_Length_B_Input__c+'\'';
        if(flmProd.Run_Up_Length_B_Input__c != Null)
            strdynamicWhereClause+=' AND RunUpLengthBIn__c>='+flmProd.Run_Up_Length_B_Input__c;

        strdynamicWhereClause+=' ORDER BY SZC__c, ESZC__c, Description__c';
        
        System.debug('lstFSRecords before FlowRate Filter:-- '+lstFSRecords);
        System.debug('AAAAAAA---'+strDynamicQuery + strdynamicWhereClause);
        lstFSRecords = Database.query(strDynamicQuery + strdynamicWhereClause);
        System.debug('lstFSRecords.size :--- '+lstFSRecords.size());
        if(lstFSRecords.size()>0 && flmProd.Constrain_Product_Selection_by_Flow__c == true){
            lstFSRecords = getFilterByFlowRate(lstFSRecords,flmProdId,flmProd);
        }

        List<SelectOption> szcOptions = new List<SelectOption>();
        szcOptions.add(new SelectOption('',''));
        List<SelectOption> eszcOpions = new List<SelectOption>();
        eszcOpions.add(new SelectOption('',''));
        List<SelectOption> descOptions = new List<SelectOption>();
        descOptions.add(new SelectOption('',''));
        List<String> uniqueListSZC=new List<String>();
        List<string> uniqueListESZC=new List<String>();
        List<string> uniqueListDESC=new List<String>();
        for(FA_MasterBlaster__c eachFAMB : lstFSRecords){
            if(!uniqueListSZC.contains(eachFAMB.SZC__c)){
                uniqueListSZC.add(eachFAMB.SZC__c);
                szcOptions.add(new selectOption(eachFAMB.SZC__c,mapOfSZC.get(eachFAMB.SZC__c)));
            }
            if(!uniqueListESZC.contains(eachFAMB.ESZC__c)){
                uniqueListESZC.add(eachFAMB.ESZC__c);
                eszcOpions.add(new selectOption(eachFAMB.ESZC__c,mapOfESZC.get(eachFAMB.ESZC__c)));
            }
            if(!uniqueListDESC.contains(eachFAMB.Description__c)){
                uniqueListDESC.add(eachFAMB.Description__c);
                descOptions.add(new selectOption(eachFAMB.Description__c,eachFAMB.Description__c));
            }
        }
        fawrapObj.connSizeOptions = szcOptions;
        fawrapObj.eleSizeOptions = eszcOpions;
        fawrapObj.modelDesc = descOptions;
        return fawrapObj;
    }

    //################# Filter using FlowRate ###################//
    public static List<FA_MasterBlaster__c> getFilterByFlowRate(List<FA_MasterBlaster__c> lstFAMB, String flmProdId, Flame_Product__c flmProd){
        
        System.debug('Molecular Weight: -- '+flmProd.Molecular_Weight__c);
        System.debug('Ratio Of Specific Heats: -- '+flmProd.Ratio_of_Specific_Heats__c);
        System.debug('Compressibility Factor: -- '+flmProd.Compressibility_Factor__c);
        System.debug('Convereted Max Allowable Pressure Drop Units: -- '+flmProd.Converted_Max_Allowable_Pressure_Drop__c);
        System.debug('Converted Atmospheric Pressure: -- '+flmProd.Converted_Atmospheric_Pressure__c);
        System.debug('Converted Required Flow Rate: -- '+flmProd.Converted_Required_Flow_Rate__c);
        System.debug('Converted Temperature of Flowing Vapor: -- '+flmProd.Converted_Temprature_of_flowing_Vapor__c);
        System.debug('Converetd Pressure of Flowing Vapor: -- '+flmProd.Converted_Pressure_of_flowing_Vapor__c);
        System.debug('Pressure Ratio: -- '+flmProd.PresRatio__c);
        System.debug('Min Reuired Flow Rate SCFH: -- '+flmProd.MinReqdFlowRateSCFH__c);
        System.debug('Critical Pressure Ratio: -- '+flmProd.CriticalPresRatio__c);
        System.debug('flmprod.InletFlowPresPSIA__c: -- '+flmprod.InletFlowPresPSIA__c);


        List<FA_MasterBlaster__c> lstOfFlowRatefilterRecs = new List<FA_MasterBlaster__c>();
        List<String> lstPTC = new List<String>();
        List<String> lstSZC = new List<String>();
        List<String> lstESZC = new List<String>();
        Map<String, FA_MasterBlaster__c> faMasterBlasterMap = new Map<String, FA_MasterBlaster__c>();
        Map<String, List<FA_KD__c>> faKDMap = new Map<String, List<FA_KD__c>>();

        for(FA_MasterBlaster__c eachFAMB : lstFAMB){
            String keyValue = 'PTC = '+eachFAMB.PTC__c+', SZC = '+eachFAMB.SZC__c+', ESZC = '+eachFAMB.ESZC__c;            
            faMasterBlasterMap.put(keyValue,eachFAMB);
            lstPTC.add(eachFAMB.PTC__c);
            lstSZC.add(eachFAMB.SZC__c);
            lstESZC.add(eachFAMB.ESZC__c);
            //lstMCELEM.add(eachFAMB.MCELEM__c);
        }

        for(FA_KD__c eachFaKd : [SELECT PTC__c, SZC__c, ESZC__c, Kd__c, PresRatio__c FROM FA_KD__c WHERE PTC__c IN: lstPTC AND SZC__c IN: lstSZC AND ESZC__c IN: lstESZC] ){
            String keyValue = 'PTC = '+eachFaKd.PTC__c+', SZC = '+eachFaKd.SZC__c+', ESZC = '+eachFaKd.ESZC__c;
            if(!faKDMap.containsKey(keyValue)) {
                faKDMap.put(keyValue, new List<FA_KD__c>());
            }
            faKDMap.get(keyValue).add(eachFaKd);
        }

        //FAOutputUtility FAOU = new FAOutputUtility(flmProdId);
        decimal PresRatio = (decimal) (flmProd.PresRatio__c);
        decimal K = (decimal) (flmProd.Ratio_of_Specific_Heats__c);
        decimal MW = (decimal) (flmProd.Molecular_Weight__c);
        decimal FlowTempDEGR = (decimal) (flmProd.Converted_Temprature_of_flowing_Vapor__c);
        //decimal FlowPresPSIG = (decimal) (flmProd.Converted_Pressure_of_flowing_Vapor__c);
        decimal InletFlowPresPSIA = flmprod.InletFlowPresPSIA__c;
        decimal Z = (decimal) (flmProd.Compressibility_Factor__c);

        Decimal presRatioLow = 0.0, KDLow = 0.0, presRatioHigh = 0.0, KDHigh = 0.0, KD = 0.0, FlowRateFA =0.0;
        for(String mapKey: faMasterBlasterMap.Keyset()) {
            if(faKDMap.containsKey(mapKey)){

                List<FA_KD__c> faKDFlowList = new List<FA_KD__c>();
                faKDFlowList.addAll(faKDMap.get(mapKey));
                decimal lowDiff;
                decimal highDiff;

                for(FA_KD__c faKDRecord : faKDFlowList){

                    decimal diff = faKDRecord.PresRatio__c - PresRatio;
                    if(diff > 0 && (highDiff > diff || highDiff == null)){
                        highDiff = diff;
                        presRatioLow = faKDRecord.PresRatio__c;
                        KDLow = faKDRecord.Kd__c;
                    }

                    if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                        lowDiff = diff;
                        
                        presRatioHigh = faKDRecord.PresRatio__c;
                        KDHigh = faKDRecord.Kd__c;
                    }
                }
            }

        

            if((presRatioLow - presRatioHigh) != 0.0 && KDHigh != 0.0 ){
                KD = (PresRatio-presRatioHigh)*(KDLow-KDHigh)/(presRatioLow-presRatioHigh)+KDHigh; 
            }

            
            system.debug('mapKey'+mapKey);
            system.debug('presRatioLow'+presRatioLow);
            system.debug('KDLow'+KDLow);
            system.debug('presRatioHigh'+presRatioHigh);
            system.debug('KDHigh'+KDHigh);
            system.debug('KD'+KD);
            system.debug('PresRatio'+PresRatio);
            system.debug('flmProd.CriticalPresRatio__c'+flmProd.CriticalPresRatio__c);
            system.debug('K'+K);
            system.debug('MW'+MW);
            system.debug('FlowTempDEGR'+FlowTempDEGR);
            system.debug('InletFlowPresPSIA'+InletFlowPresPSIA);
            system.debug('Z'+Z);
            system.debug('flmProd.MinReqdFlowRateSCFH__c'+flmProd.MinReqdFlowRateSCFH__c);
            System.debug('EffDia : -- '+faMasterBlasterMap.get(mapKey).EffDia__c);


            if(PresRatio >= flmProd.CriticalPresRatio__c.setScale(8)){                
                
                Double powCalEffDia = (Math.pow(double.valueOf(faMasterBlasterMap.get(mapKey).EffDia__c),Double.valueOf(2)));
                Double ATAN = Math.atan(1);                

               // FlowRateFA = (278700*KD*FlowPresPSIG*powCalEffDia*ATAN*(Math.pow((K/(MW*FlowTempDEGR*Z*(K-1))*((Math.pow(PresRatio, (Double.valueOf(2)/K)))- (Math.pow(PresRatio, Double.valueOf((K+1)/K))))),Double.valueOf(0.5))));
               FlowRateFA = 278700 * KD * InletFlowPresPSIA * (math.exp(2 * math.log(decimal.valueOf(faMasterBlasterMap.get(mapKey).EffDia__c)))) * math.atan(1) * (math.exp(0.5* math.log(K / (MW * FlowTempDEGR * Z * (K - 1) ) * ((math.exp((2 / K) * math.log(PresRatio)) - math.exp(((K + 1) / K)* math.log(PresRatio))))))) ;
               //system.debug('FlowRateFA: --- '+FlowRateFA);
                                
            } else {                                                                                                                                                                
                //FlowRateFA = 60 * 6.32 * 520 * KD * FlowPresPSIG * Math.pow(double.valueOf(faMasterBlasterMap.get(mapKey).EffDia__c),Double.valueOf(2)) * Math.atan(1) *  Math.pow((K / (MW * FlowTempDEGR * Z ) * Math.pow((2 / (K + 1) ),( (K + 1) / (K - 1) )) ),Double.valueOf(0.5));
                FlowRateFA = 60 * 6.32 * 520 * KD * InletFlowPresPSIA * (math.exp(2 * math.log(decimal.valueOf(faMasterBlasterMap.get(mapKey).EffDia__c)))) * math.atan(1) * (math.exp(0.5* math.log(K / (MW * FlowTempDEGR * Z ) * (math.exp(((K + 1) / (K - 1)) * math.log(2 / (K + 1)) )) )));
            }

            
			system.debug('FlowRateFA'+FlowRateFA);
            if(FlowRateFA >= flmProd.MinReqdFlowRateSCFH__c.setScale(8)){
                lstOfFlowRatefilterRecs.add(faMasterBlasterMap.get(mapKey));
                system.debug('lstOfFlowRatefilterRecs.size()'+lstOfFlowRatefilterRecs.size());
            }
        }
        // List<FA_KD__c> lstOfFAKDRecs = new List<FA_KD__c>();
        // String strdynamicWhereClauseFAKD = '';
        // List<String> lstPTC = new List<String>();
        // List<String> lstSZC = new List<String>();
        // List<String> lstESZC = new List<String>();
        // List<String> lstMCELEM = new List<String>();
        // FAOutputUtility FAOU = new FAOutputUtility(flmProdId);
        // Decimal KD = 0.0;
        // Double PresRatio = (Double) FAOU.PresRatio;
        // Double K = (Double) FAOU.K;
        // Double MW = (Double) FAOU.MW;
        // Double FlowTempDEGR = (Double) FAOU.FlowTempDEGR;
        // Double FlowPresPSIG = (Double) FAOU.FlowPresPSIG;
        // Double Z = (Double) FAOU.Z;
        // Double FlowRateFA = 0.0;    
        
        // for(FA_MasterBlaster__c eachFAMB : lstFAMB){
        //     lstPTC.add(eachFAMB.PTC__c);
        //     lstSZC.add(eachFAMB.SZC__c);
        //     lstESZC.add(eachFAMB.ESZC__c);
        //     //lstMCELEM.add(eachFAMB.MCELEM__c);
        // }
        
        
        // String strQryPRESRATIOLOW = 'SELECT Kd__c, PresRatio__c FROM FA_KD__c WHERE PTC__c IN: lstPTC AND SZC__c IN: lstSZC AND ESZC__c IN: lstESZC AND PresRatio__c>'+PresRatio+' ORDER BY PresRatio__c ASC';
        // List<FA_KD__c> lstResPRESRATIOLOW = Database.query(strQryPRESRATIOLOW);        

        // String strQryPRESRATIOHIGH = 'SELECT Kd__c, PresRatio__c FROM FA_KD__c WHERE PTC__c IN: lstPTC AND SZC__c IN: lstSZC AND ESZC__c IN: lstESZC AND PresRatio__c<='+PresRatio+' ORDER BY PresRatio__c DESC';
        // List<FA_KD__c> lstResPRESRATIOHIGH = Database.query(strQryPRESRATIOHIGH);
        
        // if(lstResPRESRATIOLOW.size()>0 && lstResPRESRATIOHIGH.size()>0){
        //     Double PRESRATIOLOW = lstResPRESRATIOLOW[0].PresRatio__c;
        //     Double KDLOW = lstResPRESRATIOLOW[0].Kd__c;
        //     Double PRESRATIOHIGH = lstResPRESRATIOHIGH[0].PresRatio__c;
        //     Double KDHIGH = lstResPRESRATIOHIGH[0].Kd__c;
            
        //     // System.debug('PRESRATIOLOW:-- '+PRESRATIOLOW);
        //     // System.debug('KDLOW:-- '+KDLOW);
        //     // System.debug('PRESRATIOHIGH:-- '+PRESRATIOHIGH);
        //     // System.debug('KDHIGH:-- '+KDHIGH);
        //     KD = (PresRatio-PRESRATIOHIGH)*(KDLOW-KDHIGH)/(PRESRATIOLOW-PRESRATIOHIGH)+KDHIGH;               
        // } else {
        //     KD = 0;
        // }  
        
        // System.debug('KD: -- '+KD);
        
        // ///################## Eff Dia is pending ###############
        // if(PresRatio >= FAOU.CriticalPresRatio){
        //     FlowRateFA = 278700 * KD * FlowPresPSIG * Math.pow(1, Double.valueOf(2)) * Math.atan(1) *  Math.pow((K / (MW * FlowTempDEGR * Z * (K - 1) ) * (Math.pow(PresRatio, (2 / K)) - Math.pow(PresRatio,( (K + 1) / K)) ) ),Double.valueOf(0.5) );
        // } else {                                                                                                                                                                
        //     FlowRateFA = 60 * 6.32 * 520 * KD * FlowPresPSIG * Math.pow(1,Double.valueOf(2)) * Math.atan(1) *  Math.pow((K / (MW * FlowTempDEGR * Z ) * Math.pow((2 / (K + 1) ),( (K + 1) / (K - 1) )) ),Double.valueOf(0.5));
        // }

        // for(FA_MasterBlaster__c eachFilteredFAMB : lstFAMB){
        //     if(FlowRateFA >= FAOU.MinReqdFlowRateSCFH){
        //         lstOfFlowRatefilterRecs.add(eachFilteredFAMB);
        //     }
        // }
        return lstOfFlowRatefilterRecs;
    }   
    


    
    // ########### CLEARING LOGIC START SECTION WISE ############## //
    public static Flame_Product__c clearSectBSizingFlowArea(Flame_Product__c flmProd){

        if(flmProd.Constrain_Product_Selection_by_Flow__c == true && flmProd.Pressure_Units__c != null){
            flmProd.Max_Allowable_Pressure_Drop_Units__c = flmProd.Pressure_Units__c;            
            if(flmprod.Mounting__c != 'End-of-Line'){
                flmprod.Pressure_of_flowing_Vapor__c = null;
                flmProd.Pressure_of_flowing_Vapor_Units__c = flmProd.Pressure_Units__c;
                flmprod.Location_of_Flowing_Pressure_Specificati__c = null;
            } else {
                flmprod.Pressure_of_flowing_Vapor__c = 0;
                flmProd.Pressure_of_flowing_Vapor_Units__c = 'psig';
                flmprod.Location_of_Flowing_Pressure_Specificati__c = 'Outlet';
            }
        }

        if(flmProd.Constrain_Product_Selection_by_Flow__c == true && flmProd.Pressure_Units__c == null){
            flmProd.Max_Allowable_Pressure_Drop_Units__c = null;
            if(flmprod.Mounting__c != 'End-of-Line'){
                flmprod.Pressure_of_flowing_Vapor__c = null;
                flmProd.Pressure_of_flowing_Vapor_Units__c = 'psia';
                flmprod.Location_of_Flowing_Pressure_Specificati__c = null;
            } else {
                flmprod.Pressure_of_flowing_Vapor__c = 0;
                flmprod.Pressure_of_flowing_Vapor_Units__c = 'psig';
                flmprod.Location_of_Flowing_Pressure_Specificati__c = 'Outlet';
            }
        }

        if(flmProd.Constrain_Product_Selection_by_Flow__c == false){
            flmprod.Pressure_of_flowing_Vapor__c = null;
            flmprod.Pressure_of_flowing_Vapor_Units__c = null;
            flmprod.Location_of_Flowing_Pressure_Specificati__c = null;
        }        

        if(flmProd.Constrain_Product_Selection_by_Flow__c == true && flmProd.Flow_Rate_Units__c != null){
            flmProd.Required_Flow_Rate_Units__c = flmProd.Flow_Rate_Units__c;
        } else {
            flmProd.Required_Flow_Rate_Units__c = null;
        }

        if(flmProd.Constrain_Product_Selection_by_Flow__c == true && flmProd.Temperature_Units__c != null){
            flmProd.Temperature_of_flowing_Vapor_Units__c = flmProd.Temperature_Units__c;
        } else {
            flmProd.Temperature_of_flowing_Vapor_Units__c = null;
        }

        if(flmProd.Constrain_Product_Selection_by_Flow__c == true){
            flmProd.Flowing_Media__c = 'Air';            
            flmProd.Atmospheric_Pressure__c = 14.6959;
            flmProd.Atmospheric_Pressure_Units__c = 'psia';
            flmProd.Ratio_of_Specific_Heats__c = 1.4;            
            flmProd.Molecular_Weight__c = 28.964;
            flmProd.Compressibility_Factor__c = 1;
        } else {
            flmProd.Media_Name__c = null;
            flmProd.Atmospheric_Pressure__c = null;
            flmProd.Atmospheric_Pressure_Units__c = null;
            flmProd.Ratio_of_Specific_Heats__c = null;            
            flmProd.Molecular_Weight__c = null;
            flmProd.Compressibility_Factor__c = null;
        }     

        
        flmProd.Max_Allowable_Pressure_Drop__c = null;
        flmProd.Converted_Max_Allowable_Pressure_Drop__c = null;
        flmProd.Required_Flow_Rate__c = null;        
        flmProd.Converted_Required_Flow_Rate__c = null;           
        flmProd.Converted_Atmospheric_Pressure__c = null;
        flmProd.Temperature_of_flowing_Vapor__c = null;        
        flmProd.Converted_Temprature_of_flowing_Vapor__c = null;
        flmProd.Converted_Pressure_of_flowing_Vapor__c = null;
        flmProd.Sizing_Flow_Area_flag__c = false;
        return flmProd;
    }

    public static Flame_Product__c clearSectCCertifications(Flame_Product__c flmProd){
        flmProd.Atex_Certificate_2014_34_EU__c = null;
        flmProd.US_Coast_guard__c = null;
        flmProd.CU_TR__c = null;
        flmProd.Certfication_Requirement__c = 'None';
        flmProd.NACE__c = false;
        flmProd.Certifications_flag__c = false;
        return flmProd;
    }

    public static Flame_Product__c clearSectDProductNarrowing(Flame_Product__c flmProd){
        flmProd.Operational_Pressure__c = 14.7;
        flmProd.Operational_Pressure_Units__c = 'psia';
        flmProd.Converted_Operational_Pressure__c = null;
        flmProd.Operational_Temperature__c = '-4°F to 140°F (-20°C to 60°C)';
        //flmProd.Operational_Temperature_Units__c = null;
        flmProd.Offset_or_Concentric_Bases__c = 'BothOffCon';
        flmProd.Arrester_for_Detonation_or_Deflagration__c = 'Both';
        flmProd.Run_Up_Length_A_Input__c = null;
        flmProd.Run_Up_Length_A_Input_Units__c = 'in';
        flmProd.Converted_Run_up_Length_A__c = null;
        flmProd.Run_Up_Length_B_Input__c = null;
        flmProd.Run_Up_Length_B_Input_Units__c = 'in';
        flmProd.Converted_Run_up_Length_B__c = null;
        flmProd.Product_Narrowing_flag__c=false;
        return flmProd;
    }

    public static Flame_Product__c clearSectEProductSelection(Flame_Product__c flmProd){
        // if(flmProd.Arrester_for_Detonation_or_Deflagration__c == 'Detonation'){
        //     flmProd.Run_Up_Length_A_Input_Units__c = null;
        //     flmProd.Run_Up_Length_B_Input_Units__c = null;
        // }
        flmProd.Connection_Size__c = null;
        flmProd.Element_Size__c = null;
        flmProd.Model__c = null;
        flmProd.SZC__c = null;
        flmProd.ESZC__c = null;
        flmProd.Size__c = null;
        flmProd.PTC__c = null;
        flmProd.Product_selection_flag__c = false;
        return flmProd;
    }
    

    
       //added by piyush for readonly/editable logic 
  @AuraEnabled 
  public static formAccessibilityWrapper fetchFormAccessibility(string qliId){

      SBQQ__QuoteLine__c  qli = [SELECT Id, Run_Config_Sync__c,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c WHERE Id=:qliId];
      string quoteStatus = qli.SBQQ__Quote__r.SBQQ__Status__c;
      formAccessibilityWrapper oformAccessibilityWrapper = new formAccessibilityWrapper();
      Flame_Product__c FA = DataSelectorWizard.getFlameProductRecord(qliId);
      oformAccessibilityWrapper.bConfigurationComplete = FA.IsConfig__c;
      system.debug('Flame_Product__c --> IsConfig__c ' + FA.IsConfig__c);
      system.debug('Flame_Product__c Quote_Description_Engineer_Override__c --> ' + FA.Quote_Description_Engineer_Override__c);
      string configStatus= '';
      if(FA.IsConfig__c){
         if(FA.Quote_Description_Engineer_Override__c){
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


  //added by piyush for readonly/editable logic 
@AuraEnabled 
public static user fetchUserInfo(){
   user oUser = [Select Id,profile.Name From User WHERE id =: userinfo.getUserId()];
   return oUser;
}

    //#######################################################################################################################
    
}