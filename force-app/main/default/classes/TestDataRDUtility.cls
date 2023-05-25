@isTest
public class TestDataRDUtility {
    public static SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
    public static SBQQ__Quote__c quote = new SBQQ__Quote__c();
    public static Rupture_Disc__c conProd = new Rupture_Disc__c();
    public static Map<String, String> mapWithRDValues = new Map<String, String>();
    public static List<Id> lstRDMBIds = new List<Id>();
    public static List<Derate_Value__c> lstDerateVal = new List<Derate_Value__c>();
    public static List<RD_tblMfgData__c> RDtblMfgDataTable = new List<RD_tblMfgData__c>();
    public static List<Girdle_Lim_Check__c>  lstGirdleLimCheck = new List<Girdle_Lim_Check__c> ();
    public static List<Manufacturing_Range_Value__c>  lstManufacturingRangeValue = new List<Manufacturing_Range_Value__c> ();
    public static List<Disc_Information__c> lstDiscInformation = new List<Disc_Information__c>();
    public static List<RD_ShopRangeValues__c> lstShopRngValue = new List<RD_ShopRangeValues__c>();
    public static List<RD_tblBurstTolMethod__c> lstRDtblBurstTolMeth = new List<RD_tblBurstTolMethod__c>();

    public static void createRDTestRecords1(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 232.0608000000;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 160;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Withstand__c = 'No Requirements';
        conProd.Is_there_a_liquid_relief_scenario__c = 'No';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Converted_Temperature_Setting__c = 160.00;
        conProd.Converted_Pressure_Setting__c = 232.0608000000;

        //Section-C Certifications
        conProd.CSA_Marking_CRN_Number__c = false;
        conProd.ASME_Section_VIII_Division_1__c = true;
        conProd.KOSHA_Compliance__c = false;
        conProd.CU_TR__c = true;
        conProd.X3A_Sanitary_Standards__c = false;
        conProd.Comply_with_AD2000_Merkblat_A1__c = false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = false;
        conProd.Atex_Certificate__c = false;
        conProd.NACE__c = 'N';
        conProd.PED_2014_68_EU_CE_mark__c = 'NonePED';
        conProd.China_Manufacturing_License__c = 'NoneCML';

        //Section-D - Product Narrowing
        conProd.Non_Fragmenting_Design_Required__c = false;
        conProd.Operating_Pressure_Ratio__c = 'OPRNone';
        conProd.Application_type__c = 'Industrial';
        conProd.Disc_Material_of_Construction__c = '';

        //Section-E - Product Selection
        conProd.Product__c = 'HPN';
        conProd.Size__c = '400';
        conProd.Seat__c = 'FS';

        //Section-F - Holders Details
        conProd.Pressure_Class__c = 'N/A';
        conProd.Inlet_Connection__c = 'N';
        conProd.Outlet_Connection__c = 'N';

        //Section-G - Rating and Range Properties
        conProd.Quantity__c = 4;
        conProd.Pressure_Rating_Type__c = 'Rated';
        conProd.Pressure_Range_Type__c = '-5% (-2.5 Psig)';

        //Section-H - Components
        conProd.Final_Assembly_Location_Requirements__c = '00';
        conProd.Material_Sourcing_Requirements__c = '00';
        conProd.Material_Outlet_Ring__c = '007';
        conProd.Material_Disc__c = '007';

        //Section-I - Cleanings,Tests and Processes
        conProd.Cleanings__c = 'N';
        conProd.Customer_Specific_Requirements__c = 'N';
        conProd.Part_Number__c='V7658A0312335ARTT00002';
        insert conProd;

        conProd = [SELECT MNFA_for_Calculations__c,
            pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
            coefficient_of_discharge__c, compressibility_factor__c, converted_different_temperature_setting__c, converted_back_pressure_value__c,
            converted_density__c, converted_positive_pressure_value__c, converted_pressure_setting__c, converted_relieving_pressure_value__c,
            converted_temperature_setting__c, converted_vacuum_setting__c, converted_viscosity__c, density__c, density_units__c, enter_different_temperature_units__c,
            enter_different_temperature_value__c, enter_relieving_pressure_units__c, enter_relieving_pressure_value__c, evaluation_per__c,
            evaluation_type__c, flow_area__c, constrain_product_selection_by_flow__c, media_type__c, molecular_weight__c, positive_pressure_units__c,
            positive_pressure_value__c, pressure_relieving_temperature__c, pressure_setting_units__c, pressure_withstand__c, ratio_of_specific_heats__c,
            relief_type__c, relieving_pressure_at_inlet__c, required_flow_rate__c, required_flow_units__c, specific_gravity__c, temperature_setting__c,
            temperature_setting_units__c, vacuum_setting__c, vacuum_setting_units__c, vacuum_withstand__c, viscosity__c, viscosity_units__c,
            quote_line__c, ped_2014_68_eu_ce_mark__c, china_manufacturing_license__c, size_units__c, nace__c, atmospheric_pressure__c, bypass__c,
            is_there_a_liquid_relief_scenario__c, saturation_pressure_at_inlet_temperature__c, constrain_product_selection__c, asme_section_viii_division_1__c,
            csa_marking_crn_number__c, kosha_compliance__c, asme_bpe__c, cu_tr__c, x3a_sanitary_standards__c, comply_with_ad2000_merkblat_a1__c,
            comply_with_regels_voor_tosellan_oder_dr__c, non_fragmenting_design_required__c, operating_pressure_ratio__c, temperature_ambient__c,
            metal_derate__c, derate_teflon__c, saturation_pressure_at_inlet_temp_units__c, liquid_density__c, latent_heat_of_vaporization__c,
            liquid_specific_heat__c, stagnation_gas_partial_pressure__c, vapor_pres_correspond_to_stagnation_temp__c, stagnation_vapor_density__c,
            isentropic_coefficient_gas__c, isentropic_coefficient_vapor__c, molecular_weight_gas__c, molecular_weight_vapor__c, stagnation_gas_vapor_quality__c,
            engineering_notes__c, discountable_price__c, non_discountable_price__c, size__c, part_number__c, required_flow_capacity_units__c,
            required_flow_capacity_value__c, rupture_disc_flow_capacity_units__c, burst_pressure__c, rupture_disc_flow_capacity_value__c,
            pressure_value_at_discharge__c, pressure_at_discharge_units__c, specfic_weight_of_water_at_inlet_condtns__c, specific_units_of_water_at_inlet_condtns__c,
            flow_rate_units__c, temperature_units__c, pressure_units__c, relieving_temperature_value__c, process_media__c, customer_specified_media__c,
            quantity__c, performance_tolerance_input_units__c, pressure_class__c, special_range_min_input__c, special_range_max_input__c, press_burst_pressure_min_input__c,
            press_burst_pressure_max_input__c, relief_flag__c, sizing_flag__c, pressure_rating_type__c, pressure_range_type__c, performance_tolerance_min_input__c,
            performance_tolerance_max_input__c, vac_rating_type__c, vac_range_type__c, vac_special_range_min_input__c, vac_special_range_max_input__c,
            vac_burst_press_max_input__c, vac_burst_press_min_input__c, converted_flow_rate__c, conv_specificvolume_at_90_inlet_pressur__c,
            vac_special_range_units__c, vac_burst_pressure_units__c, vac_performance_tolerance_units__c, vac_performance_tolerance_min_input__c,
            vac_performance_tolerance_max_input__c, relieving_temperaturerelieving_temperatu__c, add_integral_bdi_integral_bdi_flx_sensor__c,
            united_states_hts_code__c, sourcing_constraints__c, disc_material_of_construction__c, application_type__c, material_of_inlet_ring__c,
            optional_components__c, required_components__c, material_of_inlet_liner__c, material_of_outlet_ring__c, material_of_integral_bdi__c,
            material_of_seal__c, material_of_girdle__c, material_of_inlet_gasket__c, material_of_top_section__c, material_of_outlet_gasket__c,
            material_of_outlet_coating__c, material_of_inlet_coating__c, material_of_handling_support__c, material_of_vacuum_support__c, material_of_outlet__c,
            material_of_holddown_ring__c, material_of_inlet__c, material_of_outlet_liner__c, material_of_disc__c, material_of_armor_ring__c,
            material_of_hi_temp_assembly__c, material_of_arcuate_ring__c, material_of_girdle_cover__c, material_of_inlet_o_ring__c, material_of_knifeblade__c,
            material_of_middle_ring__c, material_of_gasket__c, converted_specific_volume__c, material_of_armor_ring2__c, material_of_dent_protector__c,
            material_of_seal2__c, cable_length__c, material_of_top_section2__c, temperature_test_per_asme__c, x2w_nis__c, x4w_nis__c, cleanings__c,
            inlet_connection__c, individual_packaging__c, pmi__c, halogen_based_restrictions_for_cleaning__c, outlet_connection__c, electro_polish__c,
            add_integral_b_d_i_integral_bdi_flx_sen__c, hydrotest__c, atex_certificate__c, gas_group__c, zone_0_2__c, product__c, seat__c, capacity__c,
            product_selection__c, special_range_units__c, converted_relieving_temperature__c, specific_volume__c, specific_volume_units__c, specific_volume_at_90_of_inlet_pressure__c,
            specific_volume_at_90_of_inlet_units__c, reference_mfg_range_type__c, dscvar__c, press_burst_pressure_units__c, vac_reference_mfg_range_type__c,
            deratetype__c, atmospheric_pressure_units__c, converted_atmospheric_pressure__c, final_assembly_location_requirements__c, material_sourcing_requirements__c,
            mnfa__c, to_make_with_bdi_flx_interface_cable__c, shell_test__c, surface_finish__c, packaging_material__c, mark_pack_clean__c, customer_specific_requirements__c,
            reach__c, rohs__c, dodd_frank_conflict_minerals__c, general_environmental_compliance__c, animal_derivative__c, coshh__c, sanitary_requirements_fda_requirements__c,
            nist_calibrated_equipment__c, certificate_of_origin__c, strip_type__c, gasket_material__c, wiring_configuration__c, wire_type__c,
            end_connection__c, material_of_seal3__c, material_of_inlet_ring2__c, material_of_vacuum_support2__c, material_of_inlet_coating2__c,
            material_of_inlet_ring3__c, material_of_vaccum_support3__c, required_flow_area_units__c, build_cost_override__c, specific_gravity_units__c,
            specific_volume_at_inlet__c, specific_volume_at_inlet_units__c, density_at_inlet__c, density_at_inlet_units__c, density_at_90_of_saturation_pressure__c,
            density_at_90_saturation_pressure_units__c, liquid_density_units__c, stagnation_vapor_density_units__c, diagram_override__c, drawing_outside_config__c,
            density_specific_volume_specific_gravity__c, density_specificvolume_spcfcgravityunits__c, finish_configuration_flag__c, assypartexisting__c,
            assigned_rangetype__c, rg3drt__c, tmr__c, rg2max__c, isconfigfinished__c, price_override__c, lead_time_override__c, quote_descriptions_override__c,
            additional_documents__c, output_required_flow_area__c, converted_specific_volume_at_inlet__c, converted_density_at_inlet__c, converteddensity_at_90saturationpressure__c,
            convertedspecificvolumeat90_ofinletpress__c, rating_and_range_flag__c, product_narrowing_flag__c, convertedsaturationpressure_at_inlettemp__c,
            converted_liquid_density__c, liquid_density_at_inlet__c, liquid_density_at_inlet_units__c, converted_liquid_density_at_inlet__c, converted_stagnation_vapor_density__c,
            stagnation_gas_partial_pressure_units__c, vapor_pres_to_stagnation_temp_units__c, vacrequired_flow_rate__c, vacrequired_flow_rate_units__c,
            vacconverted_flow_rate__c, vacmedia__c, vacpressure_relieving_temperature__c, vacenter_different_temperature_value__c, vacenter_different_temperature_units__c,
            vacconverted_different_temp_setting__c, vacflow_area__c, vacrequired_flow_area_units__c, vacrequired_flow_area__c, vacproduct_flow_capacity_units__c,
            converted_density_speci_volume_spegravit__c, inlet_option_code__c, outlet_option_code__c, asme_inlet_option_code__c, asme_outlet_option_code__c,
            assypartnobase__c, partrev__c, rgemin__c, vg2min__c, rg2min__c, rgsmin__c, vgsmin__c, rgemax__c, convvapor_pres_corres_to_stagnation_temp__c,
            converted_stagnation_gaspartial_pressure__c, disc_thickness__c, material_arcuate_ring__c, material_armor_ring2__c, material_armor_ring__c,
            material_dent_protector__c, material_disc__c, material_gasket__c, material_girdle_cover__c, material_girdle__c, material_handling_support__c,
            material_holddown_ring__c, material_inlet_coating2__c, material_inlet_coating__c, material_inlet_gasket__c, material_inlet_liner__c,
            material_inlet_o_ring__c, material_inlet_ring2__c, material_inlet_ring3__c, material_inlet_ring__c, material_inlet__c, material_integral_bdi__c,
            material_knifeblade__c, material_middle_ring__c, material_outlet_coating__c, material_outlet_gasket__c, material_outlet_liner__c,
            material_outlet_ring__c, material_outlet__c, material_seal2__c, material_seal3__c, material_seal__c, material_top_section2__c, material_top_section__c,
            material_vaccum_support3__c, material_vacuum_support2__c, material_vacuum_support__c, metalseal_thickness__c, newspclpartnobase__c,
            product_flow_capacity_value__c, topsection_thickness__c, vacflow_capacity_value__c, vacproduct_flow_capacity_value__c, vac_converted_vac_setting__c,
            components_flag__c, vtmr__c, vassignedrangetype__c, vg3drt__c, rgsmax__c, mcsm__c, bmrcheck__c, tmrcheck__c, rg1min__c, rg1max__c,
            rg3min__c, rg3max__c, vgsmax__c, vg1min__c, vg1max__c, vg2max__c, vg3min__c, vg3max__c, vgemin__c, vgemax__c, edit_quoteline__c
        FROM   rupture_disc__c];

        RD_Outputs__c rdOut=new RD_Outputs__c();
        rdOut.RD_Outputs_Relation_Field__c=conProd.id;
        insert rdOut;
        RD_Drawings__c rdDia=new RD_Drawings__c();
        rdDia.Rupture_Disc__c=conProd.id;
        rdDia.Dim_A__c='test';
        rdDia.Dim_B_Override__c='test';
        rdDia.Dim_B__c='test';
        rdDia.Dim_C_Override__c='test';
        rdDia.Dim_C__c='test';
        rdDia.Dim_D_Override__c='test';
        rdDia.Dim_D__c='test';
        rdDia.Dim_E_Override__c='test';
        rdDia.Dim_E__c='test';
        rdDia.Dim_F_Override__c='test';
        rdDia.Dim_F__c='test';
        insert rdDia;

        RD_Pricing__c RDPrice=new RD_Pricing__c();
        RDPrice.Rupture_Disc__c=conProd.id;
        insert RDPrice;
    }

    public static void createRDTestRecords2(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Pressure & Vacuum Relief';
        conProd.Pressure_Setting__c = 7;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Vacuum_Setting__c = 7;
        conProd.Vacuum_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 72;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Converted_Temperature_Setting__c = 72.00;
        conProd.Converted_Pressure_Setting__c = 7.00;
        conProd.Converted_Vacuum_Setting__c = 7.00;

        //Section-C Certifications
        conProd.CSA_Marking_CRN_Number__c = false;
        conProd.ASME_Section_VIII_Division_1__c = false;
        conProd.KOSHA_Compliance__c = false;
        conProd.CU_TR__c = true;
        conProd.X3A_Sanitary_Standards__c = false;
        conProd.Comply_with_AD2000_Merkblat_A1__c = false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = false;
        conProd.Atex_Certificate__c = false;
        conProd.NACE__c = 'N';
        conProd.PED_2014_68_EU_CE_mark__c = 'NonePED';
        conProd.China_Manufacturing_License__c = 'NoneCML';

        //Section-D - Product Narrowing
        conProd.Non_Fragmenting_Design_Required__c = false;
        conProd.Operating_Pressure_Ratio__c = 'OPRNone';
        conProd.Application_type__c = 'Industrial';
        conProd.Disc_Material_of_Construction__c = '';

        //Section-E - Product Selection
        conProd.Product__c = 'EV2';
        conProd.Size__c = '1000';
        conProd.Seat__c = 'D1';

        //Section-F - Holders Details
        conProd.Pressure_Class__c = 'N/A';
        conProd.Inlet_Connection__c = 'N';
        conProd.Outlet_Connection__c = 'N';

        //Section-G - Rating and Range Properties
        conProd.Quantity__c = 3;
        conProd.Pressure_Rating_Type__c = 'Rated';
        conProd.Pressure_Range_Type__c = 'Special';
        conProd.Special_Range_Min_Input__c = 5;
        conProd.Special_Range_Max_Input__c = 7;
        conProd.Vac_Rating_Type__c = 'Start/Full Relief (Min/Max)';

        //Section-H - Components
        conProd.Final_Assembly_Location_Requirements__c = '00';
        conProd.Material_Sourcing_Requirements__c = '00';
        conProd.Material_Top_Section__c = '005';
        conProd.Material_Seal__c = '070';
        conProd.Material_Girdle__c = '070';
        conProd.Material_Inlet_Gasket__c = '';

        //Section-I - Cleanings,Tests and Processes
        conProd.Cleanings__c = 'N';
        conProd.Customer_Specific_Requirements__c = 'N';
        insert conProd;

        conProd = [SELECT MNFA_for_Calculations__c,
            pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
            coefficient_of_discharge__c, compressibility_factor__c, converted_different_temperature_setting__c, converted_back_pressure_value__c,
            converted_density__c, converted_positive_pressure_value__c, converted_pressure_setting__c, converted_relieving_pressure_value__c,
            converted_temperature_setting__c, converted_vacuum_setting__c, converted_viscosity__c, density__c, density_units__c, enter_different_temperature_units__c,
            enter_different_temperature_value__c, enter_relieving_pressure_units__c, enter_relieving_pressure_value__c, evaluation_per__c,
            evaluation_type__c, flow_area__c, constrain_product_selection_by_flow__c, media_type__c, molecular_weight__c, positive_pressure_units__c,
            positive_pressure_value__c, pressure_relieving_temperature__c, pressure_setting_units__c, pressure_withstand__c, ratio_of_specific_heats__c,
            relief_type__c, relieving_pressure_at_inlet__c, required_flow_rate__c, required_flow_units__c, specific_gravity__c, temperature_setting__c,
            temperature_setting_units__c, vacuum_setting__c, vacuum_setting_units__c, vacuum_withstand__c, viscosity__c, viscosity_units__c,
            quote_line__c, ped_2014_68_eu_ce_mark__c, china_manufacturing_license__c, size_units__c, nace__c, atmospheric_pressure__c, bypass__c,
            is_there_a_liquid_relief_scenario__c, saturation_pressure_at_inlet_temperature__c, constrain_product_selection__c, asme_section_viii_division_1__c,
            csa_marking_crn_number__c, kosha_compliance__c, asme_bpe__c, cu_tr__c, x3a_sanitary_standards__c, comply_with_ad2000_merkblat_a1__c,
            comply_with_regels_voor_tosellan_oder_dr__c, non_fragmenting_design_required__c, operating_pressure_ratio__c, temperature_ambient__c,
            metal_derate__c, derate_teflon__c, saturation_pressure_at_inlet_temp_units__c, liquid_density__c, latent_heat_of_vaporization__c,
            liquid_specific_heat__c, stagnation_gas_partial_pressure__c, vapor_pres_correspond_to_stagnation_temp__c, stagnation_vapor_density__c,
            isentropic_coefficient_gas__c, isentropic_coefficient_vapor__c, molecular_weight_gas__c, molecular_weight_vapor__c, stagnation_gas_vapor_quality__c,
            engineering_notes__c, discountable_price__c, non_discountable_price__c, size__c, part_number__c, required_flow_capacity_units__c,
            required_flow_capacity_value__c, rupture_disc_flow_capacity_units__c, burst_pressure__c, rupture_disc_flow_capacity_value__c,
            pressure_value_at_discharge__c, pressure_at_discharge_units__c, specfic_weight_of_water_at_inlet_condtns__c, specific_units_of_water_at_inlet_condtns__c,
            flow_rate_units__c, temperature_units__c, pressure_units__c, relieving_temperature_value__c, process_media__c, customer_specified_media__c,
            quantity__c, performance_tolerance_input_units__c, pressure_class__c, special_range_min_input__c, special_range_max_input__c, press_burst_pressure_min_input__c,
            press_burst_pressure_max_input__c, relief_flag__c, sizing_flag__c, pressure_rating_type__c, pressure_range_type__c, performance_tolerance_min_input__c,
            performance_tolerance_max_input__c, vac_rating_type__c, vac_range_type__c, vac_special_range_min_input__c, vac_special_range_max_input__c,
            vac_burst_press_max_input__c, vac_burst_press_min_input__c, converted_flow_rate__c, conv_specificvolume_at_90_inlet_pressur__c,
            vac_special_range_units__c, vac_burst_pressure_units__c, vac_performance_tolerance_units__c, vac_performance_tolerance_min_input__c,
            vac_performance_tolerance_max_input__c, relieving_temperaturerelieving_temperatu__c, add_integral_bdi_integral_bdi_flx_sensor__c,
            united_states_hts_code__c, sourcing_constraints__c, disc_material_of_construction__c, application_type__c, material_of_inlet_ring__c,
            optional_components__c, required_components__c, material_of_inlet_liner__c, material_of_outlet_ring__c, material_of_integral_bdi__c,
            material_of_seal__c, material_of_girdle__c, material_of_inlet_gasket__c, material_of_top_section__c, material_of_outlet_gasket__c,
            material_of_outlet_coating__c, material_of_inlet_coating__c, material_of_handling_support__c, material_of_vacuum_support__c, material_of_outlet__c,
            material_of_holddown_ring__c, material_of_inlet__c, material_of_outlet_liner__c, material_of_disc__c, material_of_armor_ring__c,
            material_of_hi_temp_assembly__c, material_of_arcuate_ring__c, material_of_girdle_cover__c, material_of_inlet_o_ring__c, material_of_knifeblade__c,
            material_of_middle_ring__c, material_of_gasket__c, converted_specific_volume__c, material_of_armor_ring2__c, material_of_dent_protector__c,
            material_of_seal2__c, cable_length__c, material_of_top_section2__c, temperature_test_per_asme__c, x2w_nis__c, x4w_nis__c, cleanings__c,
            inlet_connection__c, individual_packaging__c, pmi__c, halogen_based_restrictions_for_cleaning__c, outlet_connection__c, electro_polish__c,
            add_integral_b_d_i_integral_bdi_flx_sen__c, hydrotest__c, atex_certificate__c, gas_group__c, zone_0_2__c, product__c, seat__c, capacity__c,
            product_selection__c, special_range_units__c, converted_relieving_temperature__c, specific_volume__c, specific_volume_units__c, specific_volume_at_90_of_inlet_pressure__c,
            specific_volume_at_90_of_inlet_units__c, reference_mfg_range_type__c, dscvar__c, press_burst_pressure_units__c, vac_reference_mfg_range_type__c,
            deratetype__c, atmospheric_pressure_units__c, converted_atmospheric_pressure__c, final_assembly_location_requirements__c, material_sourcing_requirements__c,
            mnfa__c, to_make_with_bdi_flx_interface_cable__c, shell_test__c, surface_finish__c, packaging_material__c, mark_pack_clean__c, customer_specific_requirements__c,
            reach__c, rohs__c, dodd_frank_conflict_minerals__c, general_environmental_compliance__c, animal_derivative__c, coshh__c, sanitary_requirements_fda_requirements__c,
            nist_calibrated_equipment__c, certificate_of_origin__c, strip_type__c, gasket_material__c, wiring_configuration__c, wire_type__c,
            end_connection__c, material_of_seal3__c, material_of_inlet_ring2__c, material_of_vacuum_support2__c, material_of_inlet_coating2__c,
            material_of_inlet_ring3__c, material_of_vaccum_support3__c, required_flow_area_units__c, build_cost_override__c, specific_gravity_units__c,
            specific_volume_at_inlet__c, specific_volume_at_inlet_units__c, density_at_inlet__c, density_at_inlet_units__c, density_at_90_of_saturation_pressure__c,
            density_at_90_saturation_pressure_units__c, liquid_density_units__c, stagnation_vapor_density_units__c, diagram_override__c, drawing_outside_config__c,
            density_specific_volume_specific_gravity__c, density_specificvolume_spcfcgravityunits__c, finish_configuration_flag__c, assypartexisting__c,
            assigned_rangetype__c, rg3drt__c, tmr__c, rg2max__c, isconfigfinished__c, price_override__c, lead_time_override__c, quote_descriptions_override__c,
            additional_documents__c, output_required_flow_area__c, converted_specific_volume_at_inlet__c, converted_density_at_inlet__c, converteddensity_at_90saturationpressure__c,
            convertedspecificvolumeat90_ofinletpress__c, rating_and_range_flag__c, product_narrowing_flag__c, convertedsaturationpressure_at_inlettemp__c,
            converted_liquid_density__c, liquid_density_at_inlet__c, liquid_density_at_inlet_units__c, converted_liquid_density_at_inlet__c, converted_stagnation_vapor_density__c,
            stagnation_gas_partial_pressure_units__c, vapor_pres_to_stagnation_temp_units__c, vacrequired_flow_rate__c, vacrequired_flow_rate_units__c,
            vacconverted_flow_rate__c, vacmedia__c, vacpressure_relieving_temperature__c, vacenter_different_temperature_value__c, vacenter_different_temperature_units__c,
            vacconverted_different_temp_setting__c, vacflow_area__c, vacrequired_flow_area_units__c, vacrequired_flow_area__c, vacproduct_flow_capacity_units__c,
            converted_density_speci_volume_spegravit__c, inlet_option_code__c, outlet_option_code__c, asme_inlet_option_code__c, asme_outlet_option_code__c,
            assypartnobase__c, partrev__c, rgemin__c, vg2min__c, rg2min__c, rgsmin__c, vgsmin__c, rgemax__c, convvapor_pres_corres_to_stagnation_temp__c,
            converted_stagnation_gaspartial_pressure__c, disc_thickness__c, material_arcuate_ring__c, material_armor_ring2__c, material_armor_ring__c,
            material_dent_protector__c, material_disc__c, material_gasket__c, material_girdle_cover__c, material_girdle__c, material_handling_support__c,
            material_holddown_ring__c, material_inlet_coating2__c, material_inlet_coating__c, material_inlet_gasket__c, material_inlet_liner__c,
            material_inlet_o_ring__c, material_inlet_ring2__c, material_inlet_ring3__c, material_inlet_ring__c, material_inlet__c, material_integral_bdi__c,
            material_knifeblade__c, material_middle_ring__c, material_outlet_coating__c, material_outlet_gasket__c, material_outlet_liner__c,
            material_outlet_ring__c, material_outlet__c, material_seal2__c, material_seal3__c, material_seal__c, material_top_section2__c, material_top_section__c,
            material_vaccum_support3__c, material_vacuum_support2__c, material_vacuum_support__c, metalseal_thickness__c, newspclpartnobase__c,
            product_flow_capacity_value__c, topsection_thickness__c, vacflow_capacity_value__c, vacproduct_flow_capacity_value__c, vac_converted_vac_setting__c,
            components_flag__c, vtmr__c, vassignedrangetype__c, vg3drt__c, rgsmax__c, mcsm__c, bmrcheck__c, tmrcheck__c, rg1min__c, rg1max__c,
            rg3min__c, rg3max__c, vgsmax__c, vg1min__c, vg1max__c, vg2max__c, vg3min__c, vg3max__c, vgemin__c, vgemax__c, edit_quoteline__c
        FROM   rupture_disc__c];
    }

    public static void createRDTestRecords3(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 158;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 160;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Withstand__c = 'Back Pressure';
        conProd.Back_Pressure_Value__c = 160;
        conProd.Back_Pressure_Units__c = 'psig';
        conProd.Is_there_a_liquid_relief_scenario__c = 'No';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'Yes';
        conProd.Converted_Temperature_Setting__c = 160.00;
        conProd.Converted_Pressure_Setting__c = 158.00;
        conProd.Converted_Relieving_Pressure_Value__c=100;
        //Section-B Sizing/Flow Area
        conProd.Evaluation_Type__c = 'Sizing & Capacity';
        conProd.Evaluation_Per__c = 'ASME Steam';
        conProd.Process_Media__c = 'Air';
        conProd.Customer_Specified_Media__c = '';
        conProd.Molecular_Weight__c = 18.02;
        conProd.Ratio_of_Specific_Heats__c = 1.31;
        conProd.Compressibility_Factor__c = 1;
        conProd.Coefficient_of_Discharge__c = '0.62';
        conProd.Required_Flow_Rate__c = 4496;
        conProd.Required_Flow_units__c = 'lb/h';
        conProd.Relieving_Pressure_at_Inlet__c = '21%';     // conProd.Enter_Relieving_Pressure_Value__c = '';    // conProd.Enter_Relieving_Pressure_units__c = '';
        conProd.Flow_Area__c = 0.683946;
        conProd.Required_Flow_Area_Units__c = 'in2';
        conProd.MNFA_for_Calculations__c=0.007;
        //Section-C Certifications
        conProd.CSA_Marking_CRN_Number__c = false;
        conProd.ASME_Section_VIII_Division_1__c = true;
        conProd.KOSHA_Compliance__c = false;
        conProd.CU_TR__c = true;
        conProd.X3A_Sanitary_Standards__c = false;
        conProd.Comply_with_AD2000_Merkblat_A1__c = false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = false;
        conProd.Atex_Certificate__c = false;
        conProd.NACE__c = 'N';
        conProd.PED_2014_68_EU_CE_mark__c = 'NonePED';
        conProd.China_Manufacturing_License__c = 'NoneCML';

        //Section-D - Product Narrowing
        conProd.Non_Fragmenting_Design_Required__c = false;
        conProd.Operating_Pressure_Ratio__c = 'OPRNone';
        conProd.Application_type__c = '';
        conProd.Disc_Material_of_Construction__c = '';

        //Section-E - Product Selection
        conProd.Product__c = 'HPN';
        conProd.Size__c = '400';
        conProd.Seat__c = 'FS';

        //Section-F - Holders Details
        conProd.Pressure_Class__c = 'N/A';
        conProd.Inlet_Connection__c = 'N';
        conProd.Outlet_Connection__c = 'N';

        // //Section-G - Rating and Range Properties
        // conProd.Quantity__c = 4;
        // conProd.Pressure_Rating_Type__c = 'Rated';
        // conProd.Pressure_Range_Type__c = '-5% (-2.5 Psig)';

        // //Section-H - Components
        // conProd.Final_Assembly_Location_Requirements__c = '00';
        // conProd.Material_Sourcing_Requirements__c = '00';
        // conProd.Material_Outlet_Ring__c = '007';
        // conProd.Material_Disc__c = '007';

        // //Section-I - Cleanings,Tests and Processes
        // conProd.Cleanings__c = 'N';
        // conProd.Customer_Specific_Requirements__c = 'N';
        insert conProd;

        conProd = [SELECT MNFA_for_Calculations__c,
            pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
            coefficient_of_discharge__c, compressibility_factor__c, converted_different_temperature_setting__c, converted_back_pressure_value__c,
            converted_density__c, converted_positive_pressure_value__c, converted_pressure_setting__c, converted_relieving_pressure_value__c,
            converted_temperature_setting__c, converted_vacuum_setting__c, converted_viscosity__c, density__c, density_units__c, enter_different_temperature_units__c,
            enter_different_temperature_value__c, enter_relieving_pressure_units__c, enter_relieving_pressure_value__c, evaluation_per__c,
            evaluation_type__c, flow_area__c, constrain_product_selection_by_flow__c, media_type__c, molecular_weight__c, positive_pressure_units__c,
            positive_pressure_value__c, pressure_relieving_temperature__c, pressure_setting_units__c, pressure_withstand__c, ratio_of_specific_heats__c,
            relief_type__c, relieving_pressure_at_inlet__c, required_flow_rate__c, required_flow_units__c, specific_gravity__c, temperature_setting__c,
            temperature_setting_units__c, vacuum_setting__c, vacuum_setting_units__c, vacuum_withstand__c, viscosity__c, viscosity_units__c,
            quote_line__c, ped_2014_68_eu_ce_mark__c, china_manufacturing_license__c, size_units__c, nace__c, atmospheric_pressure__c, bypass__c,
            is_there_a_liquid_relief_scenario__c, saturation_pressure_at_inlet_temperature__c, constrain_product_selection__c, asme_section_viii_division_1__c,
            csa_marking_crn_number__c, kosha_compliance__c, asme_bpe__c, cu_tr__c, x3a_sanitary_standards__c, comply_with_ad2000_merkblat_a1__c,
            comply_with_regels_voor_tosellan_oder_dr__c, non_fragmenting_design_required__c, operating_pressure_ratio__c, temperature_ambient__c,
            metal_derate__c, derate_teflon__c, saturation_pressure_at_inlet_temp_units__c, liquid_density__c, latent_heat_of_vaporization__c,
            liquid_specific_heat__c, stagnation_gas_partial_pressure__c, vapor_pres_correspond_to_stagnation_temp__c, stagnation_vapor_density__c,
            isentropic_coefficient_gas__c, isentropic_coefficient_vapor__c, molecular_weight_gas__c, molecular_weight_vapor__c, stagnation_gas_vapor_quality__c,
            engineering_notes__c, discountable_price__c, non_discountable_price__c, size__c, part_number__c, required_flow_capacity_units__c,
            required_flow_capacity_value__c, rupture_disc_flow_capacity_units__c, burst_pressure__c, rupture_disc_flow_capacity_value__c,
            pressure_value_at_discharge__c, pressure_at_discharge_units__c, specfic_weight_of_water_at_inlet_condtns__c, specific_units_of_water_at_inlet_condtns__c,
            flow_rate_units__c, temperature_units__c, pressure_units__c, relieving_temperature_value__c, process_media__c, customer_specified_media__c,
            quantity__c, performance_tolerance_input_units__c, pressure_class__c, special_range_min_input__c, special_range_max_input__c, press_burst_pressure_min_input__c,
            press_burst_pressure_max_input__c, relief_flag__c, sizing_flag__c, pressure_rating_type__c, pressure_range_type__c, performance_tolerance_min_input__c,
            performance_tolerance_max_input__c, vac_rating_type__c, vac_range_type__c, vac_special_range_min_input__c, vac_special_range_max_input__c,
            vac_burst_press_max_input__c, vac_burst_press_min_input__c, converted_flow_rate__c, conv_specificvolume_at_90_inlet_pressur__c,
            vac_special_range_units__c, vac_burst_pressure_units__c, vac_performance_tolerance_units__c, vac_performance_tolerance_min_input__c,
            vac_performance_tolerance_max_input__c, relieving_temperaturerelieving_temperatu__c, add_integral_bdi_integral_bdi_flx_sensor__c,
            united_states_hts_code__c, sourcing_constraints__c, disc_material_of_construction__c, application_type__c, material_of_inlet_ring__c,
            optional_components__c, required_components__c, material_of_inlet_liner__c, material_of_outlet_ring__c, material_of_integral_bdi__c,
            material_of_seal__c, material_of_girdle__c, material_of_inlet_gasket__c, material_of_top_section__c, material_of_outlet_gasket__c,
            material_of_outlet_coating__c, material_of_inlet_coating__c, material_of_handling_support__c, material_of_vacuum_support__c, material_of_outlet__c,
            material_of_holddown_ring__c, material_of_inlet__c, material_of_outlet_liner__c, material_of_disc__c, material_of_armor_ring__c,
            material_of_hi_temp_assembly__c, material_of_arcuate_ring__c, material_of_girdle_cover__c, material_of_inlet_o_ring__c, material_of_knifeblade__c,
            material_of_middle_ring__c, material_of_gasket__c, converted_specific_volume__c, material_of_armor_ring2__c, material_of_dent_protector__c,
            material_of_seal2__c, cable_length__c, material_of_top_section2__c, temperature_test_per_asme__c, x2w_nis__c, x4w_nis__c, cleanings__c,
            inlet_connection__c, individual_packaging__c, pmi__c, halogen_based_restrictions_for_cleaning__c, outlet_connection__c, electro_polish__c,
            add_integral_b_d_i_integral_bdi_flx_sen__c, hydrotest__c, atex_certificate__c, gas_group__c, zone_0_2__c, product__c, seat__c, capacity__c,
            product_selection__c, special_range_units__c, converted_relieving_temperature__c, specific_volume__c, specific_volume_units__c, specific_volume_at_90_of_inlet_pressure__c,
            specific_volume_at_90_of_inlet_units__c, reference_mfg_range_type__c, dscvar__c, press_burst_pressure_units__c, vac_reference_mfg_range_type__c,
            deratetype__c, atmospheric_pressure_units__c, converted_atmospheric_pressure__c, final_assembly_location_requirements__c, material_sourcing_requirements__c,
            mnfa__c, to_make_with_bdi_flx_interface_cable__c, shell_test__c, surface_finish__c, packaging_material__c, mark_pack_clean__c, customer_specific_requirements__c,
            reach__c, rohs__c, dodd_frank_conflict_minerals__c, general_environmental_compliance__c, animal_derivative__c, coshh__c, sanitary_requirements_fda_requirements__c,
            nist_calibrated_equipment__c, certificate_of_origin__c, strip_type__c, gasket_material__c, wiring_configuration__c, wire_type__c,
            end_connection__c, material_of_seal3__c, material_of_inlet_ring2__c, material_of_vacuum_support2__c, material_of_inlet_coating2__c,
            material_of_inlet_ring3__c, material_of_vaccum_support3__c, required_flow_area_units__c, build_cost_override__c, specific_gravity_units__c,
            specific_volume_at_inlet__c, specific_volume_at_inlet_units__c, density_at_inlet__c, density_at_inlet_units__c, density_at_90_of_saturation_pressure__c,
            density_at_90_saturation_pressure_units__c, liquid_density_units__c, stagnation_vapor_density_units__c, diagram_override__c, drawing_outside_config__c,
            density_specific_volume_specific_gravity__c, density_specificvolume_spcfcgravityunits__c, finish_configuration_flag__c, assypartexisting__c,
            assigned_rangetype__c, rg3drt__c, tmr__c, rg2max__c, isconfigfinished__c, price_override__c, lead_time_override__c, quote_descriptions_override__c,
            additional_documents__c, output_required_flow_area__c, converted_specific_volume_at_inlet__c, converted_density_at_inlet__c, converteddensity_at_90saturationpressure__c,
            convertedspecificvolumeat90_ofinletpress__c, rating_and_range_flag__c, product_narrowing_flag__c, convertedsaturationpressure_at_inlettemp__c,
            converted_liquid_density__c, liquid_density_at_inlet__c, liquid_density_at_inlet_units__c, converted_liquid_density_at_inlet__c, converted_stagnation_vapor_density__c,
            stagnation_gas_partial_pressure_units__c, vapor_pres_to_stagnation_temp_units__c, vacrequired_flow_rate__c, vacrequired_flow_rate_units__c,
            vacconverted_flow_rate__c, vacmedia__c, vacpressure_relieving_temperature__c, vacenter_different_temperature_value__c, vacenter_different_temperature_units__c,
            vacconverted_different_temp_setting__c, vacflow_area__c, vacrequired_flow_area_units__c, vacrequired_flow_area__c, vacproduct_flow_capacity_units__c,
            converted_density_speci_volume_spegravit__c, inlet_option_code__c, outlet_option_code__c, asme_inlet_option_code__c, asme_outlet_option_code__c,
            assypartnobase__c, partrev__c, rgemin__c, vg2min__c, rg2min__c, rgsmin__c, vgsmin__c, rgemax__c, convvapor_pres_corres_to_stagnation_temp__c,
            converted_stagnation_gaspartial_pressure__c, disc_thickness__c, material_arcuate_ring__c, material_armor_ring2__c, material_armor_ring__c,
            material_dent_protector__c, material_disc__c, material_gasket__c, material_girdle_cover__c, material_girdle__c, material_handling_support__c,
            material_holddown_ring__c, material_inlet_coating2__c, material_inlet_coating__c, material_inlet_gasket__c, material_inlet_liner__c,
            material_inlet_o_ring__c, material_inlet_ring2__c, material_inlet_ring3__c, material_inlet_ring__c, material_inlet__c, material_integral_bdi__c,
            material_knifeblade__c, material_middle_ring__c, material_outlet_coating__c, material_outlet_gasket__c, material_outlet_liner__c,
            material_outlet_ring__c, material_outlet__c, material_seal2__c, material_seal3__c, material_seal__c, material_top_section2__c, material_top_section__c,
            material_vaccum_support3__c, material_vacuum_support2__c, material_vacuum_support__c, metalseal_thickness__c, newspclpartnobase__c,
            product_flow_capacity_value__c, topsection_thickness__c, vacflow_capacity_value__c, vacproduct_flow_capacity_value__c, vac_converted_vac_setting__c,
            components_flag__c, vtmr__c, vassignedrangetype__c, vg3drt__c, rgsmax__c, mcsm__c, bmrcheck__c, tmrcheck__c, rg1min__c, rg1max__c,
            rg3min__c, rg3max__c, vgsmax__c, vg1min__c, vg1max__c, vg2max__c, vg3min__c, vg3max__c, vgemin__c, vgemax__c, edit_quoteline__c
        FROM   rupture_disc__c];
    }

    public static void createRDTestRecords4(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Vacuum Relief';
        conProd.Vacuum_Setting__c = 100;
        conProd.Vacuum_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 16;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Pressure_Withstand__c = 'Positive Pressure';
        conProd.Positive_Pressure_Value__c = 60;
        conProd.Positive_Pressure_Units__c = 'psig';
        conProd.Is_there_a_liquid_relief_scenario__c = 'No';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Converted_Temperature_Setting__c = 16.00;
        conProd.Converted_Vacuum_Setting__c = 100.00;

        //Section-C Certifications
        conProd.CSA_Marking_CRN_Number__c = true;
        conProd.ASME_Section_VIII_Division_1__c = true;
        conProd.KOSHA_Compliance__c = true;
        conProd.CU_TR__c = true;
        conProd.X3A_Sanitary_Standards__c = true;
        conProd.Comply_with_AD2000_Merkblat_A1__c = true;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = true;
        conProd.Atex_Certificate__c = true;
        conProd.Gas_Group__c = 'IIA';
        conProd.Zone_0_2__c = '2';
        conProd.NACE__c = 'N';
        conProd.PED_2014_68_EU_CE_mark__c = 'NonePED';
        conProd.China_Manufacturing_License__c = 'NoneCML';

        //Section-D - Product Narrowing
        conProd.Non_Fragmenting_Design_Required__c = true;
        conProd.Operating_Pressure_Ratio__c = 'OPRNone';
        conProd.Application_type__c = '';
        conProd.Disc_Material_of_Construction__c = '';

        conProd.Product__c = 'CAL';
        conProd.Size__c = '0300';
        conProd.Seat__c = 'FS';
        insert conProd;

        conProd = [SELECT MNFA_for_Calculations__c,
            pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
            coefficient_of_discharge__c, compressibility_factor__c, converted_different_temperature_setting__c, converted_back_pressure_value__c,
            converted_density__c, converted_positive_pressure_value__c, converted_pressure_setting__c, converted_relieving_pressure_value__c,
            converted_temperature_setting__c, converted_vacuum_setting__c, converted_viscosity__c, density__c, density_units__c, enter_different_temperature_units__c,
            enter_different_temperature_value__c, enter_relieving_pressure_units__c, enter_relieving_pressure_value__c, evaluation_per__c,
            evaluation_type__c, flow_area__c, constrain_product_selection_by_flow__c, media_type__c, molecular_weight__c, positive_pressure_units__c,
            positive_pressure_value__c, pressure_relieving_temperature__c, pressure_setting_units__c, pressure_withstand__c, ratio_of_specific_heats__c,
            relief_type__c, relieving_pressure_at_inlet__c, required_flow_rate__c, required_flow_units__c, specific_gravity__c, temperature_setting__c,
            temperature_setting_units__c, vacuum_setting__c, vacuum_setting_units__c, vacuum_withstand__c, viscosity__c, viscosity_units__c,
            quote_line__c, ped_2014_68_eu_ce_mark__c, china_manufacturing_license__c, size_units__c, nace__c, atmospheric_pressure__c, bypass__c,
            is_there_a_liquid_relief_scenario__c, saturation_pressure_at_inlet_temperature__c, constrain_product_selection__c, asme_section_viii_division_1__c,
            csa_marking_crn_number__c, kosha_compliance__c, asme_bpe__c, cu_tr__c, x3a_sanitary_standards__c, comply_with_ad2000_merkblat_a1__c,
            comply_with_regels_voor_tosellan_oder_dr__c, non_fragmenting_design_required__c, operating_pressure_ratio__c, temperature_ambient__c,
            metal_derate__c, derate_teflon__c, saturation_pressure_at_inlet_temp_units__c, liquid_density__c, latent_heat_of_vaporization__c,
            liquid_specific_heat__c, stagnation_gas_partial_pressure__c, vapor_pres_correspond_to_stagnation_temp__c, stagnation_vapor_density__c,
            isentropic_coefficient_gas__c, isentropic_coefficient_vapor__c, molecular_weight_gas__c, molecular_weight_vapor__c, stagnation_gas_vapor_quality__c,
            engineering_notes__c, discountable_price__c, non_discountable_price__c, size__c, part_number__c, required_flow_capacity_units__c,
            required_flow_capacity_value__c, rupture_disc_flow_capacity_units__c, burst_pressure__c, rupture_disc_flow_capacity_value__c,
            pressure_value_at_discharge__c, pressure_at_discharge_units__c, specfic_weight_of_water_at_inlet_condtns__c, specific_units_of_water_at_inlet_condtns__c,
            flow_rate_units__c, temperature_units__c, pressure_units__c, relieving_temperature_value__c, process_media__c, customer_specified_media__c,
            quantity__c, performance_tolerance_input_units__c, pressure_class__c, special_range_min_input__c, special_range_max_input__c, press_burst_pressure_min_input__c,
            press_burst_pressure_max_input__c, relief_flag__c, sizing_flag__c, pressure_rating_type__c, pressure_range_type__c, performance_tolerance_min_input__c,
            performance_tolerance_max_input__c, vac_rating_type__c, vac_range_type__c, vac_special_range_min_input__c, vac_special_range_max_input__c,
            vac_burst_press_max_input__c, vac_burst_press_min_input__c, converted_flow_rate__c, conv_specificvolume_at_90_inlet_pressur__c,
            vac_special_range_units__c, vac_burst_pressure_units__c, vac_performance_tolerance_units__c, vac_performance_tolerance_min_input__c,
            vac_performance_tolerance_max_input__c, relieving_temperaturerelieving_temperatu__c, add_integral_bdi_integral_bdi_flx_sensor__c,
            united_states_hts_code__c, sourcing_constraints__c, disc_material_of_construction__c, application_type__c, material_of_inlet_ring__c,
            optional_components__c, required_components__c, material_of_inlet_liner__c, material_of_outlet_ring__c, material_of_integral_bdi__c,
            material_of_seal__c, material_of_girdle__c, material_of_inlet_gasket__c, material_of_top_section__c, material_of_outlet_gasket__c,
            material_of_outlet_coating__c, material_of_inlet_coating__c, material_of_handling_support__c, material_of_vacuum_support__c, material_of_outlet__c,
            material_of_holddown_ring__c, material_of_inlet__c, material_of_outlet_liner__c, material_of_disc__c, material_of_armor_ring__c,
            material_of_hi_temp_assembly__c, material_of_arcuate_ring__c, material_of_girdle_cover__c, material_of_inlet_o_ring__c, material_of_knifeblade__c,
            material_of_middle_ring__c, material_of_gasket__c, converted_specific_volume__c, material_of_armor_ring2__c, material_of_dent_protector__c,
            material_of_seal2__c, cable_length__c, material_of_top_section2__c, temperature_test_per_asme__c, x2w_nis__c, x4w_nis__c, cleanings__c,
            inlet_connection__c, individual_packaging__c, pmi__c, halogen_based_restrictions_for_cleaning__c, outlet_connection__c, electro_polish__c,
            add_integral_b_d_i_integral_bdi_flx_sen__c, hydrotest__c, atex_certificate__c, gas_group__c, zone_0_2__c, product__c, seat__c, capacity__c,
            product_selection__c, special_range_units__c, converted_relieving_temperature__c, specific_volume__c, specific_volume_units__c, specific_volume_at_90_of_inlet_pressure__c,
            specific_volume_at_90_of_inlet_units__c, reference_mfg_range_type__c, dscvar__c, press_burst_pressure_units__c, vac_reference_mfg_range_type__c,
            deratetype__c, atmospheric_pressure_units__c, converted_atmospheric_pressure__c, final_assembly_location_requirements__c, material_sourcing_requirements__c,
            mnfa__c, to_make_with_bdi_flx_interface_cable__c, shell_test__c, surface_finish__c, packaging_material__c, mark_pack_clean__c, customer_specific_requirements__c,
            reach__c, rohs__c, dodd_frank_conflict_minerals__c, general_environmental_compliance__c, animal_derivative__c, coshh__c, sanitary_requirements_fda_requirements__c,
            nist_calibrated_equipment__c, certificate_of_origin__c, strip_type__c, gasket_material__c, wiring_configuration__c, wire_type__c,
            end_connection__c, material_of_seal3__c, material_of_inlet_ring2__c, material_of_vacuum_support2__c, material_of_inlet_coating2__c,
            material_of_inlet_ring3__c, material_of_vaccum_support3__c, required_flow_area_units__c, build_cost_override__c, specific_gravity_units__c,
            specific_volume_at_inlet__c, specific_volume_at_inlet_units__c, density_at_inlet__c, density_at_inlet_units__c, density_at_90_of_saturation_pressure__c,
            density_at_90_saturation_pressure_units__c, liquid_density_units__c, stagnation_vapor_density_units__c, diagram_override__c, drawing_outside_config__c,
            density_specific_volume_specific_gravity__c, density_specificvolume_spcfcgravityunits__c, finish_configuration_flag__c, assypartexisting__c,
            assigned_rangetype__c, rg3drt__c, tmr__c, rg2max__c, isconfigfinished__c, price_override__c, lead_time_override__c, quote_descriptions_override__c,
            additional_documents__c, output_required_flow_area__c, converted_specific_volume_at_inlet__c, converted_density_at_inlet__c, converteddensity_at_90saturationpressure__c,
            convertedspecificvolumeat90_ofinletpress__c, rating_and_range_flag__c, product_narrowing_flag__c, convertedsaturationpressure_at_inlettemp__c,
            converted_liquid_density__c, liquid_density_at_inlet__c, liquid_density_at_inlet_units__c, converted_liquid_density_at_inlet__c, converted_stagnation_vapor_density__c,
            stagnation_gas_partial_pressure_units__c, vapor_pres_to_stagnation_temp_units__c, vacrequired_flow_rate__c, vacrequired_flow_rate_units__c,
            vacconverted_flow_rate__c, vacmedia__c, vacpressure_relieving_temperature__c, vacenter_different_temperature_value__c, vacenter_different_temperature_units__c,
            vacconverted_different_temp_setting__c, vacflow_area__c, vacrequired_flow_area_units__c, vacrequired_flow_area__c, vacproduct_flow_capacity_units__c,
            converted_density_speci_volume_spegravit__c, inlet_option_code__c, outlet_option_code__c, asme_inlet_option_code__c, asme_outlet_option_code__c,
            assypartnobase__c, partrev__c, rgemin__c, vg2min__c, rg2min__c, rgsmin__c, vgsmin__c, rgemax__c, convvapor_pres_corres_to_stagnation_temp__c,
            converted_stagnation_gaspartial_pressure__c, disc_thickness__c, material_arcuate_ring__c, material_armor_ring2__c, material_armor_ring__c,
            material_dent_protector__c, material_disc__c, material_gasket__c, material_girdle_cover__c, material_girdle__c, material_handling_support__c,
            material_holddown_ring__c, material_inlet_coating2__c, material_inlet_coating__c, material_inlet_gasket__c, material_inlet_liner__c,
            material_inlet_o_ring__c, material_inlet_ring2__c, material_inlet_ring3__c, material_inlet_ring__c, material_inlet__c, material_integral_bdi__c,
            material_knifeblade__c, material_middle_ring__c, material_outlet_coating__c, material_outlet_gasket__c, material_outlet_liner__c,
            material_outlet_ring__c, material_outlet__c, material_seal2__c, material_seal3__c, material_seal__c, material_top_section2__c, material_top_section__c,
            material_vaccum_support3__c, material_vacuum_support2__c, material_vacuum_support__c, metalseal_thickness__c, newspclpartnobase__c,
            product_flow_capacity_value__c, topsection_thickness__c, vacflow_capacity_value__c, vacproduct_flow_capacity_value__c, vac_converted_vac_setting__c,
            components_flag__c, vtmr__c, vassignedrangetype__c, vg3drt__c, rgsmax__c, mcsm__c, bmrcheck__c, tmrcheck__c, rg1min__c, rg1max__c,
            rg3min__c, rg3max__c, vgsmax__c, vg1min__c, vg1max__c, vg2max__c, vg3min__c, vg3max__c, vgemin__c, vgemax__c, edit_quoteline__c
        FROM   rupture_disc__c];
    }

    public static void createRDTestRecords5(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 100.00;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 72.00;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Withstand__c = 'No Requirements';
        conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'Yes';
        conProd.Converted_Temperature_Setting__c = 100.00;
        conProd.Converted_Pressure_Setting__c = 72.00;



        insert conProd;

        conProd = [SELECT MNFA_for_Calculations__c,
            pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
            coefficient_of_discharge__c, compressibility_factor__c, converted_different_temperature_setting__c, converted_back_pressure_value__c,
            converted_density__c, converted_positive_pressure_value__c, converted_pressure_setting__c, converted_relieving_pressure_value__c,
            converted_temperature_setting__c, converted_vacuum_setting__c, converted_viscosity__c, density__c, density_units__c, enter_different_temperature_units__c,
            enter_different_temperature_value__c, enter_relieving_pressure_units__c, enter_relieving_pressure_value__c, evaluation_per__c,
            evaluation_type__c, flow_area__c, constrain_product_selection_by_flow__c, media_type__c, molecular_weight__c, positive_pressure_units__c,
            positive_pressure_value__c, pressure_relieving_temperature__c, pressure_setting_units__c, pressure_withstand__c, ratio_of_specific_heats__c,
            relief_type__c, relieving_pressure_at_inlet__c, required_flow_rate__c, required_flow_units__c, specific_gravity__c, temperature_setting__c,
            temperature_setting_units__c, vacuum_setting__c, vacuum_setting_units__c, vacuum_withstand__c, viscosity__c, viscosity_units__c,
            quote_line__c, ped_2014_68_eu_ce_mark__c, china_manufacturing_license__c, size_units__c, nace__c, atmospheric_pressure__c, bypass__c,
            is_there_a_liquid_relief_scenario__c, saturation_pressure_at_inlet_temperature__c, constrain_product_selection__c, asme_section_viii_division_1__c,
            csa_marking_crn_number__c, kosha_compliance__c, asme_bpe__c, cu_tr__c, x3a_sanitary_standards__c, comply_with_ad2000_merkblat_a1__c,
            comply_with_regels_voor_tosellan_oder_dr__c, non_fragmenting_design_required__c, operating_pressure_ratio__c, temperature_ambient__c,
            metal_derate__c, derate_teflon__c, saturation_pressure_at_inlet_temp_units__c, liquid_density__c, latent_heat_of_vaporization__c,
            liquid_specific_heat__c, stagnation_gas_partial_pressure__c, vapor_pres_correspond_to_stagnation_temp__c, stagnation_vapor_density__c,
            isentropic_coefficient_gas__c, isentropic_coefficient_vapor__c, molecular_weight_gas__c, molecular_weight_vapor__c, stagnation_gas_vapor_quality__c,
            engineering_notes__c, discountable_price__c, non_discountable_price__c, size__c, part_number__c, required_flow_capacity_units__c,
            required_flow_capacity_value__c, rupture_disc_flow_capacity_units__c, burst_pressure__c, rupture_disc_flow_capacity_value__c,
            pressure_value_at_discharge__c, pressure_at_discharge_units__c, specfic_weight_of_water_at_inlet_condtns__c, specific_units_of_water_at_inlet_condtns__c,
            flow_rate_units__c, temperature_units__c, pressure_units__c, relieving_temperature_value__c, process_media__c, customer_specified_media__c,
            quantity__c, performance_tolerance_input_units__c, pressure_class__c, special_range_min_input__c, special_range_max_input__c, press_burst_pressure_min_input__c,
            press_burst_pressure_max_input__c, relief_flag__c, sizing_flag__c, pressure_rating_type__c, pressure_range_type__c, performance_tolerance_min_input__c,
            performance_tolerance_max_input__c, vac_rating_type__c, vac_range_type__c, vac_special_range_min_input__c, vac_special_range_max_input__c,
            vac_burst_press_max_input__c, vac_burst_press_min_input__c, converted_flow_rate__c, conv_specificvolume_at_90_inlet_pressur__c,
            vac_special_range_units__c, vac_burst_pressure_units__c, vac_performance_tolerance_units__c, vac_performance_tolerance_min_input__c,
            vac_performance_tolerance_max_input__c, relieving_temperaturerelieving_temperatu__c, add_integral_bdi_integral_bdi_flx_sensor__c,
            united_states_hts_code__c, sourcing_constraints__c, disc_material_of_construction__c, application_type__c, material_of_inlet_ring__c,
            optional_components__c, required_components__c, material_of_inlet_liner__c, material_of_outlet_ring__c, material_of_integral_bdi__c,
            material_of_seal__c, material_of_girdle__c, material_of_inlet_gasket__c, material_of_top_section__c, material_of_outlet_gasket__c,
            material_of_outlet_coating__c, material_of_inlet_coating__c, material_of_handling_support__c, material_of_vacuum_support__c, material_of_outlet__c,
            material_of_holddown_ring__c, material_of_inlet__c, material_of_outlet_liner__c, material_of_disc__c, material_of_armor_ring__c,
            material_of_hi_temp_assembly__c, material_of_arcuate_ring__c, material_of_girdle_cover__c, material_of_inlet_o_ring__c, material_of_knifeblade__c,
            material_of_middle_ring__c, material_of_gasket__c, converted_specific_volume__c, material_of_armor_ring2__c, material_of_dent_protector__c,
            material_of_seal2__c, cable_length__c, material_of_top_section2__c, temperature_test_per_asme__c, x2w_nis__c, x4w_nis__c, cleanings__c,
            inlet_connection__c, individual_packaging__c, pmi__c, halogen_based_restrictions_for_cleaning__c, outlet_connection__c, electro_polish__c,
            add_integral_b_d_i_integral_bdi_flx_sen__c, hydrotest__c, atex_certificate__c, gas_group__c, zone_0_2__c, product__c, seat__c, capacity__c,
            product_selection__c, special_range_units__c, converted_relieving_temperature__c, specific_volume__c, specific_volume_units__c, specific_volume_at_90_of_inlet_pressure__c,
            specific_volume_at_90_of_inlet_units__c, reference_mfg_range_type__c, dscvar__c, press_burst_pressure_units__c, vac_reference_mfg_range_type__c,
            deratetype__c, atmospheric_pressure_units__c, converted_atmospheric_pressure__c, final_assembly_location_requirements__c, material_sourcing_requirements__c,
            mnfa__c, to_make_with_bdi_flx_interface_cable__c, shell_test__c, surface_finish__c, packaging_material__c, mark_pack_clean__c, customer_specific_requirements__c,
            reach__c, rohs__c, dodd_frank_conflict_minerals__c, general_environmental_compliance__c, animal_derivative__c, coshh__c, sanitary_requirements_fda_requirements__c,
            nist_calibrated_equipment__c, certificate_of_origin__c, strip_type__c, gasket_material__c, wiring_configuration__c, wire_type__c,
            end_connection__c, material_of_seal3__c, material_of_inlet_ring2__c, material_of_vacuum_support2__c, material_of_inlet_coating2__c,
            material_of_inlet_ring3__c, material_of_vaccum_support3__c, required_flow_area_units__c, build_cost_override__c, specific_gravity_units__c,
            specific_volume_at_inlet__c, specific_volume_at_inlet_units__c, density_at_inlet__c, density_at_inlet_units__c, density_at_90_of_saturation_pressure__c,
            density_at_90_saturation_pressure_units__c, liquid_density_units__c, stagnation_vapor_density_units__c, diagram_override__c, drawing_outside_config__c,
            density_specific_volume_specific_gravity__c, density_specificvolume_spcfcgravityunits__c, finish_configuration_flag__c, assypartexisting__c,
            assigned_rangetype__c, rg3drt__c, tmr__c, rg2max__c, isconfigfinished__c, price_override__c, lead_time_override__c, quote_descriptions_override__c,
            additional_documents__c, output_required_flow_area__c, converted_specific_volume_at_inlet__c, converted_density_at_inlet__c, converteddensity_at_90saturationpressure__c,
            convertedspecificvolumeat90_ofinletpress__c, rating_and_range_flag__c, product_narrowing_flag__c, convertedsaturationpressure_at_inlettemp__c,
            converted_liquid_density__c, liquid_density_at_inlet__c, liquid_density_at_inlet_units__c, converted_liquid_density_at_inlet__c, converted_stagnation_vapor_density__c,
            stagnation_gas_partial_pressure_units__c, vapor_pres_to_stagnation_temp_units__c, vacrequired_flow_rate__c, vacrequired_flow_rate_units__c,
            vacconverted_flow_rate__c, vacmedia__c, vacpressure_relieving_temperature__c, vacenter_different_temperature_value__c, vacenter_different_temperature_units__c,
            vacconverted_different_temp_setting__c, vacflow_area__c, vacrequired_flow_area_units__c, vacrequired_flow_area__c, vacproduct_flow_capacity_units__c,
            converted_density_speci_volume_spegravit__c, inlet_option_code__c, outlet_option_code__c, asme_inlet_option_code__c, asme_outlet_option_code__c,
            assypartnobase__c, partrev__c, rgemin__c, vg2min__c, rg2min__c, rgsmin__c, vgsmin__c, rgemax__c, convvapor_pres_corres_to_stagnation_temp__c,
            converted_stagnation_gaspartial_pressure__c, disc_thickness__c, material_arcuate_ring__c, material_armor_ring2__c, material_armor_ring__c,
            material_dent_protector__c, material_disc__c, material_gasket__c, material_girdle_cover__c, material_girdle__c, material_handling_support__c,
            material_holddown_ring__c, material_inlet_coating2__c, material_inlet_coating__c, material_inlet_gasket__c, material_inlet_liner__c,
            material_inlet_o_ring__c, material_inlet_ring2__c, material_inlet_ring3__c, material_inlet_ring__c, material_inlet__c, material_integral_bdi__c,
            material_knifeblade__c, material_middle_ring__c, material_outlet_coating__c, material_outlet_gasket__c, material_outlet_liner__c,
            material_outlet_ring__c, material_outlet__c, material_seal2__c, material_seal3__c, material_seal__c, material_top_section2__c, material_top_section__c,
            material_vaccum_support3__c, material_vacuum_support2__c, material_vacuum_support__c, metalseal_thickness__c, newspclpartnobase__c,
            product_flow_capacity_value__c, topsection_thickness__c, vacflow_capacity_value__c, vacproduct_flow_capacity_value__c, vac_converted_vac_setting__c,
            components_flag__c, vtmr__c, vassignedrangetype__c, vg3drt__c, rgsmax__c, mcsm__c, bmrcheck__c, tmrcheck__c, rg1min__c, rg1max__c,
            rg3min__c, rg3max__c, vgsmax__c, vg1min__c, vg1max__c, vg2max__c, vg3min__c, vg3max__c, vgemin__c, vgemax__c, edit_quoteline__c
        FROM   rupture_disc__c];
    }

    public static void createRDTestRecords6(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 100.00;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 72;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Withstand__c = 'No Requirements';
        conProd.Is_there_a_liquid_relief_scenario__c = 'No';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Converted_Temperature_Setting__c = 72.00;
        conProd.Converted_Pressure_Setting__c = 100.00;

        //Section-C Certifications
        conProd.CSA_Marking_CRN_Number__c = false;
        conProd.ASME_Section_VIII_Division_1__c = true;
        conProd.KOSHA_Compliance__c = false;
        conProd.CU_TR__c = false;
        conProd.X3A_Sanitary_Standards__c = false;
        conProd.Comply_with_AD2000_Merkblat_A1__c = false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = false;
        conProd.Atex_Certificate__c = false;
        conProd.NACE__c = 'N';
        conProd.PED_2014_68_EU_CE_mark__c = 'NonePED';
        conProd.China_Manufacturing_License__c = 'NoneCML';

        //Section-D - Product Narrowing
        conProd.Non_Fragmenting_Design_Required__c = false;
        conProd.Operating_Pressure_Ratio__c = 'OPRNone';
        conProd.Application_type__c = '';
        conProd.Disc_Material_of_Construction__c = '';

        //Section-E - Product Selection
        conProd.Product__c = 'HPX';
        conProd.Size__c = '200';
        conProd.Seat__c = 'FS';

        //Section-F - Holders Details
        conProd.Pressure_Class__c = 'N/A';
        conProd.Inlet_Connection__c = 'N';
        conProd.Outlet_Connection__c = 'N';

        //Section-G - Rating and Range Properties
        conProd.Quantity__c = 4;
        conProd.Pressure_Rating_Type__c = 'Rated';
        conProd.Pressure_Range_Type__c = 'Zero';

        //Section-H - Components
        conProd.Final_Assembly_Location_Requirements__c = '00';
        conProd.Material_Sourcing_Requirements__c = '00';
        conProd.Material_Outlet_Ring__c = '005';
        conProd.Material_Disc__c = '005';

        //Section-I - Cleanings,Tests and Processes
        conProd.Cleanings__c = 'N';
        conProd.Customer_Specific_Requirements__c = 'N';
        insert conProd;

        conProd = [SELECT MNFA_for_Calculations__c,
            pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
            coefficient_of_discharge__c, compressibility_factor__c, converted_different_temperature_setting__c, converted_back_pressure_value__c,
            converted_density__c, converted_positive_pressure_value__c, converted_pressure_setting__c, converted_relieving_pressure_value__c,
            converted_temperature_setting__c, converted_vacuum_setting__c, converted_viscosity__c, density__c, density_units__c, enter_different_temperature_units__c,
            enter_different_temperature_value__c, enter_relieving_pressure_units__c, enter_relieving_pressure_value__c, evaluation_per__c,
            evaluation_type__c, flow_area__c, constrain_product_selection_by_flow__c, media_type__c, molecular_weight__c, positive_pressure_units__c,
            positive_pressure_value__c, pressure_relieving_temperature__c, pressure_setting_units__c, pressure_withstand__c, ratio_of_specific_heats__c,
            relief_type__c, relieving_pressure_at_inlet__c, required_flow_rate__c, required_flow_units__c, specific_gravity__c, temperature_setting__c,
            temperature_setting_units__c, vacuum_setting__c, vacuum_setting_units__c, vacuum_withstand__c, viscosity__c, viscosity_units__c,
            quote_line__c, ped_2014_68_eu_ce_mark__c, china_manufacturing_license__c, size_units__c, nace__c, atmospheric_pressure__c, bypass__c,
            is_there_a_liquid_relief_scenario__c, saturation_pressure_at_inlet_temperature__c, constrain_product_selection__c, asme_section_viii_division_1__c,
            csa_marking_crn_number__c, kosha_compliance__c, asme_bpe__c, cu_tr__c, x3a_sanitary_standards__c, comply_with_ad2000_merkblat_a1__c,
            comply_with_regels_voor_tosellan_oder_dr__c, non_fragmenting_design_required__c, operating_pressure_ratio__c, temperature_ambient__c,
            metal_derate__c, derate_teflon__c, saturation_pressure_at_inlet_temp_units__c, liquid_density__c, latent_heat_of_vaporization__c,
            liquid_specific_heat__c, stagnation_gas_partial_pressure__c, vapor_pres_correspond_to_stagnation_temp__c, stagnation_vapor_density__c,
            isentropic_coefficient_gas__c, isentropic_coefficient_vapor__c, molecular_weight_gas__c, molecular_weight_vapor__c, stagnation_gas_vapor_quality__c,
            engineering_notes__c, discountable_price__c, non_discountable_price__c, size__c, part_number__c, required_flow_capacity_units__c,
            required_flow_capacity_value__c, rupture_disc_flow_capacity_units__c, burst_pressure__c, rupture_disc_flow_capacity_value__c,
            pressure_value_at_discharge__c, pressure_at_discharge_units__c, specfic_weight_of_water_at_inlet_condtns__c, specific_units_of_water_at_inlet_condtns__c,
            flow_rate_units__c, temperature_units__c, pressure_units__c, relieving_temperature_value__c, process_media__c, customer_specified_media__c,
            quantity__c, performance_tolerance_input_units__c, pressure_class__c, special_range_min_input__c, special_range_max_input__c, press_burst_pressure_min_input__c,
            press_burst_pressure_max_input__c, relief_flag__c, sizing_flag__c, pressure_rating_type__c, pressure_range_type__c, performance_tolerance_min_input__c,
            performance_tolerance_max_input__c, vac_rating_type__c, vac_range_type__c, vac_special_range_min_input__c, vac_special_range_max_input__c,
            vac_burst_press_max_input__c, vac_burst_press_min_input__c, converted_flow_rate__c, conv_specificvolume_at_90_inlet_pressur__c,
            vac_special_range_units__c, vac_burst_pressure_units__c, vac_performance_tolerance_units__c, vac_performance_tolerance_min_input__c,
            vac_performance_tolerance_max_input__c, relieving_temperaturerelieving_temperatu__c, add_integral_bdi_integral_bdi_flx_sensor__c,
            united_states_hts_code__c, sourcing_constraints__c, disc_material_of_construction__c, application_type__c, material_of_inlet_ring__c,
            optional_components__c, required_components__c, material_of_inlet_liner__c, material_of_outlet_ring__c, material_of_integral_bdi__c,
            material_of_seal__c, material_of_girdle__c, material_of_inlet_gasket__c, material_of_top_section__c, material_of_outlet_gasket__c,
            material_of_outlet_coating__c, material_of_inlet_coating__c, material_of_handling_support__c, material_of_vacuum_support__c, material_of_outlet__c,
            material_of_holddown_ring__c, material_of_inlet__c, material_of_outlet_liner__c, material_of_disc__c, material_of_armor_ring__c,
            material_of_hi_temp_assembly__c, material_of_arcuate_ring__c, material_of_girdle_cover__c, material_of_inlet_o_ring__c, material_of_knifeblade__c,
            material_of_middle_ring__c, material_of_gasket__c, converted_specific_volume__c, material_of_armor_ring2__c, material_of_dent_protector__c,
            material_of_seal2__c, cable_length__c, material_of_top_section2__c, temperature_test_per_asme__c, x2w_nis__c, x4w_nis__c, cleanings__c,
            inlet_connection__c, individual_packaging__c, pmi__c, halogen_based_restrictions_for_cleaning__c, outlet_connection__c, electro_polish__c,
            add_integral_b_d_i_integral_bdi_flx_sen__c, hydrotest__c, atex_certificate__c, gas_group__c, zone_0_2__c, product__c, seat__c, capacity__c,
            product_selection__c, special_range_units__c, converted_relieving_temperature__c, specific_volume__c, specific_volume_units__c, specific_volume_at_90_of_inlet_pressure__c,
            specific_volume_at_90_of_inlet_units__c, reference_mfg_range_type__c, dscvar__c, press_burst_pressure_units__c, vac_reference_mfg_range_type__c,
            deratetype__c, atmospheric_pressure_units__c, converted_atmospheric_pressure__c, final_assembly_location_requirements__c, material_sourcing_requirements__c,
            mnfa__c, to_make_with_bdi_flx_interface_cable__c, shell_test__c, surface_finish__c, packaging_material__c, mark_pack_clean__c, customer_specific_requirements__c,
            reach__c, rohs__c, dodd_frank_conflict_minerals__c, general_environmental_compliance__c, animal_derivative__c, coshh__c, sanitary_requirements_fda_requirements__c,
            nist_calibrated_equipment__c, certificate_of_origin__c, strip_type__c, gasket_material__c, wiring_configuration__c, wire_type__c,
            end_connection__c, material_of_seal3__c, material_of_inlet_ring2__c, material_of_vacuum_support2__c, material_of_inlet_coating2__c,
            material_of_inlet_ring3__c, material_of_vaccum_support3__c, required_flow_area_units__c, build_cost_override__c, specific_gravity_units__c,
            specific_volume_at_inlet__c, specific_volume_at_inlet_units__c, density_at_inlet__c, density_at_inlet_units__c, density_at_90_of_saturation_pressure__c,
            density_at_90_saturation_pressure_units__c, liquid_density_units__c, stagnation_vapor_density_units__c, diagram_override__c, drawing_outside_config__c,
            density_specific_volume_specific_gravity__c, density_specificvolume_spcfcgravityunits__c, finish_configuration_flag__c, assypartexisting__c,
            assigned_rangetype__c, rg3drt__c, tmr__c, rg2max__c, isconfigfinished__c, price_override__c, lead_time_override__c, quote_descriptions_override__c,
            additional_documents__c, output_required_flow_area__c, converted_specific_volume_at_inlet__c, converted_density_at_inlet__c, converteddensity_at_90saturationpressure__c,
            convertedspecificvolumeat90_ofinletpress__c, rating_and_range_flag__c, product_narrowing_flag__c, convertedsaturationpressure_at_inlettemp__c,
            converted_liquid_density__c, liquid_density_at_inlet__c, liquid_density_at_inlet_units__c, converted_liquid_density_at_inlet__c, converted_stagnation_vapor_density__c,
            stagnation_gas_partial_pressure_units__c, vapor_pres_to_stagnation_temp_units__c, vacrequired_flow_rate__c, vacrequired_flow_rate_units__c,
            vacconverted_flow_rate__c, vacmedia__c, vacpressure_relieving_temperature__c, vacenter_different_temperature_value__c, vacenter_different_temperature_units__c,
            vacconverted_different_temp_setting__c, vacflow_area__c, vacrequired_flow_area_units__c, vacrequired_flow_area__c, vacproduct_flow_capacity_units__c,
            converted_density_speci_volume_spegravit__c, inlet_option_code__c, outlet_option_code__c, asme_inlet_option_code__c, asme_outlet_option_code__c,
            assypartnobase__c, partrev__c, rgemin__c, vg2min__c, rg2min__c, rgsmin__c, vgsmin__c, rgemax__c, convvapor_pres_corres_to_stagnation_temp__c,
            converted_stagnation_gaspartial_pressure__c, disc_thickness__c, material_arcuate_ring__c, material_armor_ring2__c, material_armor_ring__c,
            material_dent_protector__c, material_disc__c, material_gasket__c, material_girdle_cover__c, material_girdle__c, material_handling_support__c,
            material_holddown_ring__c, material_inlet_coating2__c, material_inlet_coating__c, material_inlet_gasket__c, material_inlet_liner__c,
            material_inlet_o_ring__c, material_inlet_ring2__c, material_inlet_ring3__c, material_inlet_ring__c, material_inlet__c, material_integral_bdi__c,
            material_knifeblade__c, material_middle_ring__c, material_outlet_coating__c, material_outlet_gasket__c, material_outlet_liner__c,
            material_outlet_ring__c, material_outlet__c, material_seal2__c, material_seal3__c, material_seal__c, material_top_section2__c, material_top_section__c,
            material_vaccum_support3__c, material_vacuum_support2__c, material_vacuum_support__c, metalseal_thickness__c, newspclpartnobase__c,
            product_flow_capacity_value__c, topsection_thickness__c, vacflow_capacity_value__c, vacproduct_flow_capacity_value__c, vac_converted_vac_setting__c,
            components_flag__c, vtmr__c, vassignedrangetype__c, vg3drt__c, rgsmax__c, mcsm__c, bmrcheck__c, tmrcheck__c, rg1min__c, rg1max__c,
            rg3min__c, rg3max__c, vgsmax__c, vg1min__c, vg1max__c, vg2max__c, vg3min__c, vg3max__c, vgemin__c, vgemax__c, edit_quoteline__c
        FROM   rupture_disc__c];
    }
    public static void createRDTestRecStructure(){
        conProd.Quote_Line__c = quoteLine.Id;

        //Section-A Relief
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 100.00;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting__c = 72;
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Withstand__c = 'No Requirements';
        conProd.Is_there_a_liquid_relief_scenario__c = 'No';
        conProd.Size_Units__c = 'US Units';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Converted_Temperature_Setting__c = 72.00;
        conProd.Converted_Pressure_Setting__c = 100.00;

        //Section-C Certifications
        conProd.CSA_Marking_CRN_Number__c = false;
        conProd.ASME_Section_VIII_Division_1__c = true;
        conProd.KOSHA_Compliance__c = false;
        conProd.CU_TR__c = false;
        conProd.X3A_Sanitary_Standards__c = false;
        conProd.Comply_with_AD2000_Merkblat_A1__c = false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c = false;
        conProd.Atex_Certificate__c = false;
        conProd.NACE__c = 'N';
        conProd.PED_2014_68_EU_CE_mark__c = 'NonePED';
        conProd.China_Manufacturing_License__c = 'NoneCML';

        //Section-D - Product Narrowing
        conProd.Non_Fragmenting_Design_Required__c = false;
        conProd.Operating_Pressure_Ratio__c = 'OPRNone';
        conProd.Application_type__c = '';
        conProd.Disc_Material_of_Construction__c = '';

        //Section-E - Product Selection
        conProd.Product__c = 'HPZ';
        conProd.Size__c = '0108';
        conProd.Seat__c = 'NA';

        //Section-F - Holders Details
        conProd.Pressure_Class__c = 'N/A';
        conProd.Inlet_Connection__c = 'N';
        conProd.Outlet_Connection__c = 'N';
        conProd.DSCVAR__c='A';

        //Section-G - Rating and Range Properties
        conProd.Quantity__c = 4;
        conProd.Pressure_Rating_Type__c = 'Rated';
        conProd.Pressure_Range_Type__c = 'Zero';

        //Section-H - Components
        conProd.Final_Assembly_Location_Requirements__c = '00';
        conProd.Material_Sourcing_Requirements__c = '00';
        // conProd.Material_Outlet_Ring__c = '005';
        // conProd.Material_Disc__c = '005';


        //
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c='BDI';
        conProd.Gasket_Material__c='0B6';
        conProd.Strip_Type__c='024';
        conProd.Wire_Type__c='Blue Shielded Cable';
        conProd.Cable_Length__c='10 ft (3m)';
        conProd.End_Connection__c='Plug End';
        conProd.Wiring_Configuration__c='test';

        conProd.Material_Armor_Ring2__c='001';
        conProd.Material_Armor_Ring__c='001';
        conProd.Material_Dent_Protector__c='001';
        conProd.Material_Gasket__c='001';
        conProd.Material_Girdle_Cover__c='001';
        conProd.Material_Inlet_Gasket__c='001';
        conProd.Material_Girdle__c='001';
        conProd.Material_Handling_Support__c='001';
        conProd.Material_Hi_Temp_Assembly__c='001';
        conProd.Material_Holddown_Ring__c='001';
        conProd.Material_Inlet_Coating2__c='001';
        conProd.Material_Inlet_Coating__c='001';
        conProd.Material_Inlet_Liner__c='001';
        conProd.Material_Inlet_O_Ring__c='099';
        conProd.Material_Inlet_Ring2__c='001';
        conProd.Material_Inlet_Ring3__c='001';
        conProd.Material_Inlet_Ring__c='001';
        conProd.Material_Inlet__c='001';
        conProd.Material_Integral_BDI__c='001';
        conProd.Material_Knifeblade__c='001';
        conProd.Material_Middle_Ring__c='001';
        conProd.Material_Outlet_Coating__c='001';
        conProd.Material_Outlet_Gasket__c='001';
        conProd.Material_Outlet_Liner__c='001';
        conProd.Material_Outlet_Ring__c='001';
        conProd.Material_Outlet__c='071';
        conProd.Material_Seal2__c='071';
        conProd.Material_Seal3__c='071';
        conProd.Material_Seal__c='071';
        conProd.Material_Top_Section2__c='001';
        conProd.Material_Top_Section__c='001';
        conProd.Material_Vaccum_Support3__c='001';
        conProd.Material_Vacuum_Support2__c='001';
        conProd.Material_Vacuum_Support__c='001';
        conProd.Material_Arcuate_Ring__c='001';
        //Section-I - Cleanings,Tests and Processes
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.MCSM__c='005';
        conProd.Cleanings__c = 'N';
        conProd.RGSMIN__c=72;
        conProd.Material_Disc__c='001';
        conProd.Customer_Specific_Requirements__c = 'N';
        insert conProd;
    }
    public static void createRDTestRecordWithOutput(){
        conProd.Quote_Line__c = quoteLine.Id;
        conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=false;
        conProd.Animal_Derivative__c=false;
        conProd.ASME_BPE__c=false;
        conProd.ASME_Inlet_Option_Code__c='A';
        conProd.ASME_Outlet_Option_Code__c='1';
        conProd.ASME_Section_VIII_Division_1__c=false;
        conProd.Assigned_RangeType__c='-10% (-5 psig)';
        conProd.ASSYPARTNOBASE__c='DHPZ0108NA';
        conProd.Atex_Certificate__c=false;
        conProd.BMRCHECK__c=50.890526;
        conProd.Build_Cost_Override__c=false;
        conProd.Bypass__c=false;
        conProd.Certificate_of_Origin__c=false;
        conProd.China_Manufacturing_License__c='NoneCML';
        conProd.Cleanings__c='N';
        conProd.Coefficient_of_Discharge__c='0.62';
        conProd.Comply_with_AD2000_Merkblat_A1__c=false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c=false;
        conProd.Components_Flag__c=TRUE;
        conProd.constrain_product_selection_by_flow__c='Yes';
        conProd.Converted_Density_at_Inlet__c=0;
        conProd.Converted_Density_Speci_Volume_SpeGravit__c=1;
        conProd.Converted_Flow_rate__c=0;
        conProd.Converted_Pressure_Setting__c=50.7633;
        conProd.Converted_Relieving_Pressure_Value__c=4.513254738;
        conProd.Converted_Relieving_Temperature__c=0;
        conProd.Converted_Specific_Volume__c=0;
        conProd.Converted_Temperature_Setting__c=266;
        conProd.Converted_Viscosity__c=0.001;
        conProd.Coshh__c=false;
        conProd.CSA_Marking_CRN_Number__c=false;
        conProd.Customer_Specific_Requirements__c='N';
        conProd.CU_TR__c=false;
        conProd.Density_SpecificVolume_SpcfcGravityUnits__c='kg/L';
        conProd.Density_Specific_Volume_Specific_Gravity__c=62.371;
        conProd.Diagram_Override__c=false;
        conProd.Discountable_Price__c=1596;
        conProd.Disc_Thickness__c=0.004;
        conProd.Dodd_Frank_Conflict_Minerals__c=false;
        conProd.Drawing_Outside_Config__c=false;
        conProd.DSCVAR__c='A';
        conProd.Edit_QuoteLine__c=false;
        conProd.Electro_polish__c=false;
        conProd.Evaluation_Per__c='ISO Liquid';
        conProd.Evaluation_Type__c='Capacity';
        conProd.Final_Assembly_Location_Requirements__c='00';
        conProd.Finish_Configuration_Flag__c=true;
        conProd.General_Environmental_Compliance__c=false;
        conProd.Halogen_Based_Restrictions_for_cleaning__c=false;
        conProd.Individual_Packaging__c=false;
        conProd.Inlet_Connection__c='3/8 BSPP';
        conProd.Inlet_Option_Code__c='1';
        conProd.IsConfigFinished__c=false;
        conProd.Is_there_a_liquid_relief_scenario__c='Yes';
        conProd.KOSHA_Compliance__c=false;
        conProd.Lead_Time_Override__c=false;
        conProd.Gasket_Material__c='005';
        conProd.Material_Armor_Ring2__c='005';
        conProd.Material_Armor_Ring__c='005';
        conProd.Material_Dent_Protector__c='005';
        conProd.Material_Gasket__c='005';
        conProd.Material_Girdle_Cover__c='005';
        conProd.Material_Inlet_Gasket__c='005';
        conProd.Material_Girdle__c='005';
        conProd.Material_Handling_Support__c='005';
        conProd.Material_Hi_Temp_Assembly__c='005';
        conProd.Material_Holddown_Ring__c='005';
        conProd.Material_Inlet_Coating2__c='005';
        conProd.Material_Inlet_Coating__c='005';
        conProd.Material_Inlet_Liner__c='005';
        conProd.Material_Inlet_O_Ring__c='005';
        conProd.Material_Inlet_Ring2__c='005';
        conProd.Material_Inlet_Ring3__c='005';
        conProd.Material_Inlet_Ring__c='05';
        conProd.Material_Inlet__c='005';
        conProd.Material_Integral_BDI__c='005';
        conProd.Material_Knifeblade__c='005';
        conProd.Material_Middle_Ring__c='005';
        conProd.Material_Outlet_Coating__c='005';
        conProd.Material_Outlet_Gasket__c='005';
        conProd.Material_Outlet_Liner__c='005';
        conProd.Material_Outlet_Ring__c='005';
        conProd.Material_Outlet__c='005';
        conProd.Material_Seal2__c='005';
        conProd.Material_Seal3__c='005';
        conProd.Material_Seal__c='005';
        conProd.Material_Top_Section2__c='005';
        conProd.Material_Top_Section__c='005';
        conProd.Material_Vaccum_Support3__c='005';
        conProd.Material_Vacuum_Support2__c='005';
        conProd.Material_Vacuum_Support__c='005';

        conProd.Material_Sourcing_Requirements__c='00';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.NACE__c='N';
        conProd.NIST_Calibrated_Equipment__c=false;
        conProd.Non_Fragmenting_Design_Required__c=false;
        conProd.Operating_Pressure_Ratio__c='OPRNone';
        conProd.Outlet_Connection__c='3/8 BSPP';
        conProd.Outlet_Option_Code__c='2';
        conProd.Packaging_Material__c=false;
        conProd.PED_2014_68_EU_CE_mark__c='NonePED';
        conProd.Pressure_Class__c='C1';
        conProd.Pressure_Range_Type__c='Specify Reference Mfg Range';
        conProd.Pressure_Rating_Type__c='Burst Pressure Min/Max.';
        conProd.Pressure_Setting_Units__c='barg';
        conProd.Pressure_Setting__c=3.5;
        conProd.Pressure_Value_at_discharge__c=14.7;
        conProd.Press_Burst_Pressure_Max_Input__c=3.5;
        conProd.Price_Override__c=false;
        conProd.Process_Media__c='Water';
        conProd.Product_Narrowing_Flag__c=false;
        conProd.Product_Selection__c=TRUE;
        conProd.Product__c='HPZ';
        conProd.Quantity__c=1;
        conProd.Quote_Descriptions_Override__c=false;
        conProd.Rating_and_Range_Flag__c=TRUE;
        conProd.Reach__c=false;
        conProd.Reference_Mfg_Range_Type__c='-10% (-5 Psig)';
        conProd.Relief_Flag__c=true;
        conProd.Relief_Type__c='Pressure Relief';
       // conProd.Relieving_Pressure_at_Inlet__c=0;
        conProd.RG1MAX__c=3.5;
        conProd.RG1MIN__c=0;
        conProd.RG2MAX__c=50.8;
        conProd.RG2MIN__c=0;
        conProd.RG3DRT__c=95;
        conProd.RG3MAX__c=53.4;
        conProd.RG3MIN__c=0;
        conProd.RGEMAX__c=48.3;
        conProd.RGEMIN__c=0;
        conProd.RGSMAX__c=50.8;
        conProd.RGSMIN__c=0;
        conProd.RoHS__c=false;
        conProd.Rupture_Disc_Flow_Capacity_Value__c=550.248088;
        conProd.Sanitary_Requirements_FDA_requirements__c=false;
        conProd.Seat__c='NA';
        conProd.Shell_Test__c=false;
        conProd.Size_Units__c='Metric';
        conProd.Size__c='0108';
        conProd.Sizing_Flag__c=false;
        conProd.Temperature_Setting_Units__c='Deg C';
        conProd.Temperature_Setting__c=130;
        conProd.Temperature_Test_per_ASME__c=false;
        conProd.TMRCHECK__c=0;
        conProd.TMR__c=48.346;
        conProd.MCSM__c='070';
        conProd.TopSection_Thickness__c=0.9999;
        conProd.VacMedia__c='Air';
        conProd.Vacuum_Withstand__c='Full Vacuum';
        conProd.Viscosity_units__c='centipoise';
        conProd.Viscosity__c=1;
        conProd.X2W_NIS__c=false;
        conProd.X3A_Sanitary_Standards__c=false;
        conProd.X4W_NIS__c=false;
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c='BDI';
        conProd.Gasket_Material__c='0B6';
        conProd.Strip_Type__c='024';
        conProd.Wire_Type__c='Blue Shielded Cable';
        conProd.Cable_Length__c='10 ft (3m)';
        conProd.End_Connection__c='Plug End';
        conProd.Wiring_Configuration__c='Test';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.MCSM__c='005';
        conProd.Material_Disc__c='009';
        conProd.Part_Number__c='PARTNUMBER';
        insert conProd;
        RD_Outputs__c rdOut=new RD_Outputs__c();
        rdOut.RD_Outputs_Relation_Field__c=conProd.id;
        insert rdOut;
        RD_Drawings__c rdDia=new RD_Drawings__c();
        rdDia.Rupture_Disc__c=conProd.id;
        rdDia.Dim_A__c='test';
        rdDia.Dim_B_Override__c='test';
        rdDia.Dim_B__c='test';
        rdDia.Dim_C_Override__c='test';
        rdDia.Dim_C__c='test';
        rdDia.Dim_D_Override__c='test';
        rdDia.Dim_D__c='test';
        rdDia.Dim_E_Override__c='test';
        rdDia.Dim_E__c='test';
        rdDia.Dim_F_Override__c='test';
        rdDia.Dim_F__c='test';
        insert rdDia;

        RD_Pricing__c RDPrice=new RD_Pricing__c();
        RDPrice.Rupture_Disc__c=conProd.id;
        insert RDPrice;
    }
    public static void createRDTestRecordWithOutput1(){
        conProd.Quote_Line__c = quoteLine.Id;
        conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=false;
        conProd.Animal_Derivative__c=false;
        conProd.ASME_BPE__c=false;
        conProd.ASME_Inlet_Option_Code__c='A';
        conProd.ASME_Outlet_Option_Code__c='1';
        conProd.ASME_Section_VIII_Division_1__c=false;
        conProd.Assigned_RangeType__c='-10% (-5 psig)';
        conProd.ASSYPARTNOBASE__c='DHPZ0108NA';
        conProd.Atex_Certificate__c=false;
        conProd.BMRCHECK__c=50.890526;
        conProd.Build_Cost_Override__c=false;
        conProd.Bypass__c=false;
        conProd.Certificate_of_Origin__c=false;
        conProd.China_Manufacturing_License__c='NoneCML';
        conProd.Cleanings__c='N';
        conProd.Coefficient_of_Discharge__c='0.62';
        conProd.Comply_with_AD2000_Merkblat_A1__c=false;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c=false;
        conProd.Components_Flag__c=TRUE;
        conProd.constrain_product_selection_by_flow__c='Yes';
        conProd.Converted_Density_at_Inlet__c=0;
        conProd.Converted_Density_Speci_Volume_SpeGravit__c=1;
        conProd.Converted_Flow_rate__c=0;
        conProd.Converted_Pressure_Setting__c=50.7633;
        conProd.Converted_Relieving_Pressure_Value__c=4.513254738;
        conProd.Converted_Relieving_Temperature__c=0;
        conProd.Converted_Specific_Volume__c=0;
        conProd.Converted_Temperature_Setting__c=266;
        conProd.Converted_Viscosity__c=0.001;
        conProd.Coshh__c=false;
        conProd.CSA_Marking_CRN_Number__c=false;
        conProd.Customer_Specific_Requirements__c='N';
        conProd.CU_TR__c=false;
        conProd.Density_SpecificVolume_SpcfcGravityUnits__c='kg/L';
        conProd.Density_Specific_Volume_Specific_Gravity__c=62.371;
        conProd.Diagram_Override__c=false;
        conProd.Discountable_Price__c=1596;
        conProd.Disc_Thickness__c=0.004;
        conProd.Dodd_Frank_Conflict_Minerals__c=false;
        conProd.Drawing_Outside_Config__c=false;
        conProd.DSCVAR__c='A';
        conProd.Edit_QuoteLine__c=false;
        conProd.Electro_polish__c=false;
        conProd.Evaluation_Per__c='ISO Liquid';
        conProd.Evaluation_Type__c='Capacity';
        conProd.Final_Assembly_Location_Requirements__c='00';
        conProd.Finish_Configuration_Flag__c=false;
        conProd.General_Environmental_Compliance__c=false;
        conProd.Halogen_Based_Restrictions_for_cleaning__c=false;
        conProd.Individual_Packaging__c=false;
        conProd.Inlet_Connection__c='3/8 BSPP';
        conProd.Inlet_Option_Code__c='1';
        conProd.IsConfigFinished__c=false;
        conProd.Is_there_a_liquid_relief_scenario__c='Yes';
        conProd.KOSHA_Compliance__c=false;
        conProd.Lead_Time_Override__c=false;

        conProd.Material_Sourcing_Requirements__c='00';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.NACE__c='N';
        conProd.NIST_Calibrated_Equipment__c=false;
        conProd.Non_Fragmenting_Design_Required__c=false;
        conProd.Operating_Pressure_Ratio__c='OPRNone';
        conProd.Outlet_Connection__c='3/8 BSPP';
        conProd.Outlet_Option_Code__c='2';
        conProd.Packaging_Material__c=false;
        conProd.PED_2014_68_EU_CE_mark__c='NonePED';
        conProd.Pressure_Class__c='C1';
        conProd.Pressure_Range_Type__c='Specify Reference Mfg Range';
        conProd.Pressure_Rating_Type__c='Burst Pressure Min/Max.';
        conProd.Pressure_Setting_Units__c='barg';
        conProd.Pressure_Setting__c=3.5;
        conProd.Pressure_Value_at_discharge__c=14.7;
        conProd.Press_Burst_Pressure_Max_Input__c=3.5;
        conProd.Price_Override__c=false;
        conProd.Process_Media__c='Water';
        conProd.Product_Narrowing_Flag__c=false;
        conProd.Product_Selection__c=TRUE;
        conProd.Product__c='HPZ';
        conProd.Quantity__c=1;
        conProd.Quote_Descriptions_Override__c=false;
        conProd.Rating_and_Range_Flag__c=TRUE;
        conProd.Reach__c=false;
        conProd.Reference_Mfg_Range_Type__c='-10% (-5 Psig)';
        conProd.Relief_Flag__c=true;
        conProd.Relief_Type__c='Pressure Relief';
       // conProd.Relieving_Pressure_at_Inlet__c=0;
        conProd.RG1MAX__c=3.5;
        conProd.RG1MIN__c=0;
        conProd.RG2MAX__c=50.8;
        conProd.RG2MIN__c=0;
        conProd.RG3DRT__c=95;
        conProd.RG3MAX__c=53.4;
        conProd.RG3MIN__c=0;
        conProd.RGEMAX__c=48.3;
        conProd.RGEMIN__c=0;
        conProd.RGSMAX__c=50.8;
        conProd.RGSMIN__c=0;
        conProd.RoHS__c=false;
        conProd.Rupture_Disc_Flow_Capacity_Value__c=550.248088;
        conProd.Sanitary_Requirements_FDA_requirements__c=false;
        conProd.Seat__c='NA';
        conProd.Shell_Test__c=false;
        conProd.Size_Units__c='Metric';
        conProd.Size__c='0108';
        conProd.Sizing_Flag__c=false;
        conProd.Temperature_Setting_Units__c='Deg C';
        conProd.Temperature_Setting__c=130;
        conProd.Temperature_Test_per_ASME__c=false;
        conProd.TMRCHECK__c=0;
        conProd.TMR__c=48.346;
        conProd.MCSM__c='070';
        conProd.TopSection_Thickness__c=0.9999;
        conProd.VacMedia__c='Air';
        conProd.Vacuum_Withstand__c='Full Vacuum';
        conProd.Viscosity_units__c='centipoise';
        conProd.Viscosity__c=1;
        conProd.X2W_NIS__c=false;
        conProd.X3A_Sanitary_Standards__c=false;
        conProd.X4W_NIS__c=false;
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c='BDI';
        conProd.Gasket_Material__c='0B6';
        conProd.Strip_Type__c='024';
        conProd.Wire_Type__c='Blue Shielded Cable';
        conProd.Cable_Length__c='10 ft (3m)';
        conProd.End_Connection__c='Plug End';
        conProd.Wiring_Configuration__c='Test';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.MCSM__c='005';
        conProd.Material_Disc__c='001';
        conProd.Part_Number__c='PARTNUMBER';
        insert conProd;
        RD_Outputs__c rdOut=new RD_Outputs__c();
        rdOut.RD_Outputs_Relation_Field__c=conProd.id;
        insert rdOut;

        RD_Pricing__c RDPrice=new RD_Pricing__c();
        RDPrice.Rupture_Disc__c=conProd.id;
        insert RDPrice;

        RD_Drawings__c rdDia=new RD_Drawings__c();
        rdDia.Rupture_Disc__c=conProd.id;
        rdDia.Dim_A__c='test';
        rdDia.Dim_B_Override__c='test';
        rdDia.Dim_B__c='test';
        rdDia.Dim_C_Override__c='test';
        rdDia.Dim_C__c='test';
        rdDia.Dim_D_Override__c='test';
        rdDia.Dim_D__c='test';
        rdDia.Dim_E_Override__c='test';
        rdDia.Dim_E__c='test';
        rdDia.Dim_F_Override__c='test';
        rdDia.Dim_F__c='test';
        insert rdDia;
    }

    public static void createRDTestRecSecAandEwithPAS(){
        conProd.Relief_Type__c = 'Pressure & Vacuum Relief';
        conProd.Pressure_Setting__c = 100.00;
        conProd.Temperature_Setting__c = 100.00;
        conProd.Vacuum_Setting__c = 100.00;
        conProd.Converted_Vacuum_Setting__c = 100.00;
        conProd.Vac_Converted_Vac_Setting__c = 100.00;
        conProd.Converted_Pressure_Setting__c = 100.00;
        conProd.Converted_Temperature_Setting__c = 100.00;
        conProd.Back_Pressure_Value__c = 100.00;
        conProd.Converted_Back_Pressure_Value__c = 100.00;
        conProd.Converted_Positive_Pressure_Value__c = 100.00;
        conProd.Positive_Pressure_Value__c = 100.00;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Setting_Units__c = 'psig';
        conProd.Back_Pressure_Units__c = 'psig';
        conProd.Positive_Pressure_Units__c = 'psig';
        conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        conProd.Pressure_Withstand__c = 'No Requirements';
        conProd.Vacuum_Withstand__c = 'No Requirements';
        conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Product__c = 'PAS';
        conProd.Seat__c = 'FS';
        conProd.Size__c = '200';
        conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        conProd.Special_Range_Max_Input__c = 100.00;
        conProd.Vac_Special_Range_Min_Input__c = 100.00;
        conProd.Vac_Special_Range_Max_Input__c = 100.00;
        conProd.Material_Girdle__c = '005';
        insert conProd;
    }
    public static void createCost() {
        List<Cost__c> lstCst=new List<Cost__c>();
        Cost__c cost3 = new Cost__c();
        cost3.Cost_Method__c='Assembly';
        cost3.Cost_Sub_Type__c='Router';
        cost3.Inside_Cost_10__c='10';
        cost3.Inside_Cost_20__c='10';
        cost3.Inside_Cost_30__c='10';
        cost3.Inside_Cost_Override_10__c='10';
        cost3.Inside_Cost_Override_20__c='10';
        cost3.Inside_Cost_Override_30__c='10';
        cost3.Outside_Cost_10__c='10';
        cost3.Outside_Cost_20__c='10';
        cost3.Outside_Cost_30__c='10';
        cost3.Outside_Cost_Override_10__c='10';
        cost3.Outside_Cost_Override_20__c='10';
        cost3.Outside_Cost_Override_30__c='10';
        cost3.Part_Number__c='V7658A0312335ARTT00002';
        cost3.Product__c='RD';
        cost3.Ref_Id__c=conProd.Id;
        lstCst.add(cost3);
        Cost__c cost2 = new Cost__c();
        cost2.Cost_Method__c='Build Up';
        cost2.Cost_Sub_Type__c='Router';
        cost2.Inside_Cost_10__c='10';
        cost2.Inside_Cost_20__c='10';
        cost2.Inside_Cost_30__c='10';
        cost2.Inside_Cost_Override_10__c='10';
        cost2.Inside_Cost_Override_20__c='10';
        cost2.Inside_Cost_Override_30__c='10';
        cost2.Outside_Cost_10__c='10';
        cost2.Outside_Cost_20__c='10';
        cost2.Outside_Cost_30__c='10';
        cost2.Outside_Cost_Override_10__c='10';
        cost2.Outside_Cost_Override_20__c='10';
        cost2.Outside_Cost_Override_30__c='10';
        cost2.Part_Number__c='V7658A0312335ARTT00002';
        cost2.Product__c='RD';
        cost2.Ref_Id__c=conProd.Id;
        lstCst.add(cost2);
        Cost__c cost1 = new Cost__c();
        cost1.Cost_Method__c='Overriden';
        cost1.Cost_Sub_Type__c='Router';
        cost1.Inside_Cost_10__c='10';
        cost1.Inside_Cost_20__c='10';
        cost1.Inside_Cost_30__c='10';
        cost1.Inside_Cost_Override_10__c='10';
        cost1.Inside_Cost_Override_20__c='10';
        cost1.Inside_Cost_Override_30__c='10';
        cost1.Outside_Cost_10__c='10';
        cost1.Outside_Cost_20__c='10';
        cost1.Outside_Cost_30__c='10';
        cost1.Outside_Cost_Override_10__c='10';
        cost1.Outside_Cost_Override_20__c='10';
        cost1.Outside_Cost_Override_30__c='10';
        cost1.Part_Number__c='V7658A0312335ARTT00002';
        cost1.Product__c='RD';
        cost1.Ref_Id__c=conProd.Id;
        lstCst.add(cost1);
        insert lstCst;
    }
    public static void createRDTestRecSecAandEwithCAL(){
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 100.00;
        conProd.Temperature_Setting__c = 100.00;
        conProd.Vacuum_Setting__c = 100.00;
        conProd.Converted_Vacuum_Setting__c = 100.00;
        conProd.Vac_Converted_Vac_Setting__c = 100.00;
        conProd.Converted_Pressure_Setting__c = 100.00;
        conProd.Converted_Temperature_Setting__c = 100.00;
        conProd.Back_Pressure_Value__c = 100.00;
        conProd.Converted_Back_Pressure_Value__c = 100.00;
        conProd.Converted_Positive_Pressure_Value__c = 100.00;
        conProd.Positive_Pressure_Value__c = 100.00;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Setting_Units__c = 'psig';
        conProd.Back_Pressure_Units__c = 'psig';
        conProd.Positive_Pressure_Units__c = 'psig';
        conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        conProd.Pressure_Withstand__c = 'Positive Pressure';
        conProd.Vacuum_Withstand__c = 'Back Pressure';
        conProd.Constrain_product_selection__c = 'Pressure';
        conProd.constrain_product_selection_by_flow__c = 'No';
        conProd.Product__c = 'CAL';
        conProd.Seat__c = 'FS';
        conProd.Size__c = '200';
        conProd.Material_Girdle__c = '071';
        conProd.Pressure_Range_Type__c = 'Zero';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        conProd.Pressure_Rating_Type__c = 'No Rating But Must Withstand';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        conProd.Vac_Range_Type__c = 'Zero';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        conProd.Vac_Rating_Type__c = 'No Rating But Must Withstand';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        insert conProd;
    }

    public static void createRDTestRecSecAandEwithHPZ(){
        conProd.Relief_Type__c = 'Pressure Relief';
        conProd.Pressure_Setting__c = 100.00;
        conProd.Temperature_Setting__c = 100.00;
        conProd.Vacuum_Setting__c = 100.00;
        conProd.Converted_Vacuum_Setting__c = 100.00;
        conProd.Vac_Converted_Vac_Setting__c = 100.00;
        conProd.Converted_Pressure_Setting__c = 100.00;
        conProd.Converted_Temperature_Setting__c = 100.00;
        conProd.Back_Pressure_Value__c = 100.00;
        conProd.Converted_Back_Pressure_Value__c = 100.00;
        conProd.Converted_Positive_Pressure_Value__c = 100.00;
        conProd.Positive_Pressure_Value__c = 100.00;
        conProd.Pressure_Setting_Units__c = 'psig';
        conProd.Temperature_Setting_Units__c = 'Deg F';
        conProd.Vacuum_Setting_Units__c = 'psig';
        conProd.Back_Pressure_Units__c = 'psig';
        conProd.Positive_Pressure_Units__c = 'psig';
        conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        // // conProd.Pressure_Withstand__c = 'Back Pressure';
        // // conProd.Vacuum_Withstand__c = 'Positive Pressure';
        // conProd.Constrain_product_selection__c = 'Pressure';
        conProd.Rating_and_Range_Flag__c = true;
        conProd.Product__c = 'HPZ';
        conProd.Seat__c = 'NA';
        conProd.Size__c = '0108';
        conProd.Quote_Line__c = quoteLine.Id;
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c='BDI';
        conProd.Gasket_Material__c='0B6';
        conProd.Strip_Type__c='024';
        conProd.Wire_Type__c='Blue Shielded Cable';
        conProd.Cable_Length__c='10 ft (3m)';
        conProd.End_Connection__c='Plug End';
        conProd.Wiring_Configuration__c='Test';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.Material_Arcuate_Ring__c='001';
        conProd.finish_configuration_flag__c=true;
        conProd.Quantity__c=1;
         conProd.Individual_Packaging__c=true;
        conProd.surface_finish__c='15';
        conProd.NACE__c='MR0175';
        insert conProd;
        RD_Outputs__c rdOut=new RD_Outputs__c();

        rdOut.RD_Outputs_Relation_Field__c=conProd.id;
        insert rdOut;

        RD_Pricing__c RDPrice=new RD_Pricing__c();
        RDPrice.Rupture_Disc__c=conProd.id;
        insert RDPrice;

        RD_Drawings__c rdDia=new RD_Drawings__c();
        rdDia.Rupture_Disc__c=conProd.id;
        rdDia.Dim_A__c='test';
        rdDia.Dim_B_Override__c='test';
        rdDia.Dim_B__c='test';
        rdDia.Dim_C_Override__c='test';
        rdDia.Dim_C__c='test';
        rdDia.Dim_D_Override__c='test';
        rdDia.Dim_D__c='test';
        rdDia.Dim_E_Override__c='test';
        rdDia.Dim_E__c='test';
        rdDia.Dim_F_Override__c='test';
        rdDia.Dim_F__c='test';
        insert rdDia;
    }

    public static void createRDTestRecordForPricing(){
        RDPricingTestDiscPrice__c testDisc=new RDPricingTestDiscPrice__c();
        testDisc.TestDiscPriceMethod__c=4;
        testDisc.PTC__c='HPZ';
        insert testDisc;
        //select id,TestDiscPriceMethod__c from RDPricingTestDiscPrice__c where PTC__c=:PT
        conProd.Quote_Line__c = quoteLine.Id;
        conProd.Part_Number__c='V7658A0312335ARTT00002';
        conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=false;
        conProd.Animal_Derivative__c=false;
        conProd.ASME_BPE__c=false;
        conProd.ASME_Inlet_Option_Code__c='A';
        conProd.ASME_Outlet_Option_Code__c='1';
        conProd.ASME_Section_VIII_Division_1__c=false;
        conProd.Assigned_RangeType__c='-10% (-5 psig)';
        conProd.ASSYPARTNOBASE__c='DHPZ0108NA';
        conProd.Atex_Certificate__c=true;
        conProd.BMRCHECK__c=50.890526;
        conProd.Build_Cost_Override__c=false;
        conProd.Bypass__c=false;
        conProd.surface_finish__c='15';
        conProd.Certificate_of_Origin__c=false;
        conProd.China_Manufacturing_License__c='CUSTSI';
        conProd.Cleanings__c='N';
        conProd.Coefficient_of_Discharge__c='0.62';
        conProd.Comply_with_AD2000_Merkblat_A1__c=true;
        conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c=true;
        conProd.Components_Flag__c=TRUE;
        conProd.constrain_product_selection_by_flow__c='Yes';
        conProd.Converted_Density_at_Inlet__c=0;
        conProd.Converted_Density_Speci_Volume_SpeGravit__c=1;
        conProd.Converted_Flow_rate__c=0;
        conProd.Converted_Pressure_Setting__c=50.7633;
        conProd.Converted_Relieving_Pressure_Value__c=4.513254738;
        conProd.Converted_Relieving_Temperature__c=0;
        conProd.Converted_Specific_Volume__c=0;
        conProd.Converted_Temperature_Setting__c=266;
        conProd.Converted_Viscosity__c=0.001;
        conProd.Coshh__c=false;
        conProd.CSA_Marking_CRN_Number__c=true;
        conProd.Customer_Specific_Requirements__c='N';
        conProd.CU_TR__c=true;
        conProd.Density_SpecificVolume_SpcfcGravityUnits__c='kg/L';
        conProd.Density_Specific_Volume_Specific_Gravity__c=62.371;
        conProd.Diagram_Override__c=false;
        conProd.Discountable_Price__c=1596;
        conProd.Disc_Thickness__c=0.004;
        conProd.Dodd_Frank_Conflict_Minerals__c=false;
        conProd.Drawing_Outside_Config__c=false;
        conProd.DSCVAR__c='A';
        conProd.Edit_QuoteLine__c=false;
        conProd.Electro_polish__c=false;
        conProd.Evaluation_Per__c='ISO Liquid';
        conProd.Evaluation_Type__c='Capacity';
        conProd.Final_Assembly_Location_Requirements__c='00';
        conProd.Finish_Configuration_Flag__c=false;
        conProd.General_Environmental_Compliance__c=false;
        conProd.Halogen_Based_Restrictions_for_cleaning__c=false;
        conProd.Individual_Packaging__c=true;
        conProd.Inlet_Connection__c='3/8 BSPP';
        conProd.Inlet_Option_Code__c='1';
        conProd.IsConfigFinished__c=false;
        conProd.Is_there_a_liquid_relief_scenario__c='Yes';
        conProd.KOSHA_Compliance__c=true;
        conProd.Lead_Time_Override__c=false;

        conProd.Material_Sourcing_Requirements__c='00';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.NACE__c='MR0175';
        conProd.NIST_Calibrated_Equipment__c=false;
        conProd.Non_Fragmenting_Design_Required__c=false;
        conProd.Operating_Pressure_Ratio__c='OPRNone';
        conProd.Outlet_Connection__c='3/8 BSPP';
        conProd.Outlet_Option_Code__c='2';
        conProd.Packaging_Material__c=false;
        conProd.PED_2014_68_EU_CE_mark__c='NonePED';
        conProd.Pressure_Class__c='C1';
        conProd.Pressure_Range_Type__c='Specify Reference Mfg Range';
        conProd.Pressure_Rating_Type__c='Burst Pressure Min/Max.';
        conProd.Pressure_Setting_Units__c='barg';
        conProd.Pressure_Setting__c=3.5;
        conProd.Pressure_Value_at_discharge__c=14.7;
        conProd.Press_Burst_Pressure_Max_Input__c=3.5;
        conProd.Price_Override__c=false;
        conProd.Process_Media__c='Water';
        conProd.Product_Narrowing_Flag__c=false;
        conProd.Product_Selection__c=TRUE;
        conProd.Product__c='HPZ';
        conProd.Quantity__c=1;
        conProd.Quote_Descriptions_Override__c=false;
        conProd.Rating_and_Range_Flag__c=TRUE;
        conProd.Reach__c=false;
        conProd.Reference_Mfg_Range_Type__c='-10% (-5 Psig)';
        conProd.Relief_Flag__c=true;
        conProd.Relief_Type__c='Pressure Relief';
       // conProd.Relieving_Pressure_at_Inlet__c=0;
        conProd.RG1MAX__c=3.5;
        conProd.RG1MIN__c=0;
        conProd.RG2MAX__c=50.8;
        conProd.RG2MIN__c=0;
        conProd.RG3DRT__c=95;
        conProd.RG3MAX__c=53.4;
        conProd.RG3MIN__c=0;
        conProd.RGEMAX__c=48.3;
        conProd.RGEMIN__c=0;
        conProd.RGSMAX__c=50.8;
        conProd.RGSMIN__c=0;
        conProd.RoHS__c=false;
        conProd.Rupture_Disc_Flow_Capacity_Value__c=550.248088;
        conProd.Sanitary_Requirements_FDA_requirements__c=false;
        conProd.Seat__c='NA';
        conProd.Shell_Test__c=false;
        conProd.Size_Units__c='Metric';
        conProd.Size__c='0108';
        conProd.Sizing_Flag__c=false;
        conProd.Temperature_Setting_Units__c='Deg C';
        conProd.Temperature_Setting__c=130;
        conProd.Temperature_Test_per_ASME__c=true;
        conProd.TMRCHECK__c=0;
        conProd.TMR__c=48.346;
        conProd.MCSM__c='070';
        conProd.TopSection_Thickness__c=0.9999;
        conProd.VacMedia__c='Air';
        conProd.Vacuum_Withstand__c='Back Pressure';
        conProd.Viscosity_units__c='centipoise';
        conProd.Viscosity__c=1;
        conProd.X2W_NIS__c=false;
        conProd.X3A_Sanitary_Standards__c=false;
        conProd.X4W_NIS__c=false;
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c='BDI';
        conProd.Gasket_Material__c='0B6';
        conProd.Strip_Type__c='024';
        conProd.Wire_Type__c='Blue Shielded Cable';
        conProd.Cable_Length__c='10 ft (3m)';
        conProd.End_Connection__c='Plug End';
        conProd.Wiring_Configuration__c='Test';
        conProd.MetalSeal_Thickness__c=0.0015;
        conProd.MCSM__c='005';
        conProd.Material_Disc__c='001';
     //   conProd.Part_Number__c='PARTNUMBER';
        conProd.back_pressure_units__c='psig';
        conProd.back_pressure_value__c=9;
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c='BDI';
        conProd.Gasket_Material__c='0B6';
        conProd.Strip_Type__c='024';
        conProd.Wire_Type__c='Blue Shielded Cable';
        conProd.Cable_Length__c='10 ft (3m)';
        conProd.End_Connection__c='Plug End';
        conProd.Wiring_Configuration__c='test';

        conProd.Material_Armor_Ring2__c='001';
        conProd.Material_Armor_Ring__c='001';
        conProd.Material_Dent_Protector__c='001';
        conProd.Material_Gasket__c='001';
        conProd.Material_Girdle_Cover__c='001';
        conProd.Material_Inlet_Gasket__c='001';
        conProd.Material_Girdle__c='001';
        conProd.Material_Handling_Support__c='001';
        conProd.Material_Hi_Temp_Assembly__c='001';
        conProd.Material_Holddown_Ring__c='001';
        conProd.Material_Inlet_Coating2__c='001';
        conProd.Material_Inlet_Coating__c='001';
        conProd.Material_Inlet_Liner__c='001';
        conProd.Material_Inlet_O_Ring__c='099';
        conProd.Material_Inlet_Ring2__c='001';
        conProd.Material_Inlet_Ring3__c='001';
        conProd.Material_Inlet_Ring__c='001';
        conProd.Material_Inlet__c='001';
        conProd.Material_Integral_BDI__c='001';
        conProd.Material_Knifeblade__c='001';
        conProd.Material_Middle_Ring__c='001';
        conProd.Material_Outlet_Coating__c='001';
        conProd.Material_Outlet_Gasket__c='001';
        conProd.Material_Outlet_Liner__c='001';
        conProd.Material_Outlet_Ring__c='001';
        conProd.Material_Outlet__c='071';
        conProd.Material_Seal2__c='071';
        conProd.Material_Seal3__c='071';
        conProd.Material_Seal__c='071';
        conProd.Material_Top_Section2__c='001';
        conProd.Material_Top_Section__c='001';
        conProd.Material_Vaccum_Support3__c='001';
        conProd.Material_Vacuum_Support2__c='001';
        conProd.Material_Vacuum_Support__c='001';
        conProd.Material_Arcuate_Ring__c='001';
        insert conProd;
        RD_Outputs__c rdOut=new RD_Outputs__c();
        rdOut.RD_Outputs_Relation_Field__c=conProd.id;
        insert rdOut;

        RD_Pricing__c RDPrice=new RD_Pricing__c();
        RDPrice.Rupture_Disc__c=conProd.id;
        insert RDPrice;

        RD_Drawings__c rdDia=new RD_Drawings__c();
        rdDia.Rupture_Disc__c=conProd.id;
        rdDia.Dim_A__c='test';
        rdDia.Dim_B_Override__c='test';
        rdDia.Dim_B__c='test';
        rdDia.Dim_C_Override__c='test';
        rdDia.Dim_C__c='test';
        rdDia.Dim_D_Override__c='test';
        rdDia.Dim_D__c='test';
        rdDia.Dim_E_Override__c='test';
        rdDia.Dim_E__c='test';
        rdDia.Dim_F_Override__c='test';
        rdDia.Dim_F__c='test';
        insert rdDia;
    }
	@isTest
    public static void createRDMasterTestRecords(){
    		//convertPressure Method
      		List<Pressure__c> conPresTD = Test.loadData(Pressure__c.sObjectType, 'TestData_PressureTable');
            List<Temparature__c> conTempTD = Test.loadData(Temparature__c.sObjectType, 'TestData_TemperatureTable');


        	Cost__c cost1 = new Cost__c();
        cost1.Cost_Method__c='Assembly';
        cost1.Cost_Sub_Type__c='Router';
        cost1.Inside_Cost_10__c='10';
        cost1.Inside_Cost_20__c='10';
        cost1.Inside_Cost_30__c='10';
        cost1.Inside_Cost_Override_10__c='10';
        cost1.Inside_Cost_Override_20__c='10';
        cost1.Inside_Cost_Override_30__c='10';
        cost1.Outside_Cost_10__c='10';
        cost1.Outside_Cost_20__c='10';
        cost1.Outside_Cost_30__c='10';
        cost1.Outside_Cost_Override_10__c='10';
        cost1.Outside_Cost_Override_20__c='10';
        cost1.Outside_Cost_Override_30__c='10';
        cost1.Part_Number__c='V7658A0312335ARTT00002';
        cost1.Product__c='WGB';
		insert cost1;

        Cost__c cost2 = new Cost__c();
        cost2.Cost_Method__c='Assembly';
        cost2.Cost_Sub_Type__c='Router';
        cost2.Inside_Cost_10__c='10';
        cost2.Inside_Cost_20__c='10';
        cost2.Inside_Cost_30__c='10';
        cost2.Inside_Cost_Override_10__c='10';
        cost2.Inside_Cost_Override_20__c='10';
        cost2.Inside_Cost_Override_30__c='10';
        cost2.Outside_Cost_10__c='10';
        cost2.Outside_Cost_20__c='10';
        cost2.Outside_Cost_30__c='10';
        cost2.Outside_Cost_Override_10__c='10';
        cost2.Outside_Cost_Override_20__c='10';
        cost2.Outside_Cost_Override_30__c='10';
        cost2.Part_Number__c='V7658A0312335ARTT00002';
        cost2.Product__c='WGB';
		insert cost2;

        Cost__c cost3 = new Cost__c();
        cost3.Cost_Method__c='Assembly';
        cost3.Cost_Sub_Type__c='Router';
        cost3.Inside_Cost_10__c='10';
        cost3.Inside_Cost_20__c='10';
        cost3.Inside_Cost_30__c='10';
        cost3.Inside_Cost_Override_10__c='10';
        cost3.Inside_Cost_Override_20__c='10';
        cost3.Inside_Cost_Override_30__c='10';
        cost3.Outside_Cost_10__c='10';
        cost3.Outside_Cost_20__c='10';
        cost3.Outside_Cost_30__c='10';
        cost3.Outside_Cost_Override_10__c='10';
        cost3.Outside_Cost_Override_20__c='10';
        cost3.Outside_Cost_Override_30__c='10';
        cost3.Part_Number__c='V7658A0312335ARTT00002';
        cost3.Product__c='WGB';
		insert cost3;

        RD_tblMfgData__c rdMfd1=new RD_tblMfgData__c();
        rdMfd1.AMBIENT_AVG__c=58.25;
        rdMfd1.CDC_Ext_ID__c='19';
        //FrdMfd2lag__c
        rdMfd1.M220__c	=0.0055;
        rdMfd1.M280__c	=0;
        rdMfd1.M390__c	=0;
        rdMfd1.MCD__c='005';
        //rrdMfd2dMfd1.MCSM__c	=null;
        rdMfd1.PartNo__c='';
        rdMfd1.PTC__c	='STD';
        rdMfd1.SEALTYPE__c	='';
        rdMfd1.SerialNo__c	='104098';
        rdMfd1.STC__c	='LL';
        rdMfd1.SZC__c	='0108';
        rdMfd1.TEMP_AVG__c	=0;
        rdMfd1.TEMP_VAL__c	=72;
        rdMfd1.WorkorderNo__c='104098';
        insert rdMfd1;
        RDtblMfgDataTable.add(rdMfd1);

        RD_tblMfgData__c rdMfd2=new RD_tblMfgData__c();
        rdMfd2.AMBIENT_AVG__c=58.25;
        rdMfd2.CDC_Ext_ID__c='1';
        //Flag__c
        rdMfd2.M220__c	=0.0055;
        rdMfd2.M280__c	=0;
        rdMfd2.M390__c	=0;
        rdMfd2.MCD__c='005';
        //rdMfd1.MCSM__c	=null;
        rdMfd2.PartNo__c='';
        rdMfd2.PTC__c	='CAL';
        rdMfd2.SEALTYPE__c	='';
        rdMfd2.SerialNo__c	='104098';
        rdMfd2.STC__c	='FS';
        rdMfd2.SZC__c	='0200';
        rdMfd2.TEMP_AVG__c	=0;
        rdMfd2.TEMP_VAL__c	=72;
        rdMfd2.WorkorderNo__c='104098';
        RDtblMfgDataTable.add(rdMfd2);
        RD_tblMfgData__c rdMfd3=new RD_tblMfgData__c();
        rdMfd3.AMBIENT_AVG__c=58.25;
        rdMfd3.CDC_Ext_ID__c='18';
        //Flag__c
        rdMfd3.M220__c	=0.0055;
        rdMfd3.M280__c	=0;
        rdMfd3.M390__c	=0;
        rdMfd3.MCD__c='005';
        //rdMfd1.MCSM__c	=null;
        rdMfd3.PartNo__c='';
        rdMfd3.PTC__c	='PAS';
        rdMfd3.SEALTYPE__c	='';
        rdMfd3.SerialNo__c	='104098';
        rdMfd3.STC__c	='FS';
        rdMfd3.SZC__c	='0200';
        rdMfd3.TEMP_AVG__c	=0;
        rdMfd3.TEMP_VAL__c	=72;
        rdMfd3.WorkorderNo__c='104098';
        RDtblMfgDataTable.add(rdMfd3);
        RD_tblMfgData__c rdMfd4=new RD_tblMfgData__c();
        rdMfd4.AMBIENT_AVG__c=58.25;
        rdMfd4.CDC_Ext_ID__c='16';
        //Flag__c
        rdMfd4.M220__c	=0.0055;
        rdMfd4.M280__c	=0;
        rdMfd4.M390__c	=0;
        rdMfd4.MCD__c='005';
        //rdMfd1.MCSM__c	=null;
        rdMfd4.PartNo__c='';
        rdMfd4.PTC__c	='HPZ';
        rdMfd4.SEALTYPE__c	='';
        rdMfd4.SerialNo__c	='104098';
        rdMfd4.STC__c	='NA';
        rdMfd4.SZC__c	='0200';
        rdMfd4.TEMP_AVG__c	=0;
        rdMfd4.TEMP_VAL__c	=72;
        rdMfd4.WorkorderNo__c='104098';
        insert rdMfd4;
        RDtblMfgDataTable.add(rdMfd4);
        RDtblMfgDataTable.add(rdMfd4);
        RDtblMfgDataTable.add(rdMfd4);
        RDtblMfgDataTable.add(rdMfd4);
        RDtblMfgDataTable.add(rdMfd4);
        RDtblMfgDataTable.add(rdMfd4);


        RD_tblMfgData__c rdMfd51=new RD_tblMfgData__c();
        rdMfd51.AMBIENT_AVG__c=58.25;
        rdMfd51.CDC_Ext_ID__c='12';
        //Flag__c
        rdMfd51.M220__c	=0.0055;
        rdMfd51.M280__c	=0;
        rdMfd51.M390__c	=0;
        rdMfd51.MCD__c='005';
        //rdMfd1.MCSM__c	=null;
        rdMfd51.PartNo__c='';
        rdMfd51.PTC__c	='HPX';
        rdMfd51.SEALTYPE__c	='';
        rdMfd51.SerialNo__c	='104098';
        rdMfd51.STC__c	='FS';
        rdMfd51.SZC__c	='0108';
        rdMfd51.TEMP_AVG__c	=0;
        rdMfd51.TEMP_VAL__c	=72;
        rdMfd51.WorkorderNo__c='104098';
        insert rdMfd51;
        RDtblMfgDataTable.add(rdMfd51);

        RD_tblMfgData__c rdMfd5=new RD_tblMfgData__c();
        rdMfd5.AMBIENT_AVG__c=58.25;
        rdMfd5.CDC_Ext_ID__c='13';
        //Flag__c
        rdMfd5.M220__c	=0.0055;
        rdMfd5.M280__c	=0;
        rdMfd5.M390__c	=0;
        rdMfd5.MCD__c='005';
        //rdMfd1.MCSM__c	=null;
        rdMfd5.PartNo__c='';
        rdMfd5.PTC__c	='HPX';
        rdMfd5.SEALTYPE__c	='';
        rdMfd5.SerialNo__c	='104098';
        rdMfd5.STC__c	='FS';
        rdMfd5.SZC__c	='0200';
        rdMfd5.TEMP_AVG__c	=0;
        rdMfd5.TEMP_VAL__c	=72;
        rdMfd5.WorkorderNo__c='104098';
        insert rdMfd5;
        RDtblMfgDataTable.add(rdMfd5);
		/*List<RD_Cost__c> costRDCost = Test.loadData(RD_Cost__c.sObjectType, 'Cost_RDCost');
        List<Cost_Part_Number__c> costPartNumber = Test.loadData(Cost_Part_Number__c.sObjectType, 'Cost_CostPartNumber');
        List<Cost_Routing_Outside__c> costRoutingOutside = Test.loadData(Cost_Routing_Outside__c.sObjectType, 'Cost_Cost_Routing_Outside');
        List<Cost_Routing_Inside__c> costRoutingInside = Test.loadData(Cost_Routing_Inside__c.sObjectType, 'Cost_Cost_Routing_Inside'); */

            List<RD_ProductList__c> RDProductTable = Test.loadData(RD_ProductList__c.sObjectType, 'RDProductListTestData');
            List<RD_SeatList__c> RDSeatTable = Test.loadData(RD_SeatList__c.sObjectType, 'RDSeatListTestData');
            List<RD_SizeList__c> RDSizeTable = Test.loadData(RD_SizeList__c.sObjectType, 'RDSizeListTestData');
            List<RD_tblASMEValues__c> RDtblASMEValuesTable = Test.loadData(RD_tblASMEValues__c.sObjectType, 'RDtblASMEValuesTestData');
            List<Media_Property__c> MediaPropertyTable = Test.loadData(Media_Property__c.sObjectType, 'MediaPropertyTestData');
         //   List<ISODryKs__c> ISODryKsMasterData = Test.loadData(ISODryKs__c.sObjectType, 'RDISODryKsMasterData');
            List<RD_GeneralMaterialsList__c> RDGeneralMaterialListTable = Test.loadData(RD_GeneralMaterialsList__c.sObjectType, 'RDGeneralMaterialListTestData');
            List<Derate_Value__c> DerateValueTable= Test.loadData(Derate_Value__c.sObjectType, 'DerateValueTestData');
            lstDerateVal = DerateValueTable;
            List<RDMasterBlaster__c> RDMasterBlasterTable = Test.loadData(RDMasterBlaster__c.sObjectType, 'RDMasterBlasterTestData');
            for(RDMasterBlaster__c eachRDMB : RDMasterBlasterTable){
                lstRDMBIds.add(eachRDMB.Id);
            }
            List<RD_D_DiscHolderParts__c> RDDDiscHolderPartsTable= Test.loadData(RD_D_DiscHolderParts__c.sObjectType, 'RDDDiscHolderPartsTestData');
            List<RD_D_tblInletForScrewType__c> RDDtblInletForScrewTypeTable = Test.loadData(RD_D_tblInletForScrewType__c.sObjectType, 'RDDtblInletForScrewTypeTestData');

        	//Cost Tables
        	List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData');
            List<RD_Cost__c> costRDCost = Test.loadData(RD_Cost__c.sObjectType, 'Cost_RDCost');
            List<Cost_Part_Number__c> costPartNumber = Test.loadData(Cost_Part_Number__c.sObjectType, 'Cost_CostPartNumber');
            List<Cost_Routing_Outside__c> costRoutingOutside = Test.loadData(Cost_Routing_Outside__c.sObjectType, 'Cost_Cost_Routing_Outside');
            List<Cost_Routing_Inside__c> costRoutingInside = Test.loadData(Cost_Routing_Inside__c.sObjectType, 'Cost_Cost_Routing_Inside');
            //RDDiscTypeListMasterData
            List<Disc_Type_List__c> RDDiscTypeListMasterData = Test.loadData(Disc_Type_List__c.sObjectType, 'RDDiscTypeListMasterData');
            List<IFS_character_codes__c> RDIFSInterfaceMasterData = Test.loadData(IFS_character_codes__c.sObjectType, 'RDIFSInterfaceMasterData');
            List<RD_Holder_Component_Part_Number__c> RDHolderComponentPartNumberMasterData = Test.loadData(RD_Holder_Component_Part_Number__c.sObjectType, 'RDHolderComponentPartNumberMasterData');
            List<RDSourceCode__c> RDSourceCodeMasterData = Test.loadData(RDSourceCode__c.sObjectType, 'RDSourceCodeMasterData');
            List<RD_Test_Code__c> RDTestCodeMasterData = Test.loadData(RD_Test_Code__c.sObjectType, 'RDTestCodeMasterData');
            List<RD_Option_Code__c> RDOptionCodeMasterData = Test.loadData(RD_Option_Code__c.sObjectType, 'RDOptionCodeMasterData');
            List<RD_Output_OA__c> RDOutputOAMasterData = Test.loadData(RD_Output_OA__c.sObjectType, 'RDOutputOAMasterData');
            List<RD_Disc_LeadTime_Options__c> RDDiscLeadTimeOptionsData = Test.loadData(RD_Disc_LeadTime_Options__c.sObjectType, 'RDDiscLeadTimeOptionsData');
            List<RD_Disc_LeadTime_Product__c> RDDiscLeadTimeProductData = Test.loadData(RD_Disc_LeadTime_Product__c.sObjectType, 'RDDiscLeadTimeProductData');
            List<GlobalLeadTime__c> RDLeadTime = Test.loadData(GlobalLeadTime__c.sObjectType, 'RDLeadTime');

            List<RD_RoutingTranslation__c> RDRoutingTransulationData = Test.loadData(RD_RoutingTranslation__c.sObjectType, 'RDRoutingTransulationData');
            List<RD_RoutingDetail__c> RDRoutingDetailData = Test.loadData(RD_RoutingDetail__c.sObjectType, 'RDRoutingDetailData');

            List<RD_WorkGuidelinesTranslation__c> RDWorkGuidelinesTranslationData = Test.loadData(RD_WorkGuidelinesTranslation__c.sObjectType, 'RDWorkGuidelinesTranslationData');
            List<RD_WorkGuidelinesDetail__c> RDWorkGuidelinesDetailData = Test.loadData(RD_WorkGuidelinesDetail__c.sObjectType, 'RDWorkGuidelinesDetailData');

            List<RD_ControlPlanTranslation__c> RDControlPlanTranslationData = Test.loadData(RD_ControlPlanTranslation__c.sObjectType, 'RDControlPlanTranslationData');
            List<RD_ControlPlanDetail__c> RDControlPlanDetailData = Test.loadData(RD_ControlPlanDetail__c.sObjectType, 'RDControlPlanDetailData');

            List<RD_EvaluationTranslation__c> RDEvaluationTranslationData = Test.loadData(RD_EvaluationTranslation__c.sObjectType, 'RDEvaluationTranslationData');
            List<RD_EvaluationDetail__c> RDEvaluationDetailData = Test.loadData(RD_EvaluationDetail__c.sObjectType, 'RDEvaluationDetailData');

            List<RD_Attributes_LookUp_Translation__c> RDAttributesLookUpTranslationData = Test.loadData(RD_Attributes_LookUp_Translation__c.sObjectType, 'RDAttributesLookUpTranslationData');
            List<RD_Attributes_Lookup_Detail__c> RDAttributesLookupDetailData = Test.loadData(RD_Attributes_Lookup_Detail__c.sObjectType, 'RDAttributesLookupDetailData');


            List<RD_Output_OW_Translation__c> RDOutputOWTranslationData = Test.loadData(RD_Output_OW_Translation__c.sObjectType, 'RDOutputOWTranslationData');
            List<RD_Output_OW_Detail__c> RDOutputOWDetailData = Test.loadData(RD_Output_OW_Detail__c.sObjectType, 'RDOutputOWDetailData');

            List<RD_PTCCrossRef__c> RDPTCCrossRefTable = Test.loadData(RD_PTCCrossRef__c.sObjectType, 'RDPTCCrossRefTestData');
            List<RD_STCCrossRef__c> RDSTCCrossRefTable = Test.loadData(RD_STCCrossRef__c.sObjectType, 'RDSTCCrossRefTestData');
           // List<RD_tblMfgData__c> RDtblMfgDataTable = Test.loadData(RD_tblMfgData__c.sObjectType, 'RDtblMfgDataTestData');

            List<RD_tblCompCapHt__c> RDtblCompCapHtData = Test.loadData(RD_tblCompCapHt__c.sObjectType, 'RDtblCompCapHtData');
            List<Disc_Information__c> DiscInformationMasterData = Test.loadData(Disc_Information__c.sObjectType, 'DiscInformationMasterData');
            lstDiscInformation = DiscInformationMasterData;

            List<RD_Inlet_Ring_Part_Number__c> RDInletRingPartNumberMasterData = Test.loadData(RD_Inlet_Ring_Part_Number__c.sObjectType, 'RDInletRingPartNumberMasterData');
            List<Inlet_Liner_Part_Number__c> RDInletLinerPartNumber = Test.loadData(Inlet_Liner_Part_Number__c.sObjectType, 'RDInletLinerPartNumber');
            List<Outlet_Ring_Part_Number__c> RDOutletRingPartNumberMasterData = Test.loadData(Outlet_Ring_Part_Number__c.sObjectType, 'RDOutletRingPartNumberMasterData');
            List<RD_Integral_BDI_Part_Number__c> RDIntegralBDIPartNumberMasterData = Test.loadData(RD_Integral_BDI_Part_Number__c.sObjectType, 'RDIntegralBDIPartNumberMasterData');
            List<RD_Integral_BDI_Table__c> RDIntegralBDITableMasterData = Test.loadData(RD_Integral_BDI_Table__c.sObjectType, 'RDIntegralBDITableMasterData');

            List<RD_Metal_Seal_Part_Number__c> RDMetalSealPartNumberMasterData = Test.loadData(RD_Metal_Seal_Part_Number__c.sObjectType, 'RDMetalSealPartNumberMasterData');

            List<RD_Teflon_Seal_Part_Number__c> RDTeflonSealPartNumberMasterData = Test.loadData(RD_Teflon_Seal_Part_Number__c.sObjectType, 'RDTeflonSealPartNumberMasterData');

            List<RD_Girdle_Part_Number__c> RDGirdlePartNumberMasterData = Test.loadData(RD_Girdle_Part_Number__c.sObjectType, 'RDGirdlePartNumberMasterData');

            List<RD_Top_Section_Part_Number__c> RDTopSectionPartNumberMasterData = Test.loadData(RD_Top_Section_Part_Number__c.sObjectType, 'RDTopSectionPartNumberMasterData');

            List<OutletGasketPartNumber__c> RDOutletGasketPartNumberMasterData = Test.loadData(OutletGasketPartNumber__c.sObjectType, 'RDOutletGasketPartNumberMasterData');

            List<RD_Vacuum_Support_Part_Number__c> RD_VaccumSupportPartNumberMasterData = Test.loadData(RD_Vacuum_Support_Part_Number__c.sObjectType, 'RD_VaccumSupportPartNumberMasterData');

            List<RD_Disc_Part_Number__c> RDDiscPartNumberMasterData = Test.loadData(RD_Disc_Part_Number__c.sObjectType, 'RDDiscPartNumberMasterData');

            List<RD_Girdle_Cover_Part_Number__c> RDGirdleCoverPartNumberMasterData = Test.loadData(RD_Girdle_Cover_Part_Number__c.sObjectType, 'RDGirdleCoverPartNumberMasterData');

            List<RD_Arcuate_Ring_Part_Number__c> RD_ArcuateRingPartNumberBaseData = Test.loadData(RD_Arcuate_Ring_Part_Number__c.sObjectType, 'RD_ArcuateRingPartNumberBaseData');

            List<RD_XML_Outputs__c> RDXMLOutputsMasterData = Test.loadData(RD_XML_Outputs__c.sObjectType, 'RDXMLOutputsMasterData');

            List<RD_Manufacturing_Document_Translation__c> RDManufacturingDocumentTranslationData = Test.loadData(RD_Manufacturing_Document_Translation__c.sObjectType, 'RDManufacturingDocumentTranslationData');

            List<RD_Manufacturing_Document_Detail__c> RD_ManufacturingDocumentDetailData = Test.loadData(RD_Manufacturing_Document_Detail__c.sObjectType, 'RD_ManufacturingDocumentDetailData');


            List<RDPricingDiscComponentPricing__c> RDPricingDiscComponentPricingMasterData = Test.loadData(RDPricingDiscComponentPricing__c.sObjectType, 'RDPricingDiscComponentPricingMasterData');

            List<RDPricingLotCharges__c> RDPricingLotChargesMasterData = Test.loadData(RDPricingLotCharges__c.sObjectType, 'RDPricingLotChargesMasterData');


            List<RDP_HPricingHolderCompPricing__c> RDP_HPricingHolderCompPricingMAsterData = Test.loadData(RDP_HPricingHolderCompPricing__c.sObjectType, 'RDP_HPricingHolderCompPricingMAsterData');


            List<RD_ComponentMBTranslation__c> RD_ComponentMBTranslation = Test.loadData(RD_ComponentMBTranslation__c.sObjectType, 'RD_ComponentMBTranslation');
            List<RD_ComponentMBDetail__c> RD_ComponentMBDetailMasterData = Test.loadData(RD_ComponentMBDetail__c.sObjectType, 'RD_ComponentMBDetailMasterData');

            List<Girdle_Lim_Check__c> RD_GirdleLimCheckTable = Test.loadData(Girdle_Lim_Check__c.sObjectType, 'RD_GirdleLimCheckTestData');
            lstGirdleLimCheck = RD_GirdleLimCheckTable;
            List<RD_ShopRangeValues__c> RD_ShopRangeValuesTable = Test.loadData(RD_ShopRangeValues__c.sObjectType, 'RD_ShopRangeValuesTestData');
            lstShopRngValue = RD_ShopRangeValuesTable;

            List<Manufacturing_Range_Value__c> RD_ManufacturingRangeValueTable = Test.loadData(Manufacturing_Range_Value__c.sObjectType, 'RD_ManufacturingRangeValueTestData');
            lstManufacturingRangeValue = RD_ManufacturingRangeValueTable;

            List<RD_Seals_Component_Materials__c> RD_SealsComponentMaterialsTable = Test.loadData(RD_Seals_Component_Materials__c.sObjectType, 'RD_SealsComponentMaterialsTestData');
            List<RD_tblBurstTolMethod__c> RD_tblBurstTolMethodTable = Test.loadData(RD_tblBurstTolMethod__c.sObjectType, 'RD_tblBurstTolMethodTestData');
            lstRDtblBurstTolMeth = RD_tblBurstTolMethodTable;

            List<RD_Rating_Range__c> RD_Rating_RangeDatatable=Test.loadData(RD_Rating_Range__c.sObjectType, 'RDRatingRangeData');
            List<RD_NEW_PosRatingRange__c> RD_NEWPosRatingRangeTable = Test.loadData(RD_NEW_PosRatingRange__c.sObjectType, 'RD_NEWPosRatingRangeTestData');


    //     List<RD_Attributes_Lookup_Detail__c> RDAttributeLookupDetailTable = Test.loadData(RD_Attributes_Lookup_Detail__c.sObjectType, 'RDAttributesDetailsTestData');
    //     List<RD_Attributes_LookUp_Translation__c> RDAttributeLookupTranslationTable = Test.loadData(RD_Attributes_LookUp_Translation__c.sObjectType, 'RDAttributesTranslationTestData');

    //     List<RD_ControlPlanDetail__c> RDControlPlanDetailTable = Test.loadData(RD_ControlPlanDetail__c.sObjectType, 'RDControlPlanDetailsTestData');
    //     List<RD_ControlPlanTranslation__c> RDControlPlanTranslationTable = Test.loadData(RD_ControlPlanTranslation__c.sObjectType, 'RDControlPlanTranslationTestData');

    //     List<RD_Routing_Details__c> RDRoutingDetailsTable = Test.loadData(RD_Routing_Details__c.sObjectType, 'RDRoutingDetailsTestData');
    //     List<RD_RoutingTranslation__c> RDDocumentTranslationTable = Test.loadData(RD_RoutingTranslation__c.sObjectType, 'RDDocumentTranslationTestData');

    //     List<RD_ComponentMBDetail__c> RDComponentMBDetailTable = Test.loadData(RD_ComponentMBDetail__c.sObjectType, 'RDComponentMBDetailTestData');
    //     List<RD_ComponentMBTranslation__c> RDComponentMBTranslationTable = Test.loadData(RD_ComponentMBTranslation__c.sObjectType, 'RDComponentMBTranslationTestData');

    //     List<RD_EvaluationTranslation__c> RDEvaluationTranslationTable = Test.loadData(RD_EvaluationTranslation__c.sObjectType, 'RDEvaluationTranslationTestData');

    //     List<RD_Manufacturing_Document_Translation__c> RDManufacturingDocumentTranslationTable = Test.loadData(RD_Manufacturing_Document_Translation__c.sObjectType, 'RDManufacturingDocumentTranslationTestData');

    //     List<RD_Output_OA__c> RDOutputOATable = Test.loadData(RD_Output_OA__c.sObjectType, 'RDOutputOATestData');

    //     List<RD_Output_OW_Detail__c> RDOutputOWDetailTable = Test.loadData(RD_Output_OW_Detail__c.sObjectType, 'RDOutputOWDetailTestData');
    //     List<RD_Output_OW_Translation__c> RDOutputOWTranslationTable = Test.loadData(RD_Output_OW_Translation__c.sObjectType, 'RDOutputOWTranslationTestData');

    //     List<RD_WorkGuidelinesTranslation__c> RDWorkGuidelinesTranslationTable = Test.loadData(RD_WorkGuidelinesTranslation__c.sObjectType, 'RDWorkGuidelinesTranslationTestData');
    }
}