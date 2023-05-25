/**
 * @File Name          : ConfigHolderUtility.cls
 * @Description        :
 * @Author             : Nikhil Arpally
 * @Group              :
 * @Last Modified By   : Nikhil Arpally
 * @Last Modified On   : 11/6/2020, 1:55:19 pm
 * @Modification Log   :
 * Ver       Date            Author                 Modification
 * 1.0     11/6/2020       Nikhil Arpally           Initial Version
 * 1.1    23-Apr-2021      Rohini Hathi          Service Ticket #202464, removed the extra clause on self record id chk for null(not required and was breaking further where clause)
 * and added missing bracket in query in getStructures() method
**/
public with sharing class ConfigHolderUtility {

    /*public ConfigHolderUtility() {

    }*/
   public Holders__c currentHLD {get; set;}
   public ConfigHolderUtility (Id recordID) {
        currentHLD= (Holders__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];


    }


    //Holder Required parameters info method
    public static Map<String, Object> holderRequiredParameters(){
        Map<String, Object> listTotal = new Map<String, Object>();
        SObjectType sobType = Holders_Required_Component__c.SObjectType;
        system.debug('sobType:'+sobType);
        List<String> fields = new List<String>(sobType.getDescribe().fields.getMap().keySet());
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Holders_Required_Component__c.fields.getMap();
        System.debug('schemaFieldMap...'+schemaFieldMap);
        for(SObject sob : Database.query(
            ' SELECT ' + String.join(fields, ',')
            + ' FROM ' + sobType)){
            Schema.SObjectField ptc = schemaFieldMap.get('PTC__c');
            Object value = sob.get(ptc);
            System.debug('schemaFieldMap.......value'+value);
            if(value != null){
                listTotal.put(String.valueOf(value), sob);
            }
        }
        System.debug('Results '+listTotal);
        return listTotal;
    }


    /*Map<String, Object> records = ConfigHolderUtility.holderRequiredParameters();
    system.debug('Result '+ConfigHolderUtility.isHolderParamterRequired((sObject)records.get('BH2'), 'Inlet__c'));
    */
    public static Boolean isHolderParamterRequired(SObject holderRequiredInfo, String fieldName){
        Map<String, Object> fieldsToValue = holderRequiredInfo.getPopulatedFieldsAsMap();
        return (Boolean)fieldsToValue.get(fieldName);
    }

    public static String isHolderParamterRequiredString(SObject holderRequiredInfo, String fieldName){
        System.debug('holderRequiredInfo...'+holderRequiredInfo);
        Map<String, Object> fieldsToValue = holderRequiredInfo.getPopulatedFieldsAsMap();
        return (String)fieldsToValue.get(fieldName);
    }

    /*
    ** Holder Input Map that retunr the all inputs as a map<String,String>
    ** Key is the Input Attribute and value is the input value for the key Attribute
    **/
    public static map<String,String> holderInputs(Holders__c hldrRecord){
        map<String,String> holderInputMap = new map<String,String>();
        //holderInputMap.put('ASME', hldrRecord.ASME_Section_VIII__c);
        holderInputMap.put('ASME', hldrRecord.ASME_Section_VIII__c ? '8': 'N');
        holderInputMap.put('ASSYLOCATION', hldrRecord.Final_Assembly_Location_Requirements__c==null?'':hldrRecord.Final_Assembly_Location_Requirements__c);
        if(hldrRecord.ATEX_Certificate__c){
            holderInputMap.put('ATEX', 'Y');
        }else{
            holderInputMap.put('ATEX', 'N');
        }
        holderInputMap.put('BoreCF', hldrRecord.Bore__c==null?'':hldrRecord.Bore__c);
        holderInputMap.put('BoreIn', hldrRecord.Bore_Inlet__c==null?'':hldrRecord.Bore_Inlet__c);
        holderInputMap.put('BoreOut', hldrRecord.Bore2__c==null?'':hldrRecord.Bore2__c);
        if(String.isNotBlank(hldrRecord.China_Manufacturing_License__c)){
            holderInputMap.put('CHINAMFG', hldrRecord.China_Manufacturing_License__c);
        }else{
            holderInputMap.put('CHINAMFG', 'N');
        }
        holderInputMap.put('CLEAN', hldrRecord.Cleaning_Markings__c==null?'N':hldrRecord.Cleaning_Markings__c);
        holderInputMap.put('CoatingBody', hldrRecord.Coating_Body__c==null?'':hldrRecord.Coating_Body__c);
        holderInputMap.put('CoatingIn', hldrRecord.Coating_Inlet__c==null?'':hldrRecord.Coating_Inlet__c);
        holderInputMap.put('CoatingMFLG', hldrRecord.Coating_Mid_Flange__c==null?'':hldrRecord.Coating_Mid_Flange__c);
        holderInputMap.put('CoatingOut', hldrRecord.Coating__c==null?'':hldrRecord.Coating__c);
        if(hldrRecord.CSA_Markings__c){
            holderInputMap.put('CSA', 'Y');
        }else{
            holderInputMap.put('CSA', 'N');
        }
        holderInputMap.put('CSSUM', hldrRecord.Size_Unit__c==null?'':hldrRecord.Size_Unit__c);
        if(hldrRecord.GOST_CUTR_Compliance__c){
            holderInputMap.put('CUTR', 'Y');
        }else{
            holderInputMap.put('CUTR', 'N');
        }
        if(hldrRecord.X3A_Sanitary_Standards__c){
            holderInputMap.put('H3ASRV', 'Y');
        }else{
            holderInputMap.put('H3ASRV', 'N');
        }
        holderInputMap.put('DPTC', hldrRecord.Rupture_Disc_Product__c==null?'':hldrRecord.Rupture_Disc_Product__c);
        holderInputMap.put('DSZC', hldrRecord.Size__c==null?'':hldrRecord.Size__c);
        holderInputMap.put('ExcessFlowValveSelectionMFLG', hldrRecord.Excess_Flow_Valve_Mid_Flange__c==null?'':hldrRecord.Excess_Flow_Valve_Mid_Flange__c);
        holderInputMap.put('ExcessFlowValveSelectionOut', hldrRecord.Excess_Flow_Valve__c==null?'':hldrRecord.Excess_Flow_Valve__c);
        holderInputMap.put('EyeboltDrilllIn', hldrRecord.Eyebolts_Drilling_Inlet__c==null?'':hldrRecord.Eyebolts_Drilling_Inlet__c);
        holderInputMap.put('EyeboltDrilllMFLG', hldrRecord.Eyebolts_Drilling_Midflange__c==null?'':hldrRecord.Eyebolts_Drilling_Midflange__c);
        holderInputMap.put('EyeboltDrillOut', hldrRecord.Eyebolts_Outlet__c==null?'':hldrRecord.Eyebolts_Outlet__c);
        if(String.isNotBlank(hldrRecord.Eyebolts_Drilling_Inlet__c)){
            holderInputMap.put('EyeboltMatlIn', '020');
        } else {
            holderInputMap.put('EyeboltMatlIn', '');
        }
        if(String.isNotBlank(hldrRecord.Eyebolts_Drilling_Midflange__c)){
            holderInputMap.put('EyeboltMatlMFLG', '020');
        } else {
            holderInputMap.put('EyeboltMatlMFLG', '');
        }
        if(String.isNotBlank(hldrRecord.Eyebolts_Outlet__c)){
            holderInputMap.put('EyeboltMatlOut', '020');
        } else {
            holderInputMap.put('EyeboltMatlOut', '');
        }
        holderInputMap.put('GASGRP', hldrRecord.Gas_Group__c==null?'':hldrRecord.Gas_Group__c);
        holderInputMap.put('GaugeSelectionMFLG', hldrRecord.Gauge_Selection_Mid_Flange__c==null?'':hldrRecord.Gauge_Selection_Mid_Flange__c);
        holderInputMap.put('GaugeSelectionOut', hldrRecord.Gauge_Selection_Outlet__c==null?'':hldrRecord.Gauge_Selection_Outlet__c);
        holderInputMap.put('HCLASS', hldrRecord.Bolting_Class__c==null?'':hldrRecord.Bolting_Class__c);
        holderInputMap.put('HIC', hldrRecord.Inlet_Connection__c==null?'':hldrRecord.Inlet_Connection__c);
        holderInputMap.put('HOC', hldrRecord.Outlet_Connection__c==null?'':hldrRecord.Outlet_Connection__c);
        holderInputMap.put('HRTMAXUOM', hldrRecord.Holder_Max_Pressure_Units__c==null?'':hldrRecord.Holder_Max_Pressure_Units__c);
        holderInputMap.put('JackscrewCF', hldrRecord.Jackscrew_Drilling__c==null?'':hldrRecord.Jackscrew_Drilling__c);
        holderInputMap.put('JackscrewOut', hldrRecord.Jackscrew_Drilling2__c==null?'':hldrRecord.Jackscrew_Drilling2__c);
        holderInputMap.put('JHOOK', hldrRecord.J_Hook__c==null?'':hldrRecord.J_Hook__c);
        if(hldrRecord.KOSHA_Compliance__c){
            holderInputMap.put('KOSHA', 'Y');
        }else{
            holderInputMap.put('KOSHA', 'N');
        }
        holderInputMap.put('LiningIn', hldrRecord.Lining_Inlet__c==null?'':hldrRecord.Lining_Inlet__c);
        holderInputMap.put('LiningMFLG', hldrRecord.Lining_Mid_Flange__c==null?'':hldrRecord.Lining_Mid_Flange__c);
        holderInputMap.put('LiningOut', hldrRecord.Lining__c==null?'':hldrRecord.Lining__c);
        holderInputMap.put('MATLSOURCE', hldrRecord.Material_Sourcing_Requirements__c==null?'':hldrRecord.Material_Sourcing_Requirements__c);
        holderInputMap.put('MCBODY', hldrRecord.Body_Material__c==null?'':hldrRecord.Body_Material__c);
        holderInputMap.put('MCCF', hldrRecord.Companion_Flange_Material__c==null?'':hldrRecord.Companion_Flange_Material__c);
        holderInputMap.put('MCCLMP', hldrRecord.Clamp_Material__c==null?'':hldrRecord.Clamp_Material__c);
        holderInputMap.put('MCHG', hldrRecord.Gasket_Material__c==null?'':hldrRecord.Gasket_Material__c);

        holderInputMap.put('MCHI', hldrRecord.Inlet_Material__c==null?'':hldrRecord.Inlet_Material__c);
        //holderInputMap.put('MCHI', hldrRecord.Inlet_Material__c==null?'':hldrRecord.Inlet_Material__c.length() == 3 ? hldrRecord.Inlet_Material__c.right(2) : hldrRecord.Inlet_Material__c);
        holderInputMap.put('MCHN', hldrRecord.Nut_Material__c==null?'':hldrRecord.Nut_Material__c);
        holderInputMap.put('MCHO', hldrRecord.Outlet_Material__c==null?'':hldrRecord.Outlet_Material__c);
        //holderInputMap.put('MCHO', hldrRecord.Outlet_Material__c==null?'':hldrRecord.Outlet_Material__c.length() == 3 ? hldrRecord.Outlet_Material__c.right(2) : hldrRecord.Outlet_Material__c);
        holderInputMap.put('MCHRNG', hldrRecord.Holddown_Ring_Material__c==null?'':hldrRecord.Holddown_Ring_Material__c);
        holderInputMap.put('MCJackscrews', hldrRecord.Jackscrews_Additional__c==null?'':hldrRecord.Jackscrews_Additional__c);
        holderInputMap.put('MCKBLDIN', hldrRecord.Knifeblade_Material_Inlet__c==null?'':hldrRecord.Knifeblade_Material_Inlet__c);
        holderInputMap.put('MCKBLDOUT', hldrRecord.Knifeblade_Material__c==null?'':hldrRecord.Knifeblade_Material__c);
        holderInputMap.put('MCMFLG', hldrRecord.Mid_Flange_Material__c==null?'':hldrRecord.Mid_Flange_Material__c);
        holderInputMap.put('MCSpacerRing', hldrRecord.Spacer_Ring_Material__c==null?'':hldrRecord.Spacer_Ring_Material__c);
        holderInputMap.put('MCStudsNuts', hldrRecord.Studs_and_Nuts__c==null?'':hldrRecord.Studs_and_Nuts__c);
        if(String.isNotBlank(hldrRecord.NACE_Compliance__c)){
            holderInputMap.put('NACE', hldrRecord.NACE_Compliance__c);
        }else{
            holderInputMap.put('NACE', 'N');
        }
        holderInputMap.put('NippleMFLG', hldrRecord.Nipple_Mid_Flange__c==null?'':hldrRecord.Nipple_Mid_Flange__c);
        holderInputMap.put('NippleSelectionOut', hldrRecord.Nipple2__c==null?'':hldrRecord.Nipple2__c);
        holderInputMap.put('NippleSelectionMFLG', hldrRecord.Nipple_Mid_Flange__c==null?'':hldrRecord.Nipple_Mid_Flange__c);
        if(hldrRecord.CE_PED_Compliance__c){
            holderInputMap.put('PED', 'Y');
        }else{
            holderInputMap.put('PED', 'N');
        }
        holderInputMap.put('PhysicalPropsMFLG', hldrRecord.Select_Physical_Properties_Mid_Flange__c==null?'':hldrRecord.Select_Physical_Properties_Mid_Flange__c);
        holderInputMap.put('PhysicalPropsOut', hldrRecord.Select_Physical_Properties__c==null?'':hldrRecord.Select_Physical_Properties__c);
        holderInputMap.put('PMI', hldrRecord.PMI__c==null?'N':hldrRecord.PMI__c);
        holderInputMap.put('PressUnitsMFLG', hldrRecord.Select_UOM_Press_Range_Mid_Flange__c==null?'':hldrRecord.Select_UOM_Press_Range_Mid_Flange__c);
        holderInputMap.put('PressUnitsOut', hldrRecord.Select_UOM_Press_Range__c==null?'':hldrRecord.Select_UOM_Press_Range__c);
        holderInputMap.put('PTC', hldrRecord.Holder_Product_Code__c==null?'':hldrRecord.Holder_Product_Code__c);
        holderInputMap.put('RDBP', String.valueOf(hldrRecord.Rupture_Disc_Burst_Pressure__c)==null?'':String.valueOf(hldrRecord.Rupture_Disc_Burst_Pressure__c));
        holderInputMap.put('RDBPU', hldrRecord.Rupture_Disc_Burst_Pressure_Units__c==null?'':hldrRecord.Rupture_Disc_Burst_Pressure_Units__c);
        holderInputMap.put('RDTEMP', String.valueOf(hldrRecord.Rupture_Disc_Burst_Temperature__c)==null?'':String.valueOf(hldrRecord.Rupture_Disc_Burst_Temperature__c));
        holderInputMap.put('RDTEMPUOM', hldrRecord.Rupture_Disc_Burst_Temperature_Units__c==null?'':hldrRecord.Rupture_Disc_Burst_Temperature_Units__c);
        holderInputMap.put('ReducingBushingSelectionMFLG', hldrRecord.Reducing_Bushing_Mid_Flange__c==null?'':hldrRecord.Reducing_Bushing_Mid_Flange__c);
        holderInputMap.put('ReducingBushingSelectionOut', hldrRecord.Reducing_Bushing__c==null?'':hldrRecord.Reducing_Bushing__c);
        if(hldrRecord.Shell_Testing__c){
            holderInputMap.put('SHELLTEST', 'Y');
        }else{
            holderInputMap.put('SHELLTEST', 'N');
        }
        holderInputMap.put('STC', hldrRecord.Seat__c==null?'':hldrRecord.Seat__c);
        if(hldrRecord.Size__c != null){
            holderInputMap.put('SZC', hldrRecord.Size__c);
        }else{
            holderInputMap.put('SZC', hldrRecord.Brand_Dependent_Size__c);
        }
        holderInputMap.put('TeeMFLG', hldrRecord.Tee_Mid_Flange__c==null?'':hldrRecord.Tee_Mid_Flange__c);
        holderInputMap.put('TeeSelectionOut', hldrRecord.Tee2__c==null?'':hldrRecord.Tee2__c);
        holderInputMap.put('TeeSelectionMFLG', hldrRecord.Tee_Mid_Flange__c==null?'':hldrRecord.Tee_Mid_Flange__c);
        holderInputMap.put('TubeCaseMatlMFLG', hldrRecord.Select_Tube_Case_Material_Mid_Flange__c==null?'':hldrRecord.Select_Tube_Case_Material_Mid_Flange__c);
        holderInputMap.put('TubeCaseMatlOut', hldrRecord.Select_Tube_Case_Material__c==null?'':hldrRecord.Select_Tube_Case_Material__c);
        holderInputMap.put('ZONE', hldrRecord.Zone_0_2__c==null?'':hldrRecord.Zone_0_2__c);
        if(hldrRecord.Quantity__c != null){
            holderInputMap.put('Quantity', String.valueOf(hldrRecord.Quantity__c));
        }
        holderInputMap.put('COIN', hldrRecord.Inlet_Option__c==null?'':hldrRecord.Inlet_Option__c);
        holderInputMap.put('COOUT', hldrRecord.Outlet_Option2__c==null?'':hldrRecord.Outlet_Option2__c);
        holderInputMap.put('COMFLG', hldrRecord.Mid_Flange_Option__c==null?'':hldrRecord.Mid_Flange_Option__c);
        holderInputMap.put('COBODY', hldrRecord.Body_Option__c==null?'':hldrRecord.Body_Option__c);
        holderInputMap.put('COCF', hldrRecord.Companion_Flange_Option__c==null?'000':hldrRecord.Companion_Flange_Option__c);
		system.debug('FACINGOUT:::'+hldrRecord.Facing_Outlet__c);
        holderInputMap.put('Entity', hldrRecord.Brand_Formula__c==null?'':hldrRecord.Brand_Formula__c);
        holderInputMap.put('FACINGOUT',hldrRecord.Facing_Outlet__c==null?'':hldrRecord.Facing_Outlet__c);
        holderInputMap.put('FACINGOUT_NEW',hldrRecord.Facing_Outlet__c==null?'':hldrRecord.Facing_Outlet__c);
        system.debug('FACINGOUT@@'+holderInputMap.get('FACINGOUT'));
        holderInputMap.put('FACINGIN',hldrRecord.Facing_Inlet__c==null?'':hldrRecord.Facing_Inlet__c);
        holderInputMap.put('GAUGETAPOUT',hldrRecord.Gauge_Tap__c==null?'':hldrRecord.Gauge_Tap__c);
        holderInputMap.put('GAUGETAPMFLG',hldrRecord.Gauge_Tap2__c==null?'':hldrRecord.Gauge_Tap2__c);
        holderInputMap.put('GAUGETAPIN',hldrRecord.Gauge_Tap_Inlet__c==null?'':hldrRecord.Gauge_Tap_Inlet__c);
        holderInputMap.put('TEEHANDLEMATERIAL',hldrRecord.Tee_Handle_Material__c==null?'':hldrRecord.Tee_Handle_Material__c);

        holderInputMap.put('PRODUCT', hldrRecord.Holder_Product__c);

        holderInputMap.putAll(lookupAttributesAll(holderInputMap));
        Map<String,String> lookupAttMap = lookupAttributesAll(holderInputMap);
        lookupAttMap.putAll(lookupAttributesAll(holderInputMap));

        /*
        for(String lokupAttr: lookupAttMap.keySet()){
            system.debug('lookup  Key == '+lokupAttr+'  Lookup Value == '+lookupAttMap.get(lokupAttr));
        }
        */
        holderInputMap.put('COMF', holderInputMap.get('COMFLG'));
        holderInputMap.put('MCKBLD', holderInputMap.get('MCKBLDIN'));

        //Either “FGLH” if ‘Brand’ = “LaMOT” OR “FGH” if ‘Brand’ = “CDC”
		String astTyp = '';
        if(hldrRecord.Brand_Formula__c == 'LaMOT') {

            astTyp = 'FGLH';

        } else if(hldrRecord.Brand_Formula__c == 'CDC') {

            astTyp = 'FGH';
        }
        holderInputMap.put('ASYTYP', astTyp);

        system.debug('ASHIM HRTMAXPSIG::'+holderInputMap.get('HRTMAXPSIG'));
        system.debug('ASHIM HRTMAXUOM::'+holderInputMap.get('HRTMAXUOM'));
        if(holderInputMap.get('HRTMAXPSIG') != null && holderInputMap.get('HRTMAXUOM') != null &&
          		holderInputMap.get('HRTMAXPSIG') != '' && holderInputMap.get('HRTMAXUOM') != '') {

            Result resultConvertedPressure = unitConversions.convertPressure('psig', holderInputMap.get('HRTMAXUOM'), Decimal.valueOf(holderInputMap.get('HRTMAXPSIG')));
        	system.debug('ASHIM resultConvertedPressure::'+resultConvertedPressure.bResult);
            if(resultConvertedPressure.bResult){
                result resHRTMAX=unitConversions.SignificantDigitsNormal(resultConvertedPressure.dblRetValue, 3, 0);
                holderInputMap.put('HRTMAXConverted', String.valueOf(resHRTMAX.dblRetValue)+' '+holderInputMap.get('HRTMAXUOM'));
            	holderInputMap.put('HRTMAX', String.valueOf(resHRTMAX.dblRetValue)+' '+holderInputMap.get('HRTMAXUOM'));
                System.debug('HRTMAX:Pressure:'+String.valueOf(resHRTMAX.dblRetValue));
                System.debug('HRTMAX:UOM::'+holderInputMap.get('HRTMAXUOM'));
            }
		}
        //ConvertTemperature (RDTEMP, RDTEMPUOM, "F")
        if(holderInputMap.get('RDTEMP') != null && holderInputMap.get('RDTEMP') != '' && holderInputMap.get('RDTEMPUOM') != null) {

            Result resultConvertedPressure = unitConversions.convertTemperature(holderInputMap.get('RDTEMPUOM'), 'Deg F', Decimal.valueOf(holderInputMap.get('RDTEMP')));

            if(resultConvertedPressure.bResult){

            	holderInputMap.put('RDTEMPF', String.valueOf(resultConvertedPressure.dblRetValue));
            }
		}

        if(hldrRecord.Rupture_Disc_Burst_Pressure_Converted__c != null) {

            holderInputMap.put('RDBPPSI', String.valueOf(hldrRecord.Rupture_Disc_Burst_Pressure_Converted__c));

        } else {

            holderInputMap.put('RDBPPSI', '0');
        }

        //fetching other attributes as required for interface attributes
        for(Holder_Outputs__c hldOutput: [select OA_Overridden__c, OB_Overridden__c, OW_Overridden__c
                                              FROM Holder_Outputs__c
                                              WHERE ReferenceId__c = :hldrRecord.Id]) {

             holderInputMap.put('OA', hldOutput.OA_Overridden__c);
             holderInputMap.put('OB', hldOutput.OB_Overridden__c);
             holderInputMap.put('OW', hldOutput.OW_Overridden__c);
        }

        //ADDING THE HNPDSC - Ashim
        //Concatenate together 'DESC1' and " " and 'DESC2' and " " and 'DESC3'
        String HNPDSC_Value = '';
        if(holderInputMap.get('DESC1') != null) {

            HNPDSC_Value += holderInputMap.get('DESC1');
        }

        if(holderInputMap.get('DESC2') != null) {

            HNPDSC_Value += ' ';
            HNPDSC_Value += holderInputMap.get('DESC2');
        }

        if(holderInputMap.get('DESC3') != null) {

            HNPDSC_Value += ' ';
            HNPDSC_Value += holderInputMap.get('DESC3');
        }

        holderInputMap.put('HNPDSC', HNPDSC_Value.trim());
        holderInputMap.put('HNDSPSC', HNPDSC_Value.trim());

        holderInputMap.put('GASGROUP', holderInputMap.get('GASGRP'));
        holderInputMap.put('ATEXZONE', holderInputMap.get('ZONE'));
        return holderInputMap;
    }

    public static map<string,string> lookupAttributesAll(Map<String,String> holderInputs){

        Map<String, string> lookupAttributesAllMap = new Map<String, string>();
        Result lookupDetailList = new Result();
        List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
        lookupDetailList=ConfigHolderUtility.getDataFromTranslationObj('Attribute__c','Holder_Lookup_Translation__c','Holder_Lookup_Detail__c',holderInputs,selectCols, null);
        if(lookupDetailList.bResult){
            for(sObject sobj:lookupDetailList.objResultList){
                Holder_Lookup_Detail__c  holderLookupDeatilRecord = new Holder_Lookup_Detail__c ();
                holderLookupDeatilRecord = (Holder_Lookup_Detail__c )sobj;
                if(String.isNotBlank(holderLookupDeatilRecord.Text__c)){
                    lookupAttributesAllMap.put(holderLookupDeatilRecord.Attribute__c, holderLookupDeatilRecord.Text__c);
                }else if(String.isNotBlank(holderLookupDeatilRecord.Value__c)){
                    lookupAttributesAllMap.put(holderLookupDeatilRecord.Attribute__c, holderLookupDeatilRecord.Value__c);
                }else{
                    lookupAttributesAllMap.put(holderLookupDeatilRecord.Attribute__c, '');
                }
            }
        }
        Holder_Lookup_Translation__c[] allAttributes=[select Attribute__c from Holder_Lookup_Translation__c];
        for(Holder_Lookup_Translation__c att:allAttributes) {
            if(!lookupAttributesAllMap.containsKey(att.Attribute__c)) {
                lookupAttributesAllMap.put(att.Attribute__c,'');
            }
        }
        return lookupAttributesAllMap;
    }

    public static map<string,string> lookupAttributes(Map<String,String> holderInputs){
        Map<String, string> lookupAttributesMap = new Map<String, string>();
        Result lookupDetailList = new Result();
        List<String> attributeList = new List<String> {'INLETCOMPPTC','OUTLETCOMPPTC','MCTHDL','TEFTRUEMFLG'};
        List<String> selectCols = new List<String> {'Text__c','Attribute__c'};
        lookupDetailList=ConfigHolderUtility.getDataFromTranslationObj('Attribute__c','Holder_Lookup_Translation__c','Holder_Lookup_Detail__c',holderInputs,selectCols, attributeList);
        if(lookupDetailList.bResult){

            for(sObject sobj:lookupDetailList.objResultList){
                Holder_Lookup_Detail__c  holderLookupDeatilRecord = new Holder_Lookup_Detail__c ();
                holderLookupDeatilRecord = (Holder_Lookup_Detail__c )sobj;
                System.debug('.....holderLookupDeatilRecord...'+holderLookupDeatilRecord.Attribute__c+'..text..'+holderLookupDeatilRecord.Text__c);
                if(holderLookupDeatilRecord.Text__c != null){
                    if(holderLookupDeatilRecord.Attribute__c == 'INLETCOMPPTC'){
                        lookupAttributesMap.put('INLETCOMPPTC', holderLookupDeatilRecord.Text__c);
                    }else if(holderLookupDeatilRecord.Attribute__c == 'OUTLETCOMPPTC'){
                        lookupAttributesMap.put('OUTLETCOMPPTC', holderLookupDeatilRecord.Text__c);
                    }else if(holderLookupDeatilRecord.Attribute__c == 'MCTHDL'){
                        lookupAttributesMap.put('MCTHDL', holderLookupDeatilRecord.Text__c);
                    }

                }
            }
        }

        return lookupAttributesMap;
    }

    public static map<string,Holder_Additional_Acc_Details__c> additionalAccAttributes(Map<String,String> holderInputs){
        Map<String, Holder_Additional_Acc_Details__c> additionalAccAttributesMap = new Map<String, Holder_Additional_Acc_Details__c>();
        Result lookupDetailList = new Result();
        List<String> selectCols = new List<String> {'Accessory__c','Accessory_Part_Number__c','Qty_Per_Assembly__c','Scrap_Factor__c', 'Component_Scrap__c'};
        lookupDetailList=ConfigHolderUtility.getDataFromTranslationObj('Accessory__c','Holder_Additional_Acc_Translation__c','Holder_Additional_Acc_Details__c',holderInputs,selectCols, null);
        if(lookupDetailList.bResult){

            for(sObject sobj:lookupDetailList.objResultList){
                Holder_Additional_Acc_Details__c  holderLookupDeatilRecord = new Holder_Additional_Acc_Details__c ();
                holderLookupDeatilRecord = (Holder_Additional_Acc_Details__c )sobj;
                if(holderLookupDeatilRecord.Accessory__c != null){
                    additionalAccAttributesMap.put(holderLookupDeatilRecord.Accessory__c, holderLookupDeatilRecord);
                }
            }
        }

        return additionalAccAttributesMap;
    }

    public static Result getPricing(map<String,String> holderInputs){
        result BGRPrice = new Result();
        List<String> selectCols = new List<String> {'Price__c','Pricing_Element__c','Price_Override__c'};
            BGRPrice=ConfigHolderUtility.getDataFromTranslationObj('Pricing_Element__c','Holder_Price_Translation__c','Holder_Price_Details__c',holderInputs,selectCols, null);
        if(BGRPrice.bResult){
            system.debug('***Pricing Result' +BGRPrice.objResultList);
        }
        return BGRPrice;
    }

    public static set<String> discuontablePriceElements(){
        set<String> discountPriceElements = new set<String>();
        for(Holder_Price_Translation__c hpt: [Select
            Id
            ,Pricing_Element__c
            FROM Holder_Price_Translation__c
            WHERE Is_Discount_Allowed__c = true]){
                discountPriceElements.add(hpt.Pricing_Element__c);
        }
        return discountPriceElements;
    }

    public static String prepareSOQLQuery(String strKeyVal, String strTransObjName, String strDetailObjName,
                                          	Map<String, String> mapDetails, String[] listSelectCols, String[] keyFilters) {

        Map<string,sObject> mapTrans= new  Map<string,sObject>();
        Map<string,sObject[]> mapDetail= new  Map<string,sObject[]>();
        Map<String, Schema.SObjectField> objectTransFields = Schema.getGlobalDescribe().get(strTransObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
        System.debug('mapDetails: ' + mapDetails);
        // string strTransQuery=
        //System.debug('getDataFromTranslationObj1');
        //try {
            Set<String> TransFieldNames = objectTransFields.keySet();
            Set<String> DetailFieldNames = objectDetailFields.keySet();
            string strTransQuery=' SELECT ' + string.join(new List<String>(TransFieldNames), ',') + ' FROM ' +strTransObjName;
            string strDetailQuery=' SELECT ' + string.join(new List<String>(listSelectCols), ',') + ' FROM ' +strDetailObjName;

            if(keyFilters != null && keyFilters.size() > 0){
                strTransQuery += ' WHERE '+strKeyVal+' IN: keyFilters';
            }

            system.debug('TransFieldNames::'+TransFieldNames);
            system.debug('strTransQuery::'+strTransQuery);
            sObject[] sObjTransList=Database.query(strTransQuery);
            //sObject[] sObjDetailList=Database.query(strDetailQuery);
            set<String> setTransKey=new set<String>();
            set<String> setDetailKey=new set<String>();
            //System.debug('getDataFromTranslationObj2'+strDetailQuery);
            if (!sObjTransList.isEmpty()) {
                for (sObject sObj:sObjTransList) {
                    string strTransKey=(string) sobj.get(strKeyVal);
                    if(setTransKey.add(strTransKey))
                    {
                        System.debug('***** strTransKey = '+strTransKey+', sObj = '+sObj);
                        mapTrans.put(strTransKey,sObj);
                    }

                }
            }
            //System.debug('getDataFromTranslationObj23'+mapTrans);
            List <String> selectCols=new List <String>();
            for(String str:DetailFieldNames) {
                if(str.endsWith('__c'))
                selectCols.add(str);
            }
            String dynamicWhereClause='';
            //integer maxFieldCount=DetailFieldNames.size()-(12+listSelectCols.size()+1);
            integer maxFieldCount=selectCols.size();
            // System.debug('DetailFieldNames'+DetailFieldNames);
            System.debug('DetailFieldNames Size'+mapTrans);
            System.debug('DetailFieldNames Size'+mapTrans.keySet());
            for(String key : mapTrans.keySet()) {
                System.debug('strKeyVal: '+strKeyVal+' ## '+'key: '+  key);
                if(dynamicWhereClause=='')
                    dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
                else
                    dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
                for (integer i=1;i<=maxFieldCount;i++) {

                    string strTransCol='text'+i+'__c';
                    string strDetailCol='text'+i+'val__c';
                    string strNumCol='num'+i+'__c';
                    string strNumValCol='numval'+i+'__c';
                    string strTrasOpp='textopp'+i+'__c';
                    string strTrasNumOpp='numopp'+i+'__c';
                     System.debug('strTransCol = '+strTransCol);
                    // System.debug('strDetailCol = '+strDetailCol);
                    // System.debug('strNumCol = '+strNumCol);
                    // System.debug('strNumValCol = '+strNumValCol);
                    //System.debug('TransFieldNames'+TransFieldNames);
                    // System.debug('TransFieldNames.contains(strTransCol) = '+TransFieldNames.contains(strTransCol)+', TransFieldNames.contains(strNumCol) = '+TransFieldNames.contains(strNumCol));
                    // System.debug('StrKeyVal Outside'+key);
                    if(TransFieldNames.contains(strTransCol) || TransFieldNames.contains(strNumCol))
                    {
                        System.debug(' Inside strKeyVal = '+key+', strTransCol = '+strTransCol);
                        if (TransFieldNames.contains(strTransCol))
                        {
                            string mapKey=(string) mapTrans.get(key).get(strTransCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasOpp);
                            System.debug('mapKey555-'+mapKey+'--'+key);
                            System.debug('strOpp-'+strOpp+'--'+key);
                            System.debug('strOpp-'+strOpp+'--'+key);
                            System.debug('strNumValCol'+strNumValCol);
                            System.debug('mapKey: ' + mapKey+ ' Contains '+mapDetails.containsKey(mapKey));
                            if(mapKey!=null && (mapDetails.containsKey(mapKey)|| mapKey=='All'))
                            {
                                System.debug('After IF-'+key);
                                if(strOpp=='>='||strOpp=='<='||strOpp=='>'||strOpp=='<'){
                                    System.debug('in Equals '+strOpp);
                                    double doubleVal=double.valueOf(mapDetails.get(mapKey));
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+''+strOpp+'\''+doubleVal+'\'';
                                } else if (strOpp=='=ORDASH') {
                                    System.debug('in ORDASH '+strOpp);
                                    dynamicWhereClause=dynamicWhereClause+' And ('+strDetailCol+' = \''+mapDetails.get(mapKey)+'\' or ' +strDetailCol+' = \'-\')';
                                } else if (String.isNotBlank(strOpp) && strOpp.equalsIgnoreCase('contains')) {

                                    if(mapDetails.get(mapKey) != null) {

                                        System.debug('in contains '+strOpp);
                                        dynamicWhereClause += ' And ('+strDetailCol+' like \'%'+mapDetails.get(mapKey)+'%\')';
                                    }
                                    // String detailVal = mapDetails.get(mapKey);
                                    // system.debug(' detailVal '+detailVal+' strDetailCol '+strDetailCol);
                                    // if(String.isNotBlank(detailVal) && detailVal.contains('^')){
                                    //     system.debug('Split val '+detailVal.split('^'));
                                    // }
                                } else{
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+'=\''+mapDetails.get(mapKey)+'\'';
                                    System.debug('in else '+strOpp);
                                }
                            }
                        }
                        if (TransFieldNames.contains(strNumCol)) {
                            string mapKey=(string) mapTrans.get(key).get(strNumCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasNumOpp);
                            System.debug('strNumCol = '+strNumCol+', mapKey = '+mapKey+', strOpp = '+strOpp);
                            if(mapKey!=null && (mapDetails.containsKey(mapKey) && DetailFieldNames.contains(strNumValCol)) ){
                                // System.debug('strNumValCol: ' + strNumValCol);
                                // System.debug('mapKey: ' + mapKey);
                                Schema.DisplayType fielddataType = objectDetailFields.get(strNumValCol).getDescribe().getType();
                                system.debug(' strNumValCol '+strNumValCol+' fielddataType '+fielddataType +' strNumCol '+strNumCol);
                                if(mapDetails.get(mapKey)!=null){
                                    if (fielddataType  != Schema.DisplayType.DOUBLE){
                                        if(strOpp=='=ORDASH'){
                                            dynamicWhereClause=dynamicWhereClause+'  And ('+strNumValCol+' = \''+String.valueOf(mapDetails.get(mapKey))+'\' OR '+strNumValCol+' = \'-\')';
                                        }else{
                                            dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+'\''+String.valueOf(mapDetails.get(mapKey))+'\'';
                                        }
                                    }else{
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey));
                                    }
                                }
                            }
                        }

                    }
                    /*if(mapKey!=null && mapDetails.containsKey(mapKey)) {
                        if(dynamicWhereClause=='')
                            dynamicWhereClause=dynamicWhereClause+' '+strDetailCol+''+strOpp+mapDetails.get(mapKey);
                        else
                            dynamicWhereClause=dynamicWhereClause+ ' OR ('+strDetailCol+''+strOpp+mapDetails.get(mapKey) +')';
                    }*/
                    //System.debug('Dynamic Query'+dynamicWhereClause);
                }
                dynamicWhereClause=dynamicWhereClause+' )';
            }

        if(dynamicWhereClause !=null && string.isNotBlank(dynamicWhereClause)) {

            strDetailQuery = strDetailQuery + ' WHERE ' + dynamicWhereClause;
        }

        // like '%%' is an invalid condition so replacing it with = NULL so that it doesn't fetch unnecessary records
        strDetailQuery = strDetailQuery.replace('like \'%%\'', '= NULL');
        System.debug('Dynamic Query ==' + strDetailQuery);
        return strDetailQuery;
    }

    public static result getDataFromTranslationObj (String strKeyVal, String strTransObjName, String strDetailObjName,
                                                    	Map<String, String> mapDetails, String[] listSelectCols,
                                                    	String[] keyFilters) {
        Result objResult = new Result();

        //preparing the SOQL dynamically
        String strDetailQuery = ConfigHolderUtility.prepareSOQLQuery(strKeyVal, strTransObjName, strDetailObjName, mapDetails, listSelectCols, keyFilters);

        objResult.objResultList = Database.query(strDetailQuery);
		System.debug('strDetailQuery....'+strDetailQuery);
        System.debug('....objResult.objResultList.....'+objResult.objResultList);
        if(!objResult.objResultList.isEmpty())
            objResult.bResult = true;
        else
            objResult.bResult = false;

        return objResult;
    }

    /*
     * This is a overridden method of "getDataFromTranslationObj" which has a additional parameter "orderByDetails"
     * orderByDetails parameter is a String type through which the query can be sorted with
     * if multiple sort is required then pass multiple values in the following way
     * 	COLUMN_1 ASC, COLUMN_2 DESC, COLUMN_3 ASC,
    */
    public static result getDataFromTranslationObj (String strKeyVal, String strTransObjName, String strDetailObjName,
                                                    	Map<String, String> mapDetails, String[] listSelectCols,
                                                    	String[] keyFilters, String orderByDetails) {
        Result objResult = new Result();

        //preparing the SOQL dynamically
        String strDetailQuery = ConfigHolderUtility.prepareSOQLQuery(strKeyVal, strTransObjName, strDetailObjName, mapDetails, listSelectCols, keyFilters);

        if(orderByDetails != null && orderByDetails != '') {

            strDetailQuery += ' ORDER BY '+orderByDetails;
        }
        objResult.objResultList = Database.query(strDetailQuery);

        if(!objResult.objResultList.isEmpty())
            objResult.bResult = true;
        else
            objResult.bResult = false;

        return objResult;
    }

    public static map<string,string> testingCodeAttributesMap(map<string,String> holderInputs){
        Map<String, string> testingCodeAttributes = new Map<String, string>();
        result HLDAttributes = new Result();
        List<String> selectCols = new List<String> {'TestCode__c','InletTest__c','OutletTest__c','MidFlangeTest__c','NutTest__c','RingTest__c','BodyTest__c','ClampTest__c','CompanionFlangeTest__c',
            'GasketTest__c', 'KnifebladeTest__c','TeeHandTest__c','EyeboltsTest__c', 'StudsTest__c','JackTestrewTest__c','CapTestrewTest__c','GaugeTest__c','ExcessFlowTest__c' };
        HLDAttributes=ConfigHolderUtility.getDataFromTranslationObj('TestCode__c','Holder_Testing_Translation__c','Holder_Testing_Details__c',holderInputs,selectCols,null);
        System.debug('STRUCT TEST -->'+HLDAttributes);


        if(HLDAttributes.bResult)
        {
            for(sObject objD : HLDAttributes.objResultList)
            {
                Holder_Testing_Details__c lookupData = (Holder_Testing_Details__c)objD;

                if(String.isNotBlank(lookupData.InletTest__c)){
                    System.debug('lookupAttributesAll....'+holderInputs.get('InletTest')+'....HLDAttributes.bResult...'+HLDAttributes.bResult+'..Id..'+lookupData.Id);
                    testingCodeAttributes.put('InletTest', lookupData.InletTest__c);
                } else {
                    testingCodeAttributes.put('InletTest', '000');
                }
                if(String.isNotBlank(lookupData.OutletTest__c)){
                    testingCodeAttributes.put('OutletTest', lookupData.OutletTest__c);
                } else {
                    testingCodeAttributes.put('OutletTest', '000');
                }
                if(String.isNotBlank(lookupData.MidFlangeTest__c)){
                    testingCodeAttributes.put('MidFlangeTest', lookupData.MidFlangeTest__c);
                } else {
                    testingCodeAttributes.put('MidFlangeTest', '000');
                }
                if(String.isNotBlank(lookupData.NutTest__c)){
                    testingCodeAttributes.put('NutTest', lookupData.NutTest__c);
                } else {
                    testingCodeAttributes.put('NutTest', '000');
                }
                if(String.isNotBlank(lookupData.RingTest__c)){
                    testingCodeAttributes.put('RingTest', lookupData.RingTest__c);
                } else {
                    testingCodeAttributes.put('RingTest', '000');
                }
                if(String.isNotBlank(lookupData.BodyTest__c)){
                    testingCodeAttributes.put('BodyTest', lookupData.BodyTest__c);
                } else {
                    testingCodeAttributes.put('BodyTest', '000');
                }
                if(String.isNotBlank(lookupData.ClampTest__c)){
                    testingCodeAttributes.put('ClampTest', lookupData.ClampTest__c);
                } else {
                    testingCodeAttributes.put('ClampTest', '000');
                }
                if(String.isNotBlank(lookupData.CompanionFlangeTest__c)){
                    testingCodeAttributes.put('CompanionFlangeTest', lookupData.CompanionFlangeTest__c);
                } else {
                    testingCodeAttributes.put('CompanionFlangeTest', '000');
                }
                if(String.isNotBlank(lookupData.GasketTest__c)){
                    testingCodeAttributes.put('GasketTest', lookupData.GasketTest__c);
                } else {
                    testingCodeAttributes.put('GasketTest', '000');
                }
                if(String.isNotBlank(lookupData.KnifebladeTest__c)){
                    testingCodeAttributes.put('KnifebladeTest', lookupData.KnifebladeTest__c);
                } else {
                    testingCodeAttributes.put('KnifebladeTest', '000');
                }
                if(String.isNotBlank(lookupData.TeeHandTest__c)){
                    testingCodeAttributes.put('TeeHandTest', lookupData.TeeHandTest__c);
                } else {
                    testingCodeAttributes.put('TeeHandTest', '000');
                }
                if(String.isNotBlank(lookupData.EyeboltsTest__c)){
                    testingCodeAttributes.put('EyeboltsTest', lookupData.EyeboltsTest__c);
                } else {
                    testingCodeAttributes.put('EyeboltsTest', '000');
                }
                if(String.isNotBlank(lookupData.StudsTest__c)){
                    testingCodeAttributes.put('StudsTest', lookupData.StudsTest__c);
                } else {
                    testingCodeAttributes.put('StudsTest', '000');
                }
                if(String.isNotBlank(lookupData.JackTestrewTest__c)){
                    testingCodeAttributes.put('JackTestrewTest', lookupData.JackTestrewTest__c);
                } else {
                    testingCodeAttributes.put('JackTestrewTest', '000');
                }
                if(String.isNotBlank(lookupData.CapTestrewTest__c)){
                    testingCodeAttributes.put('CapTestrewTest', lookupData.CapTestrewTest__c);
                } else {
                    testingCodeAttributes.put('CapTestrewTest', '000');
                }
                if(String.isNotBlank(lookupData.GaugeTest__c)){
                    testingCodeAttributes.put('GaugeTest', lookupData.GaugeTest__c);
                } else {
                    testingCodeAttributes.put('GaugeTest', '000');
                }
                if(String.isNotBlank(lookupData.ExcessFlowTest__c)){
                    testingCodeAttributes.put('ExcessFlowTest', lookupData.ExcessFlowTest__c);
                } else {
                    testingCodeAttributes.put('ExcessFlowTest', '000');
                }
            }
        } else {
            testingCodeAttributes.put('InletTest', '000');
            testingCodeAttributes.put('ExcessFlowTest', '000');
            testingCodeAttributes.put('GaugeTest', '000');
            testingCodeAttributes.put('CapTestrewTest', '000');
            testingCodeAttributes.put('JackTestrewTest', '000');
            testingCodeAttributes.put('StudsTest', '000');
            testingCodeAttributes.put('EyeboltsTest', '000');
            testingCodeAttributes.put('TeeHandTest', '000');
            testingCodeAttributes.put('KnifebladeTest', '000');
            testingCodeAttributes.put('GasketTest', '000');
            testingCodeAttributes.put('ClampTest', '000');
            testingCodeAttributes.put('BodyTest', '000');
            testingCodeAttributes.put('RingTest', '000');
            testingCodeAttributes.put('NutTest', '000');
            testingCodeAttributes.put('MidFlangeTest', '000');
            testingCodeAttributes.put('InletTest', '000');
            testingCodeAttributes.put('OutletTest', '000');
        }
		System.debug('testingCodeAttributes...utility'+testingCodeAttributes.size());
        return testingCodeAttributes;
    }

    public static map<string,string> additionalCodeAttributesMap(map<string,String> holderInputs){
        Map<String, string> additionalCodeAttributes = new Map<String, string>();
        result HLDAttributes = new Result();
        List<String> selectCols = new List<String> {'CodeType__c','BodyAC__c','CapscrewAC__c','ClampAC__c','CompanionFlangeAC__c','ExcessFlowAC__c','EyeboltsAC__c','GasketAC__c','GaugeAC__c',
            'InletAC__c', 'JackscrewAC__c','KnifebladeAC__c','MidFlangAC__c', 'NutAC__c','OutletAC__c','RingAC__c','StudsAC__c','TeeHandAC__c' };
        HLDAttributes=ConfigHolderUtility.getDataFromTranslationObj('CodeType__c','Holder_Additional_Code_Translation__c','Holder_Additional_Codes_Detail__c',holderInputs,selectCols,null);
        if(HLDAttributes.bResult)
        {
            for(sObject objD : HLDAttributes.objResultList)
            {
                Holder_Additional_Codes_Detail__c lookupData = (Holder_Additional_Codes_Detail__c)objD;

                if(String.isNotBlank(lookupData.BodyAC__c)){
                    additionalCodeAttributes.put('BodyAC', lookupData.BodyAC__c);
                }
                if(String.isNotBlank(lookupData.CapscrewAC__c)){
                    additionalCodeAttributes.put('CapscrewAC', lookupData.CapscrewAC__c);
                }
                if(String.isNotBlank(lookupData.ClampAC__c)){
                    additionalCodeAttributes.put('ClampAC', lookupData.ClampAC__c);
                }
                if(String.isNotBlank(lookupData.CompanionFlangeAC__c)){
                    additionalCodeAttributes.put('CompanionFlangeAC', lookupData.CompanionFlangeAC__c);
                }
                if(String.isNotBlank(lookupData.ExcessFlowAC__c)){
                    additionalCodeAttributes.put('ExcessFlowAC', lookupData.ExcessFlowAC__c);
                }
                if(String.isNotBlank(lookupData.EyeboltsAC__c)){
                    additionalCodeAttributes.put('EyeboltsAC', lookupData.EyeboltsAC__c);
                }
                if(String.isNotBlank(lookupData.GasketAC__c)){
                    additionalCodeAttributes.put('GasketAC', lookupData.GasketAC__c);
                }
                if(String.isNotBlank(lookupData.GaugeAC__c)){
                    additionalCodeAttributes.put('GaugeAC', lookupData.GaugeAC__c);
                }
                if(String.isNotBlank(lookupData.InletAC__c)){
                    additionalCodeAttributes.put('InletAC', lookupData.InletAC__c);
                }
                if(String.isNotBlank(lookupData.JackscrewAC__c)){
                    additionalCodeAttributes.put('JackscrewAC', lookupData.JackscrewAC__c);
                }
                if(String.isNotBlank(lookupData.KnifebladeAC__c)){
                    additionalCodeAttributes.put('KnifebladeAC', lookupData.KnifebladeAC__c);
                }
                if(String.isNotBlank(lookupData.MidFlangAC__c)){
                    additionalCodeAttributes.put('MidFlangAC', lookupData.MidFlangAC__c);
                }
                if(String.isNotBlank(lookupData.NutAC__c)){
                    additionalCodeAttributes.put('NutAC', lookupData.NutAC__c);
                }
                if(String.isNotBlank(lookupData.OutletAC__c)){
                    additionalCodeAttributes.put('OutletAC', lookupData.OutletAC__c);
                }
                if(String.isNotBlank(lookupData.RingAC__c)){
                    additionalCodeAttributes.put('RingAC', lookupData.RingAC__c);
                }
                if(String.isNotBlank(lookupData.StudsAC__c)){
                    additionalCodeAttributes.put('StudsAC', lookupData.StudsAC__c);
                }
                if(String.isNotBlank(lookupData.TeeHandAC__c)){
                    additionalCodeAttributes.put('TeeHandAC', lookupData.TeeHandAC__c);
                }
            }
        }
        return additionalCodeAttributes;
    }

    //Holder Routing Method
    Public static Result getHLDRouting(map<String,String> holderInputs){
        result HLDRouting = new Result();

        String orderBy = 'Operation_Numeric_Val__c ASC, Standard_Operation_ID__c  ASC';
        List<string> selectCols = new List<string> {'Standard_Operation_ID__c','Outside_Operation_Item__c','Descr__c','OPERATION__c'};
        HLDRouting=ConfigHolderUtility.getDataFromTranslationObj('OPERATION__c', 'Holder_Routing_Translation__c', 'Holder_Routing_Detail__c', holderInputs, selectCols, null, orderBy);
        if(HLDRouting.bResult)
        {
            system.debug('***Holder Routing Result' +HLDRouting.objResultList );
        }
        return HLDRouting;
    }

//Holder ControlPlan Method
    Public static Result getHolderControlPlan(map<String,String> holderInputs){
        result HLDControlPlan = new Result();
        List<string> selectCols = new List<string> {'Test_OPNO__c','TEST_OPERATION_DESC__c','NORM_TYPE__c','Operation_Number__c','DATA_TYPE__c','CATEGORY_ID__c','INSPECTION_CODE__c','SAMPLE_PERCENT__c','Process_Characteristic__c','Special_Characteristic_Classification__c','OUTER_MIN__c','INNER_MIN__c','NOMINAL_VALUE__c','INNER_MAX__c','OUTER_MAX__c','Tool_ID__c','Data_Point__c','Test_OPNO_1__c'};
        HLDControlPlan=ConfigHolderUtility.getDataFromTranslationObj('Test_OPNO__c','Holder_ControlPlan_Translation__c','Holder_ControlPlan_Detail__c',holderInputs,selectCols, null);
        if(HLDControlPlan.bResult)
        {
            system.debug('***Holder ControlPlan Result' +HLDControlPlan.objResultList );
        }
        return HLDControlPlan;
    }
 //Holder WorkGuidelines Method
    Public static Result getHolderWorkGuideLines(map<String,String> holderInputs){
        result HLDWorkGL = new Result();

        String orderBy = 'Guideline_Seq_Numeric__c ASC';
        List<string> selectCols = new List<string> {'Operation__c','Test__c','Standard_Operation_ID__c','Outside_Operation_Item__c','Guideline_Seq__c','Description__c','Text__c','Type__c','Sign_Off__c','Inspection_Sign_Off_Required__c'};
            HLDWorkGL=ConfigHolderUtility.getDataFromTranslationObj('Test__c','Holder_WorkGuidelines_Translation__c','Holder_WorkGuidelines_Detail__c',holderInputs,selectCols, null, orderBy);
        if(HLDWorkGL.bResult)
        {
            system.debug('***Holder WorkGuideLines Result' +HLDWorkGL.objResultList );
        }
        return HLDWorkGL;
    }
//Holder Description Method
    Public static Result getHolderDescription(map<String,String> holderInputs){
        result HLDDescription = new Result();
        system.debug('HolderInputs'+holderInputs);
        for(string key:holderInputs.keyset()){
            system.debug('HolderInput----Key'+key+' ----Value '+holderInputs.get(key));
        }
        // holderInputs.remove('EyeboltMatlOut');
        // holderInputs.remove('EyeboltMatlMFLG');
        // holderInputs.remove('EyeboltMatlIn');
        // if(String.isNotBlank(hldrRecord.Eyebolts_Drilling_Inlet__c)){
        //     holderInputMap.put('EyeboltMatlIn', 'Carbon Steel');
        // } else {
        //     holderInputMap.put('EyeboltMatlIn', '');
        // }
        // if(String.isNotBlank(hldrRecord.Eyebolts_Drilling_Midflange__c)){
        //     holderInputMap.put('EyeboltMatlMFLG', '20');
        // } else {
        //     holderInputMap.put('EyeboltMatlMFLG', '');
        // }
        // if(String.isNotBlank(hldrRecord.Eyebolts_Outlet__c)){
        //     holderInputMap.put('EyeboltMatlOut', 'Carbon Steel');
        // } else {
        //     holderInputMap.put('EyeboltMatlOut', '');
        // }

		String orderBy = 'Attribute_Type__c ASC, Order_Sequence__c ASC';
        List<string> selectCols = new List<string> {'Attribute__c','Text__c'};
        HLDDescription=ConfigHolderUtility.getDataFromTranslationObj('Attribute__c','Holder_Description_Translation__c','Holder_Description_Detail__c',holderInputs,selectCols, null, orderBy);
        if(HLDDescription.bResult)
        {
            system.debug('***Holder Description Result' +HLDDescription.objResultList );
        }
        return HLDDescription;
    }

    public list<HLDRStructureWrapper> getStructures(){
        list<HLDRStructureWrapper> structureList = new list<HLDRStructureWrapper>();
        map<String,String> holderInputs=holderInputs(currentHLD);
        String SZCVal = holderInputs.get('SZC');
        String HCLASSVal = holderInputs.get('HCLASS');
        String COINVal = holderInputs.get('COIN');
        String PTCVal = holderInputs.get('PTC');

        Map<String, String> testingCodeAttributes = new Map<String, String>();
        Map<String, String> additionalCodeAttributes = new Map<String, String>();
        Map<String, Holder_Additional_Acc_Details__c> additionalAccAttributes = new Map<String, Holder_Additional_Acc_Details__c>();
        testingCodeAttributes = ConfigHolderUtility.testingCodeAttributesMap(holderInputs);

        additionalAccAttributes =  ConfigHolderUtility.additionalAccAttributes(holderInputs);
        if(!Test.isRunningTest()) {

            additionalCodeAttributes = ConfigHolderUtility.additionalCodeAttributesMap(holderInputs);

        }
        map<String,String> initialHolderStructureInputs = new map<String, String>();
        String initialHolderStructureInputsQuery = 'SELECT Id, InletSC__c, OutletSC__c, MidFlangeSC__c, NutSC__c, RingSC__c, BodySC__c, ClampSC__c, CompanionFlangeSC__c, GasketSC__c, EyeboltsSC__c, ';
        initialHolderStructureInputsQuery += ' StudsSC__c, JackscrewSC__c, CapscrewSC__c, Holder_Structure_Type__c from Holder_Structure__c ';

        boolean isWhereClauseAdded = false;
        String MATLSOURCEVal = holderInputs.get('MATLSOURCE');
        if(String.isNotBlank(MATLSOURCEVal)){
            isWhereClauseAdded = true;
            initialHolderStructureInputsQuery += ' WHERE Holder_Structure_Type__c = \'SourceCode\' AND Material_Sourcing_Requirements__c =: MATLSOURCEVal ';
        }
        if(isWhereClauseAdded){
            for(Holder_Structure__c hs: Database.query(initialHolderStructureInputsQuery)){

                //InletSC
                if(String.isNotBlank(MATLSOURCEVal) && hs.Holder_Structure_Type__c == 'SourceCode'){
                    initialHolderStructureInputs.put('InletSC', hs.InletSC__c);
                    initialHolderStructureInputs.put('OutletSC', hs.OutletSC__c);
                    initialHolderStructureInputs.put('MidFlangeSC', hs.MidFlangeSC__c);
                    initialHolderStructureInputs.put('NutSC', hs.NutSC__c);
                    initialHolderStructureInputs.put('RingSC', hs.RingSC__c);
                    initialHolderStructureInputs.put('BodySC', hs.BodySC__c);
                    initialHolderStructureInputs.put('ClampSC', hs.ClampSC__c);
                    initialHolderStructureInputs.put('CompanionFlangeSC', hs.CompanionFlangeSC__c);
                    initialHolderStructureInputs.put('GasketSC', hs.GasketSC__c);
                    initialHolderStructureInputs.put('EyeboltsSC', hs.EyeboltsSC__c);
                    initialHolderStructureInputs.put('StudsSC', hs.StudsSC__c);
                    initialHolderStructureInputs.put('JackscrewSC', hs.JackscrewSC__c);
                    initialHolderStructureInputs.put('CapscrewSC', hs.CapscrewSC__c);
                }

            }
        }

        String holderStructureQuery = 'SELECT Holder_Structure_Type__c,Id, Component_Part_Number__c, MCKBLD__c, ROP__c, Qty_Per_Assembly__c, Scrap_Factor__c, Component_Scrap__c,LeadtimeSchedule__c from Holder_Structure__c ';
        String PartNoInletWhereClause;
        String MCHIVal = holderInputs.get('MCHI');
        String InletTestVal = testingCodeAttributes.get('InletTest');
        String InletACVal = additionalCodeAttributes.get('InletAC');
        String InletSCVal = initialHolderStructureInputs.get('InletSC');
        map<String,String> lookupAttributes=lookupAttributes(holderInputs);
        String INLETCOMPPTCVal = lookupAttributes.get('INLETCOMPPTC');
        System.debug(' MCHIVal :'+MCHIVal+' InletTestVal :'+InletTestVal+' InletACVal :'+InletACVal+' InletSCVal :'+InletSCVal+' INLETCOMPPTCVal :'+INLETCOMPPTCVal+' SZC__c :'+SZCVal+' HCLASSVal :'+HCLASSVal+' COINVal :'+COINVal);
        if(String.isNotBlank(MCHIVal)){
            holderStructureQuery += ' WHERE (Holder_Structure_Type__c = \'Inlet\' AND INLETCOMPPTC__c =: INLETCOMPPTCVal AND SZC__c =: SZCVal AND MCHI__c =: MCHIVal ';//RHATHI, Service Ticket #202464, reverted, where clause
            holderStructureQuery += ' AND Source_Code__c =: InletSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COINVal AND Testing_Code__c =: InletTestVal AND Additional_Code__c =: InletACVal) ';
        }

        String MCHOVal = holderInputs.get('MCHO');
        String OutletSCVal = initialHolderStructureInputs.get('OutletSC');
        String COOUTVal = holderInputs.get('COOUT');
        String OutletTestVal = testingCodeAttributes.get('OutletTest');
        String OutletACVal = additionalCodeAttributes.get('OutletAC');
        String OUTLETCOMPPTCVal = lookupAttributes.get('OUTLETCOMPPTC');

        if(String.isNotBlank(MCHOVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Outlet\' AND OUTLETCOMPPTC__c =: OUTLETCOMPPTCVal AND SZC__c =: SZCVal AND MCHO__c =: MCHOVal ';
            holderStructureQuery += ' AND Source_Code__c =: OutletSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COOUTVal AND Testing_Code__c =: OutletTestVal AND Additional_Code__c =: OutletACVal) ';
        }

        String MCMFLGVal = holderInputs.get('MCMFLG');
        String MidFlangeSCVal = initialHolderStructureInputs.get('MidFlangeSC');
        String COMFLGVal = holderInputs.get('COMFLG');
        String MidFlangeTestVal = testingCodeAttributes.get('MidFlangeTest');
        String MidFlangACVal = additionalCodeAttributes.get('MidFlangAC');

        if(String.isNotBlank(MCMFLGVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Mid Flange\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCMFLG__c =: MCMFLGVal ';
            holderStructureQuery += ' AND Source_Code__c =: MidFlangeSCVal AND HCLASS__c =: HCLASSVal AND OptionCode__c =: COMFLGVal AND Testing_Code__c =: MidFlangeTestVal AND Additional_Code__c =: MidFlangACVal) ';
        }

        String MCHNVal = holderInputs.get('MCHN');
        String NutSCVal = initialHolderStructureInputs.get('NutSC');
        String NutTestVal = testingCodeAttributes.get('NutTest');
        String NutACVal = additionalCodeAttributes.get('NutAC');

        if(String.isNotBlank(MCHNVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Nut2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHN__c =: MCHNVal ';
            holderStructureQuery += ' AND Source_Code__c =: NutSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: NutTestVal AND Additional_Code__c =: NutACVal) ';
        }

        String MCSpacerRingVal = holderInputs.get('MCSpacerRing');
        String RingSCVal = initialHolderStructureInputs.get('RingSC');
        String RingTestVal = testingCodeAttributes.get('RingTest');
        String RingACVal = additionalCodeAttributes.get('RingAC');

        if(String.isNotBlank(MCSpacerRingVal) && (PTCVal == 'CR8' || PTCVal == 'CR9')){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            //RHATHI, Service Ticket #202464, NOTE:: logic below is correct but will fail as  Holder Structure does not have MCSpacerRing__c to query
          //holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCSpacerRing__c =: MCSpacerRingVal ';
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHRNG__c =: MCSpacerRingVal ';//AND MCSpacerRing__c =: MCSpacerRingVal same as in ConfigOutput
            holderStructureQuery += ' AND Source_Code__c =: RingSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: RingTestVal AND Additional_Code__c =: RingACVal) ';
        }

        String MCHRNGVal = holderInputs.get('MCHRNG');

        if(String.isNotBlank(MCHRNGVal)){ //RHATHI, Service Ticket #202464,  kept same as in configoutput..&& (PTCVal == 'CR8' || PTCVal == 'CR9')){ ..
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Ring2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHRNG__c =: MCHRNGVal ';
            holderStructureQuery += ' AND Source_Code__c =: RingSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: RingTestVal AND Additional_Code__c =: RingACVal) ';
        }

        String MCBODYVal = holderInputs.get('MCBODY');
        String COBODYVal = holderInputs.get('COBODY');
        String BodySCVal = initialHolderStructureInputs.get('BodySC');
        String BodyTestVal = testingCodeAttributes.get('BodyTest');
        String BodyACVal = additionalCodeAttributes.get('BodyAC');

        if(String.isNotBlank(MCBODYVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Body2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCBODY__c =: MCBODYVal AND OptionCode__c =: COBODYVal ';
            holderStructureQuery += ' AND Source_Code__c =: BodySCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: BodyTestVal AND Additional_Code__c =: BodyACVal) ';
        }

        String MCCLMPVal = holderInputs.get('MCCLMP');
        String ClampSCVal = initialHolderStructureInputs.get('ClampSC');
        String ClampTestVal = testingCodeAttributes.get('ClampTest');
        String ClampACVal = additionalCodeAttributes.get('ClampAC');

        if(String.isNotBlank(MCCLMPVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Clamp2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCCLMP__c =: MCCLMPVal ';
            holderStructureQuery += ' AND Source_Code__c =: ClampSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: ClampTestVal AND Additional_Code__c =: ClampACVal) ';
        }

        String MCCFVal = holderInputs.get('MCCF');
        String COCFVal = holderInputs.get('COCF');
        String CompanionFlangeSCVal = initialHolderStructureInputs.get('CompanionFlangeSC');
        String CompanionFlangeTestVal = testingCodeAttributes.get('CompanionFlangeTest')==null?'000':testingCodeAttributes.get('CompanionFlangeTest');
        String CompanionFlangeACVal = additionalCodeAttributes.get('CompanionFlangeAC');
        system.debug('CompanionFlangeSCVal'+CompanionFlangeSCVal);
        system.debug('CompanionFlangeTestVal'+CompanionFlangeTestVal);
        system.debug('CompanionFlangeACVal'+CompanionFlangeACVal);
        system.debug('MCCFVal'+MCCFVal);
        system.debug('COCFVal'+COCFVal);
        if(String.isNotBlank(MCCFVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Companion Flange2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCCF__c =: MCCFVal AND OptionCode__c =: COCFVal';
            holderStructureQuery += ' AND Source_Code__c =: CompanionFlangeSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: CompanionFlangeTestVal AND Additional_Code__c =: CompanionFlangeACVal) ';
        }

        String MCHGVal = holderInputs.get('MCHG');
        String GasketSCVal = initialHolderStructureInputs.get('GasketSC');
        String GasketTestVal = testingCodeAttributes.get('GasketTest');
        String GasketACVal = additionalCodeAttributes.get('GasketAC');

        if(String.isNotBlank(MCHGVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Gasket2\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCHG__c =: MCHGVal ';
            holderStructureQuery += ' AND Source_Code__c =: GasketSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: GasketTestVal AND Additional_Code__c =: GasketACVal) ';
        }

        String MCTHDLVal = lookupAttributes.get('MCTHDL');
        if(String.isNotBlank(MCTHDLVal)){
            String WhereORAnd;
            //RHATHI, Service Ticket #202464, reverted
            if(holderStructureQuery.contains('WHERE')){
                WhereORAnd = ' OR';
            }else{
                WhereORAnd = ' WHERE';
            }
            
            holderStructureQuery += WhereORAnd +' (Holder_Structure_Type__c = \'Tee Handle\' AND PTC__c =: PTCVal ) ';//RHATHI, Service Ticket #202464 , added missing closing bracket
        }

        String EyeboltMatlInVal = holderInputs.get('EyeboltMatlIn');
        String EyeboltsSCVal = initialHolderStructureInputs.get('EyeboltsSC');
        String EyeboltsTestVal = testingCodeAttributes.get('EyeboltsTest');
        String EyeboltsACVal = additionalCodeAttributes.get('EyeboltsAC');
        String partCodeVal = '01';

        if(holderStructureQuery.contains('WHERE')){
            holderStructureQuery += ' OR';
        }else{
            holderStructureQuery += ' WHERE';
        }
        holderStructureQuery += ' (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlInVal AND PartCode__c =: partCodeVal';
        holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

        if(String.isNotBlank(EyeboltMatlInVal)){
            holderStructureQuery += ' )';
        }else{
            holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
        }

        String EyeboltMatlOutVal = holderInputs.get('EyeboltMatlOut');
        String eboPartCodeVal = '02';

        holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlOutVal AND PartCode__c =: eboPartCodeVal';
        holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

        if(String.isNotBlank(EyeboltMatlOutVal)){
            holderStructureQuery += ' )';
        }else{
            holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
        }

        String EyeboltMatlMFLGVal = holderInputs.get('EyeboltMatlMFLG');
        String ebMFLGPartCodeVal = '03';

        holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Eyebolts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCEYEBOLT__c =: EyeboltMatlMFLGVal AND PartCode__c =: ebMFLGPartCodeVal';
        holderStructureQuery += ' AND Source_Code__c =: EyeboltsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: EyeboltsTestVal AND Additional_Code__c =: EyeboltsACVal ';

        if(String.isNotBlank(EyeboltMatlMFLGVal)){
            holderStructureQuery += ' )';
        }else{
            holderStructureQuery += ' AND AutoEyebolt__c = \'Y\' )';
        }

        String MCStudsNutsVal = holderInputs.get('MCStudsNuts');
        String StudsSCVal = initialHolderStructureInputs.get('StudsSC');
        String StudsTestVal = testingCodeAttributes.get('StudsTest');
        String StudsACVal = additionalCodeAttributes.get('StudsAC');

        if(String.isNotBlank(MCStudsNutsVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'StudsandNuts\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MCSTUD__c =: MCStudsNutsVal ';
            holderStructureQuery += ' AND Source_Code__c =: StudsSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: StudsTestVal AND Additional_Code__c =: StudsACVal) ';
        }

        String ReducingBushingSelectionOutVal = holderInputs.get('ReducingBushingSelectionOut');
        if(String.isNotBlank(ReducingBushingSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Reducer Bushing\' AND ReducerBushingSelection__c =: ReducingBushingSelectionOutVal )';
        }

        String ReducingBushingSelectionMFLGVal = holderInputs.get('ReducingBushingSelectionMFLG');
        if(String.isNotBlank(ReducingBushingSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Reducer Bushing\' AND ReducerBushingSelection__c =: ReducingBushingSelectionMFLGVal )';
        }

        String MCJackscrewsVal = holderInputs.get('MCJackscrews');
        String JackscrewSCVal = initialHolderStructureInputs.get('JackscrewSC');
        String JackTestrewTestVal = testingCodeAttributes.get('JackTestrewTest');
        String JackscrewACVal = additionalCodeAttributes.get('JackscrewAC');
        if(String.isNotBlank(MCJackscrewsVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Jackscrews\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal AND MatlCode__c =: MCStudsNutsVal ';
            holderStructureQuery += ' AND Source_Code__c =: JackscrewSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: JackTestrewTestVal AND Additional_Code__c =: JackscrewACVal) ';
        }

        String CapscrewSCVal = initialHolderStructureInputs.get('CapscrewSC');
        String CapTestrewTestVal = testingCodeAttributes.get('CapTestrewTest');
        String CapscrewACVal = additionalCodeAttributes.get('CapscrewAC');
        holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Capscrews\' AND PTC__c =: PTCVal AND SZC__c =: SZCVal ';
        holderStructureQuery += ' AND Source_Code__c =: CapscrewSCVal AND HCLASS__c =: HCLASSVal AND Testing_Code__c =: CapTestrewTestVal AND Additional_Code__c =: CapscrewACVal AND Required__c = true) ';

        String GaugeSelectionOutVal = holderInputs.get('GaugeSelectionOut');
        String PressUnitsOutVal = holderInputs.get('PressUnitsOut');
        String PhysicalPropsOutVal = holderInputs.get('PhysicalPropsOut');
        String TubeCaseMatlOutVal = holderInputs.get('TubeCaseMatlOut');
        if(String.isNotBlank(GaugeSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Gauge\' AND PressUnits__c =: PressUnitsOutVal AND PhysicalProps__c =: PhysicalPropsOutVal AND TubeCaseMatl__c =: TubeCaseMatlOutVal)';
        }

        String GaugeSelectionMFLGVal = holderInputs.get('GaugeSelectionMFLG');
        String PressUnitsMFLGVal = holderInputs.get('PressUnitsMFLG');
        String PhysicalPropsMFLGVal = holderInputs.get('PhysicalPropsMFLG');
        String TubeCaseMatlMFLGVal = holderInputs.get('TubeCaseMatlMFLG');
        if(String.isNotBlank(GaugeSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Gauge\' AND PressUnits__c =: PressUnitsMFLGVal AND PhysicalProps__c =: PhysicalPropsMFLGVal AND TubeCaseMatl__c =: TubeCaseMatlMFLGVal)';
        }

        String NippleSelectionOutVal = holderInputs.get('NippleSelectionOut');
        if(String.isNotBlank(NippleSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Nipple\' AND Desc__c =: NippleSelectionOutVal)';
        }

        String NippleSelectionMFLGVal = holderInputs.get('NippleSelectionMFLG');
        if(String.isNotBlank(NippleSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Nipple\' AND Desc__c =: NippleSelectionMFLGVal)';
        }

        String TeeSelectionOutVal = holderInputs.get('TeeSelectionOut');
        if(String.isNotBlank(TeeSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Tee\' AND Desc__c =: TeeSelectionOutVal)';
        }

        String TeeSelectionMFLGVal = holderInputs.get('TeeSelectionMFLG');
        if(String.isNotBlank(TeeSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Tee\' AND Desc__c =: TeeSelectionMFLGVal)';
        }

        String ExcessFlowValveSelectionOutVal = holderInputs.get('ExcessFlowValveSelectionOut');
        if(String.isNotBlank(ExcessFlowValveSelectionOutVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Excess Flow Valve\' AND Desc__c =: ExcessFlowValveSelectionOutVal)';
        }

        String ExcessFlowValveSelectionMFLGVal = holderInputs.get('ExcessFlowValveSelectionMFLG');
        if(String.isNotBlank(ExcessFlowValveSelectionMFLGVal)){
            holderStructureQuery += ' OR (Holder_Structure_Type__c = \'Excess Flow Valve\' AND Desc__c =: ExcessFlowValveSelectionMFLGVal)';
        }
		
        if(Test.isRunningTest()) {

            holderStructureQuery = 'SELECT Holder_Structure_Type__c,Id, Component_Part_Number__c, MCKBLD__c, ROP__c, Qty_Per_Assembly__c, Scrap_Factor__c, Component_Scrap__c,LeadtimeSchedule__c from Holder_Structure__c  WHERE Id != null ';
        }
        System.debug('STRUCT holderStructureQuery:ConfigHolderUtility cls '+holderStructureQuery);
        for(Holder_Structure__c hs: Database.query(holderStructureQuery)){
            system.debug('STRUCT HS Record '+hs);
            if(String.isNotBlank(hs.Component_Part_Number__c)){
                HLDRStructureWrapper hsw = new HLDRStructureWrapper();
                hsw.ComponentPart = hs.Component_Part_Number__c;
                hsw.MCKBLD = hs.MCKBLD__c;
                if(hs.ROP__c != null)
                    hsw.ROP = String.valueOf(hs.ROP__c);
                if(hs.Qty_Per_Assembly__c != null)
                    hsw.Qty = String.valueOf(hs.Qty_Per_Assembly__c);
                if(hs.Scrap_Factor__c != null)
                    hsw.ScrapFactor = String.valueOf(hs.Scrap_Factor__c);
                if(hs.Holder_Structure_Type__c != null){
                    //hsw.structureType = String.valueOf(hs.Holder_Structure_Type__c); RHATHI, Service Ticket #202464, taken from config
                    String tmpVal;
                    tmpVal = String.valueOf(hs.Holder_Structure_Type__c);
                    tmpVal = tmpVal.replace('2', '');
                    if(tmpVal.contains('StudsandNuts')){
                        tmpVal = tmpVal.replace('StudsandNuts', 'Studs and Nuts');
                    }
                    hsw.structureType = tmpVal;
                }
                if(hs.LeadtimeSchedule__c != null)
                    hsw.leadTime = String.valueOf(hs.LeadtimeSchedule__c);
                hsw.ComponentScrap = hs.Component_Scrap__c;
                //hsw.HolderStructureType = hs.Holder_Structure_Type__c;


                structureList.add(hsw);
                // if(hs.Holder_Structure_Type__c == 'Inlet'){
                // }else if(hs.Holder_Structure_Type__c == 'Outlet'){
                // }
            }

        }

        //where is the Acc1 attribute ?
        System.debug(' haccd Vals === '+additionalAccAttributes.values());
        for(Holder_Additional_Acc_Details__c haccd : additionalAccAttributes.values()){
            System.debug(' haccd === '+haccd);
            if(String.isNotBlank(haccd.Accessory_Part_Number__c)){
                HLDRStructureWrapper hsw = new HLDRStructureWrapper();
                hsw.Qty = haccd.Qty_Per_Assembly__c;
                hsw.ScrapFactor = haccd.Scrap_Factor__c;
                hsw.ComponentScrap = haccd.Component_Scrap__c;
                hsw.ComponentPart = haccd.Accessory_Part_Number__c;
                structureList.add(hsw);
            }
        }
 //strucData.addAll(structureList);
        return structureList;
    }


    /*Wrapper class used for BGMStructure */
    public class HLDRStructureWrapper {
        //public string HolderStructureType {set;get;}
        public string ComponentPart {set;get;}
        public string ROP {set;get;}
        public string Qty {set;get;}
        public string ScrapFactor {set;get;}
        public string ComponentScrap {set;get;}
        public String MCKBLD{get;set;}
        public string structureType{get;set;}
        public string leadTime {get;set;}
        //public string LineItemNo {set;get;}
    }
}