/**
 * @File Name          : RuptureDiscController.cls
 * @Description        :
 * @Author             : Nikhil Arpally
 * @Group              :
 * @Last Modified By   : Nikhil Arpally
 * @Last Modified On   : 29/5/2020, 2:24:31 pm
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    29/5/2020   Nikhil Arpally     Initial Version
 **/
public with sharing class RuptureDiscController {
    public RuptureDiscController() {}

    //Reorder Purpose Flag
    public static boolean ReorderFlagLWC = false;

    @AuraEnabled(cacheable = true)
    public static List < Product2 > getProductData(String quoteId) {
        String brand = '';
        for (SBQQ__Quote__c qt: [Select Brand__c from SBQQ__Quote__c where Id =: quoteId and Brand__c != null]) {
            brand = qt.Brand__c;
        }
        return [select id, ProductCode, Description, Name, Family from Product2 where IsActive = true and Family =: brand];
    }

    @AuraEnabled
    public static Rupture_Disc__c saveRelief(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Relief_Flag__c = true;
        ruptureDisc.Sizing_Flag__c = true;
        if (ruptureDisc.constrain_product_selection_by_flow__c == 'Yes') {
            ruptureDisc.Edit_QuoteLine__c = true;
        } else {
            ruptureDisc.Edit_QuoteLine__c = false;
        }

        ruptureDisc.Certificate_of_Origin__c = false;
        ruptureDisc.Product_Narrowing_Flag__c = false;
        ruptureDisc.Product_Selection__c = false;

        Result resultConvertPressure = new Result();
        Result resultConvertTemperature = new Result();
        Result resultConvertVaccum = new Result();
        Result resultConvertPositivePressure = new Result();
        Result resultConvertBackPressure = new Result();
        Result resultTempPressure = new Result();

        if (ruptureDisc.Relief_Type__c == 'Pressure Relief') {
            if (ruptureDisc.Pressure_Setting__c != Null && ruptureDisc.Pressure_Setting_Units__c != '') {
                resultConvertPressure = unitConversions.convertPressure(ruptureDisc.Pressure_Setting_Units__c, 'psig', ruptureDisc.Pressure_Setting__c);
                if (resultConvertPressure.bResult)
                    ruptureDisc.Converted_Pressure_Setting__c = resultConvertPressure.dblRetValue;
                else
                {
                    if(!ReorderFlagLWC)
                        throw new AuraHandledException(resultConvertPressure.strErrorMessage);
                }

            }
            if (ruptureDisc.Temperature_Setting__c != Null && ruptureDisc.Temperature_Setting_Units__c != '') {
                resultTempPressure = getConvertedValErrorMsg('Temperature', 1000, -320, 'Deg F', ruptureDisc.Temperature_Setting_Units__c, ruptureDisc.Temperature_Setting__c, 'Temperature Setting');
                if (resultTempPressure.bErrorCheck)
                    throw new AuraHandledException(resultTempPressure.strErrorMessage);
                else {
                    resultConvertTemperature = unitConversions.convertTemperature(ruptureDisc.Temperature_Setting_Units__c, 'Deg F', ruptureDisc.Temperature_Setting__c);
                    if (resultConvertTemperature.bResult)
                        ruptureDisc.Converted_Temperature_Setting__c = resultConvertTemperature.dblRetValue;
                    else
                        throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
                }
            }

            if (ruptureDisc.Back_Pressure_Value__c != Null && ruptureDisc.Back_Pressure_Units__c != '') {
                resultConvertBackPressure = unitConversions.convertPressure(ruptureDisc.Back_Pressure_Units__c, 'psig', ruptureDisc.Back_Pressure_Value__c);
                if (resultConvertBackPressure.bResult)
                    ruptureDisc.Converted_Back_Pressure_Value__c = resultConvertBackPressure.dblRetValue;
                else
                    throw new AuraHandledException(resultConvertBackPressure.strErrorMessage);
            }
        } else if (ruptureDisc.Relief_Type__c == 'Vacuum Relief') {

            if (ruptureDisc.Vacuum_Setting__c != Null && ruptureDisc.Vacuum_Setting_Units__c != '') {
                resultConvertVaccum = unitConversions.convertPressure(ruptureDisc.Vacuum_Setting_Units__c, 'psig', ruptureDisc.Vacuum_Setting__c);
                if (resultConvertVaccum.bResult) {
                    ruptureDisc.Converted_Vacuum_Setting__c = resultConvertVaccum.dblRetValue;
                } else {
                    throw new AuraHandledException(resultConvertVaccum.strErrorMessage);
                }
            }
            if (ruptureDisc.Temperature_Setting__c != Null && ruptureDisc.Temperature_Setting_Units__c != '') {
                resultTempPressure = getConvertedValErrorMsg('Temperature', 1000, -320, 'Deg F', ruptureDisc.Temperature_Setting_Units__c, ruptureDisc.Temperature_Setting__c, 'Temperature Setting');
                if (resultTempPressure.bErrorCheck)
                    throw new AuraHandledException(resultTempPressure.strErrorMessage);
                else {
                    resultConvertTemperature = unitConversions.convertTemperature(ruptureDisc.Temperature_Setting_Units__c, 'Deg F', ruptureDisc.Temperature_Setting__c);
                    if (resultConvertTemperature.bResult)
                        ruptureDisc.Converted_Temperature_Setting__c = resultConvertTemperature.dblRetValue;
                    else
                        throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
                }
            }

            if (ruptureDisc.Positive_Pressure_Value__c != Null && ruptureDisc.Positive_Pressure_Units__c != '') {
                resultConvertPositivePressure = unitConversions.convertPressure(ruptureDisc.Positive_Pressure_Units__c, 'psig', ruptureDisc.Positive_Pressure_Value__c);
                if (resultConvertPositivePressure.bResult) {
                    ruptureDisc.Converted_Positive_Pressure_Value__c = resultConvertPositivePressure.dblRetValue;
                } else {
                    throw new AuraHandledException(resultConvertPositivePressure.strErrorMessage);
                }
            }
        } else {
            if (ruptureDisc.Pressure_Setting__c != Null && ruptureDisc.Pressure_Setting_Units__c != '') {
                resultConvertPressure = unitConversions.convertPressure(ruptureDisc.Pressure_Setting_Units__c, 'psig', ruptureDisc.Pressure_Setting__c);
                if (resultConvertPressure.bResult)
                    ruptureDisc.Converted_Pressure_Setting__c = resultConvertPressure.dblRetValue;
                else
                    throw new AuraHandledException(resultConvertPressure.strErrorMessage);
            }

            if (ruptureDisc.Temperature_Setting__c != Null && ruptureDisc.Temperature_Setting_Units__c != '') {
                resultTempPressure = getConvertedValErrorMsg('Temperature', 1000, -320, 'Deg F', ruptureDisc.Temperature_Setting_Units__c, ruptureDisc.Temperature_Setting__c, 'Temperature Setting');
                if (resultTempPressure.bErrorCheck)
                    throw new AuraHandledException(resultTempPressure.strErrorMessage);
                else {
                    resultConvertTemperature = unitConversions.convertTemperature(ruptureDisc.Temperature_Setting_Units__c, 'Deg F', ruptureDisc.Temperature_Setting__c);
                    if (resultConvertTemperature.bResult)
                        ruptureDisc.Converted_Temperature_Setting__c = resultConvertTemperature.dblRetValue;
                    else
                        throw new AuraHandledException(resultConvertTemperature.strErrorMessage);
                }
            }

            if (ruptureDisc.Vacuum_Setting__c != Null && ruptureDisc.Vacuum_Setting_Units__c != '') {
                if (ruptureDisc.Constrain_product_selection__c != 'Pressure' && ruptureDisc.constrain_product_selection_by_flow__c == 'Yes') {
                    resultTempPressure = getConvertedValErrorMsg('CPSPressure', 2.887328, 0, 'psig', ruptureDisc.Vacuum_Setting_Units__c, ruptureDisc.Vacuum_Setting__c, 'Vaccum Setting');
                }
                if (resultTempPressure.bErrorCheck)
                    throw new AuraHandledException(resultTempPressure.strErrorMessage);
                else {
                    resultConvertVaccum = unitConversions.convertPressure(ruptureDisc.Vacuum_Setting_Units__c, 'psig', ruptureDisc.Vacuum_Setting__c);
                    if (resultConvertVaccum.bResult)
                        ruptureDisc.Converted_Vacuum_Setting__c = resultConvertVaccum.dblRetValue;
                    else
                        throw new AuraHandledException(resultConvertVaccum.strErrorMessage);
                }
            }
        }
        if (!ReorderFlagLWC) {
            ruptureDisc = clearDataBasedOnReliefType(ruptureDisc);
            ruptureDisc = clearSectCCertifications(ruptureDisc);
            ruptureDisc = clearSectDProductNarrowing(ruptureDisc);
            ruptureDisc = clearSectEProductSelection(ruptureDisc);
            ruptureDisc =clearSectFManufacturingRange(ruptureDisc);
            ruptureDisc =clearSectGComponents(ruptureDisc);
            ruptureDisc = clearAllSectBfields(ruptureDisc);
        }

        try {
            update ruptureDisc;
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return ruptureDisc;
    }


    //UNIT Converstions
    public static result getConvertedValErrorMsg(string strConvType, decimal decMaxVal, decimal decMinVal, string strBaseUnits, string strUserUnits, decimal value, string fieldname) {
        result res = new result();
        if (strConvType == 'Temperature') {
            try {
                List < Temparature__c > temp = [select Multiplier__c, Adder__c, Divider__c from Temparature__c where Temperature_UOM_From__c =: strBaseUnits and Temperature_UOM_To__c =: strUserUnits LIMIT 1];
                if (!temp.isEmpty()) {
                    decimal maxVal = ((decMaxVal * temp.get(0).Multiplier__c) + temp.get(0).Adder__c) / temp.get(0).Divider__c;
                    decimal minVal = ((decMinVal * temp.get(0).Multiplier__c) + temp.get(0).Adder__c) / temp.get(0).Divider__c;
                    if (value <= minVal || value > maxVal) {
                        res.bResult = true;
                        res.bErrorCheck = true;
                        //res.strErrorMessage=fieldname+' : Please enter valid value between '+minVal.setScale(2)+' '+strUserUnits+' and '+maxVal.setScale(2)+' '+strUserUnits;
                        res.strErrorMessage = fieldname + ' : Temperature Setting must be Greater than ' + minVal.setScale(2) + ' ' + strUserUnits + ' and less than ' + maxVal.setScale(2) + ' ' + strUserUnits;
                    } else {
                        res.bResult = true;
                        res.bErrorCheck = false;
                    }
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue = 0;
                System.debug(res.strErrorMessage);
            }
        } else if (strConvType == 'RelTemperature') {
            try {
                List < Temparature__c > temp = [select Multiplier__c, Adder__c, Divider__c from Temparature__c where Temperature_UOM_From__c =: strBaseUnits and Temperature_UOM_To__c =: strUserUnits LIMIT 1];
                if (!temp.isEmpty()) {
                    decimal maxVal = ((decMaxVal * temp.get(0).Multiplier__c) + temp.get(0).Adder__c) / temp.get(0).Divider__c;
                    decimal minVal = ((decMinVal * temp.get(0).Multiplier__c) + temp.get(0).Adder__c) / temp.get(0).Divider__c;
                    if (value <= minVal) {
                        res.bResult = true;
                        res.bErrorCheck = true;
                        //res.strErrorMessage=fieldname+' : Please enter valid value between '+minVal.setScale(2)+' '+strUserUnits+' and '+maxVal.setScale(2)+' '+strUserUnits;
                        res.strErrorMessage = fieldname + ' : Temperature Setting must be Greater than ' + minVal.setScale(2) + ' ' + strUserUnits;
                    } else {
                        res.bResult = true;
                        res.bErrorCheck = false;
                    }
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue = 0;
                System.debug(res.strErrorMessage);
            }
        } else if (strConvType == 'CPSPressure') {
            try {
                List < Pressure__c > pressure = [select Multiplier__c, Adder__c from Pressure__c where Pressure_UOM_From__c =: strBaseUnits and Pressure_UOM_To__c =: strUserUnits LIMIT 1];
                decimal maxVal = (decMaxVal * pressure.get(0).Multiplier__c) + pressure.get(0).Adder__c;
                decimal minVal = (decMinVal * pressure.get(0).Multiplier__c) + pressure.get(0).Adder__c;
                Result res1;
                Result res2;
                res1 = unitConversions.SignificantDigitsUp(minVal, 4, -99);
                decimal minvalmsg = res1.dblRetValue;
                res2 = unitConversions.SignificantDigitsDown(maxVal, 4, -99);
                decimal maxvalmsg = res2.dblRetValue;

                if (value < minVal || value > maxVal) {
                    res.bResult = true;
                    res.bErrorCheck = true;
                    res.strErrorMessage = fieldname + ' : Cannot constrain product selection in Vacuum direction when vacuum > ' + maxvalmsg + ' ' + strUserUnits;
                } else {
                    res.bResult = true;
                    res.bErrorCheck = false;
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue = 0;
                System.debug(res.strErrorMessage);
            }
        } else if (strConvType == 'Pressure') {
            try {
                List < Pressure__c > pressure = [select Multiplier__c, Adder__c from Pressure__c where Pressure_UOM_From__c =: strBaseUnits and Pressure_UOM_To__c =: strUserUnits LIMIT 1];
                decimal maxVal = (decMaxVal * pressure.get(0).Multiplier__c) + pressure.get(0).Adder__c;
                decimal minVal = (decMinVal * pressure.get(0).Multiplier__c) + pressure.get(0).Adder__c;
                Result res1;
                Result res2;
                res1 = unitConversions.SignificantDigitsUp(minVal, 4, -99);
                decimal minvalmsg = res1.dblRetValue;
                res2 = unitConversions.SignificantDigitsDown(maxVal, 4, -99);
                decimal maxvalmsg = res2.dblRetValue;

                if (value < minVal || value > maxVal) {
                    res.bResult = true;
                    res.bErrorCheck = true;
                    res.strErrorMessage = fieldname + ' : Please enter value less than ' + maxvalmsg + ' ' + strUserUnits;
                } else {
                    res.bResult = true;
                    res.bErrorCheck = false;
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue = 0;
                System.debug(res.strErrorMessage);
            }
        } else if (strConvType == 'RelievingPressure') {
            try {
                List < Pressure__c > pressure = [select Multiplier__c, Adder__c from Pressure__c where Pressure_UOM_From__c =: strBaseUnits and Pressure_UOM_To__c =: strUserUnits LIMIT 1];
                decimal maxVal = (decMaxVal * pressure.get(0).Multiplier__c) + pressure.get(0).Adder__c;
                decimal minVal = (decMinVal * pressure.get(0).Multiplier__c) + pressure.get(0).Adder__c;
                Result res1;
                Result res2;
                res1 = unitConversions.SignificantDigitsUp(minVal, 4, -99);
                decimal minvalmsg = res1.dblRetValue;
                res2 = unitConversions.SignificantDigitsDown(maxVal, 4, -99);
                decimal maxvalmsg = res2.dblRetValue;

                if (value > maxVal) {
                    res.bResult = true;
                    res.bErrorCheck = true;
                    res.strErrorMessage = fieldname + ' : The Pressure Setting is above the ASME Steam limit of ' + maxvalmsg + ' ' + strUserUnits + '.';
                } else if (value < minVal) {
                    res.bResult = true;
                    res.bErrorCheck = true;
                    res.strErrorMessage = fieldname + ' : The Pressure Setting is below the limit of ' + minvalmsg + ' ' + strUserUnits + '.';
                } else {
                    res.bResult = true;
                    res.bErrorCheck = false;
                }
            } catch (Exception e) {
                System.debug('The following exception has occurred: unitConversions:getConvertedValErrorMsg()' + e.getMessage());
                res.bResult = false;
                res.dblRetValue = 0;
                System.debug(res.strErrorMessage);
            }
        }
        return res;
    }

    @AuraEnabled
    public static RDDMWrapper saveCertificate(Rupture_Disc__c ruptureDisc) {
        RDDMWrapper rddmWrapper = new RDDMWrapper();
        ruptureDisc.Relief_Flag__c = true;
        ruptureDisc.Sizing_Flag__c = false;
        ruptureDisc.Certificate_of_Origin__c = true;
        ruptureDisc.Product_Narrowing_Flag__c = false;
        ruptureDisc.Product_Selection__c = false;
        ruptureDisc.Edit_QuoteLine__c = false;

        if (!ReorderFlagLWC) {
            ruptureDisc = clearSectDProductNarrowing(ruptureDisc);
            ruptureDisc = clearSectEProductSelection(ruptureDisc);
            ruptureDisc =clearSectFManufacturingRange(ruptureDisc);
            ruptureDisc =clearSectGComponents(ruptureDisc);
        }

        try {
            update ruptureDisc;
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        rddmWrapper.ruptDisc = ruptureDisc;
        rddmWrapper.selOptions = getDiscMaterial();
        return rddmWrapper;
    }

    public static Map < String, String > getMaterialConstruction() {
        Map < string, string > mapMat = new Map < string, string > ();
        for (RD_GeneralMaterialsList__c objCS: [select MatlCode__c, Matl__c from RD_GeneralMaterialsList__c]) {
            if (!mapMat.containsKey(objCS.MatlCode__c))
                mapMat.put(objCS.MatlCode__c, objCS.Matl__c);
        }
        return mapMat;
    }

    @AuraEnabled
    public static list < SelectOption > getDiscMaterial() {
        list < SelectOption > options = new List < SelectOption > ();
        AggregateResult[] aggResult = [SELECT MatlCodePos__c, count(id) FROM RDMasterBlaster__c GROUP BY MatlCodePos__c];
        //Schema.DescribeFieldResult fieldResult = Rupture_Disc__c.Disc_Material_of_Construction__c.getDescribe();
        //List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map < string, string > myMap = getMaterialConstruction();
        //for( Schema.PicklistEntry pickListVal : ple)
        //myMap.put(pickListVal.getValue(),pickListVal.getLabel());
        options.add(new SelectOption('', ''));
        for (AggregateResult ar: aggResult) {
            if (ar.get('MatlCodePos__c') == '-') {}
            //options.add(new SelectOption('-','-'));
            else {
                String mtCd = (String) ar.get('MatlCodePos__c');
                // if(mtCd.length() == 3){
                // String finalMTCD = mtCd.removeStart('0');
                // options.add(new SelectOption((String) ar.get('MatlCodePos__c'),myMap.get(finalMTCD)));
                // } else {
                options.add(new SelectOption(mtCd, (String) myMap.get(mtCd)));
                //}
            }
        }
        return options;
    }

    public class RDDMWrapper {
        @AuraEnabled public Rupture_Disc__c ruptDisc {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > selOptions {
            get;
            set;
        }
        public RDDMWrapper() {
            this.ruptDisc = ruptDisc;
            this.selOptions = selOptions;
        }
    }

    public class ConnectedCallBackWrapper {
        @AuraEnabled public Boolean navToProdCheck {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > selOptions {
            get;
            set;
        }
        public ConnectedCallBackWrapper() {
            this.navToProdCheck = navToProdCheck;
            this.selOptions = selOptions;
        }
    }

    @AuraEnabled
    public static ConnectedCallBackWrapper connectedCallBackMethod(String ruptId) {
        ConnectedCallBackWrapper connCallWrp = new ConnectedCallBackWrapper();
        connCallWrp.selOptions = getDiscMaterial();
        connCallWrp.navToProdCheck = navToProdSelPage(ruptId);
        return connCallWrp;
    }

    @AuraEnabled
    public static boolean navToProdSelPage(String ruptId) {
        boolean navToProdSel = true;
        Rupture_Disc__c ruptureDisc = [Select Id, Product__c, Seat__c, Size__c FROM Rupture_Disc__c where Id =: ruptId]; //, Size_Units__c
        if (String.isNotBlank(ruptureDisc.Product__c) && String.isNotBlank(ruptureDisc.Size__c) && String.isNotBlank(ruptureDisc.Seat__c)) { //&& String.isNotBlank(ruptureDisc.Size_Units__c)
            navToProdSel = false;
        }
        return navToProdSel;
    }

    public static string matlCodeProcessor(string key) {
        string ky1;
        if (key.length() == 1)
            ky1 = '00' + key;
        else if (key.length() == 2)
            ky1 = '0' + key;
        else
            ky1 = key;
        return ky1;
    }

    public static Map < string, List < Derate_Value__c >> mapDerateValues(decimal tempVal) {
        Map < string, List < Derate_Value__c >> newMap = new Map < string, List < Derate_Value__c >> ();
        system.debug('**** SELECT Id, Derate__c, DerateType__c, TempUL__c, TempLL__c, MatlCode__c FROM Derate_Value__c WHERE TempLL__c<=' + tempVal + ' AND TempUL__c>' + tempVal);
        Derate_Value__c[] derateList = Database.query('SELECT Id, Derate__c, DerateType__c, TempUL__c, TempLL__c, MatlCode__c FROM Derate_Value__c WHERE TempLL__c<=' + tempVal + ' AND TempUL__c>' + tempVal);
        Set < String > uniqueKey = new Set < String > ();
        for (Derate_Value__c dt: derateList) {
            string key = matlCodeProcessor(dt.MatlCode__c + '') + dt.DerateType__c;
            if (uniqueKey.add(key)) {
                List < Derate_Value__c > dtl = new List < Derate_Value__c > ();
                dtl.add(dt);
                newMap.put(key, dtl);
            } else {
                newMap.get(key).add(dt);
            }
        }
        return newMap;
    }

    public class RDMBWrapper {
        @AuraEnabled public List < SelectOption > prodOptions {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > seatOptions {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > sizeOptions {
            get;
            set;
        }
        @AuraEnabled public List < RDOptions > rdOptions {
            get;
            set;
        }
        public RDMBWrapper() {
            this.prodOptions = prodOptions;
            this.seatOptions = seatOptions;
            this.sizeOptions = sizeOptions;
            this.rdOptions = rdOptions;
        }
    }

    @AuraEnabled(cacheable = true)
    public static RDMBWrapper getRDMasterIDs(Rupture_Disc__c ruptureDisc, String rupRecordId) {
        RDMBWrapper rdmbWrap = new RDMBWrapper();
        List < id > rdMasterIDs = new List < Id > ();
        ruptureDisc = [Select Id, Relief_Type__c, Product__c, Seat__c, Size__c, Converted_Pressure_Setting__c, Converted_Temperature_Setting__c, Converted_Vacuum_Setting__c FROM Rupture_Disc__c where Id =: rupRecordId];
        try {
            if (ruptureDisc != NULL) {
                boolean derateCheck = ruptureDisc.Converted_Temperature_Setting__c >= 65 && ruptureDisc.Converted_Temperature_Setting__c < 75;
                Map < string, List < Derate_Value__c >> mapDetValues = new Map < string, List < Derate_Value__c >> ();
                //  if(!derateCheck)
                mapDetValues = mapDerateValues(ruptureDisc.Converted_Temperature_Setting__c);
                List < RDMasterBlaster__c > lstRDMS = rDMBRecords(ruptureDisc, rupRecordId);
                for (RDMasterBlaster__c localRDM: lstRDMS) {
                    string key = matlCodeProcessor(localRDM.MatlCodePos__c) + localRDM.DerateType__c;
                    decimal deratevalue = 1;
                    decimal brustPressure = 0;
                    if (localRDM.PTC__c != 'CAL')
                        brustPressure = ruptureDisc.Converted_Pressure_Setting__c;
                    else
                        brustPressure = ruptureDisc.Converted_Vacuum_Setting__c;
                    // if(!derateCheck) {
                    if (localRDM.PTC__c != 'PAS' && localRDM.PTC__c != 'CAL') {
                        if (mapDetValues.containsKey(key)) {
                            // Derate_Value__c dvalue=filterDerateValue(mapDetValues.get(key),ruptureDisc.Converted_Temperature_Setting__c);
                            deratevalue = mapDetValues.get(key)[0].Derate__c;
                        }
                        if (localRDM.Derate_EQN__c == 'METL' || localRDM.Derate_EQN__c == 'COMM') {
                            brustPressure = brustPressure / deratevalue;
                        } else if (localRDM.Derate_EQN__c == 'COMA') {
                            decimal MetAlum = 0;
                            string strMetlAlum = '001' + localRDM.DerateType__c;
                            // Derate_Value__c Metldvalue=filterDerateValue(mapDetValues.get(strMetlAlum),ruptureDisc.Converted_Temperature_Setting__c);
                            if (mapDetValues.containsKey(strMetlAlum))
                                MetAlum = mapDetValues.get(strMetlAlum)[0].Derate__c;
                            brustPressure = 2 * brustPressure / (deratevalue + MetAlum);
                        } else if (localRDM.Derate_EQN__c == 'COMT') {
                            string strMetlAlum = '001' + localRDM.DerateType__c;
                            decimal TefDer = 1;
                            // Derate_Value__c Metldvalue=filterDerateValue(mapDetValues.get(strMetlAlum),ruptureDisc.Converted_Temperature_Setting__c);
                            string strTef = '070' + localRDM.DerateType__c;
                            // Derate_Value__c TefDervalue=filterDerateValue(mapDetValues.get(strTef),ruptureDisc.Converted_Temperature_Setting__c);
                            //decimal MetAlum=mapDetValues.get(strMetlAlum)[0].Derate__c;
                            if (mapDetValues.containsKey(strTef))
                                TefDer = mapDetValues.get(strTef)[0].Derate__c;
                            brustPressure = brustPressure - (TefDer * localRDM.Teflon_Ambient__c) / deratevalue;
                            brustPressure += localRDM.Teflon_Ambient__c;
                            //localRDM.Teflon_Ambient__c;
                        } else {

                        }
                        //}
                    }
                    if (localRDM.PTC__c != 'CAL') {
                        if (localRDM.PressLL__c <= brustPressure && localRDM.PressUL__c > brustPressure) {
                            rdMasterIDs.add(localRDM.id);
                        } else {
                            system.debug('brustPressure  Excluded' + brustPressure + '-->>> PTC' + localRDM.PTC__c + ' --> Seat' + localRDM.STC__c + ' Size-->' + localRDM.SZC__c);
                        }
                    } else {
                        if (localRDM.VacLL__c <= brustPressure && localRDM.VacUL__c > brustPressure) {
                            rdMasterIDs.add(localRDM.id);
                        } else {
                            system.debug('brustPressure  Excluded' + brustPressure + '-->>> PTC' + localRDM.PTC__c + ' --> Seat' + localRDM.STC__c + ' Size-->' + localRDM.SZC__c);
                        }
                    }

                }
            }
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        Map < String, List < SelectOption >> mapVls = getConsolidatedPicklistValues(ruptureDisc, rupRecordId, rdMasterIDs);
        rdmbWrap.prodOptions = mapVls.get('PTC');
        rdmbWrap.seatOptions = mapVls.get('STC');
        rdmbWrap.sizeOptions = mapVls.get('SZC');
        //rdmbWrap.rdOptions = getRupDiscRecords(ruptureDisc,rupRecordId,rdMasterIDs);
        return rdmbWrap;
    }
    @AuraEnabled
    public static Rupture_Disc__c saveProductNarrowing(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Relief_Flag__c = true;
        ruptureDisc.Sizing_Flag__c = false;
        ruptureDisc.Certificate_of_Origin__c = false;
        ruptureDisc.Product_Narrowing_Flag__c = true;
        ruptureDisc.Product_Selection__c = false;
        ruptureDisc.Edit_QuoteLine__c = false;

        if (!ReorderFlagLWC) {
            ruptureDisc = clearSectEProductSelection(ruptureDisc);
            ruptureDisc =clearSectFManufacturingRange(ruptureDisc);
            ruptureDisc =clearSectGComponents(ruptureDisc);
        }

        try {
            ruptureDisc.Bypass__c = false;
            update ruptureDisc;
            if (ruptureDisc != NULL) {
                List < RDMasterBlaster__c > lstRDMS = rDMBRecords(ruptureDisc, ruptureDisc.Id);
                if (lstRDMS.size() < 1) {
                    throw new AuraHandledException('No Product Found for a given Configuration');
                }
                //MatlCodeVac__c, MatlCodePos__c, PressUL__c, PressLL__c, VacUL__c, VacLL__c, DerateType__c, Derate_EQN__c,

            }
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return ruptureDisc;
    }

    public static Derate_Value__c filterDerateValue(Derate_Value__c[] lsDerate, decimal Temp) {
        Derate_Value__c dt = new Derate_Value__c();
        for (Derate_Value__c d: lsDerate) {
            if (d.TempUL__c > Temp && d.TempLL__c <= Temp) {
                dt = d;
                break;
            }
        }
        return dt;
    }

    @AuraEnabled(cacheable = true)
    public static List < SelectOption > mediaTypesPickValues(Rupture_Disc__c ruptureDisc) {
        List < selectOption > options = new List < selectOption > ();
        options.add(new selectOption('', ''));
        //options.add(new selectOption('Customer Specified','Customer Specified'));
        if (ruptureDisc != null && ruptureDisc.Evaluation_Per__c != null) {
            String mediaTy;
            if (ruptureDisc.Evaluation_Per__c == 'ASME Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'API Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ISO Gas/Vapor') {
                options.add(new selectOption('Customer Specified', 'Customer Specified'));
                mediaTy = 'Gas/Vapor';
            } else if (ruptureDisc.Evaluation_Per__c == 'ISO Liquid' || ruptureDisc.Evaluation_Per__c == 'API Liquid') {
                options.add(new selectOption('Customer Specified', 'Customer Specified'));
                mediaTy = 'Liquid';
            } else if (ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske All Liquid Flashing' || ruptureDisc.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing' || ruptureDisc.Evaluation_Per__c == 'API Omega Method Subcooled Liquid') {
                options.add(new selectOption('Customer Specified', 'Customer Specified'));
                mediaTy = 'None';
            } else if (ruptureDisc.Evaluation_Per__c == 'ASME Steam' || ruptureDisc.Evaluation_Per__c == 'API Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Dry Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Wet Steam') {
                mediaTy = 'Dry and Saturated Steam*Dry and Saturated or Superheated Steam*Homogenous Wet Steam of Dryness 90% and Over';
            } else if (ruptureDisc.Evaluation_Per__c == 'ASME Water') {
                options.add(new SelectOption('Water', 'Water'));
                mediaTy = 'None';
            } else {
                mediaTy = '';
            }
            System.debug('MEdia Check mediaTy' + ruptureDisc.Evaluation_Per__c);
            List < Media_Property__c > mediaPropertyList = [select Media_Phase__c, Media__c from Media_Property__c where Media_Phase__c =: mediaTy];
            for (Media_Property__c mP: mediaPropertyList) {
                options.add(new SelectOption(mP.Media__c, mP.Media__c));
            }
        }
        return options;
    }

    public static List < SelectOption > optsGasFlowRate() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(' ', '--- None ---'));
        options.add(new SelectOption('ACFH', 'ACFH'));
        options.add(new SelectOption('ACFM', 'ACFM'));
        options.add(new SelectOption('Am3/h', 'Am3/h'));
        options.add(new SelectOption('Am3/min', 'Am3/min'));
        options.add(new SelectOption('kg/h', 'kg/h'));
        options.add(new SelectOption('kg/min', 'kg/min'));
        options.add(new SelectOption('lb/h', 'lb/h'));
        options.add(new SelectOption('lb/min', 'lb/min'));
        options.add(new SelectOption('Nm3/h', 'Nm3/h'));
        options.add(new SelectOption('Nm3/min', 'Nm3/min'));
        options.add(new SelectOption('SCFH', 'SCFH'));
        options.add(new SelectOption('SCFM', 'SCFM'));
        options.add(new SelectOption('SCMH', 'SCMH'));
        return options;
    }

    public static List < SelectOption > optsLiquidFlowRate() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(' ', '--- None ---'));
        options.add(new SelectOption('(Imperial) gallon/h', '(Imperial) gallon/h'));
        options.add(new SelectOption('(Imperial) gallon/min', '(Imperial) gallon/min'));
        options.add(new SelectOption('(U.S.) gallon/h', '(U.S.) gallon/h'));
        options.add(new SelectOption('(U.S.) gallon/min', '(U.S.) gallon/min'));
        options.add(new SelectOption('barrel/h', 'barrel/h'));
        options.add(new SelectOption('ft3/h', 'ft3/h'));
        options.add(new SelectOption('ft3/min', 'ft3/min'));
        options.add(new SelectOption('kg/h', 'kg/h'));
        options.add(new SelectOption('kg/min', 'kg/min'));
        options.add(new SelectOption('L/h', 'L/h'));
        options.add(new SelectOption('L/min', 'L/min'));
        options.add(new SelectOption('lb/h', 'lb/h'));
        options.add(new SelectOption('lb/min', 'lb/min'));
        options.add(new SelectOption('m3/h', 'm3/h'));
        options.add(new SelectOption('m3/min', 'm3/min'));
        return options;
    }

    public static List < SelectOption > optsStreamFlowRate() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(' ', '--- None ---'));
        options.add(new SelectOption('kg/h', 'kg/h'));
        options.add(new SelectOption('kg/min', 'kg/min'));
        options.add(new SelectOption('lb/h', 'lb/h'));
        options.add(new SelectOption('lb/min', 'lb/min'));
        return options;
    }

    public static List < SelectOption > optsAPIOmegaFlowRate() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(' ', '--- None ---'));
        options.add(new SelectOption('(Imperial) gallon/h', '(Imperial) gallon/h'));
        options.add(new SelectOption('(Imperial) gallon/min', '(Imperial) gallon/min'));
        options.add(new SelectOption('(U.S.) gallon/h', '(U.S.) gallon/h'));
        options.add(new SelectOption('(U.S.) gallon/min', '(U.S.) gallon/min'));
        options.add(new SelectOption('barrel/h', 'barrel/h'));
        options.add(new SelectOption('ft3/h', 'ft3/h'));
        options.add(new SelectOption('ft3/min', 'ft3/min'));
        options.add(new SelectOption('L/h', 'L/h'));
        options.add(new SelectOption('L/min', 'L/min'));
        options.add(new SelectOption('m3/h', 'm3/h'));
        options.add(new SelectOption('m3/min', 'm3/min'));
        return options;
    }

    public static List < SelectOption > optsFauskeFlowRate() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(' ', '--- None ---'));
        options.add(new SelectOption('kg/h', 'kg/h'));
        options.add(new SelectOption('kg/min', 'kg/min'));
        options.add(new SelectOption('kg/s', 'kg/s'));
        options.add(new SelectOption('lb/h', 'lb/h'));
        options.add(new SelectOption('lb/min', 'lb/min'));
        return options;
    }

    @AuraEnabled(cacheable = true)
    public static List < SelectOption > requiredFlowRateUnitsPicklist(Rupture_Disc__c ruptureDisc) {
        List < selectOption > options = new List < selectOption > ();
        if (ruptureDisc != null && ruptureDisc.Evaluation_Per__c != null) {
            if (ruptureDisc.Evaluation_Per__c == 'ASME Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'API Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ISO Gas/Vapor') {
                for (SelectOption eachOpt: optsGasFlowRate()) {
                    options.add(eachOpt);
                }
            } else if (ruptureDisc.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing' || ruptureDisc.Evaluation_Per__c == 'API Omega Method Subcooled Liquid') {
                for (SelectOption eachOpt: optsAPIOmegaFlowRate()) {
                    options.add(eachOpt);
                }
            } else if (ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske All Liquid Flashing') {
                for (SelectOption eachOpt: optsFauskeFlowRate()) {
                    options.add(eachOpt);
                }
            } else if (ruptureDisc.Evaluation_Per__c == 'ISO Liquid' || ruptureDisc.Evaluation_Per__c == 'ASME Water' || ruptureDisc.Evaluation_Per__c == 'API Liquid') {
                for (SelectOption eachOpt: optsLiquidFlowRate()) {
                    options.add(eachOpt);
                }
            } else if (ruptureDisc.Evaluation_Per__c == 'ASME Steam' || ruptureDisc.Evaluation_Per__c == 'API Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Dry Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Wet Steam') {
                for (SelectOption eachOpt: optsStreamFlowRate()) {
                    options.add(eachOpt);
                }
            }
        }
        return options;
    }

    @AuraEnabled(cacheable = true)
    public static List < SelectOption > coefficientOfDischargePicklistValues(Rupture_Disc__c ruptureDisc) {
        List < selectOption > options = new List < selectOption > ();
        if (ruptureDisc != null && ruptureDisc.Evaluation_Per__c != null) {
            if (ruptureDisc.Evaluation_Per__c == 'ASME Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ASME Water' || ruptureDisc.Evaluation_Per__c == 'ASME Steam' ||
                ruptureDisc.Evaluation_Per__c == 'API Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'API Liquid' || ruptureDisc.Evaluation_Per__c == 'API Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Liquid' ||
                ruptureDisc.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing' || ruptureDisc.Evaluation_Per__c == 'API Omega Method Subcooled Liquid' ||
                ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske All Liquid Flashing') {
                options.add(new SelectOption('0.62', '0.62'));
            } else if (ruptureDisc.Evaluation_Per__c == 'ISO Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ISO Dry Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Wet Steam') {
                options.add(new SelectOption('0.68', '0.68'));
                options.add(new SelectOption('0.73', '0.73'));
                options.add(new SelectOption('0.80', '0.80'));
            }
        }
        return options;
    }

    public class EvalPerChangePicklistRDWrapper {
        @AuraEnabled public List < SelectOption > mediaPicklist {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > requiredFlowUnitsPicklist {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > coefficientOfDischargePicklist {
            get;
            set;
        }
        public EvalPerChangePicklistRDWrapper() {
            this.mediaPicklist = mediaPicklist;
            this.requiredFlowUnitsPicklist = requiredFlowUnitsPicklist;
            this.coefficientOfDischargePicklist = coefficientOfDischargePicklist;
        }
    }

    @AuraEnabled
    public static EvalPerChangePicklistRDWrapper imperativeMediaTypesPickValues(Rupture_Disc__c ruptureDisc) {
        EvalPerChangePicklistRDWrapper EPCWrapper = new EvalPerChangePicklistRDWrapper();
        EPCWrapper.mediaPicklist = mediaTypesPickValues(ruptureDisc);
        EPCWrapper.requiredFlowUnitsPicklist = requiredFlowRateUnitsPicklist(ruptureDisc);
        EPCWrapper.coefficientOfDischargePicklist = coefficientOfDischargePicklistValues(ruptureDisc);
        return EPCWrapper;
    }

    @AuraEnabled
    public static RuptureDiscWrapper mediaPropertyOnProcessMedia(Rupture_Disc__c ruptureDisc) {
        boolean disableMediaValues = false;
        if (ruptureDisc != null && ruptureDisc.Process_Media__c != null) {
            List < Media_Property__c > mD = [select Media__c, Media_Phase__c, MolecularWeight__c, SpecificHeatRatio__c, Density__c, CompressFactor__c from Media_Property__c where Media__c =: ruptureDisc.Process_Media__c];
            if (!mD.isEmpty()) {
                ruptureDisc.Customer_Specified_Media__c = mD.get(0).Media__c;
                ruptureDisc.Molecular_Weight__c = mD.get(0).MolecularWeight__c;
                ruptureDisc.Compressibility_Factor__c = mD.get(0).CompressFactor__c;
                ruptureDisc.Ratio_of_Specific_Heats__c = mD.get(0).SpecificHeatRatio__c;
                disableMediaValues = true;
            } else {
                disableMediaValues = false;
            }
        }
        return new RuptureDiscWrapper(ruptureDisc, disableMediaValues);
    }

    public class SelectOption {
        public SelectOption(String value, String label) {
            this.value = value;
            this.label = label;
            this.disabled = false;
            this.escapeItem = false;
        }

        @AuraEnabled public String label {
            get;
            set;
        }
        @AuraEnabled public String value {
            get;
            set;
        }
        @AuraEnabled public Boolean disabled {
            get;
            set;
        }
        @AuraEnabled public Boolean escapeItem {
            get;
            set;
        }

    }

    public class RuptureDiscWrapper {
        @AuraEnabled public Rupture_Disc__c ruptureDisc {
            get;
            set;
        }
        @AuraEnabled public boolean disableMediaValues {
            get;
            set;
        }
        public RuptureDiscWrapper(Rupture_Disc__c ruptureDisc, boolean disableMediaValues) {
            this.ruptureDisc = ruptureDisc;
            this.disableMediaValues = disableMediaValues;
        }
    }

    public static List < QuoteLineWrapper > getQLDetails(String quoteId, String quoteLineId) {

        User userInfo = [SELECT ContactId, Profile.Name, IsPortalEnabled, ProfileId FROM user WHERE Id =: UserInfo.getUserId()];
        List < QuoteLineWrapper > wrapperObjList = new List < QuoteLineWrapper > ();
        List < SBQQ__QuoteLine__c > qlDetails = new List < SBQQ__QuoteLine__c > ();
        String dynamicQuery;
        QuoteLineWrapper wrapperObj;

        if (quoteId == null && quoteLineId == null) {

            return wrapperObjList;
        }

        dynamicQuery = 'SELECT Id,SBQQ__Quote__c, Name, SBQQ__Product__c, SBQQ__Discount__c,' +
            ' SBQQ__ProductName__c, SBQQ__ProductCode__c, SBQQ__Quantity__c, LastModifiedDate, ' +
            ' SBQQ__Product__r.Name, SBQQ__Quote__r.Name, Engineering_Status__c, ' +
            ' Product_Planning_Status__c,' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM BGR__r),' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM Rupture_Discs__r),' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM Relief_Valves__r),' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM Flame_Products__r),' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM Holders__r),' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM WasteGasBurners__r),' +
            ' (SELECT Id, Name, Discountable_Price__c, Non_Discountable_Price__c, Size__c, Part_Number__c FROM Part_Selectors__r) ' +
            ' FROM SBQQ__QuoteLine__c ';

        if (quoteLineId != null) {

            dynamicQuery += ' WHERE Id = :quoteLineId ';

        } else if (quoteId != null) {

            dynamicQuery += ' WHERE SBQQ__Quote__c = :quoteId ORDER BY LastModifiedDate ';
        }
        for (SBQQ__QuoteLine__c q: Database.query(dynamicQuery)) {

            if (q.SBQQ__ProductCode__c == 'BGR') {

                if (q.BGR__r != null && q.BGR__r.size() > 0)
                    wrapperObj = new QuoteLineWrapper(q, q.BGR__r[0], userInfo);

            } else if (q.SBQQ__ProductCode__c == 'RD') {

                if (q.Rupture_Discs__r != null && q.Rupture_Discs__r.size() > 0)
                    wrapperObj = new quoteLineWrapper(q, q.Rupture_Discs__r[0], userInfo);

            } else if (q.SBQQ__ProductCode__c == 'RLFVLV') {

                if (q.Relief_Valves__r != null && q.Relief_Valves__r.size() > 0)
                    wrapperObj = new quoteLineWrapper(q, q.Relief_Valves__r[0], userInfo);

            } else if (q.SBQQ__ProductCode__c == 'FlameProducts') {

                if (q.Flame_Products__r != null && q.Flame_Products__r.size() > 0)
                    wrapperObj = new quoteLineWrapper(q, q.Flame_Products__r[0], userInfo);

            } else if (q.SBQQ__ProductCode__c == 'HLD') {

                if (q.Holders__r != null && q.Holders__r.size() > 0)
                    wrapperObj = new quoteLineWrapper(q, q.Holders__r[0], userInfo);

            } else if (q.SBQQ__ProductCode__c == 'WGB') {

                if (q.WasteGasBurners__r != null && q.WasteGasBurners__r.size() > 0)
                    wrapperObj = new quoteLineWrapper(q, q.WasteGasBurners__r[0], userInfo);

            } else if (q.SBQQ__ProductCode__c == 'PS') {

                if (q.Part_Selectors__r != null && q.Part_Selectors__r.size() > 0)
                    wrapperObj = new quoteLineWrapper(q, q.Part_Selectors__r[0], userInfo);
            }
            wrapperObjList.add(wrapperObj);
        }

        return wrapperObjList;
    }

    @AuraEnabled(cacheable = true)
    public static List < QuoteLineWrapper > getQuoteLineDetails(String quoteLineId) {

        return getQLDetails(null, quoteLineId);
    }

    //fetch Quote line items for lwcCustomQuoteLinePage component
    @AuraEnabled(cacheable = true)
    public static List < quoteLineWrapper > getQuoteLineData(String quoteId) {

        return getQLDetails(quoteId, null);

        /*
User userInfo = [SELECT ContactId, Profile.Name, IsPortalEnabled, ProfileId FROM user WHERE Id = :UserInfo.getUserId()];
List<quoteLineWrapper> quoteLineList = new list<quoteLineWrapper>();
for (SBQQ__QuoteLine__c q: [SELECT Id,SBQQ__Quote__c,Name,SBQQ__Product__c,SBQQ__Discount__c,SBQQ__ProductName__c,SBQQ__ProductCode__c,
SBQQ__Quantity__c,LastModifiedDate, SBQQ__Product__r.Name, SBQQ__Quote__r.Name, Engineering_Status__c, Product_Planning_Status__c
FROM SBQQ__QuoteLine__c
WHERE SBQQ__Quote__c = :quoteId order by LastModifiedDate]) {
id qID=q.Id;
String query='';
string sObject_name='';
query='SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c';
if(q.SBQQ__ProductCode__c=='BGR')
sObject_name='BGR__c';
else if (q.SBQQ__ProductCode__c=='RD')
sObject_name='Rupture_Disc__c';
else if(q.SBQQ__ProductCode__c=='RLFVLV')
sObject_name='Relief_Valve__c';
else if(q.SBQQ__ProductCode__c=='FlameProducts')
sObject_name='Flame_Product__c';
else if(q.SBQQ__ProductCode__c=='HLD')
sObject_name='Holders__c';
else if(q.SBQQ__ProductCode__c=='WGB')
sObject_name='WasteGasBurner__c';
else if(q.SBQQ__ProductCode__c=='PS'){
sObject_name='Part_Selector__c';
}
//  This 'else' statement will cause issues if the quote has orphaned quote line items, or quote line items from another configurator
//else
//sObject_name='Rupture_Disc__c';

if(sObject_name != ''){
query=query+' FROM '+sObject_name+' WHERE Quote_Line__c=:qID';
try {
list<SObject> pdRec=Database.query(query);
if(pdRec != null && pdRec.size() > 0) {

quoteLineWrapper ab=new quoteLineWrapper (q, pdRec[0], userInfo);
quoteLineList.add(ab);
}
} catch(Exception ex) {

}
}

}
return quoteLineList;
*/
    }

    public class quoteLineWrapper {
        @AuraEnabled public SBQQ__QuoteLine__c ql {
            set;
            get;
        }
        @AuraEnabled public SObject rD {
            set;
            get;
        }
        @AuraEnabled public String productName {
            set;
            get;
        }
        @AuraEnabled public String productRefName {
            set;
            get;
        }
        @AuraEnabled public String Outputname {
            set;
            get;
        }
        @AuraEnabled public String quoteName {
            set;
            get;
        }
        @AuraEnabled public String quoteURL {
            set;
            get;
        }
        @AuraEnabled public String productURL {
            set;
            get;
        }
        @AuraEnabled public String productRefURL {
            set;
            get;
        }
        @AuraEnabled public String OutputURL {
            set;
            get;
        }
        @AuraEnabled public String ProdCode {
            set;
            get;
        }
        @AuraEnabled public String quoteLineURL {
            set;
            get;
        }
        @AuraEnabled public String engStatus {
            set;
            get;
        }
        @AuraEnabled public String ppStatus {
            set;
            get;
        }
        public quoteLineWrapper(SBQQ__QuoteLine__c p, SObject rD, User userinfo) {
            //User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];

            if (userinfo.IsPortalEnabled) {
                this.ql = p;
                this.rD = rD;
                this.productName = p.SBQQ__Product__r.Name;
                this.productURL = '/s/detail/' + p.SBQQ__Product__c;
                this.productRefName = (string) rD.get('Name');
                this.productRefURL = '/s/detail/' + rD.Id;
                this.quoteURL = '/s/detail/' + p.SBQQ__Product__c;
                this.quoteName = p.SBQQ__Quote__r.Name;
                this.Outputname = 'View outputs';
                this.engStatus = p.Engineering_Status__c;
                this.ppStatus = p.Product_Planning_Status__c;
                if (ql.SBQQ__ProductCode__c == 'BGR') {
                    String url = '/apex/ConfigBGR?qid=' + ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else if (ql.SBQQ__ProductCode__c == 'WGB') {
                    String url = '/apex/ConfigWGBProduct?qid=' + ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else if (ql.SBQQ__ProductCode__c == 'RD') {
                    String url = '/apex/ConfigRD?qid=' + ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else if (ql.SBQQ__ProductCode__c == 'PS') {
                    String url = '/apex/ConfigPartSelector?id=' + rD.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else if (ql.SBQQ__ProductCode__c == 'FlameProducts') {
                    String url = '/apex/ConfigFLAME?qid=' + ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else if (ql.SBQQ__ProductCode__c == 'HLD') {
                    String url = '/apex/ConfigHoldersOutputs?qid=' + ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else if (ql.SBQQ__ProductCode__c == 'RLFVLV') {
                    String url = '/apex/RVConfig?qid=' + ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } else {
                    this.OutputURL = quoteURL;
                }

                this.ProdCode = ql.SBQQ__ProductCode__c;
                this.quoteLineURL = '/s/detail/' + ql.Id;

            } else {
                this.ql = p;
                this.rD = rD;
                this.productName = p.SBQQ__Product__r.Name;
                this.productURL = '/lightning/r/SBQQ__Product__c/' + p.SBQQ__Product__c + '/view';
                this.productRefName = (string) rD.get('Name');
                this.productRefURL = '/' + rD.Id;
                this.quoteURL = '/lightning/r/SBQQ__Quote__c/' + p.SBQQ__Product__c + '/view';
                this.quoteName = p.SBQQ__Quote__r.Name;
                this.Outputname = 'View outputs';
                this.engStatus = p.Engineering_Status__c;
                this.ppStatus = p.Product_Planning_Status__c;
                if (ql.SBQQ__ProductCode__c == 'BGR')
                    this.OutputURL = '/apex/ConfigBGR?qid=' + ql.Id;
                else if (ql.SBQQ__ProductCode__c == 'WGB')
                    this.OutputURL = '/apex/ConfigWGBProduct?qid=' + ql.Id;
                else if (ql.SBQQ__ProductCode__c == 'RD')
                    this.OutputURL = '/apex/ConfigRD?qid=' + ql.Id;
                else if (ql.SBQQ__ProductCode__c == 'PS')
                    this.OutputURL = '/apex/ConfigPartSelector?id=' + rD.Id;
                else if (ql.SBQQ__ProductCode__c == 'FlameProducts')
                    this.OutputURL = '/apex/ConfigFLAME?qid=' + ql.Id;
                else if (ql.SBQQ__ProductCode__c == 'HLD')
                    this.OutputURL = '/apex/ConfigHoldersOutputs?qid=' + ql.Id;
                else if (ql.SBQQ__ProductCode__c == 'RLFVLV')
                    this.OutputURL = '/apex/RVConfig?qid=' + ql.Id;
                else
                    this.OutputURL = quoteURL;
                this.ProdCode = ql.SBQQ__ProductCode__c;
                this.quoteLineURL = '/lightning/r/SBQQ__QuoteLine__c/' + ql.Id + '/view';
            }
        }
    }

    @AuraEnabled
    public static Map < String, String > upsertQuoteLineItem(SBQQ__QuoteLine__c quoteLine, String productCode) {
        List < BGR__c > bgrRecordList = new List < BGR__c > ();
        List < Relief_Valve__c > rvRecordList = new List < Relief_Valve__c > ();
        List < Rupture_Disc__c > rdRecordlist = new List < Rupture_Disc__c > ();
        List < WasteGasBurner__c > wgbRecordList = new List < WasteGasBurner__c > ();
        List < Part_Selector__c > psRecordList = new List < Part_Selector__c > ();
        List < Flame_Product__c > flameRecordList = new List < Flame_Product__c > ();
        List < Holders__c > hldRecordList = new List < Holders__c > ();
        String result;
        Map < String, String > response = new Map < String, String > ();
        try {
            if (quoteLine != null && productCode != null) {
                AggregateResult[] aggResult = [select Max(QuoteLineNumber__c) aver from SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteLine.SBQQ__Quote__c];
                Decimal qNum;
                if (aggResult[0].get('aver') != null) {
                    qNum = (Decimal) aggResult[0].get('aver') + 1;
                } else {
                    qNum = 1;
                }
                quoteLine.QuoteLineNumber__c = (Integer) qNum;
                quoteLine.SBQQ__Quantity__c = 1;
                upsert quoteLine;
                result = quoteLine.SBQQ__Quote__c;
                response.put('QUOTE_ID', quoteLine.SBQQ__Quote__c);
                response.put('QUOTELINE_ID', quoteLine.Id);
                response.put('STATUS', 'Success');
            }
            if (quoteLine != null && quoteLine.Id != null) {
                if (productCode == 'BGR') {
                    BGR__c bgrRecord = new BGR__c();
                    bgrRecord.Quote_Line__c = quoteLine.id;
                    bgrRecordList.add(bgrRecord);
                } else if (productCode == 'RD') {
                    Rupture_Disc__c rDisc = new Rupture_Disc__c();
                    rDisc.Quote_Line__c = quoteLine.id;
                    insert rDisc;
                    rdRecordlist.add(rDisc);
                } else if (productCode == 'RLFVLV') {
                    Relief_Valve__c rvRecord = new Relief_Valve__c();
                    rvRecord.Quote_Line__c = quoteLine.id;
                    rvRecordList.add(rvRecord);
                    //insert rDisc;
                } else if (productCode == 'FlameProducts') {
                    Flame_Product__c fLM = new Flame_Product__c();
                    fLM.Quote_Line__c = quoteLine.id;
                    flameRecordList.add(fLM);
                    insert fLM;
                } else if (productCode == 'HLD') {
                    Holders__c holder = new Holders__c();
                    holder.Quote_Line__c = quoteLine.id;
                    hldRecordList.add(holder);
                    insert holder;
                } else if (productCode == 'WGB') {
                    WasteGasBurner__c Wgb = new WasteGasBurner__c();
                    Wgb.Quote_Line__c = quoteLine.id;
                    wgbRecordList.add(Wgb);
                    insert Wgb;
                } else if (productCode == 'PS') { // added by piyush @5/6/2020
                    Part_Selector__c ps = new Part_Selector__c();
                    ps.Quote_Line__c = quoteLine.id;
                    psRecordList.add(ps);
                    insert ps;
                }
            }
            //Added By Vinayak
            //** To create the BGR output object record
            //** Used to store the output results

            if (psRecordList.size() > 0) {
                List < PS_Output__c > wgbOutputList = new List < PS_Output__c > ();
                for (Part_Selector__c ps: psRecordList) {
                    PS_Output__c psOutputInstance = new PS_Output__c();
                    psOutputInstance.Part_Selector__c = ps.id;
                    wgbOutputList.add(psOutputInstance);
                }
                insert wgbOutputList;
            }

            if (wgbRecordList.size() > 0) {
                List < WGB_Outputs__c > wgbOutputList = new List < WGB_Outputs__c > ();
                for (WasteGasBurner__c wgb: wgbRecordList) {
                    WGB_Outputs__c wgbOutputInstance = new WGB_Outputs__c();
                    wgbOutputInstance.WasteGasBurner__c = wgb.id;
                    wgbOutputList.add(wgbOutputInstance);
                }
                insert wgbOutputList;
            }

            if (flameRecordList.size() > 0) {
                List < FA_Output__c > FAOutputList = new List < FA_Output__c > ();
                for (Flame_Product__c fa: flameRecordList) {
                    FA_Output__c FAOutputInstance = new FA_Output__c();
                    FAOutputInstance.FA_Output_Relation_Field__c = fa.id;
                    FAOutputList.add(FAOutputInstance);
                }
                insert FAOutputList;
            }


            if (bgrRecordList.size() > 0) {
                insert bgrRecordList;
                List < BGR_Outputs__c > bgrOutputList = new List < BGR_Outputs__c > ();
                for (BGR__c bgr: bgrRecordList) {
                    BGR_Outputs__c bgrOutputInstance = new BGR_Outputs__c();
                    bgrOutputInstance.BGR_Outputs_Relation_Field__c = bgr.id;
                    bgrOutputList.add(bgrOutputInstance);
                }
                insert bgrOutputList;
            }
            if (rvRecordList.size() > 0) {
                insert rvRecordList;
                List < RV_Outputs__c > rvOutputList = new List < RV_Outputs__c > ();
                for (Relief_Valve__c rv: rvRecordList) {
                    RV_Outputs__c rvOutputInstance = new RV_Outputs__c();
                    rvOutputInstance.RV_Outputs_Relation_Field__c = rv.id;
                    rvOutputList.add(rvOutputInstance);
                }
                insert rvOutputList;
            }
            if (hldRecordList.size() > 0) {
                List < Holder_Outputs__c > hldOutputList = new List < Holder_Outputs__c > ();
                List < Holder_Drawings__c > hldDiagramList = new List < Holder_Drawings__c > ();
                for (Holders__c rD: hldRecordList) {
                    //RD_Pricing__c rDP= new RD_Pricing__c();
                    Holder_Drawings__c rDD = new Holder_Drawings__c();
                    Holder_Outputs__c rDO = new Holder_Outputs__c();
                    rDD.Holders__c = rD.Id;
                    //rDP.Rupture_Disc__c=rD.Id;
                    rdO.ReferenceId__c = rD.Id;
                    hldOutputList.add(rDO);
                    hldDiagramList.add(rDD);
                    //RdDiagramList.add(rDD);
                }
                upsert hldOutputList;
                //upsert RdPricingList;
                upsert hldDiagramList;
            }
            if (rdRecordlist.size() > 0) {
                List < RD_Outputs__c > RdOutputList = new List < RD_Outputs__c > ();
                List < RD_Pricing__c > RdPricingList = new List < RD_Pricing__c > ();
                List < RD_Drawings__c > RdDiagramList = new List < RD_Drawings__c > ();
                for (Rupture_Disc__c rD: rdRecordlist) {
                    RD_Pricing__c rDP = new RD_Pricing__c();
                    RD_Drawings__c rDD = new RD_Drawings__c();
                    RD_Outputs__c rDO = new RD_Outputs__c();
                    rDD.Rupture_Disc__c = rD.Id;
                    rDP.Rupture_Disc__c = rD.Id;
                    rdO.RD_Outputs_Relation_Field__c = rD.Id;
                    RdOutputList.add(rDO);
                    RdPricingList.add(rDP);
                    RdDiagramList.add(rDD);
                }
                upsert RdOutputList;
                upsert RdPricingList;
                upsert RdDiagramList;
            }
        } catch (Exception e) {
            result = e.getMessage();
            response.put('STATUS', 'Failure');
            response.put('ERROR_MSG', e.getMessage());
        }
        return response;
    }

    @AuraEnabled
    public static List < quoteLineWrapper > getQuoteLineDataImpa(String quoteId) {
        return getQuoteLineData(quoteId);
    }
    //CODE ADDED FOR CO10 MNFA TO Pick from PressureConnection table********************************
    @AuraEnabled
    public static Rupture_Disc__c saveRDCapacity(Rupture_Disc__c ruptureDisc) {
        double dConvertedSpecificGravity = ruptureDisc.Converted_Density_at_Inlet__c;
        double dConvertedSpecificVolume = ruptureDisc.Converted_Specific_Volume__c;
        decimal doubleConvertedFlowCapacity = ruptureDisc.Converted_Flow_rate__c;
        decimal decConRelievingTemp = ruptureDisc.Converted_Relieving_Temperature__c;
        decimal decConRelievingPressure = ruptureDisc.Converted_Relieving_Pressure_Value__c;
        decimal decPBrustConvertedValue = ruptureDisc.Converted_Pressure_Setting__c;
        Result doubleFlowCapacity = new Result();
        system.debug('TEST CO10'+ruptureDisc.MNFA_for_Calculations__c);
        Boolean filterPSS = false;
        if (ruptureDisc.Relief_Type__c == 'Pressure Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            switch on ruptureDisc.Evaluation_Per__c {
                When 'ASME Gas/Vapor' {
                    if (ruptureDisc.Process_Media__c == 'Air') {
                        //ASMEAIRCapacity(double P, double T, double M,integer nSize, String strPTC, String strSeat)
                        doubleFlowCapacity = RDDiscSizingCapacity.ASMEAIRCapacity(decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                    } else {
                        //ASMEGASCapacity(double P,double T,double smallk,
                        //  double M, double Z,integer nSize, String strPTC, String strSeat)
                        doubleFlowCapacity = RDDiscSizingCapacity.ASMEGASCapacity(decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                    }
                }

                When 'ASME Water' {
                    //ASMEWaterCapacity(double P, double Pd, double smallw,
                    // integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.ASMEWaterCapacity(decConRelievingPressure.doubleValue(), Double.valueOf(14.6959), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                When 'ASME Steam' {
                    //ASMESteamCapacity( double P,integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.ASMESteamCapacity(decConRelievingPressure.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'API Gas/Vapor' {
                    // APIGASCapacity(double P1,double P2,double K, double T,
                    // double M, double Z,integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.APIGASCapacity(decConRelievingPressure.doubleValue(), Double.valueOf(14.6959), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }
                When 'API Liquid' {
                    //APILiquidCapacity( double P1, double G,
                    // double U, double P2,integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.APILiquidCapacity(decConRelievingPressure.doubleValue(), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), Double.valueOf(0), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'API Steam' {
                    //APISteamCapacity( double P1,double T,integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.APISteamCapacity(decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                When 'ISO Gas/Vapor' {
                    //ISOGASCapacity(double Po,double Pb,double To,double K,
                    //double M, double Zo,integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.ISOGASCapacity(decConRelievingPressure.doubleValue(), Double.valueOf(1.01325), decConRelievingTemp.doubleValue(), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c),ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                When 'ISO Liquid' {
                    //ISOLiquidCapacity( double Po, double Vo,
                    //double Uo, double Pb,integer nSize, String strPTC, String strSeat)
                    System.debug('decConRelievingPressure --' + decConRelievingPressure.doubleValue());
                    doubleFlowCapacity = RDDiscSizingCapacity.ISOLiquidCapacity(decConRelievingPressure.doubleValue(), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(),
                        Double.valueOf(1.01325), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                When 'ISO Dry Steam' {
                    //ISODryStreamCapacity(double Qm, double P0, double T0,integer nSize, String strPTC, String strSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.ISODryStreamCapacity(999999, decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c),ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'ISO Wet Steam' {
                    //ISOWetStreamCapacity(double Qm, double P0, double Xo,Integer nSize,String stPTC, String stSeat)
                    system.debug('decConRelievingPressure' + decConRelievingPressure);
                    system.debug('ruptureDisc.Dryness_of_Wet_Steam__c' + ruptureDisc.Dryness_of_Wet_Steam__c);
                    system.debug('ruptureDisc.Dryness_of_Wet_Steam__c' + ruptureDisc.Coefficient_of_Discharge__c);
                    doubleFlowCapacity = RDDiscSizingCapacity.ISOWetStreamCapacity(999999, decConRelievingPressure.doubleValue(), ruptureDisc.Dryness_of_Wet_Steam__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c),ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'API Omega Method 2 Phase Flashing or Nonflashing' {

                    //APIOmegaMTD2PhaseCapacity(double P0, double V0,
                    //double V9, double MU, double PA, Integer nSize, String stPTC, String stSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.APIOmegaMTD2PhaseCapacity(decConRelievingPressure.doubleValue(), dConvertedSpecificVolume, ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), double.valueOf(14.6959), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'API Omega Method Subcooled Liquid' {
                    //APIOmegaMtdSubcoolCapacity(double PS, double P0, double P10, double P9, double MU, double PA,
                    //Integer nSize, String stPTC, String stSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.APIOmegaMtdSubcoolCapacity(ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c.doubleValue(), decConRelievingPressure.doubleValue(), dConvertedSpecificGravity, ruptureDisc.ConvertedDensity_at_90SaturationPressure__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), double.valueOf(14.6959), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'Fauske 2 Phase Gas-Liquid' {
                    //FauskeGasLiquidCapacity(double P0, double PB, double K, double T0, double MW, double R, double X0, double P10,
                    //Integer nSize, String stPTC, String stSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.FauskeGasLiquidCapacity(decConRelievingPressure.doubleValue(), double.valueOf(101325), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), Double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(), ruptureDisc.Converted_Liquid_Density__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'Fauske 2 Phase Vapor-Liquid' {
                    //FauskeVaporLiquidCapacity(double P0, double PB, double K, double T0, double MW, double R, double X0, double PV0, double L0, double C0,
                    //Integer nSize, String stPTC, String stSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.FauskeVaporLiquidCapacity(decConRelievingPressure.doubleValue(), double.valueOf(101325), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), Double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(), ruptureDisc.Converted_Stagnation_vapor_density__c.doubleValue(), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(),
                        ruptureDisc.Liquid_specific_heat__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' {
                    //FauskeHybridGVLCapacity(double P0, double PB, double T0, double PG0, double PV0, double KG, double KV, double MWG, double MWV,
                    //double R, double X0, double P10, double C0, double L0, double PV0_d, Integer nSize, String stPTC, String stSeat)
                    doubleFlowCapacity = RDDiscSizingCapacity.FauskeHybridGVLCapacity(decConRelievingPressure.doubleValue(),
                        double.valueOf(101325), decConRelievingTemp.doubleValue(), ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c.doubleValue(), ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c.doubleValue(),
                        ruptureDisc.Isentropic_coefficient_gas__c.doubleValue(), ruptureDisc.Isentropic_coefficient_vapor__c.doubleValue(), ruptureDisc.Molecular_Weight_gas__c.doubleValue(),
                        ruptureDisc.Molecular_Weight_vapor__c.doubleValue(), double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(),
                        ruptureDisc.Converted_Liquid_Density__c.doubleValue(), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(), ruptureDisc.Liquid_specific_heat__c.doubleValue(),
                        ruptureDisc.Converted_Stagnation_vapor_density__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c,ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }

                when 'Fauske All Liquid Flashing' {
                    //FauskeAllLiquidFlashingCapacity( double T0, double PG0,double C0,
                    // double L0, double PV0_d, double P10, Integer nSize, String stPTC, String stSeat, boolean isSaturated)
                    // boolean isSaturated=false;
                    // isSaturated=[select Is_Saturated__c from ]
                    system.debug('********ISSATURATED'+ruptureDisc.Is_Saturated__c);
                    doubleFlowCapacity = RDDiscSizingCapacity.FauskeAllLiquidFlashingCapacity(decConRelievingTemp.doubleValue(),ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c.doubleValue(), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(), ruptureDisc.Liquid_specific_heat__c.doubleValue(),
                        ruptureDisc.Converted_Stagnation_vapor_density__c.doubleValue(), ruptureDisc.Converted_Liquid_Density__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, ruptureDisc.Is_Saturated__c, decConRelievingPressure.doubleValue(),ruptureDisc.MNFA_for_Calculations__c.doubleValue());
                }
            }
        }
        if (doubleFlowCapacity.bResult) {
            System.debug('CO10 --doubleFlowCapacity'+doubleFlowCapacity.dblRetValue);
            ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = doubleFlowCapacity.dblRetValue;
        }
        if (ruptureDisc.Relief_Type__c == 'Vacuum Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            if (ruptureDisc.VacConverted_Different_Temp_Setting__c != null) {
                result vacCapacity = new result();
                Result vacConvertedPress = unitConversions.convertPressure('psig', 'psia', ruptureDisc.Converted_Vacuum_Setting__c.doubleValue());
                vacCapacity = RDDiscSizingCapacity.VACUUMCapacity(vacConvertedPress.dblRetValue, ruptureDisc.VacConverted_Different_Temp_Setting__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, ruptureDisc.DSCVAR__c, ruptureDisc.Converted_Vacuum_Setting__c.doubleValue());
                ruptureDisc.VacFlow_Capacity_Value__c = vacCapacity.dblRetValue;
            }
        }
        ruptureDisc=saveCapacityConversion(ruptureDisc);
        return ruptureDisc;
    }
    @AuraEnabled
    public static Rupture_Disc__c saveCapacityConversion(Rupture_Disc__c ruptureDisc) {
        decimal decConRelievingPressure = ruptureDisc.Converted_Relieving_Pressure_Value__c;
        decimal decConRelievingTemp = ruptureDisc.Converted_Relieving_Temperature__c;
        List < String > lstOfFauskeOmega = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid'
        };
        if (ruptureDisc.Relief_Type__c == 'Pressure Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            if (unitConversions.listGasFlowRatenew.contains(ruptureDisc.Evaluation_Per__c) || unitConversions.listStreamFlowRatenew.contains(ruptureDisc.Evaluation_Per__c)) {
                if (ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c != null && ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c != null) {
                    Double convTemp = 999999999;
                    if (ruptureDisc.Evaluation_Per__c != 'ASME Steam' && ruptureDisc.Evaluation_Per__c != 'ISO Wet Steam') {
                        convTemp = decConRelievingTemp;
                    }
                    result resultFlowCapacity = unitConversions.convertGasFlowRate(unitConversions.mapRD_FlowRateBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c, ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c, decConRelievingPressure, ruptureDisc.Molecular_Weight__c, convTemp, ruptureDisc.Compressibility_Factor__c);
                    if (resultFlowCapacity.bResult) {
                        result res1 = unitConversions.SignificantDigitsNormal(resultFlowCapacity.dblRetValue, 4, -99);
                        ruptureDisc.Product_Flow_Capacity_Value__c = res1.dblRetValue;
                    }
                } else if(ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c != null) {
                    ruptureDisc.Product_Flow_Capacity_Value__c=ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c;
                }
            } else {
                if (ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c != null && ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c != null) {
                    Double denSpecGravity = 1.0;
                    if (!lstOfFauskeOmega.contains(ruptureDisc.Evaluation_Per__c)) {
                        denSpecGravity = ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c;
                        Result resultConvertDensity1 = unitConversions.convertDensitySpecifyVolume(unitConversions.mapRD_DensitySpecificVolumeSpecificGravityBaseUOM.get(ruptureDisc.Evaluation_Per__c), 'lb/ft3', ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c);
                        denSpecGravity = resultConvertDensity1.dblRetValue;
                    }
                    result resultFlowCapacity = unitConversions.convertLiquidFlowRate(unitConversions.mapRD_FlowRateBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c, ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c, denSpecGravity);
                    if (resultFlowCapacity.bResult) {
                        result resFlowCap = unitConversions.SignificantDigitsNormal(resultFlowCapacity.dblRetValue, 4, -99);
                        ruptureDisc.Product_Flow_Capacity_Value__c = resFlowCap.dblRetValue;
                    }
                } else if(ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c != null) {
                    ruptureDisc.Product_Flow_Capacity_Value__c=ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c;
                }
            }
        }

        if (ruptureDisc.Relief_Type__c == 'Vacuum Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            result vacCapacity = new result();
            Result vacConvertedPress = unitConversions.convertPressure('psig', 'psia', ruptureDisc.Converted_Vacuum_Setting__c.doubleValue());

            if (ruptureDisc.VacFlow_Capacity_Value__c != null && ruptureDisc.VacProduct_Flow_Capacity_Units__c != null) {
                result resultFlowCapacity = unitConversions.convertGasFlowRate('lb/h', ruptureDisc.VacProduct_Flow_Capacity_Units__c, ruptureDisc.VacFlow_Capacity_Value__c, vacConvertedPress.dblRetValue, double.ValueOf(28.964), ruptureDisc.VacConverted_Different_Temp_Setting__c.doubleValue(), double.valueOf(1));
                if (resultFlowCapacity.bResult) {
                    result resVacFlowCap1 = unitConversions.SignificantDigitsNormal(resultFlowCapacity.dblRetValue, 4, -99);
                    ruptureDisc.VacProduct_Flow_Capacity_Value__c = resVacFlowCap1.dblRetValue;
                }
            } else if (ruptureDisc.VacFlow_Capacity_Value__c != null) {
                ruptureDisc.VacProduct_Flow_Capacity_Value__c =ruptureDisc.VacFlow_Capacity_Value__c;
            }
        }
        return ruptureDisc;
    }
    // ***********************************************************************************************
    @AuraEnabled
    public static Rupture_Disc__c saveProductSelection(Rupture_Disc__c ruptureDisc, String rupRecordId, List < id > lstRDMBIds) {
        ruptureDisc.Relief_Flag__c = true;
        ruptureDisc.Sizing_Flag__c = false;
        ruptureDisc.Certificate_of_Origin__c = false;
        ruptureDisc.Product_Narrowing_Flag__c = false;
        ruptureDisc.Product_Selection__c = true;
        if (!ReorderFlagLWC) {
           // ruptureDisc = clearSectEProductSelection(ruptureDisc);
            ruptureDisc =clearHCLASSSelection(ruptureDisc);
            ruptureDisc =clearSectFManufacturingRange(ruptureDisc);
            ruptureDisc =clearSectGComponents(ruptureDisc);
        }
        double dConvertedSpecificGravity = ruptureDisc.Converted_Density_at_Inlet__c;
        double dConvertedSpecificVolume = ruptureDisc.Converted_Specific_Volume__c;
        decimal doubleConvertedFlowCapacity = ruptureDisc.Converted_Flow_rate__c;
        decimal decConRelievingTemp = ruptureDisc.Converted_Relieving_Temperature__c;
        decimal decConRelievingPressure = ruptureDisc.Converted_Relieving_Pressure_Value__c;
        decimal decPBrustConvertedValue = ruptureDisc.Converted_Pressure_Setting__c;
        Result doubleFlowCapacity = new Result();
        Boolean filterPSS = false;



        if (ruptureDisc.Product__c != null && ruptureDisc.Size__c != null && ruptureDisc.Seat__c != null) { // && ruptureDisc.Size_Units__c != null

            Rupture_Disc__c ruptRec = new Rupture_Disc__c();
            for (RDOptions eachRDOpt: getRupDiscRecords(ruptureDisc, rupRecordId)) {
                if (ruptureDisc.Product__c == eachRDOpt.product && ruptureDisc.Size__c == eachRDOpt.size && ruptureDisc.Seat__c == eachRDOpt.seat) {
                    filterPSS = true;
                }
            }

            if (filterPSS) {
                //CO10 Commented code *****************************************************************************
                // if (ruptureDisc.Relief_Type__c == 'Pressure Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
                //     switch on ruptureDisc.Evaluation_Per__c {
                //         When 'ASME Gas/Vapor' {
                //             if (ruptureDisc.Process_Media__c == 'Air') {
                //                 //ASMEAIRCapacity(double P, double T, double M,integer nSize, String strPTC, String strSeat)
                //                 doubleFlowCapacity = RDDiscSizingCapacity.ASMEAIRCapacity(decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //             } else {
                //                 //ASMEGASCapacity(double P,double T,double smallk,
                //                 //  double M, double Z,integer nSize, String strPTC, String strSeat)
                //                 doubleFlowCapacity = RDDiscSizingCapacity.ASMEGASCapacity(decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //             }
                //         }

                //         When 'ASME Water' {
                //             //ASMEWaterCapacity(double P, double Pd, double smallw,
                //             // integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.ASMEWaterCapacity(decConRelievingPressure.doubleValue(), Double.valueOf(14.6959), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         When 'ASME Steam' {
                //             //ASMESteamCapacity( double P,integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.ASMESteamCapacity(decConRelievingPressure.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'API Gas/Vapor' {
                //             // APIGASCapacity(double P1,double P2,double K, double T,
                //             // double M, double Z,integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.APIGASCapacity(decConRelievingPressure.doubleValue(), Double.valueOf(14.6959), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }
                //         When 'API Liquid' {
                //             //APILiquidCapacity( double P1, double G,
                //             // double U, double P2,integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.APILiquidCapacity(decConRelievingPressure.doubleValue(), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), Double.valueOf(0), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'API Steam' {
                //             //APISteamCapacity( double P1,double T,integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.APISteamCapacity(decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         When 'ISO Gas/Vapor' {
                //             //ISOGASCapacity(double Po,double Pb,double To,double K,
                //             //double M, double Zo,integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.ISOGASCapacity(decConRelievingPressure.doubleValue(), Double.valueOf(1.01325), decConRelievingTemp.doubleValue(), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c));
                //         }

                //         When 'ISO Liquid' {
                //             //ISOLiquidCapacity( double Po, double Vo,
                //             //double Uo, double Pb,integer nSize, String strPTC, String strSeat)
                //             System.debug('decConRelievingPressure --' + decConRelievingPressure.doubleValue());
                //             doubleFlowCapacity = RDDiscSizingCapacity.ISOLiquidCapacity(decConRelievingPressure.doubleValue(), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(),
                //                 Double.valueOf(1.01325), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         When 'ISO Dry Steam' {
                //             //ISODryStreamCapacity(double Qm, double P0, double T0,integer nSize, String strPTC, String strSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.ISODryStreamCapacity(999999, decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c));
                //         }

                //         when 'ISO Wet Steam' {
                //             //ISOWetStreamCapacity(double Qm, double P0, double Xo,Integer nSize,String stPTC, String stSeat)
                //             system.debug('decConRelievingPressure' + decConRelievingPressure);
                //             system.debug('ruptureDisc.Dryness_of_Wet_Steam__c' + ruptureDisc.Dryness_of_Wet_Steam__c);
                //             system.debug('ruptureDisc.Dryness_of_Wet_Steam__c' + ruptureDisc.Coefficient_of_Discharge__c);
                //             doubleFlowCapacity = RDDiscSizingCapacity.ISOWetStreamCapacity(999999, decConRelievingPressure.doubleValue(), ruptureDisc.Dryness_of_Wet_Steam__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c));
                //         }

                //         when 'API Omega Method 2 Phase Flashing or Nonflashing' {

                //             //APIOmegaMTD2PhaseCapacity(double P0, double V0,
                //             //double V9, double MU, double PA, Integer nSize, String stPTC, String stSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.APIOmegaMTD2PhaseCapacity(decConRelievingPressure.doubleValue(), dConvertedSpecificVolume, ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), double.valueOf(14.6959), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'API Omega Method Subcooled Liquid' {
                //             //APIOmegaMtdSubcoolCapacity(double PS, double P0, double P10, double P9, double MU, double PA,
                //             //Integer nSize, String stPTC, String stSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.APIOmegaMtdSubcoolCapacity(ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c.doubleValue(), decConRelievingPressure.doubleValue(), dConvertedSpecificGravity, ruptureDisc.ConvertedDensity_at_90SaturationPressure__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), double.valueOf(14.6959), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'Fauske 2 Phase Gas-Liquid' {
                //             //FauskeGasLiquidCapacity(double P0, double PB, double K, double T0, double MW, double R, double X0, double P10,
                //             //Integer nSize, String stPTC, String stSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.FauskeGasLiquidCapacity(decConRelievingPressure.doubleValue(), double.valueOf(101325), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), Double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(), ruptureDisc.Converted_Liquid_Density__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'Fauske 2 Phase Vapor-Liquid' {
                //             //FauskeVaporLiquidCapacity(double P0, double PB, double K, double T0, double MW, double R, double X0, double PV0, double L0, double C0,
                //             //Integer nSize, String stPTC, String stSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.FauskeVaporLiquidCapacity(decConRelievingPressure.doubleValue(), double.valueOf(101325), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), Double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(), ruptureDisc.Converted_Stagnation_vapor_density__c.doubleValue(), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(),
                //                 ruptureDisc.Liquid_specific_heat__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' {
                //             //FauskeHybridGVLCapacity(double P0, double PB, double T0, double PG0, double PV0, double KG, double KV, double MWG, double MWV,
                //             //double R, double X0, double P10, double C0, double L0, double PV0_d, Integer nSize, String stPTC, String stSeat)
                //             doubleFlowCapacity = RDDiscSizingCapacity.FauskeHybridGVLCapacity(decConRelievingPressure.doubleValue(),
                //                 double.valueOf(101325), decConRelievingTemp.doubleValue(), ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c.doubleValue(), ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c.doubleValue(),
                //                 ruptureDisc.Isentropic_coefficient_gas__c.doubleValue(), ruptureDisc.Isentropic_coefficient_vapor__c.doubleValue(), ruptureDisc.Molecular_Weight_gas__c.doubleValue(),
                //                 ruptureDisc.Molecular_Weight_vapor__c.doubleValue(), double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(),
                //                 ruptureDisc.Converted_Liquid_Density__c.doubleValue(), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(), ruptureDisc.Liquid_specific_heat__c.doubleValue(),
                //                 ruptureDisc.Converted_Stagnation_vapor_density__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c);
                //         }

                //         when 'Fauske All Liquid Flashing' {
                //             //FauskeAllLiquidFlashingCapacity( double T0, double PG0,double C0,
                //             // double L0, double PV0_d, double P10, Integer nSize, String stPTC, String stSeat, boolean isSaturated)

                //             doubleFlowCapacity = RDDiscSizingCapacity.FauskeAllLiquidFlashingCapacity(decConRelievingTemp.doubleValue(), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(), ruptureDisc.Liquid_specific_heat__c.doubleValue(),
                //                 ruptureDisc.Converted_Stagnation_vapor_density__c.doubleValue(), ruptureDisc.Converted_Liquid_Density__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, true, decConRelievingPressure.doubleValue());
                //         }
                //     }
                // }
                //#################################################################################################
                String filterTemp = getRDProductNarrowFilterClause(ruptRec, rupRecordId);
                String filterTemp1=' ID!=NULL';
                Decimal decVBrustConvertedValue = ruptureDisc.Converted_Vacuum_Setting__c;
                //nikhil, 19 feb, redmine 35122
                // if (decPBrustConvertedValue != null && ruptureDisc.Relief_Type__c != 'Vacuum Relief') {
                //     filterTemp += ' AND PRESSLL__c <=' + decPBrustConvertedValue + ' and PRESSUL__c>' + decPBrustConvertedValue;
                //    filterTemp1+=' AND PRESSLL__c <=' + decPBrustConvertedValue + ' and PRESSUL__c>' + decPBrustConvertedValue;
                // }
                // if (decVBrustConvertedValue != null && ruptureDisc.Relief_Type__c != 'Pressure Relief') {
                //     filterTemp += ' AND VacLL__c <=' + decVBrustConvertedValue + ' and VacUL__c>' + decVBrustConvertedValue;
                //     filterTemp1+=' AND VacLL__c <=' + decVBrustConvertedValue + ' and VacUL__c>' + decVBrustConvertedValue;
                // }
                //filterTemp = filterTemp + ' ';
                decimal burstPress=0;
                if (ruptureDisc.Product__c != 'CAL')
                    burstPress = decPBrustConvertedValue;
                else
                    burstPress = decVBrustConvertedValue;
                result resDSCVAR=new result();
                resDSCVAR = RDDiscSizingCapacity.RD_DSCVAR(Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, filterTemp,ruptureDisc.Converted_Temperature_Setting__c,burstPress); // redmine 35122
                if (resDSCVAR.bResult) {
                    ruptureDisc.DSCVAR__c = resDSCVAR.strRetValue;
                    ruptureDisc.VMNFA__c=resDSCVAR.dblRetValue;
                    ruptureDisc.MNFA__c=resDSCVAR.dblRetValue2;
                    ruptureDisc.MNFA_for_Calculations__c=resDSCVAR.dblRetValue2;
                    ruptureDisc.VMNFA_for_Calculations__c=resDSCVAR.dblRetValue;
                    // ruptureDisc.VMNFA__c=resDSCVAR.dblRetValue;
                    filterTemp1 +=' AND DSCVAR__c=\''+resDSCVAR.strRetValue+'\'';
                    //filterTemp1+=filterTemp;
                    resDSCVAR = RDDiscSizingCapacity.RD_DSCVAR(Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, filterTemp,ruptureDisc.Converted_Temperature_Setting__c,burstPress); // redmine 35122
                    if (resDSCVAR.bResult) {
                        system.debug('resDSCVAR.bResult' + resDSCVAR);
                        system.debug('resDSCVAR.dblRetValue2' + resDSCVAR.dblRetValue2);
                        system.debug('resDSCVAR.dblRetValue' + resDSCVAR.dblRetValue);
                        system.debug('resDSCVAR.Required_Flow_Area_Units__c' + ruptureDisc.Required_Flow_Area_Units__c);
                        system.debug('resDSCVAR.VacRequired_Flow_Area_Units__c' + ruptureDisc.VacRequired_Flow_Area_Units__c);
                        if (ruptureDisc.Required_Flow_Area_Units__c != null && resDSCVAR.dblRetValue2 != null)
                            ruptureDisc.MNFA__c = unitConversions.convertArea('in2', ruptureDisc.Required_Flow_Area_Units__c, resDSCVAR.dblRetValue2).dblRetValue;
                        else
                            ruptureDisc.MNFA__c = resDSCVAR.dblRetValue2;
                        ruptureDisc.MNFA_for_Calculations__c=resDSCVAR.dblRetValue2;
                        //
                        if (ruptureDisc.VacRequired_Flow_Area_Units__c != null && resDSCVAR.dblRetValue != null)
                            ruptureDisc.VMNFA__c = unitConversions.convertArea('in2', ruptureDisc.VacRequired_Flow_Area_Units__c, resDSCVAR.dblRetValue).dblRetValue;
                        else
                            ruptureDisc.VMNFA__c = resDSCVAR.dblRetValue;
                        ruptureDisc.VMNFA_for_Calculations__c=resDSCVAR.dblRetValue;
                    }
                    ruptureDisc.VMNFA__c = unitConversions.SignificantDigitsNormal(ruptureDisc.VMNFA__c, 3, 0).dblRetValue;
                    ruptureDisc.MNFA__c = unitConversions.SignificantDigitsNormal(ruptureDisc.MNFA__c, 3, 0).dblRetValue;
                }
                // system.debug('VACUUM Convertvalue' + ruptureDisc.Converted_Vacuum_Setting__c);
                // system.debug('VACUUM Convertvalue Pressure' + ruptureDisc.Converted_Pressure_Setting__c);
                //CO10 Commented code *****************************************************************************
                // if (ruptureDisc.Relief_Type__c == 'Vacuum Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
                //     if (ruptureDisc.VacConverted_Different_Temp_Setting__c != null) {
                //         result vacCapacity = new result();
                //         Result vacConvertedPress = unitConversions.convertPressure('psig', 'psia', ruptureDisc.Converted_Vacuum_Setting__c.doubleValue());
                //         vacCapacity = RDDiscSizingCapacity.VACUUMCapacity(vacConvertedPress.dblRetValue, ruptureDisc.VacConverted_Different_Temp_Setting__c.doubleValue(), Integer.valueOf(ruptureDisc.Size__c), ruptureDisc.Product__c, ruptureDisc.Seat__c, ruptureDisc.DSCVAR__c, ruptureDisc.Converted_Vacuum_Setting__c.doubleValue());
                //         ruptureDisc.VacFlow_Capacity_Value__c = vacCapacity.dblRetValue;
                //     }
                // }


                // if (doubleFlowCapacity.bResult) {
                //     ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = doubleFlowCapacity.dblRetValue;
                // }
                //#################################################################################################
            } else {
                if (!ReorderFlagLWC)
                    throw new AuraHandledException('No Records Available for selected Product, Size and Seat Configuration.');
            }
        }
        try {
            ruptureDisc.Bypass__c = false;
            if (ruptureDisc.Size__c != Null) {
                if (ruptureDisc.Size_Units__c == 'US Units') {
                    ruptureDisc.SizeDesc__c = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).nmDesc;
                } else if (ruptureDisc.Size_Units__c == 'Metric') {
                    ruptureDisc.SizeDesc__c = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).mmDesc;
                }
            }
            if (ruptureDisc.Product__c != Null) {
                Disc_Type_List__c[] PTCLabel = [SELECT Id, PTC__c, Product__c FROM Disc_Type_List__c WHERE PTC__C =: ruptureDisc.Product__c];
                if (PTCLabel.size() > 0)
                    ruptureDisc.SizeDesc__c += ' ' + PTCLabel[0].Product__c;
            }
            if (ruptureDisc.Seat__c != Null) {
                String proposalDesc=ruptureDisc.Seat__c;


                RD_SeatList__c[] STCLabel = [SELECT Id, PartSeat_Proposal__c, AssySeat__c, PartSeat__c FROM RD_SeatList__c WHERE AssySeat__c =:proposalDesc];
                // Disc_Type_List__c [] PTCLabel=[SELECT Id, PTC__c, Product__c FROM Disc_Type_List__c WHERE PTC__C=:ruptureDisc.Product__c];
                //                if(PTCLabel.size()>0)
                if(STCLabel.size()>0) {
                    if(STCLabel[0].PartSeat_Proposal__c!=null)
                        proposalDesc=STCLabel[0].PartSeat_Proposal__c;
                }

                ruptureDisc.SizeDesc__c += ' (' + proposalDesc + ')';
            }
            upsert ruptureDisc;
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                system.debug('ASHIM MSG:' + dmle.getDmlMessage(i));
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return ruptureDisc;
    }

    public class HClassWrapper {
        @AuraEnabled public Boolean disableIOConn {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > selOptions {
            get;
            set;
        }
        @AuraEnabled public List < SelectOption > requiredFlowRateUnits {
            get;
            set;
        }
        //CO10***************************************************************
        @AuraEnabled public Rupture_Disc__c rdDisc {
            get;
            set;
        }
        public HClassWrapper() {
            this.disableIOConn = disableIOConn;
            this.selOptions = selOptions;
            this.requiredFlowRateUnits = requiredFlowRateUnits;
            this.rdDisc=rdDisc;
        }
    }
    //CODE ADDED FOR CO10 HCLASS OBJECTS ARE REPLACED WITH NEW PRESSURE CONNECTION OOJECT
    // public static List<RD_PressureClassConnections__c> getMasterPressureClassConList{
    //     get {
    //         if(getMasterPressureClassConList==null)

    //     }
    // }
    public static map<string,List<RD_PressureClassConnections__c>> mapPressureClassValues(List<RD_PressureClassConnections__c> listPressRecs) {
        map<string,List<RD_PressureClassConnections__c>> mapPressClass= new map<string,List<RD_PressureClassConnections__c>>();
        for(RD_PressureClassConnections__c rdPC:listPressRecs) {
            if(mapPressClass.ContainsKey(rdPC.Table_Type__c)) {
                mapPressClass.get(rdPC.Table_Type__c).add(rdPC);
            } else {
                List<RD_PressureClassConnections__c> lst=new List<RD_PressureClassConnections__c>();
                lst.add(rdPC);
                mapPressClass.put(rdPC.Table_Type__c,lst);
            }
        }
        return mapPressClass;
    }
    public static List<RD_PressureClassConnections__c> getPressureClassValues(Rupture_Disc__c ruptureDisc) {
        List<RD_PressureClassConnections__c> pcList=new List<RD_PressureClassConnections__c>();
        String SZC = '';
        if (!String.isBlank(ruptureDisc.Size__c))
            SZC = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).SZC;
        else
            SZC = '';
        String previousHClassWhereClause = '';
        String queryString = 'SELECT Id, PTC__c, SZC__c, STC__c, HCLASS__c, HIC__c, HOC__c, Table_Type__c, MNFA__c, HIC_OrderDesc__c, HOC_OrderDesc__c, CDC_Ext_ID__c, Flag__c FROM RD_PressureClassConnections__c WHERE';
        if (ruptureDisc.Product__c != null && ruptureDisc.Size__c != null && ruptureDisc.Seat__c != null) {
            previousHClassWhereClause+=' PTC__c=\''+ruptureDisc.Product__c+'\' AND STC__c=\''+ruptureDisc.Seat__c+'\' AND SZC__c=\''+SZC+'\'';
            System.debug('ruptureDisc.Evaluation_Type__c'+ruptureDisc.Evaluation_Type__c);
            if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') {
                if (ruptureDisc.Flow_Area__c != Null) {
                    decimal i = 0;
                    system.debug('MNFA CHECK--> From Units' + unitConversions.mapRD_MNFAConverstionUOM.get(ruptureDisc.Evaluation_Per__c));
                    system.debug('MNFA CHECK--> From Value' + ruptureDisc.Flow_Area__c);
                    result conRes = unitConversions.convertArea(unitConversions.mapRD_MNFAConverstionUOM.get(ruptureDisc.Evaluation_Per__c), 'in2', ruptureDisc.Flow_Area__c);
                    system.debug('MNFA CHECK--> Final Value' + conRes.dblRetValue);
                    decimal dec=decimal.valueOf(conRes.dblRetValue);
                    previousHClassWhereClause += ' AND MNFA__c>=' + dec;
                }
            }
        } else {
            previousHClassWhereClause+= 'ID =NULL';
        }
        queryString = queryString + previousHClassWhereClause;
        string order_by = ' order by HCLASS__c';
        queryString = queryString + order_by;
        //previousHClassWhereClause = whereClause;
        List < RD_PressureClassConnections__c > sobjList = Database.query(queryString);
        return sobjList;
    }
    @AuraEnabled
    public static List < SelectOption > getHCLASSValues(string tableType,map<string,List<RD_PressureClassConnections__c>> tempMapPressDetails) {
        List < SelectOption > HCLASSOptions = new List < SelectOption > ();
        List < string > uniqueList = new List < string > ();
        HCLASSOptions.add(new selectOption('', ''));
        //List < RD_D_DiscHolderParts__c > lstRDDDHP = HCLASSRecords(ruptureDisc);
        if(tempMapPressDetails.containsKey(tableType)) {
            for (RD_PressureClassConnections__c kv: tempMapPressDetails.get(tableType)) {
                if (!uniqueList.contains(kv.HCLASS__c)) {
                    uniqueList.add(kv.HCLASS__c);
                    String strHCLASS = ConstantsUtil.mapOfHCLASS.get(kv.HCLASS__c);
                    HCLASSOptions.add(new selectOption(kv.HCLASS__c, strHCLASS));
                }
                // if(!uniqueList.contains(kv.HCLASS__c)){
                //     uniqueList.add(kv.HCLASS__c);
                //     HCLASSOptions.add(new selectOption(kv.HCLASS__c,kv.HCLASS__c));
                // }
            }
        }
        return HCLASSOptions;
    }
    @AuraEnabled
    public static List < SelectOption > getHICValues(string tableType,map<string,List<RD_PressureClassConnections__c>> tempMapPressDetails,Rupture_Disc__c ruptureDisc) {
        List < selectOption > HICOptions = new List < selectOption > ();
        List < string > uniqueList = new List < string > ();
        //HICOptions.add(new selectOption('',''));
        //Integer count = 0;

        //List < RD_D_DiscHolderParts__c > lstRDDDHP = HCLASSRecords(ruptureDisc);
        if(tempMapPressDetails.containsKey(tableType)) {
            for (RD_PressureClassConnections__c kv: tempMapPressDetails.get(tableType)) {
                if (!uniqueList.contains(kv.HIC__c) && kv.HCLASS__c == ruptureDisc.Pressure_Class__c) {
                    //count++;
                    uniqueList.add(kv.HIC__c);
                    //HICOptions.add(new selectOption(string.valueOf(kv.ConnSize__c),kv.Connection__c));
                    HICOptions.add(new selectOption(kv.HIC__c,kv.HIC_OrderDesc__c));
                }
            }
        }
        // if(count==0){
        //     HICOptions.remove(0);
        // }
        return HICOptions;
    }
    @AuraEnabled
    public static List < SelectOption > getHOCValues(string tableType,map<string,List<RD_PressureClassConnections__c>> tempMapPressDetails,Rupture_Disc__c ruptureDisc) {
        decimal decHICSize = 0.0;
        if (ruptureDisc.Inlet_Connection__c == 'N') {
            decHICSize = 0.0;
        }

        List < selectOption > HOCOptions = new List < selectOption > ();
        List < string > uniqueList = new List < string > ();
        //HOCOptions.add(new selectOption('',''));
        //List < RD_D_DiscHolderParts__c > lstRDDDHP = HCLASSRecords(ruptureDisc);
        if(tempMapPressDetails.containsKey(tableType)) {
            for (RD_PressureClassConnections__c kv: tempMapPressDetails.get(tableType)) {
                if (!uniqueList.contains(kv.HOC__c) && (kv.HCLASS__c == ruptureDisc.Pressure_Class__c && kv.HIC__c == ruptureDisc.Inlet_Connection__c)) {
                    if (ruptureDisc.ASME_Section_VIII_Division_1__c == true && kv.HOC__c != 'Muffled') {
                        uniqueList.add(kv.HOC__c);
                        HOCOptions.add(new selectOption(kv.HOC__c,kv.HOC_OrderDesc__c));
                    } else if (ruptureDisc.ASME_Section_VIII_Division_1__c == false) {
                        uniqueList.add(kv.HOC__c);
                        HOCOptions.add(new selectOption(kv.HOC__c,kv.HOC_OrderDesc__c));
                    }
                }
            }
        }
        return HOCOptions;
    }
    //+++++++++++++++++++++++++++++++++++++++++CHANGES FOR CO10 ends here+++++++++++++++++++
    @AuraEnabled
    public static HClassWrapper getConsolidateHCLASSOptns(Rupture_Disc__c ruptureDisc) {
        HClassWrapper wrapper = new HClassWrapper();
        wrapper.requiredFlowRateUnits = requiredFlowRateUnitsPicklist(ruptureDisc);
        List < SelectOption > Options = new List < SelectOption > ();
        Options.add(new SelectOption('N/A', 'N/A'));
        //CODE ADDED FOR CO10******************************************************************************
        List<RD_PressureClassConnections__c> pressRecs=getPressureClassValues(ruptureDisc);
        if (getHCLASSValues('Holder Disc Parts',mapPressureClassValues(pressRecs)).size() > 1) {
            wrapper.disableIOConn = false;
            wrapper.selOptions = getHCLASSValues('Holder Disc Parts',mapPressureClassValues(pressRecs));
            wrapper.rdDisc=ruptureDisc;
            return wrapper;
        } else if (getHCLASSValues('Screw Type',mapPressureClassValues(pressRecs)).size() > 1 && ruptureDisc.constrain_product_selection_by_flow__c == 'Yes') {
            wrapper.disableIOConn = false;
            wrapper.selOptions = getHCLASSValues('Screw Type',mapPressureClassValues(pressRecs));
            wrapper.rdDisc=ruptureDisc;
            return wrapper;
        } else {
            if (Options.size() == 1) {
                try {
                    ruptureDisc.Pressure_Class__c = 'N/A';
                    ruptureDisc.Inlet_Connection__c = 'N';
                    ruptureDisc.Outlet_Connection__c = 'N';
                    ruptureDisc=saveRDCapacity(ruptureDisc);
                    wrapper.rdDisc=ruptureDisc;
                    upsert ruptureDisc;
                } catch (System.DmlException dmle) {
                    for (Integer i = 0; i < dmle.getNumDml(); i++) {
                        throw new AuraHandledException(dmle.getDmlMessage(i));
                    }
                }
                wrapper.disableIOConn = true;
                return wrapper;
            }
        }
        //************************************************************************************************* */
        // if (getHCLASSValues(ruptureDisc).size() > 1) {
        //     wrapper.disableIOConn = false;
        //     wrapper.selOptions = getHCLASSValues(ruptureDisc);
        //     return wrapper;
        // } else if (getHCLASSValues2(ruptureDisc).size() > 1) {
        //     wrapper.disableIOConn = false;
        //     wrapper.selOptions = getHCLASSValues2(ruptureDisc);
        //     return wrapper;
        // } else {
        //     if (Options.size() == 1) {
        //         try {
        //             ruptureDisc.Pressure_Class__c = 'N/A';
        //             ruptureDisc.Inlet_Connection__c = 'N';
        //             ruptureDisc.Outlet_Connection__c = 'N';
        //             upsert ruptureDisc;
        //         } catch (System.DmlException dmle) {
        //             for (Integer i = 0; i < dmle.getNumDml(); i++) {
        //                 throw new AuraHandledException(dmle.getDmlMessage(i));
        //             }
        //         }
        //         wrapper.disableIOConn = true;
        //         return wrapper;
        //     }
        // }
        //##########################################################################################################
        return wrapper;
    }

    //HCLASS Options
    public static List < SelectOption > getHCLASSValues(Rupture_Disc__c ruptureDisc) {
        List < SelectOption > HCLASSOptions = new List < SelectOption > ();
        List < string > uniqueList = new List < string > ();
        HCLASSOptions.add(new selectOption('', ''));
        List < RD_D_DiscHolderParts__c > lstRDDDHP = HCLASSRecords(ruptureDisc);
        for (RD_D_DiscHolderParts__c kv: lstRDDDHP) {
            if (!uniqueList.contains(kv.HCLASS__c)) {
                uniqueList.add(kv.HCLASS__c);
                String strHCLASS = ConstantsUtil.mapOfHCLASS.get(kv.HCLASS__c);
                HCLASSOptions.add(new selectOption(kv.HCLASS__c, strHCLASS));
            }
            // if(!uniqueList.contains(kv.HCLASS__c)){
            //     uniqueList.add(kv.HCLASS__c);
            //     HCLASSOptions.add(new selectOption(kv.HCLASS__c,kv.HCLASS__c));
            // }
        }
        return HCLASSOptions;
    }

    //HCLASS OPTIONS
    public static List < SelectOption > getHCLASSValues2(Rupture_Disc__c ruptureDisc) {
        List < selectOption > HCLASSOptions = new List < selectOption > ();
        List < string > uniqueList = new List < string > ();
        HCLASSOptions.add(new selectOption('', ''));
        List < RD_D_tblInletForScrewType__c > lstRDDTIFST = HCLASSRecords2(ruptureDisc);
        for (RD_D_tblInletForScrewType__c kv: lstRDDTIFST) {
            if (!uniqueList.contains(kv.HCLASS__c)) {
                uniqueList.add(kv.HCLASS__c);
                String strHCLASS = ConstantsUtil.mapOfHCLASS.get(kv.HCLASS__c);
                HCLASSOptions.add(new selectOption(kv.HCLASS__c, strHCLASS));
            }
            // if(!uniqueList.contains(kv.HCLASS__c)){
            //     uniqueList.add(kv.HCLASS__c);
            //     HCLASSOptions.add(new selectOption(kv.HCLASS__c,kv.HCLASS__c));
            // }
        }
        return HCLASSOptions;
    }

    //HCLASS Method for Table D_DiscHolderParts
    @AuraEnabled
    public static List < RD_D_DiscHolderParts__c > HCLASSRecords(Rupture_Disc__c ruptureDisc) {
        String SZC = '';
        if (!String.isBlank(ruptureDisc.Size__c))
            SZC = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).SZC;
        else
            SZC = '';

        String previousHClassWhereClause = '';
        String queryString = 'select HCLASS__c,PartCode__c,ConnSize__c,Connection__c,OrderDesc__c from RD_D_DiscHolderParts__c';
        String whereClause = '';
        if (ruptureDisc.Product__c != null && SZC != null) {
            whereClause = whereClause + ' where PTC__c =\'' + ruptureDisc.Product__c + '\' and SZC__c=\'' + SZC + '\'';
        }
        queryString = queryString + whereClause;
        string order_by = ' order by HCLASS__c';
        queryString = queryString + order_by;
        previousHClassWhereClause = whereClause;
        List < RD_D_DiscHolderParts__c > sobjList = Database.query(queryString);
        return sobjList;
    }

    @AuraEnabled
    public static List < RD_D_tblInletForScrewType__c > HCLASSRecords2(Rupture_Disc__c ruptureDisc) {
        String prevHCLASSwhereClause = '';
        String queryString = 'select HCLASS__c,HIC__c from RD_D_tblInletForScrewType__c';
        String whereClause = '';
        String SZC = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).SZC;

        if (ruptureDisc.Product__c != null && ruptureDisc.Size__c != null && ruptureDisc.Seat__c != null) {
            whereClause = whereClause + ' where PTC__c =\'' + ruptureDisc.Product__c + '\' and SZC__c=\'' + SZC + '\' and SeatDesc__c=\'' + ConstantsUtil.getSeatDescFromSZCandSTC(ruptureDisc.Seat__c,ruptureDisc.Size__c) + '\'';
            System.debug('--->>'+ruptureDisc.constrain_product_selection_by_flow__c);
            if (ruptureDisc.constrain_product_selection_by_flow__c != 'Yes')
                whereClause = whereClause + ' AND ID=NULL';
        }
        queryString = queryString + whereClause;
        List < RD_D_tblInletForScrewType__c > sobjList = new List < RD_D_tblInletForScrewType__c > ();
        string order_by = ' order by HCLASS__c';
        queryString = queryString + order_by;
        prevHCLASSwhereClause = whereClause;
        sobjList = Database.query(queryString);
        return sobjList;
    }

    @AuraEnabled
    public static List < SelectOption > getConsolidateHICOptns(Rupture_Disc__c ruptureDisc) {
        List < selectOption > Options = new List < selectOption > ();
        Options.add(new selectOption('N', 'N/A'));
        //CODE ADDED FOR CO10******************************************************************************
        List<RD_PressureClassConnections__c> pressRecs=getPressureClassValues(ruptureDisc);
        if (getHICValues('Holder Disc Parts',mapPressureClassValues(pressRecs),ruptureDisc).size() >= 1)
            return getHICValues('Holder Disc Parts',mapPressureClassValues(pressRecs),ruptureDisc);
        else if (getHICValues('Screw Type',mapPressureClassValues(pressRecs),ruptureDisc).size() >= 1)
            return getHICValues('Screw Type',mapPressureClassValues(pressRecs),ruptureDisc);
        else
            return Options;
        //*************************************************************************************************
        // if (getHICValues(ruptureDisc).size() >= 1)
        //     return getHICValues(ruptureDisc);
        // else if (getHICValues2(ruptureDisc).size() >= 1)
        //     return getHICValues2(ruptureDisc);
        // else
        //     return Options;
        //#################################################################################################
    }

    //HIC Options based from RD_D_DiscHolderParts__c object
    @AuraEnabled
    public static List < SelectOption > getHICValues(Rupture_Disc__c ruptureDisc) {
        List < selectOption > HICOptions = new List < selectOption > ();
        List < string > uniqueList = new List < string > ();
        //HICOptions.add(new selectOption('',''));
        //Integer count = 0;

        List < RD_D_DiscHolderParts__c > lstRDDDHP = HCLASSRecords(ruptureDisc);
        for (RD_D_DiscHolderParts__c kv: lstRDDDHP) {
            if (!uniqueList.contains(kv.Connection__c) && kv.PartCode__c == '01') {
                //count++;
                uniqueList.add(kv.Connection__c);
                //HICOptions.add(new selectOption(string.valueOf(kv.ConnSize__c),kv.Connection__c));
                HICOptions.add(new selectOption(kv.Connection__c, kv.Connection__c));
            }
        }
        // if(count==0){
        //     HICOptions.remove(0);
        // }
        return HICOptions;
    }

    //HIC OPTIONS
    @AuraEnabled
    public static List < SelectOption > getHICValues2(Rupture_Disc__c ruptureDisc) {
        List < selectOption > HICOptions = new List < selectOption > ();
        List < string > uniqueList = new List < string > ();
        //HICOptions.add(new selectOption('',''));
        //Integer count = 0;
        List < RD_D_tblInletForScrewType__c > lstRDDTIFST = HCLASSRecords2(ruptureDisc);
        for (RD_D_tblInletForScrewType__c kv: lstRDDTIFST) {
            if (!uniqueList.contains(kv.HIC__c) && kv.HCLASS__c == ruptureDisc.Pressure_Class__c) {
                //count++;
                uniqueList.add(kv.HIC__c);
                HICOptions.add(new selectOption(kv.HIC__c, kv.HIC__c));
                //HICOptions.add(new selectOption(kv.Connection__c,kv.OrderDesc__c));
            }
        }
        // if(count==0){
        //     HICOptions.remove(0);
        // }
        return HICOptions;
    }

    @AuraEnabled
    public static List < SelectOption > getConsolidateHOCOptns(Rupture_Disc__c ruptureDisc) {
        List < selectOption > Options = new List < selectOption > ();
        Options.add(new selectOption('N', 'N'));
        //CODE ADDED FOR CO10******************************************************************************
        List<RD_PressureClassConnections__c> pressRecs=getPressureClassValues(ruptureDisc);
        if (getHOCValues('Holder Disc Parts',mapPressureClassValues(pressRecs),ruptureDisc).size() >= 1)
            return getHOCValues('Holder Disc Parts',mapPressureClassValues(pressRecs),ruptureDisc);
        else
            return Options;
        //*************************************************************************************************
        // if (getHOCValues(ruptureDisc).size() >= 1)
        //     return getHOCValues(ruptureDisc);
        // else
        //     return Options;
        //#################################################################################################
    }

    //HOC Options based from RD_D_DiscHolderParts__c object
    @AuraEnabled
    public static List < SelectOption > getHOCValues(Rupture_Disc__c ruptureDisc) {
        decimal decHICSize = 0.0;
        if (ruptureDisc.Inlet_Connection__c == 'N') {
            decHICSize = 0.0;
        } else {
            if (ruptureDisc.Product__c == 'WMP') {
                decHICSize = ConstantsUtil.mapOfWithWMPHIC.get(ruptureDisc.Inlet_Connection__c);
            } else {
                decHICSize = ConstantsUtil.mapOfWithoutWMPHIC.get(ruptureDisc.Inlet_Connection__c);
            }
        }
        List < selectOption > HOCOptions = new List < selectOption > ();
        List < string > uniqueList = new List < string > ();
        //HOCOptions.add(new selectOption('',''));
        List < RD_D_DiscHolderParts__c > lstRDDDHP = HCLASSRecords(ruptureDisc);
        for (RD_D_DiscHolderParts__c kv: lstRDDDHP) {
            if (!uniqueList.contains(kv.Connection__c) && kv.PartCode__c == '02' && kv.ConnSize__c >= decHICSize) {
                if (ruptureDisc.ASME_Section_VIII_Division_1__c == true && kv.Connection__c != 'Muffled') {
                    uniqueList.add(kv.Connection__c);
                    HOCOptions.add(new selectOption(kv.Connection__c, kv.Connection__c));
                } else if (ruptureDisc.ASME_Section_VIII_Division_1__c == false) {
                    uniqueList.add(kv.Connection__c);
                    HOCOptions.add(new selectOption(kv.Connection__c, kv.Connection__c));
                }
            }
        }
        return HOCOptions;
    }
    //CO10******************************************************************************************
    @AuraEnabled
    public static Rupture_Disc__c recalMNFA(Rupture_Disc__c ruptureDisc) {
        decimal decConRelievingPressure = ruptureDisc.Converted_Relieving_Pressure_Value__c;
        decimal decConRelievingTemp = ruptureDisc.Converted_Relieving_Temperature__c;
        List < String > lstOfFauskeOmega = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid'
        };
        String SZC = '';
        if (!String.isBlank(ruptureDisc.Size__c))
            SZC = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).SZC;
        else
            SZC = '';
        String previousHClassWhereClause = '';
        String queryString1 = 'SELECT Id, PTC__c, SZC__c, STC__c, HCLASS__c, HIC__c, HOC__c, Table_Type__c, MNFA__c, HIC_OrderDesc__c, HOC_OrderDesc__c, CDC_Ext_ID__c, Flag__c FROM RD_PressureClassConnections__c WHERE ID!=NULL ';
        if (ruptureDisc.Pressure_Class__c != null && ruptureDisc.Outlet_Connection__c != null && ruptureDisc.Inlet_Connection__c != null) {
            previousHClassWhereClause+='AND PTC__c=\''+ruptureDisc.Product__c+'\' AND STC__c=\''+ruptureDisc.Seat__c+'\' AND SZC__c=\''+SZC+'\' AND HOC__c =\''+ruptureDisc.Outlet_Connection__c+'\' AND HIC__c=\''+ruptureDisc.Inlet_Connection__c+'\' AND HCLASS__c=\''+ruptureDisc.Pressure_Class__c+'\'';
        }
        if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') {
            if (ruptureDisc.Flow_Area__c != Null) {
                decimal i = 0;
                system.debug('MNFA CHECK--> From Units' + unitConversions.mapRD_MNFAConverstionUOM.get(ruptureDisc.Evaluation_Per__c));
                system.debug('MNFA CHECK--> From Value' + ruptureDisc.Flow_Area__c);
                result conRes = unitConversions.convertArea(unitConversions.mapRD_MNFAConverstionUOM.get(ruptureDisc.Evaluation_Per__c), 'in2', ruptureDisc.Flow_Area__c);
                system.debug('MNFA CHECK--> Final Value' + conRes.dblRetValue);
                decimal dec=decimal.valueOf(conRes.dblRetValue);
                previousHClassWhereClause += ' AND MNFA__c>=' + dec;
            }
        }
        System.debug('AAAAAAAAAAA'+queryString1);
        System.debug('AAAAAAAAAAA'+previousHClassWhereClause);
        List < RD_PressureClassConnections__c > lstPrsRec = Database.query(queryString1+previousHClassWhereClause+ ' ORDER BY MNFA__c DESC');
        if (lstPrsRec.size() > 0 ) {
            // ruptureDisc.M
            //if(lstPrsRec[0].MNFA__c>ruptureDisc.MNFA__c) {
                ruptureDisc.MNFA_for_Calculations__c=lstPrsRec[0].MNFA__c;
                if (ruptureDisc.Required_Flow_Area_Units__c != null)
                    ruptureDisc.MNFA__c = unitConversions.convertArea('in2', ruptureDisc.Required_Flow_Area_Units__c, lstPrsRec[0].MNFA__c).dblRetValue;
                else
                    ruptureDisc.MNFA__c = lstPrsRec[0].MNFA__c;
           // }


            //
            // if (ruptureDisc.VacRequired_Flow_Area_Units__c != null && resDSCVAR.dblRetValue != null)
            //     ruptureDisc.VMNFA__c = unitConversions.convertArea('in2', ruptureDisc.VacRequired_Flow_Area_Units__c, resDSCVAR.dblRetValue).dblRetValue;
            // else
            //     ruptureDisc.VMNFA__c = resDSCVAR.dblRetValue;
            // ruptureDisc.VMNFA_for_Calculations__c=resDSCVAR.dblRetValue;
            // ruptureDisc.VMNFA__c = unitConversions.SignificantDigitsNormal(ruptureDisc.VMNFA__c, 3, 0).dblRetValue;
            ruptureDisc.MNFA__c = unitConversions.SignificantDigitsNormal(ruptureDisc.MNFA__c, 3, 0).dblRetValue;
        } else {
            if (!ReorderFlagLWC)
                throw new AuraHandledException('Please enter valid and product and pressure connections for giving size');
        }
        ruptureDisc=saveRDCapacity(ruptureDisc);
        upsert ruptureDisc;
        return ruptureDisc;
    }

    //##############################################################################################
    @AuraEnabled
    public static Rupture_Disc__c saveHClass(Rupture_Disc__c ruptureDisc) {
        decimal decConRelievingPressure = ruptureDisc.Converted_Relieving_Pressure_Value__c;
        decimal decConRelievingTemp = ruptureDisc.Converted_Relieving_Temperature__c;
        List < String > lstOfFauskeOmega = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid'
        };
        if (!ReorderFlagLWC) {
            // ruptureDisc = clearSectEProductSelection(ruptureDisc);
             ruptureDisc =clearSectFManufacturingRange(ruptureDisc);
             ruptureDisc =clearSectGComponents(ruptureDisc);
         }
        // if (ruptureDisc.Relief_Type__c == 'Pressure Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
        //     if (unitConversions.listGasFlowRatenew.contains(ruptureDisc.Evaluation_Per__c) || unitConversions.listStreamFlowRatenew.contains(ruptureDisc.Evaluation_Per__c)) {
        //         if (ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c != null && ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c != null) {
        //             Double convTemp = 999999999;
        //             if (ruptureDisc.Evaluation_Per__c != 'ASME Steam' && ruptureDisc.Evaluation_Per__c != 'ISO Wet Steam') {
        //                 convTemp = decConRelievingTemp;
        //             }
        //             result resultFlowCapacity = unitConversions.convertGasFlowRate(unitConversions.mapRD_FlowRateBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c, ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c, decConRelievingPressure, ruptureDisc.Molecular_Weight__c, convTemp, ruptureDisc.Compressibility_Factor__c);
        //             if (resultFlowCapacity.bResult) {
        //                 result res1 = unitConversions.SignificantDigitsNormal(resultFlowCapacity.dblRetValue, 4, -99);
        //                 ruptureDisc.Product_Flow_Capacity_Value__c = res1.dblRetValue;
        //             }
        //         }
        //     } else {
        //         if (ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c != null) {
        //             Double denSpecGravity = 1.0;
        //             if (!lstOfFauskeOmega.contains(ruptureDisc.Evaluation_Per__c)) {
        //                 denSpecGravity = ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c;
        //                 Result resultConvertDensity1 = unitConversions.convertDensitySpecifyVolume(unitConversions.mapRD_DensitySpecificVolumeSpecificGravityBaseUOM.get(ruptureDisc.Evaluation_Per__c), 'lb/ft3', ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c);
        //                 denSpecGravity = resultConvertDensity1.dblRetValue;
        //             }
        //             result resultFlowCapacity = unitConversions.convertLiquidFlowRate(unitConversions.mapRD_FlowRateBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c, ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c, denSpecGravity);
        //             if (resultFlowCapacity.bResult) {
        //                 result resFlowCap = unitConversions.SignificantDigitsNormal(resultFlowCapacity.dblRetValue, 4, -99);
        //                 ruptureDisc.Product_Flow_Capacity_Value__c = resFlowCap.dblRetValue;
        //             }
        //         }
        //     }
        // }

        // if (ruptureDisc.Relief_Type__c == 'Vacuum Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
        //     result vacCapacity = new result();
        //     Result vacConvertedPress = unitConversions.convertPressure('psig', 'psia', ruptureDisc.Converted_Vacuum_Setting__c.doubleValue());

        //     if (ruptureDisc.VacFlow_Capacity_Value__c != null && ruptureDisc.VacProduct_Flow_Capacity_Units__c != null) {
        //         result resultFlowCapacity = unitConversions.convertGasFlowRate('lb/h', ruptureDisc.VacProduct_Flow_Capacity_Units__c, ruptureDisc.VacFlow_Capacity_Value__c, vacConvertedPress.dblRetValue, double.ValueOf(28.964), ruptureDisc.VacConverted_Different_Temp_Setting__c.doubleValue(), double.valueOf(1));
        //         if (resultFlowCapacity.bResult) {
        //             result resVacFlowCap1 = unitConversions.SignificantDigitsNormal(resultFlowCapacity.dblRetValue, 4, -99);
        //             ruptureDisc.VacProduct_Flow_Capacity_Value__c = resVacFlowCap1.dblRetValue;
        //         }
        //     }
        // }
       // CODE ADDED for CO10***************************************
       Boolean reCalculateMNFA=false;
       List<RD_PressureClassConnections__c> pressRecs=getPressureClassValues(ruptureDisc);
       List < SelectOption > lstPCOptions = getHCLASSValues('Holder Disc Parts',mapPressureClassValues(pressRecs));
       List < SelectOption > lstPC2Options = getHCLASSValues('Screw Type',mapPressureClassValues(pressRecs));
       // *********************************************************
       // List < SelectOption > lstPCOptions = getHCLASSValues(ruptureDisc);
       // List < SelectOption > lstPC2Options = getHCLASSValues2(ruptureDisc);
       //##########################################################################
        List < SelectOption > lstHICOptions = getConsolidateHICOptns(ruptureDisc);
        List < SelectOption > lstHOCOptions = getConsolidateHOCOptns(ruptureDisc);
        //if(String.isBlank(ruptureDisc.Pressure_Class__c)){
        //ruptureDisc.Pressure_Class__c = 'N/A';
        if (lstPCOptions.size() > 1 || lstPC2Options.size() > 1) {
            if ((lstPCOptions.size() >= 1 || lstPC2Options.size() >= 1) && String.isBlank(ruptureDisc.Pressure_Class__c)) {
                if (!ReorderFlagLWC)
                    throw new AuraHandledException('Please select value from Pressure class dropdown');
            }

            //if(String.isBlank(ruptureDisc.Inlet_Connection__c)){
            //ruptureDisc.Inlet_Connection__c = 'N';
            if (lstHICOptions.size() >= 1 && String.isBlank(ruptureDisc.Inlet_Connection__c)) {
                if (!ReorderFlagLWC)
                    throw new AuraHandledException('Please select value from Inlet Connection dropdown');
            }

            //if(String.isBlank(ruptureDisc.Outlet_Connection__c)){
            //ruptureDisc.Outlet_Connection__c = 'N';
            if (lstHOCOptions.size() >= 1 && String.isBlank(ruptureDisc.Outlet_Connection__c)) {
                if (!ReorderFlagLWC)
                    throw new AuraHandledException('Please select value from Outlet Connection dropdown');
            }
            //reCalculateMNFA=true;
        }
        String strDPM = '';

        if (ruptureDisc.Is_there_a_liquid_relief_scenario__c == 'Yes') {
            strDPM = 'Y';
        } else if (ruptureDisc.Is_there_a_liquid_relief_scenario__c == 'No') {
            strDPM = 'N';
        }

        String queryString = 'SELECT Id, DPM__c, DSCVAR__c, PressLL__c, PressUL__c, PTC__c, STC__c, SZC__c FROM RD_tblASMEValues__c WHERE PTC__c=\'' + ruptureDisc.product__c + '\' and STC__c=\'' + ruptureDisc.seat__c + '\' and SZC__c=\'' + ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).SZC + '\' AND DPM__c=\'' + strDPM + '\'';
        if (ruptureDisc.Relief_Type__c == 'Pressure Relief' || ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief')
            queryString += ' AND PressLL__c<=' + ruptureDisc.Converted_Pressure_Setting__c + ' AND PressUL__c>=' + ruptureDisc.Converted_Pressure_Setting__c + ' ';
        //Filter For Inlet Connection
        if (ruptureDisc.Inlet_Connection__c != null)
            queryString += ' AND HIC__c IN (\'' + ruptureDisc.Inlet_Connection__c + '\',\'-\')';


        //Filter For Outlet Connection
        if (ruptureDisc.Outlet_Connection__c != null)
            queryString += ' AND HOC__c IN (\'' + ruptureDisc.Outlet_Connection__c + '\',\'-\')';
        //List<RD_tblASMEValues__c> lstOfASMERec =new List<RD_tblASMEValues__c>();
        system.debug('queryString-->' + queryString);
        List < RD_tblASMEValues__c > lstOfASMERec = Database.query(queryString);
        if (lstOfASMERec.size() == 0 && ruptureDisc.ASME_Section_VIII_Division_1__c == true) {
            if (!ReorderFlagLWC)
                throw new AuraHandledException('Please enter valid Inlet and Outlet Connection for selected product');
        }
        // if(reCalculateMNFA) {
        //     String SZC = '';
        //     if (!String.isBlank(ruptureDisc.Size__c))
        //         SZC = ConstantsUtil.getSizeDesc(ruptureDisc.Size__c).SZC;
        //     else
        //         SZC = '';
        //     String previousHClassWhereClause = '';
        //     String queryString1 = 'SELECT Id, PTC__c, SZC__c, STC__c, HCLASS__c, HIC__c, HOC__c, Table_Type__c, MNFA__c, HIC_OrderDesc__c, HOC_OrderDesc__c, CDC_Ext_ID__c, Flag__c FROM RD_PressureClassConnections__c WHERE';
        //     if (ruptureDisc.Pressure_Class__c != null && ruptureDisc.Outlet_Connection__c != null && ruptureDisc.Inlet_Connection__c != null) {
        //         previousHClassWhereClause+=' PTC__c=\''+ruptureDisc.Product__c+'\' AND STC__c=\''+ruptureDisc.Seat__c+'\' AND SZC__c=\''+SZC+'\' AND HOC__c =\''+ruptureDisc.Outlet_Connection__c+'\' AND HIC__c=\''+ruptureDisc.Inlet_Connection__c+'\' AND HCLASS__c=\''+ruptureDisc.Pressure_Class__c+'\' ORDER BY MNFA__c DESC';
        //     }
        //     List < RD_PressureClassConnections__c > lstPrsRec = Database.query(queryString1+previousHClassWhereClause);
        //     if (lstPrsRec.size() > 0 ) {
        //        // ruptureDisc.M
        //         if (ruptureDisc.Required_Flow_Area_Units__c != null)
        //             ruptureDisc.MNFA__c = unitConversions.convertArea('in2', ruptureDisc.Required_Flow_Area_Units__c, lstPrsRec[0].MNFA__c).dblRetValue;
        //         else
        //             ruptureDisc.MNFA__c = lstPrsRec[0].MNFA__c;
        //         ruptureDisc.MNFA_for_Calculations__c=lstPrsRec[0].MNFA__c;
        //         //
        //         // if (ruptureDisc.VacRequired_Flow_Area_Units__c != null && resDSCVAR.dblRetValue != null)
        //         //     ruptureDisc.VMNFA__c = unitConversions.convertArea('in2', ruptureDisc.VacRequired_Flow_Area_Units__c, resDSCVAR.dblRetValue).dblRetValue;
        //         // else
        //         //     ruptureDisc.VMNFA__c = resDSCVAR.dblRetValue;
        //         // ruptureDisc.VMNFA_for_Calculations__c=resDSCVAR.dblRetValue;
        //         // ruptureDisc.VMNFA__c = unitConversions.SignificantDigitsNormal(ruptureDisc.VMNFA__c, 3, 0).dblRetValue;
        //         ruptureDisc.MNFA__c = unitConversions.SignificantDigitsNormal(ruptureDisc.MNFA__c, 3, 0).dblRetValue;
        //     }
        // }
        try {
            ruptureDisc.Bypass__c = false;
            update ruptureDisc;
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                if (!ReorderFlagLWC)
                    throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return ruptureDisc;
    }

    // public class RDOptions {
    //     @AuraEnabled public String product {get;set;}
    //     @AuraEnabled public String seat {get;set;}
    //     @AuraEnabled public String size {get;set;}
    //     @AuraEnabled public String productValue {get;set;}
    //     @AuraEnabled public String seatValue {get;set;}
    //     @AuraEnabled public String sizeValue {get;set;}
    //     @AuraEnabled public String imageURL {get;set;}
    //     @AuraEnabled public String rdId{get;set;}
    //     @AuraEnabled public Boolean isChecked{get;set;}
    //     @AuraEnabled public Map<string,string> szcMap {get;set;}
    //     public RDOptions(String PTC, String STC, String SZC, String rdmb, Boolean isChck) {
    //         szcMap=new Map<string,string>();
    //         if (ConstantsUtil.mapPTCDesc.containsKey(PTC))
    //             productValue = ConstantsUtil.mapPTCDesc.get(PTC);
    //         else
    //             productValue=PTC;
    //         if (ConstantsUtil.mapSTCDesc.containsKey(STC))
    //             seatValue = ConstantsUtil.mapSTCDesc.get(STC);
    //         else
    //             seatValue=STC;
    //         if(!szcMap.containsKey(SZC)) {
    //             //string Sval=ConstantsUtil.getSizeDesc(SZC);
    //             if(ConstantsUtil.getSizeDesc(SZC)!=null)
    //                 sizeValue = ConstantsUtil.getSzcDesc(SZC);
    //             else
    //                 sizeValue=SZC;
    //             szcMap.put(SZC,sizeValue);
    //         } else {
    //             sizeValue=szcMap.get(SZC);
    //         }
    //         productValue=PTC;
    //         seatValue=STC;
    //         sizeValue=szcMap.get(SZC);//sizeValue1;
    //         product = PTC;
    //         seat = STC;
    //         size = SZC;
    //         imageURL = '';
    //         rdId = rdmb;
    //         isChecked = isChck;
    //     }
    // }

    public class RDOptions {
        @AuraEnabled public String product {
            get;
            set;
        }
        @AuraEnabled public String seat {
            get;
            set;
        }
        @AuraEnabled public String size {
            get;
            set;
        }
        @AuraEnabled public String productValue {
            get;
            set;
        }
        @AuraEnabled public String seatValue {
            get;
            set;
        }
        @AuraEnabled public String sizeValue {
            get;
            set;
        }
        @AuraEnabled public String imageURL {
            get;
            set;
        }
        @AuraEnabled public String rdId {
            get;
            set;
        }
        @AuraEnabled public Boolean isChecked {
            get;
            set;
        }
        public RDOptions(String PTC, String STC, String SZC, String rdmb, Boolean isChck) {
            if (ConstantsUtil.mapPTCDesc.containsKey(PTC))
                productValue = ConstantsUtil.mapPTCDesc.get(PTC);
            else
                productValue = PTC;
            // if (ConstantsUtil.mapSTCDesc.containsKey(STC))
            //     seatValue = ConstantsUtil.mapSTCDesc.get(STC);
            // else
            //     seatValue = STC;
            if (ConstantsUtil.mapSTCDescWithSZC.containsKey(STC))
                seatValue = ConstantsUtil.getSeatDescFromSZCandSTC(STC,SZC);
            else
                seatValue = STC;


            if (ConstantsUtil.getSizeDesc(SZC) != null)
                sizeValue = ConstantsUtil.getSzcDesc(SZC);
            else
                sizeValue = SZC;
            product = PTC;
            seat = STC;
            size = SZC;
            imageURL = '';
            rdId = rdmb;
            isChecked = isChck;
        }
    }

    @AuraEnabled(cacheable = true)
    public static Map < String, List < SelectOption >> getConsolidatedPicklistValues(Rupture_Disc__c ruptureDisc, String rupRecordId, List < id > lstRDMBIds) {
        Map < String, List < SelectOption >> conPickValues = new Map < String, List < SelectOption >> ();
        set < string > uniquePTC = new set < string > ();
        set < string > uniqueSTC = new set < string > ();
        set < string > uniqueSZC = new set < string > ();
        set < string > uniqueSize = new set < string > ();
        conPickValues.put('PTC', new List < selectOption > ());
        conPickValues.put('STC', new List < selectOption > ());
        conPickValues.put('SZC', new List < selectOption > ());
        // List<RDMasterBlaster__c> lstRDMS = rDMBRecords(ruptureDisc,rupRecordId);
        Map < String, String > mapPTCNamevsPTC = new Map < String, String > ();
        Map < String, String > mapSTCNamevsSTC = new Map < String, String > ();
        set < decimal > listSize = new set < decimal > ();
        map < decimal, string > mapSzLst = new map < decimal, string > ();
        // Integer count=1;
        for (RDMasterBlaster__c kv: [select id, PTC__c, STC__c, SZC__c from RDMasterBlaster__c where id IN: lstRDMBIds]) {
            // for (RDMasterBlaster__c kv: lstRDMS ) {//,SZC__c  //Commented for SZC mantainence
            // if(lstRDMBIds.contains(kv.id)) {
            if (uniquePTC.add(ConstantsUtil.mapPTCDesc.get(kv.PTC__c))) {
                //lstPTCs.add(ConstantsUtil.mapPTCDesc.get(kv.PTC__c));
                mapPTCNamevsPTC.put(ConstantsUtil.mapPTCDesc.get(kv.PTC__c), kv.PTC__c);
            }
            // if (uniqueSTC.add(ConstantsUtil.mapSTCDesc.get(kv.STC__c))) {
            //     //lstSTCs.add(ConstantsUtil.mapSTCDesc.get(kv.STC__c));
            //     mapSTCNamevsSTC.put(ConstantsUtil.mapSTCDesc.get(kv.STC__c), kv.STC__c);
            // }
            if (uniqueSTC.add(ConstantsUtil.getSeatDescFromSZCandSTC(kv.STC__c,kv.SZC__c))) {
                //lstSTCs.add(ConstantsUtil.mapSTCDesc.get(kv.STC__c));
                mapSTCNamevsSTC.put(ConstantsUtil.getSeatDescFromSZCandSTC(kv.STC__c,kv.SZC__c), kv.STC__c);
            }

            if (uniqueSize.add(kv.SZC__c + '')) {
                // Integer a= Integer.valueOf(kv.SZC__c);
                String val = String.valueOf(kv.SZC__c);
                string strSize = '';
                if (ConstantsUtil.getSizeDesc(val) != null)
                    strSize = ConstantsUtil.getSzcDesc(val);
                else
                    strSize = val;
                if (uniqueSZC.add(strSize)) {
                    if (strSize != '') {
                        listSize.add(ConstantsUtil.getSizeVal(val));
                        mapSzLst.put(ConstantsUtil.getSizeVal(val), val);
                        //conPickValues.get('SZC').add(new selectOption(val,strSize));
                    }
                }
            }
            //}
            // else
            //     strSize=val;
            // if(!uniqueSZC.add(val) && lstRDMBIds.contains(kv.id)){
            //     if(strSize != ''){
            //         conPickValues.get('SZC').add(new selectOption(val,strSize));
            //     }
            // }
        }
        List < String > PTCList = new List < String > (uniquePTC);
        List < String > STCList = new List < String > (uniqueSTC);
        List < String > SZCList = new List < String > (uniqueSize);
        List < Decimal > listSize1 = new List < Decimal > (listSize);
        // listSize
        PTCList.sort();
        listSize1.sort();
        STCList.sort();

        // for(decimal dec:listSize1) {
        //     if(mapSzLst.get(dec)!=null)
        //         conPickValues.get('SZC').add(new selectOption(mapSzLst.get(dec),ConstantsUtil.getSzcDesc(mapSzLst.get(dec))));
        // }
        for (string str: PTCList) {
            if (mapPTCNamevsPTC.get(str) != null)
                conPickValues.get('PTC').add(new selectOption(mapPTCNamevsPTC.get(str), str));
            else
                conPickValues.get('PTC').add(new selectOption(str, str));
        }
        //SELECT Desc__c, AssySeat__c,Sort_Order__c FROM RD_SeatList__c AssySeat__c in :(STCList) WHERE ORDER BY Sort_Order__c
        //SELECT  code__c, Desc__c, Sort_Order__c FROM RD_SizeList__c
        for (RD_SizeList__c szcvals: [SELECT code__c, Desc__c, Sort_Order__c FROM RD_SizeList__c WHERE code__c in: SZCList ORDER BY Sort_Order__c]) {
            conPickValues.get('SZC').add(new selectOption(szcvals.code__c, szcvals.Desc__c));
        }
        for (RD_SeatList__c stcvals: [SELECT Desc__c, AssySeat__c, Sort_Order__c FROM RD_SeatList__c WHERE Desc__c in: STCList ORDER BY Sort_Order__c]) {
            conPickValues.get('STC').add(new selectOption(stcvals.AssySeat__c, stcvals.Desc__c));
        }
        return conPickValues;
    }
    @AuraEnabled(cacheable = true)
    public static List < SelectOption > getProductPicklistValues(Rupture_Disc__c ruptureDisc, String rupRecordId, List < id > lstRDMBIds) {
        List < selectOption > prodOptions = new List < selectOption > ();
        prodOptions.add(new selectOption('', ''));
        List < string > uniqueList = new List < string > ();
        List < RDMasterBlaster__c > lstRDMS = rDMBRecords(ruptureDisc, rupRecordId);
        List < string > lstPTCs = new List < String > ();
        Map < String, String > mapPTCNamevsPTC = new Map < String, String > ();
        Set < String > setPTCs = new Set < String > ();
        for (RDMasterBlaster__c kv: lstRDMS) {
            if (setPTCs.add(ConstantsUtil.mapPTCDesc.get(kv.PTC__c)) && lstRDMBIds.contains(kv.id)) {
                lstPTCs.add(ConstantsUtil.mapPTCDesc.get(kv.PTC__c));
                mapPTCNamevsPTC.put(ConstantsUtil.mapPTCDesc.get(kv.PTC__c), kv.PTC__c);
            }

        }
        lstPTCs.sort();
        for (string str: lstPTCs) {
            prodOptions.add(new selectOption(mapPTCNamevsPTC.get(str), str));
        }
        // for (RDMasterBlaster__c kv: lstRDMS ) {
        //     if(!uniqueList.contains(kv.PTC__c)){
        //         uniqueList.add(kv.PTC__c);
        //         prodOptions.add(new selectOption(kv.PTC__c,ConstantsUtil.mapPTCDesc.get(kv.PTC__c)));
        //     }
        // }
        //prodOptions.sort();
        return prodOptions;
    }

    @AuraEnabled(cacheable = true)
    public static List < SelectOption > getSeatPicklistValues(Rupture_Disc__c ruptureDisc, String rupRecordId, List < id > lstRDMBIds) {
        List < selectOption > seatOptions = new List < selectOption > ();
        seatOptions.add(new selectOption('', ''));
        List < string > uniqueList = new List < string > ();
        List < RDMasterBlaster__c > lstRDMS = rDMBRecords(ruptureDisc, rupRecordId);
        List < string > lstSTCs = new List < String > ();
        Map < String, String > mapSTCNamevsSTC = new Map < String, String > ();
        Set < String > setSTCs = new Set < String > ();
        for (RDMasterBlaster__c kv: lstRDMS) {
            // if (setSTCs.add(ConstantsUtil.mapSTCDesc.get(kv.STC__c)) && lstRDMBIds.contains(kv.id)) {
            //     lstSTCs.add(ConstantsUtil.mapSTCDesc.get(kv.STC__c));
            //     mapSTCNamevsSTC.put(ConstantsUtil.mapSTCDesc.get(kv.STC__c), kv.STC__c);
            // }
            if (setSTCs.add(ConstantsUtil.getSeatDescFromSZCandSTC(kv.STC__c,kv.SZC__c)) && lstRDMBIds.contains(kv.id)) {
                lstSTCs.add(ConstantsUtil.getSeatDescFromSZCandSTC(kv.STC__c,kv.SZC__c));
                mapSTCNamevsSTC.put(ConstantsUtil.getSeatDescFromSZCandSTC(kv.STC__c,kv.SZC__c), kv.STC__c);
            }
        }
        lstSTCs.sort();
        for (string str: lstSTCs) {
            seatOptions.add(new selectOption(mapSTCNamevsSTC.get(str), str));
        }
        // for (RDMasterBlaster__c kv: lstRDMS ) {
        //     if(!uniqueList.contains(kv.STC__c)){
        //         uniqueList.add(kv.STC__c);
        //         seatOptions.add(new selectOption(kv.STC__c,ConstantsUtil.mapSTCDesc.get(kv.STC__c)));
        //     }
        // }
        return seatOptions;
    }

    @AuraEnabled(cacheable = true)
    public static List < SelectOption > getSizePicklistValues(Rupture_Disc__c ruptureDisc, String rupRecordId, List < id > lstRDMBIds) {
        List < selectOption > sizeOptions = new List < selectOption > ();
        sizeOptions.add(new selectOption('', ''));
        List < string > uniqueList = new List < String > ();
        List < RDMasterBlaster__c > lstRDMS = rDMBRecords(ruptureDisc, rupRecordId);
        String strSize = '';

        for (RDMasterBlaster__c kv: lstRDMS) {
            if (lstRDMBIds.contains(kv.id)) {
                //Integer a= Integer.valueOf(kv.SZC__c.stripTrailingZeros());
                String val = kv.SZC__c;
                if (ConstantsUtil.getSizeDesc(val) != null)
                    strSize = ConstantsUtil.getSzcDesc(val);
                else
                    strSize = val;
                if (!uniqueList.contains(val)) {
                    if (strSize != '') {
                        uniqueList.add(val);
                        sizeOptions.add(new selectOption(val, strSize));
                    }
                }
            }
        }
        return sizeOptions;
    }

    // @AuraEnabled(cacheable=true)
    // public static List<RDOptions> getRupDiscRecords(Rupture_Disc__c ruptDiscFields, String rupRecordId,List<id> lstRDMBIds) {
    //     Rupture_Disc__c ruptureDisc = [Select  Id, Product__c, Seat__c, Size__c FROM Rupture_Disc__c where Id =: rupRecordId];//, Size_Units__c
    //     Set<String> uniqueCombinations = new Set<String>();
    //     List<RDOptions> records = new List<RDOptions>();
    //     List<RDMasterBlaster__c> lstRDMS = rDMBRecords(ruptureDisc,rupRecordId);
    //     Map<string,string> szcMap=new Map<string,string>();
    //     // if(!szcMap.containsKey(SZC)) {
    //         //     //string Sval=ConstantsUtil.getSizeDesc(SZC);
    //         //     if(ConstantsUtil.getSizeDesc(SZC)!=null)
    //         //         sizeValue = ConstantsUtil.getSzcDesc(SZC);
    //         //     else
    //         //         sizeValue=SZC;
    //         //     szcMap.put(SZC,sizeValue);
    //         // } else {
    //         //     sizeValue=szcMap.get(SZC);
    //         // }
    //     for(RDMasterBlaster__c rdmb : lstRDMS) {
    //         Integer a= Integer.valueOf(rdmb.SZC__c.stripTrailingZeros());
    //         String val=String.valueOf(a);
    //         string sizevalue=val;
    //         boolean chck=false;
    //         String keyCheck = rdmb.PTC__c + '|' + val + '|' + rdmb.STC__c;
    //         integer count=1;
    //         // IF the RDMasterBlaster__c record's attributes are not present yet, add to the unique set
    //         if(uniqueCombinations.add(keyCheck) && lstRDMBIds.contains(rdmb.id)) {
    //             if(String.isNotBlank(ruptureDisc.Product__c) && String.isNotBlank(ruptureDisc.Size__c) && String.isNotBlank(ruptureDisc.Seat__c)
    //                 && ruptureDisc.Product__c == rdmb.PTC__c && ruptureDisc.Size__c == val && ruptureDisc.Seat__c == rdmb.STC__c){//&& String.isNotBlank(ruptureDisc.Size_Units__c)
    //                     chck = true;
    //             }
    //             // if(!szcMap.containsKey(val)) {
    //             //     //string Sval=ConstantsUtil.getSizeDesc(SZC);
    //             //     if(ConstantsUtil.getSizeDesc(val)!=null)
    //             //         sizeValue = ConstantsUtil.getSzcDesc(val);
    //             //     else
    //             //         sizeValue=val;
    //             //     szcMap.put(val,sizeValue);
    //             // } else {
    //             //     sizeValue=szcMap.get(val);
    //             // }
    //             records.add(new RDOptions(rdmb.PTC__c, rdmb.STC__c,val, rdmb.Id,chck,sizeValue));
    //             //uniqueCombinations.add(keyCheck);
    //         }

    //     }
    //     return records;
    // }

    @AuraEnabled(cacheable = true)
    public static List < RDOptions > getRupDiscRecords(Rupture_Disc__c ruptDiscFields, String rupRecordId) {
        Map < id, RDMasterBlaster__c > rdMasterIDs = new Map < Id, RDMasterBlaster__c > ();
        Rupture_Disc__c ruptureDisc = [Select Id, Product__c, Seat__c, Size__c, Converted_Temperature_Setting__c, Converted_Pressure_Setting__c, Converted_Vacuum_Setting__c FROM Rupture_Disc__c where Id =: rupRecordId]; //, Size_Units__c
        Boolean derateCheck = ruptureDisc.Converted_Temperature_Setting__c >= 65 && ruptureDisc.Converted_Temperature_Setting__c < 75;
        Map < string, List < Derate_Value__c >> mapDetValues = new Map < string, List < Derate_Value__c >> ();
        //if(!derateCheck)
        mapDetValues = mapDerateValues(ruptureDisc.Converted_Temperature_Setting__c);
        List < RDMasterBlaster__c > lstRDMS = rDMBRecords(ruptureDisc, rupRecordId);
        for (RDMasterBlaster__c localRDM: lstRDMS) {
            string key = matlCodeProcessor(localRDM.MatlCodePos__c) + localRDM.DerateType__c;
            decimal deratevalue = 1;
            decimal brustPressure = 0;

            if (localRDM.PTC__c != 'CAL')
                brustPressure = ruptureDisc.Converted_Pressure_Setting__c;
            else
                brustPressure = ruptureDisc.Converted_Vacuum_Setting__c;
            if (localRDM.PTC__c != 'PAS' && localRDM.PTC__c != 'CAL') {
                if (mapDetValues.containsKey(key)) {
                    // Derate_Value__c dvalue=filterDerateValue(mapDetValues.get(key),ruptureDisc.Converted_Temperature_Setting__c);
                    deratevalue = mapDetValues.get(key)[0].Derate__c;
                }
                if (localRDM.Derate_EQN__c == 'METL' || localRDM.Derate_EQN__c == 'COMM') {
                    brustPressure = brustPressure / deratevalue;
                } else if (localRDM.Derate_EQN__c == 'COMA') {
                    decimal MetAlum = 0;
                    string strMetlAlum = '001' + localRDM.DerateType__c;
                    // Derate_Value__c Metldvalue=filterDerateValue(mapDetValues.get(strMetlAlum),ruptureDisc.Converted_Temperature_Setting__c);
                    if (mapDetValues.containsKey(strMetlAlum))
                        MetAlum = mapDetValues.get(strMetlAlum)[0].Derate__c;
                    brustPressure = 2 * brustPressure / (deratevalue + MetAlum);
                } else if (localRDM.Derate_EQN__c == 'COMT') {
                    string strMetlAlum = '001' + localRDM.DerateType__c;
                    decimal TefDer = 1;
                    // Derate_Value__c Metldvalue=filterDerateValue(mapDetValues.get(strMetlAlum),ruptureDisc.Converted_Temperature_Setting__c);
                    string strTef = '070' + localRDM.DerateType__c;
                    // Derate_Value__c TefDervalue=filterDerateValue(mapDetValues.get(strTef),ruptureDisc.Converted_Temperature_Setting__c);
                    //decimal MetAlum=mapDetValues.get(strMetlAlum)[0].Derate__c;
                    if (mapDetValues.containsKey(strTef))
                        TefDer = mapDetValues.get(strTef)[0].Derate__c;
                    brustPressure = brustPressure - (TefDer * localRDM.Teflon_Ambient__c) / deratevalue;
                    brustPressure += localRDM.Teflon_Ambient__c;
                    //localRDM.Teflon_Ambient__c;
                } else {

                }
            }
            if (localRDM.PTC__c != 'CAL') {
                if (localRDM.PressLL__c <= brustPressure && localRDM.PressUL__c > brustPressure) {
                    rdMasterIDs.put(localRDM.id, localRDM);
                } else {
                    system.debug('brustPressure  Excluded' + brustPressure + '-->>> PTC' + localRDM.PTC__c + ' --> Seat' + localRDM.STC__c + ' Size-->' + localRDM.SZC__c);
                }
            } else {
                if (localRDM.VacLL__c <= brustPressure && localRDM.VacUL__c > brustPressure) {
                    rdMasterIDs.put(localRDM.id, localRDM);
                } else {
                    system.debug('brustPressure  Excluded' + brustPressure + '-->>> PTC' + localRDM.PTC__c + ' --> Seat' + localRDM.STC__c + ' Size-->' + localRDM.SZC__c);
                }
            }
        }

        Set < String > uniqueCombinations = new Set < String > ();
        List < RDOptions > records = new List < RDOptions > ();
        //List<RDMasterBlaster__c> lstRDMS = rDMBRecords(ruptureDisc,rupRecordId);
        for (RDMasterBlaster__c rdmb: rdMasterIDs.values()) {
            //Integer a=0;
            // Integer a= Integer.valueOf(rdmb.SZC__c.stripTrailingZeros()); //Commented for SZC mantainence
            String val = String.valueOf(rdmb.SZC__c);
            boolean chck = false;
            String keyCheck = rdmb.PTC__c + '|' + val + '|' + rdmb.STC__c;
            // IF the RDMasterBlaster__c record's attributes are not present yet, add to the unique set
            if (!uniqueCombinations.contains(keyCheck)) {
                if (String.isNotBlank(ruptureDisc.Product__c) && String.isNotBlank(ruptureDisc.Size__c) && String.isNotBlank(ruptureDisc.Seat__c) &&
                    ruptureDisc.Product__c == rdmb.PTC__c && ruptureDisc.Size__c == val && ruptureDisc.Seat__c == rdmb.STC__c) { //&& String.isNotBlank(ruptureDisc.Size_Units__c)
                    chck = true;
                }
                records.add(new RDOptions(rdmb.PTC__c, rdmb.STC__c, val, rdmb.Id, chck)); //Commented for SZC mantainence
                uniqueCombinations.add(keyCheck);
            }
        }
        return records;
    }

    @AuraEnabled(cacheable = true)
    public static List < RDMasterBlaster__c > rDMBRecords(Rupture_Disc__c ruptureDisc, String rupRecordId) {
        String previousWhereClause = '';
        String queryString = 'select VMNFA__c,PTC__c,STC__c,SZC__c, DSCVAR__c, Id, MatlCodeVac__c, MatlCodePos__c, PressUL__c, PressLL__c, VacUL__c, VacLL__c, DerateType__c, Derate_EQN__c, Derate_Teflon__c, TempLL__c, TempUL__c, KOSHA_UL__c, KOSHA_LL__c, China_ML_UL__c, China_ML_LL__c, CE_Mark_UL__c, CE_Mark_LL__c, CE_Mark__c, ASME_UL__c, ASME_LL__c,Teflon_Ambient__c  from RDMasterBlaster__c'; //,SZC__c
        String whereClause = ' WHERE ';
        whereClause += getRDProductNarrowFilterClause(ruptureDisc, rupRecordId);
        previousWhereClause = whereClause; //  Set the current criteria to the stored variable
        queryString = queryString + whereClause;
        string order_by = ' ORDER BY SZC__c'; //  Set "ORDER BY" in query string //, order by SZC__c
        queryString = queryString + order_by; //  Append "ORDER BY" to the query string
        List < RDMasterBlaster__c > sobjList = Database.query(queryString);
        return sobjList;
    }

    @AuraEnabled(cacheable = true)
    public static string getRDProductNarrowFilterClause(Rupture_Disc__c ruptDisc, String rupRecordId) {
        Rupture_Disc__c ruptureDisc = [Select Id, Application_type__c, Operating_Pressure_Ratio__c, CU_TR__c, X3A_Sanitary_Standards__c,
            Atex_Certificate__c, Relief_Type__c, Non_Fragmenting_Design_Required__c, Is_there_a_liquid_relief_scenario__c,
            Converted_Vacuum_Setting__c, Converted_Pressure_Setting__c, Converted_Temperature_Setting__c, Converted_Back_Pressure_Value__c,
            Converted_Positive_Pressure_Value__c, Vacuum_Withstand__c, Flow_Area__c, VacFlow_Area__c, Evaluation_Type__c,
            Pressure_Withstand__c, CSA_Marking_CRN_Number__c, NACE__c, ASME_Section_VIII_Division_1__c,
            PED_2014_68_EU_CE_mark__c, China_Manufacturing_License__c, KOSHA_Compliance__c, Disc_Material_of_Construction__c, Evaluation_Per__c
            FROM Rupture_Disc__c where Id =: rupRecordId
        ];
        Decimal decVBrustConvertedValue = ruptureDisc.Converted_Vacuum_Setting__c;
        Decimal decPBrustConvertedValue = ruptureDisc.Converted_Pressure_Setting__c;
        String strBrand = [select Quote_Line__r.Name, Quote_Line__r.SBQQ__Quote__r.Brand__c from Rupture_Disc__c where id =: rupRecordId].Quote_Line__r.SBQQ__Quote__r.Brand__c;
        string strdynamicWhereClause = 'Id != null';
        //Filter For Brand this is the first filter on the Master Blaster table.
        if (strBrand != null)
            strdynamicWhereClause += ' AND Brand__c=\'' + strBrand + '\'';
        //Filter on Direction
        if (ruptureDisc.Relief_Type__c != '') {
            if (ruptureDisc.Relief_Type__c == 'Pressure Relief')
                strdynamicWhereClause += ' AND Direction__c=\'P\'';
            else if (ruptureDisc.Relief_Type__c == 'Vacuum Relief')
                strdynamicWhereClause += ' AND Direction__c=\'V\'';
            else
                strdynamicWhereClause += ' AND Direction__c=\'B\'';
        }
        //Filter on PressLL and PressUL
        if (decPBrustConvertedValue != null && ruptureDisc.Relief_Type__c != 'Vacuum Relief') {
            //strdynamicWhereClause+=' AND PRESSLL__c <='+ decPBrustConvertedValue+' and PRESSUL__c>'+decPBrustConvertedValue;
        }
        if(ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            if(decPBrustConvertedValue != null && ruptureDisc.Converted_Vacuum_Setting__c != null) {
                if(ruptureDisc.Converted_Vacuum_Setting__c!=decPBrustConvertedValue)
                    strdynamicWhereClause+=' AND PTC__c NOT IN (\'EV2\',\'EV3\',\'IS2\')';
            }
        }
        // Filter on TempLL and TempUL
        if (ruptureDisc.Converted_Temperature_Setting__c != null) {
            strdynamicWhereClause += ' AND TempLL__c <=' + ruptureDisc.Converted_Temperature_Setting__c + ' and TempUL__c>=' + ruptureDisc.Converted_Temperature_Setting__c;
        }
        // Filter on VacLL and VacUL
        if (ruptureDisc.Converted_Vacuum_Setting__c != null && ruptureDisc.Relief_Type__c != 'Pressure Relief') {
            //strdynamicWhereClause+=' AND VacLL__c <='+ decVBrustConvertedValue+' and VacUL__c>'+decVBrustConvertedValue;
        }


        //  //Filter on Vac WithStand
        if (!String.IsBlank(ruptureDisc.Vacuum_Withstand__c) && ruptureDisc.Vacuum_Withstand__c != 'No Requirements') {
            decimal decBackPress;
            if (ruptureDisc.Vacuum_Withstand__c == 'Full Vacuum') {
                decBackPress = 15;
            } else {
                decBackPress = ruptureDisc.Converted_Back_Pressure_Value__c;
            }
            string strSubQuery;
            strSubQuery = ' AND ((VacWithstand_Ind__c=\'Value\' AND VacValue__c>=' + decBackPress + ')';
            decimal decValue = decBackPress.divide(decPBrustConvertedValue, 3);
            strSubQuery += ' OR (VacWithstand_Ind__c=\'Ratio\' AND VacValue__c>=' + decValue + '))';
            strdynamicWhereClause += strSubQuery;
        }
        //Filter on Liquid Scenario
        if (ruptureDisc.Is_there_a_liquid_relief_scenario__c != '') {
            string val;
            if (ruptureDisc.Is_there_a_liquid_relief_scenario__c == 'Yes')
                val = 'Y';
            // else
            //     val='Gas';
            if (String.isNotBlank(val))
                strdynamicWhereClause += ' AND Liquid_Relief__c=\'' + val + '\'';
        }
        //Filter on Pos WithStand
        if (!String.isBlank(ruptureDisc.Pressure_Withstand__c) && ruptureDisc.Pressure_Withstand__c != 'No Requirements') {
            decimal decPosPress;
            decimal decValue = 0;
            decPosPress = ruptureDisc.Converted_Positive_Pressure_Value__c;
            if (decPosPress == null) {
                decPosPress = 0;
            }
            string strSubQuery;
            strSubQuery = ' AND ((PosWithstand_Ind__c=\'Value\' AND PosValue__c>=' + decPosPress + ')';
            if (decVBrustConvertedValue != null && (decVBrustConvertedValue != 0) && decPosPress != null)
                decValue = decPosPress.divide(decVBrustConvertedValue, 3);
            strSubQuery += ' OR (PosWithstand_Ind__c=\'Ratio\' AND PosValue__c>=' + decValue + '))';
            strdynamicWhereClause += strSubQuery;
        }

        if (ruptureDisc.CSA_Marking_CRN_Number__c)
            strdynamicWhereClause += ' AND CSA__c=\'Yes\'';

        //ATEX CHECK
        if (ruptureDisc.Atex_Certificate__c)
            strdynamicWhereClause += ' AND Atex__c=\'Yes\'';

        if (ruptureDisc.CU_TR__c)
            strdynamicWhereClause += ' AND CU_TR_Compliant_Discs__c=\'Yes\'';

        if (ruptureDisc.X3A_Sanitary_Standards__c)
            strdynamicWhereClause += ' AND X3A__c=\'Yes\'';

        //NACE Check
        if (!String.IsBlank(ruptureDisc.NACE__c) && ruptureDisc.NACE__c != 'N')
            strdynamicWhereClause += ' AND NACE__c=\'Yes\'';

        //ASME Initial Check
        if (ruptureDisc.ASME_Section_VIII_Division_1__c != Null) {
            if (ruptureDisc.ASME_Section_VIII_Division_1__c) {
                if (decPBrustConvertedValue != 0 && decPBrustConvertedValue != null) {
                    strdynamicWhereClause += ' AND ASME_LL__c <=' + decPBrustConvertedValue + ' and ASME_UL__c>=' + decPBrustConvertedValue;
                }
                if (decVBrustConvertedValue != 0 && decVBrustConvertedValue != null) {
                    //  strdynamicWhereClause+=' AND ASME_LL__c <='+ decVBrustConvertedValue+' and ASME_UL__c>='+decVBrustConvertedValue;
                }
            }
        }

        //CE Mark CHECK -- ruptureDisc.PED_2014_68_EU_CE_mark__c!=Null &&
        if (ruptureDisc.PED_2014_68_EU_CE_mark__c != 'NonePED') {
            if (!String.IsBlank(ruptureDisc.PED_2014_68_EU_CE_mark__c)) {
                if (decPBrustConvertedValue != 0 && decPBrustConvertedValue != null) {
                    strdynamicWhereClause += ' AND CE_Mark_LL__c <=' + decPBrustConvertedValue + ' and CE_Mark_UL__c>=' + decPBrustConvertedValue;
                }
                if (decVBrustConvertedValue != 0 && decVBrustConvertedValue != null) {
                    //  strdynamicWhereClause+=' AND CE_Mark_LL__c <='+ decVBrustConvertedValue+' and CE_Mark_UL__c>='+decVBrustConvertedValue;
                }
            }
        }

        //CHINAMFG Check -- ruptureDisc.China_Manufacturing_License__c!=Null &&
        if (ruptureDisc.China_Manufacturing_License__c != 'NoneCML') {
            if (!String.IsBlank(ruptureDisc.China_Manufacturing_License__c)) {
                if (decPBrustConvertedValue != 0 && decPBrustConvertedValue != null) {
                    strdynamicWhereClause += ' AND China_ML_LL__c <=' + decPBrustConvertedValue + ' and China_ML_UL__c>=' + decPBrustConvertedValue;
                }
                if (decVBrustConvertedValue != 0 && decVBrustConvertedValue != null) {
                    // strdynamicWhereClause+=' AND China_ML_LL__c <='+ decVBrustConvertedValue+' and China_ML_UL__c>='+decVBrustConvertedValue;
                }
            }
        }
        //KOSHA Check
        if (ruptureDisc.KOSHA_Compliance__c != Null) {
            if (ruptureDisc.KOSHA_Compliance__c) {
                if (decPBrustConvertedValue != 0 && decPBrustConvertedValue != null) {
                    strdynamicWhereClause += ' AND KOSHA_LL__c <=' + decPBrustConvertedValue + ' and KOSHA_UL__c>=' + decPBrustConvertedValue;
                }
                if (decVBrustConvertedValue != 0 && decVBrustConvertedValue != null) {
                    // strdynamicWhereClause+=' AND KOSHA_LL__c <='+ decVBrustConvertedValue+' and KOSHA_UL__c>='+decVBrustConvertedValue;
                }
            }
        }
        //End Of Section C filters

        //Filters on Section D
        //NON FRAGMENTING DESIGN CHECK
        if (ruptureDisc.Non_Fragmenting_Design_Required__c)
            strdynamicWhereClause += ' AND NonFragDesign__c=\'Yes\'';

        //OP RATIO CHECK
        if (ruptureDisc.Operating_Pressure_Ratio__c != 'OPRNone') {
            Decimal strToDec = decimal.valueOf(ruptureDisc.Operating_Pressure_Ratio__c);
            strdynamicWhereClause += ' AND OPtoBpRatio__c>=' + strToDec;
        }

        //APPLICATION CHECK
        if (!String.IsBlank(ruptureDisc.Application_type__c)) {
            strdynamicWhereClause += ' AND Application__c=\'' + ruptureDisc.Application_type__c + '\'';
        }

        //APPLICATION CHECK
        if (!String.IsBlank(ruptureDisc.Disc_Material_of_Construction__c) && ruptureDisc.Disc_Material_of_Construction__c != '-') {
            if (ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief' || ruptureDisc.Relief_Type__c == 'Pressure Relief') {
                strdynamicWhereClause += ' AND MatlCodePos__c=\'' + ruptureDisc.Disc_Material_of_Construction__c + '\'';
            }
            if (ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief' || ruptureDisc.Relief_Type__c == 'Vacuum Relief') {
                strdynamicWhereClause += ' AND MatlCodeVac__c=\'' + ruptureDisc.Disc_Material_of_Construction__c + '\'';
            }
        }

        //MNFA CHECK

        if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') {
            if (ruptureDisc.Flow_Area__c != Null) {
                decimal i = 0;
                system.debug('MNFA CHECK--> From Units' + unitConversions.mapRD_MNFAConverstionUOM.get(ruptureDisc.Evaluation_Per__c));
                system.debug('MNFA CHECK--> From Value' + ruptureDisc.Flow_Area__c);
                result conRes = unitConversions.convertArea(unitConversions.mapRD_MNFAConverstionUOM.get(ruptureDisc.Evaluation_Per__c), 'in2', ruptureDisc.Flow_Area__c);
                system.debug('MNFA CHECK--> Final Value' + conRes.dblRetValue);
                decimal dec=decimal.valueOf(conRes.dblRetValue);
                strdynamicWhereClause += ' AND MNFA__c>=' + dec;
            }
        }

        //VMNFA CHECK
        if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') {
            if (ruptureDisc.VacFlow_Area__c != Null) {
                strdynamicWhereClause += ' AND VMNFA__c>=' + ruptureDisc.VacFlow_Area__c;
            }
        }
        system.debug('strdynamicWhereClause'+strdynamicWhereClause);
        return strdynamicWhereClause;
    }

    @AuraEnabled
    public static Rupture_Disc__c saveSizingFlowArea(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Sizing_Flag__c = true;
        ruptureDisc.Edit_QuoteLine__c = false;

        IF(ruptureDisc.Relief_Type__c == 'Pressure Relief') {
            ruptureDisc = clearVacuumAlone(ruptureDisc);
            ruptureDisc = clearSizingData(ruptureDisc);
        }

        IF(ruptureDisc.Relief_Type__c == 'Vacuum Relief') {
            ruptureDisc = clearPressureAlone(ruptureDisc);
        }

        IF(ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            ruptureDisc = clearSizingData(ruptureDisc);
        }

        double dConvertedSpecificGravity = 0;
        double dConvertedSpecificVolume = 0;
        decimal doubleConvertedFlowCapacity = 0.0;
        decimal decConRelievingTemp = 0.0;
        decimal decConRelievingPressure = 0.0;
        decimal decPBrustConvertedValue = ruptureDisc.Converted_Pressure_Setting__c;

        List < String > requiredFlowRateCheck = new List < String > {
            'ASME Gas/Vapor',
            'ASME Water',
            'ASME Steam',
            'API Gas/Vapor',
            'API Liquid',
            'API Steam',
            'ISO Gas/Vapor',
            'ISO Liquid',
            'ISO Gas/Vapor',
            'ISO Dry Steam',
            'ISO Wet Steam',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > requiredFlowRateAsmeAirCheck = new List < String > {
            'ASME Gas/Vapor'
        };

        List < String > relievingPressureatInletCheck = new List < String > {
            'ASME Gas/Vapor',
            'ASME Water',
            'ASME Steam',
            'API Gas/Vapor',
            'API Liquid',
            'API Steam',
            'ISO Gas/Vapor',
            'ISO Liquid',
            'ISO Gas/Vapor',
            'ISO Dry Steam',
            'ISO Wet Steam',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > relievingPressureatInletAsmeAirCheck = new List < String > {
            'ASME Gas/Vapor'
        };

        List < String > pressureRelievingTemperatureCheck = new List < String > {
            'ASME Gas/Vapor',
            'API Gas/Vapor',
            'API Steam',
            'ISO Gas/Vapor',
            'ISO Dry Steam',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > pressureRelievingTemperatureAsmeAirCheck = new List < String > {
            'ASME Gas/Vapor'
        };

        List < String > densitySpecificVolumeSpecificGravityCheck = new List < String > {
            'ASME Water',
            'API Liquid',
            'ISO Liquid'
        };

        List < String > viscosityCheck = new List < String > {
            'API Liquid',
            'ISO Liquid',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid'
        };

        List < String > drynessOfWetSteamCheck = new List < String > {
            'ISO Wet Steam'
        };

        List < String > specificVolumeAtInletCheck = new List < String > {
            'API Omega Method 2 Phase Flashing or Nonflashing'
        };

        List < String > specificVolumeAt90InletPressureCheck = new List < String > {
            'API Omega Method 2 Phase Flashing or Nonflashing'
        };

        List < String > saturationPressureAtInletTemperatureCheck = new List < String > {
            'API Omega Method Subcooled Liquid'
        };

        List < String > densityAt90SaturationPressureCheck = new List < String > {
            'API Omega Method Subcooled Liquid'
        };

        List < String > stagnationGasvaporQualityCheck = new List < String > {
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'
        };

        List < String > liquidDensityCheck = new List < String > {
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'
        };

        List < String > stagnationVaporDensityCheck = new List < String > {
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > latentHeatOfVaporizationCheck = new List < String > {
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > liquidSpecificHeatCheck = new List < String > {
            'Fauske 2 Phase Vapor-Liquid',
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > stagnationGasPartialPressureCheck = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' //,'Fauske All Liquid Flashing'
        };

        List < String > vaporPresCorrespondtoStagnationTempCheck = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing'
        };

        List < String > isentropicCoefMWGasVaporCheck = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'
        };

        List < String > molecularWeightCheck = new List < String > {
            'API Gas/Vapor',
            'ASME Gas/Vapor',
            'ISO Gas/Vapor',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid'
        };

        List < String > molecularWeightAsmeAirCheck = new List < String > {
            'ASME Gas/Vapor'
        };

        List < String > compressibilityFactorCheck = new List < String > {
            'ASME Gas/Vapor',
            'API Gas/Vapor',
            'ISO Gas/Vapor'
        };

        List < String > denistyAtInletCheck = new List < String > {
            'API Omega Method Subcooled Liquid'
        };

        List < String > ratioOfSpecificHeatsCheck = new List < String > {
            'ASME Gas/Vapor',
            'API Gas/Vapor',
            'ISO Gas/Vapor',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid'
        };

        List < String > lstOfFauskeOmega = new List < String > {
            'Fauske 2 Phase Hybrid Gas-Vapor-Liquid',
            'Fauske All Liquid Flashing',
            'Fauske 2 Phase Gas-Liquid',
            'Fauske 2 Phase Vapor-Liquid',
            'API Omega Method 2 Phase Flashing or Nonflashing',
            'API Omega Method Subcooled Liquid'
        };

        if (ruptureDisc.Relief_Type__c == 'Pressure Relief' || (ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief' && (ruptureDisc.Constrain_product_selection__c == 'Pressure' || ruptureDisc.Constrain_product_selection__c == 'Pressure & Vacuum'))) {
            if (ruptureDisc.Evaluation_Type__c == null)
                throw new AuraHandledException('Evaluation Type: Please Select a Value from the drop down');
            if (ruptureDisc.Evaluation_Per__c == '' || ruptureDisc.Evaluation_Per__c == null)
                throw new AuraHandledException('Evaluation Per: Please Select a Value from the drop down');
            if (ruptureDisc.Process_Media__c == '' || ruptureDisc.Process_Media__c == null)
                throw new AuraHandledException('Media: Please Select a Value from the drop down');
            if (ruptureDisc.Process_Media__c == 'Customer Specified' && ruptureDisc.Customer_Specified_Media__c == null)
                throw new AuraHandledException('Customer Specified Media: Please Enter a Value');
            // if (ruptureDisc.Process_Media__c == 'Customer Specified' && ruptureDisc.Molecular_Weight__c == null)
            //     throw new AuraHandledException('Molecular Weight: Please Enter a Value');
            // if (ruptureDisc.Process_Media__c == 'Customer Specified' && ruptureDisc.Compressibility_Factor__c == null)
            //     throw new AuraHandledException('Compressibility Factor: Please Enter a Value');
            // if (ruptureDisc.Process_Media__c == 'Customer Specified' && ruptureDisc.Ratio_of_Specific_Heats__c == null)
            //     throw new AuraHandledException('Ratio Of Specific Heats: Please Enter a Value');
            if (molecularWeightCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Customer Specified') && (ruptureDisc.Molecular_Weight__c == null))
                throw new AuraHandledException('Molecular Weight: Please Enter a Value');
            if (molecularWeightCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Customer Specified') && (ruptureDisc.Molecular_Weight__c < 2.015 || ruptureDisc.Molecular_Weight__c > 400))
                throw new AuraHandledException('Molecular Weight: Please Enter a Value In Between 2.015 - 400'); // added by piyush
            if (molecularWeightAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Molecular_Weight__c == null))
                throw new AuraHandledException('Molecular Weight: Please Enter a Value');
            if (compressibilityFactorCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Customer Specified') && (ruptureDisc.Compressibility_Factor__c == null))
                throw new AuraHandledException('Compressibility Factor: Please Enter a Value');
            if (compressibilityFactorCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Customer Specified') && (ruptureDisc.Compressibility_Factor__c < 0.8 || ruptureDisc.Compressibility_Factor__c > 1.1))
                throw new AuraHandledException('Compressibility Factor: Please Enter a Value In Between .8 - 1.1'); // added by piyush
            if (ratioOfSpecificHeatsCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Customer Specified') && (ruptureDisc.Ratio_of_Specific_Heats__c == null))
                throw new AuraHandledException('Ratio of Specific Heats: Please Enter a Value');
            if (ratioOfSpecificHeatsCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Customer Specified') && (ruptureDisc.Ratio_of_Specific_Heats__c < 1 || ruptureDisc.Ratio_of_Specific_Heats__c > 2.2))
                throw new AuraHandledException('Ratio of Specific Heats: Please Enter a Value In Between 1 - 2.2'); // added by piyush
            if (densitySpecificVolumeSpecificGravityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Density_Specific_Volume_Specific_Gravity__c == null))
                throw new AuraHandledException('Density/Specific Volume/Specific Gravity: Please Enter a Value');
            if (densitySpecificVolumeSpecificGravityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c == '' || ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c == null))
                throw new AuraHandledException('Density/Specific Volume/Specific Gravity Units: Please Select a Value from the drop down');
            if (requiredFlowRateCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Required_Flow_Rate__c == null) && ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity')
                throw new AuraHandledException('Required Flow Rate: Please Enter a Value');
            if (requiredFlowRateCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Required_Flow_units__c == '' || ruptureDisc.Required_Flow_units__c == null) && ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity')
                throw new AuraHandledException('Required Flow Rate Units: Please Select a Value from the drop down');
            if (requiredFlowRateAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Required_Flow_Rate__c == null) && ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity')
                throw new AuraHandledException('Required Flow Rate: Please Enter a Value');
            if (requiredFlowRateAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Required_Flow_units__c == '' || ruptureDisc.Required_Flow_units__c == null) && ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity')
                throw new AuraHandledException('Required Flow Rate Units: Please Enter a Value');
            if (relievingPressureatInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Relieving_Pressure_at_Inlet__c == null))
                throw new AuraHandledException('Relieving Pressure at Inlet: Please Select a Value from the drop down');
            if (relievingPressureatInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Relieving_Pressure_at_Inlet__c == 'Enter Relieving Pressure Value/ units' && (ruptureDisc.Enter_Relieving_Pressure_Value__c == null)))
                throw new AuraHandledException('Enter Relieving Pressure Value: Please Enter a Value');
            if (relievingPressureatInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Relieving_Pressure_at_Inlet__c == 'Enter Relieving Pressure Value/ units' && (ruptureDisc.Enter_Relieving_Pressure_units__c == '' || ruptureDisc.Enter_Relieving_Pressure_units__c == null)))
                throw new AuraHandledException('Enter Relieving Pressure units: Please Select a Value from the drop down');
            if (relievingPressureatInletAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Relieving_Pressure_at_Inlet__c == null))
                throw new AuraHandledException('Relieving Pressure at Inlet: Please Select a Value from the drop down');
            if (relievingPressureatInletAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Relieving_Pressure_at_Inlet__c == 'Enter Relieving Pressure Value/ units' && (ruptureDisc.Enter_Relieving_Pressure_Value__c == null)))
                throw new AuraHandledException('Enter Relieving Pressure Value: Please Enter a Value');
            if (relievingPressureatInletAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Relieving_Pressure_at_Inlet__c == 'Enter Relieving Pressure Value/ units' && (ruptureDisc.Enter_Relieving_Pressure_units__c == '' || ruptureDisc.Enter_Relieving_Pressure_units__c == null)))
                throw new AuraHandledException('Enter Relieving Pressure units: Please Select a Value from the drop down');
            if (pressureRelievingTemperatureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Pressure_Relieving_Temperature__c == null))
                throw new AuraHandledException('Pressure Relieving Temperature: Please Select a Value from the drop down');
            if (pressureRelievingTemperatureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Pressure_Relieving_Temperature__c == 'PRTEnterDifferentTemperatureUnits' && ruptureDisc.Enter_Different_Temperature_Value__c == null))
                throw new AuraHandledException('Enter Different Temperature Value: Please Enter a Value');
            if (pressureRelievingTemperatureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Pressure_Relieving_Temperature__c == 'PRTEnterDifferentTemperatureUnits' && (ruptureDisc.Enter_Different_Temperature_Units__c == '' || ruptureDisc.Enter_Different_Temperature_Units__c == null)))
                throw new AuraHandledException('Enter Different Temperature Units: Please Select a Value from the drop down');
            if (pressureRelievingTemperatureAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Pressure_Relieving_Temperature__c == null))
                throw new AuraHandledException('Pressure Relieving Temperature: Please Select a Value from the drop down');
            if (pressureRelievingTemperatureAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Pressure_Relieving_Temperature__c == 'PRTEnterDifferentTemperatureUnits') && (ruptureDisc.Enter_Different_Temperature_Value__c == null))
                throw new AuraHandledException('Enter Different Temperature Value: Please Enter a Value');
            if (pressureRelievingTemperatureAsmeAirCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Process_Media__c == 'Air') && (ruptureDisc.Pressure_Relieving_Temperature__c == 'PRTEnterDifferentTemperatureUnits') && (ruptureDisc.Enter_Different_Temperature_Units__c == '' || ruptureDisc.Enter_Different_Temperature_Units__c == null))
                throw new AuraHandledException('Enter Different Temperature Units: Please Select a Value from the drop down');
            if (viscosityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Viscosity__c == null))
                throw new AuraHandledException('Viscosity: Please Enter a Value');
            if (viscosityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Viscosity_units__c == '' || ruptureDisc.Viscosity_units__c == null))
                throw new AuraHandledException('Viscosity Units: Please Select a Value from the drop down');
            if (drynessOfWetSteamCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Dryness_of_Wet_Steam__c == null))
                throw new AuraHandledException('Dryness of Wet Steam: Please Enter a Value');
            if (drynessOfWetSteamCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Dryness_of_Wet_Steam__c < 90 || ruptureDisc.Dryness_of_Wet_Steam__c > 100))
                throw new AuraHandledException('Dryness of Wet Steam: Please Enter a Value In Between 90-100'); //added by piyush
            if (specificVolumeAtInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Specific_Volume_at_inlet__c == null))
                throw new AuraHandledException('Specific Volume at Inlet: Please Enter a Value');
            if (specificVolumeAtInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Specific_Volume_at_Inlet_Units__c == '' || ruptureDisc.Specific_Volume_at_Inlet_Units__c == null))
                throw new AuraHandledException('Specific Volume at Inlet Units: Please Select a Value from the drop down');
            if (specificVolumeAt90InletPressureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c == null))
                throw new AuraHandledException('Specific Volume at 90% of Inlet Pressure: Please Enter a Value');
            if (specificVolumeAt90InletPressureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c == '' || ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c == null))
                throw new AuraHandledException('Specific Volume at 90% of Inlet Units: Please Select a Value from the drop down');
            if (denistyAtInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Density_at_Inlet__c == null))
                throw new AuraHandledException('Density at Inlet: Please Enter a Value');
            if (denistyAtInletCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Density_at_Inlet_Units__c == '' || ruptureDisc.Density_at_Inlet_Units__c == null))
                throw new AuraHandledException('Density at Inlet Units: Please Select a Value from the drop down');
            if (saturationPressureAtInletTemperatureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c == null))
                throw new AuraHandledException('Saturation Pressure at Inlet Temperature: Please Enter a Value');
            if (saturationPressureAtInletTemperatureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c == '' || ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c == null))
                throw new AuraHandledException('Saturation Pressure at inlet temp Units: Please Select a Value from the drop down');
            if (densityAt90SaturationPressureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Density_at_90_of_Saturation_Pressure__c == null))
                throw new AuraHandledException('Density at 90 of Saturation Pressure: Please Enter a Value');
            if (densityAt90SaturationPressureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Density_at_90_Saturation_Pressure_Units__c == '' || ruptureDisc.Density_at_90_Saturation_Pressure_Units__c == null))
                throw new AuraHandledException('Density at 90 Saturation Pressure Units: Please Select a Value from the drop down');
            if (stagnationGasvaporQualityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Stagnation_gas_vapor_quality__c == null))
                throw new AuraHandledException('Stagnation Gas Vapor Quality: Please Enter a Value');
            if (liquidDensityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Liquid_density__c == null))
                throw new AuraHandledException('Liquid Density: Please Enter a Value');
            if (liquidDensityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Liquid_density_Units__c == '' || ruptureDisc.Liquid_density_Units__c == null))
                throw new AuraHandledException('Liquid Density Units: Please Select a Value from the drop down');
            if (stagnationVaporDensityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Stagnation_vapor_density__c == null))
                throw new AuraHandledException('Stagnation Vapor Density: Please Enter a Value');
            if (stagnationVaporDensityCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Stagnation_Vapor_Density_Units__c == '' || ruptureDisc.Stagnation_Vapor_Density_Units__c == null))
                throw new AuraHandledException('Stagnation Vapor Density Units: Please Select a Value from the drop down');
            if (latentHeatOfVaporizationCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Latent_heat_of_vaporization__c == null))
                throw new AuraHandledException('Latent Heat Of Vaporization: Please Enter a Value');
            if (liquidSpecificHeatCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Liquid_specific_heat__c == null))
                throw new AuraHandledException('Liquid Specific Heat: Please Enter a Value');
            if (stagnationGasPartialPressureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Stagnation_gas_partial_pressure__c == null))
                throw new AuraHandledException('Stagnation Gas Partial Pressure: Please Enter a Value');
            if (stagnationGasPartialPressureCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Stagnation_gas_partial_pressure_Units__c == '' || ruptureDisc.Stagnation_gas_partial_pressure_Units__c == null))
                throw new AuraHandledException('Stagnation Gas Partial Pressure Units: Please Select a Value from the drop down');
            if (vaporPresCorrespondtoStagnationTempCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c == null))
                throw new AuraHandledException('Vapor Pres Correspond to Stagnation Temp: Please Enter a Value');
            if (vaporPresCorrespondtoStagnationTempCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c == '' || ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c == null))
                throw new AuraHandledException('Vapor Pres to Stagnation Temp Units: Please Select a Value from the drop down');
            if (isentropicCoefMWGasVaporCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Isentropic_coefficient_gas__c == null))
                throw new AuraHandledException('Isentropic Coefficient Gas: Please Enter a Value');
            if (isentropicCoefMWGasVaporCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Isentropic_coefficient_vapor__c == null))
                throw new AuraHandledException('Isentropic Coefficient Vapor: Please Enter a Value');
            if (isentropicCoefMWGasVaporCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Molecular_Weight_gas__c == null))
                throw new AuraHandledException('Molecular Weight Gas: Please Enter a Value');
            if (isentropicCoefMWGasVaporCheck.contains(ruptureDisc.Evaluation_Per__c) && (ruptureDisc.Molecular_Weight_vapor__c == null))
                throw new AuraHandledException('Molecular Weight Vapor: Please Enter a Value');
            if (ruptureDisc.Relieving_Pressure_at_Inlet__c == 'Enter Relieving Pressure Value/ units') {
                //decConRelievingPressure
                Result resultConvertRelievingPressure = new Result();
                if (ruptureDisc.Evaluation_Per__c == 'ASME Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ASME Water')
                    resultConvertRelievingPressure = getConvertedValErrorMsg('RelievingPressure', 99999999, 15, 'psig', ruptureDisc.Enter_Relieving_Pressure_units__c, ruptureDisc.Enter_Relieving_Pressure_Value__c, 'Enter Relieving Pressure Value');
                if (ruptureDisc.Evaluation_Per__c == 'ASME Steam')
                    resultConvertRelievingPressure = getConvertedValErrorMsg('RelievingPressure', 3200, 15, 'psig', ruptureDisc.Enter_Relieving_Pressure_units__c, ruptureDisc.Enter_Relieving_Pressure_Value__c, 'Enter Relieving Pressure Value');
                if (resultConvertRelievingPressure.bErrorCheck)
                    throw new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
                else {
                    resultConvertRelievingPressure = unitConversions.convertPressure(ruptureDisc.Enter_Relieving_Pressure_units__c, unitConversions.relievPressBaseUOM, ruptureDisc.Enter_Relieving_Pressure_Value__c);
                    if (resultConvertRelievingPressure.bResult) {
                        decConRelievingPressure = resultConvertRelievingPressure.dblRetValue;
                    } else {
                        throw new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
                    }
                }
            } else {
                if (ruptureDisc.Relieving_Pressure_at_Inlet__c.contains('%')) {
                    Integer myInt = Integer.valueOf(ruptureDisc.Relieving_Pressure_at_Inlet__c.substringBefore('%'));
                    decimal adderVal;
                    if (myInt == 10) {
                        adderVal = 0.10;
                    } else if (myInt == 16) {
                        adderVal = 0.16;
                    } else if (myInt == 21) {
                        adderVal = 0.21;
                    } else {
                        adderVal = 0;
                    }
                    adderVal = decPBrustConvertedValue * adderVal;
                    decConRelievingPressure = decPBrustConvertedValue + adderVal;
                } else {
                    Integer myInt = Integer.valueOf(ruptureDisc.Relieving_Pressure_at_Inlet__c);
                    decConRelievingPressure = decPBrustConvertedValue + myInt;
                }
                decConRelievingPressure = unitConversions.convertPressure('psig', unitConversions.relievPressBaseUOM, decConRelievingPressure).dblRetValue;
                Result resultConvertRelievingPressure = new Result();
                if (ruptureDisc.Evaluation_Per__c == 'ASME Steam' || ruptureDisc.Evaluation_Per__c == 'ASME Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ASME Water') {
                    resultConvertRelievingPressure = getConvertedValErrorMsg('RelievingPressure', 3200, 15, 'psig', unitConversions.relievPressBaseUOM, decConRelievingPressure, 'Relieving Pressure at Inlet');
                }

                if (resultConvertRelievingPressure.bErrorCheck)
                    throw new AuraHandledException(resultConvertRelievingPressure.strErrorMessage);
            }
            if (ruptureDisc.Pressure_Relieving_Temperature__c == 'PRTSameAsTemperatureSetting') {
                result doubleRelievingTemp = unitConversions.convertTemperature(ruptureDisc.Temperature_Setting_Units__c, unitConversions.relievTempBaseUOM, ruptureDisc.Temperature_Setting__c);
                if (doubleRelievingTemp.bResult) {
                    decConRelievingTemp = doubleRelievingTemp.dblRetValue;
                }
            } else {
                //string strBaseTemp=unitConversions.relievTempBaseUOM;
                result doubleRelievingTemp = unitConversions.convertTemperature(ruptureDisc.Enter_Different_Temperature_Units__c, unitConversions.relievTempBaseUOM, ruptureDisc.Enter_Different_Temperature_Value__c);
                if (doubleRelievingTemp.bResult) {
                    decConRelievingTemp = doubleRelievingTemp.dblRetValue;
                }

            }
            //Density Calculations will start here
            if (ruptureDisc.Density_Specific_Volume_Specific_Gravity__c != null) {
                Result resultConvertDensity = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c, unitConversions.mapRD_DensitySpecificVolumeSpecificGravityBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Density_Specific_Volume_Specific_Gravity__c);
                if (resultConvertDensity.bResult)
                    ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = resultConvertDensity.dblRetValue;
                else
                    throw new AuraHandledException(resultConvertDensity.strErrorMessage);
            }
            //Specific Volume
            if (ruptureDisc.Specific_Volume_at_inlet__c != null) {
                string strSpcBase;
                if (ruptureDisc.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing')
                    strSpcBase = 'ft3/lb';
                else
                    strSpcBase = 'lb/ft3';
                Result resultConverGravity = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Specific_Volume_at_Inlet_Units__c, strSpcBase, ruptureDisc.Specific_Volume_at_inlet__c);
                if (resultConverGravity.bResult)
                    dConvertedSpecificVolume = resultConverGravity.dblRetValue;
                else
                    throw new AuraHandledException(resultConverGravity.strErrorMessage);
            }
            //Specific Gravity
            if (ruptureDisc.Density_at_Inlet__c != null) {
                Result resultConverGravity = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Density_at_Inlet_Units__c, 'lb/ft3', ruptureDisc.Density_at_Inlet__c);
                if (resultConverGravity.bResult)
                    dConvertedSpecificGravity = resultConverGravity.dblRetValue;
                else
                    throw new AuraHandledException(resultConverGravity.strErrorMessage);
            }
            //Required_Flow_Rate Conversion Calculations
            if (unitConversions.listGasFlowRatenew.contains(ruptureDisc.Evaluation_Per__c) || unitConversions.listStreamFlowRatenew.contains(ruptureDisc.Evaluation_Per__c)) {
                if (ruptureDisc.Required_Flow_Rate__c != null && ruptureDisc.Required_Flow_units__c != null) {
                    Double convTemp = 999999999;
                    if (ruptureDisc.Evaluation_Per__c != 'ASME Steam' && ruptureDisc.Evaluation_Per__c != 'ISO Wet Steam') {
                        convTemp = decConRelievingTemp;
                    } else {
                        ruptureDisc.Converted_Relieving_Temperature__c = 999999999;
                    }
                    result resultFlowCapacity = unitConversions.convertGasFlowRate(ruptureDisc.Required_Flow_units__c, unitConversions.mapRD_FlowRateBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Required_Flow_Rate__c, decConRelievingPressure, ruptureDisc.Molecular_Weight__c, convTemp, ruptureDisc.Compressibility_Factor__c);
                    if (resultFlowCapacity.bResult) {
                        doubleConvertedFlowCapacity = resultFlowCapacity.dblRetValue;
                    }
                }
            } else {
                if (ruptureDisc.Required_Flow_Rate__c != null) {
                    Double denSpecGravity = 1.0;
                    if (!lstOfFauskeOmega.contains(ruptureDisc.Evaluation_Per__c)) {
                        denSpecGravity = ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c;
                        Result resultConvertDensity1 = unitConversions.convertDensitySpecifyVolume(unitConversions.mapRD_DensitySpecificVolumeSpecificGravityBaseUOM.get(ruptureDisc.Evaluation_Per__c), 'lb/ft3', ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c);
                        denSpecGravity = resultConvertDensity1.dblRetValue;
                    }
                    result resultFlowCapacity = unitConversions.convertLiquidFlowRate(ruptureDisc.Required_Flow_units__c, unitConversions.mapRD_FlowRateBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Required_Flow_Rate__c, denSpecGravity);
                    if (resultFlowCapacity.bResult) {
                        doubleConvertedFlowCapacity = resultFlowCapacity.dblRetValue;
                    }
                }
            }

            //Calculate Viscosity
            result resultConvertViscosity = new result();
            if (ruptureDisc.Viscosity__c != null) {
                resultConvertViscosity = unitConversions.convertViscosity(ruptureDisc.Viscosity_units__c, unitConversions.mapRD_ViscosityBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Viscosity__c);
                if (resultConvertViscosity.bResult)
                    ruptureDisc.Converted_Viscosity__c = resultConvertViscosity.dblRetValue;
                else
                    throw new AuraHandledException(resultConvertViscosity.strErrorMessage);
            }

            //New Methods starts here
            result resultVaporPressureCorresp = new result();
            if (ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c != null) {
                resultVaporPressureCorresp = unitConversions.convertPressure(ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c, unitConversions.mapRD_VaporPressCorrespondToStagnationTempBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c);
                if (resultVaporPressureCorresp.bResult)
                    ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = resultVaporPressureCorresp.dblRetValue;
                else
                    throw new AuraHandledException(resultVaporPressureCorresp.strErrorMessage);
            }
            result resultStagnationGaspartialPressure = new result();
            if (ruptureDisc.Stagnation_gas_partial_pressure__c != null) {
                resultStagnationGaspartialPressure = unitConversions.convertPressure(ruptureDisc.Stagnation_gas_partial_pressure_Units__c, unitConversions.mapRD_StagnationGasPartialPressureBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Stagnation_gas_partial_pressure__c);
                if (resultStagnationGaspartialPressure.bResult)
                    ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = resultStagnationGaspartialPressure.dblRetValue;
                else
                    throw new AuraHandledException(resultStagnationGaspartialPressure.strErrorMessage);
            }
            result resultStagnationVaporDensity = new result();
            if (ruptureDisc.Stagnation_vapor_density__c != null) {
                resultStagnationVaporDensity = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Stagnation_Vapor_Density_Units__c, unitConversions.mapRD_StagnationVaporDensityBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Stagnation_vapor_density__c);
                if (resultStagnationVaporDensity.bResult)
                    ruptureDisc.Converted_Stagnation_vapor_density__c = resultStagnationVaporDensity.dblRetValue;
                else
                    throw new AuraHandledException(resultStagnationVaporDensity.strErrorMessage);
            }
            result resultLiquidDensity = new result();
            if (ruptureDisc.Liquid_density__c != null) {
                resultLiquidDensity = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Liquid_density_Units__c, unitConversions.mapRD_LiquidDensityBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Liquid_density__c);
                if (resultLiquidDensity.bResult)
                    ruptureDisc.Converted_Liquid_Density__c = resultLiquidDensity.dblRetValue;
                else
                    throw new AuraHandledException(resultLiquidDensity.strErrorMessage);
            }

            result resultDensityAt90Saturation = new result();
            if (ruptureDisc.Density_at_90_of_Saturation_Pressure__c != null) {
                resultDensityAt90Saturation = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Density_at_90_Saturation_Pressure_Units__c, unitConversions.mapRD_DensityatSaturationPressureBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Density_at_90_of_Saturation_Pressure__c);
                if (resultDensityAt90Saturation.bResult)
                    ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = resultDensityAt90Saturation.dblRetValue;
                else
                    throw new AuraHandledException(resultDensityAt90Saturation.strErrorMessage);
            }
            result resultConvertSpecificVolumeAt90InletPress = new result();
            if (ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c != null) {
                resultConvertSpecificVolumeAt90InletPress = unitConversions.convertDensitySpecifyVolume(ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c, unitConversions.mapRD_SpecificVolumeAt90inletBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c);
                if (resultConvertSpecificVolumeAt90InletPress.bResult)
                    ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = resultConvertSpecificVolumeAt90InletPress.dblRetValue;
                else
                    throw new AuraHandledException(resultConvertSpecificVolumeAt90InletPress.strErrorMessage);
            }
            result resultSaturationPressureAtInlet = new result();
            if (ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c != null) {
                resultSaturationPressureAtInlet = unitConversions.convertPressure(ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c, unitConversions.mapRD_SaturationPressureAtInletBaseUOM.get(ruptureDisc.Evaluation_Per__c), ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c);
                if (resultSaturationPressureAtInlet.bResult)
                    ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = resultSaturationPressureAtInlet.dblRetValue;
                else
                    throw new AuraHandledException(resultSaturationPressureAtInlet.strErrorMessage);
            }
            Result doubleFlowArea = new Result();
            if (unitConversions.relievPressBaseUOM != unitConversions.mapRD_RelievingPressureBaseUOM.get(ruptureDisc.Evaluation_Per__c)) {
                decConRelievingPressure = unitConversions.convertPressure(unitConversions.relievPressBaseUOM, unitConversions.mapRD_RelievingPressureBaseUOM.get(ruptureDisc.Evaluation_Per__c), decConRelievingPressure).dblRetValue;
            }
            if (unitConversions.relievTempBaseUOM != unitConversions.mapRD_RelievingTemperatureBaseUOM.get(ruptureDisc.Evaluation_Per__c)) {
                result dec = unitConversions.convertTemperature(unitConversions.relievTempBaseUOM, unitConversions.mapRD_RelievingTemperatureBaseUOM.get(ruptureDisc.Evaluation_Per__c), decConRelievingTemp);
                if (dec.bResult) {
                    decConRelievingTemp = dec.dblRetValue;
                }
            }
            if (ruptureDisc.Evaluation_Per__c == 'API Steam') {
                Result objResult = new Result();
                double NextLowerPres = 0.0, NextHigherPres = 0.0, SatTempAtNextLowerPres = 0.0, SatTempAtNextHigherPres = 0.0,
                    SatKsAtNextLowerPres = 0.0, SatKsAtNextHigherPres = 0.0, SatTempAtRelievingPressure = 0.0, SatKsAtRelievingPressure = 0.0;

                result resultConvertPressure1 = unitConversions.convertPressure('psia', 'psig', decConRelievingPressure);
                Double dP1 = decConRelievingPressure;
                if (resultConvertPressure1.bResult)
                    dP1 = resultConvertPressure1.dblRetValue;

                List < APIDryKs__c > objAPIDryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
                    FROM APIDryKs__c WHERE Pressure__c <=: dP1 and SteamCond__c Like 'Sat%'
                    ORDER BY Pressure__c DESC, Temprature__c ASC
                ];
                if (!objAPIDryKs.isEmpty()) {
                    // Get the NextLowerPres
                    NextLowerPres = objAPIDryKs.get(0).Pressure__c;
                    //Get SatTempAtNextLowerPres
                    SatTempAtNextLowerPres = objAPIDryKs.get(0).Temprature__c;
                    // Get SatKsAtNextLowerPres
                    SatKsAtNextLowerPres = objAPIDryKs.get(0).Ks__c;
                } else {
                    objResult.bResult = false;
                }

                objAPIDryKs = [SELECT Pressure__c, Temprature__c, SteamCond__c, Ks__c
                    FROM APIDryKs__c WHERE Pressure__c >: dP1 and SteamCond__c Like 'Sat%'
                    ORDER BY Pressure__c ASC, Temprature__c ASC
                ];
                if (!objAPIDryKs.isEmpty()) {
                    // Get the NextHigherPres
                    NextHigherPres = objAPIDryKs.get(0).Pressure__c;
                    //Get SatTempAtNextHigherPres
                    SatTempAtNextHigherPres = objAPIDryKs.get(0).Temprature__c;
                    // Get SatKsAtNextHigherPres
                    SatKsAtNextHigherPres = objAPIDryKs.get(0).Ks__c;
                    SatTempAtRelievingPressure = ((dP1 - NextLowerPres) / (NextHigherPres - NextLowerPres) * (SatTempAtNextHigherPres - SatTempAtNextLowerPres)) + SatTempAtNextLowerPres;
                    //SatKsAtRelievingPressure = (doubleRelievingTemp.dblRetValue-NextLowerPres)/(NextHigherPres-NextLowerPres)*(SatKsAtNextHigherPres-SatKsAtNextLowerPres)+SatKsAtNextLowerPres;
                }
                string strUnits;
                decimal decVal;
                if (ruptureDisc.Pressure_Relieving_Temperature__c == 'PRTSameAsTemperatureSetting') {
                    strUnits = ruptureDisc.Temperature_Setting_Units__c;
                    decVal = ruptureDisc.Temperature_Setting__c;
                } else {
                    strUnits = ruptureDisc.Enter_Different_Temperature_Units__c;
                    decVal = ruptureDisc.Enter_Different_Temperature_Value__c;
                }
                result doubleRelievingTemp1 = getConvertedValErrorMsg('RelTemperature', 99999999, SatTempAtRelievingPressure, 'Deg F', strUnits, decVal, 'Enter Different Temperature Value');
                // }
                if (doubleRelievingTemp1.bErrorCheck)
                    throw new AuraHandledException(doubleRelievingTemp1.strErrorMessage);
            }
            if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') {
                switch on ruptureDisc.Evaluation_Per__c {
                    When 'ASME Gas/Vapor' {
                        if (ruptureDisc.Process_Media__c == 'Air')
                            doubleFlowArea = RDDiscSizingCapacity.ASMEAIRSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue());
                        else
                            doubleFlowArea = RDDiscSizingCapacity.ASMEGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue());
                    }
                    When 'ASME Water' {
                        doubleFlowArea = RDDiscSizingCapacity.ASMEWaterSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), Double.valueOf(14.6959), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue());
                    }
                    When 'ASME Steam' {
                        doubleFlowArea = RDDiscSizingCapacity.ASMESteamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue());
                    }
                    when 'API Gas/Vapor' {
                        doubleFlowArea = RDDiscSizingCapacity.APIGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), Double.valueOf(14.6959), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue());
                    }
                    When 'API Liquid' {
                        doubleFlowArea = RDDiscSizingCapacity.APILiquidSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), resultConvertViscosity.dblRetValue, Double.valueOf(0));
                    }
                    when 'API Steam' {
                        doubleFlowArea = RDDiscSizingCapacity.APISteamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue());
                    }
                    When 'ISO Gas/Vapor' {
                        //ISOGASSize(double Qm, double Po,double Pb,double To,double K, double M, double Zo)
                        doubleFlowArea = RDDiscSizingCapacity.ISOGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), double.valueOf(1.01325), decConRelievingTemp.doubleValue(), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(), ruptureDisc.Compressibility_Factor__c.doubleValue(), Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c));
                    }
                    When 'ISO Liquid' {
                        doubleFlowArea = RDDiscSizingCapacity.ISOLiquidSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c.doubleValue(), ruptureDisc.Converted_Viscosity__c.doubleValue(), double.valueOf(1.01325));
                    }
                    When 'ISO Dry Steam' {
                        doubleFlowArea = RDDiscSizingCapacity.ISODryStreamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue(), Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c));
                    }
                    when 'ISO Wet Steam' {
                        doubleFlowArea = RDDiscSizingCapacity.ISOWetStreamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), Double.valueOf(ruptureDisc.Dryness_of_Wet_Steam__c), Double.valueOf(ruptureDisc.Coefficient_of_Discharge__c));
                    }
                    when 'API Omega Method 2 Phase Flashing or Nonflashing' {
                        //APIOmegaMTD2PhaseSize(double Q, double P0, double V0, double V9, double MU, double PA)
                        doubleFlowArea = RDDiscSizingCapacity.APIOmegaMTD2PhaseSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), dConvertedSpecificVolume,
                            resultConvertSpecificVolumeAt90InletPress.dblRetValue,
                            resultConvertViscosity.dblRetValue, double.valueOf(14.6959));
                    }
                    When 'API Omega Method Subcooled Liquid' {
                        //APIOmegaMtdSubcoolSize(double Q, double PS, double P0, double P10, double P9, double MU, double PA)
                        doubleFlowArea = RDDiscSizingCapacity.APIOmegaMtdSubcoolSize(doubleConvertedFlowCapacity.doubleValue(), resultSaturationPressureAtInlet.dblRetValue,
                            decConRelievingPressure.doubleValue(), dConvertedSpecificGravity, resultDensityAt90Saturation.dblRetValue, resultConvertViscosity.dblRetValue, double.valueOf(14.6959));
                    }
                    When 'Fauske 2 Phase Gas-Liquid' {
                        //FauskeGasLiquidSize(double W, double P0, double PB, double K, double T0, double MW, double R, double X0, double P10)
                        doubleFlowArea = RDDiscSizingCapacity.FauskeGasLiquidSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),
                            double.valueOf(100000), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(),
                            double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(), resultLiquidDensity.dblRetValue);
                    }
                    When 'Fauske 2 Phase Vapor-Liquid' {
                        //FauskeVaporLiquidSize(double W, double P0, double PB,
                        //double K, double T0, double MW, double R, double X0, double PV0, double L0, double C0)
                        doubleFlowArea = RDDiscSizingCapacity.FauskeVaporLiquidSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),
                            double.valueOf(100000), ruptureDisc.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), ruptureDisc.Molecular_Weight__c.doubleValue(),
                            double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(), resultStagnationVaporDensity.dblRetValue, ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(),
                            ruptureDisc.Liquid_specific_heat__c.doubleValue());
                    }
                    When 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' {
                        //FauskeHybridGVLSize(double W, double P0, double PB, double T0, double PG0,
                        //double PV0, double KG, double KV, double MWG, double MWV,
                        //double R, double X0, double P10, double C0, double L0, double PV0_d)
                        doubleFlowArea = RDDiscSizingCapacity.FauskeHybridGVLSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),
                            double.valueOf(100000), decConRelievingTemp.doubleValue(), resultStagnationGaspartialPressure.dblRetValue, resultVaporPressureCorresp.dblRetValue,
                            ruptureDisc.Isentropic_coefficient_gas__c.doubleValue(), ruptureDisc.Isentropic_coefficient_vapor__c.doubleValue(), ruptureDisc.Molecular_Weight_gas__c.doubleValue(),
                            ruptureDisc.Molecular_Weight_vapor__c.doubleValue(), double.valueOf(8314), ruptureDisc.Stagnation_gas_vapor_quality__c.doubleValue(),
                            resultLiquidDensity.dblRetValue, ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(), ruptureDisc.Liquid_specific_heat__c.doubleValue(),
                            resultStagnationVaporDensity.dblRetValue);
                    }
                    When 'Fauske All Liquid Flashing' {
                        //FauskeAllLiquidFlashingSize(double W, double P0, double PB, double T0,
                        //double PG0, double PV0, double R, double C0,
                        //double L0, double PV0_d, double P10, boolean isSaturated)

                        // if(decConRelievingPressure.doubleValue() != (resultStagnationVaporDensity.dblRetValue+resultVaporPressureCorresp.dblRetValue)){
                        //     throw new AuraHandledException('The stagnation gas partial pressure + the vapor pressure corresponding to stagnation temperature should equal the relieving pressure at inlet.'+decConRelievingPressure.doubleValue() + ' ' + resultStagnationVaporDensity.dblRetValue + ' ' +resultVaporPressureCorresp.dblRetValue);
                        // }

                        system.debug('********ISSATURATED'+ruptureDisc.Is_Saturated__c);
                        doubleFlowArea = RDDiscSizingCapacity.FauskeAllLiquidFlashingSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),
                            double.valueOf(100000), decConRelievingTemp.doubleValue(), resultVaporPressureCorresp.dblRetValue,
                            double.valueOf(8314), ruptureDisc.Latent_heat_of_vaporization__c.doubleValue(), ruptureDisc.Liquid_specific_heat__c.doubleValue(),
                            resultStagnationVaporDensity.dblRetValue, resultLiquidDensity.dblRetValue, ruptureDisc.Is_Saturated__c);
                    }
                }
            }
            try {
                if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') {
                    if (doubleFlowArea.bResult) {
                        //result res=unitConversions.SignificantDigitsNormal(doubleFlowArea.dblRetValue,4,1);
                        //ruptureDisc.Flow_Area__c=doubleFlowArea.dblRetValue;
                        Result res1 = unitConversions.SignificantDigitsNormal(doubleFlowArea.dblRetValue, 4, 1);
                        ruptureDisc.Flow_Area__c = res1.dblRetValue;
                        System.debug('Flow Area Calculated Value-->' + res1.dblRetValue);
                        System.debug('Flow Area Calculated Value-->' + ruptureDisc.Flow_Area__c);

                        result conRes = new result();
                        if (ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || ruptureDisc.Evaluation_Per__c == 'Fauske All Liquid Flashing') {
                            conRes = unitConversions.convertArea('m2', ruptureDisc.Required_Flow_Area_Units__c, ruptureDisc.Flow_Area__c);
                        } else if (ruptureDisc.Evaluation_Per__c == 'ISO Dry Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Wet Steam' || ruptureDisc.Evaluation_Per__c == 'ISO Gas/Vapor' || ruptureDisc.Evaluation_Per__c == 'ISO Liquid') {
                            conRes = unitConversions.convertArea('mm2', ruptureDisc.Required_Flow_Area_Units__c, ruptureDisc.Flow_Area__c);
                        } else {
                            conRes = unitConversions.convertArea('in2', ruptureDisc.Required_Flow_Area_Units__c, ruptureDisc.Flow_Area__c);
                        }
                        if (conRes.bResult) {
                            System.debug('Flow Area used for ProductNarrowing-->' + res1.dblRetValue);
                            result res = unitConversions.SignificantDigitsNormal(conRes.dblRetValue, 4, 1);
                            ruptureDisc.Output_Required_Flow_Area__c = res.dblRetValue;
                            ruptureDisc.Flow_Area__c = res1.dblRetValue;
                            System.debug('Flow Area used for Documention and  troubleshooting-->' + res.dblRetValue);
                        }
                    } else {
                        ruptureDisc.Output_Required_Flow_Area__c = 0.0;
                        ruptureDisc.Flow_Area__c = 0.0;
                        throw new AuraHandledException('Please Correct the values,Flow Area is not calculated');

                    }
                } else {
                    ruptureDisc.Output_Required_Flow_Area__c = 0.0;
                    ruptureDisc.Flow_Area__c = 0.0;

                }
                ruptureDisc.Bypass__c = false;
                ruptureDisc.Converted_Density_at_Inlet__c = dConvertedSpecificGravity;
                ruptureDisc.Converted_Specific_Volume__c = dConvertedSpecificVolume;
                ruptureDisc.Converted_Flow_rate__c = doubleConvertedFlowCapacity;
                Double convTemp = 999999999;
                if (ruptureDisc.Evaluation_Per__c != 'ASME Steam') {
                    convTemp = decConRelievingTemp;
                }
                ruptureDisc.Converted_Relieving_Temperature__c = convTemp;
                // ruptureDisc.Converted_Relieving_Temperature__c=decConRelievingTemp;
                ruptureDisc.Converted_Relieving_Pressure_Value__c = decConRelievingPressure;
                ruptureDisc.Converted_Pressure_Setting__c = decPBrustConvertedValue;

                // upsert ruptureDisc;
            } catch (System.DmlException dmle) {
                for (Integer i = 0; i < dmle.getNumDml(); i++) {
                    throw new AuraHandledException(dmle.getDmlMessage(i));
                }
            }

        }
        if (ruptureDisc.Relief_Type__c == 'Vacuum Relief' || (ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief' && (ruptureDisc.Constrain_product_selection__c == 'Vacuum' || ruptureDisc.Constrain_product_selection__c == 'Pressure & Vacuum'))) {
            if (ruptureDisc.VacRequired_Flow_Rate__c == null && ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') //  && (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity' || ruptureDisc.Relief_Type__c=='Vacuum Relief'))
                throw new AuraHandledException('Vacuum Required Flow Rate: Please Enter a Value');
            if (ruptureDisc.VacRequired_Flow_Rate_Units__c == null && ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') //  && (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity' || ruptureDisc.Relief_Type__c=='Vacuum Relief'))
                throw new AuraHandledException('Vacuum Required Flow Rate Units: Please Select a Value from the drop down');
            if (ruptureDisc.VacPressure_Relieving_Temperature__c == null)
                throw new AuraHandledException('VacPressure Relieving Temperature: Please Select a Value');
            if (ruptureDisc.VacPressure_Relieving_Temperature__c == 'vacPRTEnterDifferentTemperatureUnits' && ruptureDisc.VacEnter_Different_Temperature_Value__c == null)
                throw new AuraHandledException('VacEnter Different Temperature Value: Please Enter a Value');
            if (ruptureDisc.VacPressure_Relieving_Temperature__c == 'vacPRTEnterDifferentTemperatureUnits' && (ruptureDisc.VacEnter_Different_Temperature_Units__c == null || ruptureDisc.VacEnter_Different_Temperature_Units__c == ''))
                throw new AuraHandledException('VacEnter Different Temperature Units: Please Select a Value from the drop down');

            //VACUUMSize(double W, double P1, double T)
            result conPres = new result();
            result conTemp = new result();
            result conFlowRate = new Result();
            if (ruptureDisc.Vacuum_Setting__c != null && ruptureDisc.Vacuum_Setting_Units__c != null) {
                conPres = unitConversions.convertPressure(ruptureDisc.Vacuum_Setting_Units__c, 'psia', ruptureDisc.Vacuum_Setting__c);
                if (conPres.bResult)
                    ruptureDisc.Vac_Converted_Vac_Setting__c = conPres.dblRetValue;
                else
                    throw new AuraHandledException(conPres.strErrorMessage);
            }
            if (ruptureDisc.VacPressure_Relieving_Temperature__c == 'vacPRTSameAsTemperatureSetting') {
                conTemp = unitConversions.convertTemperature(ruptureDisc.Temperature_Setting_Units__c, 'Deg R', ruptureDisc.Temperature_Setting__c);
                if (conTemp.bResult) {
                    ruptureDisc.VacConverted_Different_Temp_Setting__c = conTemp.dblRetValue;
                }
            } else if (ruptureDisc.VacPressure_Relieving_Temperature__c == 'vacPRTEnterDifferentTemperatureUnits') {
                conTemp = unitConversions.convertTemperature(ruptureDisc.VacEnter_Different_Temperature_Units__c, 'Deg R', ruptureDisc.VacEnter_Different_Temperature_Value__c);
                if (conTemp.bResult) {
                    ruptureDisc.VacConverted_Different_Temp_Setting__c = conTemp.dblRetValue;
                }
            }
            if (ruptureDisc.Evaluation_Type__c == 'Sizing & Capacity') { // || ruptureDisc.Relief_Type__c=='Vacuum Relief'){
                if (ruptureDisc.VacRequired_Flow_Rate__c != null && ruptureDisc.VacRequired_Flow_Rate_Units__c != null) {
                    conFlowRate = unitConversions.convertGasFlowRate(ruptureDisc.VacRequired_Flow_Rate_Units__c, 'lb/h', ruptureDisc.VacRequired_Flow_Rate__c, ruptureDisc.Vac_Converted_Vac_Setting__c, double.valueOf(28.964), ruptureDisc.VacConverted_Different_Temp_Setting__c, double.valueOf(1));
                    if (conFlowRate.bResult) {
                        ruptureDisc.VacConverted_Flow_Rate__c = conFlowRate.dblRetValue;
                    }
                }
                //VACUUMSize(double W, double P1, double T)
                result vacSize = new result();
                //Result vacConvertedPress = unitConversions.convertPressure('psig', 'psia',ruptureDisc.Converted_Vacuum_Setting__c.doubleValue() );
                Result vacConvertedPress = unitConversions.convertPressure('psig', 'psia', ruptureDisc.Converted_Vacuum_Setting__c);
                vacSize = RDDiscSizingCapacity.VACUUMSize(ruptureDisc.VacConverted_Flow_Rate__c.doubleValue(), vacConvertedPress.dblRetValue, ruptureDisc.VacConverted_Different_Temp_Setting__c.doubleValue());
                if (vacSize.bResult) {
                    ruptureDisc.VacFlow_Area__c = vacSize.dblRetValue;
                    System.debug('VACCUM BEFORE CONVERSTION' + ruptureDisc.VacFlow_Area__c);
                    result conRes2 = unitConversions.convertArea('in2', ruptureDisc.VacRequired_Flow_Area_Units__c, ruptureDisc.VacFlow_Area__c);
                    System.debug('VACCUM AFTER CONVERSTION' + conRes2);
                    if (conRes2.bResult) {
                        result res1 = unitConversions.SignificantDigitsNormal(conRes2.dblRetValue, 4, 1);
                        ruptureDisc.VacRequired_Flow_Area__c = res1.dblRetValue;
                        //ruptureDisc.VacConverted_Flow_Rate__c=res1.dblRetValue;
                    }
                }
            } else {
                ruptureDisc.VacRequired_Flow_Area__c = null;
                ruptureDisc.VacFlow_Area__c = null;
            }
        }

        ruptureDisc = clearSectCCertifications(ruptureDisc);
        ruptureDisc = clearSectDProductNarrowing(ruptureDisc);
        ruptureDisc = clearSectEProductSelection(ruptureDisc);

        try {
            upsert ruptureDisc;
        } catch (System.DmlException dmle) {
            for (Integer i = 0; i < dmle.getNumDml(); i++) {
                throw new AuraHandledException(dmle.getDmlMessage(i));
            }
        }
        return ruptureDisc;
    }

    public static Rupture_Disc__c clearPressureAlone(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Required_Flow_Rate__c = null;
        ruptureDisc.Required_Flow_units__c = null;
        ruptureDisc.Converted_Flow_rate__c = null;
        ruptureDisc.Relieving_Pressure_at_Inlet__c = null;
        ruptureDisc.Enter_Relieving_Pressure_Value__c = null;
        ruptureDisc.Enter_Relieving_Pressure_units__c = null;
        ruptureDisc.Converted_Relieving_Pressure_Value__c = null;
        ruptureDisc.Pressure_Relieving_Temperature__c = null;
        ruptureDisc.Enter_Different_Temperature_Value__c = null;
        ruptureDisc.Enter_Different_Temperature_Units__c = null;
        ruptureDisc.Converted_Relieving_Temperature__c = null;
        ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
        ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
        ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
        ruptureDisc.Viscosity__c = null;
        ruptureDisc.Viscosity_units__c = null;
        ruptureDisc.Converted_Viscosity__c = null;
        ruptureDisc.Specific_Volume_at_inlet__c = null;
        ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
        ruptureDisc.Converted_Specific_Volume__c = null;
        ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
        ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
        ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
        ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
        ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
        ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
        ruptureDisc.Liquid_density__c = null;
        ruptureDisc.Liquid_density_Units__c = null;
        ruptureDisc.Converted_Liquid_Density__c = null;
        ruptureDisc.Stagnation_vapor_density__c = null;
        ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
        ruptureDisc.Converted_Stagnation_vapor_density__c = null;
        ruptureDisc.Stagnation_gas_partial_pressure__c = null;
        ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
        ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
        ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
        ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
        ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
        ruptureDisc.Density_at_Inlet__c = null;
        ruptureDisc.Density_at_Inlet_Units__c = null;
        ruptureDisc.Converted_Density_at_Inlet__c = null;
        ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
        ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
        ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
        ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
        ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
        ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
        ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
        ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
        ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
        ruptureDisc.Dryness_of_Wet_Steam__c = null;
        ruptureDisc.Stagnation_gas_vapor_quality__c = null;
        ruptureDisc.Latent_heat_of_vaporization__c = null;
        ruptureDisc.Isentropic_coefficient_gas__c = null;
        ruptureDisc.Isentropic_coefficient_vapor__c = null;
        ruptureDisc.Molecular_Weight_gas__c = null;
        ruptureDisc.Molecular_Weight_vapor__c = null;
        ruptureDisc.Liquid_specific_heat__c = null;
        ruptureDisc.Flow_Area__c = null;
        ruptureDisc.Output_Required_Flow_Area__c = null;
        ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
        ruptureDisc.Product_Flow_Capacity_Value__c = null;
        return ruptureDisc;
    }

    public static Rupture_Disc__c clearVacuumAlone(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.VacRequired_Flow_Rate__c = null;
        ruptureDisc.VacRequired_Flow_Rate_Units__c = null;
        ruptureDisc.VacConverted_Flow_Rate__c = null;
        ruptureDisc.VacPressure_Relieving_Temperature__c = null;
        ruptureDisc.VacEnter_Different_Temperature_Value__c = null;
        ruptureDisc.VacEnter_Different_Temperature_Units__c = null;
        ruptureDisc.VacConverted_Different_Temp_Setting__c = null;
        ruptureDisc.VacFlow_Area__c = null;
        ruptureDisc.VacRequired_Flow_Area_Units__c = null;
        ruptureDisc.VacRequired_Flow_Area__c = null;
        ruptureDisc.VacFlow_Capacity_Value__c = null;
        ruptureDisc.VacProduct_Flow_Capacity_Units__c = null;
        ruptureDisc.VacProduct_Flow_Capacity_Value__c = null;
        return ruptureDisc;
    }

    public static Rupture_Disc__c clearSizingData(Rupture_Disc__c ruptureDisc) {
        switch on ruptureDisc.Evaluation_Per__c {
            When 'ASME Gas/Vapor' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'ASME Water' {
                ruptureDisc.Pressure_Relieving_Temperature__c = null;
                ruptureDisc.Enter_Different_Temperature_Value__c = null;
                ruptureDisc.Enter_Different_Temperature_Units__c = null;
                ruptureDisc.Converted_Relieving_Temperature__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'ASME Steam' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;

            }
            when 'API Gas/Vapor' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'API Liquid' {
                ruptureDisc.Pressure_Relieving_Temperature__c = null;
                ruptureDisc.Enter_Different_Temperature_Value__c = null;
                ruptureDisc.Enter_Different_Temperature_Units__c = null;
                ruptureDisc.Converted_Relieving_Temperature__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'API Steam' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'ISO Gas/Vapor' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'ISO Liquid' {
                ruptureDisc.Pressure_Relieving_Temperature__c = null;
                ruptureDisc.Enter_Different_Temperature_Value__c = null;
                ruptureDisc.Enter_Different_Temperature_Units__c = null;
                ruptureDisc.Converted_Relieving_Temperature__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'ISO Dry Steam' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'ISO Wet Steam' {
                ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
                ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
                ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'API Omega Method 2 Phase Flashing or Nonflashing' {
                ruptureDisc.Pressure_Relieving_Temperature__c = null;
                ruptureDisc.Enter_Different_Temperature_Value__c = null;
                ruptureDisc.Enter_Different_Temperature_Units__c = null;
                ruptureDisc.Converted_Relieving_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'API Omega Method Subcooled Liquid' {
                ruptureDisc.Pressure_Relieving_Temperature__c = null;
                ruptureDisc.Enter_Different_Temperature_Value__c = null;
                ruptureDisc.Enter_Different_Temperature_Units__c = null;
                ruptureDisc.Converted_Relieving_Temperature__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Stagnation_gas_vapor_quality__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'Fauske 2 Phase Gas-Liquid' {
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
                ruptureDisc.Converted_Stagnation_vapor_density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Latent_heat_of_vaporization__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Liquid_specific_heat__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'Fauske 2 Phase Vapor-Liquid' {
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Liquid_density__c = null;
                ruptureDisc.Liquid_density_Units__c = null;
                ruptureDisc.Converted_Liquid_Density__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure__c = null;
                ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
                ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
                ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
                ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
                ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' {
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
            when 'Fauske All Liquid Flashing' {
                ruptureDisc.Viscosity__c = null;
                ruptureDisc.Viscosity_units__c = null;
                ruptureDisc.Converted_Viscosity__c = null;
                ruptureDisc.Specific_Volume_at_inlet__c = null;
                ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Specific_Volume__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Density_at_Inlet__c = null;
                ruptureDisc.Density_at_Inlet_Units__c = null;
                ruptureDisc.Converted_Density_at_Inlet__c = null;
                ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
                ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
                ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
                ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
                ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
                ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
                ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
                ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
                ruptureDisc.Dryness_of_Wet_Steam__c = null;
                ruptureDisc.Isentropic_coefficient_gas__c = null;
                ruptureDisc.Isentropic_coefficient_vapor__c = null;
                ruptureDisc.Molecular_Weight_gas__c = null;
                ruptureDisc.Molecular_Weight_vapor__c = null;
                ruptureDisc.Flow_Area__c = null;
                ruptureDisc.Output_Required_Flow_Area__c = null;
                ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
                ruptureDisc.Product_Flow_Capacity_Value__c = null;
            }
        }
        return ruptureDisc;
    }
    public static Rupture_Disc__c clearSectFManufacturingRange(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Quantity__c=null;
        ruptureDisc.Finish_Configuration_Flag__c=false;
        ruptureDisc.Rating_and_Range_Flag__c = false;
        ruptureDisc.Pressure_Rating_Type__c=null;
        ruptureDisc.Pressure_Range_Type__c=null;
        ruptureDisc.Special_Range_Min_Input__c=null;
        ruptureDisc.Special_Range_Max_Input__c=null;
        ruptureDisc.Press_Burst_Pressure_Max_Input__c=null;
        ruptureDisc.Press_Burst_Pressure_Min_Input__c=null;
        ruptureDisc.Reference_Mfg_Range_Type__c=null;
        ruptureDisc.Performance_Tolerance_Input_Units__c=null;
        ruptureDisc.Performance_Tolerance_Min_Input__c=null;
        ruptureDisc.Performance_Tolerance_Max_Input__c=null;
        ruptureDisc.Vac_Rating_Type__c=null;
        ruptureDisc.Vac_Range_Type__c=null;
        ruptureDisc.Vac_Special_Range_Min_Input__c=null;
        ruptureDisc.Vac_Special_Range_Max_Input__c=null;
        ruptureDisc.Vac_Burst_Press_Max_Input__c=null;
        ruptureDisc.Vac_Burst_Press_Min_Input__c=null;
        ruptureDisc.Vac_Reference_Mfg_Range_Type__c=null;
        ruptureDisc.Vac_Performance_Tolerance_Units__c=null;
        ruptureDisc.Vac_Performance_Tolerance_Min_Input__c=null;
        ruptureDisc.Vac_Performance_Tolerance_Max_Input__c=null;
        return ruptureDisc;
    }
    public static Rupture_Disc__c clearSectGComponents(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Components_Flag__c=false;
        ruptureDisc.Finish_Configuration_Flag__c=false;
        ruptureDisc.Final_Assembly_Location_Requirements__c=null;
        ruptureDisc.Material_Sourcing_Requirements__c=null;
        ruptureDisc.United_States_HTS_Code__c=null;
        ruptureDisc.Required_Components__c=null;
        ruptureDisc.Optional_Components__c=null;
        ruptureDisc.Material_Arcuate_Ring__c=null;
        ruptureDisc.Material_Armor_Ring2__c=null;
        ruptureDisc.Material_Armor_Ring__c=null;
        ruptureDisc.Material_Dent_Protector__c=null;
        ruptureDisc.Material_Disc__c=null;
        ruptureDisc.Material_Girdle_Cover__c=null;
        ruptureDisc.Material_Girdle__c=null;
        ruptureDisc.Material_Handling_Support__c=null;
        ruptureDisc.Material_Hi_Temp_Assembly__c=null;
        ruptureDisc.Material_Holddown_Ring__c=null;
        ruptureDisc.Material_Inlet_Coating2__c=null;
        ruptureDisc.Material_Inlet_Coating__c=null;
        ruptureDisc.Material_Inlet_Gasket__c=null;
        ruptureDisc.Material_Inlet_Liner__c=null;
        ruptureDisc.Material_Inlet_O_Ring__c=null;
        ruptureDisc.Material_Inlet_Ring2__c=null;
        ruptureDisc.Material_Inlet_Ring3__c=null;
        ruptureDisc.Material_Inlet_Ring__c=null;
        ruptureDisc.Material_Inlet__c=null;
        ruptureDisc.Material_Outlet_Coating__c=null;
        ruptureDisc.Material_Outlet_Gasket__c=null;
        ruptureDisc.Material_Outlet_Liner__c=null;
        ruptureDisc.Material_Outlet_Ring__c=null;
        ruptureDisc.Material_Outlet__c=null;
        ruptureDisc.Material_Seal2__c=null;
        ruptureDisc.Material_Seal3__c=null;
        ruptureDisc.Material_Seal__c=null;
        ruptureDisc.Material_Top_Section2__c=null;
        ruptureDisc.Material_Top_Section__c=null;
        //ruptureDisc.Material_of_Vacuum_Support_3__c=null;
        ruptureDisc.Material_Vacuum_Support2__c=null;
        ruptureDisc.Material_Vacuum_Support__c=null;
        ruptureDisc.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=null;
        ruptureDisc.Strip_Type__c=null;
        ruptureDisc.Gasket_Material__c=null;
        ruptureDisc.Wiring_Configuration__c=null;
        ruptureDisc.Wire_Type__c=null;
        ruptureDisc.Cable_Length__c=null;
        ruptureDisc.End_Connection__c=null;
        ruptureDisc.To_Make_With_BDI_FLX_Interface_cable__c=null;
        return ruptureDisc;
    }
    public static Rupture_Disc__c clearAllSectBfields(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Evaluation_Per__c = null;
        ruptureDisc.Process_Media__c = null;
        ruptureDisc.Customer_Specified_Media__c = null;
        ruptureDisc.Molecular_Weight__c = null;
        ruptureDisc.Compressibility_Factor__c = null;
        ruptureDisc.Ratio_of_Specific_Heats__c = null;
        ruptureDisc.VacRequired_Flow_Area__c = null;
        ruptureDisc.VacPressure_Relieving_Temperature__c = null;
        ruptureDisc.Evaluation_Type__c = null;

        ruptureDisc.VacFlow_Area__c = null;
        ruptureDisc.Required_Flow_Area_Units__c = null;
        ruptureDisc.VacRequired_Flow_Area_Units__c = null;
        ruptureDisc.Flow_Area__c = null;
        ruptureDisc.Output_Required_Flow_Area__c = null;
        ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
        ruptureDisc.Product_Flow_Capacity_Value__c = null;
        ruptureDisc.Required_Flow_Rate__c = null;
        ruptureDisc.Required_Flow_units__c = null;
        ruptureDisc.Relieving_Pressure_at_Inlet__c = null;
        ruptureDisc.Pressure_Relieving_Temperature__c = null;
        ruptureDisc.Enter_Relieving_Pressure_Value__c = null;
        ruptureDisc.Enter_Relieving_Pressure_units__c = null;
        ruptureDisc.Coefficient_of_Discharge__c = null;
        ruptureDisc.Enter_Different_Temperature_Value__c = null;
        ruptureDisc.Enter_Different_Temperature_Units__c = null;
        ruptureDisc.Density_Specific_Volume_Specific_Gravity__c = null;
        ruptureDisc.Density_SpecificVolume_SpcfcGravityUnits__c = null;
        ruptureDisc.Viscosity__c = null;
        ruptureDisc.Viscosity_units__c = null;
        ruptureDisc.Specific_Volume_at_inlet__c = null;
        ruptureDisc.Specific_Volume_at_Inlet_Units__c = null;
        ruptureDisc.Dryness_of_Wet_Steam__c = null;
        ruptureDisc.Specific_Volume_at_90_of_Inlet_Pressure__c = null;
        ruptureDisc.Specific_Volume_at_90_of_Inlet_Units__c = null;
        ruptureDisc.Saturation_Pressure_at_Inlet_Temperature__c = null;
        ruptureDisc.Saturation_Pressure_at_inlet_temp_units__c = null;
        ruptureDisc.Stagnation_gas_vapor_quality__c = null;
        ruptureDisc.Liquid_density__c = null;
        ruptureDisc.Stagnation_vapor_density__c = null;
        ruptureDisc.Latent_heat_of_vaporization__c = null;
        ruptureDisc.Stagnation_gas_partial_pressure__c = null;
        ruptureDisc.Vapor_pres_correspond_to_stagnation_temp__c = null;
        ruptureDisc.Isentropic_coefficient_gas__c = null;
        ruptureDisc.Isentropic_coefficient_vapor__c = null;
        ruptureDisc.Molecular_Weight_gas__c = null;
        ruptureDisc.Molecular_Weight_vapor__c = null;
        ruptureDisc.Liquid_specific_heat__c = null;
        ruptureDisc.Liquid_density_Units__c = null;
        ruptureDisc.Vapor_Pres_to_Stagnation_temp_Units__c = null;
        ruptureDisc.Stagnation_Vapor_Density_Units__c = null;
        ruptureDisc.VacConverted_Flow_Rate__c = null;
        ruptureDisc.Stagnation_gas_partial_pressure_Units__c = null;
        ruptureDisc.VacRequired_Flow_Rate__c = null;
        ruptureDisc.VacRequired_Flow_Rate_Units__c = null;
        ruptureDisc.VacEnter_Different_Temperature_Value__c = null;
        ruptureDisc.VacEnter_Different_Temperature_Units__c = null;
        ruptureDisc.VacConverted_Different_Temp_Setting__c = null;
        ruptureDisc.Density_at_Inlet__c = null;
        ruptureDisc.Density_at_Inlet_Units__c = null;
        ruptureDisc.Converted_Flow_rate__c = null;
        ruptureDisc.Converted_Different_Temperature_Setting__c = null;
        ruptureDisc.Converted_Density_at_Inlet__c = null;
        ruptureDisc.Converted_Liquid_Density__c = null;
        ruptureDisc.Converted_Liquid_Density_at_inlet__c = null;
        ruptureDisc.Converted_Relieving_Pressure_Value__c = null;
        ruptureDisc.Converted_Specific_Volume_at_Inlet__c = null;
        ruptureDisc.Converted_Stagnation_vapor_density__c = null;
        ruptureDisc.Converted_Viscosity__c = null;
        ruptureDisc.ConvertedDensity_at_90SaturationPressure__c = null;
        ruptureDisc.ConvertedSaturationPressure_at_InletTemp__c = null;
        ruptureDisc.ConvertedSpecificVolumeat90_ofInletPress__c = null;
        ruptureDisc.Converted_Density_Speci_Volume_SpeGravit__c = null;
        ruptureDisc.Density_at_90_of_Saturation_Pressure__c = null;
        ruptureDisc.Density_at_90_Saturation_Pressure_Units__c = null;
        ruptureDisc.Converted_Stagnation_gaspartial_Pressure__c = null;
        ruptureDisc.ConvVapor_pres_corres_to_stagnation_temp__c = null;
        return ruptureDisc;
    }


    public static Rupture_Disc__c clearDataBasedOnReliefType(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Bypass__c = true;

        if (ruptureDisc.Relief_Type__c == 'Pressure Relief') {
            ruptureDisc.Vacuum_Setting__c = null;
            ruptureDisc.Converted_Vacuum_Setting__c = null;
            ruptureDisc.Vacuum_Setting_Units__c = null;
            ruptureDisc.Converted_Positive_Pressure_Value__c = null;
            ruptureDisc.Positive_Pressure_Value__c = null;
            ruptureDisc.Positive_Pressure_Units__c = null;
            ruptureDisc.Pressure_Withstand__c = null;
            ruptureDisc.Constrain_product_selection__c = null;
        }
        if (ruptureDisc.Relief_Type__c == 'Vacuum Relief') {
            ruptureDisc.Pressure_Setting__c = null;
            ruptureDisc.Converted_Pressure_Setting__c = null;
            ruptureDisc.Pressure_Setting_Units__c = null;
            ruptureDisc.Vacuum_Withstand__c = null;
            ruptureDisc.Back_Pressure_Value__c = null;
            ruptureDisc.Back_Pressure_Units__c = null;
            ruptureDisc.Converted_Back_Pressure_Value__c = null;
            ruptureDisc.Constrain_product_selection__c = null;
        }
        if (ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief') {
            ruptureDisc.Vacuum_Withstand__c = null;
            ruptureDisc.Back_Pressure_Value__c = null;
            ruptureDisc.Back_Pressure_Units__c = null;
            ruptureDisc.Converted_Back_Pressure_Value__c = null;
            ruptureDisc.Positive_Pressure_Value__c = null;
            ruptureDisc.Converted_Positive_Pressure_Value__c = null;
            ruptureDisc.Positive_Pressure_Units__c = null;
            ruptureDisc.Pressure_Withstand__c = null;
            //ruptureDisc.Constrain_product_selection__c=ruptureDisc.Constrain_product_selection__c;
        }
        return ruptureDisc;
    }

    public static Rupture_Disc__c clearSectCCertifications(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Bypass__c = true;
        if (ruptureDisc.Evaluation_Per__c == 'ASME Steam' || ruptureDisc.Evaluation_Per__c == 'ASME Water' || ruptureDisc.Evaluation_Per__c == 'ASME Gas/Vapor') {
            ruptureDisc.ASME_Section_VIII_Division_1__c = true;
        } else {
            ruptureDisc.ASME_Section_VIII_Division_1__c = false;
        }
        ruptureDisc.CSA_Marking_CRN_Number__c = false;
        ruptureDisc.KOSHA_Compliance__c = false;
        ruptureDisc.ASME_BPE__c = false;
        ruptureDisc.CU_TR__c = false;
        ruptureDisc.X3A_Sanitary_Standards__c = false;
        ruptureDisc.Comply_with_AD2000_Merkblat_A1__c = false;
        ruptureDisc.Atex_Certificate__c = false;
        ruptureDisc.Gas_Group__c = null;
        ruptureDisc.Zone_0_2__c = null;
        ruptureDisc.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = false;
        ruptureDisc.NACE__c = 'N';
        ruptureDisc.PED_2014_68_EU_CE_mark__c = 'NonePED';
        ruptureDisc.China_Manufacturing_License__c = 'NoneCML';
        return ruptureDisc;
    }

    public static Rupture_Disc__c clearSectDProductNarrowing(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Bypass__c = true;

        ruptureDisc.Non_Fragmenting_Design_Required__c = false;
        ruptureDisc.Operating_Pressure_Ratio__c = 'OPRNone';
        ruptureDisc.Application_type__c = null;
        ruptureDisc.Disc_Material_of_Construction__c = '';
        return ruptureDisc;
    }

    public static Rupture_Disc__c clearSectEProductSelection(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Bypass__c = true;

        //ProductSelection Section Fields
        ruptureDisc.Product_Selection__c = false;
        ruptureDisc.Product__c = null;
        ruptureDisc.Seat__c = null;
        ruptureDisc.Size__c = null;
        //ruptureDisc.Size_Units__c=null;

        //HClass Section Fields
        ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
        ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c = null;
        ruptureDisc.Pressure_Class__c = null;
        ruptureDisc.Inlet_Connection__c = null;
        ruptureDisc.Outlet_Connection__c = null;
        return ruptureDisc;
    }
    public static Rupture_Disc__c clearHCLASSSelection(Rupture_Disc__c ruptureDisc) {
        ruptureDisc.Bypass__c = true;

        //ProductSelection Section Fields
        // ruptureDisc.Product_Selection__c = false;
        // ruptureDisc.Product__c = null;
        // ruptureDisc.Seat__c = null;
        // ruptureDisc.Size__c = null;
        //ruptureDisc.Size_Units__c=null;

        //HClass Section Fields
        ruptureDisc.Rupture_Disc_Flow_Capacity_Value__c = null;
        ruptureDisc.Product_Flow_Capacity_Value__c= null;
        ruptureDisc.VacFlow_Capacity_Value__c =null;
        ruptureDisc.VacProduct_Flow_Capacity_Value__c = null;
        //ruptureDisc.Rupture_Disc_Flow_Capacity_Units__c = null;
        ruptureDisc.Pressure_Class__c = null;
        ruptureDisc.Inlet_Connection__c = null;
        ruptureDisc.Outlet_Connection__c = null;
        return ruptureDisc;
    }
    //added by piyush for readonly/editable logic
    @AuraEnabled
    public static user fetchUserInfo() {
        user oUser = [Select Id, profile.Name From User WHERE id =: userinfo.getUserId()];
        return oUser;
    }

    //added by piyush for readonly/editable logic
    @AuraEnabled
    public static formAccessibilityWrapper fetchFormAccessibility(string qliId) {
        SBQQ__QuoteLine__c qli = [SELECT Id, Run_Config_Sync__c, SBQQ__Quote__c, SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c WHERE Id =: qliId];
        string quoteStatus = qli.SBQQ__Quote__r.SBQQ__Status__c;
        formAccessibilityWrapper oformAccessibilityWrapper = new formAccessibilityWrapper();
        // Rupture_Disc__c RD = DataSelectorWizard.getFlameProductRecord(qliId);
        Rupture_Disc__c RD = [Select id, Name, Finish_Configuration_Flag__c, Quote_Descriptions_Override__c From Rupture_Disc__c WHERE Quote_Line__c =: qliId];
        oformAccessibilityWrapper.bConfigurationComplete = RD.Finish_Configuration_Flag__c;
        string configStatus = '';
        if (RD.Finish_Configuration_Flag__c) {
            if (RD.Quote_Descriptions_Override__c) {
                // complete with override
                configStatus = 'Complete with Override(s)';

            } else {
                // complete no override
                configStatus = 'Complete No Overrides';
            }
        } else {
            configStatus = 'Incomplete';
            // incomplete
        }

        ProductAccessibilityConfig__mdt oPacMetaData = fetchCurrentProductAccessibility(quoteStatus, configStatus);
        oformAccessibilityWrapper.bShowEditButton = false;
        string defaultQuoteLineView = oPacMetaData.Default_View__c;
        string QuoteLIneView = oPacMetaData.View__c;
        if (QuoteLIneView == 'Editable') {
            oformAccessibilityWrapper.bShowEditButton = true;
            if (defaultQuoteLineView == 'Editable') {
                oformAccessibilityWrapper.bReadOnly = false;
                oformAccessibilityWrapper.bShowEditButton = false;
            } else {
                oformAccessibilityWrapper.bReadOnly = true;
            }

        } else {
            oformAccessibilityWrapper.bReadOnly = true;
        }
        return oformAccessibilityWrapper;
    }

    public class formAccessibilityWrapper {
        @AuraEnabled public boolean bReadOnly {
            get;
            set;
        }
        @AuraEnabled public boolean bShowEditButton {
            get;
            set;
        }
        @AuraEnabled public boolean bConfigurationComplete {
            get;
            set;
        }

    }

    private static ProductAccessibilityConfig__mdt fetchCurrentProductAccessibility(string sQuoteStatus, string sConfigStatus) {
        ProductAccessibilityConfig__mdt oPac;
        for (ProductAccessibilityConfig__mdt pac: UtilityHelper.self.lstProductAccessibilityConfigs) {
            list < string > lstQuoteStatus = pac.Quote_Status__c.split(';');
            if (lstQuoteStatus.contains(sQuoteStatus)) {
                if (pac.Config_Status__c == 'All' && oPac == null) {
                    oPac = pac;
                } else {
                    if (pac.Config_Status__c == sConfigStatus) {
                        oPac = pac;
                    }
                }
            }
        }

        return oPac == null ? new ProductAccessibilityConfig__mdt() : oPac;
    }

    //#######################################################################################################################
}