import { LightningElement, track,api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import HPX_RUPTURE_DISC from '@salesforce/resourceUrl/HPX_RUPTURE_DISC';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import RD_OBJECT from '@salesforce/schema/Rupture_Disc__c';

//Apex Methods
import getConsolidateHCLASSOptns from '@salesforce/apex/RuptureDiscController.getConsolidateHCLASSOptns';
import getConsolidateHICOptns from '@salesforce/apex/RuptureDiscController.getConsolidateHICOptns';
import getConsolidateHOCOptns from '@salesforce/apex/RuptureDiscController.getConsolidateHOCOptns';
import recalMNFA from '@salesforce/apex/RuptureDiscController.recalMNFA';
import saveCapacityConversion from '@salesforce/apex/RuptureDiscController.saveCapacityConversion';

import saveHClass from '@salesforce/apex/RuptureDiscController.saveHClass';
import getRDMasterIDs from '@salesforce/apex/RuptureDiscController.getRDMasterIDs';
import getRupDiscRecords from '@salesforce/apex/RuptureDiscController.getRupDiscRecords';
import saveProductSelection from '@salesforce/apex/RuptureDiscController.saveProductSelection';
import fetchFormAccessibility from '@salesforce/apex/RuptureDiscController.fetchFormAccessibility'; // @added by piyush

//Fields
import SizeUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Size_Units__c';
import CoefficientOfDischargeOptions_FIELD from '@salesforce/schema/Rupture_Disc__c.Coefficient_of_Discharge__c';
//import DrynessofWetSteam_FIELD from '@salesforce/schema/Rupture_Disc__c.Dryness_of_Wet_Steam__c';
import DrynessofWetSteam_FIELD from '@salesforce/schema/Rupture_Disc__c.Dryness_of_Wet_Steam__c';
import DSCVAR_FIELD from '@salesforce/schema/Rupture_Disc__c.DSCVAR__c';
import Required_Flow_Area_Units_FIELD from '@salesforce/schema/Rupture_Disc__c.Required_Flow_Area_Units__c';
import VacRequired_Flow_Area_Units_FIELD from '@salesforce/schema/Rupture_Disc__c.VacRequired_Flow_Area_Units__c';
import IsThereLiquidReliefScenario_FIELD from '@salesforce/schema/Rupture_Disc__c.Is_there_a_liquid_relief_scenario__c';
import ReliefType_FIELD from '@salesforce/schema/Rupture_Disc__c.Relief_Type__c';
import Application_type_FIELD from '@salesforce/schema/Rupture_Disc__c.Application_type__c';
import Operating_Pressure_Ratio_FIELD from '@salesforce/schema/Rupture_Disc__c.Operating_Pressure_Ratio__c';
import CU_TR_FIELD from '@salesforce/schema/Rupture_Disc__c.CU_TR__c';
import X3A_Sanitary_Standards_FIELD from '@salesforce/schema/Rupture_Disc__c.X3A_Sanitary_Standards__c';
import Atex_Certificate_FIELD from '@salesforce/schema/Rupture_Disc__c.Atex_Certificate__c';
import Relief_Type_FIELD from '@salesforce/schema/Rupture_Disc__c.Relief_Type__c';
import Non_Fragmenting_Design_Required_FIELD from '@salesforce/schema/Rupture_Disc__c.Non_Fragmenting_Design_Required__c';
import Quote_Line_FIELD from '@salesforce/schema/Rupture_Disc__c.Quote_Line__c';
import Product_FIELD from '@salesforce/schema/Rupture_Disc__c.Product__c';
import Size_FIELD from '@salesforce/schema/Rupture_Disc__c.Size__c';
import Seat_FIELD from '@salesforce/schema/Rupture_Disc__c.Seat__c';
import ASMESectionVIIIDivision1_FIELD from '@salesforce/schema/Rupture_Disc__c.ASME_Section_VIII_Division_1__c';
import RDFlowCapacityValue_FIELD from '@salesforce/schema/Rupture_Disc__c.Rupture_Disc_Flow_Capacity_Value__c';
import ProductFlowCapacity_FIELD from '@salesforce/schema/Rupture_Disc__c.Product_Flow_Capacity_Value__c';
import VacProductFlowCapacity_FIELD from '@salesforce/schema/Rupture_Disc__c.VacProduct_Flow_Capacity_Value__c';
import RDFlowCapacityUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Rupture_Disc_Flow_Capacity_Units__c';
import VacFlowCapacityValue_FIELD from '@salesforce/schema/Rupture_Disc__c.VacFlow_Capacity_Value__c';
import VacProductFlowCapacityUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.VacProduct_Flow_Capacity_Units__c';
import PressureClass_FIELD from '@salesforce/schema/Rupture_Disc__c.Pressure_Class__c';
import InletConnection_FIELD from '@salesforce/schema/Rupture_Disc__c.Inlet_Connection__c';
import OutletConnection_FIELD from '@salesforce/schema/Rupture_Disc__c.Outlet_Connection__c';
import ConvertedPressureSetting_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Pressure_Setting__c';
import ConvertedRelievingPressureValue_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Relieving_Pressure_Value__c';
import ConvertedRelievingTemperature_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Relieving_Temperature__c';
import ConvertedFlowRate_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Flow_rate__c';
import ConvertedDensityAtInlet_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Density_at_Inlet__c';
import ConvertedSpecificVolume_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Specific_Volume__c';
import EvaluationPer_Field from '@salesforce/schema/Rupture_Disc__c.Evaluation_Per__c';
import EvaluationType_FIELD from '@salesforce/schema/Rupture_Disc__c.Evaluation_Type__c';
import FlowArea_Field from '@salesforce/schema/Rupture_Disc__c.Flow_Area__c';
import MediaType_Field from '@salesforce/schema/Rupture_Disc__c.Process_Media__c';
import MolecularWeight_Field from '@salesforce/schema/Rupture_Disc__c.Molecular_Weight__c';
import isSaturated_FIELD from '@salesforce/schema/Rupture_Disc__c.Is_Saturated__c';
import RatioofSpecificHeats_Field from '@salesforce/schema/Rupture_Disc__c.Ratio_of_Specific_Heats__c';
import CompressibilityFactor_Field from '@salesforce/schema/Rupture_Disc__c.Compressibility_Factor__c';
import ConvertedStagnationGaspartialPressure_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Stagnation_gaspartial_Pressure__c';
import ConvVaporPresCorresToStagnationTemp_Field from '@salesforce/schema/Rupture_Disc__c.ConvVapor_pres_corres_to_stagnation_temp__c';
import IsentropicCoefficientGas_Field from '@salesforce/schema/Rupture_Disc__c.Isentropic_coefficient_gas__c';
import IsentropicCoefficientVapor_Field from '@salesforce/schema/Rupture_Disc__c.Isentropic_coefficient_vapor__c';
import MolecularWeightGas_Field from '@salesforce/schema/Rupture_Disc__c.Molecular_Weight_gas__c';
import MolecularWeightVapor_Field from '@salesforce/schema/Rupture_Disc__c.Molecular_Weight_vapor__c';
import ConvertedSpecificVolumeat90OfInletPress_Field from '@salesforce/schema/Rupture_Disc__c.ConvertedSpecificVolumeat90_ofInletPress__c';
import ConvertedSaturationPressureAtInletTemp_Field from '@salesforce/schema/Rupture_Disc__c.ConvertedSaturationPressure_at_InletTemp__c';
import ConvertedDensityAt90SaturationPressure_Field from '@salesforce/schema/Rupture_Disc__c.ConvertedDensity_at_90SaturationPressure__c';
import MNFA_for_Calculations_Field from '@salesforce/schema/Rupture_Disc__c.MNFA_for_Calculations__c';
//import ConvertedDensityAt90SaturationPressure_Field from '@salesforce/schema/Rupture_Disc__c.ConvertedDensity_at_90SaturationPressure__c';
import StagnationGasVaporQuality_Field from '@salesforce/schema/Rupture_Disc__c.Stagnation_gas_vapor_quality__c';
import ConvertedLiquidDensity_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Liquid_Density__c';
import ConvertedStagnationVaporDensity_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Stagnation_vapor_density__c';
import LiquidSpecificHeat_Field from '@salesforce/schema/Rupture_Disc__c.Liquid_specific_heat__c';
import LatentHeatOfVaporization_Field from '@salesforce/schema/Rupture_Disc__c.Latent_heat_of_vaporization__c';
import ConvertedDensitySpeciVolumeSpeGravit_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Density_Speci_Volume_SpeGravit__c';
import RequiredFlowUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Required_Flow_units__c';
import VacRequiredFlowUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.VacRequired_Flow_Rate_Units__c';
import ConvertedViscosity_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Viscosity__c';
import ConvertedVacuumSetting_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Vacuum_Setting__c';
import VacConvertedDifferentTempSetting_Field from '@salesforce/schema/Rupture_Disc__c.VacConverted_Different_Temp_Setting__c';
import ConstrainProductSelectionByFlow_Field from '@salesforce/schema/Rupture_Disc__c.constrain_product_selection_by_flow__c';
import ConvertedTemperatureSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Temperature_Setting__c';
import Shell_Test_FIELD from '@salesforce/schema/Rupture_Disc__c.Shell_Test__c'; //SERVICE TICKET #207590
import FinishConfigurationFlag_FIELD from '@salesforce/schema/Rupture_Disc__c.Finish_Configuration_Flag__c';

import Id from '@salesforce/user/Id';
const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

const QUOTELINE_FIELDS = [
    'SBQQ__QuoteLine__c.SBQQ__Quote__c'
];

const RuptureDiscFIELDS = [Quote_Line_FIELD, ReliefType_FIELD, Application_type_FIELD,Required_Flow_Area_Units_FIELD,VacRequired_Flow_Area_Units_FIELD, Operating_Pressure_Ratio_FIELD, CU_TR_FIELD, X3A_Sanitary_Standards_FIELD,
    Atex_Certificate_FIELD, Relief_Type_FIELD, Non_Fragmenting_Design_Required_FIELD, Product_FIELD, Size_FIELD, Seat_FIELD,RDFlowCapacityUnits_FIELD,RequiredFlowUnits_FIELD,DrynessofWetSteam_FIELD,VacRequiredFlowUnits_FIELD,
    ConvertedPressureSetting_Field,ConvertedRelievingPressureValue_Field,ConvertedRelievingTemperature_FIELD,ConvertedFlowRate_FIELD,ConvertedDensityAtInlet_FIELD,ConvertedSpecificVolume_FIELD,
    RDFlowCapacityValue_FIELD,InletConnection_FIELD,OutletConnection_FIELD,PressureClass_FIELD,ProductFlowCapacity_FIELD,VacProductFlowCapacityUnits_FIELD,ConstrainProductSelectionByFlow_Field,VacProductFlowCapacity_FIELD,
    ConvertedDensitySpeciVolumeSpeGravit_Field,ConvertedViscosity_Field,VacFlowCapacityValue_FIELD,EvaluationPer_Field,VacConvertedDifferentTempSetting_Field,FinishConfigurationFlag_FIELD,isSaturated_FIELD,
    FlowArea_Field,MediaType_Field,MolecularWeight_Field,CompressibilityFactor_Field,RatioofSpecificHeats_Field,ConvertedVacuumSetting_Field,EvaluationType_FIELD,MNFA_for_Calculations_Field,
    MolecularWeightVapor_Field,MolecularWeightGas_Field,IsentropicCoefficientVapor_Field,IsentropicCoefficientGas_Field,ConvVaporPresCorresToStagnationTemp_Field,ConvertedStagnationGaspartialPressure_Field,
    ConvertedSpecificVolumeat90OfInletPress_Field,ConvertedSaturationPressureAtInletTemp_Field,ConvertedDensityAt90SaturationPressure_Field,SizeUnits_FIELD,
    StagnationGasVaporQuality_Field,ConvertedLiquidDensity_Field,ConvertedStagnationVaporDensity_Field,LiquidSpecificHeat_Field,LatentHeatOfVaporization_Field,
    IsThereLiquidReliefScenario_FIELD,DSCVAR_FIELD,ASMESectionVIIIDivision1_FIELD,ConvertedTemperatureSetting_FIELD,CoefficientOfDischargeOptions_FIELD,Shell_Test_FIELD ]; //SERVICE TICKET #207590

export default class lwcProductRecommendations extends NavigationMixin(LightningElement) {
    // Expose the static resource URL for use in the template
    hpxRuptureDisc = HPX_RUPTURE_DISC;

    @api recordId;
    userId = Id;
    currentUserInfo = {};
    QuoteLineInfo = {};
    @track rdRecords;
    @track filteredRDRecords;
    @track selectedRecordId;
    @track quoteLineId;
    @track constrainProductSelectionByFlow;
    isFilterApplied = false;
    isProcessClass = false;

    //Product Filter Track to Store and Pass Value
    @track selectedProd;
    @track selectedSeat;
    @track selectedSize;
    @track productPickListValues;
    @track seatPickListOptions;
    @track sizePickListOptions;
    //@track sizeUnitsVal;
    //@track sizeUnitsOptions;

    //HClassSection Track to Store and Pass Value
    @track rdFlowCapacityValue;
    @track ProductFlowCapacity;
    @track VacProductFlowCapacity;
    @track rdFlowCapacityUnitsVal;
    @track vacRdFlowCapactityValue;
    @track vacRdFlowCapacityUnitsVal;
    @track rdFlowCapacityUnitsOptions;
    @track pressureClassVal;
    @track pressureClassOptions;
    @track inletConnectionVal;
    @track inletConnectionOptions;
    @track outletConnectionVal;
    @track outletConnectionOptions;

    //Show/Hide HClass Section
    @track HClassSection;
    @track ProductSection;

    //Error Handling SectionWise
    @track section5ErrorMessage;
    @track isErrorSection5;
    @track section6ErrorMessage;
    @track isErrorSection6;

    @track convertedPressureSetting;
    @track convertedRelievingPressureValue;
    @track convertedRelievingTemperature;
    @track convertedFlowRate;
    @track convertedDensityAtInlet;
    @track convertedSpecificVolume;
    @track evaluationPer;
    @track evaluationType;
    @track requiredFlowAreaUnits;
    @track vacrequiredFlowAreaUnits;
    @track flowArea;
    @track mediaType;
    @track isSaturated;
    @track molecularWeight;
    @track ratioOfSpecificHeats;
    @track compressibilityFactor;
    @track rDiscFlowCapacityUnits;
    @track convertedDensitySpeciVolumeSpeGravit;
    @track convertedViscosity;
    @track convertedSpecificVolumeat90OfInletPress;
    @track convertedSaturationPressureAtInletTemp;
    @track convertedDensityAt90SaturationPressure;
    @track stagnationGasVaporQuality;
    @track convertedStagnationVaporDensity;
    @track liquidSpecificHeat;
    @track latentHeatOfVaporization;
    @track convertedLiquidDensity;
    @track selReliefType;
    @track convertedStagnationGaspartialPressure;
    @track convVaporPresCorresToStagnationTemp;
    @track isentropicCoefficientGas;
    @track isentropicCoefficientVapor;
    @track molecularWeightGas;
    @track molecularWeightVapor;
    @track convertedVacuumSetting;
    @track vacConvertedDifferentTempSetting;

    @track disableIOConnFields;
    @track HideCapacity;
    //@track disableReqFlowunits;
    @track evaluationType;
    @track MNFAforCalculation;
    @track DSCVAR;
    @track IsThereLiquidReliefScenario;
    @track ASMESectionVIIIDivision1;
    @track convTempSetting;
    @api rdMBRecIds = [];
    @track coefficientOfDischargeVal;
    @track sizeUnits;

    @track isChecked;
    @track isLoading = false;
    @track finishConfigurationFlag;
    @track prodReviewButton;

    // added by piyush
    bShowEditBtn = false;
    sDisabled = '';
    bDisabled = false;
    sEditBtnLabel = 'Edit';
    bShowProductReviewLink = false;
    bShowHCLASSLink=false;

    //added by piyush
    navigateToProductReview(){
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;

        let encodeURI = '';
        let sUrl = '/apex/ConfigRD?qid='+ this.quoteLineId;

        if (isPortalUser) {
            encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
        } else {
            encodeURI = sUrl;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: encodeURI
            }
        },
            true // Replaces the current page in your browser history with the URL
        );
    }
    //REDMINE #34472 ADDED LOGIC for navigition to HCLASS Section for finished configurations
    moveForwardTOVf(){
        //console.log('this.constrainProductSelectionByFlow: ',this.constrainProductSelectionByFlow);
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        let encodeURI = '';
        let sUrl = '/apex/ConfigRD?qid='+ this.quoteLineId;

        if (isPortalUser) {
            encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
        } else {
            encodeURI = sUrl;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: encodeURI
            }
        },
            true // Replaces the current page in your browser history with the URL
        );

    }
    enableEditMode(){
        this.sEditBtnLabel = this.sEditBtnLabel == 'Edit' ? 'Cancel' : 'Edit';
        if(this.sEditBtnLabel == 'Cancel'){
            this.bShowProductReviewLink = false;
            this.bShowHCLASSLink=false;
            this.thisoPopupPDF = window.open('/apex/ConfigureProductScreen?qid=' + this.quoteLineId , "", "width=500,height=500");

        }else{
            this.bShowProductReviewLink = true;
            this.bShowHCLASSLink=true;
        }
        this.sDisabled = this.sDisabled == '' ? 'disabled' : '';
        this.bDisabled = this.bDisabled == true ? false : true;
    }

    @wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }

    @wire(getRecord, { recordId: '$quoteLineId', fields: QUOTELINE_FIELDS })
    oQLInfo({ error, data }) {
        if (data) {
			this.QuoteLineInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }

    @wire(getObjectInfo, { objectApiName: RD_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: VacProductFlowCapacityUnits_FIELD})
    vacRdFlowCapacityUnitsOptions;

    @wire(getRecord, { recordId: '$recordId', fields: RuptureDiscFIELDS})
    ruptureDiscRec({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while loading Rupture Disc',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            if(data !== undefined){
                this.quoteLineId = data.fields.Quote_Line__c.value;
                // if(data.fields.Evaluation_Type__c.value == 'Capacity'){
                //     this.disableReqFlowunits = false;
                // } else if(data.fields.Evaluation_Type__c.value == 'Sizing & Capacity') {
                //     this.disableReqFlowunits = false;
                // }
                if(data.fields.Rupture_Disc_Flow_Capacity_Units__c.value == null && data.fields.Required_Flow_units__c != null){
                    this.rdFlowCapacityUnitsVal = data.fields.Required_Flow_units__c.value;
                } else if(data.fields.Rupture_Disc_Flow_Capacity_Units__c.value != null && data.fields.Required_Flow_units__c != null){
                    this.rdFlowCapacityUnitsVal = data.fields.Rupture_Disc_Flow_Capacity_Units__c.value;
                }
                if(data.fields.VacProduct_Flow_Capacity_Units__c.value == null && data.fields.VacRequired_Flow_Rate_Units__c != null){
                    this.vacRdFlowCapacityUnitsVal = data.fields.VacRequired_Flow_Rate_Units__c.value;
                } else if(data.fields.VacProduct_Flow_Capacity_Units__c.value != null && data.fields.VacRequired_Flow_Rate_Units__c != null){
                    this.vacRdFlowCapacityUnitsVal = data.fields.VacProduct_Flow_Capacity_Units__c.value;
                }
                this.pressureClassVal=data.fields.Pressure_Class__c.value;
                this.inletConnectionVal=data.fields.Inlet_Connection__c.value;
                this.outletConnectionVal=data.fields.Outlet_Connection__c.value;
                this.convTempSetting = data.fields.Converted_Temperature_Setting__c.value;
                this.rdFlowCapacityValue = data.fields.Rupture_Disc_Flow_Capacity_Value__c.value;
                this.ProductFlowCapacity= data.fields.Product_Flow_Capacity_Value__c.value;
                this.VacProductFlowCapacity=data.fields.VacProduct_Flow_Capacity_Value__c.value;
                this.vacRdFlowCapactityValue = data.fields.VacFlow_Capacity_Value__c.value;
                this.vacRdFlowCapacityUnitsVal = data.fields.VacProduct_Flow_Capacity_Units__c.value;
                this.convertedPressureSetting = data.fields.Converted_Pressure_Setting__c.value;
                this.convertedRelievingPressureValue = data.fields.Converted_Relieving_Pressure_Value__c.value;
                this.convertedRelievingTemperature = data.fields.Converted_Relieving_Temperature__c.value;
                this.convertedFlowRate = data.fields.Converted_Flow_rate__c.value;
                this.convertedDensityAtInlet = data.fields.Converted_Density_at_Inlet__c.value;
                this.convertedSpecificVolume = data.fields.Converted_Specific_Volume__c.value;
                this.flowArea = data.fields.Flow_Area__c.value;
                this.evaluationPer = data.fields.Evaluation_Per__c.value;
                this.evaluationType=data.fields.Evaluation_Type__c.value;
                this.requiredFlowAreaUnits=data.fields.Required_Flow_Area_Units__c.value;
                this.vacrequiredFlowAreaUnits=data.fields.VacRequired_Flow_Area_Units__c.value;
                this.mediaType = data.fields.Process_Media__c.value;
                this.isSaturated=data.fields.Is_Saturated__c.value;
                this.DSCVAR=data.fields.DSCVAR__c.value;
                this.MNFAforCalculation=data.fields.MNFA_for_Calculations__c.value;
                this.molecularWeight = data.fields.Molecular_Weight__c.value;
                this.ratioOfSpecificHeats = data.fields.Ratio_of_Specific_Heats__c.value;
                this.compressibilityFactor = data.fields.Compressibility_Factor__c.value;
                this.convertedDensitySpeciVolumeSpeGravit = data.fields.Converted_Density_Speci_Volume_SpeGravit__c.value;
                this.convertedViscosity = data.fields.Converted_Viscosity__c.value;
                this.selReliefType = data.fields.Relief_Type__c.value;
                this.convertedSaturationPressureAtInletTemp = data.fields.ConvertedSaturationPressure_at_InletTemp__c.value;
                this.convertedSpecificVolumeat90OfInletPress = data.fields.ConvertedSpecificVolumeat90_ofInletPress__c.value;
                this.convertedDensityAt90SaturationPressure = data.fields.ConvertedDensity_at_90SaturationPressure__c.value;
                this.stagnationGasVaporQuality = data.fields.Stagnation_gas_vapor_quality__c.value;
                this.convertedStagnationVaporDensity = data.fields.Converted_Stagnation_vapor_density__c.value;
                this.convertedLiquidDensity = data.fields.Converted_Liquid_Density__c.value;
                this.latentHeatOfVaporization = data.fields.Latent_heat_of_vaporization__c.value;
                this.liquidSpecificHeat = data.fields.Liquid_specific_heat__c.value;
                this.convertedStagnationGaspartialPressure = data.fields.Converted_Stagnation_gaspartial_Pressure__c.value;
                this.convVaporPresCorresToStagnationTemp = data.fields.ConvVapor_pres_corres_to_stagnation_temp__c.value;
                this.isentropicCoefficientGas = data.fields.Isentropic_coefficient_gas__c.value;
                this.isentropicCoefficientVapor = data.fields.Isentropic_coefficient_vapor__c.value;
                this.molecularWeightGas = data.fields.Molecular_Weight_gas__c.value;
                this.molecularWeightVapor = data.fields.Molecular_Weight_vapor__c.value;
                this.convertedVacuumSetting = data.fields.Converted_Vacuum_Setting__c.value;
                this.vacConvertedDifferentTempSetting = data.fields.VacConverted_Different_Temp_Setting__c.value;
                this.constrainProductSelectionByFlow = data.fields.constrain_product_selection_by_flow__c.value;
                this.IsThereLiquidReliefScenario = data.fields.Is_there_a_liquid_relief_scenario__c.value;
                this.ASMESectionVIIIDivision1 = data.fields.ASME_Section_VIII_Division_1__c.value;
                this.coefficientOfDischargeVal =data.fields.Coefficient_of_Discharge__c.value;
                this.DrynessofWetSteamVal =data.fields.Dryness_of_Wet_Steam__c.value;
                this.sizeUnits = data.fields.Size_Units__c.value;
                this.finishConfigurationFlag = data.fields.Finish_Configuration_Flag__c.value;
                this.generateProductSelectionDropDown(data);


                  // added by piyush
                  console.log('record Id - ' + this.recordId);
                  console.log('quote Id - ' + this.quoteId);
                  console.log('quote line Id - ' + this.quoteLineId);


              fetchFormAccessibility({qliId : this.quoteLineId})
              .then(result => {
                  console.log('Result fetchFormAccessibility***** ---> ' + JSON.stringify(result));
                  this.bShowEditBtn = result.bShowEditButton;

                  if(result.bConfigurationComplete){
                      this.bShowProductReviewLink = true;
                  }

                  if(!result.bReadOnly){
                      this.sDisabled = '';
                      this.bDisabled = false;
                  }else{
                      this.sDisabled = 'disabled';
                      this.bDisabled = true;
                  }

              })
              .catch(error => {
                  console.log('error fetchFormAccessibility ---> ' + JSON.stringify(error));
              });

             }
        }
    }


    @wire(getRupDiscRecords,{  fields: RuptureDiscFIELDS, rupRecordId: '$recordId'})
    rDRecords({ error, data }) {
        if (data) {
            console.log('getRupDiscRecords --> ',data);
            this.filteredRDRecords = data;
            this.rdRecords = data;
            this.error = undefined;
        } else if (error) {
            console.log('error --> ',error);
            this.error = error;
            this.contacts = undefined;
        }
    }

    handleHClassCancel(event){
        this.HClassSection = false;
        this.ProductSection = false;
    }

    handleHClassSave(event){
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Inlet_Connection__c = this.inletConnectionVal;
        rDisc.Outlet_Connection__c = this.outletConnectionVal;
        rDisc.VacFlow_Capacity_Value__c = this.vacRdFlowCapactityValue;
        rDisc.VacProduct_Flow_Capacity_Units__c = this.vacRdFlowCapacityUnitsVal;
        rDisc.Rupture_Disc_Flow_Capacity_Units__c = this.rdFlowCapacityUnitsVal;
        rDisc.Rupture_Disc_Flow_Capacity_Value__c = this.rdFlowCapacityValue;
        rDisc.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rDisc.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rDisc.Converted_Density_Speci_Volume_SpeGravit__c = this.convertedDensitySpeciVolumeSpeGravit;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.Evaluation_Type__c=this.evaluationType;
        rDisc.Required_Flow_Area_Units__c = this.requiredFlowAreaUnits;
        rDisc.VacRequired_Flow_Area_Units__c = this.vacrequiredFlowAreaUnits;
        rDisc.Molecular_Weight__c = this.molecularWeight;
        rDisc.Compressibility_Factor__c = this.compressibilityFactor;
        rDisc.Relief_Type__c = this.selReliefType;
        rDisc.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rDisc.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rDisc.Id = this.recordId;

        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Is_there_a_liquid_relief_scenario__c = this.IsThereLiquidReliefScenario;
        rDisc.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rDisc.ASME_Section_VIII_Division_1__c = this.ASMESectionVIIIDivision1;
        saveHClass({ruptureDisc: rDisc})
        .then(result => {
            this.HClassSection = true;
            this.isErrorSection6 = false;
            this.section6ErrorMessage = [];
            let removeError6 = this.template.querySelectorAll(".section6");
            if(removeError6){
                removeError6.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Successfully saved HClass selection',
                    variant: 'success',
                }),
            );

            let isPortalUserVF = this.currentUserInfo.fields.IsPortalEnabled.value;
            let encodeURI = '';
            let sUrl = '/apex/ConfigRD?id='+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=seven';

            if (isPortalUserVF) {
                encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
            } else {
                encodeURI = sUrl;
            }

            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: encodeURI
                }
            },
                true // Replaces the current page in your browser history with the URL
            );
        })
        .catch(error => {
            this.isErrorSection6 = true;
            this.section6ErrorMessage = [];
            this.section6ErrorMessage.push(error.body.message);
            let removeError = this.template.querySelectorAll(".section6");
            if(removeError){
                removeError.forEach((element)=>{element.classList.add("slds-box")});
            }
        });
    }

    get isPressureVacuumHeader(){
        return (this.selReliefType === 'Vacuum Relief' || this.selReliefType === 'Pressure Relief' || this.selReliefType === 'Pressure & Vacuum Relief') && this.constrainProductSelectionByFlow  === 'Yes';
    }

    get isVacuumSelected(){
        return (this.selReliefType === 'Vacuum Relief' || this.selReliefType === 'Pressure & Vacuum Relief') && this.constrainProductSelectionByFlow  === 'Yes';
    }

    get isPressureSelected(){
        return (this.selReliefType === 'Pressure Relief' || this.selReliefType === 'Pressure & Vacuum Relief') && this.constrainProductSelectionByFlow  === 'Yes';
    }

    handleRDFlowCapacityUnits(event){
        this.rdFlowCapacityUnitsVal = event.target.value;
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Inlet_Connection__c = this.inletConnectionVal;
        rDisc.Outlet_Connection__c = this.outletConnectionVal;
        rDisc.VacFlow_Capacity_Value__c = this.vacRdFlowCapactityValue;
        rDisc.VacProduct_Flow_Capacity_Units__c = this.vacRdFlowCapacityUnitsVal;
        rDisc.Rupture_Disc_Flow_Capacity_Units__c = this.rdFlowCapacityUnitsVal;
        rDisc.Rupture_Disc_Flow_Capacity_Value__c = this.rdFlowCapacityValue;
        rDisc.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rDisc.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rDisc.Converted_Density_Speci_Volume_SpeGravit__c = this.convertedDensitySpeciVolumeSpeGravit;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.evaluation_Type__c=this.evaluationType;
        rDisc.Required_Flow_Area_Units__c = this.requiredFlowAreaUnits;
        rDisc.VacRequired_Flow_Area_Units__c = this.vacrequiredFlowAreaUnits;
        rDisc.Molecular_Weight__c = this.molecularWeight;
        rDisc.Compressibility_Factor__c = this.compressibilityFactor;
        rDisc.Relief_Type__c = this.selReliefType;
        rDisc.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rDisc.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rDisc.Id = this.recordId;

        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Is_there_a_liquid_relief_scenario__c = this.IsThereLiquidReliefScenario;
        rDisc.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rDisc.ASME_Section_VIII_Division_1__c = this.ASMESectionVIIIDivision1;
        saveCapacityConversion({ruptureDisc: rDisc})
        .then(result => {
            this.rdFlowCapacityValue = result.Rupture_Disc_Flow_Capacity_Value__c;
            this.ProductFlowCapacity=result.Product_Flow_Capacity_Value__c;
            this.VacProductFlowCapacity=result.VacProduct_Flow_Capacity_Value__c;
            this.vacRdFlowCapactityValue = result.VacFlow_Capacity_Value__c;
        }
        )
        .catch(error => {
            console.log('saveCapacityConversion error ',JSON.stringify(error));
        });
    }

    handleVacRDFlowCapacityUnits(event){
        this.vacRdFlowCapacityUnitsVal = event.target.value;
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Inlet_Connection__c = this.inletConnectionVal;
        rDisc.Outlet_Connection__c = this.outletConnectionVal;
        rDisc.VacFlow_Capacity_Value__c = this.vacRdFlowCapactityValue;
        rDisc.VacProduct_Flow_Capacity_Units__c = this.vacRdFlowCapacityUnitsVal;
        rDisc.Rupture_Disc_Flow_Capacity_Units__c = this.rdFlowCapacityUnitsVal;
        rDisc.Rupture_Disc_Flow_Capacity_Value__c = this.rdFlowCapacityValue;
        rDisc.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rDisc.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rDisc.Converted_Density_Speci_Volume_SpeGravit__c = this.convertedDensitySpeciVolumeSpeGravit;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.evaluation_Type__c=this.evaluationType;
        rDisc.Required_Flow_Area_Units__c = this.requiredFlowAreaUnits;
        rDisc.VacRequired_Flow_Area_Units__c = this.vacrequiredFlowAreaUnits;
        rDisc.Molecular_Weight__c = this.molecularWeight;
        rDisc.Compressibility_Factor__c = this.compressibilityFactor;
        rDisc.Relief_Type__c = this.selReliefType;
        rDisc.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rDisc.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rDisc.Id = this.recordId;

        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Is_there_a_liquid_relief_scenario__c = this.IsThereLiquidReliefScenario;
        rDisc.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rDisc.ASME_Section_VIII_Division_1__c = this.ASMESectionVIIIDivision1;
        saveCapacityConversion({ruptureDisc: rDisc})
        .then(result => {
            this.rdFlowCapacityValue = result.Rupture_Disc_Flow_Capacity_Value__c;
            this.ProductFlowCapacity=result.Product_Flow_Capacity_Value__c;
            this.VacProductFlowCapacity=result.VacProduct_Flow_Capacity_Value__c;
            this.vacRdFlowCapactityValue = result.VacFlow_Capacity_Value__c;
        }
        )
        .catch(error => {
            console.log('saveCapacityConversion error ',JSON.stringify(error));
        });
    }

    handlePressureClass(event){
        this.pressureClassVal = event.detail.value;
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.constrain_product_selection_by_flow__c=this.constrainProductSelectionByFlow;
        rDisc.Id = this.recordId;
        rDisc.ASME_Section_VIII_Division_1__c = this.ASMESectionVIIIDivision1;
        rDisc.Flow_Area__c = this.flowArea;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.Evaluation_Type__c=this.evaluationType;
        getConsolidateHICOptns({ruptureDisc: rDisc })
        .then(result => {
            this.inletConnectionOptions = result;
        })
        .catch(error => {
            console.log('getConsolidateHICOptns error: ',JSON.stringify(error));
        });
    }

    handleInletConnection(event){
        this.inletConnectionVal = event.detail.value;

        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Inlet_Connection__c = this.inletConnectionVal;
        rDisc.Id = this.recordId;
        rDisc.ASME_Section_VIII_Division_1__c = this.ASMESectionVIIIDivision1;
        rDisc.Flow_Area__c = this.flowArea;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.Evaluation_Type__c=this.evaluationType;
        getConsolidateHOCOptns({ruptureDisc: rDisc })
        .then(result => {
            this.outletConnectionOptions = result;
            this.outletConnectionVal=null;
        })
        .catch(error => {
            console.log('getConsolidateHOCOptns error ',JSON.stringify(error));
        });
    }

    handleOutletConnection(event){
        this.outletConnectionVal = event.detail.value;
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Id = this.recordId;
        rDisc.Bypass__c=false;
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Inlet_Connection__c = this.inletConnectionVal;
        rDisc.Outlet_Connection__c= this.outletConnectionVal;
        rDisc.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rDisc.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rDisc.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rDisc.Converted_Flow_rate__c = this.convertedFlowRate;
        rDisc.Converted_Density_at_Inlet__c = this.convertedDensityAtInlet;
        rDisc.Converted_Specific_Volume__c = this.convertedSpecificVolume;
        rDisc.Flow_Area__c = this.flowArea;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.Evaluation_Type__c=this.evaluationType;
        rDisc.Required_Flow_Area_Units__c = this.requiredFlowAreaUnits;
        rDisc.VacRequired_Flow_Area_Units__c = this.vacrequiredFlowAreaUnits;
        rDisc.Process_Media__c = this.mediaType;
        rDisc.Is_Saturated__c=this.isSaturated;
        rDisc.Molecular_Weight__c = this.molecularWeight;
        rDisc.Ratio_of_Specific_Heats__c = this.ratioOfSpecificHeats;
        rDisc.Compressibility_Factor__c = this.compressibilityFactor;
        rDisc.Rupture_Disc_Flow_Capacity_Value__c = this.rdFlowCapacityValue;
        rDisc.Product_Flow_Capacity_Value__c=this.ProductFlowCapacity;
        rDisc.VacProduct_Flow_Capacity_Value__c= this.VacProductFlowCapacity;
        rDisc.Rupture_Disc_Flow_Capacity_Units__c = this.rdFlowCapacityUnitsVal;
        rDisc.Converted_Density_Speci_Volume_SpeGravit__c = this.convertedDensitySpeciVolumeSpeGravit;
        rDisc.Converted_Viscosity__c = this.convertedViscosity;
        rDisc.ConvertedSaturationPressure_at_InletTemp__c = this.convertedSaturationPressureAtInletTemp;
        rDisc.ConvertedSpecificVolumeat90_ofInletPress__c = this.convertedSpecificVolumeat90OfInletPress;
        rDisc.ConvertedDensity_at_90SaturationPressure__c = this.convertedDensityAt90SaturationPressure;
        rDisc.Stagnation_gas_vapor_quality__c = this.stagnationGasVaporQuality;
        rDisc.Converted_Stagnation_vapor_density__c = this.convertedStagnationVaporDensity;
        rDisc.Converted_Liquid_Density__c = this.convertedLiquidDensity;
        rDisc.Latent_heat_of_vaporization__c = this.latentHeatOfVaporization;
        rDisc.Liquid_specific_heat__c = this.liquidSpecificHeat;
        rDisc.Relief_Type__c = this.selReliefType;
        rDisc.Converted_Stagnation_gaspartial_Pressure__c = this.convertedStagnationGaspartialPressure;
        rDisc.ConvVapor_pres_corres_to_stagnation_temp__c = this.convVaporPresCorresToStagnationTemp;
        rDisc.Isentropic_coefficient_gas__c = this.isentropicCoefficientGas;
        rDisc.Isentropic_coefficient_vapor__c = this.isentropicCoefficientVapor;
        rDisc.Molecular_Weight_gas__c = this.molecularWeightGas;
        rDisc.Molecular_Weight_vapor__c = this.molecularWeightVapor;
        rDisc.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rDisc.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rDisc.constrain_product_selection_by_flow__c = this.constrainProductSelectionByFlow;
        rDisc.Coefficient_of_Discharge__c = this.coefficientOfDischargeVal;
        rDisc.Dryness_of_Wet_Steam__c = this.DrynessofWetSteamVal;
        rDisc.Size_Units__c = this.sizeUnits;
        rDisc.MNFA_for_Calculations__c = this.MNFAforCalculation;
        recalMNFA({ruptureDisc: rDisc })
        .then(result => {
            this.rdFlowCapacityValue = result.Rupture_Disc_Flow_Capacity_Value__c;
            this.ProductFlowCapacity=result.Product_Flow_Capacity_Value__c;
            this.VacProductFlowCapacity=result.VacProduct_Flow_Capacity_Value__c;
            this.vacRdFlowCapactityValue = result.VacFlow_Capacity_Value__c;
        })
        .catch(error => {
            console.log('recalMNFA error ',JSON.stringify(error));
        });
    }

    handleSizePickListOptions(event){
        this.selectedSize = event.target.value
    }

    handleSeatPickListOptions(event){
        this.selectedSeat = event.target.value
    }

    handleProductPickListValues(event){
        this.selectedProd = event.target.value
    }

    handleProductSelection(event){
        Array.from(this.template.querySelectorAll('lightning-input'))
        .forEach(element => {
            element.checked=false;
        });
        const checkbox = this.template.querySelector('lightning-input[data-value="'+event.target.dataset.value+'"]');
        checkbox.checked=true;
        this.selectedProd = event.target.dataset.product;
        this.selectedSeat = event.target.dataset.seat;
        this.selectedSize = event.target.dataset.size;
        this.selectedRecordId = event.target.dataset.value;
        this.HClassSection = false;
        this.ProductSection = false;
    }

    handleProductSelectionSave(){
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Id = this.recordId;
        rDisc.Bypass__c=false;
        rDisc.Shell_Test__c = false; //SERVICE TICKET #207590, reset ShellTest, when product selection is changed
        rDisc.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rDisc.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rDisc.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rDisc.Converted_Flow_rate__c = this.convertedFlowRate;
        rDisc.Converted_Density_at_Inlet__c = this.convertedDensityAtInlet;
        rDisc.Converted_Specific_Volume__c = this.convertedSpecificVolume;
        rDisc.Flow_Area__c = this.flowArea;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.Evaluation_Type__c=this.evaluationType;
        rDisc.Required_Flow_Area_Units__c = this.requiredFlowAreaUnits;
        rDisc.VacRequired_Flow_Area_Units__c = this.vacrequiredFlowAreaUnits;
        rDisc.Process_Media__c = this.mediaType;
        rDisc.Is_Saturated__c=this.isSaturated;
        rDisc.Molecular_Weight__c = this.molecularWeight;
        rDisc.Ratio_of_Specific_Heats__c = this.ratioOfSpecificHeats;
        rDisc.Compressibility_Factor__c = this.compressibilityFactor;
        rDisc.Rupture_Disc_Flow_Capacity_Value__c = this.rdFlowCapacityValue;
        rDisc.Product_Flow_Capacity_Value__c=this.ProductFlowCapacity;
        rDisc.VacProduct_Flow_Capacity_Value__c= this.VacProductFlowCapacity;
        rDisc.Rupture_Disc_Flow_Capacity_Units__c = this.rdFlowCapacityUnitsVal;
        rDisc.Converted_Density_Speci_Volume_SpeGravit__c = this.convertedDensitySpeciVolumeSpeGravit;
        rDisc.Converted_Viscosity__c = this.convertedViscosity;
        rDisc.ConvertedSaturationPressure_at_InletTemp__c = this.convertedSaturationPressureAtInletTemp;
        rDisc.ConvertedSpecificVolumeat90_ofInletPress__c = this.convertedSpecificVolumeat90OfInletPress;
        rDisc.ConvertedDensity_at_90SaturationPressure__c = this.convertedDensityAt90SaturationPressure;
        rDisc.Stagnation_gas_vapor_quality__c = this.stagnationGasVaporQuality;
        rDisc.Converted_Stagnation_vapor_density__c = this.convertedStagnationVaporDensity;
        rDisc.Converted_Liquid_Density__c = this.convertedLiquidDensity;
        rDisc.Latent_heat_of_vaporization__c = this.latentHeatOfVaporization;
        rDisc.Liquid_specific_heat__c = this.liquidSpecificHeat;
        rDisc.Relief_Type__c = this.selReliefType;
        rDisc.DSCVAR__c = this.DSCVAR;
        rDisc.Converted_Stagnation_gaspartial_Pressure__c = this.convertedStagnationGaspartialPressure;
        rDisc.ConvVapor_pres_corres_to_stagnation_temp__c = this.convVaporPresCorresToStagnationTemp;
        rDisc.Isentropic_coefficient_gas__c = this.isentropicCoefficientGas;
        rDisc.Isentropic_coefficient_vapor__c = this.isentropicCoefficientVapor;
        rDisc.Molecular_Weight_gas__c = this.molecularWeightGas;
        rDisc.Molecular_Weight_vapor__c = this.molecularWeightVapor;
        rDisc.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rDisc.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rDisc.constrain_product_selection_by_flow__c = this.constrainProductSelectionByFlow;
        rDisc.Coefficient_of_Discharge__c = this.coefficientOfDischargeVal;
        rDisc.Dryness_of_Wet_Steam__c = this.DrynessofWetSteamVal;
        rDisc.Size_Units__c = this.sizeUnits;
        rDisc.Converted_Temperature_Setting__c = this.convTempSetting; // Redmine 35122
        saveProductSelection({ruptureDisc: rDisc,rupRecordId: this.recordId,lstRDMBIds: this.rdMBRecIds })
        .then(result => {
            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section5");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.HClassSection = true;
            this.ProductSection = true;
            this.isProcessClass = true;
            if(this.finishConfigurationFlag && this.HClassSection){
                this.prodReviewButton = true;
            }
            this.rdFlowCapacityValue = result.Rupture_Disc_Flow_Capacity_Value__c;
            this.ProductFlowCapacity=result.Product_Flow_Capacity_Value__c;
            this.VacProductFlowCapacity= result.VacProduct_Flow_Capacity_Value__c;
            this.vacRdFlowCapactityValue = result.VacFlow_Capacity_Value__c;
            this.MNFAforCalculation=result.MNFA_for_Calculations__c
            this.pressureClassVal=result.Pressure_Class__c;
            this.inletConnectionVal=result.Inlet_Connection__c;
            this.outletConnectionVal=result.Outlet_Connection__c;
            this.DSCVAR=result.DSCVAR__c;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Successfully saved product selection',
                    variant: 'success',
                }),
            );
            rDisc.MNFA_for_Calculations__c = this.MNFAforCalculation;
            rDisc.DSCVAR__c=this.DSCVAR;
            getConsolidateHCLASSOptns({ruptureDisc: rDisc })
            .then(result => {
                this.pressureClassOptions = result.selOptions;
                this.disableIOConnFields = result.disableIOConn;
                this.rdFlowCapacityUnitsOptions = result.requiredFlowRateUnits;
                this.rdFlowCapacityValue = result.rdDisc.Rupture_Disc_Flow_Capacity_Value__c;
                this.ProductFlowCapacity=result.rdDisc.Product_Flow_Capacity_Value__c;
                this.VacProductFlowCapacity= result.rdDisc.VacProduct_Flow_Capacity_Value__c;
                this.vacRdFlowCapactityValue = result.rdDisc.VacFlow_Capacity_Value__c;
                if(this.constrainProductSelectionByFlow == 'No' && this.disableIOConnFields){

                    let isPortalUserVF = this.currentUserInfo.fields.IsPortalEnabled.value;
                    let encodeURI = '';
                    let sUrl = '/apex/ConfigRD?id='+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=seven';

                    if (isPortalUserVF) {
                        encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
                    } else {
                        encodeURI = sUrl;
                    }

                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: encodeURI
                        }
                    },
                        true // Replaces the current page in your browser history with the URL
                    );
                }
            })
            .catch(error => {
                console.log('getConsolidateHCLASSOptns error: ',JSON.stringify(error));
            });
            console.log('this.constrainProductSelectionByFlow',this.constrainProductSelectionByFlow);
            console.log('this.disableIOConnFields',this.disableIOConnFields);
            this.bShowHCLASSLink=false;

        })
        .catch(error => {
            this.isErrorSection5 = true;
            this.section5ErrorMessage = [];
            this.section5ErrorMessage.push(error.body.message);
            let removeError = this.template.querySelectorAll(".section5");
            if(removeError){
                removeError.forEach((element)=>{element.classList.add("slds-box")});
            }
        });
    }

    handleProductSelectionCancel(){
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        let QuoteLineInfo = this.QuoteLineInfo.fields.SBQQ__Quote__c.value;
		if(isPortalUser){
            window.open('/s/rupturedisccmp?configId='+this.recordId + '&quoteId=' + QuoteLineInfo, "_parent");
		}else{
            window.open('/lightning/cmp/c__ruptureDiscCmp?c__configId='+ this.recordId + '&c__quoteId=' + QuoteLineInfo, "_parent");
        }
    }

    moveForward(){
        //REDMINE #34472 ADDED LOGIC for navigition to HCLASS Section for finished configurations
        console.log('this.constrainProductSelectionByFlow: ',this.constrainProductSelectionByFlow);
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        let encodeURI = '';
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Product__c = this.selectedProd;
        rDisc.Seat__c = this.selectedSeat;
        rDisc.Size__c = this.selectedSize;
        rDisc.Id = this.recordId;
        rDisc.Bypass__c=false;
        rDisc.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rDisc.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rDisc.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rDisc.Converted_Flow_rate__c = this.convertedFlowRate;
        rDisc.Converted_Density_at_Inlet__c = this.convertedDensityAtInlet;
        rDisc.Converted_Specific_Volume__c = this.convertedSpecificVolume;
        rDisc.Flow_Area__c = this.flowArea;
        rDisc.Evaluation_Per__c = this.evaluationPer;
        rDisc.Evaluation_Type__c=this.evaluationType;
        rDisc.Required_Flow_Area_Units__c = this.requiredFlowAreaUnits;
        rDisc.VacRequired_Flow_Area_Units__c = this.vacrequiredFlowAreaUnits;
        rDisc.Process_Media__c = this.mediaType;
        rDisc.Is_Saturated__c=this.isSaturated;
        rDisc.Molecular_Weight__c = this.molecularWeight;
        rDisc.Ratio_of_Specific_Heats__c = this.ratioOfSpecificHeats;
        rDisc.Compressibility_Factor__c = this.compressibilityFactor;
        rDisc.Rupture_Disc_Flow_Capacity_Value__c = this.rdFlowCapacityValue;
        rDisc.Product_Flow_Capacity_Value__c=this.ProductFlowCapacity;
        rDisc.VacProduct_Flow_Capacity_Value__c= this.VacProductFlowCapacity;
        rDisc.Rupture_Disc_Flow_Capacity_Units__c = this.rdFlowCapacityUnitsVal;
        rDisc.Converted_Density_Speci_Volume_SpeGravit__c = this.convertedDensitySpeciVolumeSpeGravit;
        rDisc.Converted_Viscosity__c = this.convertedViscosity;
        rDisc.ConvertedSaturationPressure_at_InletTemp__c = this.convertedSaturationPressureAtInletTemp;
        rDisc.ConvertedSpecificVolumeat90_ofInletPress__c = this.convertedSpecificVolumeat90OfInletPress;
        rDisc.ConvertedDensity_at_90SaturationPressure__c = this.convertedDensityAt90SaturationPressure;
        rDisc.Stagnation_gas_vapor_quality__c = this.stagnationGasVaporQuality;
        rDisc.Converted_Stagnation_vapor_density__c = this.convertedStagnationVaporDensity;
        rDisc.Converted_Liquid_Density__c = this.convertedLiquidDensity;
        rDisc.Latent_heat_of_vaporization__c = this.latentHeatOfVaporization;
        rDisc.Liquid_specific_heat__c = this.liquidSpecificHeat;
        rDisc.Relief_Type__c = this.selReliefType;
        rDisc.DSCVAR__c = this.DSCVAR;
        rDisc.Converted_Stagnation_gaspartial_Pressure__c = this.convertedStagnationGaspartialPressure;
        rDisc.ConvVapor_pres_corres_to_stagnation_temp__c = this.convVaporPresCorresToStagnationTemp;
        rDisc.Isentropic_coefficient_gas__c = this.isentropicCoefficientGas;
        rDisc.Isentropic_coefficient_vapor__c = this.isentropicCoefficientVapor;
        rDisc.Molecular_Weight_gas__c = this.molecularWeightGas;
        rDisc.Molecular_Weight_vapor__c = this.molecularWeightVapor;
        rDisc.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rDisc.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rDisc.constrain_product_selection_by_flow__c = this.constrainProductSelectionByFlow;
        rDisc.Coefficient_of_Discharge__c = this.coefficientOfDischargeVal;
        rDisc.Dryness_of_Wet_Steam__c = this.DrynessofWetSteamVal;
        rDisc.Size_Units__c = this.sizeUnits;
        rDisc.MNFA_for_Calculations__c = this.MNFAforCalculation;
        rDisc.DSCVAR__c=this.DSCVAR;
        rDisc.Pressure_Class__c = this.pressureClassVal;
        rDisc.Inlet_Connection__c = this.inletConnectionVal;
        rDisc.Outlet_Connection__c= this.outletConnectionVal;
        getConsolidateHCLASSOptns({ruptureDisc: rDisc })
        .then(result => {
            this.pressureClassOptions = result.selOptions;
            this.disableIOConnFields = result.disableIOConn;
            this.rdFlowCapacityUnitsOptions = result.requiredFlowRateUnits;
            this.rdFlowCapacityValue = result.rdDisc.Rupture_Disc_Flow_Capacity_Value__c;
            this.ProductFlowCapacity=result.rdDisc.Product_Flow_Capacity_Value__c;
            this.VacProductFlowCapacity= result.rdDisc.VacProduct_Flow_Capacity_Value__c;
            this.vacRdFlowCapactityValue = result.rdDisc.VacFlow_Capacity_Value__c;
            this.pressureClassVal=result.rdDisc.Pressure_Class__c;
            this.inletConnectionVal=result.rdDisc.Inlet_Connection__c;
            this.outletConnectionVal=result.rdDisc.Outlet_Connection__c;
            getConsolidateHICOptns({ruptureDisc: rDisc })
            .then(result => {
                this.inletConnectionOptions = result;
            })
            .catch(error => {
                console.log('getConsolidateHICOptns error: ',JSON.stringify(error));
            });
            getConsolidateHOCOptns({ruptureDisc: rDisc })
            .then(result => {
                this.outletConnectionOptions = result;
                //this.outletConnectionVal=null;
            })
            .catch(error => {
                console.log('getConsolidateHOCOptns error ',JSON.stringify(error));
            });
            console.log('this.constrainProductSelectionByFlow: ',result.rdDisc.Pressure_Class__c);
            console.log('this.disableIOConnFields: ',result.rdDisc.Inlet_Connection__c);
            console.log('this.disableIOConnFields: ',result.rdDisc.Inlet_Connection__c);
            if(this.constrainProductSelectionByFlow == 'No' && this.disableIOConnFields){

                let isPortalUserVF = this.currentUserInfo.fields.IsPortalEnabled.value;
                let encodeURI = '';
                let sUrl = '/apex/ConfigRD?id='+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=seven';

                if (isPortalUserVF) {
                    encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
                } else {
                    encodeURI = sUrl;
                }

                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: encodeURI
                    }
                },
                    true // Replaces the current page in your browser history with the URL
                );
            }
        })
        .catch(error => {
            console.log('getConsolidateHCLASSOptns error: ',JSON.stringify(error));
        });
        this.HClassSection = true;
        this.ProductSection = true;
        this.bShowHCLASSLink=true;
        //REDMINE #34472 ADDED LOGIC for navigition to HCLASS Section for finished configurations
        //Commented bellow code and moved to moveForwardTOVf() method as part of navigation changes.

            // let sUrl = '/apex/ConfigRD?qid='+ this.quoteLineId;

            // if (isPortalUser) {
            //     encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
            // } else {
            //     encodeURI = sUrl;
            // }

            // this[NavigationMixin.Navigate]({
            //     type: 'standard__webPage',
            //     attributes: {
            //         url: encodeURI
            //     }
            // },
            //     true // Replaces the current page in your browser history with the URL
            // );
        //************************************************************************************* */

    }

    generateProductSelectionDropDown(RuptureDiscObj){
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Application_type__c = RuptureDiscObj.fields.Application_type__c.value;
        rDisc.Operating_Pressure_Ratio__c = RuptureDiscObj.fields.Operating_Pressure_Ratio__c.value;
        rDisc.CU_TR__c = RuptureDiscObj.fields.CU_TR__c.value;
        rDisc.X3A_Sanitary_Standards__c = RuptureDiscObj.fields.X3A_Sanitary_Standards__c.value;
        rDisc.Atex_Certificate__c = RuptureDiscObj.fields.Atex_Certificate__c.value;
        rDisc.Relief_Type__c = RuptureDiscObj.fields.Relief_Type__c.value;
        rDisc.Non_Fragmenting_Design_Required__c = RuptureDiscObj.fields.Non_Fragmenting_Design_Required__c.value;
        this.selectedProd = RuptureDiscObj.fields.Product__c.value;
        this.selectedSeat = RuptureDiscObj.fields.Seat__c.value;
        this.selectedSize = RuptureDiscObj.fields.Size__c.value;
        this.Id = this.recordId;

        rDisc.Converted_Temperature_Setting__c = RuptureDiscObj.fields.Converted_Temperature_Setting__c.value;
        rDisc.Converted_Pressure_Setting__c = RuptureDiscObj.fields.Converted_Pressure_Setting__c.value;
        this.isLoading = true;
        getRDMasterIDs({ruptureDisc: rDisc, rupRecordId: this.recordId})
        .then(result => {
            this.isLoading = false;
            this.productPickListValues = result.prodOptions;
            this.seatPickListOptions = result.seatOptions;
            this.sizePickListOptions = result.sizeOptions;
            this.rdMBRecIds = result.rdOptions;
            //this.filteredRDRecords = result.rdOptions;
            //this.rdRecords = result.rdOptions;
            console.log('this.rdMBRecIds getRDMasterIDs--- > ',this.rdMBRecIds);
        })
        .catch(error => {
            this.isLoading = false;
            console.log('getRDMasterIDs error: ',JSON.stringify(error));
        });

        // getRupDiscRecords({ruptureDisc: rDisc, rupRecordId: this.recordId})//, lstRDMBIds: this.rdMBRecIds
        // .then(result => {
        //     console.log('this.rdMBRecIds getRupDiscRecords--- > ',this.rdMBRecIds);
        //     this.filteredRDRecords = result.rdOptions;
        //     this.rdRecords = result.rdOptions;
        // })
        // .catch(error => {
        //     console.log('getRDMasterIDs error: ',JSON.stringify(error));
        // });

        // getProductPicklistValues({ruptureDisc: rDisc, rupRecordId: this.recordId, lstRDMBIds: this.rdMBRecIds})
        // .then(result => {
        //     console.log('getProductPicklistValues - data 15/09/2020 -->  ',this.rdMBRecIds);
        //     this.productPickListValues = result;
        //     //console.log('this.productPickListValues ---> ',this.productPickListValues);
        //     // result.sort(function(o1, o2) {
        //     //     var t1 = o1.t.toLowerCase(), t2 = o2.t.toLowerCase();
        //     //     this.productPickListValues = t1 > t2 ? 1 : t1 < t2 ? -1 : 0;
        //     //     return this.productPickListValues;
        //     // });
        // })
        // .catch(error => {
        //     console.log('productPickListValues error: ',JSON.stringify(error));
        // });
        // getSeatPicklistValues({ruptureDisc: rDisc, rupRecordId: this.recordId, lstRDMBIds: this.rdMBRecIds })
        // .then(result => {
        //     console.log('getSeatPicklistValues - data 15/09/2020 -->  ',this.rdMBRecIds);
        //     this.seatPickListOptions = result;
        // })
        // .catch(error => {
        //     console.log('seatPickListOptions error: ',JSON.stringify(error));
        // });

        // getSizePicklistValues({ruptureDisc: rDisc, rupRecordId: this.recordId, lstRDMBIds: this.rdMBRecIds })
        // .then(result => {
        //     this.sizePickListOptions = result;
        // })
        // .catch(error => {
        //     console.log('sizePickListOptions error: ',JSON.stringify(error));
        // });
    }

    clearFilters(){
        this.selectedProd = null;
        this.selectedSeat = null;
        this.selectedSize = null;
    }

    filterProducts(){
        if(this.rdRecords){
            let condition1 = this.selectedProd !== undefined && this.selectedProd !== null && this.selectedProd !== 'null' && this.selectedProd !== "";
            let condition2 = this.selectedSeat !== undefined && this.selectedSeat !== null && this.selectedSeat !== 'null' && this.selectedSeat !== "";
            let condition3 = this.selectedSize !== undefined && this.selectedSize !== null && this.selectedSize !== 'null' && this.selectedSize !== "";
            let tempRDRecords = [];

            this.rdRecords.forEach(rdRecord => {
                if(!condition1 && !condition2 && !condition3){
                    tempRDRecords.push(rdRecord);
                }else if(condition1 && condition2 && condition3){
                    if(this.selectedSize === String(rdRecord.size) && this.selectedSeat === rdRecord.seat && this.selectedProd === rdRecord.product){
                        tempRDRecords.push(rdRecord);
                    }
                }else{
                    if(condition1 && condition2 && this.selectedProd === rdRecord.product && this.selectedSeat === rdRecord.seat && !condition3){
                        tempRDRecords.push(rdRecord);
                    }else if(condition2 && condition3 && this.selectedSeat === rdRecord.seat && this.selectedSize === String(rdRecord.size) && !condition1){
                        tempRDRecords.push(rdRecord);
                    }else if(condition3 && condition1 && this.selectedSize === String(rdRecord.size) && this.selectedProd === rdRecord.product && !condition2){
                        tempRDRecords.push(rdRecord);
                    }else if(condition1 && this.selectedProd === rdRecord.product && !condition2 && !condition3){
                        tempRDRecords.push(rdRecord);
                    }else if(condition2 && this.selectedSeat === rdRecord.seat && !condition1 && !condition3){
                        tempRDRecords.push(rdRecord);
                    }else if(condition3 && this.selectedSize === String(rdRecord.size) && !condition2 && !condition1){
                        tempRDRecords.push(rdRecord);
                    }
                }
            });
            this.filteredRDRecords = tempRDRecords;
        }
    }

    RemoveDecimal(event){
        let targetName = event.target.name;
        if(targetName === 'rdFlowCapacityValue')
            this.rdFlowCapacityValue = event.target.value;

    }

    restrictNonNumericalValues(event){
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
        event.preventDefault();
    }

    renderedCallback() {
        if(this.constrainProductSelectionByFlow == 'No'){
            this.HideCapacity = true;
        } else {
            this.HideCapacity = false;
        }

        if (this.rdRecords && this.isFilterApplied) {
            return this.rdRecords;
        }

        this.isFilterApplied = true;
        this.filterProducts();

        if(this.selectedProd && this.selectedSeat && this.selectedSize){
            let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
            getRupDiscRecords({ruptureDisc: rDisc, rupRecordId: this.recordId})
            .then(result => {
                this.rdRecords = result;
                this.filteredRDRecords = result;
                this.filterProducts();
            })
            .catch(error => {});
        }
    }
}