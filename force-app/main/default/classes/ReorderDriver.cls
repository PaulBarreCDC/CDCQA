/***************************************************************************************************************
* @Name         ReorderDriver
* @Author       Vikram Natikar <vikram.natikar@apexit.com>
* @Date         10/13/2020
* @Description  This class is a Queueable class which handles the Reorder functionality for RuptureDisc,Holders,
				WasteGasBurner,FlameProducts,BlanketGasRegulator and Relief Valve products
*****************************************************************************************************************/
public class ReorderDriver implements Queueable, Database.AllowsCallouts {
    
    public Id quoteLineId {get;set;}
    public string productName {get;set;}
    public integer index {get;set;}
    
    public ReorderDriver(Id quoteLineId,String productName,Integer index){        
        this.quoteLineId = quoteLineId;
        this.productName = productName;
        this.index = index;
    } 
    
    //Groth Products    
    public List<String> WGBMethods=new List<String>{'saveRecommendedProcessInformation','SaveCertifications','saveProductSelection','saveSelections'};  
    public List<String> BGRMethods=new List<String>{'saveRelief','saveCertificate','saveProductSelection',
        'saveProductMaterials','saveValveExamination','saveDocSourcing'};
    public List<String> FlameProductsMethods=new List<String>{'saveApplicationParameters','saveCertifications','saveProductNarrowing',
        'saveProductSelection','saveProductMaterialAndOptions','saveExaminationOption','saveCertificateDocumentOrSourcingRestrictions'};  
    public List<String> RVMethods=new List<String>{'saveRelief','SaveCertifications',
   'SaveProductNarrowing','SaveProductSelection','saveProductMaterialAndOptions','saveValveExaminationOption','saveDocSourcing'};
    //Disc Products    
    public List<String> HLDMethods=new List<String>{'saveRuptureDiscSpecification','SaveCertifications','saveProductSelection',
    'saveComponentMaterialOptionSelection','saveCleaningMarkingsTesting'}; 
     public List<String> RDMethods=new List<String>{'saveRelief','saveCertificate','saveProductNarrowing',
   		'saveProductSelection','saveHClass','saveRatingRange','saveComponents','saveCleaningsTestsandProcesses'};
    //,'saveSizing'
    public Map<string,List<String>> SaveMethodsMap {
        get{
                Map<string,List<String>> SaveMethodsMap=new Map<string,List<String>>();                                            
                SaveMethodsMap.put ('WGB', WGBMethods);
            	SaveMethodsMap.put ('BGR', BGRMethods);
            	SaveMethodsMap.put ('FlameProducts', FlameProductsMethods);  
            	SaveMethodsMap.put ('RLFVLV', RVMethods);
                SaveMethodsMap.put ('HLD', HLDMethods);
          		SaveMethodsMap.put ('DISC', RDMethods);
                return SaveMethodsMap;
        }
        set{
            SaveMethodsMap=value;
        }
    }
        
    public void execute(QueueableContext context) {
        
        if(productName=='WGB')
        {
            WasteGasBurner__c wgb = [SELECT Id, Quote_Line__c FROM WasteGasBurner__c WHERE Id = :quoteLineId LIMIT 1];
            ConfigureWasteGasBurner conWGB = new ConfigureWasteGasBurner(wgb.Quote_Line__c);        
            conWGB.ReorderFlag = true;
           
            System.debug('VVVVVVVVVVVVVVV');
            if(index<WGBMethods.size())
            {
                if(SaveMethodsMap.get('WGB')[index]=='saveRecommendedProcessInformation')
                {
                    System.debug('VVVV1111111');
                    conWGB.saveRecommendedProcessInformation(); 
                }
                else if(SaveMethodsMap.get('WGB')[index]=='SaveCertifications')
                {
                    System.debug('VVVV22');
                    conWGB.SaveCertifications();                
                }
                else if(SaveMethodsMap.get('WGB')[index]=='saveProductSelection')
                {
                    System.debug('VVVV33');
                    conWGB.saveProductSelection(); 
                }
                else if(SaveMethodsMap.get('WGB')[index]=='saveSelections')
                {
                    System.debug('VVVV44');
                    ReorderDriverFutureEvents.invokeEventWGB(quoteLineId);
                }
                if(index<WGBMethods.size())
                {
                  //  System.enqueueJob(new ReorderDemoClass('a348A000000p46wQAA','WGB',index+1));
                  	if(!Test.isRunningTest())
                    	System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
            }                    		

        }
        
       else if(ProductName=='BGR'){
            BGR__c conProd=new BGR__c();
            BGR__c bgr = [SELECT Id, Quote_Line__c FROM BGR__c WHERE Id = :quoteLineId LIMIT 1];

            configureBGRProduct conBGR = new configureBGRProduct(bgr.Quote_Line__c);        
            conBGR.ReorderFlag = true;
            BlanketGasRegulatorController.ReorderFlagLWC=true;
            if(index<BGRMethods.size())
            {
                if(SaveMethodsMap.get('BGR')[index]=='saveRelief')
                {
            		BlanketGasRegulatorController.saveRelief(conBGR.conBGR);
                }                          
				else if(SaveMethodsMap.get('BGR')[index]=='saveCertificate')
                {
                    BlanketGasRegulatorController.saveCertificate(conBGR.conBGR, conBGR.conBGR.id);              
                }
                else if(SaveMethodsMap.get('BGR')[index]=='saveProductSelection')
                {
                    BlanketGasRegulatorController.saveProductSelection(conBGR.conBGR); 
                }
				
			
				else if(SaveMethodsMap.get('BGR')[index]=='saveProductMaterials')
                {
                    conBGR.saveProductMaterials();                
                }
				else if(SaveMethodsMap.get('BGR')[index]=='saveValveExamination')
                {
                    conBGR.saveValveExamination(); 
                }
                else if(SaveMethodsMap.get('BGR')[index]=='saveDocSourcing')
                {
                    ReorderDriverFutureEvents.invokeEventBGR(quoteLineId);
                }
                if(index<BGRMethods.size())
                {
                  //  System.enqueueJob(new ReorderDemoClass('a348A000000p46wQAA','FlameProducts',index+1));
                    if(!Test.isRunningTest())
                    	System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
            }                        
        }
        
        else if(ProductName=='FlameProducts'){
            Flame_Product__c conProd=new Flame_Product__c();
            Flame_Product__c fa = [SELECT Id, Quote_Line__c FROM Flame_Product__c WHERE Id = :quoteLineId LIMIT 1];

            configureFLAMEproduct conFA = new configureFLAMEproduct(fa.Quote_Line__c);        
            conFA.ReorderFlag = true;
            FlameProductController.ReorderFlagLWC=true;
            if(index<FlameProductsMethods.size())
            {
                if(SaveMethodsMap.get('FlameProducts')[index]=='saveApplicationParameters')
                {
            		FlameProductController.saveApplicationParameters(conFA.flmProd);
                }          
                else if(SaveMethodsMap.get('FlameProducts')[index]=='saveCertifications')
                {
                   FlameProductController.saveCertifications(conFA.flmProd); 
                }                
				else if(SaveMethodsMap.get('FlameProducts')[index]=='saveProductNarrowing')
                {
                    if(!Test.isRunningTest())
                    FlameProductController.saveProductNarrowing(conFA.flmProd, conFA.flmProd.id);              
                }
                else if(SaveMethodsMap.get('FlameProducts')[index]=='saveProductSelection')
                {
                    FlameProductController.saveProductSelection(conFA.flmProd); 
                }
				
			
				else if(SaveMethodsMap.get('FlameProducts')[index]=='saveProductMaterialAndOptions')
                {
                    conFA.saveProductMaterialAndOptions();                
                }
				else if(SaveMethodsMap.get('FlameProducts')[index]=='saveExaminationOption')
                {
                    conFA.saveExaminationOption(); 
                }
                else if(SaveMethodsMap.get('FlameProducts')[index]=='saveCertificateDocumentOrSourcingRestrictions')
                {
                    ReorderDriverFutureEvents.invokeEventFA(quoteLineId);
                }
                if(index<FlameProductsMethods.size())
                {
                  //  System.enqueueJob(new ReorderDemoClass('a348A000000p46wQAA','FlameProducts',index+1));
                    if(!Test.isRunningTest())
                    	System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
           	 }            
           }
        
        else if(ProductName=='RLFVLV'){
          //  Relief_Valve__c conProd=new Relief_Valve__c();
            Relief_Valve__c rv = [SELECT Id, Quote_Line__c FROM Relief_Valve__c WHERE Id = :quoteLineId LIMIT 1];
			
            configureRVproduct conRV = new configureRVproduct(rv.Quote_Line__c);        
            conRV.ReorderFlag = true;
            ReliefValveController.ReorderFlagLWC=true;
            if(index<RVMethods.size())
            {
                if(SaveMethodsMap.get('RLFVLV')[index]=='saveRelief')
                {
            		ReliefValveController.saveRelief(conRV.conRV);
                }
                else if(SaveMethodsMap.get('RLFVLV')[index]=='SaveCertifications')
                {
                   ReliefValveController.SaveCertifications(conRV.conRV); 
                }                
				else if(SaveMethodsMap.get('RLFVLV')[index]=='SaveProductNarrowing')
                {
                    ReliefValveController.SaveProductNarrowing(conRV.conRV);              
                }
                else if(SaveMethodsMap.get('RLFVLV')[index]=='SaveProductSelection')
                {
                    ReliefValveController.SaveProductSelection(conRV.conRV); 
                }
				
			
				else if(SaveMethodsMap.get('RLFVLV')[index]=='saveProductMaterialAndOptions')
                {
                    conRV.saveProductMaterialAndOptions();                
                }
				else if(SaveMethodsMap.get('RLFVLV')[index]=='saveValveExaminationOption')
                {
                    conRV.saveValveExaminationOption(); 
                }
                else if(SaveMethodsMap.get('RLFVLV')[index]=='saveDocSourcing')
                {
                    ReorderDriverFutureEvents.invokeEventRV(quoteLineId);
                }
                if(index<RVMethods.size())
                {
                  //  System.enqueueJob(new ReorderDemoClass('a348A000000p46wQAA','RLFVLV',index+1));
                    if(!Test.isRunningTest())
                    	System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
           	 }            
           }
       /* else if(productName=='PS')
        {
            Part_Selector__c psrecord = [SELECT Id, Quote_Line__c FROM Part_Selector__c WHERE Id = :quoteLineId LIMIT 1];
            configurePartSelector PS = new configurePartSelector(psrecord.Quote_Line__c);        
           // conWGB.ReorderFlag = true;
           
            if(index<PSMethods.size())
            {
               if(SaveMethodsMap.get('PS')[index]=='saveProdPartNumber')
                {
                    ReorderDriverFutureEvents.invokeEventPS(quoteLineId);
                }
                if(index<PSMethods.size())
                {
                  	if(!Test.isRunningTest())
                    	System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
            }                    		

        }*/
        else if(productName=='HLD')
        {
            Holders__c HLD = [SELECT Id, Quote_Line__c FROM Holders__c WHERE Id = :quoteLineId LIMIT 1];
            ConfigHolderController conHLD = new ConfigHolderController(HLD.Quote_Line__c);           
           
            conHLD.ReorderFlag = true;
            if(index<HLDMethods.size())
            {
                if(SaveMethodsMap.get('HLD')[index]=='saveRuptureDiscSpecification')
                {
                    conHLD.saveRuptureDiscSpecification(); 
                }
                else if(SaveMethodsMap.get('HLD')[index]=='SaveCertifications')
                {
                    conHLD.SaveCertifications();                
                }
                else if(SaveMethodsMap.get('HLD')[index]=='saveProductSelection')
                {
                    conHLD.saveProductSelection(); 
                }
				else if(SaveMethodsMap.get('HLD')[index]=='saveComponentMaterialOptionSelection')
                {
                    conHLD.saveComponentMaterialOptionSelection(); 
                }
                else if(SaveMethodsMap.get('HLD')[index]=='saveCleaningMarkingsTesting')
                {
                    ReorderDriverFutureEvents.invokeEventHLD(quoteLineId);
                    ReorderDriverFutureEvents.invokeEventHLD2(quoteLineId);
                }
                if(index<HLDMethods.size())
                {
                  //  System.enqueueJob(new ReorderDemoClass('a348A000000p46wQAA','HLD',index+1));
                    if(!Test.isRunningTest())
                    	System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
            }                   		
        }
        
        else if(ProductName=='DISC')
			{
				Rupture_Disc__c rd = [SELECT Id,pressure_setting__c, dryness_of_wet_steam__c, overpressure__c, back_pressure_units__c, back_pressure_value__c, calculated_flow_rate__c,
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
            FROM Rupture_Disc__c WHERE Id = :quoteLineId LIMIT 1];

			RuptureDiscController.ReorderFlagLWC=true;
            if(index==0)                    
               RuptureDiscController.saveRelief(rd);                                	
                
			if(index<RdMethods.size())
            {                   
                ConfigureRD conRD = new ConfigureRD(rd.Quote_Line__c);
                conRD.ReorderFlag = true;
                
                if(SaveMethodsMap.get('DISC')[index]=='saveCertificate')
                {
                    RuptureDiscController.saveCertificate(conRD.conProd); 
                }                
                else if(SaveMethodsMap.get('DISC')[index]=='saveProductNarrowing')
                {
                    RuptureDiscController.SaveProductNarrowing(conRD.conProd);              
                }
                else if(SaveMethodsMap.get('DISC')[index]=='saveProductSelection')
                {
                    List<id> abc=new List<id>();
                    RuptureDiscController.saveProductSelection(conRD.conProd,conRD.conProd.id,abc); 
                } 
                else if(SaveMethodsMap.get('DISC')[index]=='saveHClass')
                {
                    RuptureDiscController.saveHClass(conRD.conProd); 
                }
                
                else if(SaveMethodsMap.get('DISC')[index]=='saveRatingRange')
                {
                    conRD.saveRatingRange();  
                    //  RR.saveRatingRange();
                }
                else if(SaveMethodsMap.get('DISC')[index]=='saveComponents')
                {
                    conRD.saveComponents(); 
                }
                else if(SaveMethodsMap.get('DISC')[index]=='saveCleaningsTestsandProcesses')
                {
                    ReorderDriverFutureEvents.invokeEventRD(quoteLineId);
                }
                if(index<RdMethods.size())
                {
                    //  System.enqueueJob(new ReorderDemoClass('a348A000000p46wQAA','DISC',index+1));
                    if(!Test.isRunningTest())
                        System.enqueueJob(new ReorderDriver(quoteLineId,productName,index+1));
                    index=index+1;  
                } 
              }            
            }
        
        
        
    }
}