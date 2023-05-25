import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';



import fetchMediaList from '@salesforce/apex/ReliefValveController.fetchMediaList';
import fetchVacMediaList from '@salesforce/apex/ReliefValveController.fetchVacMediaList';
import pressureMediaValues from '@salesforce/apex/ReliefValveController.pressureMediaValues';
import vacuumMediaValues from '@salesforce/apex/ReliefValveController.vacuumMediaValues';
import saveSizingFLowArea from '@salesforce/apex/ReliefValveController.saveSizingFLowArea';


import Media_Type_FIELD from '@salesforce/schema/Relief_Valve__c.Media_Type__c';
import Vacuum_Media_FIELD from '@salesforce/schema/Relief_Valve__c.Vacuum_Media__c';

import Atmospheric_Pressure__FIELD from '@salesforce/schema/Relief_Valve__c.Atmospheric_Pressure__c';
import Atmospheric_Pressure_Units__FIELD from '@salesforce/schema/Relief_Valve__c.Atmospheric_Pressure_Units__c';

import Ratio_of_Specific_Heats__FIELD from '@salesforce/schema/Relief_Valve__c.Ratio_of_Specific_Heats__c';
import Molecular_Weight__FIELD from '@salesforce/schema/Relief_Valve__c.Molecular_Weight__c';
import Compressibility_Factor__FIELD from '@salesforce/schema/Relief_Valve__c.Compressibility_Factor__c';
import Pressure_Relief_Req_Flow_Rate__FIELD from '@salesforce/schema/Relief_Valve__c.Pressure_Relief_Req_Flow_Rate__c';
import Enter_Relieving_Pressure_Value__FIELD from '@salesforce/schema/Relief_Valve__c.Enter_Relieving_Pressure_Value__c';
import Overpressure__FIELD from '@salesforce/schema/Relief_Valve__c.Overpressure__c';
import Pressure_Relieving_Temperature__FIELD from '@salesforce/schema/Relief_Valve__c.Pressure_Relieving_Temperature__c';
import V_Ratio_of_Specific_Heats__FIELD from '@salesforce/schema/Relief_Valve__c.V_Ratio_of_Specific_Heats__c';
import V_Molecular_Weight__FIELD from '@salesforce/schema/Relief_Valve__c.V_Molecular_Weight__c';
import V_Compressibility_Factor__FIELD from '@salesforce/schema/Relief_Valve__c.V_Compressibility_Factor__c';
import Vacuum_Relief_Req_Flow__FIELD from '@salesforce/schema/Relief_Valve__c.Vacuum_Relief_Req_Flow__c';
import V_Enter_Relieving_Vacuum_Value__FIELD from '@salesforce/schema/Relief_Valve__c.V_Enter_Relieving_Vacuum_Value__c';
import V_Overpressure_Vacuum_Value__FIELD from '@salesforce/schema/Relief_Valve__c.V_Overpressure_Vacuum_Value__c';
import V_Vacuum_Relieving_Temperature__FIELD from '@salesforce/schema/Relief_Valve__c.V_Vacuum_Relieving_Temperature__c';


import Converted_Atmospheric_Pressure_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Atmospheric_Pressure__c';
import Customer_Specified_Media_Name_FIELD from '@salesforce/schema/Relief_Valve__c.Customer_Specified_Media_Name__c';
import V_Customer_Specified_Media_Name_FIELD from '@salesforce/schema/Relief_Valve__c.V_Customer_Specified_Media_Name__c';

import Converted_Pressure_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Pressure_Setting__c';
import Converted_Vacuum_Setting__c_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Vacuum_Setting__c';
import Pressure_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Pressure_Setting__c';
import Vacuum_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Vacuum_Setting__c';
import Pressure_Setting_Units_FIELD from '@salesforce/schema/Relief_Valve__c.Pressure_Setting_Units__c';
import Vacuum_Setting_Units_FIELD from '@salesforce/schema/Relief_Valve__c.Vacuum_Setting_Units__c';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import RV_OBJECT from '@salesforce/schema/Relief_Valve__c';

const rvFIELDS = [Media_Type_FIELD, Vacuum_Media_FIELD, Customer_Specified_Media_Name_FIELD, V_Customer_Specified_Media_Name_FIELD,  
    Pressure_Setting_FIELD, Vacuum_Setting_FIELD, Vacuum_Setting_Units_FIELD, Pressure_Setting_Units_FIELD,
    Atmospheric_Pressure__FIELD, Atmospheric_Pressure_Units__FIELD, Ratio_of_Specific_Heats__FIELD, Molecular_Weight__FIELD, Compressibility_Factor__FIELD, Pressure_Relief_Req_Flow_Rate__FIELD, Enter_Relieving_Pressure_Value__FIELD, Overpressure__FIELD,
    Pressure_Relieving_Temperature__FIELD, V_Ratio_of_Specific_Heats__FIELD, V_Molecular_Weight__FIELD, V_Compressibility_Factor__FIELD, V_Enter_Relieving_Vacuum_Value__FIELD, Vacuum_Relief_Req_Flow__FIELD, V_Overpressure_Vacuum_Value__FIELD, V_Vacuum_Relieving_Temperature__FIELD,
    Converted_Atmospheric_Pressure_FIELD, Converted_Pressure_Setting_FIELD, Converted_Vacuum_Setting__c_FIELD];

export default class lwcReliefValveSizeFlowArea extends NavigationMixin(LightningElement) {
    

    @track sizingFlowObj;

    @api recordId;
    @api quoteId;
    @api selectedReliefType;

    @track atmPressure;
    @track pressureReliefRequired;
    @track pressureReliefTemperature;
    @track vacuumReliefRequired;
    @track vacuumRelievingValue = 0;
    @track vacRelTemp;

    @track PressureMediaOptions;
    @track selectedPressureMedia = 'Air';
    @track vacuumMediaOptions;
    @track selectedVacuumMedia = 'Air';

    @track customerSpecified;
    @track vCustomerSpecified;
    @track ratioOfSpecificHeats = 1.4;
    @track molecularWeight = 28.964;
    @track CompressibilityFactor = 1;
    @track vRatioOfSpecificHeats = 1.4;
    @track vMolecularWeight = 28.964;
    @track vCompressibilityFactor = 1;

    @track EnterRelievingPressureUnitsVal;
    @track enterRelievingPressure = 0;
    @track AtmosphericPressureUnitsVal = "psia";
    @track V_EnterRelievingVacuumUnitsVal;

    //Flow rate setting defaults
    @track PressureReliefReqFlowUnitsVal;
    @track VacuumReliefRequiredFlowUnits;

    //temperature default units
    @track PressureRelievingTemperatureUnitsVal;
    @track V_VacuumRelievingTemperatureUnitsVal;

    @track disableForNonCustomerSpecified = true;
    @track disableForVacuumNonCustomerSpecified;

    @track CustomSpecified;
    @track VCustomSpecified;

    //remove decimal
    @track atmosphericPressure;
    @api temperatureUnitsApi;
    @api flowRateUnitsApi;
    @api pressureUnitsApi;


    @track vacuumRelievingTemp;

    //relieving overpressure
    @track disableForVacuumOverpressure;
    @track disableForOverpressure;
    @track disableForRelievingPressure;
    @track disableForRelievingVacuum;
    @track pOverpressure;
    @track vOverpressure;

    //error messages
    @track sizingFlowAreaMessage;
    @track isErrorSizingArea;

    //added by piyush
    @api sDisabled = '';
    @api bDisabled = false;

    @track fieldsInfo;
    @wire(getObjectInfo, { objectApiName: RV_OBJECT })
    getRVInfo(result) {
        if (result.data)
            this.fieldsInfo = result.data.fields;
        console.log(JSON.stringify(result));
    }

    connectedCallback(){
        
        this.PressureRelievingTemperatureUnitsVal = this.temperatureUnitsApi;
        this.V_VacuumRelievingTemperatureUnitsVal = this.temperatureUnitsApi;

        this.PressureReliefReqFlowUnitsVal = this.flowRateUnitsApi;
        this.VacuumReliefRequiredFlowUnits = this.flowRateUnitsApi;

        this.EnterRelievingPressureUnitsVal = this.pressureUnitsApi;
        this.V_EnterRelievingVacuumUnitsVal = this.pressureUnitsApi;

        if(this.vOverpressure == 0) { 

            this.disableForRelievingVacuum = false;
            this.disableForVacuumOverpressure = false;
        }

        if(this.vacuumRelievingValue == 0) { 

            this.disableForVacuumOverpressure = false;
            this.disableForRelievingVacuum = false;

        }

        if(this.pOverpressure == 0) {
              
            this.disableForOverpressure = false;
            this.disableForRelievingPressure = false;
            
        }

        if(this.enterRelievingPressure == 0) {
              
            this.disableForOverpressure = false;
            this.disableForRelievingPressure = false;
        }
    }

    renderedCallback() {

        console.log('ASHIM:'+this.vacuumRelievingValue+' ## '+this.vOverpressure);

        if(this.vacuumRelievingValue == 0 && (this.vOverpressure == 0 || this.vOverpressure == '' 
            || this.vOverpressure == null )) { 

            this.disableForVacuumOverpressure = false;
            this.disableForRelievingVacuum = false;
        }
        
        if(this.vOverpressure == 0 && (this.vacuumRelievingValue == 0 || this.vacuumRelievingValue == '' 
            || this.vacuumRelievingValue == null)) { 

            this.disableForRelievingVacuum = false;
            this.disableForVacuumOverpressure = false;
        }

        if(this.pOverpressure == 0 && (this.enterRelievingPressure == 0 || this.enterRelievingPressure == '' 
            || this.enterRelievingPressure == null)) { 

            this.disableForOverpressure = false;
            this.disableForRelievingPressure = false;
        }

        if(this.enterRelievingPressure == 0 && (this.pOverpressure == 0 || this.pOverpressure == '' 
            || this.pOverpressure == null)) { 

            this.disableForOverpressure = false;
            this.disableForRelievingPressure = false;
        }
        
    }

    @api
    defaultTemperatureUnits(temperatureUnits) {
        //this.temperatureUnitsApi = temperatureUnits;
        
        console.log('in temperatureUnits ',temperatureUnits);
         this.PressureRelievingTemperatureUnitsVal = temperatureUnits;
         this.V_VacuumRelievingTemperatureUnitsVal = temperatureUnits;
    }

    @api 
    defaultFlowRateUnits(flowRateUnits){
        this.PressureReliefReqFlowUnitsVal = flowRateUnits;
        this.VacuumReliefRequiredFlowUnits = flowRateUnits;
    }

    @api 
    defaultPressureUnits(pressureUnits){
        this.EnterRelievingPressureUnitsVal = pressureUnits;
        //this.AtmosphericPressureUnitsVal= pressureUnits;
        this.V_EnterRelievingVacuumUnitsVal = pressureUnits;
    }


    @api
    afterSectionASave(conRvRecords){

        this.atmosphericPressure = conRvRecords.Atmospheric_Pressure__c;
        this.AtmosphericPressureUnitsVal = conRvRecords.Atmospheric_Pressure_Units__c;

        this.isErrorSizingArea = false;
        this.sizingFlowAreaMessage = [];
        let removeError = this.template.querySelectorAll(".sizingArea");
        if(removeError){
            removeError.forEach((element)=>{element.classList.remove("slds-box")});
        }
        
        if(this.selectedReliefType == 'Pressure' || this.selectedReliefType == 'Pressure & Vacuum' ){
            
            this.selectedPressureMedia = conRvRecords.Media_Type__c;
            this.customerSpecified = conRvRecords.Customer_Specified_Media_Name__c;
            this.ratioOfSpecificHeats = conRvRecords.Ratio_of_Specific_Heats__c;
            this.molecularWeight = conRvRecords.Molecular_Weight__c;
            this.CompressibilityFactor = conRvRecords.Compressibility_Factor__c;
            this.disableForNonCustomerSpecified = true;
            this.pressureReliefRequired = conRvRecords.Pressure_Relief_Req_Flow_Rate__c;
            this.enterRelievingPressure = conRvRecords.Enter_Relieving_Pressure_Value__c;
            this.pOverpressure = conRvRecords.Overpressure__c;
            this.pressureReliefTemperature = conRvRecords.Pressure_Relieving_Temperature__c;
        }
        if(this.selectedReliefType == 'Vacuum' || this.selectedReliefType == 'Pressure & Vacuum'){
            
            this.selectedVacuumMedia = conRvRecords.Vacuum_Media__c;
            this.vCustomerSpecified = conRvRecords.V_Customer_Specified_Media_Name__c;
            this.vRatioOfSpecificHeats = conRvRecords.V_Ratio_of_Specific_Heats__c;
            this.vMolecularWeight = conRvRecords.V_Molecular_Weight__c;
            this.vCompressibilityFactor = conRvRecords.V_Compressibility_Factor__c;
            this.disableForVacuumNonCustomerSpecified = true;
            this.vacuumReliefRequired = conRvRecords.Vacuum_Relief_Req_Flow__c;
            this.vacuumRelievingValue = conRvRecords.V_Enter_Relieving_Vacuum_Value__c;
            this.vOverpressure = conRvRecords.V_Overpressure_Vacuum_Value__c;
            this.vacRelTemp = conRvRecords.V_Vacuum_Relieving_Temperature__c;
        }


        updateRecord({ fields: { Id: this.recordId } });
    }

    //@wire(fetchMediaList) PressureMediaOptions;
    //@wire(fetchVacMediaList) vacuumMediaOptions;

    @wire(fetchMediaList)
    pressureMediaList({ data, error }){
        console.log('data ====== ',data);
        if(data){
            this.PressureMediaOptions = data;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.PressureMediaOptions = undefined;
        }
    }

    @wire(fetchVacMediaList)
    vacuumMediaList({ data, error }){
        console.log('data ====== ',data);
        if(data){
            this.vacuumMediaOptions = data;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.vacuumMediaOptions = undefined;
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: rvFIELDS})
    rvRec({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while loading Relief Valve',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {

            console.log('sizingFlowObj'+JSON.stringify(this.sizingFlowObj));

            this.vacuumRelievingTemp = data.fields.V_Vacuum_Relieving_Temperature__c.value;
            this.vOverpressure = data.fields.V_Overpressure_Vacuum_Value__c.value;
            this.vacuumRelievingValue = data.fields.V_Enter_Relieving_Vacuum_Value__c.value;
            this.vacuumReliefRequired = data.fields.Vacuum_Relief_Req_Flow__c.value;
            this.vCompressibilityFactor = data.fields.V_Compressibility_Factor__c.value;
            this.vMolecularWeight = data.fields.V_Molecular_Weight__c.value;
            this.vRatioOfSpecificHeats = data.fields.V_Ratio_of_Specific_Heats__c.value;
            this.pressureReliefTemperature = data.fields.Pressure_Relieving_Temperature__c.value;
            this.pOverpressure = data.fields.Overpressure__c.value;
            this.enterRelievingPressure = data.fields.Enter_Relieving_Pressure_Value__c.value;
            this.pressureReliefRequired = data.fields.Pressure_Relief_Req_Flow_Rate__c.value;
            this.CompressibilityFactor = data.fields.Compressibility_Factor__c.value;
            this.molecularWeight = data.fields.Molecular_Weight__c.value;
            this.ratioOfSpecificHeats = data.fields.Ratio_of_Specific_Heats__c.value;
            this.atmosphericPressure = data.fields.Atmospheric_Pressure__c.value;
            this.AtmosphericPressureUnitsVal = data.fields.Atmospheric_Pressure_Units__c.value;
            
            this.selectedPressureMedia = data.fields.Media_Type__c.value;
            this.selectedVacuumMedia = data.fields.Vacuum_Media__c.value;

            this.ConvertedAtmosphericPressureVal = data.fields.Converted_Atmospheric_Pressure__c.value;
            this.ConvertedVacuumSettingVal = data.fields.Converted_Vacuum_Setting__c.value;
            this.ConvertedPressureSettingVal = data.fields.Converted_Pressure_Setting__c.value;
            this.PressureSettingVal = data.fields.Pressure_Setting__c.value;
            this.PressureSettingUnitsVal = data.fields.Pressure_Setting_Units__c.value;
            this.VacuumSettingVal = data.fields.Vacuum_Setting__c.value;
            this.VacuumSettingUnitsVal = data.fields.Vacuum_Setting_Units__c.value;

            this.customerSpecified = data.fields.Customer_Specified_Media_Name__c.value;
            this.vCustomerSpecified = data.fields.V_Customer_Specified_Media_Name__c.value;

            if(this.selectedPressureMedia === 'Customer Specified' || this.selectedPressureMedia === '' || this.selectedPressureMedia === undefined || this.selectedPressureMedia === null){
                this.disableForNonCustomerSpecified = false;
                
            }else{
                this.disableForNonCustomerSpecified = true;
            }

            if(this.selectedVacuumMedia === 'Customer Specified' || this.selectedVacuumMedia === '' || this.selectedVacuumMedia === undefined || this.selectedVacuumMedia === null){
                this.disableForVacuumNonCustomerSpecified = false;
            }else{
                this.disableForVacuumNonCustomerSpecified = true;
            }

            if(this.enterRelievingPressure >= 0){
               // this.pOverpressure = '';
                this.disableForRelievingPressure = false;
                this.disableForOverpressure = true;
            }
            if(this.pOverpressure >= 10){
                this.disableForRelievingPressure = true;
                this.disableForOverpressure = false;
            }
           
            if(this.vacuumRelievingValue >= 0){
               // this.vOverpressure = '';
               this.disableForRelievingVacuum = false;
                this.disableForVacuumOverpressure = true;
            }
            if(this.vOverpressure >= 10){
                this.disableForRelievingVacuum = true;
                this.disableForVacuumOverpressure = false;
            }

            
        }
    }

    get isVacuumSelected(){
        return this.selectedReliefType === 'Vacuum';
    }

    get isPressureSelected(){
        return this.selectedReliefType === 'Pressure';
    }

    get isVacuumAndPressureSelected(){
        return this.selectedReliefType === 'Pressure & Vacuum';
    }

    handlePressureMediaChange(event){
        this.sizingFlowChanged(); //added by piyush
        window.console.log('selected value ===> '+event.target.value);

        let rvObj = { 'sobjectType': 'Relief_Valve__c' };
        rvObj.Media_Type__c = event.target.value;   
        this.selectedPressureMedia =  event.target.value;
        rvObj.Id = this.recordId;
        if(event.detail.value === 'Customer Specified'){
            
            this.disableForNonCustomerSpecified = false;
            this.ratioOfSpecificHeats = null;
            this.molecularWeight = null;
            this.CompressibilityFactor = null;
            this.CustomSpecified = true;
        }else{
            this.CustomSpecified = false;
            pressureMediaValues({conRV: rvObj})
            .then(result => {
                window.console.log('result == ',JSON.stringify(result));
                console.log('test ', result.Ratio_of_Specific_Heats__c);
                
                if(result.Ratio_of_Specific_Heats__c){
                    this.ratioOfSpecificHeats = result.Ratio_of_Specific_Heats__c;
                }else{
                    this.ratioOfSpecificHeats = null;
                }

                if(result.Molecular_Weight__c){
                    this.molecularWeight = result.Molecular_Weight__c;
                }else{
                    this.molecularWeight = null;
                }

                if(result.Compressibility_Factor__c){
                    this.CompressibilityFactor = result.Compressibility_Factor__c;
                }else{
                    this.CompressibilityFactor = null;
                }
                this.disableForNonCustomerSpecified = true;
                this.selectedPressureMedia =  result.Media_Type__c;
            })
            .catch(error => {
                console.log(error);
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        }

    }

    handleVacuumMediaChange(event){
        this.sizingFlowChanged();
        window.console.log('selected value ===> '+event.target.value);
        
        let rvObj = { 'sobjectType': 'Relief_Valve__c' };
        rvObj.Vacuum_Media__c = event.target.value;   
        this.selectedVacuumMedia =  event.target.value;
        rvObj.Id = this.recordId;
        if(event.detail.value === 'Customer Specified'){
            this.disableForVacuumNonCustomerSpecified = false;
            this.vRatioOfSpecificHeats = null;
            this.vMolecularWeight = null;
            this.vCompressibilityFactor = null;
            this.VCustomSpecified = true;
        }else{
            this.VCustomSpecified = false;
            vacuumMediaValues({conRV: rvObj})
            .then(result => {
                window.console.log('result == ',JSON.stringify(result));
                
                if(result.V_Ratio_of_Specific_Heats__c){
                    this.vRatioOfSpecificHeats = result.V_Ratio_of_Specific_Heats__c;
                }else{
                    this.vRatioOfSpecificHeats = null;
                }

                if(result.V_Molecular_Weight__c){
                    this.vMolecularWeight = result.V_Molecular_Weight__c;
                }else{
                    this.vMolecularWeight = null;
                }

                if(result.V_Compressibility_Factor__c){
                    this.vCompressibilityFactor = result.V_Compressibility_Factor__c;
                }else{
                    this.vCompressibilityFactor = null;
                }
                
                if(this.selectedPressureMedia !== '' || this.selectedPressureMedia !== 'Customer Specified'){
                    //this.notCustomerSpecified = true;
                    window.console.log('yes readonly == ');
                }else{
                    this.notCustomerSpecified = false;
                    //window.console.log('not readonly == ');
                }
                this.disableForVacuumNonCustomerSpecified = true;
                this.selectedVacuumMedia =  result.Vacuum_Media__c;
            })
            .catch(error => {
                console.log(error);
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        }
    }

    handleSaveSizingFlowArea(event){
        event.preventDefault(); 
        const rvFields = event.detail.fields;
        rvFields.Id = this.recordId;
        rvFields.Vacuum_Media__c = this.selectedVacuumMedia;
        rvFields.Media_Type__c = this.selectedPressureMedia;
       // rvFields.Atmospheric_Pressure_Units__c = this.AtmosphericPressureUnitsVal;
        //rvFIELDS.Atmospheric_Pressure__c = this.AtmosphericPressureVal;
        //rvFIELDS.Enter_Relieving_Pressure_Units__c = this.EnterRelievingPressureUnitsVal;
        //rvFIELDS.Enter_Relieving_Pressure_Value__c = this.enterRelievingPressureValueVal;
        //rvFIELDS.V_Enter_Relieving_Vacuum_units__c = this.V_EnterRelievingVacuumunitsVal;
        //rvFIELDS.V_Enter_Relieving_Vacuum_Value__c = this.V_EnterRelievingVacuumValueVal;
        rvFields.Converted_Atmospheric_Pressure__c = this.ConvertedAtmosphericPressureVal;
        rvFields.Converted_Vacuum_Setting__c = this.ConvertedVacuumSettingVal;
        rvFields.Converted_Pressure_Setting__c = this.ConvertedPressureSettingVal;
        rvFields.Pressure_Setting__c = this.PressureSettingVal;
        rvFields.Pressure_Setting_Units__c = this.PressureSettingUnitsVal;
        rvFields.Vacuum_Setting__c = this.VacuumSettingVal;
        rvFields.Vacuum_Setting_Units__c = this.VacuumSettingUnitsVal;
        //this.template.querySelector(".CertificationsForm").submit(bgrFields);
		console.log('rvFields ==== ',JSON.stringify(rvFields));
		saveSizingFLowArea({conRV: rvFields})
        .then(result => {
            this.isErrorSizingArea = false;
            this.sizingFlowAreaMessage = [];
            let removeError = this.template.querySelectorAll(".sizingArea");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
             
            // Creates the event with the data.
            const selectedEvent = new CustomEvent("savesizingarea", {
                detail: {
                    ConvertedRelievingPressureValue : result.Converted_Relieving_Pressure_Value__c,
                    V_ConvertedRelievingVacuumValue : result.V_Converted_Relieving_Vacuum_Value__c, 
                    ConvertedPressureRelievingTemperature : result.Converted_Pressure_Relieving_Temperature__c,
                    V_ConvertedVacuumRelievingTemperature : result.V_Converted_Vacuum_Relieving_Temperature__c,
                    ConvertedPressureReliefReqFlow : result.Converted_Pressure_Relief_Req_Flow__c,
                    ConvertedVacuumReliefReqFlow : result.Converted_Vacuum_Relief_Req_Flow__c,
                    ConvertedAtmosphericPressure : result.Converted_Atmospheric_Pressure__c,
                    pedCertificate : result.PED_2014_68_EU_CE_mark__c,
                    atexCertificate : result.Atex_Certificate__c,
                    gasGroupCertificate : result.Gas_Group__c,
                    zoneCertificate : result.Zone__c,
                    cutrCertificate : result.CU_TR__c,
                    naceCertificate : result.NACE__c,
       
                    selectedTypeOfModelOption : result.Type_of_model__c,
                    selectedTypeOfOverPressureValveOption : result.Type_of_overpressure_valve__c,
                    selectedIsFlameArresterNeededWithYourValve : result.Is_flame_arrester_needed_with_your_valve__c
                 
                }
           
            });
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
			console.log('Sizing FLow Area result === ', result);
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
            }
            else{
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }
            
           /* 
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.statusText,
                    message: error.body.message,
                    variant: 'error',
                }),
            );*/
        });
        
    }

    
    navigateToProductView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.quoteId,
                objectApiName: 'SBQQ__Quote__c', // objectApiName is optional
                actionName: 'view'
            }
        });
    }

    restrictNonNumericalValues(event){
        this.sizingFlowChanged(); //added by piyush
        let targetName = event.target.name;
        let targetValue = event.target.value;
        let charCode = event.which ? event.which : event.keyCode;

        if (charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && (charCode > 31 && charCode < 48 || charCode > 57 && charCode < 93 || charCode > 105) || event.shiftKey == 1 || (charCode == 110 || charCode == 190) && (targetValue.match(/\./g) || []).length > 0) {
            event.preventDefault();
        }
    }

    restrictNonNumericalValuesWithoutNegative(event){
        this.sizingFlowChanged(); //added by piyush
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 45 && charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 189 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
            event.preventDefault();
    }

    RemoveDecimal(event){
        let targetName = event.target.name;

        if(targetName === 'atmosphericPressure'){
            this.atmosphericPressure = event.target.value;
        }

        else if(targetName === 'vMolecularWeight'){
            this.vMolecularWeight = event.target.value;
        }   
        else if(targetName === 'vRatioOfSpecificHeats'){
            this.vRatioOfSpecificHeats = event.target.value;
        }
        else if(targetName === 'vCompressibilityFactor'){
            this.vCompressibilityFactor = event.target.value;
        }
        else if(targetName === 'vacuumReliefRequired'){
            this.vacuumReliefRequired = event.target.value;
        }    
        else if(targetName === 'vacuumRelievingValue'){
            this.vacuumRelievingValue = event.target.value;
        }
        else if(targetName === 'vOverpressure'){
            this.vOverpressure = event.target.value;
        }
        else if(targetName === 'vacuumRelievingTemp'){
            this.vacuumRelievingTemp = event.target.value;
        }
        /*else if(targetName === 'vCustomerSpecified'){
            this.vCustomerSpecified = event.target.value;
        }
        else if(targetName === 'customerSpecified'){
            this.customerSpecified = event.target.value;
        }  */
        else if(targetName === 'ratioOfSpecificHeats'){
            this.ratioOfSpecificHeats = event.target.value;
        }   
        else if(targetName === 'molecularWeight'){
            this.molecularWeight = event.target.value;
        }
        else if(targetName === 'CompressibilityFactor'){
            this.CompressibilityFactor = event.target.value;
        }
        else if(targetName === 'pressureReliefRequired'){
            this.pressureReliefRequired = event.target.value;
        }    
        else if(targetName === 'enterRelievingPressure'){
            this.enterRelievingPressure = event.target.value;
        }
        else if(targetName === 'pOverpressure'){
            this.pOverpressure = event.target.value;
        }
        else if(targetName === 'pressureReliefTemperature'){
            this.pressureReliefTemperature = event.target.value;
        }
    }


    handleReleivingPressureOverpressure(event){
        
        this.sizingFlowChanged();
        
        this.RemoveDecimal(event);

        let targetName = event.target.name;
        let targetValue = event.target.value;

        if(targetName === 'enterRelievingPressure'){
            
            if(this.pOverpressure == '') {
                
                //this.pOverpressure = null;
            }
            this.enterRelievingPressure = targetValue;
           console.log('this.enterRelievingPressure'+this.enterRelievingPressure);
           //if(this.enterRelievingPressure > 0 || this.enterRelievingPressure === '0'){ 
           if(this.enterRelievingPressure > 0 && this.enterRelievingPressure != ''){
                
                this.disableForOverpressure = true;
                this.disableForRelievingPressure = false;

            } else if(this.enterRelievingPressure == 0 && this.enterRelievingPressure != '') {
              
                this.disableForOverpressure = false;
                this.disableForRelievingPressure = false;
                
            } else{
                this.enterRelievingPressure = null;
                this.disableForOverpressure = false;
                this.disableForRelievingPressure = true;
            }
            
        }
        else if(targetName === 'pOverpressure'){

            if(this.enterRelievingPressure == '') {
                
                //this.enterRelievingPressure = null;
            }
            this.pOverpressure = targetValue;
            
            //if(this.pOverpressure > '0' ||  this.pOverpressure === '0' ){
            if(this.pOverpressure > 0 && this.pOverpressure != '' ){
                
                this.disableForOverpressure = false;
                this.disableForRelievingPressure = true;

            } else if(this.pOverpressure == 0 && this.pOverpressure != '') {
              
                this.disableForOverpressure = false;
                this.disableForRelievingPressure = false;
                
            } else{
                this.pOverpressure = null;
                this.disableForOverpressure = true;
                this.disableForRelievingPressure = false;
            }

            //alert(this.disableForRelievingPressure);
        }
        
       /* let pressureRelievingValue = event.target.value;
        
        if(pressureRelievingValue > 0){
            this.pOverpressure = '';
            this.disableForOverpressure = true;
        }
        else{
            this.disableForOverpressure = false;
        }*/
    }

    handleRelievingVacuumOverpressure(event){

        this.RemoveDecimal(event);

        let targetName = event.target.name;
        if(targetName === 'vacuumRelievingValue') {

            if(this.vOverpressure == '') {
                
                //this.vOverpressure = null;
            }
            //alert(this.vacuumRelievingValue);

            this.vacuumRelievingValue = event.target.value;
            //if(this.vacuumRelievingValue > 0 || this.vacuumRelievingValue  === '0' ){
            if(this.vacuumRelievingValue > 0 && this.vacuumRelievingValue  != '' ){
                
                this.disableForVacuumOverpressure = true;
                this.disableForRelievingVacuum = false;

            } else if(this.vacuumRelievingValue == 0 && this.vacuumRelievingValue  != '') { 

                this.disableForVacuumOverpressure = false;
                this.disableForRelievingVacuum = false;

            } else {

                this.vacuumRelievingValue = null;
                this.disableForVacuumOverpressure = false;
                this.disableForRelievingVacuum = true;
            }
            
        }
        else if(targetName === 'vOverpressure'){

            if(this.vacuumRelievingValue == '') {
                
                //this.vacuumRelievingValue = null;
            }

            this.vOverpressure = event.target.value;
            //if(this.vOverpressure > 0 || this.vOverpressure === '0' ){
            if(this.vOverpressure > 0 && this.vOverpressure != '' ){
                
                this.disableForVacuumOverpressure = false;
                this.disableForRelievingVacuum = true;

            } else if(this.vOverpressure == 0 && this.vOverpressure != '') { 

                this.disableForRelievingVacuum = false;
                this.disableForVacuumOverpressure = false;

            } else {
                this.vOverpressure = null;
                this.disableForVacuumOverpressure = true;
                this.disableForRelievingVacuum = false;
            }
        }
    }

      // added by piyush 
      sizingFlowChanged(){
        const selectedEvent = new CustomEvent("anyfieldupdate");
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}