import { LightningElement, track,api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import Rupture_Disc_OBJECT from '@salesforce/schema/Rupture_Disc__c';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
//import RD_OBJECT from '@salesforce/schema/Rupture_Disc__c';

import evaluationType_FIELD from '@salesforce/schema/Rupture_Disc__c.Evaluation_Type__c';
import relievingPressureatInlet_FIELD from '@salesforce/schema/Rupture_Disc__c.Relieving_Pressure_at_Inlet__c';
import pressureRelievingTemperature_FIELD from '@salesforce/schema/Rupture_Disc__c.Pressure_Relieving_Temperature__c';
import EvaluationPer_FIELD from '@salesforce/schema/Rupture_Disc__c.Evaluation_Per__c';
import CustomerSpecifiedMedia_FIELD from '@salesforce/schema/Rupture_Disc__c.Customer_Specified_Media__c';
import FlowArea_FIELD from '@salesforce/schema/Rupture_Disc__c.Flow_Area__c';
import vacPressureRelievingTemperature_FIELD from '@salesforce/schema/Rupture_Disc__c.VacPressure_Relieving_Temperature__c';
import DensityAtInlet_FIELD from '@salesforce/schema/Rupture_Disc__c.Density_at_Inlet__c';
import DensitySpecificVolumeSpecificGravity_FIELD from '@salesforce/schema/Rupture_Disc__c.Density_Specific_Volume_Specific_Gravity__c';
import SpecificVolumeAtInlet_FIELD from '@salesforce/schema/Rupture_Disc__c.Specific_Volume_at_inlet__c';
import RequiredFlowRate_FIELD from '@salesforce/schema/Rupture_Disc__c.Required_Flow_Rate__c';
import EnterDifferentTemperatureValue_FIELD from '@salesforce/schema/Rupture_Disc__c.Enter_Different_Temperature_Value__c';
import Viscosity_FIELD from '@salesforce/schema/Rupture_Disc__c.Viscosity__c';
import DrynessOfWetSteam_FIELD from '@salesforce/schema/Rupture_Disc__c.Dryness_of_Wet_Steam__c';
import SpecificVolumeAt90OfInletPressure_FIELD from '@salesforce/schema/Rupture_Disc__c.Specific_Volume_at_90_of_Inlet_Pressure__c';
import SaturationPressureAtInletTemperature_FIELD from '@salesforce/schema/Rupture_Disc__c.Saturation_Pressure_at_Inlet_Temperature__c';
import DensityAt90OfSaturationPressure_FIELD from '@salesforce/schema/Rupture_Disc__c.Density_at_90_of_Saturation_Pressure__c';
import StagnationGasVaporQuality_FIELD from '@salesforce/schema/Rupture_Disc__c.Stagnation_gas_vapor_quality__c';
import StagnationVaporDensity_FIELD from '@salesforce/schema/Rupture_Disc__c.Stagnation_vapor_density__c';
import LiquidDensity_FIELD from '@salesforce/schema/Rupture_Disc__c.Liquid_density__c';
import LatentHeatOfVaporization_FIELD from '@salesforce/schema/Rupture_Disc__c.Latent_heat_of_vaporization__c';
import StagnationGasPartialPressure_FIELD from '@salesforce/schema/Rupture_Disc__c.Stagnation_gas_partial_pressure__c';
import VaporPresCorrespondToStagnationTemp_FIELD from '@salesforce/schema/Rupture_Disc__c.Vapor_pres_correspond_to_stagnation_temp__c';
import IsentropicCoefficientGas_FIELD from '@salesforce/schema/Rupture_Disc__c.Isentropic_coefficient_gas__c';
import IsentropicCoefficientVapor_FIELD from '@salesforce/schema/Rupture_Disc__c.Isentropic_coefficient_vapor__c';
import isSaturated_FIELD from '@salesforce/schema/Rupture_Disc__c.Is_Saturated__c';
import MolecularWeightGas_FIELD from '@salesforce/schema/Rupture_Disc__c.Molecular_Weight_gas__c';
import MolecularWeightVapor_FIELD from '@salesforce/schema/Rupture_Disc__c.Molecular_Weight_vapor__c';
import OutputRequiredFlowArea_FIELD from '@salesforce/schema/Rupture_Disc__c.Output_Required_Flow_Area__c';
import EnterRelievingPressureValue_FIELD from '@salesforce/schema/Rupture_Disc__c.Enter_Relieving_Pressure_Value__c';
import VacRequiredFlowRate_FIELD from '@salesforce/schema/Rupture_Disc__c.VacRequired_Flow_Rate__c';
import VacuumSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Vacuum_Setting__c';
import VacEnterDifferentTemperatureValue_FIELD from '@salesforce/schema/Rupture_Disc__c.VacEnter_Different_Temperature_Value__c';
import VacFlowArea_FIELD from '@salesforce/schema/Rupture_Disc__c.VacFlow_Area__c';
import VacRequiredFlowArea_FIELD from '@salesforce/schema/Rupture_Disc__c.VacRequired_Flow_Area__c';
import LiquidSpecificHeat_FIELD from '@salesforce/schema/Rupture_Disc__c.Liquid_specific_heat__c';
import MolecularWeight_FIELD from '@salesforce/schema/Rupture_Disc__c.Molecular_Weight__c';
import CompressibilityFactor_FIELD from '@salesforce/schema/Rupture_Disc__c.Compressibility_Factor__c';
import RatioOfSpecificHeats_FIELD from '@salesforce/schema/Rupture_Disc__c.Ratio_of_Specific_Heats__c';
import ProcessMedia_FIELD from '@salesforce/schema/Rupture_Disc__c.Process_Media__c';
import ConvertedPressureSetting_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Pressure_Setting__c';
import ConvertedRelievingPressureValue_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Relieving_Pressure_Value__c';
import ConvertedRelievingTemperature_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Relieving_Temperature__c';
import ConvertedFlowRate_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Flow_rate__c';
import ConvertedDensityAtInlet_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Density_at_Inlet__c';
import ConvertedSpecificVolume_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Specific_Volume__c';
import VacConvertedDifferentTempSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.VacConverted_Different_Temp_Setting__c';
import VacConvertedFlowRate_FIELD from '@salesforce/schema/Rupture_Disc__c.VacConverted_Flow_Rate__c';
import ConvertedVacuumSetting_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Vacuum_Setting__c';
import TemperatureSettingUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Temperature_Setting_Units__c';
import TemperatureSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Temperature_Setting__c';
import IsThereRiquidRelScenario_FIELD from '@salesforce/schema/Rupture_Disc__c.Is_there_a_liquid_relief_scenario__c';
import VacuumSettingUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Vacuum_Setting_Units__c';
import RequiredFlowUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Required_Flow_units__c';
import constrainProductSelection_FIELD from '@salesforce/schema/Rupture_Disc__c.Constrain_product_selection__c';
import CoefficientOfDischargeOptions_FIELD from '@salesforce/schema/Rupture_Disc__c.Coefficient_of_Discharge__c';

import saveSizingFlowArea from '@salesforce/apex/RuptureDiscController.saveSizingFlowArea';
import mediaTypesPickValues from '@salesforce/apex/RuptureDiscController.mediaTypesPickValues';
import imperativeMediaTypesPickValues from '@salesforce/apex/RuptureDiscController.imperativeMediaTypesPickValues';
import mediaPropertyOnProcessMedia from '@salesforce/apex/RuptureDiscController.mediaPropertyOnProcessMedia';

const RuptureDiscFIELDS = [evaluationType_FIELD,relievingPressureatInlet_FIELD,pressureRelievingTemperature_FIELD,vacPressureRelievingTemperature_FIELD,EvaluationPer_FIELD,CustomerSpecifiedMedia_FIELD,
    DensityAtInlet_FIELD,ConvertedPressureSetting_Field,ConvertedRelievingPressureValue_Field,ConvertedRelievingTemperature_FIELD,ConvertedFlowRate_FIELD,ConvertedDensityAtInlet_FIELD,ConvertedSpecificVolume_FIELD,
    ConvertedVacuumSetting_Field,TemperatureSettingUnits_FIELD,TemperatureSetting_FIELD,IsThereRiquidRelScenario_FIELD,VacuumSettingUnits_FIELD,
    SpecificVolumeAtInlet_FIELD,RequiredFlowRate_FIELD,EnterDifferentTemperatureValue_FIELD,Viscosity_FIELD,FlowArea_FIELD,LiquidSpecificHeat_FIELD,
    DrynessOfWetSteam_FIELD,SpecificVolumeAt90OfInletPressure_FIELD,SaturationPressureAtInletTemperature_FIELD,DensityAt90OfSaturationPressure_FIELD,
    StagnationGasVaporQuality_FIELD,StagnationVaporDensity_FIELD,LiquidDensity_FIELD,LatentHeatOfVaporization_FIELD,StagnationGasPartialPressure_FIELD,isSaturated_FIELD,
    VaporPresCorrespondToStagnationTemp_FIELD,IsentropicCoefficientGas_FIELD,IsentropicCoefficientVapor_FIELD,MolecularWeightGas_FIELD,
    MolecularWeightVapor_FIELD,OutputRequiredFlowArea_FIELD,DensitySpecificVolumeSpecificGravity_FIELD,EnterRelievingPressureValue_FIELD,
    VacRequiredFlowRate_FIELD,VacuumSetting_FIELD,VacEnterDifferentTemperatureValue_FIELD,VacFlowArea_FIELD,VacRequiredFlowArea_FIELD,
    MolecularWeight_FIELD,RatioOfSpecificHeats_FIELD, CompressibilityFactor_FIELD,ProcessMedia_FIELD,VacConvertedFlowRate_FIELD,VacConvertedDifferentTempSetting_FIELD,
    RequiredFlowUnits_FIELD,constrainProductSelection_FIELD,CoefficientOfDischargeOptions_FIELD]

export default class LwcRDSizingFlowArea extends NavigationMixin(LightningElement) {
    @api recordId;
    @api selectedReliefType;
    @api selConstrainProd;
    @track pressureRelievingTemperatureOptions;
    @track vacPressureRelievingTemperatureOptions;
    @track evaluationTypeOptions;
    @track selectedEvaluationTypeOptions;
    @track relievingPressureatInletOptions;
    @track selectedRelievingPressureatInlet;
    @track selectedPressureRelievingTemperature;
    @track selectedVacPressureRelievingTemperature;

    @track selectedProcessMedia;
    @track processMediaOptions;
    @track selEvalPer;
    @track calculatedFlowArea;

    @track densityAtInlet;
    @track densitySpecialVolumeSpecialGravity;
    @track vacReqFlowArea;
    @track vacFlowArea;
    @track vacDiffTempValue;
    @track vacuumSetting;
    @track vacReqFlowRate;
    @track enterRelPressureValue;
    @track specialVolumeAtInlet;
    @track outReqFlowArea;
    @track moleWeightVapor;
    @track moleWeightGas;
    @track isentropicCoVapor;
    @track isentropicCoGas;
    @track vaporPressCorrToStagTemp;
    @track staGasPartPressure;
    @track liquidSpecificHeat;
    @track isSaturated;
    @track latHeatVapor;
    @track liquidDen;
    @track staVaporDen;
    @track staGVQua;
    @track denAt90SatPressure;
    @track satPressureAtInletTemp;
    @track drynessOfWetSteam;
    @track requiredFlowRate;
    @track enterDifferentTemperatureValue;
    @track selectedRequiredFlowUnit;
    @track requiredFlowUnitsOptions;

    @track convertedPressureSetting;
    @track convertedRelievingPressureValue;
    @track convertedRelievingTemperature;
    @track convertedFlowRate;
    @track convertedDensityAtInlet;
    @track convertedSpecificVolume;
    @track vacConvertedDifferentTempSetting;
    @track vacConvertedFlowRate;
    @track convertedVacuumSetting;
    @track temperatureSettingUnits;
    @track temperatureSetting;
    @track isThereRiquidRelScenario;
    @track evaluationPerOptions;
    @track vacuumSettingUnits;

    @track customerSpecifiedMedia;
    @track molecularWeight;
    @track CompressibilityFactor;
    @track ratioOfSpecificHeats;
    @track notCustomerSpecified;
    @track filteredEvaluationPerOptions;
    @track coefficientOfDischargeVal;
    @track CoefficientOfDischargeOptions;

    //Error Handling Section-B Sizing Section Area
    @track sizingFlowAreaMessage;
    @track isErrorSizingArea;

      //added by piyush
      @api sDisabled = '';
      @api bDisabled = false;

    //added by piyush
    evaluationPerOptionsAllValues;

    @wire(getObjectInfo, { objectApiName: Rupture_Disc_OBJECT })
        objectInfo;

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
            this.selectedEvaluationTypeOptions = data.fields.Evaluation_Type__c.value;
            this.selectedRelievingPressureatInlet = data.fields.Relieving_Pressure_at_Inlet__c.value;
            this.selectedPressureRelievingTemperature = data.fields.Pressure_Relieving_Temperature__c.value;
            this.selEvalPer = data.fields.Evaluation_Per__c.value;
            this.calculatedFlowArea = data.fields.Flow_Area__c.value;
            this.handleEvaluationPerChange({ target: {value:this.selEvalPer }} , '0');
            this.selectedProcessMedia = data.fields.Customer_Specified_Media__c.value;
            this.selectedVacPressureRelievingTemperature = data.fields.VacPressure_Relieving_Temperature__c.value;
            this.densityAtInlet = data.fields.Density_at_Inlet__c.value;
            this.convertedPressureSetting = data.fields.Converted_Pressure_Setting__c.value;
            this.convertedRelievingPressureValue = data.fields.Converted_Relieving_Pressure_Value__c.value;
            this.convertedRelievingTemperature = data.fields.Converted_Relieving_Temperature__c.value;
            this.convertedFlowRate = data.fields.Converted_Flow_rate__c.value;
            this.convertedDensityAtInlet = data.fields.Converted_Density_at_Inlet__c.value;
            this.convertedSpecificVolume = data.fields.Converted_Specific_Volume__c.value;
            this.vacConvertedDifferentTempSetting = data.fields.VacConverted_Different_Temp_Setting__c.value;
            this.vacConvertedFlowRate = data.fields.VacConverted_Flow_Rate__c.value;
            this.convertedVacuumSetting = data.fields.Converted_Vacuum_Setting__c.value;
            this.densitySpecialVolumeSpecialGravity = data.fields.Density_Specific_Volume_Specific_Gravity__c.value;
            this.specialVolumeAtInlet = data.fields.Specific_Volume_at_inlet__c.value;
            this.requiredFlowRate = data.fields.Required_Flow_Rate__c.value;
            this.enterDifferentTemperatureValue = data.fields.Enter_Different_Temperature_Value__c.value;
            this.viscosity = data.fields.Viscosity__c.value;
            this.drynessOfWetSteam =data.fields.Dryness_of_Wet_Steam__c.value;
            this.specificVolumeAt90OfInletPressure = data.fields.Specific_Volume_at_90_of_Inlet_Pressure__c.value;
            this.satPressureAtInletTemp = data.fields.Saturation_Pressure_at_Inlet_Temperature__c.value;
            this.denAt90SatPressure = data.fields.Density_at_90_of_Saturation_Pressure__c.value;
            this.staGVQua = data.fields.Stagnation_gas_vapor_quality__c.value;
            this.staVaporDen = data.fields.Stagnation_vapor_density__c.value;
            this.liquidDen = data.fields.Liquid_density__c.value;
            this.latHeatVapor = data.fields.Latent_heat_of_vaporization__c.value;
            this.staGasPartPressure = data.fields.Stagnation_gas_partial_pressure__c.value;
            this.vaporPressCorrToStagTemp = data.fields.Vapor_pres_correspond_to_stagnation_temp__c.value;
            this.isentropicCoGas = data.fields.Isentropic_coefficient_gas__c.value;
            this.isentropicCoVapor = data.fields.Isentropic_coefficient_vapor__c.value;
            this.moleWeightGas = data.fields.Molecular_Weight_gas__c.value;
            this.moleWeightVapor = data.fields.Molecular_Weight_vapor__c.value;
            this.outReqFlowArea = data.fields.Output_Required_Flow_Area__c.value;
            this.enterRelPressureValue = data.fields.Enter_Relieving_Pressure_Value__c.value;
            this.vacReqFlowRate = data.fields.VacRequired_Flow_Rate__c.value;
            this.vacuumSetting = data.fields.Vacuum_Setting__c.value;
            this.vacDiffTempValue = data.fields.VacEnter_Different_Temperature_Value__c.value;
            this.vacFlowArea = data.fields.VacFlow_Area__c.value;
            this.vacReqFlowArea = data.fields.VacRequired_Flow_Area__c.value;
            this.liquidSpecificHeat = data.fields.Liquid_specific_heat__c.value;
            this.isSaturated=data.fields.Is_Saturated__c.value;
            this.customerSpecifiedMedia = data.fields.Customer_Specified_Media__c.value;
            this.molecularWeight = data.fields.Molecular_Weight__c.value;
            this.CompressibilityFactor = data.fields.Compressibility_Factor__c.value;
            this.ratioOfSpecificHeats = data.fields.Ratio_of_Specific_Heats__c.value;
            this.selectedProcessMedia = data.fields.Process_Media__c.value;
            this.selectedRelievingPressureatInlet = data.fields.Relieving_Pressure_at_Inlet__c.value;
            this.temperatureSettingUnits = data.fields.Temperature_Setting_Units__c.value;
            this.temperatureSetting = data.fields.Temperature_Setting__c.value;
            this.vacuumSettingUnits = data.fields.Vacuum_Setting_Units__c.value;
            this.isThereRiquidRelScenario = data.fields.Is_there_a_liquid_relief_scenario__c.value;

            this.selectedRequiredFlowUnit = data.fields.Required_Flow_units__c.value;
            this.coefficientOfDischargeVal =data.fields.Coefficient_of_Discharge__c.value;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : evaluationType_FIELD
    })
    evaluationTypePickListValues({ data, error }){
        if(data){
            this.evaluationTypeOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'evaluationType'+element.value.split(' ').join('').split('&').join('')+'Id'};
                this.evaluationTypeOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.evaluationTypeOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : relievingPressureatInlet_FIELD
    })
    relievingPressureatInletPickListValues({ data, error }){
        if(data){
            this.relievingPressureatInletOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'rPInlet'+element.value.split(' ').join('').split('%').join('').split('/').join('')+'Id'};
                this.relievingPressureatInletOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.relievingPressureatInletOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : pressureRelievingTemperature_FIELD
    })
    pressureRelievingTemperaturePickListValues({ data, error }){
        if(data){
            this.pressureRelievingTemperatureOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'pressureRelievingTemp'+element.value+'Id'};
                this.pressureRelievingTemperatureOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.pressureRelievingTemperatureOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : vacPressureRelievingTemperature_FIELD
    })
    vacPressureRelievingTemperaturePickListValues({ data, error }){
        if(data){
            this.vacPressureRelievingTemperatureOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'vacPressureRelievingTemp'+element.value+'Id'};
                this.vacPressureRelievingTemperatureOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.vacPressureRelievingTemperatureOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : EvaluationPer_FIELD
    })
    evaluationPerPickListValues({ data, error }){
        if(data){
            this.evaluationPerOptionsAllValues = data;
        // code commnet by piyush [logic moved to another funtion ]
            this.evaluationPerOptions = [];
            this.evaluationPerOptions.push({ label: 'None', value: 'evalPerNone' });
            console.log('this.evaluationPerOptions 244: -',this.evaluationPerOptions);
            console.log('this.isThereRiquidRelScenario 245: -',this.isThereRiquidRelScenario);
            data.values.forEach(element =>{
                if(this.isThereRiquidRelScenario == 'No'){
                    console.log('this.isThereRiquidRelScenario 248: -');
                    let newElement = {label:element.label,value:element.value,generatedId:'EvaluationPer'+element.value+'Id'};
                    if(newElement.label == 'ASME Gas/Vapor' || newElement.label == 'ASME Steam' || newElement.label == 'API Gas/Vapor'
                    || newElement.label == 'API Steam' || newElement.label == 'ISO Gas/Vapor' || newElement.label == 'ISO Dry Steam'){
                        this.evaluationPerOptions.push(newElement);
                    }
                } else if(this.isThereRiquidRelScenario == 'Yes'){

                    let newElement = {label:element.label,value:element.value,generatedId:'EvaluationPer'+element.value+'Id'};
                    console.log('newElement===> ' + JSON.stringify(newElement));
                    this.evaluationPerOptions.push(newElement);
                }
            });
            console.log('this.evaluationPerOptions 260: -',this.evaluationPerOptions);
         // piyush --- end


            /*console.log('this.isThereRiquidRelScenario 261: -',this.isThereRiquidRelScenario);
            console.log('this.evaluationPerOptions 262: -',this.evaluationPerOptions);
            this.filteredEvaluationPerOptions = [];
            if(this.evaluationPerOptions.length > 0){
                this.evaluationPerOptions.forEach(element =>{
                    if(this.isThereRiquidRelScenario == 'No'){
                        let newElement = {label:element.label,value:element.value,generatedId:'EvaluationPer'+element.value+'Id'};
                        if(newElement.label == 'ASME Gas/Vapor' || newElement.label == 'ASME Steam' || newElement.label == 'API Gas/Vapor'
                        || newElement.label == 'API Steam' || newElement.label == 'ISO Gas/Vapor' || newElement.label == 'ISO Dry Steam'){
                            this.filteredEvaluationPerOptions.push(newElement);
                    }
                } else if(this.isThereRiquidRelScenario == 'Yes'){
                    console.log('this.isThereRiquidRelScenario 255: -');
                    let newElement = {label:element.label,value:element.value,generatedId:'EvaluationPer'+element.value+'Id'};
                    this.filteredEvaluationPerOptions.push(newElement);
                }
                });
            }*/

            this.error = undefined;
        }
        if(error){
            console.log('errror :',error);
            this.error = error;
            this.evaluationPerOptions = undefined;
        }
    }

    @api
    afterSectionASave(ruptureDisc){

        if(ruptureDisc.Relief_Type__c == 'Pressure Relief' || (ruptureDisc.Relief_Type__c == 'Pressure & Vacuum Relief' && ruptureDisc.Constrain_product_selection__c != 'Vacuum')){

            // if(this.selectedEvaluationTypeOptions && this.template.querySelector('[class="'+this.selectedEvaluationTypeOptions.split(' ').join('').split('&').join('')+'Id"]')){
            //     this.template.querySelector('[class="evaluationType'+this.selectedEvaluationTypeOptions.split(' ').join('').split('&').join('')+'Id"]').checked = false;
            // }

            this.selectedEvaluationTypeOptions = undefined;
        }

        this.isErrorSizingArea = false;

        this.sizingFlowAreaMessage = [];

        this.isThereRiquidRelScenario = ruptureDisc.Is_there_a_liquid_relief_scenario__c;

        let removeError = this.template.querySelectorAll(".sizingArea");
        if(removeError){
            removeError.forEach((element)=>{element.classList.remove("slds-box")});
        }

        /*this.filteredEvaluationPerOptions = [];

        if(this.evaluationPerOptions.length > 0){
            this.evaluationPerOptions.forEach(element =>{
            if(this.isThereRiquidRelScenario == 'No'){
                let newElement = {label:element.label,value:element.value};

                if(newElement.label == 'ASME Gas/Vapor' || newElement.label == 'ASME Steam' || newElement.label == 'API Gas/Vapor'
                || newElement.label == 'API Steam' || newElement.label == 'ISO Gas/Vapor' || newElement.label == 'ISO Dry Steam'){
                    console.log('this.filteredEvaluationPerOptions : -',this.filteredEvaluationPerOptions);
                    console.log('this.filteredEvaluationPerOptions1 : -',this.filteredEvaluationPerOptions1);

                    this.filteredEvaluationPerOptions.push(newElement);
                }
            } else if(this.isThereRiquidRelScenario == 'Yes'){

                let newElement = {label:element.label,value:element.value};
                this.filteredEvaluationPerOptions.push(newElement);
            }
            });
        }*/


        this.selConstrainProd = ruptureDisc.Constrain_product_selection__c;
        updateRecord({ fields: { Id: this.recordId } });
        eval("$A.get('e.force:refreshView').fire();");
        location.reload();
    }




    @wire(mediaTypesPickValues, {
        ruptureDisc : null
    })
    getMediaTypesPickValues({ data, error }){
        if(data){
            this.processMediaOptions = data;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.processMediaOptions = undefined;
        }
    }

    get evalTypeCapacity(){
        return this.selectedEvaluationTypeOptions === 'Sizing & Capacity';
    }

    get evalTypeCapacityPVR(){
        return this.selectedEvaluationTypeOptions === 'Capacity';// && this.selectedReliefType === 'Pressure & Vacuum Relief';
    }

    get isVacuumSelected(){
        return this.selectedReliefType === 'Vacuum Relief' || (this.selectedReliefType === 'Pressure & Vacuum Relief' && (this.selConstrainProd === 'Vacuum' || this.selConstrainProd === 'Pressure & Vacuum'));
    }

    get onlyVacuumSelected(){
        return this.selectedReliefType === 'Vacuum Relief' || (this.selectedReliefType === 'Pressure & Vacuum Relief' && this.selConstrainProd === 'Vacuum');
    }

    get isPressureSelected(){
        return this.selectedReliefType === 'Pressure Relief' || (this.selectedReliefType === 'Pressure & Vacuum Relief' && (this.selConstrainProd === 'Pressure' || this.selConstrainProd === 'Pressure & Vacuum'));
    }

    renderedCallback() {
        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){
            if(this.selectedProcessMedia !== 'Customer Specified'){
                this.notCustomerSpecified = true;
            }else{
                this.notCustomerSpecified = false;
            }

            // if(this.selectedEvaluationTypeOptions === 'Sizing'){
            //     if(this.template.querySelector('.evaluationTypeSizingId') !== null && this.template.querySelector('.evaluationTypeSizingId') !== undefined ){
            //         this.template.querySelector('.evaluationTypeSizingId').checked = true;
            //     }
            // }else
            if(this.selectedEvaluationTypeOptions=== 'Capacity'){
                if(this.template.querySelector('.evaluationTypeCapacityId') !== null && this.template.querySelector('.evaluationTypeCapacityId') !== undefined ){
                    this.template.querySelector('.evaluationTypeCapacityId').checked = true;
                }

            }else if(this.selectedEvaluationTypeOptions === 'Sizing & Capacity'){
                if(this.template.querySelector('.evaluationTypeSizingCapacityId') !== null && this.template.querySelector('.evaluationTypeSizingCapacityId') !== undefined ){
                    this.template.querySelector('.evaluationTypeSizingCapacityId').checked = true;
                }
            }

            if(this.template.querySelector('[class="pressureRelievingTemp'+this.selectedPressureRelievingTemperature+'Id"]')){
                this.template.querySelector('[class="pressureRelievingTemp'+this.selectedPressureRelievingTemperature+'Id"]').checked = true;
            }

            if(this.template.querySelector('[class="vacPressureRelievingTemp'+this.selectedVacPressureRelievingTemperature+'Id"]')){
                this.template.querySelector('[class="vacPressureRelievingTemp'+this.selectedVacPressureRelievingTemperature+'Id"]').checked = true;
            }
        }
    }


    // added by piyush
    sizingFlowChanged(event,whichField){
        const selectedEvent = new CustomEvent("anyfieldupdate");
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    handleEvaluationTypeOptions(event){
        this.sizingFlowChanged(event,'handleEvaluationTypeOptions'); //added by piyush
        this.selectedEvaluationTypeOptions = event.target.value;
    }

    handleRelievingPressureatInletOptions(event){
        this.sizingFlowChanged(event,'handleRelievingPressureatInletOptions'); //added by piyush
        this.selectedRelievingPressureatInlet = event.target.value;
    }

    handleRequiredFlowUnits(event){
        this.sizingFlowChanged(event,'handleRequiredFlowUnits'); //added by piyush
        this.selectedRequiredFlowUnit = event.target.value;
    }

    handleCoefficientOfDischargeOptions(event){
        this.sizingFlowChanged(event,'handleCoefficientOfDischargeOptions'); //added by piyush
        this.coefficientOfDischargeVal = event.target.value;
    }

    get showCF(){
        return this.selEvalPer === 'evalPerNone' || this.selEvalPer === 'ASME Gas/Vapor' || this.selEvalPer === 'ASME Steam'
            || this.selEvalPer === 'API Gas/Vapor' || this.selEvalPer === 'API Steam'
            || this.selEvalPer === 'ISO Gas/Vapor' || this.selEvalPer === 'ISO Dry Steam' || this.selEvalPer === 'ISO Wet Steam';
    }

    get showMWROSH(){
        return this.selEvalPer === 'evalPerNone' || this.selEvalPer === 'ASME Gas/Vapor' || this.selEvalPer === 'ASME Steam'
            || this.selEvalPer === 'API Gas/Vapor' || this.selEvalPer === 'API Steam'
            || this.selEvalPer === 'ISO Gas/Vapor' || this.selEvalPer === 'ISO Dry Steam' || this.selEvalPer === 'ISO Wet Steam'
            || this.selEvalPer === 'Fauske 2 Phase Gas-Liquid' || this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid';
            //|| this.selEvalPer === 'ASME Water' || this.selEvalPer === 'API Liquid' || this.selEvalPer === 'ISO Liquid'
            //|| this.selEvalPer === 'API Omega Method 2 Phase Flashing or Nonflashing' || this.selEvalPer === 'API Omega Method Subcooled Liquid'
            //|| this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing';
    }

    //Required Flow Rate and Required Flow Units Fields  &&  Relieving Pressure at Inlet Fields
    get  showFlowRateAndRelivingPressure(){
        return this.selEvalPer === 'ASME Gas/Vapor' || this.selEvalPer === 'ASME Water' || this.selEvalPer === 'ASME Steam'
            || this.selEvalPer === 'API Gas/Vapor' || this.selEvalPer === 'API Liquid' || this.selEvalPer === 'API Steam'
            || this.selEvalPer === 'ISO Gas/Vapor' || this.selEvalPer === 'ISO Liquid' || this.selEvalPer === 'ISO Dry Steam' || this.selEvalPer === 'ISO Wet Steam'
            || this.selEvalPer === 'API Omega Method 2 Phase Flashing or Nonflashing' || this.selEvalPer === 'API Omega Method Subcooled Liquid'
            || this.selEvalPer === 'Fauske 2 Phase Gas-Liquid' || this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing';
    }

    // get showCoefficientOfDischarge(){
    //     return this.selEvalPer === 'ISO Gas/Vapor' || this.selEvalPer === 'ISO Dry Steam' || this.selEvalPer === 'ISO Wet Steam';
    // }

    get showEnterRelievingPressureValueunits(){
        return this.selectedRelievingPressureatInlet === 'Enter Relieving Pressure Value/ units';
    }

    //Pressure Reliving temperature/ Different Temperature Value and Units Fields
    get showPresTempValUnits(){
        return this.selEvalPer === 'ASME Gas/Vapor' || this.selEvalPer === 'API Gas/Vapor' || this.selEvalPer === 'API Steam'
        || this.selEvalPer === 'ISO Gas/Vapor' || this.selEvalPer === 'ISO Dry Steam' || this.selEvalPer === 'Fauske 2 Phase Gas-Liquid'
        || this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'
        || this.selEvalPer === 'Fauske All Liquid Flashing';
    }

    //Density Specific Volume Specific Gravity Fields
    get showDenSpecificVolSpecficGravity(){
        return this.selEvalPer === 'ASME Water' || this.selEvalPer === 'API Liquid' || this.selEvalPer === 'ISO Liquid';
        // this.selEvalPer === 'Fauske 2 Phase Gas-Liquid' || this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing' ||
        // this.selEvalPer === 'API Omega Method Subcooled Liquid' || this.selEvalPer === 'API Omega Method 2 Phase Flashing or Nonflashing';
    }

    //Viscosity Fields
    get showViscosity(){
        return this.selEvalPer === 'API Liquid' || this.selEvalPer === 'ISO Liquid' || this.selEvalPer === 'API Omega Method Subcooled Liquid'
        || this.selEvalPer === 'API Omega Method 2 Phase Flashing or Nonflashing';
    }

    //Dryness of Wet Steam Field
    get showDryWetSteam(){
        return this.selEvalPer === 'ISO Wet Steam';
    }

    //Specific Volume at Inlet Fields
    get showSpecificVolInlet(){
        return this.selEvalPer === 'API Omega Method 2 Phase Flashing or Nonflashing';
    }

    //Density at Inlet Fields
    get showDenInlet(){
        return this.selEvalPer === 'API Omega Method Subcooled Liquid';
    }

    //Specific Volume at 90 of Inlet Pressure Fields
    get showSpecificVol90InletPressure(){
        return this.selEvalPer === 'API Omega Method 2 Phase Flashing or Nonflashing';
    }

    //Saturation Pressure at Inlet Temperature Fields
    get showSatPressureInletTemp(){
        return this.selEvalPer === 'API Omega Method Subcooled Liquid';
    }

    //Density at 90 of Saturation Pressure Fields
    get showDen90SatPressure(){
        return this.selEvalPer === 'API Omega Method Subcooled Liquid';
    }

    //Stagnation gas vapor quality Fields
    get showStaGasVaporQual(){
        return  this.selEvalPer === 'Fauske 2 Phase Gas-Liquid' || this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
    }

    //Liquid Density and Units Fields
    get showLiquidDensity(){
        return  this.selEvalPer === 'Fauske 2 Phase Gas-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing';
    }

    //Stagnation vapor density Fields
    get showStaVaporDensity(){
        return this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing';
    }

    //Latent Heat of Vaporization & Liquid Specific Heat
    get showLatHeatVaporLiqSpecificHeat(){
        return this.selEvalPer === 'Fauske 2 Phase Vapor-Liquid' || this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing';
    }
    get showIsSaturated() {
        return this.selEvalPer === 'Fauske All Liquid Flashing';
    }
    //Stagnation gas partial pressure Units Fields
    get showStaGasPartPressureUnits(){
        return this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
    }

    //Vapor pres correspond to stagnation temp Fields
    get showVaporPresStaTemp(){
        return this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || this.selEvalPer === 'Fauske All Liquid Flashing';
    }

    //Isentropic coefficient gas and Isentropic coefficient vapor Fields
    get showIsentrophicCoGasVapo(){
        return this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
    }

    //Molecular Weight Gas and Molecular Weight Vapor Fields
    get showMoleWeightGasVapor(){
        return this.selEvalPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
    }

    handlePressureRelievingTemperatureOptions(event){
        this.sizingFlowChanged(event,'handlePressureRelievingTemperatureOptions'); //added by piyush
        this.selectedPressureRelievingTemperature = event.target.value;
    }

    handleVacPressureRelievingTemperatureOptions(event){
        this.sizingFlowChanged(event,'handleVacPressureRelievingTemperatureOptions'); //added by piyush
        this.selectedVacPressureRelievingTemperature = event.target.value;
    }

    get showVacDiffTemperatureSettings(){
        return this.selectedVacPressureRelievingTemperature === 'vacPRTEnterDifferentTemperatureUnits';
    }

    get showDiffTemperatureSettings(){
        return this.selectedPressureRelievingTemperature === 'PRTEnterDifferentTemperatureUnits';
    }

    get showCalculatedFlowArea(){
        return this.calculatedFlowArea !== undefined && this.calculatedFlowArea !== null;
    }

    handleCustomerSpecifiedMedia(event){
        this.sizingFlowChanged(event,'handleCustomerSpecifiedMedia'); //added by piyush
        this.customerSpecifiedMedia = event.target.value;
    }

    handleSaveSizingFlowArea(event){
        event.preventDefault();
        const rFields = event.detail.fields;
        rFields.Evaluation_Type__c = this.selectedEvaluationTypeOptions;
        rFields.Evaluation_Per__c =this.selEvalPer;
        rFields.Relieving_Pressure_at_Inlet__c = this.selectedRelievingPressureatInlet;
        rFields.Bypass__c=false;
        rFields.Pressure_Relieving_Temperature__c = this.selectedPressureRelievingTemperature;
        rFields.VacPressure_Relieving_Temperature__c = this.selectedVacPressureRelievingTemperature;
        rFields.Converted_Pressure_Setting__c = this.convertedPressureSetting;
        rFields.Converted_Relieving_Pressure_Value__c = this.convertedRelievingPressureValue;
        rFields.Converted_Relieving_Temperature__c = this.convertedRelievingTemperature;
        rFields.Converted_Flow_rate__c = this.convertedFlowRate;
        rFields.Converted_Density_at_Inlet__c = this.convertedDensityAtInlet;
        rFields.Converted_Specific_Volume__c = this.convertedSpecificVolume;
        rFields.Converted_Vacuum_Setting__c = this.convertedVacuumSetting;
        rFields.Liquid_specific_heat__c = this.liquidSpecificHeat;
        rFields.Is_Saturated__c=this.isSaturated;
        rFields.Viscosity__c = this.viscosity;
        rFields.Specific_Volume_at_90_of_Inlet_Pressure__c = this.specificVolumeAt90OfInletPressure;
        rFields.Process_Media__c = this.selectedProcessMedia;
        rFields.Customer_Specified_Media__c = this.customerSpecifiedMedia;
        rFields.Relief_Type__c = this.selectedReliefType;
        rFields.VacConverted_Different_Temp_Setting__c = this.vacConvertedDifferentTempSetting;
        rFields.VacConverted_Flow_Rate__c = this.vacConvertedFlowRate;
        rFields.Temperature_Setting_Units__c = this.temperatureSettingUnits;
        rFields.Temperature_Setting__c = this.temperatureSetting;
        rFields.Vacuum_Setting_Units__c = this.vacuumSettingUnits;
        rFields.Vacuum_Setting__c = this.vacuumSetting;
        rFields.Required_Flow_units__c = this.selectedRequiredFlowUnit;
        rFields.Constrain_product_selection__c = this.selConstrainProd;
        rFields.Coefficient_of_Discharge__c = this.coefficientOfDischargeVal;
        rFields.Finish_Configuration_Flag__c = false;
        if(this.selEvalPer === 'ASME Steam' || this.selEvalPer === 'API Steam' || this.selEvalPer === 'ISO Wet Steam' || this.selEvalPer === 'ISO Dry Steam'){
            rFields.Molecular_Weight__c = 18.02;
            rFields.Compressibility_Factor__c = 1;
            rFields.Ratio_of_Specific_Heats__c = 1.31;
        } else if(this.selEvalPer === 'ASME Water'){
            rFields.Molecular_Weight__c = 18.02;
            rFields.Compressibility_Factor__c = null;
            rFields.Ratio_of_Specific_Heats__c = null;
        }




        saveSizingFlowArea({ruptureDisc: rFields})
        .then(result => {
            this.isErrorSizingArea = false;
            this.sizingFlowAreaMessage = [];
            let removeError = this.template.querySelectorAll(".sizingArea");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }

            console.log('result.Evaluation_Per__c',result.Evaluation_Per__c);
            // Creates the event with the data.

            const selectedEvent = new CustomEvent("savesizingarea", {
                detail: {

                    ASME_Section_VIII_Division_1 :    result.ASME_Section_VIII_Division_1__c,
                    CSA_Marking_CRN_Number : result.CSA_Marking_CRN_Number__c,
                    KOSHA_Compliance : result.KOSHA_Compliance__c,
                    ASME_BPE : result.ASME_BPE__c,
                    CU_tR : result.CU_TR__c,
                    X3A_Sanitary_Standards : result.X3A_Sanitary_Standards__c,
                    Comply_with_AD2000_Merkblat_A1 : result.Comply_with_AD2000_Merkblat_A1__c,
                    Atex_Certificate : result.Atex_Certificate__c,
                    Gas_Group : result.Gas_Group__c,
                    Zone_0_2 : result.Zone_0_2__c,
                    Comply_with_Regels_Voor_Tosellan_Oder_Dr : result.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c,
                    NACE : result.NACE__c,
                    PED_2014_68_EU_CE_mark : result.PED_2014_68_EU_CE_mark__c,
                    China_Manufacturing_License : result.China_Manufacturing_License__c,

                    Non_Fragmenting_Design_Required : result.Non_Fragmenting_Design_Required__c,
                    Operating_Pressure_Ratio : result.Operating_Pressure_Ratio__c,
                    Application_type : result.Application_type__c,
                    Disc_Material_of_Construction : result.Disc_Material_of_Construction__c,
                    Evaluation_Per : result.Evaluation_Per__c

                }


            });

            // Dispatches the event.
             this.dispatchEvent(selectedEvent);

            this.vacFlowArea = result.VacFlow_Area__c;
            this.vacReqFlowArea = result.VacRequired_Flow_Area__c;
            this.template.querySelector(".SizingFlowAreaForm").submit(result);


        })
        .catch(error => {
            if(error.body.message){
                this.isErrorSizingArea = true;
                this.sizingFlowAreaMessage = [];
                this.sizingFlowAreaMessage.push(error.body.message);
                let removeError = this.template.querySelectorAll(".sizingArea");
                if(removeError){
                    removeError.forEach((element)=>{element.classList.add("slds-box")});
                }
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }
        });
    }

    handleEvaluationPerChange(event,isInit){
        console.log('isInit handleEvaluationPerChange----> ' + isInit);
        if(isInit != '0'){
            this.sizingFlowChanged(event,'handleEvaluationPerChange'); //added by piyush
        }
        let rDisc = { 'sobjectType': 'Rupture_Disc__c' };
        rDisc.Evaluation_Per__c = event.target.value;
        this.selEvalPer = event.target.value;
        imperativeMediaTypesPickValues({ruptureDisc: rDisc})
        .then(result => {
            console.log('result CoefficientOfDischargeOptions --->  ',result.coefficientOfDischargePicklist);
            this.processMediaOptions = result.mediaPicklist;
            this.requiredFlowUnitsOptions = result.requiredFlowUnitsPicklist;
            this.CoefficientOfDischargeOptions = result.coefficientOfDischargePicklist;
        })
        .catch(error => {
            console.log('error CoefficientOfDischargeOptions --->  ',error);
            this.processMediaOptions = undefined;
            this.requiredFlowUnitsOptions = undefined;
            this.CoefficientOfDischargeOptions = undefined;
            this.error = error;
        });
    }

    handleMediaChange(event){
        this.sizingFlowChanged(event,'handleMediaChange'); //added by piyush
        let rDisc = { 'sobjectType': 'Rupture_Disc__c' };
        rDisc.Process_Media__c = event.target.value;
        this.selectedProcessMedia =  event.target.value;
        mediaPropertyOnProcessMedia({ruptureDisc: rDisc})
        .then(result => {
            // if(result.disableMediaValues){
            //     this.customerSpecifiedMedia = result.ruptureDisc.Customer_Specified_Media__c;
            //     this.molecularWeight = result.ruptureDisc.Molecular_Weight__c;
            //     this.CompressibilityFactor = result.ruptureDisc.Compressibility_Factor__c;
            //     this.ratioOfSpecificHeats = result.ruptureDisc.Ratio_of_Specific_Heats__c;
            // } else if(result.disableMediaValues == false){
            //     this.customerSpecifiedMedia = '';
            //     this.molecularWeight = '';
            //     this.CompressibilityFactor = '';
            //     this.ratioOfSpecificHeats = '';
            // }

            if(this.selectedProcessMedia !== 'Customer Specified'){
                this.notCustomerSpecified = true;
                this.customerSpecifiedMedia = '';
                this.molecularWeight = result.ruptureDisc.Molecular_Weight__c;
                this.CompressibilityFactor = result.ruptureDisc.Compressibility_Factor__c;
                this.ratioOfSpecificHeats = result.ruptureDisc.Ratio_of_Specific_Heats__c;
            }else{
                this.notCustomerSpecified = false;
                this.customerSpecifiedMedia = '';
                this.molecularWeight = '';
                this.CompressibilityFactor = '';
                this.ratioOfSpecificHeats = '';
            }
        })
        .catch(error => {
            this.error = error;
        });
    }

    restrictNonNumericalValues(event){
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
        event.preventDefault();
    }

    RemoveDecimal(event){
        let targetName = event.target.name;
        if(targetName === 'customerSpecifiedMedia')
            this.customerSpecifiedMedia = event.taget.value;
        else if(targetName === 'molecularWeight')
            this.molecularWeight = event.target.value;
        else if(targetName === 'CompressibilityFactor')
            this.CompressibilityFactor = event.target.value;
        else if(targetName === 'ratioOfSpecificHeats')
            this.ratioOfSpecificHeats = event.target.value;
        else if(targetName === 'densityAtInlet')
            this.densityAtInlet = event.target.value;
        else if(targetName === 'densitySpecialVolumeSpecialGravity')
            this.densitySpecialVolumeSpecialGravity = event.target.value;
        else if(targetName === 'specialVolumeAtInlet')
            this.specialVolumeAtInlet = event.target.value;
        else if(targetName === 'requiredFlowRate')
            this.requiredFlowRate = event.target.value;
        else if(targetName === 'enterDifferentTemperatureValue')
            this.enterDifferentTemperatureValue = event.target.value;
        else if(targetName === 'viscosity')
            this.viscosity = event.target.value;
        else if(targetName === 'drynessOfWetSteam')
            this.drynessOfWetSteam = event.target.value;
        else if(targetName === 'specificVolumeAt90OfInletPressure')
            this.specificVolumeAt90OfInletPressure = event.target.value;
        else if(targetName === 'satPressureAtInletTemp')
            this.satPressureAtInletTemp = event.target.value;
        else if(targetName === 'denAt90SatPressure')
            this.denAt90SatPressure = event.target.value;
        else if(targetName === 'staGVQua')
            this.staGVQua = event.target.value;
        else if(targetName === 'staVaporDen')
            this.staVaporDen = event.target.value;
        else if(targetName === 'liquidDen')
            this.liquidDen = event.target.value;
        else if(targetName === 'latHeatVapor')
            this.latHeatVapor = event.target.value;
        else if(targetName === 'liquidSpecificHeat')
            this.liquidSpecificHeat = event.target.value;
        else if(targetName === 'isSaturated')
            this.isSaturated = event.target.value;
        else if(targetName === 'staGasPartPressure')
            this.staGasPartPressure = event.target.value;
        else if(targetName === 'vaporPressCorrToStagTemp')
            this.vaporPressCorrToStagTemp = event.target.value;
        else if(targetName === 'isentropicCoGas')
            this.isentropicCoGas = event.target.value;
        else if(targetName === 'isentropicCoVapor')
            this.isentropicCoVapor = event.target.value;
        else if(targetName === 'moleWeightGas')
            this.moleWeightGas = event.target.value;
        else if(targetName === 'moleWeightVapor')
            this.moleWeightVapor = event.target.value;
        else if(targetName === 'calculatedFlowArea')
            this.calculatedFlowArea = event.target.value;
        else if(targetName === 'outReqFlowArea')
            this.outReqFlowArea = event.target.value;
        else if(targetName === 'enterRelPressureValue')
            this.enterRelPressureValue = event.target.value;
        else if(targetName === 'vacReqFlowRate')
            this.vacReqFlowRate = event.target.value;
        else if(targetName === 'vacuumSetting')
            this.vacuumSetting = event.target.value;
        else if(targetName === 'vacDiffTempValue')
            this.vacDiffTempValue = event.target.value;
        else if(targetName === 'vacFlowArea')
            this.vacFlowArea = event.target.value;
        else if(targetName === 'vacReqFlowArea')
            this.vacReqFlowArea = event.target.value;
    }

    handleSizingFlowAreaSuccess(event){
        this.recordId =  event.detail.id;
        this.rDiscRecordId =  event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Sizing / Flow Area data',
                variant: 'success',
            }),
        );

        const selectedEventAftersuccess = new CustomEvent("aftersuccess");
        // Dispatches the event.
        this.dispatchEvent(selectedEventAftersuccess);
        const payload = event.detail;
    }

    //added by piyush
   /* @api updateEvaluationPer(sValue){
        this.evaluationPerOptions = [];
            let data = this.evaluationPerOptionsAllValues;
            this.evaluationPerOptions.push({ label: 'None', value: 'evalPerNone' });
            if(data == undefined){
                return;
            }
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'EvaluationPer'+element.value+'Id'};

                if(sValue == 'Pressure & Vacuum' && element.label.includes("ASME")){}else{
                    this.evaluationPerOptions.push(newElement);
                }
            });
        console.log('updateEvaluationPer -- :');
    }*/
}