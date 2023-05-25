import { LightningElement, track,api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import Rupture_Disc_OBJECT from '@salesforce/schema/Rupture_Disc__c';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

import evaluationType_FIELD from '@salesforce/schema/Rupture_Disc__c.Evaluation_Type__c';
import relievingPressureatInlet_FIELD from '@salesforce/schema/Rupture_Disc__c.Relieving_Pressure_at_Inlet__c';
import pressureRelievingTemperature_FIELD from '@salesforce/schema/Rupture_Disc__c.Pressure_Relieving_Temperature__c';
import EvaluationPer_FIELD from '@salesforce/schema/Rupture_Disc__c.Evaluation_Per__c';
import CustomerSpecifiedMedia_FIELD from '@salesforce/schema/Rupture_Disc__c.Customer_Specified_Media__c';
import FlowAreaFIELD from '@salesforce/schema/Rupture_Disc__c.Flow_Area__c';


import saveSizingFlowArea from '@salesforce/apex/RuptureDiscController.saveSizingFlowArea';
import mediaTypesPickValues from '@salesforce/apex/RuptureDiscController.mediaTypesPickValues';
import imperativeMediaTypesPickValues from '@salesforce/apex/RuptureDiscController.imperativeMediaTypesPickValues';
import mediaPropertyOnProcessMedia from '@salesforce/apex/RuptureDiscController.mediaPropertyOnProcessMedia';

const RuptureDiscFIELDS = [evaluationType_FIELD,relievingPressureatInlet_FIELD,pressureRelievingTemperature_FIELD,EvaluationPer_FIELD,CustomerSpecifiedMedia_FIELD,FlowAreaFIELD]

export default class LwcRuptureDiscSizingFlowArea extends NavigationMixin(LightningElement) {
    @api recordId;
    @track pressureRelievingTemperatureOptions;
    @track evaluationTypeOptions;
    @track selectedEvaluationTypeOptions;
    @track relievingPressureatInletOptions;
    @track selectedRelievingPressureatInlet;
    @track selectedPressureRelievingTemperature;

    @track selectedProcessMedia;
    @track processMediaOptions;
    @track selectedEvaluationPer;
    @track calculatedFlowArea;
    @wire(getObjectInfo, { objectApiName: Rupture_Disc_OBJECT })
        objectInfo;

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : evaluationType_FIELD
    })
    evaluationTypePickListValues({ data, error }){
        if(data){
            //this.evaluationTypeOptions = data.values;
            console.log('????????? in sizing flow controller ');
            this.evaluationTypeOptions = [];
            data.values.forEach(element =>{
                console.log('?????? element '+element);
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
            //this.relievingPressureatInletOptions = data.values;
            this.relievingPressureatInletOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'rPInlet'
                +element.value.split(' ').join('').split('%').join('').split('/').join('')+'Id'};
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
            //this.pressureRelievingTemperatureOptions = data.values;
            this.pressureRelievingTemperatureOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'pressureRelievingTemp'
                +element.value.split(' ').join('').split('/').join('')+'Id'};
                this.pressureRelievingTemperatureOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.pressureRelievingTemperatureOptions = undefined;
        }
    }

    @wire(mediaTypesPickValues, {
        ruptureDisc : null
    })
    getMediaTypesPickValues({ data, error }){
        window.console.log('Pcik Val Data '+JSON.stringify(data));
        if(data){
            this.processMediaOptions = data;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.processMediaOptions = undefined;
        }
    }

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
            console.log('data.fields.Evaluation_Type__c.value  === ', data.fields.Evaluation_Type__c.value);
            this.selectedEvaluationTypeOptions = data.fields.Evaluation_Type__c.value;
            this.selectedRelievingPressureatInlet = data.fields.Relieving_Pressure_at_Inlet__c.value;
            this.selectedPressureRelievingTemperature = data.fields.Pressure_Relieving_Temperature__c.value;
            this.selectedEvaluationPer = data.fields.Evaluation_Per__c.value;
            this.calculatedFlowArea = data.fields.Flow_Area__c.value;
            this.handleEvaluationPerChange({ target: {value:this.selectedEvaluationPer }});
            this.selectedProcessMedia = data.fields.Customer_Specified_Media__c.value;
        }
    }
    
    renderedCallback() {
        console.log('in render call back in sizing flow area ',this.recordId);
        //let target = this.template.querySelector('[data-id="Molecular_Weight__c"]');
        //console.log('target ???????? ',target.);
        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){
            if(this.selectedEvaluationTypeOptions === 'Sizing'){
                if(this.template.querySelector('.evaluationTypeSizingId') !== null && this.template.querySelector('.evaluationTypeSizingId') !== undefined ){
                    this.template.querySelector('.evaluationTypeSizingId').checked = true;
                }
            }else if(this.selectedEvaluationTypeOptions=== 'Capacity'){
                if(this.template.querySelector('.evaluationTypeCapacityId') !== null && this.template.querySelector('.evaluationTypeCapacityId') !== undefined ){
                    this.template.querySelector('.evaluationTypeCapacityId').checked = true;
                }
                
            }else if(this.selectedEvaluationTypeOptions === 'Sizing & Capacity'){
                if(this.template.querySelector('.evaluationTypeSizingCapacityId') !== null && this.template.querySelector('.evaluationTypeSizingCapacityId') !== undefined ){
                    this.template.querySelector('.evaluationTypeSizingCapacityId').checked = true;
                }
            }

            if(this.selectedRelievingPressureatInlet === '% Overpressure'){
                if(this.template.querySelector('.rPInletOverpressureId') !== null && this.template.querySelector('.rPInletOverpressureId') !== undefined ){
                    this.template.querySelector('.rPInletOverpressureId').checked = true;
                }
            }else if(this.selectedRelievingPressureatInlet=== 'Enter Relieving Pressure Value/ units'){
                if(this.template.querySelector('.rPInletEnterRelievingPressureValueunitsId') !== null && this.template.querySelector('.rPInletEnterRelievingPressureValueunitsId') !== undefined ){
                    this.template.querySelector('.rPInletEnterRelievingPressureValueunitsId').checked = true;
                }
                
            }

            if(this.selectedPressureRelievingTemperature === 'Same As Temperature Setting'){
                if(this.template.querySelector('.pressureRelievingTempSameAsTemperatureSettingId') !== null && this.template.querySelector('.pressureRelievingTempSameAsTemperatureSettingId') !== undefined ){
                    this.template.querySelector('.pressureRelievingTempSameAsTemperatureSettingId').checked = true;
                }
            }else if(this.selectedPressureRelievingTemperature=== 'Enter Different Temperature/ units'){
                if(this.template.querySelector('.pressureRelievingTempEnterDifferentTemperatureunitsId') !== null && this.template.querySelector('.pressureRelievingTempEnterDifferentTemperatureunitsId') !== undefined ){
                    this.template.querySelector('.pressureRelievingTempEnterDifferentTemperatureunitsId').checked = true;
                }
            }
        }
    }

    handleEvaluationTypeOptions(event){
        console.log('selected Evaluation_Type__c ', event.target.value );
        this.selectedEvaluationTypeOptions = event.target.value;
    }

    handleRelievingPressureatInletOptions(event){
        this.selectedRelievingPressureatInlet = event.target.value;
    }

    get showASMEGasVaporSection(){
        return this.selectedEvaluationPer === 'ASME Gas/Vapor' ||  this.selectedEvaluationPer === 'API Gas/Vapor' 
            || this.selectedEvaluationPer === 'API Steam' || this.selectedEvaluationPer === 'ISO Gas/Vapor' 
            || this.selectedEvaluationPer === 'ISO Dry Steam';
    }

    get showASMEWaterSection(){
        return this.selectedEvaluationPer === 'ASME Water';
    }

    get showASMESteamSection(){
        return this.selectedEvaluationPer === 'ASME Steam';
    }

    get showAPILiquidSection(){
        return this.selectedEvaluationPer === 'API Liquid';
    }

    get showISOLiquidSection(){
        return this.selectedEvaluationPer === 'ISO Liquid';
    }

    get showISOWetSteamSection(){
        return this.selectedEvaluationPer === 'ISO Wet Steam';
    }

    get showAPIOmegaMethod2PhaseFlashingORNonflashing(){
        return this.selectedEvaluationPer === 'API Omega Method 2 Phase Flashing or Nonflashing';
    }

    get showAPIOmegaMethodSubcooledLiquid(){
        return this.selectedEvaluationPer === 'API Omega Method Subcooled Liquid';
    }

    get showFauske2PhaseGasLiquid(){
        return  this.selectedEvaluationPer === 'Fauske 2 Phase Gas-Liquid';
    }

    get showFauske2PhaseVaporLiquid(){
        return  this.selectedEvaluationPer === 'Fauske 2 Phase Vapor-Liquid';
    }

    get showFauskeAllLiquidFlashing(){
        return  this.selectedEvaluationPer === 'Fauske All Liquid Flashing';
    }

    get showFauske2PhaseHybridGasVaporLiquid(){
        return  this.selectedEvaluationPer === 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid';
    }

    get showEnterRelievingPressureValueunits(){
        return this.selectedRelievingPressureatInlet === 'Enter Relieving Pressure Value/ units';
    }

    get hideEnterRelievingPressureValueunits(){
        return this.selectedRelievingPressureatInlet !== 'Enter Relieving Pressure Value/ units';
    }

    handlePressureRelievingTemperatureOptions(event){
        this.selectedPressureRelievingTemperature = event.target.value;
    }

    get hideDiffTemperatureSettings(){
        return this.selectedPressureRelievingTemperature !== 'Same As Temperature Setting';
    }

    get showCalculatedFlowArea(){
        return this.calculatedFlowArea !== undefined && this.calculatedFlowArea !== null;
    }

    handleSaveSizingFlowArea(event){
        event.preventDefault(); 
        const rFields = event.detail.fields;
        rFields.Evaluation_Type__c = this.selectedEvaluationTypeOptions;
        rFields.Relieving_Pressure_at_Inlet__c = this.selectedRelievingPressureatInlet;
        rFields.Bypass__c=false;
        rFields.Pressure_Relieving_Temperature__c = this.selectedPressureRelievingTemperature;
        console.log('this.selectedEvaluationTypeOptions ==?? ',this.selectedEvaluationTypeOptions);
        console.log('rFields.Evaluation_Type__c ==??  ',rFields.Evaluation_Type__c);
        saveSizingFlowArea({ruptureDisc: rFields})
        .then(result => {
            //this.recordId = result;
            console.log('result == ',JSON.stringify(result));
            console.log('rFields == ',JSON.stringify(rFields));
            window.console.log('query Selector ', this.template.querySelector(".SizingFlowAreaForm"));
            this.template.querySelector(".SizingFlowAreaForm").submit(result);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.statusText,
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
        
    }

    handleEvaluationPerChange(event){
        console.log('evel change '+event.target.value);
        let rDisc = { 'sobjectType': 'Rupture_Disc__c' };
        rDisc.Evaluation_Per__c = event.target.value;
        this.selectedEvaluationPer = event.target.value;
        imperativeMediaTypesPickValues({ruptureDisc: rDisc})
        .then(result => {
            console.log('result == ',JSON.stringify(result));
            this.processMediaOptions = result;
        })
        .catch(error => {
            console.log(error);
            this.processMediaOptions = undefined;
            this.error = error;
        });

    }

    @track customerSpecifiedMedia;
    @track molecularWeight;
    @track CompressibilityFactor;
    @track ratioOfSpecificHeats;
    @track notCustomerSpecified;
    handleMediaChange(event){
        window.console.log('in media change event ========= ',event.target.value);
        
        let rDisc = { 'sobjectType': 'Rupture_Disc__c' };
        rDisc.Process_Media__c = event.target.value;
        this.selectedProcessMedia =  event.target.value;
        mediaPropertyOnProcessMedia({ruptureDisc: rDisc})
        .then(result => {
            window.console.log('result == ',JSON.stringify(result));
            window.console.log('Sizing vals ========= ',this.template.querySelector(".SizingFlowAreaForm"));
            this.customerSpecifiedMedia = result.ruptureDisc.Customer_Specified_Media__c;
            this.molecularWeight = result.ruptureDisc.Molecular_Weight__c;
            this.CompressibilityFactor = result.ruptureDisc.Compressibility_Factor__c;
            this.ratioOfSpecificHeats = result.ruptureDisc.Ratio_of_Specific_Heats__c;
            window.console.log('yes this.selectedProcessMedia == ',this.selectedProcessMedia);
            if(this.selectedProcessMedia !== '' || this.selectedProcessMedia !== 'Customer Specified'){
                //this.notCustomerSpecified = true;
                window.console.log('yes readonly == ');
            }else{
                this.notCustomerSpecified = false;
                //window.console.log('not readonly == ');
            }
            //this.processMediaOptions = result;
        })
        .catch(error => {
            console.log(error);
            //this.processMediaOptions = undefined;
            this.error = error;
        });

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
        window.console.log('onsuccess: ', event.detail.id);
        const payload = event.detail;
        window.console.log('record payload: ',JSON.stringify(payload));
    }
}