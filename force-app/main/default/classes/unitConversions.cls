global class unitConversions {
    public static List<String> listGasFlowRatenew= new List<String> {
        'ASME Gas/Vapor',
            'API Gas/Vapor',
            'ISO Gas/Vapor'

            };
                public static string relievPressBaseUOM='psia';
    public static string relievTempBaseUOM='Deg R';
    public static string densityBaseUOM='lb/ft3';
    public static List<String> listStreamFlowRatenew= new List<String> {
        'ISO Dry Steam',
        'ISO Wet Steam',
        'API Steam',
        'ASME Steam'
    };
    public static List<String> listLiquidFlowRatenew= new List<String> {
        'ASME Water',
        'API Liquid',
        'API Omega Method 2 Phase Flashing or Nonflashing',
        'API Omega Method Subcooled Liquid',
        'ISO Liquid',

        'Fauske 2 Phase Gas-Liquid',
        'Fauske 2 Phase Vapor-Liquid',
        'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
        'Fauske All Liquid Flashing'
        };
    public static List<SelectOption> optsGasFlowRate {
        get {

            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(' ','--- None ---'));
            options.add(new SelectOption('ACFH','ACFH'));
            options.add(new SelectOption('ACFM','ACFM'));
            options.add(new SelectOption('Am3/h','Am3/h'));
            options.add(new SelectOption('Am3/min','Am3/min'));
            options.add(new SelectOption('kg/h','kg/h'));
            options.add(new SelectOption('kg/min','kg/min'));
            options.add(new SelectOption('lb/h','lb/h'));
            options.add(new SelectOption('lb/min','lb/min'));
            options.add(new SelectOption('Nm3/h','Nm3/h'));
            options.add(new SelectOption('Nm3/min','Nm3/min'));
            options.add(new SelectOption('SCFH','SCFH'));
            options.add(new SelectOption('SCFM','SCFM'));
            options.add(new SelectOption('SCMH','SCMH'));
            return options;
        }
        set {
            optsGasFlowRate=value;
        }
    }
    public static List<SelectOption> optsLiquidFlowRate {
        get {

            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(' ','--- None ---'));
            options.add(new SelectOption('(Imperial) gallon/h','(Imperial) gallon/h'));
            options.add(new SelectOption('(Imperial) gallon/min','(Imperial) gallon/min'));
            options.add(new SelectOption('(U.S.) gallon/h','(U.S.) gallon/h'));
            options.add(new SelectOption('(U.S.) gallon/min','(U.S.) gallon/min'));
            options.add(new SelectOption('barrel/h','barrel/h'));
            options.add(new SelectOption('ft3/h','ft3/h'));
            options.add(new SelectOption('ft3/min','ft3/min'));
            options.add(new SelectOption('kg/h','kg/h'));
            options.add(new SelectOption('kg/min','kg/min'));
            options.add(new SelectOption('L/h','L/h'));
            options.add(new SelectOption('L/min','L/min'));
            options.add(new SelectOption('lb/h','lb/h'));
            options.add(new SelectOption('lb/min','lb/min'));
            options.add(new SelectOption('m3/h','m3/h'));
            options.add(new SelectOption('m3/min','m3/min'));
            return options;
        }
        set {
            optsGasFlowRate=value;
        }
    }
    public static List<SelectOption> optsStreamFlowRate {
        get {

            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(' ','--- None ---'));
            options.add(new SelectOption('kg/h','kg/h'));
            options.add(new SelectOption('kg/min','kg/min'));
            options.add(new SelectOption('lb/h','lb/h'));
            options.add(new SelectOption('lb/min','lb/min'));
            return options;
        }
        set {
            optsGasFlowRate=value;
        }
    }
    public static map<string,string> mapRD_MNFAConverstionUOM {
        get{
            Map<String, string> myMap1 = new Map<String, string>();
            myMap1.put('ASME Gas/Vapor','in2');
            myMap1.put('ASME Water','in2');
            myMap1.put('ASME Steam','in2');
            myMap1.put('API Gas/Vapor','in2');
            myMap1.put('API Liquid','in2');
            myMap1.put('API Steam','in2');
            myMap1.put('ISO Gas/Vapor','mm2');
            myMap1.put('ISO Dry Steam','mm2');
            myMap1.put('ISO Wet Steam','mm2');
            myMap1.put('ISO Liquid','mm2');
            myMap1.put('API Omega Method 2 Phase Flashing or Nonflashing','in2');
            myMap1.put('API Omega Method Subcooled Liquid','in2');
            myMap1.put('Fauske 2 Phase Gas-Liquid','m2');
            myMap1.put('Fauske 2 Phase Vapor-Liquid','m2');
            myMap1.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','m2');
            myMap1.put('Fauske All Liquid Flashing','m2');

            return myMap1;
        }
        set {
            mapRD_MNFAConverstionUOM=value;
        }
    }
    public static map<string,string> mapRD_FlowRateBaseUOM {
        get{
            Map<String, string> myMap1 = new Map<String, string>();
            myMap1.put('ASME Gas/Vapor','lb/h');
            myMap1.put('ASME Water','lb/h');
            myMap1.put('ASME Steam','lb/h');
            myMap1.put('API Gas/Vapor','lb/h');
            myMap1.put('API Liquid','(U.S.) gallon/min');
            myMap1.put('API Steam','lb/h');
            myMap1.put('ISO Gas/Vapor','kg/h');

            myMap1.put('ISO Dry Steam','kg/h');
            myMap1.put('ISO Wet Steam','kg/h');
            myMap1.put('API Omega Method 2 Phase Flashing or Nonflashing','(U.S.) gallon/min');
            myMap1.put('API Omega Method Subcooled Liquid','(U.S.) gallon/min');
            myMap1.put('Fauske 2 Phase Gas-Liquid','kg/s');
            myMap1.put('Fauske 2 Phase Vapor-Liquid','kg/s');
            myMap1.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','kg/s');
            myMap1.put('Fauske All Liquid Flashing','kg/s');
            myMap1.put('ISO Liquid','kg/h');
            return myMap1;
        }
        set {
            mapRD_FlowRateBaseUOM=value;
        }
    }
    public static map<string,string> mapRD_RelievingPressureBaseUOM {
        get{
            map<string,string> myMap2 =new map<string,string>();
            myMap2.put('ASME Gas/Vapor','psia');
            myMap2.put('ASME Water','psia');
            myMap2.put('ASME Steam','psia');
            myMap2.put('API Gas/Vapor','psia');
            myMap2.put('API Liquid','psig');
            myMap2.put('API Steam','psia');
            myMap2.put('ISO Gas/Vapor','bar abs.');
            myMap2.put('ISO Liquid','bar abs.');
            myMap2.put('ISO Dry Steam','bar abs.');
            myMap2.put('ISO Wet Steam','bar abs.');
            myMap2.put('API Omega Method 2 Phase Flashing or Nonflashing','psia');
            myMap2.put('API Omega Method Subcooled Liquid','psia');
            myMap2.put('Fauske 2 Phase Gas-Liquid','Pa abs.');
            myMap2.put('Fauske 2 Phase Vapor-Liquid','Pa abs.');
            myMap2.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','Pa abs.');
            myMap2.put('Fauske All Liquid Flashing','Pa abs.');
            return myMap2;
        }
        set {
            mapRD_RelievingPressureBaseUOM=value;
        }
    }
    public static map<string,string> mapRD_RelievingTemperatureBaseUOM {
        get{
            map<string,string> myMap3 = new map<string,string>();
            myMap3.put('ASME Gas/Vapor','Deg R');
            myMap3.put('API Gas/Vapor','Deg R');
            myMap3.put('API Steam','Deg F');
            myMap3.put('ASME Steam','Deg R');
            myMap3.put('ISO Gas/Vapor','Deg K');
            myMap3.put('ISO Dry Steam','Deg C');
            myMap3.put('Fauske 2 Phase Gas-Liquid','Deg K');
            myMap3.put('Fauske 2 Phase Vapor-Liquid','Deg K');
            myMap3.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','Deg K');
            myMap3.put('Fauske All Liquid Flashing','Deg K');
            return myMap3;
        }
        set{
            mapRD_RelievingTemperatureBaseUOM=value;
        }
    }
    public static map<string,string> mapRD_ViscosityBaseUOM {
        get{
            map<string,string> myMap4 = new map<string,string>();
            myMap4.put('API Liquid','centipoise');
            myMap4.put('ISO Liquid','Pa.s');
            myMap4.put('API Omega Method 2 Phase Flashing or Nonflashing','centipoise');
            myMap4.put('API Omega Method Subcooled Liquid','centipoise');
            return myMap4;
        }
        set{
            mapRD_ViscosityBaseUOM=value;
        }
    }
    public static map<string,string> mapRD_SpecificVolumeBaseUOM {
        get{
            map<string,string> myMap5 = new map<string,string>();
            myMap5.put('ISO Liquid','m3/kg');
            myMap5.put('API Omega Method 2 Phase Flashing or Nonflashing','ft3/lb');
            myMap5.put('API Omega Method Subcooled Liquid','lb/ft3');
            return myMap5;
        }
        set{
            mapRD_SpecificVolumeBaseUOM =value;
        }
    }
    public static map<string,string> mapRD_SpecificVolumeAt90inletBaseUOM {
        get{
            map<string,string> myMap6 = new map<string,string>();
            myMap6.put('API Omega Method 2 Phase Flashing or Nonflashing','ft3/lb');
            myMap6.put('API Omega Method Subcooled Liquid','ft3/lb');
            return myMap6;
        }
        set{
            mapRD_SpecificVolumeAt90inletBaseUOM =value;
        }
    }
    public static map<string,string> mapRD_SaturationPressureAtInletBaseUOM {
        get{
            map<string,string> myMap7 = new map<string,string>();
            myMap7.put('API Omega Method Subcooled Liquid','psia');
            return myMap7;
        }
        set{
            mapRD_SaturationPressureAtInletBaseUOM =value;
        }
    }

    public static map<string,string> mapRD_SpecificGravityBaseUOM {
        get{
            map<string,string> myMap8 = new map<string,string>();
            myMap8.put('API Liquid','lb/ft3');
            myMap8.put('ISO Liquid','lb/ft3');
            myMap8.put('ASME Water','lb/ft3');
            return myMap8;
        }
        set{
            mapRD_SpecificGravityBaseUOM =value;
        }
    }

    public static map<string,string> mapRD_LiquidDensityBaseUOM {
        get{
            map<string,string> myMap9 = new map<string,string>();
            myMap9.put('Fauske 2 Phase Gas-Liquid','kg/m3');
            myMap9.put('Fauske 2 Phase Vapor-Liquid','kg/m3');
            myMap9.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','kg/m3');
            myMap9.put('Fauske All Liquid Flashing','kg/m3');
            return myMap9;
        }
        set{
            mapRD_LiquidDensityBaseUOM =value;
        }
    }

    public static map<string,string> mapRD_DensityatSaturationPressureBaseUOM {
        get{
            map<string,string> myMap10 = new map<string,string>();
            myMap10.put('API Omega Method Subcooled Liquid','lb/ft3');
            return myMap10;
        }
        set{
            mapRD_DensityatSaturationPressureBaseUOM =value;
        }
    }
    public static map<string,string> mapRD_DensityBaseUOM {
        get{
            map<string,string> myMap11 = new map<string,string>();
            myMap11.put('ASME Water','lb/ft3');
            myMap11.put('API Liquid','lb/ft3');
            myMap11.put('ISO Liquid','lb/ft3');
            myMap11.put('API Omega Method 2 Phase Flashing or Nonflashing','lb/ft3');
            myMap11.put('API Omega Method Subcooled Liquid','lb/ft3');
            return myMap11;
        }
        set{
            mapRD_DensityBaseUOM =value;
        }
    }

    public static map<string,string> mapRD_StagnationVaporDensityBaseUOM {
        get{
            map<string,string> myMap12 = new map<string,string>();
            myMap12.put('Fauske 2 Phase Vapor-Liquid','kg/m3');
            myMap12.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','kg/m3');
            myMap12.put('Fauske All Liquid Flashing','kg/m3');
            return myMap12;
        }
        set{
            mapRD_StagnationVaporDensityBaseUOM =value;
        }
    }
    public static map<string,string> mapRD_StagnationGasPartialPressureBaseUOM {
        get{
            map<string,string> myMap13 = new map<string,string>();
            myMap13.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','Pa abs.');
            myMap13.put('Fauske All Liquid Flashing','Pa abs.');
            return myMap13;
        }
        set{
            mapRD_StagnationGasPartialPressureBaseUOM =value;
        }
    }
    public static map<string,string> mapRD_VaporPressCorrespondToStagnationTempBaseUOM {
        get{
            map<string,string> myMap14 = new map<string,string>();
            myMap14.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','Pa abs.');
            myMap14.put('Fauske All Liquid Flashing','Pa abs.');
            return myMap14;
        }
        set{
            mapRD_VaporPressCorrespondToStagnationTempBaseUOM =value;
        }
    }
    public static map<string,string> mapRD_DensitySpecificVolumeSpecificGravityBaseUOM {
        get{
            map<string,string> myMap15 = new map<string,string>();
            myMap15.put('ASME Water','lb/ft3');
            myMap15.put('API Liquid','SG');
            myMap15.put('ISO Liquid','m3/kg');
            myMap15.put('API Omega Method 2 Phase Flashing or Nonflashing','lb/ft3');
            myMap15.put('API Omega Method Subcooled Liquid','lb/ft3');
            myMap15.put('Fauske 2 Phase Gas-Liquid','lb/ft3');
            myMap15.put('Fauske 2 Phase Vapor-Liquid','lb/ft3');
            myMap15.put('Fauske 2 Phase Hybrid Gas-Vapor-Liquid','lb/ft3');
            myMap15.put('Fauske All Liquid Flashing','lb/ft3');
            return myMap15;
        }
        set{
            mapRD_DensitySpecificVolumeSpecificGravityBaseUOM =value;
        }
    }
    public static Result convertDensitySpecifyVolume(string uomFrom,string uomTo,decimal value) {
        System.debug('uomFrom'+ uomFrom);
        System.debug('uomTo'+ uomTo);
        System.debug('value'+ value);
        decimal covertedValue;
        Result objResult=new Result();
        try {
            List<Density_SpecificVolume__c> denList=[select Multiplier__c,Exponent__c from Density_SpecificVolume__c where Density_UOM_From__c=:uomFrom and Density_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! denList.isEmpty()) {
                objResult.dblRetValue=(Math.pow(double.valueOf(value),double.valueOf(denList[0].Exponent__c ))*denList[0].Multiplier__c);
                objResult.bResult = true;
                System.debug('Density Specify Volume Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        } catch (Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertTemperature()' + e.getMessage());
            // objResult.bResult = false;
            // objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }
    public static Result convertPressure(string uomFrom,string uomTo,decimal value) {
        System.debug('uomFrom: ' + uomFrom);
        System.debug('uomTo: ' + uomTo);
        System.debug('value: ' + value);
        if(value==null)
            value=0;
        System.debug('value2: ' + value);
        decimal convertedValue;
        Result objResult = new Result();
        try{
            List<Pressure__c> pressure=[select Multiplier__c,Adder__c from Pressure__c where Pressure_UOM_From__c=:uomFrom and Pressure_UOM_To__c=:uomTo  LIMIT 1];
            System.debug('pressure: ' + pressure);
            if ( ! pressure.isEmpty()) {
                decimal adder=pressure.get(0).Adder__c.setScale(6);
                decimal multi=pressure.get(0).Multiplier__c;
                system.debug('adder'+adder);
                system.debug('multi'+multi);
                objResult.dblRetValue=(value*multi)+adder;
                system.debug('objResult.dblRetValue'+objResult.dblRetValue);
                //objResult.dblRetValue=objResult.dblRetValue.setScale(6);
                objResult.bResult = true;
                // System.debug('Pressure Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertPressure()' + e.getMessage());
            // objResult.bResult = false;
            //  objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        System.debug('objResult.dblRetValue'+objResult.dblRetValue);
        return objResult;
    }
    public static Result convertTemperature(string uomFrom,string uomTo,decimal value) {
        decimal convertedValue;
        System.debug('Temperature Value From : ' + uomFrom);
        System.debug('Temperature Value To : ' + uomTo);
        Result objResult = new Result();
        try{
            List<Temparature__c> temp=[select Multiplier__c,Adder__c,Divider__c from Temparature__c where Temperature_UOM_From__c=:uomFrom and Temperature_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! temp.isEmpty()) {
                objResult.dblRetValue=((value*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                objResult.bResult = true;
                System.debug('Temperature Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertTemperature()' + e.getMessage());
            //   objResult.bResult = false;
            //  objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }
    public static Result convertViscosity(string uomFrom,string uomTo,decimal value) {
        decimal convertedValue;
        Result objResult = new Result();
        try{
            List<Viscosity__c> temp=[select Multiplier__c from Viscosity__c where Viscosity_UOM_From__c=:uomFrom and Viscosity_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! temp.isEmpty()) {
                //objResult.dblRetValue=((value*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                objResult.dblRetValue=value*temp.get(0).Multiplier__c;
                objResult.bResult = true;
                System.debug('Viscosity Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertViscosity()' + e.getMessage());
            //  objResult.bResult = false;
            //  objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }
    public static Result convertDensity(string uomFrom,string uomTo,decimal value) {
        decimal convertedValue;
        Result objResult = new Result();
        try{
            List<Density__c> temp=[select Multiplier__c from Density__c where Density_UOM_From__c=:uomFrom and Density_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! temp.isEmpty()) {
                //objResult.dblRetValue=((value*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                objResult.dblRetValue=value*temp.get(0).Multiplier__c;
                objResult.bResult = true;
                System.debug('Density Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertDensity()' + e.getMessage());
            // objResult.bResult = false;
            // objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }
    public static Result convertGasFlowRate(string uomFrom,string uomTo,decimal GasFlowRate_Value_From,decimal P_psia,decimal MW,decimal T_DegR,decimal Z) {
        decimal convertedValue;
        decimal numerator;
        decimal numerator1;
        decimal denominator1;
        decimal numerator2;
        decimal denominator2;
        Result objResult = new Result();
        try{
            system.debug('From'+uomFrom);
            system.debug('To'+uomTo);
            system.debug('GasFlowRate_Value_From'+GasFlowRate_Value_From);
            system.debug('P_psia'+P_psia);
            system.debug('MW'+MW);
            system.debug('T_DegR'+T_DegR);
            system.debug('Z'+Z);

            List<GasFlowRate__c> temp=[select Multiplier__c,DensityActualFrom__c,DensityActualTo__c,DensityStandardFrom__c,DensityStandardTo__c,PFromPsia__c,PToPsia__c,TFromR__c,TToR__c from GasFlowRate__c where GasFlowRate_UOM_From__c=:uomFrom and GasFlowRate_UOM_To__c=:uomTo  LIMIT 1];
            System.debug('AAAAAAAAA temp : ' + temp);
            if ( ! temp.isEmpty()) {
                numerator=GasFlowRate_Value_From*temp.get(0).Multiplier__c;
                numerator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.get(0).DensityActualFrom__c.doubleValue());
                denominator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.get(0).DensityActualTo__c.doubleValue());
                numerator2=Math.pow(((temp.get(0).PFromPsia__c*MW*144)/(1545*temp.get(0).TFromR__c*Z)).doubleValue(), temp.get(0).DensityStandardFrom__c.doubleValue());
                denominator2=Math.pow(((temp.get(0).PToPsia__c*MW*144)/(1545*temp.get(0).TToR__c*Z)).doubleValue(), temp.get(0).DensityStandardTo__c.doubleValue());
                objResult.dblRetValue=numerator*(numerator1/denominator1)*(numerator2/denominator2);
                objResult.bResult = true;
                System.debug('convertGasFlowRate : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                //objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }

        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertGasFlowRate()' + e.getMessage());
            // objResult.bResult = false;
            //objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }

        return objResult;
    }
    public static Result convertLiquidFlowRate(string uomFrom,string uomTo,decimal LiquidFlowRate_Value_From,decimal density) {
        decimal convertedValue;
        decimal numerator;
        decimal numerator1;
        decimal denominator1;
        decimal numerator2;
        decimal denominator2;
        Result objResult = new Result();
        try{
            system.debug('From'+uomFrom);
            system.debug('To'+uomTo);
            system.debug('LiquidFlowRate_Value_From'+LiquidFlowRate_Value_From);
            system.debug('density'+density);

            List<LiquidFlowRate__c> temp=[select Multiplier__c,DensityActualTo__c,DensityActualFrom__c from LiquidFlowRate__c where LiquidFlowRate_UOM_From__c=:uomFrom and LiquidFlowRate_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! temp.isEmpty()) {
                numerator=LiquidFlowRate_Value_From*temp.get(0).Multiplier__c;
                numerator1=Math.pow(density.doubleValue(), temp.get(0).DensityActualFrom__c.doubleValue());
                denominator1=Math.pow(density.doubleValue(), temp.get(0).DensityActualTo__c.doubleValue());
                objResult.dblRetValue=numerator*(numerator1/denominator1);
                objResult.bResult = true;
                System.debug('convertLiquidFlowRate : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                //objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
                System.debug('convertLiquidFlowRate : No Data Found' + string.valueof(objResult.dblRetValue));
            }

        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertGasFlowRate()' + e.getMessage());
            // objResult.bResult = false;
            //objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }

        return objResult;
    }
    public static Result convertDistance(string uomFrom,string uomTo,decimal value) {
        decimal convertedValue;
        Result objResult = new Result();
        try{
            List<Distance__c> temp=[select Multiplier__c,Divider__c from Distance__c where Distance_UOM_From__c=:uomFrom and Distance_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! temp.isEmpty()) {
                //objResult.dblRetValue=((value*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                objResult.dblRetValue=value*(temp.get(0).Multiplier__c/temp.get(0).Divider__c);
                objResult.bResult = true;
                System.debug('Distance Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertDistance()' + e.getMessage());
            // objResult.bResult = false;
            //  objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }
    public static Result convertArea(string uomFrom,string uomTo,decimal value) {
        decimal convertedValue;
        Result objResult = new Result();
        try{
            List<Area__c> temp=[select Multiplier__c,Divider__c from Area__c where Area_UOM_From__c=:uomFrom and Area_UOM_To__c=:uomTo  LIMIT 1];
            System.debug('convertArea  uomFrom: ' + uomFrom);
            System.debug('convertArea  uomTo: ' + uomTo);
            System.debug('convertArea  value: ' + value);
            if ( ! temp.isEmpty()) {
                //objResult.dblRetValue=((value*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                objResult.dblRetValue=value*(temp.get(0).Multiplier__c/temp.get(0).Divider__c);
                objResult.bResult = true;
                System.debug('Distance Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertArea()' + e.getMessage());
            // objResult.bResult = false;
            // objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        //system.debug('objResult---->>>>'+objResult);
        return objResult;
    }
    public static Result convertVolume(string uomFrom,string uomTo,decimal value) {
        decimal convertedValue;
        Result objResult = new Result();
        try{
            List<Volume__c> temp=[select Multiplier__c from Volume__c where Volume_UOM_From__c=:uomFrom and Volume_UOM_To__c=:uomTo  LIMIT 1];
            if ( ! temp.isEmpty()) {
                //objResult.dblRetValue=((value*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                objResult.dblRetValue=value*temp.get(0).Multiplier__c;
                objResult.bResult = true;
                System.debug('Volume Value : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false;
                objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
        }
        catch(Exception e) {
            System.debug('The following exception has occurred: unitConversions:convertVolume()' + e.getMessage());
            //  objResult.bResult = false;
            //  objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }
    //UNIT Converstions
    public static result getConvertedValErrorMsg(string strConvType,decimal decMaxVal,decimal decMinVal,string strBaseUnits,string strUserUnits,decimal value, string fieldname) {
        result res=new result();
        if (strConvType=='Pressure') {
            try{
                List<Pressure__c> pressure=[select Multiplier__c,Adder__c from Pressure__c where Pressure_UOM_From__c=:strBaseUnits and Pressure_UOM_To__c=:strUserUnits  LIMIT 1];
                decimal maxVal=(decMaxVal*pressure.get(0).Multiplier__c)+pressure.get(0).Adder__c;
                decimal minVal=(decMinVal*pressure.get(0).Multiplier__c)+pressure.get(0).Adder__c;
                System.debug('minVal: ' + minVal);
                System.debug('maxVal: ' + maxVal);
                Result res1;
                Result res2;
                res1=SignificantDigitsUp(minVal,4,-99);
                decimal minvalmsg=res1.dblRetValue;
                res2=SignificantDigitsDown(maxVal,4,-99);
                decimal maxvalmsg=res2.dblRetValue;

                if (value<minVal || value>maxVal) {
                    System.debug('Try block:-----');
                    res.bResult=true;
                    res.bErrorCheck=true;
                    res.strErrorMessage=fieldname+' : Please enter valid value between '+minvalmsg+' '+strUserUnits+' and '+maxvalmsg+' '+strUserUnits;
                } else {
                    res.bResult=true;
                    res.bErrorCheck=false;
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                //   res.bResult = false;
                //   res.dblRetValue=0;
                res.strErrorMessage = e.getMessage();
                System.debug(res.strErrorMessage);
            }

        } else if (strConvType=='Temperature') {
            System.debug('temp: ' + strConvType);
            try{
                List<Temparature__c> temp=[select Multiplier__c,Adder__c,Divider__c from Temparature__c where Temperature_UOM_From__c=:strBaseUnits and Temperature_UOM_To__c=:strUserUnits  LIMIT 1];
                System.debug('temp: ' + temp);
                System.debug('units: ' + strBaseUnits);
                System.debug('strUserUnits: ' + strUserUnits);
                if ( ! temp.isEmpty()) {
                    System.debug('value: ' + value);
                    decimal maxVal=((decMaxVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                    decimal minVal=((decMinVal*temp.get(0).Multiplier__c)+temp.get(0).Adder__c)/temp.get(0).Divider__c;
                    System.debug('value: ' + value);
                    System.debug('minVal: ' + minVal);
                    System.debug('maxVal: ' + maxVal);
                    Result res1;
                    Result res2;
                    res1=SignificantDigitsUp(minVal,4,-99);
                    decimal minvalmsg=res1.dblRetValue;
                    res2=SignificantDigitsDown(maxVal,4,-99);
                    decimal maxvalmsg=res2.dblRetValue;

                    if (value<minVal || value>maxVal) {
                        res.bResult=true;
                        res.bErrorCheck=true;
                        res.strErrorMessage=fieldname+' : Please enter valid value between '+minvalmsg+' '+strUserUnits+' and '+maxvalmsg+' '+strUserUnits;
                        //res.strErrorMessage=fieldname+' : Temperature Setting must be Greater than '+minVal.setScale(2)+' '+strUserUnits+' and less than '+maxVal.setScale(2)+' '+strUserUnits;
                    } else {
                        res.bResult=true;
                        res.bErrorCheck=false;
                    }
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                //   res.bResult = false;
                //   res.dblRetValue=0;
                res.strErrorMessage = e.getMessage();
                System.debug(res.strErrorMessage);
            }
        }
        else if (strConvType=='GasFlowRate') {
            decimal convertedValue;
            decimal numerator;
            decimal numerator1;
            decimal denominator1;
            decimal numerator2;
            decimal denominator2;
            decimal GasMinnumerator;
            decimal GasMaxnumerator;
            try{
                List<GasFlowRate__c> temp=[select Multiplier__c,DensityActualFrom__c,DensityActualTo__c,DensityStandardFrom__c,DensityStandardTo__c,PFromPsia__c,PToPsia__c,TFromR__c,TToR__c from GasFlowRate__c where GasFlowRate_UOM_From__c=:strBaseUnits and GasFlowRate_UOM_To__c=:strUserUnits  LIMIT 1];
                if ( ! temp.isEmpty()) {
                    decimal P_psia=1;
                    decimal MW=1;
                    decimal T_DegR=1;
                    decimal Z=1;

                    GasMinnumerator=decMinVal*temp.get(0).Multiplier__c;
                    GasMaxnumerator=decMaxVal*temp.get(0).Multiplier__c;
                    numerator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.get(0).DensityActualFrom__c.doubleValue());
                    denominator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.get(0).DensityActualTo__c.doubleValue());
                    numerator2=Math.pow(((temp.get(0).PFromPsia__c*MW*144)/(1545*temp.get(0).TFromR__c*Z)).doubleValue(), temp.get(0).DensityStandardFrom__c.doubleValue());
                    denominator2=Math.pow(((temp.get(0).PToPsia__c*MW*144)/(1545*temp.get(0).TToR__c*Z)).doubleValue(), temp.get(0).DensityStandardTo__c.doubleValue());
                    decimal minVal=GasMinnumerator*(numerator1/denominator1)*(numerator2/denominator2);
                    decimal maxVal=GasMaxnumerator*(numerator1/denominator1)*(numerator2/denominator2);
                    System.debug('minVal: ' + minVal);
                    System.debug('maxVal: ' + maxVal);
                    Result res1;
                    Result res2;
                    res1=SignificantDigitsUp(minVal,4,-99);
                    decimal minvalmsg=res1.dblRetValue;
                    res2=SignificantDigitsDown(maxVal,4,-99);
                    decimal maxvalmsg=res2.dblRetValue;

                    if (value<=minVal || value>maxVal) {
                        res.bResult=true;
                        res.bErrorCheck=true;
                        res.strErrorMessage=fieldname+'Please enter valid value between '+minvalmsg+' '+strUserUnits+' and '+maxvalmsg+' '+strUserUnits;
                    } else {
                        res.bResult=true;
                        res.bErrorCheck=false;
                    }
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                //  res.bResult = false;
                //  res.dblRetValue=0;
                res.strErrorMessage = e.getMessage();
                System.debug(res.strErrorMessage);
            }
        }

        else if (strConvType=='WGBGasFlowRate') {
            decimal convertedValue;
            decimal numerator;
            decimal numerator1;
            decimal denominator1;
            decimal numerator2;
            decimal denominator2;
            decimal GasMinnumerator;
            decimal GasMaxnumerator;
            try{
                List<GasFlowRate__c> temp=[select Multiplier__c,DensityActualFrom__c,DensityActualTo__c,DensityStandardFrom__c,DensityStandardTo__c,PFromPsia__c,PToPsia__c,TFromR__c,TToR__c from GasFlowRate__c where GasFlowRate_UOM_From__c=:strBaseUnits and GasFlowRate_UOM_To__c=:strUserUnits  LIMIT 1];
                if ( ! temp.isEmpty()) {
                    decimal P_psia=1;
                    decimal MW=1;
                    decimal T_DegR=1;
                    decimal Z=1;

                    GasMinnumerator=decMinVal*temp.get(0).Multiplier__c;
                    GasMaxnumerator=decMaxVal*temp.get(0).Multiplier__c;
                    numerator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.get(0).DensityActualFrom__c.doubleValue());
                    denominator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.get(0).DensityActualTo__c.doubleValue());
                    numerator2=Math.pow(((temp.get(0).PFromPsia__c*MW*144)/(1545*temp.get(0).TFromR__c*Z)).doubleValue(), temp.get(0).DensityStandardFrom__c.doubleValue());
                    denominator2=Math.pow(((temp.get(0).PToPsia__c*MW*144)/(1545*temp.get(0).TToR__c*Z)).doubleValue(), temp.get(0).DensityStandardTo__c.doubleValue());
                    decimal minVal=GasMinnumerator*(numerator1/denominator1)*(numerator2/denominator2);
                    decimal maxVal=GasMaxnumerator*(numerator1/denominator1)*(numerator2/denominator2);
                    System.debug('minVal: ' + minVal);
                    System.debug('maxVal: ' + maxVal);
                    Result res1;
                    Result res2;
                    res1=SignificantDigitsUp(minVal,4,-99);
                    decimal minvalmsg=res1.dblRetValue;
                    res2=SignificantDigitsDown(maxVal,4,-99);
                    decimal maxvalmsg=res2.dblRetValue;

                    if (value<=minVal || value>maxVal) {
                        res.bResult=true;
                        res.bErrorCheck=true;
                        res.strErrorMessage=fieldname+'Please enter a value greater than '+minvalmsg+' '+strUserUnits+' and less than or equal to '+maxvalmsg+' '+strUserUnits;
                    } else {
                        res.bResult=true;
                        res.bErrorCheck=false;
                    }
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                //   res.bResult = false;
                //   res.dblRetValue=0;
                res.strErrorMessage = e.getMessage();
                System.debug(res.strErrorMessage);
            }
        }

        return res;
    }
    // ROUNDING FUNCTIONS
    public static Result SignificantDigitsNormal(decimal dblInitialValue, integer intSignificantDigits,integer intMinDecimalPlaces ) {
        decimal dcNum =0.0;
        Result objResult = new Result();
        try{
            long DecimalPlaces;
            long intresult;
            decimal ld=math.log10(dblInitialValue);
            System.debug('Logarithm Value'+ ld);

            decimal intval=intSignificantDigits-ld;
            System.debug('Significant minus Log Value'+ intval);

            //intresult=Integer.valueOf(intval);

            intresult=intval.round(System.RoundingMode.FLOOR);
            System.debug('Significant minus Log Value Integer Value'+ intresult);

            System.debug('MinDecimalPlaces---'+ intMinDecimalPlaces);
            if(intMinDecimalPlaces>intresult)
                DecimalPlaces=intMinDecimalPlaces;
            else
                DecimalPlaces=intresult;
            System.debug('DecimalPlaces'+DecimalPlaces);
            //=INT(dblInitialValue*10^DecimalPlaces+0.5)/10^DecimalPlaces
            /*Long numerator = (dblInitialValue*(math.exp(DecimalPlaces*math.log(10)))+0.5).round(System.RoundingMode.FLOOR);
//Integer denominator = Integer.valueOf(math.exp(DecimalPlaces*math.log(10)));
decimal result1 = numerator/denominator;
System.debug('result ** ' +result1);
objResult.dblRetValue=numerator/denominator;
System.debug('numerator ** ' +numerator);
System.debug('denominator ** ' +denominator);
System.debug('Significant Round Normal value ** ' +objResult.dblRetValue);*/

            integer decpalces=integer.valueOf(DecimalPlaces);
            dcNum = dblInitialValue;
            //dcNum = dcNum.setScale(decpalces);
            objResult.dblRetValue=dcNum.setScale(decpalces, RoundingMode.HALF_UP);
            System.debug('Significant Round Normal value ----' +dcNum);
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        return objResult;
    }

    public static Result SignificantDigitsDown(decimal dblInitialValue, integer intSignificantDigits,long intMinDecimalPlaces ){
        decimal dcNum =0.0;
        decimal decf=0.0;
        decimal FloorInitialValue=0.0;
        Result objResult = new Result();
        try{
            long DecimalPlaces,intresult;

            decimal ld=math.log10(dblInitialValue);
            //  System.debug('Log Value'+ ld);

            decimal intval=intSignificantDigits-ld;
            intresult=intval.round(System.RoundingMode.FLOOR);
            if(intMinDecimalPlaces>intresult)
                DecimalPlaces=intMinDecimalPlaces;
            else
                DecimalPlaces=intresult;
            dcNum =dblInitialValue;
            decf=math.pow(10, DecimalPlaces);
            FloorInitialValue=dblInitialValue*decf;
            dcNum=FloorInitialValue.round(System.RoundingMode.FLOOR);
            dcNum = dcNum/decf;
            objResult.dblRetValue=dcNum;

        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        return objResult;
    }

    public static Result SignificantDigitsUp(decimal dblInitialValue, integer intSignificantDigits,long intMinDecimalPlaces ) {
        decimal dcNum =0.0;
        decimal decf=0.0;
        decimal FloorInitialValue=0.0;
        Result objResult = new Result();
        try{
            long DecimalPlaces,intresult;

            decimal ld=math.log10(dblInitialValue);
            //     System.debug('Log Value'+ ld);

            decimal intval=intSignificantDigits-ld;
            intresult=intval.round(System.RoundingMode.FLOOR);
            if(intMinDecimalPlaces>intresult)
                DecimalPlaces=intMinDecimalPlaces;
            else
                DecimalPlaces=intresult;
            dcNum =dblInitialValue;
            decf=math.pow(10, DecimalPlaces);
            FloorInitialValue=dblInitialValue*decf;
            dcNum=FloorInitialValue.round(System.RoundingMode.Up);
            dcNum = dcNum/decf;
            objResult.dblRetValue=dcNum;
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        return objResult;
    }

    public static decimal RoundNormal(decimal dblInitialValue, integer nDecimalPlaces) {
        decimal dcNum =0.0;
        try{
            dcNum = dblInitialValue;
            dcNum = dcNum.setScale(nDecimalPlaces);
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        return dcNum;
    }
    public static decimal RoundDown(decimal dblInitialValue, integer nDecimalPlaces) {
        decimal dcNum =0.0;
        decimal decf=0.0;
        decimal FloorInitialValue=0.0;

        try{
            decf=math.pow(10, nDecimalPlaces);
            FloorInitialValue=dblInitialValue*decf;
            FloorInitialValue=FloorInitialValue/decf;
            dcNum=FloorInitialValue.round(System.RoundingMode.FLOOR);
            // dcNum = dcNum/decf;
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        return dcNum;
    }
    public static Decimal multiplyAndAdd(Decimal baseValue, Decimal scaleValue) {
        Decimal multiplier = 1.0;
        if(-99999.0 < baseValue && 0.1 >= baseValue) {
            multiplier = 10000.0;
        } else if(0.1 < baseValue && 1.0 >= baseValue) {
            multiplier = 1000.0;
        } else if(1.0 < baseValue && 10.0 >= baseValue) {
            multiplier = 100.0;
        } else if(10.0 < baseValue && 100.0 >= baseValue) {
            multiplier = 10.0;
        }
        Long intermediateValue=(baseValue * multiplier + scaleValue).round(System.RoundingMode.DOWN);
        // ('BaseValue------------'+baseValue);
        //System.debugm.debug('ScaleValue------------'+scaleValue);
        return (intermediateValue / multiplier).setScale(2);
    }
    public static decimal RoundUp(decimal dblInitialValue, integer nDecimalPlaces) {
        decimal dcNum =0.0;
        decimal decf=0.0;
        decimal CeilingInitialValue=0.0;
        try{
            decf=math.pow(10, nDecimalPlaces);
            CeilingInitialValue=dblInitialValue*decf;
            CeilingInitialValue=CeilingInitialValue/decf;
            dcNum=CeilingInitialValue.round(System.RoundingMode.CEILING);
            // dcNum = dcNum/decf;
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        return dcNum;
    }
}