// This class handles size and capacity calculation for rupture disc.
// shailesh kolhe Aug 2019
// Why variable names are used like W, P, T and M etc instead of proper names ??
// This is because they represent same letter as that specified in excel "DiscSizingCapacityRules"
// That excel details all the formulas and related explanation for those terms and formulas.
// References:
// Double
// A 64-bit number that includes a decimal point. Doubles have a minimum value of -2^63 and a maximum value of (2^63)-1
// So. (2^63)-1 gives 9223372036854775807 and -2^63 gives -9223372036854775808 if you have no decimal value.
// Using double instead of decimal as our case includes detailed scientific calculation with more precison required.
// IMP: Where you see debug below, retain that code but comment out in production. It has important values printed
// Why Size and Capacity methods are separate? In User flow it is likely that first Size is required. Then user flow continues
// and eventually we have all input needed to calculate the capacity. Plus it is easy to maiantain that way to separate size
// and capacity calculation. The formulas are different. The input are same for some parameters and different as well.
// We can reduce some amount of code lines by calling Size method from within the Capacity as Size is required for
// capacity. However then we will end up processing more then. few more lines of code is better than increasing processing time

// IMP: The Size and Capacity functions have some common code. Those are related common query, validation etc
// that way it is easy to maintain same code related to validation etc.

global class RDDiscSizingCapacity {

    // ASMEAIR
    // This method returns Size for ASMEAir
    public static Result ASMEAIRSize(double W, double P, double T, double M){
    // This object is used to convey back the results of various operations we will end up doing here.
    system.debug('Flow Capacity'+W);
    system.debug('Pressure'+P);
    system.debug('Temperature'+T);
    system.debug('Molecular Weight'+M);
    Result objResult = new Result();
    try{
    double K=0.0;
    objResult = ASMEAIRCommon(P);
    if(objResult.bResult != True)
    return objResult;
    else
    K = objResult.dblRetValue;
    // ASME Air Size formula
    objResult.dblRetValue = W/ (356*K*P) * Math.sqrt(T/M);
    system.debug('ASMEAIRSize:' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    system.debug('ASMEAIRSize: Rounded' + string.valueof(objResult.dblRetValue));
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEAIRSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }
    // This method returns Capacity for ASMEAir
    public static Result ASMEAIRCapacity(double P, double T, double M,integer nSize, String strPTC, String strSeat,double Ard){
    // This object is used to convey back the results of various operations we will end up doing here.
        Result objResult = new Result();
        try{
            // K is a lookup from table "DiscCoef"
                double K=0.0;
                //Ard=0.0;
                objResult = ASMEAIRCommon(P);
            if(objResult.bResult != True)
                return objResult;
            else
                K = objResult.dblRetValue;

            // Get value of Ard from table "RDMasterBlaster"
            //C010*******************************************************************************
            // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
            // if(objResult.bResult != True)
            //     return objResult;
            // else
            //     Ard = objResult.dblRetValue;
            //##################################################################################
            // Calculate Capacity
            objResult.dblRetValue = 356* k *Ard* P * (Math.sqrt(M/T));
            System.debug('ASMEAIRCapacity: ' +string.valueof(objResult.dblRetValue));
            // Round the result to 6 decimals
            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
            System.debug('ASMEAIRCapacity:Rounded ' +string.valueof(objResult.dblRetValue));
        }
        catch(Exception e){
        System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEAIRCapacity()' + e.getMessage());
        objResult.bResult = false;
        objResult.strErrorMessage = e.getMessage();
        }
        objResult.bResult = true;
        return objResult;
    }

    public static Result ASMEAIRCommon(double P){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try{
    // Valid value check
    // P  must be greater than 27.82
    if(P<27.82){
    objResult.bResult = false;
    objResult.strErrorMessage = 'Value of P is less that 27.82 psia, which is not allowed for ASME Steam';
    System.debug('ASMEAIRCommon:' + objResult.strErrorMessage);
    return objResult;
    }
    // Get value of K from table "DiscCoef"
    List<DiscCoef__c> objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE (Evaluation__c='ASME Air' ) ];
    // Make sure we got response
    if ( ! objDiscCoef.isEmpty()) {
    objResult.dblRetValue = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'No Data Found';
    return objResult;
    }
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEAIRCommon()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }
//Method Signarture Changed to fix #35122 redmine.
//Added Derate calculation logic to pick the DSCVAR from the MAsterBlaster
public static Result RD_DSCVAR(integer nSize, String strPTC, String strSeat, String filterSecABCD, decimal tempDerate,decimal brustPressure){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
// try{
// Get value of Ard from table "RDMasterBlaster"
//String strDynamic;
    String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
    String strDynamic = 'SELECT VMNFA__c, DSCVAR__C,MNFA__c,MatlCodePos__c,DerateType__c,PTC__c,Derate_EQN__c,Teflon_Ambient__c,PressLL__c,PressUL__c,VacLL__c,VacUL__c,STC__c,SZC__c FROM RDMasterBlaster__c WHERE ';
    strDynamic = strDynamic + 'SZC__c =\'' + strSZC + '\' and PTC__c=\'' + strPTC + '\' and STC__c=\'' + strSeat +'\' and ' + filterSecABCD;
    System.debug('strDynamic'+strDynamic);

    List<RDMasterBlaster__c> objRDMasterBlaster = Database.query(strDynamic);
    //List<RDMasterBlaster__c> objRDMasterBlaster = [SELECT DSCVAR__C FROM RDMasterBlaster__c WHERE SZC__c=:nSize and PTC__c=:strPTC and STC__c=:strSeat and filterSecABCD];
    // Make sure we got response
    Set<String> uniqueDSCVARList=new  Set<String>();
    Set<Decimal> uniqueVMNFASet = new Set<Decimal>();
    Set<Decimal> uniqueMNFASet = new Set<Decimal>();
    decimal tempBrustPressure=brustPressure;
    if ( ! objRDMasterBlaster.isEmpty()) {
        Map < string, List < Derate_Value__c >> mapDetValues = new Map < string, List < Derate_Value__c >> ();
        //  if(!derateCheck)
        mapDetValues = RuptureDiscController.mapDerateValues(tempDerate);
        Boolean hasDerateRec=false;
        for (RDMasterBlaster__c localRDM:objRDMasterBlaster) {

            string key = RuptureDiscController.matlCodeProcessor(localRDM.MatlCodePos__c) + localRDM.DerateType__c;
            decimal deratevalue = 1;
        //    decimal brustPressure = 0;
        //     if (localRDM.PTC__c != 'CAL')
        //         brustPressure = ruptureDisc.Converted_Pressure_Setting__c;
        //     else
        //         brustPressure = ruptureDisc.Converted_Vacuum_Setting__c;
            tempBrustPressure=brustPressure;
            // // if(!derateCheck) {
            if (localRDM.PTC__c != 'PAS' && localRDM.PTC__c != 'CAL') {
                if (mapDetValues.containsKey(key)) {
                    // Derate_Value__c dvalue=filterDerateValue(mapDetValues.get(key),ruptureDisc.Converted_Temperature_Setting__c);
                    deratevalue = mapDetValues.get(key)[0].Derate__c;
                }
                if (localRDM.Derate_EQN__c == 'METL' || localRDM.Derate_EQN__c == 'COMM') {
                    
                    tempBrustPressure = tempBrustPressure / deratevalue;
                    // System.debug('Material' +localRDM.MatlCodePos__c +'PressLL' +localRDM.PressLL__c+' PressUL'+localRDM.PressUL__c +'DEarte '+deratevalue+' Brust PRessure'+tempBrustPressure);
                } else if (localRDM.Derate_EQN__c == 'COMA') {
                    decimal MetAlum = 0;
                    string strMetlAlum = '001' + localRDM.DerateType__c;
                    // Derate_Value__c Metldvalue=filterDerateValue(mapDetValues.get(strMetlAlum),ruptureDisc.Converted_Temperature_Setting__c);
                    if (mapDetValues.containsKey(strMetlAlum))
                        MetAlum = mapDetValues.get(strMetlAlum)[0].Derate__c;
                        tempBrustPressure = 2 * tempBrustPressure / (deratevalue + MetAlum);
                } else if (localRDM.Derate_EQN__c == 'COMT') {
                    string strMetlAlum = '001' + localRDM.DerateType__c;
                    decimal TefDer = 1;
                    // Derate_Value__c Metldvalue=filterDerateValue(mapDetValues.get(strMetlAlum),ruptureDisc.Converted_Temperature_Setting__c);
                    string strTef = '070' + localRDM.DerateType__c;
                    // Derate_Value__c TefDervalue=filterDerateValue(mapDetValues.get(strTef),ruptureDisc.Converted_Temperature_Setting__c);
                    //decimal MetAlum=mapDetValues.get(strMetlAlum)[0].Derate__c;
                    if (mapDetValues.containsKey(strTef))
                        TefDer = mapDetValues.get(strTef)[0].Derate__c;
                        tempBrustPressure = tempBrustPressure - (TefDer * localRDM.Teflon_Ambient__c) / deratevalue;
                        tempBrustPressure += localRDM.Teflon_Ambient__c;
                    //localRDM.Teflon_Ambient__c;
                } else {

                }
                //}
            }
            if (localRDM.PTC__c != 'CAL') {
                if (localRDM.PressLL__c <= tempBrustPressure && localRDM.PressUL__c > tempBrustPressure) {
                    //rdMasterIDs.add(localRDM.id);
                    hasDerateRec=true;
                    uniqueDSCVARList.add(localRDM.DSCVAR__C);
                    uniqueVMNFASet.add(localRDM.VMNFA__c);
                    uniqueMNFASet.add(localRDM.MNFA__c);
                    system.debug('tempBrustPressure  INCLUDED DSCVAR ' + tempBrustPressure.setScale(2) + '-->>> PTC' + localRDM.PTC__c + '-' + localRDM.STC__c + '-' + localRDM.SZC__c +'Material'+localRDM.MatlCodePos__c);
                } else {
                    // system.debug('tempBrustPressure  Excluded' + tempBrustPressure + '-->>> PTC' + localRDM.PTC__c + ' --> Seat' + localRDM.STC__c + ' Size-->' + localRDM.SZC__c);
                }
            } else {
                if (localRDM.VacLL__c <= tempBrustPressure && localRDM.VacUL__c > tempBrustPressure) {
                    // rdMasterIDs.add(localRDM.id);
                    hasDerateRec=true;
                    uniqueDSCVARList.add(localRDM.DSCVAR__C);
                    uniqueVMNFASet.add(localRDM.VMNFA__c);
                    uniqueMNFASet.add(localRDM.MNFA__c);
                } else {
                    //system.debug('tempBrustPressure  Excluded' + tempBrustPressure + '-->>> PTC' + localRDM.PTC__c + ' --> Seat' + localRDM.STC__c + ' Size-->' + localRDM.SZC__c);
                }
            }

        }
        if(hasDerateRec) {
            System.debug('DSCVARLIST--->'+uniqueDSCVARList);
            string firstelement =(new list<string>(uniqueDSCVARList) )[0] ;
            Decimal firstVMNFASetElement =0;
            Decimal firstMNFASetElement =0;
            for (decimal d:uniqueMNFASet) {
                if(d!=0 && d!=null) {
                    firstMNFASetElement=d;
                    break;
                }
            }
            for (decimal d:uniqueVMNFASet) {
                if(d!=0 && d!=null) {
                    firstVMNFASetElement=d;
                    break;
                }
            }
            //Decimal firstVMNFASetElement =(new list<Decimal>(uniqueVMNFASet) )[0];
            //Decimal firstMNFASetElement =(new list<Decimal>(uniqueMNFASet) )[0];
            if(uniqueDSCVARList.size()>1 || firstelement=='AL' || firstelement=='M' || firstelement=='T')
                objResult.strRetValue ='N';
            else
                objResult.strRetValue = firstelement;

            // if(uniqueVMNFASet.size()>1){
            //     objResult.dblRetValue = firstVMNFASetElement;
            // } else {
            //     objResult.dblRetValue = firstVMNFASetElement;
            // }
            // if(uniqueMNFASet.size()>1){
            //     objResult.dblRetValue2 = firstMNFASetElement;
            // } else {
            //     objResult.dblRetValue2 = firstMNFASetElement;
            // }

            objResult.dblRetValue = firstVMNFASetElement;
            objResult.dblRetValue2 = firstMNFASetElement;

            System.debug('DSCVAR: ' +string.valueof(objResult.strRetValue));
            System.debug('VMNFA: ' +string.valueof(objResult.dblRetValue));
            System.debug('MNFA: ' +string.valueof(objResult.dblRetValue2));
            objResult.bResult = true;
        } else {
            objResult.bResult = false;
            objResult.strErrorMessage = 'RDDiscSizingCapacity:RDMasterBlaster: No Data Found After Derate';
        }
    } else {
        objResult.bResult = false;
        objResult.strErrorMessage = 'RDDiscSizingCapacity:RDMasterBlaster: No Data Found';
    }

// }
// // catch(Exception e){
//     System.debug('The following exception has occurred: RDDiscSizingCapacity:RDMasterBlaster()' + e.getMessage());
//     objResult.bResult = false; objResult.strErrorMessage = e.getMessage();
// }
    objResult.bResult = true;
    return objResult;
}

    public static Result RDMasterBlaster(integer nSize, String strPTC, String strSeat){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
    try{
    // Get value of Ard from table "RDMasterBlaster"
    //List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
    List<RDMasterBlaster__c> objRDMasterBlaster =  [SELECT MNFA__c
                            FROM RDMasterBlaster__c WHERE  PTC__c=:strPTC and STC__c=:strSeat and SZC__c=:strSZC  AND MNFA__c !=NULL ORDER BY MNFA__c DESC]; //SZC__c=:nSize and
    // Make sure we got response
    if ( ! objRDMasterBlaster.isEmpty()) {
        objResult.dblRetValue = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
        System.debug('Ard: ' +string.valueof(objResult.dblRetValue));
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'RDDiscSizingCapacity:RDMasterBlaster: No Data Found';
    return objResult;
    }
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:RDMasterBlaster()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }

    // This method returns Size for ASME GAS.
    public static Result ASMEGASSize(double W, double P,double T,double smallk,
        double M, double Z){
            // This object is used to convey back the results of various operations we will end up doing here.
            Result objResult = new Result();
            try{
                double K=0.0;
                objResult = ASMEGASCommon(P,smallk);
                if(objResult.bResult != True)
                    return objResult;
                else
                    K = objResult.dblRetValue;

                // ASME GAS Size variables
                double  C = 0.0;
                // calculate C which is used later
                C = 520* MATH.sqrt(smallk * (MATH.pow(2/(smallk+1), ((smallk+1)/(smallk-1)) ) ));
                System.debug('C :' + string.valueof(C));
                // Finally calculate the size
                objResult.dblRetValue = W/ (C*K*P) * MATH.sqrt(T*Z/M);
                System.debug('ASMEGASSize : ' + string.valueof(objResult.dblRetValue));
                // Round the result to 6 decimals
                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                System.debug('ASMEGASSize :Rounded ' + string.valueof(objResult.dblRetValue));
            }
            catch(Exception e){
                System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEGASSize()' + e.getMessage());
                objResult.bResult = false;
                objResult.strErrorMessage = e.getMessage();
            }
            objResult.bResult = true;
            return objResult;
        }

    // This method returns Capacity for ASME GAS.
    public static Result ASMEGASCapacity(double P,double T,double smallk,
            double M, double Z,integer nSize, String strPTC, String strSeat,double Ard){
                // This object is used to convey back the results of various operations we will end up doing here.
                Result objResult = new Result();
                try{
                    // This is a lookup from table "DiscCoef"
                    double K,C = 0.0;
                    //CO10 Ard=0.0
                    objResult = ASMEGASCommon(P,smallk);
                    if(objResult.bResult != True)
                        return objResult;
                    else
                        K = objResult.dblRetValue;

                    // calculate C which is used later
                    C = 520* MATH.sqrt(smallk * (MATH.pow(2/(smallk+1), ((smallk+1)/(smallk-1)) ) ));
                    System.debug('C :' + string.valueof(C));

                    // Get value of Ard from table "RDMasterBlaster"
                    //CO10************************************************************************
                    // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                    // if(objResult.bResult != True)
                    //     return objResult;
                    // else
                    //     Ard = objResult.dblRetValue;
                    //###########################################################################
                    // Calculate Capacity
                    objResult.dblRetValue = C* K *Ard* P * (Math.sqrt(M/(Z*T)));
                    System.debug('ASMEGASCapacity: ' +string.valueof(objResult.dblRetValue));
                    // Round the result to 6 decimals
                    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                    System.debug('ASMEGASCapacity:Rounded ' +string.valueof(objResult.dblRetValue));
                }
                catch(Exception e){
                    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEGASCapacity()' + e.getMessage());
                    objResult.bResult = false;
                    objResult.strErrorMessage = e.getMessage();
                }
                return objResult;
            }

    public static Result ASMEGASCommon( double P,double smallk){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try{
    // Valid value check
    // Only valid for CRITICAL FLOW  as per the equation
    double P1= P;
    double P2= 14.6959; //Atmospheric Pressure (14.6959 psia)
    if((P2/P1) > MATH.pow( (2/(smallk+1)),(smallk/(smallk-1) ))) {
    objResult.bResult = false;
    objResult.strErrorMessage = 'This is not a CRITICAL FLOW for ASME GAS';
    System.debug('ASMEGASSize:' + objResult.strErrorMessage);
    return objResult;
    }
    // Get value of K from table "DiscCoef"
    List<DiscCoef__c> objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE (Evaluation__c='ASME Gas' ) ];

    // Make sure we got response
    if ( ! objDiscCoef.isEmpty()) {
    objResult.dblRetValue = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'ASMEGASCommon: No Data Found';
    return objResult;
    }
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEAIRCapacity()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }


    // This method returns Size for ASMEWater. No common method for this there is not much common
    public static Result ASMEWaterSize(double W, double P, double Pd, double smallw){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try{
    // This is a lookup from table "DiscCoef"
    double K =0.0;

    // Get value of K from table "DiscCoef"
    List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE (Evaluation__c='ASME Water' ) LIMIT 1];
    // Make sure we got response
    if ( ! objDiscCoef.isEmpty()) {
    K = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    // ASME Water Size formula
    objResult.dblRetValue = W/ (2407 * K * (MATH.sqrt((P-Pd)*smallw))) ;
    System.debug('ASMEWaterSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    System.debug('ASMEWaterSize :Rounded ' + string.valueof(objResult.dblRetValue));
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'No Data Found';
    }
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEWaterSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }

    // This method returns Capacity for ASMEWater
    public	static  Result ASMEWaterCapacity(double P, double Pd, double smallw,
                integer nSize, String strPTC, String strSeat,double Ard){
                    // This object is used to convey back the results of various operations we will end up doing here.
                    Result objResult = new Result();
                    try{
                        // This is a lookup from table "DiscCoef"
                        double K;

                        // Get value of K from table "DiscCoef"
                        List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                        FROM DiscCoef__c WHERE (Evaluation__c='ASME Water' ) LIMIT 1];
                        // Make sure we got response
                        if ( ! objDiscCoef.isEmpty()) {
                            K = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                        }
                        else{
                            objResult.bResult = false;
                            objResult.strErrorMessage = 'No Data Found';
                            return objResult;
                        }

                        // Get value of Ard from table "RDMasterBlaster"
                        // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                        // if(objResult.bResult != True)
                        //     return objResult;
                        // else
                        //     Ard = objResult.dblRetValue;

                        objResult.dblRetValue = 2407* K *Ard * (Math.sqrt((P-Pd)*smallw));
                        System.debug('ASMEWaterCapacity: ' +string.valueof(objResult.dblRetValue));
                        // Round the result to 6 decimals
                        objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                        System.debug('ASMEWaterCapacity:Rounded ' +string.valueof(objResult.dblRetValue));
                    }
                    catch(Exception e){
                        System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMEWaterCapacity()' + e.getMessage());
                        objResult.bResult = false;
                        objResult.strErrorMessage = e.getMessage();
                    }
                    return objResult;
                }


    // This method returns Size for ASMESteam
    public static Result ASMESteamSize(double W, double P){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try{
    // This is a lookup from table "DiscCoef"
    double K = 0.0, dblCorrectionFactor = 0.0;

    objResult = ASMESteamCommon(P);
    if(objResult.bResult != True)
    return objResult;
    else
    K = objResult.dblRetValue;

    // Calculate correction factor
    dblCorrectionFactor = ((0.1906 * P) - 1000) / ( (0.2292 *P) - 1061 ) ;
    System.debug('Correction factor' + string.valueof(dblCorrectionFactor));

    // ASME Steam Size formula
    // Correction factor must be applied only if it is greater than 1
    if(dblCorrectionFactor > 1){
    objResult.dblRetValue = W/ (51.5 *K * P * dblCorrectionFactor) ;
    }
    else{
    objResult.dblRetValue = W/ (51.5 *K * P);
    }
    System.debug('ASMESteamSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    System.debug('ASMESteamSize :Rounded ' + string.valueof(objResult.dblRetValue));

    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMESteamSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }


    // This method returns Capacity for ASMESteam
    public static Result ASMESteamCapacity( double P,integer nSize, String strPTC, String strSeat,double Ard){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
    // This is a lookup from table "DiscCoef"  Ard=0.0
    double K = 0.0, dblCorrectionFactor = 0.0 ;
    objResult = ASMESteamCommon(P);
    if(objResult.bResult != True)
    return objResult;
    else
    K = objResult.dblRetValue;

    // Calculate correction factor
    dblCorrectionFactor = ((0.1906 * P) - 1000) / ( (0.2292 *P) - 1061 ) ;
    System.debug('Correction factor' + string.valueof(dblCorrectionFactor));

    // Get value of Ard from table "RDMasterBlaster"
    //CO10************************************************************************
    // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
    // if(objResult.bResult != True)
    // return objResult;
    // else
    // Ard = objResult.dblRetValue;
    //###########################################################################
    // Calculate Capacity
    // ASME Steam Capacity formula
    // Correction factor must be applied only if it is greater than 1
    if(dblCorrectionFactor > 1){
    objResult.dblRetValue = 51.5 *K * Ard * P * dblCorrectionFactor ;
    }
    else{
    objResult.dblRetValue = 51.5 *K * Ard * P;
    }
    System.debug('ASMESteamCapacity : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    System.debug('ASMESteamCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMESteamCapacity()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }
    public static Result ASMESteamCommon(double P){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
    // Valid value check
    // P must not be greater than 3200 psia and must be greater than 27.02
    if(P>3200){
    objResult.bResult = false;
    objResult.strErrorMessage = 'Value of P is greater that 3200 psia, which is not allowed for ASME Steam';
    return objResult;
    }
    if(P<27.02){
    objResult.bResult = false;
    objResult.strErrorMessage = 'Value of P is less that 27.02 psia, which is not allowed for ASME Steam';
    return objResult;
    }
    // Get value of K from table "DiscCoef"
    List<DiscCoef__c> objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE (Evaluation__c='ASME Steam' ) ];

    // Make sure we got response
    if ( ! objDiscCoef.isEmpty()) {
    objResult.dblRetValue = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'ASMESteamCommon: No Data Found';
    return objResult;
    }
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ASMESteamCommon()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }


    // This method returns Size for API GAS.
    public static Result APIGASSize(double W, double P1,double P2,double K, double T,
    double M, double Z){
        // This object is used to convey back the results of various operations we will end up doing here.
        Result objResult = new Result();

        try{
            // This is a lookup from table "DiscCoef"
            double Kd=0.0;
            String strCriticalFlow='';

            objResult = APIGASCommon(P1,P2,K);
            if(objResult.bResult != True)
                return objResult;
            else{
                Kd = objResult.dblRetValue;
                strCriticalFlow = objResult.strRetValue;
            }

            // API GAS Size formula
            double F2 = 0.0, C = 0.0;
            // Subcritical flow
            If(strCriticalFlow == 'SUBCRITICAL FLOW'){
                //      TBD Need to use ROUND functionality from the common rounding module
                double dVal = 0.0;
                dVal = ( 1- MATH.pow((P2/P1),((K-1)/K) )) /(1- (P2/P1)  ) ;
                System.debug('dVal : ' + string.valueof(dVal));
                F2 =   MATH.sqrt( (K/(K-1)) * MATH.pow(  (P2/P1), (2/K) )  * dVal  );
                System.debug('F2 : ' + string.valueof(F2));
                // Round the result to 6 decimals
                F2 = unitConversions.RoundNormal(F2, 6) ;
                System.debug('F2 :Rounded ' + string.valueof(F2));
                // Finally calculate the size
                objResult.dblRetValue = W/ (735*F2*Kd) * (MATH.sqrt(Z*T/ (M*P1*(P1-P2)) ));
            }
            // Critical flow
            If(strCriticalFlow == 'CRITICAL FLOW'){
                //      TBD Need to use ROUND functionality from the common rounding module
                C = 520* MATH.sqrt(K* MATH.pow(2/(K+1), ((K+1)/(K-1)) ));
                System.debug('C : ' + string.valueof(C));
                // Round the result to 6 decimals
                C = unitConversions.RoundNormal(C, 6) ;
                System.debug('C :Rounded ' + string.valueof(C));
                // Finally calculate the size
                objResult.dblRetValue = W/ (C*Kd*P1) * MATH.sqrt(T*Z/M);
            }
            System.debug('APIGASSize : ' + string.valueof(objResult.dblRetValue));
            // Round the result to 6 decimals
            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
            System.debug('Flow Type: ' +strCriticalFlow);
            System.debug('APIGASSize :Rounded ' + string.valueof(objResult.dblRetValue));
        }
        catch(Exception e){
            System.debug('The following exception has occurred: RDDiscSizingCapacity:APIGASSize()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        objResult.bResult = true;
        return objResult;
    }

    public static Result APIGASCommon(double P1,double P2,double K){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
    // First check if its subcritical flow or critical flow
    double dblCal =0.0; String strCriticalFlow='';
    dblCal = Math.pow((2/(K+1)),(K/(K-1)));

    if( (P2/P1) > dblCal){
    strCriticalFlow='SUBCRITICAL FLOW';
    }
    else{
    strCriticalFlow='CRITICAL FLOW';
    }

    // Get value of K from table "DiscCoef"
    List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE Evaluation__c='API Gas'  LIMIT 1];

    // Make sure we got response
    if ( ! objDiscCoef.isEmpty()) {
    objResult.dblRetValue = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'APIGASCommon: No Data Found';
    return objResult;
    }
    // flow related information
    objResult.strRetValue = strCriticalFlow;

    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:APIGASCommon()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }

    // This method returns Caapacity for API GAS.
    public static Result APIGASCapacity(double P1,double P2,double K, double T,
        double M, double Z,integer nSize, String strPTC, String strSeat,double Ard){
            // This object is used to convey back the results of various operations we will end up doing here.
            Result objResult = new Result();

            try{
                // This is a lookup from table "DiscCoef" ,Ard=0.0
                double Kd ;
                String strCriticalFlow='';

                objResult = APIGASCommon(P1,P2,K);
                if(objResult.bResult != True)
                    return objResult;
                else{
                    Kd = objResult.dblRetValue;
                    strCriticalFlow = objResult.strRetValue;
                }

                // Get value of Ard from table "RDMasterBlaster"
                //CO10************************************************************************
                // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                // if(objResult.bResult != True)
                //     return objResult;
                // else
                //     Ard = objResult.dblRetValue;
                //###########################################################################
                double F2 = 0.0, C = 0.0;
                // Subcritical flow
                If(strCriticalFlow == 'SUBCRITICAL FLOW'){
                    double dVal = 0.0;
                    dVal = ( 1- MATH.pow((P2/P1),((K-1)/K) )) /(1- (P2/P1)  ) ;
                    System.debug('dVal : ' + string.valueof(dVal));
                    F2 =   MATH.sqrt( (K/(K-1)) * MATH.pow(  (P2/P1), (2/K) )  * dVal  );
                    System.debug('F2 : ' + string.valueof(F2));
                    // Round the result to 6 decimals
                    F2 = unitConversions.RoundNormal(F2, 6) ;
                    System.debug('F2 :Rounded ' + string.valueof(F2));
                    // Finally calculate the capacity
                    objResult.dblRetValue = (735 * Ard * F2 * Kd )* (math.sqrt((M*P1*(P1-P2))/ (Z*T)))  ;
                }

                // Critical flow
                If(strCriticalFlow == 'CRITICAL FLOW'){
                    //      TBD Need to use ROUND functionality from the common rounding module
                    C = 520* MATH.sqrt(K* MATH.pow(2/(K+1), ((K+1)/(K-1)) ));
                    System.debug('C : ' + string.valueof(C));
                    // Round the result to 6 decimals
                    C = unitConversions.RoundNormal(C, 6) ;
                    System.debug('C :Rounded ' + string.valueof(C));
                    // Finally calculate the capacity
                    objResult.dblRetValue = Ard * C * Kd * P1 * (math.sqrt(M/(T*Z)));
                }
                System.debug('APIGASCapacity : ' + string.valueof(objResult.dblRetValue));
                // Round the result to 6 decimals
                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                System.debug('Flow Type: ' +strCriticalFlow);
                System.debug('APIGASCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
            }
            catch(Exception e){
                System.debug('The following exception has occurred: RDDiscSizingCapacity:APIGASCapacity()' + e.getMessage());
                objResult.bResult = false;
                objResult.strErrorMessage = e.getMessage();
            }
            objResult.bResult = true;
            return objResult;
        }


    // This method returns Size for APILiquid
    public static Result APILiquidSize(double Q, double P1, double G,
        double U, double P2){
            // This object is used to convey back the results of various operations we will end up doing here.
            Result objResult = new Result();

            try{
                // This is a lookup from table "DiscCoef"
                double Kd = 0.0, Kv=0.0;

                // Get value of K from table "DiscCoef"
                List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                    FROM DiscCoef__c WHERE (Evaluation__c='API Liquid' ) LIMIT 1];
                System.debug('Q'+Q);
                System.debug('P1'+P1);
                System.debug('G'+G);
                System.debug('U'+U);
                System.debug('P2'+P2);
                // Make sure we got response
                if ( ! objDiscCoef.isEmpty()) {
                    Kd = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);

                    // Use iterative method to calculate Kv how many times do we iterate ??
                    // We will iterate until ABS(Ai - Ai-1 )< .0001 for the areas.
                    // Rv affects A and then A affects Rv hence that iteration.
                    // Calculate A with Kv as 1 and then move ahead from there on iteration.
                    Kv  =1;

                    double A = 0.0, PrevA =0.0; boolean bLoop = true;
                    integer i=1;
                    // This loop assumes value of A increases always through loops.
                    while(bLoop){
                        // calculate A for size
                        A = (Q/ (38*Kd*Kv)) * (MATH.sqrt(G/(P1-P2)) ) ;
                        //System.debug('A It: ' + string.valueof(i) + ' :' +string.valueof(A));

                        // calculate R for size
                        double R = (Q*2800*G) / (U * MATH.sqrt(A));
                        //System.debug('R It: ' + string.valueof(i) + ' :' +string.valueof(R));

                        // Calculate Kv
                        double dblVar1 = 0.5, dblVar2 = 1.5;
                        double dblVar3 = 0.9935 + (2.878/ MATH.pow(R, dblVar1)) + (342.75 / MATH.pow(R, dblVar2));
                        double dblVal4 = -1.0;
                        Kv = math.pow(dblVar3, dblVal4) ;

                        System.debug('APILiquidSize It: ' + string.valueof(i) + ' :' +string.valueof(A));
                        if(i==1 && (Kv>1 && R>33)){
                            bLoop=false;
                        }
                        i=i+1; // Used only for debug info
                        // Check and terminate loop if it matches condition
                        if((A-PrevA) <0.0001 && R>33)
                            bLoop=false;
                        // Used in next loop to check if we have "looped" enough
                        PrevA = A;
                        if(i>=25) {
                            bLoop=false;
                            PrevA=0;
                        }
                    }
                    if(PrevA==0) {
                        objResult.bResult = false;
                        objResult.strErrorMessage = 'R (Renolds number) has to be greater than 33';
                    } else {
                        // APi Liquid Size formula
                        objResult.dblRetValue = PrevA ;
                        System.debug('APILiquidSize : ' +string.valueof(objResult.dblRetValue));
                        objResult.bResult = true;
                        // Round the result to 6 decimals
                        objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                        System.debug('APILiquidSize Rounded: ' +string.valueof(objResult.dblRetValue));
                    }
                }
                else{
                    objResult.bResult = false;
                    objResult.strErrorMessage = 'No Data Found';
                }

            }
            catch(Exception e){
                System.debug('The following exception has occurred: RDDiscSizingCapacity:APILiquidSize()' + e.getMessage());
                objResult.bResult = false;
                objResult.strErrorMessage = e.getMessage();
            }

            return objResult;
        }


    // This method returns Capacity for APILiquid
    public static Result APILiquidCapacity( double P1, double G,
            double U, double P2,integer nSize, String strPTC, String strSeat,double Ard){
                // This object is used to convey back the results of various operations we will end up doing here.
                Result objResult = new Result();

                try{
                    // This is a lookup from table "DiscCoef",Ard=0.0
                    double Kd = 0.0, Kv=0.0, Qrd=0.0;

                    // Get value of Ard from table "RDMasterBlaster"
                    //CO10************************************************************************
                    // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                    // if(objResult.bResult != True)
                    //     return objResult;
                    // else
                    //     Ard = objResult.dblRetValue;
                    //###########################################################################
                    //result resDistance=unitConversions.convertArea('in2','mm2',Ard);
                    // Ard=resDistance.dblRetValue;
                    // Get value of K from table "DiscCoef"
                    List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                        FROM DiscCoef__c WHERE (Evaluation__c='API Liquid' ) LIMIT 1];

                    // Make sure we got response
                    if ( ! objDiscCoef.isEmpty()) {
                        Kd = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);

                        // use iterative method to calculate Kv how many times do we iterate ??
                        // For the capacities we will iterate until ABS(Qi - Qi-1)< .0001
                        // Rv affects A and then A affects Rv hence that iteration.
                        // Calculate A with Kv as 1 and then move ahead from there on iteration.
                        Kv  =1;
                        double  PrevQrd =100000.0; boolean bLoop = true;
                        integer i=1;
                        // This loop assumes value of Qrd decreases always.
                        while(bLoop){
                            // calculate A for size
                            Qrd = (38 * Ard * Kd * Kv )* math.sqrt((P1-P2)/G);

                            // calculate R for size
                            double R = (Qrd*2800*G) / (U * MATH.sqrt(Ard));

                            // Calculate Kv
                            double dblVar1 = 0.5, dblVar2 = 1.5;
                            double dblVar3 = 0.9935 + (2.878/ MATH.pow(R, dblVar1)) + (342.75 / MATH.pow(R, dblVar2));
                            double dblVal4 = -1.0;
                            Kv = math.pow(dblVar3, dblVal4) ;
                            System.debug('Qrd It: ' + string.valueof(i) + ' :' +string.valueof(Qrd));
                            if(i==1 && (Kv>1 && R>33)){
                                bLoop=false;
                            }
                            i=i+1; // Used only for debug info
                            // Check and terminate loop if it matches condition
                            if((PrevQrd-Qrd) <0.0001 && R>33)
                                bLoop=false;
                            // Used in next loop to check if we have "looped" enough
                            PrevQrd = Qrd;
                            if(i>=25) {
                                bLoop=false;
                                Qrd=0;
                            }
                        }
                        if(Qrd==0) {
                            objResult.bResult = false;
                            objResult.strErrorMessage = 'R (Renolds number) has to be greater than 33';
                        } else {
                            objResult.dblRetValue = Qrd ;
                            objResult.bResult = true;
                            System.debug('APILiquidCapacity : ' +string.valueof(objResult.dblRetValue));
                            // Round the result to 6 decimals
                            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                            System.debug('APILiquidCapacity Rounded: ' +string.valueof(objResult.dblRetValue));
                        }
                    }
                    else{
                        objResult.bResult = false;
                        objResult.strErrorMessage = 'No Data Found';
                    }

                }
                catch(Exception e){
                    System.debug('The following exception has occurred: RDDiscSizingCapacity:APILiquidCapacity()' + e.getMessage());
                    objResult.bResult = false;
                    objResult.strErrorMessage = e.getMessage();
                }
                return objResult;
            }

    // This method returns Size for ISOLiquid
    public static Result ISOLiquidSize(double Qm, double Po, double Vo,
        double Uo, double Pb){
            // This object is used to convey back the results of various operations we will end up doing here.
            Result objResult = new Result();
            system.debug('Qm'+ Qm);
            system.debug('Po'+ Po);
            system.debug('Vo'+ Vo);
            system.debug('Uo'+ Uo);
            system.debug('Pb'+ Pb);
            try{
                // This is a lookup from table "DiscCoef"
                double Alpha = 0.0, Kv=0.0;

                // Get value of K from table "DiscCoef"
                List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                    FROM DiscCoef__c WHERE (Evaluation__c='ISO Liquid' ) LIMIT 1];
                //System.debug('Q'+Q);
                //System.debug('P1'+P1);
                //System.debug('G'+G);
                //System.debug('U'+U);
                //System.debug('P2'+P2);
                // Make sure we got response
                if ( ! objDiscCoef.isEmpty()) {
                    Alpha = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);

                    // Use iterative method to calculate Kv how many times do we iterate ??
                    // We will iterate until ABS(Ai - Ai-1 )< .0001 for the areas.
                    // Kv affects A and then A affects Kv hence that iteration.
                    // Calculate A with Kv as 1 and then move ahead from there on iteration.
                    Kv  =1;

                    double A = 0.0, R=0.0, PrevA =0.0; boolean bLoop = true;
                    integer i=1;
                    // This loop assumes value of A increases always through loops.
                    while(bLoop){
                        // calculate A for size
                        A = 0.621*(Qm/(Kv*Alpha* MATH.sqrt(1/Vo*(Po-Pb)))) ;
                        System.debug('A It: ' + string.valueof(i) + ' :' +string.valueof(A));

                        // calculate R for size
                        R = Qm / (3.6 * Uo ) * MATH.sqrt (4/MATH.PI * A);
                        System.debug('R It: ' + string.valueof(i) + ' :' +string.valueof(R));

                        // Calculate Kv
                        double dblVar1 = 0.5, dblVar2 = 1.5;
                        double dblVar3 = 0.9935 + (2.878/ MATH.pow(R, dblVar1)) + (342.75 / MATH.pow(R, dblVar2));
                        double dblVal4 = -1.0;
                        Kv = math.pow(dblVar3, dblVal4) ;

                        System.debug('ISOLiquidSize It: ' + string.valueof(i) + ' :' +string.valueof(A));
                        System.debug('ISOLiquidSize Kv: ' + Kv);
                        if(i==1 && (Kv>1 && R>33)){
                            bLoop=false;
                            System.debug('ISOLiquidSize Kv  INSIDE: ' + Kv);
                        }
                        i=i+1; // Used only for debug info
                        // Check and terminate loop if it matches condition
                        decimal tempA=A;
                        decimal tempV=A-PrevA;
                        System.debug('ISOLiquidSize Kv  A: ' +A );
                        System.debug('ISOLiquidSize Kv  tempAA: ' +tempA );
                        System.debug('ISOLiquidSize Kv  A-PrevA: ' +tempV );
                        if((tempA-PrevA) <0.0001 && R>33)
                            bLoop=false;
                        // Used in next loop to check if we have "looped" enough
                        PrevA = tempA;
                        if(i>=25) {
                            bLoop=false;
                            PrevA=0;
                        }

                    }
                    if(PrevA==0) {
                        objResult.bResult = false;
                        objResult.strErrorMessage = 'R (Renolds number) has to be greater than 33';
                    } else {
                        // ISO Liquid Size formula
                        objResult.dblRetValue = PrevA ;
                        objResult.bResult = true;
                        System.debug('ISOLiquidSize : ' +string.valueof(objResult.dblRetValue));
                        // Round the result to 6 decimals
                        objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                        System.debug('ISOLiquidSize Rounded: ' +string.valueof(objResult.dblRetValue));
                    }
                }
                else{
                    objResult.bResult = false;
                    objResult.strErrorMessage = 'No Data Found';
                }

            }
            catch(Exception e){
                System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOLiquidSize()' + e.getMessage());
                objResult.bResult = false;
                objResult.strErrorMessage = e.getMessage();
            }
            return objResult;
        }

    // This method returns Capacity for ISOLiquid
    public static Result ISOLiquidCapacity( double Po, double Vo,
            double Uo, double Pb,integer nSize, String strPTC, String strSeat,double Ard){
                // This object is used to convey back the results of various operations we will end up doing here.
                Result objResult = new Result();
                System.debug('Po: ' + Po);
                System.debug('Vo: ' + Vo);
                System.debug('Uo: ' + Uo);
                System.debug('Pb: ' + Pb);

                try{
                    // This is a lookup from table "DiscCoef",Ard=0.0
                    double Alpha = 0.0, Kv=0.0, Qrd=0.0;

                    // Get value of Ard from table "RDMasterBlaster"
                    //CO10************************************************************************
                    // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                    // if(objResult.bResult != True)
                    //     return objResult;
                    // else
                    //     Ard = objResult.dblRetValue;
                    //###########################################################################
                    result resDistance=unitConversions.convertArea('in2','mm2',Ard);
                    result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                    Ard=resDistance1.dblRetValue;
                    system.debug('Ard'+Ard);
                    // Get value of K from table "DiscCoef"
                    List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                        FROM DiscCoef__c WHERE (Evaluation__c='ISO Liquid' ) LIMIT 1];

                    // Make sure we got response
                    if ( ! objDiscCoef.isEmpty()) {
                        Alpha = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);

                        // use iterative method to calculate Kv how many times do we iterate ??
                        // For the capacities we will iterate until ABS(Qi - Qi-1)< .0001
                        // Rv affects A and then A affects Rv hence that iteration.
                        // Calculate A with Kv as 1 and then move ahead from there on iteration.
                        Kv  =1;
                        double  PrevQrd =100000.0; boolean bLoop = true;
                        integer i=1;
                        // This loop assumes value of Qrd decreases always.
                        while(bLoop){
                            // calculate A for size
                            Qrd = 1.61*Ard*Kv*Alpha*(MATH.sqrt(1/Vo*(Po-Pb)));

                            // calculate R for size
                            double R =Qrd/(3.6*Uo)* Math.sqrt(4/Math.PI*Ard);

                            // Calculate Kv
                            double dblVar1 = 0.5, dblVar2 = 1.5;
                            double dblVar3 = 0.9935 + (2.878/ MATH.pow(R, dblVar1)) + (342.75 / MATH.pow(R, dblVar2));
                            double dblVal4 = -1.0;
                            Kv = math.pow(dblVar3, dblVal4) ;
                            System.debug('Qrd It: ' + string.valueof(i) + ' :' +string.valueof(Qrd));
                            if(i==1 && (Kv>1 && R>33)){
                                bLoop=false;
                            }
                            i=i+1; // Used only for debug info
                            // Check and terminate loop if it matches condition
                            if((PrevQrd-Qrd) <0.0001  && R>33)
                                bLoop=false;
                            // Used in next loop to check if we have "looped" enough
                            PrevQrd = Qrd;
                            if(i>=25) {
                                bLoop=false;
                                Qrd=0;
                            }
                        }
                        if(Qrd==0) {
                            objResult.bResult = false;
                            objResult.strErrorMessage = 'R (Renolds number) has to be greater than 33';
                        } else {
                            objResult.dblRetValue = Qrd ;
                            objResult.bResult = true;
                            System.debug('ISOLiquidCapacity : ' +string.valueof(objResult.dblRetValue));
                            // Round the result to 6 decimals
                            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                            System.debug('ISOLiquidCapacity Rounded: ' +string.valueof(objResult.dblRetValue));
                        }
                    }
                    else{
                        objResult.bResult = false;
                        objResult.strErrorMessage = 'No Data Found';
                    }

                }
                catch(Exception e){
                    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOLiquidCapacity()' + e.getMessage());
                    objResult.bResult = false;
                    objResult.strErrorMessage = e.getMessage();
                }

                return objResult;
            }

    // This method returns Size for APISteam
    public static Result APISteamSize(double W, double P1, double T){
    // This object is used to convey back the results of various operations we will end up doing here.
        Result objResult = new Result();

        try{
        // This is a lookup from table "DiscCoef"
            double Kd=0.0, Kn=0.0, Ks=0.0;
            system.debug('API Steam W'+W);
            system.debug('API Steam P1'+P1);
            system.debug('API Steam T'+T);
            objResult = APISteamCommon(P1);
            if(objResult.bResult != True)
                return objResult;
            else{
                Kd = objResult.dblRetValue;
                // Primitive types cant be passed by reference, hence using result class string to get Kn value
                Kn = double.valueof(objResult.strRetValue);
            }
            System.debug('Kd : ' + Kd);
            System.debug('Kn : ' + Kn);

            // Get Steam Interpolation done and get ks
            result resultConvertPressure=unitConversions.convertPressure('psia','psig',P1);
            Double dP1=P1;
            if(resultConvertPressure.bResult)
                dP1=resultConvertPressure.dblRetValue;
                objResult = SteamInterpolationAPIDryKs(dP1,T);
            if(objResult.bResult != True)
                return objResult;
            else{
                Ks = objResult.dblRetValue;
            }

            System.debug('Ks : ' + Ks);
            // Calculate size
            objResult.dblRetValue = W / (51.5 * P1 * Kd * Kn * Ks);
            System.debug('APISteamSize : ' + objResult.dblRetValue);
            objResult.bResult=true;
            // Round the result to 6 decimals
            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
            System.debug('Converted APISteamSize : ' +string.valueof(objResult.dblRetValue));
        }
        catch(Exception e){
            System.debug('The following exception has occurred: RDDiscSizingCapacity:APISteamSize()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        return objResult;
    }

    // This returns Kd and Kn used by both size and capacity functions
    public static Result APISteamCommon(double P1){
    // This object is used to convey back the results of various operations we will end up doing here.
        Result objResult = new Result();

        try{
            double Kn = 0.0;

            // Valid value check
            // P must not be greater than 3200 psia and must be greater than 27.02
            if(P1>3200){
                objResult.bResult = false;
                objResult.strErrorMessage = 'Value of P is greater that 3200 psia, which is not allowed for ASME Steam';
                return objResult;
            }
            if(P1<27.02){
                objResult.bResult = false;
                objResult.strErrorMessage = 'Value of P is less that 27.02 psia, which is not allowed for ASME Steam';
                return objResult;
            }
            // Get value of K from table "DiscCoef"
            List<DiscCoef__c> objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                        FROM DiscCoef__c WHERE (Evaluation__c='API Steam' ) ];

            // Make sure we got response
            if ( ! objDiscCoef.isEmpty()) {
                objResult.dblRetValue = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
            }
            else{
                objResult.bResult = false;
                objResult.strErrorMessage = 'APISteamCommon: No Data Found';
                return objResult;
            }

            // Calculate Kn
            if(P1<= 1500) {
                Kn=1;
            }
            else{
                Kn = ((0.1906*P1)-1000) / ((0.2292*P1)-1061);
            }
            // Primitive types cant be passed by reference, hence using result class string to return Ks value
            objResult.strRetValue = string.valueof(Kn);

        }
        catch(Exception e){
            System.debug('The following exception has occurred: RDDiscSizingCapacity:APISteamCommon()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        objResult.bResult = true;
        return objResult;
    }

    // This method does Steam Interpolation.
    // Purpose is to return Ks
    // Imp: Perhaps we could use just one method for interpolation. However Salesforce type casting is
    // not as strong as C++
    public static Result SteamInterpolationAPIDryKs( double P1,double T){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
        double  NextLowerPres=0.0, NextHigherPres=0.0,  SatTempAtNextLowerPres=0.0,  SatTempAtNextHigherPres=0.0,
        SatKsAtNextLowerPres=0.0,   SatKsAtNextHigherPres=0.0,  SatTempAtRelievingPressure=0.0,   SatKsAtRelievingPressure=0.0;

        double UpperRightPres=0.0, UpperRightTemp=0.0, UpperRightKs=0.0, LowerRightPres=0.0, LowerRightTemp=0.0,
        LowerRightKs=0.0, UpperLeftTemp=0.0,UpperLeftKs=0.0, LowerLeftTemp=0.0,
        LowerLeftKs=0.0, RightSideKs=0.0, LeftSideKs=0.0, Ks=0.0;


        List<APIDryKs__c>  objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
                    FROM APIDryKs__c WHERE (Pressure__c=:P1 And Temprature__c=:T ) ];


        // Found exact match
        if ( ! objAPIDryKs.isEmpty()) {
        objResult.bResult = true;
        Ks =objAPIDryKs.get(0).Ks__c;
        objResult.dblRetValue=Ks;
        }
        else{
        // All logic below in this else block fires queries in various stages to get a block of records.
        // Then as per the excel rules, it gets the right values used for interpolation

        objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        FROM APIDryKs__c WHERE Pressure__c <= :P1 and SteamCond__c Like 'Sat%' ORDER BY Pressure__c DESC, Temprature__c ASC ];
        System.debug('Records Found : ' + objAPIDryKs.size());
        if ( ! objAPIDryKs.isEmpty()) {
        // Get the NextLowerPres
        NextLowerPres = objAPIDryKs.get(0).Pressure__c;
        //Get SatTempAtNextLowerPres
        SatTempAtNextLowerPres = objAPIDryKs.get(0).Temprature__c;
        // Get SatKsAtNextLowerPres
        SatKsAtNextLowerPres =  objAPIDryKs.get(0).Ks__c;
        system.debug('API Steam Intial Value for NextLowerPres'+NextLowerPres);
        system.debug('API Steam Intial Value for SatTempAtNextLowerPres'+SatTempAtNextLowerPres);
        system.debug('API Steam Intial Value for SatKsAtNextLowerPres'+SatKsAtNextLowerPres);

        }
        else{
        objResult.bResult = false;
        return objResult;
        }

        objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        FROM APIDryKs__c WHERE Pressure__c > :P1 and SteamCond__c Like 'Sat%' ORDER BY Pressure__c ASC, Temprature__c ASC ];
        System.debug('Records Found 2 : ' + objAPIDryKs.size());
        if ( ! objAPIDryKs.isEmpty()) {
        // Get the NextHigherPres
        NextHigherPres = objAPIDryKs.get(0).Pressure__c;
        //Get SatTempAtNextHigherPres
        SatTempAtNextHigherPres = objAPIDryKs.get(0).Temprature__c;
        // Get SatKsAtNextHigherPres
        SatKsAtNextHigherPres =  objAPIDryKs.get(0).Ks__c;

        SatTempAtRelievingPressure =(P1-NextLowerPres)/(NextHigherPres-NextLowerPres)*(SatTempAtNextHigherPres-SatTempAtNextLowerPres)+SatTempAtNextLowerPres;
        SatKsAtRelievingPressure = (P1-NextLowerPres)/(NextHigherPres-NextLowerPres)*(SatKsAtNextHigherPres-SatKsAtNextLowerPres)+SatKsAtNextLowerPres;

        system.debug('API Steam Intial Value for NextHigherPres'+NextLowerPres);
        system.debug('API Steam Intial Value for SatTempAtNextHigherPres'+SatTempAtNextHigherPres);
        system.debug('API Steam Intial Value for SatKsAtNextHigherPres'+SatKsAtNextHigherPres);
        }
        else{
        objResult.bResult = false;
        return objResult;
        }

        UpperRightPres = NextLowerPres;
        LowerRightPres = NextHigherPres;
        system.debug('API Steam Intial Value for UpperRightPres'+UpperRightPres);
        system.debug('API Steam Intial Value for LowerRightPres'+LowerRightPres);
        //system.debug('API Steam Intial Value for SatKsAtNextHigherPres'+SatKsAtNextHigherPres);
        objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        FROM APIDryKs__c WHERE Pressure__c = :UpperRightPres AND Temprature__c > :T and SteamCond__c Like 'SH%'
        ORDER BY Temprature__c ASC ];
        System.debug('Records Found 3: ' + objAPIDryKs.size());
        System.debug('UpperRightPres 3: ' + UpperRightPres);
        System.debug('T 3: ' + T);
        if ( ! objAPIDryKs.isEmpty()) {
        // Get UpperRightTemp
        UpperRightTemp = objAPIDryKs.get(0).Temprature__c;
        // get UpperRightKs
        UpperRightKs = objAPIDryKs.get(0).Ks__c;
        }
        else{
        objResult.bResult = false;
        return objResult;
        }

        objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        FROM APIDryKs__c WHERE Pressure__c = :UpperRightPres AND Temprature__c <= :T and SteamCond__c Like 'SH%'
        ORDER BY Temprature__c DESC ];
        System.debug('UpperRightPres 4: ' + UpperRightPres);
        System.debug('T: ' + T);
        System.debug('Records Found 4: ' + objAPIDryKs.size());
        if ( ! objAPIDryKs.isEmpty()) {
        UpperLeftTemp =  objAPIDryKs.get(0).Temprature__c;
        UpperLeftKs = objAPIDryKs.get(0).Ks__c;
        }
        else{
        objResult.bResult = false;
        System.debug('objResult 4: ' + objResult);
        return objResult;
        }
        system.debug('API Steam Intial Value for UpperRightTemp'+UpperRightTemp);
        system.debug('API Steam Intial Value for UpperLeftTemp'+UpperLeftTemp);

        objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        FROM APIDryKs__c WHERE Pressure__c = :LowerRightPres AND Temprature__c > :T and SteamCond__c Like 'SH%'
        ORDER BY Temprature__c ASC ];
        System.debug('Records Found 5: ' + objAPIDryKs.size());
        if ( ! objAPIDryKs.isEmpty()) {
        // Get LowerRightTemp
        LowerRightTemp = objAPIDryKs.get(0).Temprature__c;
        // get LowerRightKs
        LowerRightKs = objAPIDryKs.get(0).Ks__c;
        }
        else{
        objResult.bResult = false;
        return objResult;
        }
        // system.debug('API Steam Intial Value for LowerRightTemp'+LowerRightTemp);
        // system.debug('API Steam Intial Value for UpperLeftTemp'+UpperLeftTemp);
        objAPIDryKs =  [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        FROM APIDryKs__c WHERE Pressure__c = :LowerRightPres AND Temprature__c <= :T and SteamCond__c Like 'SH%'
        ORDER BY Temprature__c DESC ];

        if ( ! objAPIDryKs.isEmpty()) {
        LowerLeftTemp = objAPIDryKs.get(0).Temprature__c;
        LowerLeftKs = objAPIDryKs.get(0).Ks__c;
        }
        else{
        objResult.bResult = false;
        return objResult;
        }
        system.debug('API Steam Intial Value for LowerRightTemp'+LowerRightTemp);
        system.debug('API Steam Intial Value for LowerLeftTemp'+LowerLeftTemp);
        System.debug('Records Found 6: ' + objAPIDryKs.size());
        RightSideKs =(P1-UpperRightPres)/(LowerRightPres-UpperRightPres)*(LowerRightKs-UpperRightKs)+UpperRightKs;
        LeftSideKs =(P1-UpperRightPres)/(LowerRightPres-UpperRightPres)*(LowerLeftKs-UpperLeftKs)+UpperLeftKs;
        Ks =(T-UpperLeftTemp)/(UpperRightTemp-UpperLeftTemp)*(RightSideKs-LeftSideKs)+LeftSideKs;

        // COMMENT OUT BUT MAINTAIN THESE DEBUG STATEMENTS
        System.debug('NextLowerPres : ' + NextLowerPres);
        System.debug('NextHigherPres : ' + NextHigherPres);
        System.debug('SatTempAtNextLowerPres : ' + SatTempAtNextLowerPres);
        System.debug('SatTempAtNextHigherPres : ' + SatTempAtNextHigherPres);
        System.debug('SatKsAtNextLowerPres : ' + SatKsAtNextHigherPres);
        System.debug('SatKsAtNextHigherPres : ' + SatKsAtNextHigherPres);
        System.debug('SatTempAtRelievingPressure : ' + SatTempAtRelievingPressure);
        System.debug('SatKsAtRelievingPressure : ' + SatKsAtRelievingPressure);

        System.debug('UpperRightPres : ' + UpperRightPres);
        System.debug('UpperRightTemp : ' + UpperRightTemp);
        System.debug('UpperRightKs : ' + UpperRightKs);

        System.debug('LowerRightPres : ' + LowerRightPres);
        System.debug('LowerRightTemp : ' + UpperRightTemp);
        System.debug('LowerRightKs : ' + LowerRightKs);

        System.debug('UpperLeftTemp : ' + UpperLeftTemp);
        System.debug('UpperLeftKs : ' + UpperLeftKs);

        System.debug('LowerLeftTemp : ' + LowerLeftTemp);
        System.debug('LowerLeftKs : ' + LowerLeftKs);

        System.debug('RightSideKs : ' + RightSideKs);
        System.debug('LeftSideKs : ' + LeftSideKs);

        // Whole logic above to get this value.
        System.debug('Ks : ' + Ks);
        objResult.dblRetValue = Ks;
        }
        }
        catch(Exception e){
        System.debug('The following exception has occurred: RDDiscSizingCapacity:APISteamCapacity()' + e.getMessage());
        objResult.bResult = false;
        objResult.strErrorMessage = e.getMessage();
        }
        objResult.bResult = true;
        return objResult;
    }
    // This method returns Capacity for APISteam
    public static Result APISteamCapacity( double P1,double T,integer nSize, String strPTC, String strSeat,double Ard){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
    double Kd = 0.0, Kn=0.0, Ks=0.0 ;
    objResult = APISteamCommon(P1);
    if(objResult.bResult != True)
    return objResult;
    else{
    Kd = objResult.dblRetValue;
    // Primitive types cant be passed by reference, hence using result class string to get Kn value
    Kn = double.valueof(objResult.strRetValue);
    }
    System.debug('Kd : ' + Kd);
    System.debug('Kn : ' + Kn);

    // Get Steam Interpolation done and get ks
    result resultConvertPressure=unitConversions.convertPressure('psia','psig',P1);
    Double dP1=P1;
    if(resultConvertPressure.bResult)
    dP1=resultConvertPressure.dblRetValue;
    objResult = SteamInterpolationAPIDryKs(dP1,T);
    //objResult = SteamInterpolationAPIDryKs(P1,T);
    if(objResult.bResult != True)
    return objResult;
    else{
    Ks = objResult.dblRetValue;
    }

    System.debug('Ks : ' + Ks);

    // Get value of Ard from table "RDMasterBlaster"
    //CO10************************************************************************
    // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
    // if(objResult.bResult != True)
    // return objResult;
    // else
    // Ard = objResult.dblRetValue;
    //###########################################################################
    // Calculate Capacity
    // API Steam Capacity formula
    objResult.dblRetValue = 51.5 * Ard * P1 * Kd * Kn * Ks;

    System.debug('APISteamCapacity : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    System.debug('APISteamCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:APISteamCapacity()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }


    // This method returns Size for ISO GAS.
    public static Result ISOGASSize(double Qm, double Po,double Pb,double To,double K, double M, double Zo,double X){
    // This object is used to convey back the results of various operations we will end up doing here.
    System.debug('Qm: ' + Qm);
    System.debug('Po: ' + Po);
    System.debug('Pb: ' + Pb);
    System.debug('To: ' + To);
    System.debug('K: ' + K);
    System.debug('M: ' + M);
    System.debug('Zo: ' + Zo);
    System.debug('X: ' + X);
    Result objResult = new Result();

    try{
    // This is a lookup from table "DiscCoef"
    //double X=0.0;
    String strCriticalFlow='';

    objResult = ISOGASCommon(Po,Pb,K);
    if(objResult.bResult != True)
    return objResult;
    else{
    //X = objResult.dblRetValue;
    strCriticalFlow = objResult.strRetValue;
    }

    // ISO GAS Size formula
    double Kb = 0.0, C=0.0;
    C = 3.948 * Math.sqrt(K* Math.pow( (2/(K+1)), ((K+1) /(K-1) )));
    System.debug('C : ' + string.valueof(C));

    // Subcritical flow
    If(strCriticalFlow == 'SUBCRITICAL FLOW'){
    double dVal1 = 0.0, dVal2=0.0;
    dVal1 = (2*k/(K-1)) * ( (Math.pow( (Pb/Po), (2/K) )) - (Math.pow( (Pb/Po), ((K+1)/K)   ) ) ) ;

    dVal2 = K * (Math.pow( (2/(K+1)), ((K+1)/(K-1) ) ) ) ;
    System.debug('dVal1 : ' + string.valueof(dVal1));
    System.debug('dVal2 : ' + string.valueof(dVal2));
    Kb =   MATH.sqrt( dVal1 /dVal2  );
    System.debug('Kb : ' + string.valueof(Kb));
    // Round the result to 6 decimals
    Kb = unitConversions.RoundNormal(Kb, 6) ;
    System.debug('Kb :Rounded ' + string.valueof(Kb));

    // Finally calculate the size
    objResult.dblRetValue = (Qm / (C * Kb * X * Po) ) * math.sqrt((To*Zo)/M);
    }
    // Critical flow
    If(strCriticalFlow == 'CRITICAL FLOW'){

    // Round the result to 6 decimals
    //C = unitConversions.RoundNormal(C, 6) ;
    //System.debug('C :Rounded ' + string.valueof(C));
    // Finally calculate the size
    objResult.dblRetValue = ( Qm / (C*X*Po) ) * Math.sqrt((To*Zo)/M);
    }
    System.debug('ISOGASSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    System.debug('Flow Type: ' +strCriticalFlow);
    System.debug('ISOGASSize :Rounded ' + string.valueof(objResult.dblRetValue));
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOGASSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }

    public static Result ISOGASCommon(double Po,double Pb,double K){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
    // First check if its subcritical flow or critical flow
    double dblCal =0.0; String strCriticalFlow='';
    dblCal = Math.pow((2/(K+1)),(K/(K-1)));

    if( (Pb/Po) > dblCal){
    strCriticalFlow='SUBCRITICAL FLOW';
    }
    else{
    strCriticalFlow='CRITICAL FLOW';
    }


    // Get value of K from table "DiscCoef"
    List<DiscCoef__c>  objDiscCoef =  [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE Evaluation__c='ISO Gas'  LIMIT 1];
    System.debug('objDiscCoef: ' + objDiscCoef);
    // Make sure we got response
    if ( ! objDiscCoef.isEmpty()) {
    if (objDiscCoef.get(0).Available_Coeffient_of_Discharge__c.contains(',')) {
    string strCoef=objDiscCoef.get(0).Available_Coeffient_of_Discharge__c.substringBefore(',');
    objResult.dblRetValue=double.valueOf(strCoef);
    } else {
    objResult.dblRetValue = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    }
    }
    else{
    objResult.bResult = false;
    objResult.strErrorMessage = 'ISOGASCommon: No Data Found';
    System.debug('ISOGASCommon: No Data Found');
    return objResult;
    }
    // flow related information
    objResult.strRetValue = strCriticalFlow;

    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOGASCommon()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }

    // This method returns Caapacity for ISO GAS.
    public static Result ISOGASCapacity(double Po,double Pb,double To,double K,
        double M, double Zo,integer nSize, String strPTC, String strSeat,double X,double Ard){
            // This object is used to convey back the results of various operations we will end up doing here.
            Result objResult = new Result();
            System.debug('Po: ' + Po);
            System.debug('Pb: ' + Pb);
            System.debug('To: ' + To);
            System.debug('K: ' + K);
            System.debug('M: ' + M);
            System.debug('Zo: ' + Zo);
            System.debug('X: ' + X);
            try{
                // This is a lookup from table "DiscCoef"
                // double X,Ard=0.0 ;
                //double Ard=0.0 ;
                String strCriticalFlow='';


                objResult = ISOGASCommon(Po,Pb,K);
                if(objResult.bResult != True)
                    return objResult;
                else{
                    // X = objResult.dblRetValue;
                    strCriticalFlow = objResult.strRetValue;
                }


                // Get value of Ard from table "RDMasterBlaster"
                //CO10************************************************************************
                // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                // if(objResult.bResult != True)
                //     return objResult;
                // else
                //     Ard = objResult.dblRetValue;
                //###########################################################################
                result resDistance=unitConversions.convertArea('in2','mm2',Ard);
                result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                Ard=resDistance1.dblRetValue;

                double Kb = 0.0, C = 0.0;
                C = 3.948 * Math.sqrt(K* Math.pow( (2/(K+1)), ((K+1) /(K-1) )));
                System.debug('C : ' + string.valueof(C));

                // Subcritical flow
                If(strCriticalFlow == 'SUBCRITICAL FLOW'){
                    double dVal1 = 0.0, dVal2=0.0;
                    dVal1 = (2*k/(K-1)) * ( (Math.pow( (Pb/Po), (2/K) )) - (Math.pow( (Pb/Po), ((K+1)/K)   ) ) ) ;

                    dVal2 = K * (Math.pow( (2/(K+1)), ((K+1)/(K-1) ) ) ) ;
                    System.debug('dVal1 : ' + string.valueof(dVal1));
                    System.debug('dVal2 : ' + string.valueof(dVal2));
                    Kb =   MATH.sqrt( dVal1 /dVal2  );
                    System.debug('Kb : ' + string.valueof(Kb));
                    // Round the result to 6 decimals
                    Kb = unitConversions.RoundNormal(Kb, 6) ;
                    System.debug('Kb :Rounded ' + string.valueof(Kb));
                    // Finally calculate the capacity
                    objResult.dblRetValue = C * Kb * X * Ard *Po * (Math.sqrt(M/ (To*Zo))) ;
                }

                // Critical flow
                If(strCriticalFlow == 'CRITICAL FLOW'){

                    // Finally calculate the capacity
                    objResult.dblRetValue = C *  X * Ard *Po * (Math.sqrt(M/ (To*Zo))) ;
                }
                System.debug('ISOGASCapacity : ' + string.valueof(objResult.dblRetValue));
                // Round the result to 6 decimals
                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                System.debug('Flow Type: ' +strCriticalFlow);
                System.debug('ISOGASCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
            }
            catch(Exception e){
                System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOGASCapacity()' + e.getMessage());
                objResult.bResult = false;
                objResult.strErrorMessage = e.getMessage();
            }
            objResult.bResult = true;
            return objResult;
        }

    // This method returns Size for ISODryStream
    public static Result ISODryStreamSize(double Qm, double P0, double T0,double Alpha) {
    // This object is used to convey back the results of various operations we will end up doing here.
    System.debug('Qm: ' + Qm);
    System.debug('P0: ' + P0);
    System.debug('T0: ' + T0);
    Result objResult = new Result();
    try {
    // This is a lookup from table "ISO_Dry_Ks_Lookup"
    double Ks = 0.0;
    // This is a lookup from table "DiscCoef"
    // double Alpha = 0.0;

    // Get Steam Interpolation done and get ks
    objResult = SteamInterpolationISODryKs(P0, T0);
    if (objResult.bResult != True)
    return objResult;
    else {
    Ks = objResult.dblRetValue;
    }

    // Get value of alpha from table "DiscCoef"
    // // List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
    // //         FROM DiscCoef__c WHERE(Evaluation__c = 'ISO Dry Steam') LIMIT 1];
    // System.debug('objDiscCoef'+objDiscCoef);
    // Make sure we got response
    // if (!objDiscCoef.isEmpty()) {
    // Alpha = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    System.debug('Alpha : ' + Alpha);
    System.debug('Ks : ' + Ks);
    // ISO Dry Stream Size formula
    objResult.dblRetValue = Qm * (Ks / Alpha / P0);
    System.debug('ISODRYSTREAMSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
    System.debug('ISODRYSTREAMSize :Rounded ' + string.valueof(objResult.dblRetValue));
    objResult.bResult = true;
    // }
    // else {
    //     objResult.bResult = false;
    //     objResult.strErrorMessage = 'No Data Found';
    // }

    }
    catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISODRYSTREAMSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }


    // This method returns Capacity for ISODryStream
    public static Result ISODryStreamCapacity(double Qm, double P0, double T0,integer nSize, String strPTC, String strSeat,double Alpha,double Ard) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try {
    // This is a lookup from table "ISO_Dry_Ks_Lookup"
    double Ks = 0.0;
    // This is a lookup from table "DiscCoef"
    //double Alpha = 0.0;
    // This is a lookup from table "MasterBlaster"
    //double ARD = 0.0;

    // Get Steam Interpolation done and get ks
    System.debug('P0'+P0);
    System.debug('T0'+T0);
    objResult = SteamInterpolationISODryKs(P0, T0);
    System.debug('SteamInterpolationISODryKs'+objResult);
    if (objResult.bResult != True)
    return objResult;
    else {
    Ks = objResult.dblRetValue;
    }

    // Get value of alpha from table "DiscCoef"
    // List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
    //     FROM DiscCoef__c WHERE(Evaluation__c = 'ISO Dry Steam') LIMIT 1];
    //     // Make sure we got response
    //     if (!objDiscCoef.isEmpty()) {
    //         Alpha = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    //     }
    //     else {
    //         objResult.bResult = false;
    //         objResult.strErrorMessage = 'No Data Found';
    //     }

    // Get value of ARD from table "RDMasterBlaster__c"
    // Get value of Ard from table "RDMasterBlaster"
    //CO10************************************************************************
    // objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
    // if(objResult.bResult != True)
    // return objResult;
    // else
    // Ard = objResult.dblRetValue;
    //###########################################################################

    result resDistance=unitConversions.convertArea('in2','mm2',Ard);
    result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3,0 );
    Ard=resDistance1.dblRetValue;

    // ISO Dry Stream Capacity formula
    objResult.dblRetValue = (ARD * Alpha * P0) / Ks;
    System.debug('ISODRYSTREAMCapacity : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
    System.debug('ISODRYSTREAMCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
    objResult.bResult = true;
    }
    catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISODRYStreamCapacity()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }


    // This method does Steam Interpolation.
    // Purpose is to return Ks
    public static Result SteamInterpolationISODryKs(double P0, double T0) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try {
    double NextLowerPres = 0.0, NextHigherPres = 0.0, SatTempAtNextLowerPres = 0.0, SatTempAtNextHigherPres = 0.0,
    SatKsAtNextLowerPres = 0.0, SatKsAtNextHigherPres = 0.0, SatTempAtRelievingPressure = 0.0, SatKsAtRelievingPressure = 0.0;

    double UpperRightPres = 0.0, UpperRightTemp = 0.0, UpperRightKs = 0.0, LowerRightPres = 0.0, LowerRightTemp = 0.0,
    LowerRightKs = 0.0, UpperLeftTemp = 0.0, UpperLeftKs = 0.0, LowerLeftTemp = 0.0,
    LowerLeftKs = 0.0, RightSideKs = 0.0, LeftSideKs = 0.0, Ks = 0.0;

    List < ISODryKs__c > objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
                FROM ISODryKs__c WHERE(Pressure__c =: P0 And Temprature__c =: T0)];
    System.debug('P0'+P0);
    System.debug('T0'+T0);
    System.debug('SteamInterpolationISODryKs : '+objISODryKs);

    // Found exact match
    if (!objISODryKs.isEmpty()) {
    objResult.bResult = true;

    Ks = objISODryKs.get(0).Ks__c;
    objResult.dblRetValue=Ks;
    System.debug('SteamInterpolationISODryKs Value'+Ks);
    } else {
    // All logic below in this else block fires queries in various stages to get a block of records.
    // Then as per the excel rules, it gets the right values used for interpolation
    System.debug('Records Found : ' + objISODryKs.size());
    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c <=: P0  AND SteamCond__c like 'Sat%' ORDER BY Pressure__c DESC, Temprature__c ASC];

    if (!objISODryKs.isEmpty()) {
    // Get the NextLowerPres
    NextLowerPres = objISODryKs.get(0).Pressure__c;
    System.debug('NextLowerPres : ' + NextLowerPres);
    //Get SatTempAtNextLowerPres
    SatTempAtNextLowerPres = objISODryKs.get(0).Temprature__c;
    System.debug('SatTempAtNextLowerPres : ' + SatTempAtNextLowerPres);
    // Get SatKsAtNextLowerPres
    SatKsAtNextLowerPres = objISODryKs.get(0).Ks__c;
    System.debug('SatKsAtNextLowerPres : ' + SatKsAtNextLowerPres);

    }
    else {
    objResult.bResult = false;
    return objResult;
    }

    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c >: P0 AND SteamCond__c like 'Sat%' ORDER BY Pressure__c ASC, Temprature__c ASC];

    if (!objISODryKs.isEmpty()) {
    // Get the NextHigherPres
    NextHigherPres = objISODryKs.get(0).Pressure__c;
    System.debug('NextHigherPres : ' + NextHigherPres);
    //Get SatTempAtNextHigherPres
    SatTempAtNextHigherPres = objISODryKs.get(0).Temprature__c;
    System.debug('SatTempAtNextHigherPres : ' + SatTempAtNextHigherPres);
    // Get SatKsAtNextHigherPres
    SatKsAtNextHigherPres = objISODryKs.get(0).Ks__c;
    System.debug('SatKsAtNextHigherPres : ' + SatKsAtNextHigherPres);

    SatTempAtRelievingPressure = (P0 - NextLowerPres) / (NextHigherPres - NextLowerPres) * (SatTempAtNextHigherPres - SatTempAtNextLowerPres) + SatTempAtNextLowerPres;
    System.debug('SatTempAtRelievingPressure : ' + SatTempAtRelievingPressure);
    SatKsAtRelievingPressure = (P0 - NextLowerPres) / (NextHigherPres - NextLowerPres) * (SatKsAtNextHigherPres - SatKsAtNextLowerPres) + SatKsAtNextLowerPres;
    System.debug('SatKsAtRelievingPressure : ' + SatKsAtRelievingPressure);

    }
    else {
    objResult.bResult = false;
    return objResult;
    }

    UpperRightPres = NextLowerPres;
    System.debug('UpperRightPres : ' + UpperRightPres);

    LowerRightPres = NextHigherPres;
    System.debug('LowerRightPres : ' + LowerRightPres);

    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: UpperRightPres AND Temprature__c >: T0 AND SteamCond__c like 'SH%'
    ORDER BY Temprature__c ASC];

    if (!objISODryKs.isEmpty()) {
    // Get UpperRightTemp
    UpperRightTemp = objISODryKs.get(0).Temprature__c;
    System.debug('UpperRightTemp : ' + UpperRightTemp);

    // get UpperRightKs
    //  UpperRightKs = objISODryKs.get(0).Ks__c;
    // System.debug('UpperRightKs : ' + UpperRightKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }

    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: UpperRightPres AND Temprature__c =: UpperRightTemp
    ORDER BY Temprature__c ASC];

    if (!objISODryKs.isEmpty()) {
    // Get UpperRightTemp
    //  UpperRightTemp = objISODryKs.get(0).Temprature__c;
    //  System.debug('UpperRightTemp : ' + UpperRightTemp);

    // get UpperRightKs
    UpperRightKs = objISODryKs.get(0).Ks__c;
    System.debug('UpperRightKs : ' + UpperRightKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }


    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: UpperRightPres AND Temprature__c <=: T0 AND SteamCond__c like 'S%'
    ORDER BY Temprature__c DESC];

    if (!objISODryKs.isEmpty()) {
    UpperLeftTemp = objISODryKs.get(0).Temprature__c;
    System.debug('UpperLeftTemp : ' + UpperLeftTemp);
    //UpperLeftKs = objISODryKs.get(0).Ks__c;
    // System.debug('UpperLeftKs : ' + UpperLeftKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }

    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: UpperRightPres AND Temprature__c =: UpperLeftTemp
    ORDER BY Temprature__c DESC];

    if (!objISODryKs.isEmpty()) {
    //UpperLeftTemp = objISODryKs.get(0).Temprature__c;
    //System.debug('UpperLeftTemp : ' + UpperLeftTemp);
    UpperLeftKs = objISODryKs.get(0).Ks__c;
    System.debug('UpperLeftKs : ' + UpperLeftKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }

    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: LowerRightPres AND Temprature__c >: T0 AND SteamCond__c Like 'SH%'
    ORDER BY Temprature__c ASC];

    if (!objISODryKs.isEmpty()) {
    // Get LowerRightTemp
    LowerRightTemp = objISODryKs.get(0).Temprature__c;
    System.debug('LowerRightTemp : ' + LowerRightTemp);
    // get LowerRightKs
    // LowerRightKs = objISODryKs.get(0).Ks__c;
    //  System.debug('LowerRightKs : ' + LowerRightKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }
    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: LowerRightPres AND Temprature__c =: LowerRightTemp
    ORDER BY Temprature__c ASC];

    if (!objISODryKs.isEmpty()) {
    // Get LowerRightTemp
    //    LowerRightTemp = objISODryKs.get(0).Temprature__c;
    //    System.debug('LowerRightTemp : ' + LowerRightTemp);
    // get LowerRightKs
    LowerRightKs = objISODryKs.get(0).Ks__c;
    System.debug('LowerRightKs : ' + LowerRightKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }

    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: LowerRightPres AND Temprature__c <=: T0 AND SteamCond__c Like 'SH%'
    ORDER BY Temprature__c DESC];

    if (!objISODryKs.isEmpty()) {
    LowerLeftTemp = objISODryKs.get(0).Temprature__c;
    System.debug('LowerLeftTemp : ' + LowerLeftTemp);
    //LowerLeftKs = objISODryKs.get(0).Ks__c;
    // System.debug('LowerLeftKs : ' + LowerLeftKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }
    objISODryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
    FROM ISODryKs__c WHERE Pressure__c =: LowerRightPres AND Temprature__c =: LowerLeftTemp
    ORDER BY Temprature__c DESC];

    if (!objISODryKs.isEmpty()) {
    // LowerLeftTemp = objISODryKs.get(0).Temprature__c;
    // System.debug('LowerLeftTemp : ' + LowerLeftTemp);
    LowerLeftKs = objISODryKs.get(0).Ks__c;
    System.debug('LowerLeftKs : ' + LowerLeftKs);
    } else {
    objResult.bResult = false;
    return objResult;
    }

    RightSideKs = (P0 - UpperRightPres) / (LowerRightPres - UpperRightPres) * (LowerRightKs - UpperRightKs) + UpperRightKs;
    System.debug('RightSideKs : ' + RightSideKs);
    LeftSideKs = (P0 - UpperRightPres) / (LowerRightPres - UpperRightPres) * (LowerLeftKs - UpperLeftKs) + UpperLeftKs;
    System.debug('LeftSideKs : ' + LeftSideKs);
    Ks = (T0 - UpperLeftTemp) / (UpperRightTemp - UpperLeftTemp) * (RightSideKs - LeftSideKs) + LeftSideKs;
    System.debug('Ks : ' + Ks);

    objResult.dblRetValue = Ks;
    }
    }
    catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISODrySteam()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }
    // This method returns Size for ISOWetStream
    public static Result ISOWetStreamSize(double Qm, double P0, double Xo,double Alpha) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    System.debug('Qm: ' + Qm);
    System.debug('P0: ' + P0);
    System.debug('Xo: ' + Xo);
    try {
    // This is a lookup from table "ISO_Wet_Ks_Lookup"
    double Ks = 0.0;
    // This is a lookup from table "DiscCoef"
    //double Alpha = 0.0;

    // Get Steam Interpolation done and get ks
    objResult = SteamInterpolationISOWetKs(P0, Xo);
    System.debug('124444444456444 : ' + objResult);
    if (objResult.bResult != True)
    return objResult;
    else {
    Ks = objResult.dblRetValue;
    }

    // Get value of alpha from table "DiscCoef"
    //    List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
    //     FROM DiscCoef__c WHERE(Evaluation__c = 'ISO Wet Stream') LIMIT 1];
    //    // Make sure we got response
    //     System.debug('1244444444 : ' + objDiscCoef);
    //    if (!objDiscCoef.isEmpty()) {
    // Alpha = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    // ISO Wet Stream Size formula
    objResult.dblRetValue = Qm * Ks * (MATH.sqrt(Xo/100) / Alpha / P0);
    System.debug('ISOWetSTREAMSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
    System.debug('ISOWetSTREAMSize :Rounded ' + string.valueof(objResult.dblRetValue));
    objResult.bResult = true;
    //    }
    //     else {
    //         objResult.bResult = false;
    //         objResult.strErrorMessage = 'No Data Found';
    //    }

    }
    catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOWetSTREAMSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }


    // This method returns Capacity for ISOWetStream
    public static Result ISOWetStreamCapacity(double Qm, double P0, double Xo,Integer nSize,String stPTC, String stSeat,double Alpha,double Ard) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try {
    // This is a lookup from table "ISO_Wet_Ks_Lookup"
    double Ks = 0.0;
    // This is a lookup from table "DiscCoef"
    //double Alpha = 0.0;
    // This is a lookup from table "MasterBlaster"
    //double ARD = 0.0;

    // Get Steam Interpolation done and get ks
    objResult = SteamInterpolationISOWetKs(P0, Xo);
    if (objResult.bResult != True)
    return objResult;
    else {
    Ks = objResult.dblRetValue;
    }

    // Get value of alpha from table "DiscCoef"
    //    List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
    //     FROM DiscCoef__c WHERE(Evaluation__c = 'ISO Wet Stream') LIMIT 1];
    //    // Make sure we got response
    //    if (!objDiscCoef.isEmpty()) {
    //         Alpha = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    //    } else {
    //         objResult.bResult = false;
    //         objResult.strErrorMessage = 'No Data Found';
    //         return objResult;
    //    }

    // Get value of ARD from table "RDMasterBlaster__c"
    // Get value of Ard from table "RDMasterBlaster"
    //CO10************************************************************************
    // objResult = RDMasterBlaster( nSize,  stPTC,  stSeat);
    // if(objResult.bResult != True)
    // return objResult;
    // else
    // Ard = objResult.dblRetValue;
    //###########################################################################

    result resDistance=unitConversions.convertArea('in2','mm2',Ard);
    result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
    Ard=resDistance1.dblRetValue;

    // ISO Wet Stream Size formula
    objResult.dblRetValue = (ARD * Alpha * P0 / Ks )/ MATH.sqrt(Xo/100);
    System.debug('ISOWetSTREAMCapacity : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
    System.debug('ISOWetSTREAMCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
    objResult.bResult = true;

    } catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOWetSTREAMCapacity()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }


    // This method does Steam Interpolation.
    // Purpose is to return Ks
    public static Result SteamInterpolationISOWetKs(double P0, double Xo) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try {
        double NextLowerPres = 0.0, NextHigherPres = 0.0, SatTempAtNextLowerPres = 0.0, SatTempAtNextHigherPres = 0.0,
        SatKsAtNextLowerPres = 0.0, SatKsAtNextHigherPres = 0.0, SatTempAtRelievingPressure = 0.0, SatKsAtRelievingPressure = 0.0;

        double UpperRightPres = 0.0, UpperRightTemp = 0.0, UpperRightKs = 0.0, LowerRightPres = 0.0, LowerRightTemp = 0.0,
        LowerRightKs = 0.0, UpperLeftTemp = 0.0, UpperLeftKs = 0.0, LowerLeftTemp = 0.0,
        LowerLeftKs = 0.0, RightSideKs = 0.0, LeftSideKs = 0.0, Ks = 0.0;

        // ISODryKs and ISOWetKs are same as far as data or table is concerned.
        List <ISODryKs__c > objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
                    FROM ISODryKs__c WHERE(Pressure__c =: P0  AND SteamCond__c LIKE 'Sat%') ];
        System.debug('objISOWetKs: ' + objISOWetKs);
        System.debug('objISOWetKs Records Found: ' + objISOWetKs.size());
        // Found exact match
        if (!objISOWetKs.isEmpty()) {
            objResult.bResult = true;
            Ks = objISOWetKs.get(0).Ks__c;
        } else {
            // All logic below in this else block fires queries in various stages to get a block of records.
            // Then as per the excel rules, it gets the right values used for interpolation

            objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
            FROM ISODryKs__c WHERE Pressure__c <=: P0 AND SteamCond__c LIKE 'Sat%' ORDER BY Pressure__c DESC, Temprature__c ASC];
            System.debug('Records Found 2: ' + objISOWetKs.size());

            if (!objISOWetKs.isEmpty()) {
            // Get the NextLowerPres
                NextLowerPres = objISOWetKs.get(0).Pressure__c;
                //Get SatTempAtNextLowerPres
                SatTempAtNextLowerPres = objISOWetKs.get(0).Temprature__c;
                // Get SatKsAtNextLowerPres
                SatKsAtNextLowerPres = objISOWetKs.get(0).Ks__c;

            } else {
                objResult.bResult = false;
                return objResult;
            }
            System.debug('Records Found 2: SatTempAtNextLowerPres ' +SatTempAtNextLowerPres);
            //System.debug('Records Found 2: ' +SatTempAtNextLowerPres);
            objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
            FROM ISODryKs__c WHERE Pressure__c >: P0 AND SteamCond__c LIKE 'Sat%' ORDER BY Pressure__c ASC, Temprature__c ASC];
            System.debug('Records Found 3: ' + objISOWetKs.size());
            if (!objISOWetKs.isEmpty()) {
            // Get the NextHigherPres
                NextHigherPres = objISOWetKs.get(0).Pressure__c;
                //Get SatTempAtNextHigherPres
                SatTempAtNextHigherPres = objISOWetKs.get(0).Temprature__c;
                // Get SatKsAtNextHigherPres
                SatKsAtNextHigherPres = objISOWetKs.get(0).Ks__c;

                SatTempAtRelievingPressure = (P0 - NextLowerPres) / (NextHigherPres - NextLowerPres) * (SatTempAtNextHigherPres - SatTempAtNextLowerPres) + SatTempAtNextLowerPres;
                SatKsAtRelievingPressure = (P0 - NextLowerPres) / (NextHigherPres - NextLowerPres) * (SatKsAtNextHigherPres - SatKsAtNextLowerPres) + SatKsAtNextLowerPres;

        } else {
            objResult.bResult = false;
            return objResult;
        }

        // UpperRightPres = NextLowerPres;
        // LowerRightPres = NextHigherPres;
        // System.debug('UpperRightPres: ' + UpperRightPres);
        // System.debug('LowerRightPres: ' + LowerRightPres);
        // System.debug('SatTempAtNextHigherPres: ' + SatTempAtNextHigherPres);
        // // System.debug('LowerRightPres: ' + LowerRightPres);
        // objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        // FROM ISODryKs__c WHERE Pressure__c =: UpperRightPres AND Temprature__c >: SatTempAtRelievingPressure AND SteamCond__c='Sat'
        // ORDER BY Temprature__c ASC];
        // System.debug('Records Found 4: ' + objISOWetKs.size());
        // if (!objISOWetKs.isEmpty()) {
        // // Get UpperRightTemp
        // UpperRightTemp = objISOWetKs.get(0).Temprature__c;
        // // get UpperRightKs
        // UpperRightKs = objISOWetKs.get(0).Ks__c;
        // } else {
        // objResult.bResult = false;
        // return objResult;
        // }

        // System.debug('Before : ') ;
        // objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        // FROM ISODryKs__c WHERE Pressure__c =: UpperRightPres AND Temprature__c <: UpperRightTemp AND SteamCond__c='Sat'
        // ORDER BY Temprature__c DESC];

        // System.debug('UpperRightPres : ' + UpperRightPres);
        // System.debug('Xo : ' + Xo);

        // if (!objISOWetKs.isEmpty()) {
        // UpperLeftTemp = objISOWetKs.get(0).Temprature__c;
        // UpperLeftKs = objISOWetKs.get(0).Ks__c;
        // } else {
        // objResult.bResult = false;
        // return objResult;
        // }

        // System.debug('After : ' );

        // System.debug('After : ' +LowerRightPres);

        // objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        // FROM ISODryKs__c WHERE Pressure__c =: LowerRightPres AND Temprature__c >: UpperLeftTemp AND SteamCond__c='Sat'
        // ORDER BY Temprature__c ASC];


        // if (!objISOWetKs.isEmpty()) {
        // // Get LowerRightTemp
        // LowerRightTemp = objISOWetKs.get(0).Temprature__c;
        // // get LowerRightKs
        // LowerRightKs = objISOWetKs.get(0).Ks__c;
        // } else {
        // objResult.bResult = false;
        // return objResult;
        // }

        // objISOWetKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
        // FROM ISODryKs__c WHERE Pressure__c =: LowerRightPres AND Temprature__c <: LowerRightTemp AND SteamCond__c='Sat'
        // ORDER BY Temprature__c DESC
        // ];

        // if (!objISOWetKs.isEmpty()) {
        // LowerLeftTemp = objISOWetKs.get(0).Temprature__c;
        // LowerLeftKs = objISOWetKs.get(0).Ks__c;
        // } else {
        // objResult.bResult = false;
        // return objResult;
        // }

        // RightSideKs = (P0 - UpperRightPres) / (LowerRightPres - UpperRightPres) * (LowerRightKs - UpperRightKs) + UpperRightKs;
        // LeftSideKs = (P0 - UpperRightPres) / (LowerRightPres - UpperRightPres) * (LowerLeftKs - UpperLeftKs) + UpperLeftKs;
        // Ks = (Xo - UpperLeftTemp) / (UpperRightTemp - UpperLeftTemp) * (RightSideKs - LeftSideKs) + LeftSideKs;

        // // COMMENT OUT BUT MAINTAIN THESE DEBUG STATEMENTS
        // System.debug('NextLowerPres : ' + NextLowerPres);
        // System.debug('NextHigherPres : ' + NextHigherPres);
        // System.debug('SatTempAtNextLowerPres : ' + SatTempAtNextLowerPres);
        // System.debug('SatTempAtNextHigherPres : ' + SatTempAtNextHigherPres);
        // System.debug('SatKsAtNextLowerPres : ' + SatKsAtNextHigherPres);
        // System.debug('SatKsAtNextHigherPres : ' + SatKsAtNextHigherPres);
        // System.debug('SatTempAtRelievingPressure : ' + SatTempAtRelievingPressure);
        // System.debug('SatKsAtRelievingPressure : ' + SatKsAtRelievingPressure);

        // System.debug('UpperRightPres : ' + UpperRightPres);
        // System.debug('UpperRightTemp : ' + UpperRightTemp);
        // System.debug('UpperRightKs : ' + UpperRightKs);

        // System.debug('LowerRightPres : ' + LowerRightPres);
        // System.debug('LowerRightTemp : ' + UpperRightTemp);
        // System.debug('LowerRightKs : ' + LowerRightKs);

        // System.debug('UpperLeftTemp : ' + UpperLeftTemp);
        // System.debug('UpperLeftKs : ' + UpperLeftKs);

        // System.debug('LowerLeftTemp : ' + LowerLeftTemp);
        // System.debug('LowerLeftKs : ' + LowerLeftKs);

        // System.debug('RightSideKs : ' + RightSideKs);
        // System.debug('LeftSideKs : ' + LeftSideKs);

        // Whole logic above to get this value.
        System.debug('Ks : ' + SatKsAtRelievingPressure);
        objResult.dblRetValue = SatKsAtRelievingPressure;
        }
    } catch (Exception e) {
        System.debug('The following exception has occurred: RDDiscSizingCapacity:ISOWetSteam()' + e.getMessage());
        objResult.bResult = false;
        objResult.strErrorMessage = e.getMessage();
    }
        objResult.bResult = true;
        return objResult;
    }

    // This method returns Size for APIOmegaMTD2Phase
    public static Result APIOmegaMTD2PhaseSize(double Q, double P0, double V0, double V9, double MU, double PA) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try {
    // This is a lookup from table "DiscCoef"
    double KD = 0.0;

    // Get value of KD from table "DiscCoef"
    List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE(Evaluation__c = 'API Omega Mtd 2-phase') LIMIT 1];
    // Make sure we got response
    if (!objDiscCoef.isEmpty()) {
    KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    // APIOmegaMTD2Phase Size formulas
    double KV0 = 1;
    System.debug('KV0 : ' + KV0);
    System.debug('V9 : ' + V9);
    System.debug('V0 : ' + V0);
    double W = 9 *( (V9 / V0 )- 1);
    System.debug('W : ' + W);
    double NA = PA / P0;
    System.debug('NA : ' + NA);
    double NC = MATH.pow(Double.valueOf(1 + (1.0446 - 0.0093431 * MATH.sqrt(W)) * MATH.pow(W, Double.valueOf(-0.56261))), Double.valueOf((-0.70356 + 0.014685 * MATH.log(W))));
    System.debug('NC : ' + NC);
    double G_Critical = 68.09 * NC * MATH.sqrt(P0 / (V0 * W));
    System.debug('G_Critical : ' + G_Critical);
    double G_Subcritical = 68.09 * MATH.sqrt(-2 * (W * MATH.log(NA) + (W - 1) * (1 - NA))) / (W * (1 / NA - 1) + 1) * MATH.sqrt(P0 / V0);
    System.debug('G_Subcritical : ' + G_Subcritical);
    double G = (PA <= (P0 * NC) ? G_Critical : G_Subcritical);
    System.debug('G : ' + G);

    double A = 0.0, PrevA = 0.0, R = 0.0, KV = KV0;
    boolean bLoop = true;
    integer i = 1;
    // This loop assumes value of A increases always through loops.
    while (bLoop) {
    A = 0.04 * Q / (KD * KV * G);
    R = Q * 2800 * 1 / (V0 * 62.371) / (MU * MATH.sqrt(A));
    KV = Math.pow(Double.valueOf(0.9935 + 2.878 / (MATH.pow(R, Double.valueOf(0.5))) + 342.75 / (MATH.pow(R, Double.valueOf(1.5)))), Double.valueOf(-1));

    // Check and terminate loop if it matches condition
    if (KV > 1 && R>33) {
        bLoop = false;
    } else if (MATH.abs(A - PrevA) < 0.0001 && R>33) {
        bLoop = false;
    } else if (i == 10) {
        bLoop = false;
    } else {
    // Used in next loop to check if we have "looped" enough
        PrevA = A;
    }

    // Used only for debug info
    i = i + 1;
    }
    // API Omega MTD2Phase Size formula has valid value
    if (i != 10) {
    objResult.dblRetValue = A;
    System.debug('APIOmegaMTD2PhaseSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    objResult.bResult = true;
    } else {
    System.debug('APIOmegaMTD2PhaseSize : Did not find match after 10 iterations ');
    objResult.bResult = false;
    objResult.strErrorMessage = 'Did not find match after 10 iterations';
    }
    } else {
    objResult.bResult = false;
    objResult.strErrorMessage = 'No Data Found';
    }
    } catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:APIOmegaMTD2PhaseSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }



    // This method returns Capacity for APIOmegaMTD2Phase
    public static Result APIOmegaMTD2PhaseCapacity(double P0, double V0,
                    double V9, double MU, double PA, Integer nSize, String stPTC, String stSeat,double Ard) {
                        // This object is used to convey back the results of various operations we will end up doing here.
                        Result objResult = new Result();
                        try {
                            // This is a lookup from table "DiscCoef"
                            double KD = 0.0;

                            // This is a lookup from table "MasterBlaster"
                           // double ARD = 0.0;
                            String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                            // Get value of ARD from table "RDMasterBlaster__c"
                            //List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
                            List <RDMasterBlaster__c> objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, MNFA__c
                                                                            FROM RDMasterBlaster__c WHERE( PTC__c =: stPTC AND STC__c =: stSeat AND SZC__c =: strSZC AND MNFA__c !=NULL) ORDER BY MNFA__c DESC LIMIT 1];//SZC__c =: nSize AND

                            // Make sure we got response
                            //CO10************************************************************************
                            // if (!objRDMasterBlaster.isEmpty()) {
                            //     ARD = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
                            // } else {
                            //     objResult.bResult = false;
                            //     objResult.strErrorMessage = 'No Data Found';
                            //     return objResult;
                            // }
                            //###########################################################################
                            // Get value of KD from table "DiscCoef"
                            List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                FROM DiscCoef__c WHERE(Evaluation__c = 'API Omega Mtd 2-phase') LIMIT 1];
                            // Make sure we got response
                            System.debug('ARD : '+ARD);
                            if (!objDiscCoef.isEmpty()) {
                                KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                                // APIOmegaMTD2Phase Capacity formulas
                                double KV0 = 1;
                                System.debug('KV0 : ' + KV0);
                                double W = 9 * (V9 / V0 - 1);
                                System.debug('W : ' + W);
                                double NA = PA / P0;
                                System.debug('NA : ' + NA);
                                double NC = MATH.pow(Double.valueOf(1 + (1.0446 - 0.0093431 * MATH.sqrt(W)) * MATH.pow(W, Double.valueOf(-0.56261))), Double.valueOf((-0.70356 + 0.014685 * MATH.log(W))));
                                System.debug('NC : ' + NC);
                                double G_Critical = 68.09 * NC * MATH.sqrt(P0 / (V0 * W));
                                System.debug('G_Critical : ' + G_Critical);
                                double G_Subcritical = 68.09 * MATH.sqrt(-2 * (W * MATH.log(NA) + (W - 1) * (1 - NA))) / (W * (1 / NA - 1) + 1) * MATH.sqrt(P0 / V0);
                                System.debug('G_Subcritical : ' + G_Subcritical);
                                double G = (PA <= (P0 * NC) ? G_Critical : G_Subcritical);
                                System.debug('G : ' + G);

                                double QRD = 0.0, PrevQRD = 0.0, R = 0.0, KV = KV0;
                                boolean bLoop = true;
                                integer i = 1;
                                // This loop assumes value of A increases always through loops.
                                while (bLoop) {
                                    QRD = ARD * KD * KV * G / 0.04;
                                    R = QRD * 2800 * (V0 * 62.371) / (MU * MATH.sqrt(ARD)); // added by Robert on 10/1 per updated equation provided by Aaron Ratigan at CDC
                                    // R = QRD * 2800 * 1 / (V0 * 62.371) / (MU * MATH.sqrt(ARD)); // original equation that was replaced
                                    KV = MATH.pow(Double.valueOf(0.9935 + 2.878 / (MATH.pow(R, Double.valueOf(0.5))) + 342.75 / (MATH.pow(R, Double.valueOf(1.5)))), Double.valueOf(-1));

                                    // Check and terminate loop if it matches condition
                                    if (KV > 1 && R>33) {
                                        bLoop = false;
                                    } else if (MATH.abs(QRD - PrevQRD) < 0.0001 && R>33) {
                                        bLoop = false;
                                    } else if (i == 10) {
                                        bLoop = false;
                                    } else {
                                        // Used in next loop to check if we have "looped" enough
                                        PrevQRD = QRD;
                                    }
                                    // Used only for debug info
                                    i = i + 1;
                                }
                                // API Omega MTD2Phase Capacity formula has valid value
                                if (i != 10) {
                                    objResult.dblRetValue = QRD;
                                    System.debug('APIOmegaMTD2PhaseCapacity : ' + string.valueof(objResult.dblRetValue));
                                    // Round the result to 6 decimals
                                    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                                    objResult.bResult = true;
                                } else {
                                    System.debug('APIOmegaMTD2PhaseCapacity : Did not find match after 10 iteration ');
                                    objResult.bResult = false;
                                    objResult.strErrorMessage = 'Did not find match after 10 iteration';
                                }
                            } else {
                                objResult.bResult = false;
                                objResult.strErrorMessage = 'No Data Found';
                            }

                        } catch (Exception e) {
                            System.debug('The following exception has occurred: RDDiscSizingCapacity:APIOmegaMTD2PhaseCapacity()' + e.getMessage());
                            objResult.bResult = false;
                            objResult.strErrorMessage = e.getMessage();
                        }
                        return objResult;
                    }
    // This method returns Size for API Omega Mtd Subcool
    public static Result APIOmegaMtdSubcoolSize(double Q, double PS, double P0, double P10, double P9, double MU, double PA) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try {
    // This is a lookup from table "DiscCoef"
    double KD = 0.0;
    system.debug('Q'+Q);
    system.debug('PS'+PS);
    system.debug('P0'+P0);
    system.debug('P10'+P10);
    system.debug('P9'+P9);
    system.debug('MU'+MU);
    system.debug('PA'+PA);
    // Get value of KD from table "DiscCoef"
    List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE(Evaluation__c = 'API Omega Mtd Subcool') LIMIT 1];
    // Make sure we got response
    if (!objDiscCoef.isEmpty()) {
    KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    // API Omega Mtd Subcool Size formulas
    System.debug('APIOmegaMtdSubcoolSize #############');
    double KV0 = 1;
    System.debug('KV0 :  ' + KV0);
    double NS = PS / P0;
    System.debug('NS :  ' + NS);
    double WS = 9 * (P10 / P9 - 1);
    System.debug('WS :  ' + WS);
    double NST = 2 * WS / (1 + 2 * WS);
    System.debug('NST :  ' + NST);
    double NA = PA / P0;
    System.debug('NA :  ' + NA);
    double NC = (NS <= NST ? NS : NS * (2 * WS / (2 * WS - 1) * (1 - MATH.sqrt(1 - 1 / NS * (2 * WS - 1 / (2 * WS))))));
    System.debug('NC :  ' + NC);
    double N = (PA <= P0 * NC ? NC : NA);
    System.debug('N :  ' + N);
    double P = (PA <= P0 * NC ? PS : PA);
    System.debug('P :  ' + P);
    String SUBCOOLING_REGION = (PS >= NST * P0 ? 'LOW SUBCOOL' : 'HIGH SUBCOOL');
    System.debug('SUBCOOLING_REGION :  ' + SUBCOOLING_REGION);
    double G_Low_Subcool = 68.09 * MATH.sqrt(2 * (1 - NS) + 2 * (WS * NS * MATH.log(NS / N) - (WS - 1) * (NS - N))) / (WS * (NS / N - 1) + 1) * MATH.sqrt(P * P10);
    System.debug('G_Low_Subcool :  ' + G_Low_Subcool);
    double G_High_Subcool = 96.3 * MATH.sqrt(P10 * (P0 - P));
    System.debug('G_High_Subcool :  ' + G_High_Subcool);
    double G = (SUBCOOLING_REGION == 'LOW SUBCOOL' ? G_Low_Subcool : (SUBCOOLING_REGION == 'HIGH SUBCOOL' ? G_High_Subcool : 0));
    System.debug('G :  ' + G);

    double A = 0.0, PrevA = 0.0, R = 0.0, KV = KV0;
    boolean bLoop = true;
    integer i = 1;
    // This loop assumes value of A increases always through loops.
    System.debug('Entering viscosity calcuation loop'); // added by Robert on 9/30/20
    while (bLoop) {

    A = 0.3208 * Q * P10 / (KD * KV * G);
    // R = Q * 2800 * 1 / (P10 * 62.371) / (MU * MATH.sqrt(A)); original line before editing by Aaron/Robert on 9/30/20 for Bug 33761
    R = Q * 2800 * (P10 / 62.371) / (MU * MATH.sqrt(A));
    System.debug('Loop number ' + i); // added by Robert on 9/30/20
    System.debug('Calculated R is ' + R); // added by Robert on 9/30/20
    KV = MATH.pow(Double.valueOf(0.9935 + 2.878 / (MATH.pow(R, Double.valueOf(0.5))) + 342.75 / (MATH.pow(R, Double.valueOf(1.5)))), Double.valueOf(-1));
    System.debug('Calculated KV is ' + KV); // added by Robert on 9/30/20

    // Check and terminate loop if it matches condition
    if (KV > 1 && R>33) {
    bLoop = false;
    } else if (MATH.abs(A - PrevA) < 0.0001 && R>33) {
    bLoop = false;
    } else if (i == 10) {
    bLoop = false;
    } else {
    // Used in next loop to check if we have "looped" enough
    PrevA = A;
    }
    // Used only for debug info
    i = i + 1;
    }
    // API Omega MtdSubcool Size formula has valid value
    if (i != 10) {
    objResult.dblRetValue = A;
    System.debug('APIOmegaMtdSubcoolSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
    objResult.bResult = true;
    } else {
    System.debug('APIOmegaMtdSubcoolSize : Did not find match after 10 iterations ');
    objResult.bResult = false;
    objResult.strErrorMessage = 'Did not find match after 10 iterations';
    }


    } else {
    objResult.bResult = false;
    objResult.strErrorMessage = 'No Data Found';
    }

    } catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:APIOmegaMtdSubcoolSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }

    // This method returns Capacity for APIOmegaMtdSubcool
    public static Result APIOmegaMtdSubcoolCapacity(double PS, double P0, double P10, double P9, double MU, double PA,
                    Integer nSize, String stPTC, String stSeat,double Ard) {
                        // This object is used to convey back the results of various operations we will end up doing here.
                        Result objResult = new Result();
                        try {
                            // This is a lookup from table "DiscCoef"
                            double KD = 0.0;

                            // This is a lookup from table "MasterBlaster"
                            //double ARD = 0.0;

                            // Get value of ARD from table "RDMasterBlaster__c"
                            // Note: I am creating a sample SOQL Query. Need to replace / correct with actual table,fields and filter clause
                            //List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
                            String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                            List < RDMasterBlaster__c > objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, MNFA__c
                                                                                FROM RDMasterBlaster__c WHERE( PTC__c =: stPTC AND STC__c =: stSeat AND SZC__c =: strSZC AND MNFA__c !=NULL) ORDER BY MNFA__c DESC LIMIT 1];//SZC__c =: nSize AND

                            // Make sure we got response
                            //CO10************************************************************************
                            // if (!objRDMasterBlaster.isEmpty()) {
                            //     ARD = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
                            // } else {
                            //     objResult.bResult = false;
                            //     objResult.strErrorMessage = 'No Data Found';
                            //     return objResult;
                            // }
                            //###########################################################################
                            System.debug('APIOmegaMtdSubcoolCapacity #############'+ARD);
                            // Get value of KD from table "DiscCoef"
                            List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                FROM DiscCoef__c WHERE(Evaluation__c = 'API Omega Mtd Subcool') LIMIT 1];
                            // Make sure we got response
                            if (!objDiscCoef.isEmpty()) {
                                KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                                // APIOmegaMtdSubcool Capacity formulas
                                System.debug('APIOmegaMtdSubcoolCapacity #############');
                                double KV0 = 1;
                                System.debug('KV0 :  ' + KV0);
                                double NS = PS / P0;
                                System.debug('NS :  ' + NS);
                                double WS = 9 * (P10 / P9 - 1);
                                System.debug('WS :  ' + WS);
                                double NST = 2 * WS / (1 + 2 * WS);
                                System.debug('NST :  ' + NST);
                                double NA = PA / P0;
                                System.debug('NA :  ' + NA);
                                double NC = (NS <= NST ? NS : NS * (2 * WS / (2 * WS - 1) * (1 - MATH.sqrt(1 - 1 / NS * (2 * WS - 1 / (2 * WS))))));
                                System.debug('NC :  ' + NC);
                                double N = (PA <= P0 * NC ? NC : NA);
                                System.debug('N :  ' + N);
                                double P = (PA <= P0 * NC ? PS : PA);
                                System.debug('P :  ' + P);
                                String SUBCOOLING_REGION = (PS >= NST * P0 ? 'LOW SUBCOOL' : 'HIGH SUBCOOL');
                                System.debug('SUBCOOLING_REGION :  ' + SUBCOOLING_REGION);
                                double G_Low_Subcool = 68.09 * MATH.sqrt(2 * (1 - NS) + 2 * (WS * NS * MATH.log(NS / N) - (WS - 1) * (NS - N))) / (WS * (NS / N - 1) + 1) * MATH.sqrt(P * P10);
                                System.debug('G_Low_Subcool :  ' + G_Low_Subcool);
                                double G_High_Subcool = 96.3 * MATH.sqrt(P10 * (P0 - P));
                                System.debug('G_High_Subcool :  ' + G_High_Subcool);
                                double G = (SUBCOOLING_REGION == 'LOW SUBCOOL' ? G_Low_Subcool : (SUBCOOLING_REGION == 'HIGH SUBCOOL' ? G_High_Subcool : 0));
                                System.debug('G :  ' + G);

                                double QRD = 0.0, PrevQRD = 0.0, R = 0.0, KV = KV0;
                                boolean bLoop = true;
                                integer i = 1;
                                System.debug('Entering viscosity calcuation loop'); // added by Robert on 10/2/20
                                System.debug('ARD : ' + ARD); // added by Robert on 10/2/20
                                System.debug('KD : ' + KD); // added by Robert on 10/2/20
                                System.debug('KV0 : ' + KV0); // added by Robert on 10/2/20
                                System.debug('G : ' + G); // added by Robert on 10/2/20
                                // This loop assumes value of A increases always through loops.
                                while (bLoop) {

                                    System.debug('Loop number ' + i); // added by Robert on 10/2/20
                                    // QRD = ARD * KD * KV0 * G / 0.04; // original line before editing by Robert on 10/2/20 for Bug 33761
                                    QRD = ARD * KD * KV * G / 0.3208 / P10;
                                    System.debug('QRD :  ' + QRD);
                                    // R = QRD * 2800 * 1 / (P10 * 62.371) / (MU * MATH.sqrt(ARD)); original line before editing by Robert on 10/2/20 for Bug 33761
                                    R = QRD * 2800 * (P10 / 62.371) / (MU * MATH.sqrt(ARD));
                                    System.debug('R :  ' + R);
                                    KV = MATH.pow(Double.valueOf((0.9935 + 2.878 / (MATH.pow(R, Double.valueOf(0.5)))) + (342.75 / (MATH.pow(R, Double.valueOf(1.5))))), Double.valueOf(-1));
                                    System.debug('KV :  ' + KV);
                                    // Check and terminate loop if it matches condition
                                    system.debug('Value of QRD - PrevQRD is ' + (MATH.abs(QRD - PrevQRD)));
                                    if (KV > 1 && R>33) {
                                        bLoop = false;
                                    } else if (MATH.abs(QRD - PrevQRD) < 0.0001 && R>33) {
                                        bLoop = false;
                                    } else if (i == 10) {
                                        bLoop = false;
                                    } else {
                                        // Used in next loop to check if we have "looped" enough
                                        PrevQRD = QRD;
                                    }

                                    // Used only for debug info
                                    i = i + 1;

                                }
                                // APIOmegaMtdSubcoolCapacity formula has valid value
                                if (i != 10) {
                                    objResult.dblRetValue = QRD;
                                    System.debug('APIOmegaMtdSubcoolCapacity : ' + string.valueof(objResult.dblRetValue));
                                    // Round the result to 6 decimals
                                    //objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                                    objResult.bResult = true;
                                } else {
                                    System.debug('APIOmegaMtdSubcoolCapacity : Did not find match after 10 iterations ');
                                    objResult.bResult = false;
                                    objResult.strErrorMessage = 'Did not find match after 10 iterations';
                                }

                            } else {
                                objResult.bResult = false;
                                objResult.strErrorMessage = 'No Data Found';
                            }

                        } catch (Exception e) {
                            System.debug('The following exception has occurred: RDDiscSizingCapacity:APIOmegaMtdSubcoolCapacity()' + e.getMessage());
                            objResult.bResult = false;
                            objResult.strErrorMessage = e.getMessage();
                        }
                        return objResult;
                    }

    // This method returns Size for FauskeGasLiquid
    public static Result FauskeGasLiquidSize(double W, double P0, double PB, double K, double T0, double MW, double R, double X0, double P10) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    system.debug('FauskeGasLiquidSize W->:'+W);
    system.debug('FauskeGasLiquidSize P0:'+P0);
    system.debug('FauskeGasLiquidSize PB:'+PB);
    system.debug('FauskeGasLiquidSize K:'+K);
    system.debug('FauskeGasLiquidSize T0:'+T0);
    system.debug('FauskeGasLiquidSize MW:'+MW);
    system.debug('FauskeGasLiquidSize R:'+R);
    system.debug('FauskeGasLiquidSize X0:'+X0);
    system.debug('FauskeGasLiquidSize P10:'+P10);
    try {
    // This is a lookup from table "DiscCoef"
    double KD = 0.0;

    // Get value of alpha from table "DiscCoef"
    List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske Gas-Liquid') LIMIT 1
                ];
    // Make sure we got response
    if (!objDiscCoef.isEmpty()) {
    System.debug('FauskeGasLiquidSize ##################################');
    KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
    System.debug('KD  : ' + KD);
    double G = 0.0;

    Result objCommonResult  = FauskeGasLiquidCommon( P0,  PB,  K,  T0,  MW,  R,  X0,  P10);
    // Make sure we got response
    if (objCommonResult.bResult != True) {
    return objCommonResult;
    } else {
    G = objCommonResult.dblRetValue;
    System.debug('G  : ' + G);
    }

    objResult.dblRetValue = W / KD / G;
    System.debug('FauskeGasLiquidSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
    System.debug('FauskeGasLiquidSize :Rounded ' + string.valueof(objResult.dblRetValue));
    objResult.bResult = true;
    } else {
    objResult.bResult = false;
    objResult.strErrorMessage = 'No Data Found';
    }

    } catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeGasLiquidSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }


    // This method returns Capacity for FauskeGasLiquid
    public static Result FauskeGasLiquidCapacity(double P0, double PB, double K, double T0, double MW, double R, double X0, double P10,
                    Integer nSize, String stPTC, String stSeat,double Ard) {
                        // This object is used to convey back the results of various operations we will end up doing here.
                        Result objResult = new Result();
                        try {
                            // This is a lookup from table "DiscCoef"
                            double KD = 0.0;
                            // This is a lookup from table "MasterBlaster"
                            //double ARD = 0.0;

                            // Get value of ARD from table "RDMasterBlaster__c"
                            // Note: I am creating a sample SOQL Query. Need to replace / correct with actual table,fields and filter clause
                            //List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
                            String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                            List < RDMasterBlaster__c > objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, MNFA__c
                                                                            FROM RDMasterBlaster__c WHERE( PTC__c =: stPTC AND STC__c =: stSeat AND SZC__c =: strSZC AND MNFA__c !=NULL) ORDER BY MNFA__c DESC LIMIT 1//SZC__c =: nSize AND
                                                                            ];

                            // Make sure we got response
                            //CO10************************************************************************
                            // if (!objRDMasterBlaster.isEmpty()) {
                            //     ARD = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
                            // } else {
                            //     objResult.bResult = false;44
                            //     objResult.strErrorMessage = 'No Data Found';
                            //     return objResult;
                            // }
                            //###########################################################################
                            result resDistance=unitConversions.convertArea('in2','mm2',ARD);
                            result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, -99);
                            resDistance=unitConversions.convertArea('mm2','m2',resDistance1.dblRetValue);
                            resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, -99);
                            ARD=resDistance1.dblRetValue;
                            system.debug('ARD'+ARD);
                            // Get value of alpha from table "DiscCoef"
                            List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske Gas-Liquid') LIMIT 1
                                                            ];
                            // Make sure we got response
                            if (!objDiscCoef.isEmpty()) {
                                System.debug('FauskeGasLiquidCapacity ##################################');
                                KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                                System.debug('KD  : ' + KD);
                                double G = 0.0;

                                Result objCommonResult  = FauskeGasLiquidCommon(   P0,  PB,  K,  T0,  MW,  R,  X0,  P10);
                                // Make sure we got response
                                if (objCommonResult.bResult != True) {
                                    return objCommonResult;
                                } else {
                                    G = objCommonResult.dblRetValue;
                                    System.debug('G  : ' + G);
                                }

                                objResult.dblRetValue = KD * ARD * G;
                                System.debug('FauskeGasLiquidCapacity : ' + string.valueof(objResult.dblRetValue));
                                // Round the result to 6 decimals
                                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                                System.debug('FauskeGasLiquidCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
                                objResult.bResult = true;
                            } else {
                                objResult.bResult = false;
                                objResult.strErrorMessage = 'No Data Found';
                            }

                        } catch (Exception e) {
                            System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeGasLiquidCapacity()' + e.getMessage());
                            objResult.bResult = false;
                            objResult.strErrorMessage = e.getMessage();
                        }
                        return objResult;
                    }


    public static Result FauskeGasLiquidCommon(double P0, double PB, double K, double T0, double MW, double R, double X0, double P10) {
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();
    try {
    system.debug('FauskeGasLiquidCommon ###############################3');
    //System.debug('W : '+ W);
    System.debug('P0 : '+ P0);
    System.debug('PB : '+ PB);
    System.debug('K : '+ K);
    System.debug('T0 : '+ T0);
    System.debug('MW : '+ MW);
    System.debug('R : '+ R);
    System.debug('X0 : '+ X0);
    System.debug('P10 : '+ P10);

    // Fauske Gas Liquid Size formula
    double GX0_0 = MATH.sqrt(2 * (P0 - PB) * P10);
    double GX0_1_Crt = P0 * MATH.sqrt(MW / (R * T0)) * MATH.sqrt(K * MATH.pow((2 / (K + 1)), ((K + 1) / (K - 1))));
    double GX0_1_SubCrt = P0 * MATH.sqrt(MW / (R * T0)) * MATH.sqrt((2 * K / (K - 1)) * MATH.pow((PB / P0), (2 / K)) - MATH.pow((PB / P0), ((K + 1) / (K))));
    double G = (PB / P0 <= MATH.pow((2 / (K + 1)), (K / (K - 1))) ? 1 / MATH.sqrt((1 - X0) / MATH.pow(GX0_0, Double.valueOf(2)) + X0 / MATH.pow(GX0_1_Crt, Double.valueOf(2))) : 1 / MATH.sqrt((1 - X0) / MATH.pow(GX0_0, Double.valueOf(2)) + X0 / MATH.pow(GX0_1_SubCrt, Double.valueOf(2))));

    System.debug('GX0_0 : ' + GX0_0);
    System.debug('GX0_1_Crt : ' + GX0_1_Crt);
    System.debug(' GX0_1_SubCrt: ' + GX0_1_SubCrt);
    System.debug('G : ' + G);

    objResult.dblRetValue =  G;
    System.debug('FauskeGasLiquidCommon : ' + string.valueof(objResult.dblRetValue));
    objResult.bResult = true;


    } catch (Exception e) {
    System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeGasLiquidCommon()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    return objResult;
    }
    // This method returns Size for Fauske Hybrid GVL
    public static Result FauskeHybridGVLSize(double W, double P0, double PB, double T0, double PG0, double PV0, double KG, double KV, double MWG, double MWV,
                double R, double X0, double P10,  double C0,double L0, double PV0_d) {
                    // This object is used to convey back the results of various operations we will end up doing here.
                    Result objResult = new Result();
                    try {
                        // This is a lookup from table "DiscCoef"
                        double KD = 0.0;
                        system.debug('FauskeHybridGVLSize W: '+W);
                        system.debug('FauskeHybridGVLSize P0: '+P0);
                        system.debug('FauskeHybridGVLSize PB: '+PB);
                        system.debug('FauskeHybridGVLSize T0: '+T0);
                        system.debug('FauskeHybridGVLSize PG0: '+PG0);
                        system.debug('FauskeHybridGVLSize PV0: '+PV0);
                        system.debug('FauskeHybridGVLSize KG: '+KG);
                        system.debug('FauskeHybridGVLSize KV: '+KV);
                        system.debug('FauskeHybridGVLSize MWG: '+MWG);
                        system.debug('FauskeHybridGVLSize MWV: '+MWV);
                        system.debug('FauskeHybridGVLSize R: '+R);
                        system.debug('FauskeHybridGVLSize X0: '+X0);
                        system.debug('FauskeHybridGVLSize P10: '+P10);
                        system.debug('FauskeHybridGVLSize C0: '+C0);
                        system.debug('FauskeHybridGVLSize L0: '+L0);
                        system.debug('FauskeHybridGVLSize PV0_d: '+PV0_d);

                        // Get value of alpha from table "DiscCoef"
                        List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                            FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske Hybrid GVL') LIMIT 1
                                                        ];
                        // Make sure we got response
                        if (!objDiscCoef.isEmpty()) {
                            System.debug('FauskeHybridGVLSize ##############################');
                            KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                            System.debug('KD  : ' + KD);

                            double G =0.0;

                            Result objCommonResult  = FauskeHybridGVLCommon(  P0,  PB,  T0,  PG0,  PV0,  KG,  KV,  MWG,  MWV,R,  X0,  P10,  C0,  L0,  PV0_d);
                            // Make sure we got response
                            if (objCommonResult.bResult != True) {
                                return objCommonResult;
                            } else {
                                G = objCommonResult.dblRetValue;
                                System.debug('G  : ' + G);
                            }

                            objResult.dblRetValue = W / KD / G;
                            System.debug('FauskeHybridGVLSize : ' + string.valueof(objResult.dblRetValue));
                            // Round the result to 6 decimals
                            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                            System.debug('FauskeHybridGVLSize :Rounded ' + string.valueof(objResult.dblRetValue));
                            objResult.bResult = true;
                        } else {
                            objResult.bResult = false;
                            objResult.strErrorMessage = 'No Data Found';
                        }

                    } catch (Exception e) {
                        System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeHybridGVLSize()' + e.getMessage());
                        objResult.bResult = false;
                        objResult.strErrorMessage = e.getMessage();
                    }
                    return objResult;
                }


    // This method returns Capacity for FauskeHybridGVL
    public static Result FauskeHybridGVLCapacity(double P0, double PB, double T0, double PG0, double PV0, double KG, double KV, double MWG, double MWV,
                    double R, double X0, double P10,   double C0,double L0,double PV0_d, Integer nSize, String stPTC, String stSeat,double Ard) {
                        // This object is used to convey back the results of various operations we will end up doing here.
                        Result objResult = new Result();
                        try {
                            // This is a lookup from table "DiscCoef"
                            double KD = 0.0;
                            // This is a lookup from table "MasterBlaster"
                           // double ARD = 0.0;

                            // Get value of ARD from table "RDMasterBlaster__c"
                            // Note: I am creating a sample SOQL Query. Need to replace / correct with actual table,fields and filter clause
                            //List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
                            String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                            List < RDMasterBlaster__c > objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, MNFA__c
                                                                            FROM RDMasterBlaster__c WHERE( PTC__c =: stPTC AND STC__c =: stSeat AND SZC__c =: strSZC AND MNFA__c !=NULL) ORDER BY MNFA__c DESC LIMIT 1//SZC__c =: nSize AND
                                                                            ];

                            // Make sure we got response
                            //CO10************************************************************************
                            // if (!objRDMasterBlaster.isEmpty()) {
                            //     ARD = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
                            // } else {
                            //     objResult.bResult = false;
                            //     objResult.strErrorMessage = 'No Data Found';
                            //     return objResult;
                            // }
                            //###########################################################################
                            result resDistance=unitConversions.convertArea('in2','mm2',ARD);
                            result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                            resDistance=unitConversions.convertArea('mm2','m2',resDistance1.dblRetValue);
                            resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                            ARD=resDistance1.dblRetValue;
                            system.debug('ARD'+ARD);
                            // Get value of alpha from table "DiscCoef"
                            List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske Hybrid GVL') LIMIT 1
                                                            ];
                            // Make sure we got response
                            if (!objDiscCoef.isEmpty()) {
                                System.debug('FauskeHybridGVLCapacity #####################################');
                                KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                                System.debug('KD  : ' + KD);

                                double G =0.0;

                                Result objCommonResult  = FauskeHybridGVLCommon(  P0,  PB,  T0,  PG0,  PV0,  KG,  KV,  MWG,  MWV,R,  X0,  P10,  C0,  L0,  PV0_d);
                                // Make sure we got response
                                if (objCommonResult.bResult != True) {
                                    return objCommonResult;
                                } else {
                                    G = objCommonResult.dblRetValue;
                                    System.debug('G  : ' + G);
                                }

                                objResult.dblRetValue = KD * ARD * G;
                                System.debug('FauskeHybridGVLCapacity : ' + string.valueof(objResult.dblRetValue));
                                // Round the result to 6 decimals
                                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                                System.debug('FauskeHybridGVLCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
                                objResult.bResult = true;
                            } else {
                                objResult.bResult = false;
                                objResult.strErrorMessage = 'No Data Found';
                            }

                        } catch (Exception e) {
                            System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeHybridGVLCapacity()' + e.getMessage());
                            objResult.bResult = false;
                            objResult.strErrorMessage = e.getMessage();
                        }
                        return objResult;
                    }


    public static Result FauskeHybridGVLCommon( double P0, double PB, double T0, double PG0, double PV0, double KG, double KV, double MWG, double MWV,
                double R, double X0, double P10, double C0, double L0, double PV0_d) {
                    // This object is used to convey back the results of various operations we will end up doing here.
                    Result objResult = new Result();
                    try {
                        System.debug('FauskeHybridGVLCommon ########################## ');
                        // System.debug('W : ' + W);System.debug('P0 : ' + P0);System.debug('PB : ' + PB);
                        System.debug('T0 : ' + T0);System.debug('PG0 : ' + PG0);System.debug('PV0 : ' + PV0);
                        System.debug('KG : ' + KG);System.debug('KV : ' + KV);System.debug('MWG : ' + MWG);
                        System.debug('MWV : ' + MWV);System.debug('R : ' + R);System.debug('X0 : ' + X0);
                        System.debug('P10 : ' + P10);System.debug('C0 : ' + C0);System.debug('L0 : ' + L0);
                        System.debug('PV0_d : ' + PV0_d);

                        // Fauske Vapor-Liquid Size formula
                        double MW = MWG*PG0/P0+MWV*PV0/P0;
                        double K = KG * PG0 / P0 + KV * PV0 / P0;
                        //SQRT(2*K7*K18+K20^2*K21^2/(K6*K19)) 2*2080000 *897+ 1,90,61,956 *16.9744 /19,34,138 (0.3562905532416451)  41,00,34,019 0.3562905532416451  167.2917164785553
                        double dem1=(T0 * C0);
                        double num1=MATH.pow(L0, Double.valueOf(2)) * MATH.pow(PV0_d, Double.valueOf(2));
                        double num2=2 * PG0 * P10;
                        System.debug('dem1 : ' + dem1);
                        System.debug('num1 : ' + num1);
                        System.debug('num2 : ' + num2);
                        double GX0_0 = MATH.sqrt(num2 + num1 / dem1);
                        double GX0_1_Crt = P0 * MATH.sqrt(MW / (R * T0)) * MATH.sqrt(K * MATH.pow((2 / (K + 1)), ((K + 1) / (K - 1))));

                        double GX0_1_SubCrt = P0 * MATH.sqrt(MW / (R * T0)) * MATH.sqrt((2 * K / (K - 1)) * MATH.pow((PB / P0), (2 / K)) - MATH.pow((PB / P0), ((K + 1) / (K))));

                        double G = (PB / P0 <= MATH.pow((2 / (K + 1)), (K / (K - 1))) ? 1 / MATH.sqrt((1 - X0) / MATH.pow(GX0_0, Double.valueOf(2)) + X0 / MATH.pow(GX0_1_Crt, Double.valueOf(2))) :
                                    1 / MATH.sqrt((1 - X0) / MATH.pow(GX0_0, Double.valueOf(2)) + X0 / MATH.pow(GX0_1_SubCrt, Double.valueOf(2))));

                        System.debug('GX0_0 : ' + GX0_0);
                        System.debug('GX0_1_Crt : ' + GX0_1_Crt);
                        System.debug(' GX0_1_SubCrt: ' + GX0_1_SubCrt);
                        System.debug('G : ' + G);

                        objResult.dblRetValue = G;
                        System.debug('FauskeHybridGVLCommon : ' + string.valueof(objResult.dblRetValue));
                        objResult.bResult = true;

                    } catch (Exception e) {
                        System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeHybridGVLCommon()' + e.getMessage());
                        objResult.bResult = false;
                        objResult.strErrorMessage = e.getMessage();
                    }
                    return objResult;
                }
    // This method returns Size for Fauske Vapor-Liquid
    public static Result FauskeVaporLiquidSize(double W, double P0, double PB,
                double K, double T0, double MW, double R, double X0, double PV0, double L0, double C0) {
                    // This object is used to convey back the results of various operations we will end up doing here.
                    Result objResult = new Result();
                    try {
                        // This is a lookup from table "DiscCoef"
                        double KD = 0.0;
                        system.debug('FauskeVaporLiquidSize W'+W);
                        system.debug('FauskeVaporLiquidSize P0'+P0);
                        system.debug('FauskeVaporLiquidSize PB'+PB);
                        system.debug('FauskeVaporLiquidSize K'+K);
                        system.debug('FauskeVaporLiquidSize T0'+T0);
                        system.debug('FauskeVaporLiquidSize MW'+MW);
                        system.debug('FauskeVaporLiquidSize R'+R);
                        system.debug('FauskeVaporLiquidSize X0'+X0);
                        system.debug('FauskeVaporLiquidSize PV0'+PV0);
                        system.debug('FauskeVaporLiquidSize L0'+L0);
                        system.debug('FauskeVaporLiquidSize C0'+C0);

                        // Get value of alpha from table "DiscCoef"
                        List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                            FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske Vapor-Liquid') LIMIT 1];
                        // Make sure we got response
                        if (!objDiscCoef.isEmpty()) {
                            KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                            System.debug('KD  : ' + KD);
                            double G = 0.0;

                            Result objCommonResult  = FauskeVaporLiquidCommon( P0, PB, K, T0, MW, R, X0, PV0, L0, C0);
                            // Make sure we got response
                            if (objCommonResult.bResult != True) {
                                return objCommonResult;
                            } else {
                                G = objCommonResult.dblRetValue;
                                System.debug('G  : ' + G);
                            }

                            objResult.dblRetValue = W / KD / G;
                            System.debug('FauskeVaporLiquidSize : ' + string.valueof(objResult.dblRetValue));
                            // Round the result to 6 decimals
                            objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                            System.debug('FauskeVaporLiquidSize :Rounded ' + string.valueof(objResult.dblRetValue));
                            objResult.bResult = true;
                        } else {
                            objResult.bResult = false;
                            objResult.strErrorMessage = 'No Data Found';
                        }

                    } catch (Exception e) {
                        System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeVaporLiquidSize()' + e.getMessage());
                        objResult.bResult = false;
                        objResult.strErrorMessage = e.getMessage();
                    }
                    return objResult;
                }


    // This method returns Capacity for FauskeVaporLiquid
    public static Result FauskeVaporLiquidCapacity(double P0, double PB, double K, double T0, double MW, double R, double X0, double PV0, double L0, double C0,
                    Integer nSize, String stPTC, String stSeat,double Ard) {
                        // This object is used to convey back the results of various operations we will end up doing here.
                        Result objResult = new Result();
                        try {
                            // This is a lookup from table "DiscCoef"
                            double KD = 0.0;
                            // This is a lookup from table "MasterBlaster"
                            //double ARD = 0.0;

                            // Get value of ARD from table "RDMasterBlaster__c"
                            // Note: I am creating a sample SOQL Query. Need to replace / correct with actual table,fields and filter clause
                            // List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
                            String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                            List < RDMasterBlaster__c > objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, MNFA__c
                                                                                FROM RDMasterBlaster__c WHERE( PTC__c =: stPTC AND STC__c =: stSeat AND SZC__c =: strSZC AND MNFA__c !=NULL) ORDER BY MNFA__c DESC LIMIT 1];//SZC__c =: nSize AND

                            // Make sure we got response
                            //CO10************************************************************************
                            // if (!objRDMasterBlaster.isEmpty()) {
                            //     ARD = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
                            // } else {
                            //     objResult.bResult = false;
                            //     objResult.strErrorMessage = 'No Data Found';
                            //     return objResult;
                            // }
                            //###########################################################################
                            result resDistance=unitConversions.convertArea('in2','mm2',ARD);
                            result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                            resDistance=unitConversions.convertArea('mm2','m2',resDistance1.dblRetValue);
                            resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                            ARD=resDistance1.dblRetValue;
                            system.debug('ARD'+ARD);
                            // Get value of alpha from table "DiscCoef"
                            List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske Vapor-Liquid') LIMIT 1];
                            // Make sure we got response
                            if (!objDiscCoef.isEmpty()) {
                                KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);
                                System.debug('KD  : ' + KD);
                                double G = 0.0;

                                Result objCommonResult  = FauskeVaporLiquidCommon(  P0, PB, K, T0, MW, R, X0, PV0, L0, C0);
                                // Make sure we got response
                                if (objCommonResult.bResult != True) {
                                    return objCommonResult;
                                } else {
                                    G = objCommonResult.dblRetValue;
                                    System.debug('G  : ' + G);
                                }

                                objResult.dblRetValue = KD * ARD * G;
                                System.debug('FauskeVaporLiquidCapacity : ' + string.valueof(objResult.dblRetValue));
                                // Round the result to 6 decimals
                                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                                System.debug('FauskeVaporLiquidCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
                                objResult.bResult = true;
                            } else {
                                objResult.bResult = false;
                                objResult.strErrorMessage = 'No Data Found';
                            }

                        } catch (Exception e) {
                            System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeVaporLiquidCapacity()' + e.getMessage());
                            objResult.bResult = false;
                            objResult.strErrorMessage = e.getMessage();
                        }
                        return objResult;
                    }


    public static Result FauskeVaporLiquidCommon( double P0, double PB,
                    double K, double T0, double MW, double R, double X0, double PV0, double L0, double C0) {
                        // This object is used to convey back the results of various operations we will end up doing here.
                        Result objResult = new Result();
                        try {
                            System.debug('FauskeVaporLiquidCommon #################################');
                            // Fauske Vapor-Liquid Size formula
                            double GX0_0 = PV0 * L0 * 1 / MATH.sqrt(T0 * C0);
                            double GX0_1_Crt = P0 * MATH.sqrt(MW / (R * T0)) * MATH.sqrt(K * MATH.pow((2 / (K + 1)), ((K + 1) / (K - 1))));
                            double GX0_1_SubCrt = P0 * MATH.sqrt(MW / (R * T0)) * MATH.sqrt((2 * K / (K - 1)) * MATH.pow((PB / P0), (2 / K)) - MATH.pow((PB / P0), ((K + 1) / (K))));
                            double G = (PB / P0 <= MATH.pow((2 / (K + 1)), (K / (K - 1))) ? 1 / MATH.sqrt((1 - X0) / MATH.pow(GX0_0, Double.valueOf(2)) + X0 / MATH.pow(GX0_1_Crt, Double.valueOf(2))) :
                                        1 / MATH.sqrt((1 - X0) / MATH.pow(GX0_0, Double.valueOf(2)) + X0 / MATH.pow(GX0_1_SubCrt, Double.valueOf(2))));

                            System.debug('GX0_0 : ' + GX0_0);
                            System.debug('GX0_1_Crt : ' + GX0_1_Crt);
                            System.debug(' GX0_1_SubCrt: ' + GX0_1_SubCrt);
                            System.debug('G : ' + G);

                            objResult.dblRetValue = G;
                            System.debug('FauskeVaporLiquidCommon : ' + string.valueof(objResult.dblRetValue));
                            objResult.bResult = true;

                        } catch (Exception e) {
                            System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeVaporLiquidCommon()' + e.getMessage());
                            objResult.bResult = false;
                            objResult.strErrorMessage = e.getMessage();
                        }
                        return objResult;
                    }

    // This method returns Size for Fauske All Liquid Flashing - SATURATED/SUBCOOLED
    public static Result FauskeAllLiquidFlashingSize(double W, double P0, double PB, double T0,
                        double PV0, double R,
                        double C0,double L0, double PV0_d, double P10, boolean isSaturated) {
                            // This object is used to convey back the results of various operations we will end up doing here.
                            Result objResult = new Result();
                            try {
                                // This is a lookup from table "DiscCoef"
                                double KD = 0.0;
                                double G = 0.0;
                                double PG0 = P0-PV0;
                                system.debug('W'+W);
                                system.debug('P0'+P0);
                                system.debug('PB'+PB);
                                system.debug('T0'+T0);
                                system.debug('PG0'+PG0);
                                system.debug('PV0'+PV0);
                                system.debug('R '+R);
                                system.debug('C0 '+C0);
                                system.debug('L0 '+L0);
                                system.debug('PV0_d '+PV0_d);
                                system.debug('P10 '+P10);

                                // Get value of alpha from table "DiscCoef"
                                List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                    FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske All Liquid Flashing') LIMIT 1];
                                system.debug('DiscCoef__c'+objDiscCoef);
                                // Make sure we got response
                                if (!objDiscCoef.isEmpty()) {
                                    KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);

                                    // FauskeAllLiquidFlashing Size formula
                                    if(isSaturated){
                                        G = (PV0_d * L0 * 1) / MATH.sqrt(T0 * C0);
                                    }else{
                                        G = MATH.sqrt(2 * PG0 * P10 + MATH.pow(L0, double.valueOf(2)) * MATH.pow(PV0_d, double.valueOf(2)) / (T0 * C0));
                                    }

                                    System.debug('G : ' + G);

                                    objResult.dblRetValue = W / KD / G;
                                    System.debug('FauskeAllLiquidFlashingSize : ' + string.valueof(objResult.dblRetValue));
                                    // Round the result to 6 decimals
                                    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                                    System.debug('FauskeAllLiquidFlashingize :Rounded ' + string.valueof(objResult.dblRetValue));
                                    objResult.bResult = true;
                                } else {
                                    objResult.bResult = false;
                                    objResult.strErrorMessage = 'No Data Found';
                                }

                            } catch (Exception e) {
                                System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeAllLiquidFlashingSize()' + e.getMessage());
                                objResult.bResult = false;
                                objResult.strErrorMessage = e.getMessage();
                            }
                            return objResult;
                        }


    // This method returns Capacity for FauskeAllLiquidFlashing - SATURATED/SUBCOOLED
    public static Result FauskeAllLiquidFlashingCapacity( double T0,double PV0,
                            double C0,double L0, double PV0_d, double P10, Integer nSize, String stPTC, String stSeat, boolean isSaturated,double P0,double Ard) {
                                // This object is used to convey back the results of various operations we will end up doing here.


                                Result objResult = new Result();
                                try {
                                    // This is a lookup from table "DiscCoef"
                                    double KD = 0.0;
                                    // This is a lookup from table "MasterBlaster"
                                    //double ARD = 0.0;
                                    double G = 0.0;
                                    double PG0 = P0-PV0;
                                    system.debug('P0'+P0);
                                    system.debug('T0'+T0);
                                    system.debug('PG0'+PG0);
                                    system.debug('PV0'+PV0);
                                    //system.debug('R '+R);
                                    system.debug('C0 '+C0);
                                    system.debug('L0 '+L0);
                                    system.debug('PV0_d '+PV0_d);
                                    system.debug('P10 '+P10);
                                    // Get value of ARD from table "RDMasterBlaster__c"
                                    // Note: I am creating a sample SOQL Query. Need to replace / correct with actual table,fields and filter clause
                                    //List < RDMasterBlaster__c > objRDMasterBlaster=new List < RDMasterBlaster__c >();
                                    String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                                    List < RDMasterBlaster__c > objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, MNFA__c
                                                                                    FROM RDMasterBlaster__c WHERE( PTC__c =: stPTC AND STC__c =: stSeat AND SZC__c =: strSZC AND MNFA__c !=NULL) ORDER BY MNFA__c DESC LIMIT 1];//SZC__c =: nSize AND

                                    // Make sure we got response
                                    //CO10************************************************************************
                                    // if (!objRDMasterBlaster.isEmpty()) {
                                    //     ARD = double.valueOf(objRDMasterBlaster.get(0).MNFA__c);
                                    // } else {
                                    //     objResult.bResult = false;
                                    //     objResult.strErrorMessage = 'No Data Found';
                                    //     return objResult;
                                    // }
                                    //###########################################################################
                                    result resDistance=unitConversions.convertArea('in2','mm2',ARD);
                                    result resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                                    resDistance=unitConversions.convertArea('mm2','m2',resDistance1.dblRetValue);
                                    resDistance1=unitConversions.SignificantDigitsNormal(resDistance.dblRetValue, 3, 0);
                                    ARD=resDistance1.dblRetValue;
                                    // Get value of alpha from table "DiscCoef"
                                    List < DiscCoef__c > objDiscCoef = [SELECT Critical_Flow__c, Available_Coeffient_of_Discharge__c
                                                                        FROM DiscCoef__c WHERE(Evaluation__c = 'Fauske All Liquid Flashing') LIMIT 1
                                                                    ];
                                    // Make sure we got response
                                    if (!objDiscCoef.isEmpty()) {
                                        KD = double.valueOf(objDiscCoef.get(0).Available_Coeffient_of_Discharge__c);

                                        // Fauske All Liquid Flashing Capacity formula
                                        if(isSaturated){
                                            G = PV0_d * L0 * 1 / MATH.sqrt(T0 * C0);
                                        }else{
                                            double dem1=(T0 * C0);
                                            double num1=MATH.pow(L0, Double.valueOf(2)) * MATH.pow(PV0_d, Double.valueOf(2));
                                            double num2=2 * PG0 * P10;
                                            System.debug('dem1 : ' + dem1);
                                            System.debug('num1 : ' + num1);
                                            System.debug('num2 : ' + num2);
                                            G = MATH.sqrt(num2 +( num1 / dem1));
                                        }

                                        System.debug('KD  : ' + KD);
                                        System.debug('G : ' + G);
                                        System.debug('ARD : ' + ARD);
                                        objResult.dblRetValue = KD * ARD * G;
                                        System.debug('FauskeAllLiquidFlashingCapacity : ' + string.valueof(objResult.dblRetValue));
                                        // Round the result to 6 decimals
                                        objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6);
                                        System.debug('FauskeAllLiquidFlashingCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
                                        objResult.bResult = true;
                                    } else {
                                        objResult.bResult = false;
                                        objResult.strErrorMessage = 'No Data Found';
                                    }

                                } catch (Exception e) {
                                    System.debug('The following exception has occurred: RDDiscSizingCapacity:FauskeAllLiquidFlashingCapacity()' + e.getMessage());
                                    objResult.bResult = false;
                                    objResult.strErrorMessage = e.getMessage();
                                }
                                return objResult;
                            }
    public static Result VACUUMSize(double W, double P1, double T){
    // This object is used to convey back the results of various operations we will end up doing here.
    Result objResult = new Result();

    try{
    // It is always subcritical flow for vacuum
    String strCriticalFlow='SUBCRITICAL FLOW';
    // Media is always Air. Hardcoded these values unless this condition changes we may pickup from table.
    double P2 = 14.6959;
    double K = 1.4;
    double M = 28.964;
    double Z = 1;
    double Kd= 1;

    // Vacuum Size formula
    double F2 = 0.0, C = 0.0;
    // Subcritical flow
    If(strCriticalFlow == 'SUBCRITICAL FLOW'){
    double dVal = 0.0;
    dVal = ( 1- MATH.pow((P2/P1),((K-1)/K) )) /(1- (P2/P1)  ) ;
    System.debug('dVal : ' + string.valueof(dVal));
    F2 =   MATH.sqrt( (K/(K-1)) * MATH.pow(  (P2/P1), (2/K) )  * dVal  );
    System.debug('F2 : ' + string.valueof(F2));
    // Round the result to 6 decimals
    F2 = unitConversions.RoundNormal(F2, 6) ;
    System.debug('F2 :Rounded ' + string.valueof(F2));
    // Finally calculate the size
    objResult.dblRetValue = W/ (735*F2*Kd) * (MATH.sqrt(Z*T/ (M*P1*(P1-P2)) ));
    }

    System.debug('VACUUMSize : ' + string.valueof(objResult.dblRetValue));
    // Round the result to 6 decimals
    objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
    System.debug('Flow Type: ' +strCriticalFlow);
    System.debug('VACUUMSize :Rounded ' + string.valueof(objResult.dblRetValue));
    }
    catch(Exception e){
    System.debug('The following exception has occurred: RDDiscSizingCapacity:VACUUMSize()' + e.getMessage());
    objResult.bResult = false;
    objResult.strErrorMessage = e.getMessage();
    }
    objResult.bResult = true;
    return objResult;
    }

    // This method returns Caapacity for Vacuum.
    public static Result VACUUMCapacity(double P1, double T,
        integer nSize, String strPTC, String strSeat,string DSCVAR,double VacValue){
            // This object is used to convey back the results of various operations we will end up doing here.
            Result objResult = new Result();

            try{
                // This is a lookup from table "DiscCoef"
                double Ard=0.0 ;
                // It is always subcritical flow for vacuum
                String strCriticalFlow='SUBCRITICAL FLOW';
                // Media is always Air. Hardcoded these values unless this condition changes we may pickup from table.
                double P2 = 14.6959;
                double K = 1.4;
                double M = 28.964;
                double Z = 1;
                double Kd= 1;

                // Get value of Ard from table "RDMasterBlaster"
                //objResult = RDMasterBlaster( nSize,  strPTC,  strSeat);
                String strSZC=ConstantsUtil.getSizeDesc(string.valueOf(nSize)).SZC;
                System.debug('DSCVAR'+DSCVAR);
                System.debug('VacValue'+VacValue);
                System.debug('strPTC'+strPTC);
                System.debug('strPTC'+strSZC);
                System.debug('strPTC'+strSeat);
                List <RDMasterBlaster__c> objRDMasterBlaster = [SELECT SZC__c, PTC__c, STC__c, VMNFA__c
                                                                FROM RDMasterBlaster__c WHERE( PTC__c =: strPTC AND STC__c =: strSeat AND SZC__c =: strSZC AND DSCVAR__c=:DSCVAR AND VACLL__c<=:VacValue and VACUL__c>:VacValue AND VMNFA__c !=NULL) LIMIT 1];
                if(objRDMasterBlaster.isEmpty()) {
                    objResult.bResult = false;
                    return objResult;
                } else
                    Ard = objRDMasterBlaster[0].VMNFA__c;

                System.debug('P1'+P1);
                System.debug('objResult'+objResult);
                System.debug('Ard'+Ard);
                double F2 = 0.0, C = 0.0;
                // Subcritical flow
                If(strCriticalFlow == 'SUBCRITICAL FLOW'){
                    double dVal = 0.0;
                    dVal = ( 1- MATH.pow((P2/P1),((K-1)/K) )) /(1- (P2/P1)  ) ;
                    System.debug('dVal : ' + string.valueof(dVal));
                    F2 =   MATH.sqrt( (K/(K-1)) * MATH.pow(  (P2/P1), (2/K) )  * dVal  );
                    System.debug('F2 : ' + string.valueof(F2));
                    // Round the result to 6 decimals
                    F2 = unitConversions.RoundNormal(F2, 6) ;
                    System.debug('F2 :Rounded ' + string.valueof(F2));
                    // Finally calculate the capacity
                    objResult.dblRetValue = (735 * Ard * F2 * Kd )* (math.sqrt((M*P1*(P1-P2))/ (Z*T)))  ;
                }


                System.debug('VACUUMCapacity : ' + string.valueof(objResult.dblRetValue));
                // Round the result to 6 decimals
                objResult.dblRetValue = unitConversions.RoundNormal(objResult.dblRetValue, 6) ;
                System.debug('Flow Type: ' +strCriticalFlow);
                System.debug('VACUUMCapacity :Rounded ' + string.valueof(objResult.dblRetValue));
            }
            catch(Exception e){
                System.debug('The following exception has occurred: RDDiscSizingCapacity:VACUUMCapacity()' + e.getMessage());
                objResult.bResult = false;
                objResult.strErrorMessage = e.getMessage();
            }
            objResult.bResult = true;
            return objResult;
        }

    }