public class AssyPartDefinationProcessor {
    /*
AUTHOR: NIKHIL ARPALLY
DATE: FEB 2020
[TODO]: THIS CLASS WILL GENERATES THE PART NUMBER,CHECKS ASSYPARTEXISTING  ALSO COPIES THE VALUES INTO NEW RECORD FOR RE-ORDER
*/
    public static Map<string,string> mapBGRFields {
        get {
            return new Map<String, String>
            {
                'SERVICE'=> 'Service_Type__c',
                    'RTPRS1'=> 'Setting__c',
                    'RTPRSU'=> 'Setting_Units__c',
                    'SUPRS1'=> 'Supply_Pressure__c',
                    'SUPRSU'=> 'Supply_Pressure_Units__c',
                    'ATEX'=> 'Atex__c',
                    'CUTR'=> 'GOST_CU_Tr_010_2011__c',
                    'CSA'=> 'CSA_Markings__c',
                    'PTC'=> 'Model__c',
                    'SZC'=> 'Size__c',
                    'GORIFC'=> 'Orifice_value__c',
                    'MCBODY'=> 'Body_Material_dynamic__c',
                    'MCDPHM'=> 'Soft_Goods_Material_dynamic__c',
                    'HCLASS'=> 'Connection_dynamic__c',
                    'XRAY'=> 'Radiography__c',
                    'PMI'=> 'Positive_Material_Identification__c',
                    'SHLTSTMETHACT'=> 'Shell_test__c',
                    'SHLTSTMETHBDY'=> 'Shell_Test_Valve_Body__c',
                    'ASSYLOCATION'=> 'Final_Assembly_Location_Requirements__c',
                    'MATLSOURCE'=> 'Material_Sourcing_Requirements__c'


                    };
                        }
        set  {
            mapBGRFields = value;
        }
    }

    public static Map<string,string> mapFAFields {
        get {
            return new Map<String, String>
            {
                'ASSYLOCATION'=>     'Final_Assembly_Location_Requirements__c',
                    'ATEX'=>     'Atex_Certificate_2014_34_EU__c',
                    'BRINHARDEXAM'=>     'Brinell_hardness_examination__c',
                    'CHARPYIMPEXAM'=>     'Charpy_Impact_Testing__c',
                    'CUTR'=>     'CU_TR__c',
                    'EndCondition'=>     'Pipe_Design__c',
                    'ESZC'=>     'ESZC__c',
                    'FWLDP'=>     'Fillet_Weld_Liquid_Dye_Penetrant__c',
                    'GasGroupLevel'=>     'GasGroupDynamic__c',
                    'GINLOP_OptA'=>     'Inlet_Option_A__c',
                    'GINLOP_OptB'=>     'Inlet_Option_B__c',
                    'GINLOP_OptC'=>     'Inlet_Option_C__c',
                    'GOUTOP_OptA'=>     'Outlet_Option_A__c',
                    'GOUTOP_OptB'=>     'Outlet_Option_B__c',
                    'GOUTOP_OptC'=>     'Outlet_Option_C__c',
                    'GPAINT'=>     'Painting_Coating_Option__c',
                    'HCLASS'=>     'Drilling__c',
                    'IGCEXAM'=>     'Intergranular_Corossion_Test__c',
                    'LDP'=>     'Liquid_Dye_Penetrant__c',
                    'MAGPARTEXAM'=>     'Magnetic_Particle_Examination__c',
                    'MATLSOURCE'=>     'Material_Sourcing_Requirements__c',
                    'MCBODY'=>     'Body_Material__c',
                    'MCDPHM'=>     'Diaphragm_Material__c',
                    'MCELMT'=>     'Element_Material__c',
                    'MCHOUS'=>     'Housing_Material__c',
                    'MCPALL'=>     'Pallet_Material__c',
                    'Mounting'=>     'Mounting__c',
                    'NACE'=>     'NACE__c',
                    //  'Narrow by Flow'=>     '',
                    'PMI'=>     'Positive_Material_Identification__c',
                    'PTC'=>     'PTC__c',
                    'ReqdGasGroupLevel'=>     'Gas_Group_Code__c',
                    'SETTING'=>     'Pressure_Setting__c',
                    'SPRING'=>     'Spring_Range__c',
                    'SZC'=>     'Size__c',
                    'USCG'=>     'US_Coast_guard__c',
                    'USONICEXAM'=>     'Ultrasonic_Examination__c',
                    'VISCASTEXAM'=>     'Visual_Casting_Examination__c',
                    'XRAY'=>     'Radiography__c'

                    };
                        }
        set  {
            mapFAFields = value;
        }
    }

    public static map<string,string> mapRVFields {
        get {
            return new Map<String, String>
            {
                'BRAND'=> 'Brand__c',
                    'PosFlow'=>     'Relief_Type__c',
                    'VacFlow'=>     'Relief_Type__c',
                    'RTPRS1'=>     'Pressure_Setting__c',
                    'RTPRSU'=>     'Pressure_Setting_Units__c',
                    'PosBackPres'=>     'Back_Pressure__c',
                    'PosBackPresUOM'=>     'Back_Pressure_Units__c',
                    'VTPRS1'=>     'Vacuum_Setting__c',
                    'VTPRSU'=>     'Vacuum_Setting_Units__c',
                    'MaxProcPres'=>     'Max_Process_Pressure__c',
                    'MaxProcPresUOM'=>     'Max_Process_Pressure_Unit__c',
                    //  'Narrow by Flow'=>     'Constraint_Product_Selection_By_Flow__c',
                    'PEDreorder'=>     'PED_2014_68_EU_CE_mark__c',
                    'ATEXreorder'=>     'Atex_Certificate__c',
                    'GasGroup'=>     'Gas_Group__c',
                    'ATEXZONE'=>     'Zone__c',
                    'CUTRreorder'=>     'CU_TR__c',
                    'NACEreorder'=>     'NACE__c',
                    'OPPERCENT'=>     'Type_of_overpressure_valve__c',

                    'MPTC'=>     'Model_name__c',
                    'PTC'=>     'Model_name__c',
                    'SZC'=>     'Size__c',
                    'MSZC'=>     'Size__c',
                    'HCLASS'=>     'Drilling__c',
                    'MCBODY'=>     'Body_Material__c',
                    'GPFACE'=>     'Facing__c',
                    'MCSEAT'=>     'Seat_Material__c',
                    'MCPALL'=>     'Pressure_Pallet_Material__c',
                    'GPTYPE'=>     'Pallet_Type__c',
                    'MCDPHM'=>     'Diaphragm_Material__c',
                    'MCVPAL'=>     'Vacuum_Pallet_Material__c',
                    'MCPSGD'=>     'Pilot_Soft_Goods_Material__c',
                    'MCWGHT'=>     'Weight_Material__c',
                    'MCSPRG'=>     'Spring_Material__c',
                    'MCFAST'=>     'Fastener_Material__c',
                    'MCSTMJ'=>     'Steam_Jacket_Material__c',
                    'GPAINT'=>     'Painting_Coating_Option__c',
                    'MCCOTB'=>     'Body_Coating_Material__c',
                    'MCCOTP'=>     'Pallet_Fastener_Coating_Material__c',
                    'MCELMT'=>     'Element_Material__c',
                    'GOUTOP'=>     'Flame_Arrester_Option__c',
                    'VPRTOP'=>     'Vacuum_Port_Option__c',
                    'POSPROXSENSORreorder'=>     'Pressure_Port_Proximity_Sensor__c',
                    'VACPROXSENSORreorder'=>     'Vacuum_Port_Proximity_Sensor__c',
                    'GPACT'=>     'Pilot_Action__c',
                    'manualBlowdownreorder'=>     'Manual_Blowdown__c',
                    'remoteSensereorder'=>     'Remote_Sense__c',
                    'pilotExhstPipedreorder'=>     'Pilot_Exhaust_Piped_to_Discharge_Header__c',
                    'fieldTestConnectreorder'=>     'Field_Test_Connection__c',
                    'pilotSplyFilterreorder'=>     'Pilot_Supply_Filter__c',
                    'GMTH21reorder'=>     'Method21_Leak_Detection__c',
                    'XRAY'=>     'Radiography__c',
                    'FWLDPreorder'=>     'Fillet_Weld_Liquid_Dye_Penetrant__c',
                    'PMI'=>     'Positive_Material_Identification__c',
                    'LDP'=>     'Liquid_Dye_Penetrant__c',
                    'USONICEXAMreorder'=>     'Ultrasonic_Examination__c',
                    'MAGPARTEXAMreorder'=>     'Magnetic_Particle_Examination__c',
                    'BRINHARDEXAMreorder'=>     'Brinell_hardness_examination__c',
                    'CHARPYIMPEXAMreorder'=>     'Charpy_Impact_Testing__c',
                    'VISCASTEXAMreorder'=>     'Visual_Casting_Examination__c',
                    'IGCEXAMreorder'=>     'Intergranular_Corossion_Test__c',
                    'SHLTSTMETHBDY'=>     'Shell_Test_Valve_Body__c',
                    'ASSYLOCATION'=>     'Final_Assembly_Location_Requirements__c',
                    'MATLSOURCE'=>     'Material_Sourcing_Requirements__c',
                    'EFFMBP'=>     'EffMBP__c',
                    'EffMOP'=>     'EFFMop__c',
                    'PosSetPresOSIG'=>     'PosSetPresOSIG__c',
                    'VacSetPresOSIG'=>     'VacSetPresOSIG__c',
                    'conMaxProcPress'=>     'Converted_Max_Process_Pressure__c',
                    'conBackPress'=>     'Converted_Back_Pressure__c',
                    'conPressSet'=>     'Converted_Pressure_Setting__c',
                    'conVacSet'=>     'Converted_Vacuum_Setting__c',
                    'conRelPressVal'=>     'Converted_Relieving_Pressure_Value__c',
                    'conAtmPress'=>     'Converted_Atmospheric_Pressure__c',
                    'conRelVacVal'=>     'V_Converted_Relieving_Vacuum_Value__c',
                    'conPressRelReqFlow'=>     'Converted_Pressure_Relief_Req_Flow__c',
                    'conconVacRelReqFlow'=>     'Converted_Vacuum_Relief_Req_Flow__c',
                    'conVacRelTemp'=>     'V_Converted_Vacuum_Relieving_Temperature__c',
                    'conPressRelTemp'=>     'Converted_Pressure_Relieving_Temperature__c'


                    };
                        }
        set {
            mapRVFields= value;
        }
    }

    public static map<string,string> mapRDFields {
        get {
            return new Map<String, String>
            {
                'SERVICE' =>'Relief_Type__c',
                    'RTPRS1'      =>   'Pressure_Setting__c',
                    'RTPRSU' => 'Pressure_Setting_Units__c',
                    'RTTMSP'    =>   'Temperature_Setting__c',
                    'RTTMUN'     => 'Temperature_Setting_Units__c',
                    'VACUUMTHSTND'  => 'Vacuum_Withstand__c',
                    'BACKPRESSINPUT' => 'Back_Pressure_Value__c',
                    'BACKPRESSUOM'  => 'Back_Pressure_Units__c',
                    'VTPRS1'     => 'Vacuum_Setting__c',
                    'VTPRSU' => 'Vacuum_Setting_Units__c',
                    'POSWTHSTND' => 'Pressure_Withstand__c',
                    'POSPRESSINPUT' => 'Positive_Pressure_Value__c',
                    'POSPRESSUOM' => 'Positive_Pressure_Units__c',
                    'DPM' => 'Is_there_a_liquid_relief_scenario__c',
                    'Narrow by Flow'  => 'constrain_product_selection_by_flow__c',
                    'ASME'      => 'ASME_Section_VIII_Division_1__c',
                    'PED'         =>    'PED_2014_68_EU_CE_mark__c',
                    'CHINAMFG'    =>    'China_Manufacturing_License__c',
                    'CSA'         =>    'CSA_Marking_CRN_Number__c' ,
                    'ATEX'     => 'Atex_Certificate__c',
                    'GASGRP'      =>    'Gas_Group__c',
                    'ZONE'        =>    'Zone_0_2__c',
                    'KOSHA'      =>     'KOSHA_Compliance__c',
                    'CUTR'        =>    'CU_TR__c' ,
                    'D3ASRV'     =>     'X3A_Sanitary_Standards__c',
                    'ADMERK'  =>   'Comply_with_AD2000_Merkblat_A1__c',
                    'RPVM084' =>  'Comply_with_Regels_Voor_Tosellan_Oder_Dr__c' ,
                    'NACE' =>  'NACE__c',
                    'SZC'  => 'Size__c',
                    'CSSUM'  => 'Size_Units__c',
                    'PTC' => 'Product__c',
                    'SeatDesc' => 'Seat__c' ,
                    'HCLASS' => 'Pressure_Class__c',
                    'HIC' =>  'Inlet_Connection__c',
                    'HOC' => 'Outlet_Connection__c',
                    'RGRAT1' => 'Pressure_Rating_Type__c',
                    'RGTYP1' => 'Pressure_Range_Type__c',
                    'SpecRngMin' => 'Special_Range_Min_Input__c',
                    'SpecRngMax'=> 'Special_Range_Max_Input__c',
                    'BPMMin'=>   'Press_Burst_Pressure_Min_Input__c',
                    'BPMMRefRng'=> 'Reference_Mfg_Range_Type__c',
                    'PerfTolUOM'=> 'Performance_Tolerance_Input_Units__c',
                    'PerfTolMin'=> 'Performance_Tolerance_Min_Input__c',
                    'PerfTolMax'=> 'Performance_Tolerance_Max_Input__c',
                    'VGRAT1'=>  'Vac_Rating_Type__c',
                    'VGTYP1'=>   'Vac_Range_Type__c',
                    'VSpecRngMin'=> 'Vac_Special_Range_Min_Input__c',
                    'VSpecRngMax'=> 'Vac_Special_Range_Max_Input__c',
                    'VBPMMMin'=>  'Vac_Burst_Press_Min_Input__c',
                    'VBPMMRefRng'=>  'Vac_Reference_Mfg_Range_Type__c',
                    'VPerfTolUOM'=> 'Vac_Performance_Tolerance_Units__c',
                    'VPerfTolMin'=> 'Vac_Performance_Tolerance_Min_Input__c',
                    'VPerfTolMax'=> 'Vac_Performance_Tolerance_Max_Input__c',
                    'ASSYLOCATION'=> 'Final_Assembly_Location_Requirements__c',
                    'MATLSOURCE'=> 'Material_Sourcing_Requirements__c',
                    'MCHO'  => 'Material_Outlet__c',
                    'MCHRNG'  => 'Material_Holddown_Ring__c',
                    'MCAR'  => 'Material_Arcuate_Ring__c',
                    'MCGR1'  => 'Material_Armor_Ring__c',
                    'MCOG'  => 'Material_Outlet_Gasket__c',
                    'MCGR2'  => 'Material_Armor_Ring2__c',
                    'MCOR'  => 'Material_Outlet_Ring__c',
                    'MCDP'  => 'Material_Dent_Protector__c',
                    'MCOL'  => 'Material_Outlet_Liner__c',
                    'MCVS1'  => 'Material_Vacuum_Support__c',
                    'MCOC'  => 'Material_Outlet_Coating__c',
                    'MCDT1'  => 'Material_Top_Section__c',
                    'MCDD'  => 'Material_Disc__c',
                    'MCSS1'  => 'Material_Seal__c',
                    'MCGD'  => 'Material_Girdle__c',
                    'MCSS2'  => 'Material_Seal2__c',
                    'MCDT2'  => 'Material_Top_Section2__c',
                    'MCIC1'  => 'Material_Inlet_Coating__c',
                    'MCSS3'  => 'Material_Seal3__c',
                    'MCIR1'  => 'Material_Inlet_Ring__c',
                    'MCIL'  => 'Material_Inlet_Liner__c',
                    'MCIR2'  => 'Material_Inlet_Ring2__c',
                    'MCVS2'  => 'Material_Vacuum_Support2__c',
                    'MCIC2'  => 'Material_Inlet_Coating2__c',
                    'MCIR3'  => 'Material_Inlet_Ring3__c',
                    'MCHS'  => 'Material_Handling_Support__c',
                    'MCVS3'  => 'Material_Vaccum_Support3__c',
                    'MCIG'  => 'Material_Inlet_Gasket__c',
                    'MCHT'  => 'Material_Hi_Temp_Assembly__c',
                    'MCTSOR'  => 'Material_Inlet_O_Ring__c',
                    'MCHI'  => 'Material_Inlet__c',
                    'addIntegralBDI'=> 'Add_Integral_BDI_Integral_BDI_FLX_Sensor__c',
                    'MCBS'=>  'Strip_Type__c',
                    'MCBDIG'=>  'Gasket_Material__c',
                    'WiringConfig'=> 'Wiring_Configuration__c',
                    'BCT'=> 'Wire_Type__c',
                    'BCL'=> 'Cable_Length__c',
                    'BEC'=> 'End_Connection__c' ,
                    'InterfaceCable'=>  'To_Make_With_BDI_FLX_Interface_cable__c',
                    'TMPTSTASME'=> 'Temperature_Test_per_ASME__c',
                    'SHELLTEST'=> 'Shell_Test__c',
                    'PMI'=> 'PMI__c' ,
                    'SURFFINISH'=> 'Surface_Finish__c',
                    'ELECTROPOL'=> 'Electro_polish__c',
                    'INDPCK'=> 'Individual_Packaging__c',
                    'CLEAN'=> 'Cleanings__c',
                    'CSPECS'=> 'Customer_Specific_Requirements__c'
                    };
                        }
        set {
            mapRDFields=value;
        }
    }

    public static Map<string,string> mapHLDFields {
        get {
            return new Map<String, String>
            {
                'ASME'=> 'ASME_Section_VIII__c',
                    'CSA'=>  'CSA_Markings__c',
                    'ATEX'=> 'ATEX_Certificate__c',
                    'CUTR'=> 'GOST_CUTR_Compliance__c',
                    'PED'=> 'CE_PED_Compliance__c',
                    'KOSHA'=> 'KOSHA_Compliance__c',
                    'NACE'=>  'NACE_Compliance__c',
                    'D3ASRV'=>  'X3A_Sanitary_Standards__c',
                    'CHINAMFG'=> 'China_Manufacturing_License__c',
                    'CSSUM'=> 'Size_Unit__c',
                    'SZC'=> 'Size2__c',
                    'PTC'=>  'Holder_Product_Code__c',
                    'HCLASS'=> 'Bolting_Class__c',
                    'HIC'=> 'Inlet_Connection__c',
                    'HOC'=> 'Outlet_Connection__c',
                    'HRTMAXUOM'=> 'Holder_Max_Pressure_Units__c',
                    'MCCF'=> 'Companion_Flange_Material__c',
                    'BoreCF'=> 'Bore__c',
                    'JackscrewCF'=> 'Jackscrew_Drilling__c',
                    'MCHG'=> 'Gasket_Material__c',
                    'MCSpacerRing'=> 'Spacer_Ring_Material__c',
                    'MCHO'=> 'Outlet_Material__c',
                    'MCKBLDOUT'=> 'Knifeblade_Material__c',
                    'GaugeTapOut'=> 'Gauge_Tap__c',
                    'EyeboltMatlOut'=> 'Eyebolts_Outlet__c',
                    'FacingOut'=> 'Facing_Outlet__c',
                    'CoatingOut'=> 'Coating__c',
                    'LiningOut'=> 'Lining__c',
                    'BoreOut'=> 'Bore2__c',
                    'NippleSelectionOut'=> 'Nipple2__c',
                    'TeeSelectionOut'=> 'Tee2__c',
                    'ReducingBushingSelectionOut'=> 'Reducing_Bushing__c',
                    'PressUnitsOut'=> 'Select_UOM_Press_Range__c',
                    'PhysicalPropsOut'=> 'Select_Physical_Properties__c',
                    'TubeCaseMatlOut'=> 'Select_Tube_Case_Material__c',
                    'ExcessFlowValveSelectionOut'=> 'Excess_Flow_Valve__c',
                    'MCMFLG'=> 'Mid_Flange_Material__c',
                    'GaugeTapMFLG'=> 'Gauge_Tap2__c',
                    'EyeboltMatlMFLG'=> 'Eyebolts_Drilling_Midflange__c',
                    'CoatingMFLG'=> 'Coating_Mid_Flange__c',
                    'LiningMFLG'=> 'Lining_Mid_Flange__c',
                    'NippleMFLG'=> 'Nipple_Mid_Flange__c',
                    'TeeMFLG'=> 'Tee_Mid_Flange__c',
                    'ReducerBushingSelectionMFLG'=> 'Reducing_Bushing_Mid_Flange__c',
                    'PressUnitsMFLG'=> 'Select_UOM_Press_Range_Mid_Flange__c',
                    'PhysicalPropsMFLG'=> 'Select_Physical_Properties_Mid_Flange__c',
                    'TubeCaseMatlMFLG'=> 'Select_Tube_Case_Material_Mid_Flange__c',
                    'ExcessFlowValveSelectionMFLG'=> 'Excess_Flow_Valve_Mid_Flange__c',
                    'MCHN'=> 'Nut_Material__c',
                    'MCCLMP'=> 'Clamp_Material__c',
                    'MCHRNG'=> 'Holddown_Ring_Material__c',
                    'MCHI'=> 'Inlet_Material__c',
                    'MCKBLDIN'=> 'Knifeblade_Material_Inlet__c',
                    'GaugeTapIn'=> 'Gauge_Tap_Inlet__c',
                    'EyeboltMatlIn'=> 'Eyebolts_Drilling_Inlet__c',
                    'JHOOK'=> 'J_Hook__c',
                    'FacingIn'=> 'Facing_Inlet__c',
                    'CoatingIn'=> 'Coating_Inlet__c',
                    'LiningIn'=> 'Lining_Inlet__c',
                    'BoreIn'=> 'Bore_Inlet__c',
                    'MCBODY'=> 'Body_Material__c',
                    'CoatingBody'=> 'Coating_Body__c',
                    'MCStudsNuts'=> 'Studs_and_Nuts__c',
                    'MCJackscrews'=> 'Jackscrews_Additional__c',
                    'ASSYLOCATION'=> 'Final_Assembly_Location_Requirements__c',
                    'MATLSOURCE'=> 'Material_Sourcing_Requirements__c',
                    'CLEAN'=> 'Cleaning_Markings__c',
                    'SHELLTEST'=> 'Shell_Testing__c',
                    'PMI'=> 'PMI__c',
                    'EyeboltMatOut'=>'Eyebolts_Outlet__c'
                    };
                        }
        set  {
            mapHLDFields = value;
        }
    }

    public static map<string,string> mapWGBFields {
        get {
            return new Map<String, String>
            {
                'GASGROUP'=>     'Pilot_Gas__c',
                    'RTPRS1'=>        'Pilot_Supply_Pressure__c',
                    'RTPRSU' =>       'Pressure_Setting_Units__c',
                    'REQDFLOW' =>   'Flow_Rate__c',
                    'REQDFLOWUOM' =>       'Flow_Rate_Units__c',
                    'ULCERT'=>            'Certification__c',
                    'PTC'=>                'Select_Model__c',
                    'SZC' =>           'Size__c',
                    'PEDCON'=>        'Pedestal_Connection__c',
                    'IGNCTL'=>        'Ignitor_Control__c',
                    'FLMSNS'=>        'Flame_Sensor__c',
                    'TCMaterial'=>    'Thermocouple_Material__c',
                    'ENCTYP' =>       'Enclosure_Type__c',
                    'CPALRM' =>       'Control_Panel_Alarm__c',
                    'CPHEAT' =>       'Control_Panel_Heater__c',
                    'STNDCT'=>        'Stand_Control_Material__c',
                    'SUNCTL' =>       'Sunshield_Control__c',
                    'SPDT' =>       'Step_Down_Transformer__c',
                    'BPS' =>           'Back_up_Power_Supply__c',
                    'MCUS'=>    'Upper_Shroud_Stack_Matl__c',
                    'MCLS'=> 'Lower_Stack_Pedestal_Matl__c',
                    'PARTNOBASE' => 'Part_Number_Base__c'

                    };
                        }
        set {
            mapWGBFields= value;
        }

    }

    public static map<string,string> mapPSFields
    {
        get
        {
            return new Map<String, String>
            {
                'ASSYPARTNO'=> 'Part_Number__c',
                    'PTC'=> 'PTC__c',
                    'SZC' => 'SZC__c',
                    'ASSYPARTNOBASE' => 'Part_Number_Base__c',
                    'IFSManaged' => 'Quote_Description_Engineer_Override__c'
                    };
                        }
        set {
            mapPSFields= value;
        }
    }


    // public static Map<string,string> mapBGRFields {
    //     get {
    //         return new Map<String, String>
    //         {
    //             'SERVICE'=> 'Service_Type__c',
    //             'RTPRS1'=> 'Setting__c',
    //             'RTPRSU'=> 'Setting_Units__c',
    //             'SUPRS1'=> 'Supply_Pressure__c',
    //             'SUPRSU'=> 'Supply_Pressure_Units__c',
    //             'ATEX'=> 'Atex__c',
    //             'CUTR'=> 'GOST_CU_Tr_010_2011__c',
    //             'CSA'=> 'CSA_Markings__c',
    //             'PTC'=> 'Model__c',
    //             'SZC'=> 'Size__c',
    //             'GORIFC'=> 'Combo_Orifice_Setting__c',
    //             'MCBODY'=> 'Body_Material_dynamic__c',
    //             'MCDPHM'=> 'Soft_Goods_Material_dynamic__c',
    //             'HCLASS'=> 'Connection_dynamic__c',
    //             'XRAY'=> 'Radiography__c',
    //             'PMI'=> 'Positive_Material_Identification__c',
    //             'SHLTSTMETHACT'=> 'Shell_test__c',
    //             'SHLTSTMETHBDY'=> 'Shell_Test_Valve_Body__c',
    //             'ASSYLOCATION'=> 'Final_Assembly_Location_Requirements__c',
    //             'MATLSOURCE'=> 'Material_Sourcing_Requirements__c'


    //         };
    //     }
    //     set  {
    //         mapBGRFields = value;
    //     }
    // }
    public static Map<string,string> mapBrandwithCode {
        get {
            return new Map<String, String>{
                'GROTH'=>'V',
                    'CDC'=>'D',
                    'LAMOT'=>'T',
                    'LVA'=>'L'
                    };
                        }
        set {
            mapBrandwithCode=value;
        }
    }

    public static Map<string,string> mapQuoteNo {
        get {
            return new Map<String, String>{
                'DISC' => 'Quote_Descriptions_Override__c',
                    'BGR' => 'Quote_Description_Engineer_Override__c',
                    'WGB' => 'Quote_Description_Engineer_Override__c',
                    //'HLD' => 'Quote_Description_Engineer_Override__c',
                    'HLD' => 'Quote_Descriptions_Override__c',
                    'FlameProducts' => 'Quote_Description_Engineer_Override__c',
                    'RLFVLV'=> 'Quote_Description_Engineer_Override__c',
                    'PS'=> 'Quote_Description_Engineer_Override__c'
                    };
                        }
    }
    public static Map<string,string> mapPartBaseNo {
        get {
            return new Map<String, String>{
                'DISC' => 'ASSYPARTNOBASE__c',
                    'BGR' => 'Part_Number_Base__c',
                    'WGB' => 'Part_Number_Base__c',
                    'HLD' => 'Part_Number_Base__c',
                    'FlameProducts' => 'Part_Number_Base__c',
                    'RLFVLV'=> 'Part_Number_Base__c',
                    'PS'=> 'Part_Number_Base__c',
                    'RD'=>'ASSYPARTNOBASE__c'
                    };
                        }
        set {

        }
    }
    public static Map<string,string> mapObjectwithConfigurator1 {
        get {
            return new Map<String, String>{
                'Rupture_Disc__c' => 'RD',
                    'BGR__c' => 'BGR',
                    'WasteGasBurner__c' => 'WGB',
                    'Holders__c' => 'HLD',
                    'Flame_Product__c' => 'FlameProducts',
                    'Relief_Valve__c'=> 'RLFVLV',
                    'Part_Selector__c'=> 'PS'
                    };

                        }
        set {
            mapObjectwithConfigurator1 = value;
        }
    }
    public static Map<string,string> mapObjectwithConfigurator {
        get {
            return new Map<String, String>{
                'Rupture_Disc__c' => 'DISC',
                    'BGR__c' => 'BGR',
                    'WasteGasBurner__c' => 'WGB',
                    'Holders__c' => 'HLD',
                    'Flame_Product__c' => 'FlameProducts',
                    'Relief_Valve__c'=> 'RLFVLV',
                    'Part_Selector__c'=> 'PS'
                    };

                        }
        set {
            mapObjectwithConfigurator = value;
        }
    }
    public static Map<string,string> mapConfiguratorwithObject {
        get {
            return new Map<String, String>{
                'DISC' => 'Rupture_Disc__c',
                    'BGR' => 'BGR__c',
                    'WGB' => 'WasteGasBurner__c',
                    'HLD' => 'Holders__c',
                    'FlameProducts' => 'Flame_Product__c',
                    'RLFVLV'=> 'Relief_Valve__c',
                    'PS'=>'Part_Selector__c'
                    };

                        }
        set {
            mapConfiguratorwithObject = value;
        }
    }
    public static result copyValuesFromTransData(sObject sObj,string strPartNumber) {
        result resCopyData=new result();
        string strProdObjName;
        string strDetailObjName='ConfigInputsTranslation__c';
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
        Set<String> DetailFieldNames = objectDetailFields.keySet();
        set <String> detailCustomFields=new set <String>();
        string strPartObjName='AssyPartDefinition__c';
        Map<String, Schema.SObjectField> PartObjFields = Schema.getGlobalDescribe().get(strPartObjName).getDescribe().fields.getMap();
        Set<String> partFieldNames = PartObjFields.keySet();
        set <String> partCustomFields=new set <String>();
        for(String str1:partFieldNames) {
            if(str1.endsWith('__c'))
                partCustomFields.add(str1);
        }
        for(String str:DetailFieldNames) {
            if(str.endsWith('__c'))
                detailCustomFields.add(str);
        }
        string strTransQuery=' SELECT id,' + string.join(new List<String>(detailCustomFields), ',') + ' FROM ' +strDetailObjName;
        string strPartQuery=' SELECT id,'+ string.join(new List<String>(partCustomFields), ',') + ' FROM ' +strPartObjName;
        System.debug('strTransQuery'+strTransQuery);
        List<sobject> lstAssyPartDef=Database.query(strPartQuery+' WHERE ASSYPARTNO__c=\''+strPartNumber+'\'');
        strProdObjName=sObj.id.getSObjectType().getDescribe().getName();
        string strConfigurator=mapObjectwithConfigurator.get(strProdObjName);
        List<sobject> ReOrd=Database.query(strTransQuery+' WHERE Configurator__c=\''+strConfigurator+'\'');
        sObject assyPartDef=lstAssyPartDef[0];

        integer maxFieldCount=DetailFieldNames.size()-(14);

        for (sObject obj:ReOrd) {
            string objName=sObj.id.getSObjectType().getDescribe().getName();
            Map<String, Schema.SObjectField> objFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
            System.debug('obj: ' + sObj.id);
            Map<string,string> mapObjFields=new Map<String,String>();
            if(mapObjectwithConfigurator.get(strProdObjName)=='BGR')
                mapObjFields=mapBGRFields;
            else if (mapObjectwithConfigurator.get(strProdObjName)=='WGB')
                mapObjFields=mapWGBFields;
            else if (mapObjectwithConfigurator.get(strProdObjName)=='FlameProducts')
                mapObjFields=mapFAFields;
            else if (mapObjectwithConfigurator.get(strProdObjName)=='RLFVLV')
                mapObjFields=mapRVFields;
            else if (mapObjectwithConfigurator.get(strProdObjName)=='DISC')
                mapObjFields=mapRDFields;
            else if (mapObjectwithConfigurator.get(strProdObjName)=='HLD')
                mapObjFields=mapHLDFields;
            else
                mapObjFields.put('test','test');
            System.debug('mapObjFields'+mapObjFields);
            for (integer i=1;i<=maxFieldCount;i++) {
                string strDetailCol='field'+i+'__c';
                string strOpp='fieldopp'+i+'__c';
                if (detailCustomFields.contains(strDetailCol)) {
                    System.debug('Fist Block'+strDetailCol);
                    if(mapObjFields.containsKey((string) obj.get(strDetailCol))) {
                        System.debug('sec Block'+strDetailCol);
                        string fieldName=mapObjFields.get((string) obj.get(strDetailCol));
                        System.debug('Field Name'+fieldName);
                        Schema.DisplayType fielddataType = objFields.get(fieldName).getDescribe().getType();
                        if (fielddataType  != Schema.DisplayType.DOUBLE && fielddataType!=Schema.DisplayType.BOOLEAN) {
                            System.debug('fieldValue'+String.ValueOf(assyPartDef.get(strDetailCol)));
                            sObj.put(fieldName,String.ValueOf(assyPartDef.get(strDetailCol)));
                        }
                        else if(fielddataType==Schema.DisplayType.BOOLEAN){
                            String isNullVal='false';
                            if(String.isNotBlank((string) assyPartDef.get(strDetailCol))) {
                                isNullVal=(string) assyPartDef.get(strDetailCol);
                            }
                            System.debug('fieldValue1'+BOOLEAN.ValueOf(isNullVal));
                            sObj.put(fieldName,BOOLEAN.valueOf(isNullVal));
                        }
                        else {
                            //System.debug('Field Name1'+fieldName);
                            //System.debug('Field Type1'+fielddataType);
                            //System.debug('fieldName'+fieldName);
                            /*if (fielddataType  != Schema.DisplayType.DOUBLE && fielddataType!=Schema.DisplayType.BOOLEAN)
sObjt.put(strDetailCol,(string) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))));
else if(fielddataType!=Schema.DisplayType.BOOLEAN)
sObjt.put(strDetailCol,string.ValueOf((decimal) sObj.get(mapObjFields.get((string) obj.get(strDetailCol)))));
else
sObjt.put(strDetailCol,(Boolean) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))) +'');*/

                            System.debug('fieldValue1'+double.ValueOf(assyPartDef.get(strDetailCol)));
                            sObj.put(fieldName,double.valueOf(assyPartDef.get(strDetailCol)));
                        }
                    }
                }
            }
        }
        System.debug('Final sObj'+sObj);
        try {
            sObj.put('Bypass__c',true);
            upsert sObj;
            resCopyData.bResult=true;
        } catch (Exception e) {
            System.debug('Final sObj'+e.getMessage());
            resCopyData.bResult=false;
        }
        return resCopyData;
    }
    public static result generatePartNumber(sObject sObj)
    {
        boolean partnumbercreated;
        result genPart=new result();
        DescribeSObjectResult describeResult = sObj.Id.getSObjectType().getDescribe();
        System.debug('Record  '+describeResult);
        string sObjName=describeResult.getName();
        id idQuoteLine=(id) sObj.get('Quote_Line__c');
        string strBrand=[select SBQQ__Quote__r.Brand__c from SBQQ__QuoteLine__c where id=:idQuoteLine].SBQQ__Quote__r.Brand__c;
        string ASSYPARTNOSEQ;
        boolean isSPlSeq=false;
        string strConfig;
        string ASSYPARTNOBASE;
        try
        {
            system.debug('AssyPartDefeninationProcessor-> Logic to generate PARTNUMBERBASE starts here' + sObjName + '_______'+ mapQuoteNo +'____' +mapObjectwithConfigurator +'______'+sObjName);
            if((boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))))
            {
                system.debug('AssyPartDefeninationProcessor-> SPL PARTS BLOCK');
                strConfig=(string) mapObjectwithConfigurator.get(sObjName);
                System.debug('AssyPartDefeninationProcessor->strConfig = '+strConfig);
                if(strConfig =='DISC' || strConfig == 'PS' || strConfig == 'HLD')
                {
                    isSPlSeq=true; //USED TO CHECK 4 DIGIT SEQUENCE FOR SPLS (RD,HLD,PS)
                    string spl=(string) sObj.get('NEWSPCLPARTNOBASE__c');
                    //string spl='CD546789A';
                    system.debug('AssyPartDefeninationProcessor-> LOGIC FOR BASE');
                    System.debug('*** spl = '+spl);
                    integer seq=0;
                    if(String.isNotBlank(spl))
                    {

                        if(spl.contains('CD'))
                        {
                            string seqQuery='SELECT count() from AssyPartDefinition__c where ASSYPARTNO__c Like \'CD5%\'';
                            //sObject[] res=Database.countQuery(seqQuery);
                            seq=Database.countQuery(seqQuery)+1;
                            seq=50000+seq;
                            ASSYPARTNOBASE='CD'+seq+'A';
                            system.debug('AssyPartDefeninationProcessor->   CD AssyPartBase: '+ASSYPARTNOBASE);

                        }
                        else if (spl.contains('LD'))
                        {
                            string seqQuery='SELECT count() from AssyPartDefinition__c where ASSYPARTNO__c Like \'LD5%\'';
                            //sObject[] res=Database.countQuery(seqQuery);
                            seq=Database.countQuery(seqQuery)+1;
                            seq=50000+seq;
                            ASSYPARTNOBASE='LD'+seq+'A';
                            system.debug('AssyPartDefeninationProcessor->  LD AssyPartBase: '+ASSYPARTNOBASE);
                        }
                    }
                    else if((strConfig == 'PS' && ((string) sObj.get('NEWSPCLPARTNOBASE__c') == null || (string) sObj.get('NEWSPCLPARTNOBASE__c') == 'None')) || (strConfig =='DISC' || strConfig =='HLD') )
                    {
                        ASSYPARTNOBASE=(string) sObj.get(mapPartBaseNo.get(strConfig));
                        system.debug('AssyPartDefeninationProcessor->  AssyPartBase '+ASSYPARTNOBASE);
                    }

                }
                else
                {
                    ASSYPARTNOBASE=(string) sObj.get(mapPartBaseNo.get(strConfig));
                    system.debug('AssyPartDefeninationProcessor 2 ->  AssyPartBase '+ASSYPARTNOBASE);
                }
            }
            else
            {
                system.debug('AssyPartDefeninationProcessor-> STD PARTS BLOCK'+ sObjName +'______'+mapObjectwithConfigurator );
                string strBRANDCODE=mapBrandwithCode.get(strBrand.ToUpperCase());
                strConfig=mapObjectwithConfigurator.get(sObjName);
                system.debug('Inside'+strConfig);
                if (strConfig=='BGR')
                {
                    System.debug('@@@@@BGRRRRRR');
                    STRING SIZE=(String) sObj.get(mapBGRFields.get('SZC'));
                    System.debug('@@@@@BGRRRRRR22222222');
                    SIZE=SIZE.leftPad(1,'0');
                    System.debug('@@@@@BGRRRRRR33333333' +SIZE);
                    STRING PNSIZE=[SELECT Text__c FROM BGR_Attribute_lookup_Details__c WHERE Attribute__c='PNSIZE' AND Text1Val__c=:SIZE].Text__c;
                    System.debug('@@@@@BGRRRRRR4444444');
                    STRING PNMODEL=[SELECT Text__c FROM BGR_Attribute_lookup_Details__c WHERE Attribute__c='PNMODEL' AND Text1Val__c=:(String) sObj.get(mapBGRFields.get('PTC'))].Text__c;
                    System.debug('@@@@@BGRRRRRR55555');
                    ASSYPARTNOBASE=strBRANDCODE+PNMODEL+PNSIZE+(String) sObj.get(mapBGRFields.get('MCBODY'))+'00'+(String) sObj.get(mapBGRFields.get('MCDPHM'))+'0'+(String) sObj.get(mapBGRFields.get('HCLASS'));
                    System.debug('@@@@@BGRRRRRRASSYPARTNOBASE'+ASSYPARTNOBASE);
                    System.debug('@@@@@PNSIZE'+PNMODEL);
                    System.debug('@@@@@PNSIZE'+PNSIZE);
                }
                else if(strConfig=='FlameProducts')
                {
                    System.debug('Flame-----');
                    string strSZC=(String) sObj.get(mapFAFields.get('SZC'));
                    System.debug('Flame1111111-----');
                    string strESZC=(String) sObj.get(mapFAFields.get('ESZC'));
                    string strMCBODY=(String) sObj.get(mapFAFields.get('MCBODY'));
                    string strMCHOUS=(String) sObj.get(mapFAFields.get('MCHOUS'));
                    string strMCELMT=(String) sObj.get(mapFAFields.get('MCELMT'));
                    string strHCLASS=(String) sObj.get(mapFAFields.get('HCLASS'));
                    //string strPNGPFACE=(String) sObj.get(mapFAFields.get('PNGPFACE'));
                    string strGOUTOP_OptA=(String) sObj.get(mapFAFields.get('GOUTOP_OptA'));
                    string strGINLOP_OptA=(String) sObj.get(mapFAFields.get('GINLOP_OptA'));
                    System.debug('Flame-----');
                    result FAAttributes = new Result();
                    Map<string, string> mapVals = new Map<string, string>();
                    mapVals.put('PTC',(String) sObj.get(mapFAFields.get('PTC')));
                    mapVals.put('MCBODY',(String) sObj.get(mapFAFields.get('MCBODY')));

                    System.debug('Inside the if block'+strConfig);
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
                    ASSYPARTNOBASE=strBRANDCODE+strPNMODEL+strSZC+strESZC+ strMCBODY + strMCHOUS + strMCELMT + strHCLASS + strPNGPFACE + strGINLOP_OptA + strGOUTOP_OptA;
                    System.debug('@@@@@RVVVVASSYPARTNOBASE'+ASSYPARTNOBASE);
                }
                else if(strConfig=='RLFVLV')
                {
                    string strPNMCPALL='';
                    string strMCPALL=(String) sObj.get(mapRVFields.get('MCPALL'));
                    if (strMCPALL=='N')
                        strPNMCPALL=(String) sObj.get(mapRVFields.get('MCVPAL'));
                    else
                        strPNMCPALL=(String) sObj.get(mapRVFields.get('MCPALL'));
                    result RVAttributes = new Result();
                    Map<string, string> mapVals = new Map<string, string>();
                    mapVals.put('MCDPHM',(String) sObj.get(mapRVFields.get('MCDPHM')));
                    mapVals.put('PTC',(String) sObj.get(mapRVFields.get('PTC')));

                    System.debug('Inside the if block'+strConfig);
                    List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
                        RVAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RV_Valve_Attributes_Translation__c','RV_Valve_Attributes_Details__c',mapVals,selectCols);
                    List<string> listName = new List<string>();
                    listName.add('PNMCDPHM');
                    listName.add('PNMODEL');
                    Map<string,string> mapAttValues= new Map<string,string>();
                    if (RVAttributes.bResult) {
                        for(sObject objD : RVAttributes.objResultList)
                        {
                            if(listName.contains((string) objD.get('Attribute__c'))) {
                                mapAttValues.put((string) objD.get('Attribute__c'),(string) objD.get('Text__c'));
                            }
                        }
                    }

                    String PNMCDPHM=mapAttValues.get('PNMCDPHM');
                    String PNMODEL=mapAttValues.get('PNMODEL');
                    //String strSZC=(String) sObj.get(mapRVFields.get('SZC'));
                    //strSZC=strSZC+'0';
                    String strSZC=(String) sObj.get(mapRVFields.get('SZC'));
                    integer strLEN=strSZC.length();
                    if(strLEN<2)
                        strSZC='0'+strSZC;
                    else
                        strSZC=strSZC;

                    ASSYPARTNOBASE=strBRANDCODE+PNMODEL+strSZC
                        +(String) sObj.get(mapRVFields.get('MCBODY'))+(String) sObj.get(mapRVFields.get('MCSEAT'))+strPNMCPALL
                        +PNMCDPHM+(String) sObj.get(mapRVFields.get('HCLASS'));
                    System.debug('@@@@@RVVVVASSYPARTNOBASE'+ASSYPARTNOBASE);
                }
                else if (strConfig=='WGB')
                {
                    /* System.debug('@@@@@BGRRRRRRWWWWWWWWWWWW');
STRING SIZE=(String) sObj.get(mapWGBFields.get('SZC'));
System.debug('WGB SIZE TEST1: ' + SIZE);
SIZE=SIZE.leftPad(2,'0');
System.debug('WGB SIZE TEST2: ' + SIZE);
STRING MODEL=(String) sObj.get(mapWGBFields.get('PTC'));
System.debug('WGB MODEL TEST2: ' + MODEL);
STRING MCUS=(String) sObj.get('Upper_Shroud_Stack_Matl__c');
STRING MCLS=(String) sObj.get('Lower_Stack_Pedestal_Matl__c');
STRING PEDCON=(String) sObj.get(mapWGBFields.get('PEDCON'));
result WGBAttributes = new Result();
Map<string, string> mapVals = new Map<string, string>();
mapVals.put('IGNCTL',(String) sObj.get(mapWGBFields.get('IGNCTL')));
mapVals.put('BPS',(String) sObj.get(mapWGBFields.get('BPS')));
mapVals.put('CPALRM',(String) sObj.get(mapWGBFields.get('CPALRM')));
mapVals.put('FLMSNS',(String) sObj.get(mapWGBFields.get('FLMSNS')));
mapVals.put('ENCTYP',(String) sObj.get(mapWGBFields.get('ENCTYP')));
mapVals.put('CPHEAT',(String) sObj.get(mapWGBFields.get('CPHEAT')));
//mapVals.put('SpecialOpt',(String) sObj.get(mapWGBFields.get('SpecialOpt')));
// mapVals.put('SpecialOpt2',(String) sObj.get(mapWGBFields.get('SpecialOpt2')));
//mapVals.put('SpecialOpt4',(String) sObj.get(mapWGBFields.get('SpecialOpt4')));
// mapVals.put('SpecialOpt6',(String) sObj.get(mapWGBFields.get('SpecialOpt6')));
//mapVals.put('SpecialOpt8',(String) sObj.get(mapWGBFields.get('SpecialOpt8')));
System.debug('Inside the if block'+strConfig);
List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
WGBAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','WGB_Attribute_Lookup_Translation__c','WGB_Attribute_Lookup_Detail__c',mapVals,selectCols);
System.debug('Inside the if block1'+strConfig);
List<string> listName = new List<string>();
listName.add('IgnitorOpt');
listName.add('FlameSensorOpt');
listName.add('EnclosureOpt');
listName.add('SpecialOpt');
listName.add('SpecialOpt2');
listName.add('SpecialOpt4');
listName.add('SpecialOpt6');
listName.add('SpecialOpt8');
//listName.add('ConnectionDesc');
Map<string,string> mapAttValues= new Map<string,string>();
if (WGBAttributes.bResult) {
for(sObject objD : WGBAttributes.objResultList)
{
if(listName.contains((string) objD.get('Attribute__c'))) {
mapAttValues.put((string) objD.get('Attribute__c'),(string) objD.get('Text__c'));
}
}
}
String IgnitorOpt=mapAttValues.get('IgnitorOpt');
String SpecialOpt=mapAttValues.get('SpecialOpt');
String EnclosureOpt=mapAttValues.get('EnclosureOpt');
String FlameSensorOpt=mapAttValues.get('FlameSensorOpt');

ASSYPARTNOBASE=strBRANDCODE+MODEL+'00'+SIZE+'00'+MCUS+MCLS+PEDCON+IgnitorOpt+FlameSensorOpt+EnclosureOpt+SpecialOpt;*/
                    STRING strPARTNOBASE=(String) sObj.get(mapWGBFields.get('PARTNOBASE'));
                    ASSYPARTNOBASE=strPARTNOBASE;
                }
                else if (strConfig=='DISC')
                {
                    System.debug('@@@@@RRDDDDDDWWWWWWWWWWWW');
                    STRING strSIZE=ConstantsUtil.getSizeDesc((String) sObj.get(mapRDFields.get('SZC'))).SZC;
                    STRING strMODEL=(String) sObj.get(mapRDFields.get('PTC'));
                    STRING strSEAT=(String) sObj.get(mapRDFields.get('SeatDesc'));
                    ASSYPARTNOBASE=strBRANDCODE+strMODEL+strSIZE+strSEAT;
                    System.debug('DISC ASSYPARTNOBASE = '+ASSYPARTNOBASE);
                    //BRANDCODE & PTC & SZC & STC
                }
                else if (strConfig=='HLD')
                {
                    System.debug('AAA');
                    System.debug('@@@@@HLD');
                    STRING SIZE=(String) sObj.get(mapHLDFields.get('SZC'));
                    //System.debug('HLD SIZE TEST1: ' + SIZE);
                    SIZE=SIZE.leftPad(2,'0');
                    //System.debug('HLD SIZE TEST2: ' + SIZE);
                    STRING MODEL=(String) sObj.get(mapHLDFields.get('PTC'));
                    //System.debug('HLD MODEL TEST2: ' + MODEL);
                    STRING HCLASS=(String) sObj.get(mapHLDFields.get('HCLASS'));
                    ASSYPARTNOBASE=strBRANDCODE+MODEL+SIZE+HCLASS;
                    //BRANDCODE & PTC & SZC & HCLASS
                }
                System.debug('Inside the if block2'+strConfig);
            }

            System.debug('PPP ASSYPARTNOBASE = '+ASSYPARTNOBASE);
            System.debug('PPP PS Part number = '+(string) sObj.get('Part_Number__c'));
            Boolean Asypart1 = True;
            //Added below line for the redmine 34206
            if(!(boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName)))){
                for(AssyPartDefinition__c asdef1:[SELECT Id,ASSYPARTNO__c FROM  AssyPartDefinition__c WHERE ASSYPARTNO__c  =: (string) sObj.get('Part_Number__c')])
                {
                    Asypart1 = False;
                     system.debug('$$$$$$$'+Asypart1);
                }
            }
            System.debug('ASSYPARTNOBASE@@'+ASSYPARTNOBASE);
            string GetHighestSequence = '0';
            //string seqQuery='SELECT count() from AssyPartDefinition__c where ASSYPARTNO__c Like \''+ASSYPARTNOBASE+'%\'';
            string seqQuery='SELECT ASSYPARTNO__c from AssyPartDefinition__c where ASSYPARTNO__c Like \''+ASSYPARTNOBASE+'%\' order by ASSYPARTNO__c DESC';
            List<AssyPartDefinition__c> res = new List<AssyPartDefinition__c>();
            res=Database.query(seqQuery);
            system.debug('@@@@@@res'+res);
            integer seq= 1;
            if(res.size()>0 )
            {
                List<integer> SequenceList = new List<integer>();
                for(AssyPartDefinition__c assyPartRec : res)
                {
                    String assyPartNumberWithoutBase = assyPartRec.ASSYPARTNO__c.substringAfter(ASSYPARTNOBASE);
                    Pattern p = Pattern.compile('[^0-9]');
                    integer assyPartNumberWithoutBaseNumeric = Integer.valueOf(p.matcher(assyPartNumberWithoutBase).replaceAll(''));
                    SequenceList.add(assyPartNumberWithoutBaseNumeric);
                }
               
                if(SequenceList.size() > 0)
                {
                    SequenceList.sort();
                    seq = SequenceList[SequenceList.size() - 1];
                    seq += 1;
                }
                
               /* GetHighestSequence = res[0].ASSYPARTNO__c.substringAfter(ASSYPARTNOBASE);
                system.debug(GetHighestSequence.split(''));
                Integer count =0;
                for(string s1 : GetHighestSequence.split('')){
                    if(s1.isNumeric()){
                        break;
                    }else{
                        count++;
                    }
                }
                string tempstr = GetHighestSequence.split('')[count];
                GetHighestSequence = tempstr+GetHighestSequence.split(tempstr,2)[1];*/
            }
            system.debug('$$$$$$$$$$ count' +GetHighestSequence);
            //integer seq=Database.countQuery(seqQuery)+1;
             //integer seq= integer.valueOf(GetHighestSequence)+1;
            //  system.debug('$$$$$$$$$$ count' +Database.countQuery(seqQuery));
            string str=String.ValueOf(seq);
            if((strConfig == 'HLD'||strConfig=='DISC'||strConfig=='PS') && isSPlSeq )
                ASSYPARTNOSEQ=str.leftPad(4,'0');
            else
                ASSYPARTNOSEQ=str.leftPad(5,'0');
            string ASSYPARTNO;

            system.debug('&&&&&&&&&&&'+ASSYPARTNOSEQ);
            if(strConfig == 'PS' && (boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))) && ((string) sObj.get('NEWSPCLPARTNOBASE__c') == null || (string) sObj.get('NEWSPCLPARTNOBASE__c') == 'None'))
            {
                ASSYPARTNOBASE = (String) sObj.get(mapPSFields.get('ASSYPARTNOBASE'));
                if(Asypart1 == True)
                {
                    ASSYPARTNOSEQ=str.leftPad(4,'0');
                    ASSYPARTNO = ASSYPARTNOBASE+'A'+ASSYPARTNOSEQ;
                }
                else
                {
                    ASSYPARTNO = (string) sObj.get('Part_Number__c');
                }

            }
            else if(strConfig == 'PS' && (!(boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName)))))
            {
                ASSYPARTNOBASE = (string) sObj.get(mapPartBaseNo.get(strConfig));
                ASSYPARTNO = (string) sObj.get(mapPartBaseNo.get(strConfig));
                system.debug('@@ Part Number Quote description unchecked: '+ASSYPARTNOBASE);
            }
            else
            {
                ASSYPARTNO = ASSYPARTNOBASE+ASSYPARTNOSEQ;
            }
            System.debug('ASSYPARTNO@@'+ASSYPARTNO);
            System.debug('ASSYPARTNOBASE@@'+ASSYPARTNOBASE);
            /*Boolean Asypart=False;
for(AssyPartDefinition__c asdef:[SELECT Id, ASSYPARTNO__c FROM  AssyPartDefinition__c WHERE ASSYPARTNO__c=: ASSYPARTNO]){
Asypart=True;
system.debug('enter loop');
}*/
            String PS_ASSYPARTNO = '';
            if(strConfig == 'PS')
            {
                PS_ASSYPARTNO = (string) sObj.get('Part_Number_Backup__c');
            }
            String PS_PartNum = '';
            /*if(strConfig == 'PS')
{
PS_PartNum = (string) sObj.get('Part_Number__c');//added by Ashim and null check below
}
if(strConfig == 'PS' && PS_ASSYPARTNO != PS_PartNum  && (boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))) && ((string) sObj.get('NEWSPCLPARTNOBASE__c') != null || (string) sObj.get('NEWSPCLPARTNOBASE__c') != 'None'))
{
ASSYPARTNO =  PS_PartNum;
}*/
            genPart.strRetValue=ASSYPARTNO;
            genPart.strRetValue2=ASSYPARTNOBASE;
            genPart.bResult=true;
            System.debug('ASSYPARTNO@@'+ASSYPARTNO);
            System.debug('ASSYPARTNOBASE@@'+ASSYPARTNOBASE);
        }
        catch (Exception e) {
            system.debug(e);
            system.debug(e.getLineNumber());
            genPart.bResult=false;
        }
        system.debug('$$$$$$$'+genPart);
        return genPart;
    }

    //This Method is used to Get Existing the Part Number based on the sObject
    //Parameters:sObject (record instance for which PARTNUMBER to be generate)
    //Returns : Result
    public static result getPartNumberExisting(string strPartBase,sObject sObj,string strConf) {
        result resPartData=new result();
        DescribeSObjectResult describeResult = sObj.Id.getSObjectType().getDescribe();
        System.debug('Record  '+describeResult);
        string sObjName=describeResult.getName();
        Map<String, Schema.SObjectField> sObjFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        string strConfigObjName='ConfigInputsTranslation__c';
        Map<String, Schema.SObjectField> objectConfigFields = Schema.getGlobalDescribe().get(strConfigObjName).getDescribe().fields.getMap();
        Set<String> ConfigFieldNames = objectConfigFields.keySet();
        set <String> ConfigCustomFields=new set <String>();
        string strPartObjName='AssyPartDefinition__c';
        Map<String, Schema.SObjectField> PartObjFields = Schema.getGlobalDescribe().get(strPartObjName).getDescribe().fields.getMap();
        Set<String> partFieldNames = PartObjFields.keySet();
        set <String> partCustomFields=new set <String>();
        for(String str1:partFieldNames) {
            if(str1.endsWith('__c'))
                partCustomFields.add(str1);
        }
        for(String str:ConfigFieldNames) {
            if(str.endsWith('__c'))
                ConfigCustomFields.add(str);
        }
        string strConfigQuery=' SELECT id,' + string.join(new List<String>(ConfigCustomFields), ',') + ' FROM ' +strConfigObjName;
        System.debug('strConfigQuery'+strConfigQuery);
        //System.debug('strConfig'+strConfig);
        List<sobject> conRec=Database.query(strConfigQuery+' WHERE Configurator__c=\''+strConf+'\'');
        integer maxFieldCount=ConfigCustomFields.size()-(14);
        Map<string,string> mapObjFields=new Map<String,String>();
        AssyPartDefinition__c sObjt=new AssyPartDefinition__c();
        strPartObjName='AssyPartDefinition__c';
        PartObjFields = Schema.getGlobalDescribe().get(strPartObjName).getDescribe().fields.getMap();
        partFieldNames = PartObjFields.keySet();
        partCustomFields=new set <String>();
        for(String str1:partFieldNames) {
            if(str1.endsWith('__c'))
                partCustomFields.add(str1);
        }
        string strPartQuery=' SELECT id,'+ string.join(new List<String>(partCustomFields), ',') + ' FROM ' +strPartObjName;

        //modified by Ashim to exclude picking records associated with "SPECIAL"
        String notSplConfig = 'SPECIAL';
        String checkPartSQL = strPartQuery + ' WHERE Configurator__c != :notSplConfig AND ASSYPARTNO__c LIKE\'%'+strPartBase+'%\'';
        checkPartSQL += ' ORDER BY Id DESC ';
        system.debug('checkPartSQL:'+checkPartSQL);
        //List<sobject> lstAssyBase=Database.query(strPartQuery+' WHERE ASSYPARTNO__c LIKE\'%'+strPartBase+'%\'');
        List<sobject> lstAssyBase=Database.query(checkPartSQL);

        //sObject[] res=Database.countQuery(seqQuery);
        //integer seq=Database.countQuery(seqQuery)+1;
        if(mapObjectwithConfigurator.get(sObjName)=='BGR')
            mapObjFields=mapBGRFields;
        else if (mapObjectwithConfigurator.get(sObjName)=='RLFVLV')
            mapObjFields=mapRVFields;
        else if (mapObjectwithConfigurator.get(sObjName)=='WGB')
            mapObjFields=mapWGBFields;
        else if (mapObjectwithConfigurator.get(sObjName)=='FlameProducts')
            mapObjFields=mapFAFields;
        else if (mapObjectwithConfigurator.get(sObjName)=='DISC')
            mapObjFields=mapRDFields;
        else if (mapObjectwithConfigurator.get(sObjName)=='HLD')
            mapObjFields=mapHLDFields;
        else if (mapObjectwithConfigurator.get(sObjName)=='PS')
            mapObjFields=mapPSFields;
        else
            mapObjFields.put('test','test');
        system.debug('mapObjFields'+mapObjFields);
        boolean isConfigFound=true;
        if(lstAssyBase.size()<=0 || lstAssyBase.isEmpty()) {
            isConfigFound=false;
        }
        for (sObject obj:conRec) {
            for(sObject assyRec:lstAssyBase) {
                isConfigFound=true;
                for (integer i=1;i<=maxFieldCount;i++) {
                    string strDetailCol='field'+i+'__c';
                    //System.debug('strDetailCol: ' + strDetailCol);
                    if (ConfigCustomFields.contains(strDetailCol) && partCustomFields.contains(strDetailCol)) {
                        //Check Logic
                        system.debug('PartNumber Check Logic Trsn FieldName'+strDetailCol);
                        System.debug('PartNumber Check Logic Trsn Key Value'+(string) obj.get(strDetailCol));
                        String pdObjFieldName=mapObjFields.get((string) obj.get(strDetailCol));

                        if(mapObjFields.containsKey((string) obj.get(strDetailCol))) {
                            Schema.DisplayType fielddataType = sObjFields.get(mapObjFields.get((string) obj.get(strDetailCol))).getDescribe().getType();
                            System.debug('CheckP '+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol));
                            if (fielddataType  != Schema.DisplayType.DOUBLE && fielddataType!=Schema.DisplayType.BOOLEAN) {
                                if(!(string.isBlank((string) assyRec.get(strDetailCol)) && string.isBlank((string) sObj.get(pdObjFieldName)))) {
                                    if ((string) assyRec.get(strDetailCol)!= (string) sObj.get(pdObjFieldName)) {
                                        isConfigFound=false;
                                        System.debug('AAAAAAAAA----'+(String) assyRec.get('ASSYPARTNO__c')+' ASSY  Rec Value' +(string) assyRec.get(strDetailCol)+' Record Value' + (string) sObj.get(pdObjFieldName) +' ');
                                        System.debug('CheckP Broke @'+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                        break;
                                    }
                                }
                            } else if(fielddataType!=Schema.DisplayType.BOOLEAN){
                                if ((string) assyRec.get(strDetailCol)!= string.ValueOf((decimal) sObj.get(pdObjFieldName))) {
                                    isConfigFound=false;
                                    System.debug('AAAAAAAAA----'+(String) assyRec.get('ASSYPARTNO__c')+' ASSY  Rec Value' +(string) assyRec.get(strDetailCol)+' Record Value' + string.ValueOf((decimal) sObj.get(pdObjFieldName)) +' ');
                                    System.debug('CheckP Break Point 2 @'+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                    break;
                                }
                            }
                            else {
                                if ((string) assyRec.get(strDetailCol)!= string.ValueOf((Boolean) sObj.get(pdObjFieldName))) {
                                    isConfigFound=false;
                                    System.debug('AAAAAAAAA----'+(String) assyRec.get('ASSYPARTNO__c')+' ASSY  Rec Value' +(string) assyRec.get(strDetailCol)+' Record Value' + string.ValueOf((Boolean) sObj.get(pdObjFieldName)) +' ');
                                    System.debug('CheckP Break Point 2 @'+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                    break;
                                }
                            }
                            System.debug('CheckP is Done for  '+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);

                        }
                        System.debug('CheckP is Done 2 for  '+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol));
                    }

                }
                System.debug('CheckP is Done for All  '+(String) assyRec.get('ASSYPARTNO__c')+' ConfigFound '+isConfigFound);
                if(isConfigFound) {
                    System.debug('PartNumber Found Matched : ' + (String) assyRec.get('ASSYPARTNO__c'));
                    //sObj.put('Part_Number__c',(String) assyRec.get('ASSYPARTNO__c'));
                    //sObj.put('PARTREV__c',(String) assyRec.get('PartRevision__c'));
                    resPartData.strRetValue=(String) assyRec.get('ASSYPARTNO__c');
                    break;
                }
                else {
                    System.debug('PartNumber Found Not Matched : ' + (String) assyRec.get('ASSYPARTNO__c'));
                    continue;
                }

            }
        }
        if(!isConfigFound) {
            resPartData.bResult=false;
            resPartData.strRetValue='No Data Found';
        } else {
            resPartData.bResult=true;

        }
        return resPartData;
    }

    //This Method is used to gernate the Part Number based on the sObject
    //Parameters:sObject (record instance for which PARTNUMBER to be generate)
    //Returns : Result
    public static result getPartNumberByRec(sObject sObj)
    {
        string strConfig;
        //GET Object Name by the Record ID
        result resPartData=new result();
        try
        {
            DescribeSObjectResult describeResult = sObj.Id.getSObjectType().getDescribe();
            System.debug('Record  '+describeResult);
            string sObjName=describeResult.getName();
            Map<String, Schema.SObjectField> sObjFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
            id idQuoteLine=(id) sObj.get('Quote_Line__c');
            SBQQ__QuoteLine__c quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.Brand__c,isIFSManaged__c FROM SBQQ__QuoteLine__c  WHERE id = :idQuoteLine];
            string strBrand=quoteLine.SBQQ__Quote__r.Brand__c;
            string strBRANDCODE=mapBrandwithCode.get(strBrand.ToUpperCase());
            strConfig=mapObjectwithConfigurator.get(sObjName);

            string strConfigObjName='ConfigInputsTranslation__c';
            Map<String, Schema.SObjectField> objectConfigFields = Schema.getGlobalDescribe().get(strConfigObjName).getDescribe().fields.getMap();
            Set<String> ConfigFieldNames = objectConfigFields.keySet();
            set <String> ConfigCustomFields=new set <String>();
            string strPartObjName='AssyPartDefinition__c';
            Map<String, Schema.SObjectField> PartObjFields = Schema.getGlobalDescribe().get(strPartObjName).getDescribe().fields.getMap();
            Set<String> partFieldNames = PartObjFields.keySet();
            set <String> partCustomFields=new set <String>();
            for(String str1:partFieldNames)
            {
                if(str1.endsWith('__c'))
                    partCustomFields.add(str1);
            }
            for(String str:ConfigFieldNames)
            {
                if(str.endsWith('__c'))
                    ConfigCustomFields.add(str);
            }
            string strConfigQuery=' SELECT id,' + string.join(new List<String>(ConfigCustomFields), ',') + ' FROM ' +strConfigObjName;
            System.debug('strConfigQuery'+strConfigQuery);
            System.debug('strConfig'+strConfig);
            String strConfigCond = strConfig;
            if(strConfigCond == 'PS')
            {
                strConfigCond = 'SPECIAL';
            }
            List<sobject> conRec=Database.query(strConfigQuery+' WHERE Configurator__c=\''+strConfigCond+'\'');
            integer maxFieldCount=ConfigCustomFields.size()-(14);
            Map<string,string> mapObjFields=new Map<String,String>();
            String assypartRecordPartNumber = '';
            if(mapObjectwithConfigurator.get(sObjName)=='PS') {

                assypartRecordPartNumber = (String) sObj.get('Part_Number_backend__c');
            }
            System.debug('&*&*&* assypartRecordPartNumber = '+assypartRecordPartNumber);
            if((mapObjectwithConfigurator.get(sObjName)=='PS' && String.isBlank(assypartRecordPartNumber)) || mapObjectwithConfigurator.get(sObjName) != 'PS')
            {
                AssyPartDefinition__c sObjt=new AssyPartDefinition__c();
                string ASSYPARTNOSEQ;
                string ASSYPARTNOBASE;
                string ASSYPARTNO;
                //Check If Already have the Configuration......................
                result resPART=generatePartNumber(sObj);
                System.debug('resPART: ' + resPART);
                if(resPART.bResult) {
                    ASSYPARTNO=resPART.strRetValue;
                    ASSYPARTNOBASE=resPART.strRetValue2;
                } else {
                    return resPART;
                }

                System.debug('ASSYPARTNO: ' + ASSYPARTNO);
                System.debug('ASSYPARTNOBASE: ' + ASSYPARTNOBASE);
                sObjt.ASSYPARTNO__c=ASSYPARTNO;
                sObjt.Configurator__c=strConfig;
                system.debug('sObjt.ASSYPARTNO__c' +sObjt.ASSYPARTNO__c);
                strPartObjName='AssyPartDefinition__c';
                PartObjFields = Schema.getGlobalDescribe().get(strPartObjName).getDescribe().fields.getMap();
                partFieldNames = PartObjFields.keySet();
                partCustomFields=new set <String>();
                for(String str1:partFieldNames)
                {
                    if(str1.endsWith('__c'))
                        partCustomFields.add(str1);
                }
                string strPartQuery=' SELECT id,'+ string.join(new List<String>(partCustomFields), ',') + ' FROM ' +strPartObjName;
                List<sobject> lstAssyBase = new List<sobject>();
                //modified by Ashim to exclude picking records associated with "SPECIAL"
                String notSplConfig = 'SPECIAL';
                if(!Test.isRunningTest()) {
                   // System.debug('strPartQuery'+strPartQuery+' WHERE Configurator__c !=');
                   strPartQuery+=' WHERE Configurator__c !=\'SPECIAL\' AND ASSYPARTNO__c LIKE\'%'+ASSYPARTNOBASE+'%\'';
                    lstAssyBase = Database.query(strPartQuery);
                } else {

                    lstAssyBase = Database.query(strPartQuery+' LIMIT 1');

                }
                //sObject[] res=Database.countQuery (seqQuery);
                //integer seq=Database.countQuery(seqQuery)+1;
                system.debug('sObjName'+sObjName);
                system.debug('sObjName'+sObjName);
                if(mapObjectwithConfigurator.get(sObjName)=='BGR')
                    mapObjFields=mapBGRFields;
                else if (mapObjectwithConfigurator.get(sObjName)=='RLFVLV')
                    mapObjFields=mapRVFields;
                else if (mapObjectwithConfigurator.get(sObjName)=='WGB')
                    mapObjFields=mapWGBFields;
                else if (mapObjectwithConfigurator.get(sObjName)=='FlameProducts')
                    mapObjFields=mapFAFields;
                else if (mapObjectwithConfigurator.get(sObjName)=='DISC')
                    mapObjFields=mapRDFields;
                else if (mapObjectwithConfigurator.get(sObjName)=='PS')
                    mapObjFields=mapPSFields;
                else if (mapObjectwithConfigurator.get(sObjName)=='HLD')
                    mapObjFields=mapHLDFields;
                else
                    mapObjFields.put('test','test');
                boolean isConfigFound=true;
                if(lstAssyBase.size()<=0 || lstAssyBase.isEmpty())
                {
                    isConfigFound=false;
                }
                System.debug('conRec: ' + conRec);
                System.debug('conRec: ' + isConfigFound);
                System.debug('lstAssyBase: ' + lstAssyBase);
                if(mapObjectwithConfigurator.get(sObjName) != 'PS')
                {
                    system.debug('cheeking value');
                    for (sObject obj:conRec)
                    {
                        for(sObject assyRec:lstAssyBase)
                        {
                            isConfigFound=true;
                            for(integer i=1;i<=maxFieldCount;i++)
                            {
                                string strDetailCol='field'+i+'__c';
                                System.debug('strDetailCol: ' + strDetailCol);
                                System.debug('ConfigCustomFields: ' + ConfigCustomFields);
                                System.debug('partCustomFields: ' + partCustomFields);

                                if (ConfigCustomFields.contains(strDetailCol) && partCustomFields.contains(strDetailCol)) {
                                    //Check Logic
                                    system.debug('PartNumber Check Logic Trsn FieldName'+strDetailCol);
                                    System.debug('PartNumber Check Logic Trsn Key Value'+(string) obj.get(strDetailCol));
                                    String pdObjFieldName=mapObjFields.get((string) obj.get(strDetailCol));
                                    if(mapObjFields.containsKey((string) obj.get(strDetailCol))) {
                                        Schema.DisplayType fielddataType = sObjFields.get(mapObjFields.get((string) obj.get(strDetailCol))).getDescribe().getType();
                                        System.debug('CheckP '+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+'  DataType+'+fielddataType);
                                        if (fielddataType  != Schema.DisplayType.DOUBLE && fielddataType!=Schema.DisplayType.BOOLEAN) {
                                            if ((string) assyRec.get(strDetailCol)!= (string) sObj.get(pdObjFieldName)) {
                                                isConfigFound=false;
                                                System.debug('AAAAAAAAA----'+(String) assyRec.get('ASSYPARTNO__c')+' ASSY  Rec Value' +(string) assyRec.get(strDetailCol)+' Record Value' + (string) sObj.get(pdObjFieldName) +' ');
                                                System.debug('CheckP Broke @'+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                                break;
                                            }
                                        }
                                        else if(fielddataType!=Schema.DisplayType.BOOLEAN){
                                            if ((string) assyRec.get(strDetailCol)!= string.ValueOf((decimal) sObj.get(pdObjFieldName))) {
                                                isConfigFound=false;
                                                System.debug('AAAAAAAAA----'+(String) assyRec.get('ASSYPARTNO__c')+' ASSY  Rec Value' +(string) assyRec.get(strDetailCol)+' Record Value' + string.ValueOf((decimal) sObj.get(pdObjFieldName)) +' ');
                                                System.debug('CheckP Break Point 2 @'+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                                break;
                                            }
                                        }
                                        else {
                                            if ((string) assyRec.get(strDetailCol)!= string.ValueOf((Boolean) sObj.get(pdObjFieldName))) {
                                                isConfigFound=false;
                                                System.debug('AAAAAAAAA----'+(String) assyRec.get('ASSYPARTNO__c')+' ASSY  Rec Value' +(string) assyRec.get(strDetailCol)+' Record Value' + string.ValueOf((Boolean) sObj.get(pdObjFieldName)) +' ');
                                                System.debug('CheckP Break Point 2 @'+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                                break;
                                            }
                                        }
                                        System.debug('CheckP is Done for  '+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol)+' ConfigFound '+isConfigFound);
                                    }
                                    System.debug('CheckP is Done 2 for  '+(String) assyRec.get('ASSYPARTNO__c')+' @ Field'+(string) obj.get(strDetailCol));
                                }

                            }
                            System.debug('CheckP is Done for All  '+(String) assyRec.get('ASSYPARTNO__c')+' ConfigFound '+isConfigFound);
                            if(isConfigFound) {
                                System.debug('PartNumber Found Matched : ' + (String) assyRec.get('ASSYPARTNO__c'));
                                sObj.put('Part_Number__c',(String) assyRec.get('ASSYPARTNO__c'));
                                sObj.put('PARTREV__c',(String) assyRec.get('PartRevision__c'));
                                quoteLine.put('PARTNUMBER__c',(String) assyRec.get('ASSYPARTNO__c'));
                                break;
                            }
                            else {
                                System.debug('PartNumber Found Not Matched : ' + (String) assyRec.get('ASSYPARTNO__c'));
                                continue;
                            }

                        }
                    }

                }
                System.debug('isConfigFound: ' + isConfigFound);
                if(!isConfigFound || mapObjectwithConfigurator.get(sObjName) == 'PS' || ((boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))))) {
                    sObjt.Brand__c=strBrand;
                    sObjt.Product_Ref__c=mapObjectwithConfigurator.get(sObjName);
                    //if(!(boolean) sObj.get('Quote_Description_Engineer_Override__c')) {
                    System.debug('isConfigFound 2: ' + isConfigFound);
                    for (sObject obj:conRec) {
                        for (integer i=1;i<=maxFieldCount;i++) {
                            string strDetailCol='field'+i+'__c';
                            System.debug('strDetailCol: ' + strDetailCol);
                            if (ConfigCustomFields.contains(strDetailCol)) {
                                System.debug('ConfigCustomFields'+strDetailCol);
                                System.debug('Config Field Val--->'+(string) obj.get(strDetailCol));
                                //System.debug('mapObjFields--->'+mapObjFields);
                                if(mapObjFields.containsKey((string) obj.get(strDetailCol))) {
                                    //System.debug('Setting the Vals'+mapBGRFields.get(strDetailCol));
                                    System.debug('Setting the Vals For-->'+mapObjFields.get((string) obj.get(strDetailCol)));

                                    Schema.DisplayType fielddataType = sObjFields.get(mapObjFields.get((string) obj.get(strDetailCol))).getDescribe().getType();
                                    if (fielddataType  != Schema.DisplayType.DOUBLE && fielddataType!=Schema.DisplayType.BOOLEAN) {
                                        sObjt.put(strDetailCol,(string) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))));
                                        System.debug('Setting the Vals-->'+(string) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))));
                                    } else if(fielddataType!=Schema.DisplayType.BOOLEAN) {
                                        sObjt.put(strDetailCol,string.ValueOf((decimal) sObj.get(mapObjFields.get((string) obj.get(strDetailCol)))));
                                        System.debug('Setting the Vals-->'+(decimal) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))));
                                    } else {
                                        sObjt.put(strDetailCol,(Boolean) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))) +'');
                                        System.debug('Setting the Vals-->'+(Boolean) sObj.get(mapObjFields.get((string) obj.get(strDetailCol))));
                                    }
                                }
                            }
                        }
                    }
                    if(!(boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName)))) {
                        sObjt.Managed_In__c='Salesforce';
                        sObjt.PartRevision__c='1';
                    }  else {
                        sObjt.Managed_In__c='IFS';
                        sObjt.PartRevision__c='1';
                        sObjt.Configurator__c='SPECIAL';
                        //strConfig='CATALOG';
                        //strConfig='SPECIAL';
                    }
                    System.debug('isConfigFound 2: ' + ASSYPARTNO);
                    /*
    if(mapObjectwithConfigurator.get(sObjName)=='PS' && (boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))) && (quoteLine.isIFSManaged__c == false || quoteLine.isIFSManaged__c == true))
    {
    System.debug('isConfigFound 1: ');
    upsert sObjt;
    AssyPartDefinition__c assy=[select id,name,ASSYPARTNO__c from AssyPartDefinition__c where Id=:sObjt.id];
    system.debug('$$$$$$$$$$$'+assy);
    }
    else if(mapObjectwithConfigurator.get(sObjName)=='PS' && ((string) sObj.get('NEWSPCLPARTNOBASE__c') !=null || (string) sObj.get('NEWSPCLPARTNOBASE__c') !='None') && (boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))))
    {
    System.debug('isConfigFound 2: ');
    upsert sObjt;
    }
    else if(mapObjectwithConfigurator.get(sObjName)!='PS')
    {
    System.debug('isConfigFound 3: ');
    upsert sObjt;
    }
    */
                    sObj.put('Part_Number__c',ASSYPARTNO);
                    quoteLine.put('PARTNUMBER__c',ASSYPARTNO);
                }
                //Check will Ends Here...........................................
                Boolean needRecordUpsert = true;
                if(mapObjectwithConfigurator.get(sObjName) == 'PS')
                {
                    List<AssyPartDefinition__c> existingAssyPartRecord = new List<AssyPartDefinition__c>();
                    existingAssyPartRecord = [SELECT Id,ASSYPARTNO__c FROM  AssyPartDefinition__c WHERE ASSYPARTNO__c =:ASSYPARTNO ];
                    System.debug('PPP ASSYPARTNO = '+ASSYPARTNO+', existing date = '+existingAssyPartRecord);
                    if(existingAssyPartRecord.size() > 0)
                    {
                        needRecordUpsert = false;
                    }
                }
                System.debug('PPP needRecordUpsert = '+needRecordUpsert );
                if(needRecordUpsert == true)
                {
                    if(mapObjectwithConfigurator.get(sObjName) == 'PS' && (boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName))))
                    {
                        sObj.put('Part_Number_backend__c',sObjt.ASSYPARTNO__c);
                        upsert sObjt;

                    }

                    if(mapObjectwithConfigurator.get(sObjName) != 'PS' && (isConfigFound == false || (boolean) sObj.get(mapQuoteNo.get(mapObjectwithConfigurator.get(sObjName)))))
                    {
                        upsert sObjt;
                    }
                    //sObj.put('Part_Number_backend__c',sObjt.ASSYPARTNO__c);
                    update sObj;
                }

                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@FinalPARTNUMBER: ' + sObj);
                //update quoteLine;
                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@FinalPARTNUMBER: ' +(String) sObj.get('Part_Number__c'));
                resPartData.bResult=true;
            }
        }
        catch (Exception e) {
            System.debug('Final sObj'+e.getMessage());
            resPartData.bResult=false;
            //resPartData.strErrorMessage=e.getMessage();
        }
        return resPartData;
    }
}