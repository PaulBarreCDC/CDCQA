@isTest
public class RVWeightDeterminationTest
{
    @testSetup
    public static void dataSetup() {
        
        Map<String, String> mapWithRVValues = new Map<String, String>();
        mapWithRVValues.put('BRAND','Groth');
        mapWithRVValues.put('PRODUCT_CODE','RLFVLV');
        mapWithRVValues.put('PRODUCT_NAME','ReliefValves');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRVValues);
        List<RV_Master_Blaster__c> RVMasterBlasterTable = Test.loadData(RV_Master_Blaster__c.sObjectType, 'RV_MasterBlaster_data');
        
        Test.loadData(RV_CFactor__c.sObjectType, 'RV_CFactor');
        Test.loadData(RV_VacSettingLimits__c.sObjectType, 'RV_VacSettingLimits_Data2');
        Test.loadData(RV_PosSettingLimits__c.sObjectType, 'RV_PosSettingLimits_Data2');

        loadRVWeightStackTestData();
        TestDataRVUtility.createRVWeightData(quoteLine);
        TestDataRVUtility.createRVWeightData5(quoteLine);
        TestDataRVUtility.createRVWeightData6(quoteLine);
        TestDataRVUtility.createRVWeightData7(quoteLine);
        TestDataRVUtility.createRVWeightData8(quoteLine);
        
    }

    @isTest
    public static void RVProductNarrowingMethods() {        
        Test.startTest();
        List<Relief_Valve__c> reliefValveList = new List<Relief_Valve__c>();

        reliefValveList = [SELECT Id,ASSYPARTNO__c,Atex_bkend__c,Atex_Certificate__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Back_Pressure_Units__c,Back_Pressure__c,Body_Coating_Material__c,Body_Design__c,Body_Material__c,Brand__c,Brinell_hardness_examination_Backend__c,Brinell_hardness_examination__c,Build_Cost_Override__c,Bypass__c,Charpy_Impact_Testing_Backend__c,Charpy_Impact_Testing__c,Compressibility_Factor__c,Constraint_Product_Selection_By_Flow__c,Converted_Atmospheric_Pressure__c,Converted_Back_Pressure__c,Converted_Max_Process_Pressure__c,Converted_Pressure_Relief_Req_Flow__c,Converted_Pressure_Relieving_Temperature__c,Converted_Pressure_Setting__c,Converted_Relieving_Pressure_Value__c,Converted_Vacuum_Relief_Req_Flow__c,Converted_Vacuum_Setting__c,Customer_Specified_Media_Name__c,CUTR_bkend__c,CU_TR__c,Diaphragm_Material__c,Discountable_Price__c,Document_IDs__c,Drilling__c,Dummy_Atex__c,Dummy_CUTR__c,Dummy_Flowing_Pressure_Units__c,Dummy_Flowing_Pressure__c,Dummy_PED__c,Dummy_Vacuum_Flowing_Pressure_Units__c,Dummy_Vacuum_Flowing_Pressure__c,EffMBP__c,EFFMop__c,Element_Material_Flag__c,Element_Material__c,Engineering_Notes__c,Engineering_Specials__c,Enter_Relieving_Pressure_Units__c,Enter_Relieving_Pressure_Value__c,Facing__c,Fastener_Material__c,Field_Test_Connection_Backend__c,Field_Test_Connection__c,Fillet_Weld_Liquid_Dye_Penetrant_Backend__c,Fillet_Weld_Liquid_Dye_Penetrant__c,Final_Assembly_Location_Requirements__c,Finish_Configuration_Flag__c,Flame_Arrester_Flag__c,Flame_Arrester_Option__c,Flow_Rate_Units__c,Gas_Group__c,Gas_List__c,Hydrotest__c,Intergranular_Corossion_Test_Backend__c,Intergranular_Corossion_Test__c,Is_flame_arrester_needed_with_your_valve__c,Lead_Time_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,Lead_Time_Site_30__c,Lead_Time_Site_40__c,Liquid_Dye_Penetrant__c,List_Price_Each__c,Magnetic_Particle_Examination_Backend__c,Magnetic_Particle_Examination__c,Manual_Blowdown_Backend__c,Manual_Blowdown__c,Material_Sourcing_Requirements__c,Max_Process_Pressure_Unit__c,Max_Process_Pressure__c,Media_Name__c,Media_Type__c,Media__c,Method21_Leak_Detection_Backend__c,Method21_Leak_Detection__c,Model_name__c,Model_Size__c,Molecular_Weight__c,Nace_Backend__c,NACE__c,Non_Discountable_Price__c,OA01__c,OA02__c,OA03__c,OA04__c,OA05__c,OA06__c,OA__c,OB010__c,OB0100__c,OB0110__c,OB020__c,OB030__c,OB040__c,OB050__c,OB060__c,OB070__c,OB080__c,OB090__c,OB100__c,OB110__c,OB130__c,OB140__c,OB150__c,OB160__c,OB170__c,OB180__c,OB190__c,OB200__c,OB210__c,OB220__c,OB240__c,OB245__c,OB250__c,OB300__c,OB320__c,OB365__c,OB370__c,OB400__c,OB420__c,OB470__c,OB471__c,OB480__c,OB490__c,OB500__c,OB502__c,OB503__c,OB510__c,OB515__c,OB520__c,OB525__c,OB527__c,OB530__c,OB540__c,OB550__c,OB560__c,OB570__c,OB580__c,OB590__c,OB610__c,OB620__c,OB630__c,OB640__c,OB650__c,OB660__c,OB670__c,OB680__c,OB690__c,OB695__c,OB700__c,OB710__c,OB720__c,OB730__c,OB740__c,OB__c,Overpressure__c,OW050__c,OW060__c,OW070__c,OW071__c,OW072__c,OW110__c,OW111__c,OW130__c,OW910__c,OW920__c,OW__c,Painting_Coating_Option__c,Pallet_Fastener_Coating_Material__c,Pallet_Type__c,PARTREV__c,Part_Number_Base__c,Part_Number__c,PC020__c,PC025__c,PC040__c,PC045__c,PC050__c,PC055__c,PC080__c,PC081__c,PC__c,PED_2014_68_EU_CE_mark__c,PED_bkend__c,Pilot_Action_Flag__c,Pilot_Action__c,Pilot_Exhaust_Discharge_Header_Backend__c,Pilot_Exhaust_Piped_to_Discharge_Header__c,Pilot_Soft_Goods_Material__c,Pilot_Supply_Filter_Backend__c,Pilot_Supply_Filter__c,Pilot_Valves_option__c,Positive_Material_Identification__c,PosKDHigh__c,PosKDLow__c,PosKD__c,PosPresRatioHigh__c,PosPresRatioLow__c,PosSetPresOSIG__c,Pressure_Direction__c,Pressure_Pallet_Material__c,Pressure_Port_Proximity_Sensor_Backend__c,Pressure_Port_Proximity_Sensor__c,Pressure_Relief_Req_Flow_Rate__c,Pressure_Relief_Req_Flow_Units__c,Pressure_Relieving_Temperature_Units__c,Pressure_Relieving_Temperature__c,Pressure_Setting_Units__c,Pressure_Setting__c,Pressure_Units__c,Price_Engineer_Override__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,Radiography__c,Ratio_of_Specific_Heats__c,Relief_Type__c,Remote_Sense_Backend__c,Remote_Sense__c,Schedule_BaseLead__c,Seat_Material__c,Section_A_Flag__c,Section_B_Flag__c,Section_C_Flag__c,Section_D_Flag__c,Section_E_Flag__c,Section_F_Flag__c,Section_G_Flag__c,Section_H_Flag__c,Section_I_Flag__c,Shell_Test_Valve_Body__c,Size_Preference__c,Size__c,Smallest__c,Split_Overpressure__c,Spring_Material__c,StdPosAirFlowSCFH__c,StdPosKd__c,StdPosPresRatio__c,StdVacAirFlowSCFH__c,StdVacKd__c,StdVacPresRatio__c,SteamJacket_Display_Flag__c,Steam_Jacket_Material__c,Temperature_Units__c,Type_of_model__c,Type_of_overpressure_valve__c,Ultrasonic_Examination_Backend__c,Ultrasonic_Examination__c,VacKDHigh__c,VacKDLow__c,VacPresRatioHigh__c,VacPresRatioLow__c,VacSetPresOSIG__c,Vacuum_Media__c,Vacuum_Pallet_Material__c,Vacuum_Port_Option__c,Vacuum_Port_Proximity_Sensor_Backend__c,Vacuum_Port_Proximity_Sensor__c,Vacuum_Relief_Required_Flow_Units__c,Vacuum_Relief_Req_Flow__c,Vacuum_Relief__c,Vacuum_Setting_Units__c,Vacuum_Setting__c,Visual_Casting_Examination_Backend__c,Visual_Casting_Examination__c,V_Compressibility_Factor__c,V_Converted_Relieving_Vacuum_Value__c,V_Converted_Vacuum_Relieving_Temperature__c,V_Customer_Specified_Media_Name__c,V_Enter_Relieving_Vacuum_units__c,V_Enter_Relieving_Vacuum_Value__c,V_Gas_List__c,V_Media_Name__c,V_Media__c,V_Molecular_Weight__c,V_Overpressure_Vacuum_Value__c,V_Ratio_of_Specific_Heats__c,V_Vacuum_Relieving_Temperature_Units__c,V_Vacuum_Relieving_Temperature__c,Weight_Material__c,Working_days_CDC__c,Working_days_GCI__c,Working_days_GP__c,Zone__c
        FROM Relief_Valve__c 
        WHERE ASSYPARTNO__c = 'V146000006355VTA00003' limit 1];

        Relief_Valve__c conRV;
        if(!reliefValveList.isEmpty()){
            conRV = reliefValveList[0];
        }
        
        RVWeightDetermination WeightDetermination = new RVWeightDetermination(conRV);
        
        RV_Cavity__c cav = new RV_Cavity__c();
        cav.CavityDiameter1__c = 8.5;
        cav.CavityDiameter2__c = 7.56;
        cav.CavityHeight1__c = 3.437;
        cav.CavityHeight2__c = 0.875;
        cav.Direction__c = 'Pos';
        cav.EffSealingDiameter__c = 7.9375;
        cav.PTC__c = '1460';
        cav.SpacerYN__c = 'N';
        cav.StemDiameter__c = 0.5;
        cav.SZC__c = '06';
        insert cav;

        RV_Valve_Attributes_Details__c rvdetail = new RV_Valve_Attributes_Details__c();
        rvdetail.Attribute__c = 'ASYTYP';
        rvdetail.Text1Val__c = '1460';
        rvdetail.Text__c = 'ERV';
        insert rvdetail;

        

        TestDataRVUtility.createRVMapData();
        
        map<string,string> WeightMethod = WeightDetermination.getInitialWeightDetermination(conRV, TestDataRVUtility.mapWithRVValues4);
        WeightDetermination.cleanRVrecord(conRV);
        Test.stopTest();
    }

    @istest
    public static void RVProductNarrowingMethods2(){
        Test.startTest();
        List<Relief_Valve__c> reliefValveList = new List<Relief_Valve__c>();

        reliefValveList = [SELECT Id,ASSYPARTNO__c,Atex_bkend__c,Atex_Certificate__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Back_Pressure_Units__c,Back_Pressure__c,Body_Coating_Material__c,Body_Design__c,Body_Material__c,Brand__c,Brinell_hardness_examination_Backend__c,Brinell_hardness_examination__c,Build_Cost_Override__c,Bypass__c,Charpy_Impact_Testing_Backend__c,Charpy_Impact_Testing__c,Compressibility_Factor__c,Constraint_Product_Selection_By_Flow__c,Converted_Atmospheric_Pressure__c,Converted_Back_Pressure__c,Converted_Max_Process_Pressure__c,Converted_Pressure_Relief_Req_Flow__c,Converted_Pressure_Relieving_Temperature__c,Converted_Pressure_Setting__c,Converted_Relieving_Pressure_Value__c,Converted_Vacuum_Relief_Req_Flow__c,Converted_Vacuum_Setting__c,Customer_Specified_Media_Name__c,CUTR_bkend__c,CU_TR__c,Diaphragm_Material__c,Discountable_Price__c,Document_IDs__c,Drilling__c,Dummy_Atex__c,Dummy_CUTR__c,Dummy_Flowing_Pressure_Units__c,Dummy_Flowing_Pressure__c,Dummy_PED__c,Dummy_Vacuum_Flowing_Pressure_Units__c,Dummy_Vacuum_Flowing_Pressure__c,EffMBP__c,EFFMop__c,Element_Material_Flag__c,Element_Material__c,Engineering_Notes__c,Engineering_Specials__c,Enter_Relieving_Pressure_Units__c,Enter_Relieving_Pressure_Value__c,Facing__c,Fastener_Material__c,Field_Test_Connection_Backend__c,Field_Test_Connection__c,Fillet_Weld_Liquid_Dye_Penetrant_Backend__c,Fillet_Weld_Liquid_Dye_Penetrant__c,Final_Assembly_Location_Requirements__c,Finish_Configuration_Flag__c,Flame_Arrester_Flag__c,Flame_Arrester_Option__c,Flow_Rate_Units__c,Gas_Group__c,Gas_List__c,Hydrotest__c,Intergranular_Corossion_Test_Backend__c,Intergranular_Corossion_Test__c,Is_flame_arrester_needed_with_your_valve__c,Lead_Time_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,Lead_Time_Site_30__c,Lead_Time_Site_40__c,Liquid_Dye_Penetrant__c,List_Price_Each__c,Magnetic_Particle_Examination_Backend__c,Magnetic_Particle_Examination__c,Manual_Blowdown_Backend__c,Manual_Blowdown__c,Material_Sourcing_Requirements__c,Max_Process_Pressure_Unit__c,Max_Process_Pressure__c,Media_Name__c,Media_Type__c,Media__c,Method21_Leak_Detection_Backend__c,Method21_Leak_Detection__c,Model_name__c,Model_Size__c,Molecular_Weight__c,Nace_Backend__c,NACE__c,Non_Discountable_Price__c,OA01__c,OA02__c,OA03__c,OA04__c,OA05__c,OA06__c,OA__c,OB010__c,OB0100__c,OB0110__c,OB020__c,OB030__c,OB040__c,OB050__c,OB060__c,OB070__c,OB080__c,OB090__c,OB100__c,OB110__c,OB130__c,OB140__c,OB150__c,OB160__c,OB170__c,OB180__c,OB190__c,OB200__c,OB210__c,OB220__c,OB240__c,OB245__c,OB250__c,OB300__c,OB320__c,OB365__c,OB370__c,OB400__c,OB420__c,OB470__c,OB471__c,OB480__c,OB490__c,OB500__c,OB502__c,OB503__c,OB510__c,OB515__c,OB520__c,OB525__c,OB527__c,OB530__c,OB540__c,OB550__c,OB560__c,OB570__c,OB580__c,OB590__c,OB610__c,OB620__c,OB630__c,OB640__c,OB650__c,OB660__c,OB670__c,OB680__c,OB690__c,OB695__c,OB700__c,OB710__c,OB720__c,OB730__c,OB740__c,OB__c,Overpressure__c,OW050__c,OW060__c,OW070__c,OW071__c,OW072__c,OW110__c,OW111__c,OW130__c,OW910__c,OW920__c,OW__c,Painting_Coating_Option__c,Pallet_Fastener_Coating_Material__c,Pallet_Type__c,PARTREV__c,Part_Number_Base__c,Part_Number__c,PC020__c,PC025__c,PC040__c,PC045__c,PC050__c,PC055__c,PC080__c,PC081__c,PC__c,PED_2014_68_EU_CE_mark__c,PED_bkend__c,Pilot_Action_Flag__c,Pilot_Action__c,Pilot_Exhaust_Discharge_Header_Backend__c,Pilot_Exhaust_Piped_to_Discharge_Header__c,Pilot_Soft_Goods_Material__c,Pilot_Supply_Filter_Backend__c,Pilot_Supply_Filter__c,Pilot_Valves_option__c,Positive_Material_Identification__c,PosKDHigh__c,PosKDLow__c,PosKD__c,PosPresRatioHigh__c,PosPresRatioLow__c,PosSetPresOSIG__c,Pressure_Direction__c,Pressure_Pallet_Material__c,Pressure_Port_Proximity_Sensor_Backend__c,Pressure_Port_Proximity_Sensor__c,Pressure_Relief_Req_Flow_Rate__c,Pressure_Relief_Req_Flow_Units__c,Pressure_Relieving_Temperature_Units__c,Pressure_Relieving_Temperature__c,Pressure_Setting_Units__c,Pressure_Setting__c,Pressure_Units__c,Price_Engineer_Override__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,Radiography__c,Ratio_of_Specific_Heats__c,Relief_Type__c,Remote_Sense_Backend__c,Remote_Sense__c,Schedule_BaseLead__c,Seat_Material__c,Section_A_Flag__c,Section_B_Flag__c,Section_C_Flag__c,Section_D_Flag__c,Section_E_Flag__c,Section_F_Flag__c,Section_G_Flag__c,Section_H_Flag__c,Section_I_Flag__c,Shell_Test_Valve_Body__c,Size_Preference__c,Size__c,Smallest__c,Split_Overpressure__c,Spring_Material__c,StdPosAirFlowSCFH__c,StdPosKd__c,StdPosPresRatio__c,StdVacAirFlowSCFH__c,StdVacKd__c,StdVacPresRatio__c,SteamJacket_Display_Flag__c,Steam_Jacket_Material__c,Temperature_Units__c,Type_of_model__c,Type_of_overpressure_valve__c,Ultrasonic_Examination_Backend__c,Ultrasonic_Examination__c,VacKDHigh__c,VacKDLow__c,VacPresRatioHigh__c,VacPresRatioLow__c,VacSetPresOSIG__c,Vacuum_Media__c,Vacuum_Pallet_Material__c,Vacuum_Port_Option__c,Vacuum_Port_Proximity_Sensor_Backend__c,Vacuum_Port_Proximity_Sensor__c,Vacuum_Relief_Required_Flow_Units__c,Vacuum_Relief_Req_Flow__c,Vacuum_Relief__c,Vacuum_Setting_Units__c,Vacuum_Setting__c,Visual_Casting_Examination_Backend__c,Visual_Casting_Examination__c,V_Compressibility_Factor__c,V_Converted_Relieving_Vacuum_Value__c,V_Converted_Vacuum_Relieving_Temperature__c,V_Customer_Specified_Media_Name__c,V_Enter_Relieving_Vacuum_units__c,V_Enter_Relieving_Vacuum_Value__c,V_Gas_List__c,V_Media_Name__c,V_Media__c,V_Molecular_Weight__c,V_Overpressure_Vacuum_Value__c,V_Ratio_of_Specific_Heats__c,V_Vacuum_Relieving_Temperature_Units__c,V_Vacuum_Relieving_Temperature__c,Weight_Material__c,Working_days_CDC__c,Working_days_GCI__c,Working_days_GP__c,Zone__c
        FROM Relief_Valve__c 
        WHERE ASSYPARTNO__c = 'V1220A0006355BTA00001' limit 1];

        Relief_Valve__c conRV;
        if(!reliefValveList.isEmpty()){
            conRV = reliefValveList[0];
        }

        RV_PosSettingLimits__c posTestRecord = new RV_PosSettingLimits__c(BackpressureLL__c=-14.696,BackpressureUL__c=12,PalletDesign__c='Spun',PalletMatlCode__c='5',
        PalletType__c='N',PosProxSensorAvailable__c='N',PTC__c='1220A',SettingLL__c=0.6,SettingUL__c=5,
        SpacerYN__c='N',SZC__c='06',WeightMatlCode__c='S');
        insert posTestRecord;

        
        RV_Cavity__c cav = new RV_Cavity__c();
        cav.CavityDiameter1__c = 8.5;
        cav.CavityDiameter2__c = 7.56;
        cav.CavityHeight1__c = 3.437;
        cav.CavityHeight2__c = 0.875;
        cav.Direction__c = 'Pos';
        cav.EffSealingDiameter__c = 7.9375;
        cav.PTC__c = '1220A';
        cav.SpacerYN__c = 'N';
        cav.StemDiameter__c = 0.5;
        cav.SZC__c = '06';
        insert cav;
        
        RV_Valve_Attributes_Details__c rvdetail = new RV_Valve_Attributes_Details__c();
        rvdetail.Attribute__c = 'ASYTYP';
        rvdetail.Text1Val__c = '1220A';
        rvdetail.Text__c = 'PVRV';
        insert rvdetail;

        RV_Valve_Structure_Details__c rvstructure = new RV_Valve_Structure_Details__c();
        rvstructure.Component_Part__c = 'MGPAL000600500LPL2300000';
        rvstructure.ItemNo__c = '270';
        rvstructure.Structure_Element__c = 'PosPallet';
        rvstructure.Text1Val__c = '1220A'; // mapRVAttr.get('ValveSubModel')
        rvstructure.Text2Val__c = '06'; // rvRec.Size__c
        rvstructure.Text3Val__c = '-'; //rvRec.Body_Material__c
        rvstructure.Text4Val__c = '5'; //rvRec.Pressure_Pallet_Material__c
        rvstructure.Text5Val__c = 'Spun'; //rvPosSettings[0].PalletDesign__c
        rvstructure.Text6Val__c = 'N';
        rvstructure.Text7Val__c = 'N'; // rvRec.Nace_Backend__c
        rvstructure.Text8Val__c = '0';
        rvstructure.Text9Val__c = 'N';
        rvstructure.Text12Val__c = 'N';
        rvstructure.Text14Val__c = 'N';
        rvstructure.Text16Val__c = 'N';
        rvstructure.Text17Val__c = 'N';
        insert rvstructure;

        RV_PartWgtThickness__c thick = new RV_PartWgtThickness__c();
        thick.ModulePN__c = 'MGPAL000600500LPL2300000';
        thick.Thickness__c = 0.048;
        thick.Weight__c = 1.783;

        RVWeightDetermination WeightDetermination = new RVWeightDetermination(conRV);
        TestDataRVUtility.createRVMapData5();
        
        map<string,string> WeightMethod = WeightDetermination.getInitialWeightDetermination(conRV, TestDataRVUtility.mapWithRVValues5);
        WeightDetermination.cleanRVrecord(conRV);
        Test.stopTest();
    }

    @istest
    public static void RVProductNarrowingMethods3(){
        Test.startTest();
        List<Relief_Valve__c> reliefValveList = new List<Relief_Valve__c>();

        reliefValveList = [SELECT Id,ASSYPARTNO__c,Atex_bkend__c,Atex_Certificate__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Back_Pressure_Units__c,Back_Pressure__c,Body_Coating_Material__c,Body_Design__c,Body_Material__c,Brand__c,Brinell_hardness_examination_Backend__c,Brinell_hardness_examination__c,Build_Cost_Override__c,Bypass__c,Charpy_Impact_Testing_Backend__c,Charpy_Impact_Testing__c,Compressibility_Factor__c,Constraint_Product_Selection_By_Flow__c,Converted_Atmospheric_Pressure__c,Converted_Back_Pressure__c,Converted_Max_Process_Pressure__c,Converted_Pressure_Relief_Req_Flow__c,Converted_Pressure_Relieving_Temperature__c,Converted_Pressure_Setting__c,Converted_Relieving_Pressure_Value__c,Converted_Vacuum_Relief_Req_Flow__c,Converted_Vacuum_Setting__c,Customer_Specified_Media_Name__c,CUTR_bkend__c,CU_TR__c,Diaphragm_Material__c,Discountable_Price__c,Document_IDs__c,Drilling__c,Dummy_Atex__c,Dummy_CUTR__c,Dummy_Flowing_Pressure_Units__c,Dummy_Flowing_Pressure__c,Dummy_PED__c,Dummy_Vacuum_Flowing_Pressure_Units__c,Dummy_Vacuum_Flowing_Pressure__c,EffMBP__c,EFFMop__c,Element_Material_Flag__c,Element_Material__c,Engineering_Notes__c,Engineering_Specials__c,Enter_Relieving_Pressure_Units__c,Enter_Relieving_Pressure_Value__c,Facing__c,Fastener_Material__c,Field_Test_Connection_Backend__c,Field_Test_Connection__c,Fillet_Weld_Liquid_Dye_Penetrant_Backend__c,Fillet_Weld_Liquid_Dye_Penetrant__c,Final_Assembly_Location_Requirements__c,Finish_Configuration_Flag__c,Flame_Arrester_Flag__c,Flame_Arrester_Option__c,Flow_Rate_Units__c,Gas_Group__c,Gas_List__c,Hydrotest__c,Intergranular_Corossion_Test_Backend__c,Intergranular_Corossion_Test__c,Is_flame_arrester_needed_with_your_valve__c,Lead_Time_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,Lead_Time_Site_30__c,Lead_Time_Site_40__c,Liquid_Dye_Penetrant__c,List_Price_Each__c,Magnetic_Particle_Examination_Backend__c,Magnetic_Particle_Examination__c,Manual_Blowdown_Backend__c,Manual_Blowdown__c,Material_Sourcing_Requirements__c,Max_Process_Pressure_Unit__c,Max_Process_Pressure__c,Media_Name__c,Media_Type__c,Media__c,Method21_Leak_Detection_Backend__c,Method21_Leak_Detection__c,Model_name__c,Model_Size__c,Molecular_Weight__c,Nace_Backend__c,NACE__c,Non_Discountable_Price__c,OA01__c,OA02__c,OA03__c,OA04__c,OA05__c,OA06__c,OA__c,OB010__c,OB0100__c,OB0110__c,OB020__c,OB030__c,OB040__c,OB050__c,OB060__c,OB070__c,OB080__c,OB090__c,OB100__c,OB110__c,OB130__c,OB140__c,OB150__c,OB160__c,OB170__c,OB180__c,OB190__c,OB200__c,OB210__c,OB220__c,OB240__c,OB245__c,OB250__c,OB300__c,OB320__c,OB365__c,OB370__c,OB400__c,OB420__c,OB470__c,OB471__c,OB480__c,OB490__c,OB500__c,OB502__c,OB503__c,OB510__c,OB515__c,OB520__c,OB525__c,OB527__c,OB530__c,OB540__c,OB550__c,OB560__c,OB570__c,OB580__c,OB590__c,OB610__c,OB620__c,OB630__c,OB640__c,OB650__c,OB660__c,OB670__c,OB680__c,OB690__c,OB695__c,OB700__c,OB710__c,OB720__c,OB730__c,OB740__c,OB__c,Overpressure__c,OW050__c,OW060__c,OW070__c,OW071__c,OW072__c,OW110__c,OW111__c,OW130__c,OW910__c,OW920__c,OW__c,Painting_Coating_Option__c,Pallet_Fastener_Coating_Material__c,Pallet_Type__c,PARTREV__c,Part_Number_Base__c,Part_Number__c,PC020__c,PC025__c,PC040__c,PC045__c,PC050__c,PC055__c,PC080__c,PC081__c,PC__c,PED_2014_68_EU_CE_mark__c,PED_bkend__c,Pilot_Action_Flag__c,Pilot_Action__c,Pilot_Exhaust_Discharge_Header_Backend__c,Pilot_Exhaust_Piped_to_Discharge_Header__c,Pilot_Soft_Goods_Material__c,Pilot_Supply_Filter_Backend__c,Pilot_Supply_Filter__c,Pilot_Valves_option__c,Positive_Material_Identification__c,PosKDHigh__c,PosKDLow__c,PosKD__c,PosPresRatioHigh__c,PosPresRatioLow__c,PosSetPresOSIG__c,Pressure_Direction__c,Pressure_Pallet_Material__c,Pressure_Port_Proximity_Sensor_Backend__c,Pressure_Port_Proximity_Sensor__c,Pressure_Relief_Req_Flow_Rate__c,Pressure_Relief_Req_Flow_Units__c,Pressure_Relieving_Temperature_Units__c,Pressure_Relieving_Temperature__c,Pressure_Setting_Units__c,Pressure_Setting__c,Pressure_Units__c,Price_Engineer_Override__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,Radiography__c,Ratio_of_Specific_Heats__c,Relief_Type__c,Remote_Sense_Backend__c,Remote_Sense__c,Schedule_BaseLead__c,Seat_Material__c,Section_A_Flag__c,Section_B_Flag__c,Section_C_Flag__c,Section_D_Flag__c,Section_E_Flag__c,Section_F_Flag__c,Section_G_Flag__c,Section_H_Flag__c,Section_I_Flag__c,Shell_Test_Valve_Body__c,Size_Preference__c,Size__c,Smallest__c,Split_Overpressure__c,Spring_Material__c,StdPosAirFlowSCFH__c,StdPosKd__c,StdPosPresRatio__c,StdVacAirFlowSCFH__c,StdVacKd__c,StdVacPresRatio__c,SteamJacket_Display_Flag__c,Steam_Jacket_Material__c,Temperature_Units__c,Type_of_model__c,Type_of_overpressure_valve__c,Ultrasonic_Examination_Backend__c,Ultrasonic_Examination__c,VacKDHigh__c,VacKDLow__c,VacPresRatioHigh__c,VacPresRatioLow__c,VacSetPresOSIG__c,Vacuum_Media__c,Vacuum_Pallet_Material__c,Vacuum_Port_Option__c,Vacuum_Port_Proximity_Sensor_Backend__c,Vacuum_Port_Proximity_Sensor__c,Vacuum_Relief_Required_Flow_Units__c,Vacuum_Relief_Req_Flow__c,Vacuum_Relief__c,Vacuum_Setting_Units__c,Vacuum_Setting__c,Visual_Casting_Examination_Backend__c,Visual_Casting_Examination__c,V_Compressibility_Factor__c,V_Converted_Relieving_Vacuum_Value__c,V_Converted_Vacuum_Relieving_Temperature__c,V_Customer_Specified_Media_Name__c,V_Enter_Relieving_Vacuum_units__c,V_Enter_Relieving_Vacuum_Value__c,V_Gas_List__c,V_Media_Name__c,V_Media__c,V_Molecular_Weight__c,V_Overpressure_Vacuum_Value__c,V_Ratio_of_Specific_Heats__c,V_Vacuum_Relieving_Temperature_Units__c,V_Vacuum_Relieving_Temperature__c,Weight_Material__c,Working_days_CDC__c,Working_days_GCI__c,Working_days_GP__c,Zone__c
        FROM Relief_Valve__c 
        WHERE ASSYPARTNO__c = 'V2000A0020355T0A00037' limit 1];

        Relief_Valve__c conRV;
        if(!reliefValveList.isEmpty()){
            conRV = reliefValveList[0];
        }

        RV_PosSettingLimits__c posTestRecord = new RV_PosSettingLimits__c();
        posTestRecord.BackpressureLL__c = -14.696;
        posTestRecord.BackpressureUL__c = 100;
        posTestRecord.PalletDesign__c = 'Free Lift High';
        posTestRecord.PalletMatlCode__c = '5';
        posTestRecord.PalletType__c = 'N';
        posTestRecord.PosProxSensorAvailable__c = 'N';
        posTestRecord.PTC__c = '2000A';
        posTestRecord.SettingLL__c = 1.7;
        posTestRecord.SettingUL__c = 16;
        posTestRecord.SpacerYN__c = 'N';
        posTestRecord.SZC__c = '20';
        posTestRecord.WeightMatlCode__c = 'S';
        insert posTestRecord;
        
        RV_Cavity__c cav = new RV_Cavity__c();
        cav.CavityDiameter1__c = 24;
        cav.CavityDiameter2__c = 0;
        cav.CavityHeight1__c = 99;
        cav.CavityHeight2__c = 0;
        cav.Direction__c = 'Pos';
        cav.EffSealingDiameter__c = 19.75;
        cav.PTC__c = '2000A';
        cav.SpacerYN__c = 'N';
        cav.StemDiameter__c = 0.75;
        cav.SZC__c = '20';
        insert cav;
        
        RV_Valve_Attributes_Details__c rvdetail = new RV_Valve_Attributes_Details__c();
        rvdetail.Attribute__c = 'ASYTYP';
        rvdetail.NumVal1__c = 0;
        rvdetail.NumVal2__c = 0;
        rvdetail.NumVal3__c = 0;
        rvdetail.NumVal4__c = 0;
        rvdetail.Text1Val__c = '2000A';
        rvdetail.Text__c = 'ERV';
        insert rvdetail;

        RV_Valve_Structure_Details__c rvstructure = new RV_Valve_Structure_Details__c();
        rvstructure.Component_Part__c = 'MGPAL3A2000500H0N0600000';
        rvstructure.ItemNo__c = '270';
        rvstructure.Structure_Element__c = 'PosPallet';
        rvstructure.Text1Val__c = '2000A'; // mapRVAttr.get('ValveSubModel')
        rvstructure.Text2Val__c = '20'; // rvRec.Size__c
        rvstructure.Text3Val__c = '3'; //rvRec.Body_Material__c
        rvstructure.Text4Val__c = '5'; //rvRec.Pressure_Pallet_Material__c
        rvstructure.Text6Val__c = '-';
        rvstructure.Text5Val__c = 'Free Lift High'; //rvPosSettings[0].PalletDesign__c
        rvstructure.Text7Val__c = 'N'; // rvRec.Nace_Backend__c
        rvstructure.Text8Val__c = '0';
        rvstructure.Text9Val__c = 'N';
        rvstructure.Text12Val__c = 'N';
        rvstructure.Text14Val__c = 'N';
        rvstructure.Text16Val__c = 'N';
        rvstructure.Text17Val__c = 'N';
        insert rvstructure;

        RV_PartWgtThickness__c thick = new RV_PartWgtThickness__c();
        thick.ModulePN__c = 'MGPAL3A2000500H0N0600000';
        thick.Thickness__c = 0.135;
        thick.Weight__c = 36.71054273;

        RVWeightDetermination WeightDetermination = new RVWeightDetermination(conRV);
        TestDataRVUtility.createRVMapData6();
        map<string,string> WeightMethod = WeightDetermination.getInitialWeightDetermination(conRV, TestDataRVUtility.mapWithRVValues6);
        WeightDetermination.cleanRVrecord(conRV);
        Test.stopTest();
    }

    @istest
    public static void RVProductNarrowingMethods4(){
        Test.startTest();
        List<Relief_Valve__c> reliefValveList = new List<Relief_Valve__c>();

        reliefValveList = [SELECT Id,ASSYPARTNO__c,Atex_bkend__c,Atex_Certificate__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Back_Pressure_Units__c,Back_Pressure__c,Body_Coating_Material__c,Body_Design__c,Body_Material__c,Brand__c,Brinell_hardness_examination_Backend__c,Brinell_hardness_examination__c,Build_Cost_Override__c,Bypass__c,Charpy_Impact_Testing_Backend__c,Charpy_Impact_Testing__c,Compressibility_Factor__c,Constraint_Product_Selection_By_Flow__c,Converted_Atmospheric_Pressure__c,Converted_Back_Pressure__c,Converted_Max_Process_Pressure__c,Converted_Pressure_Relief_Req_Flow__c,Converted_Pressure_Relieving_Temperature__c,Converted_Pressure_Setting__c,Converted_Relieving_Pressure_Value__c,Converted_Vacuum_Relief_Req_Flow__c,Converted_Vacuum_Setting__c,Customer_Specified_Media_Name__c,CUTR_bkend__c,CU_TR__c,Diaphragm_Material__c,Discountable_Price__c,Document_IDs__c,Drilling__c,Dummy_Atex__c,Dummy_CUTR__c,Dummy_Flowing_Pressure_Units__c,Dummy_Flowing_Pressure__c,Dummy_PED__c,Dummy_Vacuum_Flowing_Pressure_Units__c,Dummy_Vacuum_Flowing_Pressure__c,EffMBP__c,EFFMop__c,Element_Material_Flag__c,Element_Material__c,Engineering_Notes__c,Engineering_Specials__c,Enter_Relieving_Pressure_Units__c,Enter_Relieving_Pressure_Value__c,Facing__c,Fastener_Material__c,Field_Test_Connection_Backend__c,Field_Test_Connection__c,Fillet_Weld_Liquid_Dye_Penetrant_Backend__c,Fillet_Weld_Liquid_Dye_Penetrant__c,Final_Assembly_Location_Requirements__c,Finish_Configuration_Flag__c,Flame_Arrester_Flag__c,Flame_Arrester_Option__c,Flow_Rate_Units__c,Gas_Group__c,Gas_List__c,Hydrotest__c,Intergranular_Corossion_Test_Backend__c,Intergranular_Corossion_Test__c,Is_flame_arrester_needed_with_your_valve__c,Lead_Time_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,Lead_Time_Site_30__c,Lead_Time_Site_40__c,Liquid_Dye_Penetrant__c,List_Price_Each__c,Magnetic_Particle_Examination_Backend__c,Magnetic_Particle_Examination__c,Manual_Blowdown_Backend__c,Manual_Blowdown__c,Material_Sourcing_Requirements__c,Max_Process_Pressure_Unit__c,Max_Process_Pressure__c,Media_Name__c,Media_Type__c,Media__c,Method21_Leak_Detection_Backend__c,Method21_Leak_Detection__c,Model_name__c,Model_Size__c,Molecular_Weight__c,Nace_Backend__c,NACE__c,Non_Discountable_Price__c,OA01__c,OA02__c,OA03__c,OA04__c,OA05__c,OA06__c,OA__c,OB010__c,OB0100__c,OB0110__c,OB020__c,OB030__c,OB040__c,OB050__c,OB060__c,OB070__c,OB080__c,OB090__c,OB100__c,OB110__c,OB130__c,OB140__c,OB150__c,OB160__c,OB170__c,OB180__c,OB190__c,OB200__c,OB210__c,OB220__c,OB240__c,OB245__c,OB250__c,OB300__c,OB320__c,OB365__c,OB370__c,OB400__c,OB420__c,OB470__c,OB471__c,OB480__c,OB490__c,OB500__c,OB502__c,OB503__c,OB510__c,OB515__c,OB520__c,OB525__c,OB527__c,OB530__c,OB540__c,OB550__c,OB560__c,OB570__c,OB580__c,OB590__c,OB610__c,OB620__c,OB630__c,OB640__c,OB650__c,OB660__c,OB670__c,OB680__c,OB690__c,OB695__c,OB700__c,OB710__c,OB720__c,OB730__c,OB740__c,OB__c,Overpressure__c,OW050__c,OW060__c,OW070__c,OW071__c,OW072__c,OW110__c,OW111__c,OW130__c,OW910__c,OW920__c,OW__c,Painting_Coating_Option__c,Pallet_Fastener_Coating_Material__c,Pallet_Type__c,PARTREV__c,Part_Number_Base__c,Part_Number__c,PC020__c,PC025__c,PC040__c,PC045__c,PC050__c,PC055__c,PC080__c,PC081__c,PC__c,PED_2014_68_EU_CE_mark__c,PED_bkend__c,Pilot_Action_Flag__c,Pilot_Action__c,Pilot_Exhaust_Discharge_Header_Backend__c,Pilot_Exhaust_Piped_to_Discharge_Header__c,Pilot_Soft_Goods_Material__c,Pilot_Supply_Filter_Backend__c,Pilot_Supply_Filter__c,Pilot_Valves_option__c,Positive_Material_Identification__c,PosKDHigh__c,PosKDLow__c,PosKD__c,PosPresRatioHigh__c,PosPresRatioLow__c,PosSetPresOSIG__c,Pressure_Direction__c,Pressure_Pallet_Material__c,Pressure_Port_Proximity_Sensor_Backend__c,Pressure_Port_Proximity_Sensor__c,Pressure_Relief_Req_Flow_Rate__c,Pressure_Relief_Req_Flow_Units__c,Pressure_Relieving_Temperature_Units__c,Pressure_Relieving_Temperature__c,Pressure_Setting_Units__c,Pressure_Setting__c,Pressure_Units__c,Price_Engineer_Override__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,Radiography__c,Ratio_of_Specific_Heats__c,Relief_Type__c,Remote_Sense_Backend__c,Remote_Sense__c,Schedule_BaseLead__c,Seat_Material__c,Section_A_Flag__c,Section_B_Flag__c,Section_C_Flag__c,Section_D_Flag__c,Section_E_Flag__c,Section_F_Flag__c,Section_G_Flag__c,Section_H_Flag__c,Section_I_Flag__c,Shell_Test_Valve_Body__c,Size_Preference__c,Size__c,Smallest__c,Split_Overpressure__c,Spring_Material__c,StdPosAirFlowSCFH__c,StdPosKd__c,StdPosPresRatio__c,StdVacAirFlowSCFH__c,StdVacKd__c,StdVacPresRatio__c,SteamJacket_Display_Flag__c,Steam_Jacket_Material__c,Temperature_Units__c,Type_of_model__c,Type_of_overpressure_valve__c,Ultrasonic_Examination_Backend__c,Ultrasonic_Examination__c,VacKDHigh__c,VacKDLow__c,VacPresRatioHigh__c,VacPresRatioLow__c,VacSetPresOSIG__c,Vacuum_Media__c,Vacuum_Pallet_Material__c,Vacuum_Port_Option__c,Vacuum_Port_Proximity_Sensor_Backend__c,Vacuum_Port_Proximity_Sensor__c,Vacuum_Relief_Required_Flow_Units__c,Vacuum_Relief_Req_Flow__c,Vacuum_Relief__c,Vacuum_Setting_Units__c,Vacuum_Setting__c,Visual_Casting_Examination_Backend__c,Visual_Casting_Examination__c,V_Compressibility_Factor__c,V_Converted_Relieving_Vacuum_Value__c,V_Converted_Vacuum_Relieving_Temperature__c,V_Customer_Specified_Media_Name__c,V_Enter_Relieving_Vacuum_units__c,V_Enter_Relieving_Vacuum_Value__c,V_Gas_List__c,V_Media_Name__c,V_Media__c,V_Molecular_Weight__c,V_Overpressure_Vacuum_Value__c,V_Ratio_of_Specific_Heats__c,V_Vacuum_Relieving_Temperature_Units__c,V_Vacuum_Relieving_Temperature__c,Weight_Material__c,Working_days_CDC__c,Working_days_GCI__c,Working_days_GP__c,Zone__c
        FROM Relief_Valve__c 
        WHERE ASSYPARTNO__c = 'V1220AFG06999T0A00001' limit 1];

        Relief_Valve__c conRV;
        if(!reliefValveList.isEmpty()){
            conRV = reliefValveList[0];
            system.debug('what up');
        }

        RV_PosSettingLimits__c posTestRecord = new RV_PosSettingLimits__c();
        posTestRecord.BackpressureLL__c = -5;
        posTestRecord.BackpressureUL__c = 5;
        posTestRecord.PalletDesign__c = 'FBGHastLow';
        posTestRecord.PalletMatlCode__c = '9';
        posTestRecord.PalletType__c = 'N';
        posTestRecord.PosProxSensorAvailable__c = 'N';
        posTestRecord.PTC__c = '1220A Fiberglass';
        posTestRecord.SettingLL__c = 1;
        posTestRecord.SettingUL__c = 4;
        posTestRecord.SpacerYN__c = 'N';
        posTestRecord.SZC__c = '06';
        posTestRecord.WeightMatlCode__c = 'RL';
        insert posTestRecord;
        
        RV_Cavity__c cav = new RV_Cavity__c();
        cav.CavityDiameter1__c = 0;
        cav.CavityDiameter2__c = 0;
        cav.CavityHeight1__c = 4.102;
        cav.CavityHeight2__c = 0;
        cav.Direction__c = 'Pos';
        cav.EffSealingDiameter__c = 6.095;
        cav.PTC__c = '1220A Fiberglass';
        cav.SpacerYN__c = 'N';
        cav.StemDiameter__c = 0;
        cav.SZC__c = '06';
        insert cav;
        
        RV_Valve_Attributes_Details__c rvdetail = new RV_Valve_Attributes_Details__c();
        rvdetail.Attribute__c = 'ASYTYP';
        rvdetail.NumVal1__c = 0;
        rvdetail.NumVal2__c = 0;
        rvdetail.NumVal3__c = 0;
        rvdetail.NumVal4__c = 0;
        rvdetail.Text1Val__c = '1220A Fiberglass';
        rvdetail.Text__c = 'PVRV';
        insert rvdetail;

        RV_Valve_Structure_Details__c rvstructure = new RV_Valve_Structure_Details__c();
        rvstructure.Component_Part__c = 'MGPAL00060T700LPL0900000';
        rvstructure.ItemNo__c = '270';
        rvstructure.Structure_Element__c = 'PosPallet';
        rvstructure.Text1Val__c = '1220A Fiberglass'; // mapRVAttr.get('ValveSubModel')
        rvstructure.Text2Val__c = '06'; // rvRec.Size__c
        rvstructure.Text3Val__c = '9'; //rvRec.Body_Material__c
        rvstructure.Text4Val__c = '6'; //rvRec.Pressure_Pallet_Material__c
        rvstructure.Text5Val__c = 'FBGHastLow'; //rvPosSettings[0].PalletDesign__c
        rvstructure.Text6Val__c = 'N';
        rvstructure.Text7Val__c = 'N'; // rvRec.Nace_Backend__c
        rvstructure.Text8Val__c = '0';
        rvstructure.Text9Val__c = 'Y';
        rvstructure.Text12Val__c = 'N';
        rvstructure.Text14Val__c = 'N';
        rvstructure.Text16Val__c = 'N';
        rvstructure.Text17Val__c = 'N';
        insert rvstructure;

        RV_PartWgtThickness__c thick = new RV_PartWgtThickness__c();
        thick.ModulePN__c = 'MGPAL00060T700LPL0900000';
        thick.Thickness__c = 0.0;
        thick.Weight__c = 0.864;

        RVWeightDetermination WeightDetermination = new RVWeightDetermination(conRV);
        TestDataRVUtility.createRVMapData7();
        map<string,string> WeightMethod = WeightDetermination.getInitialWeightDetermination(conRV, TestDataRVUtility.mapWithRVValues7);
        WeightDetermination.cleanRVrecord(conRV);
        Test.stopTest();
    }

    @istest
    public static void RVProductNarrowingMethods5(){
        Test.startTest();
        List<Relief_Valve__c> reliefValveList = new List<Relief_Valve__c>();

        reliefValveList = [SELECT ASSYPARTNO__c, Atex_Certificate__c, Atex_bkend__c, Atmospheric_Pressure_Units__c, Atmospheric_Pressure__c, Back_Pressure_Units__c, Back_Pressure__c, Body_Coating_Material__c, Body_Design__c, Body_Material__c, Brand__c, Brinell_hardness_examination_Backend__c, Brinell_hardness_examination__c, Build_Cost_Override__c, Bypass__c, CUTR_bkend__c, CU_TR__c, Charpy_Impact_Testing_Backend__c, Charpy_Impact_Testing__c, Compressibility_Factor__c, Constraint_Product_Selection_By_Flow__c, Converted_Atmospheric_Pressure__c, Converted_Back_Pressure__c, Converted_Max_Process_Pressure__c, Converted_Pressure_Relief_Req_Flow__c, Converted_Pressure_Relieving_Temperature__c, Converted_Pressure_Setting__c, Converted_Relieving_Pressure_Value__c, Converted_Vacuum_Relief_Req_Flow__c, Converted_Vacuum_Setting__c, CreatedById, CreatedDate, CurrencyIsoCode, Customer_Specified_Media_Name__c, Diaphragm_Material__c, Discountable_Price__c, Document_IDs__c, Drilling__c, Dummy_Atex__c, Dummy_CUTR__c, Dummy_Flowing_Pressure_Units__c, Dummy_Flowing_Pressure__c, Dummy_PED__c, Dummy_Vacuum_Flowing_Pressure_Units__c, Dummy_Vacuum_Flowing_Pressure__c, EFFMop__c, EffMBP__c, Element_Material_Flag__c, Element_Material__c, Engineering_Notes__c, Engineering_Specials__c, Enter_Relieving_Pressure_Units__c, Enter_Relieving_Pressure_Value__c, Facing__c, Fastener_Material__c, Field_Test_Connection_Backend__c, Field_Test_Connection__c, Fillet_Weld_Liquid_Dye_Penetrant_Backend__c, Fillet_Weld_Liquid_Dye_Penetrant__c, Final_Assembly_Location_Requirements__c, Finish_Configuration_Flag__c, Flame_Arrester_Flag__c, Flame_Arrester_Option__c, Flow_Rate_Units__c, Gas_Group__c, Gas_List__c, Hydrotest__c, Id, Intergranular_Corossion_Test_Backend__c, Intergranular_Corossion_Test__c, IsDeleted, Is_flame_arrester_needed_with_your_valve__c, LastActivityDate, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Lead_Time_Override__c, Lead_Time_Site_10__c, Lead_Time_Site_20__c, Lead_Time_Site_30__c, Lead_Time_Site_40__c, Liquid_Dye_Penetrant__c, List_Price_Each__c, Magnetic_Particle_Examination_Backend__c, Magnetic_Particle_Examination__c, Manual_Blowdown_Backend__c, Manual_Blowdown__c, Material_Sourcing_Requirements__c, Max_Process_Pressure_Unit__c, Max_Process_Pressure__c, Media_Name__c, Media_Type__c, Media__c, Method21_Leak_Detection_Backend__c, Method21_Leak_Detection__c, Model_Size__c, Model_name__c, Molecular_Weight__c, NACE__c, Nace_Backend__c, Name, Non_Discountable_Price__c, OA01__c, OA02__c, OA03__c, OA04__c, OA05__c, OA06__c, OA__c, OB0100__c, OB010__c, OB0110__c, OB020__c, OB030__c, OB040__c, OB050__c, OB060__c, OB070__c, OB080__c, OB090__c, OB100__c, OB110__c, OB130__c, OB134__c, OB136__c, OB140__c, OB150__c, OB160__c, OB170__c, OB180__c, OB190__c, OB200__c, OB210__c, OB220__c, OB240__c, OB245__c, OB250__c, OB300__c, OB320__c, OB365__c, OB370__c, OB400__c, OB420__c, OB470__c, OB471__c, OB480__c, OB490__c, OB500__c, OB501__c, OB502__c, OB503__c, OB510__c, OB515__c, OB520__c, OB525__c, OB527__c, OB530__c, OB540__c, OB550__c, OB560__c, OB570__c, OB580__c, OB590__c, OB610__c, OB620__c, OB630__c, OB640__c, OB650__c, OB660__c, OB670__c, OB680__c, OB690__c, OB695__c, OB700__c, OB710__c, OB720__c, OB730__c, OB740__c, OB__c, OW050__c, OW060__c, OW070__c, OW071__c, OW072__c, OW110__c, OW111__c, OW130__c, OW910__c, OW920__c, OW__c, Overpressure__c, OwnerId, PARTREV__c, PC020__c, PC025__c, PC040__c, PC045__c, PC050__c, PC055__c, PC080__c, PC081__c, PC__c, PED_2014_68_EU_CE_mark__c, PED_bkend__c, Painting_Coating_Option__c, Pallet_Fastener_Coating_Material__c, Pallet_Type__c, Part_Number_Base__c, Part_Number__c, Pilot_Action_Flag__c, Pilot_Action__c, Pilot_Exhaust_Discharge_Header_Backend__c, Pilot_Exhaust_Piped_to_Discharge_Header__c, Pilot_Soft_Goods_Material__c, Pilot_Supply_Filter_Backend__c, Pilot_Supply_Filter__c, Pilot_Valves_option__c, PosKDHigh__c, PosKDLow__c, PosKD__c, PosPresRatioHigh__c, PosPresRatioLow__c, PosSetPresOSIG__c, Positive_Material_Identification__c, Pressure_Direction__c, Pressure_Pallet_Material__c, Pressure_Port_Proximity_Sensor_Backend__c, Pressure_Port_Proximity_Sensor__c, Pressure_Relief_Req_Flow_Rate__c, Pressure_Relief_Req_Flow_Units__c, Pressure_Relieving_Temperature_Units__c, Pressure_Relieving_Temperature__c, Pressure_Setting_Units__c, Pressure_Setting__c, Pressure_Units__c, Price_Engineer_Override__c, Prospectus_Item__c, Quantity__c, Quote_Description_Engineer_Override__c, Quote_Line__c, Radiography__c, Ratio_of_Specific_Heats__c, Relief_Type__c, Remote_Sense_Backend__c, Remote_Sense__c, Schedule_BaseLead__c, Seat_Material__c, Section_A_Flag__c, Section_B_Flag__c, Section_C_Flag__c, Section_D_Flag__c, Section_E_Flag__c, Section_F_Flag__c, Section_G_Flag__c, Section_H_Flag__c, Section_I_Flag__c, Shell_Test_Valve_Body__c, Size_Preference__c, Size__c, Smallest__c, Split_Overpressure__c, Spring_Material__c, StdPosAirFlowSCFH__c, StdPosKd__c, StdPosPresRatio__c, StdVacAirFlowSCFH__c, StdVacKd__c, StdVacPresRatio__c, Steam_Jacket_Material__c, SystemModstamp, Temperature_Units__c, Type_of_model__c, Type_of_overpressure_valve__c, Ultrasonic_Examination_Backend__c, Ultrasonic_Examination__c, V_Compressibility_Factor__c, V_Converted_Relieving_Vacuum_Value__c, V_Converted_Vacuum_Relieving_Temperature__c, V_Customer_Specified_Media_Name__c, V_Enter_Relieving_Vacuum_Value__c, V_Enter_Relieving_Vacuum_units__c, V_Gas_List__c, V_Media_Name__c, V_Media__c, V_Molecular_Weight__c, V_Overpressure_Vacuum_Value__c, V_Ratio_of_Specific_Heats__c, V_Vacuum_Relieving_Temperature_Units__c, V_Vacuum_Relieving_Temperature__c, VacKDHigh__c, VacKDLow__c, VacPresRatioHigh__c, VacPresRatioLow__c, VacSetPresOSIG__c, Vacuum_Media__c, Vacuum_Pallet_Material__c, Vacuum_Port_Option__c, Vacuum_Port_Proximity_Sensor_Backend__c, Vacuum_Port_Proximity_Sensor__c, Vacuum_Relief_Req_Flow__c, Vacuum_Relief_Required_Flow_Units__c, Vacuum_Relief__c, Vacuum_Setting_Units__c, Vacuum_Setting__c, Visual_Casting_Examination_Backend__c, Visual_Casting_Examination__c, Weight_Material__c, Working_days_CDC__c, Working_days_GCI__c, Working_days_GP__c, Zone__c
        FROM Relief_Valve__c 
        WHERE ASSYPARTNO__c = 'V1200A0006351T0A00001' limit 1];

        Relief_Valve__c conRV;
        if(!reliefValveList.isEmpty()){
            conRV = reliefValveList[0];
        }
        else {
            system.debug('no record found - sidd reb');
        }

        RV_PosSettingLimits__c posTestRecord = new RV_PosSettingLimits__c(BackpressureLL__c=-14.696,BackpressureUL__c=12,PalletDesign__c='Spun',PalletMatlCode__c='1',
        PalletType__c='N',PosProxSensorAvailable__c='N',PTC__c='1200A',SettingLL__c=0.3999,SettingUL__c=5,
        SpacerYN__c='N',SZC__c='06',WeightMatlCode__c='S');
        insert posTestRecord;

        
        RV_Cavity__c cav = new RV_Cavity__c();
        cav.CavityDiameter1__c = 8.5;
        cav.CavityDiameter2__c = 0;
        cav.CavityHeight1__c = 2.62;
        cav.CavityHeight2__c = 0;
        cav.Direction__c = 'Pos';
        cav.EffSealingDiameter__c = 7.8750;
        cav.PTC__c = '1200A';
        cav.SpacerYN__c = 'N';
        cav.StemDiameter__c = 0.5000;
        cav.SZC__c = '06';
        insert cav;
        
        RV_Valve_Attributes_Details__c rvdetail = new RV_Valve_Attributes_Details__c();
        rvdetail.Attribute__c = 'ASYTYP';
        rvdetail.Text1Val__c = '1200A';
        rvdetail.Text__c = 'PVRV';
        insert rvdetail;

        RV_Valve_Structure_Details__c rvstructure = new RV_Valve_Structure_Details__c();
        rvstructure.Component_Part__c = 'MGPAL000600100LPL2300000';
        rvstructure.ItemNo__c = '270';
        rvstructure.Structure_Element__c = 'PosPallet';
        rvstructure.Text1Val__c = '1200A'; // mapRVAttr.get('ValveSubModel')
        rvstructure.Text2Val__c = '06'; // rvRec.Size__c
        rvstructure.Text3Val__c = '-'; //rvRec.Body_Material__c
        rvstructure.Text4Val__c = '1'; //rvRec.Pressure_Pallet_Material__c
        rvstructure.Text5Val__c = 'Spun'; //rvPosSettings[0].PalletDesign__c
        rvstructure.Text6Val__c = 'N';
        rvstructure.Text7Val__c = 'N'; // rvRec.Nace_Backend__c
        rvstructure.Text8Val__c = '0';
        rvstructure.Text9Val__c = 'N';
        rvstructure.Text12Val__c = '-';
        rvstructure.Text14Val__c = '-';
        rvstructure.Text16Val__c = '-';
        rvstructure.Text17Val__c = '-';
        insert rvstructure;

        RV_PartWgtThickness__c thick = new RV_PartWgtThickness__c();
        thick.ModulePN__c = 'MGPAL000600100LPL2300000';
        thick.Thickness__c = 0.0600;
        thick.Weight__c = 1.2770;

        RVWeightDetermination WeightDetermination = new RVWeightDetermination(conRV);
        TestDataRVUtility.createRVMapData8();
        
        map<string,string> WeightMethod = WeightDetermination.getInitialWeightDetermination(conRV, TestDataRVUtility.mapWithRVValues8);
        WeightDetermination.cleanRVrecord(conRV);
        Test.stopTest();
    }

    static void loadRVWeightStackTestData(){
        List<RV_StackWeights__c> stackWeightsList = new List<RV_StackWeights__c>();
        RV_StackWeights__c sw1 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000000100000', OutDia__c=0.8, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.01);
        RV_StackWeights__c sw2 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000000500000', OutDia__c=1.56, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.05);
        RV_StackWeights__c sw3 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000000200000', OutDia__c=1.1, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.02);
        RV_StackWeights__c sw4 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000000400000', OutDia__c=1.45, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.04);
        RV_StackWeights__c sw5 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000000900000', OutDia__c=2.09, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.09);
        RV_StackWeights__c sw6 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0000AM8000000100000', OutDia__c=0.81, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.01);
        RV_StackWeights__c sw7 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0000AM8000000500000', OutDia__c=1.57, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.05);
        RV_StackWeights__c sw8 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0000AM8000000200000', OutDia__c=1.1, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.02);
        RV_StackWeights__c sw9 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0000AM8000000400000', OutDia__c=1.46, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.04);
        RV_StackWeights__c sw10 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0000AM8000000900000', OutDia__c=2.1, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.09);
        RV_StackWeights__c sw11 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000001000000', OutDia__c=2.19, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.1);
        RV_StackWeights__c sw12 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000002000000', OutDia__c=3.02, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.195);
        RV_StackWeights__c sw13 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000003700000', OutDia__c=4.075, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.365);
        RV_StackWeights__c sw14 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000007500000', OutDia__c=3.761, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=0.745);
        RV_StackWeights__c sw15 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000008200000', OutDia__c=6.08, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.815);
        RV_StackWeights__c sw16 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000014100000', OutDia__c=5.141, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=1.41);
        RV_StackWeights__c sw17 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000015100000', OutDia__c=8.25, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=1.505);
        RV_StackWeights__c sw18 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB00000AJ000022700000', OutDia__c=6.526, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=2.275);
        RV_StackWeights__c sw19 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000023500000', OutDia__c=10.285, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=2.34);
        RV_StackWeights__c sw20 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000043900000', OutDia__c=9.061, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=4.385);
        RV_StackWeights__c sw21 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000048300000', OutDia__c=14.75, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=4.825);
        RV_StackWeights__c sw22 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000064200000', OutDia__c=17, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=6.41);
        RV_StackWeights__c sw23 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000072400000', OutDia__c=11.631, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=7.24);
        RV_StackWeights__c sw24 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000106100000', OutDia__c=14.081, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=10.615);
        RV_StackWeights__c sw25 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000149600000', OutDia__c=16.711, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=14.96);
        RV_StackWeights__c sw26 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000188300000', OutDia__c=18.75, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=18.835);
        RV_StackWeights__c sw27 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000244800000', OutDia__c=21.38, Thickness__c=0.236, WeightMatlCode__c='S', Weight__c=24.495);
        RV_StackWeights__c sw28 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0200AM8000001000000', OutDia__c=2.183, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.1);
        RV_StackWeights__c sw29 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0200AM8000001900000', OutDia__c=3.011, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.195);
        RV_StackWeights__c sw30 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0200AM8000003600000', OutDia__c=4.063, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.355);
        RV_StackWeights__c sw31 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0200AM8000007300000', OutDia__c=3.749, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=0.73);
        RV_StackWeights__c sw32 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000008000000', OutDia__c=6.061, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.8);
        RV_StackWeights__c sw33 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000103500000', OutDia__c=14.036, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=10.35);
        RV_StackWeights__c sw34 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0200AM8000013700000', OutDia__c=5.125, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=1.37);
        RV_StackWeights__c sw35 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000145800000', OutDia__c=16.658, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=14.585);
        RV_StackWeights__c sw36 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000014800000', OutDia__c=8.23, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=1.475);
        RV_StackWeights__c sw37 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000183600000', OutDia__c=18.69, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=18.36);
        RV_StackWeights__c sw38 = new RV_StackWeights__c(InDia__c=0.438, ModulePN__c='WGTAB0200AM8000022200000', OutDia__c=6.506, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=2.22);
        RV_StackWeights__c sw39 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000023000000', OutDia__c=10.25, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=2.295);
        RV_StackWeights__c sw40 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000238800000', OutDia__c=21.312, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=23.88);
        RV_StackWeights__c sw41 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000047300000', OutDia__c=12.65, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=3.5);
        RV_StackWeights__c sw42 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000042800000', OutDia__c=9.033, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=4.275);
        RV_StackWeights__c sw43 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000047300000', OutDia__c=14.702, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=4.735);
        RV_StackWeights__c sw44 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000062900000', OutDia__c=16.946, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=6.29);
        RV_StackWeights__c sw45 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000070600000', OutDia__c=11.594, Thickness__c=0.236, WeightMatlCode__c='3', Weight__c=7.055);
        RV_StackWeights__c sw46 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB00000AJ000002500000', OutDia__c=3.4, Thickness__c=0.098, WeightMatlCode__c='S', Weight__c=0.25);
        RV_StackWeights__c sw47 = new RV_StackWeights__c(InDia__c=0.563, ModulePN__c='WGTAB0200AM8000002500000', OutDia__c=3.4, Thickness__c=0.098, WeightMatlCode__c='3', Weight__c=0.25);
        RV_StackWeights__c sw48 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000004200000', OutDia__c=3.75, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=0.42);
        RV_StackWeights__c sw49 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000004400000', OutDia__c=4.63, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=0.44);
        RV_StackWeights__c sw50 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000001000000', OutDia__c=3.5, Thickness__c=0.0355, WeightMatlCode__c='S', Weight__c=0.1);
        RV_StackWeights__c sw51 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000101500000', OutDia__c=12.88, Thickness__c=0.1875, WeightMatlCode__c='L', Weight__c=10.15);
        RV_StackWeights__c sw52 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000P05000023200000', OutDia__c=7.8, Thickness__c=0.18, WeightMatlCode__c='S', Weight__c=2.32);
        RV_StackWeights__c sw53 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000004800000', OutDia__c=4, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=0.48);
        RV_StackWeights__c sw54 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000000100000', OutDia__c=1.45, Thickness__c=0.0235, WeightMatlCode__c='S', Weight__c=0.01);
        RV_StackWeights__c sw55 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000P05000069700000', OutDia__c=13.4, Thickness__c=0.18, WeightMatlCode__c='S', Weight__c=6.97);
        RV_StackWeights__c sw56 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000007600000', OutDia__c=5.87, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=0.76);
        RV_StackWeights__c sw57 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000004500000', OutDia__c=7.56, Thickness__c=0.0355, WeightMatlCode__c='S', Weight__c=0.45);
        RV_StackWeights__c sw58 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000D2000020200000P', OutDia__c=23, Thickness__c=0.18, WeightMatlCode__c='3', Weight__c=20.2);
        RV_StackWeights__c sw59 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000D2000027500000P', OutDia__c=26.5, Thickness__c=0.18, WeightMatlCode__c='3', Weight__c=27.5);
        RV_StackWeights__c sw60 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000052500000', OutDia__c=9.25, Thickness__c=0.1875, WeightMatlCode__c='L', Weight__c=5.28);
        RV_StackWeights__c sw61 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000D2000014800000P', OutDia__c=19.5, Thickness__c=0.18, WeightMatlCode__c='3', Weight__c=14.8);
        RV_StackWeights__c sw62 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000085600000', OutDia__c=14.25, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=8.56);
        RV_StackWeights__c sw63 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000008400000', OutDia__c=3.25, Thickness__c=0.25, WeightMatlCode__c='L', Weight__c=0.841);
        RV_StackWeights__c sw64 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000026400000', OutDia__c=9.5, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=2.64);
        RV_StackWeights__c sw65 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000002200000', OutDia__c=3.25, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=0.22);
        RV_StackWeights__c sw66 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000P05000149600000', OutDia__c=19.5, Thickness__c=0.18, WeightMatlCode__c='S', Weight__c=14.96);
        RV_StackWeights__c sw67 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000053300000', OutDia__c=11.25, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=5.33);
        RV_StackWeights__c sw68 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000037600000', OutDia__c=10.88, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=3.76);
        RV_StackWeights__c sw69 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000002800000', OutDia__c=3.06, Thickness__c=0.135, WeightMatlCode__c='S', Weight__c=0.28);
        RV_StackWeights__c sw70 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000010000000', OutDia__c=5.75, Thickness__c=0.135, WeightMatlCode__c='S', Weight__c=1);
        RV_StackWeights__c sw71 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000006100000', OutDia__c=4.5, Thickness__c=0.135, WeightMatlCode__c='S', Weight__c=0.61);
        RV_StackWeights__c sw72 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000046400000', OutDia__c=10.5, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=4.64);
        RV_StackWeights__c sw73 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000000500000', OutDia__c=1.75, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=0.05);
        RV_StackWeights__c sw74 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000D2000002300000P', OutDia__c=7.8, Thickness__c=0.18, WeightMatlCode__c='3', Weight__c=2.3);
        RV_StackWeights__c sw75 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000003200000', OutDia__c=3.25, Thickness__c=0.135, WeightMatlCode__c='S', Weight__c=0.32);
        RV_StackWeights__c sw76 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000P05000204100000', OutDia__c=23, Thickness__c=0.18, WeightMatlCode__c='S', Weight__c=20.41);
        RV_StackWeights__c sw77 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000071200000', OutDia__c=13, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=7.12);
        RV_StackWeights__c sw78 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000030800000', OutDia__c=8.5, Thickness__c=0.125, WeightMatlCode__c='L', Weight__c=3.04);
        RV_StackWeights__c sw79 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000000700000', OutDia__c=3.06, Thickness__c=0.0355, WeightMatlCode__c='S', Weight__c=0.07);
        RV_StackWeights__c sw80 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000004100000', OutDia__c=3.25, Thickness__c=0.125, WeightMatlCode__c='L', Weight__c=0.421);
        RV_StackWeights__c sw81 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000025500000', OutDia__c=4, Thickness__c=0.5, WeightMatlCode__c='L', Weight__c=2.55);
        RV_StackWeights__c sw82 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000002000000', OutDia__c=3.06, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=0.2);
        RV_StackWeights__c sw83 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000065800000', OutDia__c=12.5, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=6.58);
        RV_StackWeights__c sw84 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000008300000', OutDia__c=4.5, Thickness__c=0.125, WeightMatlCode__c='L', Weight__c=0.84);
        RV_StackWeights__c sw85 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000D2000006900000P', OutDia__c=13.4, Thickness__c=0.18, WeightMatlCode__c='3', Weight__c=6.9);
        RV_StackWeights__c sw86 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000030500000', OutDia__c=8.63, Thickness__c=0.125, WeightMatlCode__c='L', Weight__c=3.05);
        RV_StackWeights__c sw87 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000050700000', OutDia__c=12.88, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=5.07);
        RV_StackWeights__c sw88 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000007300000', OutDia__c=5, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=0.73);
        RV_StackWeights__c sw89 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000007500000', OutDia__c=5, Thickness__c=0.135, WeightMatlCode__c='S', Weight__c=0.75);
        RV_StackWeights__c sw90 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000058500000', OutDia__c=11.87, Thickness__c=0.125, WeightMatlCode__c='L', Weight__c=5.85);
        RV_StackWeights__c sw91 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000P05000004800000', OutDia__c=4, Thickness__c=0.135, WeightMatlCode__c='S', Weight__c=0.48);
        RV_StackWeights__c sw92 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000043400000', OutDia__c=11.87, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=4.34);
        RV_StackWeights__c sw93 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000075200000', OutDia__c=11.13, Thickness__c=0.1875, WeightMatlCode__c='L', Weight__c=7.52);
        RV_StackWeights__c sw94 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000032300000', OutDia__c=4.5, Thickness__c=0.5, WeightMatlCode__c='L', Weight__c=3.23);
        RV_StackWeights__c sw95 = new RV_StackWeights__c(InDia__c=0.75, ModulePN__c='WGT3A0000P05000277900000', OutDia__c=26.5, Thickness__c=0.18, WeightMatlCode__c='S', Weight__c=27.79);
        RV_StackWeights__c sw96 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000014800000', OutDia__c=3.13, Thickness__c=0.5, WeightMatlCode__c='L', Weight__c=1.48);
        RV_StackWeights__c sw97 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000015200000', OutDia__c=8.5, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=1.52);
        RV_StackWeights__c sw98 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000010800000', OutDia__c=7.06, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=1.08);
        RV_StackWeights__c sw99 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000024000000', OutDia__c=7.56, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=2.4);
        RV_StackWeights__c sw100 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000014600000', OutDia__c=8.63, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=1.46);
        RV_StackWeights__c sw101 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000028600000', OutDia__c=8.25, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=2.86);
        RV_StackWeights__c sw102 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000001200000', OutDia__c=2.5, Thickness__c=0.0625, WeightMatlCode__c='L', Weight__c=0.12);
        RV_StackWeights__c sw103 = new RV_StackWeights__c(InDia__c=0.38, ModulePN__c='WGT1A0000013000014500000', OutDia__c=5.75, Thickness__c=0.125, WeightMatlCode__c='L', Weight__c=1.45);
        RV_StackWeights__c sw104 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000P05000036000000', OutDia__c=9.25, Thickness__c=0.1874, WeightMatlCode__c='S', Weight__c=3.6);
        RV_StackWeights__c sw105 = new RV_StackWeights__c(InDia__c=0.5, ModulePN__c='WGT1A0000013000017500000', OutDia__c=7.56, Thickness__c=0.09375, WeightMatlCode__c='L', Weight__c=1.75);
        stackWeightsList.add(sw1);
        stackWeightsList.add(sw2);
        stackWeightsList.add(sw3);
        stackWeightsList.add(sw4);
        stackWeightsList.add(sw5);
        stackWeightsList.add(sw6);
        stackWeightsList.add(sw7);
        stackWeightsList.add(sw8);
        stackWeightsList.add(sw9);
        stackWeightsList.add(sw10);
        stackWeightsList.add(sw11);
        stackWeightsList.add(sw12);
        stackWeightsList.add(sw13);
        stackWeightsList.add(sw14);
        stackWeightsList.add(sw15);
        stackWeightsList.add(sw16);
        stackWeightsList.add(sw17);
        stackWeightsList.add(sw18);
        stackWeightsList.add(sw19);
        stackWeightsList.add(sw20);
        stackWeightsList.add(sw21);
        stackWeightsList.add(sw22);
        stackWeightsList.add(sw23);
        stackWeightsList.add(sw24);
        stackWeightsList.add(sw25);
        stackWeightsList.add(sw26);
        stackWeightsList.add(sw27);
        stackWeightsList.add(sw28);
        stackWeightsList.add(sw29);
        stackWeightsList.add(sw30);
        stackWeightsList.add(sw31);
        stackWeightsList.add(sw32);
        stackWeightsList.add(sw33);
        stackWeightsList.add(sw34);
        stackWeightsList.add(sw35);
        stackWeightsList.add(sw36);
        stackWeightsList.add(sw37);
        stackWeightsList.add(sw38);
        stackWeightsList.add(sw39);
        stackWeightsList.add(sw40);
        stackWeightsList.add(sw41);
        stackWeightsList.add(sw42);
        stackWeightsList.add(sw43);
        stackWeightsList.add(sw44);
        stackWeightsList.add(sw45);
        stackWeightsList.add(sw46);
        stackWeightsList.add(sw47);
        stackWeightsList.add(sw48);
        stackWeightsList.add(sw49);
        stackWeightsList.add(sw50);
        stackWeightsList.add(sw51);
        stackWeightsList.add(sw52);
        stackWeightsList.add(sw53);
        stackWeightsList.add(sw54);
        stackWeightsList.add(sw55);
        stackWeightsList.add(sw56);
        stackWeightsList.add(sw57);
        stackWeightsList.add(sw58);
        stackWeightsList.add(sw59);
        stackWeightsList.add(sw60);
        stackWeightsList.add(sw61);
        stackWeightsList.add(sw62);
        stackWeightsList.add(sw63);
        stackWeightsList.add(sw64);
        stackWeightsList.add(sw65);
        stackWeightsList.add(sw66);
        stackWeightsList.add(sw67);
        stackWeightsList.add(sw68);
        stackWeightsList.add(sw69);
        stackWeightsList.add(sw70);
        stackWeightsList.add(sw71);
        stackWeightsList.add(sw72);
        stackWeightsList.add(sw73);
        stackWeightsList.add(sw74);
        stackWeightsList.add(sw75);
        stackWeightsList.add(sw76);
        stackWeightsList.add(sw77);
        stackWeightsList.add(sw78);
        stackWeightsList.add(sw79);
        stackWeightsList.add(sw80);
        stackWeightsList.add(sw81);
        stackWeightsList.add(sw82);
        stackWeightsList.add(sw83);
        stackWeightsList.add(sw84);
        stackWeightsList.add(sw85);
        stackWeightsList.add(sw86);
        stackWeightsList.add(sw87);
        stackWeightsList.add(sw88);
        stackWeightsList.add(sw89);
        stackWeightsList.add(sw90);
        stackWeightsList.add(sw91);
        stackWeightsList.add(sw92);
        stackWeightsList.add(sw93);
        stackWeightsList.add(sw94);
        stackWeightsList.add(sw95);
        stackWeightsList.add(sw96);
        stackWeightsList.add(sw97);
        stackWeightsList.add(sw98);
        stackWeightsList.add(sw99);
        stackWeightsList.add(sw100);
        stackWeightsList.add(sw101);
        stackWeightsList.add(sw102);
        stackWeightsList.add(sw103);
        stackWeightsList.add(sw104);
        stackWeightsList.add(sw105);
        insert stackWeightsList;
    }
}